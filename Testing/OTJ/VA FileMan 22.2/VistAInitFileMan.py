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

from __future__ import with_statement
import sys
import os
import argparse
# setup system path
filedir = os.path.dirname(os.path.abspath(__file__))
test_python_dir = os.path.normpath(os.path.join(filedir, "../../Python/"))
scripts_python_dir = os.path.normpath(os.path.join(filedir, "../../../Scripts"))
sys.path.append(test_python_dir)
sys.path.append(scripts_python_dir)

from VistATestClient import VistATestClientFactory, createTestClientArgParser
from LoggerManager import logger, initConsoleLogging
from ExternalDownloader import obtainKIDSBuildFileBySha1
from ConvertToExternalData import readSha1SumFromSha1File
from ConvertToExternalData import isValidRoutineSha1Suffix

def getFileMan22_2RoutineFile(rFile):
  sha1sum = readSha1SumFromSha1File(rFile)
  logger.info("sha1sum is %s" % sha1sum)
  result, path = obtainKIDSBuildFileBySha1(rFile, sha1sum, filedir)
  if not result:
    logger.error("Could not obtain FileMan 22V2 file for %s" % rFile)
    raise Exception("Error getting FileMan 22V2 file for %s" % rFile)
  return path

def inputMumpsSystem(testClient):
  connection = testClient.getConnection()
  if testClient.isCache(): # this is the Cache
    connection.send("CACHE\r")
  elif testClient.isGTM(): # this is GT.M(UNIX)
    connection.send("GT.M(UNIX)\r")
  else:
    pass

def initFileMan(testClient, siteName, siteNumber):
  connection = testClient.getConnection()
  testClient.waitForPrompt()
  connection.send("D ^DINIT\r")
  connection.expect("Initialize VA FileMan now?")
  connection.send("YES\r")
  connection.expect("SITE NAME:")
  if siteName and len(siteName) > 0:
    connection.send(siteName+"\r")
  else:
    connection.send("\r") # just use the default
  connection.expect("SITE NUMBER")
  if siteNumber and int(siteNumber) != 0:
    connection.send(str(siteNumber)+"\r")
  else:
    connection.send("\r")
  selLst = [
             "Do you want to change the MUMPS OPERATING SYSTEM File?",
             "TYPE OF MUMPS SYSTEM YOU ARE USING:",
           ]
  while True:
    idx = connection.expect(selLst)
    if idx == 0:
      connection.send("YES\r") # we want to change MUMPS OPERATING SYSTEM File
      continue
    elif idx == len(selLst) - 1:
      inputMumpsSystem(testClient)
      break
  testClient.waitForPrompt()
  connection.send('\r')

def initFileMan22_2(testClient):
  testClient.waitForPrompt()
  conn = testClient.getConnection()
  conn.send('D ^DIINIT\r')
  conn.expect('ARE YOU SURE EVERYTHING\'S OK\? ')
  conn.send('YES\r')
  testClient.waitForPrompt()
  conn.send('D ^DMLAINIT\r')
  testClient.waitForPrompt()
  conn.send('\r')

def inhibitLogons(testClient, flag=True):
  from VistAMenuUtil import VistAMenuUtil
  from VistATaskmanUtil import getBoxVolPair
  volumeSet = getBoxVolPair(testClient).split(':')[0]
  menuUtil = VistAMenuUtil(duz=1)
  menuUtil.gotoFileManEditEnterEntryMenu(testClient)
  conn = testClient.getConnection()
  conn.send('14.5\r') # 14.5 is the VOLUME SET File
  conn.expect('EDIT WHICH FIELD: ')
  conn.send('1\r') # field Inhibit Logons?
  conn.expect('THEN EDIT FIELD: ')
  conn.send('\r')
  conn.expect('Select VOLUME SET: ')
  conn.send('%s\r' % volumeSet)
  conn.expect('INHIBIT LOGONS\?: ')
  if flag:
    conn.send('YES\r')
  else:
    conn.send('NO\r')
  conn.expect('Select VOLUME SET: ')
  conn.send('\r')
  menuUtil.exitFileManMenu(testClient)


def stopAllMumpsProcessGTM():
  pass

def deleteFileManRoutinesCache(testClient):
  conn = testClient.getConnection()
  testClient.waitForPrompt()
  conn.send('D ^%ZTRDEL\r')
  conn.expect('All Routines\? ')
  conn.send('No\r')
  for input in ("DI*", "'DIZ*", "DM*", "'DMZ*", "DD*", "'DDZ*"):
    conn.expect('Routine: ')
    conn.send(input+'\r')
  conn.expect('Routine: ')
  conn.send('\r')
  conn.expect('routines to DELETE, OK: ')
  conn.send('YES\r')
  testClient.waitForPrompt()
  conn.send('\r')

def deleteFileManRoutinesGTM():
  """ first get routine directory """
  from ParseGTMRoutines import extract_m_source_dirs
  var = os.getenv('gtmroutines')
  routineDirs = extract_m_source_dirs(var)
  if not routineDirs:
    return []
  import glob
  outDir = routineDirs[0:1]
  for routineDir in routineDirs:
    for pattern in ['DI*.m', 'DD*.m', 'DM*.m']:
      globPtn = os.path.join(routineDir, pattern)
      fmFiles = glob.glob(os.path.join(routineDir, pattern))
      if fmFiles:
        if routineDir not in outDir:
          outDir.append(routineDir)
        for fmFile in fmFiles:
          logger.debug("removing file %s" % fmFile)
          os.remove(fmFile)
  return outDir

def verifyRoutines(testClient):
  testClient.waitForPrompt()
  conn = testClient.getConnection()
  conn.send('D ^DINTEG\r')
  testClient.waitForPrompt()
  conn.send('\r')

def rewriteFileManRoutineCache(testClient):
  testClient.waitForPrompt()
  conn = testClient.getConnection()
  for filename in ['DIDT','DIDTC','DIRCR']:
    conn.send('ZL %s ZS %s\r' % (filename, filename.replace('DI','%')))
    testClient.waitForPrompt()
  conn.send('\r')

def rewriteFileManRoutineGTM(outDir):
  import shutil
  for filename in ['DIDT','DIDTC','DIRCR']:
    src = os.path.join(outDir, filename + ".m")
    dst = os.path.join(outDir, filename.replace('DI','_') + '.m')
    logger.debug("Copy %s to %s" % (src, dst))
    shutil.copyfile(src, dst)

def installFileMan22_2(testClient, inputROFile):
  """
    Script to initiate FileMan 22.2
  """
  if not os.path.exists(inputROFile):
    logger.error("File %s does not exist" % inputROFile)
    return
  rFile = inputROFile
  if isValidRoutineSha1Suffix(inputROFile):
    rFile = getFileMan22_2RoutineFile(inputROFile)
  from VistATaskmanUtil import VistATaskmanUtil
  outDir = None # gtm routine import out dir
  #allow logon to shutdown taskman via menu
  inhibitLogons(testClient, flag=False)
  # stop all taskman tasks
  taskManUtil = VistATaskmanUtil()
  logger.info("Stop Taskman...")
  taskManUtil.stopTaskman(testClient)
  logger.info("Inhibit logons...")
  inhibitLogons(testClient)
  # remove fileman 22.2 affected routines
  logger.info("Remove FileMan 22 routines")
  if testClient.isCache():
    deleteFileManRoutinesCache(testClient)
  else:
    outDir = deleteFileManRoutinesGTM()
    if not outDir:
      logger.info("Can not identify mumps routine directory")
      return
    outDir = outDir[0]
  # import routines into System
  from VistARoutineImport import VistARoutineImport
  vistARtnImport = VistARoutineImport()
  logger.info("Import FileMan 22.2 Routines from %s" % rFile)
  vistARtnImport.importRoutines(testClient, rFile, outDir)
  # verify integrity of the routines that just imported
  logger.info("Verify FileMan 22.2 Routines...")
  verifyRoutines(testClient)
  # rewrite fileman routines
  logger.info("Rewrite FileMan 22.2 Routines...")
  if testClient.isCache():
    rewriteFileManRoutineCache(testClient)
  else:
    rewriteFileManRoutineGTM(outDir)
  # initial fileman
  logger.info("Initial FileMan...")
  initFileMan(testClient, None, None)
  logger.info("Initial FileMan 22.2...")
  initFileMan22_2(testClient)
  logger.info("Enable logons...")
  inhibitLogons(testClient, flag=False)
  """ restart taskman """
  logger.info("Restart Taskman...")
  taskManUtil.startTaskman(testClient)

DEFAULT_OUTPUT_LOG_FILE_NAME = "VistAInitFileMan.log"
import tempfile
def getTempLogFile():
    return os.path.join(tempfile.gettempdir(), DEFAULT_OUTPUT_LOG_FILE_NAME)

def main():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA Initialize FileMan Utilities',
                                   parents=[testClientParser])
  parser.add_argument('roFile', help="routine import file in ro format")
  result = parser.parse_args();
  print (result)
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  with testClient as vistAClient:
    logFilename = getTempLogFile()
    print "Log File is %s" % logFilename
    initConsoleLogging()
    vistAClient.setLogFile(logFilename)
    installFileMan22_2(vistAClient, result.roFile)

if __name__ == '__main__':
  main()
