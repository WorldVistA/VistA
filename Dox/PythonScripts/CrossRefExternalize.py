#!/usr/bin/env python

# A Python model to read/write CrossReference as XML format
#---------------------------------------------------------------------------
# Copyright 2011 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#----------------------------------------------------------------
from CrossReference import CrossReference, Routine, Package
from CrossReference import LocalVariable, GlobalVariable, NakedGlobal, MarkedItem
from CrossReference import RoutineCallSet, RoutineCallerInfo
from xml.etree.ElementTree import ElementTree, Element, SubElement, parse, dump
import argparse
import os
import CallerGraphParser
from datetime import datetime, date, time

class CrossRefExternalize:
    def __init__(self):
        self.crossRef=CrossReference()
        self.root=Element("CrossReference", version="1.0")
    def __init__(self, crossRef):
        self.crossRef=crossRef
        self.root=Element("CrossReference", version="1.0")
    def getCrossReference(self):
        return self.crossRef
    def outputRoutineVariables(self, parent, variables, tag):
        variablesElement=SubElement(parent,tag)
        for var in variables:
            varElement=SubElement(variablesElement,"Var",
                                  name=var.getName(),
                                  EK=str(var.getNotKilledExp()),
                                  N=str(var.getNewed()),
                                  C=str(var.getChanged()),
                                  K=str(var.getKilled()))
    def outputRoutineCalledRoutines(self, parent, calledRoutines):
        calledRoutinesElement=SubElement(parent,"CalledRoutines")
        for callInfo in calledRoutines:
            varElement=SubElement(calledRoutinesElement,"Routine",
                                  name=callInfo.getCalledRoutine().getName())
    def outputRoutinesAsXML(self, parent):
        allRoutineElement = SubElement(parent, "Routines")
        allRoutines = self.crossRef.getAllRoutines()
        for routine in allRoutines.values():
            packageName=""
            package = routine.getPackage()
            if package:
                packageName=package.getName()
            routineElement = SubElement(allRoutineElement,"Routine",
                                        name=routine.getName(),
                                        package=packageName)
            self.outputRoutineVariables(routineElement,
                                        routine.getLocalVariables(),
                                        "LocalVariables")
            self.outputRoutineVariables(routineElement,
                                        routine.getLocalVariables(),
                                        "GlobalVariables")
            self.outputRoutineVariables(routineElement,
                                        routine.getLocalVariables(),
                                        "NakedGlobals")
            self.outputRoutineVariables(routineElement,
                                        routine.getLocalVariables(),
                                        "MarkedItems")
            self.outputRoutineCalledRoutines(routineElement,
                                             routine.getCalledRoutines())
    def outputOrphanRoutinesAsXML(self, parent):
        routinesElement=SubElement(parent,"OrphanRoutines")
        for routineName in self.crossRef.getOrphanRoutines():
            routineElement=SubElement(routinesElement,"Routine", name=routineName)
    def outputPackagesAsXML(self, parent):
        allPackageElement = SubElement(parent,"Packages")
        allPackages = self.crossRef.getAllPackages()
        for packageName in allPackages.iterkeys():
            packageElement = SubElement(allPackageElement,"Package",
                                        name=packageName,
                                        total="%d" % len(allPackages[packageName].getAllRoutines()))
    def outputRoutinesAsPlainLog(self,outputFile):
        outputFile.write("Total Routines, %s" % len(allRoutines))
    def outputPackagesAsPlainLog(self, outputFile):
        allPackages = self.crossRef.getAllPackages()
        outputFile.write("Total Packages, %d" % len(allPackages))
        for packageName, package in allPackages.iteritems():
            outputFile.write("Package,%s, Total,%d" % (packageName, len(package.getAllRoutines())))
    def outputAsXML(self,outputFile):
        self.outputPackagesAsXML(self.root)
        self.outputRoutinesAsXML(self.root)
        self.outputOrphanRoutinesAsXML(self.root)
        fileHandle=open(outputFile,'w')
        ElementTree(self.root).write(fileHandle, "utf-8")
    def outputAsPlainLog(self,outputFile):
        fileHandle=open(outputFile,'w')
        self.outputPackagesAsPlainLog(fileHandle)
        self.outputRoutinesAsPlainLog(fileHandle)
        self.outputOrphanRoutinesAsPlainLog(fileHandle)
    def loadFromXML(self, inputFile):
        pass

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA Cross Reference XML Package')
    parser.add_argument('-l', required=False, dest='logFileDir',
                        help='Input XINDEX log files directory generated by CTest, nomally under'
                             'CMAKE_BUILD_DIR/Docs/CallerGraph/')
    parser.add_argument('-r', required=False, dest='repositDir',
                        help='VistA Git Repository Directory')
    parser.add_argument('-O', required=False, dest='outputFile',
                        help='Output XML File Name')
    parser.add_argument('-I', required=False, dest='inputXMLFile',
                        help='Input XML File')
    result = vars(parser.parse_args());
    if result['inputXMLFile']:
        crossRefXML = CrossRefExternalize()
        crossRefXML.loadFromXML(result['inputXMLFile'])
        crossRef = crossRefXML.getCrossReference()
        crossRef.getPackageByName("Kernel").printResult()
        exit()
    logParser = CallerGraphParser.CallerGraphLogFileParser()
    print "Starting parsing package/routine...."
    print "Time is: %s" % datetime.now()
    routineFilePattern = "*/Routines/*.m"
    routineFileDir = os.path.join(result['repositDir'], "Packages")
    logParser.findPackagesAndRoutinesBySource(routineFileDir, routineFilePattern)
    print "End parsing package/routine...."
    print "Time is: %s" % datetime.now()
    print "Starting parsing caller graph log file...."

    callLogPattern="*.log"
    logParser.parseAllCallerGraphLog(result['logFileDir'], callLogPattern)
    print "End of parsing log file......"
    print "Time is: %s" % datetime.now()
    crossRef = CrossRefExternalize(logParser.getCrossReference())
    crossRef.outputAsXML(result['outputFile'])
    # read the user input from the terminal
