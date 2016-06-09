"""
This file defined the reverse engineered ICR fileman schema.
"""

ICR_FILE_KEYWORDS = set([
    'NUMBER',
    'ID',
    'IA #',
    'FILE NUMBER',
    'GLOBAL ROOT',
    'DATE CREATED',
    'DATE ACTIVATED',
    'CUSTODIAL PACKAGE',
    'CUSTODIAL ISC',
    'USAGE',
    'TYPE',
    'DBIC APPROVAL STATUS',
    'NAME',
    'ROUTINE',
    'ORIGINAL NUMBER',
    # SUB_ID
    'CREATOR',
    'GENERAL DESCRIPTION',
    'STATUS',
    'DURATION',
    'MAIL MESSAGE',
    'GOOD ONLY FOR VERSION',
    'DBA Comments',
    'EDITOR'
])

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
    'FIELD NUMBER': [
        'FIELD NAME',
        'ACCESS',
        'FIELD DESCRIPTION',
        'LOCATION'
    ]
}


SUBFILE_KEYWORDS = reduce(set.union, [set(y) for y in SUBFILE_FIELDS.itervalues()], set()) | set([x for x in SUBFILE_FIELDS.iterkeys()])

ICR_FILE_KEYWORDS = ICR_FILE_KEYWORDS | SUBFILE_KEYWORDS

WORDS_FIELDS = set([
    'FIELD DESCRIPTION',
    'VARIABLES DESCRIPTION',
    'DBA Comments',
    'GLOBAL DESCRIPTION',
    'GENERAL DESCRIPTION',
    'SUBSCRIBING DETAILS'
])