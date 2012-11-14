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
  if installName.find("*") < 0: # handle namepsace 1.0
    result = re.match("^(?P<namespace>[A-Z]+) (?P<ver>[1-9][0-9]?\.[0-9])$", installName)
    if result:
      namespace = result.group('namespace')
      ver = result.group('ver')
      patch = None
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
def setPatchInfoFromInstallName(installName, kidsPatchInfo):
  (namespace, ver, patch) = extractInfoFromInstallName(installName)
  logger.debug((namespace, ver, patch, installName))
  logger.debug((kidsPatchInfo))
  if kidsPatchInfo.namespace:
    if kidsPatchInfo.namespace != namespace:
      logger.error((namespace, ver, patch))
      logger.error(installName)
      logger.error(kidsPatchInfo)
  else:
    kidsPatchInfo.namespace = namespace
  if kidsPatchInfo.version:
    if (float(kidsPatchInfo.version) !=
        float(ver)):
      logger.error((namespace, ver, patch))
      logger.error(installName)
      logger.error(kidsPatchInfo)
  else:
    kidsPatchInfo.version = ver
  kidsPatchInfo.patchNo = patch

"""
a class to store all information related to a KIDS build
"""
class KIDSPatchInfo(object):
  def __init__(self):
    self.package = None
    self.namespace = None
    self.version = None
    self.patchNo = None
    self.seqNo = None
    self.installName = None
    self.kidsFilePath = None
    self.kidsSha1 = None
    self.kidsInfoPath = None
    self.kidsInfoSha1 = None
    self.rundate = None
    self.status = None
    self.priority = None
    """ attributes related to multibuilds """
    self.isMultiBuilds = False
    self.multiBuildsList = None
    self.otherKidsInfoList = None
    self.depKIDSPatch = set()
    """ related to custom intaller """
    self.hasCustomInstaller = False
    self.customInstallerPath = None
  def __str__(self):
    return ("%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,"
            " %s, %s, %s, %s\n%s" %
             (self.package, self.namespace, self.version,
              self.patchNo, self.seqNo, self.installName,
              self.kidsFilePath, self.kidsSha1,
              self.kidsInfoPath, self.kidsInfoSha1,
              self.rundate, self.status,
              self.isMultiBuilds, self.multiBuildsList, self.otherKidsInfoList,
              self.priority, self.depKIDSPatch) )
  def __repr__(self):
    return self.__str__()

"""
This class will read the KIDS installation guide and extract information and
create a KIDPatch Info object
"""
class KIDSPatchInfoParser(object):
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

  """ one KIDS file can contains several kids build together
      get the KIDS Install Name from KIDS Build File and also
      the SeqNo if available
      @parameter kidsFile: path to KIDS Patch Build
      @return: a tuple consists of a list of installNames
         and seqNo if available
  """
  def getKIDSBuildInstallNameSeqNo(self, kidsFile):
    assert os.path.exists(kidsFile)
    kidsFileHandle = open(kidsFile, 'rb')
    installNames, seqNo = None, None
    for line in kidsFileHandle:
      line = line.rstrip(" \r\n")
      if len(line) == 0:
        continue
      ret = re.search("Released (.*) SEQ #(?P<num>[0-9]+)",line)
      if ret:
        seqNo = ret.group('num')
        continue
      ret = re.search('^\*\*KIDS\*\*:(?P<name>.*)\^$', line)
      if ret:
        installNames = ret.group('name').strip().split('^')
        break
    kidsFileHandle.close()
    return (installNames, seqNo)

  """ Parse KIDS Info File, and store result in KIDSPatchInfo
    @parameter infoFile: the path to KIDS Info file
    @return KIDSPatchInfo object if has installName, otherwise None
  """
  def parseKIDSInfoFile(self, infoFile):
    kidsPatchInfo = KIDSPatchInfo()
    assert os.path.exists(infoFile)
    kidsPatchInfo.kidsInfoPath = infoFile
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
        kidsPatchInfo.rundate = datetime.strptime(ret.group('date'),
                                                  self.RUNDATE_FORMAT_STRING)
        kidsPatchInfo.installName = convertToInstallName(ret.group('design'))
        continue
      ret = self.PACKAGE_PRIORITY_REGEX.search(line)
      if ret:
        package = ret.group('name').strip()
        logger.debug(package)
        (namespace, name) = package.split(" - ", 1) # split on first -
        kidsPatchInfo.namespace = namespace.strip()
        kidsPatchInfo.package = name.strip()
        kidsPatchInfo.priority = ret.group('pri').strip()
        continue
      ret = self.VERSION_STATUS_REGEX.search(line)
      if ret:
        versionInfo = ret.group('no').strip()
        pos = versionInfo.find('SEQ #')
        if pos >= 0:
          kidsPatchInfo.version = versionInfo[:pos].strip()
          kidsPatchInfo.seqNo = versionInfo[pos+5:].strip()
          try: int(kidsPatchInfo.seqNo)
          except ValueError as ex:
            logger.error("invalid seqNo %s" % kidsPatchInfo.seqNo)
            raise ex
        else:
          kidsPatchInfo.version = versionInfo.strip()
        # fix the kidsPatch version to make sure 1 => 1.0
        if (float(kidsPatchInfo.version).is_integer() and
            kidsPatchInfo.version.find('.') < 0):
          kidsPatchInfo.version += ".0"
        kidsPatchInfo.status = ret.group('status').strip()
      """ find out the dep patch info """
      ret = self.ASSOCIATED_PATCH_START_REGEX.search(line)
      if ret:
        self.parseAssociatedPart(line[self.ASSOCIATED_PATCH_START_INDEX:],
                                 kidsPatchInfo)
        continue
      ret = self.ASSOCIATED_PATCH_SECTION_REGEX.search(line)
      if ret:
        self.parseAssociatedPart(line.strip(), kidsPatchInfo)
        continue
    if kidsPatchInfo.installName == None: return None
    setPatchInfoFromInstallName(kidsPatchInfo.installName,
                                kidsPatchInfo)
    return kidsPatchInfo
  """ parsing the associated KIDS build part """
  def parseAssociatedPart(self, infoString, kidsPatchInfo):
    pos = infoString.find("<<= must be installed BEFORE")
    if pos >=0:
      patchInfo = convertToInstallName(infoString[3:pos].strip())
      kidsPatchInfo.depKIDSPatch.add(patchInfo)
    else:
      logger.warn(infoString)

def testKIDSInfoParser():
  print ("sys.argv is %s" % sys.argv)
  if len(sys.argv) <= 1:
    print ("Need at least two arguments")
    sys.exit(-1)
  kidsInfoParser = KIDSPatchInfoParser()
  patchInfo = kidsInfoParser.parseKIDSInfoFile(sys.argv[1])
  print patchInfo

if __name__ == '__main__':
  testKIDSInfoParser()
