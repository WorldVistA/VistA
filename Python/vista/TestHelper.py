#---------------------------------------------------------------------------
# Copyright 2013 PwC
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

## @package TestHelper
## Functional Test Helpers

'''
Functional Test Helper Classes

Created on Mar 2, 2012
@author pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import csv
import logging

class TestError(Exception):
    ''' The TestError class extends the Exception class and is used to handle unexpected test results '''
    def __init__(self, value):
        self.value = value
    def __str__(self):
        return repr(self.value)

class CSVFileReader(object):
    ''' The CSVFileReader class extends the object class.

    CSVFileReader provides the getfiledata() method to open a CSV file and return a table or specified row (record)
    '''

    def getfiledata (self, fname, fhkey, getrow=None):
        '''This method opens a CSV file with DictReader and returns a table or specified row'''
        infile = open(fname)
        csvreader = csv.DictReader(infile, delimiter='|')
        table = {}
        for rowdata in csvreader:
            key = rowdata.pop(fhkey)
            table[key] = rowdata
        if getrow is None:
            return table
        else:
            row = {getrow: table[getrow]}
            return row
