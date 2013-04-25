'''
Created on Apr 20, 2012

@author: pbradley
'''
import time
import TestHelper
from Actions import Actions

class ORActions (Actions):
    def __init__(self, VistAconn, user=None, code=None):
        Actions.__init__(self, VistAconn, user, code)

    def signon (self):
        if self.acode is None:
            self.VistA.wait('');
            self.VistA.write('S DUZ=1 D ^XUP')
            self.VistA.wait('OPTION NAME:');
            self.VistA.write('OR MAIN MENU CLINICIAN')
        else:
            self.VistA.wait('');
            self.VistA.write('D ^ZU')
            self.VistA.wait('ACCESS CODE:');
            self.VistA.write(self.acode)
            self.VistA.wait('VERIFY CODE:');
            self.VistA.write(self.vcode)
            self.VistA.wait('//');
            self.VistA.write('')

    def verproblems (self, ssn, vlist):
        # Activate a problem
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
