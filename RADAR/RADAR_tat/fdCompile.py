#!/usr/bin/env python

import os, sys
import Compiler as CA

PATH_TO_OBS_COMPILER = '~/Desktop/radar/RADAR_tat/'
PATH_TO_FAST_DOWNWARD = '~/Desktop/FastDownward/src/'

class fdCompile(CA.Compiler):
    
    def __init__(self, domainFile, problemFile, obsFile, flag = False):
        CA.Compiler.__init__(self, domainFile, problemFile, obsFile, flag)

    def updateFiles(self):
        # This is where you need to update the files from the database #
        # Call this method everytime you need to update #
        # Plans recomputed everytime operator or fact file is update #
        # Call returnPlan() method to get the plan without associated garbage #

        tempObs = ""
        obsList = [] # get from database 
        for obs in obsList:
            tempObs += obs + '\n'
        # uncomment this
        #with open(self.obsFile,'w') as masterObs:
        #    masterObs.write(tempObs) 

        tempProblem  = "(define (problem BYENG) (:domain RADAR)\n\n(:objects"
        objectList   = [] # get from database
        for obj in objectList:
            # depends on how you are storing objects and their types
            # possibly table with type and corresponding objects 
            # so do .join over all objects and add - type
            tempProblem += obj 
        tempProblem += "\n)\n\n(:init\n"
        initStateList = [] # get from database
        for predicate in initStateList:
            tempProblem += '(' + predicate + ')\n'
        tempProblem += '\n(=(total-cost) 0.0)\n\n'
        dataList = [] # get from database
        for data in dataList:
            # data is fluent-value tuple
            tempProblem += '(=(' + data[0] + ') ' + data[1] + ')\n'
        durationList = [] # get from database
        for duration in durationList:
            # data is fluent-value tuple
            tempProblem += '(=(' + duration[0] + ') ' + duration[1] + ')\n'
        tempProblem += '\n)\n\n(:goal\n(and\n'
        goalList = [] # get from database
        for goal in goalList:
            tempProblem += '(' + goal + ')\n'
        tempProblem += '))\n'
        tempProblem += '\n(:metric minimize (total-cost))\n\n)\n'
        
        # uncomment this
        #with open(self.problemFile,'w') as masterProblem:
        #    masterProblem.write(tempProblem)

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


if __name__ == '__main__':
    
    if len(sys.argv) == 1:
        domainFile  = 'domain.pddl'
        problemFile = 'template.pddl'
        obsFile     = 'obs.dat'
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
