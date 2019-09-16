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

from builtins import range
from builtins import object
import sys
import os
import subprocess
import argparse
import re
import json
# add the current to sys.path
SCRIPTS_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPTS_DIR)

from string import Template
from LoggerManager import getTempLogFile, logger, initConsoleLogging
from MCompReposCommitter import MCompReposCommitter
from MCompReposCommitter import getDefaultCommitMsgFileByPatchInfo
from MCompReposCommitter import generateCommitMsgFileByPatchInfo
from GitUtils import getGitRepoRevisionHash

from PatchSequenceApply import PatchSequenceApply
from VistATestClient import VistATestClientFactory
from VistATestClient import DEFAULT_NAMESPACE, DEFAULT_INSTANCE
from VistAMComponentExtractor import VistADataExtractor
from PatchInfoParser import PatchInfo
from VistAPackageInfoFetcher import VistAPackageInfoFetcher
from IntersysCacheUtils import backupCacheDataByGitHash, startCache
from IntersysCacheUtils import getCacheBackupNameByHash, restoreCacheData
"""
  constants
"""

"""
  class
"""
class PatchIncrInstallExtractCommit(object):
  def __init__(self, config):
    self._parseJSONConfig(config)
  def _parseJSONConfig(self, config):
    with open(config, 'r') as configFile:
      self._config = json.load(configFile)
      testClientConfig = self._config['VistA_Connection']
      self._instance = testClientConfig.get('instance',DEFAULT_INSTANCE)
      self._useSudo = testClientConfig.get('useSudo', False)
      self._duz = testClientConfig.get('duz', "17")
  def _createTestClient(self):
    testClientConfig = self._config['VistA_Connection']
    system = testClientConfig['system']
    namespace = testClientConfig.get('namespace', DEFAULT_NAMESPACE)
    username = testClientConfig.get('username', None)
    password = testClientConfig.get('password', None)
    prompt = testClientConfig.get('prompt', None)
    return VistATestClientFactory.createVistATestClient(system,
                                           prompt=prompt,
                                           namespace=namespace,
                                           instance=self._instance,
                                           username=username,
                                           password=password)
  def _autoRecover(self):
    """
      private method to recover the right cache.dat based on the patch
      installed in the running VistA instance.
    """
    from GitUtils import getCommitInfo
    mExtractConfig = self._config['M_Extract']
    mRepo = mExtractConfig['M_repo']
    mRepoBranch = mExtractConfig.get('M_repo_branch', None)
    if not mRepoBranch:
      mRepoBranch = 'master' # default is the master branch
    commitInfo = getCommitInfo(mRepo, mRepoBranch)
    if not commitInfo:
      logger.error("Can not read commit info from %s branch %s" % (mRepo,
                                                             mRepoBranch))
      return -1
    logger.debug(commitInfo)
    """ convert datetime to VistA T- format """
    from datetime import datetime
    commitDate = datetime.fromtimestamp(int(commitInfo['%ct']))
    timeDiff =  datetime.now() - commitDate
    days = timeDiff.days + 30 # extra 30 days
    logger.debug("Totol dates to query is %s" % days)
    installNames = None
    idx = commitInfo['%s'].find('Install: ')
    if idx >= 0:
      installNames = commitInfo['%s'][len('Install: '):].split(', ')
    logger.info("installNames is %s" % installNames)
    if installNames is None:
      logger.error("Can not find patch installed after")
      return -1
    """ check to see what and when is the last patch installed """
    testClient = self._createTestClient()
    """ make sure cache instance is up and running """
    startCache(self._instance, self._useSudo)
    with testClient:
      patchInfoFetch = VistAPackageInfoFetcher(testClient)
      output = patchInfoFetch.getAllPatchInstalledAfterByTime("T-%s" % days)
    if not output: # must be an error or something, skip backup
      logger.error("Can not get patch installation information from VistA")
      return -1
    logger.debug(output)
    """ logic to check if we need to recover from cache backup data """
    found = False
    for idx in range(0,len(output)):
      if output[idx][0] == installNames[-1]:
        found = True
        break
    if found and idx == len(output) - 1:
      """ last patch is the same as last in the commit """
      logger.info("No need to recover.")
      return 0
    if not found or idx < len(output) - 1:
      """ check to see if cache.dat exist in the backup dir"""
      backupConfig = self._config.get('Backup')
      backupDir = backupConfig['backup_dir']
      if not os.path.exists(backupDir):
        logger.error("%s does not exist" % backupDir)
        return -4
      cacheDir = backupConfig['cache_dat_dir']
      origDir = os.path.join(cacheDir, "CACHE.DAT")
      """ identify the exists of backup file in the right format """
      commitHash = commitInfo['%H']
      cacheBackupFile = os.path.join(backupDir,
                                     getCacheBackupNameByHash(commitHash))
      if not os.path.exists(cacheBackupFile):
        logger.error("backup file %s does not exist" % cacheBackupFile)
        return -5
      logger.info("Need to restore from backup data %s" % cacheBackupFile)
      restoreCacheData(self._instance, cacheBackupFile,
                       cacheDir, self._useSudo)
      startCache(self._instance, self._useSudo)
      return 0
    return -1

  def run(self):
    patchApplyConfig = self._config['Patch_Apply']
    isContinuous = patchApplyConfig.get('continuous')
    patchLogDir = patchApplyConfig['log_dir']
    if not os.path.exists(patchLogDir):
      logger.error("%s does not exist" % patchLogDir)
      return False
    inputPatchDir = patchApplyConfig['input_patch_dir']
    mExtractConfig = self._config['M_Extract']
    mRepo = mExtractConfig['M_repo']
    mRepoBranch = mExtractConfig.get('M_repo_branch', None)
    outputDir = mExtractConfig['temp_output_dir']
    if not os.path.exists(outputDir):
      os.makedirs(outputDir)
    extractLogDir  = mExtractConfig['log_dir']
    commitMsgDir = mExtractConfig['commit_msg_dir']
    if not os.path.exists(commitMsgDir):
      logger.error("%s does not exist" % commitMsgDir)
      return False
    backupConfig = self._config.get('Backup')
    if backupConfig and backupConfig['auto_recover']:
      self._autoRecover()
    while True:
      startCache(self._instance, self._useSudo)
      testClient = self._createTestClient()
      testClient2 = self._createTestClient()
      with testClient:
        with testClient2:
          patchApply = PatchSequenceApply(testClient, patchLogDir,testClient2)
          patchApply._duz= self._duz
          outPatchList = patchApply.generatePatchSequence(inputPatchDir)
          if not outPatchList:
            logger.info("No Patch needs to apply")
            return True
          patchInfo = outPatchList[0]
          logger.info(patchInfo)
          result = patchApply.applyPatchSequenceByInstallName(
                                                patchInfo.installName,
                                                patchOnly=True)
          if result < 0:
            logger.error("Error installing patch %s" % patchInfo.installName)
            return False
          elif result == 0:
            logger.info("%s is already installed" % patchInfo.installName)
            continue
          commitFile = getDefaultCommitMsgFileByPatchInfo(patchInfo,
                                                          dir=commitMsgDir)
          generateCommitMsgFileByPatchInfo(patchInfo, commitFile,
                                           reposDir=SCRIPTS_DIR)
          MExtractor = VistADataExtractor(mRepo, outputDir, extractLogDir,
                                          gitBranch=mRepoBranch)
          MExtractor.extractData(testClient)
          commit = MCompReposCommitter(mRepo)
          commit.commit(commitFile)

          if backupConfig:
            backupDir = backupConfig['backup_dir']
            if not os.path.exists(backupDir):
              logger.error("%s does not exist" % backupDir)
              return False
            cacheDir = backupConfig['cache_dat_dir']
            origDir = os.path.join(cacheDir, "CACHE.DAT")
            backupCacheDataByGitHash(self._instance, origDir, backupDir,
                                     mRepo, mRepoBranch, self._useSudo)
            startCache(self._instance, self._useSudo)
          if not isContinuous:
            break
    return True

if __name__ == '__main__':
  initConsoleLogging()
  parserDescr = 'Incremental install Patch, extract M Comp and commit'
  parser = argparse.ArgumentParser(description=parserDescr)
  parser.add_argument('configFile', help='Configuration file in JSON format')
  result = parser.parse_args()
  runTest = PatchIncrInstallExtractCommit(result.configFile)
  runTest.run()
