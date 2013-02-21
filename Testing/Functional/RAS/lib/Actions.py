'''
Created on Apr 20, 2012

@author: pbradley
'''
import time
import TestHelper

class Actions (object):
    def __init__(self, VistAconn, scheduling=None, user=None, code=None):
        self.sched= scheduling
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
