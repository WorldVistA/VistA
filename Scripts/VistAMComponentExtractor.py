#!/usr/bin/env python
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
import subprocess
import shutil
import glob
import argparse
# add the current to sys.path
SCRIPTS_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPTS_DIR)
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from VistARoutineExport import VistARoutineExport
from VistARoutineImport import VistARoutineImport
from VistAGlobalExport import VistAGlobalExport
from LoggerManager import logger, initConsoleLogging, initFileLogging
from VistATaskmanUtil import VistATaskmanUtil

""" List of routine names that are excluded from export process """
ROUTINE_EXTRACT_EXCLUDE_LIST = (
   "ZGO", "ZGI", "xobw.*", "%*",
   "CHK2LEV", "CHKOP", "GENDASH", "GENOUT",
   "GETPASS", "GTMHELP", "GTMHLPLD", "LOADOP",
   "LOADVX", "MSG", "PINENTRY", "TTTGEN",
   "TTTSCAN"
)

""" Extract routines/globals from a VistA instance and import
    to the git repository
"""
class VistADataExtractor:
  def __init__(self, vistARepoDir, outputResultDir,
               outputLogDir, routineOutDir=None):
    assert os.path.exists(vistARepoDir)
    assert os.path.exists(outputResultDir)
    assert os.path.exists(outputLogDir)
    self._vistARepoDir = vistARepoDir
    self._outputLogDir = outputLogDir
    self._outputResultDir = outputResultDir
    self._packagesDir = os.path.join(self._vistARepoDir, "Packages")
    assert os.path.exists(self._packagesDir)
    self._packagesCSV = os.path.normpath(os.path.join(SCRIPTS_DIR,
                                                 "../Packages.csv"))
    assert os.path.exists(self._packagesCSV)
    self._routineOutputFile = os.path.join(self._outputResultDir, "Routines.ro")
    self._globalOutputDir = os.path.join(self._outputResultDir, "Globals")
    if not os.path.exists(self._globalOutputDir):
      os.mkdir(self._globalOutputDir)
    if routineOutDir:
      assert os.path.exists(routineOutDir)
    self._routineOutDir = routineOutDir

  def extractData(self, vistATestClient):
    self.__setupLogging__(vistATestClient)
    self.__stopTaskman__(vistATestClient)
    self.__extractRoutines__(vistATestClient)
    self.__importZGORoutine__(vistATestClient)
    self.__exportAllGlobals__(vistATestClient)
    self.__chmodGlobalOutput__()
    self.__removePackagesTree__()
    self.__unpackRoutines__()
    self.__copyAllGlobals__()
    self.__splitGlobalFiles__()
    self.__populatePackageFiles__()
    self.__reportGitStatus__()
    self.__cleanup__()

  def __setupLogging__(self, vistATestClient):
    DEFAULT_LOGGING_FILENAME = "VistADataExtractor.log"
    DEFAULT_EXPECT_LOG_FILENAME = "VistAPExpect.log"
    vistATestClient.setLogFile(os.path.join(self._outputLogDir,
                               DEFAULT_EXPECT_LOG_FILENAME))
    initConsoleLogging()
    initFileLogging(os.path.join(self._outputLogDir,
                                 DEFAULT_LOGGING_FILENAME))

  def __stopTaskman__(self, vistATestClient):
    taskmanUtil = VistATaskmanUtil()
    taskmanUtil.shutdownAllTasks(vistATestClient)

  def __extractRoutines__(self, vistATestClient):
    # do not export ZGO, ZGI and xobw.* routines for now
    excludeList = ROUTINE_EXTRACT_EXCLUDE_LIST
    vistARoutineExport = VistARoutineExport()
    logger.info("Extracting All Routines from VistA-FOIA instance to %s" %
                self._routineOutputFile)
    vistARoutineExport.exportAllRoutines(vistATestClient,
                                         self._routineOutputFile,
                                         excludeList)

  def __importZGORoutine__(self, vistATestClient):
    logger.info("Import ZGO routine to VistA-FOIA")
    from PackRO import pack
    zgoOutFile = os.path.join(self._outputResultDir, "ZGO.ro")
    zgoRoutine = os.path.join(self._vistARepoDir, "Scripts", "ZGO.m")
    assert os.path.exists(zgoRoutine)
    pack([zgoRoutine], open(zgoOutFile, 'w'))
    vistARoutineImport = VistARoutineImport()
    vistARoutineImport.importRoutines(vistATestClient, zgoOutFile,
                                      self._routineOutDir)

  def __exportAllGlobals__(self, vistATestClient):
    """ remove all the zwr files first """
    logger.info("Remove all zwr files under %s" % self._globalOutputDir)
    for file in glob.glob(os.path.join(self._globalOutputDir, "*.zwr")):
      os.remove(file)
    logger.info("Exporting all globals from VistA-FOIA instance")
    vistAGlobalExport = VistAGlobalExport()
    vistAGlobalExport.exportAllGlobals(vistATestClient, self._globalOutputDir)

  def __removePackagesTree__(self):
    logger.info("Removing all files under %s" % self._packagesDir)
    for dirEntry in os.listdir(self._packagesDir):
      if dirEntry == ".gitattributes": # ignore the .gitattributes
        continue
      fullPath = os.path.join(self._packagesDir, dirEntry)
      if os.path.isdir(fullPath):
        shutil.rmtree(fullPath)
      else:
        os.remove(fullPath)

  def unpackRoutines(self, routinesOutputFile, outputDir):
    from UnpackRO import unpack
    assert os.path.exists(routinesOutputFile)
    assert os.path.exists(outputDir)
    absOutDir = os.path.abspath(outputDir)
    logfile = os.path.join(absOutDir, "unpackro.log")
    logger.info("Unpack routines from %s to %s" %
                (routinesOutputFile, outputDir))
    with open(routinesOutputFile, 'r') as routineFile: # open as txt
      with open(logfile, 'w') as logFile:
        unpack(routineFile, out=logFile, odir=outputDir)

  def __unpackRoutines__(self):
    self.unpackRoutines(self._routineOutputFile, self._packagesDir)

  def __copyAllGlobals__(self):
    logger.info("Copying all files from %s to %s" %
                (self._globalOutputDir, self._packagesDir))
    zwrFiles = glob.glob(os.path.join(self._globalOutputDir, "*.zwr"))
    for zwrFile in zwrFiles:
      logger.debug("Copying %s to %s" % (zwrFile, self._packagesDir))
      shutil.copy2(zwrFile, self._packagesDir)

  def __splitGlobalFiles__(self):
    from SplitZWR import splitZWR
    zwrFiles = glob.glob(os.path.join(self._packagesDir, "*.zwr"))
    maxSize = 64 << 20
    for f in zwrFiles:
      if os.stat(f).st_size > maxSize:
        splitZWR(f, maxSize)

  def __populatePackageFiles__(self):
    from PopulatePackages import populate
    curDir = os.getcwd()
    os.chdir(self._packagesDir)
    populate(open(self._packagesCSV, "rb"))
    os.chdir(curDir)

  def __chmodGlobalOutput__(self):
    allZWRFiles = glob.glob(os.path.join(self._globalOutputDir,
                                         "*.zwr"))
    for file in allZWRFiles:
      os.chmod(file, 0644)

  def __reportGitStatus__(self):
    curDir = os.getcwd()
    try:
      logger.info("Reporting git status on Uncategorized dir")
      cmd = ["git","status","--","Uncategorized/"]
      os.chdir(self._packagesDir)
      output = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
      logger.info(output)
      logger.info("Reporting git status on Packages dir")
      cmd = ["git","status","--","Packages/"]
      os.chdir(self._vistARepoDir)
      output = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
      logger.info(output)
    finally:
      os.chdir(curDir)

  def __cleanup__(self):
    pass

DEFAULT_OUTPUT_LOG_FILE_NAME = "GlobalExportTest.log"
import tempfile
def getTempLogFile():
    return os.path.join(tempfile.gettempdir(), DEFAULT_OUTPUT_LOG_FILE_NAME)
def main():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA Data Extractor',
                                   parents=[testClientParser])
  parser.add_argument('-o', '--outputDir', required=True,
                      help='output Dir to store global/routine export files')
  parser.add_argument('-r', '--vistARepo', required=True,
                    help='path to the top directory of VistA-FOIA repository')
  parser.add_argument('-l', '--logDir', required=True,
                      help='path to the top directory to store the log files')
  parser.add_argument('-ro', '--routineOutDir', default=None,
                help='path to the directory where GT. M stores routines')
  result = parser.parse_args();
  print (result)
  outputDir = result.outputDir
  assert os.path.exists(outputDir)
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  with testClient as vistAClient:
    vistADataExtractor = VistADataExtractor(result.vistARepo,
                                            outputDir,
                                            result.logDir,
                                            result.routineOutDir)
    vistADataExtractor.extractData(testClient)

def test1():
  vistADataExtractor = VistADataExtractor(".",".",".")
  vistADataExtractor.unpackRoutines(sys.argv[1], sys.argv[2])
  #vistADataExtractor.__chmodGlobalOutput__()
  #vistADataExtractor.__removePackagesTree__()
  #vistADataExtractor.__unpackRoutines__()
  #vistADataExtractor.__copyAllGlobals__()
  #vistADataExtractor.__splitGlobalFiles__()
  #vistADataExtractor.__populatePackageFiles__()

if __name__ == '__main__':
  #test1()
  main()
