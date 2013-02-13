'''
Created on Apr 20, 2012

@author: pbradley
'''
import time
import TestHelper

class Actions (object):
    def __init__(self, VistAconn, scheduling=None, user=None, code=None):
        self.sched = scheduling
        self.acode = user
        self.vcode = code
        self.VistA = VistAconn

    def signon (self):
        print 'in Actions:', self.acode
        if self.acode is None:
            self.VistA.wait('');
            self.VistA.write('S DUZ=1 D ^XUP')
        else:
            self.VistA.wait('');
            self.VistA.write('D ^ZU')
            self.VistA.wait('ACCESS CODE:');
            self.VistA.write(self.acode)
            self.VistA.wait('VERIFY CODE:');
            self.VistA.write(self.vcode)
            self.VistA.wait('//');
            self.VistA.write('')

    def signoff (self):
        if self.acode is None:
            self.VistA.write('^\r^\r^\rh\r')
        else:
            self.VistA.write('^\r^\r^\r\r\r\r')

    def logflow(self, rlist):
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
        if self.VistA.type == 'cache':
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
