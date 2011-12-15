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
#some constants
NOT_KILLED_EXPLICITLY_VALUE = ">>"
NOT_KILLED_EXPLICITLY_NAME = "not _killed explicitly"
CHANGED_VALUE = "*"
CHANGED_NAME = "Changed"
KILLED_VALUE = "!"
KILLED_NAME = "Killed"
NEWED_VALUE = "~"
NEWED_NAME = "Newed"

UNKNOWN_PACKAGE = "UNKNOWN"
write = sys.stdout.write

BoolDict={True:"Y",False:"N"}

def isUnknownPackage(packageName):
    return packageName == UNKNOWN_PACKAGE

#===============================================================================
# A Class to represent the variable in a routine
#===============================================================================
class AbstractVariable:
    def __init__(self, name, prefix, cond):
        self._name = name
        if prefix and (prefix.strip() == NOT_KILLED_EXPLICITLY_VALUE):
            self._notKilledExp = True
        else:
            self._notKilledExp = False
        self._changed = False
        self._newed = False
        self._killed = False
        if cond:
            if cond.find(NEWED_VALUE) != -1:
                self._newed = True
            if cond.find(CHANGED_VALUE) != -1:
                self._changed = True
            if cond.find(KILLED_VALUE) != -1:
                self._killed = True
    def getName(self):
        return self._name
    def getKilled(self):
        return self._killed
    def setKilled(self, killed):
        self._killed = killed
    def getNewed(self):
        return self._newed
    def setNewed(self, newed):
        self._newed = newed
    def getChanged(self):
        return self._changed
    def setChanged(self, changed):
        self._changed = changed
    def getNotKilledExp(self):
        return self._notKilledExp
    def setNotKilledExp(self, notKilledExp):
        self._notKilledExp = notKilledExp
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
#===============================================================================
#  A class to wrap up information about a VistA Routine
#===============================================================================
class Routine:
    #constructor
    def __init__(self, routineName, package=None):
        self._name = routineName
        self._localVariables = []
        self._globalVariables = []
        self._nakedGlobals = []
        self._markedItems = []
        self._calledRoutines = RoutineCallDict()
        self._callerRoutines = RoutineCallDict()
        self._refGlobals=dict()
        self._package = package
        self._totalCaller=0
        self._totalCalled=0
        self._comment=[]
    def setName(self, routineName):
        self._name = routineName
    def getName(self):
        return self._name
    def addComment(self, comment):
        self._comment.append(comment)
    def getComment(self):
        return self._comment
    def getTotalCaller(self):
        return self._totalCaller
    def getTotalCalled(self):
        return self._totalCalled
    def addLocalVariables(self, localVariables):
        self._localVariables.append(localVariables)
    def getLocalVariables(self):
        return self._localVariables
    def addGlobalVariables(self, globalVariables):
        self._globalVariables.append(globalVariables)
    def getGlobalVariables(self):
        return self._globalVariables
    def addReferredGlobal(self, globalVar):
        if globalVar.getName() not in self._refGlobals:
            self._refGlobals[globalVar.getName()]=globalVar
    def getReferredGlobal(self):
        return self._refGlobals
    def addNakedGlobals(self, globals):
        self._nakedGlobals.append(globals)
    def getNakedGlobals(self):
        return self._nakedGlobals
    def addMarkedItems(self, markedItem):
        self._markedItems.append(markedItem)
    def getMarkedItems(self):
        return self._markedItems
    def addCallDepRoutines(self, routine, tag, isCalled=True):
        if isCalled:
            depRoutines=self._calledRoutines
        else:
            depRoutines=self._callerRoutines
        routinePackage=routine.getPackage()
        if routinePackage not in depRoutines:
            depRoutines[routinePackage]=dict()
        if routine not in depRoutines[routinePackage]:
            depRoutines[routinePackage][routine]=[]
            if isCalled:
                self._totalCalled+=1
            else:
                self._totalCaller+=1
        # tag only applies to called routine.
        if isCalled and tag and len(tag) > 0 and tag not in depRoutines[routinePackage][routine]:
            depRoutines[routinePackage][routine].append(tag)
    def addCalledRoutines(self, routine, tag=None):
        self.addCallDepRoutines(routine, tag, True)
        routine.addCallerRoutines(self, tag)
    def getCalledRoutines(self):
        return self._calledRoutines
    def addCallerRoutines(self, routine, tag=None):
        self.addCallDepRoutines(routine, tag, False)
    def getCallerRoutines(self):
        return self._callerRoutines
    def setPackage(self, package):
        self._package = package
    def getPackage(self):
        return self._package
    def printVariables(self, name, variables):
        write("%s: \n" % name)
        for var in variables:
            write("%s:%s Name:%s %s:%s %s:%s %s:%s\n" % (NOT_KILLED_EXPLICITLY_NAME, var.getNotKilledExp(),
                                                       var.getName(),
                                                       KILLED_NAME, BoolDict[var.getKilled()],
                                                       CHANGED_NAME, BoolDict[var.getChanged()],
                                                       NEWED_NAME, BoolDict[var.getNewed()]))
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
        sortedDepRoutines=sorted(sorted(callRoutines.keys()),
                                 key=lambda item: len(callRoutines[item]),
                                 reverse=True)
        for package in sortedDepRoutines:
            write ("Package: %s Total: %d" % (package, len(callRoutines[package])))
            for (routine, tags) in callRoutines[package].iteritems():
                write(" %s " % routine)
                if len(tags) > 0:
                    write(str(tags))
            write("\n")
        write("\n")
    def printResult(self):
        write ("Routine Name: %s\n" % (self._name))
        write("Package Name: %s\n" % self._package.getName())
        self.printVariables("Global Vars", self._globalVariables)
        self.printVariables("Local Vars", self._localVariables)
        self.printVariables("Naked Globals", self._nakedGlobals)
        self.printVariables("Marked Globals", self._markedItems)
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
        if not isinstance(other,Routine):
            return False;
        return self._name == other._name
    def __lt__(self, other):
        if not isinstance(other,Routine):
            return False
        return self._name < other._name
    def __gt__(self, other):
        if not isinstance(other,Routine):
            return False
        return self._name > other._name
    def __le__(self, other):
        if not isinstance(other,Routine):
            return False
        return self._name <= other._name
    def __ge__(self, other):
        if not isinstance(other,Routine):
            return False
        return self._name >= other._name
    def __ne__(self, other):
        if not isinstance(other,Routine):
            return True
        return self._name != other._name
    def __hash__(self):
        return self._name.__hash__()
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
        self._description=description
        self._package = package
        self._references = dict() # accessed by routines
        self._totalReferenced=0
        self._fileNo=fileNo
    def setName(self, globalName):
        self._name=globalName
    def getName(self):
        return self._name
    def getAllReferencedRoutines(self):
        return self._references
    def addReferencedRoutine(self, routine):
        if not routine:
            return
        package=routine.getPackage()
        if not package:
            return
        if package not in self._references:
            self._references[package]=set()
        self._references[package].add(routine)
        self._totalReferenced=self._totalReferenced+1
    def getReferredRoutineByPackage(self, package):
        return self._references.get(package)
    def setPackage(self, package):
        self._package=package
    def setDescription(self, description):
        self._description = description
    def setFileNo(self, fileNo):
        self._fileNo=fileNo
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
        if not isinstance(other,Global):
            return False;
        return self._name == other._name
    def __lt__(self, other):
        if not isinstance(other,Global):
            return False
        return self._name < other._name
    def __gt__(self, other):
        if not isinstance(other,Global):
            return False
        return self._name > other._name
    def __le__(self, other):
        if not isinstance(other,Global):
            return False
        return self._name <= other._name
    def __ge__(self, other):
        if not isinstance(other,Global):
            return False
        return self._name >= other._name
    def __ne__(self, other):
        if not isinstance(other,Global):
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
        self._globals=dict()
        self._namespaces=[]
        self._globalNamespace=[]
        self._routineDependencies = dict()
        self._routineDependents = dict()
        self._globalDependencies = dict()
        self._globalDependents = dict()
        self._origName=packageName
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
                if package != self and package._name != UNKNOWN_PACKAGE:
                    if package not in self._routineDependencies:
                        # the first set consists of all caller routine in the self package
                        # the second set consists of all called routines in dependency package
                        self._routineDependencies[package] = (set(),set())
                    self._routineDependencies[package][0].add(routine)
                    self._routineDependencies[package][1].update(calledRoutines[package])
                    if self not in package._routineDependents:
                        # the first set consists of all called routine in the package
                        # the second set consists of all caller routines in that package
                        package._routineDependents[self] = (set(),set())
                    package._routineDependents[self][0].add(routine)
                    package._routineDependents[self][1].update(calledRoutines[package])
            referredGlobals = routine.getReferredGlobal()
            for globalVar in referredGlobals.itervalues():
                package = globalVar.getPackage()
                if package !=self and package._name != UNKNOWN_PACKAGE:
                    if package not in self._globalDependencies:
                        self._globalDependencies[package]=(set(),set())
                    self._globalDependencies[package][0].add(routine)
                    self._globalDependencies[package][1].add(globalVar)
                    if self not in package._globalDependents:
                        package._globalDependents[self]=(set(),set())
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
        if not isinstance(other,Package):
            return False;
        return self._name == other._name
    def __lt__(self, other):
        if not isinstance(other,Package):
            return False
        return self._name < other._name
    def __gt__(self, other):
        if not isinstance(other,Package):
            return False
        return self._name > other._name
    def __le__(self, other):
        if not isinstance(other,Package):
            return False
        return self._name <= other._name
    def __ge__(self, other):
        if not isinstance(other,Package):
            return False
        return self._name >= other._name
    def __ne__(self, other):
        if not isinstance(other,Package):
            return True
        return self._name != other._name
    def __hash__(self):
        return self._name.__hash__()
#===============================================================================
# A Class represent the Routine call information NOT USED
#===============================================================================
class RoutineCallerInfo:
    def __init__(self, routine, tag):
        self.routine = routine
        self.callTag = tag
    def getRoutine(self):
        return self.routine
    def getCallTag(self):
        return self.callTag
    def __eq__(self, other):
        if not isinstance(other,RoutineCallerInfo):
            return False
        return (self.routine == other.routine) \
            and (self.tag == other.tag)
    def __ne__(self, other):
        if not isinstance(other,RoutineCallerInfo):
            return True
        return (self.routine != other.routine) \
            or (self.tag != other.tag)
    def __gt__(self, other):
        if not isinstance(other,RoutineCallerInfo):
            return False
        if self.routine == other.routine:
            return self.tag > other.tag
        return self.routine > other.routine
    def __lt__(self, other):
        if not isinstance(other,RoutineCallerInfo):
            return False
        if self.routine == other.routine:
            return self.tag < other.tag
        return self.routine < other.routine
    def __ge__(self, other):
        if not isinstance(other,RoutineCallerInfo):
            return False
        if self.routine == other.routine:
            return self.tag >= other.tag
        return self.routine >= other.routine
    def __lt__(self, other):
        if not isinstance(other,RoutineCallerInfo):
            return False
        if self.routine == other.routine:
            return self.tag <= other.tag
        return self.routine <= other.routine
#===============================================================================
# A Class represent All call/caller routine Set
#===============================================================================
class RoutineCallDict(dict):
    def __init__(self):
        pass
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
        self._percentageRoutine=set()
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
        return self._allRoutines.get(routineName)
    def getPackageByName(self, packageName):
        return self._allPackages.get(packageName)
    def getGlobalByName(self, globalName):
        return self._allGlobals.get(globalName)
    def addRoutineToPackageByName(self, routineName, packageName):
        if packageName not in self._allPackages:
            self._allPackages[packageName] = Package(packageName)
        if routineName not in self._allRoutines:
            self._allRoutines[routineName] = Routine(routineName)
        self._allPackages[packageName].addRoutine(self._allRoutines[routineName])
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
    def addRoutineCommentByName(self,routineName, comment):
        routine=self.getRoutineByName(routineName)
        if routine:
            routine.setComment(comment)
    def addPercentageRoutine(self,routineName):
        self._percentageRoutine.add(routineName)
    def getAllPercentageRoutine(self):
        return self._percentageRoutine
def testPackage():
    packageA=Package("A")
    packageB=Package("B")
    anotherA=Package("A")
    routineA=Routine("A")
    assert isinstance(packageA, Package)
    assert not isinstance(routineA,Package)
    assert packageA != packageB
    assert packageA == anotherA
    assert routineA !=packageA

def testRoutine():
    RoutineA=Routine("A")
    RoutineB=Routine("B")
    anotherA=Routine("A")
    packageA=Package("A")
    assert isinstance(RoutineA, Routine)
    assert not isinstance(packageA, Routine)
    assert not RoutineA == RoutineB
    assert RoutineA != RoutineB
    assert RoutineA == anotherA
    assert not packageA==RoutineA

def testGlobal():
    globalA=Global("A")
    globalB=Global("B")
    anotherA=Global("A")
    routineA=Routine("A")
    assert isinstance(globalA, Global)
    assert not isinstance(routineA,Global)
    assert globalA != globalB
    assert globalA == anotherA
    assert routineA !=globalA
#===============================================================================
# Main routine
#===============================================================================
if __name__ == '__main__':
    testPackage()
    testRoutine()
    testGlobal()