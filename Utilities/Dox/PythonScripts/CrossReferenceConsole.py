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
import re
import sys
from datetime import datetime, date, time
import csv
from LogManager import logger, initConsoleLogging
import logging
from CrossReferenceBuilder import CrossReferenceBuilder
from CrossReferenceBuilder import createCrossReferenceLogArgumentParser

routineName = re.compile("^R:(?P<name>[^ ]+)")
packageName = re.compile("^P:(?P<name>.*)")
globalName = re.compile("^G:(?P<name>.*)")

#===============================================================================
# interface to generated the output based on a routine, global, package
#===============================================================================
class RoutineVisit:
    def visitRoutine(self, routine, outputDir=None):
        pass

class PackageVisit:
    def visitPackage(self, package, outputDir=None):
        pass
#===============================================================================
# Default implementation of the routine Visit
#===============================================================================
class DefaultRoutineVisit(RoutineVisit):
    def visitRoutine(self, routine, outputDir=None):
        routine.printResult()

#===============================================================================
#
#===============================================================================
class GraphvizPackageDependencyVisit(PackageVisit):
    def visitPackage(self, package, outputDir):
        generatePackageDependencyGraph(package, outputDir, True)
#===============================================================================
#
#===============================================================================
class GraphvizPackageDependentVisit(PackageVisit):
    def visitPackage(self, package, outputDir):
        generatePackageDependencyGraph(package, outputDir, False)
#===============================================================================
#
#===============================================================================
class CplusRoutineVisit(RoutineVisit):
    def visitRoutine(self, routine, outputDir):
        calledRoutines = routine.getCalledRoutines()
        if not calledRoutines or len(calledRoutines) == 0:
            logger.warn("No called Routines found! for package:%s" % routineName)
            return
        routineName = routine.getName()
        if not routine.getPackage():
            logger.error("ERROR: package: %s does not belongs to a package" % routineName)
            return

        packageName = routine.getPackage().getName()
        try:
            dirName = os.path.join(outputDir, packageName)
            if not os.path.exists(dirName):
                os.makedirs(dirName)
        except OSError, e:
            logger.error("Error making dir %s : Error: %s" % (dirName, e))
            return

        outputFile = open(os.path.join(dirName, routineName), 'w')
        outputFile.write(("/*! \\namespace %s \n") % (packageName))
        outputFile.write("*/\n")
        outputFile.write("namespace %s {" % packageName)

        outputFile.write("/* Global Vars: */\n")
        for var in routine.getGlobalVariables():
            outputFile.write(" int %s;\n" % var)
        outputFile.write("\n")
        outputFile.write("/* Naked Globals: */\n")
        for var in routine.getNakeGlobals:
            outputFile.write(" int %s;\n" % var)
        outputFile.write("\n")
        outputFile.write("/* Marked Items: */\n")
        for var in routine.getMarkedItems():
            outputFile.write(" int %s;\n" % var)
        outputFile.write("\n")
        outputFile.write("/*! \callgraph\n")
        outputFile.write("*/\n")
        outputFile.write ("void " + self.name + "(){\n")

        outputFile.write("/* Local Vars: */\n")
        for var in routine.getLocalVariables():
            outputFile.write(" int %s; \n" % var)


        outputFile.write("/* Called Routines: */\n")
        for var in calledRoutines:
            outputFile.write("  %s ();\n" % var)
        outputFile.write("}\n")
        outputFile.write("}// end of namespace")
        outputFile.close()
#===============================================================================
# Default implementation of the package Visit
#===============================================================================
class DefaultPackageVisit(PackageVisit):
    def visitPackage(self, package, outputDir=None):
        package.printResult()

def printRoutine(crossRef, routineName, visitor=DefaultRoutineVisit()):
    routine = crossRef.getRoutineByName(routineName)
    if routine:
        visitor.visitRoutine(routine)
    else:
        logger.error ("Routine: %s Not Found!" % routineName)

def printPackage(crossRef, packageName, visitor=DefaultPackageVisit()):
    package = crossRef.getPackageByName(packageName)
    if package:
        visitor.visitPackage(package)
    else:
        logger.error ("Package: %s Not Found!" % packageName)

def printGlobal(crossRef, globalName, visitor=None):
    globalVar = crossRef.getGlobalByName(globalName)
    if globalVar:
        if visitor:
            visitor.visitGlobal(globalVar)
        else:
            globalVar.printResult()
    else:
        logger.error ("Global: %s Not Found!" % globalName)

def findRoutinesWithMostOfCallers(crossRef):
    maxCallerRoutine = None
    maxCalledRoutine = None
    for routine in crossRef.getAllRoutines().itervalues():
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

def findPackagesWithMostOfDependency(crossRef):
    maxPackageDependency = None
    maxPackageDependent = None
    for package in crossRef.getAllPackages().itervalues():
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
def printOrphanGlobals(crossRef):
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

if __name__ == '__main__':
    crossRefArgParse = createCrossReferenceLogArgumentParser()
    parser = argparse.ArgumentParser(
                description='VistA Cross-Reference information Console',
                parents=[crossRefArgParse])
    result = parser.parse_args();
    print result
    initConsoleLogging()
    crossRef = CrossReferenceBuilder().buildCrossReferenceWithArgs(result)
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
            findRoutinesWithMostOfCallers(crossRef)
            continue
        if var == "max_dep":
            findPackagesWithMostOfDependency(crossRef)
            continue
        if var == "gen_allpack":
            generateAllPackageDependencyList(crossRef.getAllPackages())
            continue
        if var == "all_percent":
            printAllPercentRoutines(crossRef)
            continue
        if var == "help":
            printUsage()
            continue
        result = routineName.search(var)
        if result:
            printRoutine(crossRef, result.group('name'))
            continue
        result = packageName.search(var)
        if result:
            printPackage(crossRef, result.group('name').strip())
            continue
        result = globalName.search(var)
        if result:
            printGlobal(crossRef, result.group('name').strip())
            continue
