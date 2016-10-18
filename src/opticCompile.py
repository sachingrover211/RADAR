#!/usr/bin/env python

import os, sys
import Compiler as CA

class opticCompile(CA.Compiler):
    
    def __init__(self, domainFile, problemFile, obsFile = None, flag = False):
        CA.Compiler.__init__(self, domainFile, problemFile, obsFile, flag)

    def updateFiles(self):

        # This is where you need to update the files from the database #
        # Call this method everytime you need to update #
        # Plans recomputed everytime operator or fact file is update #
        # Call returnPlan() method to get the plan without associated garbage #

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
        tempProblem += '\n(:metric minimize (total-time))\n\n)\n'

        # uncomment this
        #with open(self.problemFile,'w') as masterProblem:
        #    masterProblem.write(tempProblem)

        self.__runPlanner__()
        self.__extractPlan__()


    def __runPlanner__(self):
        try:
            cmd = 'optic ' + self.domainFile + ' ' + self.problemFile + ' > ' + self.logFile
            os.system(cmd)
            print 'OPTIC called...'
        except:
            raise Exception('Error running FAST-DOWNWARD!')

    def __extractPlan__(self):
        try:
            self.plan = ""
            flag1     = False
            flag2     = False
            with open(self.logFile,'r') as planFile:
                for line in planFile:
                    flag1 = flag1 or 'Solution Found' in line
                    if flag2:
                        self.plan += '_'.join(line.split(' ')[1:-2]).split(')')[0].split('(')[1] + '\n'
                    flag2 = (flag1 and 'Time' in line) or flag2
                self.plan = self.plan.strip()
        except:
            raise Exception('Error reading plan file!')


if __name__ == '__main__':
    
    if len(sys.argv) == 1:
        domainFile  = 'temporal-domain.pddl'
        problemFile = 'temporal-problem.pddl'
    else:
        try:
            domainFile  = sys.argv[1]
            problemFile = sys.argv[2]
        except:
            raise Exception("USAGE :: ./fdCompile <domain> <problem> <observations>")

    opticCompiler = opticCompile(domainFile, problemFile)
    opticCompiler.updateFiles()
    print '\nFinal Plan >>\n' + opticCompiler.returnPlan()
