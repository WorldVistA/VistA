#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
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

from __future__ import with_statement
import sys
import os
import argparse
from VistATestClient import VistATestClientFactory, createTestClientArgParser

class VistARoutineImport(object):
  def __init__(self):
    pass
  def __importRoutineCache__(self, connection, routineImportFile):
    nativeName = os.path.normpath(routineImportFile)
    connection.expect("Device: ")
    connection.send("%s\r" % nativeName)
    connection.expect("Parameters\? \"R\" =>")
    connection.send("\r")
    connection.expect("Override and use this File with %RI\? No =>")
    connection.send("YES\r")
    connection.expect("Please enter a number from the above list:")
    connection.send("\r")
    connection.expect("Routine Input Option:")
    connection.send("All\r")
    connection.expect("shall it replace the one on file\? No =>")
    connection.send("YES\r")
    connection.expect("Recompile\? Yes =>")
    connection.send("\r")
    connection.expect("Display Syntax Errors\? Yes =>")
    connection.send("\r")

  def __importRoutineGTM__(self, connection, routineImportFile,
                           routineOutputDir):
    nativeName = os.path.normpath(routineImportFile)
    connection.expect("Formfeed delimited <No>\? ")
    connection.send("No\r")
    connection.expect("Input device: <terminal>: ")
    connection.send("%s\r" % nativeName)
    connection.expect("Output directory : ")
    connection.send("%s\r" % routineOutputDir)

  def importRoutines(self, vistATestClient, routineImportFile,
                     routineOutputDir, timeout=1200):
    assert os.path.exists(routineImportFile)
    vistATestClient.waitForPrompt()
    connection = vistATestClient.getConnection()
    connection.send("D ^%RI\r")
    if vistATestClient.isCache():
      self.__importRoutineCache__(connection, routineImportFile)
    elif vistATestClient.isGTM():
      self.__importRoutineGTM__(connection, routineImportFile,
                                routineOutputDir)
    vistATestClient.waitForPrompt(timeout)
    connection.send('\r')

DEFAULT_OUTPUT_LOG_FILE_NAME = "RoutineImportTest.log"
import tempfile
def getTempLogFile():
    return os.path.join(tempfile.gettempdir(), DEFAULT_OUTPUT_LOG_FILE_NAME)
def main():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA Routine Import',
                                   parents=[testClientParser])
  parser.add_argument('-i', '--routineImportFile', required=True,
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
    logFilename = getTempLogFile()
    print "Log File is %s" % logFilename
    vistAClient.setLogFile(logFilename)
    vistARoutineImport = VistARoutineImport()
    vistARoutineImport.importRoutines(vistAClient, routineImportFile,
                                      routineOutputDir)

if __name__ == '__main__':
  main()
