#!/usr/bin/env python

# A Python model to represent the relationship between packages/globals/_routines
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
import sys
import types
from LogManager import logger
import csv
from operator import itemgetter, attrgetter
#some constants
NOT_KILLED_EXPLICITLY_VALUE = ">>"
UNKNOWN_PACKAGE = "UNKNOWN"
write = sys.stdout.write
MUMPS_ROUTINE_PREFIX = "Mumps"

BoolDict = {True:"Y", False:"N"}

def isUnknownPackage(packageName):
    return packageName == UNKNOWN_PACKAGE

LINE_OFFSET_DELIM = ","
#===============================================================================
# A Class to represent the variable in a _calledRoutine
#===============================================================================
class AbstractVariable:
    def __init__(self, name, prefix, lineOffsets):
        self._name = name
        self._prefix = prefix
        if prefix and prefix.strip() == NOT_KILLED_EXPLICITLY_VALUE:
            self._notKilledExp = True
        else:
            self._notKilledExp = False
        self._lineOffsets = lineOffsets.split(LINE_OFFSET_DELIM)
    def getName(self):
        return self._name
    def getNotKilledExp(self):
        return self._notKilledExp
    def setNotKilledExp(self, notKilledExp):
        self._notKilledExp = notKilledExp
    def appendLineOffsets(self, lineOffsets):
        self._lineOffsets.extend(lineOffsets)
    def getLineOffsets(self):
        return self._lineOffsets
    def getPrefix(self):
        return self._prefix
#===============================================================================
# Wrapper classes around the AbstractVariable, place holders
#===============================================================================
class LocalVariable(AbstractVariable):
    def __init__(self, name, prefix, cond):
        AbstractVariable.__init__(self, name, prefix, cond)
class GlobalVariable(AbstractVariable):
    def __init__(self, name, prefix, cond):
        AbstractVariable.__init__(self, name, prefix, cond)
class NakedGlobal(AbstractVariable):
    def __init__(self, name, prefix, cond):
        AbstractVariable.__init__(self, name, prefix, cond)
class MarkedItem(AbstractVariable):
    def __init__(self, name, prefix, cond):
        AbstractVariable.__init__(self, name, prefix, cond)
class LabelReference(AbstractVariable):
    def __init__(self, name, prefix, cond):
        AbstractVariable.__init__(self, name, prefix, cond)
#===============================================================================
#  A class to wrap up information about a VistA Routine
#===============================================================================
class Routine:
    #constructor
    def __init__(self, routineName, package=None):
        self._name = routineName
        self._localVariables = dict()
        self._globalVariables = dict()
        self._nakedGlobals = dict()
        self._markedItems = dict()
        self._labelReference = dict()
        self._calledRoutines = RoutineDepDict()
        self._callerRoutines = RoutineDepDict()
        self._refGlobals = dict()
        self._package = package
        self._totalCaller = 0
        self._totalCalled = 0
        self._comments = []
        self._originalName = routineName
        self._hasSourceCode = True
    def setName(self, routineName):
        self._name = routineName
    def getName(self):
        return self._name
    def setOriginalName(self, originalName):
        self._originalName = originalName
    def getOriginalName(self):
        return self._originalName
    def addComment(self, comment):
        self._comments.append(comment)
    def getComment(self):
        return self._comments
    def getTotalCaller(self):
        return self._totalCaller
    def getTotalCalled(self):
        return self._totalCalled
    def addLocalVariables(self, localVar):
        varName = localVar.getName()
        if varName not in self._localVariables:
            self._localVariables[varName] = localVar
        else:
            self._localVariables[varName].appendLineOffsets(
                                                localVar.getLineOffsets())
    def getLocalVariables(self):
        return self._localVariables
    def addGlobalVariables(self, GlobalVariable):
        varName = GlobalVariable.getName()
        if varName not in self._globalVariables:
            self._globalVariables[varName] = GlobalVariable
        else:
            self._globalVariables[varName].appendLineOffsets(GlobalVariable.getLineOffsets())
    def getGlobalVariables(self):
        return self._globalVariables
    def addReferredGlobal(self, globalVar):
        if globalVar.getName() not in self._refGlobals:
            self._refGlobals[globalVar.getName()] = globalVar
    def getReferredGlobal(self):
        return self._refGlobals
    def addNakedGlobals(self, NakedGlobal):
        varName = NakedGlobal.getName()
        if varName not in self._nakedGlobals:
            self._nakedGlobals[varName] = NakedGlobal
        else:
            self._nakedGlobals[varName].appendLineOffsets(NakedGlobal.getLineOffsets())
    def getNakedGlobals(self):
        return self._nakedGlobals
    def addMarkedItems(self, MarkedItem):
        varName = MarkedItem.getName()
        if varName not in self._markedItems:
            self._markedItems[varName] = MarkedItem
        else:
            self._markedItems[varName].appendLineOffsets(MarkedItem.getLineOffsets())
    def getMarkedItems(self):
        return self._markedItems
    def getLabelReferences(self):
        return self._labelReference
    def addLabelReference(self, LabelReference):
        varName = LabelReference.getName()
        if varName not in self._labelReference:
            self._labelReference[varName] = LabelReference
        else:
            self._labelReference[varName].appendLineOffsets(LabelReference.getLineOffsets())
    def getExternalReference(self):
        output = dict()
        for routineDict in self._calledRoutines.itervalues():
            for (routine, callTagDict) in routineDict.iteritems():
                routineName = routine.getName()
                for (callTag, lineOffsets) in callTagDict.iteritems():
                    output[(routineName, callTag)] = lineOffsets
        return output
    def addCallDepRoutines(self, depRoutine, callTag, lineOccurences, isCalled=True):
        if isCalled:
            depRoutines = self._calledRoutines
        else:
            depRoutines = self._callerRoutines
        package = depRoutine.getPackage()
        if package not in depRoutines:
            depRoutines[package] = dict()
        if depRoutine not in depRoutines[package]:
            depRoutines[package][depRoutine] = dict()
            if isCalled:
                self._totalCalled += 1
            else:
                self._totalCaller += 1
        if callTag not in depRoutines[package][depRoutine]:
            depRoutines[package][depRoutine][callTag] = lineOccurences.split(LINE_OFFSET_DELIM)
        else:
            depRoutines[package][depRoutine][callTag].extend(lineOccurences.split(LINE_OFFSET_DELIM))
    def addCalledRoutines(self, routine, callTag, lineOccurences):
        self.addCallDepRoutines(routine, callTag, lineOccurences, True)
        routine.addCallerRoutines(self, callTag, lineOccurences)
    def getCalledRoutines(self):
        return self._calledRoutines
    def addCallerRoutines(self, depRoutine, callTag, lineOccurences):
        self.addCallDepRoutines(depRoutine, callTag, lineOccurences, False)
    def getCallerRoutines(self):
        return self._callerRoutines
    def setPackage(self, package):
        self._package = package
    def getPackage(self):
        return self._package
    def isRenamed(self):
        return self._name != self._originalName
    def hasSourceCode(self):
        return self._hasSourceCode
    def setHasSourceCode(self, hasSourceCode):
        self._hasSourceCode = hasSourceCode
    def printVariables(self, name, variables):
        write("%s: \n" % name)
        allVars = sorted(variables.iterkeys())
        for varName in allVars:
            var = variables[varName]
            write("%s %s %s\n" % (var.getPrefix(), varName, var.getLineOffsets()))
        write("\n")
    def printExternalReference(self):
        write("External References:\n")
        output = self.getExternalReference()
        allVar = sorted(output.iterkeys(), key = itemgetter(0,1))
        for nameTag in allVar:
            value = output[nameTag]
            write("%s %s\n" % (nameTag[1]+"^"+nameTag[0],value))
        write("\n")
    def printCallRoutines(self, isCalledRoutine=True):
        if isCalledRoutine:
            callRoutines = self._calledRoutines
            title = "Called Routines:"
            write("%s: Total: %d\n" % (title, self._totalCalled))
        else:
            callRoutines = self._callerRoutines
            title = "Caller Routines:"
            write("%s: Total: %d\n" % (title, self._totalCaller))
        sortedDepRoutines = sorted(sorted(callRoutines.keys()),
                                 key=lambda item: len(callRoutines[item]),
                                 reverse=True)
        for package in sortedDepRoutines:
            write ("Package: %s Total: %d" % (package, len(callRoutines[package])))
            for (routine, tagDict) in callRoutines[package].iteritems():
                write(" %s " % routine)
                for (tag, lineOccurences) in tagDict.iteritems():
                        write("%s: %s\n" % (tag, lineOccurences))
        write("\n")
    def printResult(self):
        write ("Routine Name: %s\n" % (self._name))
        if self.isRenamed():
            write("Original Name: %s\n" % self._originalName)
        if self._package:
            write("Package Name: %s\n" % self._package.getName())
        write("Renamed: %s, hasSource: %s\n" % (self.isRenamed(),
                                              self.hasSourceCode()))
        self.printVariables("Global Vars", self._globalVariables)
        self.printVariables("Local Vars", self._localVariables)
        self.printVariables("Naked Globals", self._nakedGlobals)
        self.printVariables("Marked Globals", self._markedItems)
        self.printVariables("Label References", self._labelReference)
        self.printExternalReference()
        self.printCallRoutines(True)
        self.printCallRoutines(False)
    #===========================================================================
    # operator
    #===========================================================================
    def __str__(self):
        return self._name
    def __repr__(self):
        return "Routine: %s" % self._name
    def __eq__(self, other):
        if not isinstance(other, Routine):
            return False;
        return self._name == other._name
    def __lt__(self, other):
        if not isinstance(other, Routine):
            return False
        return self._name < other._name
    def __gt__(self, other):
        if not isinstance(other, Routine):
            return False
        return self._name > other._name
    def __le__(self, other):
        if not isinstance(other, Routine):
            return False
        return self._name <= other._name
    def __ge__(self, other):
        if not isinstance(other, Routine):
            return False
        return self._name >= other._name
    def __ne__(self, other):
        if not isinstance(other, Routine):
            return True
        return self._name != other._name
    def __hash__(self):
        return self._name.__hash__()
#===============================================================================
# # class to represent a platform dependent generic _calledRoutine
#===============================================================================
class PlatformDependentGenericRoutine(Routine):
    def __init__(self, routineName, package):
        Routine.__init__(self, routineName, package)
        self._platformRoutines = dict()
    def getComment(self):
        return ""
    def addLocalVariables(self, localVariables):
        pass
    def addNakedGlobals(self, globals):
        pass
    def addMarkedItems(self, markedItem):
        pass
    def addCalledRoutines(self, routine, tag=None):
        pass
    def hasSourceCode(self):
        return False
    def printVariables(self, name, variables):
        pass
    def addPlatformRoutines(self, mappingList):
        for item in mappingList:
            if item[0] not in self._platformRoutines:
                self._platformRoutines[item[0]] = [Routine(item[0], self._package),
                                                   item[1]]
    # return a list of two elements, first is the Routine, second is the platform name
    def getPlatformDepRoutineInfoByName(self, routineName):
        return self._platformRoutines.get(routineName, [None, None])
    def getAllPlatformDepRoutines(self):
        return self._platformRoutines
#===============================================================================
# # class to represent a global variable
#===============================================================================
class Global:
    #constructor
    def __init__(self, globalName,
                 description=None,
                 package=None,
                 fileNo=None):
        self._name = globalName
        self._description = description
        self._package = package
        self._references = dict() # accessed by routines
        self._totalReferenced = 0
        self._fileNo = fileNo
    def setName(self, globalName):
        self._name = globalName
    def getName(self):
        return self._name
    def getAllReferencedRoutines(self):
        return self._references
    def addReferencedRoutine(self, routine):
        if not routine:
            return
        package = routine.getPackage()
        if not package:
            return
        if package not in self._references:
            self._references[package] = set()
        self._references[package].add(routine)
        self._totalReferenced = self._totalReferenced + 1
    def getReferredRoutineByPackage(self, package):
        return self._references.get(package)
    def setPackage(self, package):
        self._package = package
    def setDescription(self, description):
        self._description = description
    def setFileNo(self, fileNo):
        self._fileNo = fileNo
    def getFileNo(self):
        return self._fileNo
    def getDescription(self):
        return self._description
    def getPackage(self):
        return self._package
    def printResult(self):
        write("Name:[%s], FileNo:[%s]: Des:[%s], Package:[%s]\n" %
              (self._name, self._fileNo, self._description, self._package))
        write("Referenced By:\n")
        for (package, routineSet) in self._references.iteritems():
            write("Package: %s " % package)
            for routine in routineSet:
                write(" %s" % routine)
            write("\n")
    #===========================================================================
    # operator
    #===========================================================================
    def __str__(self):
        return self._name
    def __repr__(self):
        return "Global: %s" % self._name
    def __eq__(self, other):
        if not isinstance(other, Global):
            return False;
        return self._name == other._name
    def __lt__(self, other):
        if not isinstance(other, Global):
            return False
        return self._name < other._name
    def __gt__(self, other):
        if not isinstance(other, Global):
            return False
        return self._name > other._name
    def __le__(self, other):
        if not isinstance(other, Global):
            return False
        return self._name <= other._name
    def __ge__(self, other):
        if not isinstance(other, Global):
            return False
        return self._name >= other._name
    def __ne__(self, other):
        if not isinstance(other, Global):
            return True
        return self._name != other._name
    def __hash__(self):
        return self._name.__hash__()
#===============================================================================
# # class to represent a VistA _package
#===============================================================================
class Package:
    #constructor
    def __init__(self, packageName):
        self._name = packageName
        self._routines = dict()
        self._globals = dict()
        self._namespaces = []
        self._globalNamespace = []
        self._routineDependencies = dict()
        self._routineDependents = dict()
        self._globalDependencies = dict()
        self._globalDependents = dict()
        self._origName = packageName
        self._docLink = ""
        self._docMirrorLink = ""
    def addRoutine(self, Routine):
        self._routines[Routine.getName()] = Routine
        Routine.setPackage(self)
    def addGlobal(self, globalVar):
        self._globals[globalVar.getName()] = globalVar
        globalVar.setPackage(self)
    def removeGloal(self, globalVar):
        self._globals.pop(globalVar.getName())
    def getAllRoutines(self):
        return self._routines
    def getAllGlobals(self):
        return self._globals
    def getRoutine(self, routineName):
        return self._routines.get[routineName]
    def hasRoutine(self, routineName):
        return routineName in self._routines
    def getName(self):
        return self._name
    def getOriginalName(self):
        return self._origName
    def setOriginalName(self, origName):
        self._origName = origName
    def generatePackageDependencies(self):
        for routine in self._routines.itervalues():
            calledRoutines = routine.getCalledRoutines()
            for package in calledRoutines.iterkeys():
                if package and package != self and package._name != UNKNOWN_PACKAGE:
                    if package not in self._routineDependencies:
                        # the first set consists of all caller _calledRoutine in the self package
                        # the second set consists of all called routines in dependency package
                        self._routineDependencies[package] = (set(), set())
                    self._routineDependencies[package][0].add(routine)
                    self._routineDependencies[package][1].update(calledRoutines[package])
                    if self not in package._routineDependents:
                        # the first set consists of all called _calledRoutine in the package
                        # the second set consists of all caller routines in that package
                        package._routineDependents[self] = (set(), set())
                    package._routineDependents[self][0].add(routine)
                    package._routineDependents[self][1].update(calledRoutines[package])
            referredGlobals = routine.getReferredGlobal()
            for globalVar in referredGlobals.itervalues():
                package = globalVar.getPackage()
                if package != self and package._name != UNKNOWN_PACKAGE:
                    if package not in self._globalDependencies:
                        self._globalDependencies[package] = (set(), set())
                    self._globalDependencies[package][0].add(routine)
                    self._globalDependencies[package][1].add(globalVar)
                    if self not in package._globalDependents:
                        package._globalDependents[self] = (set(), set())
                    package._globalDependents[self][0].add(routine)
                    package._globalDependents[self][1].add(globalVar)
    def getPackageRoutineDependencies(self):
        return self._routineDependencies
    def getPackageRoutineDependents(self):
        return self._routineDependents
    def getPackageGlobalDependencies(self):
        return self._globalDependencies
    def getPackageGlobalDependents(self):
        return self._globalDependents
    def addNamespace(self, namespace):
        self._namespaces.append(namespace)
    def addNamespaceList(self, namespaceList):
        self._namespaces.extend(namespaceList)
    def getNamespaces(self):
        return self._namespaces
    def addGlobalNamespace(self, namespace):
        self._globalNamespace.append(namespace)
    def getGlobalNamespace(self):
        return self._globalNamespace
    def getDocLink(self):
        return self._docLink
    def getDocMirrorLink(self):
        return self._docMirrorLink
    def setDocLink(self, docLink):
        self._docLink = docLink
    def setMirrorLink(self, docMirrorLink):
        self._docMirrorLink = docMirrorLink
    def printRoutineDependency(self, dependencyList=True):
        if dependencyList:
            header = "Routine Dependencies list"
            depPackages = self._routineDependencies
        else:
            header = "Routine Dependents list"
            depPackages = self._routineDependents
        write("Package %s: \n" % header)
        for package, depRoutineTuple in depPackages.iteritems():
            write(" %s: Total caller Routines: %d [ " % (package, len(depRoutineTuple[0])))
            for routine in depRoutineTuple[0]:
                write (" %s " % (routine))
            write("]\n")
            write(" %s: Total called Rouintes: %d [ " % (package, len(depRoutineTuple[1])))
            for routine in depRoutineTuple[1]:
                write (" %s " % (routine))
            write("]\n")
        write("\n")
    def printGlobalDependency(self, dependencyList=True):
        if dependencyList:
            header = "Global Dependencies list"
            depPackages = self._globalDependencies
        else:
            header = "Global Dependents list"
            depPackages = self._globalDependents
        write("Package %s: \n" % header)
        for package, depGlobalTuple in depPackages.iteritems():
            write(" %s: Total Caller Routines: %d [ " % (package, len(depGlobalTuple[0])))
            for globalVar in depGlobalTuple[0]:
                write (" %s " % (globalVar))
            write("]\n")
            write(" %s: Total Referred Globals: %d [ " % (package, len(depGlobalTuple[1])))
            for globalVar in depGlobalTuple[1]:
                write (" %s " % (globalVar))
            write("]\n")
        write("\n")
    def printResult(self):
        write("Package :%s, total Num of Routines: %d, Total Num of Globals: %d\n" %
              (self, len(self._routines), len(self._globals)))
        if len(self._origName) > 0:
            write("Original Name is: %s\n" % self._origName)
        if len(self._namespaces) > 0:
            write("Namespaces: ")
            for namespace in self._namespaces:
                write(" [%s]" % namespace)
            write("\n")
        if len(self._globalNamespace) > 0:
            write("Global Namespaces:")
            for namespace in self._globalNamespace:
                write(" [%s]" % namespace)
            write("\n")
        self.printRoutineDependency(True)
        self.printRoutineDependency(False)
        self.printGlobalDependency(True)
        self.printGlobalDependency(False)
    #===========================================================================
    # operator
    #===========================================================================
    def __str__(self):
        return self._name
    def __repr__(self):
        return "Package: %s" % self._name
    def __eq__(self, other):
        if not isinstance(other, Package):
            return False;
        return self._name == other._name
    def __lt__(self, other):
        if not isinstance(other, Package):
            return False
        return self._name < other._name
    def __gt__(self, other):
        if not isinstance(other, Package):
            return False
        return self._name > other._name
    def __le__(self, other):
        if not isinstance(other, Package):
            return False
        return self._name <= other._name
    def __ge__(self, other):
        if not isinstance(other, Package):
            return False
        return self._name >= other._name
    def __ne__(self, other):
        if not isinstance(other, Package):
            return True
        return self._name != other._name
    def __hash__(self):
        return self._name.__hash__()
##===============================================================================
## Class represent a detailed call info NOT USED
##===============================================================================
class RoutineCallDetails:
    def __init__(self, callTag, lineOccurences):
        self._callDetails = callTag
        self._lineOccurences = []
        lineOccurs = lineOccurences.split(LINE_OFFSET_DELIM)
        self._lineOccurences.extend(lineOccurs)
        self._isExtrinsic = callTag.startswith("$$")
    def getCallTag(self):
        return self._callDetails
    def getLineOccurence(self):
        return self._lineOccurences
    def isExtrinsic(self):
        return self._isExtrinsic
    def appendLineOccurence(self, lineOccurences):
        self._lineOccurences.extend(lineOccurences)
#===============================================================================
# A Class represent the call information between routine and called routine
#===============================================================================
class RoutineCallInfo(dict):
    def addCallDetail(self, callTag, lineOccurences):
        if callTag not in self:
            self[callTag] = lineOccurences.split(LINE_OFFSET_DELIM)
        else:
            self[callTag].extend(lineOccurences.split(LINE_OFFSET_DELIM))
#===============================================================================
# A Class represent all called/caller _calledRoutine Dictionary
#===============================================================================
class RoutineDepDict(dict):
    '''
    placeholder
    '''
#===============================================================================
# A class represents _package dependency between two packages based on call _routines
#===============================================================================
class PackageDependencyRoutineList(dict):
    def __init__(self):
        pass
#===============================================================================
# A Wrapper class represents all Cross Reference Information
#===============================================================================
class CrossReference:
    def __init__(self):
        self._allPackages = dict()
        self._allRoutines = dict()
        self._orphanRoutines = set()
        self._allGlobals = dict()
        self._orphanGlobals = set()
        self._percentRoutine = set()
        self._percentRoutineMapping = dict()
        self._renameRoutines = dict()
        self._mumpsRoutines = set()
        self._platformDepRoutines = dict() # [name, package, mapping list]
        self._platformDepRoutineMappings = dict() # [platform dep _calledRoutine -> generic _calledRoutine]
    def getAllRoutines(self):
        return self._allRoutines
    def getAllPackages(self):
        return self._allPackages
    def getOrphanRoutines(self):
        return self._orphanRoutines
    def getAllGlobals(self):
        return self._allGlobals
    def getOrphanGlobals(self):
        return self._orphanGlobals
    def hasPackage(self, packageName):
        return packageName in self._allPackages
    def hasRoutine(self, routineName):
        return routineName in self._allRoutines
    def hasGlobal(self, globalName):
        return globalName in self._allGlobals
    def addPackageByName(self, packageName):
        if not self.hasPackage(packageName):
            self._allPackages[packageName] = Package(packageName)
    def addRoutineByName(self, routineName):
        if not self.hasRoutine(routineName):
            self._allRoutines[routineName] = Routine(routineName)
    def addGlobalByName(self, globalName):
        if not self.hasGlobal(globalName):
            self._allGlobals[globalName] = Global(globalName)
    def getRoutineByName(self, routineName):
        if self.isPlatformDependentRoutineByName(routineName):
            return self.getPlatformDependentRoutineByName(routineName)
        return self._allRoutines.get(routineName)
    def getPackageByName(self, packageName):
        return self._allPackages.get(packageName)
    def getGlobalByName(self, globalName):
        return self._allGlobals.get(globalName)
    def addRoutineToPackageByName(self, routineName, packageName, hasSourceCode=True):
        if packageName not in self._allPackages:
            self._allPackages[packageName] = Package(packageName)
        if routineName not in self._allRoutines:
            self._allRoutines[routineName] = Routine(routineName)
        routine = self._allRoutines[routineName]
        if not hasSourceCode:
            routine.setHasSourceCode(hasSourceCode)
        self._allPackages[packageName].addRoutine(routine)
    def addGlobalToPackageByName(self, globalName, packageName):
        if packageName not in self._allPackages:
            self._allPackages[packageName] = Package(packageName)
        if globalName not in self._allGlobals:
            self._allGlobals[globalName] = Global(globalName)
        self._allPackages[packageName].addGlobalToPackage(self._allGlobals[globalName])
    def addGlobalToPackage(self, globalVar, packageName):
        if packageName not in self._allPackages:
            self._allPackages[packageName] = Package(packageName)
        if globalVar.getName() not in self._allGlobals:
            self._allGlobals[globalVar.getName()] = globalVar
        self._allPackages[packageName].addGlobal(globalVar)
    def addToOrphanRoutinesByName(self, routineName):
        if not self.hasRoutine(routineName):
            self._orphanRoutines.add(routineName)
    def addToOrphanGlobalByName(self, globalName):
        if not self.hasGlobal(globalName):
            self._orphanGlobals.add(globalName)
    def addRoutineCommentByName(self, routineName, comment):
        routine = self.getRoutineByName(routineName)
        if routine:
            routine.setComment(comment)
    def addPercentRoutine(self, routineName):
        self._percentRoutine.add(routineName)
    def getAllPercentRoutine(self):
        return self._percentRoutine
    # this should be called after we have all the call graph information
    def addPercentRoutineMapping(self, routineName,
                                mappingRoutineName,
                                mappingPackage):
        if routineName not in self._percentRoutineMapping:
            self._percentRoutineMapping[routineName] = []
        self._percentRoutineMapping[routineName].append(mappingRoutineName)
        self._percentRoutineMapping[routineName].append(mappingPackage)
        if len(mappingRoutineName) > 0:
            self._renameRoutines[mappingRoutineName] = routineName
        elif mappingPackage.startswith(MUMPS_ROUTINE_PREFIX):
            self._mumpsRoutines.add(routineName)
    def getPercentRoutineMapping(self):
        return self._percentRoutineMapping
    def routineNeedRename(self, routineName):
        return routineName in self._renameRoutines
    def getRenamedRoutineName(self, routineName):
        return self._renameRoutines.get(routineName)
    def isMumpsRoutine(self, routineName):
        return routineName in self._mumpsRoutines
    def addPlatformDependentRoutineMapping(self, routineName,
                                           packageName,
                                           mappingList):
        if routineName not in self._platformDepRoutines:
            routine = PlatformDependentGenericRoutine(routineName,
                                                      self.getPackageByName(packageName))
            self._platformDepRoutines[routineName] = routine
        routine = self._platformDepRoutines[routineName]
        routine.addPlatformRoutines(mappingList)
        self._allRoutines[routineName] = routine
        self._allPackages[packageName].addRoutine(routine)
        for item in mappingList:
            self._platformDepRoutineMappings[item[0]] = routineName
    def isPlatformDependentRoutineByName(self, routineName):
        return routineName in self._platformDepRoutineMappings
    def isPlatformGenericRoutineByName(self, routineName):
        return routineName in self._platformDepRoutines
    def getGenericPlatformDepRoutineNameByName(self, routineName):
        return self._platformDepRoutineMappings.get(routineName)
    def getGenericPlatformDepRoutineByName(self, routineName):
        genericName = self._platformDepRoutineMappings.get(routineName)
        if genericName:
            return self._platformDepRoutines[genericName]
        return None
    def getPlatformDependentRoutineByName(self, routineName):
        genericRoutine = self.getGenericPlatformDepRoutineByName(routineName)
        if genericRoutine:
            assert isinstance(genericRoutine, PlatformDependentGenericRoutine)
            return genericRoutine.getPlatformDepRoutineInfoByName(routineName)[0]
        return None
    # should be using trie structure for quick find, but
    # as python does not have trie and seems to be OK now
    def categorizeRoutineByNamespace(self, routineName):
        for package in self._allPackages.itervalues():
            hasMatch = False
            matchNamespace = ""
            for namespace in package.getNamespaces():
                if routineName.startswith(namespace):
                    hasMatch = True
                    matchNamespace = namespace
                if namespace.startswith("!"):
                    if not hasMatch:
                        break
                    elif routineName.startswith(namespace[1:]):
                        hasMatch = False
                        matchNamespace = ""
                        break
            if hasMatch:
                return (matchNamespace, package)
        return (None, None)
    def categorizeGlobalByNamespace(self, globalName):
        pass
    def routineHasSourceCodeByName(self, routineName):
        routine = self.getRoutineByName(routineName)
        return routine and routine.hasSourceCode()
    def __generatePlatformDependentRoutineDependencies__(self):
        for genericRoutine in self._platformDepRoutines.itervalues():
            genericRoutine.setHasSourceCode(False)
            callerRoutines = genericRoutine.getCallerRoutines()
            for routineDict in callerRoutines.itervalues():
                for routine in routineDict.keys():
                    routineName = routine.getName()
                    if self.isPlatformDependentRoutineByName(routineName):
                        value = routineDict.pop(routine)
                        newRoutine = self.getGenericPlatformDepRoutineByName(routineName)
                        routineDict[newRoutine] = value
    def __fixPlatformDependentRoutines__(self):
        for routineName in self._platformDepRoutineMappings:
            if routineName in self._allRoutines:
                logger.info("Removing Routine: %s" % routineName)
                self._allRoutines.pop(routineName)
    def generateAllPackageDependencies(self):
        self.__fixPlatformDependentRoutines__()
        self.__generatePlatformDependentRoutineDependencies__()
        for package in self._allPackages.itervalues():
            package.generatePackageDependencies()

def testPackage():
    packageA = Package("A")
    packageB = Package("B")
    anotherA = Package("A")
    routineA = Routine("A")
    assert isinstance(packageA, Package)
    assert not isinstance(routineA, Package)
    assert packageA != packageB
    assert packageA == anotherA
    assert routineA != packageA

def testRoutine():
    #===========================================================================
    # Test Routine operator overrides
    #===========================================================================
    RoutineA = Routine("A")
    RoutineB = Routine("B")
    anotherA = Routine("A")
    packageA = Package("A")
    assert isinstance(RoutineA, Routine)
    assert not isinstance(packageA, Routine)
    assert not RoutineA == RoutineB
    assert RoutineA != RoutineB
    assert RoutineA == anotherA
    assert not packageA == RoutineA
    #===========================================================================
    # Test Routine
    #===========================================================================
    packageA = Package("Imaging")
    packageB = Package("VA FileMan")
    rMAGDHWA = Routine("MAGDHWA", packageA)
    # add local variables
    lVar = LocalVariable("DEL", ">> ",
                         "MSH+1,MSH+2,MSH+3,PID+5,PID+13,PID+14,PID+18,PID+19,PID+20,PID+21,PID+22,PID+23,PID+24,PID+32,PID+35,PID+37,PID+39")
    rMAGDHWA.addLocalVariables(lVar)
    lVar = LocalVariable("DEL", ">> ",
                          "PID+41,PID+43,PID+45,ORC+5,ORC+8,ORC+10,OBR+3,OBR+5,OBR+8,OBR+12,OBR+19,OBR+23,OBR+28,OBR+32,OBR+37,ZSV+3,ZSV+4")
    rMAGDHWA.addLocalVariables(lVar)
    lVar = LocalVariable("DEL", ">> ", "ALLERGY+5")
    print ("lineOffsets: %s"  % lVar.getLineOffsets())
    rMAGDHWA.addLocalVariables(lVar)
    lVar = LocalVariable("DEL", ">> ", "ALLERGY+7,POSTINGS+7,POSTINGS+9")
    print ("lineOffsets: %s"  % lVar.getLineOffsets())
    rMAGDHWA.addLocalVariables(lVar)
    # add global variables
    gVar = GlobalVariable("^MAG(2006.5839","   ", "NEWTIU+5,NEWTIU+6,NEWTIU+17!,NEWTIU+18,NEWTIU+19*,NEWTIU+20")
    gVar1 = GlobalVariable('''^%ZOSF("TRAP"''',"   ", "TIUXLINK+11")
    rMAGDHWA.addGlobalVariables(gVar)
    rMAGDHWA.addGlobalVariables(gVar1)
    # add called routines
    calledRoutine = Routine("DIQ", packageB)
    lineOccurences = '''ORC+8,OBR+4,OBR+5,OBR+7,OBR+8,OBR+10,OBR+16,OBR+27,OBR+28,OBR+36,OBR+37'''
    rMAGDHWA.addCalledRoutines(calledRoutine, "$$GET1", lineOccurences)

    calledRoutine = Routine("VADPT", Package("Registration"))
    lineOccurences = "PID+7"
    rMAGDHWA.addCalledRoutines(calledRoutine, "ADD", lineOccurences)
    rMAGDHWA.addCalledRoutines(calledRoutine, "DEM", lineOccurences)
    rMAGDHWA.addCalledRoutines(calledRoutine, "INP", lineOccurences)

    rMAGDHWA.printResult()

def testGlobal():
    globalA = Global("A")
    globalB = Global("B")
    anotherA = Global("A")
    routineA = Routine("A")
    assert isinstance(globalA, Global)
    assert not isinstance(routineA, Global)
    assert globalA != globalB
    assert globalA == anotherA
    assert routineA != globalA

def testParsePlatformDependentRoutines(fileName):
    routineFile = open(fileName, "rb")
    sniffer = csv.Sniffer()
    dialect = sniffer.sniff(routineFile.read(128))
    routineFile.seek(0)
    hasHeader = sniffer.has_header(routineFile.read(128))
    routineFile.seek(0)
    result = csv.reader(routineFile, dialect)
    currentName = ""
    routineDict = dict()
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
    print ("Total # is %d" % len(routineDict))
    for (routine, platform) in routineDict.iteritems():
        print ("Routine: %s, Package %s" % (routine, platform[0]))
        print ("Total platform: %d %s" % (len(platform[1:]), platform[1:]))
#===============================================================================
# Test Constants
#===============================================================================
PLATFORM_DEPENDENT_ROUTINE_CSV = "C:/Users/jason.li/git/OSEHRA-Automated-Testing/Dox/PlatformDependentRoutine.csv"
#===============================================================================
# Main _calledRoutine
#===============================================================================
if __name__ == '__main__':
    testPackage()
    testRoutine()
    testGlobal()
#    testParsePlatformDependentRoutines(PLATFORM_DEPENDENT_ROUTINE_CSV)