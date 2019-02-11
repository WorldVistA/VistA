#---------------------------------------------------------------------------
# Copyright 2018 The Open Source Electronic Health Record Alliance
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
#---------------------------------------------------------------------------

import os
import re
import os.path
import json

from datetime import datetime
from LogManager import logger
from ICRSchema import ICR_FILE_KEYWORDS, DATE_TIME_FIELD, INTEGRATION_REFERENCES_LIST
from ICRSchema import isSubFile, isSubFileField, isWordProcessingField

# regular  expression for fields
START_OF_RECORD = re.compile('^(?P<name>NUMBER): (?P<number>[0-9]+)')
GENERIC_START_OF_RECORD = re.compile('^( *)?(?P<name>[A-Z^/]+( [A-Z/#^]+)*): ') # TODO? max of 2 spaces
DBA_COMMENTS = re.compile('^( +)?(?P<name>DBA Comments): ')
GENERIC_FIELD_RECORD = re.compile('( )(?P<name>[A-Z^/]+( [A-Z/^#]+)*): ')

LINES_TO_IGNORE = [
    re.compile('^-+$')
]

def convertICRToJson(inputFilename, outputFilename):
    icrFileToJson = ICRFileToJson()
    icrFileToJson.parse(inputFilename, outputFilename)

"""
This is the class to parse the VA ICR file and convert to JSON format.
"""
class ICRFileToJson(object):
    def __init__(self):
        self._curRecord = None # current record object
        self._outObject = [] # store output result
        self._curField = None
        self._curStack = []

    def parse(self, inputFilename, outputFilename):
        with open(inputFilename,'r') as ICRFile:
            curLineNo = 0
            DBAComments = False
            generalDescription = False
            subscribingDetails = False
            curNumber = None
            for line in ICRFile:
                line = line.rstrip("\r\n")
                curLineNo +=1
                # get rid of lines that are ignored
                if self.isIgnoredLine(line):
                    continue
                match = INTEGRATION_REFERENCES_LIST.match(line)
                if match:
                    # Skip this line. Use getDate() to parse date
                    continue
                match = START_OF_RECORD.match(line)
                if match:
                    name = match.group('name')
                    number = match.group('number')
                    skipField = False
                    isFreeTextField = DBAComments or generalDescription or subscribingDetails
                    if isFreeTextField:
                        # Check if the number is matches what we're currently processing
                        skipField = number == curNumber
                    if not skipField:
                        curNumber = number
                        DBAComments = False
                        generalDescription = False
                        subscribingDetails = False
                        self._startOfNewItem(name, number, match, line)
                        continue
                match = GENERIC_START_OF_RECORD.search(line)
                if not match:
                    match = DBA_COMMENTS.match(line)
                    if match:
                        DBAComments = True
                if match and match.group('name') in ICR_FILE_KEYWORDS:
                    fieldName = match.group('name')
                    if fieldName == 'DBA Comments':
                        DBAComments = True
                    elif fieldName == 'GENERAL DESCRIPTION':
                        generalDescription = True
                    elif fieldName == 'SUBSCRIBING DETAILS':
                        subscribingDetails = True
                    if DBAComments:
                        if fieldName == 'DATE/TIME EDITED' or fieldName == 'NUMBER':
                            DBAComments = False
                    elif generalDescription:
                        if line.startswith("  STATUS:"):  # Starts with exactly 2 spaces
                            generalDescription = False
                    elif subscribingDetails:
                        # This assumes that 'Subscribing Details' may start
                        # with a field name but will never contain a field name
                        # in the middle of the entry
                        if fieldName in ICR_FILE_KEYWORDS and 'SUBSCRIBING DETAILS' in self._curRecord:
                            subscribingDetails = False
                    if DBAComments:
                        fieldName = 'DBA Comments'
                        if self._curField == fieldName:
                            self._appendWordsFieldLine(line)
                        else:
                            self._curField = fieldName
                            name = match.group('name') # this is the name part
                            restOfLine = line[match.end():]
                            self._curRecord[name] = restOfLine.strip()
                    elif generalDescription:
                        fieldName = 'GENERAL DESCRIPTION'
                        if self._curField == fieldName:
                            self._appendWordsFieldLine(line)
                        else:
                            # Starting to process general description
                            self._curField = fieldName
                            self._rewindStack();
                            self._findKeyValueInLine(match, line)
                    elif subscribingDetails:
                        fieldName = 'SUBSCRIBING DETAILS'
                        if self._curField == fieldName:
                            self._appendWordsFieldLine(line)
                        else:
                            self._curField = fieldName
                            name = match.group('name') # this is the name part
                            restOfLine = line[match.end():]
                            self._curRecord[name] = restOfLine.strip()
                    elif isSubFile(fieldName):
                        self._curField = fieldName
                        self._startOfSubFile(match, line)
                    else:
                        """ Check to see if fieldName is already in the out list """
                        if isWordProcessingField(self._curField):
                            if self._ignoreKeywordInWordProcessingFields(fieldName):
                                self._appendWordsFieldLine(line)
                                continue
                        # figure out where to store the record
                        self._curField = fieldName
                        self._rewindStack()
                        self._findKeyValueInLine(match, line)
                elif self._curField and self._curField in self._curRecord:
                    if not line.strip() and not isWordProcessingField(self._curField):
                        # Ignore blank line
                        continue
                    self._appendWordsFieldLine(line)
                else:
                    if self._curRecord:
                        if not line.strip():
                            continue
                        logger.debug('No field associated with line %s: %s ' %
                                      (curLineNo, line))
        # TODO: Copy + paste from '_startOfNewItem()'
        self._curField = None
        self._rewindStack()
        if self._curRecord:
            self._outObject.append(self._curRecord)
        outputDir = os.path.dirname(outputFilename)
        if not os.path.exists(outputDir):
            # Will also create intermediate directories if needed
            os.makedirs(outputDir)
        with open(outputFilename, 'w') as out_file:
            json.dump(self._outObject,out_file, indent=4)

    def _startOfNewItem(self, name, number, matchObj, line):
        self._curField = None
        self._rewindStack()
        if self._curRecord:
            self._outObject.append(self._curRecord)
        self._curRecord = {}
        self._curRecord[name] = number
        self._findKeyValueInLine(matchObj, line)

    def _findKeyValueInLine(self, match, line):
        """ parse all name value pair in a line and put back in self._curRecord"""
        name = match.group('name'); # this is the name part
        """ add logic to ignore some of the field """

        # now find if there is any other name value pair in the same line
        restOfLine = line[match.end():]
        allFlds = []
        if name in ICR_FILE_KEYWORDS:
            allFlds = [name]
        allmatches = []
        for m in GENERIC_FIELD_RECORD.finditer(restOfLine):
            if m.group('name') in ICR_FILE_KEYWORDS: # ignore non-keyword
                allmatches.append(m)
                allFlds.append(m.group('name'))
        if allmatches:
            changeField = False
            for idx, rm in enumerate(allmatches):
                if idx == 0 and name in ICR_FILE_KEYWORDS:
                    val = restOfLine[:rm.start()].strip()
                    self._curRecord[name] = val
                    changeField = not(name == 'DESCRIPTION' and val == "")
                if idx == len(allmatches) -1:
                    if changeField:
                        self._curField = rm.group('name')
                        self._curRecord[self._curField] = restOfLine[rm.end():].strip()
                    else:
                        self._curRecord[rm.group('name')] = restOfLine[rm.end():].strip()
                else:
                    if changeField:
                        self._curField = allmatches[idx-1].group('name')
                        self._curRecord[self._curField] = restOfLine[allmatches[idx-1].end():rm.start()].strip()
                    else:
                        self._curRecord[allmatches[idx-1].group('name')] = restOfLine[allmatches[idx-1].end():rm.start()].strip()
        else:
            if name == 'GENERAL DESCRIPTION':
                self._curRecord[name] = [line[match.end():].strip()]
            else:
                self._curRecord[name] = line[match.end():].strip()

        dtFields = set(allFlds) & DATE_TIME_FIELD
        for fld in dtFields:
            self._curRecord[fld] = self._convertDateTimeField(self._curRecord[fld])

    def _convertDateTimeField(self, inputDt):
        try:
            if inputDt.find('@') < 0:
                return datetime.strptime(inputDt, '%b %d, %Y').strftime('%Y/%m/%d')
            else:
                return datetime.strptime(inputDt, '%b %d, %Y@%H:%M').strftime('%Y/%m/%d %H:%M')
        except ValueError:
            return inputDt

    def _startOfSubFile(self, match, line):
        """
            for start of the sub file, we need to add a list element to the current record if it not there
            reset _curRecord to be a new one, and push old one into the stack
        """
        subFile = match.group('name')
        while self._curStack: # we are in subfile mode
            prevSubFile = self._curStack[-1][1]
            if prevSubFile == subFile: # just continue with more of the same subfile
                self._curStack[-1][0].setdefault(subFile, []).append(self._curRecord) # append the previous result
                break;
            else: # this is a different subfile # now check if it is a nested subfile
                if isSubFileField(prevSubFile, subFile): # this is a nested subFile, push to stack
                    self._curStack.append((self._curRecord, subFile))
                    break;
                else: # this is a different subFile now:
                    preStack = self._curStack.pop()
                    preStack[0].setdefault(preStack[1], []).append(self._curRecord)
                    self._curRecord = preStack[0]
        if not self._curStack:
            self._curStack.append((self._curRecord, subFile)) # push a tuple, the first is the record, the second is the subFile field
        self._curRecord = {}
        self._findKeyValueInLine(match, line)

    def _rewindStack(self):
        while self._curStack: # we are in subFile Mode
            if not isSubFileField(self._curStack[-1][1], self._curField):
                preStack = self._curStack.pop()
                preStack[0].setdefault(preStack[1],[]).append(self._curRecord)
                self._curRecord = preStack[0]
            else:
                break

    """ This will append the line in word processing fields """
    def _appendWordsFieldLine(self, line):
        if not (type(self._curRecord[self._curField]) is list):
            preVal = self._curRecord[self._curField]
            self._curRecord[self._curField] = []
            self._curRecord[self._curField].append(preVal)
        self._curRecord[self._curField].append(line.strip())

    def isIgnoredLine(self, line):
        for regEx in LINES_TO_IGNORE:
            if regEx.match(line):
                logger.debug('Ignore line %s', line)
                return True
        return False

    def _ignoreKeywordInWordProcessingFields(self, fieldName):
        """ This is a HACK to circuvent the case that there is a keyword value like pair
            in the sub file word processing fields
            the keyword is not part of the subFile, we assume it is part of word processing field
            if any of the parent field already has that field.
        """
        if self._curRecord and fieldName in self._curRecord:
            return True
        """ This is some special logic to ignore some of the fields in word processing field """
        if fieldName == 'ROUTINE':
            recordToCheck = self._curRecord
            if self._curStack: # we are in subfile mode and it is a world processing field
                recordToCheck = self._curStack[0][0]
            if 'REMOTE PROCEDURE' in recordToCheck:
                return True
        for stackItem in self._curStack:
            if fieldName in stackItem[0]:
                return True
        return False
