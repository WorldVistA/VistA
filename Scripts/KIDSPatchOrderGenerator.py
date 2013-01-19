#!/usr/bin/env python
# Generate KIDS Patch Order Sequence
#
#   python KIDSPatchOrderGenerator.py <path_to_kids_patch_dir>
#
# This script reads all the KIDS patch files(*.KID/*.KIDs)
# and info file (*.TXT(s)/*,txt) under the input directory recursively
# and generate the KIDS patch order via patch dependency
#
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
import os
import sys
import re
import glob
import csv
from datetime import datetime
# append this module in the sys.path at run time
curDir = os.path.dirname(os.path.abspath(__file__))
if curDir not in sys.path:
  sys.path.append(curDir)
from LoggerManager import logger, initConsoleLogging
from KIDSPatchInfoParser import KIDSPatchInfoParser
from KIDSPatchInfoParser import convertToInstallName
from KIDSPatchInfoParser import dirNameToInstallName, KIDSPatchInfo
from KIDSPatchInfoParser import setPatchInfoFromInstallName

PATCH_IGNORED_DIRS = ('Packages', 'Uncategorized', 'MultiBuilds')
VALID_CSV_ORDER_FILE_FIELDS = [
    'INSTALLED', 'VERIFY_DT', 'STATUS', 'SEQ#',
    'LABELED_AS', 'CATEGORY', 'PRODUCT_NAME'
    ]

"""
This class will generate a KIDS Patch order based on input
patch directory
"""
class KIDSPatchOrderGenerator(object):
  def __init__(self):
    self._kidsInstallNameDict = dict() # the install name -> kids files
    self._multiBuildDict = dict() # kids file -> install name
    self._kidsBuildFileList = [] # all the kids file under vista patches dir
    self._kidsInfoFileList = [] # all kids info file under vista patches dir
    self._csvOrderFileList = [] # all csv order file under vista patches dir
    self._patchInfoDict = dict() #install name -> patchInfo
    self._missKidsBuildDict = dict() # install name -> patchInfo without Kids
    self._missKidsInfoSet = set() # kids build without info file
    self._patchOrderCSVDict = dict() # csv File -> list of patches in order
    self._patchOrder = [] # list of install name in order
    self._informationalKidsSet = set() # a list of kids that are informational
    self._notInstalledKidsSet = set() # a list of kids that are not installed
    self._patchDependencyDict = dict()  # the dependency dict of all patches
    self._invalidInfoFileSet = set() # invalid txt file
    self._csvDepDict = dict() # installName => installName based on csvFile
    self._installNameSeqMap = dict() # installName => seqNo, patch in order
    self._customInstallerMap = dict() # installName => KIDS customInstaller

  def generatePatchOrder(self, patchReposDir):
      return self.generatePatchOrderTopologic(patchReposDir)

  """ generate a patch seqence order by topologic sort """
  def generatePatchOrderTopologic(self, patchDir):
    self.analyzeVistAPatchDir(patchDir)
    self.__updatePatchDependency__()
    self.__generatePatchDependencyGraph__()
    self.__topologicSort__()
    logger.info("After topologic sort %d" % len(self._patchOrder))
    self.printPatchOrderList()
    return self._patchOrder

  """ analyze VistA patch Dir generate data structure """
  def analyzeVistAPatchDir(self, patchDir):
    assert os.path.exists(patchDir)
    self.__getAllKIDSBuildInfoAndOtherFileList__(patchDir)
    self.__parseAllKIDSBuildFilesList__()
    self.__parseAllKIDSInfoFilesList__()
    self.__generateMissKIDSInfoSet__()
    self.__addMissKIDSInfoPatch__()
    self.__updateCustomInstaller__()
    self.__getPatchOrderDependencyByCSVFiles__()

  """ Some getter function to return result """
  """ @ return all patchInfoDict install => patchInfo"""
  def getPatchInfoDict(self):
    return self._patchInfoDict
  """ @return all invalid KIDS info files set"""
  def getInvalidInfoFiles(self):
    return self._invalidInfoFileSet
  """ @return Info file without a KIDS build as install => patchInfo"""
  def getNoKidsBuildInfoDict(self):
    return self._missKidsBuildDict

  """ print the final order list """
  def printPatchOrderList(self):
    for x in self._patchOrder:
      print((x.installName, x.package, x.namespace,
             x.version, x.patchNo, x.seqNo, x.csvDepPatch))

  """ walk through the dir to find all KIDS build and info file and others """
  def __getAllKIDSBuildInfoAndOtherFileList__(self, patchDir):
    assert os.path.exists(patchDir)
    absPatchDir = os.path.abspath(patchDir)
    for (root, dirs, files) in os.walk(absPatchDir):
      for fileName in files:
        """ Handle KIDS build files """
        if (fileName.endswith(".KIDs") or
            fileName.endswith(".KID")):
          self._kidsBuildFileList.append(os.path.join(root, fileName))
          continue
        """ Handle KIDS Info files """
        if (fileName.endswith(".TXT") or
            fileName.endswith(".TXTs") or
            fileName.endswith(".txt")):
          self._kidsInfoFileList.append(os.path.join(root, fileName))
          continue
        """ Handle KIDS.py files """
        if (fileName.endswith('KIDS.py')):
          """ ignore the file directly under PATCH_IGNORED_DIRS """
          lastDir = os.path.split(root)[-1]
          if lastDir in PATCH_IGNORED_DIRS:
              continue
          installName = dirNameToInstallName(lastDir)
          self._customInstallerMap[installName] = os.path.join(root, fileName)
        """ handle all csv files """
        if (fileName.endswith('.csv')):
          csvFilePath = os.path.join(root, fileName)
          if isValidOrderCSVFile(csvFilePath):
            self._csvOrderFileList.append(csvFilePath)

    logger.info("Total # of KIDS Builds are %d" % len(self._kidsBuildFileList))
    logger.info("Total # of KIDS Info are %d" % len(self._kidsInfoFileList))
    logger.info("Total # of CSV files are %d" % len(self._csvOrderFileList))

  """ parse all the KIDS files, update kidsInstallNameDict, multibuildDict """
  def __parseAllKIDSBuildFilesList__(self):
    kidsParser = KIDSPatchInfoParser()
    for kidsFile in self._kidsBuildFileList:
      logger.debug("%s" % kidsFile)
      installNameList,seqNo = kidsParser.getKIDSBuildInstallNameSeqNo(kidsFile)
      if len(installNameList) > 1:
        if not self._multiBuildDict.get(kidsFile):
          self._multiBuildDict[kidsFile] = installNameList
        else:
          assert self._multiBuildDict[kidsFile] == installNameList
      elif seqNo:
        if installNameList[0] not in self._installNameSeqMap:
          self._installNameSeqMap[installNameList[0]] = seqNo
        else:
          logger.error("Duplicated KIDS build file %s" % kidsFile)
      for installName in installNameList:
        if installName in self._kidsInstallNameDict:
          logger.warn("%s is already in the dict %s" % (installName, kidsFile))
        logger.debug("Added installName %s, file %s" % (installName, kidsFile))
        self._kidsInstallNameDict[installName] = os.path.normpath(kidsFile)
    logger.debug("%s" % sorted(self._kidsInstallNameDict.keys()))
    logger.info("Total # of install name %d" % len(self._kidsInstallNameDict))

  """ parse all the KIDS info files, update patchInfoDict, missKidsBuildDict"""
  def __parseAllKIDSInfoFilesList__(self):
    kidsParser = KIDSPatchInfoParser()
    for kidsInfoFile in self._kidsInfoFileList:
      patchInfo = kidsParser.parseKIDSInfoFile(kidsInfoFile)
      if not patchInfo:
        logger.warn("invalid kids info file %s" % kidsInfoFile)
        self._invalidInfoFileSet.add(kidsInfoFile)
        continue
      """ only add to list for info that is related to a KIDS patch"""
      installName = patchInfo.installName
      if installName not in self._kidsInstallNameDict:
        logger.warn("no KIDS file related to %s" % patchInfo)
        if installName in self._missKidsBuildDict:
          logger.warn("duplicated kids install name")
          if kidsInfoFile != self._missKidsBuildDict[installName].kidsInfoPath:
            logger.warn("duplicated kids info file name %s" % kidsInfoFile)
          continue
        self._missKidsBuildDict[installName] = patchInfo
        continue
      patchInfo.kidsFilePath = self._kidsInstallNameDict[installName]
      assert patchInfo.kidsFilePath
      if installName in self._patchInfoDict:
        logger.warn("duplicated installName %s, %s, %s" %
                     (installName, self._patchInfoDict[installName],
                     kidsInfoFile))
      self._patchInfoDict[installName] = patchInfo

  """ update multiBuild KIDS files dependencies """
  def __updateMultiBuildDependencies__(self):
    patchList = self._patchInfoDict
    for installList in self._multiBuildDict.itervalues():
      logger.info("Multi-Buids KIDS install List: %s" % (installList))
      firstPatch = patchList[installList[0]]
      firstPatch.isMultiBuilds = True
      firstPatch.multiBuildsList = installList
      firstPatch.otherKidsInfoList = []
      for index in range(1,len(installList)):
        nextPatchInfo = patchList[installList[index]]
        """ just to make sure the first one has all the dependencies """
        firstPatch.depKIDSPatch.update(nextPatchInfo.depKIDSPatch)
        firstPatch.otherKidsInfoList.append([nextPatchInfo.kidsInfoPath,
                                            nextPatchInfo.kidsInfoSha1])
        nextPatchInfo.isMultiBuilds = True
        nextPatchInfo.multiBuildsList = installList
        prevInstallName = installList[index - 1]
        if prevInstallName not in nextPatchInfo.depKIDSPatch:
          nextPatchInfo.depKIDSPatch.add(prevInstallName)
        #del patchList[installList[index]] #remove the other patch from the list
      """ remove the self dependencies of the first patch """
      firstPatch.depKIDSPatch.difference_update(installList)
      logger.debug(firstPatch)

  """ update the csvDepPatch based on csv file based dependencies """
  def __updateCSVDependencies__(self):
    for patchInfo in self._patchInfoDict.itervalues():
      installName = patchInfo.installName
      if installName in self._csvDepDict:
        patchInfo.csvDepPatch = self._csvDepDict[installName]

  def __updatePatchDependency__(self):
    """ update the dependencies based on csv files """
    self.__updateCSVDependencies__()
    """ update the dependencies for multi-build KIDS files """
    self.__updateMultiBuildDependencies__()

  """ now generate the dependency graph """
  def __generatePatchDependencyGraph__(self):
    depDict = self._patchDependencyDict
    namespaceVerSeq = dict()
    for patchInfo in self._patchInfoDict.itervalues():
      installName = patchInfo.installName
      if patchInfo.depKIDSPatch:
        """ reduce the node by removing info not in the current patch """
        if installName not in depDict:
          depDict[installName] = set()
        depDict[installName].update(
          [x for x in patchInfo.depKIDSPatch if x in self._patchInfoDict])
      """ combine csv dependencies """
      if patchInfo.csvDepPatch:
        if installName not in depDict:
          depDict[installName] = set()
        if patchInfo.csvDepPatch in self._patchInfoDict:
          depDict[installName].add(patchInfo.csvDepPatch)
      """ generate dependencies map based on seq # """
      namespace = patchInfo.namespace
      version = patchInfo.version
      seqNo = patchInfo.seqNo
      if namespace and version:
        if not seqNo:
          if float(version) == 1.0:
            seqNo = "0"
          else:
            continue
        if namespace not in namespaceVerSeq:
          namespaceVerSeq[namespace] = dict()
        if version not in namespaceVerSeq[namespace]:
          namespaceVerSeq[namespace][version] = []
        namespaceVerSeq[namespace][version].append((int(seqNo),
                                                    installName))
    """ add dependencies based on SEQ # """
    for versionDict in namespaceVerSeq.itervalues():
      for seqList in versionDict.itervalues():
        if len(seqList) < 2:
          continue
        else:
          seqOrder = sorted(seqList, key=lambda item: item[0])
          for idx in range(len(seqOrder)-1,0,-1):
            if seqOrder[idx][1] not in depDict:
              depDict[seqOrder[idx][1]] = set()
            depDict[seqOrder[idx][1]].add(seqOrder[idx-1][1])

  """ generate self._missKidsInfoSet """
  def __generateMissKIDSInfoSet__(self):
    patchInstallNameSet = set(x for x in self._patchInfoDict)
    kidsInstallNameSet = set(self._kidsInstallNameDict.keys())
    self._missKidsInfoSet = kidsInstallNameSet.difference(patchInstallNameSet)
    logger.info("Missing KIDS Info set %s" % self._missKidsInfoSet)
  """ add missing info KIDS patch """
  def __addMissKIDSInfoPatch__(self):
    for kidsInstallName in self._missKidsInfoSet:
      logger.debug("Installation Name: %s, does not have info file, %s" %
                (kidsInstallName, self._kidsInstallNameDict[kidsInstallName]))
      kidsPatchInfo = KIDSPatchInfo()
      kidsPatchInfo.installName = kidsInstallName
      setPatchInfoFromInstallName(kidsInstallName, kidsPatchInfo)
      if kidsInstallName in self._installNameSeqMap:
        kidsPatchInfo.seqNo = self._installNameSeqMap[kidsInstallName]
      kidsPatchInfo.kidsFilePath = self._kidsInstallNameDict[kidsInstallName]
      self._patchInfoDict[kidsInstallName] = kidsPatchInfo
  """ update KIDSPatchInfo custom installer """
  def __updateCustomInstaller__(self):
    logger.debug(self._customInstallerMap)
    for installName in self._customInstallerMap:
      customInstaller = self._customInstallerMap[installName]
      self._patchInfoDict[installName].hasCustomInstaller = True
      self._patchInfoDict[installName].customInstallerPath = customInstaller

  """ get all the patch order dependency by csv files """
  def __getPatchOrderDependencyByCSVFiles__(self):
    for csvOrderFile in self._csvOrderFileList:
      self.__getPatchOrderListByCSV__(csvOrderFile)
      self.__buildPatchOrderDependencyByCSV__(csvOrderFile)

  """ build csvDepDict based on csv File """
  def __buildPatchOrderDependencyByCSV__(self, orderCSV):
    patchOrderList = self._patchOrderCSVDict[orderCSV]
    if patchOrderList is None: return
    """ some sanity check """
    outOrderList = []
    for patchOrder in patchOrderList:
      installName = patchOrder[0]
      if installName not in self._patchInfoDict:
        if (installName not in self._informationalKidsSet and
            installName not in self._kidsInstallNameDict):
          logger.warn("No KIDS file found for %s" % str(patchOrder))
        continue
      patchInfo = self._patchInfoDict[installName]
      """ check the seq no """
      seqNo = patchOrder[1]
      if len(seqNo) > 0:
        """ check the seq no match the parsing result """
        if patchInfo.seqNo is not None:
          if int(seqNo) != int(patchInfo.seqNo):
            logger.error("SeqNo mismatch for %s, from csv: %s, info %s" %
                         (installName, seqNo, patchInfo.seqNo))
        else:
          logger.info("Add seqNo %s for %s" % (seqNo, installName))
          patchInfo.seqNo = seqNo
      """ handle the case with multibuilds kids file """
      if patchInfo.isMultiBuilds:
        installList = patchInfo.multiBuildsList
        index = installList.index(installName)
        if index > 0:
          for idx in range(0, index):
            prevInstallName = installList[idx]
            prevPatchInfo = self._patchInfoDict[prevInstallName]
            if prevInstallName in self._notInstalledKidsSet:
              logger.error("%s is not installed by FOIA" % prevInstallName)
            if prevInstallName not in outOrderList:
              logger.debug("Adding %s as part of multibuilds" % prevInstallName)
              outOrderList.append(prevInstallName)
            else:
              logger.debug("%s is already in the list" % prevInstallName)
      outOrderList.append(installName)

    for idx in range(len(outOrderList)-1, 0, -1):
      installName = outOrderList[idx]
      prevInstallName = outOrderList[idx-1]
      self._csvDepDict[installName] = prevInstallName

  """ parse the order csv file and generate an ordered list of install name """
  def __getPatchOrderListByCSV__(self, orderCSV):
    """INSTALLED,VERIFY_DT,STATUS,SEQ#,LABELED_AS,CATEGORY,PRODUCT_NAME"""
    assert os.path.exists(orderCSV)
    logger.info("Parsing file: %s" % orderCSV)
    if orderCSV not in self._patchOrderCSVDict:
      self._patchOrderCSVDict[orderCSV] = []
    patchOrderList = self._patchOrderCSVDict[orderCSV]
    result = csv.DictReader(open(orderCSV, 'rb'))
    installNameSet = set() # to check possible duplicates entry
    for row in result:
      installName = convertToInstallName(row['LABELED_AS'].strip())
      if installName in installNameSet:
        logger.error("Ignore duplicate installName %s" % installName)
        continue
      installNameSet.add(installName)
      if row['INSTALLED'].strip() != "TRUE":
        self._notInstalledKidsSet.add(installName)
        if installName in self._kidsInstallNameDict:
          logger.error("Uninstalled patch %s found in %s: %s" %
                       (installName, self._kidsInstallNameDict[installName],
                        row))
        logger.debug("Ignore uninstalled patch %s" % row)
        continue
      try:
        verifiedTime = datetime.strptime(row['VERIFY_DT'], "%d-%b-%y")
      except ValueError as ex:
        logger.debug(ex)
        verifiedTime = datetime.strptime(row['VERIFY_DT'], "%Y-%m-%d")
      """ check the seq # field """
      seqNo = row['SEQ#'].strip()
      if len(seqNo) > 0:
        try: int(seqNo)
        except: seqNo = ""
      patchOrderList.append((installName, seqNo, verifiedTime))
      if re.match("^Informational$", row['CATEGORY'].strip(), re.IGNORECASE):
        logger.debug("patch is informational %s " % row)
        self._informationalKidsSet.add(installName)

  """ generate a sequence of patches that need to be applied by
      using topologic sort algorithm, also for the patch under the
      same namepsace, make sure it was applied in the right sequence
  """
  def __topologicSort__(self):
    patchDict = self._patchInfoDict
    depDict = self._patchDependencyDict
    """ new generate a set consist of patch info that does not have incoming dependency"""
    startingSet = set()
    for patch in patchDict.iterkeys():
      found = False
      for depSet in depDict.itervalues():
        if patch in depSet:
          found = True
          break;
      if not found:
        startingSet.add(patch)
    startingList = [y.installName for y in sorted([patchDict[x] for x in startingSet],
                    cmp=comparePatchInfo)]
    visitSet = set() # store all node that are already visited
    result = []
    for item in startingList:
      visitNode(item, depDict, visitSet, result)
    self._patchOrder = [self._patchInfoDict[x] for x in result]

""" compare function for KIDSPatchInfo objects """
def comparePatchInfo(one, two):
  assert isinstance(one, KIDSPatchInfo)
  assert isinstance(two, KIDSPatchInfo)
  if (one.package == two.package and
      (one.version != None and two.version != None) and
      float(one.version) == float(two.version)):
    if one.seqNo and two.seqNo:
      return cmp(int(one.seqNo), int(two.seqNo))
    if one.seqNo: return 1
    if two.seqNo: return -1
    return 0
  if one.rundate and two.rundate:
    return cmp(one.rundate, two.rundate)
  if one.rundate:
    return -1
  return 1

def visitNode(nodeName, depDict, visitSet, result):
  if nodeName in visitSet: # already visited, just return
    return
  visitSet.add(nodeName)
  for item in depDict.get(nodeName,[]):
    visitNode(item, depDict, visitSet, result)
  result.append(nodeName)

""" Utility function to check if the csv file is indeed in valid format """
def isValidOrderCSVFile(patchesCSV):
  assert os.path.exists(patchesCSV)
  validFields = VALID_CSV_ORDER_FILE_FIELDS
  patches_csv = csv.DictReader(open(patchesCSV, 'rb'))
  patchCSVHeader = patches_csv.fieldnames
  if (patchCSVHeader is None or
      len(patchCSVHeader) < len(validFields)):
    return False
  fieldSet = set(patchCSVHeader)
  if fieldSet.issuperset(validFields):
    return True
  return False

###########################################################################
####### """ Testing code section """
###########################################################################
def testGeneratePatchOrder():
  initConsoleLogging()
  kidsInfoGen = KIDSPatchOrderGenerator()
  if len(sys.argv) <= 1:
    sys.stderr.write("Specify patch directory")
    sys.exit(-1)
  kidsInfoGen.generatePatchOrder(sys.argv[1])

if __name__ == '__main__':
  testGeneratePatchOrder()
