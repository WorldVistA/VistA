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

## @package sc_testmain01
## Scheduling Package Testing (Main)

'''
This is the main Scheduling script that calls the underlying
scheduling functional tests located in SC_Suite001.

This test method (main()) is called through ctest, but can be
launched direct via python with proper arguments.

The resultdir argument is location where test results will be placed.
The namespace argument specifies the VistA namespace to be tested.
The coveragetype argument specifies the type of coverage files generated.
The logging-level and logging-file arguments specify the logging levels
to be used during testing (CRITICAL, ERROR, WARNING, INFO, DEBUG).

The pass/fail results from each test will be logged in the
Scheduling_results.txt file which will be written to the resultdir.

Created on Jun 14, 2012
@author: bcaine,pbradley
@copyright PwC
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import logging
import sys
import os
sys.path = ['./RAS/lib'] + ['./dataFiles'] + ['../Python/vista'] + sys.path
import SC_Suite001
import argparse
import datetime

LOGGING_LEVELS = {'critical': logging.CRITICAL,
                  'error': logging.ERROR,
                  'warning': logging.WARNING,
                  'info': logging.INFO,
                  'debug': logging.DEBUG}

def timeStamped(fname, fmt='%Y-%m-%d-%H-%M-%S_{fname}'):
    ''' This method appends a date/time stamp to a filename'''
    return datetime.datetime.now().strftime(fmt).format(fname=fname)

def main():
    '''This is the main test method that calls the individual tests in the Scheduling test suite'''
    usage = "usage: %prog [options] arg"
    parser = argparse.ArgumentParser()
    parser.add_argument('resultdir', help='Result Directory')
    parser.add_argument('namespace', help='Namespace')
    parser.add_argument('coveragetype', help='Human readable coverage on/off')
    parser.add_argument('-l', '--logging-level', help='Logging level')
    parser.add_argument('-f', '--logging-file', help='Logging file name')
    args = parser.parse_args()
    logging_level = LOGGING_LEVELS.get(args.logging_level, logging.NOTSET)
    logging.basicConfig(level=logging_level,
                      filename=args.logging_file,
                      format='%(asctime)s %(levelname)s: %(message)s',
                      datefmt='%Y-%m-%d %H:%M:%S')

    if not os.path.isdir(args.resultdir):
      try:
         os.makedirs(args.resultdir)
      except OSError, e:
         if e.errno != errno.EEXIST:
             raise
    try:
        logging.debug('RESULTDIR: ' + args.resultdir)
        logging.debug('LOGGING:   ' + args.logging_level)
        resfile = args.resultdir + '/' + timeStamped('Scheduling_results.txt')
        if not os.path.isabs(args.resultdir):
            logging.error('EXCEPTION: Absolute Path Required for Result Directory')
            raise
        resultlog = file(resfile, 'w')
        SC_Suite001.startmon(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test001(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test002(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test003(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test004(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test005(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test006(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test007(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test008(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test009(resultlog, args.resultdir, args.namespace)
        SC_Suite001.sc_test010(resultlog, args.resultdir, args.namespace)
        SC_Suite001.stopmon(resultlog, args.resultdir, args.coveragetype, args.namespace)
        resultlog.write('finished')
    except Exception, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    finally:
        logging.debug('Test Finished')

if __name__ == '__main__':
    main()
