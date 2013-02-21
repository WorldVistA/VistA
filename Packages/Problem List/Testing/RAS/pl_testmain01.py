'''
Created on Mar 1, 2012
@author: pbradley
This is the main test script that calls the underlying PL functional tests
located in PL_Suite001.
'''
import sys
import logging
sys.path = ['./RAS/lib'] + ['./dataFiles'] + ['../Python/vista'] + sys.path
import PL_Suite001
import os, errno
import argparse

LOGGING_LEVELS = {'critical': logging.CRITICAL,
                  'error': logging.ERROR,
                  'warning': logging.WARNING,
                  'info': logging.INFO,
                  'debug': logging.DEBUG}

def main():
    usage = "usage: %prog [options] arg"
    parser = argparse.ArgumentParser()
    parser.add_argument('resultdir', help='Result Directory')
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
        resfile = args.resultdir + '/ProblemList_results.txt'
        if not os.path.isabs(args.resultdir):
            logging.error('EXCEPTION: Absolute Path Required for Result Directory')
            raise
        resultlog = file(resfile, 'w')
        PL_Suite001.startmon(resultlog, args.resultdir)
        PL_Suite001.pl_test001(resultlog, args.resultdir)
        PL_Suite001.pl_test002(resultlog, args.resultdir)
        PL_Suite001.pl_test003(resultlog, args.resultdir)
        PL_Suite001.pl_test010(resultlog, args.resultdir)
        PL_Suite001.pl_test011(resultlog, args.resultdir)
        PL_Suite001.pl_test004(resultlog, args.resultdir)
        PL_Suite001.pl_test005(resultlog, args.resultdir)
        PL_Suite001.pl_test006(resultlog, args.resultdir)
        PL_Suite001.pl_test007(resultlog, args.resultdir)
        PL_Suite001.pl_test008(resultlog, args.resultdir)
        PL_Suite001.pl_test009(resultlog, args.resultdir)
        PL_Suite001.pl_test012(resultlog, args.resultdir)
        PL_Suite001.pl_test013(resultlog, args.resultdir)
        PL_Suite001.stopmon(resultlog, args.resultdir)
    except Exception, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    finally:
        resultlog.write('finished')

if __name__ == '__main__':
  main()
