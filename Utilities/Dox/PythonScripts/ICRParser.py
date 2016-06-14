import os
import re
import os.path
import json
import argparse
import pprint
import logging
from LogManager import logger, initConsoleLogging
from ICRSchema import SUBFILE_FIELDS, SUBFILE_KEYWORDS, WORDS_FIELDS, ICR_FILE_KEYWORDS
from ICRSchema import isSubFile, isSubFileField

# regular  expression for fields
START_OF_RECORD = re.compile('^(?P<name>NUMBER): ')
GENERIC_START_OF_RECORD = re.compile('^( {0,2})?(?P<name>[A-Z/]+( [A-Z/#]+)*): ') # max of 2 spaces
DBA_COMMENTS = re.compile('^( +)?(?P<name>DBA Comments): ')
GENERIC_FIELD_RECORD = re.compile('( )(?P<name>[A-Z/]+( [A-Z/#]+)*): ')
# This is dictories of all possible sub-files in the schema
LINES_TO_IGNORE = [
    re.compile('^(\r\f)?INTEGRATION REFERENCES LIST'),
    re.compile('^-+$')
]

"""
This is the class to parse the VA ICR Text file and convert to JSON format.
"""
class ICRParser(object):
    def __init__(self):
        self._totalRecord = 0 # total number of record
        self._curRecord = None # current record object
        self._outObject = [] # store output result
        self._curLineNo = 0
        self._curField = None
        self._curStack = []
    def parse(self, inputFilename, outputFilename):
        with open(inputFilename,'r') as ICRFile:
            for line in ICRFile:
                line = line.rstrip("\r\n")
                self._curLineNo +=1
                """ get rid of lines that are ignored """
                if self.isIgnoredLine(line):
                    continue
                match = START_OF_RECORD.match(line)
                if match:
                    self._startOfNewItem(match, line)
                    continue
                match = GENERIC_START_OF_RECORD.search(line)
                if not match:
                    match = DBA_COMMENTS.match(line)
                if match and match.group('name') in ICR_FILE_KEYWORDS:
                    fieldName = match.group('name')
                    if isSubFile(fieldName):
                        self._curField = fieldName
                        self._startOfSubFile(match, line)
                    else:
                        logger.debug('field name is: %s', fieldName)
                        """ Check to see if fieldName is already in the out list """
                        if self._curField in WORDS_FIELDS:
                            if self._ignoreKeywordInWordProcessingFields(fieldName):
                                self._appendWordsFieldLine(line)
                                continue
                        # figure out where to store the record
                        self._curField = fieldName
                        self._rewindStack();
                        self._findKeyValueInLine(match, line, self._curRecord)
                elif self._curField and self._curField in self._curRecord:
                    if len(line.strip()) == 0 and self._curField not in WORDS_FIELDS:
                        logger.warn('Ignore blank line for current field: [%s]', self._curField)
                        continue
                    self._appendWordsFieldLine(line)
                else:
                    if self._curRecord:
                        if len(line.strip()) == 0:
                            continue
                        print 'No field associated with line %s: %s ' % (self._curLineNo, line)
        logger.info('End of file now')
        if len(self._curStack) > 0:
            self._curField = None
            self._rewindStack()
        if self._curRecord:
            logger.info('Add last record: %s', self._curRecord)
            self._outObject.append(self._curRecord)
        # pprint.pprint(self._outObject);
        with open(outputFilename, 'w') as out_file:
            json.dump(self._outObject,out_file, indent=4)

    def _startOfNewItem(self, matchObj, line):
        logger.debug('Starting of new item: %s', self._curStack)
        logger.info('Starting of new item: %s', line)
        self._curField = None

        self._rewindStack()
        if self._curRecord:
            self._outObject.append(self._curRecord)
        self._curRecord = {}
        self._findKeyValueInLine(matchObj, line, self._curRecord)
        #pprint.pprint(self._curRecord)
    def _findKeyValueInLine(self, match, line, outObj):
        """ parse all name value pair in a line and put back in outObj"""
        name = match.group('name'); # this is the name part
        """ add logic to ignore some of the field """

        # now find if there is any other name value pair in the same line
        restOfLine = line[match.end():]
        allmatches = []
        for m in GENERIC_FIELD_RECORD.finditer(restOfLine):
            if m.group('name') in ICR_FILE_KEYWORDS: # ignore non-keyword
                allmatches.append(m);
        if allmatches:
            for idx, rm in enumerate(allmatches):
                if idx == 0:
                    outObj[name] = restOfLine[:rm.start()].strip()
                if idx == len(allmatches) -1 :
                    outObj[rm.group('name')] = restOfLine[rm.end():].strip()
                else:
                    outObj[allmatches[idx-1].group('name')] = restOfLine[allmatches[idx-1].end():rm.start()].strip()
        else:
            outObj[name] = line[match.end():].strip()

    def _startOfSubFile(self, match, line):
        """
            for start of the sub file, we need to add a list element to the current record if it not there
            reset _curRecord to be a new one, and push old one into the stack
        """
        subFile = match.group('name')
        logger.debug('Start parsing subFile: %s, %s', subFile, line)
        while len(self._curStack) > 0: # we are in subfile mode
            prevSubFile = self._curStack[-1][1]
            if prevSubFile == subFile: # just continue with more of the same subfile
                self._curStack[-1][0].setdefault(subFile, []).append(self._curRecord) # append the previous result
                logger.debug('append previous record the current stack')
                break;
            else: # this is a different subfile # now check if it is a nested subfile
                if isSubFileField(prevSubFile, subFile): # this is a nested subFile, push to stack
                    logger.debug('Nested subFile, push to the stack')
                    self._curStack.append((self._curRecord, subFile))
                    logger.debug('Nested subFile, stack is %s', self._curStack)
                    break;
                else: # this is a different subFile now:
                    logger.debug('different subFile')
                    preStack = self._curStack.pop()
                    logger.debug('Pop stack')
                    preStack[0].setdefault(preStack[1], []).append(self._curRecord)
                    self._curRecord = preStack[0]
                    logger.debug('different subFile, stack is %s', self._curStack)
        if len(self._curStack) == 0:
            self._curStack.append((self._curRecord, subFile)) # push a tuple, the first is the record, the second is the subFile field
            # logger.debug('push to stack: %s', self._curStack)
        self._curRecord = {}
        self._findKeyValueInLine(match, line, self._curRecord)

    def _rewindStack(self):
        logger.debug('rewindStack is called')
        while len(self._curStack) > 0: # we are in subFile Mode
            if not isSubFileField(self._curStack[-1][1], self._curField):
                preStack = self._curStack.pop()
                # logger.debug('pop previous stack item: %s', preStack)
                preStack[0].setdefault(preStack[1],[]).append(self._curRecord)
                # logger.debug('reset current record: %s', preStack)
                self._curRecord = preStack[0]
            else:
                logger.debug('in subFile Fields: %s, record: %s', self._curField, self._curRecord)
                break
    """ This will append the line in word processing fields """
    def _appendWordsFieldLine(self, line):
        logger.debug('append line [%s] to word processing field: [%s]', line, self._curField)
        if not (type(self._curRecord[self._curField]) is list):
            preVal = self._curRecord[self._curField]
            self._curRecord[self._curField] = []
            self._curRecord[self._curField].append(preVal)
        self._curRecord[self._curField].append(line)

    def isIgnoredLine(self, line):
        for regEx in LINES_TO_IGNORE:
            if regEx.match(line):
                logger.warn('Ignore line %s', line)
                return True
        return False

    def _ignoreKeywordInWordProcessingFields(self, fieldName):
        """ This is a HACK to circuvent the case that there is a keyword value like pair
            in the sub file word processing fields
            the keyword is not part of the subFile, we assume it is part of word processing field
            if any of the parent field already has that field.
        """
        logger.debug('current field is [%s]', self._curField)
        if self._curRecord and fieldName in self._curRecord:
            logger.warn('fieldName: [%s] is already parsed, ignore fields', fieldName)
            return True
        """ This is some special logic to ignore some of the fields in word processing field """
        if fieldName == 'ROUTINE':
            recordToCheck = self._curRecord
            if self._curStack and len(self._curStack) > 0: # we are in subfile mode and it is a world processing field
                recordToCheck = self._curStack[0][0]
            if 'REMOTE PROCEDURE' in recordToCheck:
                logger.warn('Ignore ROUTINE field as it is a REMOTE PROCEDURE type')
                return True
        for stackItem in self._curStack:
            if fieldName in stackItem[0]:
                logger.warn('fieldName: [%s] is already parsed in [%s], ignore the words fields', fieldName, stackItem[1])
                return True
        return False

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA ICR File Parser')
    parser.add_argument('icrfile', help='path to the VistA ICR file')
    parser.add_argument('outJson', help='path to the output JSON file')
    result = parser.parse_args()
    initConsoleLogging()
    # initConsoleLogging(logging.DEBUG)
    if result.icrfile:
        icrParser = ICRParser()
        icrParser.parse(result.icrfile, result.outJson)
