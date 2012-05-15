#!/usr/bin/env python

# A python script to parse log file to generate cross-reference information
# and print out the cross-reference information based on the input.
# To run the script, please do
# python CrossReferenceConsole.py -l <logFileDir> -r <VistA-Repository-Dir> -d <Dox-Repository-Dir>
# enter quit to exit
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
import argparse
import os
import CallerGraphParser
from DataDictionaryParser import DataDictionaryListFileLogParser
import re
import sys
from datetime import datetime, date, time
import csv
from LogManager import logger
import logging

routineName = re.compile("^R:(?P<name>[^ ]+)")
packageName = re.compile("^P:(?P<name>.*)")
globalName = re.compile("^G:(?P<name>.*)")

def findRoutinesWithMostOfCallers(logParser):
    maxCallerRoutine = None
    maxCalledRoutine = None
    for routine in logParser.getAllRoutines().itervalues():
        if not maxCallerRoutine:
            maxCallerRoutine = routine
        if not maxCalledRoutine:
            maxCalledRoutine = routine
        if routine.getTotalCaller() > maxCallerRoutine.getTotalCaller():
            maxCallerRoutine = routine
        if routine.getTotalCalled() > maxCalledRoutine.getTotalCalled():
            maxCalledRoutine = routine
    print ("Max Caller Routine is %s, package: %s, total Caller: %d" % (maxCallerRoutine,
                                                                        maxCallerRoutine.getPackage(),
                                                                        maxCallerRoutine.getTotalCaller()))
    print ("Max Called Routine is %s, package: %s, total Called: %d" % (maxCalledRoutine,
                                                                        maxCalledRoutine.getPackage(),
                                                                        maxCalledRoutine.getTotalCalled()))

def findPackagesWithMostOfDependency(logParser):
    maxPackageDependency = None
    maxPackageDependent = None
    for package in logParser.getAllPackages().itervalues():
        if not maxPackageDependency:
            maxPackageDependency = package
        if not maxPackageDependent:
            maxPackageDependent = package
        if len(package.getPackageRoutineDependencies()) > len(maxPackageDependency.getPackageRoutineDependencies()):
            maxPackageDependency = package
        if len(package.getPackageRoutineDependents()) > len(maxPackageDependent.getPackageRoutineDependents()):
            maxPackageDependent = package
    print ("Max Dependency package: %s, total Dependencies: %d" % (maxPackageDependency.getName(),
                                                                   len(maxPackageDependency.getPackageRoutineDependencies())))
    print ("Max Dependent package: %s, total Dependents: %d" % (maxPackageDependent.getName(),
                                                                len(maxPackageDependent.getPackageRoutineDependents())))

def normalizePackageName(packageName):
    newName = packageName.replace(' ', '_')
    return newName.replace('-', "_")

# this is too big to generate the whole graph
def generateAllPackageDependencyGraph(allPackages, outputFile):
    output = open(outputFile, 'w')
    output.write("digraph allPackage{\n")
    output.write("\tnode [shape=box fontsize=11];\n")
    output.write("\tnodesep=0.45;\n")
    for name in allPackages.iterkeys():
         output.write("\t%s [label=\"%s\"];\n" % (normalizePackageName(name), name))
    for package in allPackages.itervalues():
        for depPack in package.getPackageDependencies().iterkeys():
            output.write("\t %s->%s;\n" % (normalizePackageName(package.getName()),
                                           normalizePackageName(depPack.getName())))
    output.write("}\n")

def generateAllPackageDependencyList(allPackages):
    dependentList = set()
    for package in allPackages.itervalues():
        for depPack in package.getPackageDependencies().iterkeys():
            name = "%s-%s" % (package, depPack)
            name1 = "%s-%s" % (depPack, package)
            if name not in dependentList and name1 not in dependentList:
                dependentList.add(name)
    print ("Total # items is %d" % len(dependentList))
    print (sorted(dependentList))
def printAllPercentRoutines(crossReference, outputFile=None):
    allRoutines = crossReference.getAllPercentRoutine()
    sortedRoutine = sorted(allRoutines)
    index = 0
    print ("Total # of Percent routines: %d" % len(allRoutines))
    if outputFile:
        outputFile = open(outputFile, "wb")
        csvWriter = csv.writer(outputFile)
    for routineName in sortedRoutine:
        sys.stdout.write(" %s " % routineName)
        if outputFile:
            csvWriter.writerow([routineName, "", ""])
        if (index + 1) % 10 == 0:
            sys.stdout.write ("\n")
        index += 1
    sys.stdout.write("\n")
def printOrphanGlobals(logParser):
    crossRef = logParser.getCrossReference()
    orphanGlobals = crossRef.getOrphanGlobals()
    sortedGlobals = sorted(orphanGlobals)
    index = 0
    topLevel = dict()
    topLevelRegex = re.compile("(?P<Name>^\^[^ \(]+)\(?(?P<Index>.*)")
    for globalName in sortedGlobals:
        result = topLevelRegex.search(globalName)
        if result:
            varName = result.group('Name')
            index = result.group('Index')
            if varName not in topLevel:
                topLevel[varName] = set()
            topLevel[varName].add(index)
        else:
            sys.stderr.write("Could not parse global %s\n" % globalName)
            continue
        #sys.stdout.write(" %s " % globalName)
        #if (index + 1) % 10 == 0:
        #    sys.stdout.write("\n")
        #index += 1
    print ("Total # of top level orphan globals: %d" % len(topLevel))
    topLevelFileMan = set()
    for key in sorted(topLevel.keys()):
        sys.stdout.write("%s %s\n" % (key,topLevel[key]))
        globalVar = crossRef.getGlobalByName(key)
        if globalVar:
            topLevelFileMan.add(globalVar)
    sys.stdout.write("\n")
    print ("Total # of top level FileMan File: %d\n" % len(topLevelFileMan))
    sys.stdout.write("%s\n" % (topLevelFileMan))
    sys.stdout.write("\n")
def printAllUnknownRoutines(crossRef, outputFileName=None):
    unknownPackage = crossRef.getPackageByName("UNKNOWN")
    allPercentRoutines = sorted(crossRef.getAllPercentRoutine())
    if outputFileName:
        outputFile = open(outputFile, 'wb')
        csvWriter = csv.writer(outputFile)
    if unknownPackage:
        allRoutines = unknownPackage.getAllRoutines()
        print ("Total # of routines: %d" % len(allRoutines))
        index = 0
        totalPercentRoutines = 0
        for routineName in sorted(allRoutines.keys()):
            routine = allRoutines[routineName]
            if not routineName.startswith("%"):
                tempName = "%" + routineName
                if tempName in allPercentRoutines:
                    routineName = tempName
                    totalPercentRoutines += 1
            sys.stdout.write(" %s " % routineName)
            if outputFileName: csvWriter.writerow([routineName, "", ""])
            if (index + 1) % 10 == 0:
                sys.stdout.write("\n")
            index += 1
        sys.stdout.write("\n")
        print ("Total Percent routines are: %d" % totalPercentRoutines)

def printUsage():
    print ("Please enter quit to exit")
    print ("Please enter help for usage")
    print ("please enter orphan_routine to print orphan routines")
    print ("please enter orphan_global to print orphan globals")
    print ("please enter max_call to print routines with max caller and max called routines")
    print ("please enter max_dep to print packages with max dependencies and max dependents")
    print ("please enter gen_allpack to generate all packages dependency list")
    print ("please enter all_percent to print all routines start with %")
    print ("please enter R:<routineName> to print all information related to a routine")
    print ("please enter G:<globalname> to print all information related to a global")
    print ("please enter P:<packageName> to print all information related to a package")
    print ("please enter output-unknown to print all routines under package UNKNOWN")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA Cross-Reference information Finder')
    parser.add_argument('-l', required=True, dest='logFileDir',
                        help='Input XINDEX log files directory generated by CTest, nomally under'
                             'CMAKE_BUILD_DIR/Docs/CallerGraph/')
    parser.add_argument('-r', required=True, dest='repositDir',
                        help='VistA Git Repository Directory')
    parser.add_argument('-d', required=True, dest='docRepositDir',
                        help='VistA Cross-Reference Git Repository Directory')
    parser.add_argument('-f', dest='fileSchemaDir',
                        help='VistA File Man Schema log Directory')
    result = vars(parser.parse_args());
    logger.setLevel(logging.INFO)
    consoleHandler = logging.StreamHandler()
    consoleHandler.setLevel(logging.INFO)
    logger.addHandler(consoleHandler)
    logParser = CallerGraphParser.CallerGraphLogFileParser()
    print "Starting parsing package/routine...."
    print "Time is: %s" % datetime.now()

    logParser.parsePercentRoutineMappingFile(os.path.join(result['docRepositDir'],
                                                          "PercentRoutineMapping.csv"))
    logParser.parsePackagesFile(os.path.join(result['repositDir'], "Packages.csv"))
    logParser.parsePlatformDependentRoutineFile(os.path.join(result['docRepositDir'],
                                                                 "PlatformDependentRoutine.csv"))
    packagesDir = os.path.join(result['repositDir'], "Packages")
    globalFilePattern = "*/Globals/*.zwr"
    logParser.findGlobalsBySourceV2(packagesDir, globalFilePattern)
    routineFilePattern = "*/Routines/*.m"
    logParser.findPackagesAndRoutinesBySource(packagesDir, routineFilePattern)
    print "End parsing package/routine...."
    print "Time is: %s" % datetime.now()
    print "Starting parsing caller graph log file...."
    callLogPattern = "*.log"
    logParser.parseAllCallerGraphLog(result['logFileDir'], callLogPattern)
    orphanRoutines = sorted(logParser.getCrossReference().getOrphanRoutines())
    if result['fileSchemaDir']:
      dataDictLogParser = DataDictionaryListFileLogParser(logParser.getCrossReference())
      dataDictLogParser.parseAllDataDictionaryListLog(result['fileSchemaDir'],"*.schema")
      dataDictLogParser.parseAllDataDictionaryListLog(result['fileSchemaDir'],".*.schema")
    # generate package direct dependency based on XINDEX call graph and fileman reference
    logParser.getCrossReference().generateAllPackageDependencies()
    print "End of parsing log file......"
    print "Time is: %s" % datetime.now()
    # read the user input from the terminal
    isExit = False
    printUsage()
    while not isExit:
        var = raw_input("Please enter the routine Name or package Name:")
        if (var == 'quit'):
            isExit = True
            continue
        if (var == 'orphan_routine'):
            for routine in orphanRoutines:
                print routine
            continue
        if (var == 'orphan_global'):
            printOrphanGlobals(logParser)
            continue
        if var == "max_call":
            findRoutinesWithMostOfCallers(logParser)
            continue
        if var == "max_dep":
            findPackagesWithMostOfDependency(logParser)
            continue
        if var == "gen_allpack":
            generateAllPackageDependencyList(logParser.getAllPackages())
            continue
        if var == "all_percent":
            printAllPercentRoutines(logParser.getCrossReference())
            continue
        if var == "output-unknown":
            printAllUnknownRoutines(logParser.getCrossReference())
            continue
        if var == "help":
            printUsage()
            continue
        result = routineName.search(var)
        if result:
            logParser.printRoutine(result.group('name'))
            continue
        result = packageName.search(var)
        if result:
            logParser.printPackage(result.group('name').strip())
            continue
        result = globalName.search(var)
        if result:
            logParser.printGlobal(result.group('name').strip())
            continue
