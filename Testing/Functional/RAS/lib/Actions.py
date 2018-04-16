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

## @class Actions
## VistA Actions (base class)

'''
Action class. Extends object.

Created on Apr 20, 2012
@author: pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import time
import sys
import TestHelper

class Actions (object):
    ''' This class extends the object class with methods specific to actions performed
    through the VistA Roll and Scroll interface.'''
    def __init__(self, VistAconn, scheduling=None, user=None, code=None):
        self.sched = scheduling
        self.acode = user
        self.vcode = code
        self.VistA = VistAconn

    def signon (self):
        ''' This provides a signon via ^XUP or ^ZU depending on the value of acode'''
        if self.acode is None:
            self.VistA.write('S DUZ=1,DUZ(0)="@" D ^XUP')
        else:
            self.VistA.write('D ^ZU')
            self.VistA.wait('ACCESS CODE:');
            self.VistA.write(self.acode)
            self.VistA.wait('VERIFY CODE:');
            self.VistA.write(self.vcode)
            self.VistA.wait('//');
            self.VistA.write('')

    def signoff (self):
        '''Signoff and halt'''
        if self.acode is None:
            self.VistA.write('^\r^\r^\rh\r')
        else:
            self.VistA.write('^\r^\r^\r\r\r\r')

    def logflow(self, rlist):
        ''' This method call XTFCR to create flow diagrams of routines'''
        self.VistA.write('S DUZ=1 D ^XUP')
        self.VistA.wait('OPTION NAME')
        self.VistA.write('')
        self.VistA.write('D ^XTFCR')
        rval = self.VistA.multiwait(['All Routines', 'Routine:'])
        if rval == 0:
            self.VistA.write('No')
            for ritem in rlist:
                self.VistA.wait('Routine:')
                self.VistA.write(ritem)
        elif rval == 1:
            self.VistA.write('?')
            for ritem in rlist:
                self.VistA.wait('Routine:')
                self.VistA.write(ritem)
        self.VistA.wait('Routine:')
        self.VistA.write('')
        self.VistA.wait('DEVICE')
        self.VistA.write('')
        if sys.platform == 'win32':
            self.VistA.wait('Right Margin')
            self.VistA.write('')
        while True:
            rval = self.VistA.multiwait(['to halt...', self.VistA.prompt])
            if rval == 0:
                self.VistA.write('')
            elif rval == 1:
                break
            elif rval[0] == -1:
                break
            else:
                print "HOW DID I GET HERE: " + str(rval)

    def adduser(self, name, ssn, gender, initials, acode, vcode1):
        ''' Add a user to system'''
        self.VistA.wait('Option:')
        self.VistA.write('USER MANAGEMENT')
        self.VistA.wait('User Management')
        self.VistA.write('ADD')
        self.VistA.wait('name')
        self.VistA.write(name + '\rY')
        self.VistA.wait('INITIAL:')
        self.VistA.write(initials)
        self.VistA.wait('SSN:')
        self.VistA.write(ssn)
        self.VistA.wait('SEX:')
        self.VistA.write(gender)
        self.VistA.wait('NPI')
        self.VistA.write('')
        self.VistA.wait('NAME COMPONENTS')
        self.VistA.write('\r\r\r\r\r^PRIMARY MENU OPTION\rXUCOR\r^SECONDARY MENU OPTIONS\rGMPL MGT MENU\rY\r\r\r\rOR CPRS GUI CHART\rY\r\r\r\rGMV V/M GUI\rY\r\r\r\r^Want to edit ACCESS CODE\rY\r' + acode + '\r' + acode + '\r^Want to edit VERIFY CODE\rY\r' + vcode1 + '\r' + vcode1 + '\rVISTA HEALTH CARE\rY\r\r\r\r\r^SERVICE/SECTION\rIRM\r^Language\r\r767\rY\rY\rT\r\r^RESTRICT PATIENT SELECTION\r0\r\rCOR\rY\rT\r\r^MULTIPLE SIGN-ON\r1\r1\r99\r^\rS\rE')
        self.VistA.wait('User Account Access Letter')
        self.VistA.write('NO')
        self.VistA.wait('wish to allocate security keys?')
        self.VistA.write('Y')
        self.VistA.wait('Allocate key')
        self.VistA.write('PROVIDER\r1')
        self.VistA.wait('Another key')
        self.VistA.write('GMV MANAGER')
        self.VistA.wait('Another key')
        self.VistA.write('LRLAB')
        self.VistA.wait('Another key')
        self.VistA.write('LRVERIFY')
        self.VistA.wait('Another key')
        self.VistA.write('ORES')
        self.VistA.wait('Another key')
        self.VistA.write('SD SUPERVISOR')
        self.VistA.wait('Another key')
        self.VistA.write('SDWL PARAMETER')
        self.VistA.wait('Another key')
        self.VistA.write('SDWL MENU')
        self.VistA.wait('Another key')
        self.VistA.write('SDOB')
        self.VistA.wait('Another key')
        self.VistA.write('')
        self.VistA.wait('Another holder')
        self.VistA.write('')
        self.VistA.wait('Do you wish to proceed')
        self.VistA.write('Yes')
        self.VistA.wait('add this user to mail groups')
        self.VistA.write('NO')
        self.VistA.wait('User Management')
        self.VistA.write('')
        self.VistA.wait('Option:')
        self.VistA.write('\r\r\r')

    def sigsetup(self, acode, vcode1, vcode2, sigcode):
        '''Set up Electronic Signature'''
        self.VistA.wait('')
        self.VistA.write('D ^ZU')
        self.VistA.wait('ACCESS CODE:')
        self.VistA.write(acode)
        self.VistA.wait('VERIFY CODE:')
        self.VistA.write(vcode1)
        self.VistA.wait('verify code:')
        self.VistA.write(vcode1)
        self.VistA.wait('VERIFY CODE:')
        self.VistA.write(vcode2)
        self.VistA.wait('right:')
        self.VistA.write(vcode2)
        self.VistA.wait('TYPE NAME')
        self.VistA.write('')
        self.VistA.wait('Core Applications')
        self.VistA.write('USER\'s TOOLBOX')
        self.VistA.wait('Toolbox')
        self.VistA.write('ELE')
        self.VistA.wait('INITIAL')
        self.VistA.write('')
        self.VistA.wait('SIGNATURE BLOCK PRINTED NAME')
        self.VistA.write('')
        self.VistA.wait('SIGNATURE BLOCK TITLE')
        self.VistA.write('\r\r\r')
        self.VistA.wait('SIGNATURE CODE')
        self.VistA.write(sigcode)
        self.VistA.wait('SIGNATURE CODE FOR VERIFICATION')
        self.VistA.write(sigcode)
        self.VistA.wait('Toolbox')
        self.VistA.write('\r\r\r')

    def addSAsubtype(self, subcat):
        '''Add SHARING AGREEMENT sub-category (for Appointment Type), exits to VistA>'''
        self.VistA.wait('Select OPTION NAME:')
        self.VistA.write('SD SHARING AGREEMENT UPDATE')
        self.VistA.wait('Select APPOINTMENT TYPE NAME:')
        self.VistA.write('SHARING AGREEMENT')
        self.VistA.wait('Select SHARING AGREEMENT SUB-CATEGORY NAME:')
        self.VistA.write(subcat)
        self.VistA.wait('Are you adding')
        self.VistA.write('Yes')
        self.VistA.wait('SHARING AGREEMENT CATEGORY ACTIVE:')
        self.VistA.write('yes')
