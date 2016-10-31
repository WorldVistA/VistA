#!/usr/bin/env python
# Generate the Patch Order Sequence, query a running VISTA
# instance to vefify the patch dependencies and apply the Patch
# in right order
#
# For detailed help information, please run
#   python PatchSequenceApply.py -h
#
#---------------------------------------------------------------------------
# Copyright 2011-2012 The Open Source Electronic Health Record Agent
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
import re
import glob
import argparse
from datetime import datetime
import time

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_CACHE_DIR = os.path.normpath(os.path.join(SCRIPT_DIR, "../"))
sys.path.append(SCRIPT_DIR)

""" Class to find and store patch history for each package
"""
def getCurrentTimestamp():
  from datetime import datetime
  return datetime.now().strftime("%Y-%m-%d_%H-%M-%S")

from VistATestClient import VistATestClientFactory, createTestClientArgParser
from DefaultKIDSBuildInstaller import KIDSInstallerFactory
from LoggerManager import logger, initConsoleLogging, initFileLogging
from PatchInfoParser import extractInfoFromInstallName
from PatchOrderGenerator import PatchOrderGenerator
from VistAPackageInfoFetcher import VistAPackageInfoFetcher
from VistAPackageInfoFetcher import getPackageLatestVersionByNamespace
from ExternalDownloader import obtainKIDSBuildFileBySha1
from ConvertToExternalData import generateSha1Sum
from VistATaskmanUtil import VistATaskmanUtil


class PatchSequenceApply(object):
  DEFAULT_VISTA_LOG_FILENAME = "VistAInteraction.log"
  DEFAULT_OUTPUT_FILE_LOG = "PatchAnalyzer.log"
  def __init__(self, testClient, logFileDir):
    self._testClient = testClient
    curTimestamp = getCurrentTimestamp()
    logFileName = "%s.%s" % (self.DEFAULT_VISTA_LOG_FILENAME, curTimestamp)
    self._logFileName = os.path.join(logFileDir,
                             logFileName)
    self._testClient.setLogFile(self._logFileName)
    self._patchOrderGen = PatchOrderGenerator()
    self._vistaPatchInfo = VistAPackageInfoFetcher(testClient)
    self._outPatchList = []
    self._patchSet = set()
    initFileLogging(os.path.join(logFileDir, self.DEFAULT_OUTPUT_FILE_LOG))

  """ generate the patch order sequence base on input """
  def generatePatchSequence(self, patchDir, installName=None,
                                isUpToPatch=False):
    patchOrderGen = self._patchOrderGen
    patchHistInfo = self._vistaPatchInfo
    patchList = []
    if isUpToPatch:
      patchList = patchOrderGen.generatePatchOrderTopologic(patchDir)
    else:
      patchList = patchOrderGen.generatePatchOrderTopologic(patchDir, installName)
    self._patchSet.update([x.installName for x in patchList])
    if installName and installName not in self._patchSet:
      errMsg = ("Can not find patch for install name %s" % installName)
      raise Exception(errMsg)
    for patchInfo in patchList:
      namespace = patchInfo.namespace
      self.__updatePatchInfoPackageName__(patchInfo)
      logger.info("Checking for patch info %s" % patchInfo.installName)
      logger.debug("Checking for patch info %s" % patchInfo)
      """ check to see if the patch is already installed """
      if not self.__isPatchInstalled__(patchInfo):
        if self.__isPatchReadyToInstall__(patchInfo, patchList):
          self._outPatchList.append(patchInfo)
        else:
          errorMsg = ("Can not install patch %s" % patchInfo.installName)
          logger.error(errorMsg)
          raise Exception(errorMsg)
      if isUpToPatch and installName and installName == patchInfo.installName:
        break

    logger.info("Total patches are %d" % len(self._outPatchList))
    for patchInfo in self._outPatchList:
      logger.info("%s, %s, %s" % (patchInfo.installName,
                                  patchInfo.namespace,
                                  patchInfo.kidsFilePath))
    return self._outPatchList

  """ Apply up to maxPatches Patches ordered by sequence number """
  def applyPatchSequenceByNumber(self, maxPatches=1):
    totalPatch = len(self._outPatchList)
    numOfPatch = 1
    if re.match("All", str(maxPatches), re.IGNORECASE):
      numOfPatch = totalPatch
    else:
      numOfPatch = int(maxPatches)
    endIndex = min(totalPatch, numOfPatch)
    return self.__applyPatchUptoIndex__(endIndex)

  def applyPatchSequenceByInstallName(self, installName, patchOnly=False):
    """ apply the Patch in sequence order up to specified install name
        if patchOnly is set to True, will only apply that patch
    """
    if installName not in self._patchSet:
      raise Exception("Invalid install name: %s" % installName)
    if len(self._outPatchList) == 0:
      logger.info("No Patch to apply")
      return 0
    logger.info("Apply patches up to %s" % installName)
    patchIndex = self.__getPatchIndexByInstallName__(installName)
    endIndex = patchIndex + 1
    startIndex = 0
    if patchOnly:
      startIndex = patchIndex
    return self.__applyPatchUptoIndex__(endIndex, startIndex)

  @staticmethod
  def generateSha1SumForPatchInfo(patchInfo):
    if patchInfo.kidsSha1 is None:
      patchInfo.kidsSha1 = generateSha1Sum(patchInfo.kidsFilePath)
    if patchInfo.kidsInfoPath:
      patchInfo.kidsInfoSha1 = generateSha1Sum(patchInfo.kidsInfoPath)
    if patchInfo.otherKidsInfoList:
      for item in patchInfo.otherKidsInfoList:
        if item[0]:
          item[1] = generateSha1Sum(item[0])

  @staticmethod
  def indexInPatchList(installName, patchList):
    for index in range(0,len(patchList)):
      if patchList[index].installName == installName:
        return index
    return -1

#---------------------------------------------------------------------------
# private implementation
#---------------------------------------------------------------------------
  """
    apply patch incrementally up to the end index in self._outPatchList
  """
  def __applyPatchUptoIndex__(self, endIndex, startIndex=0):
    assert endIndex >= 0 and endIndex <= len(self._outPatchList)
    assert startIndex >=0 and startIndex <= endIndex
    """ make sure taskman is running """
    taskmanUtil = VistATaskmanUtil()
    taskmanUtil.startTaskman(self._testClient)
    result = 0
    for index in range(startIndex, endIndex):
      patchInfo = self._outPatchList[index]
      result = self.__applyIndividualPatch__(patchInfo)
      if result < 0:
        logger.error("Failed to install patch %s: KIDS %s" %
                      (patchInfo.installName, patchInfo.kidsFilePath))
        return result
    """ wait until taskman is current """
    taskmanUtil.waitTaskmanToCurrent(self._testClient)
    return result

#---------------------------------------------------------------------------
# private implementation
#---------------------------------------------------------------------------
  """
    get index of a patch in self._outPatchList by install name
  """
  def __getPatchIndexByInstallName__(self, installName):
    idx = 0
    for patchInfo in self._outPatchList:
      if patchInfo.installName == installName:
        return idx
      idx += 1
    return -1
  """
    apply individual patch
    @return:
      throw exception for installation error.
      0 if patch is already installed.
      -1 if patch is not ready to install
      1 if patch installed sucessfully
  """
  def __applyIndividualPatch__(self, patchInfo):
    """ double check to see if patch is already installed """
    if self.__isPatchInstalled__(patchInfo):
      return 0
    if not self.__isPatchReadyToInstall__(patchInfo):
      return -1
    """ generate Sha1 Sum for patch Info """
    self.generateSha1SumForPatchInfo(patchInfo)
    """ install the Patch """
    result = self.__installPatch__(patchInfo)
    if not result:
      errorMsg = ("Failed to install patch %s: KIDS %s" %
                 (patchInfo.installName, patchInfo.kidsFilePath))
      logger.error(errorMsg)
      raise Exception(errorMsg)
    else:
      # also need to reload the package patch hist
      self.__reloadPackagePatchHistory__(patchInfo)
      """ special logic to handle release code """
      installed = False
      namespace,ver,patch = extractInfoFromInstallName(patchInfo.installName)
      if not patch:
        if namespace and ver:
          updVer = getPackageLatestVersionByNamespace(namespace,
                                                      self._testClient)
          if updVer and updVer == ver:
            installed = True
      if not installed:
        assert self.__isPatchInstalled__(patchInfo)
    return 1
  """ get the package patch history and update package name
      for KIDS only build
  """
  def __updatePatchInfoPackageName__(self, patchInfo):
    patchHistInfo = self._vistaPatchInfo
    packageName = patchInfo.package
    namespace = patchInfo.namespace
    verInfo = patchInfo.version
    if namespace:
      patchHistInfo.getPackagePatchHistByNamespace(namespace, verInfo)
      if packageName:
        vistAPackageName = patchHistInfo.getPackageName(namespace)
        if vistAPackageName != packageName:
          logger.error("Different PackageName for %s, %s:%s" %
                       (patchInfo.installName, vistAPackageName, packageName))
          patchInfo.package = vistAPackageName
      else:
        packageName = patchHistInfo.getPackageName(namespace)
        patchInfo.package = packageName

  """ check to see if the patch is already installed """
  def __isPatchInstalled__(self, patchInfo):
    patchHistInfo = self._vistaPatchInfo
    namespace = patchInfo.namespace
    installName = patchInfo.installName
    if patchHistInfo.hasPatchInstalled(patchInfo.installName,
                                       patchInfo.namespace,
                                       patchInfo.version,
                                       patchInfo.patchNo,
                                       patchInfo.seqNo):
      logger.info("%s is already installed" % installName)
      return True
    installStatus = patchHistInfo.getInstallationStatus(installName)
    logger.debug("%s installation status is %d" %
                 (installName, installStatus))
    if patchHistInfo.isInstallCompleted(installStatus):
      logger.info("%s installed completed" % installName)
      return True
    else:
      return False

  """ update package patch history """
  def __reloadPackagePatchHistory__(self, patchInfo):
    patchHistInfo = self._vistaPatchInfo
    installNameList = []
    if patchInfo.isMultiBuilds:
      installNameList = patchInfo.multiBuildsList
    else:
      installNameList.append(patchInfo.installName)
    for installName in installNameList:
      (namespace,ver,patch) = extractInfoFromInstallName(installName)
      if not patchHistInfo.hasNamespace(namespace):
        ns = patchHistInfo.getPackageNamespaceByName(namespace)
        if not ns:
          patchHistInfo.createAllPackageMapping()
        else:
          namespace = ns
      if patchHistInfo.hasNamespace(namespace):
        packageName = patchHistInfo.getPackageName(namespace)
        patchHistInfo.getPackagePatchHistory(packageName, namespace, ver)

  """ create Patch Installer by patch Info and install
      the patch specified in patchInfo, return the result
      @return, True indicates on error, False indicates failure
  """
  def __installPatch__(self, patchInfo):
    installName = patchInfo.installName
    kidsPath = patchInfo.kidsFilePath
    seqNo = patchInfo.seqNo
    logFileName = self._logFileName
    multiBuildsList = patchInfo.multiBuildsList
    kidsInstaller = None
    """ handle patch stored as external link """
    if patchInfo.kidsSha1Path != None:
      kidsSha1 = patchInfo.kidsSha1
      (result, resultPath) = obtainKIDSBuildFileBySha1(kidsPath,
                                                       kidsSha1,
                                                       DEFAULT_CACHE_DIR)
      if not result:
        logger.error("Could not obtain external Patch for %s" % kidsPath)
        return result
      kidsPath = resultPath # set the KIDS Path
    """ get the right KIDS installer """
    associateFiles = patchInfo.associatedInfoFiles
    associatedGlobals = patchInfo.associatedGlobalFiles
    if patchInfo.hasCustomInstaller:
      """ use python imp module to load the source """
      logger.info("using custom installer %s" % patchInfo.customInstallerPath)
      import imp
      installerModule = imp.load_source("KIDS",
                                patchInfo.customInstallerPath)
      from KIDS import CustomInstaller
      kidsInstaller = CustomInstaller(kidsPath, installName,
                                      seqNo, logFileName,
                                      multiBuildsList,
                                      files=associateFiles,
                                      globals=associatedGlobals)

    else:
      kidsInstaller = KIDSInstallerFactory.createKIDSInstaller(
                            kidsPath, installName, seqNo, logFileName,
                            multiBuildsList,
                            files=associateFiles,
                            globals=associatedGlobals)
    logger.info("Applying Patch %s" % patchInfo)
    assert kidsInstaller
    return kidsInstaller.runInstallation(self._testClient, self._testClient2)

  """ check to see if patch is ready to be installed """
  def __isPatchReadyToInstall__(self, patchInfo, patchList = None):
    packageName = patchInfo.package
    ver = patchInfo.version
    patchHist = self._vistaPatchInfo.getPackagePatchHistByName(packageName, ver)
    if not patchHist or not patchHist.hasPatchHistory():
      logger.info("no patch hist for %s, ver: %s" % (packageName, ver))
      return True # if no such an package or hist info, just return True
    """ check patch sequence no to see if it is out of order """
    if patchInfo.seqNo:
      seqNo = patchHist.getLatestSeqNo()
      if patchInfo.seqNo < seqNo:
        logger.error("SeqNo out of order, %s less than latest one %s" %
                      (patchInfo.seqNo), seqNo)
        return False
    # check all the dependencies
    for item in patchInfo.depKIDSBuild:
      if patchList and item in self._patchSet: # we are going to install the dep patch
        logger.info("We are going to install the patch %s" % item)
        """ make sure installation is in the right order """
        itemIndex = self.indexInPatchList(item, patchList)
        patchIndex = self.indexInPatchList(patchInfo.installName, patchList)
        if itemIndex >= patchIndex:
          logger.warn("%s is out of order with %s" % (item, patchInfo))
          return False
        else:
          continue
      (namespace,ver,patch) = extractInfoFromInstallName(item)
      if self._vistaPatchInfo.hasPatchInstalled(item, namespace, ver, patch):
        logger.debug("%s is arelady installed" % item)
        continue
      installStatus = self._vistaPatchInfo.getInstallationStatus(item)
      if self._vistaPatchInfo.isInstallCompleted(installStatus):
        continue
      elif item in patchInfo.optionalDepSet:
        logger.warn("Patch specified in KIDS info file %s is not installed for %s" %
                    (item, patchInfo.installName))
        continue
      else:
        logger.error("dep %s is not installed for %s %s" %
                    (item, patchInfo.installName, patchInfo.kidsFilePath))
        return False
    return True

""" main
"""
def main():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='FOIA Patch Sequence Analyzer',
                                   parents=[testClientParser])
  parser.add_argument('-p', '--patchFileDir', required=True,
        help='input file path to the folder that contains all the FOIA patches')
  parser.add_argument('-l', '--logDir', required=True,
                      help='Output dirctory to store all log file information')
  parser.add_argument('-i', '--install', default=False, action="store_true",
                      help = 'whether to install Patch or not')
  group = parser.add_mutually_exclusive_group()
  group.add_argument('-n', '--numOfPatch', default=1,
                     help="input All for all patches, "
                          "otherwise just enter number, default is 1")
  group.add_argument('-u', '--upToPatch',
                     help="install patches up to specified install name")
  group.add_argument('-o', '--onlyPatch',
                     help='install specified patch and required patches only'
                          ', this option will ignore the CSV dependencies')

  result = parser.parse_args();
  print (result)
  inputPatchDir = result.patchFileDir
  assert os.path.exists(inputPatchDir)
  outputDir = result.logDir
  assert os.path.exists(outputDir)
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  testClient2 = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  initConsoleLogging()
  with testClient as vistAClient:
    patchSeqApply = PatchSequenceApply(vistAClient, outputDir)
    assert testClient2
    with testClient2 as vistAClient2:
      patchSeqApply._testClient2 = vistAClient2
      if result.upToPatch:
        patchSeqApply.generatePatchSequence(inputPatchDir,
                                                 result.upToPatch, True)
      else:
        patchSeqApply.generatePatchSequence(inputPatchDir, result.onlyPatch)
      if result.install:
        if result.onlyPatch:
          patchSeqApply.applyPatchSequenceByNumber("All")
        elif result.upToPatch:
          patchSeqApply.applyPatchSequenceByInstallName(result.upToPatch)
        else:
          patchSeqApply.applyPatchSequenceByNumber(result.numOfPatch)

if __name__ == '__main__':
  main()
