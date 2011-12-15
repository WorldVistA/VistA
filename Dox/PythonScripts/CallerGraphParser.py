#!/usr/bin/env python

# A parser to parse XINDEX log file and generate the routine/package information
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

from datetime import datetime, date, time
from CrossReference import CrossReference, Routine, Package, Global
from CrossReference import LocalVariable, GlobalVariable, NakedGlobal, MarkedItem
from CrossReference import RoutineCallDict, RoutineCallerInfo, UNKNOWN_PACKAGE

#Routines starts with A followed by a number
ARoutineEx=re.compile("^A[0-9][^ ]+$")

nameValuePair=re.compile("(?P<prefix>^(>> |   ))(?P<name>[^ \"]+(\".*\")?) +(?P<value>[^ *!~]+)(?P<cond>[*!~]*),?")
LongName=re.compile("^(>> |   )[^ ]+(\".*\")? $")
RoutineStart=re.compile("^Routine: (?P<name>[^ ]+)$")
localVarStart=re.compile("^Local Variables +Routines")
globalVarStart=re.compile("^Global Variables")
nakedGlobalStart=re.compile("^Naked Globals")
markedItemStart=re.compile("^Marked Items")
routineInvokesStart=re.compile('Routine +Invokes')
calledRoutineStart=re.compile("^Routine +is Invoked by:")
RoutineEnd=re.compile("-+ END -+")
pressReturn=re.compile("Press return to continue:")
routineTag=re.compile("(\$\$)?(?P<tag>[^$^]*)\^?(?P<name>.*)")


#===============================================================================
# Interface to parse a section of the XINDEX log file
#===============================================================================
class AbstractSectionParse:
    def parseLine(self, line, crossReference):
        pass
    def setRoutine(self, routine):
        pass

#===============================================================================
# Implementation of a section parser to parse the local variables part
#===============================================================================
class LocalVarSectionParse (AbstractSectionParse):
    def __init__(self):
        self.routine=None
    def parseLine(self, line, crossReference):
        result = nameValuePair.search(line)
        if (result):
            self.routine.addLocalVariables(LocalVariable(result.group('name'),
                                                         result.group('prefix'),
                                                         result.group('cond')))
    def setRoutine(self, routine):
        self.routine=routine

#===============================================================================
# Implementation of a section parser to parse the Global variables part
#===============================================================================
class GlobalVarSectionParse (AbstractSectionParse):
    def __init__(self):
        self.routine=None
    def parseLine(self, line, crossRef):
        result = nameValuePair.search(line)
        if (result):
            globalName=result.group('name')
            self.routine.addGlobalVariables(GlobalVariable(globalName,
                                                           result.group('prefix'),
                                                           result.group('cond')))
            globalVar=crossRef.getGlobalByName(globalName)
            if globalVar:
                globalVar.addReferencedRoutine(self.routine)
                self.routine.addReferredGlobal(globalVar)
    def setRoutine(self, routine):
        self.routine=routine

#===============================================================================
# Implementation of a section parser to parse the Naked Globals part
#===============================================================================
class NakedGlobalsSectionParser (AbstractSectionParse):
    def __init__(self):
        self.routine=None
    def parseLine(self, line, crossReference):
        result = nameValuePair.search(line)
        if (result):
            self.routine.addNakedGlobals(NakedGlobal(result.group('name'),
                                                     result.group('prefix'),
                                                     result.group('cond')))
    def setRoutine(self, routine):
        self.routine=routine

#===============================================================================
# Implementation of a section parser to parse the Marked Items part
#===============================================================================
class MarkedItemsSectionParser (AbstractSectionParse):
    def __init__(self):
        self.routine=None
    def parseLine(self, line, crossReference):
        result = nameValuePair.search(line)
        if (result):
            self.routine.addMarkedItems(MarkedItem(result.group('name'),
                                                   result.group('prefix'),
                                                   result.group('cond')))
    def setRoutine(self, routine):
        self.routine=routine

#===============================================================================
# Implementation of a section parser to parse the Called Routine parts
#===============================================================================
class CalledRoutineSectionParser (AbstractSectionParse):
    def __init__(self):
        self.routine=None
    def parseLine(self, line, crossReference):
        result = nameValuePair.search(line)
        if (result):
            routineDetail=routineTag.search(result.group('name').strip())
            if routineDetail:
                routineName = routineDetail.group('name')
                if (routineName.startswith("%")):
                   crossReference.addPercentageRoutine(routineName)
                   routineName=routineName[1:]
                tag=routineDetail.group('tag')
                if not crossReference.hasRoutine(routineName):
                    crossReference.addRoutineToPackageByName(routineName, UNKNOWN_PACKAGE)
                routine=crossReference.getRoutineByName(routineName)
                self.routine.addCalledRoutines(routine,tag)
    def setRoutine(self, routine):
        self.routine=routine

#===============================================================================
# Global instance of section parser
#===============================================================================
localVarParser=LocalVarSectionParse()
globalVarParser=GlobalVarSectionParse()
nakedGlobalParser=NakedGlobalsSectionParser()
markedItemsParser=MarkedItemsSectionParser()
calledRoutineParser=CalledRoutineSectionParser()

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
    def visitRoutine(self, routine,outputDir=None):
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
        self.crossReference = CrossReference()
        self.currentRoutine=None
        self.parser=None

    def onNewRoutineStart(self, routineName):
        if not self.crossReference.hasRoutine(routineName):
            print "Invalid Routine: %s" % routineName
            return
        self.currentRoutine = self.crossReference.getRoutineByName(routineName)

    def onNewRoutineEnd(self, routineName):
        self.currentRoutine = None
        self.parser=None
    def onLocalVariablesStart(self, line):
        self.parser=localVarParser
        self.parser.setRoutine(self.currentRoutine)
    def onGlobaleVariables(self, line):
        self.parser=globalVarParser
        self.parser.setRoutine(self.currentRoutine)
    def onCalledRoutines(self,line):
        self.parser=calledRoutineParser
        self.parser.setRoutine(self.currentRoutine)
    def onNakedGlobals(self, line):
        self.parser=nakedGlobalParser
        self.parser.setRoutine(self.currentRoutine)
    def onMarkedItems(self, line):
        self.parser=markedItemsParser
        self.parser.setRoutine(self.currentRoutine)
    def onRoutineInvokes(self, line):
        self.parser=None
    def parseNameValuePair(self, line):
        if self.parser:
            self.parser.parseLine(line,self.crossReference)
    def printResult(self):
        print "Total Routines are %d" % len(self.crossReference.getAllRoutines())

    def printRoutine(self, routineName, visitor=DefaultRoutineVisit()):
        routine = self.crossReference.getRoutineByName(routineName)
        if routine:
            visitor.visitRoutine(routine)
        else:
            print ("Routine: %s Not Found!" % routineName)

    def printPackage(self, packageName, visitor=DefaultPackageVisit()):
        package = self.crossReference.getPackageByName(packageName)
        if package:
            visitor.visitPackage(package)
        else:
            print ("Package: %s Not Found!" % packageName)
    def printGlobal(self, globalName, visitor=None):
        globalVar = self.crossReference.getGlobalByName(globalName)
        if globalVar:
            if visitor:
                visitor.visitGlobal(globalVar)
            else:
                globalVar.printResult()
        else:
            print ("Global: %s Not Found!" % globalName)
    def getCrossReference(self):
        return self.crossReference
    def getAllRoutines(self):
        return self.crossReference.getAllRoutines()
    def getAllPackages(self):
        return self.crossReference.getAllPackages()
    def getAllGlobals(self):
        return self.crossReference.getAllGlobals()
    def outputPackageCSVFile(self, outputFile):
        output=csv.writer(open(outputFile,'w'), lineterminator='\n')
        allPackages=self.crossReference.getAllPackages()
        sortedPackage=sorted(allPackages.keys(),
                             key=lambda item: allPackages[item].getOriginalName())
        for packageName in sortedPackage:
            package=allPackages[packageName]
            namespaceList=package.getNamespaces()
            globalnamespaceList=package.getGlobalNamespace()
            globals=package.getAllGlobals()
            globalList=sorted(globals.values(),
                              key=lambda item: float(item.getFileNo()))
            maxRows=max(len(namespaceList),
                        len(globalnamespaceList),
                        len(globals))
            if maxRows==0:
                continue
            for index in range(maxRows):
                if len(namespaceList) > index:
                    namespace=namespaceList[index]
                else:
                    namespace=""
                if len(globalnamespaceList) > index:
                    globalNamespace = globalnamespaceList[index]
                else:
                    globalNamespace=""
                if len(globals) > index:
                    globalFileNo=globalList[index].getFileNo()
                    globalDes=globalList[index].getDescription()
                else:
                    globalFileNo=""
                    globalDes=""
                if index==0:
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
        allFiles=glob.glob(callerGraphLogFile)
        for logFile in allFiles:
            file = open(logFile,'r')
            print "Parsing log file %s" % logFile
            prevLine=""
            for line in file:
                #strip the newline
                line = line.rstrip(os.linesep)
                #skip the empty line
                if (line.strip() == ''):
                    prevLine=""
                    continue
                if (pressReturn.search(line)):
                    prevLine = ""
                    continue
                result = RoutineStart.search(line)
                if result:
                    routineName = result.group('name')
                    self.onNewRoutineStart(routineName)
                    prevLine=""
                    continue
                if localVarStart.search(line):
                    self.onLocalVariablesStart(line)
                    prevLine=""
                    continue
                if globalVarStart.search(line):
                    self.onGlobaleVariables(line)
                    prevLine=""
                    continue
                if nakedGlobalStart.search(line):
                    self.onNakedGlobals(line)
                    prevLine=""
                    continue
                if markedItemStart.search(line):
                    self.onMarkedItems(line)
                    prevLine=""
                    continue
                if calledRoutineStart.search(line):
                    self.onCalledRoutines(line)
                    prevLine=""
                    continue
                if RoutineEnd.search(line):
                    self.onNewRoutineEnd(routineName)
                    prevLine=""
                    continue
                if routineInvokesStart.search(line):
                    self.onRoutineInvokes(line)
                    prevLine=""
                    continue
                result=None
                result=nameValuePair.search(line)
                if result:
        #            print "Name: %s Value=%s" % (result.group("name"), result.group("value"))
                    prevLine=""
                    self.parseNameValuePair(line)
                    continue
                if (len(prevLine) > 0 and self.currentRoutine and line.find(self.currentRoutine.getName()) !=-1):
                    self.parseNameValuePair(prevLine + line)
                    prevLine=""
                    continue
                result=None
                result=LongName.search(line)
                if result:
                    prevLine=line
                    continue
                prevLine=""
            file.close()

        # generate package direct dependency based on XINDEX call graph
        for package in self.crossReference.getAllPackages().values():
            package.generatePackageDependencies()
    #===========================================================================
    # find all the package name and routines by reading the repository directory
    #===========================================================================
    def findPackagesAndRoutinesBySource(self, dirName, pattern):
        searchFiles = glob.glob(os.path.join(dirName, pattern))
        print "Total Search Files are %d " % len(searchFiles)
        allRoutines=self.crossReference.getAllRoutines()
        allPackages=self.crossReference.getAllPackages()
        crossReference = self.crossReference
        for file in searchFiles:
            routineName = os.path.basename(file).split(".")[0]
            packageName = os.path.dirname(file)
            packageName = packageName[packageName.index("Packages")+9:packageName.index("Routines")-1]
            crossReference.addRoutineToPackageByName(routineName, packageName)
            if ARoutineEx.search(routineName):
#                print "A Routines %s should be exempted" % routineName
                pass
        crossReference.addPackageByName(UNKNOWN_PACKAGE)
        print "Total package is %d and Total Routines are %d" % (len(allPackages), len(allRoutines))
#===============================================================================
# Find all globals by source
#===============================================================================
    def findGlobalsBySource(self, dirName, pattern):
        packageNameMismatchDict={"NOIS TRACKING":"NATIONAL ONLINE INFORMATION SHARING",
                                 "HEALTH DATE & INFORMATICS":"HEALTH DATA & INFORMATICS",
                                 "CM TOOLS":"CAPACITY MANAGEMENT TOOLS",
                                 "HIPPA":"E CLAIMS MGMT ENGINE",
                                 "WOUNDED INJURED & ILL":"WOUNDED INJURED & ILL WARRIORS",
                                 "VISTA DATA EXTRACTION":"VDEF",
                                 "VISTA LINK":"VISTALINK",
                                 "BLOOD BANK":"VBECS"}
        packageFileNoDict={"18.02":"Web Services Client",
                           "18.12":"Web Services Client",
                           "18.13":"Web Services Client",
                           "52.87":"Outpatient Pharmacy",
                           "59.73":"Pharmacy Data Management",
                           "59.74":"Pharmacy Data Management"
                           }
        searchFiles = glob.glob(os.path.join(dirName, pattern))
        print "Total Search Files are %d " % len(searchFiles)
        allGlobals=self.crossReference.getAllGlobals()
        allPackages=self.crossReference.getAllPackages()
        crossReference = self.crossReference
        skipFile=[]
        fileNoSet=set()
        for file in searchFiles:
            packageName = os.path.dirname(file)
            packageName = packageName[packageName.index("Packages")+9:packageName.index("Globals")-1]
            if not crossReference.hasPackage(packageName):
                print ("Package: %s is new" % packageName)
                crossReference.addPackageByName(packageName)
            zwrFile=open(file,'r')
            lineNo=0
            globalDes=""
            fileNo=""
            globalName=""
#            print ("Parsing file: %s" % file)
            for line in zwrFile:
                if lineNo==0:
                    globalDes=line.strip()
                    if globalDes.startswith("^"):
#                        print ("No Description: Skip this file: %s" % file)
                        skipFile.append(file)
                        break
                if lineNo==1:
                    assert line.strip() == 'ZWR'
                if lineNo >= 2:
                    info = line.strip().split('=')
                    globalName=info[0]
                    detail = info[1].strip("\"")
                    if globalName.find(',') > 0:
                        result=globalName.split(',')
                        if len(result)==2 and result[1]=="0)":
                            globalName=result[0]
                            if globalName.find("(") >0:
                                fileNo=globalName.split('(')[1]
                                if detail.find(fileNo) < 0:
#                                    print "Could not find fileNo in %s file: %s" % (line, file)
                                    fileNo=""
                    elif globalName.endswith("(0)"):
                        globalName=globalName.split('(')[0]
                    else:
                        continue
                    if detail.find('^') >= 0:
                        items = detail.split('^')
                        items[0]=items[0].strip()
                        if (items[0]== globalDes
                            or globalDes.find(items[0]) > 0
                            or items[0].find(globalDes) > 0):
                            fileNo=detail.split('^')[1]
                            result = re.search("(?P<name>([0-9]|\.)+).*", fileNo)
                            if result:
    #                            print result.groups()
                                fileNo = result.group('name')
                                break
                lineNo=lineNo+1
#            print ("globalName: %s, Des: %s, fileNo: %s, package: %s" %
#                   (globalName, globalDes, fileNo, packageName))
            if len(fileNo) == 0:
                if file not in skipFile:
                    print ("Warning: No FileNo found for file %s" % file)
                continue
            globalVar = Global(globalName,globalDes,
                               allPackages.get(packageName), fileNo)
            try:
                fileNum=float(globalVar.getFileNo())
            except ValueError, es:
                print ("error: %s, globalVar:%s file %s" % (es, globalVar,file))
                continue
#            crossReference.addGlobalToPackage(globalVar, packageName)
            # only add to allGlobals dict as we have to change the package later on
            if globalVar.getName() not in allGlobals:
                allGlobals[globalVar.getName()]=globalVar
            if fileNo not in fileNoSet:
                fileNoSet.add(fileNo)
            else:
                print ("Error, duplicated file No [%s,%s,%s,%s] file:%s " %
                       (fileNo, globalName,globalDes,packageName, file))
        zwrFile.close()
        print ("Total # of Packages is %d and Total # of Globals is %d, Total Skip File %d" %
               (len(allPackages), len(allGlobals), len(skipFile)))
        mappingFile=open("c:/users/jason.li/Downloads/docs/GlobalMapping.csv",'r')
        mappingNewFile=csv.writer(open("c:/users/jason.li/Downloads/docs/GlobalMappingNew.csv",'w'))
        result=csv.reader(mappingFile)
        for line in result:
#            line[-1] is the original package name, replace with the new one
            line[-1]=line[-1].upper()
            if line[-1] in packageNameMismatchDict:
                line[-1]=packageNameMismatchDict[line[-1]]
            # line[2] is the globalVar name
            line[2]=line[2].strip()
            line[2]=line[2].rstrip(", ")
            if line[2].endswith('('):
                line[2]=line[2].rstrip("(")

            globalVar=allGlobals.get(line[2])
            if not globalVar:
                for glbVar in allGlobals.itervalues():
                    if line[0] == glbVar.getFileNo():
                        if glbVar.getName().find(line[2]) >= 0:
                            globalVar=glbVar
                            line[2]=glbVar.getName()
                            break
                        else:
                            print ("Global Name mismatch: %s, %s" % (line[2], glbVar))
            if globalVar:
                if globalVar.getFileNo() != line[0]:
                    if float(globalVar.getFileNo()) != float(line[0]):
                        print ("Diff in file No. [%s],  [%s, %s, %s]" %
                               (line, globalVar, globalVar.getFileNo(), globalVar.getPackage()))
                        # fix the file #
                        if globalVar.getName().find(globalVar.getFileNo()) < 0:
                            globalVar.setFileNo(line[0])
                    else:
                        line[0]=globalVar.getFileNo()
                if (globalVar.getDescription() != line[1] and
                    globalVar.getFileNo() == line[0]):
#                        print ("Diff in Description [%s], [%s]" % (globalVar.getDescription(), line[1]))
#                        fix the description part (name)
                        line[1]=globalVar.getDescription()
                if (globalVar.getPackage().getName() != line[-1] and
                    globalVar.getPackage().getOriginalName() != line[-1]):
    #                    print ("Diff in package name [%s], [%s]" % (line[-1],globalVar.getPackage().getOriginalName()))
                    for package in self.crossReference.getAllPackages().itervalues():
                        if package.getOriginalName() == line[-1]:
                            oldPackage=globalVar.getPackage()
                            globalVar.setPackage(package)
                            break
            else:
                print line
            mappingNewFile.writerow(line)
        #sort the globals by the file #
        sortedKeyList=sorted(allGlobals.keys(),
                             key=lambda item: float(allGlobals[item].getFileNo()))
#        outputWriter=csv.writer(open("c:/users/jason.li/Downloads/docs/GlobalMappingGit.csv",'w'),)
        for key in sortedKeyList:
            globalVar = allGlobals[key]
            # fix the uncategoried item
            if globalVar.getFileNo() in packageFileNoDict:
                globalVar.setPackage(allPackages[packageFileNoDict[globalVar.getFileNo()]])
            crossReference.addGlobalToPackage(globalVar,
                                              globalVar.getPackage().getName())
#            outputWriter.writerow([globalVar.getFileNo(),
#                                   globalVar.getDescription(),
#                                   globalVar.getName(),
#                                   globalVar.getPackage().getOriginalName()])
    def parsePackageFile(self, packageFilename):
        packageFile=open(packageFilename,'r')
        result = csv.reader(packageFile)
        crossRef=self.crossReference
        # in the format of original name, primary namespace, additional namespace, addition globals, directory name
        currentPackage=None
        for line in result:
            if len(line[-1]) > 0:
                currentPackage=crossRef.getPackageByName(line[-1])
                if not currentPackage:
#                    print ("Warning, Package [%s] not found" % line[-1])
                    crossRef.addPackageByName(line[-1])
                currentPackage=crossRef.getPackageByName(line[-1])
                currentPackage.setOriginalName(line[0])
            else:
                if not currentPackage:
                    continue
            if len(line[1]):
                currentPackage.addNamespace(line[1])
            if len(line[2]):
                currentPackage.addNamespace(line[2])
            if len(line[3]):
                currentPackage.addGlobalNamespace(line[3])
        print ("Total # of Packages is %d" % (len(crossRef.getAllPackages())))
# end of class CallerGraphLogFileParser
if __name__ == '__main__':
    parser = CallerGraphLogFileParser()
    parser.parsePackageFile("C:/users/jason.li/git/VistA-FOIA/Packages.csv")
    parser.findGlobalsBySource("C:/users/jason.li/git/VistA-FOIA/Packages/", "*/Globals/*.zwr")
    parser.findPackagesAndRoutinesBySource("C:/users/jason.li/git/VistA-FOIA/Packages/", "*/Routines/*.m")
    parser.outputPackageCSVFile("C:/users/jason.li/git/VistA-FOIA/Packages_new.csv")
