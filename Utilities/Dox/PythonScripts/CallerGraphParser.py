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
from CrossReference import LocalVariable, GlobalVariable, NakedGlobal, MarkedItem, LabelReference
from CrossReference import RoutineCallInfo, getAlternateGlobalName, getTopLevelGlobalName

from LogManager import logger, initConsoleLogging

#Routines starts with A followed by a number
ARoutineEx = re.compile("^A[0-9][^ ]+$")

nameValuePair = re.compile("(?P<prefix>^(>> |   ))(?P<name>[^ \"]+(\".*\")?) +(?P<value>[^ *!~]+)(?P<cond>[*!~]*),?")
longName = re.compile("^(>> |   )[^ ]+(\".*\")? $")
#RoutineStart = re.compile("^Routine: (?P<name>[^ ]+)$")
RoutineStart = re.compile("^\*\*\*\*\* +INDEX OF (?P<name>[^ ]+) +\*\*\*\*\*$")
localVarStart = re.compile("^Local Variables")
globalVarStart = re.compile("^Global Variables")
nakedGlobalStart = re.compile("^Naked Globals")
markedItemStart = re.compile("^Marked Items")
labelReferencesStart = re.compile("^Label References$")
externalReferencesStart = re.compile("^External References$")
routineInvokesStart = re.compile('Routine +Invokes')
calledRoutineStart = re.compile("^Routine +is Invoked by:")
RoutineEnd = re.compile("-+ END -+")
pressReturn = re.compile("Press return to continue:")
crossRef = re.compile("\*\*\*\*\*   Cross Reference of all Routines")
routineTag = re.compile("(?P<external>\$\$)?(?P<tag>[^$^]*)\^?(?P<name>.*)")
variableCond = re.compile("( \* Changed  ! Killed  \~ Newed)")
# according to M(mumps) standard, the very first letter of a routine should be a letter or % sign followed by letters or digits.
validRoutineName = re.compile("^(\$\&|\@)?[a-zA-Z%\(]?[a-zA-Z0-9\.%]*$")

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
class ISectionParser:
    def __init__(self):
        pass
    def onSectionStart(self, line, section):
        pass
    def onSectionEnd(self, line, section, Routine, CrossReference):
        pass
    def parseLine(self, line, Routine, CrossReference):
        pass
#===============================================================================
# Default Implementation of the ISectionParser
#===============================================================================
DEFAULT_VALUE_FIELD_START_INDEX = 16
DEFAULT_NAME_FIELD_START_INDEX = 3
class AbstractSectionParser (ISectionParser):
    def __init__(self, section, valueStartIndex = DEFAULT_VALUE_FIELD_START_INDEX):
        self._varName = None
        self._varPrefix = None
        self._varValue = None
        self._section = section
        self._valueStartIdx = valueStartIndex
        self._addVarToRoutine = None
        self._postParsingRoutine = None
        self._suspiousLine = False
    def __resetVar__(self):
        self._varName = None
        self._varPrefix = None
        self._varValue = None
        self._suspiousLine = False
    def __handleSuspiousCases__(self, Routine, CrossReference):
        if not self._suspiousLine:
            return
        logger.debug("Handling [%s] with value field [%d] in Routine:[%s]" % (self._varName, self._valueStartIdx, Routine))
        self._varValue = self._varName[self._valueStartIdx - DEFAULT_NAME_FIELD_START_INDEX:]
        self._varName = self._varName[:self._valueStartIdx - DEFAULT_NAME_FIELD_START_INDEX]
        if self._addVarToRoutine:
            self._addVarToRoutine(Routine, CrossReference)
        if self._postParsingRoutine:
            self._postParsingRoutine(Routine, CrossReference)
    def __isNameValuePairLine__(self, line):
        if (line[DEFAULT_NAME_FIELD_START_INDEX] == ' ' or
            line[-1] == '\"' or len(line) < self._valueStartIdx + 1):
            return False
        if ((line[self._valueStartIdx - 1] == ' ' or
             line[self._valueStartIdx - 1] == '\"') and
            line.find('\"', self._valueStartIdx) == -1):
            return True
        return False
    def __isLongNameLine__(self, line):
        if (len(line) <= self._valueStartIdx):
            return False
        return True
    def __isValueOnlyLine__(self, line):
        return len(line.lstrip()) == len(line) - self._valueStartIdx
    def __ignoreLine__(self, line):
        if (line.rstrip() == "   NONE" or
            line.strip() == "( * Changed  ! Killed  ~ Newed)"):
            return True
        if (line[0:DEFAULT_NAME_FIELD_START_INDEX] != "   " and
            line[0:DEFAULT_NAME_FIELD_START_INDEX] != ">> "):
            return True
        return False
    def onSectionStart(self, line, section):
        assert section == self._section
        self.__resetVar__()
    def onSectionEnd(self, line, section, Routine, CrossReference):
        assert section == self._section
        self.__handleSuspiousCases__(Routine, CrossReference)
        self.__resetVar__()
    def registerAddVarToRoutine(self, addVarToRoutine):
        self._addVarToRoutine = addVarToRoutine
    def registerPostParsingRoutine(self, postParsing):
        self._postParsingRoutine = postParsing
    def parseLine(self, line, Routine, CrossReference):
        if self.__ignoreLine__(line):
            return
        # handle three cases:
        # 1. continuation of the previous info with value info
        # 2. Name too long.
        # 3. normal name/value pair
        result = self.__isNameValuePairLine__(line)
        if result:
            if self._suspiousLine:
                self.__handleSuspiousCases__(Routine, CrossReference)
                self._suspiousLine = False
            self._varPrefix = line[0:DEFAULT_NAME_FIELD_START_INDEX]
            self._varValue = line[self._valueStartIdx:]
            self._varName = line[DEFAULT_NAME_FIELD_START_INDEX:self._valueStartIdx].strip()
            if self._addVarToRoutine:
                self._addVarToRoutine(Routine, CrossReference)
            if self._postParsingRoutine:
                self._postParsingRoutine(Routine, CrossReference)
            return
        result = self.__isValueOnlyLine__(line)
        if result:
            self._suspiousLine = False
            self._varValue = line[self._valueStartIdx:].strip()
            if not self._varName:
                logger.error("No varname is set, Routine: %s line: %s" % (Routine, line))
                return
            if self._addVarToRoutine:
                self._addVarToRoutine(Routine, CrossReference)
            if self._postParsingRoutine:
                self._postParsingRoutine(Routine, CrossReference)
            return
        result = self.__isLongNameLine__(line)
        if result:
            if self._suspiousLine:
                self.__handleSuspiousCases__(Routine, CrossReference)
            self._varName = line[DEFAULT_NAME_FIELD_START_INDEX:].strip()
            self._varPrefix = line[0:DEFAULT_NAME_FIELD_START_INDEX]
            self._suspiousLine = True
            return
        logger.error("Could not handle this, Routine: %s, line: %s" % (Routine, line))
#===============================================================================
# Implementation of a section _sectionParser to parse the local variables part
#===============================================================================
class LocalVarSectionParser (AbstractSectionParser):
    def __init__(self):
        AbstractSectionParser.__init__(self, IXindexLogFileParser.LOCAL_VARIABLE)
        self.registerAddVarToRoutine(self.__addVarToRoutine__)
    def __addVarToRoutine__(self, Routine, CrossReference):
        Routine.addLocalVariables(LocalVariable(self._varName,
                                                self._varPrefix,
                                                self._varValue))
#===============================================================================
# Implementation of a section logFileParser to parse the Global variables part
#===============================================================================
class GlobalVarSectionParser (AbstractSectionParser):
    def __init__(self):
        GLOBAL_VAR_VALUE_FIELD_START_INDEX = 23
        AbstractSectionParser.__init__(self, IXindexLogFileParser.GLOBAL_VARIABLE,
                                             GLOBAL_VAR_VALUE_FIELD_START_INDEX)
        self.registerAddVarToRoutine(self.__addVarToRoutine__)
        self.registerPostParsingRoutine(self.__postParsing__)
    def __addVarToRoutine__(self, Routine, CrossReference):
        globalVar = CrossReference.getGlobalByName(self._varName)
        if not globalVar:
           # this is to fix a problem with the name convention of a top level global
           # like ICD9 can be referred as eith ICD9 or ICD9(
           altName = getAlternateGlobalName(self._varName)
           globalVar = CrossReference.getGlobalByName(altName)
           if globalVar:
              logger.debug("Changing global name from %s to %s" % (self._varName, altName))
              self._varName = altName
        Routine.addGlobalVariables(GlobalVariable(self._varName,
                                                  self._varPrefix,
                                                  self._varValue))
    def __postParsing__(self, Routine, CrossReference):
        globalVar = CrossReference.getGlobalByName(self._varName)
        if not globalVar:
            globalVar = CrossReference.addNonFileManGlobalByName(self._varName)
        routineName = Routine.getName()
        # case to handle the platform dependent routines
        if CrossReference.isPlatformDependentRoutineByName(routineName):
            genericRoutine = CrossReference.getGenericPlatformDepRoutineByName(routineName)
            assert genericRoutine
            globalVar.addReferencedRoutine(genericRoutine)
            genericRoutine.addReferredGlobal(globalVar)
        else:
            globalVar.addReferencedRoutine(Routine)
        Routine.addReferredGlobal(globalVar)
#===============================================================================
# Implementation of a section logFileParser to parse the Naked Globals part
#===============================================================================
class NakedGlobalsSectionParser (AbstractSectionParser):
    def __init__(self):
        AbstractSectionParser.__init__(self, IXindexLogFileParser.NAKED_GLOBAL)
        self.registerAddVarToRoutine(self.__addVarToRoutine__)
    def __addVarToRoutine__(self, Routine, CrossReference):
        Routine.addNakedGlobals(NakedGlobal(self._varName,
                                            self._varPrefix,
                                            self._varValue))
#===============================================================================
# Implementation of a section logFileParser to parse the Marked Items part
#===============================================================================
class MarkedItemsSectionParser (AbstractSectionParser):
    def __init__(self):
        AbstractSectionParser.__init__(self, IXindexLogFileParser.MARKED_ITEMS)
        self.registerAddVarToRoutine(self.__addVarToRoutine__)
    def __addVarToRoutine__(self, Routine, CrossReference):
        Routine.addMarkedItems(MarkedItem(self._varName,
                                          self._varPrefix,
                                          self._varValue))
#===============================================================================
# Implementation of a section logFileParser to parse the Label References part
#===============================================================================
class LabelReferenceSectionParser (AbstractSectionParser):
    def __init__(self):
        AbstractSectionParser.__init__(self, IXindexLogFileParser.LABEL_REFERENCE)
        self.registerAddVarToRoutine(self.__addVarToRoutine__)
    def __addVarToRoutine__(self, Routine, CrossReference):
        Routine.addLabelReference(LabelReference(self._varName,
                                                self._varPrefix,
                                                self._varValue))
#===============================================================================
# Implementation of a section logFileParser to parse the Called Routine parts
#===============================================================================
class ExternalReferenceSectionParser (AbstractSectionParser):
    def __init__(self):
        EXTERNAL_REFERENCE_VALUE_FIELD_START_INDEX = 23
        AbstractSectionParser.__init__(self, IXindexLogFileParser.EXTERNEL_REFERENCE,
                                             EXTERNAL_REFERENCE_VALUE_FIELD_START_INDEX)
        self.registerPostParsingRoutine(self.__postParsing__)
    def __postParsing__(self, Routine, CrossReference):
        routineDetail = routineTag.search(self._varName.strip())
        if routineDetail:
            routineName = routineDetail.group('name')
            if not validRoutineName.search(routineName):
                logger.warning("invalid Routine Name: %s in routine:%s, package: %s" %
                             (routineName, Routine, Routine.getPackage()))
                return
            if (routineName.startswith("%")):
               CrossReference.addPercentRoutine(routineName)
               # ignore mumps routine for now
               if CrossReference.isMumpsRoutine(routineName):
                   return
#                   routineName=routineName[1:]
            if CrossReference.routineNeedRename(routineName):
                routineName = CrossReference.getRenamedRoutineName(routineName)
            tag = ""
            if routineDetail.group('external'):
                tag += routineDetail.group('external')
            if routineDetail.group('tag'):
                tag += routineDetail.group('tag')
            if not CrossReference.hasRoutine(routineName):
                # automatically categorize the routine by the namespace
                # if could not find one, assign to Uncategorized
                defaultPackageName = "Uncategorized"
                (namespace, package) = CrossReference.categorizeRoutineByNamespace(routineName)
                if namespace and package:
                    defaultPackageName = package.getName()
                CrossReference.addRoutineToPackageByName(routineName, defaultPackageName, False)
            routine = CrossReference.getRoutineByName(routineName)
            Routine.addCalledRoutines(routine, tag, self._varValue)

#===============================================================================
# Interface for a Xindex Log File Parser
#===============================================================================
class IXindexLogFileParser:
    # some enum like constant for section header
    LOCAL_VARIABLE=1
    GLOBAL_VARIABLE=2
    NAKED_GLOBAL=3
    MARKED_ITEMS=4
    ROUTINE_INVOKES=5
    ROUTINE_CALLED=6
    LABEL_REFERENCE=7
    EXTERNEL_REFERENCE=8
    ROUTINE=9
    # format constant

    def __init__(self, crossReference):
        '''
        default constructor
        '''
    def parseXindexLogFile(self, logFileName):
        '''
        pass Xindex Log File
        '''
    def __ignoreCurrentLine__(self, curLine):
        '''
        wether the current line should be ignored
        '''
    def __isSectionHeader__(self, curLine):
        '''
        wether current line is a section header, returns a tuple (bool, section enum)
        '''
    def __isEndOfSection__(self, curLine, section):
        '''
        wether this is the end of the section, returns a tuple (bool, section enum)
        '''
    def registerSectionHandle(self, section, AbstractSectionParser):
        '''
        register a handle callback for each of the section, should be called before parsing
        '''

# Class defines the parsing workflow for XINDEX log file
#===============================================================================
class XINDEXLogFileParser (IXindexLogFileParser, ISectionParser):
    def __init__(self, CrossReference):
        self._crossRef = CrossReference
        self._curSection = None
        self._curHandler = None
        self._sectHandleDict = dict()
        self._sectionStack = []
        self._sectionHeaderRegex = dict()
        self.__initSectionHeaderRegex__()
        self.__initDefaultSectionHandler__()
        self._curRoutine = None
    def __initSectionHeaderRegex__(self):
        self._sectionHeaderRegex[RoutineStart] = IXindexLogFileParser.ROUTINE
        self._sectionHeaderRegex[localVarStart] = IXindexLogFileParser.LOCAL_VARIABLE
        self._sectionHeaderRegex[globalVarStart] = IXindexLogFileParser.GLOBAL_VARIABLE
        self._sectionHeaderRegex[nakedGlobalStart] = IXindexLogFileParser.NAKED_GLOBAL
        self._sectionHeaderRegex[markedItemStart] = IXindexLogFileParser.MARKED_ITEMS
        self._sectionHeaderRegex[labelReferencesStart] = IXindexLogFileParser.LABEL_REFERENCE
        self._sectionHeaderRegex[externalReferencesStart] = IXindexLogFileParser.EXTERNEL_REFERENCE
    def __initDefaultSectionHandler__(self):
        self._sectHandleDict[IXindexLogFileParser.ROUTINE] = self
        self._sectHandleDict[IXindexLogFileParser.LOCAL_VARIABLE] = LocalVarSectionParser()
        self._sectHandleDict[IXindexLogFileParser.GLOBAL_VARIABLE] = GlobalVarSectionParser()
        self._sectHandleDict[IXindexLogFileParser.NAKED_GLOBAL] = NakedGlobalsSectionParser()
        self._sectHandleDict[IXindexLogFileParser.MARKED_ITEMS] = MarkedItemsSectionParser()
        self._sectHandleDict[IXindexLogFileParser.LABEL_REFERENCE] = LabelReferenceSectionParser()
        self._sectHandleDict[IXindexLogFileParser.EXTERNEL_REFERENCE] = ExternalReferenceSectionParser()
    # implementation of section parser interface for Routine Section
    def onSectionStart(self, line, section):
        if section != IXindexLogFileParser.ROUTINE:
            logger.error("Invalid section Header")
            return False
        routineName = RoutineStart.search(line).group('name')
        assert validRoutineName.search(routineName) != None, "Invalid RoutineName: [%s] Line: [%s]" % (routineName, line)
        if self._crossRef.isPlatformDependentRoutineByName(routineName):
            self._curRoutine = self._crossRef.getPlatformDependentRoutineByName(routineName)
            return True
        renamedRoutineName = routineName
        if self._crossRef.routineNeedRename(routineName):
            renamedRoutineName = self._crossRef.getRenamedRoutineName(routineName)
        if not self._crossRef.hasRoutine(renamedRoutineName):
            logger.error("Invalid Routine: %s: rename Routine %s" %
                         (routineName, renamedRoutineName))
            return False
        self._curRoutine = self._crossRef.getRoutineByName(renamedRoutineName)
        return True
    def onSectionEnd(self, line, section, Routine, CrossReference):
        if section != IXindexLogFileParser.ROUTINE:
            logger.error("Invalid section Header")
            return False
        self._curRoutine = None
        return True
    def registerSectionHandle(self, section, AbstractSectionParser):
        self._sectHandleDict[section] = AbstractSectionParser
    def parseXindexLogFile(self, logFileName):
        if not os.path.exists(logFileName):
            logger.error("File: %s does not exist" % logFileName)
            return
        logFile = open(logFileName, "rb")
        for curLine in logFile:
            curLine = curLine.rstrip("\r\n")
            if pressReturn.search(curLine) or crossRef.search(curLine):
                continue
            # check to see if it is a section header or we just in the routine header part
            if not self._curSection or self._curSection == IXindexLogFileParser.ROUTINE:
                sectionHeader = self.__isSectionHeader__(curLine)
                if sectionHeader:
                    self._curSection = sectionHeader
                    self._curHandler = self._sectHandleDict.get(sectionHeader)
                    if self._curHandler:
                        self._curHandler.onSectionStart(curLine, sectionHeader)
                    self._sectionStack.append(sectionHeader)
                continue
            if self.__isEndOfSection__(curLine, self._curSection):
                if self._curHandler:
                    self._curHandler.onSectionEnd(curLine, self._curSection,
                                                  self._curRoutine, self._crossRef)
                assert(self._curSection == self._sectionStack.pop())
                if len(self._sectionStack) > 0:
                    self._curSection = self._sectionStack[-1]
                    self._curHandler = self._sectHandleDict[self._curSection]
                else:
                    self._curSection = None
                    self._curHandler = None
                continue
            if self._curHandler:
                self._curHandler.parseLine(curLine, self._curRoutine, self._crossRef)
    def __ignoreCurrentLine__(self, curLine):
        return pressReturn.search(curLine) or crossRef.search(curLine)
    def __isSectionHeader__(self, curLine):
        for (regex, section) in self._sectionHeaderRegex.iteritems():
            if regex.search(curLine):
                return section
        return None
    def __isEndOfSection__(self, curLine, section):
        if section == IXindexLogFileParser.ROUTINE:
            return RoutineEnd.search(curLine)
        else:
            return curLine.strip() == ''

#===============================================================================
# A class to parse XINDEX log file output and convert to Routine/Package
#===============================================================================
class CallerGraphLogFileParser(object):
    def __init__(self):
        self._crossRef = CrossReference()

    def printResult(self):
        logger.info("Total Routines are %d" % len(self._crossRef.getAllRoutines()))

    def getCrossReference(self):
        return self._crossRef
    def getAllRoutines(self):
        return self._crossRef.getAllRoutines()
    def getAllPackages(self):
        return self._crossRef.getAllPackages()
    def getAllGlobals(self):
        return self._crossRef.getAllGlobals()
    def outputPackageCSVFile(self, outputFile):
        output = csv.writer(open(outputFile, 'w'), lineterminator='\n')
        allPackages = self._crossRef.getAllPackages()
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
                    globalDes = globalList[index].getFileManName()
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
        XindexParser = XINDEXLogFileParser(self._crossRef)
        for logFileName in allFiles:
            logger.info("Start paring log file [%s]" % logFileName)
            XindexParser.parseXindexLogFile(logFileName)
    #===========================================================================
    # find all the package name and routines by reading the repository directory
    #===========================================================================
    def findPackagesAndRoutinesBySource(self, dirName, pattern):
        searchFiles = glob.glob(os.path.join(dirName, pattern))
        logger.info("Total Search Files are %d " % len(searchFiles))
        allRoutines = self._crossRef.getAllRoutines()
        allPackages = self._crossRef.getAllPackages()
        crossReference = self._crossRef
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
        logger.info("Total package is %d and Total Routines are %d" %
                    (len(allPackages), len(allRoutines)))
#===============================================================================
# Find all globals by source zwr and package.csv files version v2
#===============================================================================
    def findGlobalsBySourceV2(self, dirName, pattern):
        searchFiles = glob.glob(os.path.join(dirName, pattern))
        logger.info("Total Search Files are %d " % len(searchFiles))
        crossReference = self._crossRef
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
            result = re.search("(?P<fileNo>^[0-9.]+)(-1)?\+(?P<des>.*)\.zwr$", fileName)
            if result:
                fileNo = result.group('fileNo')
                if fileNo.startswith('0'): fileNo = fileNo[1:]
                globalDes = result.group('des')
            else:
                result = re.search("(?P<namespace>^[^.]+)\.zwr$", fileName)
                if result:
                    namespace = result.group('namespace')
#                    package.addGlobalNamespace(namespace)
                    continue
                else:
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
            globalVar = Global(globalName, fileNo, globalDes,
                               allPackages.get(packageName))
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
        crossReference = self._crossRef
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
            globalVar = Global(globalName, fileNo,  globalDes,
                               allPackages.get(packageName))
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
                    if (globalVar.getFileManName() != line[1] and
                        globalVar.getFileNo() == line[0]):
                            logger.warn ("Diff in Description [%s], [%s]" % (globalVar.getFileManName(), line[1]))
    #                        fix the description part (name)
                            line[1] = globalVar.getFileManName()
                    if (globalVar.getPackage().getName() != line[-1] and
                        globalVar.getPackage().getOriginalName() != line[-1]):
                        logger.warn("Diff in package name [%s], [%s]" %
                                    (line[-1], globalVar.getPackage().getOriginalName()))
                        for package in self._crossRef.getAllPackages().itervalues():
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
#                                   globalVar.getFileManName(),
#                                   globalVar.getName(),
#                                   globalVar.getPackage().getOriginalName()])
    def parsePackagesFile(self, packageFilename):
        result = csv.DictReader(open(packageFilename, 'rb'))
        crossRef = self._crossRef
        currentPackage = None
        index = 0
        for row in result:
            packageName = row['Directory Name']
            if len(packageName) > 0:
                currentPackage = crossRef.getPackageByName(packageName)
                if not currentPackage:
                    logger.debug ("Package [%s] not found" % packageName)
                    crossRef.addPackageByName(packageName)
                currentPackage = crossRef.getPackageByName(packageName)
                currentPackage.setOriginalName(row['Package Name'])
                vdlId = row['VDL ID']
                if vdlId and len(vdlId):
                    currentPackage.setDocLink(getVDLHttpLinkByID(vdlId))
            else:
                if not currentPackage:
                    logger.warn ("row is not under any package: %s" % row)
                    continue
            if len(row['Prefixes']):
                currentPackage.addNamespace(row['Prefixes'])
            if len(row['Globals']):
                currentPackage.addGlobalNamespace(row['Globals'])
        logger.info ("Total # of Packages is %d" % (len(crossRef.getAllPackages())))
    def parsePercentRoutineMappingFile(self, mappingFile):
        csvReader = csv.reader(open(mappingFile, "rb"))
        for line in csvReader:
            self._crossRef.addPercentRoutineMapping(line[0], line[1], line[2])
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
        crossRef = self._crossRef
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
        crossRef = self._crossRef
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
    def getRoutinePackageNameSpace(self, routineName):
        return self._crossRef.categorizeRoutineByNamespace(routineName)
    def getGlobalPackageNameSpace(self, globalName):
        return self._crossRef.categorizeGlobalByNamespace(globalName)
# end of class CallerGraphLogFileParser

def getVDLHttpLinkByID(vdlId):
  return "http://www.va.gov/vdl/application.asp?appid=%s" % vdlId
#===============================================================================
# Section for unit/regression testing routines
#===============================================================================
#Testing Constants
# Unit test of categorizing routine based on namespace
RoutineNamespaceMappingTestDict = {"%ZTLOAD": ("%Z", Package("Kernel")),
                                   "PRC0A": ("PRC", Package("IFCAP")),
                                   "PRCABIL1": ("PRCA", Package("Accounts Receivable")),
                                   "RGUTALR": ("RGUT", Package("Run Time Library")),
                                   "IBQL356": ("IBQ", Package("Utilization Management Rollup")),
                                   "A1B2OSR": (None,None)}

def testingRoutineNamespaceMapping(loggerParser, testMapping):
    for (routineName, expectedValue) in testMapping.iteritems():
        result = loggerParser.getRoutinePackageNameSpace(routineName)
        assert result == expectedValue, "result: %s, expect: %s" % (result, expectedValue)

# regression testing functions
# dict in the format of routinename as key, a list of variables as value
localVarRegressionTest = {"ONCBPC1":['''TABLE("DURATION OF SMOKE-FREE HISTORY"''',
                                     '''TABLE("DURATION OF SMOKING HISTORY"''',
                                     '''TABLE("FAMILY HISTORY OF CANCER"''',
                                     '''TABLE("ACCESSION/SEQUENCE NUMBER"''',
                                     '''I''',
                                     '''DR'''],
                          "AFJXTRF":['''XMY("G.AFJX PATID FILTER BLOCK"''',
                                     '''AXPID("NAME"''',
                                     '''AXDREC'''],
                          "MAGXIDXU":['''XMY("G.MAG SERVER"''',
                                      '''CNT'''],
                          "MAGBRTE4":['''KEYWORD("CONDITION"'''],
                          "XTERSUM4":['''ZTSAVE("XTERMAX"'''],
                          "XTINEND":['''XMY("G.KERNEL_INSTALL@ISC-SF.VA.GOV"'''],
                          "XTHC10A":['''DFLTHDR("CONTENT-LENGTH"''','''DFLTHDR("USER-AGENT"'''],
                          "RCCPW":['''ZTSAVE("SITE"''','''ZTSAVE("^TMP(""RCCPW"",$J,"'''],
                          "PRCARPS":['''ZTSAVE("PRCA(""BILLN"")"''','''ZTSAVE("PRCA(""BILLN"")"'''],
                          "XINDX8":['''ZTSAVE("^UTILITY($J,"''','''IND("CMD"''']
}
globalVarRegressionTest = {"MAGGA03":['''^TMP("MAGGA03A.NAME"'''],
                           "MAGGTMC":['''^XUSEC("MAGCAP MED "'''],
                           "MAGXIDXU":['''^XTMP("MAG INDEX TERMS BACKUP"'''],
                           "MAGBRTE4":['''^XTMP("MAGEVALSTUDY"'''],
                           "XOBWD":['''^TMP("XOBW WSDL FILING"'''],
                           "PRCAI162":['''^TMP("PRCAI162REPAY"''','''^PRCA(430'''],
                           "RCDPE8NZ":['''^TMP("RCDPE8NZZ_EFT"''','''^RCY(344'''],
                           "PXRMHF":['''^PXRMINDX(9000010.23''','''^TMP("PXRMXMZ"'''],
                           "ORWGAPI4":['''^PXRMINDX(9000010.18''', '''^PXRMINDX(9000010.16''',
                                       '''^PXRMINDX(9000010.13''','''^PXRMINDX(9000010.07''',
                                       '''^PXRMINDX(9000010.11''', '''^PXRMINDX(9000010.12'''],
                           "PXPXRMI1":['''^PXRMINDX(9000010.11''', '''^PXRMINDX(9000010.18''',
                                       '''^PXRMINDX(9000010.23''', '''^AUTTIMM''']
}
routineInvokeRegressionTest = {}
nakedGlobalsRegressionTest = {"FSCCLEAN":['''^("STATUS HIST"''',
                                          '''^("STU ALERT"''']}
markedItemRegressionTest = {"XINDX11":['''$T(RTN^XTRUTL1'''],
                            "RCRJRBDT":['''$T(FOOTNOTE+%'''],
                            "IBDFN6":['''$T(ALL^IBCNS1''', '''$T(INSURED^IBCNS1'''],
                            "KMPRUTL":['''$T(ELEMENTS+I''', '''$T('''],
                            "IBTRKR41":['''$T(CLDATA+(3)'''],
                            "XGFDEMO1":['''$T(KEYBOARD+%''', '''$T(CURSOR+%'''],
                            "ZTM0":['''$T(ACTJ^%ZOSV''']}
def regressionTestingLocalVarParsing(localVarDict, crossRef):
    for (routineName, resultList) in localVarDict.iteritems():
        if crossRef.hasRoutine(routineName):
            routine = crossRef.getRoutineByName(routineName)
            assert routine, "Can not find routine: %s" % routineName
            localVars = routine.getLocalVariables()
            for item in resultList:
                assert item in localVars, "localVar: %s not found in routine %s" % (item, routineName)
                assert len(localVars[item].getLineOffsets()[0]) > 0

def regressionTestingGlobalVarParsing(globalVarDict, crossRef):
    for (routineName, resultList) in globalVarDict.iteritems():
        if crossRef.hasRoutine(routineName):
            routine = crossRef.getRoutineByName(routineName)
            assert routine, "Can not find routine: %s" % routineName
            globalVars = routine.getGlobalVariables()
            for item in resultList:
                assert item in globalVars, "GlobalVar: %s not found in routine %s" % (item, routineName)
                assert len(globalVars[item].getLineOffsets()[0]) > 0, "GlobalVar: %s tag + offset is empty in routine: %s" % (item, routineName)

def regressionTestingNakedGLobalParsing(markedItemDict, crossRef):
    for (routineName, resultList) in markedItemDict.iteritems():
        if crossRef.hasRoutine(routineName):
            routine = crossRef.getRoutineByName(routineName)
            assert routine, "Can not find routine: %s" % routineName
            nakedGlobals = routine.getNakedGlobals()
            for item in resultList:
                assert item in nakedGlobals, "NakedGlobal: %s not found in routine %s" % (item, routineName)
                assert len(nakedGlobals[item].getLineOffsets()[0]) > 0

def regressionTestingMarkedItemParsing(markedItemDict, crossRef):
    for (routineName, resultList) in markedItemDict.iteritems():
        if crossRef.hasRoutine(routineName):
            routine = crossRef.getRoutineByName(routineName)
            assert routine, "Can not find routine: %s" % routineName
            markedItems = routine.getMarkedItems()
            for item in resultList:
                assert item in markedItems, "Marked Items: %s not found in routine %s" % (item, routineName)
                assert len(markedItems[item].getLineOffsets()[0]) > 0

def runRegressionTestingCases(logFileParser):
    testingRoutineNamespaceMapping(logFileParser, RoutineNamespaceMappingTestDict)
    regressionTestingLocalVarParsing(localVarRegressionTest, logFileParser.getCrossReference())
    regressionTestingGlobalVarParsing(globalVarRegressionTest, logFileParser.getCrossReference())
    regressionTestingNakedGLobalParsing(nakedGlobalsRegressionTest, logFileParser.getCrossReference())
    regressionTestingMarkedItemParsing(markedItemRegressionTest, logFileParser.getCrossReference())

""" generate argument parse for Parsing log related parameters """
def createCallGraphLogAugumentParser():
    parser = argparse.ArgumentParser(add_help=False) # no help page
    argGroup = parser.add_argument_group(
                              'Call Graph Log Parser Releated Arguments',
                              "Argument for Parsing Call Graph and Schema logs")
    argGroup.add_argument('-xl', '--xindexLogDir', required=True,
                          help='Input XINDEX log files directory, nomally under'
                             '${CMAKE_BUILD_DIR}/Docs/CallerGraph/')
    argGroup.add_argument('-mr', '--MRepositDir', required=True,
                          help='VistA M Component Git Repository Directory')
    argGroup.add_argument('-pr', '--patchRepositDir', required=True,
                          help="VistA Git Repository Directory")
    return parser

def parseAllCallGraphLogWithArg(arguments):
    return parseAllCallGraphLog(arguments.xindexLogDir,
                                arguments.MRepositDir,
                                arguments.patchRepositDir)

def parseAllCallGraphLog(xindexLogDir, MRepositDir, patchRepositDir):
    logFileParser = CallerGraphLogFileParser()
    DoxDir = 'Utilities/Dox'
    percentMapFile = os.path.join(patchRepositDir, DoxDir,
                                  "PercentRoutineMapping.csv")
    logFileParser.parsePercentRoutineMappingFile(percentMapFile)
    logFileParser.parsePackagesFile(os.path.join(patchRepositDir,
                                                 "Packages.csv"))
    platformDepRtnFile = os.path.join(patchRepositDir, DoxDir,
                                  "PlatformDependentRoutine.csv")
    logFileParser.parsePlatformDependentRoutineFile(platformDepRtnFile)
    logFileParser.findGlobalsBySourceV2(os.path.join(MRepositDir,
                                                     "Packages"),
                                        "*/Globals/*.zwr")
    logFileParser.findPackagesAndRoutinesBySource(os.path.join(MRepositDir,
                                                               "Packages"),
                                                  "*/Routines/*.m")
    logFileParser.parseAllCallerGraphLog(xindexLogDir, "*.log")
    return logFileParser

import logging
if __name__ == '__main__':
    logFileParser = createCallGraphLogAugumentParser()
    parser = argparse.ArgumentParser(
                description='VistA Cross-Reference Call Graph Log Files Parser',
                parents=[logFileParser])
    initConsoleLogging()
    result = parser.parse_args();
    logParser = parseAllCallGraphLogWithArg(result)
    runRegressionTestingCases(logParser)
