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
import re
import argparse
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from datetime import datetime
from LoggerManager import logger, initConsoleLogging, initFileLogging
from VistAMenuUtil import VistAMenuUtil

""" class to fetch package related information from a running vista instance """
class VistAPackageInfoFetcher(object):
  """ Patch install Status list """
  PATCH_INSTALL_STATUS_LIST = [
      "Loaded from Distribution", # status 0
      "Queued for Install",       # status 1
      "Start of Install",         # status 2
      "Install Completed",        # status 3
      "De-Installed"              # status 4
  ]

  def __init__(self, vistATestClient):
    self._testClient = vistATestClient
    self._packageMapping = dict()
    self._packagePatchHist = dict()
  """ get all packages and package namespace mapping from a running Vista """
  def createAllPackageMapping(self):
    self._packageMapping.clear()
    connection = self._testClient.getConnection()
    result = None
    menuUtil = VistAMenuUtil(duz=1) # set duz as 1
    menuUtil.gotoFileManPrintFileEntryMenu(self._testClient)
    # print file entry
    connection.send("9.4\r") # Package file with fileman #9.4
    connection.expect("SORT BY:")
    connection.send("\r")
    connection.expect("START WITH")
    connection.send("\r")
    connection.expect("FIRST PRINT FIELD:")
    connection.send(".01\r") # fileman field# .01 is NAME
    connection.expect("THEN PRINT FIELD:")
    connection.send("1\r") # fileman field# 1 is the PREFIX
    connection.expect("THEN PRINT FIELD:")
    connection.send("\r")
    connection.expect("PACKAGE LIST//")
    connection.send("\r")
    connection.expect("DEVICE:")
    connection.send(";132;99999\r")
    connection.expect("Select OPTION: ")
    self.__parseAllPackages__(connection.before)
    menuUtil.exitFileManMenu(self._testClient, waitOption=False)

  def __parseAllPackages__(self, allPackageString):
    allLines = allPackageString.split('\r\n')
    packageStart = False
    for line in allLines:
      line = line.strip()
      if len(line) == 0:
        continue
      if re.search("^-+$", line):
        packageStart = True
        continue
      if packageStart:
        packageName = line[:32].strip()
        packageNamespace = line[32:].strip()
        self._packageMapping[packageNamespace] = packageName

  def getPackagePatchHistory(self, packageName, namespace):
    if not self._packageMapping:
      self.createAllPackageMapping()
    connection = self._testClient.getConnection()
    result = None
    menuUtil = VistAMenuUtil(duz=1) # set duz as 1
    menuUtil.gotoKidsUtilMenu(self._testClient)
    connection.send("Display\r")
    connection.expect("Select PACKAGE NAME:")
    connection.send("%s\r" % packageName)
    while True:
      index  = connection.expect(["Select VERSION: [0-9.]+\/\/",
                                  "Select VERSION: ",
                                  "Select Utilities ",
                                  "CHOOSE [0-9]+-[0-9]+"])
      if index == 3:
        outchoice = findChoiceNumber(connection.before, packageName, namespace)
        if outchoice:
          connection.send("%s\r" % outchoice)
        else: # no match
          connection.send("\r")
        continue
      if index == 0 or index == 1:
        if index == 0:
          connection.send("\r")
        else:
          connection.send("1.0\r")
        connection.expect("Do you want to see the Descriptions\?")
        connection.send("\r")
        connection.expect("DEVICE:")
        connection.send(";132;99999\r")
        connection.expect("Select Utilities ")
        result = parseKIDSPatchHistory(connection.before,
                                       packageName, namespace)
        break
      else:
        break
    menuUtil.exitKidsUtilMenu(self._testClient)
    self._packagePatchHist[packageName] = result
    return result

  def getAllPackagesPatchHistory(self):
    self.createAllPackageMapping()
    self._packagePatchHist.clear()
    for (namespace, package) in self._packageMapping.iteritems():
      logger.info("Parsing Package %s, namespace %s" % (package, namespace))
      #if not (package[0] == "PHARMACY" and package[1] == "PS"): continue
      self.getPackagePatchHistory(package, namespace)

  def getPackagePatchHistByName(self, packageName):
    if not self._packageMapping:
      self.createAllPackageMapping()
    if not packageName:
      return None
    if packageName in self._packagePatchHist:
      return self._packagePatchHist[packageName]
    for (namespace, package) in self._packageMapping.iteritems():
      if package == packageName:
        result = self.getPackagePatchHistory(package, namespace)
        return result

  def getPackagePatchHistByNamespace(self, namespace):
    if not self._packageMapping:
      self.createAllPackageMapping()
    if namespace in self._packageMapping:
      package = self._packageMapping[namespace]
      if package in self._packagePatchHist: return
      result = self.getPackagePatchHistory(package, namespace)
      return result

  def hasPatchHistoryList(self, namespace):
    if namespace not in self._packageMapping:
      return False
    return self._packageMapping[namespace] in self._packagePatchHist

  def getPackageMapping(self):
    return self._packageMapping

  def getPackagePatchHistoryMap(self):
    return self._packagePatchHist

  def getPackageName(self, namespace):
    return self._packageMapping.get(namespace)

  def hasNamespace(self, namespace):
    return namespace in self._packageMapping

  """ check to see if patch is already installed via patch history """
  def hasPatchInstalled(self, installName, namespace, version,
                        patchNo, seqNo = None):
    if namespace not in self._packageMapping:
      logger.info("this is a new namespace %s" % namespace)
      return False
    packageName = self._packageMapping[namespace]
    if packageName not in self._packagePatchHist:
      self.getPackagePatchHistByNamespace(namespace)
    patchHist = self._packagePatchHist[packageName]
    if seqNo:
      if patchHist.hasSeqNo(seqNo):
        return True
    if patchHist.version:
      if float(patchHist.version) != float(version):
        logger.info("Diff ver %s, %s" % (patchHist.version, version))
        status = self.getInstallationStatus(installName)
        return self.isInstallCompleted(status)
    if patchNo:
      return patchHist.hasPatchNo(patchNo)
    logger.debug("Check to see if install is completed %s" % installName)
    status = self.getInstallationStatus(installName)
    return self.isInstallCompleted(status)

  """ check to see if the installation is not installed """
  @staticmethod
  def isNotInstalled(status):
      return status == -1
  """ check to see if the installation is loaded from distribution"""
  @staticmethod
  def isLoadedFromDistribution(status):
      return status == 0
  """ check to see if the installation is Queued for install"""
  @staticmethod
  def isQueuedForInstall(status):
      return status == 1
  """ check to see if the installation is already started """
  @staticmethod
  def isInstallStarted(status):
      return status == 2
  """ check to see if the installation is completed """
  @staticmethod
  def isInstallCompleted(status):
      return status == 3
  """ check to see if the installation is De-installed """
  @staticmethod
  def isDeinstalled(status):
      return status == 4

  """ get the installation status for an install
      @parameter installName: patch KIDS install name
      @return -1 if installName not found
              0 if Loaded from Distribution
              1 if Queued for install
              2 if Start of Install
              3 if Install Completed
              4 if De-installed
  """
  def getInstallationStatus(self, installName):
    connection = self._testClient.getConnection()
    result = -1 # default is not installed
    menuUtil = VistAMenuUtil(duz=1)
    menuUtil.gotoFileManInquireFileEntryMenu(self._testClient)
    connection.send("9.7\r") # Package file with fileman #9.7
    connection.expect("Select INSTALL NAME:")
    connection.send("%s\r" % installName)
    while True:
      index = connection.expect(["Select INSTALL NAME: ",
                                 "ANOTHER ONE: ",
                                 "CHOOSE 1-[0-9]+: "])
      if index == 0:
        connection.send("\r")
        break
      elif index == 1:
        txtToSearch = connection.before.replace("\r\n","")
        logger.debug(txtToSearch)
        result = indexOfInstallStatus(txtToSearch)
        connection.send("^\r")
        break
      # handle if the install has multiple install status
      elif index == 2:
        linesToSearch = connection.before.split("\r\n")
        for line in linesToSearch: # only care the the first line
          line = line.strip("\r\n ")
          if not re.search("^1 ", line): continue
          result = indexOfInstallStatus(line)
          break
        connection.send("^\r")
        continue
    menuUtil.exitFileManMenu(self._testClient)
    return result

  def printPackagePatchHist(self, packageName):
    import pprint
    if packageName in self._packagePatchHist:
      print ("-----------------------------------------")
      print ("--- Package %s Patch History Info ---" % packageName)
      print ("-----------------------------------------")
      pprint.pprint(self._packagePatchHist[packageName].patchHistory)

  def printPackageLastPatch(self, packageName):
    import pprint
    if packageName in self._packagePatchHist:
      print ("-----------------------------------------")
      print ("--- Package %s Last Patch Info ---" % packageName)
      print ("-----------------------------------------")
      pprint.pprint(self._packagePatchHist[packageName].patchHistory[-1])

""" a utility class to find out the choice number from VistA choice prompt """
def findChoiceNumber(choiceTxt, matchString, extraInfo=None):
  logger.debug("txt is [%s]" % choiceTxt)
  matchRegEx = None
  if extraInfo and len(extraInfo) > 0:
    matchRegEx = re.compile('^  +(?P<number>[0-9]+)   %s +%s$' %
                            (matchString, extraInfo))
  else:
    matchRegEx = re.compile('^  +(?P<number>[0-9]+)   %s$' % (matchString))
  choiceLines = choiceTxt.split('\r\n')
  for line in choiceLines:
    line = line.rstrip()
    if len(line) == 0:
      continue
    result = matchRegEx.search(line)
    if result:
      return result.group('number')
    else:
      continue
  return None

"""Store the Patch History related to a Package
"""
class PackagePatchHistory(object):
  def __init__(self, packageName, namespace):
    self.packageName = packageName
    self.namespace = namespace
    self.patchHistory = []
    self.version = None
  def addPatchInfo(self, PatchInfo):
    self.patchHistory.append(PatchInfo)
  def hasPatchHistory(self):
    return len(self.patchHistory) > 0
  def setVersion(self, version):
    self.version = version
  def hasSeqNo(self, seqNo):
    for patchInfo in self.patchHistory:
      if patchInfo.seqNo == int(seqNo):
        return True
    return False
  def hasPatchNo(self, patchNo):
    for patchInfo in self.patchHistory:
      if patchInfo.patchNo == int(patchNo):
        return True;
    return False
  def getLastPatchInfo(self):
    if len(self.patchHistory) == 0:
      return None
    return self.patchHistory[-1]
  def getLatestSeqNo(self):
    if not self.hasPatchHistory():
      return 0
    last = len(self.patchHistory)
    for index in range(last,0,-1):
      patchInfo = self.patchHistory[index-1]
      if patchInfo.seqNo:
        return patchInfo.seqNo
    return 0
  def __str__(self):
    return self.patchHistory.__str__()
  def __repr__(self):
    return self.patchHistory.__str__()

"""
a class to parse and store KIDS patch history info
"""
class PatchInfo(object):
  PATCH_HISTORY_LINE_REGEX = re.compile("^   [0-9]")
  PATCH_VERSION_LINE_REGEX = re.compile("^VERSION: [0-9.]+ ")
  PATCH_VERSION_START_INDEX = 3
  PATCH_APPLIED_DATETIME_INDEX = 20
  PATCH_APPLIED_USERNAME_INDEX = 50

  DATETIME_FORMAT_STRING = "%b %d, %Y@%H:%M:%S"
  DATE_FORMAT_STRING = "%b %d, %Y"
  DATE_TIME_SEPERATOR = "@"
  def __init__(self, historyLine):
    self.patchNo = None
    self.seqNo = None
    self.datetime = None
    self.userName = None
    self.version = None
    self.__parseHistoryLine__(historyLine)
  def __parseHistoryLine__(self, historyLine):
    totalLen = len(historyLine)
    if totalLen < self.PATCH_VERSION_START_INDEX:
      return
    pos = historyLine.find(";Created on") # handle informal history line
    datetimeIndent = self.PATCH_APPLIED_DATETIME_INDEX
    userIndent = self.PATCH_APPLIED_USERNAME_INDEX
    if pos >= 0: # ignore the Created on format
      logger.debug(historyLine)
      historyLine = historyLine[:pos].rstrip()
      totalLen = len(historyLine)
      if totalLen > datetimeIndent:
        historyLine = historyLine.split('-')[0].rstrip()
        totalLen = len(historyLine)
      logger.debug("total len is %d" % totalLen)
    if totalLen > userIndent:
      self.userName = historyLine[userIndent:].strip()
    if totalLen > datetimeIndent:
      datetimePart = historyLine[datetimeIndent:userIndent].strip()
      pos = datetimePart.find(self.DATE_TIME_SEPERATOR)
      if pos >=0:
        if len(datetimePart) - pos == 3:
          datetimePart += ":00:00"
        if len(datetimePart) - pos == 6:
          datetimePart +=":00"
        self.datetime = datetime.strptime(datetimePart,
                                          self.DATETIME_FORMAT_STRING)
      else:
        self.datetime = datetime.strptime(datetimePart, self.DATE_FORMAT_STRING)
    if self.isVersionLine(historyLine):
      self.__parseVersionInfo__(
          historyLine[:datetimeIndent].strip())
      return
    patchPart = historyLine[self.PATCH_VERSION_START_INDEX:datetimeIndent]
    seqIndex = patchPart.find("SEQ #")
    if seqIndex >= 0:
      self.patchNo = int(patchPart[:seqIndex].strip())
      self.seqNo = int(patchPart[seqIndex+5:].strip())
    else:
      try:
        self.patchNo = int(patchPart.strip())
      except ValueError as ex:
        print ex
        logger.error("History Line is %s" % historyLine)
        self.patchNo = 0

  def hasVersion(self):
    return self.version != None
  def __parseVersionInfo__(self, historyLine):
    self.seqNo = None
    self.patchNo = None
    self.version = historyLine[historyLine.find("VERSION: ")+9:]
  @staticmethod
  def isValidHistoryLine(historyLine):
    return PatchInfo.isPatchLine(historyLine) or PatchInfo.isVersionLine(historyLine)
  @staticmethod
  def isPatchLine(patchLine):
    return PatchInfo.PATCH_HISTORY_LINE_REGEX.search(patchLine) != None
  @staticmethod
  def isVersionLine(versionLine):
    return PatchInfo.PATCH_VERSION_LINE_REGEX.search(versionLine) != None

  def __str__(self):
    retString = ""
    if self.version:
      retString += "Ver: %s " % self.version
    if self.patchNo:
      retString += "%d" % self.patchNo
    if self.seqNo:
      retString += " SEQ #%d" % self.seqNo
    if self.datetime:
      retString += " %s " % self.datetime.strftime(self.DATETIME_FORMAT_STRING)
    if self.userName:
      retString += " %s" % self.userName
    return retString
  def __repr__(self):
    return self.__str__()

""" Utility Function to check to see if has the right install status """
def indexOfInstallStatus(statusTxt):
  statusList = VistAPackageInfoFetcher.PATCH_INSTALL_STATUS_LIST
  for idx in range(0,len(statusList)):
    if re.search(statusList[idx], statusTxt, re.IGNORECASE):
      return idx
  return -1

""" function to convert package patch history into PackagePatchHistory """
def parseKIDSPatchHistory(historyString, packageName, namespace):
  allLines = historyString.split('\r\n')
  patchHistoryStart = False
  result = None
  for line in allLines:
    line = line.rstrip()
    if len(line) == 0:
      continue
    if re.search("^-+$", line):
      patchHistoryStart = True
      continue
    if patchHistoryStart:
      if not PatchInfo.isValidHistoryLine(line):
        continue
      if not result: result = PackagePatchHistory(packageName, namespace)
      patchInfo = PatchInfo(line)
      result.addPatchInfo(patchInfo)
      if patchInfo.hasVersion():
        result.setVersion(patchInfo.version)
  return result

""" test the fetcher class """
def testMain():
  testClient = createTestClient()
  with testClient:
    initConsoleLogging()
    packagePatchHist = VistAPackageInfoFetcher(testClient)
    packagePatchHist.getAllPackagesPatchHistory()
    packagePatchHist.getPackagePatchHistByName("TOOLKIT")
    packagePatchHist.printPackageLastPatch("TOOLKIT")
    packagePatchHist.getPackagePatchHistByName("IMAGING")
    packagePatchHist.printPackageLastPatch("IMAGING")
    packagePatchHist.getPackagePatchHistByNamespace("VPR")
    packagePatchHist.printPackagePatchHist("VIRTUAL PATIENT RECORD")
    packagePatchHist.printPackageLastPatch("VIRTUAL PATIENT RECORD")
    packagePatchHist.getPackagePatchHistByNamespace("DENT")
    packagePatchHist.printPackagePatchHist("DENTAL")
    packagePatchHist.getPackagePatchHistByNamespace("NUPA")
    packagePatchHist.printPackagePatchHist("PATIENT ASSESSMENT DOCUM")

def createTestClient():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA Patch Info Query',
                                   parents=[testClientParser])
  result = parser.parse_args();
  print (result)
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  return testClient

def testIsInstallCompleted():
  testClient = createTestClient()
  assert testClient
  with testClient:
    initConsoleLogging()
    packagePatchHist = VistAPackageInfoFetcher(testClient)
    installNameLst = [
        "ECLAIMS 5 BUNDLE 1.0",
        "TEST 1.0",
        "LR*5.2*334",
        "TERATOGENIC MEDICATIONS ORDER CHECKS 1.0"
    ]
    for installName in installNameLst:
      result = packagePatchHist.getInstallationStatus(installName)
      if packagePatchHist.isNotInstalled(result):
        print ("%s installation status is %s" % (installName, "Not Installed"))
      else:
        print ("%s installation status is %s" % (installName,
               packagePatchHist.PATCH_INSTALL_STATUS_LIST[result]))

if __name__ == '__main__':
  testIsInstallCompleted()
  testMain()
