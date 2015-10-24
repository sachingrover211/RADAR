#!/usr/bin/env python

import os, sys
import Compiler as CA
import MySQLdb

PATH_TO_OBS_COMPILER = '~/Documents/Radar/Radar/RADAR_tat/'
PATH_TO_FAST_DOWNWARD = '~/Documents/FD/src/'

class fdCompile(CA.Compiler):
    
    def __init__(self, domainFile, problemFile, obsFile, flag = False):
        CA.Compiler.__init__(self, domainFile, problemFile, obsFile, flag)

    def updateFiles(self):
        # This is where you need to update the files from the database #
        # Call this method everytime you need to update #
        # Plans recomputed everytime operator or fact file is update #
        # Call returnPlan() method to get the plan without associated garbage #

	db = MySQLdb.connect("localhost","root","root","radar")
	cursor = db.cursor()

        tempObs = ""
        cursor.execute('select plan_desc from plans')
        obsList = cursor.fetchall()
        for obs in obsList:
            tempObs += obs[0] + '\n'
        
        with open(self.obsFile,'w') as masterObs:
            masterObs.write(tempObs) 

        tempProblem  = "(define (problem BYENG) (:domain RADAR)\n\n(:objects \n"
	
	#Objects in problem.pddl
        cursor.execute('select * from object_type')
	object_type = cursor.fetchall()
	for i in object_type:
	    cursor.execute('select object_name from objects where type ='+ str(i[0]))
	    objects = cursor.fetchall()
            for o in objects:
		tempProblem += ' ' + o[0]
   	    tempProblem += ' - ' + i[1]	+ '\n'
	
	#initialization Statement       
        tempProblem += "\n)\n\n(:init\n"
	
	#The initial task
	cursor.execute('select * from tasks')        
	initStateList = cursor.fetchall()
        for predicate in initStateList:
            tempProblem += '(' + predicate[0] + ')\n'

        tempProblem += '\n(=(total-cost) 0.0)\n\n'

	tempProblem = self.addNotNeeded(tempProblem, cursor)

	#The given data or resources
	query = 'select * from fire_stations'
  	query_for_predicates = 'select * from predicates_for_fireStation'        
	tempProblem = self.resourceAvailable(query, query_for_predicates, cursor, tempProblem)

	query = 'select * from hospitals'
  	query_for_predicates = 'select * from predicates_for_hospital'        
	tempProblem = self.resourceAvailable(query, query_for_predicates, cursor, tempProblem)

	query = 'select * from police_stations'
  	query_for_predicates = 'select * from predicates_for_policeStation'        
	tempProblem = self.resourceAvailable(query, query_for_predicates, cursor, tempProblem)

	cursor.execute('select * from durations')
        durationList = cursor.fetchall()
        for duration in durationList:
            # data is fluent-value tuple
            tempProblem += '(=(' + duration[0] + ') ' + str(duration[1]) + ')\n'
        tempProblem += '\n)\n\n(:goal\n(and\n'

	cursor.execute('select * from subgoals')
        goalList = cursor.fetchall()
        for goal in goalList:
            tempProblem += '(' + goal[0] + ')\n'

	tempProblem = self.addNotNeeded(tempProblem, cursor)
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
            cmd = PATH_TO_FAST_DOWNWARD + 'fast-downward.py output --landmarks "lm_hm()" > ' + self.logFile
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
	    tempProblem += '( not_needed_barricade ' + i[0] + ' )\n'
	    tempProblem += '( not_needed_search_casualties ' + i[0] + ' )\n'
	    tempProblem += '( not_needed_attend_casualties ' + i[0] + ' )\n'
	    for j in pois:
		tempProblem += '( not_needed_diverted_traffic ' + i[0] + ' '+ j[0] +')\n'
        for i in actors:
	    tempProblem += '( not_needed_active_local_alert ' + i[0] + ' )\n'
        tempProblem += '(not_needed_address_media )\n'
        return tempProblem

    def addlandmarks(self):
        #resourceIdPair = {'helicopter': 1, 'bulldozers': 2, 'big_engine': 3, 'rescuer':4 }
	resourceIdPair = {}
	db = MySQLdb.connect("localhost","root","root","radar")
	cursor = db.cursor()
	cursor.execute('delete from landmarks')
	cursor.execute('select * from predicate_resource')
	resourceIdTemp = cursor.fetchall()
	for r in resourceIdTemp:
	    resourceIdPair[r[1]] = int(r[0])
	#resource = resourceIdPair.keys()
	res = cursor.fetchall()
	landmarksFile = open('landmark.txt', 'r')
	land = []
	landmarks = (landmarksFile.read()).split('\n')
	duplicate=[]
	for landmark in landmarks:
	    land.append(landmark.split(' '))
	try:
            for l in land:
		if l[0] != '':
		    if( "deployed" in l[2]):
			for i in resourceIdPair:
			    if(i in l[2]):
				if resourceIdPair[i] not in duplicate:
  		                    cursor.execute("insert into landmarks values(" + str(resourceIdPair[i]) +",'" + l[2] + "')")
				    duplicate.append(resourceIdPair[i])
	    db.commit()
	except:
	    print "failed \n"
	    db.rollback()
	landmarksFile.close()	    
	
    def alert(self):
	db = MySQLdb.connect("localhost","root","root","radar")
	cursor = db.cursor()
	cursor.execute('delete from alert')
	cursor.execute('select id from landmarks')
 	landmarks = cursor.fetchall()
	for i in landmarks:
	    try:
		cursor.execute('select resource_type from predicate_resource where id = '+ str(i[0]))
		resource = (cursor.fetchone())[0]
		cursor.execute('select ' + resource + ' from fire_stations_actual')
		fire_stations = cursor.fetchall()
		for i in fire_stations:
		    if(int((i)[0]) == 1):
			continue
		    else:
			cursor.execute("insert into alert values('"+resource+"')")
		        print 'You need '+ resource+' before you can complete the task'
			break
	    except:
		print 'failed'
	db.commit()	
    

if __name__ == '__main__':
    
    if len(sys.argv) == 1:
        domainFile  = 'domain.pddl'
        problemFile = 'template1.pddl'
        obsFile     = 'obs1.dat'
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
    fdCompiler.alert()
    #print '\nFinal Plan >>\n' + fdCompiler.returnPlan()

'''    def addlandmarks(self):
	db = MySQLdb.connect("localhost","root","root","radar")
	cursor = db.cursor()
	cursor.execute('delete from landmarks')
	db.commit()
	landmarks = open('example.txt', 'r')
	land=[]
        landEdge = ((landmarks.read()).split('\n'))
        landEdge = landEdge[0: (len(landEdge) - 1)]
	for i in landEdge:
	    land.append(i.split(' '))
        l = []
        for i in land:
            l.append(int(i[0]))
        l = list(set(l))
	try:
	    for i in l:
	    	cursor.execute('insert into landmarks values('+str(i)+')')
            db.commit()
	except:
	    db.rollback()
	landmarks.close()
'''

