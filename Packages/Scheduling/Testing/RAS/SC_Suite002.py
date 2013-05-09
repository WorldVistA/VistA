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


## @package SC_Suite002
## Scheduling Competition Test (Suite)

'''
These are the Scheduling Competition package Suite002 tests, implemented as Python functions.

Each test has a unique name derived from the test method name.
Each test has a unique result log with a filename derived from the testname and a datestamp.
There is a parent resultlog that is also used for pass/fail logging.
In general each test establishes a connection to the target application (VistA),
signs on as a user, provider, or programmer and then performs a set of test functions.
When testing is complete the connection is closed and a pass/fail indicate is written
to the resultlog.

Created on April 2013
@copyright: PwC
@author: afequ871
@license: http://www.apache.org/licenses/LICENSE-2.0

'''
import sys
sys.path = ['./Functional/RAS/lib'] + ['./dataFiles'] + ['./Python/vista'] + sys.path
from CompSCActions import CompSCActions
import TestHelper
import datetime
import logging

def comp_sc_test001(resultlog, result_dir, namespace):
    '''Objective: Use Case 1 - Configure and update scheduling component structure, file, and tables.'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA = connect_VistA(testname, result_dir, namespace)
        SC = CompSCActions(VistA, scheduling='Scheduling')
        #time = SC.schtime()
        SC.signon(isFileman=True)
        SC.createCompSchedInsitutions()
        SC.signon(isFileman=True)
        SC.preAppointmentTemplateSetup()
        SC.signon(isFileman=True)
        SC.appointmentTypeSetup()
        SC.signon(optionType='Services')
        SC.standardServicesSetup()
        SC.signon(optionType='Holiday')
        SC.holidaySetup(holidayList=[{'name': 'National VA Organization Day', 'date': 'Jul 20 2012'},
                                     {'name': 'National VA Organization Day', 'date': 'Jul 22 2013'},
                                     {'name': 'National VA Organization Day', 'date': 'Jul 21 2014'},
                                     {'name': 'Valentines Day', 'date': 'Feb 13 2012'},
                                     {'name': 'Valentines Day', 'date': 'Feb 14 2013'},
                                     {'name': 'Valentines Day', 'date': 'Feb 14 2014'}])
        SC.signon(optionType='Clinic Setup')
        SC.clinicSetup(clinicList=[{'name': 'CALIFORNIA VA REGIONAL MED CTR', 'abr': 'CAVARMC', 'provider1': 'Alexander', 'provider2': 'Smith', 'strTime':'8', 'time':'0800-1600'},
                                   {'name': 'CALIFORNIA VA OUTPAT CLIN', 'abr': 'CAVAOPC', 'provider1': 'Smith', 'provider2': 'Alexander', 'strTime':'8', 'time':'0800-1600'},
                                   {'name': 'CALIFORNIA VA REGIONAL EARLY', 'abr': 'CAVARE', 'provider1': 'Alexander', 'provider2': 'Smith', 'strTime':'0', 'time':'0000-0800'},
                                   {'name': 'CALIFORNIA VA REGIONAL LATE', 'abr': 'CAVARL', 'provider1': 'Alexander', 'provider2': 'Smith', 'strTime':'16', 'time':'1600-2400'},
                                   {'name': 'CALIFORNIA VA OUTPAT EARLY', 'abr': 'CAVAOE', 'provider1': 'Smith', 'provider2': 'Alexander', 'strTime':'0', 'time':'0000-0800'},
                                   {'name': 'CALIFORNIA VA OUTPAT LATE', 'abr': 'CAVAOL', 'provider1': 'Smith', 'provider2': 'Alexander', 'strTime':'16', 'time':'1600-2400'},
                                   {'name': 'TEMP CLINIC', 'abr': 'TC', 'provider1': 'Alexander', 'provider2': 'Smith', 'strTime':'8', 'time':'0800-1600'}])
        SC.signon(isFileman=True)
        SC.modifyClinicInst(clinicList=[{'name': 'CALIFORNIA VA REGIONAL MED CTR', 'facilityId': '7100'},
                                        {'name': 'CALIFORNIA VA OUTPAT CLIN', 'facilityId': '7102'}])
        SC.signon(optionType='Supervisor')
        SC.deactivateClinic(clinic='TEMP CLINIC')
        SC.signon(optionType='Supervisor')
        SC.reactivateClinic(clinic='TEMP CLINIC')
        SC.signon(optionType='Register a Patient')
        SC.patientRegistration(patient={'name':'Simmons, Kelli A', 'sex':'F', 'dob':'12021989', 'ssn':'444555777', 'type':'NSC Veteran', 'veteran':'Y', 'service':'Y', 'isTwin':'N', 'maiden':'Crews', 'cityOB':'Boston', 'stateOB':'MA'})
        SC.signoff()
    except TestHelper.TestError, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    else:
        resultlog.write('Pass\n')

def comp_sc_test002(resultlog, result_dir, namespace):
    '''Objective: Use Case 2 - Configure resources for a section (i.e., providers, rooms, equipment).
       Create schedules for resources in a section.  Hold a schedule that was created then release it manually and automatically.
       Block a date/time range of schedules. Block a date/time range of schedule with existing appointments. '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA = connect_VistA(testname, result_dir, namespace)
        SC = CompSCActions(VistA, scheduling='Scheduling')
        #time = SC.schtime()
        SC.signon()
        SC.makeMultiApp(clinic='CALIFORNIA VA REGIONAL MED CTR', appointments=[{'patient': 'ONE', 'datetime': 't+1@1200', 'mins': '30', 'note': 'Initial', 'fresh': None}, #+ SC.schtime('30m'),'mins': '30','note': 'Initial','fresh': None},
                                                                                {'patient': 'ONE', 'datetime': 't+1@1300', 'mins': '15', 'note': 'Follow-Up', 'fresh': 'True'}])#+SC.schtime('1h'),'mins': '15','note': 'Follow-Up','fresh': 'True'}])
        SC.signon()
        SC.makeMultiApp(clinic='CALIFORNIA VA OUTPAT CLIN', appointments=[{'patient': 'TWO', 'datetime': 't+1@1200', 'mins': '30', 'note': 'C&P', 'fresh': None}, #+SC.schtime('30m'),'mins': '30','note': 'C&P','fresh': None},
                                                                           {'patient': 'TWO', 'datetime': 't+1@1300' , 'mins': '15', 'note': 'Regular', 'fresh': 'True'}]) #+SC.schtime('1h'),'mins': '15','note': 'Regular','fresh': 'True'}])
        SC.signon()
        SC.copyMultiAppDateRange(clinic='CALIFORNIA VA REGIONAL MED CTR', appointment={'patient': 'ONE', 'datetime': '@0800', 'mins': '30', 'note': 'Schedule', 'fresh': None, 'nextAvailable': 'No'}, strDate='12/04/2013', endDate='01/15/2014')
        SC.signon(optionType='Supervisor')
        SC.blockApp(clinic='CALIFORNIA VA REGIONAL MED CTR', date='Jan 5 2014', note='block single appt')
        SC.signon(optionType='Supervisor')
        SC.restoreApp(clinic='CALIFORNIA VA REGIONAL MED CTR', date='Jan 5 2014')
        SC.signon(optionType='Supervisor')
        SC.blockApp(clinic='CALIFORNIA VA REGIONAL MED CTR', date='Dec 5 2013', note='block half day', strTime='0900', endTime='1200')
        SC.signon()
        SC.makeMultiApp(clinic='CALIFORNIA VA REGIONAL MED CTR', appointments=[{'patient': 'ONE', 'datetime': 't+1@1000', 'mins': '15', 'note': 'Medicine refills', 'fresh': None},
                                                                                {'patient': 'ONE', 'datetime': 't+1@1545', 'mins': '15', 'note': 'New appointment', 'fresh': 'True'}])
        SC.signon(optionType='Supervisor')
        SC.blockApp(clinic='CALIFORNIA VA REGIONAL MED CTR', date='Jan 14 2014', note='block multi days')
        SC.signon(optionType='Supervisor')
        SC.blockApp(clinic='CALIFORNIA VA REGIONAL MED CTR', date='Jan 15 2014', note='block multi days')
        SC.signon()
        SC.listAllAppointmentByDate(clinic='CALIFORNIA VA REGIONAL MED CTR', strDate='t', endDate='t+365')
        SC.signoff()
    except TestHelper.TestError, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    else:
        resultlog.write('Pass\n')

def comp_sc_test003(resultlog, result_dir, namespace):
    '''Objective: Use Case 3 - Create an appointment. Once the appointment has been scheduled, the scheduler
       provides the scheduled appointment information to the patient. Additional actions to be
       demonstrated are detailed in the use case steps. Written appointment notifications need to be
       provided to the patient either through the mail or by using e-mail and the method that was used to
       notify the patient of their appointment is captured in the scheduling component.'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA = connect_VistA(testname, result_dir, namespace)
        SC = CompSCActions(VistA, scheduling='Scheduling')
        #time = SC.schtime()
        SC.signon(optionType='Register a Patient')
        SC.patientRegistration(patient={'name':'Ryan, Mark A', 'sex':'M', 'dob':'09021987', 'ssn':'777888999', 'type':'NSC Veteran', 'veteran':'Y', 'service':'Y', 'isTwin':'N', 'maiden':'Brown', 'cityOB':'Manhattan', 'stateOB':'NY'})
        SC.signon()
        SC.makeMultiApp(clinic='CALIFORNIA VA OUTPAT CLIN', appointments=[{'patient': 'Ryan, Mark A', 'datetime': 'Jul 8 2013@0800', 'mins': '15', 'note': 'desired appointment'},
                                                                           {'patient': 'Ryan, Mark A', 'datetime': 'Jul 22 2013@0800', 'mins': '15', 'note': 'agreed upon date'}])
        SC.signoff()
    except TestHelper.TestError, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    else:
        resultlog.write('Pass\n')

def comp_sc_test004(resultlog, result_dir, namespace):
    '''Objective: Use Case 4 - Check in a patient for an appointment and disposition a patient from an appointment.'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA = connect_VistA(testname, result_dir, namespace)
        SC = CompSCActions(VistA, scheduling='Scheduling')
        #time = SC.schtime()
        SC.signon()
        SC.viewPatientDemographic(patient='Ryan, Mark A')
        SC.signon()
        returnObj = SC.makeMultiApp(clinic='CALIFORNIA VA REGIONAL MED CTR', appointments=[{'patient': 'Ryan, Mark A', 'datetime': 'NOW', 'mins': '15', 'note': 'multi appt'}])
        acceptedClinic = returnObj[0].get('clinic')
        SC.signon()
        SC.makeMultiApp(clinic='CALIFORNIA VA OUTPAT CLIN', appointments=[{'patient': 'Ryan, Mark A', 'datetime': 't+1@1130', 'mins': '15', 'note': 'multi appt'}])
        SC.signon()
        SC.checkin(clinic=acceptedClinic, vlist=['CHECKED-IN:'], strDate='t', endDate='t') #SC.schtime('30m'), 'CHECKED-IN:'])
        SC.signon()
        SC.listAllAppointmentByDate(clinic='CALIFORNIA VA OUTPAT CLIN', strDate='t', endDate='t+1')
        SC.signon()
        SC.patientCheckout(clinic=acceptedClinic, strDate='t', endDate='t', provider='Alexander', diagnosis='305.91')
        '''SC.checkout(clinic='CALIFORNIA VA REGIONAL MED CTR', vlist1=['Ryan, Mark A', 'now', 'Checked In'],#SC.schtime('30m'), 'Checked In'],
                    vlist2=['305.91', 'OTHER DRUG', 'RESULTING'], icd='305.91',strDate='t',endDate='t')'''
        SC.signon()
        SC.listAllAppointmentByPatient(patient='Ryan, Mark A')
        SC.signoff()
    except TestHelper.TestError, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    else:
        resultlog.write('Pass\n')

def comp_sc_test005(resultlog, result_dir, namespace):
    '''Objective: Use Case 5 - Manage a patient that requires an unscheduled appointment (walk-in).'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA = connect_VistA(testname, result_dir, namespace)
        SC = CompSCActions(VistA, scheduling='Scheduling')
        #time = SC.schtime()
        SC.signon()
        SC.viewPatientDemographic(patient='Simmons, Kelli A')
        SC.signon()
        clinicReturn = SC.unschPatientVisit(clinic='CALIFORNIA VA OUTPAT CLIN', patient='Simmons, Kelli A')
        #SC.unschvisit(clinic='CALIFORNIA VA OUTPAT CLIN', patient='777888999', patientname='Ryan, Mark A')
        SC.signon()
        SC.listAllAppointmentByDate(clinic=clinicReturn, strDate='t', endDate='t+1')
        SC.signon()
        SC.patientCheckout(clinic=clinicReturn, strDate='t', endDate='t', provider='Smith', diagnosis='305.91')
        '''SC.checkout(clinic='CALIFORNIA VA OUTPAT CLIN', vlist1=['Ryan, Mark A', SC.schtime('0m'), 'Checked In'],
                    vlist2=['305.91', 'OTHER DRUG', 'RESULTING'], icd='305.91')'''
        SC.signon()
        SC.listAllAppointmentByPatient(patient='Simmons, Kelli A')
        SC.signoff()
    except TestHelper.TestError, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    else:
        resultlog.write('Pass\n')

def comp_sc_test007(resultlog, result_dir, namespace):
    '''Objective: Use Case 7 - Reschedule appointment.'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA = connect_VistA(testname, result_dir, namespace)
        SC = CompSCActions(VistA, scheduling='Scheduling')
        #time = SC.schtime()
        SC.signon()
        SC.makeMultiApp(clinic='CALIFORNIA VA OUTPAT CLIN', appointments=[{'patient': 'Simmons, Kelli A', 'datetime': 't+2@0800', 'mins': '15', 'note': 'appt'}])
        SC.signon()
        SC.canapp(clinic='CALIFORNIA VA OUTPAT CLIN', rebook=True, strDate='t+2', endDate='t+2')
        SC.signon()
        SC.noshow(clinic='CALIFORNIA VA OUTPAT CLIN')
        SC.signon()
        SC.listNoShowByDate(clinic='CALIFORNIA VA REGIONAL MED CTR', strDate='t', endDate='t+3')
        SC.signoff()
    except TestHelper.TestError, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    else:
        resultlog.write('Pass\n')


def startmon(resultlog, result_dir, namespace):
    '''Starts Coverage Monitor'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1 = connect_VistA(testname, result_dir, namespace)
        VistA1.startCoverage(routines=['SC*', 'SD*'])
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    finally:
        '''
        Close Vista
        '''
        VistA1.write('^\r^\r^\r')
        VistA1.write('h\r')

def stopmon (resultlog, result_dir, humanreadable, namespace):
    ''' STOP MONITOR'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        # Connect to VistA
        VistA1 = connect_VistA(testname, result_dir, namespace)
        path = (result_dir + '/' + timeStamped('Scheduling_coverage.txt'))
        VistA1.stopCoverage(path, humanreadable)
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    finally:
        '''
        Close Vista
        '''
        VistA1.write('^\r^\r^\r')
        VistA1.write('h\r')

def timeStamped(fname, fmt='%Y-%m-%d-%H-%M-%S_{fname}'):
    return datetime.datetime.now().strftime(fmt).format(fname=fname)

def connect_VistA(testname, result_dir, namespace):
    '''Connect to VistA'''
    logging.debug('Connect_VistA' + ', Namespace: ' + namespace)
    from OSEHRAHelper import ConnectToMUMPS, PROMPT
    VistA = ConnectToMUMPS(logfile=result_dir + '/' + timeStamped(testname + '.txt'), instance='', namespace=namespace)
    if VistA.type == 'cache':
        try:
            VistA.ZN(namespace)
        except IndexError, no_namechange:
            pass
    VistA.wait(PROMPT)
    return VistA
