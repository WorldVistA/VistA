'''
Created on Mar 26, 2012

@author: pbradley
'''
import time
import TestHelper
from Actions import Actions

class PATActions (Actions):
    def __init__(self, VistAconn, user=None, code=None):
        Actions.__init__(self, VistAconn, user, code)

    def setuser (self, user=None, code=None):
        self.acode = user
        self.vcode = code

    def signon (self):
        self.VistA.wait('');
        self.VistA.write('S DUZ=1 D ^XUP')

    def signoff (self):
        self.VistA.write('')
        self.VistA.wait('>');
        self.VistA.write('h\r\r')

    def patientaddcsv(self, ssn, pfile=None, getrow=None):
    # Add one patient to VistA
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
    # Add ALL patients from CSV to VistA
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
