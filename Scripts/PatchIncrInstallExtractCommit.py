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
from IntersysCacheUtils import backupCacheDataByGitHash, startCache
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
      os.mkdirs(outputDir)
    extractLogDir  = mExtractConfig['log_dir']
    commitMsgDir = mExtractConfig['commit_msg_dir']
    if not os.path.exists(commitMsgDir):
      logger.error("%s does not exist" % commitMsgDir)
      return False
    backupConfig = self._config.get('Backup')
    startCache(self._instance, self._useSudo)
    testClient = self._createTestClient()
    with testClient:
      patchApply = PatchSequenceApply(testClient, patchLogDir)
      outPatchList = patchApply.generatePatchSequence(inputPatchDir)
      if not outPatchList:
        logger.info("No Patch needs to apply")
        return True
      if not isContinuous:
        outPatchList = [outPatchList[0]]
      for patchInfo in outPatchList:
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
        generateCommitMsgFileByPatchInfo(patchInfo, commitFile)
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

if __name__ == '__main__':
  initConsoleLogging()
  parserDescr = 'Incremental install Patch, extract M Comp and commit'
  parser = argparse.ArgumentParser(description=parserDescr)
  parser.add_argument('configFile', help='Configuration file in JSON format')
  result = parser.parse_args()
  runTest = PatchIncrInstallExtractCommit(result.configFile)
  runTest.run()
