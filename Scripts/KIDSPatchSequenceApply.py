#!/usr/bin/env python
# Generate the KIDS Patch Order Sequence, query a running VISTA
# instance to vefify the patch dependencies and apply the KIDS Patch
# in right order
#
# For detailed help information, please run
#   python KIDSPatchSequenceApply.py -h
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
from VistATestClient import stopCache, forceDownCache, startCache
from DefaultKIDSPatchInstaller import KIDSInstallerFactory
from LoggerManager import logger, initConsoleLogging, initFileLogging
from KIDSPatchInfoParser import extractInfoFromInstallName
from KIDSPatchOrderGenerator import KIDSPatchOrderGenerator
from VistAPackageInfoFetcher import VistAPackageInfoFetcher
from ExternalDownloader import obtainKIDSPatchFileBySha1
from ConvertToExternalData import generateSha1Sum


class KIDSPatchSequenceApply(object):
  DEFAULT_VISTA_LOG_FILENAME = "VistAInteraction.log"
  DEFAULT_OUTPUT_FILE_LOG = "PatchAnalyzer.log"
  def __init__(self, testClient, logFileDir):
    self._testClient = testClient
    curTimestamp = getCurrentTimestamp()
    logFileName = "%s.%s" % (self.DEFAULT_VISTA_LOG_FILENAME, curTimestamp)
    self._logFileName = os.path.join(logFileDir,
                             logFileName)
    self._testClient.setLogFile(self._logFileName)
    self._kidsOrderGen = KIDSPatchOrderGenerator()
    self._vistaPatchInfo = VistAPackageInfoFetcher(testClient)
    self._outPatchList = []
    self._patchSet = set()
    initConsoleLogging()
    initFileLogging(os.path.join(logFileDir, self.DEFAULT_OUTPUT_FILE_LOG))

  """ generate the patch order sequence base on input """
  def generateKIDSPatchSequence(self, patchDir, patchesCSV=None):
    kidsOrderGen = self._kidsOrderGen
    patchHistInfo = self._vistaPatchInfo
    patchList = []
    if patchesCSV and os.path.exists(patchCSVFile):
      patchList = kidsOrderGen.generatePatchOrderByCSV(patchDir, patchCSVFile)
    else:
      patchList = kidsOrderGen.generatePatchOrderTopologic(patchDir)
    self._patchSet.update([x.installName for x in patchList])
    for patchInfo in patchList:
      namespace = patchInfo.namespace
      self.__updatePatchInfoPackageName__(patchInfo)
      logger.info("Checking for patch info %s" % patchInfo.installName)
      logger.debug("Checking for patch info %s" % patchInfo)
      """ check to see if the patch is already installed """
      if self.__isPatchInstalled__(patchInfo):
        continue
      if self.__isPatchReadyToInstall__(patchInfo, patchList):
        self._outPatchList.append(patchInfo)
      else:
        logger.error("Can not install patch %s" % patchInfo.installName)
        break
    logger.info("Total patches are %d" % len(self._outPatchList))
    for patchInfo in self._outPatchList:
      logger.info("%s, %s, %s" % (patchInfo.installName,
                                  patchInfo.namespace,
                                  patchInfo.kidsFilePath))

  """ apply the KIDS Patch in order """
  def applyKIDSPatchSequence(self, numOfPatches = 1, restart = True):
    totalPatch = len(self._outPatchList)
    numOfPatch = 1
    if re.match("All", str(numOfPatches), re.IGNORECASE):
      numOfPatch = totalPatch
    else:
      numOfPatch = int(numOfPatches)
    restartCache = False
    for index in range(0,min(totalPatch, numOfPatch)):
      patchInfo = self._outPatchList[index]
      """ double check to see if patch is already installed """
      if self.__isPatchInstalled__(patchInfo):
        continue
      if not self.__isPatchReadyToInstall__(patchInfo):
        break
      """ generate Sha1 Sum for patch Info """
      self.generateSha1SumForPatchInfo(patchInfo)
      """ install the KIDS patch """
      result = self.__installKIDSPatch__(patchInfo)
      if not result:
        logger.error("Failed to install patch %s: KIDS %s" %
                      (patchInfo.installName, patchInfo.kidsFilePath))
        break
      else:
        # also need to reload the package patch hist
        self.__reloadPackagePatchHistory__(patchInfo)
        assert self.__isPatchInstalled__(patchInfo)
        restartCache = True
    """ restart Cache if needed """
    if restart and restartCache and self._testClient.isCache():
      self.__restartCache__()

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
  """ get the package patch history and update package name
      for KIDS only build
  """
  def __updatePatchInfoPackageName__(self, patchInfo):
    patchHistInfo = self._vistaPatchInfo
    packageName = patchInfo.package
    namespace = patchInfo.namespace
    if namespace:
      patchHistInfo.getPackagePatchHistByNamespace(namespace)
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
    if namespace == None:
      installStatus = patchHistInfo.getInstallationStatus(installName)
      logger.debug("%s installation status is %d" %
                   (installName, installStatus))
      if patchHistInfo.isInstallCompleted(installStatus):
        logger.info("%s installed completed" % installName)
        return True
      else:
        return False
    if patchHistInfo.hasPatchInstalled(patchInfo.installName,
                                       patchInfo.namespace,
                                       patchInfo.version,
                                       patchInfo.patchNo,
                                       patchInfo.seqNo):
      logger.info("%s is already installed" % installName)
      return True
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
        patchHistInfo.createAllPackageMapping()
      assert patchHistInfo.hasNamespace(namespace)
      packageName = patchHistInfo.getPackageName(namespace)
      patchHistInfo.getPackagePatchHistory(packageName, namespace)

  """ create KIDS Patch Installer by patch Info and install
      the patch specified in patchInfo, return the result
      @return, True indicates on error, False indicates failure
  """
  def __installKIDSPatch__(self, patchInfo):
    installName = patchInfo.installName
    kidsPath = patchInfo.kidsFilePath
    seqNo = patchInfo.seqNo
    logFileName = self._logFileName
    multiBuildsList = patchInfo.multiBuildsList
    kidsInstaller = None
    """ handle patch stored as external link """
    if patchInfo.kidsSha1Path != None:
      kidsSha1 = patchInfo.kidsSha1
      (result, resultPath) = obtainKIDSPatchFileBySha1(kidsPath,
                                                       kidsSha1,
                                                       DEFAULT_CACHE_DIR)
      if not result:
        logger.error("Could not obtain external KIDS patch for %s" % kidsPath)
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
    logger.info("Applying KIDS Patch %s" % patchInfo)
    assert kidsInstaller
    return kidsInstaller.runInstallation(self._testClient)

  """ restart the cache instance """
  def __restartCache__(self):
    self._testClient.getConnection().terminate()
    logger.info("Wait for 5 seconds")
    time.sleep(5)
    logger.info("Restart CACHE instance")
    instanceName = self._testClient.getInstanceName()
    result = stopCache(instanceName, True)
    if not result:
      result = forceDownCache(instanceName)
      if result:
        startCache(instanceName)
      else:
        logger.error("Can not stop cache instance %s" % instanceName)

  """ check to see if patch is ready to be installed """
  def __isPatchReadyToInstall__(self, patchInfo, patchList = None):
    packageName = patchInfo.package
    patchHist = self._vistaPatchInfo.getPackagePatchHistByName(packageName)
    if not patchHist or not patchHist.hasPatchHistory():
      logger.info("no patch hist for %s" % packageName)
      return True # if no such an package or hist info, just return True
    """ check patch sequence no to see if it is out of order """
    if patchInfo.seqNo:
      seqNo = patchHist.getLatestSeqNo()
      if patchInfo.seqNo < seqNo:
        logger.error("SeqNo out of order, %s less than latest one %s" %
                      (patchInfo.seqNo), seqNo)
        return False
    # check all the dependencies
    for item in patchInfo.depKIDSPatch:
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
                      help = 'whether to install KIDS Patch or not')
  parser.add_argument('-n', '--numOfPatch', required=False, default=1,
    help="input All for all patches, otherwise just enter number, default is 1")
  result = parser.parse_args();
  print (result)
  inputPatchDir = result.patchFileDir
  assert os.path.exists(inputPatchDir)
  outputDir = result.logDir
  assert os.path.exists(outputDir)
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  with testClient as vistAClient:
    kidsPatchApply = KIDSPatchSequenceApply(vistAClient, outputDir)
    kidsPatchApply.generateKIDSPatchSequence(inputPatchDir)
    if result.install:
      kidsPatchApply.applyKIDSPatchSequence(result.numOfPatch)

if __name__ == '__main__':
  main()
