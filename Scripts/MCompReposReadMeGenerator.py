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

from builtins import object
import sys
import os
import re
import argparse
import csv
from string import Template
from LoggerManager import logger, initConsoleLogging, initFileLogging
from KIDSBuildParser import checksum

HEADER_DESCRIPTION = """
This directory holds M routines and globals for a VistA package.

See `<../../README.rst>`__ for more information.
"""
DOCUMENT_SECTION = """
-------------
Documentation
-------------

Documentation for this package is available in the `VistA Document Library`_.

.. _`VistA Document Library`: http://www.va.gov/vdl/application.asp?appid=${appid}
"""

VISTA_GOLD_DISK_TXT = """
-------------------
VA Enterprise VistA
-------------------

US DVA sites standardize this package on the following routine checksums.
"""
class MCompReposReadMeGenerator(object):
  def __init__(self, inputDir, outputDir):
    self._outputFile = None
    self._inputDir = inputDir
    self._outputDir = outputDir
    self._allPackageName = set()  # store all package directory name
    self._packageVDLDict = dict()  # name => vdl app id
    self._packageNameDict = dict()  # directory => official name
    self._packageGoldDiskDict = dict() # name => gold disk info
  """
  """
  def generatePackageReadMes(self):
    self.__readFromPackageCsv__()
    for packageName in self._allPackageName:
      inputReadMePath = os.path.join(self._inputDir, "Packages",
                                packageName, "README.rst")
      outputDir = os.path.join(self._outputDir, "Packages",
                                packageName)
      if not os.path.exists(inputReadMePath):
        logger.warn("No README.rst for Package %s" % packageName)
        continue
      if not os.path.exists(outputDir):
        logger.warn("Package %s does not exist in M Repository" % packageName)
        continue
      goldSection = self.__parseGoldSectionFromReadMe__(inputReadMePath)
      if goldSection:
        self._packageGoldDiskDict[packageName] = goldSection
      self.generatePackageReadMe(packageName)
    if self._outputFile:
      self._outputFile.close()

  def generatePackageReadMe(self, packageName):
    if self._outputFile:
      self._outputFile.close()
    self._outputFile = open(os.path.join(self._outputDir,
                                         "Packages",
                                         packageName,
                                         "README.rst"), 'w')
    self.__generateHeader__(self._packageNameDict[packageName])
    if packageName in self._packageVDLDict:
      appid = self._packageVDLDict[packageName]
      self.__generateDocumentSection__(appid)
    if packageName in self._packageGoldDiskDict:
      goldDisk = self._packageGoldDiskDict[packageName]
      self.__generateGoldDiskSection__(packageName, goldDisk)

  """
    parse gold section information from README.rst
  """
  def __parseGoldSectionFromReadMe__(self, inputReadMePath):
    inGoldSection = False
    goldSection = None
    with open(inputReadMePath, 'r') as input:
      curLine = input.readline()
      while len(curLine) > 0:
        if inGoldSection:
          goldSection = self.__parseGoldSection__(input, curLine)
          return goldSection
        elif self.__isGoldSection__(input, curLine):
          inGoldSection = True
        curLine = input.readline()
    return goldSection

  def __isGoldSection__(self, input, curLine):
    if re.search('^-+$', curLine):
      nextLine = input.readline()
      if nextLine.startswith('VA Enterprise VistA'):
        if re.search('^-+$', input.readline()):
          return True
    return False

  def __parseGoldSection__(self, input, curLine):
    prevLine = curLine
    curLine = input.readline()
    goldSection = None
    curModule = None
    while len(curLine) > 0:
      if re.search('^\^+$', curLine):
        curModule = prevLine.strip(' \r\n')
        logger.debug("current module is %s" % curModule)
      elif curLine.startswith('.. table::'):
        routineData = self.__parseRoutineData__(input, curLine)
        if routineData:
          if not goldSection:
            goldSection=[]
          if curModule:
            goldSection.append((curModule, routineData))
          else:
            goldSection.append(routineData)
      prevLine = curLine
      curLine = input.readline()
    return goldSection

  def __parseRoutineData__(self, input, curLine):
    sepCount = 0
    routineData =  None
    routineSepRegex = re.compile('^ +=+ +=+$')
    while len(curLine) > 0:
      if routineSepRegex.search(curLine):
        sepCount += 1
      if sepCount == 2:
        curLine = input.readline() # read next line
        while len(curLine) > 0 and not routineSepRegex.search(curLine):
          if not routineData:
            routineData = []
          ret = re.search('^ +(?P<name>[^ ]+) +(?P<chksum>[0-9]+)$', curLine)
          if ret:
            routineData.append((ret.group('name'), int(ret.group('chksum'))))
          curLine = input.readline()
        if len(curLine) > 0:
          break
      curLine = input.readline()
    return routineData

  " section to generate the ReadMe file for each package "

  def __generateHeader__(self, packageName):
    outputFile = self._outputFile
    nameLen = len(packageName) + len("VistA: ")
    headSep = '='*nameLen
    outputFile.write("%s\n" % headSep)
    outputFile.write("VistA: %s\n" % packageName)
    outputFile.write("%s\n" % headSep)
    outputFile.write(HEADER_DESCRIPTION)

  def __generateDocumentSection__(self, appid):
    s = Template(DOCUMENT_SECTION)
    self._outputFile.write(s.substitute(appid=appid))

  def __generateGoldDiskSection__(self, packageName, section):
    if not section:
      logger.error("gold section is None")
      return
    outputFile = self._outputFile
    outputFile.write(VISTA_GOLD_DISK_TXT)
    packageDir = os.path.join(self._outputDir, "Packages",
                              packageName)
    osehraChkSumDict = generateRoutineCheckSumResult(packageDir)
    if len(section) == 1: # no submodule
      outputFile.write("\n")
      self.__writeRoutineDataAsCsvTable__(section[0], osehraChkSumDict)
    else:
      for subModule, routineData in section:
        outputFile.write("\n")
        outputFile.write("%s\n" % subModule)
        subModuleSep = "^"*(len(subModule))
        outputFile.write("%s\n" % subModuleSep)
        outputFile.write("\n")
        self.__writeRoutineDataAsCsvTable__(routineData, osehraChkSumDict)

  def __writeRoutineDataAsCsvTable__(self, routineData, osehraChkSumDict):
    f = self._outputFile
    # write csv table header
    f.write('.. csv-table::\n')
    f.write('   :header:  "Routine Source", "VA Checksum", "Current Checksum"\n')
    f.write('\n')
    for name, chksum in routineData:
      if name not in osehraChkSumDict:
        f.write('   %s.m,%s,%s\n' % (name, chksum, '(missing)'))
        continue
      osehraChksum = osehraChkSumDict[name]
      if osehraChksum == chksum:
        # @TODO write the tick later
        f.write('   `<Routines/%s.m>`__,%s,%s\n' % (name, chksum, "|check|"))
      else:
        # write the checksum directly
        f.write('   `<Routines/%s.m>`__,%s,%s\n' %
                                      (name, chksum, osehraChksum))
    f.write("\n")
    f.write(".. |check| unicode:: U+2713\n")
  def __readFromPackageCsv__(self):
    pkgDict = self._packageVDLDict
    packageCsv = os.path.join(self._inputDir, "Packages.csv")
    result = csv.DictReader(open(packageCsv, 'r'))
    for row in result:
      pkgName = row['Directory Name']
      vdlId = row['VDL ID']
      if pkgName is not None and len(pkgName) > 0:
        self._allPackageName.add(pkgName)
        self._packageNameDict[pkgName] = row['Package Name']
        if vdlId is not None and len(vdlId) > 0:
          pkgDict[pkgName] = vdlId

"""
"""
def generateRoutineCheckSumResult(packageDir):
  outputResult = dict()
  for (root, dirs, files) in os.walk(packageDir):
    for f in files:
      if not f.endswith('.m'):
        continue
      chkSum = checksum(os.path.join(root, f))
      routineName = f[0:-2]
      outputResult[routineName] = chkSum
  return outputResult

def main():
  initConsoleLogging()
  parser = argparse.ArgumentParser(
                  description='Generate VistA M Components reference repo READMEs')
  parser.add_argument('-i', '--inputDir', required=True,
                    help='path to VistA Respository')
  parser.add_argument('-o', '--outputMReposDir', required=True,
                      help='top dir of VistA M Component repository')
  parser.add_argument('-l', '--logFile', default = None,
                      help='output log file, default is no')
  result = parser.parse_args();
  logger.info (result)
  if result.logFile:
    initFileLogging(result.logFile)
  readMeGen = MCompReposReadMeGenerator(result.inputDir, result.outputMReposDir)
  readMeGen.generatePackageReadMes()

if __name__ == '__main__':
  main()
