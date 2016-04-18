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

## @class PLActions
## Problem List Package Tests (Actions)

'''
Problem List Actions class. Extends Actions

Created on Mar 7, 2012
@author: pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import time
import TestHelper
from Actions import Actions
import logging

class PLActions (Actions):
    '''
    This class extends the Actions class with methods specific to actions performed
    through the Roll and Scroll interface for the Problem List package.
    '''
    def __init__(self, VistAconn, scheduling=None, user=None, code=None):
        Actions.__init__(self, VistAconn, scheduling, user, code)

    def signon (self):
        ''' This provides a signon via ^XUP or ^ZU depending on the value of acode'''
        if self.acode is None:
            self.VistA.write('S DUZ=1,DUZ(0)="@" D ^XUP')
            self.VistA.wait('OPTION NAME:')
            self.VistA.write('GMPL MGT MENU')
        else:
            self.VistA.write('D ^ZU')
            self.VistA.wait('ACCESS CODE:')
            self.VistA.write(self.acode)
            self.VistA.wait('VERIFY CODE:')
            self.VistA.write(self.vcode)
            self.VistA.wait('//')
            self.VistA.write('')
            self.VistA.wait('Option:')
            self.VistA.write('Problem List')

#    def signoff(self):
#        super(Actions,self).signoff(self.VistA, self.acode)

    def write(self, string):
        self.VistA.write(string)

    def addcsv(self, ssn, pfile=None, getrow=None, slist=None):
        '''Add a list of problems to a patient's record (ignore Select List if present)'''
        prec = [1]
        if pfile is not None:
            preader = TestHelper.CSVFileReader()
            prec = preader.getfiledata(pfile, 'key', getrow)
        for pitem in prec:
            self.VistA.wait('Problem List Mgt Menu')
            self.VistA.write('Patient Problem List')
            self.VistA.wait('PATIENT NAME')
            self.VistA.write(ssn)
            self.VistA.wait('Select Action')
            self.VistA.write('AD')
            self.VistA.wait('Clinic')
            self.VistA.write(prec[pitem]['clinic'].rstrip().lstrip())
            if slist is not None:  # if there is a SL, the skip it...
                self.VistA.wait('Select Item')
                self.VistA.write('AD')
            probID =[prec[pitem]['icd'].rstrip().lstrip(),prec[pitem]['icd10'].rstrip().lstrip(),prec[pitem]['snomed'].rstrip().lstrip()]
            valIndex = 0
            while True:
              index = self.VistA.multiwait(['Ok','PROBLEM'])
              if index == 1:
                self.VistA.write(probID[valIndex])
                valIndex += 1;
              elif index == 0:
                break
              else:
                self.VistA.write('?')
            self.VistA.write('Yes')
            # if self.acode is not None:
            #    self.VistA.wait('//'); self.VistA.write('')
            self.VistA.wait('COMMENT');
            self.VistA.write(prec[pitem]['comment1'].rstrip().lstrip())
            self.VistA.wait('ANOTHER COMMENT')
            self.VistA.write(prec[pitem]['comment2'].rstrip().lstrip())
            self.VistA.wait('DATE OF ONSET')
            self.VistA.write(prec[pitem]['onsetdate'].rstrip().lstrip())
            self.VistA.wait('STATUS')
            self.VistA.write(prec[pitem]['status'].rstrip().lstrip())
            self.VistA.wait('hronic')
            self.VistA.write(prec[pitem]['acutechronic'].rstrip().lstrip())
            rval = self.VistA.multiwait(['service-connected condition',
                                     'uit w/o saving'])
            if rval == 0:
                self.VistA.write(prec[pitem]['service'].rstrip().lstrip())
                self.VistA.wait('uit w/o saving?')
                self.VistA.write('Save')
            elif rval == 1:
                self.VistA.write('Save')
            self.VistA.wait('PROBLEM')
            self.VistA.write('')
            self.VistA.wait('Select Action')
            self.VistA.write('QUIT')
            self.VistA.wait('Print a new problem list')
            self.VistA.write('N')

    def add(self, ssn, clinic, comment, onsetdate, status, acutechronic,
              service, probnum=None, icd=None,icd10=None,snomed=None, evalue=None, verchknum=None):
        ''' Add a problem using clinic or user with assigned selection list'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('AD')
        self.VistA.wait('Clinic')
        self.VistA.write(clinic)
        if probnum == 'skip':  # SL exists but don't use
            self.VistA.wait('Select Item')
            self.VistA.write('AD')
            self.VistA.wait('PROBLEM')
            self.VistA.write(icd)
        elif probnum is None :  # SL doesn't exist
            probList = [icd, icd10,snomed]
            probIndex = 0
            while True:
              index = self.VistA.multiwait(['PROBLEM','Ok'])
              if index==0:
                self.VistA.write(probList[probIndex])
                probIndex += 1
              elif index == 1:
                break
              else:
                self.VistA.write('?')

            self.VistA.write('YES')
        else :  # Use SL
            self.VistA.wait('Select Item')
            self.VistA.write(probnum)
            # if clinic == '':
            #    self.VistA.wait(evalue); self.VistA.write('')
        self.VistA.wait('COMMENT')
        self.VistA.write(comment)
        self.VistA.wait('ANOTHER COMMENT')
        self.VistA.write('')
        self.VistA.wait('DATE OF ONSET')
        self.VistA.write(onsetdate)
        self.VistA.wait('STATUS')
        self.VistA.write(status)
        self.VistA.wait('hronic')
        self.VistA.write(acutechronic)
        rval = self.VistA.multiwait(['service-connected condition', 'uit w/o saving'])
        if rval == 0:
            self.VistA.write(service)
            self.VistA.wait('uit w/o saving')
            self.VistA.write('Save')
        elif rval == 1:
            self.VistA.write('Save')
        #
        if probnum == 'skip':
            self.VistA.wait('PROBLEM')
            self.VistA.write('')
        elif probnum is None:
            self.VistA.wait('PROBLEM')
            self.VistA.write('')
        else:
            self.VistA.wait('Select Item')
            self.VistA.write('')
        self.VistA.wait('Select Action')
        # optionally, check to make sure user entering the data can't also verify it
        if verchknum is not None:
            self.VistA.write('$')
            self.VistA.wait('Select Problem')
            self.VistA.write(verchknum)
            self.VistA.wait('does not require verification')
            self.VistA.wait('Select Action')
        self.VistA.write('QUIT')
        self.VistA.wait('Print a new problem list')
        self.VistA.write('N')

    def addspec(self, ssn, clinic, comment, onsetdate, status, acutechronic,
              service, icd, prompt='yes', uselex='yes', screendups='yes', isdup=None, prob=None, vlist=None):
        ''' Add problems with checks for the PL site parameters'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('AD')
        self.VistA.wait('Clinic')
        self.VistA.write(clinic)
        self.VistA.wait('PROBLEM')
        self.VistA.write(icd)
        if uselex is 'yes':
            self.VistA.wait('Ok?')
            self.VistA.write('YES')
        if screendups == isdup == 'yes':
            self.VistA.wait('>>>  ' + prob)
            self.VistA.wait('     is already an')
            self.VistA.wait('Are you sure you want to continue')
            self.VistA.write('Yes')
        self.VistA.wait('COMMENT')
        self.VistA.write(comment)
        self.VistA.wait('ANOTHER COMMENT')
        self.VistA.write('')
        self.VistA.wait('DATE OF ONSET')
        self.VistA.write(onsetdate)
        self.VistA.wait('STATUS')
        self.VistA.write(status)
        self.VistA.wait('hronic')
        self.VistA.write(acutechronic)
        rval = self.VistA.multiwait(['service-connected condition', 'uit w/o saving'])
        if rval == 0:
            self.VistA.write(service)
            self.VistA.wait('uit w/o saving')
            self.VistA.write('Save')
        elif rval == 1:
            self.VistA.write('Save')
        self.VistA.wait('PROBLEM')
        self.VistA.write('')
        if vlist is not None:
            while True:
                index = self.VistA.multiwait(vlist)
                if index == len(vlist)-1:
                    break
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT')
        if prompt == 'yes':
            self.VistA.wait('Print a new problem list')
            self.VistA.write('N')

    def dataentry(self, ssn, provider, clinic, problem, comment, onsetdate, status, acutechronic,
              service, probnum=None, icd=None, evalue=None):
        '''Add a problem (via data entry) using description or selection list'''
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Provider:')
        self.VistA.write(provider)
        self.VistA.wait('Select Action')
        self.VistA.write('AD')
        self.VistA.wait('Clinic')
        self.VistA.write(clinic)
        if probnum == 'skip':  # SL exists but don't use
            self.VistA.wait('Select Item')
            self.VistA.write('AD')
            self.VistA.wait('PROBLEM')
            self.VistA.write(icd)
        elif probnum is None :  # SL doesn't exist
            self.VistA.wait('PROBLEM')
            self.VistA.write(problem)
        else :  # Use SL
            self.VistA.wait('Select Item')
            self.VistA.write(probnum)
            # if clinic == '':
            #    self.VistA.wait(evalue); self.VistA.write('')
        self.VistA.wait('COMMENT')
        self.VistA.write(comment)
        self.VistA.wait('ANOTHER COMMENT')
        self.VistA.write('')
        self.VistA.wait('DATE OF ONSET')
        self.VistA.write(onsetdate)
        self.VistA.wait('STATUS')
        self.VistA.write(status)
        self.VistA.wait('hronic')
        self.VistA.write(acutechronic)
        rval = self.VistA.multiwait(['service-connected condition', 'uit w/o saving'])
        if rval == 0:
            self.VistA.write(service)
            self.VistA.wait('uit w/o saving')
            self.VistA.write('Save')
        elif rval == 1:
            self.VistA.write('Save')
        self.VistA.wait('PROBLEM:')
        self.VistA.write('')
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT')
        self.VistA.wait('Print a new problem list')
        self.VistA.write('N')

    def editsimple(self, ssn, probnum, itemnum, chgval,icd10='',snomed=''):
        '''Simple edit of problem, items 1,2,4,5 or 6 only'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('ED')
        self.VistA.wait('Select Problem')
        self.VistA.write(probnum)  # which patient problem
        self.VistA.wait('Select Item')
        self.VistA.write(itemnum)  # select 1, 2,4,5,or6
        self.VistA.wait(':')
        self.VistA.write(chgval)
        valIndex=0
        valList = [icd10,snomed]
        while True:
          rval = self.VistA.multiwait(['Select Item', 'Ok','A suitable term'])
          if rval == 0:
              self.VistA.write('SC')
              break
          elif rval == 1:
              self.VistA.write('Yes')
          elif rval == 2:
              self.VistA.write(valList[valIndex])
              valIndex +=1
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT')
        self.VistA.wait('Print a new problem list')
        self.VistA.write('N')

    def editinactivate (self, ssn, probnum, resdate):
        '''Inactivate a problem'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('ED')
        self.VistA.wait('Select Problem')
        self.VistA.write(probnum)  # which patient problem
        self.VistA.wait('Select Item')
        self.VistA.write('3')  # STATUS
        self.VistA.wait('STATUS')
        self.VistA.write('INACTIVE')
        self.VistA.wait('DATE RESOLVED')
        self.VistA.write(resdate)
        self.VistA.wait('Select Item')
        self.VistA.write('SC')
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT')
        self.VistA.wait('Print a new problem list')
        self.VistA.write('N')

    def editactivate (self, ssn, probnum, acutechronic):
        '''Activate a problem'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('ED')
        self.VistA.wait('Select Problem')
        self.VistA.write(probnum)  # which patient problem
        self.VistA.wait('Select Item')
        self.VistA.write('3')  # STATUS
        self.VistA.wait('STATUS')
        self.VistA.write('ACTIVE')
        self.VistA.wait('hronic')
        self.VistA.write(acutechronic)
        self.VistA.wait('Select Item')
        self.VistA.write('SC')
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT')
        self.VistA.wait('Print a new problem list')
        self.VistA.write('N')

    def verify(self, ssn, probnum, itemnum, evalue, view='AT'):
        '''Verify a problem exists'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('VW')
        self.VistA.wait('Select Item')
        self.VistA.write(view)
        self.VistA.wait('Select Action')
        self.VistA.write('ED')
        self.VistA.wait('Select Problem')
        self.VistA.write(probnum)  # which patient problem
        self.VistA.wait('Select Item')
        self.VistA.write(itemnum)  # which item to verify?
        self.VistA.multiwait(evalue)
        self.VistA.write('^')
        self.VistA.wait('Select Item')
        self.VistA.write('QUIT')
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT')

    def comcm (self, ssn, probnum, comment):
        '''Comment on an Active problem'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('CM')
        self.VistA.wait('Select Problem')
        self.VistA.write(probnum)  # which patient problem
        self.VistA.wait('COMMENT')
        self.VistA.write(comment)
        self.VistA.wait('ANOTHER COMMENT')
        self.VistA.write('')
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT')
        self.VistA.wait('Print a new problem list')
        self.VistA.write('N')

    def rem (self, ssn):
        '''Remove the first problem on the list (Active or Inactive)'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('VW')
        self.VistA.wait('Select Item')
        self.VistA.write('BO')
        self.VistA.wait('Select Action')
        self.VistA.write('RM')
        self.VistA.wait('Select Problem')
        self.VistA.write('1')
        self.VistA.wait('Are you sure')
        self.VistA.write('YES')
        self.VistA.wait('REASON FOR REMOVAL')
        self.VistA.write('testing')
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT')
        self.VistA.wait('Print a new problem list')
        self.VistA.write('N')

    def rem_all (self, ssn):
        '''Remove the first problem on the list (Active or Inactive)'''
        rval = 0
        while rval is not 1:
            self.VistA.wait('Problem List Mgt Menu')
            self.VistA.write('Patient Problem List')
            self.VistA.wait('PATIENT NAME')
            self.VistA.write(ssn)
            self.VistA.wait('Select Action')
            self.VistA.write('VW')
            self.VistA.wait('Select Item')
            self.VistA.write('BO')
            self.VistA.wait('Select Action')
            self.VistA.write('RM')
            rval = self.VistA.multiwait(['Select Problem', 'Select Action'])
            if rval == 0:
                self.VistA.write('1')
                self.VistA.wait('Are you sure')
                self.VistA.write('YES')
                self.VistA.wait('REASON FOR REMOVAL')
                self.VistA.write('testing')
                self.VistA.wait('Select Action')
                self.VistA.write('QUIT')
                self.VistA.wait('Print a new problem list')
                self.VistA.write('N')
            elif rval == 1:
                self.VistA.write('QUIT')
                r2val = self.VistA.multiwait(['Print a new problem list', 'Problem List Mgt Menu'])
                if r2val == 0:
                    self.VistA.write('N')
                elif r2val == 1:
                    self.VistA.write('?')
                else:
                    self.VistA.wait('SHOULDNOTGETHERE')
            else:
                self.VistA.wait('SHOULDNOTGETHERE')

    def replace (self, ssn, probnum):
        '''Replace Removed Problem'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Replace Removed Problem')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select the problem')
        self.VistA.write(probnum)
        self.VistA.wait('Are you sure you want to do this?')
        self.VistA.write('YES')
        self.VistA.wait('to continue')
        self.VistA.write('')

    def checkempty (self, ssn):
        '''Verify that patient problem list is empty'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action: Add New Problems//')
        self.VistA.write('QUIT')

    def createsellist (self, listname, clinic):
        '''Create a Selection List'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('new PROBLEM SELECTION LIST')
        self.VistA.write('Yes')
        self.VistA.wait('PROBLEM SELECTION LIST CLINIC:')
        self.VistA.write(clinic)
        self.VistA.wait('Select Action:')
        self.VistA.write('SV')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def createcat (self, listname, catname):
        '''Create a Category'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build Problem Selection List')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Select Action')
        self.VistA.write('EC')
        self.VistA.wait('Select CATEGORY NAME:')
        self.VistA.write(catname)
        self.VistA.wait('new PROBLEM SELECTION CATEGORY')
        self.VistA.write('Yes')
        self.VistA.wait('Select Item')
        self.VistA.write('SV')
        self.VistA.wait('Select Action')
        self.VistA.write('Quit')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def catad (self, listname, catname, icd, snomed, spec='', dtext='', seqnum=''):
        '''Add a Problem (ICD) to a Category'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Select Action')
        self.VistA.write('EC')
        self.VistA.wait('Select CATEGORY NAME:')
        self.VistA.write(catname)
        self.VistA.wait('Select Item')
        self.VistA.write('AD')
        index = self.VistA.multiwait(['PROBLEM','Select Specialty Subset'])
        if index == 1:
          self.VistA.write(spec)
          self.VistA.wait('PROBLEM')
        self.VistA.write(icd)
        index = self.VistA.multiwait(['Ok', 'STOP or Select', 'A suitable term'])
        if index == 0:
            self.VistA.write('')
            self.VistA.wait('DISPLAY TEXT')
            self.VistA.write(dtext)
            self.VistA.wait('ICD CODE')
            self.VistA.write(icd)
            self.VistA.wait('...OK')
            self.VistA.write('Yes')
            self.VistA.wait('SEQUENCE')
            self.VistA.write(seqnum)
            self.VistA.wait('PROBLEM')
            self.VistA.write('')
        elif index == 1:
            self.VistA.write('1')
            self.VistA.wait('DISPLAY TEXT')
            self.VistA.write(dtext)
            self.VistA.wait('ICD CODE')
            self.VistA.write(icd)
            self.VistA.wait('...OK')
            self.VistA.write('Yes')
            self.VistA.wait('SEQUENCE')
            self.VistA.write(seqnum)
            self.VistA.wait('PROBLEM')
            self.VistA.write('')
        elif index == 2:
            self.VistA.write(snomed)
            index = self.VistA.multiwait(['Ok', 'A suitable term'])
            if index == 0:
              self.VistA.write('')
              self.VistA.wait('DISPLAY TEXT')
              self.VistA.write(dtext)
              self.VistA.wait('... Ok')
              self.VistA.write('Yes')
              self.VistA.wait('SEQUENCE')
              self.VistA.write(seqnum)
              self.VistA.wait('PROBLEM')
            self.VistA.write('')
        self.VistA.wait('Select Item')
        self.VistA.write('SV')
        self.VistA.wait('Select Action')
        self.VistA.write('SV')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def sellistad (self, listname, catname, hdrname='', seqnum=''):
        '''Add a Category to a Selection List'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Select Action')
        self.VistA.write('AD')
        self.VistA.wait('Select CATEGORY NAME:')
        self.VistA.write(catname)
        self.VistA.wait('HEADER')
        self.VistA.write(hdrname)
        self.VistA.wait('SEQUENCE')
        self.VistA.write(seqnum)
        self.VistA.wait('Select CATEGORY NAME')
        self.VistA.write('')
        self.VistA.wait('Select Action')
        self.VistA.write('SV')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def sellistss (self, listname, clinic, username):
        '''Assign a Selection List to a User'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Select Action')
        self.VistA.write('SS')
        self.VistA.wait('CLINIC:')
        self.VistA.write(clinic)
        self.VistA.wait('Select USER')
        self.VistA.write(username)
        self.VistA.wait('ANOTHER ONE')
        self.VistA.write('')
        self.VistA.wait('Are you ready')
        self.VistA.write('Yes')
        self.VistA.wait('Select Action')
        self.VistA.write('SV')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def sellistgal (self, listname, username):
        '''Assign a Selection List to a User'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Assign')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Select USER')
        self.VistA.write(username)
        self.VistA.wait('ANOTHER ONE')
        self.VistA.write('')
        self.VistA.wait('Are you ready')
        self.VistA.write('Yes')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def sellistrfu (self, listname, username):
        '''De-Assign a Selection List from a User'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Remove')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Select USER')
        self.VistA.write(username)
        self.VistA.wait('ANOTHER ONE')
        self.VistA.write('')
        self.VistA.wait('Are you ready')
        self.VistA.write('Yes')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def sellistrm (self, listname, catnum='1'):
        ''' Remove Category from a Selection List'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Select Action')
        self.VistA.write('RM')
        self.VistA.wait('Select Category')
        self.VistA.write(catnum)
        self.VistA.wait('Are you sure you want to remove')
        self.VistA.write('Yes')
        self.VistA.wait('Select Action')
        self.VistA.write('SV')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def catdl (self, listname, catname):
        ''' Delete a Category'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Select Action')
        self.VistA.write('EC')
        self.VistA.wait('Select CATEGORY NAME')
        self.VistA.write(catname)
        self.VistA.wait('Select Item')
        self.VistA.write('DL')
        self.VistA.wait('Are you sure you want to delete the entire')
        self.VistA.write('Yes')
        self.VistA.wait('Select CATEGORY NAME')
        self.VistA.write('')
        self.VistA.wait('Select Action')
        self.VistA.write('SV')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def sellistdl (self, listname):
        '''Delete a Selection List'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Delete')
        self.VistA.wait('Select LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Are you sure you want to delete this list')
        self.VistA.write('Yes')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def createibform (self, clinic, formname, groupname, plist, icd10list):
        '''Create IB Encounter Form'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('')
        self.VistA.wait('Core Applications')
        self.VistA.write('IB')
        self.VistA.wait('Integrated Billing Master Menu')
        self.VistA.write('Encounter Forms')
        self.VistA.wait('Encounter Forms')
        self.VistA.write('Edit Encounter Forms')
        self.VistA.wait('Edit Encounter Forms')
        self.VistA.write('Clinic Setup')
        self.VistA.wait('WHICH CLINIC?')
        self.VistA.write(clinic)
        self.VistA.wait('Select Action:')
        self.VistA.write('Create Blank Form')
        self.VistA.wait('New Form Name')
        self.VistA.write(formname + '\r\r\r0\r\r\rTest Form\r1')
        self.VistA.wait('Select Action')
        self.VistA.write('Edit Form')
        self.VistA.wait('Select Action')
        self.VistA.write('Add Toolkit')
        self.VistA.wait('Select Action')
        self.VistA.write('Add Tool Kit Block')
        self.VistA.wait('Select TOOL KIT BLOCK:')
        self.VistA.write('8')
        self.VistA.wait('STARTING ROW:')
        self.VistA.write('\r\r\r')
        self.VistA.wait('Select Action')
        self.VistA.write('Fast Selection Edit')
        self.VistA.wait('Select Action:')
        self.VistA.write('Group Add')
        self.VistA.wait('HEADER')
        self.VistA.write(groupname + '\r1\r\r')
        for pitem in plist:
            self.VistA.wait('Select Action')
            self.VistA.write('Add Selection')
            self.VistA.wait('Select PROBLEM:')
            self.VistA.write(pitem)
            index = self.VistA.multiwait(['Select PROBLEM','Ok'])
            if index == 0:
              self.VistA.write(icd10list[plist.index(pitem)])
              self.VistA.wait('Ok')
            self.VistA.write('\rGroup1\r\r^')
            index = self.VistA.multiwait(['NARRATIVE','Select Action'])
            if index == 0:
              self.VistA.write('TEST')
            else:
              self.VistA.write('?')
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT\rYES')
        self.VistA.wait('Select Action')
        self.VistA.write('QUIT\r\r\r')
        self.VistA.wait('Integrated Billing Master Menu')
        self.VistA.write('Problem List')

    def checkOutOfOrder (self, menuName):
        '''Remove Category from a Selection List'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('?');
        index = self.VistA.multiwait(['SNOMED CT','Select Problem Selection Lists'])
        self.VistA.write('')
        if index == 0:
          return False
        else:
          return True

    def sellistib (self, formname, listname, clinic):
        '''Remove Category from a Selection List'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem Selection Lists')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Copy Selection List from IB Encounter')
        self.VistA.wait('Select a FORM:')
        self.VistA.write(formname)
        self.VistA.wait('LIST NAME')
        self.VistA.write(listname)
        self.VistA.wait('CLINIC')
        self.VistA.write(clinic)
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def versellist(self, ssn, clinic, vlist):
        '''Verify a clinic selection list, content and order'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('AD')
        self.VistA.wait('Clinic')
        self.VistA.write(clinic)
        while True:
            index = self.VistA.multiwait(vlist)
            if index == len(vlist)-1:
                break
        self.VistA.wait('Select Item')
        self.VistA.write('Quit')
        self.VistA.wait('Select Action')
        self.VistA.write('Quit')

    def verplist(self, ssn, vlist):
        '''Verify a patient problem list, content and order'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        while True:
            index = self.VistA.multiwait(vlist)
            if index == len(vlist)-1:
                break
        self.VistA.wait('Select Action')
        self.VistA.write('Quit')

    def verlistpats(self, vlist):
        '''Verify a patient problem list, content and order'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('List Patients with Problem List data')
        self.VistA.wait('//')
        self.VistA.write('')
        while True:
            index = self.VistA.multiwait(vlist)
            if index == len(vlist)-1:
                break
        self.VistA.wait('to exit:')
        self.VistA.write('')

    def verpatsrch(self, prob, icd10,snomed, vlist):
        '''Verify a patient problem list, content and order'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Search for Patients having selected Problem')
        probList = [prob,icd10,snomed]
        probIndex =0
        while True:
          index = self.VistA.multiwait(['Ok','PROBLEM'])
          if index == 1:
            self.VistA.write(probList[probIndex])
            probIndex += 1
          elif index == 0:
            break
          else:
            self.VistA.write('?')
        self.VistA.write('')
        self.VistA.wait('Select STATUS:')
        self.VistA.write('')
        self.VistA.wait('DEVICE:')
        self.VistA.write('')
        while True:
            index = self.VistA.multiwait(vlist)
            if index == len(vlist)-1:
                break
        self.VistA.wait('to exit:')
        self.VistA.write('')
        self.VistA.wait('PROBLEM:')
        self.VistA.write('')

    def detview (self, ssn, probnum, vlist1, vlist2):
        '''Checks the Detailed View'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('DT')
        self.VistA.wait('Select Problem')
        self.VistA.write(probnum)  # which patient problem
        while True:
            index = self.VistA.multiwait(vlist1)
            if index == len(vlist1)-1:
                break
        self.VistA.wait('Select Action')
        self.VistA.write('')
        while True:
            index = self.VistA.multiwait(vlist2)
            if index == len(vlist2)-1:
                break
        self.VistA.wait('Select Action')
        self.VistA.write('')
        self.VistA.wait('Select Action')
        self.VistA.write('')

    def verifyproblem(self, ssn, problem):
        '''Check that its unconfirmed'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('1')
        self.VistA.wait('PATIENT NAME:')
        self.VistA.write(ssn)
        self.VistA.wait('$')  # check for $ verify mark
        self.VistA.wait(problem)  # check for $ verify mark
        self.VistA.wait('Select Action:')
        self.VistA.write('DT')
        self.VistA.wait('Select Problem')
        self.VistA.write('')
        self.VistA.wait('CLERK')
        self.VistA.write('q')
        self.VistA.wait('Select Action:')
        self.VistA.write('$')
        self.VistA.wait('Select Problem')
        self.VistA.write('')
        self.VistA.write('DT')
        self.VistA.wait('Select Problem')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('Q')
        # verify again and confirm previous verification worked
        self.VistA.wait('Select Action:')
        self.VistA.write('$')
        self.VistA.wait('Select Problem')
        self.VistA.write('')
        self.VistA.wait('does not require verification')
        self.VistA.write('Q')

    def selectnewpatient(self, ssn1, name1, ss2, name2):
        '''This checks to see if the select new patient feature works properly'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn1)
        self.VistA.wait(name1)
        self.VistA.write('SP')
        self.VistA.wait('PATIENT NAME:')
        self.VistA.write(ss2)
        self.VistA.wait(name2)
        self.VistA.write('Q')
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('')

    def printproblemlist(self, ssn, vlist):
        '''This checks that the print function inside problem list works properly'''
        self.VistA.wait("Problem List Mgt Menu")
        self.VistA.write('Patient Problem List')
        self.VistA.wait('NAME:')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action:')
        self.VistA.write('PP')
        self.VistA.wait('ll problems?')
        self.VistA.write('A')
        self.VistA.wait('DEVICE:')
        self.VistA.write('HOME')
        while True:
            index = self.VistA.multiwait(vlist)
            if index == len(vlist)-1:
                break
        self.VistA.wait('exit:')
        self.VistA.write('^')
        self.VistA.wait('Select Action')
        self.VistA.write('')

    def resequencecat(self, listname, catnames):
        '''Tests re-sequence function inside of category build list'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build')
        self.VistA.wait('LIST NAME:')
        self.VistA.write(listname)
        self.VistA.wait('Select Action:')
        self.VistA.write('SQ')
        self.VistA.wait('Select Category')
        self.VistA.write('1')
        self.VistA.wait('SEQUENCE')
        self.VistA.write('3')
        self.VistA.wait(catnames[1])
        self.VistA.wait(catnames[0])
        self.VistA.write('SQ')
        self.VistA.wait('Select Category')
        self.VistA.write('2')
        self.VistA.wait('SEQUENCE')
        self.VistA.write('1')
        self.VistA.wait(catnames[0])
        self.VistA.wait(catnames[1])
        self.VistA.wait('Select Action:')
        self.VistA.write('VW')
        self.VistA.wait('<1>')
        self.VistA.write('')
        self.VistA.wait('Save')
        self.VistA.write('Yes')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def categorydisp(self, listname, catname):
        '''Tests category display function'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build')
        self.VistA.wait('LIST NAME')
        self.VistA.write(listname)
        self.VistA.wait('Select Action:')
        self.VistA.write('CD')
        self.VistA.wait('Category')
        self.VistA.write('1')
        self.VistA.wait('HEADER:')
        self.VistA.write(catname.upper())
        self.VistA.wait('AUTOMATICALLY')
        self.VistA.write('Yes')
        self.VistA.wait(catname.upper())
        self.VistA.write('CD')
        self.VistA.wait('Category')
        self.VistA.write('1')
        self.VistA.wait('HEADER:')
        self.VistA.write(catname)
        self.VistA.wait('AUTOMATICALLY')
        self.VistA.write('Yes')
        self.VistA.wait('Select Action')
        self.VistA.write('SV')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def changesellist(self, list1, list2, category=None):
        '''Changes the Selection List'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Create Problem')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('Build')
        self.VistA.wait('LIST NAME:')
        self.VistA.write(list1)
        self.VistA.wait('Select Action:')
        self.VistA.write('CL')
        self.VistA.wait('LIST NAME:')
        self.VistA.write(list2)
        self.VistA.wait(list2)
        if category is None:
            self.VistA.wait('No items available.')
        else:
            self.VistA.wait(category)
        self.VistA.write('')
        self.VistA.wait('Create Problem Selection Lists')
        self.VistA.write('')

    def editpart1(self, ssn, probnum, itemnum, chgval):
        '''Simple edit of problem, items 1,2,4,5 or 6 only'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('ED')
        self.VistA.wait('Select Problem')
        self.VistA.write(probnum)  # which patient problem
        self.VistA.wait('Select Item')
        self.VistA.write(itemnum)  # select 1, 2,4,5,or6

    def editpart2(self, ssn, probnum, itemnum, chgval, icd10='',snomed=''):
        ''' Edit for lock test'''
        self.VistA.wait(':')
        probList=[chgval,icd10,snomed]
        probIndex = 0
        while True:
          rval = self.VistA.multiwait(['Select Item', 'Ok','A suitable term'])
          if rval == 0:
              self.VistA.write('SC')
              break
          elif rval == 1:
              self.VistA.write('Yes')
          elif rval == 2:
             self.VistA.write(probList[probIndex])
             probIndex += 1
        self.VistA.write('QUIT')
        self.VistA.wait('Print a new problem list')
        self.VistA.write('N')

    def badeditpart1(self, ssn, probnum, itemnum, chgval,icd10):
        ''' Simple edit of problem, items 1,2,4,5 or 6 only'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('ED')
        self.VistA.wait('Select Problem')
        self.VistA.write(probnum)  # which patient problem
        # self.VistA.wait('Select Item')
        # self.VistA.write(itemnum)
        index = self.VistA.multiwait(['Select Problem', 'edited by another user'])
        if index == 0:
          self.VistA.write(icd10)
          self.VistA.wait('edited by another user')
        self.VistA.write('QUIT')

    def editPLsite(self, ver, prompt, uselex, order, screendups):
        '''Simple edit of problem, items 1,2,4,5 or 6 only'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Edit PL Site Parameters')
        self.VistA.wait('VERIFY TRANSCRIBED PROBLEMS:')
        self.VistA.write(ver)
        self.VistA.wait('PROMPT FOR CHART COPY:')
        self.VistA.write(prompt)
        self.VistA.wait('USE CLINICAL LEXICON:')
        self.VistA.write(uselex)
        self.VistA.wait('DISPLAY ORDER:')
        self.VistA.write(order)
        self.VistA.wait('SCREEN DUPLICATE ENTRIES:')
        self.VistA.write(screendups)

    def checkVerplsetting(self, ssn):
        ''' Check Verify PL site setting'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('$')
        self.VistA.wait('$ is not a valid selection')
        self.VistA.wait('Select Action')
        self.VistA.write('Q')

    def checkRMsellist(self, ssn, clinic):
        '''Check to verify  response when adding problem via clinic with a removed selection list'''
        self.VistA.wait('Problem List Mgt Menu')
        self.VistA.write('Patient Problem List')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(ssn)
        self.VistA.wait('Select Action')
        self.VistA.write('AD')
        self.VistA.wait('Clinic')
        self.VistA.write(clinic)
        self.VistA.wait('Retrieving list of  problems ...')
        self.VistA.wait('No items available.  Returning to Problem List ...')
        self.VistA.wait('Select Action')
        self.VistA.write('Q')
