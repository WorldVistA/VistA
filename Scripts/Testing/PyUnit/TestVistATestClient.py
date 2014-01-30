#---------------------------------------------------------------------------
# Copyright 2014 The Open Source Electronic Health Record Alliance
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
import os
import sys
import unittest

curDir = os.path.dirname(os.path.abspath(__file__))
scriptDir = os.path.normpath(os.path.join(curDir, "../../"))
if scriptDir not in sys.path:
  sys.path.append(scriptDir)

from VistATestClient import TestException, getTestClientConnArg
from VistATestClient import testExceptionSafe, testConnection

connArgs = None

class TestVistATestClient(unittest.TestCase):
  def __init__(self, methodName='runTest'):
    unittest.TestCase.__init__(self, methodName)

  def test_ExceptionSafe(self):
    self.assertRaises(TestException, testExceptionSafe, connArgs)

  def test_Connection(self):
    result = testConnection(connArgs)
    self.assertTrue(result)

if __name__ == '__main__':
  connArgs = getTestClientConnArg('VistA Test Client Tests')
  suite = unittest.TestLoader().loadTestsFromTestCase(TestVistATestClient)
  unittest.TextTestRunner(verbosity=2).run(suite)
