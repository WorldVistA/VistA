#!/usr/bin/env python

# A logFileParser class to parse XINDEX log files and generate the routine/package information in CrossReference Structure
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

import glob
import re
import os
import os.path
import sys
import subprocess
import re
import csv
import argparse

from datetime import datetime, date, time
from CrossReference import CrossReference, Routine, Package, Global, PlatformDependentGenericRoutine
from CrossReference import LocalVariable, GlobalVariable, NakedGlobal, MarkedItem
from CrossReference import RoutineCallDict, RoutineCallerInfo, UNKNOWN_PACKAGE

from LogManager import logger

#Routines starts with A followed by a number
ARoutineEx = re.compile("^A[0-9][^ ]+$")

nameValuePair = re.compile("(?P<prefix>^(>> |   ))(?P<name>[^ \"]+(\".*\")?) +(?P<value>[^ *!~]+)(?P<cond>[*!~]*),?")
LongName = re.compile("^(>> |   )[^ ]+(\".*\")? $")
RoutineStart = re.compile("^Routine: (?P<name>[^ ]+)$")
localVarStart = re.compile("^Local Variables +Routines")
globalVarStart = re.compile("^Global Variables")
nakedGlobalStart = re.compile("^Naked Globals")
markedItemStart = re.compile("^Marked Items")
routineInvokesStart = re.compile('Routine +Invokes')
calledRoutineStart = re.compile("^Routine +is Invoked by:")
RoutineEnd = re.compile("-+ END -+")
pressReturn = re.compile("Press return to continue:")
routineTag = re.compile("(\$\$)?(?P<tag>[^$^]*)\^?(?P<name>.*)")

# some dicts for easy lookup
packageNameMismatchDict = {"NOIS TRACKING":"NATIONAL ONLINE INFORMATION SHARING",
                         "HEALTH DATE & INFORMATICS":"HEALTH DATA & INFORMATICS",
                         "CM TOOLS":"CAPACITY MANAGEMENT TOOLS",
                         "HIPPA":"E CLAIMS MGMT ENGINE",
                         "WOUNDED INJURED & ILL":"WOUNDED INJURED & ILL WARRIORS",
                         "VISTA DATA EXTRACTION":"VDEF",
                         "VISTA LINK":"VISTALINK",
                         "BLOOD BANK":"VBECS"}
fileNoPackageMappingDict = {"18.02":"Web Services Client",
                   "18.12":"Web Services Client",
                   "18.13":"Web Services Client",
                   "52.87":"Outpatient Pharmacy",
                   "59.73":"Pharmacy Data Management",
                   "59.74":"Pharmacy Data Management"
                   }

#===============================================================================
# Interface to parse a section of the XINDEX log file
#===============================================================================
class AbstractSectionParse:
    def parseLine(self, line, crossReference):
        pass
    def setRoutine(self, routine):
        pass

#===============================================================================
# Implementation of a section _sectionParser to parse the local variables part
#===============================================================================
class LocalVarSectionParse (AbstractSectionParse):
    def __init__(self):
        self.routine = None
    def parseLine(self, line, crossReference):
        result = nameValuePair.search(line)
        if (result):
            self.routine.addLocalVariables(LocalVariable(result.group('name'),
                                                         result.group('prefix'),
                                                         result.group('cond')))
    def setRoutine(self, routine):
        self.routine = routine

#===============================================================================
# Implementation of a section logFileParser to parse the Global variables part
#===============================================================================
class GlobalVarSectionParse (AbstractSectionParse):
    def __init__(self):
        self.routine = None
    def parseLine(self, line, crossRef):
        result = nameValuePair.search(line)
        if (result):
            globalName = result.group('name')
            self.routine.addGlobalVariables(GlobalVariable(globalName,
                                                           result.group('prefix'),
                                                           result.group('cond')))
            globalVar = crossRef.getGlobalByName(globalName)
            if globalVar:
                routineName = self.routine.getName()
                # case to handle the platform dependent routines
                if crossRef.isPlatformDependentRoutineByName(routineName):
                    genericRoutine = crossRef.getGenericPlatformDepRoutineByName(routineName)
                    assert genericRoutine
                    globalVar.addReferencedRoutine(genericRoutine)
                    genericRoutine.addReferredGlobal(globalVar)
                else:
                    globalVar.addReferencedRoutine(self.routine)
                self.routine.addReferredGlobal(globalVar)
            else:
                crossRef.addToOrphanGlobalByName(globalName)
    def setRoutine(self, routine):
        self.routine = routine

#===============================================================================
# Implementation of a section logFileParser to parse the Naked Globals part
#===============================================================================
class NakedGlobalsSectionParser (AbstractSectionParse):
    def __init__(self):
        self.routine = None
    def parseLine(self, line, crossReference):
        result = nameValuePair.search(line)
        if (result):
            self.routine.addNakedGlobals(NakedGlobal(result.group('name'),
                                                     result.group('prefix'),
                                                     result.group('cond')))
    def setRoutine(self, routine):
        self.routine = routine

#===============================================================================
# Implementation of a section logFileParser to parse the Marked Items part
#===============================================================================
class MarkedItemsSectionParser (AbstractSectionParse):
    def __init__(self):
        self.routine = None
    def parseLine(self, line, crossReference):
        result = nameValuePair.search(line)
        if (result):
            self.routine.addMarkedItems(MarkedItem(result.group('name'),
                                                   result.group('prefix'),
                                                   result.group('cond')))
    def setRoutine(self, routine):
        self.routine = routine

#===============================================================================
# Implementation of a section logFileParser to parse the Called Routine parts
#===============================================================================
class CalledRoutineSectionParser (AbstractSectionParse):
    def __init__(self):
        self.routine = None
    def parseLine(self, line, crossRef):
        result = nameValuePair.search(line)
        if (result):
            routineDetail = routineTag.search(result.group('name').strip())
            if routineDetail:
                routineName = routineDetail.group('name')
                if (routineName.startswith("%")):
                   crossRef.addPercentRoutine(routineName)
                   # ignore mumps routine for now
                   if crossRef.isMumpsRoutine(routineName):
                       return
#                   routineName=routineName[1:]
                if crossRef.routineNeedRename(routineName):
                    routineName = crossRef.getRenamedRoutineName(routineName)
                tag = routineDetail.group('tag')
                if not crossRef.hasRoutine(routineName):
                    # automatically categorize the routine by the namespace
                    # if could not find one, assign to Uncategorized
                    defaultPackageName = "Uncategorized"
                    (namespace, package) = crossRef.categorizeRoutineByNamespace(routineName)
                    if namespace and package:
                        defaultPackageName = package.getName()
                    crossRef.addRoutineToPackageByName(routineName, defaultPackageName, False)
                routine = crossRef.getRoutineByName(routineName)
                self.routine.addCalledRoutines(routine, tag)
    def setRoutine(self, routine):
        self.routine = routine

#===============================================================================
# Global instance of section logFileParser
#===============================================================================
localVarParser = LocalVarSectionParse()
globalVarParser = GlobalVarSectionParse()
nakedGlobalParser = NakedGlobalsSectionParser()
markedItemsParser = MarkedItemsSectionParser()
calledRoutineParser = CalledRoutineSectionParser()

#===============================================================================
# interface to generated the output based on a routine
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
# Default implementation of the package Visit
#===============================================================================
class DefaultPackageVisit(PackageVisit):
    def visitPackage(self, package, outputDir=None):
        package.printResult()

#===============================================================================
# A class to parse XINDEX log file output and convert to Routine/Package
#===============================================================================
class CallerGraphLogFileParser:
    def __init__(self):
        self._crossReference = CrossReference()
        self._currentRoutine = None
        self._sectionParser = None

    def onNewRoutineStart(self, routineName):
        if self._crossReference.isPlatformDependentRoutineByName(routineName):
            self._currentRoutine = self._crossReference.getPlatformDependentRoutineByName(routineName)
            return
        renamedRoutineName = routineName
        if self._crossReference.routineNeedRename(routineName):
            renamedRoutineName = self._crossReference.getRenamedRoutineName(routineName)
        if not self._crossReference.hasRoutine(renamedRoutineName):
            logger.error("Invalid Routine: %s: rename Routine %s" %
                         (routineName, renamedRoutineName))
            return
        self._currentRoutine = self._crossReference.getRoutineByName(renamedRoutineName)

    def onNewRoutineEnd(self, routineName):
        self._currentRoutine = None
        self._sectionParser = None
    def onLocalVariablesStart(self, line):
        self._sectionParser = localVarParser
        self._sectionParser.setRoutine(self._currentRoutine)
    def onGlobaleVariables(self, line):
        self._sectionParser = globalVarParser
        self._sectionParser.setRoutine(self._currentRoutine)
    def onCalledRoutines(self, line):
        self._sectionParser = calledRoutineParser
        self._sectionParser.setRoutine(self._currentRoutine)
    def onNakedGlobals(self, line):
        self._sectionParser = nakedGlobalParser
        self._sectionParser.setRoutine(self._currentRoutine)
    def onMarkedItems(self, line):
        self._sectionParser = markedItemsParser
        self._sectionParser.setRoutine(self._currentRoutine)
    def onRoutineInvokes(self, line):
        self._sectionParser = None
    def parseNameValuePair(self, line):
        if self._sectionParser:
            self._sectionParser.parseLine(line, self._crossReference)
    def printResult(self):
        logger.info("Total Routines are %d" % len(self._crossReference.getAllRoutines()))

    def printRoutine(self, routineName, visitor=DefaultRoutineVisit()):
        routine = self._crossReference.getRoutineByName(routineName)
        if routine:
            visitor.visitRoutine(routine)
        else:
            logger.error ("Routine: %s Not Found!" % routineName)

    def printPackage(self, packageName, visitor=DefaultPackageVisit()):
        package = self._crossReference.getPackageByName(packageName)
        if package:
            visitor.visitPackage(package)
        else:
            logger.error ("Package: %s Not Found!" % packageName)
    def printGlobal(self, globalName, visitor=None):
        globalVar = self._crossReference.getGlobalByName(globalName)
        if globalVar:
            if visitor:
                visitor.visitGlobal(globalVar)
            else:
                globalVar.printResult()
        else:
            logger.error ("Global: %s Not Found!" % globalName)
    def getCrossReference(self):
        return self._crossReference
    def getAllRoutines(self):
        return self._crossReference.getAllRoutines()
    def getAllPackages(self):
        return self._crossReference.getAllPackages()
    def getAllGlobals(self):
        return self._crossReference.getAllGlobals()
    def outputPackageCSVFile(self, outputFile):
        output = csv.writer(open(outputFile, 'w'), lineterminator='\n')
        allPackages = self._crossReference.getAllPackages()
        sortedPackage = sorted(allPackages.keys(),
                             key=lambda item: allPackages[item].getOriginalName())
        for packageName in sortedPackage:
            package = allPackages[packageName]
            namespaceList = package.getNamespaces()
            globalnamespaceList = package.getGlobalNamespace()
            globals = package.getAllGlobals()
            globalList = sorted(globals.values(),
                              key=lambda item: float(item.getFileNo()))
            maxRows = max(len(namespaceList),
                        len(globalnamespaceList),
                        len(globals))
            if maxRows == 0:
                continue
            for index in range(maxRows):
                if len(namespaceList) > index:
                    namespace = namespaceList[index]
                else:
                    namespace = ""
                if len(globalnamespaceList) > index:
                    globalNamespace = globalnamespaceList[index]
                else:
                    globalNamespace = ""
                if len(globals) > index:
                    globalFileNo = globalList[index].getFileNo()
                    globalDes = globalList[index].getDescription()
                else:
                    globalFileNo = ""
                    globalDes = ""
                if index == 0:
                    output.writerow([package.getOriginalName(),
                                     package.getName(),
                                     namespace,
                                     globalFileNo,
                                     globalDes,
                                     globalNamespace])
                else:
                    output.writerow(["",
                                     "",
                                     namespace,
                                     globalFileNo,
                                     globalDes,
                                     globalNamespace])
    #===========================================================================
    # pass the log file and get all routines ready
    #===========================================================================
    def parseAllCallerGraphLog(self, dirName, pattern):
        callerGraphLogFile = os.path.join(dirName, pattern)
        allFiles = glob.glob(callerGraphLogFile)
        for logFile in allFiles:
            file = open(logFile, 'r')
            logger.info("Parsing log file [%s]" % logFile)
            prevLine = ""
            for line in file:
                #strip the newline
                line = line.rstrip(os.linesep)
                #skip the empty line
                if (line.strip() == ''):
                    prevLine = ""
                    continue
                if (pressReturn.search(line)):
                    prevLine = ""
                    continue
                result = RoutineStart.search(line)
                if result:
                    routineName = result.group('name')
                    self.onNewRoutineStart(routineName)
                    prevLine = ""
                    continue
                if localVarStart.search(line):
                    self.onLocalVariablesStart(line)
                    prevLine = ""
                    continue
                if globalVarStart.search(line):
                    self.onGlobaleVariables(line)
                    prevLine = ""
                    continue
                if nakedGlobalStart.search(line):
                    self.onNakedGlobals(line)
                    prevLine = ""
                    continue
                if markedItemStart.search(line):
                    self.onMarkedItems(line)
                    prevLine = ""
                    continue
                if calledRoutineStart.search(line):
                    self.onCalledRoutines(line)
                    prevLine = ""
                    continue
                if RoutineEnd.search(line):
                    self.onNewRoutineEnd(routineName)
                    prevLine = ""
                    continue
                if routineInvokesStart.search(line):
                    self.onRoutineInvokes(line)
                    prevLine = ""
                    continue
                result = None
                result = nameValuePair.search(line)
                if result:
                    prevLine = ""
                    self.parseNameValuePair(line)
                    continue
                if (len(prevLine) > 0 and self._currentRoutine and line.find(self._currentRoutine.getName()) != -1):
                    self.parseNameValuePair(prevLine + line)
                    prevLine = ""
                    continue
                result = None
                result = LongName.search(line)
                if result:
                    prevLine = line
                    continue
                prevLine = ""
            file.close()

        # generate package direct dependency based on XINDEX call graph
        self._crossReference.generateAllPackageDependencies()
    #===========================================================================
    # find all the package name and routines by reading the repository directory
    #===========================================================================
    def findPackagesAndRoutinesBySource(self, dirName, pattern):
        searchFiles = glob.glob(os.path.join(dirName, pattern))
        logger.info("Total Search Files are %d " % len(searchFiles))
        allRoutines = self._crossReference.getAllRoutines()
        allPackages = self._crossReference.getAllPackages()
        crossReference = self._crossReference
        for file in searchFiles:
            routineName = os.path.basename(file).split(".")[0]
            needRename = crossReference.routineNeedRename(routineName)
            if needRename:
                origName = routineName
                routineName = crossReference.getRenamedRoutineName(routineName)
            if crossReference.isPlatformDependentRoutineByName(routineName):
                continue
            packageName = os.path.dirname(file)
            packageName = packageName[packageName.index("Packages") + 9:packageName.index("Routines") - 1]
            crossReference.addRoutineToPackageByName(routineName, packageName)
            if needRename:
                routine = crossReference.getRoutineByName(routineName)
                assert(routine)
                routine.setOriginalName(origName)
            if ARoutineEx.search(routineName):
                logger.debug("A Routines %s should be exempted" % routineName)
                pass
        crossReference.addPackageByName(UNKNOWN_PACKAGE)
        logger.info("Total package is %d and Total Routines are %d" %
                    (len(allPackages), len(allRoutines)))
#===============================================================================
# Find all globals by source zwr and package.csv files version v2
#===============================================================================
    def findGlobalsBySourceV2(self, dirName, pattern):
        searchFiles = glob.glob(os.path.join(dirName, pattern))
        logger.info("Total Search Files are %d " % len(searchFiles))
        crossReference = self._crossReference
        allGlobals = crossReference.getAllGlobals()
        allPackages = crossReference.getAllPackages()
        skipFile = []
        fileNoSet = set()
        for file in searchFiles:
            packageName = os.path.dirname(file)
            packageName = packageName[packageName.index("Packages") + 9:packageName.index("Globals") - 1]
            if not crossReference.hasPackage(packageName):
                logger.info ("Package: %s is new" % packageName)
                crossReference.addPackageByName(packageName)
            package = allPackages.get(packageName)
            zwrFile = open(file, 'r')
            lineNo = 0
            fileName = os.path.basename(file)
            result = re.search("(?P<fileNo>^[0-9.]+)\+(?P<des>.*)\.zwr$", fileName)
            if result:
                fileNo = result.group('fileNo')
                globalDes = result.group('des')
            else:
                result = re.search("(?P<namespace>^[^.]+)\.zwr$", fileName)
                if result:
                    namespace = result.group('namespace')
#                    package.addGlobalNamespace(namespace)
                    continue
            globalName = "" # find out the global name by parsing the global file
            logger.debug ("Parsing file: %s" % file)
            for line in zwrFile:
                if lineNo == 0:
                    globalDes = line.strip()
                    if globalDes.startswith("^"):
                        logger.info ("No Description: Skip this file: %s" % file)
                        skipFile.append(file)
                        namespace = globalDes[1:]
                        package.addGlobalNamespace(namespace)
                        break
                if lineNo == 1:
                    assert line.strip() == 'ZWR'
                if lineNo >= 2:
                    info = line.strip().split('=')
                    globalName = info[0]
                    detail = info[1].strip("\"")
                    if globalName.find(',') > 0:
                        result = globalName.split(',')
                        if len(result) == 2 and result[1] == "0)":
                            globalName = result[0]
                            break
                    elif globalName.endswith("(0)"):
                        globalName = globalName.split('(')[0]
                        break
                    else:
                        continue
                lineNo = lineNo + 1
            logger.debug ("globalName: %s, Des: %s, fileNo: %s, package: %s" %
                          (globalName, globalDes, fileNo, packageName))
            if len(fileNo) == 0:
                if file not in skipFile:
                    logger.warn ("Warning: No FileNo found for file %s" % file)
                continue
            globalVar = Global(globalName, globalDes,
                               allPackages.get(packageName), fileNo)
            try:
                fileNum = float(globalVar.getFileNo())
            except ValueError, es:
                logger.error ("error: %s, globalVar:%s file %s" % (es, globalVar, file))
                continue
#            crossReference.addGlobalToPackage(globalVar, packageName)
            # only add to allGlobals dict as we have to change the package later on
            if globalVar.getName() not in allGlobals:
                allGlobals[globalVar.getName()] = globalVar
            if fileNo not in fileNoSet:
                fileNoSet.add(fileNo)
            else:
                logger.error ("Error, duplicated file No [%s,%s,%s,%s] file:%s " %
                       (fileNo, globalName, globalDes, packageName, file))
        zwrFile.close()
        logger.info ("Total # of Packages is %d and Total # of Globals is %d, Total Skip File %d, total FileNo is %d" %
               (len(allPackages), len(allGlobals), len(skipFile), len(fileNoSet)))

        sortedKeyList = sorted(allGlobals.keys(),
                             key=lambda item: float(allGlobals[item].getFileNo()))
#        outputWriter=csv.writer(open("c:/users/jason.li/Downloads/docs/GlobalMappingGit.csv",'w'),)
        for key in sortedKeyList:
            globalVar = allGlobals[key]
            # fix the uncategoried item
            if globalVar.getFileNo() in fileNoPackageMappingDict:
                globalVar.setPackage(allPackages[fileNoPackageMappingDict[globalVar.getFileNo()]])
            crossReference.addGlobalToPackage(globalVar,
                                              globalVar.getPackage().getName())

# Find all globals by source zwr and package.csv files version v1
#===============================================================================
    def findGlobalsBySourceV1(self, dirName, pattern, correctionFileName=None, outputFile=None):
        searchFiles = glob.glob(os.path.join(dirName, pattern))
        logger.info ("Total Search Files are %d " % len(searchFiles))
        crossReference = self._crossReference
        allGlobals = crossReference.getAllGlobals()
        allPackages = crossReference.getAllPackages()
        skipFile = []
        fileNoSet = set()
        for file in searchFiles:
            packageName = os.path.dirname(file)
            packageName = packageName[packageName.index("Packages") + 9:packageName.index("Globals") - 1]
            if not crossReference.hasPackage(packageName):
                logger.info ("Package: %s is new" % packageName)
                crossReference.addPackageByName(packageName)
            zwrFile = open(file, 'r')
            lineNo = 0
            globalDes = ""
            fileNo = "" #os.path.basename(p)
            globalName = ""
#            print ("Parsing file: %s" % file)
            for line in zwrFile:
                if lineNo == 0:
                    globalDes = line.strip()
                    if globalDes.startswith("^"):
#                        print ("No Description: Skip this file: %s" % file)
                        skipFile.append(file)
                        break
                if lineNo == 1:
                    assert line.strip() == 'ZWR'
                if lineNo >= 2:
                    info = line.strip().split('=')
                    globalName = info[0]
                    detail = info[1].strip("\"")
                    if globalName.find(',') > 0:
                        result = globalName.split(',')
                        if len(result) == 2 and result[1] == "0)":
                            globalName = result[0]
                            if globalName.find("(") > 0:
                                fileNo = globalName.split('(')[1]
                                result = re.search("(?P<name>([0-9]|\.)+).*", fileNo)
                                if result:
                                    fileNo = result.group('name')
                                else:
                                    fileNo = ""
                                if detail.find(fileNo) < 0:
#                                    print "Could not find fileNo in %s file: %s" % (line, file)
                                    fileNo = ""
                    elif globalName.endswith("(0)"):
                        globalName = globalName.split('(')[0]
                    else:
                        continue
                    if detail.find('^') >= 0:
                        items = detail.split('^')
                        items[0] = items[0].strip()
                        if (items[0] == globalDes
                            or globalDes.find(items[0]) > 0
                            or items[0].find(globalDes) > 0):
                            fileNoNew = detail.split('^')[1]
                            result = re.search("(?P<name>([0-9]|\.)+).*", fileNoNew)
                            if result:
    #                            print result.groups()
                                fileNoNew = result.group('name')
                                if len(fileNo) == 0:
                                    fileNo = fileNoNew
                                if float(fileNoNew) != float(fileNo):
#                                    print ("Warning: File# mismatch [name:%s]:[value:%s]" % (fileNo, fileNoNew))
                                    if float(fileNoNew) != 0.21: # hack to .21 mismatch
                                        fileNo = fileNoNew
                                break
                lineNo = lineNo + 1
#            print ("globalName: %s, Des: %s, fileNo: %s, package: %s" %
#                   (globalName, globalDes, fileNo, packageName))
            if len(fileNo) == 0:
                if file not in skipFile:
                    logger.warn ("Warning: No FileNo found for file %s" % file)
                continue
            globalVar = Global(globalName, globalDes,
                               allPackages.get(packageName), fileNo)
            try:
                fileNum = float(globalVar.getFileNo())
            except ValueError, es:
                logger.warn ("error: %s, globalVar:%s file %s" % (es, globalVar, file))
                continue
#            crossReference.addGlobalToPackage(globalVar, packageName)
            # only add to allGlobals dict as we have to change the package later on
            if globalVar.getName() not in allGlobals:
                allGlobals[globalVar.getName()] = globalVar
            if fileNo not in fileNoSet:
                fileNoSet.add(fileNo)
            else:
                logger.warn ("Error, duplicated file No [%s,%s,%s,%s] file:%s " %
                       (fileNo, globalName, globalDes, packageName, file))
        zwrFile.close()
        logger.info ("Total # of Packages is %d and Total # of Globals is %d, Total Skip File %d, total FileNo is %d" %
               (len(allPackages), len(allGlobals), len(skipFile), len(fileNoSet)))
        if correctionFileName:
            mappingCorrectionFile = open(correctionFileName, 'rb')
            if outputFile:
                mappingNewFile = csv.writer(open(outputFile, 'w'))
            result = csv.reader(mappingCorrectionFile)
            for line in result:
    #            line[-1] is the original package name, replace with the new one
                line[-1] = line[-1].upper()
                if line[-1] in packageNameMismatchDict:
                    line[-1] = packageNameMismatchDict[line[-1]]
                # line[2] is the globalVar name
                line[2] = line[2].strip()
                line[2] = line[2].rstrip(", ")
                if line[2].endswith('('):
                    line[2] = line[2].rstrip("(")
                globalVar = allGlobals.get(line[2])
                if not globalVar:
                    for glbVar in allGlobals.itervalues():
                        if line[0] == glbVar.getFileNo():
                            if glbVar.getName().find(line[2]) >= 0:
                                globalVar = glbVar
                                line[2] = glbVar.getName()
                                break
                            else:
                                logger.warn ("Global Name mismatch: %s, %s" % (line[2], glbVar))
                if globalVar:
                    if globalVar.getFileNo() != line[0]:
                        if float(globalVar.getFileNo()) != float(line[0]):
                            logger.warn ("Diff in file No. [%s],  [%s, %s, %s]" %
                                   (line, globalVar, globalVar.getFileNo(), globalVar.getPackage()))
                            # fix the file #
                            if globalVar.getName().find(globalVar.getFileNo()) < 0:
                                globalVar.setFileNo(line[0])
                        else:
                            line[0] = globalVar.getFileNo()
                    if (globalVar.getDescription() != line[1] and
                        globalVar.getFileNo() == line[0]):
                            logger.warn ("Diff in Description [%s], [%s]" % (globalVar.getDescription(), line[1]))
    #                        fix the description part (name)
                            line[1] = globalVar.getDescription()
                    if (globalVar.getPackage().getName() != line[-1] and
                        globalVar.getPackage().getOriginalName() != line[-1]):
                        logger.warn("Diff in package name [%s], [%s]" %
                                    (line[-1], globalVar.getPackage().getOriginalName()))
                        for package in self._crossReference.getAllPackages().itervalues():
                            if package.getOriginalName() == line[-1]:
                                oldPackage = globalVar.getPackage()
                                globalVar.setPackage(package)
                                break
                else:
                    print line
                if outputFile:
                    mappingNewFile.writerow(line)
        #sort the globals by the file #
        sortedKeyList = sorted(allGlobals.keys(),
                             key=lambda item: float(allGlobals[item].getFileNo()))
#        outputWriter=csv.writer(open("c:/users/jason.li/Downloads/docs/GlobalMappingGit.csv",'w'),)
        for key in sortedKeyList:
            globalVar = allGlobals[key]
            # fix the uncategoried item
            if globalVar.getFileNo() in fileNoPackageMappingDict:
                globalVar.setPackage(allPackages[fileNoPackageMappingDict[globalVar.getFileNo()]])
            crossReference.addGlobalToPackage(globalVar,
                                              globalVar.getPackage().getName())
#            outputWriter.writerow([globalVar.getFileNo(),
#                                   globalVar.getDescription(),
#                                   globalVar.getName(),
#                                   globalVar.getPackage().getOriginalName()])
    def parsePackagesFile(self, packageFilename):
        packageFile = open(packageFilename, 'rb')
        sniffer = csv.Sniffer()
        dialect = sniffer.sniff(packageFile.read(1024))
        packageFile.seek(0)
        hasHeader = sniffer.has_header(packageFile.read(1024))
        packageFile.seek(0)
        result = csv.reader(packageFile, dialect)
        crossRef = self._crossReference
        # in the format of original name, primary namespace, additional namespace, addition globals, directory name
        currentPackage = None
        index = 0
        for line in result:
            if index == 0 and hasHeader:
                index += 1
                continue
            if len(line[1].strip()) > 0:
                currentPackage = crossRef.getPackageByName(line[1])
                if not currentPackage:
                    logger.debug ("Package [%s] not found" % line[1])
                    crossRef.addPackageByName(line[1])
                currentPackage = crossRef.getPackageByName(line[1])
                currentPackage.setOriginalName(line[0])
            else:
                if not currentPackage:
                    logger.warn ("line is not under any package: %s" % line)
                    continue
            if len(line[2]):
                currentPackage.addNamespace(line[2])
            if len(line[-1]):
                currentPackage.addGlobalNamespace(line[-1])
        logger.info ("Total # of Packages is %d" % (len(crossRef.getAllPackages())))
    def parsePercentRoutineMappingFile(self, mappingFile):
        csvReader = csv.reader(open(mappingFile, "rb"))
        for line in csvReader:
            self._crossReference.addPercentRoutineMapping(line[0], line[1], line[2])
    def parsePackageDocumentationLink(self, linkFile):
        packageFile = open(linkFile, 'rb')
        sniffer = csv.Sniffer()
        dialect = sniffer.sniff(packageFile.read(1024))
        packageFile.seek(0)
        hasHeader = sniffer.has_header(packageFile.read(1024))
        packageFile.seek(0)
        result = csv.reader(packageFile, dialect)
        index = 0
        crossRef = self._crossReference
        for line in result:
            if hasHeader and index == 0:
                index += 1
                continue
            packageName = line[0].strip()
            package = crossRef.getPackageByName(packageName)
            if not package:
                logger.error("Error: package: %s not found!" % packageName)
            else:
                if len(line) >= 5:
                    package.setDocLink(line[4].strip())
                if len(line) >= 6:
                    package.setMirrorLink(line[5].strip())
    def parsePlatformDependentRoutineFile(self, routineCSVFile):
        routineFile = open(routineCSVFile, "rb")
        sniffer = csv.Sniffer()
        dialect = sniffer.sniff(routineFile.read(1024))
        routineFile.seek(0)
        hasHeader = sniffer.has_header(routineFile.read(1024))
        routineFile.seek(0)
        result = csv.reader(routineFile, dialect)
        currentName = ""
        routineDict = dict()
        crossRef = self._crossReference
        index = 0
        for line in result:
            if hasHeader and index == 0:
                index += 1
                continue
            if len(line[0]) > 0:
                currentName = line[0]
                if line[0] not in routineDict:
                    routineDict[currentName] = []
                routineDict[currentName].append(line[-1])
            routineDict[currentName].append([line[1], line[2]])
        for (routineName, mappingList) in routineDict.iteritems():
            crossRef.addPlatformDependentRoutineMapping(routineName,
                                                        mappingList[0],
                                                        mappingList[1:])
    def printAllNamespaces(self):
        crossRef = self._crossReference
        allPackages = crossRef.getAllPackages()
        namespaces = set()
        excludeNamespace = set()
        for package in allPackages.itervalues():
            for namespace in package.getNamespaces():
                if (namespace.startswith("!")):
                    excludeNamespace.add(namespace)
                else:
                    namespaces.add(namespace)
        sortedSet = sorted(namespaces)
        sortedExclude = sorted(excludeNamespace)
        logger.info("Total # of namespace: %d" % len(sortedSet))
        logger.info("Total # of excluded namespaces: %d" % len(sortedExclude))
        logger.info(sortedSet)
        logger.info(sortedExclude)
        for item in excludeNamespace:
            if item[1:] not in sortedSet:
                logger.warn("item: %s not in the namespace set" % item[1:])
    def getRoutineNameSpace(self, routineName):
        return self._crossReference.categorizeRoutineByNamespace(routineName)
# end of class CallerGraphLogFileParser

import logging
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA Cross-Reference Log Files Parser')
    parser.add_argument('-l', required=True, dest='logFileDir',
                        help='Input XINDEX log files directory generated by CTest, nomally under'
                             'CMAKE_BUILD_DIR/Docs/CallerGraph/')
    parser.add_argument('-r', required=True, dest='repositDir',
                        help='VistA Git Repository Directory')
    parser.add_argument('-d', required=True, dest='docRepositDir',
                        help='VistA Cross-Reference Git Repository Directory')
    result = vars(parser.parse_args());
    logger.setLevel(logging.INFO)
    consoleHandler = logging.StreamHandler()
    consoleHandler.setLevel(logging.INFO)
    logger.addHandler(consoleHandler)
    logFileParser = CallerGraphLogFileParser()
    logFileParser.parsePercentRoutineMappingFile(os.path.join(result['docRepositDir'],
                                                              "PercentRoutineMapping.csv"))
    logFileParser.parsePackagesFile(os.path.join(result['repositDir'],
                                                 "Packages.csv"))
    logFileParser.parsePackageDocumentationLink(os.path.join(result['docRepositDir'],
                                                             "PackageToVDL.csv"))
    logFileParser.parsePlatformDependentRoutineFile(os.path.join(result['docRepositDir'],
                                                                 "PlatformDependentRoutine.csv"))
    logFileParser.findGlobalsBySourceV2(os.path.join(result['repositDir'],
                                                     "Packages"),
                                        "*/Globals/*.zwr")
    logFileParser.findPackagesAndRoutinesBySource(os.path.join(result['repositDir'],
                                                               "Packages"),
                                                  "*/Routines/*.m")
#    logFileParser.printAllNamespaces()
    testRoutineName = ["%ZTLOAD", "PRC0A", "A1B2OSR"]
    for routineName in testRoutineName:
        (namespace, package) = logFileParser.getRoutineNameSpace(routineName)
        logger.info("Routine: %s belongs to namespace %s, package %s" % (routineName, namespace, package))