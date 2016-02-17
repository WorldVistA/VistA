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

## @class SCActions
## Scheduling Actions

'''
Scheduler Actions class. Extends Actions.

Created on Jun 14, 2012
@author: pbradley, bcaine
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

from Actions import Actions
import TestHelper
import datetime
import time

class SCActions (Actions):
    '''
    This class extends the Actions class with methods specific to actions performed
    through the Roll and Scroll interface for the Scheduling package.
    '''
    def __init__(self, VistAconn, scheduling=None, user=None, code=None):
        Actions.__init__(self, VistAconn, scheduling, user, code)

    def signon (self):
        ''' This provides a signon via ^XUP or ^ZU depending on the value of acode'''
        if self.acode is None:
            self.VistA.write('S DUZ=1,DUZ(0)="@" D ^XUP')
            if self.sched is not None:
                self.VistA.wait('OPTION NAME:')
                self.VistA.write('SDAM APPT MGT')
        else:
            self.VistA.write('D ^ZU')
            self.VistA.wait('ACCESS CODE:');
            self.VistA.write(self.acode)
            self.VistA.wait('VERIFY CODE:');
            self.VistA.write(self.vcode)
            self.VistA.wait('//');
            self.VistA.write('')
            self.VistA.wait('Core Applications')
            self.VistA.write('Scheduling')

    def schtime(self, plushour=1):
        '''Calculates a time for the next hour'''
        ttime = datetime.datetime.now() + datetime.timedelta(hours=1)
        return ttime.strftime("%I%p").lstrip('0')

    def getclinic(self):
        '''Determines which clinic to use based on the time of day'''
        now = datetime.datetime.now()
        hour = now.hour
        if (hour >= 23 and hour <= 24) or (hour >= 0 and hour <= 6):
            clinic = 'Clinic1'
        elif hour >= 7 and hour <= 14:
            clinic = 'Clinic2'
        elif hour >= 15 and hour <= 22:
            clinic = 'CLINICX'
        return clinic

    def dateformat(self, dayadd=0):
        '''Currently not used, needs to be able to handle when the added days
        puts the total days over the months total (ei change 8/35/12 to 9/3/12).
        Idea is to use for date verification'''
        now = datetime.datetime.now()
        month = now.month
        day = now.day + dayadd
        year = now.year % 20
        date = str(month) + '/' + str(day) + '/' + str(year)
        return date

    def makeapp(self, clinic, patient, datetime, fresh=None, badtimeresp=None, apptype=None, subcat=None):
        '''Makes Appointment for specified user at specified time via Clinic view'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('MA')
        self.VistA.wait('PATIENT NAME:')
        self.VistA.write('??')
        self.VistA.multiwait(['TO STOP:','to exit'])
        self.VistA.write('^')
        self.VistA.wait('PATIENT NAME:')
        self.VistA.write(patient)
        if apptype is not None:
            self.VistA.wait('TYPE:')
            self.VistA.write(apptype)
            self.VistA.wait('APPT TYPE:')
            self.VistA.write(subcat[0])
            self.VistA.wait('APPT TYPE:')
            self.VistA.write(subcat[1])
        else:
            self.VistA.wait('TYPE:')
            self.VistA.write('Regular')
        if fresh is not None:
            self.VistA.wait('APPOINTMENTS:')
            self.VistA.write('Yes')
        self.VistA.wait('ETHNICITY:')
        self.VistA.write('')
        self.VistA.wait('RACE:')
        self.VistA.write('')
        self.VistA.wait('COUNTRY:')
        self.VistA.write('')
        self.VistA.wait('STREET ADDRESS')
        self.VistA.write('')
        self.VistA.wait('ZIP')
        self.VistA.write('')
        for x in range(0, 2):
            self.VistA.wait('PHONE NUMBER')
            self.VistA.write('')
        self.VistA.wait('BAD ADDRESS')
        self.VistA.write('')
        self.VistA.wait('above changes')
        self.VistA.write('No')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('REQUEST')
        self.VistA.write('Yes')
        self.VistA.wait('DATE/TIME')
        self.VistA.write('t+5')
        self.VistA.wait('DATE/TIME')
        self.VistA.write(datetime)
        if badtimeresp is 'noslot':
            self.VistA.wait('NO OPEN SLOTS THEN')
            self.VistA.wait('DATE/TIME')
            self.VistA.write('')
        elif badtimeresp is 'overbook':
            self.VistA.wait('OVERBOOK')
            self.VistA.write('yes')
            self.VistA.wait('CORRECT')
            self.VistA.write('Yes')
            self.VistA.wait('STOPS')
            self.VistA.write('No')
            self.VistA.wait('OTHER INFO:')
            self.VistA.write('')
            self.VistA.wait('continue:')
            self.VistA.write('')
        else:
            self.VistA.wait('CORRECT')
            self.VistA.write('Yes')
            self.VistA.wait('STOPS')
            self.VistA.write('No')
            self.VistA.wait('OTHER INFO:')
            self.VistA.write('')
            self.VistA.wait('continue:')
            self.VistA.write('')
        index = self.VistA.multiwait(['Select Action:','APPOINTMENT LETTER'])
        if index == 1:
          self.VistA.write('No')
          self.VistA.wait('Select Action')
        self.VistA.write('Quit')
        self.VistA.wait('')

    def makeapp_bypat(self, clinic, patient, datetime, loopnum=1, fresh=None, CLfirst=None, prevCO=None):
        '''Makes Appointment for specified user at specified time via Patient view'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)  # <--- by patient
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        for _ in range(loopnum):
            self.VistA.wait('Select Action:')
            if CLfirst is not None:
                self.VistA.write('CL')
                self.VistA.wait('Select Clinic:')
                self.VistA.write(clinic)
                self.VistA.wait('Select Action:')
                self.VistA.write('MA')
                self.VistA.wait('PATIENT NAME:')
                self.VistA.write(patient)
            else:
                self.VistA.write('MA')
                self.VistA.wait('Select CLINIC:')
                self.VistA.write(clinic)
            self.VistA.wait('TYPE:')
            self.VistA.write('Regular')
            if fresh is not None:
                self.VistA.wait('APPOINTMENTS:')
                self.VistA.write('Yes')
            elif _ >= 1:
                self.VistA.wait('APPOINTMENTS:')
                self.VistA.write('Yes')
            self.VistA.wait('ETHNICITY:')
            self.VistA.write('')
            self.VistA.wait('RACE:')
            self.VistA.write('')
            self.VistA.wait('COUNTRY:')
            self.VistA.write('')
            self.VistA.wait('STREET ADDRESS')
            self.VistA.write('')
            self.VistA.wait('ZIP')
            self.VistA.write('')
            for x in range(0, 2):
                self.VistA.wait('PHONE NUMBER')
                self.VistA.write('')
            self.VistA.wait('BAD ADDRESS')
            self.VistA.write('')
            self.VistA.wait('above changes')
            self.VistA.write('No')
            self.VistA.wait('continue:')
            self.VistA.write('')
            self.VistA.wait('REQUEST')
            self.VistA.write('Yes')
            self.VistA.wait('DATE/TIME')
            self.VistA.write(datetime)
            if _ >= 1:
                self.VistA.wait('DO YOU WANT TO CANCEL IT')
                self.VistA.write('Yes')
                self.VistA.wait('Press RETURN to continue:')
                self.VistA.write('')
            if prevCO is not None:
                self.VistA.wait('A check out date has been entered for this appointment!')
                self.VistA.wait('DATE/TIME:')
                self.VistA.write('')
            else:
                self.VistA.wait('CORRECT')
                self.VistA.write('Yes')
                self.VistA.wait('STOPS')
                self.VistA.write('No')
                self.VistA.wait('OTHER INFO:')
                self.VistA.write('')
                self.VistA.wait('continue:')
                self.VistA.write('')
            while True:
              index = self.VistA.multiwait(['Select Action:','Select CLINIC:','APPOINTMENT LETTER'])
              if index == 0:
                self.VistA.write('?\r')
                break
              elif index == 1:
                self.VistA.write('')
              elif index == 2:
                self.VistA.write('No')
        self.VistA.write('Quit')
        self.VistA.wait('')

    def makeapp_var(self, clinic, patient, datetime, fresh=None, nextaval=None):
        '''Makes Appointment for clinic that supports variable length appts (CLInicA)'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)  # <--- by patient
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Select Action:')
        self.VistA.write('CL')
        self.VistA.wait('Select Clinic:')
        self.VistA.write(clinic)
        self.VistA.wait('Select Action:')
        self.VistA.write('MA')
        self.VistA.wait('PATIENT NAME:')
        self.VistA.write(patient)
        self.VistA.wait('TYPE:')
        self.VistA.write('Regular')
        if fresh is not None:
            self.VistA.wait('APPOINTMENTS:')
            self.VistA.write('Yes')
        self.VistA.wait('ETHNICITY:')
        self.VistA.write('')
        self.VistA.wait('RACE:')
        self.VistA.write('')
        self.VistA.wait('COUNTRY:')
        self.VistA.write('')
        self.VistA.wait('STREET ADDRESS')
        self.VistA.write('')
        self.VistA.wait('ZIP')
        self.VistA.write('')
        for x in range(0, 2):
            self.VistA.wait('PHONE NUMBER')
            self.VistA.write('')
        self.VistA.wait('BAD ADDRESS')
        self.VistA.write('')
        self.VistA.wait('above changes')
        self.VistA.write('No')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('REQUEST')
        if nextaval is not None:
            self.VistA.write('No')
            self.VistA.wait('APPOINTMENT')
        else:
            self.VistA.write('Yes')
            self.VistA.wait('DATE/TIME')
        self.VistA.write(datetime)
        if 't+122' in datetime:
            self.VistA.wait('Add to EWL')
            self.VistA.write('Yes')
        else:
            self.VistA.wait('LENGTH OF APPOINTMENT')
            self.VistA.write('15')
            self.VistA.wait('increment minutes per hour')
            self.VistA.wait('LENGTH OF APPOINTMENT')
            self.VistA.write('60')
            self.VistA.wait('CORRECT')
            self.VistA.write('Yes')
            self.VistA.wait('STOPS')
            self.VistA.write('No')
            self.VistA.wait('OTHER INFO:')
            self.VistA.write('')
        self.VistA.wait('continue')
        self.VistA.write('')
        index = self.VistA.multiwait(['Select Action:','APPOINTMENT LETTER'])
        if index == 1:
          self.VistA.write('No')
          self.VistA.wait('Select Action')
        self.VistA.write('Quit')
        self.VistA.wait('')


    def set_mademographics(self, clinic, patient, datetime, dgrph, CLfirst=None):
        ''' This test sets demographics via MA action.  Not used.  Reference only. This test crashes on SAVE in gtm'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)  # <--- by patient
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Select Action:')
        if CLfirst is not None:
            self.VistA.write('CL')
            self.VistA.wait('Select Clinic:')
            self.VistA.write(clinic)
            self.VistA.wait('Select Action:')
            self.VistA.write('MA')
            self.VistA.wait('PATIENT NAME:')
            self.VistA.write(patient)
        else:
            self.VistA.write('MA')
            self.VistA.wait('Select CLINIC:')
            self.VistA.write(clinic)
        self.VistA.wait('TYPE:')
        self.VistA.write('Regular')
        for wwset in dgrph:
            self.VistA.wait(wwset[0])
            self.VistA.write(wwset[1])
        self.VistA.wait('REQUEST?')
        self.VistA.write('yes')
        self.VistA.wait('DATE/TIME:')
        self.VistA.write(datetime)
        rval = self.VistA.multiwait(['LENGTH OF APPOINTMENT', 'CORRECT'])
        if rval == 0:
            self.VistA.write('')
            self.VistA.wait('CORRECT')
            self.VistA.write('Yes')
        elif rval == 1:
            self.VistA.write('Yes')
        self.VistA.wait('STOPS')
        self.VistA.write('No')
        self.VistA.wait('OTHER INFO:')
        self.VistA.write('')
        self.VistA.wait('continue:')
        self.VistA.write('')
        if CLfirst is not None:
            self.VistA.wait('Select Action:')
        else:
            self.VistA.wait('Select CLINIC:')
            self.VistA.write('')
            self.VistA.wait('Select Action:')
        self.VistA.write('Quit')
        self.VistA.wait('')

    def fix_demographics(self, clinic, patient, dgrph,):
        ''' This test sets demographics via PD action. This is an alternate implementation of set_mademographics()'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)  # <--- by patient
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Select Action:')
        self.VistA.write('PD')
        for wwset in dgrph:
            self.VistA.wait(wwset[0])
            self.VistA.write(wwset[1])

    def set_demographics(self, clinic, patient, dgrph, emailAddress=None, CLfirst=None, patidx=None):
        '''
        This sets demographics via PD action and has an option to select the clinic
        before setting demographics for a patient via a patient index (patidx) argument.
        '''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)  # <--- by patient
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        if CLfirst is not None:
            self.VistA.wait('Select Action:')
            self.VistA.write('CL')
            self.VistA.wait('Select Clinic:')
            self.VistA.write(clinic)
            self.VistA.wait('Select Action:')
            self.VistA.write('PD')
            self.VistA.wait('Select Appointments')
            self.VistA.write(patidx)
        else:
            self.VistA.wait('Select Action:')
            self.VistA.write('PD')
        for wwset in dgrph:
            self.VistA.wait(wwset[0])
            self.VistA.write(wwset[1])
        index = self.VistA.multiwait(['DOES THE PATIENT','EMAIL ADDRESS'])
        if index == 0:
          if emailAddress != None :
            self.VistA.write('Y')
            self.VistA.wait('EMAIL ADDRESS')
            self.VistA.write(emailAddress)
          else:
            self.VistA.write('N')
        else:
          if emailAddress != None :
            self.VistA.write(emailAddress)
          else:
            self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')
        self.VistA.wait('')

    def get_demographics(self, patient, vlist, emailAddress=None):
        '''This gets the patient demographics via the PD action.'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)  # <--- by patient
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Select Action:')
        self.VistA.write('PD')
        for wwset in vlist:
            self.VistA.wait(wwset[0])
            self.VistA.write(wwset[1])
        index = self.VistA.multiwait(['DOES THE PATIENT','EMAIL ADDRESS'])
        if index == 0:
          if emailAddress != None:
            self.VistA.write('Y')
            self.VistA.wait(emailAddress)
            self.VistA.write('')
          else:
            self.VistA.write('N')
        else:
          self.VistA.write('')
        self.VistA.wait('Select Action')
        self.VistA.write('Quit')
        self.VistA.wait('')


    def verapp_bypat(self, patient, vlist, ALvlist=None, EPvlist=None, COnum=None, CInum=None):
        '''Verify previous Appointment for specified user at specified time.'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)  # <--- by patient
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('Select List:')
        self.VistA.write('TA')
        for vitem in vlist:
            self.VistA.wait(vitem)
        if ALvlist is not None:
            self.VistA.wait('Select Action:')
            self.VistA.write('AL')
            self.VistA.wait('Select List:')
            self.VistA.write('TA')
            for vitem in ALvlist:
                self.VistA.wait(vitem)
        if EPvlist is not None:
            self.VistA.wait('Select Action:')
            self.VistA.write('EP')
            self.VistA.wait('Select Appointment(s):')
            self.VistA.write('1')
            for vitem in EPvlist:
                self.VistA.wait(vitem)
            self.VistA.wait('Select Action:')
            self.VistA.write('^')
        if COnum is not None:
            self.VistA.wait('Select Action:')
            self.VistA.write('AL')
            self.VistA.wait('Select List:')
            self.VistA.write('FU')
            self.VistA.wait('Select Action:')
            self.VistA.write('CO')
            if COnum[0] is not '1':
                self.VistA.wait('Select Appointment(s):')
                self.VistA.write(COnum[1])
            self.VistA.wait('It is too soon to check out this appointment')
            self.VistA.write('')
        if CInum is not None:
            self.VistA.wait('Select Action:')
            self.VistA.write('AL')
            self.VistA.wait('Select List:')
            self.VistA.write('FU')
            self.VistA.wait('Select Action:')
            self.VistA.write('CI')
            if CInum[0] is not '1':
                self.VistA.wait('Select Appointment(s):')
                self.VistA.write(CInum[1])
            self.VistA.wait('It is too soon to check in this appointment')
            self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')
        self.VistA.wait('')


    def verapp(self, clinic, vlist, COnum=None, CInum=None):
        '''Verify previous Appointments by clinic and with CI/CO check '''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('CD')
        self.VistA.wait('Select Beginning Date:')
        self.VistA.write('')
        self.VistA.wait('Ending Date:')
        self.VistA.write('t+100')
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('Select List:')
        self.VistA.write('TA')
        for vitem in vlist:
            self.VistA.wait(vitem)
        if COnum is not None:
            self.VistA.wait('Select Action:')
            self.VistA.write('AL')
            self.VistA.wait('Select List:')
            self.VistA.write('FU')
            self.VistA.wait('Select Action:')
            self.VistA.write('CO')
            if COnum[0] is not '1':
                self.VistA.wait('Select Appointment(s):')
                self.VistA.write(COnum[1])
            rval = self.VistA.multiwait(['It is too soon to check out this appointment',
                                         'You can not check out this appointment'])
            if rval == 0:
                self.VistA.write('')
            elif rval == 1:
                self.VistA.write('')
            else:
                self.VistA.wait('SPECIALERROR, rval: ' + str(rval))  # this should cause a timeout
        if CInum is not None:
            self.VistA.wait('Select Action:')
            self.VistA.write('AL')
            self.VistA.wait('Select List:')
            self.VistA.write('FU')
            self.VistA.wait('Select Action:')
            self.VistA.write('CI')
            if CInum[0] is not '1':
                self.VistA.wait('Select Appointment(s):')
                self.VistA.write(CInum[1])
            self.VistA.wait('It is too soon to check in this appointment')
            self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')
        self.VistA.wait('')

    def ver_actions(self, clinic, patient, PRvlist, DXvlist, CPvlist):
        ''' verify action in menu, patient must be checked out'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        # EC
        self.VistA.wait('Select Action:')
        self.VistA.write('EC')
        self.VistA.wait('Select Appointment(s)')
        self.VistA.write('2')
        self.VistA.wait('to continue')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        # RT
        self.VistA.write('RT')
        for vitem in ['Chart Request', 'Fill Next Clinic Request', 'Profile of Charts', 'Recharge a Chart']:
            self.VistA.wait(vitem)
        self.VistA.wait('Select Record Tracking Option:')
        self.VistA.write('^')
        # PR
        self.VistA.wait('Select Action:')
        self.VistA.write('PR')
        self.VistA.wait('CHOOSE 1-2:')
        self.VistA.write('1')
        self.VistA.wait('Select Appointment(s):')
        self.VistA.write('1')
        for vitem in PRvlist:
            self.VistA.wait(vitem)
        self.VistA.wait('Enter PROVIDER:')
        self.VistA.write('')
        self.VistA.wait('for this ENCOUNTER')
        self.VistA.write('')
        self.VistA.wait('Enter PROVIDER:')
        self.VistA.write('')
        # DX
        self.VistA.wait('Select Action:')
        self.VistA.write('DX')
        self.VistA.wait('Select Appointment(s):')
        self.VistA.write('1')
        for vitem in DXvlist:
            self.VistA.wait(vitem)
        self.VistA.wait('Diagnosis :')
        self.VistA.write('')
        self.VistA.wait('Problem List')
        self.VistA.write('no')
        # CP
        self.VistA.wait('Select Action:')
        self.VistA.write('CP')
        self.VistA.wait('Select Appointment(s):')
        self.VistA.write('1')
        for vitem in CPvlist:
            self.VistA.wait(vitem)
        self.VistA.wait('Enter PROCEDURE')
        self.VistA.write('')
        # PC
        self.VistA.wait('Select Action:')
        self.VistA.write('PC')
        self.VistA.multiwait(['to continue','is locked'])
        self.VistA.write('')

    def use_sbar(self, clinic, patient, fresh=None):
        '''Use the space bar to get previous clinic or patient '''
        self.VistA.wait('Clinic name:')
        self.VistA.write(' ')  # spacebar to test recall
        self.VistA.wait(patient)  # check to make sure expected patient SSN is recalled
        self.VistA.write('No')
        self.VistA.wait(clinic)  # check to make sure expected clinic is recalled
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('MA')
        self.VistA.wait('Select PATIENT NAME:')
        self.VistA.write(' ')  # spacebar to test recall
        self.VistA.wait(patient)  # check to make sure expected patient SSN is recalled
        self.VistA.wait('TYPE:')
        self.VistA.write('Regular')
        if fresh is not None:
            self.VistA.wait('APPOINTMENTS:')
            self.VistA.write('Yes')
        self.VistA.wait('ETHNICITY:')
        self.VistA.write('')
        self.VistA.wait('RACE:')
        self.VistA.write('')
        self.VistA.wait('COUNTRY:')
        self.VistA.write('')
        self.VistA.wait('STREET ADDRESS')
        self.VistA.write('')
        self.VistA.wait('ZIP')
        self.VistA.write('')
        for x in range(0, 2):
            self.VistA.wait('PHONE NUMBER')
            self.VistA.write('')
        self.VistA.wait('BAD ADDRESS')
        self.VistA.write('')
        self.VistA.wait('above changes')
        self.VistA.write('No')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('REQUEST')
        self.VistA.write('Yes')
        self.VistA.wait('DATE/TIME')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')
        self.VistA.wait('')

    def canapp(self, clinic, mult=None, future=None, rebook=None):
        '''Cancel an Appointment, if there are multiple appts on schedule, send a string to the parameter "first"'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+100')
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        if future is None:
            self.VistA.wait('Select List:')
            self.VistA.write('TA')
        else:
            self.VistA.wait('Select List:')
            self.VistA.write('FU')
        self.VistA.wait('Select Action:')
        self.VistA.write('CA')
        if mult is not None:
            # If there are more than 1 appointments
            self.VistA.wait('Select Appointment')
            self.VistA.write(mult)
        self.VistA.wait('linic:')
        self.VistA.write('Clinic')
        self.VistA.wait('REASONS NAME')
        self.VistA.write('Clinic Cancelled')
        self.VistA.wait('REMARKS:')
        self.VistA.write('')
        self.VistA.wait('continue:')
        self.VistA.write('')
        if rebook is None:
            self.VistA.wait('CANCELLED')
            self.VistA.write('no')
            self.VistA.wait('CANCELLED')
            self.VistA.write('')
        else:
            self.VistA.wait('CANCELLED')
            self.VistA.write('yes')
            self.VistA.wait('OUTPUT REBOOKED APPT')
            self.VistA.write('')
            self.VistA.wait('TO BE REBOOKED:')
            self.VistA.write('1')
            self.VistA.wait('FROM WHAT DATE:')
            self.VistA.write('')
            self.VistA.wait('continue:')
            self.VistA.write('')
            self.VistA.wait('continue:')
            self.VistA.write('')
            self.VistA.wait('CONTINUE')
            self.VistA.write('')
            self.VistA.wait('PRINT LETTERS FOR THE CANCELLED APPOINTMENT')
            self.VistA.write('')
        self.VistA.wait('exit:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def noshow(self, clinic, appnum):
        '''Registers a patient as a no show'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('NS')
        self.VistA.wait('Select Appointment')
        self.VistA.write(appnum)
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('NOW')
        self.VistA.write('')
        self.VistA.wait('NOW')
        self.VistA.write('')
        self.VistA.wait('exit:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def checkin(self, clinic, vlist, mult=None):
        '''Checks a patient in'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('Select List:')
        self.VistA.write('TA')
        self.VistA.wait('Select Action:')
        self.VistA.write('CI')
        if mult is not None:
            self.VistA.wait('Appointment')
            self.VistA.write(mult)
        for vitem in vlist:
            self.VistA.wait_re(vitem)
        self.VistA.write('')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def checkout(self, clinic, vlist1, vlist2, icd, icd10, mult=None):
        '''Checks a Patient out'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('Select List:')
        self.VistA.write('TA')
        self.VistA.wait('Select Action:')
        self.VistA.write('CO')
        if mult is not None:
            self.VistA.wait('Appointment')
            self.VistA.write(mult)
        for vitem in vlist1:
            self.VistA.wait(vitem)
        self.VistA.wait('appointment')
        self.VistA.write('No')
        self.VistA.wait('date and time:')
        self.VistA.write('Now')
        self.VistA.wait('PROVIDER:')
        self.VistA.write('Alexander')
        self.VistA.wait('ENCOUNTER')
        self.VistA.write('Yes')
        self.VistA.wait('PROVIDER')
        self.VistA.write('')
        self.VistA.wait('Diagnosis')
        self.VistA.write(icd)
        index = self.VistA.multiwait(['No records','OK'])
        if index == 0:
          self.VistA.write(icd10)
          self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('ENCOUNTER')
        self.VistA.write('Yes')
        self.VistA.wait('Resulting:')
        self.VistA.write('R')
        for vitem in vlist2:
            self.VistA.wait(vitem)
        self.VistA.wait('Diagnosis')
        self.VistA.write('')
        self.VistA.wait('Problem List')
        self.VistA.write('No')
        self.VistA.wait('PROCEDURE')
        self.VistA.write('')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('screen')
        self.VistA.write('No')
        self.VistA.wait('Clinic:')
        self.VistA.write('')

    def unschvisit(self, clinic, patient, patientname):
        '''Makes a walk-in appointment. Automatically checks in'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('UN')
        self.VistA.wait('Select Patient:')
        self.VistA.write(patient)
        self.VistA.wait('TIME:')
        self.VistA.write('')
        self.VistA.wait('TYPE:')
        self.VistA.write('Regular')
        self.VistA.wait('continue:')
        self.VistA.write('')
        index = self.VistA.multiwait(['Check Out:','ROUTING SLIP'])
        if index == 1:
          self.VistA.write('N')
          self.VistA.wait('Check Out')
        self.VistA.write('CI')
        self.VistA.wait_re('CHECKED')
        self.VistA.write('')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('SLIP NOW')
        self.VistA.write('No')
        self.VistA.wait(patientname)
        self.VistA.wait('Checked In')
        self.VistA.wait('Select Action')
        self.VistA.write('')

    def chgpatient(self, clinic, patient1, patient2, patientname1, patientname2):
        '''Changes the patient between patient 1 and patient 2'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('PT')
        self.VistA.wait('Patient:')
        self.VistA.write(patient1)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait(patientname1.upper())
        self.VistA.wait('Select Action:')
        self.VistA.write('PT')
        self.VistA.wait('Patient:')
        self.VistA.write(patient2)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait(patientname2.upper())
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')

    def chgclinic(self):
        '''Changes the clinic from clinic1 to clinic2'''
        self.VistA.wait('Clinic name:')
        self.VistA.write('Clinic1')
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Clinic1')
        self.VistA.wait('Select Action:')
        self.VistA.write('CL')
        self.VistA.wait('Select Clinic:')
        self.VistA.write('Clinic2')
        self.VistA.wait('Clinic2')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')

    def chgdaterange(self, clinic):
        '''Changes the date range of the clinic'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait(clinic)
        self.VistA.wait('Select Action:')
        self.VistA.write('CD')
        self.VistA.wait('Date:')
        self.VistA.write('t+7')
        self.VistA.wait('Date:')
        self.VistA.write('t+7')
        self.VistA.wait('Select Action:')
        self.VistA.write('CD')
        self.VistA.wait('Date:')
        self.VistA.write('t-4')
        self.VistA.wait('Date:')
        self.VistA.write('t+4')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def expandentry(self, clinic, vlist1, vlist2, vlist3, vlist4, vlist5, mult=None):
        '''Expands an appointment entry for more detail'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait(clinic)
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('Select List:')
        self.VistA.write('TA')
        self.VistA.wait('Select Action:')
        self.VistA.write('EP')
        if mult is not None:
            self.VistA.wait('Appointment')
            self.VistA.write(mult)
        for vitem in vlist1:
            self.VistA.wait(vitem)
        self.VistA.wait('Select Action:')
        self.VistA.write('')
        for vitem in vlist2:
            self.VistA.wait(vitem)
        self.VistA.wait('Select Action:')
        self.VistA.write('')
        for vitem in vlist3:
            self.VistA.wait(vitem)
        self.VistA.wait('Select Action:')
        self.VistA.write('')
        for vitem in vlist4:
            self.VistA.wait(vitem)
        self.VistA.wait('Select Action:')
        self.VistA.write('')
        for vitem in vlist5:
            self.VistA.wait(vitem)
        self.VistA.wait('Select Action:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def addedit(self, clinic, name, icd, icd10):
        '''
        Functional but not complete. Exercises the Add/Edit menu but doesn't make any changes
        Same problem as checkout with the CPT codes and the MPI
        '''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait(clinic)
        self.VistA.wait('Select Action:')
        self.VistA.write('AE')
        self.VistA.wait('Name:')
        self.VistA.write(name)
        self.VistA.wait('exit:')
        self.VistA.write('A')
        self.VistA.wait('Clinic:')
        self.VistA.write(clinic)
        self.VistA.wait('Time:')
        time = self.schtime()
        self.VistA.write(time)
        self.VistA.wait('APPOINTMENT TYPE:')
        self.VistA.write('')
        self.VistA.wait('PROVIDER:')
        self.VistA.write('Alexander')
        self.VistA.wait('ENCOUNTER')
        self.VistA.write('Yes')
        self.VistA.wait('Enter PROVIDER:')
        self.VistA.write('')
        self.VistA.wait('Diagnosis')
        self.VistA.write(icd)
        index = self.VistA.multiwait(['No records','Ok'])
        if index == 0:
          self.VistA.write(icd10)
          self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('ENCOUNTER')
        self.VistA.write('Yes')
        self.VistA.wait('Resulting')
        self.VistA.write('R')
        self.VistA.wait('Diagnosis')
        self.VistA.write('')
        self.VistA.wait('Problem List')
        self.VistA.write('')
        self.VistA.wait('CPT CODE')
        self.VistA.write('')
        self.VistA.wait('encounter')
        self.VistA.write('Yes')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def patdem(self, clinic, name, mult=None):
        '''This edits the patients demographic information'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait(clinic)
        self.VistA.wait('Select Action:')
        self.VistA.write('PD')
        if mult is not None:
            self.VistA.wait('Appointment')
            self.VistA.write(mult)
        self.VistA.wait(name)
        self.VistA.wait('COUNTRY:')
        self.VistA.write('')
        self.VistA.wait('ADDRESS')
        self.VistA.write('')
        self.VistA.wait(':')
        self.VistA.write('')
        self.VistA.wait('PHONE NUMBER')
        self.VistA.write('')
        self.VistA.wait('PHONE NUMBER')
        self.VistA.write('')
        self.VistA.wait('INDICATOR:')
        self.VistA.write('')
        self.VistA.wait('changes')
        self.VistA.write('No')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('SEX:')
        self.VistA.write('')
        self.VistA.wait('INFORMATION')
        self.VistA.write('N')
        self.VistA.wait('INFORMATION:')
        self.VistA.write('W')
        self.VistA.wait('RACE INFORMATION')
        self.VistA.write('Yes')
        self.VistA.wait('INFORMATION:')
        self.VistA.write('')
        self.VistA.wait('STATUS:')
        self.VistA.write('Married')
        self.VistA.wait('PREFERENCE:')
        self.VistA.write('')
        self.VistA.wait('ACTIVE')
        self.VistA.write('No')
        self.VistA.wait('NUMBER')
        self.VistA.write('')
        self.VistA.wait('NUMBER')
        self.VistA.write('')
        index = self.VistA.multiwait(['DOES THE','ADDRESS'])
        if index == 0:
          self.VistA.write('Y')
          self.VistA.wait('EMAIL ADDRESS')
        self.VistA.write('email3@example.org')
        self.VistA.wait('Select Action')
        self.VistA.write('')

    def teaminfo(self, clinic, patient=None):
        '''This checks the display team info feature'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('TI')
        if patient is not None:
            self.VistA.wait('Select Patient')
            self.VistA.write(patient)
        self.VistA.wait('Team Information')
        self.VistA.wait('Select Action:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def enroll(self, clinic, patient):
        '''This enrolls a patient as an inpatient in a clinic'''
        self.VistA.wait('OPTION NAME')
        self.VistA.write('Appointment Menu')
        self.VistA.wait('Appointment Menu')
        self.VistA.write('Edit Clinic Enrollment Data')
        self.VistA.wait('PATIENT NAME')
        self.VistA.write(patient)
        self.VistA.wait('CLINIC:')
        self.VistA.write(clinic)
        self.VistA.wait('ENROLLMENT CLINIC')
        self.VistA.write('Yes')
        self.VistA.wait('ENROLLMENT:')
        self.VistA.write('t')
        self.VistA.wait('Are you adding')
        self.VistA.write('Yes')
        self.VistA.wait('AC:')
        self.VistA.write('OPT')
        self.VistA.wait('DATE:')
        self.VistA.write('')
        self.VistA.wait('DISCHARGE:')
        self.VistA.write('')
        self.VistA.wait('DISCHARGE')
        self.VistA.write('')
        self.VistA.wait('CLINIC:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('ENROLLMENT')
        self.VistA.write('')
        self.VistA.wait('ENROLLMENT')
        self.VistA.write('')
        self.VistA.wait('AC:')
        self.VistA.write('')
        self.VistA.wait('DATE:')
        self.VistA.write('')
        self.VistA.wait('DISCHARGE')
        self.VistA.write('')
        self.VistA.wait('DISCHARGE')
        self.VistA.write('')
        self.VistA.wait('CLINIC')
        self.VistA.write('')
        self.VistA.wait('NAME:')
        self.VistA.write('')
        self.VistA.wait('Appointment Menu')
        self.VistA.write('')
        self.VistA.wait('halt')
        self.VistA.write('')

    def discharge(self, clinic, patient, appnum=None):
        '''Discharges a patient from the clinic'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('DC')
        if appnum is not None:
            self.VistA.wait('Select Appointment')
            self.VistA.write(appnum)
        self.VistA.wait('Discharging patient from')
        self.VistA.wait('DATE OF DISCHARGE:')
        self.VistA.write('t')
        self.VistA.wait('REASON FOR DISCHARGE')
        self.VistA.write('testing')
        self.VistA.wait('Action:')
        self.VistA.write('')

    def deletecheckout(self, clinic, appnum=None):
        '''
        Deletes checkout from the menu
        Must be signed in as fakedoc1 (1Doc!@#$)
        Must have the SD SUPERVISOR Key assigned to Dr. Alexander
        '''
        self.VistA.wait('Scheduling Manager\'s Menu')
        self.VistA.write('Appointment Menu')
        self.VistA.wait('Appointment Menu')
        self.VistA.write('Appointment Management')
        self.VistA.wait('Clinic name')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Action:')
        self.VistA.write('DE')
        if appnum is not None:
            self.VistA.wait('Select Appointment')
            self.VistA.write(appnum)
        self.VistA.wait('check out')
        self.VistA.write('Yes')
        self.VistA.wait('deleting')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('deleting check out')
        self.VistA.wait('exit:')
        self.VistA.write('')
        self.VistA.wait('Action:')
        self.VistA.write('')

    def waitlistentry(self, clinic, patient):
        '''
        Enters a patient into the wait list
        This assumes that SDWL PARAMETER and SDWL MENU
        keys are given to fakedoc1
        '''
        self.VistA.wait('Scheduling Manager\'s Menu')
        self.VistA.write('Appointment Menu')
        self.VistA.wait('Appointment Menu')
        self.VistA.write('Appointment Management')
        self.VistA.wait('name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Action:')
        self.VistA.write('WE')
        self.VistA.wait('NAME:')
        self.VistA.write(patient)
        self.VistA.wait('Patient')
        self.VistA.write('Yes')
        self.VistA.wait('response:')
        # TODO: Explore all three options (PCMM TEAM ASSIGNMENT, SERVICE/SPECIALTY, SPECIFIC CLINIC
        self.VistA.write('1')
        self.VistA.wait('Institution:')
        self.VistA.write('1327')
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Team:')
        self.VistA.write('1')
        self.VistA.wait('OK')
        self.VistA.write('yes')
        self.VistA.wait('Comments:')
        self.VistA.write('test')
        self.VistA.wait('Action:')
        self.VistA.write('')

    def waitlistdisposition(self, clinic, patient):
        '''This verifies that the wait list disposition option is working'''
        self.VistA.wait('Option:')
        self.VistA.write('Appointment Management')
        self.VistA.wait('name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Action:')
        self.VistA.write('WD')
        self.VistA.wait('PATIENT:')
        self.VistA.write(patient)
        self.VistA.wait('Quit')
        self.VistA.write('Yes')
        # TODO: For deeper coverage, execute all 6 disposition reasons
        self.VistA.wait('response:')
        self.VistA.write('D')
        self.VistA.wait('removed from Wait List')
        self.VistA.wait('exit:')
        self.VistA.write('')
        self.VistA.wait('no Wait List')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def gotoApptMgmtMenu(self):
        '''
        Get to Appointment Management Menu via ZU
        '''
        self.VistA.wait('Scheduling Manager\'s Menu')
        self.VistA.write('Appointment Menu')
        self.VistA.wait('Appointment Menu')
        self.VistA.write('Appointment Management')

    def multiclinicdisplay(self, cliniclist, patient, timelist, pending=None):
        '''
        Create multiple clinic appointments
        '''
        self.VistA.wait('Scheduling Manager\'s Menu')
        self.VistA.write('Appointment Menu')
        self.VistA.wait('Appointment Menu')
        self.VistA.write('Multiple Clinic Display')
        self.VistA.wait('PATIENT NAME:')
        self.VistA.write(patient)
        if pending:
            self.VistA.wait('DISPLAY PENDING APPOINTMENTS')
            self.VistA.write('')
        self.VistA.wait('DISPLAY PENDING APPOINTMENTS')
        self.VistA.write('')
        self.VistA.wait('ETHNICITY:')
        self.VistA.write('')
        self.VistA.wait('RACE:')
        self.VistA.write('')
        self.VistA.wait('COUNTRY:')
        self.VistA.write('')
        self.VistA.wait('STREET ADDRESS')
        self.VistA.write('')
        self.VistA.wait('ZIP')
        self.VistA.write('')
        for x in range(0, 2):
            self.VistA.wait('PHONE NUMBER')
            self.VistA.write('')
        self.VistA.wait('BAD ADDRESS')
        self.VistA.write('')
        self.VistA.wait('above changes')
        self.VistA.write('No')
        self.VistA.wait('continue:')
        self.VistA.write('')
        for clinic in cliniclist:
            self.VistA.wait('Select CLINIC')
            self.VistA.write(clinic)
        self.VistA.wait('Select CLINIC:')
        self.VistA.write('')
        self.VistA.wait('OK to proceed')
        self.VistA.write('Yes')
        self.VistA.wait('LOOK FOR CLINIC AVAILABILITY STARTING WHEN:')
        self.VistA.write('t+1')
        self.VistA.wait('SELECT LATEST DATE TO CHECK FOR AVAILABLE SLOTS:')
        self.VistA.write('t+10')
        self.VistA.wait('REDISPLAY:')
        self.VistA.write('B')
        for ptime in timelist:
            self.VistA.wait('SCHEDULE TIME:')
            self.VistA.write(ptime)
            rval = self.VistA.multiwait(['APPOINTMENT TYPE:', '...OK'])
            if rval == 0:
                self.VistA.write('Regular')
            elif rval == 1:
                self.VistA.write('Yes')
                self.VistA.wait('APPOINTMENT TYPE:')
                self.VistA.write('Regular')
            self.VistA.wait('OR EKG STOPS')
            self.VistA.write('No')
            self.VistA.wait('OTHER INFO:')
            self.VistA.write('')
            self.VistA.wait('Press RETURN to continue:')
            self.VistA.write('')
        self.VistA.wait('Select PATIENT NAME:')
        self.VistA.write('')
        self.VistA.wait('Appointment Menu')
        self.VistA.write('')

    def ma_clinicchk(self, clinic, patient, exp_apptype, datetime, cslots, cxrays, fresh=None, cvar=None, elig=None):
        '''Makes Appointment to check clinic settings'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('MA')
        self.VistA.wait('PATIENT NAME:')
        self.VistA.write('??')
        self.VistA.multiwait(['TO STOP','to exit'])
        self.VistA.write('^')
        self.VistA.wait('PATIENT NAME:')
        self.VistA.write(patient)
        self.VistA.wait('APPOINTMENT TYPE: ' + exp_apptype)
        self.VistA.write('REGULAR')
        if fresh is not None:
            self.VistA.wait('APPOINTMENTS:')
            self.VistA.write('Yes')
        self.VistA.wait('ETHNICITY:')
        self.VistA.write('')
        self.VistA.wait('RACE:')
        self.VistA.write('')
        self.VistA.wait('COUNTRY:')
        self.VistA.write('')
        self.VistA.wait('STREET ADDRESS')
        self.VistA.write('')
        self.VistA.wait('ZIP')
        self.VistA.write('')
        for x in range(0, 2):
            self.VistA.wait('PHONE NUMBER')
            self.VistA.write('')
        self.VistA.wait('BAD ADDRESS')
        self.VistA.write('')
        self.VistA.wait('above changes')
        self.VistA.write('No')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('APPOINTMENT REQUEST')
        self.VistA.write('Yes')
        self.VistA.wait(cslots)
        self.VistA.wait('DATE/TIME')
        self.VistA.write('t+5')
        self.VistA.wait('DATE/TIME')
        self.VistA.write(datetime)
        if cvar is not None:
            self.VistA.wait('LENGTH OF APPOINTMENT')
            self.VistA.write('')
        self.VistA.wait('CORRECT')
        self.VistA.write('Yes')
        self.VistA.wait('STOPS')
        self.VistA.write('No')
        self.VistA.wait('OTHER INFO:')
        self.VistA.write('')
        if elig is not None and self.VistA.type == 'cache':
            self.VistA.wait('ENTER THE ELIGIBILITY FOR THIS APPOINTMENT:')
            self.VistA.write('')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')
        self.VistA.wait('')
