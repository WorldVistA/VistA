from __future__ import print_function
# Update the globals that are updated by the Master File Server
# in a running instance of VistA.
#
# The list of globals to update was originally taken from
# http://www.vistapedia.com/index.php/MFS_list but has been updated
# with information from file #4.001 of the December 2018 FOIA release.
#
# For detailed help information, please run
#   python UpdateMFSGlobals.py -h
#
#---------------------------------------------------------------------------
# Copyright 2016-2018 OSEHRA
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
from __future__ import with_statement
import sys
import os
import re
import glob
import argparse
import urllib.request, urllib.parse, urllib.error
from datetime import datetime
import time

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_CACHE_DIR = os.path.normpath(os.path.join(SCRIPT_DIR, "../"))
sys.path.append(SCRIPT_DIR)


from VistATestClient import VistATestClientFactory, createTestClientArgParser
from LoggerManager import logger, initConsoleLogging, initFileLogging
from VistATaskmanUtil import VistATaskmanUtil
from VistAGlobalImport import VistAGlobalImport
from ExternalDownloader import ExternalDataDownloader
from PackRO             import pack
from VistARoutineImport import VistARoutineImport

  #(fileNum, Package, GlobalName)
class updateMFSGlobals(object):
  MFS_list = [
  ("Kernel","4.009","STANDARD TERMINOLOGY VERSION FILE"),
  ("Registration","10.99", "RACE MASTER"),
  ("Registration","11.99", "MASTER MARITAL STATUS"),
  ("Registration","13.99", "MASTER RELIGION"),
  ("National Drug File","50.60699", "MASTER DOSAGE FORM"),
  ("Lab Service","66.3", "MASTER LABORATORY TEST"),
  ("Radiology Nuclear Medicine","71.99", "MASTER RADIOLOGY PROCEDURE"),
  ("Lab Service", "95.3",  "LAB LOINC"),
  ("Order Entry Results Reporting","100.01","ORDER STATUS"),
  ("Order Entry Results Reporting","100.02","NATURE OF ORDER"),
  ("General Medical Record - Vitals","120.51","GMRV VITAL TYPE"),
  ("General Medical Record - Vitals","120.52","GMRV VITAL QUALIFIER"),
  ("General Medical Record - Vitals","120.53","GMRV VITAL CATEGORY"),
  ("Adverse Reaction Tracking","120.82","GMR ALLERGIES"),
  ("Adverse Reaction Tracking","120.83","SIGN-SYMPTOMS"),
  ("Integrated Billing","355.99", "MASTER TYPE OF PLAN"),
  ("PCE Patient Care Encounter","920", "VACCINE INFORMATION STATEMENT"),
  ("PCE Patient Care Encounter","920.1", "IMMUNIZATION INFO SOURCE"),
  ("PCE Patient Care Encounter","920.2", "IMM ADMINISTRATION ROUTE"),
  ("PCE Patient Care Encounter","920.3", "IMM ADMINISTRATION SITE (BODY)"),
  ("PCE Patient Care Encounter","920.4", "IMM CONTRAINDICATION REASONS"),
  ("PCE Patient Care Encounter","920.5", "IMM REFUSAL REASONS"),
  ("Health Data and Informatics","7118.11","HDIS TERM-CONCEPT VUID ASSOCIATION"),
  ("Text Integration Utility","8925.6", "TIU STATUS"),
  ("Text Integration Utility","8926.1", "TIU VHA ENTERPRISE STANDARD TITLE"),
  ("Text Integration Utility","8926.2", "TIU LOINC SUBJECT MATTER DOMAIN"),
  ("Text Integration Utility","8926.3", "TIU LOINC ROLE"),
  ("Text Integration Utility","8926.4", "TIU LOINC SETTING"),
  ("Text Integration Utility","8926.5", "TIU LOINC SERVICE"),
  ("Text Integration Utility","8926.6", "TIU LOINC DOCUMENT TYPE"),
  ("Kernel","8932.1", "PERSON CLASS"),
  ("Toolkit","8985.1","XTID VUID FOR SET OF CODES"),
  ("PCE Patient Care Encounter","9999999.04", "IMM MANUFACTURER"),
  ("PCE Patient Care Encounter","9999999.14", "IMMUNIZATION"),
  ("PCE Patient Care Encounter","9999999.28", "SKIN TEST")]

  """ Deletes file from VistA. Returns true if file found and deleted; false if
  not found """
  def deleteFile(self, connection, fileNumber):
      # Obtain Root of Global
      connection.send('W $$ROOT^DILFD(' + fileNumber + ',"",1)' + "\n")
      try:
        index = connection.expect(["\n\^.*\n"],1)
      except:
        print("File %s does not exist in the instance, skipping..." % fileNumber)
	return False
      myGlobal = connection.after.strip()
      print("Killing Global " + myGlobal)
      connection.send("KILL " + myGlobal + "\n")
      connection.expect(".*>.*")
      return True
      
  def installFile(self, vistaClient, connection, downloadedGblPath):
      print("Importing %s" % downloadedGblPath)

      connection.send("D ^ZGI\r")
      connection.expect("Device",1)
      connection.send(downloadedGblPath+"\r")
      if vistaClient.isCache():
        connection.expect("Parameters")
        connection.send("\r")
      try:
        connection.expect("Loaded")
      except Exception as ex:
        #Print error message with import problem?
        print("Problem importing global: %s" % ex)

  def checkforZGI(self,vistaClient,tmpDir,gtmDir):
    connection = vistaClient.getConnection()
    try:
      print("Checking for the ZGI routine")
      connection.send("D ^ZGI\r")
      connection.expect("Device")
      connection.send("^\r")
    # If error, ZGI routine doesn't exist
    except Exception as ex:
        print("Installing ZGI")
        # Attempt to install ZGI from SCRIPT_DIR?
        zgiRO = open(tmpDir+"/ZGI.ro","w")
        pack([SCRIPT_DIR+"/ZGI.m"],zgiRO)
        zgiRO.close()
        vistARoutineImport = VistARoutineImport()
        vistARoutineImport.importRoutines(vistaClient, tmpDir+"/ZGI.ro",
                                          gtmDir)
        print("Done installing!")

  """ This function downloads from a known set of Globals which are updated by the master file server

  It takes a VistA TestClient, a string which represents a branch on the OSEHRA-Sandbox/VistA-M repository
  to download the globals from.  It also has a tmpDir for storing the downloaded files and the GT.M routine
  dir in the case that ZGI has to be installed prior to importing.

  """
  def updateMFSGlobalFiles(self,vistaClient,foiaBranch,foiaRemote, tmpDir,gtmDir, install):
    urlRoot = foiaRemote+foiaBranch
    globalFiles = []
    self.checkforZGI(vistaClient,tmpDir,gtmDir)
    connection = vistaClient.getConnection()
    # Go through each file from above and download it from the branch set above
    for MFS_info in self.MFS_list:
      print("")
      zwrFile = urlRoot+"/Packages/%s/Globals/%s+%s.zwr" % (MFS_info[0], MFS_info[1],MFS_info[2].replace(")","").replace("(",""))
      print("Downloading the %s global from %s" % (MFS_info[2], zwrFile))
      downloadedGblPath = '%s/%s+%s.zwr' % (tmpDir,MFS_info[1],MFS_info[2])
      # Download from URL
      downloader = ExternalDataDownloader()
      downloader.downloadExternalDataDirectly(zwrFile,downloadedGblPath)
      # Start the import of the downloaded global
      # First check that the content of the global matches what was expected
      # Prevents the attempt to import an empty global
      with open(downloadedGblPath,"r") as gblContent:
        gbl_first_line = gblContent.readline()
      if gbl_first_line.strip() == "404: Not Found":
        print("Trying to see if global has split:")
        index = 1
	didIDeleteTheFileAlready = False
        while True:
            splitZwrFile = urlRoot+"/Packages/%s/Globals/%s-%s+%s.zwr" % (MFS_info[0], MFS_info[1], index,MFS_info[2])
            print("trying %s" % (splitZwrFile))
            downloadedSplitGblPath = '%s/%s-%s+%s.zwr' % (tmpDir, MFS_info[1], index,MFS_info[2])
            # Download from URL
            downloader = ExternalDataDownloader()
            downloader.downloadExternalDataDirectly(splitZwrFile,downloadedSplitGblPath)
            with open(downloadedSplitGblPath,"r") as gblContent:
              gbl_split_first_line = gblContent.readline()
            if gbl_split_first_line.strip() == "404: Not Found":
              break
            if install:
	      if didIDeleteTheFileAlready or self.deleteFile(connection, MFS_info[1]):
	        didIDeleteTheFileAlready = True
	        self.installFile(vistaClient,connection,downloadedSplitGblPath)
              os.remove(downloadedSplitGblPath)
            index = index+1
        os.remove(downloadedSplitGblPath)
        os.remove(downloadedGblPath)
        continue
      elif MFS_info[2].replace('-','/') not in gbl_first_line:
        print("Downloaded global information does not match desired name")
        continue
    # Import the global using the ZGI routine
      if install:
        if self.deleteFile(connection, MFS_info[1]):
          self.installFile(vistaClient,connection,downloadedGblPath)
        print("Deleting Download")
        os.remove(downloadedGblPath)

  """ main
  """
def main():
    testClientParser = createTestClientArgParser()
    parser = argparse.ArgumentParser(description='FOIA Patch Sequence Analyzer',
                                     parents=[testClientParser])
    parser.add_argument('-f', '--foiaBranch', required=True,
          help='input the branch name from which the global files are downloaded')
    parser.add_argument('-r', '--foiaRemote', required=False, default="https://raw.githubusercontent.com/OSEHRA-Sandbox/VistA-M/",
          help='input the VistA-M repository from which the global files are downloaded, must be a link to the raw data.\
          Default remote is: https://raw.githubusercontent.com/OSEHRA-Sandbox/VistA-M/ ')
    parser.add_argument('-t', '--tmpDir', required=True,
          help='input the filepath to a directory to download the necessary global files')
    parser.add_argument('-g', '--gtmDir', required=False,
          help='input the filepath to a directory where GT.M stores its routines')
    parser.add_argument('-i', '--install', required=False, action="store_true",
          help='Attempt to install global files with ^ZGI?')
    parser.add_argument('-l', '--log', required=False,
          help='File to which I would log VistA communication')
    result = parser.parse_args();

    """ create the VistATestClient"""
    testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
    assert testClient
    initConsoleLogging()
    if result.log: testClient.setLogFile(result.log)
    with testClient as vistaClient:
      update = updateMFSGlobals()
      update.updateMFSGlobalFiles(vistaClient,result.foiaBranch, result.foiaRemote,result.tmpDir, result.gtmDir, result.install)

if __name__ == '__main__':
  main()
