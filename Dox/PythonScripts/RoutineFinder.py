#!/usr/bin/env python

# A python script to parse log file to generate routine/package information
# and print out the routine information based on the input.
# To run the script, please do
# python RoutineFinder.py -l <logFileDir> -r <VistA-Repository-Dir>
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
import re
import sys
from datetime import datetime, date, time

routineName=re.compile("^R:(?P<name>[^ ]+)")
packageName=re.compile("^P:(?P<name>.*)")
globalName=re.compile("^G:(?P<name>.*)")

def findRoutinesWithMostOfCallers(logParser):
    maxCallerRoutine=None
    maxCalledRoutine=None
    for routine in logParser.getAllRoutines().itervalues():
        if not maxCallerRoutine:
            maxCallerRoutine=routine
        if not maxCalledRoutine:
            maxCalledRoutine=routine
        if routine.getTotalCaller() > maxCallerRoutine.getTotalCaller():
            maxCallerRoutine=routine
        if routine.getTotalCalled() > maxCalledRoutine.getTotalCalled():
            maxCalledRoutine=routine
    print ("Max Caller Routine is %s, package: %s, total Caller: %d" % (maxCallerRoutine,
                                                                        maxCallerRoutine.getPackage(),
                                                                        maxCallerRoutine.getTotalCaller()))
    print ("Max Called Routine is %s, package: %s, total Called: %d" % (maxCalledRoutine,
                                                                        maxCalledRoutine.getPackage(),
                                                                        maxCalledRoutine.getTotalCalled()))

def findPackagesWithMostOfDependency(logParser):
    maxPackageDependency=None
    maxPackageDependent=None
    for package in logParser.getAllPackages().itervalues():
        if not maxPackageDependency:
            maxPackageDependency=package
        if not maxPackageDependent:
            maxPackageDependent=package
        if len(package.getPackageDependencies()) > len(maxPackageDependency.getPackageDependencies()):
            maxPackageDependency=package
        if len(package.getPackageDependents()) > len(maxPackageDependent.getPackageDependents()):
            maxPackageDependent=package
    print ("Max Dependency package: %s, total Dependencies: %d" % (maxPackageDependency.getName(), len(maxPackageDependency.getPackageDependencies())))
    print ("Max Dependent package: %s, total Dependents: %d" % (maxPackageDependent.getName(), len(maxPackageDependent.getPackageDependents())))

def normalizePackageName(packageName):
    newName = packageName.replace(' ','_')
    return newName.replace('-',"_")

# this is too big to generate the whole graph
def generateAllPackageDependencyGraph(allPackages):
    output = open("c:/Temp/Testing/AllPackage.dot", 'w')
    output.write("digraph allPackage{\n")
    output.write("\tnode [shape=box fontsize=11];\n")
    output.write("\tnodesep=0.45;\n")
    for name in allPackages.iterkeys():
         output.write("\t%s [label=\"%s\"];\n" % (normalizePackageName(name),name))
    for package in allPackages.itervalues():
        for depPack in package.getPackageDependencies().iterkeys():
            output.write("\t %s->%s;\n" % (normalizePackageName(package.getName()),
                                           normalizePackageName(depPack.getName())))
    output.write("}\n")

def generateAllPackageDependencyList(allPackages):
    dependentList=set()
    for package in allPackages.itervalues():
#        if isUnknownPackage(package.getName()):
#            continue
        for depPack in package.getPackageDependencies().iterkeys():
            name = "%s-%s" % (package, depPack)
            name1 = "%s-%s" % (depPack, package)
            if name not in dependentList and name1 not in dependentList:
                dependentList.add(name)
    print ("Total # items is %d" % len(dependentList))
    print (sorted(dependentList))
def printAllPercentageRoutines(crossReference):
    allRoutines=crossReference.getAllPercentageRoutine()
    sortedRoutine=sorted(allRoutines)
    index=0
    print ("Total # of percentage routines: %d" % len(allRoutines))
    for routineName in sortedRoutine:
        sys.stdout.write(" %s " % routineName)
        if (index+1) % 10 == 0:
            sys.stdout.write ("\n")
        index+=1
    sys.stdout.write("\n")
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA Routine information Finder')
    parser.add_argument('-l', required=True, dest='logFileDir',
                        help='Input XINDEX log files directory generated by CTest, nomally under'
                             'CMAKE_BUILD_DIR/Docs/CallerGraph/')
    parser.add_argument('-r', required=True, dest='repositDir',
                        help='VistA Git Repository Directory')

    result = vars(parser.parse_args());
    logParser = CallerGraphParser.CallerGraphLogFileParser()
    print "Starting parsing package/routine...."
    print "Time is: %s" % datetime.now()
    logParser.parsePackageFile("C:/users/jason.li/git/VistA-FOIA/Packages.csv")
    logParser.findGlobalsBySource("C:/users/jason.li/git/VistA-FOIA/Packages/", "*/Globals/*.zwr")
    routineFilePattern = "*/Routines/*.m"
    routineFileDir = os.path.join(result['repositDir'], "Packages")
    logParser.findPackagesAndRoutinesBySource(routineFileDir, routineFilePattern)
    print "End parsing package/routine...."
    print "Time is: %s" % datetime.now()
    print "Starting parsing caller graph log file...."
    callLogPattern="*.log"
    logParser.parseAllCallerGraphLog(result['logFileDir'], callLogPattern)
    orphanRoutines=sorted(logParser.getCrossReference().getOrphanRoutines())
    print "End of parsing log file......"
    print "Time is: %s" % datetime.now()
    # read the user input from the terminal
    isExit=False
    print "Please enter quit to exit"
    print "please enter orphan_routine to print orphan routines"
    print "please enter max_call to print routines with max caller and max called routines"
    print "please enter max_dep to print packages with max dependencies and max dependents"
    print "please enter gen_allpack to generate all packages dependency list"
    print "please enter all_percentage to print all routines start with %"
    while not isExit:
        var = raw_input("Please enter the routine Name or package Name:")
        if (var == 'quit'):
            isExit=True
            continue
        if (var=='orphan_routine'):
            for routine in orphanRoutines:
                print routine
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
        if var == "all_percentage":
            printAllPercentageRoutines(logParser.getCrossReference())
        result=routineName.search(var)
        if result:
            logParser.printRoutine(result.group('name'))
            continue
        result=packageName.search(var)
        if result:
            logParser.printPackage(result.group('name').strip())
            continue
        result=globalName.search(var)
        if result:
            logParser.printGlobal(result.group('name').strip())
            continue
