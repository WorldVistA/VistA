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

## @class ORActions
## Order Entry Actions

'''
Order Entry Action class. Extends Actions.

Created on Apr 20, 2012
@author: pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import time
import TestHelper
from Actions import Actions

class ORActions (Actions):
    '''
    This class extends the Actions class with methods specific to actions performed
    through the Roll and Scroll interface for the Clinician Menu.
    '''
    def __init__(self, VistAconn, user=None, code=None):
        Actions.__init__(self, VistAconn, user, code)

    def signon (self):
        ''' This provides a signon via ^XUP or ^ZU depending on the value of acode'''
        if self.acode is None:
            self.VistA.write('S DUZ=1,DUZ(0)="@" D ^XUP')
            self.VistA.wait('OPTION NAME:');
            self.VistA.write('OR MAIN MENU CLINICIAN')
        else:
            self.VistA.write('D ^ZU')
            self.VistA.wait('ACCESS CODE:');
            self.VistA.write(self.acode)
            self.VistA.wait('VERIFY CODE:');
            self.VistA.write(self.vcode)
            self.VistA.wait('//');
            self.VistA.write('')

    def verproblems (self, ssn, vlist):
        '''Verify Problem List problems via CC action in CPRS Clinician Menu'''
        self.VistA.wait('Clinician Menu')
        self.VistA.write('CPRS Clinician Menu')
        self.VistA.wait('Select Patient:')
        self.VistA.write('Find Patient')
        self.VistA.wait('Select PATIENT NAME:');
        self.VistA.write(ssn)
        self.VistA.wait('Select:');
        self.VistA.write('CC')
        self.VistA.wait('Select chart component:');
        self.VistA.write('Problems')
        for vitem in vlist:
            self.VistA.wait(vitem)
        self.VistA.wait('Select:');
        self.VistA.write('Q')
        self.VistA.wait('Select Patient:');
        self.VistA.write('Q')
        self.VistA.wait('Clinician Menu');
        self.VistA.write('\r\r')
