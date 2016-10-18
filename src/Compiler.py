#!/usr/bin/env python

import os, sys

class Compiler():
    
    def __init__(self, domainFile, problemFile, obsFile, flag):
        self.logFile     = self.__class__.__name__+'_log.txt'
        self.domainFile  = domainFile
        self.problemFile = problemFile
        self.obsFile     = obsFile
        self.plan        = None
        cmd = 'rm -f *~ *.stats sas_plan *output* .dat ' + self.logFile 
        os.system(cmd)
        print self.__class__.__name__ + ' initialized...'
        if flag:
            self.updateFiles()

    def updateFiles(self):
        pass

    def __runPlanner__(self):
        pass

    def __extractPlan__(self):
        pass

    def setDomainFile(self, domainFile):
        self.domainFile = domainFile

    def setProblemFile(self, problemFile):
        self.problemFile = problemFile

    def setObsFile(self, obsFile):
        self.obsFile = obsFile

    def whichFiles(self):
        return [self.domainFile, self.problemFile, self.obsFile]

    def returnPlan(self):
        return str(self.plan)
