'''
Created on Feb 28, 2013

@author: pbradley
'''
import time
import TestHelper
from Actions import Actions
import logging

class CPRSActions (Actions):
    def __init__(self, VistAconn, scheduling=None, user=None, code=None):
        Actions.__init__(self, VistAconn, scheduling, user, code)

    def signon (self):
        if self.acode is None:
            self.VistA.wait('');
            self.VistA.write('S DUZ=1 D ^XUP')

        else:
            self.VistA.wait('')
            self.VistA.write('D ^ZU')
            self.VistA.wait('ACCESS CODE:')
            self.VistA.write(self.acode)
            self.VistA.wait('VERIFY CODE:')
            self.VistA.write(self.vcode)
            self.VistA.wait('//')
            self.VistA.write('')


    def cprs_cc_inactivate(self, ssn, plnum):
        ''' Inactivate a Problem via CPRS Clinician Menu'''
        self.VistA.wait('Option:')
        self.VistA.write('CPRS MENU')
        self.VistA.wait('Select Patient:')
        self.VistA.write(ssn)
        self.VistA.wait('Select:')
        self.VistA.write('CC')
        self.VistA.wait('Select chart component')
        self.VistA.write('Problems')
        self.VistA.wait('Select')
        self.VistA.write(plnum)
        self.VistA.wait('Select Action')
        self.VistA.write('Inactivate')
        self.VistA.wait('inactivate this problem')
        self.VistA.write('yes')
        self.VistA.wait('Select')
        self.VistA.write('Q')
        self.VistA.wait('Select Patient:')
        self.VistA.write('Q')

    def cprs_cc_addcomment(self, ssn, plnum, comment):
        ''' Add a Comment to a Problem via CPRS Clinician Menu'''
        self.VistA.wait('Option:')
        self.VistA.write('CPRS MENU')
        self.VistA.wait('Select Patient:')
        self.VistA.write(ssn)
        self.VistA.wait('Select:')
        self.VistA.write('CC')
        self.VistA.wait('Select chart component')
        self.VistA.write('Problems')
        self.VistA.wait('Select')
        self.VistA.write(plnum)
        self.VistA.wait('Select Action')
        self.VistA.write('Add Comment')
        self.VistA.wait('COMMENT')
        self.VistA.write(comment)
        self.VistA.wait('Select')
        self.VistA.write('Q')
        self.VistA.wait('Select Patient:')
        self.VistA.write('Q')

    def cprs_cc_edit(self, ssn, plnum, loc, edititem, editvalue):
        ''' Edit a Problem via CPRS Clinician Menu'''
        self.VistA.wait('Option:')
        self.VistA.write('CPRS MENU')
        self.VistA.wait('Select Patient:')
        self.VistA.write(ssn)
        self.VistA.wait('Select:')
        self.VistA.write('CC')
        self.VistA.wait('Select chart component')
        self.VistA.write('Problems')
        self.VistA.wait('Select')
        self.VistA.write(plnum)
        self.VistA.wait('Select Action')
        self.VistA.write('Edit')
        self.VistA.wait('Patient Location')
        self.VistA.write(loc)
        self.VistA.wait('Select Item(s)')
        self.VistA.write(edititem)
        self.VistA.wait('//')
        self.VistA.write(editvalue)
        self.VistA.wait(editvalue)  # verify it is applied
        self.VistA.wait('Select Item(s)')
        self.VistA.write('SC')
        self.VistA.wait('Select')
        self.VistA.write('Q')
        self.VistA.wait('Select Patient:')
        self.VistA.write('Q')

    def cprs_cc_remove(self, ssn, plnum):
        ''' Remove a Problem via CPRS Clinician Menu'''
        self.VistA.wait('Option:')
        self.VistA.write('CPRS MENU')
        self.VistA.wait('Select Patient:')
        self.VistA.write(ssn)
        self.VistA.wait('Select:')
        self.VistA.write('CC')
        self.VistA.wait('Select chart component')
        self.VistA.write('Problems')
        self.VistA.wait('Select')
        self.VistA.write('CV')
        self.VistA.wait('to change:')
        self.VistA.write('Status')
        self.VistA.wait('Select Problem Status:')
        self.VistA.write('both')
        self.VistA.wait('Select')
        self.VistA.write(plnum)
        self.VistA.wait('Select Action')
        self.VistA.write('Remove')
        self.VistA.wait('remove this problem')
        self.VistA.write('yes')
        self.VistA.wait('REASON FOR REMOVAL')
        self.VistA.write('this is a test')
        self.VistA.wait('Select')
        self.VistA.write('Q')
        self.VistA.wait('Select Patient:')
        self.VistA.write('Q')

    def cprs_cc_verify(self, ssn, plnum, vtext):
        ''' Verify a Problem via CPRS Clinician Menu'''
        self.VistA.wait('Option:')
        self.VistA.write('CPRS MENU')
        self.VistA.wait('Select Patient:')
        self.VistA.write(ssn)
        self.VistA.wait('Select:')
        self.VistA.write('CC')
        self.VistA.wait('Select chart component')
        self.VistA.write('Problems')
        self.VistA.wait('Select')
        self.VistA.write(plnum)
        self.VistA.wait('Select Action')
        self.VistA.write('Verify')
        self.VistA.wait('verify this problem')
        self.VistA.write('yes')
        self.VistA.wait(vtext)
        self.VistA.wait('Select')
        self.VistA.write('Q')
        self.VistA.wait('Select Patient:')
        self.VistA.write('Q')

    def cprs_cc_detdisplay(self, ssn, plnum, vlist):
        ''' Detailed Display of Problem via CPRS Clinician Menu'''
        self.VistA.wait('Option:')
        self.VistA.write('CPRS MENU')
        self.VistA.wait('Select Patient:')
        self.VistA.write(ssn)
        self.VistA.wait('Select:')
        self.VistA.write('CC')
        self.VistA.wait('Select chart component')
        self.VistA.write('Problems')
        self.VistA.wait('Select')
        self.VistA.write(plnum)
        self.VistA.wait('Select Action')
        self.VistA.write('Detailed Display')
        for vitem in vlist:
            self.VistA.wait(vitem)
        self.VistA.wait('Select Action')
        self.VistA.write('Q')
        self.VistA.wait('Select')
        self.VistA.write('Q')
        self.VistA.wait('Select Patient:')
        self.VistA.write('Q')
