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

## @package SC_Suite001
## Scheduling Package Tests (Suite)

'''
These are the Scheduling package Suite001 tests, implemented as Python functions.

Each test has a unique name derived from the test method name.
Each test has a unique result log with a filename derived from the testname and a datestamp.
There is a parent resultlog that is also used for pass/fail logging.
In general each test establishes a connection to the target application (VistA),
signs on as a user, provider, or programmer and then performs a set of test functions.
When testing is complete the connection is closed and a pass/fail indicate is written
to the resultlog.

Created on Jun 14, 2012
@author: pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import sys
import os
sys.path = ['./Functional/RAS/lib'] + ['./dataFiles'] + ['./Python/vista'] + sys.path
from SCActions import SCActions
from ADTActions import ADTActions
from Actions import Actions
import TestHelper
import datetime

def sc_test001(test_suite_details):
    '''
    Test for basic appointment management options.
    Make an Appointment, Check in, Check Out
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)
    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, scheduling='Scheduling')
        time = SC.schtime()
        SC.signon()
        tclinic = SC.getclinic()
        SC.makeapp(patient='333224444', clinic=tclinic, datetime=time)
        time = SC.schtime(plushour=1)
        now = datetime.datetime.now()
        hour = now.hour + 1
        SC.signon()
        SC.checkin(clinic=tclinic, vlist=['Three', str(hour), 'CHECKED'])
        SC.signon()
        SC.checkout(clinic=tclinic, vlist1=['Three', str(hour), 'Checked In'],
                    vlist2=['RESULTING'], icd='305.91', icd10='F18.10')
        SC.signon()
        SC.makeapp_bypat(clinic=tclinic, patient='333224444', datetime=time, fresh='No', prevCO='yes')
        SC.signoff()
        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test002(test_suite_details):
    '''Test basic appointment management options.
    Make an Appointment (Scheduled and Unscheduled),
    record a No-Show, Cancel an appointment and change patients
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, scheduling='Scheduling')
        time = SC.schtime()
        SC.signon()
        tclinic = SC.getclinic()
        SC.makeapp(clinic=tclinic, patient='655447777', datetime=time)
        time = SC.schtime(plushour=1)
        SC.signon()
        SC.unschvisit(clinic=tclinic, patient='345678233', patientname='Twelve')
        SC.signon()
        SC.noshow(clinic=tclinic, appnum='3')
        SC.signon()
        SC.canapp(clinic=tclinic, mult='1')
        SC.signon()
        SC.chgpatient(clinic=tclinic, patient1='345678233', patient2='345238901',
                      patientname1='Twelve', patientname2='Ten')
        SC.signoff()
        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test003(test_suite_details):
    '''
    This tests clinic features such as change clinic, change date-range,
    expand the entry, add and edit, and Patient demographics
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, scheduling='Scheduling')
        SC.signon()
        tclinic = SC.getclinic()
        SC.chgclinic()
        SC.signon()
        SC.chgdaterange(clinic=tclinic)
        SC.signon()
        SC.teaminfo(clinic=tclinic)
        SC.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test004(test_suite_details):
    '''
    This tests clinic features such as expand the entry, add and edit, and Patient demographics
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, scheduling='Scheduling')
        time = SC.schtime(plushour=1)
        SC.signon()
        tclinic = SC.getclinic()
        SC.makeapp(clinic=tclinic, patient='345238901', datetime=time)
        SC.signon()
        SC.patdem(clinic=tclinic, name='Ten', mult='2')
        SC.signon()
        SC.expandentry(clinic=tclinic, vlist1=['TEN', 'SCHEDULED', '30'],
                       vlist2=['Event', 'Date', 'User', 'USER'],
                       vlist3=['NEXT AVAILABLE', 'NO', '0'], vlist4=['1933', 'MALE', 'UNANSWERED'],
                       vlist5=['Combat Veteran:', 'No check out information'], mult='3')
        SC.signon()
        SC.addedit(clinic=tclinic, name='354623902', icd='305.91', icd10='F18.10')
        SC.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test005(test_suite_details):
    '''
    This test checks a patient into a clinic, then discharges him, then deletes his checkout
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA)
        SC.signon()
        tclinic = SC.getclinic()
        SC.enroll(clinic=tclinic, patient='543236666')
        SC = SCActions(VistA, scheduling='Scheduling')
        time = SC.schtime(plushour=1)
        SC.signon()
        SC.makeapp(clinic=tclinic, patient='543236666', datetime=time)
        SC.signon()
        SC.discharge(clinic=tclinic, patient='543236666', appnum='3')
        SC.signon()
        SC.checkout(clinic=tclinic, vlist1=['One', 'No Action'],
                    vlist2=['RESULTING'], icd='305.91', icd10='F18.10', mult='4')
        SC = SCActions(VistA, user='fakedoc1', code='1Doc!@#$')
        SC.signon()
        SC.deletecheckout(clinic=tclinic, appnum='3')
        SC.signoff()
        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test006(test_suite_details):
    '''This test will exercise the wait list functionality'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, user='fakedoc1', code='1Doc!@#$')
        SC.signon()
        tclinic = SC.getclinic()
        SC.waitlistentry(clinic=tclinic, patient='323123456')
        SC.waitlistdisposition(clinic=tclinic, patient='323123456')
        SC.signoff()
        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test007(test_suite_details):
    '''
    This is a basic appointment, similar to sc_test001 but specifying patient name not clinic at first prompt
    This test will also use the space-bar to check recall feature works.
    Make an Appointment, Check in, Check Out
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, scheduling='Scheduling')
        time = SC.schtime()
        SC.signon()
        tclinic = SC.getclinic()
        SC.makeapp_bypat(clinic=tclinic, patient='656454321', datetime=time)
        SC.signon()
        SC.use_sbar(clinic=tclinic, patient='656454321', fresh='No')
        time = SC.schtime(plushour=1)
        now = datetime.datetime.now()
        hour = now.hour + 1
        SC.signon()
        SC.checkin(clinic=tclinic, vlist=['Five', str(hour), 'CHECKED'], mult='5')
        SC.signon()
        SC.checkout(clinic=tclinic, vlist1=['Five', str(hour), 'Checked In'],
                    vlist2=['RESULTING'], icd='305.91', icd10='F18.10', mult='5')
        SC.signon()
        SC.ver_actions(clinic=tclinic, patient='4444',
                       PRvlist=['THREE,PATIENT C', 'ALEXANDER,ROBERT'],
                       DXvlist=['RESULTING'],
                       CPvlist=['THREE,PATIENT C'])
        SC.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test008(test_suite_details):
    '''
    This test makes future appointments and verifies, and also checks case sensitivity (cLiNiCx, ClInIcX, etc.)
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, scheduling='Scheduling')
        time = SC.schtime()
        SC.signon()
        tclinic = SC.getclinic()
        SC.makeapp_bypat(clinic='cLiNiCx', patient='323678904', datetime='t+5@8PM')
        SC.signon()
        SC.verapp_bypat(patient='323678904', vlist=['THIRTEEN,PATIENT M', 'Clinicx', 'Future'])
        SC.signon()
        SC.makeapp_bypat(clinic='cLiNiCx', patient='222559876', datetime='t+6@8PM', CLfirst='Yes')
        SC.signon()
        SC.verapp_bypat(patient='222559876', vlist=['SIXTEEN,PATIENT P', 'Clinicx', 'Future'],
                        CInum=['1', '1'], COnum=['1', '2'])
        SC.signon()
        SC.verapp(clinic='cLiNiCx',
                  vlist=['Thirteen,Patient M', 'Future', 'Sixteen,Patient P', 'Future'],
                  CInum=['2', '1'], COnum=['2', '2'])
        SC.signon()
        SC.canapp(clinic='cLiNiCx', mult='2', future=1, rebook=1)
        SC.signoff()
        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test009(test_suite_details):
    '''
    This test makes appointments with variable length and makes appointment in distant future for EWL
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, scheduling='Scheduling')
        time = SC.schtime()
        SC.signon()
        tclinic = SC.getclinic()
        SC.makeapp_var(clinic='CLInicA', patient='323678904', datetime='t+7@7AM', fresh='No')
        SC.signon()
        SC.verapp_bypat(patient='323678904', vlist=['THIRTEEN,PATIENT M', 'Clinica', '7:00', 'Future'],)
        SC.signon()
        SC.makeapp_var(clinic='CLInicA', patient='323678904', datetime='t+122@6AM', fresh='No')
        SC.signon()
        SC.makeapp_var(clinic='CLInicA', patient='323678904', datetime='t+10@4AM', fresh='No', nextaval='No')
        SC.signon()
        SC.verapp_bypat(patient='323678904', vlist=['THIRTEEN,PATIENT M', 'Clinica', '4:00', 'Future'],
                        ALvlist=['THIRTEEN,PATIENT M', 'Clinicx', 'Clinica', 'Clinica'],
                        EPvlist=['THIRTEEN,PATIENT M', 'CLINICX', '8904', 'FUTURE', 'SCHEDULED', 'REGULAR'])
        SC.signoff()
        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test010(test_suite_details):
    '''
    This test makes appointments and saves demographics
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, scheduling='Scheduling')
        time = SC.schtime()
        # this signon() and fix_demographics() is a workaround for gtm bug
        if not (os.environ.get('gtm_zquit_anyway') == "1") and (VistA.type == 'GTM'):
            SC.signon()
            SC.fix_demographics(clinic='CLInicA', patient='323123456',
                                dgrph=[['COUNTRY', ''],
                                     ['STREET ADDRESS', ''],
                                     ['ZIP', '20005'],
                                     ['CITY', 'WASHINGTON'],
                                     ['PHONE NUMBER', ''],
                                     ['PHONE NUMBER', ''],
                                     ['BAD ADDRESS INDICATOR', ''],
                                     ['save the above changes', 'yes']])
        #
        SC.signon()
        tclinic = SC.getclinic()
        SC.set_demographics(clinic='CLInicA', patient='323123456',
                        dgrph=[['COUNTRY', ''],
                                 ['STREET ADDRESS', '123 SMITH STREET'],
                                 ['STREET ADDRESS', ''],
                                 ['ZIP', '20005'],
                                 ['CITY', 'WASHINGTON'],
                                 ['PHONE NUMBER', '2021112222'],
                                 ['PHONE NUMBER', ''],
                                 ['BAD ADDRESS INDICATOR', ''],
                                 ['save the above changes', 'yes'],
                                 ['Press ENTER to continue', ''],
                                 ['SEX', 'MALE'] ,
                                 ['Select ETHNICITY', 'N'],
                                 ['Select RACE', 'Black'],
                                 ['new RACE INFORMATION', 'Yes'],
                                 ['RACE', ''],
                                 ['MARITAL STATUS', 'MARRIED'],
                                 ['RELIGIOUS PREFERENCE', 'CELTICISM'],
                                 ['TEMPORARY ADDRESS ACTIVE', 'NO'],
                                 ['PHONE NUMBER', ''],
                                 ['PAGER NUMBER', '']], emailAddress = 'email@example.org')
        SC.signon()
        SC.get_demographics(patient='323123456',
                        vlist=[['COUNTRY: UNITED STATES', ''],
                                 ['123 SMITH STREET', ''],
                                 ['STREET ADDRESS', ''],
                                 ['20005', ''],
                                 ['CITY: WASHINGTON', ''],
                                 ['2021112222', ''],
                                 ['PHONE NUMBER', ''],
                                 ['BAD ADDRESS INDICATOR', ''],
                                 ['save the above changes', 'no'],
                                 ['Press ENTER to continue', ''],
                                 ['SEX: MALE', ''],
                                 ['Select ETHNICITY INFORMATION: NOT HISPANIC OR LATINO', ''],
                                 ['ETHNICITY: NOT HISPANIC OR LATINO', ''],
                                 ['Select RACE INFORMATION: BLACK OR AFRICAN AMERICAN', ''],
                                 ['RACE: BLACK OR AFRICAN AMERICAN', ''],
                                 ['Select RACE INFORMATION', ''],
                                 ['MARITAL STATUS', 'MARRIED'],
                                 ['RELIGIOUS PREFERENCE: CELTICISM', ''],
                                 ['ADDRESS ACTIVE', ''],
                                 ['PHONE NUMBER', ''],
                                 ['PAGER NUMBER', '']], emailAddress ='email@example.org')
        SC.signoff()
        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def sc_test011(test_suite_details):
    '''
    This makes appointments via Multiple Clinic Display and then verifies the appointments
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, user='fakedoc1', code='1Doc!@#$')
        SC.signon()
        SC.multiclinicdisplay(cliniclist=['Clinic1', 'ClinicX'], patient='656454321', timelist=['7', '5'], pending=None)
        SC.gotoApptMgmtMenu()
        SC.verapp_bypat(patient='656454321', vlist=['Clinic1', '7:00', 'Future', 'Clinicx', '17:00', 'Future'],)
        SC.signoff()
    except TestHelper.TestError, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    else:
        resultlog.write('Pass\n')

def sc_test012(test_suite_details):
    '''
    This test adds a new user with SDOB keys and creates & verifies appointments in timeslots outside a clinic's normal operating window
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        # create new user with SDOB keys
        VistA1 = test_driver.connect_VistA(test_suite_details)
        SC = Actions(VistA1, user='SM1234', code='SM1234!!!')
        SC.signon()
        SC.adduser(name='CRANE,JON', ssn='000000065', gender='M', initials='JC', acode='fakejon1', vcode1='1SWUSH1234!!')
        SC.signoff()
        VistA1 = test_driver.connect_VistA(testname + '_01', result_dir, namespace)
        SC = Actions(VistA1)
        SC.sigsetup(acode='fakejon1', vcode1='1SWUSH1234!!', vcode2='1SWUSH12345!!', sigcode='JONC123')
        SC.signoff()
        # Create appointment outside Clinic1's operating hours via fakedoc1
        VistA2 = test_driver.connect_VistA(testname + '_02', result_dir, namespace)
        SC = SCActions(VistA2, user='fakedoc1', code='1Doc!@#$')
        SC.signon()
        SC.gotoApptMgmtMenu()
        SC.makeapp(patient='333224444', clinic='Clinic1', datetime='t+5@9AM', fresh='No', badtimeresp='noslot')
        SC.signoff()
        # Create appointment outside Clinic1's operating hours via fakejon1 (SDOB key)
        VistA3 = test_driver.connect_VistA(testname + '_02', result_dir, namespace)
        SC = SCActions(VistA3, user='fakejon1', code='1SWUSH12345!!')
        SC.signon()
        SC.gotoApptMgmtMenu()
        SC.makeapp(patient='333224444', clinic='Clinic1', datetime='t+10@9AM', fresh='No', badtimeresp='overbook')
        SC.signoff()
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)
def sc_test013(test_suite_details):
    '''
    This test creates a Sharing Agreement subcategory and adds it to a select patient's eligibility
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    if sys.platform == 'win32':
        try:
            # Create Sharing Agreement sub-category
            VistA1 = test_driver.connect_VistA(test_suite_details)
            aa = Actions(VistA1)
            aa.signon()
            aa.addSAsubtype(subcat='subcat1')
            aa.signon()
            aa.addSAsubtype(subcat='SUBCAT2')
        # Add Sharing Agreement to Patient Eligibility
            VistA1 = test_driver.connect_VistA(testname + '_1', result_dir, namespace)
            adt = ADTActions(VistA1)
            adt.signon()
            adt.gotoADTmenu()
            adt.eligverific(patient='333224444', eligtype='SHARING AGREEMENT')
            adt.signoff()
        # Make Appointment using new sub-category
            VistA1 = test_driver.connect_VistA(testname + '_2', result_dir, namespace)
            SC = SCActions(VistA1, user='fakejon1', code='1SWUSH12345!!')
            SC.signon()
            SC.gotoApptMgmtMenu()
            SC.makeapp(patient='333224444', clinic='Clinic1', datetime='t+9@5AM', fresh='No', apptype='SHARING AGREEMENT', subcat=['subcat1', 'SUBCAT2'])
            SC.signoff()
        except TestHelper.TestError, e:
            test_driver.exception_handling(test_suite_details, e)
        finally:
            test_driver.finally_handling(test_suite_details)
    else:
        test_driver.finally_handling(test_suite_details)

def sc_test014(test_suite_details):
    '''
    This test verifies clinic setup parameters
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        SC = SCActions(VistA, scheduling='Scheduling')
        time = SC.schtime()
        SC.signon()
        SC.ma_clinicchk(patient='333224444', clinic='CLInicB', exp_apptype='EMPLOYEE', datetime='t+3@05PM',
                        cslots='[2]', cxrays='YES', fresh='No', cvar='Yes', elig='Yes')
        SC.signon()
        SC.ma_clinicchk(patient='333224444', clinic='CLInicC', exp_apptype='RESEARCH', datetime='t+4@04pm',
                        cslots='[4]', cxrays='', fresh='No', elig='Yes')
        SC.signon()
        SC.ma_clinicchk(patient='333224444', clinic='CLInicD', exp_apptype='REGULAR', datetime='t+5@03pm',
                        cslots='[4]', cxrays='', fresh='No', elig='Yes')
        SC.signoff()
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def startmon(test_suite_details):
    '''
    This method starts the Coverage Monitor
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    VistA1 = None
    if test_suite_details.coverage_subset == ['*']:
      test_suite_details.coverage_subset=['SC*', 'SD*']
    try:
        VistA = test_driver.connect_VistA(test_suite_details)
        VistA.startCoverage(test_suite_details.coverage_subset)

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        '''
        Close Vista
        '''
        VistA.write('^\r^\r^\r')
        VistA.write('h\r')
        test_driver.finally_handling(test_suite_details)
    test_driver.end_method_handling(test_suite_details)

def stopmon (test_suite_details):
    '''
    This method stops the Coverage Monitor
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    VistA1 = None
    try:
        # Connect to VistA
        VistA=test_driver.connect_VistA(test_suite_details)
        path = (test_suite_details.result_dir + '/' + TestHelper.timeStamped('Scheduling_coverage.txt'))
        VistA.stopCoverage(path, test_suite_details.coverage_type)

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        '''
        Close Vista
        '''
        VistA.write('^\r^\r^\r')
        VistA.write('h\r')
        test_driver.finally_handling(test_suite_details)
    test_driver.end_method_handling(test_suite_details)
