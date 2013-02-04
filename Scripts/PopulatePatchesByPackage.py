#!/usr/bin/env python
# Populate package directories.
#
#   python PopulatePatchesByPackage.py < ../Packages.csv
#
# This script reads all the KIDS patch files(*.KID/*.KIDs)
# and info file (*.TXT(s)/*,txt) under the current directory recursively
# and populate them by Package Name according to input Packages.csv file.
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
from __future__ import with_statement
import sys
import os
import csv
# append this module in the sys.path at run time
curDir = os.path.dirname(os.path.abspath(__file__))
if curDir not in sys.path:
  sys.path.append(curDir)

from LoggerManager import logger, initConsoleLogging
from KIDSPatchOrderGenerator import KIDSPatchOrderGenerator
from KIDSPatchInfoParser import installNameToDirName

class Package:
    def __init__(self, name, path):
        self.name = name
        self.path = path.strip().replace('/',os.path.sep)
        self.included = set()
        self.excluded = set()
        self.globals = set()
    def add_namespace(self, ns):
        if ns:
            if ns[0] in ('-','!'):
                self.excluded.add(ns[1:])
            else:
                self.included.add(ns)
    def add_number(self, n):
        if n:
            if n[0] == '.':
                n = '0' + n
            self.globals.add(n) # numbers work just like globals
    def add_global(self, g):
        if g:
            self.globals.add(g)

def order_long_to_short(l,r):
    if len(l) > len(r):
        return -1
    elif len(l) < len(r):
        return +1
    else:
        return cmp(l,r)

def place(src,dst):
    logger.info('%s => %s\n' % (src,dst))
    d = os.path.dirname(dst)
    if d and not os.path.exists(d):
        try: os.makedirs(d)
        except OSError as ex:
          logger.error(ex)
          pass
    if not os.path.exists(dst):
      try:
        os.rename(src,dst)
      except OSError as ex:
        logger.error(ex)
        logger.error( "%s => %s" % (src, dst))
        pass

def placePatchInfo(patchInfo, curDir, path, associatedTxtSet=None):
  """ place the KIDS info file first if present """
  logger.debug("place patch info %s" % patchInfo)
  infoSrc = patchInfo.kidsInfoPath
  if infoSrc:
    infoSrcName = os.path.basename(infoSrc)
    infoDestDir = os.path.join(curDir, path)
    infoDest = os.path.join(infoDestDir, infoSrcName)
    if infoDest != infoSrc:
      place(infoSrc, infoDest)
    # handle the associated txt file
    if associatedTxtSet:
      outList = getAssociatedInfoFile(infoSrcName, associatedTxtSet)
      if outList:
        for file in outList:
          fileDest = os.path.join(infoDestDir, os.path.basename(file))
          place(file, fileDest)
          associatedTxtSet.remove(file)
  """ ignore the multiBuilds kids file """
  if patchInfo.isMultiBuilds: return
  kidsSrc = patchInfo.kidsFilePath
  if not kidsSrc: return
  kidsDest = os.path.normpath(os.path.join(curDir, path,
                              os.path.basename(kidsSrc)))
  if kidsSrc != kidsDest:
    place(kidsSrc, kidsDest)

def getAssociatedInfoFile(infoFileName, associatedTxtSet):
  fileList = None
  for file in associatedTxtSet:
    fileName = os.path.basename(file)
    if fileName.startswith(infoFileName[:infoFileName.rfind('.')]):
      if not fileList:
        fileList = []
      fileList.append(file)
  return fileList
#-----------------------------------------------------------------------------

def populate(input):
  packages_csv = csv.DictReader(input)
  # Parse packages and namespaces from CSV table on stdin.
  packages = []
  pkg = None
  for fields in packages_csv:
      if fields['Package Name']:
          pkg = Package(fields['Package Name'], fields['Directory Name'])
          packages.append(pkg)
      if pkg:
          pkg.add_namespace(fields['Prefixes'])
          pkg.add_number(fields['File Numbers'])
          pkg.add_global(fields['Globals'])

  # Construct "namespace => path" map.
  namespaces = {}
  for p in packages:
      for ns in p.included:
          namespaces[ns] = p.path
      for ns in p.excluded:
          if not namespaces.has_key(ns):
              namespaces[ns] = None

  #---------------------------------------------------------------------------
  # Collect all KIDS and info files under the current directory recursively
  #---------------------------------------------------------------------------
  curDir = os.getcwd()
  kidsOrderGen = KIDSPatchOrderGenerator()
  patchOrder = kidsOrderGen.generatePatchOrder(curDir)
  patchOrderList = [x.installName for x in patchOrder]
  patchInfoDict = kidsOrderGen.getPatchInfoDict()
  patchInfoSet = set(patchInfoDict.keys())
  patchList = patchInfoDict.values()
  noKidsInfoDict = kidsOrderGen.getNoKidsBuildInfoDict()
  noKidsInfoSet = set(noKidsInfoDict.keys())
  noKidsPatchList = noKidsInfoDict.values()
  leftoverTxtFiles = kidsOrderGen.getInvalidInfoFiles()
  #---------------------------------------------------------------------------
  # place multiBuilds KIDS patch under MultiBuilds directory
  #---------------------------------------------------------------------------
  multiBuildSet = set([x.installName for x in patchList if x.isMultiBuilds])
  for info in multiBuildSet:
    patchInfo = patchInfoDict[info]
    src = patchInfo.kidsFilePath
    dest = os.path.normpath(os.path.join(curDir, "MultiBuilds",
                                         os.path.basename(src)))
    if src != dest:
      place(src,dest)

  # Map by package namespace (prefix).
  for ns in sorted(namespaces.keys(),order_long_to_short):
    path = namespaces[ns]
    nsPatchList = [x.installName for x in patchList if x.namespace==ns]
    for patch in nsPatchList:
      logger.info("Handling Kids %s" % patch)
      patchInfo = patchInfoDict[patch]
      patchDir = os.path.join(path, "Patches", installNameToDirName(patch))
      placePatchInfo(patchInfo, curDir, patchDir, leftoverTxtFiles)
    # Map KIDS Info Files that do not have associated KIDS Build Files
    nsNoKidsList = [x.installName for x in noKidsPatchList if x.namespace==ns]
    for patch in nsNoKidsList:
      logger.info("Handling No Kids info File %s" % patch)
      patchInfo = noKidsInfoDict[patch]
      patchDir = os.path.join(path, "Patches", installNameToDirName(patch))
      placePatchInfo(patchInfo, curDir, patchDir, leftoverTxtFiles)
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
    dirName = os.path.dirname(src)
    if not dirName.endswith("Packages"):
      logger.debug("Do not move %s" % src)
      continue
    dest = os.path.normpath(os.path.join(curDir, 'Uncategorized',
                                         os.path.basename(src)))
    if src != dest:
      place(src,dest)

def main():
  initConsoleLogging()
  populate(sys.stdin)

if __name__ == '__main__':
  main()
