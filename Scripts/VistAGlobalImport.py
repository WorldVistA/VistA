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
from builtins import object
import sys
import os
import argparse
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from LoggerManager import getTempLogFile

DEFAULT_GLOBAL_IMPORT_TIMEOUT = 60 # default time out is 60 seconds
class VistAGlobalImport(object):
  def __init__(self):
    pass

  def __setupDeviceGTM__(self, connection, nativeFile):
    connection.expect("Input device: ")
    connection.send("%s\r" % nativeFile)
    connection.expect("OK ")
    connection.send("\r")

  def __setupDeviceCache__(self, connection, nativeFile):
    connection.expect("Device:")
    connection.send("%s\r" % nativeFile)
    connection.expect("Parameters\?")
    connection.send("\r")
    connection.expect("Input option: ")
    connection.send("A\r")

  def importGlobal(self, vistATestClient, inputFile,
                   globalList=None, timeout=DEFAULT_GLOBAL_IMPORT_TIMEOUT):
    assert os.path.exists(inputFile)
    connection = vistATestClient.getConnection()
    nativeFile = os.path.normpath(os.path.abspath(inputFile))
    vistATestClient.waitForPrompt()
    connection.send("D ^%GI\r")
    if vistATestClient.isCache():
      self.__setupDeviceCache__(connection, nativeFile)
    elif vistATestClient.isGTM():
      self.__setupDeviceGTM__(connection, nativeFile)
    else:
      return False
    vistATestClient.waitForPrompt(timeout)
    connection.send('\r') # make sure the next one can expect prompt
    return True

DEFAULT_OUTPUT_LOG_FILE_NAME = "GlobalImportTest.log"

def testMain():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA Global Import Tool',
                                   parents=[testClientParser])
  parser.add_argument('inputGlobalFile',
                      help='input global file path to be imported to VistA')
  parser.add_argument('-t', '--timeout', default=DEFAULT_GLOBAL_IMPORT_TIMEOUT,
                      type=int,
                      help=('global import time out in second, default is %s' %
                             DEFAULT_GLOBAL_IMPORT_TIMEOUT) )
  result = parser.parse_args();
  print (result)
  inputFile = result.inputGlobalFile
  assert os.path.exists(inputFile)
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  with testClient as vistAClient:
    logFilename = getTempLogFile(DEFAULT_GLOBAL_IMPORT_TIMEOUT)
    print("Log File is %s" % logFilename)
    vistAClient.setLogFile(logFilename)
    vistAGlobalImport = VistAGlobalImport()
    vistAGlobalImport.importGlobal(vistAClient, inputFile, timeout=result.timeout)

if __name__ == '__main__':
  testMain()
