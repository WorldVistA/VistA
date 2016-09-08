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
    connection.expect(re.compile("SORT BY:", re.I))
    connection.send("\r")
    connection.expect(re.compile("START WITH", re.I))
    connection.send("\r")
    connection.expect(re.compile("FIRST PRINT FIELD:", re.I))
    connection.send(".01\r") # fileman field# .01 is NAME
    connection.expect(re.compile("THEN PRINT FIELD:", re.I))
    connection.send("1\r") # fileman field# 1 is the PREFIX
    connection.expect(re.compile("THEN PRINT FIELD:", re.I))
    connection.send("\r")
    connection.expect(re.compile("PACKAGE LIST//", re.I))
    connection.send("\r")
    connection.expect("DEVICE:")
    connection.send(";132;99999\r")
    connection.expect("Select OPTION: ")
    self.__parseAllPackages__(connection.before)
    menuUtil.exitFileManMenu(self._testClient, waitOption=False)

  def __parseAllPackages__(self, allPackageString):
    MAX_PACKAGE_NAME_LEN = 32
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
        packageName = line[:MAX_PACKAGE_NAME_LEN].strip()
        packageNamespace = line[MAX_PACKAGE_NAME_LEN:].strip()
        self._packageMapping[packageNamespace] = packageName

  def getPackagePatchHistory(self, packageName, namespace, version=None):
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
      index  = connection.expect(["Select VERSION: [0-9.VvTtPp]+\/\/",
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
          if version:
            connection.send("%s\r" % version)
          else:
            connection.send("\r")
        else:
          connection.send("1.0\r")
        """ handle the case that same version could also have different
            history, like test version T1, T2 or V1, V2, or package does not
            have a version information (old system)
        """
        while True:
          idx = connection.expect(["Do you want to see the Descriptions\?",
                                    "CHOOSE [0-9]+-[0-9]+",
                                    "Select VERSION: ",
                                    "DEVICE:"])
          if idx == 0:
            connection.send("\r")
            continue
          elif idx == 1:
            connection.send("1\r") # always use the latest one
            continue
          elif idx == 2:
            connection.send('^\r')
            break
          elif idx ==3 :
            connection.send(";132;99999\r")
            break
        connection.expect("Select Utilities ")
        result = parsePackagePatchHistory(connection.before,
                                          packageName, namespace, version)
        break
      else:
        break
    menuUtil.exitKidsUtilMenu(self._testClient)
    if not result:
      return result
    assert result.version
    # ignore the non-floating version
    try:
      curVer = float(result.version)
    except ValueError as ve:
      return None
    if packageName not in self._packagePatchHist:
      self._packagePatchHist[packageName] = dict()
    verDict = self._packagePatchHist[packageName]
    curVer = float(result.version)
    if curVer in verDict:
      logger.info("already has hist for ver:%s, package:%s" %
                  (result.version, packageName))
    self._packagePatchHist[packageName][curVer] = result
    return result

  def getAllPatchesInstalledByTime(self, datetime):
    if not self._packageMapping:
      self.createAllPackageMapping()
    if not self._packagePatchHist:
      self.getAllPackagesPatchHistory()
    outputResult = []
    for packageName in self._packagePatchHist:
      for ver in self._packagePatchHist[packageName]:
        packageHistList = self._packagePatchHist[packageName][ver]
        patchHist = packageHistList.patchHistory
        for patchInfo in patchHist:
          if patchInfo.datetime and patchInfo.datetime > datetime:
            outputResult.append([packageHistList.namespace,
                                packageHistList.version,
                                patchInfo.patchNo,
                                patchInfo.seqNo,
                                patchInfo.datetime])
    """ sort the result """
    outputResult = sorted(outputResult, key=lambda item: item[4])
    return outputResult

  def getAllPatchInstalledAfterByTime(self, dateTime):
    """ This will search install file to find out all patches installed
        after specific time
    """
    connection = self._testClient.getConnection()
    menuUtil = VistAMenuUtil(duz=1)
    menuUtil.gotoFileManSearchFileEntryMenu(self._testClient)
    connection.send("9.7\r") # INSTALL file #
    connection.expect("-A- SEARCH FOR INSTALL FIELD: ")
    connection.send("17\r") # field # for INSTALL COMPLETE TIME
    connection.expect("-A- CONDITION: ")
    connection.send("GREATER THAN\r")
    connection.expect("-A- GREATER THAN DATE: ")
    connection.send("%s\r" % dateTime)
    connection.expect("-B- SEARCH FOR INSTALL FIELD: ")
    connection.send("\r")
    connection.expect("IF: A// ")
    connection.send("\r")
    connection.expect("STORE RESULTS OF SEARCH IN TEMPLATE: ")
    connection.send("\r")
    connection.expect([re.compile("SORT BY: ", re.I),
                       re.compile("SORT BY: NAME// ", re.I)])
    connection.send("17\r") # sort by INSTALL COMPLETE TIME
    connection.expect([re.compile("START WITH INSTALL COMPLETE TIME: ", re.I),
                       re.compile("START WITH INSTALL COMPLETE TIME: FIRST// ",re.I)])
    connection.send("\r")
    connection.expect(re.compile("WITHIN INSTALL COMPLETE TIME, SORT BY: ", re.I))
    connection.send("\r")
    connection.expect(re.compile("FIRST PRINT FIELD: ", re.I))
    connection.send("NAME\r")
    connection.expect(re.compile("THEN PRINT FIELD: ", re.I))
    connection.send("17\r")
    connection.expect(re.compile("THEN PRINT FIELD: ", re.I))
    connection.send("\r")
    connection.expect(re.compile("Heading \(S/C\): INSTALL SEARCH// ", re.I))
    connection.send("\r") # use default heading
    connection.expect("DEVICE:")
    connection.send(";132;99999\r")
    connection.expect("[0-9]+ MATCH(ES)? FOUND\.")
    result = connection.before.split("\r\n")
    output = []
    resultStart = False
    DATETIME_INDENT = 52
    for line in result:
      line = line.strip()
      if len(line) == 0:
        continue
      if resultStart:
        output.append((line[:DATETIME_INDENT].rstrip(),
                       parsePatchInstallDatetime(line[DATETIME_INDENT:])))
        continue
      if re.search('^-+$',line):
        resultStart = True
    menuUtil.exitFileManMenu(self._testClient)
    return output

  def getAllPackagesPatchHistory(self):
    self.createAllPackageMapping()
    self._packagePatchHist.clear()
    for (namespace, package) in self._packageMapping.iteritems():
      logger.info("Parsing Package %s, namespace %s" % (package, namespace))
      #if not (package[0] == "PHARMACY" and package[1] == "PS"): continue
      self.getPackagePatchHistory(package, namespace)

  def getPackagePatchHistByName(self, packageName, version=None):
    if not self._packageMapping:
      self.createAllPackageMapping()
    if not packageName:
      return None
    if packageName in self._packagePatchHist:
      result = self._getPackageHistListByVer(packageName, version)
      if result:
        return result
    for (namespace, package) in self._packageMapping.iteritems():
      if package == packageName:
        result = self.getPackagePatchHistory(package, namespace, version)
        return result
    return None

  def _getPackageHistListByVer(self, package, version):
    verDict = self._packagePatchHist[package]
    if version:
      floatVer = float(version)
      if floatVer in verDict:
        return verDict[floatVer]
      else:
        return None
    else:
      return verDict[sorted(verDict.keys(),reverse=True)[0]]

  def getPackagePatchHistByNamespace(self, namespace, version=None):
    if not self._packageMapping:
      self.createAllPackageMapping()
    if namespace in self._packageMapping:
      package = self._packageMapping[namespace]
      if package in self._packagePatchHist:
        result = self._getPackageHistListByVer(package, version)
        if result:
          return result
      result = self.getPackagePatchHistory(package, namespace, version)
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

  def getPackageNamespaceByName(self, pgkName):
    for (namespace, packageName) in self._packageMapping.iteritems():
      if pgkName == packageName:
        return namespace
    return None

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
      patchHist = self.getPackagePatchHistByNamespace(namespace, version)
    else:
      patchHist = self._getPackageHistListByVer(packageName, version)
      if not patchHist:
        patchHist = self.getPackagePatchHistByNamespace(namespace, version)
    if patchHist:
      if seqNo:
        if patchHist.hasSeqNo(seqNo):
          return True
      if patchHist.version:
        try:
          if float(patchHist.version) != float(version):
            logger.info("Diff ver %s, %s" % (patchHist.version, version))
        except Exception as ex:
          logger.error(ex)
      if patchNo:
        return patchHist.hasPatchNo(patchNo)
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
                                 re.compile("ANOTHER ONE: ", re.I),
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
  """ use Kernel KIDS API to check the installation status.
      This method might not work if install name does not
      belong to a namespace, like "ECLAIM BUNDLE 1.0".
  """
  def isPatchInstalled(self, installName):
    connection = self._testClient.getConnection()
    self._testClient.waitForPrompt()
    connection.send('W $$PATCH^XPDUTL("%s")\r' % installName)
    self._testClient.waitForPrompt()
    connection.send('\r')
    result = connection.before
    for line in result.split('\r\n'):
      line = line.strip(' \r\n')
      if re.search('^[0-1]$', line):
        try:
          if int(line) == 1:
            return True
        except ValueError as ve:
          pass
    return False

  def printPackagePatchHist(self, packageName):
    import pprint
    if packageName in self._packagePatchHist:
      print ("-----------------------------------------")
      print ("--- Package %s Patch History Info ---" % packageName)
      print ("-----------------------------------------")
      verDict = self._packagePatchHist[packageName]
      for ver in sorted(verDict.keys(), reverse=True):
        pprint.pprint(verDict[float(ver)].patchHistory)

  def printPackageLastPatch(self, packageName):
    import pprint
    if packageName in self._packagePatchHist:
      print ("-----------------------------------------")
      print ("--- Package %s Last Patch Info ---" % packageName)
      print ("-----------------------------------------")
      verDict = self._packagePatchHist[packageName]
      for ver in sorted(verDict.keys(), reverse=True):
        pprint.pprint("VERSION: %s" % ver)
        pprint.pprint(verDict[float(ver)].patchHistory[-1])

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
  def addPatchInstallLog(self, PatchInstallLog):
    self.patchHistory.append(PatchInstallLog)
  def hasPatchHistory(self):
    return len(self.patchHistory) > 0
  def setVersion(self, version):
    self.version = version
  def hasSeqNo(self, seqNo):
    for patchLog in self.patchHistory:
      if patchLog.seqNo == int(seqNo):
        return True
    return False
  def hasPatchNo(self, patchNo):
    for patchLog in self.patchHistory:
      if patchLog.patchNo == int(patchNo):
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
      patchLog = self.patchHistory[index-1]
      if patchLog.seqNo:
        return patchLog.seqNo
    return 0
  def __str__(self):
    return self.patchHistory.__str__()
  def __repr__(self):
    return self.patchHistory.__str__()

"""
a class to parse and store Patch install history info
"""
class PatchInstallLog(object):
  PATCH_HISTORY_LINE_REGEX = re.compile("^   [0-9]")
  PATCH_VERSION_LINE_REGEX = re.compile("^VERSION: [0-9.]+ ?")
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
      self.datetime = parsePatchInstallDatetime(datetimePart)
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
    return PatchInstallLog.isPatchLine(historyLine) or PatchInstallLog.isVersionLine(historyLine)
  @staticmethod
  def isPatchLine(patchLine):
    return PatchInstallLog.PATCH_HISTORY_LINE_REGEX.search(patchLine) != None
  @staticmethod
  def isVersionLine(versionLine):
    return PatchInstallLog.PATCH_VERSION_LINE_REGEX.search(versionLine) != None

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
def parsePackagePatchHistory(historyString, packageName, namespace, version):
  allLines = historyString.split('\r\n')
  patchHistoryStart = False
  result = None
  for line in allLines:
    line = line.rstrip()
    if len(line) == 0:
      continue
    if re.search("^-+$", line): # find line with '----'
      patchHistoryStart = True
      continue
    if patchHistoryStart:
      if not PatchInstallLog.isValidHistoryLine(line):
        continue
      if not result: result = PackagePatchHistory(packageName, namespace)
      patchLog = PatchInstallLog(line)
      result.addPatchInstallLog(patchLog)
      if patchLog.hasVersion():
        if version:
          try:
            if float(version) != float(patchLog.version):
              logger.error("version mismatch, %s:%s" %
                           (version, patchLog.version))
          except ValueError as ve:
            logger.error(ve)
        result.setVersion(patchLog.version)
  return result

def convertAbbreviatedMonth(dtString):
  convertLst = (('JAN', 'Jan'), ('FEB', 'Feb'), ('MAR', 'Mar'),
                ('APR', 'Apr'), ('MAY', 'May'), ('JUN', 'Jun'),
                ('JUL', 'Jul'), ('AUG', 'Aug'), ('SEP', 'Sep'),
                ('OCT', 'Oct'), ('NOV', 'Nov'), ('DEC', 'Dec'))
  for abvMon in convertLst:
    if dtString.startswith(abvMon[0]):
      return dtString.replace(abvMon[0], abvMon[1])
  return dtString

def parsePatchInstallDatetime(dtString):
  """
  Utility function to parse Patch Install Date time
  return datetime object if valid, otherwise None
  """
  outDatetime = None
  datetimeFmtLst = (
                     "%b %d, %Y@%H:%M:%S",
                     "%b %d, %Y@%H:%M",
                     "%b %d,%Y@%H:%M:%S",
                     "%b %d,%Y@%H:%M",
                     "%b %d,%Y  %H:%M",
                   )
  date_time_seperator = "@"
  for fmtStr in datetimeFmtLst:
    dtStr = convertAbbreviatedMonth(dtString)
    try:
      if dtStr.find(date_time_seperator) < 0:
        if fmtStr.find(date_time_seperator) >= 0:
          fmtStr = fmtStr[0:fmtStr.find(date_time_seperator)]
      outDatetime = datetime.strptime(dtStr, fmtStr)
    except ValueError, ve:
      pass

  if not outDatetime:
    logger.error("Can not parse datetime %s" % dtString)
  return outDatetime

"""
  get the latest version for a given package
"""

def getPackageLatestVersionByNamespace(pkgNamespace, vistATestClient):
  vistATestClient.waitForPrompt()
  conn = vistATestClient.getConnection()
  conn.send('W $$VERSION^XPDUTL("%s")\r' % pkgNamespace)
  vistATestClient.waitForPrompt()
  conn.send('\r')
  return conn.before.strip('\r\n ').split('\r\n')[-1]

""" test the fetcher class """
def testMain():
  testClient = createTestClient()
  import logging
  with testClient:
    initConsoleLogging(logging.INFO)
    packagePatchHist = VistAPackageInfoFetcher(testClient)
    packagePatchHist.getAllPackagesPatchHistory()
    packagePatchHist.getPackagePatchHistByName("TOOLKIT")
    packagePatchHist.printPackageLastPatch("TOOLKIT")
    packagePatchHist.getPackagePatchHistByNamespace("FMDC")
    packagePatchHist.printPackagePatchHist("FILEMAN DELPHI COMPONENTS")
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
  import logging
  with testClient:
    initConsoleLogging(logging.INFO)
    packagePatchHist = VistAPackageInfoFetcher(testClient)
    installNameLst = [
        "ECLAIMS 5 BUNDLE 1.0",
        "TEST 1.0",
        "XOBU 1.6",
        "LR*5.2*334",
        "XU*8.0*80",
        "TERATOGENIC MEDICATIONS ORDER CHECKS 1.0"
    ]
    for installName in installNameLst:
      result = packagePatchHist.isPatchInstalled(installName)
      if not result:
        print ("%s installation status is %s" % (installName, "Not Installed"))
      else:
        print ("%s installation status is %s" % (installName, "Installed"))
      result = packagePatchHist.getInstallationStatus(installName)
      if packagePatchHist.isNotInstalled(result):
        print ("%s installation status is %s" % (installName, "Not Installed"))
      else:
        print ("%s installation status is %s" % (installName,
               packagePatchHist.PATCH_INSTALL_STATUS_LIST[result]))

def main():
  testClient = createTestClient()
  assert testClient
  import logging
  with testClient:
    import pprint
    initConsoleLogging(logging.INFO)
    packagePatchHist = VistAPackageInfoFetcher(testClient)
    packagePatchHist.getPackagePatchHistByNamespace("DI", "22.0")
    packagePatchHist.printPackagePatchHist("VA FILEMAN")
    ver = getPackageLatestVersionByNamespace("DI", testClient)
    print "the latest version is [%s]" % ver
    output = packagePatchHist.getAllPatchesInstalledByTime(datetime(2012,8,24))
    pprint.pprint(output)
    output = packagePatchHist.getAllPatchInstalledAfterByTime("T-1000")
    pprint.pprint(output)


if __name__ == '__main__':
  testIsInstallCompleted()
  #testMain()
  main()
