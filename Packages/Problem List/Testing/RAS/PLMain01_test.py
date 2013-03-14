'''
Created on Mar 1, 2012
@author: pbradley
This is the main test script that calls the underlying PL functional tests
located in PL_Suite001.
'''
import sys
sys.path = ['./RAS/lib'] + ['./dataFiles'] + ['../Python/vista'] + sys.path
import PLMain01_suite
import TestHelper

def main():
    test_suite_driver = TestHelper.TestSuiteDriver(__file__)
    test_suite_details = test_suite_driver.generate_test_suite_details()

    try:
        test_suite_driver.pre_test_suite_run(test_suite_details)

        # Begin Tests
        PLMain01_suite.startmon(test_suite_details)
        PLMain01_suite.pl_test001(test_suite_details)
        PLMain01_suite.pl_test002(test_suite_details)
        PLMain01_suite.pl_test003(test_suite_details)
        PLMain01_suite.pl_test010(test_suite_details)
        PLMain01_suite.pl_test011(test_suite_details)
        PLMain01_suite.pl_test004(test_suite_details)
        PLMain01_suite.pl_test005(test_suite_details)
        PLMain01_suite.pl_test006(test_suite_details)
        PLMain01_suite.pl_test007(test_suite_details)
        PLMain01_suite.pl_test008(test_suite_details)
        PLMain01_suite.pl_test009(test_suite_details)
        PLMain01_suite.pl_test012(test_suite_details)
        PLMain01_suite.pl_test013(test_suite_details)
        PLMain01_suite.pl_test014(test_suite_details)
        PLMain01_suite.pl_test015(test_suite_details)
        PLMain01_suite.stopmon(test_suite_details)
       # End Tests

        test_suite_driver.post_test_suite_run(test_suite_details)
    except Exception, e:
        test_suite_driver.exception_handling(test_suite_details, e)
    else:
        test_suite_driver.try_else_handling(test_suite_details)
    finally:
        test_suite_driver.finally_handling(test_suite_details)

    test_suite_driver.end_method_handling(test_suite_details)

if __name__ == '__main__':
  main()
