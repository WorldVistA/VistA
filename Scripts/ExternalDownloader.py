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
from future import standard_library
standard_library.install_aliases()
from builtins import object
import sys
import os
import urllib.request, urllib.parse, urllib.error
from LoggerManager import logger, initConsoleLogging
from ConvertToExternalData import generateExternalDataFileName
from ConvertToExternalData import generateSha1Sum

"""
   Download External Data
"""

DEFAULT_EXTERNAL_DOWNLOAD_SITE_URL = "http://code.osehra.org/content/SHA1"

""" find or download the external KIDS Build file, return the file path """
def obtainKIDSBuildFileBySha1(filePath, sha1Sum, cacheDir):
  assert cacheDir and os.path.exists(cacheDir)
  rootDir = os.path.dirname(filePath)
  externalFileName = generateExternalDataFileName(sha1Sum)
  externalFile = os.path.join(rootDir, externalFileName)
  logger.info("Checking %s" % externalFile)
  if os.path.exists(externalFile):
    if generateSha1Sum(externalFile) == sha1Sum:
      return (True, externalFile)
    else:
      os.remove(externalFile)
  """ try to find the file in the cache dir """
  externalFile = os.path.join(cacheDir, externalFileName.replace('_','/'))
  logger.info("Checking %s" % externalFile)
  if os.path.exists(externalFile):
    if generateSha1Sum(externalFile) == sha1Sum:
      return (True, externalFile)
    else:
      os.remove(externalFile)
  """ make sure cacheDir has the right layout """
  rootDir = os.path.dirname(externalFile)
  if not os.path.exists(rootDir):
    os.makedirs(rootDir)
  """ download from remote """
  extDownloader = ExternalDataDownloader()
  logger.info("Downloading from remote link")
  result = extDownloader.downloadExternalDataByHash(sha1Sum, externalFile)
  if not result:
    logger.error("Downloading from remote failed")
    if os.path.exists(externalFile):
      os.remove(externalFile)
    externalFile = None
  logger.info("%s, %s" % (result, externalFile))
  return (result, externalFile)

class ExternalDataDownloader(object):

  def __init__(self, siteUrl=DEFAULT_EXTERNAL_DOWNLOAD_SITE_URL):
    self._siteUrl = siteUrl
  """
  """
  @staticmethod
  def downloadExternalDataDirectly(dwnUrl, fileToSave):
    try:
      urllib.request.urlretrieve(dwnUrl, fileToSave)
      return True
    except Exception as ex:
      logger.error(ex)
    return False
  """
  """
  def downloadExternalDataByHash(self, sha1Sum, fileToSave):
    dwnUrl = "%s/%s" % (self._siteUrl, sha1Sum)
    if not self.downloadExternalDataDirectly(dwnUrl, fileToSave):
      return False
    """ verify the sha1sum of downloaded file """
    sha1SumDwn = generateSha1Sum(fileToSave)
    if sha1Sum == sha1SumDwn:
      return True
    logger.error("sha1Sum mismatch %s:%s" % (sha1Sum, sha1SumDwn))
    os.remove(fileToSave)

def main():
  initConsoleLogging()
  # testing the PatchFileBySha1
  logger.info(sys.argv)
  PatchFileBySha1(sys.argv[1], sys.argv[2], sys.argv[3])

def downloadAllKIDSSha1File(topDir, cacheDir):
  from ConvertToExternalData import isValidKIDSBuildSha1Suffix
  from ConvertToExternalData import readSha1SumFromSha1File
  import shutil
  initConsoleLogging()
  absCurDir = os.path.abspath(topDir)
  for (root, dirs, files) in os.walk(absCurDir):
    for f in files:
      if not isValidKIDSBuildSha1Suffix(f):
        continue
      filePath = os.path.join(root, f)
      sha1Sum = readSha1SumFromSha1File(filePath)
      result, extFilePath = obtainKIDSBuildFileBySha1(filePath, sha1Sum, cacheDir)
      if result:
        destFile = filePath[:filePath.rfind('.')]
        if os.path.exists(destFile) and generateSha1Sum(destFile) == sha1Sum:
          logger.info("%s is already current" % destFile)
          continue
        logger.info("%s => %s" % (extFilePath, destFile))
        shutil.copyfile(extFilePath, destFile)

if __name__ == '__main__':
  #main()
  downloadAllKIDSSha1File(sys.argv[1], sys.argv[2])
