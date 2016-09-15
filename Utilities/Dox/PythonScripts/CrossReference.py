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
write = sys.stdout.write
MUMPS_ROUTINE_PREFIX = "Mumps"

BoolDict = {True:"Y", False:"N"}

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
class Routine(object):
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
        self._dbGlobals = dict()
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
    def addFilemanDbCallGlobal(self, dbGlobal, callTag=None):
        dbFileNo = dbGlobal.getFileNo() # if it is a file man file
        if not dbFileNo: return
        if dbFileNo not in self._dbGlobals:
            self._dbGlobals[dbFileNo] = (dbGlobal, [])
        self._dbGlobals[dbFileNo][1].append(callTag)
        dbGlobal.addFileManDbCallRoutine(self)
    def getFilemanDbCallGlobals(self):
        return self._dbGlobals
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
    def addCalledRoutines(self, routine, tag=None, lineOccurance=None):
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
# # class to represent A FileMan File
#===============================================================================
class FileManFile(object):
    def __init__(self, fileNo, fileManName, parentFile = None):
        self._fileNo = None
        self._fileManName = fileManName
        self._parentFile = parentFile
        self._fields = None # dict of all fields
        self._subFiles = None  # dict of all subFiles
        self._description = None # description of fileMan file
        self.setFileNo(fileNo)
        self._fileManDbCallRoutines = None
    def getFileNo(self):
        return self._fileNo
    def setFileNo(self, fileNo):
        if fileNo:
            try:
                floatFileNo = float(fileNo)
                self._fileNo = fileNo
            except ValueError:
                self._fileNo = None
        else:
            self._fileNo = None
    def getFileManName(self):
        return self._fileManName
    def setFileManName(self, fileManName):
        self._fileManName = fileManName
    def addFileManField(self, FileManField):
        if not self._fields:
            self._fields = dict()
        self._fields[FileManField.getFieldNo()] = FileManField
    def getAllFileManFields(self):
        return self._fields
    def hasField(self, fieldNo):
      if self._fields:
        return fieldNo in self._fields
      return False
    def getField(self, fieldNo):
      if self._fields:
        return self._fields.get(fieldNo)
      return None
    def addFileManSubFile(self, FileManSubFile):
        if not self._subFiles:
            self._subFiles = dict()
        self._subFiles[FileManSubFile.getFileNo()] = FileManSubFile
    def hasSubFile(self):
        return self._subFiles and len(self._subFiles) > 0
    def getAllSubFiles(self):
        return self._subFiles
    def isRootFile(self):
        return self._parentFile == None
    def isSubFile(self):
        return not self.isRootFile()
    def getParentFile(self):
        return self._parentFile
    def setParentFile(self, parentFile):
        self._parentFile = parentFile
    def getRootFile(self):
        root = self
        while not root.isRootFile():
            root = root.getParentFile()
        return root
    def getSubFileByFileNo(self, fileNo):
        if not self._subFiles:
            return None
        return self._subFiles.get(fileNo)
    def getFileManFieldByFieldNo(self, fieldNo):
        if not self._fields:
            return None
        return self._fields.get(fieldNo)
    def getDescription(self):
        return self._description
    def setDescription(self, description):
        self._description = [x.decode('latin1').encode('utf8') for x in description]
    def getFileManDbCallRoutines(self):
        return self._fileManDbCallRoutines
    def addFileManDbCallRoutine(self, routine):
        if not routine: return
        package = routine.getPackage()
        if not package: return
        if not self._fileManDbCallRoutines:
            self._fileManDbCallRoutines = dict()
        if package not in self._fileManDbCallRoutines:
            self._fileManDbCallRoutines[package] = set()
        self._fileManDbCallRoutines[package].add(routine)
    def printFileManInfo(self):
        self.printFileManDescription()
        self.printFileManFields()
        self.printFileManSubFiles()
    def printFileManDescription(self):
        if not self._description or len(self._description) == 0:
            return
        write("\n################################################\n")
        write("%s %s\n" % (self._fileNo, "Description"))
        for line in self._description:
            write(line + "\n")
    def printFileManFields(self):
        if not self._fields or len(self._fields) == 0:
            return
        write("################################################\n")
        write("%s: Total # of FileMan Fields: %d\n" % (self._fileNo, len(self._fields)))
        for fieldNo in sorted(self._fields.keys(), key=float):
            self._fields[fieldNo].printResult()
        write("\n")
    def printFileManSubFiles(self):
        if not self._subFiles or len(self._subFiles) == 0:
            return
        write("\n################################################\n")
        write("%s: Total # of FileMan SubFiles: %d\n" % (self._fileNo, len(self._subFiles)))
        for subFile in self._subFiles.itervalues():
            write(" %s(%s) " % (subFile.getFileNo(), subFile.getParentFile().getFileNo()))
        write("\n")
        for subFile in self._subFiles.itervalues():
            subFile.printFileManInfo()
        write("\n")
    #===========================================================================
    # operator
    #===========================================================================
    def __str__(self):
        return self._fileNo
    def __repr__(self):
        return "File: %s, Name: %s" % (self._fileNo, self._fileManName)
#===============================================================================
# # class to represent a Field in FileMan File
#===============================================================================
class FileManField(object):
    FIELD_TYPE_NONE = 0 # Field has No Type, normally just a place hold
    FIELD_TYPE_DATE_TIME = 1
    FIELD_TYPE_NUMBER = 2
    FIELD_TYPE_SET = 3
    FIELD_TYPE_FREE_TEXT = 4
    FIELD_TYPE_WORD_PROCESSING = 5
    FIELD_TYPE_COMPUTED = 6
    FIELD_TYPE_FILE_POINTER = 7
    FIELD_TYPE_VARIABLE_FILE_POINTER = 8
    FIELD_TYPE_SUBFILE_POINTER = 9
    FIELD_TYPE_MUMPS = 10
    FIELD_TYPE_BOOLEAN = 11
    FIELD_TYPE_LAST = 12

    """
      Enumeration for SPECIFIER
    """
    FIELD_SPECIFIED_NONE = 0
    FIELD_SPECIFIER_REQUIRED = 1
    FIELD_SPECIFIER_AUDIT= 2
    FIELD_SPECIFIER_MULTILINE = 3
    FIELD_SPECIFIER_LAYGO_NOT_ALLOWED = 4
    FIELD_SPECIFIER_OUTPUT_TRANSFORM = 5
    FIELD_SPECIFIER_EDITING_NOT_ALLOWD = 6
    FIELD_SPECIFIER_NO_WORD_WRAPPING = 7
    FIELD_SPECIFIER_IGORE_PIPE = 8
    FIELD_SPECIFIER_NEW_ENTRY_NO_ASK = 9
    FIELD_SPECIFIER_NEW_ENTRY_ASK_ANOTHER = 10
    FIELD_SPECIFIER_UNEDITABLE = 11
    FIELD_SPECIFIER_AUDIT_EDIT_DELETE = 12
    FIELD_SPECIFIER_EDIT_PROG_ONLY = 13

    def __init__(self, fieldNo, name, fType ,location = None):
        self._fieldNo = None
        self.setFieldNo(fieldNo)
        self._name = name
        self._loc = location
        self._type = fType
        self._subType = None
        self._specifier = None
        self._typeName = None
        self._indexName = None
        self._propList = None # store extra information is name value pair format
        # attributes
        self._isRequired = False
        self._isAudited = False
        self._isAddNewEntryWithoutAsking = False
        self._isMultiplyAsked = False
        self._isKeyField = False
    def setFieldNo(self, fieldNo):
        if fieldNo:
            try:
                floatFieldNo = float(fieldNo)
                self._fieldNo = fieldNo
            except ValueError:
                self._fieldNo = None
        else:
            self._fieldNo = None
    def getName(self):
        return self._name
    def getLocation(self):
        return self._loc
    def getType(self):
        return self._type
    def getSubType(self):
        return self._subType
    def setSubType(self, subType):
        self._subType = subType
    def addSubType(self, subType):
        if not self._subType:
           self._subType = []
        self._subType.append(subType)
    def hasSubType(self, subType):
        if self._subType:
            return subType in self._subType
        return False
    def getSpecifier(self):
        return self._specifier
    def setSpecifier(self, specifier):
        self._specifier = specifier
    def getFieldNo(self):
        return self._fieldNo
    def setType(self, fType):
        self._type = fType
    def getTypeName(self):
        return self._typeName
    def setTypeName(self, typeName):
        self._typeName = typeName
    def getIndexName(self):
        return self._indexName
    def setIndexName(self, index):
        self._indexName = index
    def setRequired(self, required):
        self._isRequired = required
    def setAudited(self, audited):
        self._isAudited = audited
    def setAddNewEntryWithoutAsking(self, value):
        self._isAddNewEntryWithoutAsking = value
    def setMultiplyAsked(self, value):
        self._isMultiplyAsked = value
    def isRequired(self):
        return self._isRequired
    def isAudited(self):
        return self._isAudited
    def isAddNewEntryWithoutAsking(self):
        return self._isAddNewEntryWithoutAsking
    def isMultiplyAsked(self):
        return self._isMultiplyAsked
    def isKeyField(self):
        return self._isKeyField
    def addProp(self, propName, propValue):
        if not self._propList: self._propList = []
        self._propList.append((propName, propValue))
    def hasProp(self, propName):
        if not self._propList: return False
        for item in self._propList:
            if item[0] == propName:
                return True
        return False
    def getProp(self, propName):
        if not self._propList: return None
        for item in self._propList:
            if item[0] == propName:
                return item[1]
        return None
    def getPropList(self):
        return self._propList
    def printResult(self):
        write("%r\n" % self)
        self.printPropList()
    def printPropList(self):
        if not self._propList or len(self._propList) <= 0:
            return
        for (name, values) in self._propList:
            write("%s:  " % name)
            for value in values:
                write("%s\n" % value)
    # type checking method
    def isFilePointerType(self):
        return self._type == self.FIELD_TYPE_FILE_POINTER
    def isSubFilePointerType(self):
        return self._type == self.FIELD_TYPE_SUBFILE_POINTER
    def isVariablePointerType(self):
        return self._type == self.FIELD_TYPE_VARIABLE_FILE_POINTER
    def isWordProcessingType(self):
        return self._type == self.FIELD_TYPE_WORD_PROCESSING
    def isSetType(self):
        return self._type == self.FIELD_TYPE_SET
    #===========================================================================
    # operator
    #===========================================================================
    def __str__(self):
        return self._fieldNo
    def __repr__(self):
        return ("%s, %s, %s, %s, %s, %s, %s" % (self.getFieldNo(),
                                    self.getName(),
                                    self.getLocation(),
                                    self.getTypeName(),
                                    self.getType(),
                                    self.getSubType(),
                                    self.getSpecifier()))
#===============================================================================
# # A series of subclass of FileManField based on type
#===============================================================================
class FileManNoneTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_NONE
        FileManField.__init__(self, fieldNo, name, fType ,location)

class FileManDateTimeTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_DATE_TIME
        FileManField.__init__(self, fieldNo, name, fType ,location)

class FileManNumberTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_NUMBER
        FileManField.__init__(self, fieldNo, name, fType ,location)

class FileManSetTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_SET
        FileManField.__init__(self, fieldNo, name, fType ,location)
        self._setMembers = []
    def getSetMembers(self):
        return self._setMembers
    def setSetMembers(self, memList):
        self._setMembers = memList
    def __repr__(self):
        return "%s, %s" % (FileManField.__repr__(self), self._setMembers)

class FileManFreeTextTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_FREE_TEXT
        FileManField.__init__(self, fieldNo, name, fType ,location)

class FileManWordProcessingTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_WORD_PROCESSING
        FileManField.__init__(self, fieldNo, name, fType ,location)
        self._isNoWrap = False
        self._ignorePipe = False
    def setNoWrap(self, noWrap):
        self._isNoWrap = noWrap
    def getNoWrap(self):
        return self._isNoWrap
    def __repr__(self):
        return ("%s, %s, %s" % (FileManField.__repr__(self),
                                self._isNoWrap,
                                self._ignorePipe))

class FileManComputedTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_COMPUTED
        assert location == None
        FileManField.__init__(self, fieldNo, name, fType ,location)

class FileManFilePointerTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_FILE_POINTER
        FileManField.__init__(self, fieldNo, name, fType ,location)
        self._filePointedTo = None
    def setPointedToFile(self, filePointedTo):
        #assert isinstance(filePointedTo, FileManFile)
        self._filePointedTo = filePointedTo
    def getPointedToFile(self):
        return self._filePointedTo
    def __repr__(self):
        return ("%s, %s" % (FileManField.__repr__(self),
                            self._filePointedTo))

class FileManVariablePointerTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_VARIABLE_FILE_POINTER
        FileManField.__init__(self, fieldNo, name, fType ,location)
        self._pointedToFiles = []
    def setPointedToFiles(self, pointedToFiles):
      if pointedToFiles:
        self._pointedToFiles = pointedToFiles
      else:
        self._pointedToFiles = []
    def getPointedToFiles(self):
        return self._pointedToFiles
    def __repr__(self):
        return ("%s, %s" % (FileManField.__repr__(self), self._pointedToFiles))

class FileManSubFileTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_SUBFILE_POINTER
        FileManField.__init__(self, fieldNo, name, fType ,location)
        self._pointedToSubFile= None
    def setPointedToSubFile(self, pointedToSubFile):
        assert isinstance(pointedToSubFile, FileManFile)
        assert not pointedToSubFile.isRootFile()
        self._pointedToSubFile = pointedToSubFile
    def getPointedToSubFile(self):
        return self._pointedToSubFile
    def __repr__(self):
        return ("%s, %s" % (FileManField.__repr__(self),
                            self._pointedToSubFile))

class FileManMumpsTypeField(FileManField):
    def __init__(self, fieldNo, name, fType ,location = None):
        assert fType == self.FIELD_TYPE_MUMPS
        FileManField.__init__(self, fieldNo, name, fType ,location)

class FileManFieldFactory:
    _creationTuple_ = (FileManNoneTypeField, FileManDateTimeTypeField,
                       FileManNumberTypeField, FileManSetTypeField,
                       FileManFreeTextTypeField, FileManWordProcessingTypeField,
                       FileManComputedTypeField, FileManFilePointerTypeField,
                       FileManVariablePointerTypeField, FileManSubFileTypeField,
                       FileManMumpsTypeField)
    @staticmethod
    def createField(fieldNo, name, fType, location = None):
        assert (fType >= FileManField.FIELD_TYPE_NONE and
                fType < FileManField.FIELD_TYPE_LAST)
        if fType < len(FileManFieldFactory._creationTuple_):
          return FileManFieldFactory._creationTuple_[fType](fieldNo,
                                                            name,
                                                            fType,
                                                            location)
        else:
          return FileManField(fieldNo, name, fType, location)
#===============================================================================
# # class to represent a global variable inherits FileManFile
#===============================================================================
class Global(FileManFile):
    #constructor
    def __init__(self, globalName,
                 fileNo=None,
                 fileManName = None,
                 package=None):
        FileManFile.__init__(self, fileNo, fileManName)
        self._name = globalName
        self._package = package
        self._referencesRoutines = dict() # accessed by routines directly
        self._filePointers = dict() # pointer to some other file
        self._filePointedBy = dict() # pointed to by some other files
        self._totalReferencedRoutines = 0
        self._totalReferencedGlobals = 0
        self._totalReferredGlobals = 0
    def setName(self, globalName):
        self._name = globalName
    def getName(self):
        return self._name
    def getTotalNumberOfReferencedRoutines(self):
        return self._totalReferencedRoutines
    def getAllReferencedRoutines(self):
        return self._referencesRoutines
    def getTotalNumberOfReferencedGlobals(self):
        return self._totalReferencedGlobals
    def getAllReferencedFileManFiles(self):
        return self._filePointedBy
    def getTotalNumberOfReferredGlobals(self):
        return self._totalReferredGlobals
    def getAllReferredFileManFiles(self):
        return self._filePointers
    def hasPointerToFileManFile(self, fileManFile, fileManFieldNo, subFileNo):
        return self.__hasFileManFileDependency__(fileManFile, fileManFieldNo, subFileNo, False)
    def isPointedToByFileManFile(self, fileManFile, fileManFieldNo, subFileNo):
        return self.__hasFileManFileDependency__(fileManFile, fileManFieldNo, subFileNo, True)
    def __hasFileManFileDependency__(self, fileManFile, fileManFieldNo, subFileNo, isPointedToBy = True):
        assert isinstance(fileManFile, Global),  "Must be a Global instance, [%s]" % fileManFile
        package = fileManFile.getPackage()
        if not package:
            return False
        filePointerDeps = self._filePointedBy
        if not isPointedToBy:
            filePointerDeps = self._filePointers
        if package not in filePointerDeps:
            return False
        if fileManFile in filePointerDeps[package]:
            return (fileManFieldNo, subFileNo) in filePointerDeps[package][fileManFile]
        return False
    def addReferencedRoutine(self, routine):
        if not routine:
            return
        package = routine.getPackage()
        if not package:
            return
        if package not in self._referencesRoutines:
            self._referencesRoutines[package] = set()
        self._referencesRoutines[package].add(routine)
        self._totalReferencedRoutines = self._totalReferencedRoutines + 1
    def getReferredRoutineByPackage(self, package):
        return self._referencesRoutines.get(package)
    def addPointedToByFile(self, Global, fieldNo, subFileNo=None):
        self.__addReferenceGlobalFilesCommon__(Global, fieldNo, subFileNo, True)
        Global.__addPointedToFiles__(self, fieldNo, subFileNo)
    def getPointedByFilesByPackage(self, Package):
        return self._filePointedBy.get(package)
    def __addPointedToFiles__(self, Global, fieldNo, subFileNo):
        self.__addReferenceGlobalFilesCommon__(Global, fieldNo, subFileNo, False)
    def __addReferenceGlobalFilesCommon__(self, Global, fieldNo, subFileNo, pointedToBy=True):
        if not Global:
            return
        package = Global.getPackage()
        if not package:
            return
        depFileDict = self._filePointedBy
        if not pointedToBy:
            depFileDict = self._filePointers
        if package not in depFileDict:
            depFileDict[package] = dict()
        if Global not in depFileDict[package]:
            depFileDict[package][Global] = []
            if pointedToBy:
              self._totalReferredGlobals = self._totalReferredGlobals + 1
              Global._totalReferencedGlobals = Global._totalReferencedGlobals + 1
        depFileDict[package][Global].append((fieldNo, subFileNo))
    def getPointedToFilesByPackage(self, Package):
        return self._filePointers.get(Package)
    def setPackage(self, package):
        self._package = package
    def isFileManFile(self):
        return self.getFileNo() != None
    def getPackage(self):
        return self._package
    def printResult(self):
        write("Name:[%s], FileNo:[%s]: FileManName:[%s], Package:[%s]\n" %
              (self._name, self._fileNo, self._fileManName, self._package))
        #self.printReferencedRoutines()
        self.printFileManFileDependencies()
        if self.isFileManFile:
            self.printFileManInfo()
    def printReferencedRoutines(self):
        write("Referenced By Routines: %d\n" % self._totalReferencedRoutines)
        for (package, routineSet) in self._referencesRoutines.iteritems():
            write("Package: %s Total: %d" % (package, len(routineSet)))
            for routine in routineSet:
                write(" %s" % routine)
            write("\n")
        write("################################################\n")
    def printFileManFileDependencies(self):
        write("Pointed By FileMan Files: %d\n" % self._totalReferredGlobals)
        for (package, filePointerDict) in self._filePointedBy.iteritems():
            write("Package: %s Total: %d" % (package, len(filePointerDict)))
            for (Global, detailList) in filePointerDict.iteritems():
                write(" %s:%s" % (Global.getFileNo(), detailList))
            write("\n")
        write("################################################\n")
        write("Pointers to FileMan Files: %d\n" % self._totalReferencedGlobals)
        for (package, filePointerDict) in self._filePointers.iteritems():
            write("Package: %s Total: %d" % (package, len(filePointerDict)))
            for (Global, detailList) in filePointerDict.iteritems():
                write(" %s:%s" % (Global.getFileNo(), detailList))
            write("\n")
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
# # Utilities function related to Global
#===============================================================================
def getAlternateGlobalName(globalName):
    pos = globalName.find("(") # this should find the very first "("
    if pos == -1:
        return globalName + "("
    if pos == len(globalName) - 1:
        return globalName[0:len(globalName)-1]
    return globalName
def getTopLevelGlobalName(globalName):
    pos = globalName.find("(") # this should find the very first "("
    if pos == -1: # could not find, must be the top level name already
        return globalName[1:]
    return globalName[1:pos]

#===============================================================================
# # class to represent a VistA Package
#===============================================================================
class Package(object):
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
        self._fileManDependencies = dict()
        self._fileManDependents = dict()
        """ fileman db call related dependencies """
        self._fileManDbDependencies = dict()
        self._fileManDbDependents = dict()
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
        self.generateRoutineBasedDependencies()
        self.generateFileManFileBasedDependencies()
    def generateRoutineBasedDependencies(self):
        # build routine based dependencies
        for routine in self._routines.itervalues():
            calledRoutines = routine.getCalledRoutines()
            for package in calledRoutines.iterkeys():
                if package and package != self:
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
            # based on referred Globals
            for globalVar in referredGlobals.itervalues():
                package = globalVar.getPackage()
                if package != self:
                    if package not in self._globalDependencies:
                        self._globalDependencies[package] = (set(), set())
                    self._globalDependencies[package][0].add(routine)
                    self._globalDependencies[package][1].add(globalVar)
                    if self not in package._globalDependents:
                        package._globalDependents[self] = (set(), set())
                    package._globalDependents[self][0].add(routine)
                    package._globalDependents[self][1].add(globalVar)
            # based on fileman db calls
            filemanDbCallGbls = routine.getFilemanDbCallGlobals()
            for filemanDbGbl, tags in filemanDbCallGbls.itervalues():
                # find the package associated with the global
                package = filemanDbGbl.getRootFile().getPackage()
                if package != self:
                    if package not in self._fileManDbDependencies:
                        self._fileManDbDependencies[package] = (set(), set())
                    self._fileManDbDependencies[package][0].add(routine)
                    self._fileManDbDependencies[package][1].add(filemanDbGbl)
                    if self not in package._fileManDbDependents:
                        package._fileManDbDependents[self] = (set(), set())
                    package._fileManDbDependents[self][0].add(routine)
                    package._fileManDbDependents[self][1].add(filemanDbGbl)
    def generateFileManFileBasedDependencies(self):
        # build fileman file based dependencies
        self.__correctFileManFilePointerDependencies__()
        for Global in self._globals.itervalues():
            if not Global.isFileManFile(): # only care about the file man file now
                continue
            pointerToFiles = Global.getAllReferredFileManFiles()
            for package in pointerToFiles.iterkeys():
                if package != self:
                    if package not in self._fileManDependencies:
                        self._fileManDependencies[package] = (set(), set())
                    self._fileManDependencies[package][0].add(Global)
                    self._fileManDependencies[package][1].update(pointerToFiles[package])
                    if self not in package._fileManDependents:
                        package._fileManDependents[self] = (set(), set())
                    package._fileManDependents[self][0].add(Global)
                    package._fileManDependents[self][1].update(pointerToFiles[package])
    # this routine will correct any inconsistence caused by parsing logic
    def __correctFileManFilePointerDependencies__(self):
        for Global in self._globals.itervalues():
            if not Global.isFileManFile(): # only care about the file man file now
                continue
            self.__checkIndividualFileManPointers__(Global)
    def __checkIndividualFileManPointers__(self, Global, subFile = None):
        currentGlobal = Global
        if subFile: currentGlobal = subFile
        allFileManFields = currentGlobal.getAllFileManFields()
        # get all fields of the current global
        if allFileManFields:
            for field in allFileManFields.itervalues():
                if field.isFilePointerType():
                    fileManFile = field.getPointedToFile()
                    self.__checkFileManPointerField__(field, fileManFile, Global, subFile)
                    continue
                if field.isVariablePointerType():
                    fileManFiles = field.getPointedToFiles()
                    for fileManFile in fileManFiles:
                        self.__checkFileManPointerField__(field, fileManFile, Global, subFile)
                    continue
        else:
            logger.debug("[%s] does not have any fields" % currentGlobal)
        if not subFile:
            # get all subfiles of current globals
            allSubFiles = Global.getAllSubFiles()
            if not allSubFiles: return
            for subFile in allSubFiles.itervalues():
                self.__checkIndividualFileManPointers__(Global, subFile)
    def __checkFileManPointerField__(self, field, fileManFile, Global, subFile = None):
        if not fileManFile:
            logger.warning("Invalid fileMan File pointed to by field:[%s], Global:[%s], subFile:[%s]" % (field, Global, subFile))
            return
        # make sure that fileManFile is in the Global' filePointers
        fieldNo = field.getFieldNo()
        subFileNo = None
        if subFile: subFileNo = subFile.getFileNo()
        if not Global.hasPointerToFileManFile(fileManFile, fieldNo, subFileNo):
            logger.warning("Global[%r] does not have a pointer to [%r] at [%s]:[%s]" % (Global, fileManFile, fieldNo, subFileNo))
            fileManFile.addPointedToByFile(Global, fieldNo, subFileNo)
            return
        if not fileManFile.isPointedToByFileManFile(Global, fieldNo, subFileNo):
            logger.warning("FileMan file[%r] does not pointed to by [%r] at [%s]:[%s]" % (fileManFile, Global, fieldNo, subFileNo))
            fileManFile.addPointedToByFile(Global, fieldNo, subFileNo)
            return
    def getPackageRoutineDependencies(self):
        return self._routineDependencies
    def getPackageRoutineDependents(self):
        return self._routineDependents
    def getPackageGlobalDependencies(self):
        return self._globalDependencies
    def getPackageGlobalDependents(self):
        return self._globalDependents
    def getPackageFileManFileDependencies(self):
        return self._fileManDependencies
    def getPackageFileManFileDependents(self):
        return self._fileManDependents
    def getPackageFileManDbCallDependencies(self):
        return self._fileManDbDependencies
    def getPackageFileManDbCallDependents(self):
        return self._fileManDbDependents
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
    def printFileManFileDependency(self, dependencyList=True):
        if dependencyList:
            header = "FileMan File Dependencies list"
            depPackages = self._fileManDependencies
        else:
            header = "FileMan File Dependents list"
            depPackages = self._fileManDependents
        write("Package %s: \n" % header)
        for package, depFileManTuple in depPackages.iteritems():
            write(" %s: Total Files Pointed To By: %d [ " % (package, len(depFileManTuple[0])))
            for globalVar in depFileManTuple[0]:
                write (" %s " % (globalVar))
            write("]\n")
            write(" %s: Total File Pointer To : %d [ " % (package, len(depFileManTuple[1])))
            for globalVar in depFileManTuple[1]:
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
        self.printFileManFileDependency(True)
        self.printFileManFileDependency(False)
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
        self._allFileManGlobals = dict() # Globals that are managed by FileMan
        self._orphanGlobals = set()
        self._percentRoutine = set()
        self._percentRoutineMapping = dict()
        self._renameRoutines = dict()
        self._mumpsRoutines = set()
        self._platformDepRoutines = dict() # [name, package, mapping list]
        self._platformDepRoutineMappings = dict() # [platform dep _calledRoutine -> generic _calledRoutine]
        self._allFileManSubFiles = dict() # store all fileman subfiles
    def getAllRoutines(self):
        return self._allRoutines
    def getAllPackages(self):
        return self._allPackages
    def getOrphanRoutines(self):
        return self._orphanRoutines
    def getAllGlobals(self):
        return self._allGlobals
    def getAllFileManGlobals(self):
        return self._allFileManGlobals
    def getAllFileManSubFiles(self):
        return self._allFileManSubFiles
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
    def getRoutineByName(self, routineName):
        newRtnName = routineName
        if self.routineNeedRename(routineName):
            newRtnName = self.getRenamedRoutineName(routineName)
        if self.isPlatformDependentRoutineByName(newRtnName):
            return self.getPlatformDependentRoutineByName(newRtnName)
        return self._allRoutines.get(newRtnName)
    def getPackageByName(self, packageName):
        return self._allPackages.get(packageName)
    def getGlobalByName(self, globalName):
        return self._allGlobals.get(globalName)
    def getGlobalByFileNo(self, globalFileNo):
        return self._allFileManGlobals.get(float(globalFileNo))
    def addRoutineToPackageByName(self, routineName, packageName, hasSourceCode=True):
        if packageName not in self._allPackages:
            self._allPackages[packageName] = Package(packageName)
        if routineName not in self._allRoutines:
            self._allRoutines[routineName] = Routine(routineName)
        routine = self._allRoutines[routineName]
        if not hasSourceCode:
            routine.setHasSourceCode(hasSourceCode)
        self._allPackages[packageName].addRoutine(routine)
    def addNonFileManGlobalByName(self, globalName):
        if self.getGlobalByName(globalName): return # already exists
        topLevelName = getTopLevelGlobalName(globalName)
        (namespace, package) = self.categorizeGlobalByNamespace(topLevelName)
        logger.debug("Global: %s, namespace: %s, package: %s" %
                     (globalName, namespace, package))
        if not package:
            package = self.getPackageByName("Uncategorized")
            self.addToOrphanGlobalByName(globalName)
        globalVar = Global(globalName, None, None, package)
        self.addGlobalToPackage(globalVar, package.getName())
        return globalVar
    def addGlobalToPackageByName(self, globalName, packageName):
        if packageName not in self._allPackages:
            self._allPackages[packageName] = Package(packageName)
        if globalName not in self._allGlobals:
            self._allGlobals[globalName] = Global(globalName)
        self._allPackages[packageName].addGlobal(self._allGlobals[globalName])
    def addGlobalToPackage(self, globalVar, packageName):
        if packageName not in self._allPackages:
            self._allPackages[packageName] = Package(packageName)
        if globalVar.getName() not in self._allGlobals:
            self._allGlobals[globalVar.getName()] = globalVar
        self._allPackages[packageName].addGlobal(self._allGlobals[globalVar.getName()])
        # also added to fileMan Globals
        fileNo = globalVar.getFileNo()
        if fileNo:
            realFileNo = float(fileNo)
            if realFileNo not in self._allFileManGlobals:
                self._allFileManGlobals[realFileNo] = self._allGlobals[globalVar.getName()]
    def addFileManSubFile(self, subFile):
        self._allFileManSubFiles[subFile.getFileNo()] = subFile
    def isFileManSubFileByFileNo(self, subFileNo):
        return subFileNo in self._allFileManSubFiles
    def getFileManSubFileByFileNo(self, subFileNo):
        return self._allFileManSubFiles.get(subFileNo)
    def getSubFileRootByFileNo(self, subFileNo):
        root = self.getFileManSubFileByFileNo(subFileNo)
        if not root:
            return None
        return root.getRootFile()
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
        return self.__categorizeVariableNameByNamespace__(routineName)
    def categorizeGlobalByNamespace(self, globalName):
        return self.__categorizeVariableNameByNamespace__(globalName, True)
    def __categorizeVariableNameByNamespace__(self, variableName, isGlobal = False):
        for package in self._allPackages.itervalues():
            hasMatch = False
            matchNamespace = ""
            if isGlobal:
                for globalNameSpace in package.getGlobalNamespace():
                    if variableName.startswith(globalNameSpace):
                        return (globalNameSpace, package)
            for namespace in package.getNamespaces():
                if variableName.startswith(namespace):
                    hasMatch = True
                    matchNamespace = namespace
                if namespace.startswith("!"):
                    if not hasMatch:
                        break
                    elif variableName.startswith(namespace[1:]):
                        hasMatch = False
                        matchNamespace = ""
                        break
            if hasMatch:
                return (matchNamespace, package)
        return (None, None)
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
    # Testing fileMan global referencing
    pTestA = Package("TestA")
    pTestB = Package("TestB")
    gPackage = Global("Package", "9.4", pTestA, "Package Test")
    gDialog = Global("Dialog", ".84", pTestB, "Dialog Test")
    gInstall = Global("Install", "9.7", pTestB, "Install Test")
    gBuild = Global("Build", "9.6", pTestA, "Build Test")
    gPackage.addPointedToByFile(gDialog, "0.1")
    gPackage.addPointedToByFile(gInstall, "45.1")
    gPackage.addPointedToByFile(gBuild, "23.1")
    gPackage.addPointedToByFile(gBuild, "23.4", "9.611")
    gBuild.addPointedToByFile(gPackage, ".03")
    gBuild.addPointedToByFile(gPackage, "34.56", "9.423")
    assert gBuild.hasPointerToFileManFile(gPackage, "23.1", None)
    assert gBuild.hasPointerToFileManFile(gPackage, "23.4", "9.611")
    gPackage.printResult()
    gBuild.printResult()

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
