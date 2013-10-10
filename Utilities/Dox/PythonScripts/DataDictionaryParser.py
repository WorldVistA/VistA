#!/usr/bin/env python

# A logFileParser class to parse VistA FileMan Schema log files and generate
# the FileMan Schema and dependencies among packages.
#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
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
from CrossReference import FileManField, FileManFile, FileManFieldFactory
from CrossReference import LocalVariable, GlobalVariable, NakedGlobal, MarkedItem, LabelReference

from LogManager import logger, initConsoleLogging

class IDDSectionParser:
    def __init__(self):
        pass
    def onSectionStart(self, line, section, Global, CrossReference):
        pass
    def onSectionEnd(self, line, section, Global, CrossReference):
        pass
    def parseLine(self, line, Global, CrossReference):
        pass
class DescriptionSectionParser(IDDSectionParser):
    def __init__(self):
        self._lines=None
        self._curLine = None
        self._section = IDataDictionaryListFileLogParser.DESCRIPTION_SECTION
    def onSectionStart(self, line, section, Global, CrossReference):
        logger.debug("Section %d started" % section)
        self._lines=[]
        self._curLine = ""
    def onSectionEnd(self, line, section, Global, CrossReference):
        if len(self._curLine) > 0:
            self._lines.append(self._curLine)
        Global.setDescription(self._lines)
    def parseLine(self, line, Global, CrossReference):
        logger.debug("Current Description line is [%s]" % line)
        if len(line.strip()) == 0: # assume this is the paragrahp break
            logger.debug("Found Break in Description %s" % Global)
            if len(self._curLine) > 0:
                self._lines.append(self._curLine)
                self._curLine = ""
        else:
            self._curLine += " " + line.strip()
#===============================================================================
# A class to parse Field # section in Data Dictionary schema log file output
#===============================================================================
class FileManFieldSectionParser(IDDSectionParser):
    NAME_LOC_TYPE_REGEX = re.compile("(?P<Name>^[^ ].*) +(?P<Loc>[^ ]*;[^ ]*) +(?P<Type>[^ ]+.*$)")
    NAME_LOC_REGEX = re.compile("(?P<Name>^[^ ].*) +(?P<Loc>[^ ]*;[^ ]*$)")
    NAME_TYPE_REGEX = re.compile("(?P<Name>^[^ ].*)  +(?P<Type>[^ ]+.*$)")
    POINTER_TO_REGEX = re.compile("^POINTER TO .* \(#(?P<File>[.0-9]+)\)")
    UNDEFINED_POINTER = re.compile("^POINTER \*\* TO AN UNDEFINED FILE \*\*")
    SUBFILE_REGEX = re.compile("Multiple #(?P<File>[.0-9]+)")
    DEFAULT_VALUE_INDENT = 32
    DEFAULT_NAME_INDENT = 14
    MAXIMIUM_TYPE_START_INDEX = 50
    totalFieldNotes = set() # for debugging purpose
    #Dictionary
    StringTypeMappingDict = {"COMPUTED":FileManField.FIELD_TYPE_COMPUTED,
                             "BOOLEAN COMPUTED":FileManField.FIELD_TYPE_COMPUTED,
                             "COMPUTED POINTER":FileManField.FIELD_TYPE_COMPUTED,
                             "COMPUTED DATE":FileManField.FIELD_TYPE_DATE_TIME,
                             "DATE":FileManField.FIELD_TYPE_DATE_TIME,
                             "NUMBER":FileManField.FIELD_TYPE_NUMBER,
                             "SET":FileManField.FIELD_TYPE_SET,
                             "FREE TEXT":FileManField.FIELD_TYPE_FREE_TEXT,
                             "WORD-PROCESSING":FileManField.FIELD_TYPE_WORD_PROCESSING,
                             "VARIABLE POINTER":FileManField.FIELD_TYPE_VARIABLE_FILE_POINTER,
                             "MUMPS":FileManField.FIELD_TYPE_MUMPS}
    FieldAttributesInfoList = [["""(Required)""", "_isRequired"],
                          ["""(audited)""", "_isAudited"],
                          ["""(Add New Entry without Asking)""", "_isAddNewEntryWithoutAsking"],
                          ["""(Multiply asked)""", "_isMultiplyAsked"],
                          ["""(Key field)""", "_isKeyField"],
                          ["""(NOWRAP)""", "_isNoWrap"],
                          ['''(IGNORE "|")''', "_ignorePipe"]]

#'''Short Descr:''',
#'''Estimated Case Length (HOURS:''',
#'''Uniqueness Index:''')
#'''Description:''',
    FileFieldCaptionList = ('''LAST EDITED BY:''',
                            '''LOSSES:''',
                            '''GROUP:''',
                            '''TOTAL DIALYSIS PATIENT REMAINING:''',
                            '''NOTES:''',
                            '''PATIENTS COMPLETING INITIAL TRAINING:''',
                            '''HELP-PROMPT:''',
                            '''SCREEN ON FILE:''',
                            '''EXECUTABLE HELP:''',
                            '''COMPLICATIONS WITHIN 24 HOURS:''',
                            '''REQUEST ENTERED BY:''',
                            '''IDENTIFIED BY:''',
                            '''DESIGNATED BEDS IN GENERAL PURPOSE UNITS:''',
                            '''DIALYSIS CENTER TREATMENTS:''',
                            '''TECHNICAL DESCR:''',
                            '''CROSS-REFERENCE:''',
                            '''RECORD INDEXES:''',
                            '''AUDIT CONDITION:''',
                            '''SECONDARY KEY:''',
                            '''DIALYSIS/BEDS/FACILITIES:''',
                            '''SUM:''',
                            '''AUDIT:''',
                            '''HOME (SELF) DIALYSIS TRAINING:''',
                            '''ALGORITHM:''',
                            '''DELETE TEST:''',
                            '''LAST EDITED:''',
                            '''SCREEN:''',
                            '''INDEXED BY:''',
                            '''HOME DIALYSIS:''',
                            '''MUMPS CODE:''',
                            '''DESCRIPTION:''',
                            '''ADDITIONS DURING REPORTING PERIOD:''',
                            '''EXPLANATION:''',
                            '''FIELD INDEX:''',
                            '''PRE-LOOKUP:''',
                            '''PRIMARY KEY:''',
                            '''OUTPUT TRANSFORM:''',
                            '''LAYGO TEST:''',
                            '''INPUT TRANSFORM:''')
    def __init__(self):
        self._lines=None
        self._section = IDataDictionaryListFileLogParser.FILEMAN_FIELD_SECTION
        self._curFile = None
        self._field = None
        self._isSubFile = False
    def onSectionStart(self, line, section, Global, CrossReference):
        logger.debug("[%s]" % line)
        self._lines = []
        result = DataDictionaryListFileLogParser.FILEMAN_FIELD_START.search(line)
        assert result
        fileNo = result.group('FileNo')
        fieldNo = result.group("FieldNo")
        self._isSubFile = float(fileNo) != float(Global.getFileNo())
        if self._isSubFile:
            logger.debug("%s is a subfile" % fileNo)
            self._curFile = Global.getSubFileByFileNo(fileNo)
            assert self._curFile, "Could not find subFile [%s] in file [%s] line [%s]" % (fileNo, Global.getFileNo(), line)
        else:
            self._curFile = Global
        restOfLineStart = line.find("," + fieldNo) + len(fieldNo)
        startIdent = self.DEFAULT_NAME_INDENT
        #if len(fileNo) + 4 > startIdent:
        #    startIdent = self
        defaultIdentLevel = self.__getDefaultIndentLevel__(self._curFile, self.DEFAULT_NAME_INDENT)
        if restOfLineStart > defaultIdentLevel:
            logger.debug("FileNo: %s, FieldNo: %s, line: %s, may not be a valid field no, %d, %d" % (fileNo, fieldNo, line, restOfLineStart, defaultIdentLevel))
            try:
                floatValue = float(fieldNo)
            except ValueError:
                logger.error("invalid fieldNo %s" % fieldNo)
                fieldNo = line[line.find(",")+1:defaultIdentLevel]
                floatValue = float(fieldNo)
        restOfLine = line[line.find("," + fieldNo) + len(fieldNo)+1:].strip()
        logger.debug("Parsing [%s]" % restOfLine)
        result = self.NAME_LOC_TYPE_REGEX.search(restOfLine)
        fName, fType, fLocation = None, None, None
        if result:
            logger.debug("FileNo: %s, Field#: %s, Name: %s, Loc %s, Type %s" %
            (fileNo, fieldNo, result.group('Name').rstrip(), result.group('Loc'), result.group('Type')))
            fName = result.group('Name').strip()
            fLocation = result.group('Loc').strip()
            if fLocation == ";":
                fLocation = None
            fType = result.group('Type').strip()
        else:
            # handle three cases, 1. no location info 2. no type info 3. Both
            if restOfLine.find(";") != -1: # missing type info
                logger.warn("Missing Type information [%s]" % line)
                result = self.NAME_LOC_REGEX.search(restOfLine)
                if result:
                    logger.debug("Name: %s, Loc %s" % (result.group('Name'), result.group('Loc')))
                    fName = result.group('Name').strip()
                    fLocation = result.group('Loc').strip()
                else:
                    logger.error("Could not parse [%s]" % restOfLine)
                    return
            else: # missing location, assume at least two space seperate name and type
                logger.warn("Missing location information [%s]" % line)
                result = self.NAME_TYPE_REGEX.search(restOfLine)
                if result:
                    fName = result.group('Name').strip()
                    fType = result.group('Type').strip()
                    logger.debug("Name: %s, Type %s" % (result.group('Name'), result.group('Type')))
                else:
                    logger.warn("Guessing Name: %s at line [%s]" % (restOfLine.strip(), line))
        stripedType = ""
        if fType:
            stripedType = self.__stripFieldAttributes__(fType)
        if len(stripedType) > 0:
            self.__createFieldByType__(fieldNo, stripedType, fName, fLocation, line, Global, CrossReference)
        else:
            self._field = FileManFieldFactory.createField(fieldNo, fName, FileManField.FIELD_TYPE_NONE, fLocation)
        logger.debug("Add field %s to File %s" % (fName, self._curFile.getFileNo()))
        self._curFile.addFileManField(self._field)
        if len(stripedType) > 0 :
            self.__parseFieldAttributes__(fType)
    def onSectionEnd(self, line, section, Global, CrossReference):
        if not self._lines or len(self._lines) == 0:
            pass
        #elif self._isSubFilePointer and self._pointedToSubFile:
        #    self.__parsingSubFileDescription__()
        elif self._field.isVariablePointerType():
            self.__parsingVariablePointer__(Global, CrossReference)
        elif self._field.isSetType():
            self.__parsingSetTypeDetails__(Global)
        # this is to parse the field details part
        self.__parseFieldDetails__()
        # this is to find out how many subfileds in the schema file
        #self.__findTotalSubFileds__()
        self.__resetVar__()
    def parseLine(self, line, Global, CrossReference):
        if not self._lines:
            self._lines=[]
        self._lines.append(line)
    def __parseFieldDetails__(self):
        if not self._lines or len(self._lines) <= 0:
            return
        curCaption = None
        curValues = None
        for line in self._lines:
            found = False
            for caption in self.FileFieldCaptionList:
                result = re.search(" +%s ?(?P<Value>.*)" % caption, line)
                if result:
                    if curCaption:
                        self._field.addProp(curCaption, curValues)
                        logger.debug("Add Prop: %s value: [%s]" % (curCaption, curValues))
                    curCaption = caption
                    curValues = []
                    if result.group('Value'):
                        curValues.append(result.group('Value').strip())
                    else:
                        curValues.append("")
                    found = True
                    break
            if not found and curCaption:
                if not curValues: curValues = []
                curValues.append(line.strip())
        if curCaption:
            self._field.addProp(curCaption, curValues)
            logger.debug("Add Prop: %s value: [%s]" % (curCaption, curValues))
    def __findTotalSubFileds__(self):
        if not self._lines or len(self._lines) == 0:
            pass
        indentValue = self.__getDefaultIndentLevel__(self._curFile, self.DEFAULT_NAME_INDENT)
        for line in self._lines:
            result = re.search("^ {%d,%d}(?P<Name>[A-Z][^:]+):" % (self.DEFAULT_NAME_INDENT, indentValue), line)
            if result:
                name = result.group('Name')
                if name.startswith("SCREEN ON FILE "): name = "SCREEN ON FILE"
                if name not in self.totalFieldNotes:
                    logger.info("NEW FIELD NOTE TITLE: [%s]" % name)
                    self.totalFieldNotes.add(name)
    def __getDefaultIndentLevel__(self, pointedToSubFile, startIndent):
        retValue = startIndent
        startFile = pointedToSubFile
        while not startFile.isRootFile():
            startFile = startFile.getParentFile()
            retValue += 2
        return retValue
    def __parsingSubFileDescription__(self):
        description = None
        index = 0
        desPos = -1
        indentValue = self.__getDefaultIndentLevel__(self._pointedToSubFile,
                                                     self.DEFAULT_VALUE_INDENT)
        for index in range(len(self._lines)):
            logger.debug("%s " % self._lines[index])
            if desPos == -1:
                desPos = self._lines[index].find("DESCRIPTION:")
            else:
                if re.search("^ {%d,%d}[^ ]" % (self.DEFAULT_VALUE_INDENT, indentValue), self._lines[index]):
                    if not description: description = []
                    description.append(self._lines[index].strip())
                else:
                    break
        self._pointedToSubFile.setDescription(description)
    def __parsingSetTypeDetails__(self, Global):
        index, detailList, found = 0, None, False
        indentValue = self.__getDefaultIndentLevel__(self._curFile,
                                                     self.DEFAULT_VALUE_INDENT)
        for index in range(len(self._lines)):
            if not found:
                result = re.search("^ {%d,%d}(?P<Detail>[^ ]+.*)" % (self.DEFAULT_VALUE_INDENT, indentValue),
                             self._lines[index])
                if result:
                    if not detailList: detailList = []
                    detailList.append(result.group('Detail').strip())
                    found = True
                continue
            else:
                result = re.search("^ {%d,%d}(?P<Detail>[^ ]+.*)" % (self.DEFAULT_VALUE_INDENT, indentValue),
                             self._lines[index])
                if result:
                    detailList.append(result.group('Detail').strip())
                else:
                    break
        self._field.setSetMembers(detailList)
    def __parsingVariablePointer__(self, Global, CrossReference):
        index, fileList, found = 0, None, False
        indentValue = self.__getDefaultIndentLevel__(self._curFile,
                                                     self.DEFAULT_NAME_INDENT)
        for index in range(len(self._lines)):
            if not found:
                if re.search("^ {%d,%d}FILE  ORDER  PREFIX    LAYGO  MESSAGE$" % (self.DEFAULT_NAME_INDENT, indentValue),
                             self._lines[index]):
                    found = True
                continue
            else:
                if re.search("^ {%d,}$" % indentValue, self._lines[index]):
                    break
                else:
                    result = re.search("^ +(?P<File>[0-9\.]+) +", self._lines[index])
                    if result:
                        filePointedTo = CrossReference.getGlobalByFileNo(result.group('File'))
                        if not filePointedTo:
                            # log an error for now, will handle this case later
                            logger.error("INVALID File! File is %s, Global is %s" % (result.group('File'), Global))
                            continue
                        if not fileList: fileList = []
                        fileList.append(filePointedTo)
        self._field.setPointedToFiles(fileList)
    def __createFieldByType__(self, fieldNo, fType, fName, fLocation, line, Global, CrossReference):
        logger.debug("Current Type is [%s]" % fType)
        result = self.UNDEFINED_POINTER.search(fType)
        if result:
            self._field = FileManFieldFactory.createField(fieldNo, fName,
                               FileManField.FIELD_TYPE_FILE_POINTER, fLocation)
            return
        result = self.POINTER_TO_REGEX.search(fType)
        if result:
            fileNo = result.group('File')
            filePointedTo = CrossReference.getGlobalByFileNo(fileNo)
            self._field = FileManFieldFactory.createField(fieldNo, fName,
                               FileManField.FIELD_TYPE_FILE_POINTER, fLocation)
            if not filePointedTo:
                logger.error("Could not find file pointed to [%s], [%s], line:[%s]" % (fileNo, self._curFile, line))
            else:
                self._field.setPointedToFile(filePointedTo)
            return
        # deal with file pointer to subFiles
        result = self.SUBFILE_REGEX.search(fType)
        if result:
            # create a field for sub file type
            self._field = FileManFieldFactory.createField(fieldNo, fName,
                                FileManField.FIELD_TYPE_SUBFILE_POINTER, fLocation)
            fileNo = result.group('File')
            logger.debug("Pointer to subFile %s" % fileNo)
            subFile = Global.getSubFileByFileNo(fileNo)
            if not subFile: # this is a new subfile
                subFile = FileManFile(fileNo, fName, self._curFile)
                self._curFile.addFileManSubFile(subFile)
                logger.debug("Added subFile %s to File %s" % (fileNo, self._curFile.getFileNo()))
                if self._isSubFile:
                    Global.addFileManSubFile(subFile)
            self._field.setPointedToSubFile(subFile)
            CrossReference.addFileManSubFile(subFile)
            return
        for (key, value) in self.StringTypeMappingDict.iteritems():
            if fType.startswith(key):
                self._field = FileManFieldFactory.createField(fieldNo, fName, value, fLocation)
                break
        if not self._field:
          # double check the loc and type
          if line.find(fType) > self.MAXIMIUM_TYPE_START_INDEX:
              fType = line[self.MAXIMIUM_TYPE_START_INDEX:]
              if fLocation:
                  fLocation = line[line.find(fLocation):self.MAXIMIUM_TYPE_START_INDEX]
              logger.warn("new Type is [%s], loc is [%s]" % (fType, fLocation))
              self.__createFieldByType__(fieldNo, fType, fName, fLocation, line, Global, CrossReference)
        assert self._field, "Could not find the right type for %s, %s, %s, %s, %s" % (fType, fLocation, fieldNo, line, self._curFile.getFileNo())

    def __stripFieldAttributes__(self, fType):
        outType = fType
        for nameAttr in self.FieldAttributesInfoList:
            if outType.find(nameAttr[0]) != -1:
                outType = outType.replace(nameAttr[0],"")
        logger.debug("[%s]" % outType)
        return outType.strip()

    def __parseFieldAttributes__(self, fType):
        for nameAttr in self.FieldAttributesInfoList:
            if fType.find(nameAttr[0]) != -1:
                fType = fType.replace(nameAttr[0],"")
                self._field.__setattr__(nameAttr[1], True)
        fType.strip()
        logger.debug("Final Type Name is %s" % fType)
        self._field.setTypeName(fType)

    def __resetVar__(self):
        self._lines = None
        self._isSubFile = False
        self._curFile = None
        self._field = None
#===============================================================================
# A class to parse Pointed T By section in Data Dictionary schema log file output
#===============================================================================
class PointedToBySectionParser(IDDSectionParser):
    # Useful constants
    POINTED_TO_BY_VALUE = re.compile("field \(#(?P<fieldNo>[0-9.]+)\) (of the .*? sub-field \(#(?P<subFieldNo>[0-9.]+)\))?.*of the (?P<Name>.*) File \(#(?P<FileNo>[0-9.]+)\)$")
    POINTED_TO_BY_VALUE_INDEX = 15
    def __init__(self):
        self._global = None
        self._section = IDataDictionaryListFileLogParser.POINTED_TO_BY_SECTION
    def onSectionStart(self, line, section, Global, CrossReference):
        assert self._section == section
        self._global = Global
        self.parseLine(line, Global, CrossReference)
    def onSectionEnd(self, line, section, Global, CrossReference):
        assert self._section == section
        self._global = None
    def parseLine(self, line, Global, CrossReference):
        assert self._global
        strippedLine = line.rstrip(" ")
        if len(strippedLine) == 0:
            return
        value = strippedLine[self.POINTED_TO_BY_VALUE_INDEX:]
        logger.debug("Parsing line [%s]" % value)
        result = self.POINTED_TO_BY_VALUE.search(value)
        if result:
            fileManNo = result.group("FileNo")
            fieldNo = result.group('fieldNo')
            subFileNo = result.group('subFieldNo')
            logger.debug("File # %s, field # %s, sub-field # %s" % (fileManNo, fieldNo, subFileNo))
            pointedByGlobal = CrossReference.getGlobalByFileNo(fileManNo)
            if pointedByGlobal:
                self._global.addPointedToByFile(pointedByGlobal, fieldNo, subFileNo)
                logger.debug("added global to pointed list: %s, %s, %s" %
                            (fileManNo, fieldNo, subFileNo))
            else:
                logger.warning("Could not find global based on %s, %s" %
                               (fileManNo, result.group("Name")))
        else:
            logger.error("Could not parse pointer reference [%s] in file [%s]" % (line, self._global.getFileNo()))

class IDataDictionaryListFileLogParser:
    # Enum for section value
    DESCRIPTION_SECTION = 1
    COMPILED_CROSS_REFERENCE_ROUTINE_SECTION = 2
    FILE_SCREEN_SECTION = 3
    SPECIAL_LOOKUP_ROUTINE_SECTION = 4
    POST_SELECTION_ACTION_SECTION = 5
    DD_ACCESS_SECTION = 6
    RD_ACCESS_SECTION = 7
    WR_ACCESS_SECTION = 8
    DEL_ACCESS_SECTION = 9
    LAYGO_ACCESS_SECTION = 10
    AUDIT_ACCESS_SECTION = 11
    IDENTIFIED_BY_SECTION = 12
    POINTED_TO_BY_SECTION = 13
    A_FIELD_IS_SECTION = 14
    TRIGGERED_BY_SECTION = 15
    CROSS_SECTION = 16
    REFERENCED_BY_SECTION = 17
    INDEXED_BY_SECTION = 18
    PRIMARY_KEY_SECTION = 19
    FILEMAN_FIELD_SECTION = 20
    FILES_POINTED_TO_SECTION = 21
    FILE_RECORD_INDEXED_SECTION = 22
    SUBFILE_RECORD_INDEXED_SECTION = 23
    INPUT_TEMPLATE_SECTION = 24
    PRINT_TEMPLATE_SECTION = 25
    SORT_TEMPLATE_SECTION = 26
    FORM_BLOCKS_SECTION = 27
#===============================================================================
# A class to parse Data Dictionary log file output and generate Global/Package dependencies
#===============================================================================
class DataDictionaryListFileLogParser(IDataDictionaryListFileLogParser):
    # this is the global member
    DESCRIPTION_START = re.compile(r"^-{254,254}$")
    COMPILED_CROSS_REFERENCE_ROUTINE_START = re.compile("^COMPILED CROSS-REFERENCE ROUTINE:")
    FILE_SCREEN_START = re.compile("^FILE SCREEN \(SCR-node\) :")
    SPECIAL_LOOKUP_ROUTINE_START = re.compile("^SPECIAL LOOKUP ROUTINE :")
    POST_SELECTION_ACTION_START = re.compile("^POST-SELECTION ACTION +:")
    DD_ACCESS_START = re.compile("^ +DD ACCESS:")
    RD_ACCESS_START = re.compile("^ +RD ACCESS:")
    WR_ACCESS_START = re.compile("^ +WR ACCESS:")
    DEL_ACCESS_START = re.compile("^ +DEL ACCESS:")
    LAYGO_ACCESS_START = re.compile("^ +LAYGO ACCESS:")
    AUDIT_ACCESS_START = re.compile("^ +AUDIT ACCESS:")
    IDENTIFIED_BY_START = re.compile("^IDENTIFIED BY:")
    POINTED_TO_BY_START = re.compile("^POINTED TO BY: ")
    A_FIELD_IS_START = re.compile("^A FIELD IS$")
    TRIGGERED_BY_START = re.compile("^TRIGGERED BY :")
    CROSS_START = re.compile("^CROSS$")
    REFERENCED_BY_START = re.compile("^REFERENCED BY:")
    INDEXED_BY_START = re.compile("^INDEXED BY: ")
    PRIMARY_KEY_START = re.compile("^PRIMARY KEY: ")
    FILEMAN_FIELD_START = re.compile("(?P<FileNo>^[.0-9]+),(?P<FieldNo>[.0-9]+)")
    FILES_POINTED_TO_START = re.compile("^ +FILES POINTED TO +FIELDS$")
    FILE_RECORD_INDEXED_START = re.compile("^File #[.0-9]+$")
    SUBFILE_RECORD_INDEXED_START = re.compile("^Subfile #[.0-9]+$")
    INPUT_TEMPLATE_START = re.compile("^INPUT TEMPLATE\(S\):$")
    PRINT_TEMPLATE_START = re.compile("^PRINT TEMPLATE\(S\):$")
    SORT_TEMPLATE_START = re.compile("^SORT TEMPLATE\(S\):$")
    FORM_BLOCKS_START = re.compile("^FORM\(S\)/BLOCK\(S\):$")

    def __init__(self, CrossReference):
        assert CrossReference
        self._crossRef = CrossReference
        self._curSect = None
        self._curParser = None
        self._curGlobal = None
        self._sectionHeaderRegEx = dict()
        self._sectionParserDict = dict()
        self.__initSectionHeaderRegEx__()
        self.__initSectionParser__()
    def __initSectionHeaderRegEx__(self):
        self._sectionHeaderRegEx[self.DESCRIPTION_START] = self.DESCRIPTION_SECTION
        self._sectionHeaderRegEx[self.COMPILED_CROSS_REFERENCE_ROUTINE_START] = self.COMPILED_CROSS_REFERENCE_ROUTINE_SECTION
        self._sectionHeaderRegEx[self.FILE_SCREEN_START] = self.FILE_SCREEN_SECTION
        self._sectionHeaderRegEx[self.SPECIAL_LOOKUP_ROUTINE_START] = self.SPECIAL_LOOKUP_ROUTINE_SECTION
        self._sectionHeaderRegEx[self.POST_SELECTION_ACTION_START] = self.POST_SELECTION_ACTION_SECTION
        self._sectionHeaderRegEx[self.DD_ACCESS_START] = self.DD_ACCESS_SECTION
        self._sectionHeaderRegEx[self.RD_ACCESS_START] = self.RD_ACCESS_SECTION
        self._sectionHeaderRegEx[self.WR_ACCESS_START] = self.WR_ACCESS_SECTION
        self._sectionHeaderRegEx[self.DEL_ACCESS_START] = self.DEL_ACCESS_SECTION
        self._sectionHeaderRegEx[self.LAYGO_ACCESS_START] = self.LAYGO_ACCESS_SECTION
        self._sectionHeaderRegEx[self.AUDIT_ACCESS_START] = self.AUDIT_ACCESS_SECTION
        self._sectionHeaderRegEx[self.IDENTIFIED_BY_START] = self.IDENTIFIED_BY_SECTION
        self._sectionHeaderRegEx[self.POINTED_TO_BY_START] = self.POINTED_TO_BY_SECTION
        self._sectionHeaderRegEx[self.A_FIELD_IS_START] = self.A_FIELD_IS_SECTION
        self._sectionHeaderRegEx[self.TRIGGERED_BY_START] = self.TRIGGERED_BY_SECTION
        self._sectionHeaderRegEx[self.CROSS_START] = self.CROSS_SECTION
        self._sectionHeaderRegEx[self.REFERENCED_BY_START] = self.REFERENCED_BY_SECTION
        self._sectionHeaderRegEx[self.INDEXED_BY_START] = self.INDEXED_BY_SECTION
        self._sectionHeaderRegEx[self.PRIMARY_KEY_START] = self.PRIMARY_KEY_SECTION
        # START OF FILEMAN FIELD SECTION
        self._sectionHeaderRegEx[self.FILEMAN_FIELD_START] = self.FILEMAN_FIELD_SECTION
        self._sectionHeaderRegEx[self.FILES_POINTED_TO_START] = self.FILES_POINTED_TO_SECTION
        self._sectionHeaderRegEx[self.FILE_RECORD_INDEXED_START] = self.FILE_RECORD_INDEXED_SECTION
        self._sectionHeaderRegEx[self.SUBFILE_RECORD_INDEXED_START] = self.SUBFILE_RECORD_INDEXED_SECTION
        self._sectionHeaderRegEx[self.INPUT_TEMPLATE_START] = self.INPUT_TEMPLATE_SECTION
        self._sectionHeaderRegEx[self.PRINT_TEMPLATE_START] = self.PRINT_TEMPLATE_SECTION
        self._sectionHeaderRegEx[self.SORT_TEMPLATE_START] = self.SORT_TEMPLATE_SECTION
        self._sectionHeaderRegEx[self.FORM_BLOCKS_START] = self.FORM_BLOCKS_SECTION
    def __initSectionParser__(self):
        self._sectionParserDict[self.POINTED_TO_BY_SECTION] = PointedToBySectionParser()
        self._sectionParserDict[self.DESCRIPTION_SECTION] = DescriptionSectionParser()
        self._sectionParserDict[self.FILEMAN_FIELD_SECTION] = FileManFieldSectionParser()
    def printResult(self):
        logger.debug("Total Routines are %d" % len(self._crossRef.getAllRoutines()))

    def printGlobal(self, globalName, visitor=None):
        globalVar = self._crossRef.getGlobalByName(globalName)
        if globalVar:
            if visitor:
                visitor.visitGlobal(globalVar)
            else:
                globalVar.printResult()
        else:
            logger.error ("Global: %s Not Found!" % globalName)
    def getCrossReference(self):
        return self._crossRef
    #===========================================================================
    # pass the log file and get all routines ready
    #===========================================================================
    def parseAllDataDictionaryListLog(self, dirName, pattern):
        dataDictionaryLogFiles = os.path.join(dirName, pattern)
        allFiles = glob.glob(dataDictionaryLogFiles)
        for logFileName in allFiles:
            logger.info("Start paring log file [%s]" % logFileName)
            self.__parseDataDictionaryLogFile__(logFileName)

    def __parseDataDictionaryLogFile__(self, logFileName):
        if not os.path.exists(logFileName):
            logger.error("File: %s does not exist" % logFileName)
            return
        logFileHandle = open(logFileName, "rb")
        baseName = os.path.basename(logFileName)
        fileNo = baseName[:-len(".schema")]
        self._curGlobal = self._crossRef.getGlobalByFileNo(fileNo)
        if not self._curGlobal:
            logger.error("Could not find global based on file# %s" % fileNo)
            return
        for line in logFileHandle:
            # handle the empty line
            line = line.rstrip("\r\n")
            if len(line) == 0: # ignore the empty line
                continue
            section = self.__isSectionHeader__(line)
            if section:
                if section != self.FILEMAN_FIELD_SECTION:
                    logger.debug("Current Section is %d [%s]" % (section, line))
                if self._curSect and self._curParser:
                    self._curParser.onSectionEnd(line, self._curSect, self._curGlobal, self._crossRef)
                self._curSect = section
                self._curParser = self._sectionParserDict.get(self._curSect)
                if self._curParser:
                    self._curParser.onSectionStart(line, self._curSect, self._curGlobal, self._crossRef)
            elif self._curSect and self._curParser:
                self._curParser.parseLine(line, self._curGlobal, self._crossRef)
    def __isSectionHeader__(self, curLine):
        for (regex, section) in self._sectionHeaderRegEx.iteritems():
            if regex.search(curLine):
                return section
        return None

def testOutput(DDFileParser):
  #DDFileParser.printGlobal("^DIBT")
  DDFileParser.printGlobal("^DPT")
  #DDFileParser.printGlobal("^GECS(2100")
  #DDFileParser.printGlobal("^ONCO(165.5")
  #DDFileParser.printGlobal("^ORD(100.99")
  #DDFileParser.printGlobal("^ICD9")
  #DDFileParser.printGlobal("^YSD(627.8")
  logger.info("Total FileMan Field Note Title is %d" % len(FileManFieldSectionParser.totalFieldNotes))
  for item in FileManFieldSectionParser.totalFieldNotes:
      logger.info(item)

import logging
from CallerGraphParser import createCallGraphLogAugumentParser
from CallerGraphParser import parseAllCallGraphLogWithArg

def parseDataDictionaryLogFile(crossRef, fileSchemaDir):
    DDFileParser = DataDictionaryListFileLogParser(crossRef)
    DDFileParser.parseAllDataDictionaryListLog(fileSchemaDir, "*.schema")
    DDFileParser.parseAllDataDictionaryListLog(fileSchemaDir, ".*.schema")
    return DDFileParser

def createDataDictionaryAugumentParser():
    parser = argparse.ArgumentParser(add_help=False) # no help page
    argGroup = parser.add_argument_group("Data Dictionary Parser Auguments")
    argGroup.add_argument('-fs', '--fileSchemaDir', required=True,
                          help='VistA File Man Schema log Directory')
    return parser
if __name__ == '__main__':
    callLogArgParser = createCallGraphLogAugumentParser()
    dataDictArgParser = createDataDictionaryAugumentParser()
    parser = argparse.ArgumentParser(
          description='VistA Cross-Reference Data Dictionary Log Files Parser',
          parents=[callLogArgParser, dataDictArgParser])
    result = parser.parse_args();
    initConsoleLogging()
    logFileParser = parseAllCallGraphLogWithArg(result)
    DDFileParser = parseDataDictionaryLogFile(logFileParser.getCrossReference(),
                                              result.fileSchemaDir)
    testOutput(DDFileParser)
