#!/usr/bin/env python
# Generate Patch Order Sequence
#
#   python PatchOrderGenerator.py <path_to_patches_dir>
#
# This script reads all the Patch files(*.KID/*.KIDs)
# and info file (*.TXT(s)/*,txt) under the input directory recursively
# and generate the Patch order via patch dependency
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

PATCH_IGNORED_DIRS = ('Packages', 'Uncategorized', 'MultiBuilds')
VALID_CSV_ORDER_FILE_FIELDS = [
    'INSTALLED', 'VERIFY_DT', 'STATUS', 'SEQ#',
    'LABELED_AS', 'CATEGORY', 'PRODUCT_NAME'
    ]

""" enums """
KIDS_BUILD_FILE_TYPE_KIDS = 0
KIDS_BUILD_FILE_TYPE_HEADER = 1
KIDS_BUILD_FILE_TYPE_SHA1 = 2

from LoggerManager import logger, initConsoleLogging
from KIDSBuildParser import KIDSBuildParser
from PatchInfoParser import PatchInfoParser
from PatchInfoParser import convertToInstallName
from PatchInfoParser import dirNameToInstallName, PatchInfo
from PatchInfoParser import setPatchInfoFromInstallName
from ConvertToExternalData import readSha1SumFromSha1File
from ConvertToExternalData import isValidKIDSBuildSuffix
from ConvertToExternalData import isValidKIDSBuildHeaderSuffix
from ConvertToExternalData import isValidKIDSBuildSha1Suffix
from ConvertToExternalData import isValidPatchInfoSuffix
from ConvertToExternalData import isValidPatchInfoSha1Suffix
from ConvertToExternalData import isValidCSVSuffix
from ConvertToExternalData import isValidPatchRelatedFiles
from ConvertToExternalData import isValidGlobalFileSuffix
from ConvertToExternalData import isValidGlobalSha1Suffix
from ConvertToExternalData import isValidPythonSuffix
from KIDSAssociatedFilesMapping import getAssociatedInstallName

"""
This class will generate a Patch order based on input
patch directory
"""
class PatchOrderGenerator(object):
  def __init__(self):
    self._kidsInstallNameDict = dict() # the install name -> kids files
    self._kidsDepBuildDict = dict() # install name -> [dependency build]
    self._multiBuildDict = dict() # kids file -> [install names]
    self._kidsBuildFileDict = dict() # all the kids files name->[path,sha1path]
    self._kidsInstallNameSha1Dict = dict() # install name -> sha1
    self._kidsInfoFileList = [] # all kids info file under vista patches dir
    self._csvOrderFileList = [] # all csv order file under vista patches dir
    self._globalFilesSet = set() # all global file under vista patches dir
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
    self._pythonScriptList = [] # all the python script files

  def generatePatchOrder(self, patchReposDir, installName=None):
      return self.generatePatchOrderTopologic(patchReposDir, installName)

  """ generate a patch seqence order by topologic sort """
  def generatePatchOrderTopologic(self, patchDir, installName=None):
    self.analyzeVistAPatchDir(patchDir)
    if installName:
      if installName not in self._patchInfoDict:
        raise Exception("Could not find patch for %s" % installName)
    self.__updatePatchDependency__((installName is None))
    self.__generatePatchDependencyGraph__()
    self.__topologicSort__(installName)
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
    self.__handlePatchAssociatedFiles__()
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
      print({"Name" : x.installName},
            {"Seq#" : x.seqNo},
            {"KIDS" : os.path.basename(x.kidsFilePath)},
            {"CSVDep" : x.csvDepPatch},
           )

  def __addKidsBuildFileToDict__(self, fileName, absPath, fileType):
    if fileName not in self._kidsBuildFileDict:
      self._kidsBuildFileDict[fileName] = [None, None]
    if ( fileType == KIDS_BUILD_FILE_TYPE_KIDS or
         fileType == KIDS_BUILD_FILE_TYPE_HEADER ):
      filePath = self._kidsBuildFileDict[fileName][0]
      if self._kidsBuildFileDict[fileName][0] != None:
        logger.error("Duplicated KIDS file path %s : %s" % (filePath, absPath))
      else:
        self._kidsBuildFileDict[fileName][0] = absPath
      return
    if fileType == KIDS_BUILD_FILE_TYPE_SHA1:
      sha1File = self._kidsBuildFileDict[fileName][1]
      if self._kidsBuildFileDict[fileName][1] != None:
        logger.error("Duplicated KIDS Sha1 File %s : %s" % (sha1File, absPath))
      else:
        self._kidsBuildFileDict[fileName][1] = absPath

  """ walk through the dir to find all KIDS build and info file and others """
  def __getAllKIDSBuildInfoAndOtherFileList__(self, patchDir):
    assert os.path.exists(patchDir)
    absPatchDir = os.path.abspath(patchDir)
    for (root, dirs, files) in os.walk(absPatchDir):
      lastDir = os.path.split(root)[-1]
      for fileName in files:
        absFilename = os.path.join(root, fileName)
        if not isValidPatchRelatedFiles(absFilename, True):
          continue
        """ Handle KIDS build files """
        if isValidKIDSBuildSuffix(fileName):
          logger.debug("Adding %s KIDS file to dict" % absFilename)
          self.__addKidsBuildFileToDict__(fileName, absFilename,
                                          KIDS_BUILD_FILE_TYPE_KIDS)
          continue
        """ Handle KIDS build HEADER files """
        if isValidKIDSBuildHeaderSuffix(fileName):
          logger.debug("Adding %s KIDS header to dict" % absFilename)
          kidsFileName = fileName[0:fileName.rfind('.')]
          self.__addKidsBuildFileToDict__(kidsFileName, absFilename,
                                          KIDS_BUILD_FILE_TYPE_HEADER)
          continue
        """ Handle KIDS build Sha1 files """
        if isValidKIDSBuildSha1Suffix(fileName):
          logger.debug("Adding %s KIDS info to dict" % absFilename)
          kidsFileName = fileName[0:fileName.rfind('.')]
          self.__addKidsBuildFileToDict__(kidsFileName, absFilename,
                                          KIDS_BUILD_FILE_TYPE_SHA1)
          continue
        """ Handle KIDS Info/Sha1 files """
        if ( isValidPatchInfoSuffix(fileName) or
             isValidPatchInfoSha1Suffix(fileName) ):
          self._kidsInfoFileList.append(absFilename)
          continue
        """ Handle Global/Sha1 Files """
        if ( isValidGlobalFileSuffix(fileName) or
             isValidGlobalSha1Suffix(fileName) ):
          logger.debug("Adding %s Global files to list" % absFilename)
          self._globalFilesSet.add(absFilename)
          continue
        """ handle all csv files """
        if isValidCSVSuffix(fileName):
          if isValidOrderCSVFile(absFilename):
            self._csvOrderFileList.append(absFilename)
            continue
        """ Handle .py files """
        if isValidPythonSuffix(fileName):
          logger.debug("Adding %s python script to list" % absFilename)
          self._pythonScriptList.append(absFilename)
          continue

    logger.info("Total # of KIDS Builds are %d" % len(self._kidsBuildFileDict))
    logger.info("Total # of KIDS Info are %d" % len(self._kidsInfoFileList))
    logger.info("Total # of Global files are %d" % len(self._globalFilesSet))
    logger.info("Total # of Python files are %d" % len(self._pythonScriptList))
    logger.info("Total # of CSV files are %d" % len(self._csvOrderFileList))

  """ parse all the KIDS files, update kidsInstallNameDict, multibuildDict """
  def __parseAllKIDSBuildFilesList__(self):
    for basename in self._kidsBuildFileDict.iterkeys():
      kidsFile, sha1Path = self._kidsBuildFileDict[basename]
      if kidsFile == None:
        logger.error("No KIDS file available for name %s" % basename)
        continue
      installNameList, seqNo, kidsBuilds = None, None, None
      if isValidKIDSBuildHeaderSuffix(kidsFile):
        from KIDSBuildParser import loadMetaDataFromJSON
        #continue
        installNameList, seqNo, kidsBuilds = loadMetaDataFromJSON(kidsFile)
      else:
        kidsParser = KIDSBuildParser(None)
        kidsParser.unregisterSectionHandler(KIDSBuildParser.ROUTINE_SECTION)
        kidsParser.parseKIDSBuild(kidsFile)
        installNameList = kidsParser.installNameList
        logger.debug("install name list is %s" % installNameList)
        seqNo = kidsParser.seqNo
        kidsBuilds = kidsParser.kidsBuilds
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
        """ handle KIDS sha1 file Path """
        if sha1Path:
          if installName in self._kidsInstallNameSha1Dict:
            logger.warn("%s is already in the dict %s" % (installName, sha1Path))
          self._kidsInstallNameSha1Dict[installName] = sha1Path
        """ update kids dependency """
        if installName in self._kidsDepBuildDict:
          logger.warn("%s is already has the dep map %s" %
                      (installName, self._kidsDepBuildDict[installName]))
        if kidsBuilds:
          for kidsBuild in kidsBuilds:
            if kidsBuild.installName == installName:
              depList = kidsBuild.dependencyList
              if depList:
                self._kidsDepBuildDict[installName] = set([x[0] for x in
                  depList])
                logger.info("%s: %s" % (installName,
                  self._kidsDepBuildDict[installName]))

    logger.debug("%s" % sorted(self._kidsInstallNameDict.keys()))
    logger.info("Total # of install name %d" % len(self._kidsInstallNameDict))

  """ parse all the KIDS info files, update patchInfoDict, missKidsBuildDict"""
  def __parseAllKIDSInfoFilesList__(self):
    kidsParser = PatchInfoParser()
    for kidsInfoFile in self._kidsInfoFileList:
      patchInfo = kidsParser.parseKIDSInfoFile(kidsInfoFile)
      if not patchInfo:
        logger.debug("invalid kids info file %s" % kidsInfoFile)
        self._invalidInfoFileSet.add(kidsInfoFile)
        continue
      """ only add to list for info that is related to a Patch"""
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
      """ update PatchInfo kidsSha1 and kidsSha1Path """
      if installName in self._kidsInstallNameSha1Dict:
        sha1Path = self._kidsInstallNameSha1Dict[installName]
        patchInfo.kidsSha1Path = sha1Path
        patchInfo.kidsSha1 = readSha1SumFromSha1File(sha1Path)
      if installName in self._patchInfoDict:
        logger.warn("duplicated installName %s, %s, %s" %
                     (installName, self._patchInfoDict[installName],
                     kidsInfoFile))
      """ merge the dependency if needed """
      if installName in self._kidsDepBuildDict:
        infoDepSet = set()
        kidsDepSet = set()
        if patchInfo.depKIDSBuild:
          infoDepSet = patchInfo.depKIDSBuild
        if self._kidsDepBuildDict[installName]:
          kidsDepSet = self._kidsDepBuildDict[installName]
        diffSet = kidsDepSet ^ infoDepSet
        if len(diffSet):
          logger.info("Merging kids dependencies %s" % installName)
          logger.debug("kids build set is %s" % kidsDepSet)
          logger.debug("info build set is %s" % infoDepSet)
          logger.warning("difference set: %s" % diffSet)
          patchInfo.depKIDSBuild = infoDepSet | kidsDepSet
        else:
          patchInfo.depKIDSBuild = infoDepSet
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
      if firstPatch.csvDepPatch is None:
        """
          If primary build install name is not specified in the csv file
          will fall back to use dependency specified in the first
          secondary build
        """
        firstPatch.csvDepPatch = patchList[installList[1]].csvDepPatch
      for index in range(1,len(installList)):
        nextPatchInfo = patchList[installList[index]]
        """ just to make sure the first one has all the dependencies """
        firstPatch.depKIDSBuild.update(nextPatchInfo.depKIDSBuild)
        firstPatch.otherKidsInfoList.append([nextPatchInfo.kidsInfoPath,
                                            nextPatchInfo.kidsInfoSha1])
        nextPatchInfo.isMultiBuilds = True
        nextPatchInfo.multiBuildsList = installList
        prevInstallName = installList[index - 1]
        if prevInstallName not in nextPatchInfo.depKIDSBuild:
          nextPatchInfo.depKIDSBuild.add(prevInstallName)
        #del patchList[installList[index]] #remove the other patch from the list
        logger.debug("%s:%s" % (nextPatchInfo.installName, nextPatchInfo.depKIDSBuild))
      """ remove the self dependencies of the first patch """
      firstPatch.depKIDSBuild.difference_update(installList)
      logger.debug("%s:%s" % (firstPatch.installName, firstPatch.depKIDSBuild))

  """ update the csvDepPatch based on csv file based dependencies """
  def __updateCSVDependencies__(self):
    for patchInfo in self._patchInfoDict.itervalues():
      installName = patchInfo.installName
      if installName in self._csvDepDict:
        patchInfo.csvDepPatch = self._csvDepDict[installName]

  def __updatePatchDependency__(self, updCSVDep=True):
    if updCSVDep:
      """ update the dependencies based on csv files """
      self.__updateCSVDependencies__()
    """ update the dependencies based on patch Sequenece # """
    self.__updateSeqNoDependencies__()
    """ update the dependencies for multi-build KIDS files """
    self.__updateMultiBuildDependencies__()

  def __updateSeqNoDependencies__(self):
    namespaceVerSeq = dict()
    patchInfoDict = self._patchInfoDict
    for patchInfo in patchInfoDict.itervalues():
      """ generate dependencies map based on seq # """
      namespace = patchInfo.namespace
      version = patchInfo.version
      seqNo = patchInfo.seqNo
      installName = patchInfo.installName
      if namespace and version:
        if not seqNo:
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
          # sorted list by sequence #
          seqOrder = sorted(seqList, key=lambda item: item[0])
          for idx in range(len(seqOrder)-1,0,-1):
            installName = seqOrder[idx][1]
            patchInfoDict[installName].depKIDSBuild.add(seqOrder[idx-1][1])

  """ now generate the dependency graph """
  def __generatePatchDependencyGraph__(self):
    depDict = self._patchDependencyDict
    namespaceVerSeq = dict()
    for patchInfo in self._patchInfoDict.itervalues():
      installName = patchInfo.installName
      if patchInfo.depKIDSBuild:
        """ reduce the node by removing info not in the current patch """
        if installName not in depDict:
          depDict[installName] = set()
        depDict[installName].update(
          [x for x in patchInfo.depKIDSBuild if x in self._patchInfoDict])
      """ combine csv dependencies """
      if patchInfo.csvDepPatch:
        if installName not in depDict:
          depDict[installName] = set()
        if patchInfo.csvDepPatch in self._patchInfoDict:
          depDict[installName].add(patchInfo.csvDepPatch)

  """ generate self._missKidsInfoSet """
  def __generateMissKIDSInfoSet__(self):
    patchInstallNameSet = set(x for x in self._patchInfoDict)
    kidsInstallNameSet = set(self._kidsInstallNameDict.keys())
    self._missKidsInfoSet = kidsInstallNameSet.difference(patchInstallNameSet)
    logger.info("Missing KIDS Info set %s" % self._missKidsInfoSet)
  """ add missing info Patch """
  def __addMissKIDSInfoPatch__(self):
    for kidsInstallName in self._missKidsInfoSet:
      logger.debug("Installation Name: %s, does not have info file, %s" %
                (kidsInstallName, self._kidsInstallNameDict[kidsInstallName]))
      patchInfo = PatchInfo()
      patchInfo.installName = kidsInstallName
      setPatchInfoFromInstallName(kidsInstallName, patchInfo)
      if kidsInstallName in self._installNameSeqMap:
        patchInfo.seqNo = self._installNameSeqMap[kidsInstallName]
      patchInfo.kidsFilePath = self._kidsInstallNameDict[kidsInstallName]
      if kidsInstallName in self._kidsDepBuildDict:
        logger.info("update the Missing Info KIDS depencency %s" %
            kidsInstallName)
        patchInfo.depKIDSBuild = self._kidsDepBuildDict[kidsInstallName]
      self._patchInfoDict[kidsInstallName] = patchInfo
  """ update the associated files for patchInfo """
  def __handlePatchAssociatedFiles__(self):
    """ handle the info files first """
    """ first by name assiciation """
    patchInfoList = self._patchInfoDict.values()
    #handle the associated files for missingKIDSBuild info
    patchInfoList.extend(self._missKidsBuildDict.values())
    for patchInfo in patchInfoList:
      infoPath = patchInfo.kidsInfoPath
      if infoPath:
        infoName = os.path.basename(infoPath)
        associateSet = set()
        for infoFile in self._invalidInfoFileSet:
          infoFileName = os.path.basename(infoFile)
          if infoFileName.startswith(infoName[:infoName.rfind('.')]):
            patchInfo.addToAssociatedInfoList(infoFile)
            associateSet.add(infoFile)
            continue
        self._invalidInfoFileSet.difference_update(associateSet)
    """ second by mapping association """
    associateSet = set()
    for infoFile in self._invalidInfoFileSet:
      installName = getAssociatedInstallName(infoFile)
      if installName:
        if installName in self._patchInfoDict:
          patchInfo = self._patchInfoDict[installName]
        #handle the associated files for missingKIDSBuild info
        elif installName in self._missKidsBuildDict:
          patchInfo = self._missKidsBuildDict[installName]
        else:
          continue
        patchInfo.addToAssociatedInfoList(infoFile)
        associateSet.add(infoFile)
    self._invalidInfoFileSet.difference_update(associateSet)

    """ handle global files """
    associateSet = set()
    for globalFile in self._globalFilesSet:
      installName = getAssociatedInstallName(globalFile)
      if installName and installName in self._patchInfoDict:
        patchInfo = self._patchInfoDict[installName]
        patchInfo.addToAssociatedGlobalList(globalFile)
        associateSet.add(globalFile)
    self._globalFilesSet.difference_update(associateSet)

    logger.info("Total # of leftover info files: %s" %
                len(self._invalidInfoFileSet))
    logger.debug(self._invalidInfoFileSet)
    logger.info("Total # of leftover global files: %s" %
                len(self._globalFilesSet))
    logger.debug(self._globalFilesSet)
  """ update PatchInfo custom installer """
  def __updateCustomInstaller__(self):
    for pythonScript in self._pythonScriptList:
      installName = os.path.basename(pythonScript)
      installName = dirNameToInstallName(installName[:installName.rfind('.')])
      if installName in self._patchInfoDict:
        patchInfo = self._patchInfoDict[installName]
        patchInfo.hasCustomInstaller = True
        if patchInfo.customInstallerPath:
          logger.warning("Duplicated installer for %s: [%s:%s]" %
                         installName, patchInfo.customInstallerPath,
                         pythonScript)

        logger.info("%s: custom installer %s" % (pythonScript, installName))
        self._patchInfoDict[installName].customInstallerPath = pythonScript

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
  def __topologicSort__(self, installName=None):
    patchDict = self._patchInfoDict
    depDict = self._patchDependencyDict
    """ new generate a set consist of patch info that does not have incoming dependency"""
    startingSet = set()
    if installName:
      startingSet.add(installName)
    else:
      startingSet = set(patchDict.iterkeys()) - reduce(set.union, depDict.itervalues(), set())
    startingList = [y.installName for y in sorted([patchDict[x] for x in startingSet],
                    cmp=comparePatchInfo)]
    visitSet = set() # store all node that are already visited
    result = []
    for item in startingList:
      visitNode(item, depDict, visitSet, result)
    self._patchOrder = [self._patchInfoDict[x] for x in result]

""" compare function for PatchInfo objects """
def comparePatchInfo(one, two):
  assert isinstance(one, PatchInfo)
  assert isinstance(two, PatchInfo)
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
  import logging
  initConsoleLogging(logging.INFO)
  patchOrderGen = PatchOrderGenerator()
  if len(sys.argv) <= 1:
    sys.stderr.write("Specify patch directory")
    sys.exit(-1)
  if len(sys.argv) == 2:
    patchOrderGen.generatePatchOrder(sys.argv[1])
  else:
    patchOrderGen.generatePatchOrder(sys.argv[1], sys.argv[2])

if __name__ == '__main__':
  testGeneratePatchOrder()
