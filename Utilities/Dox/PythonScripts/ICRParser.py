import os
import re
import os.path
import json
import argparse


# regular  expression for fields
START_OF_RECORD = re.compile('^NUMBER: [0-9]+ ')
GENERIC_START_OF_RECORD = re.compile('^( +)?(?P<name>[A-Z/]+( [A-Z/#]+)?): ')
GENERIC_FIELD_RECORD = re.compile('( )?(?P<name>[A-Z/]+( [A-Z/#]+)?): ')
# This is dictories of all possible sub-files in the schema
SUBFILE_FIELDS = {
    'GLOBAL REFERENCE': [
        'FIELD NUMBER',
        'FIELD NAME',
        'ACCESS',
        'GLOBAL DESCRIPTION'
    ],
    'COMPONENT/ENTRY POINT': [
        'COMPONENT DESCRIPTION',
        'VARIABLES'
    ],
    'VARIABLES': [
        'TYPE',
        'VARIABLES DESCRIPTION'
    ]
    'SUBSCRIBING PACKAGE': [
        'ISC',
        'SUBSCRIBING DETAILS'
    ],
    'DATE/TIME EDITED': [
        'ACTION',
        'AT THE REQUEST OF',
        'WITH CONCURRENCE OF'
    ],
    'EDITOR': [
        'DATE/TIME EDITED'
    ]
}

class ICRParser(object):
    def __init__(self):
        self._totalRecord = 0 # total number of record
        self._curRecord = None # current record object
        self._outObject = [] # store output result
        self._curSubFile = []
    def parse(self, filename):
        with open(filename,'r') as ICRFile:
            for line in ICRFile:
                match = START_OF_RECORD.search(line):
                if match:
                    self._startOfNewItem(match, line)
                    continue
                match = GENERIC_START_OF_RECORD.search(line)
                if match:
                    fieldName = match.group('name')
                    if self._isSubFile(fieldName):
                        self._startOfSubFile()
                    if startm:
                        print startm.group('name');
                        newstart = line[startm.end():]
                        #print "start of seaching line from: ", newstart
                        for result in GENERIC_FIELD_RECORD.finditer(newstart):
                            print result.group('name');

    def _isSubFile(self, field):
        return field in SUBFILE_FIELDS
    def _isSubFileField(self, subFile, field):
        return self._isSubFile(subFile) && field in SUBFILE_FIELDS[subFile]
    def _startOfNewItem(self, matchObj, line):
        if self._curRecord:
            self._outObject.append(self._curRecord)
        self.curRecord = {}
    def _startOfSubFile(self, subFile, line):

    def _findKeyValue
    def _startOfSubFile(self, )
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA ICR File Parser')
    parser.add_argument('icrfile', help='path to the VistA ICR file')
    result = parser.parse_args()
    if result.icrfile:
        icrParser = ICRParser()
        icrParser.parse(result.icrfile)
