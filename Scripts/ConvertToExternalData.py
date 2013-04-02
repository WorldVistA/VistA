#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
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

import sys
import os
import re
import tempfile
import shutil
import argparse
import glob
import stat

from LoggerManager import logger, initConsoleLogging, initFileLogging

""" constants """

EXTERNAL_DATA_SIZE_THRESHOLD = 1*1024*1024 # 1 MiB
EXTERNAL_DATA_PREFIX = ".ExternalData_SHA1_"

IGNORE_FILE_LIST = ("CMakeLists.txt")

VALID_KIDS_PATCH_SUFFIX_LIST = (".KIDs", ".KID", ".kids", ".kid")
VALID_KIDS_INFO_SUFFIX_LIST = (".TXTs",".TXT",".txt")
VALID_CSV_FILE_SUFFIX_LIST = (".csv",".CSV")
VALID_GLOBAL_FILE_SUFFIX_LIST = (".GBLs", ".GBL")
VALID_HEADER_FILE_SUFFIX_LIST = (".json",".JSON")
VALID_SHA1_FILE_SUFFIX_LIST = (".SHA1",".sha1")

VALID_KIDS_PATCH_HEADER_SUFFIX_LIST = tuple(
  [x+y for x in VALID_KIDS_PATCH_SUFFIX_LIST for y in VALID_HEADER_FILE_SUFFIX_LIST]
)

VALID_KIDS_PATCH_SHA1_SUFFIX_LIST = tuple(
  [x+y for x in VALID_KIDS_PATCH_SUFFIX_LIST for y in VALID_SHA1_FILE_SUFFIX_LIST]
)

VALID_KIDS_INFO_SHA1_SUFFIX_LIST = tuple(
  [x+y for x in VALID_KIDS_INFO_SUFFIX_LIST for y in VALID_SHA1_FILE_SUFFIX_LIST]
)

VALID_GLOBAL_SHA1_SUFFIX_LIST = tuple(
  [x+y for x in VALID_GLOBAL_FILE_SUFFIX_LIST for y in VALID_SHA1_FILE_SUFFIX_LIST]
)

"""
  Utilities functions to check if it is valid file type extension
"""
def isValidSha1Suffix(fileName):
  return fileName.endswith(VALID_SHA1_FILE_SUFFIX_LIST)

def isValidPythonSuffix(fileName):
  return fileName.endswith(".py")

def isValidKIDSPatchSuffix(fileName):
  return fileName.endswith(VALID_KIDS_PATCH_SUFFIX_LIST)

def isValidKIDSInfoSuffix(fileName):
  return fileName.endswith(VALID_KIDS_INFO_SUFFIX_LIST)

def isValidGlobalFileSuffix(fileName):
  return fileName.endswith(VALID_GLOBAL_FILE_SUFFIX_LIST)

def isValidKIDSPatchHeaderSuffix(fileName):
  return fileName.endswith(VALID_KIDS_PATCH_HEADER_SUFFIX_LIST)

def isValidKIDSPatchSha1Suffix(fileName):
  return fileName.endswith(VALID_KIDS_PATCH_SHA1_SUFFIX_LIST)

def isValidKIDSInfoSha1Suffix(fileName):
  return fileName.endswith(VALID_KIDS_INFO_SHA1_SUFFIX_LIST)

def isValidGlobalSha1Suffix(fileName):
  return fileName.endswith(VALID_GLOBAL_SHA1_SUFFIX_LIST)

def isValidCSVSuffix(fileName):
  return fileName.endswith(VALID_CSV_FILE_SUFFIX_LIST)

def isValidPatchDataSuffix(fileName, includeExternalExt=False):
  isValid = ( isValidKIDSPatchSuffix(fileName)  or
              isValidKIDSInfoSuffix(fileName)   or
              isValidGlobalFileSuffix(fileName) or
              isValidCSVSuffix(fileName)        or
              isValidPythonSuffix(fileName)
            )
  if includeExternalExt:
    isValid = isValid or (isValidKIDSPatchHeaderSuffix(fileName) or
                          isValidKIDSPatchSha1Suffix(fileName) or
                          isValidKIDSInfoSha1Suffix(fileName) or
                          isValidGlobalSha1Suffix(fileName))
  return isValid

def isValidPatchRelatedFiles(absFileName, checkExternalExt=False):
  fileName = os.path.basename(absFileName)
  # ignore files that starts with .
  if fileName.startswith('.'):
    return False
  # ignore symlink files as well
  st = os.stat(absFileName)
  if stat.S_ISLNK(st.st_mode):
    return False
  # ignore the external data file
  if fileName.startswith(EXTERNAL_DATA_PREFIX):
    return False
  if fileName in IGNORE_FILE_LIST:
    return False
  # ignore invalid file extensions
  if not isValidPatchDataSuffix(fileName, checkExternalExt):
    return False
  return True

""" utility function to check if externalData name is valid """
def isValidExternalDataFileName(fileName):
  baseName = os.path.basename(fileName)
  return baseName.startswith(EXTERNAL_DATA_PREFIX)
""" retrive sha1 hash from the filename directly """
def getSha1HashFromExternalDataFileName(fileName):
  baseName = os.path.basename(fileName)
  return baseName[len(EXTERNAL_DATA_PREFIX):]
""" generate External Data filename """
def generateExternalDataFileName(sha1Sum):
  return "%s%s" % (EXTERNAL_DATA_PREFIX, sha1Sum)

""" read the sha1Sum from sha1 file """
def readSha1SumFromSha1File(sha1File):
  with open(sha1File, "r") as input:
    return input.readline().rstrip('\r\n ')

""" add file to git ignore list
    @fileName: absolute path of the file
"""
def addToGitIgnoreList(fileName):
  rootDir = os.path.dirname(fileName)
  basename = os.path.basename(fileName)
  gitIgnoreFile = os.path.join(rootDir, ".gitignore")
  if os.path.exists(gitIgnoreFile):
    with open(gitIgnoreFile, "r") as ignoreFile:
      for line in ignoreFile:
        if line.strip(' \r\n') == basename:
          return
    with open(gitIgnoreFile, "a") as ignoreFile:
      ignoreFile.write("%s\n" % basename)
  else:
    with open(gitIgnoreFile, "w") as ignoreFile:
      ignoreFile.write("%s\n" % basename)

""" utility method to generate sha1 hash key for input file """
def generateSha1Sum(inputFilename):
  import hashlib
  assert os.path.exists(inputFilename)
  sha1sum = hashlib.sha1()
  fileSize = os.path.getsize(inputFilename)
  MAX_READ_SIZE = 20 * 1024 * 1024 # 20 MiB
  buf = fileSize/50
  if buf > MAX_READ_SIZE:
    buf = MAX_READ_SIZE
  with open(inputFilename, "r") as inputFile:
    while True:
      nByte = inputFile.read(buf)
      if nByte:
        sha1sum.update(nByte)
      else:
        break
  return sha1sum.hexdigest()

""" Convert the KIDS Build, Global or TXT file to External Data format """

class ExternalDataConverter(object):

  def __init__(self, externalDir, gitignore=False,
               sizeLimit=EXTERNAL_DATA_SIZE_THRESHOLD):
    self._externDir = None
    self._gitIgnore = gitignore
    if externalDir != None and os.path.exists(externalDir):
      self._externDir = os.path.abspath(externalDir)
    if sizeLimit <=0:
      sizeLimit = EXTERNAL_DATA_SIZE_THRESHOLD
    self._sizeLimit = sizeLimit
  """
      Convert All the files with size > than threshold under the current
      directory recursively
  """
  def convertCurrentDir(self, curDir):
    assert os.path.exists(curDir)
    absCurDir = os.path.abspath(curDir)
    for (root, dirs, files) in os.walk(absCurDir):
      for fileName in files:
        absFileName = os.path.join(root, fileName)
        if not isValidPatchRelatedFiles(absFileName):
          continue
        # get the size of the file
        fileSize = os.path.getsize(absFileName)
        if fileSize < self._sizeLimit:
          continue
        if isValidKIDSPatchSuffix(fileName):
          logger.info("converting KIDS file %s " % absFileName)
          self.convertKIDSBuildFile(absFileName)
        else:
          self.convertToSha1File(absFileName)
  """ """
  def convertKIDSBuildFile(self, kidsFile):
    from KIDSPatchParser import KIDSPatchParser, outputMetaDataInJSON
    assert os.path.exists(kidsFile)
    """ write KIDS metadata file """
    kidsParser = KIDSPatchParser(None)
    """ do not parse the routine part """
    kidsParser.unregisterSectionHandler(KIDSPatchParser.ROUTINE_SECTION)
    kidsParser.parseKIDSBuild(kidsFile)
    logger.info("output meta data as %s" % (kidsFile+".json"))
    outputMetaDataInJSON(kidsParser, kidsFile+".json")
    self.convertToSha1File(kidsFile)
  """ """
  def convertToSha1File(self, inputFile):
    assert os.path.exists(inputFile)
    """ write the sha-1 hash to the .SHA1 file """
    sha1Sum = generateSha1Sum(inputFile)
    with open(inputFile + ".sha1", "w") as output:
      output.write("%s\n" % sha1Sum)
    """ add the file to ignore list """
    if self._gitIgnore:
      addToGitIgnoreList(inputFile)
    self.__moveToExternalDir__(inputFile, sha1Sum)

  def __moveToExternalDir__(self, fileName, sha1Sum):
    assert os.path.exists(fileName)
    destFile = generateExternalDataFileName(sha1Sum)
    if self._externDir:
      destFile = os.path.join(self._externDir, destFile)
    else:
      destFile = os.path.join(os.path.dirname(fileName), destFile)
    if os.path.exists(destFile):
      if generateSha1Sum(destFile) == sha1Sum:
        os.remove(fileName)
        logger.info("%s already exists and is valid" % destFile)
        return
      os.remove(destFile)
    os.rename(fileName, destFile)


def main():
  initConsoleLogging()
  parser = argparse.ArgumentParser(
                  description='Convert Patch Data to external data format')
  parser.add_argument('-i', '--inputDir', required=True,
                    help='path to top leve directory to convert all patch data')
  parser.add_argument('-e', '--externalDataDir', required=False, default=None,
                      help='output dir to store the external data,'
                      ' default is inplace')
  parser.add_argument('-g', '--gitignore', required=False, default=False,
                      action="store_true",
                      help='Add original file to .gitignore, default is not')
  parser.add_argument('-s', '--size', default=1, type=int,
                      help='file size threshold to be converted to external '
                      'data, unit is MiB, default is 1(MiB)')
  parser.add_argument('-l', '--logFile', default=None,
                      help='output log file, default is no')
  result = parser.parse_args();
  logger.info (result)
  if result.logFile:
    initFileLogging(result.logFile)
  converter = ExternalDataConverter(result.externalDataDir, result.gitignore,
      result.size*EXTERNAL_DATA_SIZE_THRESHOLD)
  converter.convertCurrentDir(result.inputDir)

if __name__ == '__main__':
  main()
