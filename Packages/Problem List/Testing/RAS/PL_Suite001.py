'''
Created on Mar 9, 2012


@author: pbradley

'''
import sys
sys.path = ['./Functional/RAS/lib'] + ['./dataFiles'] + ['./Python/vista'] + sys.path
from PLActions import PLActions
from ORActions import ORActions
import datetime
import TestHelper
import logging

def pl_test001(resultlog, result_dir):
    ''' NIST Inpatient Test '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname, result_dir)
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
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test002(resultlog, result_dir):
    ''' Restore Removed Problems '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname, result_dir)
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
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test003(resultlog, result_dir):
    ''' Change Problem Data '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname, result_dir)
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
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test004(resultlog, result_dir):
    ''' Create Problem Selection List, add/modify/remove categories and problems '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname, result_dir)
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
        pl.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test005(resultlog, result_dir):
    ''' Create Problem Selection List, assign to user, and add problem '''
    '''Separate VistA Instances to allow concurrent logins in case of
    future use of tstart and trollback when these features are available'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname+'_01', result_dir)
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
        VistA2 = connect_VistA(testname+'_02', result_dir)
        pl2 = PLActions(VistA2, user='fakedoc1', code='1Doc!@#$')
        pl2.signon()
        pl2.versellist(ssn='345623902', clinic='',
                      vlist=['List002', 'cat011', 'Heartburn', 'chest pain',
                             'Leptospirosis', 'cat022', 'Sleep Disturbance',
                             'Drug withdrawal', 'drug dependence'])
        pl2.add(ssn='345623902', clinic='', probnum='1',
                   comment='this is a test', onsetdate='t',
                   status='Active', acutechronic='A', service='N',
                   evalue='Heartburn')
        pl2.verify(ssn='345623902', probnum='1', itemnum='1',
                      evalue='Heartburn')
        pl2.rem(ssn='345623902')
        pl1.sellistrm(listname='List002')
        pl1.sellistrm(listname='List002')
        pl1.catdl(listname='List002', catname='cat011')
        pl1.catdl(listname='List002', catname='cat022')
        pl1.sellistrfu(listname='List002', username='Alexander')
        pl1.sellistdl(listname='List002')
        pl2.signoff()
        pl1.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test006 (resultlog, result_dir):
    ''' Create Selection List from IB Encounter Form'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA=connect_VistA(testname, result_dir)
        pl = PLActions(VistA, user='fakenurse1', code='1Nur!@#$')
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
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test007 (resultlog, result_dir):
    ''' Add problems and View Patients by Problems (PL menu items 4 & 5)'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname, result_dir)
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
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test008 (resultlog, result_dir):
    ''' Add problem via data entry as clerk and change as doctor'''
    '''Multiple VistA instances to allow concurrent logins for when
    tstart and trollback become available and implemented'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname+'_01', result_dir)
        pl1 = PLActions(VistA1, user='fakeclerk1', code='1Cle!@#$')
        pl1.signon()
        pl1.dataentry(ssn='666551234', provider='Alexander', clinic='', problem='chest pain',
                      comment='test', onsetdate='t', status='Active', acutechronic='A',
                      service='N')
        pl1.signoff()
        VistA2 = connect_VistA(testname+'_02', result_dir)
        pl2 = PLActions(VistA2, user='fakedoc1', code='1Doc!@#$')
        pl2.signon()
        pl2.editsimple(ssn='666551234', probnum='1', itemnum='1', chgval='786.50')
        pl2.verplist(ssn='666551234', vlist=['Unspecified chest pain'])
        pl2.rem('666551234')
        pl2.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test009 (resultlog, result_dir):
    ''' Verify Problem List through Order Entry package'''
    '''Multiple VistA instances to allow concurrent logins for when
    tstart and trollback become available and implemented'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1 = connect_VistA(testname+'_01', result_dir)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='323678904', pfile='./Functional/dataFiles/NISTinpatientdata0.csv')
        pl.verplist(ssn='323678904', vlist=['Essential Hypertension',
                                            'Chronic airway obstruction',
                                            'Acute myocardial',
                                            'Congestive Heart Failure'])
        pl.signoff()
        VistA2 = connect_VistA(testname+'_02', result_dir)
        oentry = ORActions(VistA2)
        oentry.signon()
        oentry.verproblems(ssn='323678904', vlist=['Essential Hypertension',
                                            'Chronic airway obstruction',
                                            'Acute myocardial',
                                            'Congestive Heart Failure'])
        oentry.signoff()
        VistA3 = connect_VistA(testname+'_03', result_dir)
        pl = PLActions(VistA3, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        for i in range(4):
            pl.rem('323678904')
        pl.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test010(resultlog, result_dir):
    ''' Add problems to Problem List and then Remove them. '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname, result_dir)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='323554545', pfile='./Functional/dataFiles/probdata0.csv')
        pl.verplist(ssn='323554545', vlist=['drug abuse', 'Arterial embolism'])
        pl.rem(ssn='323554545')
        pl.rem(ssn='323554545')
        pl.checkempty(ssn='323554545')
        pl.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test011(resultlog, result_dir):
    ''' Add a problem, add comments, and then remove to/from Problem List. '''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname, result_dir)
        pl = PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv(ssn='656451234', pfile='./Functional/dataFiles/probdata0.csv')
        pl.verplist(ssn='656451234', vlist=['drug abuse', 'Arterial embolism'])
        pl.comcm(ssn='656451234', probnum='1', comment='this is XZY a test')
        pl.rem(ssn='656451234')
        pl.rem(ssn='656451234')
        pl.checkempty(ssn='656451234')
        pl.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test012(resultlog, result_dir):
    '''Problem List Menu Testing'''
    testname=sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname+'_01', result_dir)
        pl=PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.addcsv( ssn='656451234', pfile='./Functional/dataFiles/probdata0.csv')
        pl.detview(ssn='656451234', probnum='2', vlist1=['ACTIVE', 'ALEXANDER','444.21'], vlist2=['hurts'])
        pl.rem( ssn='656451234')
        pl.rem( ssn='656451234')
        pl.checkempty( ssn='656451234')
        pl.signoff()
        VistA2=connect_VistA(testname+'_02', result_dir)
        p2=PLActions(VistA2, user='fakeclerk1', code='1Cle!@#$')
        p2.signon()
        p2.dataentry(ssn='656451234', provider='Alexander', clinic='', problem='305.91', comment='Test', onsetdate='t', status='a', acutechronic='A', service='n')
        p2.signoff()
        VistA3=connect_VistA(testname+'_03', result_dir)
        p3=PLActions(VistA3, user='fakedoc1', code='1Doc!@#$')
        p3.signon()
        p3.verifyproblem(ssn='656451234', problem='305.91')
        p3.signoff()
        VistA4=connect_VistA(testname+'_04', result_dir)
        p4=PLActions(VistA4, user='fakedoc1', code='1Doc!@#$')
        p4.signon()
        p4.selectnewpatient(ssn1='656451234', name1='SIX,', ss2='323554545', name2='NINE,')
        p4.signoff()
        VistA5=connect_VistA(testname+'_05', result_dir)
        p5=PLActions(VistA5, user='fakedoc1', code='1Doc!@#$')
        p5.signon()
        p5.addcsv( ssn='656451234', pfile='./Functional/dataFiles/probdata0.csv')
        p5.printproblemlist(ssn='656451234', vlist=['PROBLEM LIST', '305.91'])
        p5.signoff()
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def pl_test013(resultlog, result_dir):
    #Tests the remainder of the selection list Build menu options
    testname=sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname, result_dir)
        pl=PLActions(VistA1, user='fakedoc1', code='1Doc!@#$')
        pl.signon()
        pl.createsellist( listname="List001", clinic='VISTA')
        pl.createsellist( listname="List002", clinic='VISTA')
        pl.createcat( listname='List001', catname='cat001')
        pl.createcat( listname='List001', catname='cat002')
        pl.catad( listname='List001', catname='cat001', icd='787.1')
        pl.catad( listname='List001', catname='cat001', icd='786.50')
        pl.catad( listname='List001', catname='cat001', icd='100.0')
        pl.catad( listname='List001', catname='cat002', icd='780.50')
        pl.catad( listname='List001', catname='cat002', icd='292.0')
        pl.catad( listname='List001', catname='cat002', icd='304.90')
        pl.sellistad(listname='List001', catname='cat001')
        pl.sellistad(listname='List001', catname='cat002')
        pl.resequencecat(listname='List001', catnames=['cat001','cat002'])
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
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    else:
        resultlog.write('Pass\n')

def startmon(resultlog, result_dir):
    '''Starts Coverage Monitor'''
    testname=sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        VistA1=connect_VistA(testname, result_dir)
        VistA1.startCoverage(routines=['GMPL*'])
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname+ ' EXCEPTION ERROR: Unexpected test result')
    finally:
        '''
        Close Vista
        '''
        VistA1.write('^\r^\r^\r')
        VistA1.write('h\r')

def stopmon (resultlog, result_dir):
    ''' STOP MONITOR'''
    testname = sys._getframe().f_code.co_name
    resultlog.write('\n' + testname + ', '
                    + str(datetime.datetime.today()) + ': ')
    logging.debug('\n' + testname + ', ' + str(datetime.datetime.today()) + ': ')
    try:
        # Connect to VistA
        VistA1=connect_VistA(testname, result_dir)
        VistA1.stopCoverage(path=(result_dir + '/' + 'ProblemList_coverage.txt'))
    except TestHelper.TestError, e:
        resultlog.write(e.value)
        logging.error(testname + ' EXCEPTION ERROR: Unexpected test result')
    finally:
        '''
        Close Vista
        '''
        VistA1.write('^\r^\r^\r')
        VistA1.write('h\r')

def connect_VistA(testname, result_dir):
    # Connect to VistA
    logging.debug('Connect_VistA')
    from OSEHRAHelper import ConnectToMUMPS,PROMPT
    VistA = ConnectToMUMPS(logfile=result_dir + '/' + testname + '.txt', instance='', namespace='')
    if VistA.type=='cache':
        try:
            VistA.ZN('VISTA')
        except IndexError,no_namechange:
            pass
    VistA.wait(PROMPT)
    return VistA
