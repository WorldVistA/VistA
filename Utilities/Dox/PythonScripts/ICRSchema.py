"""
This file defined the reverse engineered ICR fileman schema.
"""

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
    'AVAILABILITY'
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
    'COMPONENT DESCRIPTION'
])

DATE_TIME_FIELD = set([
    'DATE/TIME EDITED',
    'DATE CREATED',
    'DATE ACTIVATED',
    'EXPIRATION DATE',
    'REMINDER',
    'DEFERRED UNTIL'
])

""" SOME UTILITY FUNCTIONS  """
def isSubFile(field):
    return field in SUBFILE_FIELDS

def isSubFileField(subFile, field):
    return isSubFile(subFile) and field in SUBFILE_FIELDS[subFile]

def isWordProcessingField(field):
    return field in WORDS_FIELDS

def isDateTimeField(field):
    return field in DATE_TIME_FIELD
