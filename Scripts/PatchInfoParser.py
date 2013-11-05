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
from datetime import datetime
from LoggerManager import logger

""" Utility function to convert KIDS designated name to install name"""
def convertToInstallName(designationName):
  installName = designationName
  result = designationName.split("*")
  if len(result) >=2 and result[1].find(".") < 0:
    result[1] += ".0"
    installName = "*".join(result)
  elif (installName.find(' ') > 0 and
        installName.find('.') < 0):
    installName += ".0"
  return installName

""" utility function to convert installName to a valid dir Name"""
def installNameToDirName(installName):
  return installName.replace('*','_')
""" utility function to convert dirName to a installName """
def dirNameToInstallName(dirName):
  return dirName.replace('_','*')
""" Utility function to extract namespace, version, patchNo from installName"""
def extractInfoFromInstallName(installName):
  namespace, ver, patch = None, None, None
  if installName.find("*") < 0: # handle "namepsace version"
    pos = installName.rfind(' ')
    if pos >= 0:
      namespace = installName[:pos]
      ver = installName[pos+1:]
  else:
    result = installName.split('*')
    namespace = result[0]
    ver = result[1]
    if len(result) > 2:
      patch = result[2]
    else:
      patch = "0"
  return (namespace, ver, patch)

""" utility function to extract patch information from install name """
def setPatchInfoFromInstallName(installName, patchInfo):
  (namespace, ver, patch) = extractInfoFromInstallName(installName)
  logger.debug((namespace, ver, patch, installName))
  logger.debug((patchInfo))
  if patchInfo.namespace:
    if patchInfo.namespace != namespace:
      logger.error((namespace, ver, patch))
      logger.error(installName)
      logger.error(patchInfo)
  else:
    patchInfo.namespace = namespace
  if patchInfo.version:
    if (float(patchInfo.version) !=
        float(ver)):
      logger.error((namespace, ver, patch))
      logger.error(installName)
      logger.error(patchInfo)
  else:
    patchInfo.version = ver
  patchInfo.patchNo = patch

"""
a class to store all information related to a KIDS build
"""
class PatchInfo(object):
  def __init__(self):
    self.package = None
    self.namespace = None
    self.version = None
    self.patchNo = None
    self.seqNo = None
    self.installName = None
    self.kidsFilePath = None
    self.kidsSha1 = None
    self.kidsSha1Path = None
    self.kidsInfoPath = None
    self.kidsInfoSha1 = None
    self.rundate = None
    self.status = None
    self.priority = None
    """ attributes related to multibuilds """
    self.isMultiBuilds = False
    self.multiBuildsList = None
    self.otherKidsInfoList = None
    self.depKIDSBuild = set()
    """ related to custom intaller """
    self.hasCustomInstaller = False
    self.customInstallerPath = None
    """ related to FOIA dependency """
    self.csvDepPatch = None
    """ Associated Files """
    self.associatedInfoFiles = None
    self.associatedGlobalFiles = None
    """ Verified Date or release Date """
    self.verifiedDate = None
    """ Store optional dependency set """
    self.optionalDepSet = set()

  """ Utility method to add associated info file to the list """
  def addToAssociatedInfoList(self, infoFile):
    if not self.associatedInfoFiles:
      self.associatedInfoFiles = []
    self.associatedInfoFiles.append(infoFile)
  """ Utility method to add associated global file to the list """
  def addToAssociatedGlobalList(self, globalFile):
    if not self.associatedGlobalFiles:
      self.associatedGlobalFiles = []
    self.associatedGlobalFiles.append(globalFile)

  def __str__(self):
    return ("%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,"
        " %s, %s, %s, %s, %s\n%s, \ninfo:%s\nglobal:%s, %s, %s" %
             (self.package, self.namespace, self.version,
              self.patchNo, self.seqNo, self.installName,
              self.kidsFilePath, self.kidsSha1, self.kidsSha1Path,
              self.kidsInfoPath, self.kidsInfoSha1,
              self.rundate, self.status,
              self.isMultiBuilds, self.multiBuildsList, self.otherKidsInfoList,
              self.priority, self.depKIDSBuild,
              self.associatedInfoFiles, self.associatedGlobalFiles,
              self.hasCustomInstaller, self.customInstallerPath) )
  def __repr__(self):
    return self.__str__()

"""
This class will read the KIDS installation guide and extract information and
create a KIDPatch Info object
"""
class PatchInfoParser(object):
  """ Regular Expression and constants """
  RUNDATE_DESIGNATION_REGEX = re.compile(
                                "^Run Date: (?P<date>[A-Z]{3,3} [0-9][0-9], "
                                "[0-9]{4,4}) +Designation: (?P<design>.*)")
  RUNDATE_FORMAT_STRING = "%b %d, %Y"
  PACKAGE_PRIORITY_REGEX = re.compile(
                              "^Package : (?P<name>.*) Priority: (?P<pri>.*)")
  VERSION_STATUS_REGEX = re.compile(
                            "^Version : (?P<no>.*) Status: (?P<status>.*)")
  SUBJECT_PART_START_REGEX = re.compile("^Subject: ")
  ASSOCIATED_PATCH_START_REGEX = re.compile("^Associated patches: ")
  ASSOCIATED_PATCH_START_INDEX = 20
  ASSOCIATED_PATCH_SECTION_REGEX = re.compile("^ {%d,%d}\(v\)" %
                                              (ASSOCIATED_PATCH_START_INDEX,
                                               ASSOCIATED_PATCH_START_INDEX))

  def __init__(self):
    pass

  """ Parse KIDS Info File, and store result in PatchInfo
    @parameter infoFile: the path to KIDS Info file
    @return PatchInfo object if has installName, otherwise None
  """
  def parseKIDSInfoFile(self, infoFile):
    logger.debug("Parsing Info file %s" % infoFile)
    patchInfo = PatchInfo()
    assert os.path.exists(infoFile)
    patchInfo.kidsInfoPath = infoFile
    inputFile = open(infoFile, 'rb')
    for line in inputFile:
      line = line.rstrip(" \r\n")
      if len(line) == 0:
        continue
      """ subject part are treated as end of parser section for now"""
      if self.SUBJECT_PART_START_REGEX.search(line):
        break;
      ret = self.RUNDATE_DESIGNATION_REGEX.search(line)
      if ret:
        patchInfo.rundate = datetime.strptime(ret.group('date'),
                                                  self.RUNDATE_FORMAT_STRING)
        patchInfo.installName = convertToInstallName(ret.group('design'))
        continue
      ret = self.PACKAGE_PRIORITY_REGEX.search(line)
      if ret:
        package = ret.group('name').strip()
        logger.debug(package)
        (namespace, name) = package.split(" - ", 1) # split on first -
        patchInfo.namespace = namespace.strip()
        patchInfo.package = name.strip()
        patchInfo.priority = ret.group('pri').strip()
        continue
      ret = self.VERSION_STATUS_REGEX.search(line)
      if ret:
        versionInfo = ret.group('no').strip()
        pos = versionInfo.find('SEQ #')
        if pos >= 0:
          patchInfo.version = versionInfo[:pos].strip()
          patchInfo.seqNo = versionInfo[pos+5:].strip()
          try: int(patchInfo.seqNo)
          except ValueError as ex:
            logger.error("invalid seqNo %s" % patchInfo.seqNo)
            raise ex
        else:
          patchInfo.version = versionInfo.strip()
        # fix the patch version to make sure 1 => 1.0
        if (float(patchInfo.version).is_integer() and
            patchInfo.version.find('.') < 0):
          patchInfo.version += ".0"
        patchInfo.status = ret.group('status').strip()
      """ find out the dep patch info """
      ret = self.ASSOCIATED_PATCH_START_REGEX.search(line)
      if ret:
        self.parseAssociatedPart(line[self.ASSOCIATED_PATCH_START_INDEX:],
                                 patchInfo)
        continue
      ret = self.ASSOCIATED_PATCH_SECTION_REGEX.search(line)
      if ret:
        self.parseAssociatedPart(line.strip(), patchInfo)
        continue
    if patchInfo.installName == None: return None
    setPatchInfoFromInstallName(patchInfo.installName,
                                patchInfo)
    return patchInfo
  """ parsing the associated KIDS build part """
  def parseAssociatedPart(self, infoString, patchInfo):
    pos = infoString.find("<<= must be installed BEFORE")
    if pos >=0:
      installName = convertToInstallName(infoString[3:pos].strip())
      patchInfo.depKIDSBuild.add(installName)
    else:
      logger.warn(infoString)

def testPatchInfoParser():
  print ("sys.argv is %s" % sys.argv)
  if len(sys.argv) <= 1:
    print ("Need at least two arguments")
    sys.exit(-1)
  infoParser = PatchInfoParser()
  patchInfo = infoParser.parseKIDSInfoFile(sys.argv[1])
  print patchInfo

if __name__ == '__main__':
  testPatchInfoParser()
