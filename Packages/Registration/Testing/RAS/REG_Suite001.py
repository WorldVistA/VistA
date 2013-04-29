'''
Created on November 2012

Test for Registration package using ADT
@author: pbradley

'''
import sys
sys.path = ['./Functional/RAS/lib'] + ['./dataFiles'] + ['./Python/vista'] + sys.path
from ADTActions import ADTActions
import datetime
import time
import TestHelper
import logging

def reg_test001(resultlog, result_dir, namespace):
    ''' Admit 4 patients, verify, then discharge them '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1 = connect_VistA(testname, result_dir, namespace)
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
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def reg_test002(resultlog, result_dir, namespace):
    ''' Schedule, Unschedule, Transfer Patient '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1 = connect_VistA(testname, result_dir, namespace)
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
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def reg_test003(resultlog, result_dir, namespace):
    ''' Wait list testing '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1 = connect_VistA(testname, result_dir, namespace)
        reg = ADTActions(VistA1)
        reg.signon()
        reg.waiting_list_entry(ssn='323554567')
        reg.signon()
        reg.waiting_list_entry(ssn='123455678')
        reg.signon()
        reg.waiting_list_output(vlist=['TWENTYFOUR,PATIENT', 'TWENTYTHREE,PATIENT'])
        reg.signon()
        reg.delete_waiting_list_entry(ssn='323554567')
        reg.signon()
        reg.delete_waiting_list_entry(ssn='123455678')
        reg.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def reg_test004(resultlog, result_dir, namespace):
    ''' Lodger checkin / checkout testing '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1 = connect_VistA(testname, result_dir, namespace)
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
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def reg_test005(resultlog, result_dir, namespace):
    ''' ADT Menu Smoke Tests '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1 = connect_VistA(testname, result_dir, namespace)
        reg = ADTActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        reg.signon()
        reg.adt_menu_smoke(ssn='323554567')

        reg.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def reg_logflow(resultlog, result_dir, namespace):
    ''' Use XTFCR to log flow to file '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1 = connect_VistA(testname, result_dir, namespace)
        reg = ADTActions(VistA1)
        reg.logflow(['DGPMV', 'DGSWITCH'])
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')


def setup_ward(resultlog, result_dir, namespace):
    ''' Set up ward for ADT testing '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1 = connect_VistA(testname, result_dir, namespace)
        reg = ADTActions(VistA1)
        reg.signon()
        reg.adt_setup()
        reg.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
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
        VistA1.startCoverage(routines=['DGPMV', 'DGSWITCH', 'DGSCHAD', 'DGPMEX', 'DGWAIT', 'DGSILL'])
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
        path = (result_dir + '/' + timeStamped('ADT_coverage.txt'))
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
    # Connect to VistA
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
