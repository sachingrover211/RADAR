#!/usr/bin/env python

import os, sys
import Compiler as CA
import MySQLdb

PATH_TO_OBS_COMPILER = '/home/vdondeti/Documents/RADAR/RADAR/RADAR_tat/'
PATH_TO_FAST_DOWNWARD = '/home/vdondeti/Documents/FD/src/'

class fdCompile(CA.Compiler):
    
    def __init__(self, domainFile, problemFile, obsFile, flag = False):
        CA.Compiler.__init__(self, domainFile, problemFile, obsFile, flag)
	self.db = MySQLdb.connect('localhost','root','root','radar')
	self.cursor = self.db.cursor()

    def updateFiles(self):
        # This is where you need to update the files from the database #
        # Call this method everytime you need to update #
        # Plans recomputed everytime operator or fact file is update #
        # Call returnPlan() method to get the plan without associated garbage #

        tempObs = ""
        self.cursor.execute('select plan_desc from plans')
        obsList = self.cursor.fetchall()
        for obs in obsList:
            tempObs += obs[0] + '\n'
        
        with open(self.obsFile,'w') as masterObs:
            masterObs.write(tempObs) 

        tempProblem  = "(define (problem BYENG) (:domain RADAR)\n\n(:objects \n"
	
	#Objects in problem.pddl
        self.cursor.execute('select * from object_type')
	object_type = self.cursor.fetchall()
	for i in object_type:
	    self.cursor.execute('select object_name from objects where type ='+ str(i[0]))
	    objects = self.cursor.fetchall()
            for o in objects:
		tempProblem += ' ' + o[0]
   	    tempProblem += ' - ' + i[1]	+ '\n'
	
	#initialization Statement       
        tempProblem += "\n)\n\n(:init\n"
	
	#The initial task
	self.cursor.execute('select * from tasks')        
	initStateList = self.cursor.fetchall()
        for predicate in initStateList:
            tempProblem += '(' + predicate[0] + ')\n'

        tempProblem += '\n(=(total-cost) 0.0)\n\n'

	tempProblem = self.addNotNeeded(tempProblem, self.cursor)

	#The given data or resources
	query = 'select * from fire_stations_actual'
  	query_for_predicates = 'select * from predicates_for_fireStation'        
	tempProblem = self.resourceAvailable(query, query_for_predicates, self.cursor, tempProblem)

	query = 'select * from hospitals'
  	query_for_predicates = 'select * from predicates_for_hospital'        
	tempProblem = self.resourceAvailable(query, query_for_predicates, self.cursor, tempProblem)

	query = 'select * from police_stations'
  	query_for_predicates = 'select * from predicates_for_policeStation'        
	tempProblem = self.resourceAvailable(query, query_for_predicates, self.cursor, tempProblem)

	self.cursor.execute('select * from durations')
        durationList = self.cursor.fetchall()
        for duration in durationList:
            # data is fluent-value tuple
            tempProblem += '(=(' + duration[0] + ') ' + str(duration[1]) + ')\n'
        tempProblem += '\n)\n\n(:goal\n(and\n'

	self.cursor.execute('select * from subgoals')
        goalList = self.cursor.fetchall()
        for goal in goalList:
            tempProblem += '(' + goal[0] + ')\n'

	tempProblem = self.addNotNeeded(tempProblem, self.cursor)
        tempProblem += '))\n'
        tempProblem += '\n(:metric minimize (total-cost))\n\n)\n'
        
        with open(self.problemFile,'w') as masterProblem:
            masterProblem.write(tempProblem)

        #self.__compileObservations__()
        self.__runPlanner__()
        #self.__extractPlan__()


    def __compileObservations__(self):
        try:
            cmd = PATH_TO_OBS_COMPILER + 'pr2plan -d ' + self.domainFile + ' -i ' + self.problemFile + ' -o ' + self.obsFile + ' > ' + self.logFile 
            os.system(cmd)
            print 'Observations compiled to grounded domain and problem files...'
        except:
            raise Exception("Compilation aborted with error!")
            
    def __runPlanner__(self):
        try:
            cmd = PATH_TO_FAST_DOWNWARD + 'translate/translate.py '+ self.domainFile +' '+ self.problemFile + ' > ' + self.logFile
            os.system(cmd)
            cmd = PATH_TO_FAST_DOWNWARD + 'preprocess/preprocess < output.sas > ' + self.logFile
            os.system(cmd)
            cmd = PATH_TO_FAST_DOWNWARD + 'fast-downward.py output --landmarks "lm_exhaust()" > ' + self.logFile
            os.system(cmd)
            print 'FAST-DOWNWARD called...'
        except:
            raise Exception('Error running FAST-DOWNWARD!')

    def __extractPlan__(self):
        try:
            self.plan = ""
            with open('sas_plan','r') as planFile:
            	for line in planFile:
                	if 'cost' not in line:
                	    if 'explain' not in line:
                	        self.plan += line.split(')')[0].split('(')[1] + '\n'
                	else:
                	    self.plan += '_'.join(line.split('_')[1:-1]) + '\n'                            
	                self.plan = self.plan.strip()
        except:
            raise Exception('Plan file not found - looking for <sas_plan> !')

    def resourceAvailable(self, query, query_for_predicates, cursor, tempProblem):
	cursor.execute(query)
	data = cursor.fetchall()
	cursor.execute(query_for_predicates)
        pred = cursor.fetchall()
	for i in data:
            length = len(i)
	    for j in range(1, length):
	    	pre = [p[1] for p in pred if p[0] == j]
		if(i[j] > 0):
	    	    tempProblem += '('+ pre[0] +' '+ i[0] +')\n'
        return tempProblem
	

    def addNotNeeded(self, tempProblem, cursor):
	cursor.execute('select object_name from objects where type = 8')
	pois = cursor.fetchall()
        cursor.execute('select object_name from objects where type in (1,2,3,4)')
	actors = cursor.fetchall()
	for i in pois:
	    #tempProblem += '( not_needed_barricade ' + i[0] + ' )\n'
	    tempProblem += '( not_needed_search_casualties ' + i[0] + ' )\n'
	    tempProblem += '( not_needed_attend_casualties ' + i[0] + ' )\n'
	    for j in pois:
		tempProblem += '( not_needed_diverted_traffic ' + i[0] + ' '+ j[0] +')\n'
        for i in actors:
	    tempProblem += '( not_needed_active_local_alert ' + i[0] + ' )\n'
        tempProblem += '(not_needed_address_media )\n'
        return tempProblem

    def addlandmarks(self):
	resourceIdPair = {}
	self.cursor.execute('delete from landmarks')
	self.cursor.execute('delete from disj_landmark')
	self.db.commit()
	self.cursor.execute('select * from predicate_resource')
	resourceIdTemp = self.cursor.fetchall()
	for r in resourceIdTemp:
	    resourceIdPair[r[1]] = [int(r[0]), r[2]]
	landmarksFile = open('landmark.txt', 'r')
	land = []
	landmarks = (landmarksFile.read()).split('\n')
	duplicate=[]
	#print resourceIdPair
	for landmark in landmarks:
	    if("conj" not in landmark and "disj" not in landmark):
	        land.append(landmark.split(' '))
	#print resourceIdPair['deployed_engines'][0]
	try:
            for l in land:
		if l[0] != '':
		    if( "deployed" in l[2] and "NegatedAtom" not in l[1]):
			for i in resourceIdPair:
			    if(i in l[2]):
				if ((resourceIdPair[i])[1]==True):
				    self.cursor.execute("insert into disj_landmark values(3, 5)")
				elif ((resourceIdPair[i])[0]) not in duplicate:
  		                    self.cursor.execute("insert into landmarks values(" + str(resourceIdPair[i][0]) +",'" + l[2] + "')")
				    duplicate.append(resourceIdPair[i])
	    self.db.commit()
	except:
	    print "failed \n"
	    self.db.rollback()
	landmarksFile.close()

    def addDisjuctiveLandmark(self):
	resourceIdPair = {}
	#self.cursor.execute('delete from disj_landmark')
	self.db.commit()
	self.cursor.execute('select * from predicate_resource')
	resourceIdTemp = self.cursor.fetchall()
	for r in resourceIdTemp:
	    resourceIdPair[r[1]] = int(r[0])
	landmarksFile = open('landmark.txt','r')
	disjLandmark = []
	resource1 =""
	resource2 =""
	isDisjunctive = 0
	landmarks = (landmarksFile.read()).split('\n')
	for landmark in landmarks:
	    if('disj' in landmark):
		disjLandmark.append(landmark.split(' '))
	try:
	    for l in disjLandmark:
		if l[0] !='':
		    if("deployed" in l[3] and "NegatedAtom" not in l[2]  and "deployed" in l[5] and "NegatedAtom" not in l[4]):
			for i in resourceIdPair:
			    if(i in l[3]):
				resource1 = str(resourceIdPair[i])
			    if(i in l[5]):
				resource2 = str(resourceIdPair[i])
			self.cursor.execute("insert into disj_landmark values("+resource1+","+resource2+")")
			resource1 =""
			resource2 =""
			isDisjunctive = True
	    if(isDisjunctive):
  	        self.db.commit()
	except:
	   print "Failed"
	   self.db.rollback()
	landmarksFile.close()

	
    def alert(self):
	self.cursor.execute('delete from alert')
	self.db.commit()
	self.cursor.execute('select id from landmarks')
 	landmarks = self.cursor.fetchall()
	for i in landmarks:
	    try:
		self.cursor.execute('select resource_type from predicate_resource where id = '+ str(i[0]))
		resource = (self.cursor.fetchone())[0]
		print resource
		self.cursor.execute('select ' + resource + ' from fire_stations')
		fire_stations = self.cursor.fetchall()
		print fire_stations;
		noAlert = False
		for i in fire_stations:
		    if(int((i)[0]) == 1):
			noAlert = True
			break
		    else:
			continue;
		if(noAlert == False):
	            self.cursor.execute("insert into alert values('You need "+resource+" before you can complete the task')")
	    except:
		print 'failed'
	self.db.commit()
	
    def disj_alert(self):
	self.cursor.execute('select landmark1, landmark2 from disj_landmark')
 	disjlandmarks = self.cursor.fetchall()
	k = 0
	for i in disjlandmarks:
	    try:
		isResource1NotAvail = False
		isResource2NotAvail = False
		self.cursor.execute('select resource_type from predicate_resource where id = '+ str(i[0]))
		resource1 = (self.cursor.fetchone())[0]
		self.cursor.execute('select resource_type from predicate_resource where id = '+ str(i[1]))
		resource2 = (self.cursor.fetchone())[0]
		self.cursor.execute('select ' + resource1 + ' from fire_stations')
		resource1List = self.cursor.fetchall()
		self.cursor.execute('select ' + resource2 + ' from fire_stations')
		resource2List = self.cursor.fetchall()
		for i in resource1List:
		    if(int((i)[0]) == 1):
			continue
		    else:
			isResource1NotAvail = True
			break
		for i in resource2List:
		    if(int((i)[0]) == 1):
			continue
		    else:
			isResource2NotAvail = True
			break
		if(isResource1NotAvail and isResource2NotAvail):
		    self.cursor.execute("insert into alert values('You need either "+resource1+" or "+resource2+" before you can complete the task')")
	    except:
		print 'failed'
	self.db.commit()


if __name__ == '__main__':
    
    if len(sys.argv) == 1:
        domainFile  = PATH_TO_OBS_COMPILER+'domain.pddl'
        problemFile = PATH_TO_OBS_COMPILER+'template1.pddl'
        obsFile     = PATH_TO_OBS_COMPILER+'obs1.dat'
    else:
        try:
            domainFile  = sys.argv[1]
            problemFile = sys.argv[2]
            obsFile     = sys.argv[3]
        except:
            raise Exception("USAGE :: ./fdCompile <domain> <problem> <observations>")

    fdCompiler = fdCompile(domainFile, problemFile, obsFile)
    fdCompiler.updateFiles()
    fdCompiler.addlandmarks()
    #fdCompiler.addDisjuctiveLandmark()
    fdCompiler.alert()
    fdCompiler.disj_alert()
    #print '\nFinal Plan >>\n' + fdCompiler.returnPlan()


