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

## @package PL_Suite001
## Problem List Package Test (Suite)

'''
These are the Problem List package Suite001 tests, implemented as Python functions.

Each test has a unique name derived from the test method name.
Each test has a unique result log with a filename derived from the testname and a datestamp.
There is a parent resultlog that is also used for pass/fail logging.
In general each test establishes a connection to the target application (VistA),
signs on as a user, provider, or programmer and then performs a set of test functions.
When testing is complete the connection is closed and a pass/fail indicate is written
to the resultlog.

Created on Mar 9, 2012
@author: pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import sys
sys.path = ['./Functional/RAS/lib'] + ['./dataFiles'] + ['./Python/vista'] + sys.path
from PLActions import PLActions
from ORActions import ORActions
from CPRSActions import CPRSActions
import TestHelper

def pl_test001(test_suite_details):
    '''
    This performs the NIST Inpatient Test; add problem to problem list, edit problem list,
    verify, and remove problem from problem list.

    The test scripts for testing of the Problem List adhere to the approved
    guidelines as described in the NIST Test Procedure for 170.302 (c) Maintain up-to-date
    problem list found at: http://healthcare.nist.gov/docs/170.302.c_problemlist_v1.1.pdf .
    '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='333224444', pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl.editinactivate(ssn='333224444', probnum='4', resdate='08/29/2010')
        pl.editinactivate(ssn='333224444', probnum='3', resdate='08/29/2010')
        pl.verplist(ssn='333224444', vlist=['Essential Hypertension',
                                            'Chronic airway obstruction'])
        pl.verify(ssn='333224444', probnum='1', itemnum='1',
                     evalue='Essential Hypertension')
        pl.verify(ssn='333224444', probnum='2', itemnum='1',
                     evalue='Chronic airway obstruction')
        pl.verify(ssn='333224444', probnum='1', itemnum='1',
                     evalue='Acute myocardial', view='IA')
        pl.verify(ssn='333224444', probnum='2', itemnum='1',
                     evalue='Congestive Heart Failure', view='IA')
        for i in range(4):
            pl.rem(ssn='333224444')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test002(test_suite_details):
    '''This test restores previously removed problems '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='888776666', pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl.editinactivate(ssn='888776666', probnum='4', resdate='08/29/2010')
        pl.editinactivate(ssn='888776666', probnum='3', resdate='08/29/2010')
        pl.verplist(ssn='888776666', vlist=['Essential Hypertension',
                                            'Chronic airway obstruction'])
        pl.verify(ssn='888776666', probnum='1', itemnum='1',
                     evalue='Essential Hypertension')
        pl.verify(ssn='888776666', probnum='2', itemnum='1',
                     evalue='Chronic airway obstruction')
        pl.verify(ssn='888776666', probnum='1', itemnum='1',
                     evalue='Acute myocardial', view='IA')
        pl.verify(ssn='888776666', probnum='2', itemnum='1',
                     evalue='Congestive Heart Failure', view='IA')
        for i in range(4):
            pl.rem(ssn='888776666')
        pl.checkempty(ssn='888776666')
        pl.replace(ssn='888776666', probnum='1')
        pl.verify(ssn='888776666', probnum='1', itemnum='1',
                     evalue='Essential Hypertension')
        pl.rem(ssn='888776666')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)


def pl_test003(test_suite_details):
    '''This test changes problem data '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='656771234',
                     pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl.editsimple(ssn='656771234', probnum='1', itemnum='1',
                        chgval='787.1')
        pl.editsimple(ssn='656771234', probnum='1', itemnum='2',
                        chgval='3/26/12')
        pl.editsimple(ssn='656771234', probnum='1', itemnum='4',
                        chgval='MANAGER')
        pl.editsimple(ssn='656771234', probnum='1', itemnum='5',
                        chgval='VISTA')
        pl.verify(ssn='656771234', probnum='1', itemnum='1',
                     evalue='Heartburn')
        pl.verify(ssn='656771234', probnum='1', itemnum='2',
                     evalue='3/26/12')
        pl.verify(ssn='656771234', probnum='1', itemnum='4',
                     evalue='MANAGER,SYSTEM')
        pl.verify(ssn='656771234', probnum='1', itemnum='5',
                     evalue='VISTA')
        for i in range(4):
            pl.rem(ssn='656771234')
        pl.checkempty(ssn='656771234')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test004(test_suite_details):
    ''' This test creates a Problem Selection List, and then adds/modifies/removes categories and problems '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1)
        pl.signon()
        pl.createsellist(listname="List001", clinic='VISTA')
        pl.createcat(listname='List001', catname='cat001')
        pl.createcat(listname='List001', catname='cat002')
        pl.catad(listname='List001', catname='cat001', icd='787.1')
        pl.catad(listname='List001', catname='cat001', icd='786.50')
        pl.catad(listname='List001', catname='cat001', icd='100.0')
        pl.catad(listname='List001', catname='cat002', icd='780.50')
        pl.catad(listname='List001', catname='cat002', icd='292.0')
        pl.catad(listname='List001', catname='cat002', icd='304.90')
        pl.sellistad(listname='List001', catname='cat001')
        pl.sellistad(listname='List001', catname='cat002')
        pl.versellist(ssn='656454321', clinic='VISTA',
                      vlist=['List001', 'cat001', 'Heartburn', 'chest pain',
                             'Leptospirosis', 'cat002', 'Sleep Disturbance',
                             'Drug withdrawal', 'drug dependence'])
        pl.add(ssn='656454321', clinic='VISTA', probnum='1',
                  comment='this is a test', onsetdate='t', status='Active',
                  acutechronic='A', service='N', evalue='Heartburn')
        pl.verify(ssn='656454321', probnum='1', itemnum='1',
                     evalue='Heartburn')
        pl.rem(ssn='656454321')
        pl.sellistrm(listname='List001')
        pl.sellistrm(listname='List001')
        pl.catdl(listname='List001', catname='cat001')
        pl.catdl(listname='List001', catname='cat002')
        pl.sellistrfu(listname='List001', username='Alexander')
        pl.sellistdl(listname='List001')
        pl.checkRMsellist(ssn='656454321', clinic='VISTA')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test005(test_suite_details):
    '''This test creates a Problem Selection List, assigns it to user, and adds problem. '''
    '''This test uses separate VistA Instances to allow concurrent connections in case of
    future use of tstart and trollback when these features are available.'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        test_driver.testname = testname + '_01'
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl1 = PLActions(VistA1)
        pl1.signon()
        pl1.createsellist(listname="List002", clinic='')
        pl1.sellistgal(listname="List002", username='Alexander')
        pl1.createcat(listname='List002', catname='cat011')
        pl1.createcat(listname='List002', catname='cat022')
        pl1.catad(listname='List002', catname='cat011', icd='787.1')
        pl1.catad(listname='List002', catname='cat011', icd='786.50')
        pl1.catad(listname='List002', catname='cat011', icd='100.0')
        pl1.catad(listname='List002', catname='cat022', icd='780.50')
        pl1.catad(listname='List002', catname='cat022', icd='292.0')
        pl1.catad(listname='List002', catname='cat022', icd='304.90')
        pl1.sellistad(listname='List002', catname='cat011')
        pl1.sellistad(listname='List002', catname='cat022')

        test_driver.testname = testname + '_02'
        VistA2 = test_driver.connect_VistA(test_suite_details)
        pl2 = PLActions(VistA2, user='fakedoc1', code='1Doc!@#$')
        pl2.signon()
        pl2.versellist(ssn='354623902', clinic='',
                      vlist=['List002', 'cat011', 'Heartburn', 'chest pain',
                             'Leptospirosis', 'cat022', 'Sleep Disturbance',
                             'Drug withdrawal', 'drug dependence'])
        pl2.add(ssn='354623902', clinic='', probnum='1',
                   comment='this is a test', onsetdate='t',
                   status='Active', acutechronic='A', service='N',
                   evalue='Heartburn')
        pl2.verify(ssn='354623902', probnum='1', itemnum='1',
                      evalue='Heartburn')
        pl2.rem(ssn='354623902')
        pl1.sellistrm(listname='List002')
        pl1.sellistrm(listname='List002')
        pl1.catdl(listname='List002', catname='cat011')
        pl1.catdl(listname='List002', catname='cat022')
        pl1.sellistrfu(listname='List002', username='Alexander')
        pl1.sellistdl(listname='List002')
        pl2.signoff()
        pl1.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test006 (test_suite_details):
    '''This test creates a Selection List from IB Encounter Form'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakenurse1', code='1Nur!@#$')
        pl.signon()
        pl.createibform('LAB', 'FORM1', 'Group1', ['428.0', '410.90', '401.9'])
        pl.sellistib('FORM1', 'List003', 'LAB')
        pl.versellist(ssn='345238901', clinic='LAB',
                   vlist=['List003', 'Group1', 'Congestive Heart Failure', 'Acute myocardial', 'Essential Hypertension'])
        pl.add(ssn='345238901', clinic='LAB', probnum='1',
                  comment='this is a test', onsetdate='t', status='Active',
                  acutechronic='A', service='N', evalue='Congestive')
        pl.verify(ssn='345238901', probnum='1', itemnum='1',
                     evalue='Congestive')
        pl.rem('345238901')
        pl.sellistrm(listname='List003')
        pl.catdl(listname='List003', catname='Group1')
        pl.sellistrfu(listname='List003', username='Alexander')
        pl.sellistdl(listname='List003')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test007 (test_suite_details):
    '''This test adds problems and then views patients by problem via Problem List menu items 4 & 5'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='655447777', pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl.addcsv(ssn='543236666', pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl.addcsv(ssn='345678233', pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl.verlistpats(vlist=['EIGHT,PATIENT', 'ONE,PATIENT', 'TWELVE,PATIENT'])
        pl.verpatsrch(prob='428.0', vlist=['EIGHT,PATIENT', 'ONE,PATIENT', 'TWELVE,PATIENT'])
        for i in range(4):
            pl.rem('655447777')
            pl.rem('543236666')
            pl.rem('345678233')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test008 (test_suite_details):
    '''This test adds a problem via data entry as clerk and changes the problem as doctor'''
    '''Multiple VistA instances to allow concurrent logins for when
    tstart and trollback become available and implemented'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        test_driver.testname = testname + '_01'
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl1 = PLActions(VistA1, user='fakeclerk1', code='1Cle!@#$')
        pl1.signon()
        pl1.dataentry(ssn='666551234', provider='Alexander', clinic='', problem='chest pain',
                      comment='test', onsetdate='t', status='Active', acutechronic='A',
                      service='N')
        pl1.signoff()

        test_driver.testname = testname + '_02'
        VistA2 = test_driver.connect_VistA(test_suite_details)
        pl2 = PLActions(VistA2, user='fakedoc1', code='1Doc!@#$')
        pl2.signon()
        pl2.editsimple(ssn='666551234', probnum='1', itemnum='1', chgval='786.50')
        pl2.verplist(ssn='666551234', vlist=['Unspecified chest pain'])
        pl2.rem('666551234')
        pl2.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test009 (test_suite_details):
    '''This test verifies problems entered into the Problem List through Order Entry package'''
    '''Multiple VistA instances to allow concurrent logins for when
    tstart and trollback become available and implemented'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        test_driver.testname = testname + '_01'
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='323678904', pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl.verplist(ssn='323678904', vlist=['Essential Hypertension',
                                            'Chronic airway obstruction',
                                            'Acute myocardial',
                                            'Congestive Heart Failure'])
        pl.signoff()

        test_driver.testname = testname + '_02'
        VistA2 = test_driver.connect_VistA(test_suite_details)
        oentry = ORActions(VistA2)
        oentry.signon()
        oentry.verproblems(ssn='323678904', vlist=['Essential Hypertension',
                                            'Chronic airway obstruction',
                                            'Acute myocardial',
                                            'Congestive Heart Failure'])
        oentry.signoff()
        test_driver.testname = testname + '_03'
        VistA3 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA3, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        for i in range(4):
            pl.rem('323678904')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test010(test_suite_details):
    '''This tests adds problems to the Problem List and then removes them. '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='323123456', pfile='./Functional/dataFiles/probdata0.csv')
        pl.verplist(ssn='323123456', vlist=['drug abuse', 'Arterial embolism'])
        pl.rem(ssn='323123456')
        pl.rem(ssn='323123456')
        pl.checkempty(ssn='323123456')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test011(test_suite_details):
    '''This test adds a problem, adds comments, and then removes them from the Problem List. '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='656451234', pfile='./Functional/dataFiles/probdata0.csv')
        pl.verplist(ssn='656451234', vlist=['drug abuse', 'Arterial embolism'])
        pl.comcm(ssn='656451234', probnum='1', comment='this is XZY a test')
        pl.rem(ssn='656451234')
        pl.rem(ssn='656451234')
        pl.checkempty(ssn='656451234')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)
        
def pl_test012(test_suite_details):
    '''This test performs Problem List Menu Testing (pseudo smoke test)'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        test_driver.testname = testname + '_01'
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='656451234', pfile='./Functional/dataFiles/probdata0.csv')
        pl.detview(ssn='656451234', probnum='2', vlist1=['ACTIVE', 'ALEXANDER', '444.21'], vlist2=['hurts'])
        pl.rem(ssn='656451234')
        pl.rem(ssn='656451234')
        pl.checkempty(ssn='656451234')
        pl.signoff()

        test_driver.testname = testname + '_02'
        VistA2 = test_driver.connect_VistA(test_suite_details)
        p2 = PLActions(VistA2, user='fakeclerk1', code='1Cle!@#$')
        p2.signon()
        p2.dataentry(ssn='656451234', provider='Alexander', clinic='', problem='305.91',
                     comment='Test', onsetdate='t', status='a', acutechronic='A', service='n')
        p2.signoff()

        test_driver.testname = testname + '_03'
        VistA3 = test_driver.connect_VistA(test_suite_details)
        p3 = PLActions(VistA3, user='fakedoc1', code='1Doc!@#$')
        p3.signon()
        p3.verifyproblem(ssn='656451234', problem='305.91')
        p3.add(ssn='656451234', clinic='Clinic1', comment='this is a test',
               onsetdate='t', status='Active', acutechronic='A', service='N',
               icd='786.2', verchknum='2')
        p3.signoff()

        test_driver.testname = testname + '_04'
        VistA4 = test_driver.connect_VistA(test_suite_details)
        p4 = PLActions(VistA4, user='fakedoc1', code='1Doc!@#$')
        p4.signon()
        p4.selectnewpatient(ssn1='656451234', name1='SIX,', ss2='323123456', name2='NINE,')
        p4.signoff()

        test_driver.testname = testname + '_05'
        VistA5 = test_driver.connect_VistA(test_suite_details)
        p5 = PLActions(VistA5, user='fakedoc1', code='1Doc!@#$')
        p5.signon()
        p5.addcsv(ssn='656451234', pfile='./Functional/dataFiles/probdata0.csv')
        p5.printproblemlist(ssn='656451234', vlist=['PROBLEM LIST', '305.91'])
        p5.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test013(test_suite_details):
    '''This tests the remaining selection list Build menu options not already tested elsewhere'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.createsellist(listname="List001", clinic='VISTA')
        pl.createsellist(listname="List002", clinic='VISTA')
        pl.createcat(listname='List001', catname='cat001')
        pl.createcat(listname='List001', catname='cat002')
        pl.catad(listname='List001', catname='cat001', icd='787.1')
        pl.catad(listname='List001', catname='cat001', icd='786.50')
        pl.catad(listname='List001', catname='cat001', icd='100.0')
        pl.catad(listname='List001', catname='cat002', icd='780.50')
        pl.catad(listname='List001', catname='cat002', icd='292.0')
        pl.catad(listname='List001', catname='cat002', icd='304.90')
        pl.sellistad(listname='List001', catname='cat001')
        pl.sellistad(listname='List001', catname='cat002')
        pl.resequencecat(listname='List001', catnames=['cat001', 'cat002'])
        pl.categorydisp(listname='List001', catname='cat001')
        pl.changesellist(list1='List001', list2='List002')
        pl.sellistrm(listname='List001')
        pl.sellistrm(listname='List001')
        pl.catdl(listname='List001', catname='cat001')
        pl.catdl(listname='List001', catname='cat002')
        pl.sellistrfu(listname='List001', username='Alexander')
        pl.sellistdl(listname='List001')
        pl.sellistdl(listname='List002')
        pl.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test014(test_suite_details):
    '''This tests the Problem List via CPRS MENU '''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        test_driver.testname = testname + '_01'
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.rem_all(ssn='656451234')
        pl.addcsv(ssn='656451234', pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl.verplist(ssn='656451234', vlist=['Essential Hypertension',
                                    'Chronic airway obstruction',
                                    'Acute myocardial',
                                    'Congestive Heart Failure'])
        pl.signoff()

        test_driver.testname = testname + '_02'
        VistA2 = test_driver.connect_VistA(test_suite_details)
        cp = CPRSActions(VistA2, user='fakedoc1', code='1Doc!@#$')
        cp.signon()
        cp.cprs_cc_addcomment(ssn='656451234', plnum='2', comment='this is a test')
        cp.cprs_cc_edit(ssn='656451234', plnum='2', loc='VISTA', edititem='4', editvalue='SMITH')
        cp.cprs_cc_verify(ssn='656451234', plnum='2', vtext='Chronic airway obstruction')
        cp.cprs_cc_detdisplay(ssn='656451234', plnum='2', vlist=['Chronic airway obstruction', 'SMITH,MARY'])
        cp.cprs_cc_inactivate(ssn='656451234', plnum='1')
        cp.cprs_cc_remove(ssn='656451234', plnum='4')
        cp.cprs_cc_remove(ssn='656451234', plnum='3')
        cp.cprs_cc_remove(ssn='656451234', plnum='2')
        cp.cprs_cc_remove(ssn='656451234', plnum='1')
        cp.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test015(test_suite_details):
    '''This test verifies that lock function works correctly -- that is that two
    providers/users can not edit the same record simultaneously.'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        test_driver.testname = testname + '_01'
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl1 = PLActions(VistA1, user='fakenurse1', code='1Nur!@#$')
        pl1.signon()
        pl1.rem_all(ssn='656451234')
        pl1.addcsv(ssn='656451234', pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl1.verplist(ssn='656451234', vlist=['Essential Hypertension',
                                    'Chronic airway obstruction',
                                    'Acute myocardial',
                                    'Congestive Heart Failure'])
        pl1.editpart1(ssn='656451234', probnum='1', itemnum='1', chgval='786.50')
        #

        test_driver.testname = testname + '_02'
        VistA2 = test_driver.connect_VistA(test_suite_details)
        pl2 = PLActions(VistA2, user='fakedoc1', code='1Doc!@#$')
        pl2.signon()
        pl2.badeditpart1(ssn='656451234', probnum='1', itemnum='1', chgval='786.50')
        pl2.signoff()
        pl1.editpart2(ssn='656451234', probnum='1', itemnum='1', chgval='786.50')
        pl1.rem_all(ssn='656451234')
        pl1.signoff()

        test_driver.post_test_run(test_suite_details)
    except TestHelper.TestError, e:
        test_driver.exception_handling(test_suite_details, e)
    else:
        test_driver.try_else_handling(test_suite_details)
    finally:
        test_driver.finally_handling(test_suite_details)

def pl_test016(resultlog, result_dir, namespace):
    '''This tests the PL Site Parameters menu'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        # check verify pl setting
        pl.editPLsite(ver='no', prompt='no', uselex='yes', order='CHRONO', screendups='yes')
        pl.checkVerplsetting(ssn='656451234')
        # check lexicon pl setting and prompt setting
        pl.editPLsite(ver='yes', prompt='no', uselex='no', order='CHRONO', screendups='yes')
        pl.addspec(ssn='656451234', clinic='Clinic1', comment='this is a test',
               onsetdate='t-1', status='Active', acutechronic='A', service='N',
               icd='785.2', prompt='no', uselex='no', screendups='yes', isdup='no')
        # check chronology pl setting
        pl.addspec(ssn='656451234', clinic='Clinic1', comment='this is a test',
               onsetdate='t', status='Active', acutechronic='A', service='N',
               icd='786.2', prompt='no', uselex='no', screendups='yes', isdup='no')
        pl.verplist(ssn='656451234', vlist=['785.2', '786.2'])
        pl.editPLsite(ver='yes', prompt='yes', uselex='yes', order='REVERSE', screendups='yes')
        pl.addspec(ssn='656451234', clinic='Clinic1', comment='this is a test',
               onsetdate='t', status='Active', acutechronic='A', service='N',
               icd='787.1', prompt='yes', uselex='yes', screendups='yes', isdup='no',
               vlist=['Heartburn', '785.2', '786.2'])
        # check that re-adding a problem is detected properly
        pl.editPLsite(ver='yes', prompt='yes', uselex='yes', order='REVERSE', screendups='yes')
        pl.addspec(ssn='656451234', clinic='Clinic1', comment='this is a test',
                   onsetdate='t', status='Active', acutechronic='A', service='N',
                   icd='787.1', prompt='yes', uselex='yes', screendups='yes', isdup='yes', prob='Heartburn')
        pl.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test017(resultlog, result_dir, namespace):
    '''This test creates Problem Selection List, but does not delete the lists upon completion
    such that global files can be compared post-testing.'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1 = test_driver.connect_VistA(test_suite_details)
        pl = PLActions(VistA1)
        pl.signon()
        pl.createsellist(listname="List001", clinic='VISTA')
        pl.createcat(listname='List001', catname='cat001')
        pl.createcat(listname='List001', catname='cat002')
        pl.createcat(listname='List001', catname='cat003')
        pl.catad(listname='List001', catname='cat001', icd='785.2', spec='General', dtext='', seqnum='5')
        pl.catad(listname='List001', catname='cat001', icd='786.50', spec='General', dtext='', seqnum='1')
        pl.catad(listname='List001', catname='cat001', icd='786.2', spec='General', dtext='PAINFUL cough', seqnum='2')
        pl.catad(listname='List001', catname='cat001', icd='786.05', spec='General', dtext='Trouble Breathing', seqnum='7')
        pl.catad(listname='List001', catname='cat002', icd='829.0', spec='N', dtext='', seqnum='19')
        pl.catad(listname='List001', catname='cat002', icd='807.00', spec='N', dtext='', seqnum='18')
        pl.catad(listname='List001', catname='cat002', icd='806.12', spec='N', dtext='', seqnum='17')
        pl.catad(listname='List001', catname='cat002', icd='829.1', spec='N', dtext='', seqnum='16')
        pl.catad(listname='List001', catname='cat002', icd='802.8', spec='N', dtext='', seqnum='15')
        pl.catad(listname='List001', catname='cat003', icd='780.50', spec='I', dtext='', seqnum='3')
        pl.catad(listname='List001', catname='cat003', icd='292.0', spec='I', dtext='DRUG withdrawal', seqnum='1')
        pl.catad(listname='List001', catname='cat003', icd='304.90', spec='I', dtext='', seqnum='2')
        pl.sellistad(listname='List001', catname='cat001', hdrname='FATCAT', seqnum='7')
        pl.sellistad(listname='List001', catname='cat002', hdrname='SKINNYcat', seqnum='1')
        pl.sellistad(listname='List001', catname='cat003', hdrname='blackCAT', seqnum='5')
        pl.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def startmon(test_suite_details):
    '''This starts the Coverage Monitor'''
    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        VistA1=test_driver.connect_VistA(test_suite_details)
        VistA1.startCoverage(routines=['GMPL*'])

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

def stopmon (test_suite_details):
    '''This stops the Coverage Monitor'''

    testname = sys._getframe().f_code.co_name
    test_driver = TestHelper.TestDriver(testname)

    test_driver.pre_test_run(test_suite_details)
    try:
        # Connect to VistA
        VistA1=test_driver.connect_VistA(test_suite_details)
        path = (test_suite_details.result_dir + '/' + TestHelper.timeStamped('ProblemList_coverage.txt'))
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