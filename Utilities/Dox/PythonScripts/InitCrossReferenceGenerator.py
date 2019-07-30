# ---------------------------------------------------------------------------
# Copyright 2018 The Open Source Electronic Health Record Alliance
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
# ---------------------------------------------------------------------------

import glob
import re
import csv
import os
import sys
import argparse

FILE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(FILE_DIR, "../../../Scripts"))
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)

from CrossReference import CrossReference, Routine, Package, Global, PlatformDependentGenericRoutine
from LogManager import logger

A_ROUTINE_EX = re.compile("^A[0-9][^ ]+$")
ZWR_FILENO_REGEX = re.compile("(?P<fileNo>^[0-9.]+)(-1)?\+(?P<des>.*)\.zwr$")
ZWR_NAMESPACE_REGEX = re.compile("(?P<namespace>^[^.]+)\.zwr$")

fileNoPackageMappingDict = {"18.02":"Web Services Client",
                   "18.12":"Web Services Client",
                   "18.13":"Web Services Client",
                   "52.87":"Outpatient Pharmacy",
                   "59.73":"Pharmacy Data Management",
                   "59.74":"Pharmacy Data Management"
                   }


def getVDLHttpLinkByID(vdlId):
  return "https://www.va.gov/vdl/application.asp?appid=%s" % vdlId

class InitCrossReferenceGenerator(object):
  def __init__(self):
    self.crossRef = CrossReference()

  @property
  def crossReference(self):
    return self.crossRef

  def parsePercentRoutineMappingFile(self, mappingFile):
    result = csv.DictReader(open(mappingFile, "rb"))
    for row in result:
      self.crossRef.addPercentRoutineMapping(row['Name'],
                                             row['Source'],
                                             row['Package'])

  def parsePackagesFile(self, packageFilename):
    result = csv.DictReader(open(packageFilename, 'rb'))
    crossRef = self.crossRef
    currentPackage = None
    index = 0
    for row in result:
      packageName = row['Directory Name']
      if packageName:
        currentPackage = crossRef.getPackageByName(packageName)
        if not currentPackage:
          crossRef.addPackageByName(packageName)
        currentPackage = crossRef.getPackageByName(packageName)
        currentPackage.setOriginalName(row['Package Name'])
        vdlId = row['VDL ID']
        if vdlId and len(vdlId):
          currentPackage.setDocLink(getVDLHttpLinkByID(vdlId))
      else:
        if not currentPackage:
          logger.warn("row is not under any package: %s" % row)
          continue
      if len(row['Prefixes']):
        currentPackage.addNamespace(row['Prefixes'])
      if len(row['Globals']):
        currentPackage.addGlobalNamespace(row['Globals'])
    logger.info("Total # of Packages is %d" % (len(crossRef.getAllPackages())))

  def parsePlatformDependentRoutineFile(self, routineCSVFile):
    routineFile = open(routineCSVFile, "rb")
    sniffer = csv.Sniffer()
    dialect = sniffer.sniff(routineFile.read(1024))
    routineFile.seek(0)
    hasHeader = sniffer.has_header(routineFile.read(1024))
    routineFile.seek(0)
    result = csv.reader(routineFile, dialect)
    currentName = ""
    routineDict = dict()
    crossRef = self.crossRef
    index = 0
    for line in result:
      if hasHeader and index == 0:
        index += 1
        continue
      if line[0]:
        currentName = line[0]
        if line[0] not in routineDict:
            routineDict[currentName] = []
        routineDict[currentName].append(line[-1])
      routineDict[currentName].append([line[1], line[2]])
    for (routineName, mappingList) in routineDict.iteritems():
      crossRef.addPlatformDependentRoutineMapping(routineName,
                                                  mappingList[0],
                                                  mappingList[1:])

#===============================================================================
# Find all globals by source zwr and package.csv files version v2
#===============================================================================
  def findGlobalsBySourceV2(self, dirName, pattern):
    searchFiles = glob.glob(os.path.join(dirName, pattern))
    logger.info("Total Search Files are %d " % len(searchFiles))
    crossReference = self.crossRef
    allGlobals = crossReference.getAllGlobals()
    allPackages = crossReference.getAllPackages()
    skipFile = []
    fileNoSet = set()
    for file in searchFiles:
      packageName = os.path.dirname(file)
      packageName = packageName[packageName.index("Packages") + 9:packageName.index("Globals") - 1]
      if not crossReference.hasPackage(packageName):
        crossReference.addPackageByName(packageName)
      package = allPackages.get(packageName)
      zwrFile = open(file, 'r')
      lineNo = 0
      fileName = os.path.basename(file)
      result = ZWR_FILENO_REGEX.search(fileName)
      if result:
        fileNo = result.group('fileNo')
        if fileNo.startswith('0'): fileNo = fileNo[1:]
        globalDes = result.group('des')
      else:
        result = ZWR_NAMESPACE_REGEX.search(fileName)
        if result:
            namespace = result.group('namespace')
#                    package.addGlobalNamespace(namespace)
            continue
        else:
            continue
      globalName = "" # find out the global name by parsing the global file
      logger.debug("Parsing file: %s" % file)
      for line in zwrFile:
        if lineNo == 0:
          globalDes = line.strip()
          # Removing the extra text in the header of the ZWR file
          # to tell if it needs to be added or skipped
          globalDes = globalDes.replace("OSEHRA ZGO Export: ",'')
          if globalDes.startswith("^"):
            logger.info("No Description: Skip this file: %s" % file)
            skipFile.append(file)
            namespace = globalDes[1:]
            package.addGlobalNamespace(namespace)
            break
        if lineNo >= 2:
          info = line.strip().split('=')
          globalName = info[0]
          detail = info[1].strip("\"")
          if globalName.find(',') > 0:
              result = globalName.split(',')
              if len(result) == 2 and result[1] == "0)":
                  globalName = result[0]
                  break
          elif globalName.endswith("(0)"):
              globalName = globalName.split('(')[0]
              break
          else:
              continue
        lineNo = lineNo + 1
      if not fileNo:
        if file not in skipFile:
          logger.warn("Warning: No FileNo found for file %s" % file)
        continue
      globalVar = Global(globalName, fileNo, globalDes,
                         allPackages.get(packageName))
      try:
        fileNum = float(globalVar.getFileNo())
      except ValueError, es:
        logger.error("error: %s, globalVar:%s file %s" % (es, globalVar, file))
        continue
#            crossReference.addGlobalToPackage(globalVar, packageName)
      # only add to allGlobals dict as we have to change the package later on
      if globalVar.getName() not in allGlobals:
        allGlobals[globalVar.getName()] = globalVar
      if fileNo not in fileNoSet:
        fileNoSet.add(fileNo)
      else:
        logger.error("Duplicated file No [%s,%s,%s,%s] file:%s " %
                      (fileNo, globalName, globalDes, packageName, file))
      zwrFile.close()
    logger.info("Total # of Packages is %d and Total # of Globals is %d, Total Skip File %d, total FileNo is %d" %
           (len(allPackages), len(allGlobals), len(skipFile), len(fileNoSet)))

    sortedKeyList = sorted(allGlobals.keys(),
                         key=lambda item: float(allGlobals[item].getFileNo()))
    for key in sortedKeyList:
      globalVar = allGlobals[key]
      # fix the uncategoried item
      if globalVar.getFileNo() in fileNoPackageMappingDict:
          globalVar.setPackage(allPackages[fileNoPackageMappingDict[globalVar.getFileNo()]])
      crossReference.addGlobalToPackage(globalVar,
                                        globalVar.getPackage().getName())

  #===========================================================================
  # find all the package name and routines by reading the repository directory
  #===========================================================================
  def findPackagesAndRoutinesBySource(self, dirName, pattern):
    searchFiles = glob.glob(os.path.join(dirName, pattern))
    logger.info("Total Search Files are %d " % len(searchFiles))
    allRoutines = self.crossRef.getAllRoutines()
    allPackages = self.crossRef.getAllPackages()
    crossReference = self.crossRef
    for file in searchFiles:
      routineName = os.path.basename(file).split(".")[0]
      needRename = crossReference.routineNeedRename(routineName)
      if needRename:
        origName = routineName
        routineName = crossReference.getRenamedRoutineName(routineName)
      if crossReference.isPlatformDependentRoutineByName(routineName):
        continue
      packageName = os.path.dirname(file)
      packageName = packageName[packageName.index("Packages") + 9:packageName.index("Routines") - 1]
      crossReference.addRoutineToPackageByName(routineName, packageName)
      if needRename:
        routine = crossReference.getRoutineByName(routineName)
        assert(routine)
        routine.setOriginalName(origName)
      if A_ROUTINE_EX.search(routineName):
        pass
    logger.info("Total package is %d and Total Routines are %d" %
                (len(allPackages), len(allRoutines)))

def parseCrossRefGeneratorWithArgs(args):
  return parseCrossReferenceGeneratorArgs(args.MRepositDir,
                                          args.patchRepositDir)

def parseCrossReferenceGeneratorArgs(MRepositDir,
                                     patchRepositDir):
  DoxDir = 'Utilities/Dox'

  crossRefGen = InitCrossReferenceGenerator()
  percentMapFile = os.path.join(patchRepositDir, DoxDir,
                                "PercentRoutineMapping.csv")
  crossRefGen.parsePercentRoutineMappingFile(percentMapFile)
  crossRefGen.parsePackagesFile(os.path.join(MRepositDir,
                                               "Packages.csv"))
  platformDepRtnFile = os.path.join(patchRepositDir, DoxDir,
                                "PlatformDependentRoutine.csv")
  crossRefGen.parsePlatformDependentRoutineFile(platformDepRtnFile)
  crossRefGen.findGlobalsBySourceV2(os.path.join(MRepositDir,
                                                   "Packages"),
                                      "*/Globals/*.zwr")
  crossRefGen.findPackagesAndRoutinesBySource(os.path.join(MRepositDir,
                                                           "Packages"),
                                                "*/Routines/*.m")

  return crossRefGen.crossReference

def createInitialCrossRefGenArgParser():
    parser = argparse.ArgumentParser(add_help=False) # no help page
    argGroup = parser.add_argument_group(
                              'Initial CrossReference Generator Arguments',
                              "Argument for generating initial CrossReference")
    argGroup.add_argument('-mr', '--MRepositDir', required=True,
                          help='VistA M Component Git Repository Directory')
    argGroup.add_argument('-pr', '--patchRepositDir', required=True,
                          help="VistA Git Repository Directory")
    return parser
