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

## @class PATActions
## Patient Registration Actions

'''
Add Patients class.  Extends Actions.

Created on Mar 26, 2012
@author: pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import time
import TestHelper
from Actions import Actions

class PATActions (Actions):
    '''
    This class extends the Actions class with methods specific to actions performed
    through the Roll and Scroll interface to add patients to system.  Two methods are provided;
    patientaddcsv() which adds a single record from a CSV file and patientaddallcsv() which
    adds all patient records from a CSV file.
    '''
    def __init__(self, VistAconn, user=None, code=None):
        Actions.__init__(self, VistAconn, user, code)

    def setuser (self, user=None, code=None):
        '''Set access code and verify code'''
        self.acode = user
        self.vcode = code

    def signon (self):
        '''Signon via XUP'''
        self.VistA.write('S DUZ=1 D ^XUP')

    def signoff (self):
        '''Signoff and halt'''
        self.VistA.write('')
        self.VistA.write('h\r\r')

    def patientaddcsv(self, ssn, pfile=None, getrow=None):
        '''Add a patient from a specified record of a specified CSV file'''
        prec = [1]
        if pfile is not None:
            preader = TestHelper.CSVFileReader()
            prec = preader.getfiledata(pfile, 'key', getrow)
        for pitem in prec:
            self.signon()
            self.VistA.wait('OPTION NAME');
            self.VistA.write('Register a Patient')
            self.VistA.wait('PATIENT NAME');
            self.VistA.write(prec[pitem]['fullname'].rstrip().lstrip())
            self.VistA.wait('NEW PATIENT');
            self.VistA.write('YES')
            self.VistA.wait('SEX');
            self.VistA.write(prec[pitem]['sex'].rstrip().lstrip())
            self.VistA.wait('DATE OF BIRTH');
            self.VistA.write(prec[pitem]['dob'].rstrip().lstrip())
            self.VistA.wait('SOCIAL SECURITY NUMBER');
            self.VistA.write(ssn)
            self.VistA.wait('TYPE');
            self.VistA.write(prec[pitem]['type'].rstrip().lstrip())
            self.VistA.wait('PATIENT VETERAN');
            self.VistA.write(prec[pitem]['veteran'].rstrip().lstrip())
            self.VistA.wait('SERVICE CONNECTED');
            self.VistA.write(prec[pitem]['service'].rstrip().lstrip())
            self.VistA.wait('MULTIPLE BIRTH INDICATOR');
            self.VistA.write(prec[pitem]['twin'].rstrip().lstrip())
            self.VistA.wait('//');
            self.VistA.write('^\r')
            self.VistA.wait('MAIDEN NAME');
            self.VistA.write(prec[pitem]['maiden'].rstrip().lstrip())
            self.VistA.wait('PLACE OF BIRTH');
            self.VistA.write(prec[pitem]['cityob'].rstrip().lstrip())
            self.VistA.wait('PLACE OF BIRTH');
            self.VistA.write(prec[pitem]['stateob'].rstrip().lstrip())
            self.VistA.wait('');
            self.VistA.write('\r\r\r')

    def patientaddallcsv(self, pfile):
        '''Add ALL patients from specified CSV '''
        preader = TestHelper.CSVFileReader()
        prec = preader.getfiledata(pfile, 'key')
        for pitem in prec:
            self.signon()
            self.VistA.wait('OPTION NAME');
            self.VistA.write('Register a Patient')
            self.VistA.wait('PATIENT NAME');
            self.VistA.write(prec[pitem]['fullname'].rstrip().lstrip())
            self.VistA.wait('NEW PATIENT');
            self.VistA.write('YES')
            self.VistA.wait('SEX');
            self.VistA.write(prec[pitem]['sex'].rstrip().lstrip())
            self.VistA.wait('DATE OF BIRTH');
            self.VistA.write(prec[pitem]['dob'].rstrip().lstrip())
            self.VistA.wait('SOCIAL SECURITY NUMBER');
            self.VistA.write(pitem)
            self.VistA.wait('TYPE');
            self.VistA.write(prec[pitem]['type'].rstrip().lstrip())
            self.VistA.wait('PATIENT VETERAN');
            self.VistA.write(prec[pitem]['veteran'].rstrip().lstrip())
            self.VistA.wait('SERVICE CONNECTED');
            self.VistA.write(prec[pitem]['service'].rstrip().lstrip())
            self.VistA.wait('MULTIPLE BIRTH INDICATOR');
            self.VistA.write(prec[pitem]['twin'].rstrip().lstrip())
            if str(prec[pitem]['pdup'].rstrip().lstrip()) is '1':
                self.VistA.wait('as a new patient')
                self.VistA.write('Yes')
            self.VistA.wait('//');
            self.VistA.write('^\r')
            self.VistA.wait('MAIDEN NAME');
            self.VistA.write(prec[pitem]['maiden'].rstrip().lstrip())
            self.VistA.wait('PLACE');
            self.VistA.write(prec[pitem]['cityob'].rstrip().lstrip())
            self.VistA.wait('PLACE');
            self.VistA.write(prec[pitem]['stateob'].rstrip().lstrip())
            self.VistA.wait('');
            self.VistA.write('\r\r\r')
