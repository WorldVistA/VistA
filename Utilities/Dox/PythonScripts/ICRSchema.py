# This file defined the reverse engineered ICR fileman schema
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

import re
import os

RPC_FILE_NO = '8994'
RPC_NAME_FIELD_NO = '.01'

""" This is a list of keywords in ICR top level files
    This list is a sequence order of each fields
"""
ICR_FILE_KEYWORDS_LIST = [
    'NUMBER',
    'IA #',
    'FILE NUMBER',
    'GLOBAL ROOT',
    'DATE CREATED',
    'CUSTODIAL PACKAGE',
    'CUSTODIAL ISC',
    'USAGE',
    'TYPE',
    'DBIC APPROVAL STATUS',
    'ROUTINE',
    'NAME',
    'REMOTE PROCEDURE',
    'ORIGINAL NUMBER',
    'GENERAL DESCRIPTION',
    'GLOBAL REFERENCE',
    'STATUS',
    'KEYWORDS',
    'DURATION',
    'EXPIRATION DATE',
    'ID',
    'COMPONENT/ENTRY POINT',
    'SUBSCRIBING PACKAGE',
    'CREATOR',
    'DBA Comments',
    'EDITOR',
    'DATE ACTIVATED',
    # SUB_ID
    'MAIL MESSAGE',
    'GOOD ONLY FOR VERSION',
    'DATE/TIME EDITED',
    'DEFERRED UNTIL',
    'REMINDER',
    'ENTERED',
    'EXPIRES',
    'VERSION',
    'TAG^ROUTINE',
    'DESCRIPTION',
    'COMPONENT',
    'RETURN VALUE TYPE',
    'APP PROXY ALLOWED',
    'WORD WRAP ON',
    'AVAILABILITY',
    'SQL TABLE',
    'SQL COLUMN'
]

""" Convert to a set for fast search """
ICR_FILE_KEYWORDS = set(ICR_FILE_KEYWORDS_LIST)

SUBFILE_FIELDS = {
    'GLOBAL REFERENCE': [
        'FIELD NUMBER',
        'GLOBAL DESCRIPTION'
    ],
    'COMPONENT/ENTRY POINT': [
        'COMPONENT DESCRIPTION',
        'VARIABLES'
    ],
    'VARIABLES': [
        'TYPE',
        'VARIABLES DESCRIPTION'
    ],
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
    ],
    'KEYWORDS': [
    ],
    'VIEWER': [
    ],
    'FIELD NUMBER': [
        'FIELD NAME',
        'ACCESS',
        'FIELD DESCRIPTION',
        'LOCATION'
    ],
    'INPUT PARAMETER': [
      'PARAMETER TYPE',
      'MAXIMUM DATA LENGTH',
      'SEQUENCE NUMBER',
      'REQUIRED'
    ],
    'CROSS REF NUM': [
      'TYPE',
    ],
    'SQL COLUMN': [
      'COLUMN DETAILS',
    ]
}

""" This is to get all the keywords in sub files """
SUBFILE_KEYWORDS = reduce(set.union, [set(y) for y in SUBFILE_FIELDS.itervalues()], set()) | set([x for x in SUBFILE_FIELDS.iterkeys()])

ICR_FILE_KEYWORDS = ICR_FILE_KEYWORDS | SUBFILE_KEYWORDS

WORDS_FIELDS = set([
    'FIELD DESCRIPTION',
    'VARIABLES DESCRIPTION',
    'DBA Comments',
    'GLOBAL DESCRIPTION',
    'GENERAL DESCRIPTION',
    'SUBSCRIBING DETAILS',
    'COMPONENT DESCRIPTION',
    'COLUMN DETAILS'
])

DATE_TIME_FIELD = set([
    'DATE/TIME EDITED',
    'DATE CREATED',
    'DATE ACTIVATED',
    'EXPIRATION DATE',
    'REMINDER',
    'DEFERRED UNTIL'
])

# regular  expression for fields
INTEGRATION_REFERENCES_LIST = re.compile('^[\r\f]?INTEGRATION REFERENCES LIST *(.*)(([01]\d|2[0-3]):([0-5]\d)|24:00) *PAGE')


""" SOME UTILITY FUNCTIONS  """
def isSubFile(field):
    return field in SUBFILE_FIELDS

def isSubFileField(subFile, field):
    return isSubFile(subFile) and field in SUBFILE_FIELDS[subFile]

def isWordProcessingField(field):
    return field in WORDS_FIELDS

def getDate(icrFilename):
    with open(icrFilename,'r') as ICRFile:
        for line in ICRFile:
            line = line.rstrip("\r\n")
            match = INTEGRATION_REFERENCES_LIST.match(line)
            if match:
                return match.group(1).strip()
    # No date specified in the file, try to parse the filename
    # Expected format: <year>_<month>_<day>_IA_Listing_Descriptions.TXT
    filename = os.path.basename(icrFilename)
    s = filename.find("_IA_Listing_Descriptions")
    if s > 0:
        date_str = filename[:s]
        vals = date_str.split("_")
        if len(vals) == 3:
            # Format: <month> <day>, <year>
            return vals[1] + " " + vals[2] + ", " + vals[0]
    return None
