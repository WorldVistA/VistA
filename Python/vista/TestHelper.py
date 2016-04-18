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

## @package TestHelper
## Functional Test Helpers

'''
Functional Test Helper Classes

Created on Mar 2, 2012
@author pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import sys
import csv
import logging
import argparse
import os
import errno
import datetime
import ConfigParser
import traceback

import RemoteConnection

LOGGING_LEVELS = {'critical': logging.CRITICAL,
                  'error': logging.ERROR,
                  'warning': logging.WARNING,
                  'info': logging.INFO,
                  'debug': logging.DEBUG}

class TestError(Exception):
    ''' The TestError class extends the Exception class and is used to handle unexpected test results '''
    def __init__(self, value):
        self.value = value
    def __str__(self):
        return repr(self.value)

class CSVFileReader(object):
    ''' The CSVFileReader class extends the object class.

    CSVFileReader provides the getfiledata() method to open a CSV file and return a table or specified row (record)
    '''

    def getfiledata (self, fname, fhkey, getrow=None):
        '''This method opens a CSV file with DictReader and returns a table or specified row'''
        infile = open(fname)
        csvreader = csv.DictReader(infile, delimiter='|')
        table = {}
        for rowdata in csvreader:
            key = rowdata.pop(fhkey)
            table[key] = rowdata
        if getrow is None:
            return table
        else:
            row = {getrow: table[getrow]}
            return row

class TestSuiteDriver(object):
    '''
    classdocs

    Created on Oct 11, 2012

    Reusable code to handle driver the tests located in /tests directory. This is to prevent
    the RAS Recorder from generating code which may later need to be revised.
    @author: jspivey
    '''

    def __init__(self, test_file):
        '''
        Constructor
        '''
        self.test_file = test_file

    def generate_test_suite_details(self):
        test_suite_name = os.path.basename(self.test_file).split('_test.')[0]

        usage = "usage: %prog [options] arg"
        parser = argparse.ArgumentParser()
        parser.add_argument('resultdir', help='Result Directory') #perhaps a default relative directory can be given, then tests can be ran without parms
        parser.add_argument('-l', '--logging-level', help='Logging level', default='info')
        #not needed, filename should just be a default convention
        #parser.add_argument('-f', '--logging-file', help='Logging file name')
        #these parms are configured on a test suite level, therefore they are not globally scoped for an entire test run
        #parser.add_argument('-i', '--instance', help='cache instance type', choices=["TRYCACHE", "GTM"], default='')
        parser.add_argument('-n', '--namespace', help='cache namespace', default='')
        parser.add_argument('-c', '--coverage-type', help='Human readable coverage on/off')
        parser.add_argument('-cs','--coverage-subset',help='Subset of Routines to calculate coverage over')
        args = parser.parse_args()

        logging_level = LOGGING_LEVELS.get(args.logging_level, logging.NOTSET)
        logging.basicConfig(level=logging_level,
                            filename=args.resultdir+'/loggerOut.txt',
                            format='%(asctime)s %(levelname)s: %(message)s',
                            datefmt='%Y-%m-%d %H:%M:%S')
        logging.info('RESULT DIR arg: ' + str(args.resultdir)) #note, this gets printed each time a test suite runs. counter-intuitive since it is the same cli arguement each time
        #logging.info('LOGGING FILE arg: ' + str(args.logging_file))
        logging.info('LOGGING LEVEL arg: ' + str(args.logging_level))
        #logging.info('INSTANCE arg: ' + str(args.instance))
        logging.info('NAMESPACE arg: ' + str(args.namespace))
        logging.info('COVERAGE TYPE arg: ' + str(args.coverage_type))
        logging.info('COVERAGE Subset arg: ' + str(args.coverage_subset.split(",")))

        package_name = self.test_file[self.test_file.rfind('Packages')+9:self.test_file.rfind('/Testing/RAS/'+test_suite_name)]

        #TODO: move config parsing setup out of here
        config = ConfigParser.RawConfigParser()
        read_files = config.read(os.path.join(os.path.dirname(self.test_file), test_suite_name + '.cfg'))
        if read_files.__len__() != 1:
            raise IOError
        if config.getboolean('RemoteDetails', 'RemoteConnect'):
            remote_server = config.get('RemoteDetails', 'ServerLocation')
            remote_port   = int(config.get('RemoteDetails', 'ServerPort'))
            if not remote_port:
                remote_port = 22

            #get ssh username/password from local user's config file
            #NB: TODO: VEN/SMH - package now comes up empty. So I edited the .ATF folder
            userConfig = read_suite_config_file()
            uid = userConfig.get(package_name+'-'+test_suite_name, 'SSHUsername')
            pwd = userConfig.get(package_name+'-'+test_suite_name, 'SSHPassword')

            if not uid:
                uid = config.get('RemoteDetails','SSHUsername')
                pwd = config.get('RemoteDetails','SSHPassword')

            default_namespace = config.getboolean('RemoteDetails', 'UseDefaultNamespace')
            instance = config.get('RemoteDetails', 'Instance')
            if not default_namespace:
                namespace = config.get('RemoteDetails', 'Namespace')
            else:
                namespace = ''

            logging.info('Using REMOTE SERVER from config: ' + str(remote_server))
            logging.info('Using REMOTE PORT from config: ' + str(remote_port))
            logging.info('Using INSTANCE from config: ' + str(instance))
            logging.info('Using NAMESPACE from config: ' + str(namespace))
            remote_conn_details = RemoteConnection.RemoteConnectionDetails(remote_server,
                remote_port,
                uid,
                pwd,
                default_namespace)
            username = ''
        else:
            remote_conn_details = None
            instance = os.getenv('CACHE_INSTANCE','notused')
            namespace = os.getenv('CACHE_NAMESPACE','')
            username = os.getenv('CACHE_USERNAME','')
            logging.info("Instance = %s, Namespace = %s" % (instance, namespace))

        if not os.path.isdir(args.resultdir):
            try:
                os.makedirs(args.resultdir)
            except OSError, e:
                if e.errno != errno.EEXIST:
                    raise
        #resfile = args.resultdir + '/' + test_suite_name + '.txt'
        resfilename = datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S_{fname}').format(fname=test_suite_name + '.txt')
        resfile = args.resultdir + '/' + resfilename
        if not os.path.isabs(args.resultdir):
            logging.error('EXCEPTION: Absolute Path Required for Result Directory')
            raise
        result_log = file(resfile, 'w')

        return test_suite_details(package_name, test_suite_name, result_log, args.resultdir, instance,
                           namespace, username, remote_conn_details, args.coverage_type, args.coverage_subset.split(","))

    def pre_test_suite_run(self, test_suite_details):
        logging.info('Start ATF Test Suite \'' + test_suite_details.test_suite_name + '\'')

    def post_test_suite_run(self, test_suite_details):
        logging.info('End ATF Test Suite \'' + test_suite_details.test_suite_name + '\'')

    def exception_handling(self, test_suite_details, e): #An exception occurred while running the tests in the suite
        logging.error('Exception in Test Suite \'' + test_suite_details.test_suite_name + '\'\n')
        logging.error('Exception Name: ' +str(e)+ '\n')
        logging.error(traceback.format_exc()+ '\n')

        #This will force ctest to recognize this test as a failure by printing output to std err
        sys.stderr.write('Exception ' +str(e)+ ' in test suite \'' + test_suite_details.test_suite_name + '\'\n')

    def try_else_handling(self, test_suite_details): #All tests in suite passed
        outstr = 'All tests in test suite \'' + test_suite_details.test_suite_name + '\'' + ' completed without interruption from a major exception.'
        logging.info(outstr)
        #test_suite_details.result_log.write(outstr + '\n')

    def finally_handling(self, test_suite_details):
        outstr = 'Test Suite \'' +test_suite_details.test_suite_name+'\' finished'
        test_suite_details.result_log.write('\n' + outstr + '\n')
        logging.info(outstr)

    def end_method_handling(self, test_suite_details):
        pass

class TestDriver(object):
    '''
    classdocs

    Created on Oct 11, 2012

    Reusable code to handle each test run. This is to prevent the ATF Recorder
    from generating code which may later need to be revised.
    @author: jspivey
    '''

    def __init__(self, testname):
        self.testname = testname

    def pre_test_run(self, test_suite_details):
        '''
        Ran before each test.
        '''
        test_suite_details.result_log.write('\n' + self.testname + ', ' + str(datetime.datetime.today()) + ': ')
        logging.debug('\n' + self.testname + ', ' + str(datetime.datetime.today()) + ': ')

    def post_test_run(self, test_suite_details):
        pass

    def exception_handling(self, test_suite_details, e): #test method throw an exception
        test_suite_details.result_log.write(e.value+ '\n')
        logging.error(self.testname + ': exception \'' +str(e)+ '\' in Test \'' +self.testname +'\'')

        #This will force ctest to recognize this test as a failure by printing output to std err
        sys.stderr.write('Exception in test \'' +self.testname+ '\' ' +str(e)+ ' in test suite \'' + test_suite_details.test_suite_name + '\'\n')

    def try_else_handling(self, test_suite_details): #test method passed
        test_suite_details.result_log.write(' Passed\n')

    def finally_handling(self, test_suite_details):
        pass

    def end_method_handling(self, test_suite_details):
        pass

    def connect_VistA(self, test_suite_details):
        '''
        Generic method to connect to VistA. Intended to be used by the ATF Recorder.
        '''
        if test_suite_details.remote_conn_details:
            location = test_suite_details.remote_conn_details.remote_address
        else:
            location = '127.0.0.1'
        from OSEHRAHelper import ConnectToMUMPS, PROMPT
        try:
            VistA = ConnectToMUMPS(logfile=test_suite_details.result_dir + '/' + self.testname + '.txt',
                                   instance=test_suite_details.instance, namespace=test_suite_details.namespace,
                                   location=location,
                                   remote_conn_details=test_suite_details.remote_conn_details)
        except ImportError as ex:
           print ex
           raise

        if test_suite_details.username != '':
            test_suite_details.password = os.getenv('CACHE_PASSWORD','')
            VistA.wait("Username")
            VistA.write(test_suite_details.username)
            VistA.wait("Password")
            VistA.write(test_suite_details.password)

        if VistA.type is not None and VistA.type =='cache' and test_suite_details.namespace != '':
            try:
                VistA.ZN(test_suite_details.namespace)
            except IndexError, no_namechange:
                pass
            VistA.wait(PROMPT)

#        if test_suite_details.remote_conn_details:
#            VistA.wait('ACCESS CODE:')
#            VistA.write(fetch_access_code(test_suite_details, self.testname))
#            VistA.wait('VERIFY CODE:')
#            VistA.write(fetch_verify_code(test_suite_details, self.testname))

        return VistA

class test_suite_details(object):
    '''
    A single parameter which is passed into each test. Allows for flexibility
    with parameters (adding and removing new ones without having to refactor
    existing tests).
    '''

    def __init__(self, package_name, test_suite_name, result_log, result_dir, instance,
                 namespace, username, remote_conn_details,coverage_type,coverage_subset):
        '''
        Constructor
        '''
        self.package_name = package_name
        self.test_suite_name = test_suite_name
        self.result_log = result_log
        self.result_dir = result_dir
        self.instance = instance
        self.namespace = namespace
        self.username = username
        self.remote_conn_details = remote_conn_details
        self.coverage_type = coverage_type
        self.coverage_subset= coverage_subset


def read_suite_config_file():
    #move to a module for parsing cfg values
    config = ConfigParser.RawConfigParser()
    from os.path import expanduser
    read_files = config.read(expanduser("~/.ATF/roles.cfg"))
    if read_files.__len__() != 1:
        raise IOError
    return config
    #move to a module for parsing cfg values

def fetch_access_code(test_suite_details, testname):
    config = read_suite_config_file()
    return config.get(test_suite_details.package_name+'-'+test_suite_details.test_suite_name, testname+'_aCode')

    '''
    from os.path import expanduser
    in_test_suite = False
    for line in  open(expanduser("~/.ATF/roles.cfg"), 'r'):
        line = line.strip()
        in_test_suite = line == test_suite_name or in_test_suite
        if line.startswith('aCode') and in_test_suite:
            return line[line.strip().rfind("="):].strip()
    '''

def fetch_verify_code(test_suite_details, testname):
    config = read_suite_config_file()
    return config.get(test_suite_details.package_name+'-'+test_suite_details.test_suite_name, testname+'_vCode')

def timeStamped(fname, fmt='%Y-%m-%d-%H-%M-%S_{fname}'):
    return datetime.datetime.now().strftime(fmt).format(fname=fname)
