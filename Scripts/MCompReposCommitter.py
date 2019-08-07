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
from __future__ import print_function
from builtins import str
from builtins import object
import sys
import os
import subprocess
import argparse
import re
# add the current to sys.path
SCRIPTS_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPTS_DIR)

from string import Template
from LoggerManager import getTempLogFile, logger, initConsoleLogging
from PatchInfoParser import PatchInfo, installNameToDirName
from GitUtils import addChangeSet, commitChange, getGitRepoRevisionHash

"""
  constants
"""
DEFAULT_OUTPUT_LOG_FILE_NAME = "MCompReposCommitter.log"
PATCH_SRC_WEB_LINK = "http://code.osehra.org/VistA.git/${type}/${hb}/${patch_dir}"

"""
  class to commit all the changes under the Packages directory
  in VistA-FOIA repository after patch(s) are applied and extracted.
"""
class MCompReposCommitter(object):
  def __init__(self, vistAMRepo):
    assert os.path.exists(vistAMRepo)
    self._vistAMRepoDir = os.path.abspath(vistAMRepo)
    self._packagesDir = os.path.join(self._vistAMRepoDir, 'Packages')

  def commit(self, commitMsgFile):
    self.__addChangeSet__()
    self.__commit__(commitMsgFile)

  def __addChangeSet__(self):
    logger.info("Add change set")
    #validChangeFileList = ["\*.zwr", "\*.m"]
    addChangeSet(self._packagesDir)

  def __commit__(self, commitMsgFile):
    logger.info("Commit the change")
    commitChange(commitMsgFile, self._packagesDir)

def generateCommitMsgFileByPatchInfo(patchInfo, commitMsgFile,
                                     branch="HEAD", reposDir=None):
  reposHash = getGitRepoRevisionHash(branch, reposDir)[:8]
  with open(commitMsgFile, 'w') as output:
    topicLine = "Install: %s" % patchInfo.installName
    if patchInfo.multiBuildsList:
      topicLine = "Install: %s" % (", ".join(patchInfo.multiBuildsList))
    output.write("%s\n" % topicLine)
    output.write("\nPatch Subject: %s" % patchInfo.subject)
    output.write('\n')
    output.write("Description:\n\n" + '\n'.join([str(x) for x in patchInfo.description]))
    output.write('\n')
    output.write('\n')
    output.write('Use default answers for KIDS load/install questions.\n')
    output.write('\n')
    if patchInfo.isMultiBuilds: # special logic for multibuilds
      buildLink, otherLinks = getWebLinkForPatchSourceMultiBuilds(patchInfo,
                                                                  reposHash)
      output.write('Multi-Build: %s\n' % buildLink)
      for link in otherLinks:
        if link:
          output.write('Patch-Files: %s\n' % link)
    else:
      packageLink = getWebLinkForPatchSourceByFile(patchInfo.kidsFilePath,
                                                   reposHash)
      output.write('Patch-Files: %s\n' % packageLink)

def getWebLinkForPatchSourceMultiBuilds(patchInfo, reposHash):
  # find the package path from the patchInfo
  buildLink = getWebLinkForPatchSourceByFile(patchInfo.kidsFilePath,
                                             reposHash, fileType=True)
  otherLink = []
  if patchInfo.otherKidsInfoList:
    for item in patchInfo.otherKidsInfoList:
      if item[0]:
        otherLink.append(getWebLinkForPatchSourceByFile(item[0], reposHash))
      else:
        otherLink.append(None)
  return buildLink, otherLink

def getWebLinkForPatchSourceByFile(filePath, reposHash, fileType=False):
  packageDir = os.path.dirname(filePath)
  typeName = "tree"
  if fileType:
    typeName = "blob"
    packageDir = filePath
  packageDir = packageDir[packageDir.find('Packages'):]
  packageDir = packageDir.replace('\\','/').replace(' ','+')
  webLink = Template(PATCH_SRC_WEB_LINK)
  packageLink = webLink.substitute(type=typeName,
                                   patch_dir=packageDir,
                                   hb="master")
  return packageLink

def testSinglePatchCommitMsg():
  patchInfo = PatchInfo()
  patchInfo.installName = "LR*5.2*334"
  patchInfo.kidsFilePath = "C:/users/jason.li/git/VistA/Packages/"\
                           "Lab Service/Patches/LR_5.2_334/LR_52_334.KIDs.json"
  commitMsgFile = getDefaultCommitMsgFileByPatchInfo(patchInfo)
  print(commitMsgFile)
  generateCommitMsgFileByPatchInfo(patchInfo, commitMsgFile,
                                   "origin/master", SCRIPTS_DIR)

def testMultiBuildPatchCommitMsg():
  patchInfo = PatchInfo()
  patchInfo.installName = "HDI*1.0*7"
  patchInfo.kidsFilePath = "C:/users/jason.li/git/VistA/Packages/"\
                           "MultiBuilds/LAB_LEDI_IV.KIDs.json"
  patchInfo.kidsInfoPath = \
    "C:/users/jason.li/git/VistA/Packages/Health Data and Informatics/"\
     "Patches/HDI_1.0_7/HDI-1_SEQ-8_PAT-7.TXT"
  patchInfo.kidsInfoSha1 = None
  patchInfo.isMultiBuilds = True
  patchInfo.multiBuildsList = ["HDI*1.0*7", "LR*5.2*350", "LA*5.2*74"]
  patchInfo.otherKidsInfoList = [
    ["C:/users/jason.li/git/VistA/Packages/Lab Service/"\
     "Patches/LR_5.2_350/LR-5P2_SEQ-332_PAT-350.TXT" , None],
    ["C:/users/jason.li/git/VistA/Packages/Automated Lab Instruments/"\
     "Patches/LA_5.2_74/LA-5P2_SEQ-57_PAT-74.TXT", None],
  ]
  commitMsgFile = getDefaultCommitMsgFileByPatchInfo(patchInfo)
  generateCommitMsgFileByPatchInfo(patchInfo, commitMsgFile,
                                   "origin/master", SCRIPTS_DIR)

def getDefaultCommitMsgFileByPatchInfo(patchInfo, dir=None):
  outputFile = installNameToDirName(patchInfo.installName) + ".msg"
  if dir is None:
    return getTempLogFile(outputFile)
  else:
    return os.path.join(dir, outputFile)

def testMain():
  testSinglePatchCommitMsg()
  testMultiBuildPatchCommitMsg()

def main():
  pass
if __name__ == '__main__':
  main()
