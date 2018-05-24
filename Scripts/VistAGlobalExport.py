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
from LoggerManager import getTempLogFile

class VistAGlobalExport(object):
  def __init__(self):
    pass

  """ export all Globals using ZGO routine """
  def exportAllGlobals(self, vistATestClient, outputDir,serialExport, timeout=3600):
    assert os.path.exists(outputDir)
    connection = vistATestClient.getConnection()
    nativeDir = os.path.normpath(outputDir)
    vistATestClient.waitForPrompt()
    if serialExport:
      connection.send("S ZGODEBUG=1\r")
      vistATestClient.waitForPrompt()
    connection.send("D SAVEALL^ZGO(\"%s%s\")\r" % (nativeDir, os.sep))
    vistATestClient.waitForPrompt(timeout)
    connection.send('\r') # make sure the next one can expect prompt

DEFAULT_OUTPUT_LOG_FILE_NAME = "GlobalExportTest.log"
def main():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA Global Export',
                                   parents=[testClientParser])
  parser.add_argument('-o', '--outputDir', required=True,
                      help='output Dir to store global export file in zwr format')
  result = parser.parse_args();
  print (result)
  outputDir = result.outputDir
  assert os.path.exists(outputDir)
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  with testClient as vistAClient:
    logFilename = getTempLogFile(DEFAULT_OUTPUT_LOG_FILE_NAME)
    print "Log File is %s" % logFilename
    vistAClient.setLogFile(logFilename)
    vistAGlobalExport = VistAGlobalExport()
    vistAGlobalExport.exportAllGlobals(vistAClient, outputDir)

if __name__ == '__main__':
  main()
