#---------------------------------------------------------------------------
# Copyright 2013-2019 The Open Source Electronic Health Record Alliance
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
from __future__ import print_function
import codecs
import os
import sys
import subprocess
import re
import argparse
from LoggerManager import logger, initConsoleLogging
import logging

CACHE_DATA_FILE = 'CACHE.DAT'
#---------------------------------------------------------------------------
""" Utilities Functions to control cache instance
    1. make sure ccontrol is accessible directly via command line
    2. intersystem cache version is later than 2010
    3. on linux, please run as root or set up the user to be able to run
       cache related command as sudo without password
"""
#---------------------------------------------------------------------------
""" a utility method to stop Cache instance
    @instanceName, the name of cache instance
    @restart, restart the cache instance
    @useSudo, whether to run ccontrol with sudo,
              does not work if sudo needs password
    @return True if is stopped, otherwise return False
"""
def stopCache(instanceName, restart=False, useSudo=False):
  if not isInstanceRunning(instanceName):
    return True
  callList = ["ccontrol", "stop", instanceName, "quietly"]
  if restart:
    callList.append("restart")
  if useSudo:
    callList.insert(0, "sudo") # prepend sudo command
  logger.info("Stop Cache instance %s" % instanceName)
  rcode = subprocess.call(callList)
  return rcode == 0
""" a utility method to force down Cache instance
    @instanceName, the name of cache instance
    @useSudo, whether to run ccontrol with sudo,
              does not work if sudo needs password
    @return True if is down, otherwise return False
"""
def forceDownCache(instanceName, useSudo=False):
  callList = ["ccontrol", "force", instanceName, "quietly"]
  if useSudo:
    callList.insert(0, "sudo")
  logger.info("Force down Cache instance %s" % instanceName)
  rcode = subprocess.call(callList)
  return rcode == 0
""" a utility method to start Cache instance
    @instanceName, the name of cache instance
    @useSudo, whether to run ccontrol with sudo,
              does not work if sudo needs password
    @return True if is started, otherwise return False
"""
def startCache(instanceName, useSudo=False):
  if isInstanceRunning(instanceName):
    return True
  callList = ["ccontrol", "start", instanceName]
  if useSudo:
    callList.insert(0, "sudo")
  logger.info("Start Cache instance %s" % instanceName)
  rcode = subprocess.call(callList)
  return rcode == 0
"""
  A Utility function to check if a cache instance is running
  Working with Cache 2010 and later version
  @instanceName: cache instance name to check
  @return True if instance is running, otherwise return False
"""
def isInstanceRunning(instanceName):
  from VistATestClient import isWindowsSystem
  cmdLst = ["ccontrol", "qlist"]
  if isWindowsSystem():
    cmdLst.append("nodisplay")
  RUNNING_REGEX = re.compile("^running", re.IGNORECASE)
  try:
    output = subprocess.Popen(cmdLst, stdout=subprocess.PIPE).communicate()[0]
    lines = codecs.decode(output, 'utf-8', 'ignore').split('\n')
    for line in lines:
      resultList = line.split('^')
      if resultList[0] == instanceName:
        return (RUNNING_REGEX.search(resultList[3].split(',')[0]) != None)
  except OSError as ex:
    print(ex)
  return False
"""
  dismount/mount a local database via InterSystem Cache ^DATABASE call
"""
def dismountLocalDatabase(dbFilePath, testClient):
  return _mountLocalDatabaseCommon(dbFilePath, testClient, True)

def mountLocalDatabase(dbFilePath, testClient):
  return _mountLocalDatabaseCommon(dbFilePath, testClient, False)

def _mountLocalDatabaseCommon(dbFilePath, testClient,
                              isDismount, readOnly=False):
  # convert dbFilePath to abspath
  if not os.path.isdir(dbFilePath):
    logging.error("%s is not a valid directory" % dbFilePath)
    return False
  absDbFilePath = os.path.abspath(dbFilePath)
  conn = testClient.getConnection()
  testClient.waitForPrompt()
  if isDismount:
    conn.send('D DISMOUNT^DATABASE\r')
  else:
    conn.send('D MOUNT^DATABASE\r')
  conn.expect('mount\? ')
  conn.send(os.path.normpath(absDbFilePath)+ '\r')
  index = conn.expect(['mount of databases\? ',
                       'mount\? '
                      ])
  if index == 0: # confirmation the mount/dismount action
    conn.send('Yes\r')
    if not isDismount: # extra confirmation for mount
      conn.expect('Mount Read Only\?')
      if readOnly:
        conn.send('Yes\r')
      else:
        conn.send('No\r')
    conn.expect('mounted') # just double check
    conn.expect('mount\? ')
    conn.send('\r')
  else: # database is already mounted/dismounted
    conn.send('\r')
  testClient.waitForPrompt()
  conn.send('\r')
  return True

"""
  restore Cache data file for Cache Instance provided
  @instanceName: Cache instance name to restore
  @bzipDataFile:
"""
def restoreCacheData(instanceName, bzipDataFile, cacheDataDir, useSudo=False):
  if not os.path.exists(bzipDataFile):
    logger.error("%s does not exist" % bzipDataFile)
    return False
  if not os.path.exists(cacheDataDir):
    logger.error("%s does not exist" % cacheDataDir)
    return False
  src = os.path.join(cacheDataDir, CACHE_DATA_FILE)
  if not os.path.exists(src):
    logger.error("%s does not exist" % src)
    return False
  if isInstanceRunning(instanceName):
    logger.info("stop Cache instance %s" % instanceName)
    if not stopCache(instanceName, useSudo=useSudo):
      logger.info("force down Cache instance %s" % instanceName)
      forceDownCache(instanceName, useSudo=useSudo)
  if isInstanceRunning(instanceName):
    logger.error("Can not stop cache instance %s" % instanceName)
    return False
  try:
    tmpBackup = src + ".bak"
    logger.info("rename %s to %s" % (src, tmpBackup))
    os.rename(src, tmpBackup)
    logger.info("extract %s to %s" % (bzipDataFile, cacheDataDir))
    extractBZIP2Tarball(bzipDataFile, cacheDataDir)
    logger.info("remove backup %s" % tmpBackup)
    os.unlink(tmpBackup)
    return True
  except OSError as oe:
    logger.error(os)
    return False

"""
  Backup Cache data file according to the sha1 hash from git repository
"""
def backupCacheDataByGitHash(instanceName, origDataPath, backupDir,
                             gitReposDir, gitReposBranch, useSudo=False):
  if not os.path.exists(origDataPath):
    logger.error("%s does not exist" % origDataPath)
    return False
  if not os.path.exists(gitReposDir):
    logger.error("%s does not exist" % gitReposDir)
    return False
  if not os.path.exists(backupDir):
    logger.error("%s does not exists"  % backupDir)
    return False
  if isInstanceRunning(instanceName):
    logger.info("stop Cache instance %s" % instanceName)
    if not stopCache(instanceName, useSudo=useSudo):
      logger.info("force down Cache instance %s" % instanceName)
      forceDownCache(instanceName, useSudo=useSudo)
  if isInstanceRunning(instanceName):
    logger.error("Can not stop cache instance %s" % instanceName)
    return False
  from GitUtils import getGitRepoRevisionHash
  if gitReposBranch is None:
    gitReposBranch = "HEAD"
  backupHash = getGitRepoRevisionHash(gitReposBranch, gitReposDir)
  destFile = os.path.join(backupDir, getCacheBackupNameByHash(backupHash))
  if not os.path.exists(destFile):
    logger.info("Creating tar file for %s" % origDataPath)
    createBZIP2Tarball(origDataPath, destFile)
  else:
    logger.warn("%s already exists" % destFile)
  return True

"""
  Utility function to generate cache back up file name based on input hash
"""
def getCacheBackupNameByHash(hash):
  return "%s.%s.tbz2" % (CACHE_DATA_FILE, hash)

"""
  Utilities function to generate bziped tarball file
  based on origin data path
  this will only keep the basename of the origDataFile
"""
def createBZIP2Tarball(origDataFile, destFile):
  import tarfile
  curDir = os.getcwd()
  try:
    os.chdir(os.path.dirname(origDataFile))
    bz2File = tarfile.open(destFile, "w:bz2")
    bz2File.add(os.path.basename(origDataFile))
    bz2File.close()
  finally:
    os.chdir(curDir)
"""
  Utility function to extract bziped tarball file to
  destination directory.
  @bzipFile: the bzip file to extract
  @destDir: destDir to extract bzipFile to, must be
            writable
"""
def extractBZIP2Tarball(bzipFile, destDir):
  import tarfile
  curDir = os.getcwd()
  try:
    os.chdir(destDir)
    bz2File = tarfile.open(bzipFile, "r:bz2")
    bz2File.extractall()
    bz2File.close()
  finally:
    os.chdir(curDir)
"""
  Utility function to export all Intersystem classes
  to individual xml files.
  @testClient, an instance of VistATestClient, in ready state
  @destDir, destination directory to store all xml files. If
   destDir does not exist, it will be created in export process.
  @diffexport, export in diff friendly format, default is True
"""
def exportAllClassesIndividual(testClient, destDir, diffexport=True):
  connection = testClient.getConnection()
  testClient.waitForPrompt()
  qualifier = ""
  if diffexport:
    qualifier="/diffexport"
  dest=os.path.abspath(destDir)  # convert to absolute path
  connection.send('W $SYSTEM.OBJ.ExportAllClassesIndividual("%s","%s")\r'
                  % (dest, qualifier))
  testClient.waitForPrompt()
  logging.info(connection.before)
"""
  Utility function to Import all Intersystem classes.
  @testClient, an instance of VistATestClient, in ready state
  @srcDir, source directory where all xml files are stored
"""
def importDir(testClient, srcDir):
  connection = testClient.getConnection()
  testClient.waitForPrompt()
  qualifier = "fc" # force action and compile
  src=os.path.abspath(srcDir)  # convert to absolute path
  connection.send('W $SYSTEM.OBJ.ImportDir("%s",,"%s")\r' % (src, qualifier))
  testClient.waitForPrompt()
  logging.info(connection.before)

""" -------- TEST CODE SECTION -------- """
def testBackup():
  instanceName = 'PROD'
  origDataPath = '/opt/cachesys/prod/mgr/VISTA/CACHE.DAT'
  backupDataPath = '/home/osehra-agent/backup/prod'
  gitReposDir = '/home/osehra-agent/git/VistA-FOIA'
  gitBranch = 'staged'
  useSudo = True
  backupCacheDataByGitHash(instanceName, origDataPath, backupDataPath,
                           gitReposDir, gitBranch, useSudo)

def testRestore(bzipFile):
  instanceName = 'PROD'
  origDataPath = '/opt/cachesys/prod/mgr/VISTA/'
  restoreCacheData(instanceName, bzipFile, origDataPath)

def testExtract():
  bzipFile = '/home/osehra-agent/backup/CACHE.DAT' \
             '.c9ee0edcb8df5912a1e4a836b92a65aca2279147.tbz2'
  destDir = '/tmp'
  extractBZIP2Tarball(bzipFile, destDir)

def testMountDisMountLocalDb():
  from VistATestClient import createTestClientArgParser
  from VistATestClient import VistATestClientFactory

  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='InterSystem Cache Mount Dismount Test',
                                   parents=[testClientParser])
  parser.add_argument('-p', '--dirPath', required=True,
                      help='Enter directory path for the local database')
  parser.add_argument('-a', '--action', choices=['M','D'],
                      required=True, type=str,
                      help='M: mount the database, D: dismount the database. '
                           'Make sure InterSystem ^DATABASE routine is accessable via'
                           ' specified namespace.')
  result = parser.parse_args();
  print(result)
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  with testClient:
    if result.action == 'D':
      logging.info('Dismount LocalDB: %s' % result.dirPath)
      dismountLocalDatabase(result.dirPath, testClient)
    else:
      logging.info('mount LocalDB: %s' % result.dirPath)
      mountLocalDatabase(result.dirPath, testClient)

def test_exportAllClassesIndividual():
  from VistATestClient import createTestClientArgParser
  from VistATestClient import VistATestClientFactory
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='Intersystem Cache Classes Exporter',
                                   parents=[testClientParser])
  parser.add_argument('dstDir', help='Output directory to store all exported classes')
  result = parser.parse_args()
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  with testClient:
    exportAllClassesIndividual(testClient, result.dstDir)

def test_importDir():
  from VistATestClient import createTestClientArgParser
  from VistATestClient import VistATestClientFactory
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='Intersystem Cache Classes Importer',
                                   parents=[testClientParser])
  parser.add_argument('srcDir', help='source directory that stores all exported classes')
  result = parser.parse_args()
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  with testClient:
    importDir(testClient, result.srcDir)

def main():
  initConsoleLogging()
  test_importDir()
  #test_exportAllClassesIndividual()

if __name__ == '__main__':
  main()
