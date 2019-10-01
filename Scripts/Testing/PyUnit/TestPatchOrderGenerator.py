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
import os
import sys
import unittest

curDir = os.path.dirname(os.path.abspath(__file__))
scriptDir = os.path.normpath(os.path.join(curDir, "../../"))
if scriptDir not in sys.path:
  sys.path.append(scriptDir)

PACKAGE_DIR = os.path.normpath(os.path.join(scriptDir, "../Packages"))

TEST_PACKAGE_DIR = os.path.join(curDir, "Packages")
from PatchOrderGenerator import PatchOrderGenerator, topologicSort
from LoggerManager import logger, initConsoleLogging
import logging

class TestPatchOrderGenerator(unittest.TestCase):
  def __init__(self, methodName='runTest'):
    unittest.TestCase.__init__(self, methodName)
    self.handler = None

  def setUp(self):
    logger.setLevel(logging.ERROR)
    self.handler = initConsoleLogging(logging.ERROR)

  def tearDown(self):
    logger.removeHandler(self.handler)

  def test_generatePatchOrderTopologic(self):
    patchOrderGen = PatchOrderGenerator()
    patchOrder = patchOrderGen.generatePatchOrderTopologic(PACKAGE_DIR)
    self.assertTrue(patchOrder, "no valid patch order is generated")

  def test_generatePatchOrderTopologicSample(self):
    patchOrderGen = PatchOrderGenerator()
    patchOrder = patchOrderGen.generatePatchOrderTopologic(TEST_PACKAGE_DIR)
    self.verifySampleOrder(patchOrder)

  def verifySampleOrder(self, patchOrder):
    self.assertTrue(patchOrder, "no valid patch order is generated")
    expectedOrder = ['LR*5.2*382', 'HDI*1.0*7', 'LR*5.2*350',
                     'LA*5.2*74', 'LR*5.2*420'
                    ]
    installList = [x.installName for x in patchOrder]
    self.assertEqual(installList, expectedOrder)

  def test_topologicSort(self):
    depDict = {'2':  ['11'],
               '9':  ['11', '8'],
               '10': ['11', '3'],
               '11': ['7', '5'],
               '8':  ['7' , '3'],
               '12': [],
              }
    result = topologicSort(depDict)
    self.assertTrue(result, "no valid order is generated")
    self.assertTrue('12' in result, "orphan node is ignored")
    print result
    result = topologicSort(depDict, '9')
    self.assertTrue(result, "no valid order is generated")
    print result
    result = topologicSort(depDict, '10')
    self.assertTrue(result, "no valid order is generated")
    print result
    result = topologicSort(depDict, '2')
    self.assertTrue(result, "no valid order is generated")
    print result
    self.assertTrue(result, "no valid order is generated")
   # this will create a cycle among 5, 11, 10
    depDict.update({'5':  ['10']})
    self.assertRaises(Exception, topologicSort, depDict)
   # this will create a cycle among 2, 5, 8, 11
    depDict.update({'5':  ['8'],
                    '8':  ['7', '3', '2']})
    self.assertRaises(Exception, topologicSort, depDict)

if __name__ == '__main__':
  suite = unittest.TestLoader().loadTestsFromTestCase(TestPatchOrderGenerator)
  unittest.TextTestRunner(verbosity=2).run(suite)
