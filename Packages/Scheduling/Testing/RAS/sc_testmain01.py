'''
Created on Jun 14, 2012

@author: bcaine
This is the main Scheduling script that calls the underlying
scheduling functional tests located in SC_Suite001
'''
import logging
import sys
import os
sys.path = ['./RAS/lib'] + ['./dataFiles'] + ['../Python/vista'] + sys.path
import SC_Suite001
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
        resfile = args.resultdir + '/Scheduling_results.txt'
        if not os.path.isabs(args.resultdir):
            logging.error('EXCEPTION: Absolute Path Required for Result Directory')
            raise
        resultlog = file(resfile, 'w')
        SC_Suite001.startmon(resultlog, args.resultdir)
        SC_Suite001.sc_test001(resultlog, args.resultdir)
        SC_Suite001.sc_test002(resultlog, args.resultdir)
        SC_Suite001.sc_test003(resultlog, args.resultdir)
        SC_Suite001.sc_test004(resultlog, args.resultdir)
        SC_Suite001.sc_test005(resultlog, args.resultdir)
        SC_Suite001.sc_test006(resultlog, args.resultdir)
        SC_Suite001.stopmon(resultlog, args.resultdir)
        resultlog.write('finished')
    except Exception, e:
        resultlog.write('\nEXCEPTION ERROR:' + str(e))
        logging.error('*****exception*********' + str(e))
    finally:
        logging.debug('Test Finished')

if __name__ == '__main__':
    main()
