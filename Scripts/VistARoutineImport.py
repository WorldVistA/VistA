
#---------------------------------------------------------------------------
# Copyright 2012-2019 The Open Source Electronic Health Record Alliance
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
from __future__ import print_function
from __future__ import with_statement
from builtins import object
import sys
import os
import argparse
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from LoggerManager import getTempLogFile

class VistARoutineImport(object):
  def __init__(self):
    pass
  def __importRoutineCache__(self, connection, routineImportFile):
    connection.expect("Device: ")
    connection.send("%s\r" % routineImportFile)
    connection.expect("Parameters\? ")
    connection.send("\r")
    while True:
      index = connection.expect(["Override and use this File with %RI\? No =>",
                                 "Please enter a number from the above list:",
                                 "Routine Input Option:",
                                ])
      if index == 0:
        connection.send("YES\r")
      elif index == 1:
        connection.send("\r")
      else:
        connection.send("All\r")
        break
    connection.expect("shall it replace the one on file\? No =>")
    connection.send("YES\r")
    connection.expect("Recompile\? Yes =>")
    connection.send("\r")
    connection.expect("Display Syntax Errors\? Yes =>")
    connection.send("\r")

  def __importRoutineGTM__(self, connection, routineImportFile,
                           routineOutputDir):
    connection.expect("Formfeed delimited <No>\? ")
    connection.send("No\r")
    connection.expect("Input device: <terminal>: ")
    connection.send("%s\r" % routineImportFile)
    connection.expect("Output directory : ")
    connection.send("%s\r" % routineOutputDir)

  def importRoutines(self, vistATestClient, routineImportFile,
                     routineOutputDir, timeout=1200):
    assert os.path.exists(routineImportFile)
    absRtnImportFile = os.path.normpath(os.path.abspath(routineImportFile))
    vistATestClient.waitForPrompt()
    connection = vistATestClient.getConnection()
    connection.send("D ^%RI\r")
    if vistATestClient.isCache():
      self.__importRoutineCache__(connection, absRtnImportFile)
    elif vistATestClient.isGTM():
      absRtnOutDir = os.path.normpath(os.path.abspath(routineOutputDir))
      self.__importRoutineGTM__(connection, absRtnImportFile,
                                os.path.join(absRtnOutDir, ""))
    vistATestClient.waitForPrompt(timeout)
    connection.send('\r')

DEFAULT_OUTPUT_LOG_FILE_NAME = "RoutineImportTest.log"

def main():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA Routine Import',
                                   parents=[testClientParser])
  parser.add_argument('routineImportFile',
                      help='path to Routine Import File in .ro format')
  parser.add_argument('-o', '--routineOutputDir', default=None,
                      help='path to Routine output Dir, GTM only')
  result = parser.parse_args();
  print (result)
  routineImportFile = result.routineImportFile
  assert os.path.exists(routineImportFile)
  routineOutputDir = result.routineOutputDir
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  with testClient as vistAClient:
    logFilename = getTempLogFile(DEFAULT_OUTPUT_LOG_FILE_NAME)
    print("Log File is %s" % logFilename)
    vistAClient.setLogFile(logFilename)
    vistARoutineImport = VistARoutineImport()
    vistARoutineImport.importRoutines(vistAClient, routineImportFile,
                                      routineOutputDir)

if __name__ == '__main__':
  main()
