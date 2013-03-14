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

## @package REG_Suite001
## Registration Package Test (Suite)

'''
These are the Registration package Suite001 tests, implemented as Python functions.

Each test has a unique name derived from the test method name.
Each test has a unique result log with a filename derived from the testname and a datestamp.
There is a parent resultlog that is also used for pass/fail logging.
In general each test establishes a connection to the target application (VistA),
signs on as a user, provider, or programmer and then performs a set of test functions.
When testing is complete the connection is closed and a pass/fail indicate is written
to the resultlog.

Created on November 2012
@author: pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import sys
sys.path = ['./Functional/RAS/lib'] + ['./dataFiles'] + ['./Python/vista'] + sys.path
from ADTActions import ADTActions
from Actions import Actions
import datetime
import TestHelper
import time

def reg_test001(test_suite_details):
    '''Test admission of 4 patients, then verify, then discharge '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        reg = ADTActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        reg.signon()
        reg.admit_a_patient(ssn='888776666', bed='1-A')
        reg.roster_list(vlist=['TWO,PATIENT B', '1-A'])
        reg.det_inpatient_inquiry(ssn='888776666', item='1', vlist=['DIRECT', '1-A', 'ALEXANDER,ROBER', 'SMITH,MARY'])
        reg.switch_bed(ssn='888776666', bed='1-B')
        reg.admit_a_patient(ssn='656451234', bed='1-A')
        reg.roster_list(vlist=['SIX,PATIENT F', '1-A'])
        reg.switch_bed(ssn='656451234', bed='2-A', badbed='1-B')
        reg.admit_a_patient(ssn='656771234', bed='1-A')
        reg.roster_list(vlist=['SEVEN,PATIENT G', '1-A'])
        reg.admit_a_patient(ssn='444678924', bed='2-B')
        reg.roster_list(vlist=['FOURTEEN,PATIENT', '2-B'])
        time.sleep(10)
        reg.seriously_ill_list(ssnlist=['888776666', '656451234', '656771234', '444678924'],
                               vlist1=['FOURTEEN,PATIENT', 'SEVEN,PATIENT', 'SIX,PATIENT', 'TWO,PATIENT'],
                               vlist2=[['TWO,PATIENT', '888776666'],
                                       ['SIX,PATIENT', '656451234'],
                                       ['SEVEN,PATIENT', '656771234'],
                                       ['FOURTEEN,PATIENT', '444678924']])
        reg.treating_spcl_trans(ssn='888776666', spcl='CARDIAC SURGERY')
        time.sleep(10)
        reg.discharge_patient(ssn='888776666', dtime='NOW+1')
        reg.discharge_patient(ssn='656451234', dtime='NOW+10')
        reg.discharge_patient(ssn='656771234', dtime='NOW+100')
        reg.discharge_patient(ssn='444678924', dtime='NOW+1000')
        reg.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def reg_test002(test_suite_details):
    '''Test to Schedule, Unschedule, and Transfer Patients '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        reg = ADTActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        reg.signon()
        reg.admit_a_patient(ssn='888776666', bed='1-A')
        reg.roster_list(vlist=['TWO,PATIENT B', '1-A'])
        reg.det_inpatient_inquiry(ssn='888776666', item='1', vlist=['DIRECT', '1-A', 'ALEXANDER,ROBER', 'SMITH,MARY'])
        reg.schedule_admission(ssn='656451234')
        reg.schedule_admission(ssn='656771234')
        reg.scheduled_admit_list(vlist=['SEVEN,PATIENT G', 'SIX,PATIENT F'])
        time.sleep(10)
        reg.provider_change(ssn='888776666')
        time.sleep(10)
        reg.transfer_patient(ssn='888776666')
        reg.cancel_scheduled_admission(ssn='656451234')
        reg.cancel_scheduled_admission(ssn='656771234')
        reg.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def reg_test003(test_suite_details):
    '''Test for Wait list entries '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        reg = ADTActions(VistA1)
        reg.signon()
        reg.gotoADTmenu()
        reg.waiting_list_entry(ssn='323554567')
        reg.signon()
        reg.gotoADTmenu()
        reg.waiting_list_entry(ssn='123455678')
        reg.signon()
        reg.gotoADTmenu()
        reg.waiting_list_output(vlist=['TWENTYFOUR,PATIENT', 'TWENTYTHREE,PATIENT'])
        reg.signon()
        reg.gotoADTmenu()
        reg.delete_waiting_list_entry(ssn='323554567')
        reg.signon()
        reg.gotoADTmenu()
        reg.delete_waiting_list_entry(ssn='123455678')
        reg.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def reg_test004(test_suite_details):
    '''Test for Lodger checkin / checkout '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        reg = ADTActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        reg.signon()
        reg.checkin_lodger(ssn='323554567', bed='1-A')
        reg.checkin_lodger(ssn='123455678', bed='1-B')
        time.sleep(10)
        reg.lodger_checkout(ssn='323554567')
        reg.lodger_checkout(ssn='123455678')
        # DRG Calculation
        reg.wwgeneric(dlist=[[['Option:'], ['bed control menu']],
                              [['Option:'], ['DRG Calculation']],
                              [['Effective Date:'], ['t']],
                              [['Choose Patient from PATIENT file'], ['Yes']],
                              [['Select PATIENT NAME:'], ['123455678']],
                              [['Transfer to an acute care facility'], ['No']],
                              [['Discharged against medical advice'], ['No']],
                              [['Enter PRINCIPAL diagnosis:'], ['787.1']],
                              [['YES//'], ['YES']],
                              [['Enter SECONDARY diagnosis'], ['786.50']],
                              [['YES//'], ['YES']],
                              [['Enter SECONDARY diagnosis'], ['']],
                              [['Enter Operation/Procedure'], ['31.93']],
                              [['Yes//'], ['YES']],
                              [['Enter Operation/Procedure'], ['']],
                              [['Diagnosis Related Group: +[0-9]+', 'Average Length of Stay\(ALOS\): +[0-9.]+', 'Weight: +[0-9.]+', 'Low Day\(s\): +[0-9]+', 'High Days: +[0-9]+', '392- ESOPHAGITIS'], []],
                              [['Effective Date'], ['']],
                              [['Choose Patient from PATIENT file'], ['']],
                              [['Select PATIENT NAME:'], ['']],
                              [['Bed Control Menu'], ['']]])
        reg.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def reg_test005(test_suite_details):
    '''This is a basic ADT Menu Smoke Tests '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        reg = ADTActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        reg.signon()
        reg.adt_menu_smoke(ssn='323554567')
        reg.signoff()
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def reg_test006(test_suite_details):
    '''Discharge previously discharged patient (break test, REF-221 ticket) and then perform Detailed Inpatient Inquire (REF-268) '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        reg = ADTActions(VistA1)
        reg.signon()
        reg.gotoADTmenu()
        reg.discharge_patient(ssn='444678924', dtime='NOW')
        reg.det_inpatient_inquiry(ssn='444678924', item='1', vlist=['DIRECT', '2-B', 'ALEXANDER,ROBER', 'SMITH,MARY'])
        reg.signoff()
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def reg_test007(test_suite_details):
    '''Add a new doctor, wait 2 minutes, add another doctor, then attempt to add doctor during patient admitting using a prior date (REF-218) '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        reg = Actions(VistA1, user='SM1234', code='SM12345!!')
        reg.signon()
        reg.adduser(name='JONES,JOE', ssn='000000050', gender='M', initials='JJ', acode='fakejoe1', vcode1='1SWUSH1234!!')
        VistA1 = test_driver.connect_VistA(testname + '_01', result_dir, namespace)
        reg = Actions(VistA1)
        reg.sigsetup(acode='fakejoe1', vcode1='1SWUSH1234!!', vcode2='1SWUSH12345!!', sigcode='JOEJ123')
        VistA1 = test_driver.connect_VistA(testname + '_02', result_dir, namespace)
        reg = Actions(VistA1, user='SM1234', code='SM12345!!')
        reg.signon()
        reg.adduser(name='BURKE,BARBARA', ssn='000000051', gender='F', initials='BB', acode='fakebar1', vcode1='1OIG1234!!')
        VistA1 = test_driver.connect_VistA(testname + '_03', result_dir, namespace)
        reg = Actions(VistA1)
        reg.sigsetup(acode='fakebar1', vcode1='1OIG1234!!', vcode2='1OGI12345!!', sigcode='BARB123')
        reg.signoff()
        VistA1 = test_driver.connect_VistA(testname + '_04', result_dir, namespace)
        reg = ADTActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        reg.signon()
        reg.admit_a_patient(ssn='666551234', bed='2-B', time='t-1@01am', doctorlist=['BURKE', 'Alexander', 'JONES', 'Alexander'])
        reg.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def reg_logflow(test_suite_details):
    '''Use XTFCR to log flow to file.  Note a test, just creates flow diagrams. '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        reg = ADTActions(VistA1)
        reg.logflow(['DGPMV', 'DGSWITCH'])

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def setup_ward(test_suite_details):
    ''' Set up ward for ADT testing '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        reg = ADTActions(VistA1)
        reg.signon()
        reg.adt_setup()
        reg.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def startmon(test_suite_details):
    '''This starts the Coverage Monitor'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        VistA1.startCoverage(routines=['DGPMV', 'DGSWITCH', 'DGSCHAD', 'DGPMEX', 'DGWAIT', 'DGSILL'])

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        '''
        Close Vista
        '''
        VistA1.write('^\r^\r^\r')
        VistA1.write('h\r')
        test_driver.finally_handling(test_suite_details)
    test_driver.end_method_handling(test_suite_details)

def stopmon(test_suite_details):
    '''This stops the Coverage Monitor'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        path = (test_suite_details.result_dir + '/' + TestHelper.timeStamped('ADT_coverage.txt'))
        VistA1.stopCoverage(path, test_suite_details.coverage_type)

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        '''
        Close Vista
        '''
        VistA1.write('^\r^\r^\r')
        VistA1.write('h\r')
        test_driver.finally_handling(test_suite_details)
    test_driver.end_method_handling(test_suite_details)

def timeStamped(fname, fmt='%Y-%m-%d-%H-%M-%S_{fname}'):
    '''This method appends a date/time stamp to a filename'''
    return datetime.datetime.now().strftime(fmt).format(fname=fname)

def connect_VistA(testname, result_dir, namespace):
    ''' This method is used to establish the connection to VistA via ConnectToMUMPS'''
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

