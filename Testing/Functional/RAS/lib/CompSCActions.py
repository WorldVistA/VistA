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


## @class CompSCActions
## Scheduling/Competition Scheduling Actions


'''
Scheduling/Competition Scheduling Actions class. Extends SCActions

Created on April 2013
@copyright: PwC
@author: afequ871
@license: http://www.apache.org/licenses/LICENSE-2.0

'''
from SCActions import SCActions
import TestHelper
import datetime
from datetime import timedelta, time
import sys
import logging
#import tkMessageBox

class CompSCActions (SCActions):
    '''
    This class extends the SCActions class with methods specific to actions performed
    through the Roll and Scroll interface for the Competition Scheduling in the Scheduling package.
    '''
    # Object for different Option types
    options = {'Holiday': 'SDHOLIDAY', 'Services': 'ECTP LOCAL SERVICES', 'Clinic Setup': 'SDBUILD', 'Supervisor': 'SDSUP', 'Register a Patient': 'Register a Patient'}
    clinics = []
    isWindows = True if sys.platform == 'win32' else False

    def __init__(self, VistAconn, scheduling=None, user=None, code=None):
        SCActions.__init__(self, VistAconn, scheduling, user, code)

    def signon (self, isFileman=None, optionType=None):
        ''' This provides a signon via ^XUP or S XUMF=1 D Q^DI based on isFileMan option.
        Also signon via ^ZU depending on the value of acode'''
        if self.acode is None:
            if isFileman is None:
                self.VistA.wait('')
                self.VistA.write('S DUZ=1 D ^XUP')
                if optionType is None:
                    self.VistA.wait('OPTION NAME:')
                    self.VistA.write('SDAM APPT MGT')
                else:
                    self.VistA.wait('OPTION NAME:')
                    self.VistA.write(self.options[optionType])
            else:
                self.VistA.wait('')
                self.VistA.write('S DUZ=1 S XUMF=1 D Q^DI')
                self.VistA.wait('OPTION:')
                self.VistA.write('1')
        else:
            self.VistA.wait('');
            self.VistA.write('D ^ZU')
            self.VistA.wait('ACCESS CODE:');
            self.VistA.write(self.acode)
            self.VistA.wait('VERIFY CODE:');
            self.VistA.write(self.vcode)
            self.VistA.wait('//');
            self.VistA.write('')
            self.VistA.wait('Option:')
            self.VistA.write('Scheduling')

    def schtime(self, delta):
        '''Calculates a time for the next hour or mins'''
        if 'h' in delta:
            ttime = datetime.datetime.now() + datetime.timedelta(hours=int(delta.rstrip('h')))
        elif 'm' in delta:
            ttime = datetime.datetime.now() + datetime.timedelta(minutes=int(delta.rstrip('m')))
        return ttime.strftime("%H%M")#.lstrip('0')

    def getclinic(self, wantedClinic):
        '''Determines which clinic to use based on the time of day and expected clinic'''
        now = datetime.datetime.now()
        hour = now.hour
        relatedClinicList = self.findRelatedClinic(wantedClinic)
        return self.findClinicByTime(relatedClinicList, hour)

    def findClinicByTime(self, relatedClinics, currentTimeHour):
        '''Searches related clinics and extracts appropriate clinic based on desired time hour'''
        correctClinic = ""
        for i in range (0, len(relatedClinics)):
            currentClinic = relatedClinics[i]
            timeRange = currentClinic.get("time").split("-")
            start = 24 if int(timeRange[0][:2]) == 0 else int(timeRange[0][:2])
            end = 24 if int(timeRange[1][:2]) == 0 else int(timeRange[1][:2])
            if currentTimeHour >= start and currentTimeHour <= end:
                correctClinic = currentClinic.get("name")
        return correctClinic

    def findRelatedClinic(self, clinic):
        '''Takes clinic and parses clinic list for similar matching clinics'''
        matchingClinics = []
        results = clinic.split()
        searchStr = results[0] + " " + results[1] + " " + results[2]
        for x in range (0, len(self.clinics)):
            currentClinic = self.clinics[x]
            if searchStr in currentClinic.get("name"):
                matchingClinics.append(currentClinic)
        return matchingClinics

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

    def createCompSchedInsitutions(self):
        '''Creates specific institutions for Scheduling Competition'''
        self.VistA.wait('INPUT TO WHAT FILE:')
        self.VistA.write('4')
        self.VistA.wait('EDIT WHICH FIELD')
        self.VistA.write('STATION NUMBER')
        self.VistA.wait('THEN EDIT FIELD')
        self.VistA.write('')
        self.VistA.wait('Select INSTITUTION NAME:')
        self.VistA.write('CALIFORNIA VA HEALTH CARE SYS')
        self.VistA.wait('Are you adding')
        self.VistA.write('Y')
        self.VistA.wait('STATION NUMBER:')
        self.VistA.write('7100')
        self.VistA.wait('Select INSTITUTION NAME:')
        self.VistA.write('CALIFORNIA VA OUTPAT CLIN')
        self.VistA.wait('Are you adding')
        self.VistA.write('Y')
        self.VistA.wait('STATION NUMBER:')
        self.VistA.write('7102')
        self.VistA.wait('Select INSTITUTION NAME:')
        self.VistA.write('')
        self.VistA.wait('Select OPTION:')
        self.VistA.write('1')
        self.VistA.wait('INPUT TO WHAT FILE:')
        self.VistA.write('40.8')
        self.VistA.wait('EDIT WHICH FIELD')
        self.VistA.write('FACILITY NUMBER')
        self.VistA.wait('THEN EDIT FIELD')
        self.VistA.write('INSTITUTION FILE POINTER')
        self.VistA.wait('THEN EDIT FIELD')
        self.VistA.write('')
        self.VistA.wait('DIVISION NAME')
        self.VistA.write('CALIFORNIA VA REGIONAL MED CTR')
        self.VistA.wait('Are you adding')
        self.VistA.write('Y')
        self.VistA.wait('MEDICAL CENTER DIVISION NUM:')
        self.VistA.write('')
        self.VistA.wait('FACILITY NUMBER')
        self.VistA.write('7101')
        self.VistA.write('')
        self.VistA.wait('INSTITUTION FILE POINTER')
        self.VistA.write('7100')
        self.VistA.write('')
        self.VistA.wait('Select OPTION:')
        self.VistA.write('1')
        self.VistA.wait('INPUT TO WHAT FILE:')
        self.VistA.write('4')
        self.VistA.wait('EDIT WHICH FIELD')
        self.VistA.write('ASSOCIATIONS')
        self.VistA.wait('ASSOCIATIONS SUB-FIELD:')
        self.VistA.write('PARENT OF ASSOCIATION')
        self.VistA.wait('ASSOCIATIONS SUB-FIELD:')
        self.VistA.write('')
        self.VistA.wait('THEN EDIT FIELD:')
        self.VistA.write('')
        self.VistA.wait('Select INSTITUTION NAME:')
        self.VistA.write('CALIFORNIA VA HEALTH CARE SYS')
        self.VistA.wait('Select ASSOCIATIONS:')
        self.VistA.write('2')
        self.VistA.wait('TUTION)?')
        self.VistA.write('y')
        self.VistA.wait('PARENT OF ASSOCIATION:')
        self.VistA.write('CALIFORNIA VA OUTPAT CLIN\r\r')


    def standardServicesSetup(self):
        '''Standard Services Setup for Scheduling Competition'''
        self.VistA.wait('Select a number (1 - 5):')
        self.VistA.write('1')
        while True:
            output = self.VistA.wait_re(['LOCAL SERVICE', 'VISTA>', 'GTM>'])
            currentIndex = output[0]
            currentText = output[2]
            currentMatch = output[1]
            if currentIndex == 1 or currentIndex == 2:
                break
            elif "\nMEDICINE\r" in currentText or "\nPSYCHIATRY\r" in currentText or "\nSURGERY\r" in currentText:
                self.VistA.write('YES')
            else:
                self.VistA.write('')

    def holidaySetup(self, holidayList):
        '''Holiday Setup for Scheduling Competition'''
        for x in range (0, len(holidayList)):
            output = self.VistA.wait_re(['ADD/EDIT HOLIDAY'])
            self.VistA.write(holidayList[x].get('date'))
            self.VistA.wait('as a new HOLIDAY')
            self.VistA.write('Yes')
            self.VistA.wait('HOLIDAY NAME:')
            if x == len(holidayList) - 1:
                self.VistA.write(holidayList[x].get('name') + '\r\r')
            else:
                self.VistA.write(holidayList[x].get('name') + '\r')

    def preAppointmentTemplateSetup(self):
        '''pre-Appointment Template Setup for Scheduling Competition'''
        self.VistA.wait('INPUT TO WHAT FILE:')
        self.VistA.write('LETTER')
        self.VistA.wait('1-2:')
        self.VistA.write('1')
        self.VistA.wait('EDIT WHICH FIELD:')
        self.VistA.write('ALL')
        self.VistA.wait('Select LETTER NAME:')
        self.VistA.write('NEW APPOINTMENT')
        self.VistA.wait(')?')
        self.VistA.write('yes')
        self.VistA.wait('TYPE:')
        self.VistA.write('P\r')
        self.VistA.wait('INITIAL SECTION OF LETTER:')
        self.VistA.write('This is a test pre-appointment letter\r\r')
        self.VistA.wait('FINAL SECTION OF LETTER:')
        self.VistA.write('Thanks\r\r')
        self.VistA.wait('Select LETTER NAME:')
        self.VistA.write('\r')

    def appointmentTypeSetup(self):
        '''Standard Appointment Type Setup for Scheduling Competition'''
        self.VistA.wait('INPUT TO WHAT FILE:')
        self.VistA.write('appointment type')
        self.VistA.wait('EDIT WHICH FIELD')
        self.VistA.write('ALL')
        self.VistA.wait('Select APPOINTMENT TYPE NAME:')
        self.VistA.write('??')

        output = self.VistA.wait_re(['Select APPOINTMENT TYPE NAME:'])
        currentText = output[2]
        if "COMPENSATION & PENSION" in currentText and "EMPLOYEE" in currentText and "REGULAR" in currentText:
            ''' then good '''
        else:
            ''' add them '''
        self.VistA.write('\r\r')

    def clinicSetup(self, clinicList):
        '''Clinic setup for Scheduling Competition'''
        for i in range(0, len(clinicList)):
            self.VistA.wait('CLINIC NAME:')
            self.VistA.write(clinicList[i].get('name'))
            self.VistA.wait('LOCATION?')
            self.VistA.write('Yes')
            self.VistA.wait('NAME:')
            self.VistA.write('')
            self.VistA.wait('ABBREVIATION')
            self.VistA.write(clinicList[i].get('abr'))
            self.VistA.wait('FACILITY?')
            self.VistA.write('')
            self.VistA.wait('SERVICE:')
            self.VistA.write('MEDICINE')
            self.VistA.wait('CLINIC?')
            self.VistA.write('N')
            self.VistA.wait('NUMBER:')
            self.VistA.write('323')
            self.VistA.wait('TYPE:')
            self.VistA.write('')
            self.VistA.wait('MEDS?')
            self.VistA.write('')
            self.VistA.wait('TELEPHONE')
            self.VistA.write('')
            self.VistA.wait('FILMS?')
            self.VistA.write('Yes')
            self.VistA.wait('PROFILES?')
            self.VistA.write('Yes')
            for x in range(0, 4):
                output = self.VistA.wait_re(['LETTER:'])
                currentText = output[2]
                if "\nPRE-APP" in currentText:
                    self.VistA.write('New Appointment')
                else:
                    self.VistA.write('')
            self.VistA.wait('TIME:')
            self.VistA.write('Yes')
            self.VistA.wait('PROVIDER:')
            self.VistA.write(clinicList[i].get('provider1'))
            self.VistA.wait(')?')
            self.VistA.write('Yes')
            self.VistA.wait('DEFAULT PROVIDER:')
            self.VistA.write('yes')
            self.VistA.wait('PROVIDER:')
            self.VistA.write(clinicList[i].get('provider2'))
            self.VistA.wait(')?')
            self.VistA.write('Yes')
            self.VistA.wait('DEFAULT PROVIDER:')
            self.VistA.write('no')
            self.VistA.wait('PROVIDER:')
            self.VistA.write('')
            self.VistA.wait('PRACTITIONER?')
            self.VistA.write('')
            self.VistA.wait('DIAGNOSIS')
            self.VistA.write('')
            self.VistA.wait('CHK OUT:')
            self.VistA.write('')
            self.VistA.wait('NO-SHOWS:')
            self.VistA.write('10')
            self.VistA.wait('BOOKING')
            self.VistA.write('365')
            self.VistA.wait('BEGINS:')
            self.VistA.write(clinicList[i].get('strTime'))
            self.VistA.wait('REBOOK:')
            self.VistA.write('')
            self.VistA.wait('REBOOK:')
            self.VistA.write('365')
            self.VistA.wait('HOLIDAYS')
            self.VistA.write('Yes')
            self.VistA.wait('CODE:')
            self.VistA.write('450')
            self.VistA.wait('CLINIC')
            self.VistA.write('')
            self.VistA.wait('LOCATION')
            self.VistA.write('')
            self.VistA.wait('CLINIC')
            self.VistA.write('')
            self.VistA.wait('MAXIMUM')
            self.VistA.write('4')
            self.VistA.wait('INSTRUCTIONS')
            self.VistA.write('')
            self.VistA.wait('LENGTH')
            self.VistA.write('15')
            self.VistA.wait('LENGTH')
            self.VistA.write('yes')
            self.VistA.wait('HOUR')
            self.VistA.write('4')
            for a in range(0, 7):
                self.VistA.wait('DATE:')
                if a == 0:
                    self.VistA.write('t')
                else:
                    self.VistA.write('t+' + str(a))
                self.VistA.wait('TIME:')
                self.VistA.write(clinicList[i].get('time'))
                self.VistA.wait('SLOTS:')
                self.VistA.write('16')
                self.VistA.wait('TIME:')
                self.VistA.write('')
                self.VistA.wait('INDEFINITELY')
                self.VistA.write('Yes')
            self.VistA.wait('DATE:')
            self.VistA.write('')

            ''' Store clinic in list'''
            clinicObj = {}
            clinicObj['name'] = clinicList[i].get('name')
            clinicObj['time'] = clinicList[i].get('time')
            self.clinics.append(clinicObj)
        self.VistA.write('')

    def modifyClinicInst(self, clinicList):
        '''Modify Clinic Institution mapping file for Scheduling Competition'''
        self.VistA.wait('INPUT TO WHAT FILE:')
        self.VistA.write('Hospital Location')
        self.VistA.wait('EDIT WHICH FIELD')
        self.VistA.write('Institution\r')
        for i in range(0, len(clinicList)):
            self.VistA.wait('LOCATION NAME:')
            self.VistA.write(clinicList[i].get('name'))
            self.VistA.wait('INSTITUTION:')
            self.VistA.write(clinicList[i].get('facilityId'))
        self.VistA.wait('LOCATION NAME:')
        self.VistA.write('\r')

    def deactivateClinic(self, clinic):
        '''Deactivates a clinic for Scheduling Competition'''
        self.VistA.wait('Option:')
        self.VistA.write('Inactivate')
        self.VistA.wait('CLINIC NAME:')
        self.VistA.write(clinic)
        self.VistA.wait('to be Inactivated:')
        self.VistA.write('t' + '\r')
        self.VistA.wait('halt?')
        self.VistA.write('yes')

    def reactivateClinic(self, clinic):
        '''Reactivates a clinic for Scheduling Competition'''
        self.VistA.wait('Option:')
        self.VistA.write('Reactivate')
        self.VistA.wait('CLINIC NAME:')
        self.VistA.write(clinic)
        self.VistA.wait('to be reactivated:')
        self.VistA.write('t+1')
        self.VistA.wait('TIME:')
        self.VistA.write('0800-1600')
        self.VistA.wait('SLOTS:')
        self.VistA.write('16')
        self.VistA.wait('TIME:')
        self.VistA.write('')
        self.VistA.wait('INDEFINITELY')
        self.VistA.write('Yes')
        self.VistA.wait('now?')
        self.VistA.write('Yes')
        for a in range(2, 8):
            self.VistA.wait('DATE:')
            self.VistA.write('t+' + str(a))
            self.VistA.wait('TIME:')
            self.VistA.write('0800-1600')
            self.VistA.wait('SLOTS:')
            self.VistA.write('16')
            self.VistA.wait('TIME:')
            self.VistA.write('')
            self.VistA.wait('INDEFINITELY')
            self.VistA.write('Yes')
        self.VistA.wait('DATE:')
        self.VistA.write('\r')
        self.VistA.wait('halt?')
        self.VistA.write('yes')

    def copyMultiAppDateRange(self, clinic, appointment, strDate, endDate):
        '''Makes Multiple Appointment for specified user at specified time'''
        dateFormat = "%m/%d/%Y"
        d1 = datetime.datetime.strptime(strDate, dateFormat)
        d2 = datetime.datetime.strptime(endDate, dateFormat)
        length = (d2 - d1).days
        currentDate = d1
        originalDateTime = appointment['datetime']
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write('')
        self.VistA.wait('Date:')
        self.VistA.write('t+365')
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('Select List:')
        self.VistA.write('TA')
        for i in range(0, length + 1):
            appointment['datetime'] = str(currentDate.strftime("%b %d %Y")) + originalDateTime
            self.makeAppForLoop(appointment.get('patient'), appointment.get('datetime'), appointment.get('mins'), appointment.get('note'), appointment.get('fresh'), appointment.get('nextAvailable'))
            currentDate += timedelta(days=1)
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')

    def makeMultiApp(self, clinic, appointments):
        '''Makes Multiple Appointment for specified user at specified time'''
        returnList = []
        returnObj = {}
        number = len(appointments)
        for i in range(0, number):
            if appointments[i].get('datetime').upper() == "NOW":
                clinic = self.getclinic(clinic)
            self.VistA.wait('Clinic name:')
            self.VistA.write(clinic)
            self.VistA.wait('OK')
            self.VistA.write('Yes')
            self.VistA.wait('Date:')
            self.VistA.write('')
            self.VistA.wait('Date:')
            self.VistA.write('t+365')
            self.makeAppForLoop(appointments[i].get('patient'), appointments[i].get('datetime'), appointments[i].get('mins'), appointments[i].get('note'), appointments[i].get('fresh'), appointments[i].get('nextAvailable'))
            self.VistA.wait('Select Action:')
            self.VistA.write('Quit')
            self.signon()
            ''' Return object '''
            returnObj['clinic'] = clinic
            returnObj['patient'] = appointments[i].get('patient')
            returnObj['datetime'] = appointments[i].get('datetime')
            returnList.append(returnObj)
        self.VistA.write('^\r')
        return returnList

    def makeAppForLoop(self, patient, datetime, mins, note, fresh=None, nextAvailable=None):
        '''Makes Appointment for specified user at specified time used in loops'''
        self.VistA.wait('Select Action:')
        self.VistA.write('MA')
        '''self.VistA.wait('PATIENT NAME:')
        self.VistA.write('??')
        if self.VistA.wait('TO STOP:'):
            self.VistA.write('^')'''
        self.VistA.wait('PATIENT NAME:')
        self.VistA.write(patient)
        self.VistA.wait('TYPE:')
        self.VistA.write('Regular')
        option = self.VistA.wait_re(['DISPLAY PENDING APPOINTMENTS:', 'ETHNICITY:'])
        currentIndex = option[0]
        currentText = option[2]
        if currentIndex == 0 or 'PENDING APPOINTMENTS:' in currentText:
            #self.VistA.wait('APPOINTMENTS:')
            self.VistA.write('Yes')
            output = self.VistA.wait_re(['to escape', 'ETHNICITY:'])
            nextIndex = output[0]
            if nextIndex == 0:
                self.VistA.write("^")
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
        if nextAvailable is None:
            self.VistA.write('Yes')
            self.VistA.wait('DATE/TIME')
        else:
            self.VistA.write(nextAvailable)
            self.VistA.wait('APPOINTMENT:')
        self.VistA.write(datetime)
        output = self.VistA.wait_re(['OK?', 'IN MINUTES:'])
        currentIndex = output[0]
        if currentIndex == 0:
            self.VistA.write('Yes')
        #self.VistA.wait('IN MINUTES')
        self.VistA.write(mins)
        self.VistA.wait('CORRECT')
        self.VistA.write('Yes')
        self.VistA.wait('STOPS')
        self.VistA.write('No')
        self.VistA.wait('OTHER INFO:')
        self.VistA.write(note)
        self.VistA.wait('continue:')
        self.VistA.write('')
        output = self.VistA.wait_re(['Check In or Check Out:', ':'])
        currentIndex = output[0]
        if currentIndex == 0:#self.VistA.wait('Check In or Check Out:'):#currentIndex == 0:
            self.VistA.write('^')


    def blockMultiApp(self, appointments):
        '''Blocks Multiple Appointment for specified user at specified time'''
        number = len(appointments)
        for i in range(0, number):
            self.blockApp(appointments[i].get('clinic'), appointments[i].get('date'), appointments[i].get('note'), appointments[i].get('strTime'), appointments[i].get('endTime'))

    def blockApp(self, clinic, date, note, strTime=None, endTime=None, multi=None):
        '''Blocks Appointment for specified user at specified time or full day'''
        self.VistA.wait('Option:')
        self.VistA.write('cancel clinic')
        self.VistA.wait('CLINIC NAME:')
        self.VistA.write(clinic)
        self.VistA.wait('DATE:')
        self.VistA.write(date)
        rval = self.VistA.multiwait(['WHOLE DAY?', 'DEVICE:'])
        if rval == 1:
            text = '\r' if self.isWindows else ''
            self.VistA.write(text) # for windows ('\r') linux-('')
            option = self.VistA.multiwait(['WHOLE DAY?', 'exit:'])
            if option == 1:
                self.VistA.write('^')
                self.VistA.wait('WHOLE DAY?')
        if strTime is None or endTime is None:
            #self.VistA.wait('WHOLE DAY?:')
            self.VistA.write('Yes')
            self.VistA.wait('cancellation:')
            self.VistA.write(note)
        else:
            #self.VistA.wait('WHOLE DAY?:')
            self.VistA.write('no')
            self.VistA.wait('PART OF THE DAY?')
            self.VistA.write('YES')
            self.VistA.wait('STARTING TIME:')
            self.VistA.write(strTime)
            self.VistA.wait('ENDING TIME:')
            self.VistA.write(endTime)
            self.VistA.wait('cancellation:')
            self.VistA.write(note)

        option = self.VistA.multiwait(['continue:', ':'])
        if option == 0:
            self.VistA.write('')
            self.VistA.wait('APPOINTMENTS NOW?')
            self.VistA.write('no')
            self.VistA.wait('PRINTED NOW?')
            self.VistA.write('no')
        if multi is None:
            self.VistA.write('\r')

    def restoreMultiApp(self, appointments):
        '''Restores Multiple Blocked Appointment for specified user at specified time'''
        number = len(appointments)
        for i in range(0, number):
            self.restoreApp(appointments[i].get('clinic'), appointments[i].get('date'), appointments[i].get('period'), multi='Yes')

    def restoreApp(self, clinic, date, period=None, multi=None):
        '''restores Blocked Appointment for specified user at specified time or full day'''
        self.VistA.wait('Option:')
        self.VistA.write('restore clinic')
        self.VistA.wait('CLINIC NAME:')
        self.VistA.write(clinic)
        self.VistA.wait('DATE:')
        self.VistA.write(date)
        option = self.VistA.multiwait(['WHICH PERIOD?', ':'])
        if option == 0 and period is not None:
            self.VistA.write(period)
        elif option == 0 and period is None:
            self.VistA.write('1')
        if multi is None:
            self.VistA.write('\r')

    def listAllAppointmentByDate(self, clinic, strDate, endDate):
        '''Makes Appointment for specified user at specified time'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write(strDate)
        self.VistA.wait('Date:')
        self.VistA.write(endDate)
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('List:')
        self.VistA.write('TA')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')

    def listAllAppointmentByPatient(self, patient):
        '''Makes Appointment for specified user at specified time'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        '''self.VistA.wait('Date:')
        self.VistA.write(strDate)
        self.VistA.wait('Date:')
        self.VistA.write(endDate)'''
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('List:')
        self.VistA.write('TA')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')

    def listNoShowByDate(self, clinic, strDate, endDate):
        '''Makes Appointment for specified user at specified time'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write(strDate)
        self.VistA.wait('Date:')
        self.VistA.write(endDate)
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('List:')
        self.VistA.write('NS')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')

    def patientRegistration(self, patient):
        '''Patient Registration for a specific user '''
        self.VistA.wait('PATIENT NAME');
        self.VistA.write(patient.get('name'))
        self.VistA.wait('NEW PATIENT');
        self.VistA.write('YES')
        self.VistA.wait('SEX');
        self.VistA.write(patient.get('sex'))
        self.VistA.wait('DATE OF BIRTH');
        self.VistA.write(patient.get('dob'))
        self.VistA.wait('SOCIAL SECURITY NUMBER');
        self.VistA.write(patient.get('ssn'))
        self.VistA.wait('TYPE');
        self.VistA.write(patient.get('type'))
        self.VistA.wait('PATIENT VETERAN');
        self.VistA.write(patient.get('veteran'))
        self.VistA.wait('SERVICE CONNECTED');
        self.VistA.write(patient.get('service'))
        self.VistA.wait('MULTIPLE BIRTH INDICATOR');
        self.VistA.write(patient.get('isTwin'))
        self.VistA.wait('//');
        self.VistA.write('^\r')
        self.VistA.wait('MAIDEN NAME');
        self.VistA.write(patient.get('maiden'))
        self.VistA.wait('PLACE OF BIRTH');
        self.VistA.write(patient.get('cityOB'))
        self.VistA.wait('PLACE OF BIRTH');
        self.VistA.write(patient.get('stateOB'))
        self.VistA.wait('');
        self.VistA.write('\r\r\r')

    def viewPatientDemographic(self, patient):
        '''View specific patient demographic '''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)  # <--- by patient
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        #self.VistA.wait('Date:')
        #self.VistA.write('t')
        #self.VistA.wait('Date:')
        #self.VistA.write('t+365')
        self.VistA.wait('Select Action:')
        self.VistA.write('PD')
        while True:
            output = self.VistA.wait_re(['Select Action:', 'changes?', 'MARITAL STATUS', ':'])
            currentText = output[2]
            currentMatch = output[1]
            currentIndex = output[0]
            if currentIndex == 0:
                self.VistA.write('Quit')
                break
            elif currentIndex == 1:
                self.VistA.write('no')
            elif currentIndex == 2:
                if '//' in currentText:
                    self.VistA.write('')
                else:
                    self.VistA.write('unknown')
            else:
                self.VistA.write('')

    def patientCheckin(self, patient, strDate, endDate, appointmentNum):
        '''Patient Checkin now'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write(strDate)
        self.VistA.wait('Date:')
        self.VistA.write(endDate)
        self.VistA.wait('Select Action:')
        self.VistA.write('CI')
        self.VistA.wait('Appointmnet(s)')
        self.VistA.write(appointmentNum)
        self.VistA.wait('CHECKED-IN:')
        self.VistA.write('')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')

    def patientCheckout(self, clinic, strDate, endDate, provider, diagnosis):
        '''Patient Checkout now without follow up'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write(strDate)
        self.VistA.wait('Date:')
        self.VistA.write(endDate)
        self.VistA.wait('Select Action:')
        self.VistA.write('CO')
        '''self.VistA.wait('Appointmnet(s)')
        self.VistA.write(appointmentNum)'''
        self.VistA.wait('follow-up appointment?')
        self.VistA.write('no')
        self.VistA.wait('Check out date and time:')
        self.VistA.write('now')
        self.VistA.wait('PROVIDER')
        self.VistA.write(provider)
        self.VistA.wait('this ENCOUNTER?')
        self.VistA.write('yes')
        self.VistA.wait('PROVIDER')
        self.VistA.write('')
        self.VistA.wait('Diagnosis')
        self.VistA.write(diagnosis)
        self.VistA.wait('Ok')
        self.VistA.write('yes')
        self.VistA.wait('ENCOUNTER?')
        self.VistA.write('yes')
        self.VistA.wait('Ordering or Resulting:')
        self.VistA.write('R')
        self.VistA.wait('Diagnosis')
        self.VistA.write('')
        self.VistA.wait('Problem List?')
        self.VistA.write('no')
        self.VistA.wait('PROCEDURE')
        self.VistA.write('')
        self.VistA.wait('continue')
        self.VistA.write('')
        self.VistA.wait('check out screen?')
        self.VistA.write('no')
        self.VistA.wait('Clinic:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')

    def displayPatientAppointments(self, patient, strDate, endDate):
        '''Display Patient appointments'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(patient)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        self.VistA.write(strDate)
        self.VistA.wait('Date:')
        self.VistA.write(endDate)
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')

    def unschPatientVisit(self, clinic, patient):
        '''Makes a walk-in appointment. Automatically checks in'''
        clinic = self.getclinic(clinic)
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
        self.VistA.write('REGULAR')
        self.VistA.wait('to continue:', 40)
        self.VistA.write('')
        self.VistA.wait('Check In or Check Out:')
        self.VistA.write('CI')
        self.VistA.wait('CHECKED-IN:')
        self.VistA.write('')
        self.VistA.wait('to continue:')
        self.VistA.write('')
        self.VistA.wait('SLIP NOW?')
        self.VistA.write('No')
        self.VistA.wait('Checked In')
        self.VistA.wait('Select Action:')
        self.VistA.write('Quit')
        ''' Return accepted clinic'''
        return clinic

    def canapp(self, clinic, mult=None, rebook=None, strDate=None, endDate=None):
        '''Cancel an Appointment, if there are multiple apts on schedule, send a string to the parameter "first"'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        if strDate is not None and endDate is not None:
            self.VistA.write(strDate)
            self.VistA.wait('Date:')
            self.VistA.write(endDate)
        else:
            self.VistA.write('t')
            self.VistA.wait('Date:')
            self.VistA.write('t+1')
        self.VistA.wait('Select Action:')
        self.VistA.write('AL')
        self.VistA.wait('Select List:')
        self.VistA.write('TA')
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
        if rebook is not None:
            self.VistA.wait('CANCELLED')
            self.VistA.write('Y')
            self.VistA.wait('REBOOKED APPT(S)')
            self.VistA.write('')
            self.VistA.wait('REBOOKED:')
            self.VistA.write('1')
            self.VistA.wait('DATE:')
            self.VistA.write('')
            self.VistA.wait('continue')
            self.VistA.write('')
            self.VistA.wait('continue')
            self.VistA.write('')
            self.VistA.wait('CONTINUE')
            self.VistA.write('')
            self.VistA.wait('APPOINTMENT(S)?')
            self.VistA.write('N')
        else:
            self.VistA.wait('CANCELLED')
            self.VistA.write('')
            self.VistA.wait('CANCELLED')
            self.VistA.write('')
        self.VistA.wait('exit:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def noshow(self, clinic, appnum=None):
        '''Registers a patient as a no show'''
        clinic = self.getclinic(clinic)
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
        if appnum is not None:
            self.VistA.wait('Select Appointment')
            self.VistA.write(appnum)
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('NOW')
        self.VistA.write('no')
        self.VistA.wait('NOW')
        self.VistA.write('no')
        self.VistA.wait('exit:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('')

    def checkin(self, clinic, vlist, strDate=None, endDate=None, mult=None):
        '''Checks a patient in'''
        self.VistA.wait('Clinic name:')
        self.VistA.write(clinic)
        self.VistA.wait('OK')
        self.VistA.write('Yes')
        self.VistA.wait('Date:')
        if strDate is not None and endDate is not None:
            self.VistA.write(strDate)
            self.VistA.wait('Date:')
            self.VistA.write(endDate)
        else:
            self.VistA.write('t')
            self.VistA.wait('Date:')
            self.VistA.write('t')
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
            self.VistA.wait(vitem)
        self.VistA.write('')
        self.VistA.wait('continue:')
        self.VistA.write('')
        self.VistA.wait('Select Action:')
        self.VistA.write('')
