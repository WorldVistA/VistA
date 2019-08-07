#!/usr/bin/env python
# Populate package directories.
#
#   python PopulatePatchesByPackage.py < ../Packages.csv
#
# This script reads all the Patch files(*.KID/*.KIDs)
# and info file (*.TXT(s)/*,txt) under the current directory recursively
# and populate them by Package Name according to input Packages.csv file.
#
#---------------------------------------------------------------------------
# Copyright 2012-2019 The Open Source Electronic Health Record Alliance
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
import csv
import re
# append this module in the sys.path at run time
curDir = os.path.dirname(os.path.abspath(__file__))
if curDir not in sys.path:
  sys.path.append(curDir)

from LoggerManager import logger, initConsoleLogging
from PatchOrderGenerator import PatchOrderGenerator
from PatchInfoParser import installNameToDirName
from ConvertToExternalData import addToGitIgnoreList, isValidKIDSBuildHeaderSuffix
from ConvertToExternalData import isValidSha1Suffix
from PopulatePackages import populatePackageMapByCSV, order_long_to_short

def checkPaths(source, dest):
  move = True
  curDir = os.getcwd()
  pattern = re.compile("Patches")
  # If destination path exists, do not move
  if os.path.exists(dest):
    move = False
  # If source is a patch that has already been placed, do not move
  # Check multibuilds
  if source.startswith(os.path.join(curDir, "MultiBuilds")):
    move = False
  # Check if source dir includes "Patches", eliminate the curDir to remove
  # chance that user has a folder named "Patches" in the path to VistA
  if pattern.search(source, len(curDir)):
    move = False
  return move


def place(src,dst):
    logger.info('%s => %s\n' % (src,dst))
    d = os.path.dirname(dst)
    if d and not os.path.exists(d):
        try: os.makedirs(d)
        except OSError as ex:
          logger.error(ex)
          pass
    if checkPaths(src,dst):
      try:
        os.rename(src,dst)
      except OSError as ex:
        logger.error(ex)
        logger.error( "%s => %s" % (src, dst))
        pass

def placeToDir(infoSrc, destDir, addToGitIgnore=True):
  if not infoSrc or not os.path.exists(infoSrc):
    return
  infoSrcName = os.path.basename(infoSrc)
  infoDest = os.path.join(destDir, infoSrcName)
  place(infoSrc, infoDest)
  if addToGitIgnore and isValidSha1Suffix(infoSrcName):
    addToGitIgnoreList(infoDest[:infoDest.rfind('.')])

def placeAssociatedFiles(associatedFileList, destDir):
  if associatedFileList:
    for infoSrc in associatedFileList:
      placeToDir(infoSrc, destDir)

def placePatchInfo(patchInfo, curDir, path):
  """ place the KIDS info file first if present """
  logger.debug("place patch info %s" % patchInfo)
  destDir = os.path.join(curDir, path)
  infoSrc = patchInfo.kidsInfoPath
  if infoSrc:
    placeToDir(infoSrc, destDir)
  """ place the associated files """
  placeAssociatedFiles(patchInfo.associatedInfoFiles, destDir)
  """ place the global files """
  placeAssociatedFiles(patchInfo.associatedGlobalFiles, destDir)
  """ place the custom installer file """
  placeToDir(patchInfo.customInstallerPath, destDir)

  """ ignore the multiBuilds kids file """
  if patchInfo.isMultiBuilds: return
  placeToDir(patchInfo.kidsFilePath, destDir)
  """ check the KIDS Sha1 path """
  placeToDir(patchInfo.kidsSha1Path, destDir)

#-----------------------------------------------------------------------------

def populate(input):
  packages, namespaces = populatePackageMapByCSV(input)
  #---------------------------------------------------------------------------
  # Collect all KIDS and info files under the current directory recursively
  #---------------------------------------------------------------------------
  curDir = os.getcwd()
  patchOrderGen = PatchOrderGenerator()
  patchOrder = patchOrderGen.generatePatchOrder(curDir)
  patchInfoDict = patchOrderGen.getPatchInfoDict()
  patchInfoSet = set(patchInfoDict.keys())
  patchList = list(patchInfoDict.values())
  noKidsInfoDict = patchOrderGen.getNoKidsBuildInfoDict()
  noKidsInfoSet = set(noKidsInfoDict.keys())
  noKidsPatchList = list(noKidsInfoDict.values())
  leftoverTxtFiles = patchOrderGen.getInvalidInfoFiles()
  #---------------------------------------------------------------------------
  # place multiBuilds KIDS Build under MultiBuilds directory
  #---------------------------------------------------------------------------
  multiBuildSet = set([x.installName for x in patchList if x.isMultiBuilds])
  for info in multiBuildSet:
    logger.info("Handling Multibuilds Kids %s" % info)
    patchInfo = patchInfoDict[info]
    src = patchInfo.kidsFilePath
    dest = os.path.normpath(os.path.join(curDir, "MultiBuilds",
                                         os.path.basename(src)))
    if src != dest:
      place(src,dest)
    if isValidKIDSBuildHeaderSuffix(dest):
      " add to ignore list if not there"
      addToGitIgnoreList(dest[0:dest.rfind('.')])
    src = patchInfo.kidsSha1Path
    if not src: continue
    dest = os.path.normpath(os.path.join(curDir, "MultiBuilds",
                                         os.path.basename(src)))
    if src != dest:
      place(src,dest)

  # Map by package namespace (prefix).
  for ns in sorted(list(namespaces.keys()),order_long_to_short):
    path = namespaces[ns]
    nsPatchList = [x.installName for x in patchList if x.namespace==ns]
    for patch in nsPatchList:
      logger.info("Handling Kids %s" % patch)
      patchInfo = patchInfoDict[patch]
      patchDir = os.path.join(path, "Patches", installNameToDirName(patch))
      placePatchInfo(patchInfo, curDir, patchDir)
    # Map KIDS Info Files that do not have associated KIDS Build Files
    nsNoKidsList = [x.installName for x in noKidsPatchList if x.namespace==ns]
    for patch in nsNoKidsList:
      logger.info("Handling No Kids info File %s" % patch)
      patchInfo = noKidsInfoDict[patch]
      patchDir = os.path.join(path, "Patches", installNameToDirName(patch))
      placePatchInfo(patchInfo, curDir, patchDir)
    patchInfoSet.difference_update(nsPatchList)
    noKidsInfoSet.difference_update(nsNoKidsList)

  # Put leftover kids files in Uncategorized package.
  for patch in patchInfoSet:
    logger.info("Handling left over Kids File %s" % patch)
    patchInfo = patchInfoDict[patch]
    placePatchInfo(patchInfo, curDir, 'Uncategorized')

  for patch in noKidsInfoSet:
    logger.info("Handling left over no Kids Info File %s" % patch)
    patchInfo = noKidsInfoDict[patch]
    placePatchInfo(patchInfo, curDir, 'Uncategorized')

  # Put invalid kids info files in Uncategorized package.
  for src in leftoverTxtFiles:
    logger.info("Handling left over files: %s" % src)
    from KIDSAssociatedFilesMapping import getAssociatedInstallName
    installName = getAssociatedInstallName(src)
    if installName == "MultiBuilds": # put in Multibuilds directory
      dest = os.path.normpath(os.path.join(curDir, "MultiBuilds",
                                           os.path.basename(src)))
      if src != dest:
        place(src,dest)
      continue
    dirName = os.path.dirname(src)
    if not dirName.endswith("Packages"):
      logger.debug("Do not move %s" % src)
      continue
    dest = os.path.normpath(os.path.join(curDir, 'Uncategorized',
                                         os.path.basename(src)))
    if src != dest:
      place(src,dest)

def main():
  import logging
  initConsoleLogging(logging.INFO)
  populate(sys.stdin)

if __name__ == '__main__':
  main()
