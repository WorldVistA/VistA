#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
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

import argparse
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../../../../Scripts/'))
import unittest
import re
from VistATestClient import VistATestClientFactory, createTestClientArgParser

class TestZTMGRSET(unittest.TestCase):

    def test_PATCHlessThan999(self):
        '''Test the PATCH^ZTMGRSET(patchnumber=998) entrypoint'''
        self.PATCH("998")

    def test_PATCHequalTo999(self):
        '''Test the PATCH^ZTMGRSET(patchnumber=999) entrypoint'''
        self.PATCH("999")

    def test_PATCHgreaterThan999(self):
        '''Test the PATCH^ZTMGRSET(patchnumber=1000) entrypoint'''
        self.PATCH("1000")

    def PATCH(self, patchNumber):
        with self.createTestClient() as testClient:
            expectedResult = self.expectedResult(patchNumber, testClient)
            connection = testClient.getConnection()
            testClient.waitForPrompt()
            connection.send("D PATCH^ZTMGRSET(" + patchNumber + ")\r")
            testClient.waitForPrompt()
            result = self.lineParser(connection.before, "^ALL DONE")
            if expectedResult:
                self.assertEqual(result, "ALL DONE", msg="ZTMGRSET Failed")
            else:
                self.assertEqual(result, None, msg="ZTMGRSET Failed")

    def test_RELOADlessThan999(self):
        '''Test the RELOAD^ZTMGRSET entrypoint'''
        self.RELOAD("998")

    def test_RELOADequalTo999(self):
        '''Test the RELOAD^ZTMGRSET entrypoint'''
        self.RELOAD("999")

    def test_RELOADgreaterThan999(self):
        '''Test the RELOAD^ZTMGRSET entrypoint'''
        self.RELOAD("1000")

    def RELOAD(self, patchNumber):
        with self.createTestClient() as testClient:
            expectedResult = self.expectedResult(patchNumber, testClient)
            connection = testClient.getConnection()
            testClient.waitForPrompt()
            connection.send("D RELOAD^ZTMGRSET\r")
            connection.expect("N//")
            connection.send("Y\r")
            connection.expect("//")
            connection.send("\r")
            connection.expect("load:")
            connection.send(patchNumber + "\r")
            testClient.waitForPrompt()
            result = self.lineParser(connection.before, "^ALL DONE")
            if expectedResult:
                self.assertEqual(result, "ALL DONE", msg="ZTMGRSET Failed")
            else:
                self.assertEqual(result, None, msg="ZTMGRSET Failed")

    #def test_DEFAULT(self):
        #'''Test ^ZTMGRSET called from the top'''

    def lineParser(self, stringToSearch, searchString):
        linesToSearch = stringToSearch.split("\r\n")
        result = None
        for line in linesToSearch:
            line = line.strip("\r\n ")
            if not re.search(searchString, line): continue
            result = line
            break
        return result

    def createTestClient(self):
        from __main__ import args
        return VistATestClientFactory.createVistATestClientWithArgs(args)

    def expectedResult(self, patchNumber, testClient):
        result = True # a flag to indicate whether to check expected result
        patchOutRange = (int(patchNumber) >= 1000)
        if patchOutRange:
            """ need to report test fail as OK if patch number is out of
                range
            """
            result = False
        return result

if __name__ == '__main__':
    testClientParser = createTestClientArgParser()
    parser = argparse.ArgumentParser(description='ZTMGRSET Unit Tests',
                                     parents=[testClientParser])
    args = parser.parse_args();
    suite = unittest.TestLoader().loadTestsFromTestCase(TestZTMGRSET)
    unittest.TextTestRunner(verbosity=2).run(suite)
