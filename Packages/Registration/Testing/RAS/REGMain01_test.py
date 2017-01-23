'''
Created on November, 2012
@author: pbradley
This is the main test script that calls the underlying REG functional tests
located in REGMain01_suite.
'''
import sys
sys.path = ['./RAS/lib'] + ['./dataFiles'] + ['../Python/vista'] + sys.path
import REGMain01_suite
import TestHelper

def main():
    test_suite_driver = TestHelper.TestSuiteDriver(__file__)
    test_suite_details = test_suite_driver.generate_test_suite_details()

    try:
        test_suite_driver.pre_test_suite_run(test_suite_details)

        # Begin Tests
        REGMain01_suite.startmon(test_suite_details)
        REGMain01_suite.reg_test001(test_suite_details)
        REGMain01_suite.reg_test002(test_suite_details)
        REGMain01_suite.reg_test003(test_suite_details)
        REGMain01_suite.reg_test004(test_suite_details)
        REGMain01_suite.reg_test005(test_suite_details)
        REGMain01_suite.reg_logflow(test_suite_details)
        REGMain01_suite.stopmon(test_suite_details)
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
