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
        tempProblem += '))\n'
        tempProblem += '\n(:metric minimize (total-cost))\n\n)\n'
        
        with open(self.problemFile,'w') as masterProblem:
            masterProblem.write(tempProblem)

        self.__compileObservations__()
        self.__runPlanner__()
        self.__extractPlan__()


    def __compileObservations__(self):
        try:
            cmd = PATH_TO_OBS_COMPILER + 'pr2plan -d ' + self.domainFile + ' -i ' + self.problemFile + ' -o ' + self.obsFile + ' > ' + self.logFile 
            os.system(cmd)
            print 'Observations compiled to grounded domain and problem files...'
        except:
            raise Exception("Compilation aborted with error!")
            
    def __runPlanner__(self):
        try:
            cmd = PATH_TO_FAST_DOWNWARD + 'translate/translate.py pr-domain.pddl pr-problem.pddl > ' + self.logFile
            os.system(cmd)
            cmd = PATH_TO_FAST_DOWNWARD + 'preprocess/preprocess < output.sas > ' + self.logFile
            os.system(cmd)
            cmd = PATH_TO_FAST_DOWNWARD + "fast-downward.py output --search 'astar(lmcut())' > " + self.logFile
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
	    	tempProblem += '(=('+ pre[0] +' '+ i[0] +') ' + str(i[j]) + ')\n'
        return tempProblem


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
    print '\nFinal Plan >>\n' + fdCompiler.returnPlan()
