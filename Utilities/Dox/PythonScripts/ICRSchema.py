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
    'STATUS',
    'DURATION',
    'EXPIRATION DATE',
    'ID',
    'CREATOR',
    'DBA Comments',
    'EDITOR',
    'DATE ACTIVATED',
    # SUB_ID
    'MAIL MESSAGE',
    'GOOD ONLY FOR VERSION'
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

""" SOME UTILITY FUNCTIONS  """
def isSubFile(field):
        return field in SUBFILE_FIELDS

def isSubFileField(subFile, field):
    return isSubFile(subFile) and field in SUBFILE_FIELDS[subFile]
