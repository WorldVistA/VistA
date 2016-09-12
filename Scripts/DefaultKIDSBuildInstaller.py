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

import sys
import os
import re
import tempfile
import shutil
import argparse
import glob
from PatchInfoParser import installNameToDirName
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from LoggerManager import logger, initConsoleLogging
from VistAPackageInfoFetcher import VistAPackageInfoFetcher
from VistAGlobalImport import VistAGlobalImport, DEFAULT_GLOBAL_IMPORT_TIMEOUT
from ExternalDownloader import obtainKIDSBuildFileBySha1
from ConvertToExternalData import readSha1SumFromSha1File
from ConvertToExternalData import isValidExternalDataFileName
from ConvertToExternalData import isValidGlobalFileSuffix, isValidGlobalSha1Suffix
from ConvertToExternalData import getSha1HashFromExternalDataFileName

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_CACHE_DIR = os.path.normpath(os.path.join(SCRIPT_DIR, "../"))
from VistAMenuUtil import VistAMenuUtil

DEFAULT_INSTALL_DUZ = 17 # VistA user, "USER,SEVENTEEN"
CHECK_INSTALLATION_PROGRESS_TIMEOUT = 1200 # 1200 seconds or 20 minutes
GLOBAL_IMPORT_BYTE_PER_SEC = 0.5*1024*1024 # import speed is 0.5 MiB per sec

""" Default Installer for KIDS Build """
class DefaultKIDSBuildInstaller(object):
  #---------------------------------------------------------------------------#
  # Class Constants
  #---------------------------------------------------------------------------#
  """ A list of tuple, defined the action list corresponding to KIDS Build
    questions that might need to act.
    each tuple should have three items.
    first item:  KIDS Menu option text
    second item: default answer, use \"\" for default
    third item: bool flag to indicate whether to break out of the menu loop
    If more menu options is needed, please either add extra option
    in the subclass if just specific to that KIDS Build, or add it here if
    it is a general question
  """
  KIDS_MENU_OPTION_ACTION_LIST = [
      ("Want to continue installing this build\?","YES", False),
      ("Enter the Coordinator for Mail Group", "", False),
      ("Want KIDS to Rebuild Menu Trees Upon Completion of Install\?",
       "", False),
      ("Want KIDS to INHIBIT LOGONs during the install?",
       "NO", False),
      ("Want to DISABLE Scheduled Options, Menu Options, and Protocols\?",
       "NO", False),
      ("Delay Install \(Minutes\):  \(0\-60\):", "0", False),
      ("do you want to include disabled components\?", "NO", False),
      ("DEVICE:", None, True)
  ]

  """ A list of tuple, defined the action list corresponding to KIDS Build
    questions that might need to act.
    each tuple should have three items.
    first item:  KIDS Menu option text
    second item: default answer, use \"\" for default
    third item: bool flag to indicate whether to break out of the menu loop
    If more menu options is needed, please either add extra option
    in the subclass if just specific to that KIDS Build, or add it here if
    it is a general question
  """
  KIDS_LOAD_QUESTION_ACTION_LIST = [
      ("OK to continue with Load","YES", False),
      ("Want to Continue with Load\?","YES", False),
      ("Select Installation ","?", True),
      ("Want to continue installing this build\?","YES", False),
      ("Want to RUN the Environment Check Routine\? YES//","YES",False)
  ]

  """ option action list for Exit KIDS menu, similar struct as above """
  EXIT_KIDS_MENU_ACTION_LIST = [
      ("Select Installation ", "", False),
      ("Select Kernel Installation & Distribution System ", "", False),
      ("Select Programmer Options ", "", False),
      ("Select Systems Manager Menu ", "", False),
      ("Do you really want to halt\?", "YES", True)
  ]

  KIDS_FILE_PATH_MAX_LEN = 75 # this might need to be fixed in VistA XPD
  #---------------------------------------------------------------------------#
  # Class Methods
  #---------------------------------------------------------------------------#
  """ Constructor
    @kidsFile: the absolute path to KIDS Build file
    @kidsInstallName: the install name for the KIDS Build
    @seqNo: seqNo of the KIDS Build, default is None
    @logFile: logFile to store the log information for VistA interaction
    @multiBuildList: a python list of install names, only applies to
                     a multibuilds KIDS Build
    @duz: the applier's VistA DUZ, default is set to 17, in VistA FOIA
          it is USER SEVENTEEN
    @**kargs: any extra information that might be needed
  """
  def __init__(self, kidsFile, kidsInstallName, seqNo=None, logFile=None,
               multiBuildList = None, duz = DEFAULT_INSTALL_DUZ, **kargs):
    assert os.path.exists(kidsFile), ("kids file does not exist %s" % kidsFile)
    self._origKidsFile = kidsFile
    if len(kidsFile) >= self.KIDS_FILE_PATH_MAX_LEN:
      destFilename = os.path.basename(kidsFile)
      tempDir = tempfile.gettempdir()
      if isValidExternalDataFileName(kidsFile):
        # if read directly from inplace, need to replace the name with hash
        destFilename = getSha1HashFromExternalDataFileName(kidsFile)
      while (len(tempDir)+len(destFilename)+1) >= self.KIDS_FILE_PATH_MAX_LEN:
        tempDir = os.path.split(tempDir)[0]
      dest = os.path.join(tempDir, destFilename)
      shutil.copy(kidsFile, dest)
      self._kidsFile = os.path.normpath(dest)
      logger.info("new kids file is %s" % self._kidsFile)
    else:
      self._kidsFile = os.path.normpath(kidsFile)
    self._kidsInstallName = kidsInstallName
    self._logFile = logFile
    self._duz = duz
    self._updatePackageLink = False
    self._multiBuildList = multiBuildList
    # store all the globals files associated with KIDS"
    self._globalFiles = None
    if "globals" in kargs:
      self._globalFiles = kargs['globals']
    self._tgOutputDir = None
    if "printTG" in kargs:
      self._tgOutputDir = kargs['printTG']

  """ set up the log for VistA connection
    @connection: a connection from a VistATestClient
  """
  def __setupLogFile__(self, connection):
    if self._logFile:
      connection.logfile = open(self._logFile, "ab")
    else:
      connection.logfile = sys.stdout

  """ Go to KIDS Main Menu
    Always start with ready state (wait for promp)
  """
  def __gotoKIDSMainMenu__(self, vistATestClient):
    menuUtil = VistAMenuUtil(self._duz)
    menuUtil.gotoKidsMainMenu(vistATestClient)

  """ load the KIDS build distribution file via menu
    must be called while in KIDS Main Menu
  """
  def __loadKIDSBuild__(self, connection):
    connection.send("Installation\r")
    connection.expect("Select Installation ")
    connection.send("1\r") # load the distribution
    connection.expect("Enter a Host File:")
    connection.send(self._kidsFile+"\r")

  """ Answer all the KIDS install questions
  """
  def __handleKIDSInstallQuestions__(self, connection, connection2=None):
    connection.send("Install\r")
    connection.expect("Select INSTALL NAME:")
    connection.send(self._kidsInstallName+"\r")
    """ handle any questions before general KIDS installation questions"""
    result = self.handleKIDSInstallQuestions(connection)
    if not result:
      return False
    kidsMenuActionLst = self.KIDS_MENU_OPTION_ACTION_LIST
    while True:
      index = connection.expect([x[0] for x in kidsMenuActionLst])
      sendCmd = kidsMenuActionLst[index][1]
      if sendCmd != None:
        connection.send("%s\r" % sendCmd)
      if kidsMenuActionLst[index][2]:
        break
    return True
  """ restart the previous installation
  """
  def restartInstallation(self, vistATestClient):
    logger.warn("restart the previous installation for %s" %
                self._kidsInstallName)
    connection = vistATestClient.getConnection()
    self.__gotoKIDSMainMenu__(vistATestClient)
    self.__selectRestartInstallOption__(connection)
    index = connection.expect(["DEVICE: ", "Select INSTALL NAME: "])
    if index == 0:
      self.__installationCommon__(vistATestClient)
      return True
    else:
      logger.error("Restart install %s failed" % self._kidsInstallName)
      """ go back to KIDS main menu first """
      connection.send('\r')
      connection.expect("Select Installation ")
      connection.send('\r')
      """ try to unload a distribution first """
      result = self.unloadDistribution(vistATestClient, False)
      if not result:
        logger.error("Unload Distribution %s failed" % self._kidsInstallName)
      return self.normalInstallation(vistATestClient)

  """ go to the restart KIDS build option """
  def __selectRestartInstallOption__(self, connection):
    connection.send("Installation\r")
    connection.expect("Select Installation ")
    connection.send("Restart Install of\r") # restart install of package(s)
    connection.expect("Select INSTALL NAME: ")
    connection.send(self._kidsInstallName+"\r")

  """ go to the unload a distribution option """
  def __selectUnloadDistributionOption__(self, connection):
    #connection.expect("Select Kernel Installation & Distribution System ")
    connection.send("installation\r")
    connection.expect("Select Installation ")
    connection.send("Unload a Distribution\r")
    connection.expect("Select INSTALL NAME: ")
    connection.send(self._kidsInstallName+"\r")

  """ unload a previous loaded distribution """
  def unloadDistribution(self, vistATestClient, waitForPrompt=True):
    connection = vistATestClient.getConnection()
    logger.info("Unload distribution for %s" % self._kidsInstallName)
    if waitForPrompt:
      self.__gotoKIDSMainMenu__(vistATestClient)
    self.__selectUnloadDistributionOption__(connection)
    index = connection.expect([
      "Want to continue with the Unload of this Distribution\? NO// ",
      "Select INSTALL NAME: "])
    if index == 1:
      connection.send('\r')
      self.__exitKIDSMenu__(vistATestClient)
      return False
    connection.send('YES\r')
    self.__exitKIDSMenu__(vistATestClient)
    return True

  """ Do a fresh load and installation """
  def normalInstallation(self, vistATestClient, vistATestClient2=None, reinst=True):
    logger.info("Start installing %s" % self._kidsInstallName)
    connection = vistATestClient.getConnection()
    if vistATestClient2:
      connection2 = vistATestClient2.getConnection()
    self.__gotoKIDSMainMenu__(vistATestClient)
    self.__loadKIDSBuild__(connection)
    result = self.__handleKIDSLoadOptions__(connection, reinst)
    if not result:
      logger.error("Error handling KIDS Load Options %s, %s" %
                   (self._kidsInstallName, self._kidsFile))
      return False
    if self._tgOutputDir:
      if self._multiBuildList is None:
        self.__printTransportGlobal__(vistATestClient,[self._kidsInstallName],self._tgOutputDir)
      else:
        self.__printTransportGlobal__(vistATestClient,self._multiBuildList,self._tgOutputDir)
    if vistATestClient2:
      result = self.__handleKIDSInstallQuestions__(connection, connection2)
    else:
      result = self.__handleKIDSInstallQuestions__(connection)
    if not result:
      result = self.unloadDistribution(vistATestClient, False)
      if not result:
        logger.error("Unload %s failed" % self._kidsInstallName)
        return False
      return self.normalInstallation(vistATestClient, vistATestClient2, reinst)
    self.__installationCommon__(vistATestClient)
    return True

  """ common shared workflow in KIDS installation process """
  def __installationCommon__(self, vistATestClient):
    connection = vistATestClient.getConnection()
    self.setupDevice(connection)
    self.__checkInstallationProgress__(connection)
    self.__exitKIDSMenu__(vistATestClient)
    self.extraFixWork(vistATestClient)

  """ Handle options during load KIDS distribution section """
  def __handleKIDSLoadOptions__(self, connection, reinst):
    loadOptionActionList = self.KIDS_LOAD_QUESTION_ACTION_LIST[:]
    """ make sure install completed is the last one """
    loadOptionActionList.append(
               (self._kidsInstallName + "   Install Completed", None))
    while True:
      index = connection.expect([x[0] for x in loadOptionActionList], 120)
      if index == len(loadOptionActionList) - 1:
        if not reinst:
          return False
      else:
        connection.send("%s\r" % (loadOptionActionList[index][1]))
        if loadOptionActionList[index][2]:
          break
    return True

  """ Exit the KIDS Menu option.
    Make sure the VistA connection is in the ready state (wait for prompt)
  """
  def __exitKIDSMenu__(self, vistATestClient):
    exitMenuActionList = self.EXIT_KIDS_MENU_ACTION_LIST[:]
    connection = vistATestClient.getConnection()
    """ add wait for prompt """
    exitMenuActionList.append((vistATestClient.getPrompt(), "\r", True))
    expectList = [x[0] for x in exitMenuActionList]
    while True:
      idx = connection.expect(expectList,120)
      connection.send("%s\r" % exitMenuActionList[idx][1])
      if exitMenuActionList[idx][2]:
        break

  """ Checking the current status of the KIDS build
  """
  def __checkInstallationProgress__(self, connection):
    KIDS_BUILD_STATUS_ACTION_LIST = [
      ("Running Pre-Install Routine:",self.runPreInstallationRoutine,False),
      ("Running Post-Install Routine:",self.runPostInstallationRoutine,False),
      ("Starting Menu Rebuild:", None , False),
      ("Installing Routines:",  None , False),
      ("Installing Data:",  None , False),
      ("Menu Rebuild Complete:", None , False),
      ("Installing PACKAGE COMPONENTS:", None ,False),
      ("Send mail to: ", self.handleSendMailToOptions, False),
      ("Select Installation ", self.handleInstallError, True),
      ("Install Completed", self.installCompleted, True)
    ]
    """ Bulid the status update action list """
    statusActionList = []
    installName = self._kidsInstallName
    if self._multiBuildList:
      for item in self._multiBuildList:
        statusActionList.append(
            (re.escape("Install Started for %s :" %item), None, False))
        statusActionList.append(
            (re.escape("%s Installed." % item), None, False))
    else:
      statusActionList.append(
          (re.escape("Install Started for %s :" % installName),
           None, False))
      statusActionList.append(
          (re.escape("%s Installed." % installName), None, False))
    statusActionList.extend(KIDS_BUILD_STATUS_ACTION_LIST)
    expectList = [x[0] for x in statusActionList]
    while True:
      index = connection.expect(expectList, CHECK_INSTALLATION_PROGRESS_TIMEOUT)
      status = expectList[index].replace("\\","")
      logger.info(status)
      callback = statusActionList[index][1]
      if callback:
        callback(connection, status=status)
      if statusActionList[index][2]:
        break
      else:
        continue
  """ This is the entry point of KIDS installer
    It defines the workflow of KIDS installation process
    @reinst: wether re-install the KIDS build, default is False
    @return, True if no error, otherwise False
  """
  def runInstallation(self, vistATestClient, vistATestClient2=None, reinst=False):
    connection = vistATestClient.getConnection()
    self.__setupLogFile__(connection)
    infoFetcher = VistAPackageInfoFetcher(vistATestClient)
    installStatus = infoFetcher.getInstallationStatus(self._kidsInstallName)
    """ select KIDS installation workflow based on install status """
    if infoFetcher.isInstallCompleted(installStatus):
      logger.warn("install %s is already completed!" %
                   self._kidsInstallName)
      if not reinst:
        return True
    # run pre-installation preparation
    self.preInstallationWork(vistATestClient)
    if infoFetcher.isInstallStarted(installStatus):
      return self.restartInstallation(vistATestClient)
    return self.normalInstallation(vistATestClient,vistATestClient2, reinst)

  def __printTGlobalChecksums__(self,testClient,installname,outputDir):
    connection = testClient.getConnection()
    connection.expect("Select Installation")
    connection.send("Verify Checksums\r")
    connection.expect("Select INSTALL NAME")
    connection.send(installname +"\r")
    connection.expect("Want each Routine Listed with Checksums")
    connection.send("YES\r")
    connection.expect("DEVICE")
    connection.send("HFS\r")
    connection.expect("HOST FILE NAME")
    logfile=os.path.join(outputDir,installNameToDirName(installname)+"Checksums.log")
    if testClient.isCache():
      logfile=os.path.normpath(logfile)
    connection.send(logfile+"\r")
    connection.expect("PARAMETERS")
    if testClient.isCache():
      connection.send("\r")
    else:
      connection.send("NEWVERSION:NOREADONLY:VARIABLE\r")
    index = connection.expect(["Select Installation","overwrite it"],600)
    if index == 0:
      connection.send("?\r")
    else:
      connection.send('\r')

  def __printTGlobalSummary__(self,testClient,installname,outputDir):
    connection = testClient.getConnection()
    connection.expect("Select Installation")
    connection.send("Print Transport Global\r")
    connection.expect("Select INSTALL NAME")
    connection.send(installname +"\r")
    connection.expect("What to Print")
    connection.send('2\r')
    connection.expect("DEVICE")
    connection.send("HFS\r")
    connection.expect("HOST FILE NAME")
    logfile=os.path.join(outputDir,installNameToDirName(installname)+"Print.log")
    if testClient.isCache():
      logfile=os.path.normpath(logfile)
    connection.send(logfile+"\r")
    connection.expect("PARAMETERS")
    if testClient.isCache():
      connection.send("\r")
    else:
      connection.send("NEWVERSION:NOREADONLY:VARIABLE\r")
    index = connection.expect(["Select Installation","overwrite it"],600)
    if index == 0:
      connection.send("?\r")
    else:
      connection.send('\r')

  def __printTGlobalCompare__(self,testClient,installname,outputDir):
    connection = testClient.getConnection()
    connection.expect("Select Installation")
    connection.send("Compare Transport Global\r")
    connection.expect("Select INSTALL NAME")
    connection.send(installname +"\r")
    connection.expect("Type of Compare")
    connection.send("1\r")
    connection.expect("DEVICE")
    connection.send("HFS\r")
    connection.expect("HOST FILE NAME")
    logfile=os.path.join(outputDir,installNameToDirName(installname)+"Compare.log")
    if testClient.isCache():
      logfile=os.path.normpath(logfile)
    connection.send(logfile+"\r")
    connection.expect("PARAMETERS")
    if testClient.isCache():
      connection.send("\r")
    else:
      connection.send("NEWVERSION:NOREADONLY:VARIABLE\r")
    index = connection.expect(["Select Installation","overwrite it"],600)
    if index == 0:
      connection.send("?\r")
    else:
      connection.send('\r')

  ''' Print out the checksums and the summary of the transport global  '''
  def __printTransportGlobal__(self,testClient,installNameList,outputDir):
    for installName in installNameList:
      self.__printTGlobalChecksums__(testClient,installName,outputDir)
      self.__printTGlobalSummary__(testClient,installName,outputDir)
      self.__printTGlobalCompare__(testClient,installName,outputDir)
  #---------------------------------------------------------------------------#
  #  Public override methods sections
  #---------------------------------------------------------------------------#
  """ Set up the KIDS installation result output device
    default is to use HOME device
    if you want to use a difference device, please override this method
  """
  def setupDevice(self, connection):
    connection.send("HOME;82;999\r")

  """ intended to be implemented by subclass
    this is to handle any build related questions that
    comes up before the general KIDS questions
    default implementation is to check the error condition
  """
  def handleKIDSInstallQuestions(self, connection, **kargs):
    errorCheckTimeout = 5 # 5 seconds
    try:
      connection.expect("\*\*INSTALL FILE IS CORRUPTED\*\*",errorCheckTimeout)
      logger.error("%s:INSTALL FILE IS CORRUPTED" % self._kidsInstallName)
      connection.expect("Select Installation ", errorCheckTimeout)
      connection.send('\r')
      return False
    except Exception as ex:
      return True

  """ intended to be implemented by subclass
    answer question related to pre install routine
  """
  def runPreInstallationRoutine(self, connection, **kargs):
    pass
  """ intended to be implemented by subclass
    answer question related to post install routine
  """
  def runPostInstallationRoutine(self, connection, **kargs):
    pass
  """ intended to be implemented by subclass """
  def extraFixWork(self, vistATestClient):
    pass
  """ default action for Send Mail To option
    please override or enhance it if more action is needed
  """
  def handleSendMailToOptions(self, connection, **kargs):
    connection.send("\r")
    connection.expect("Select basket to send to: ")
    connection.send("\r")
    connection.expect("Send ")
    connection.send("\r")

  """ default action for install completed
    please override or enhance it if more action is needed
  """
  def installCompleted(self, connection, **kargs):
    extraInfo = connection.before
    logger.debug(extraInfo)
    if re.search("No link to PACKAGE file", extraInfo):
      self._updatePackageLink = True
      logger.warn("You might have to update KIDS build %s to link"
                  " to Package file" %
                  (self._kidsInstallName))

  """ default action for installation error
    please override or enhance it if more action is needed
  """
  def handleInstallError(self, connection, **kargs):
    logger.error("Installation failed for %s" % self._kidsInstallName)
    connection.send("\r")

  """ default action for pre-installation preperation.
    right now it is just to import the globals file under
    the same directory as the KIDs directory
    please override or enhance it if more action is needed
  """
  def preInstallationWork(self, vistATestClient, **kargs):
    """ ignore the multi-build patch for now """
    if self._multiBuildList is not None:
      return
    globalFiles = self.__getGlobalFileList__()
    if globalFiles is None or len(globalFiles) == 0:
      return
    globalImport = VistAGlobalImport()
    for glbFile in globalFiles:
      logger.info("Import global file %s" % (glbFile))
      fileSize = os.path.getsize(glbFile)
      importTimeout = DEFAULT_GLOBAL_IMPORT_TIMEOUT
      importTimeout += int(fileSize/GLOBAL_IMPORT_BYTE_PER_SEC)
      globalImport.importGlobal(vistATestClient, glbFile, timeout=importTimeout)

  #---------------------------------------------------------------------------#
  #  Utilities Functions
  #---------------------------------------------------------------------------#

  """ utility function to find the all global files ends with GLB/s """
  def __getGlobalFileList__(self):
    globalFiles = []
    if self._globalFiles is None or len(self._globalFiles) == 0:
      return globalFiles
    for gFile in self._globalFiles:
      if isValidGlobalFileSuffix(gFile):
        globalFiles.append(gFile)
        continue
      if isValidGlobalSha1Suffix(gFile): # external file
        sha1Sum = readSha1SumFromSha1File(gFile)
        (result, path) = obtainKIDSBuildFileBySha1(gFile,
                                                   sha1Sum,
                                                   DEFAULT_CACHE_DIR)
        if not result:
          logger.error("Could not obtain global file for %s" % gFile)
          raise Exception("Error getting global file for %s" % gFile)
        globalFiles.append(path)

    if len(globalFiles) > 0:
      logger.info("global file lists %s" % globalFiles)
    return globalFiles

""" utility function to find the name associated the DUZ """
def getPersonNameByDuz(inputDuz, vistAClient):
  logger.info ("inputDuz is %s" % inputDuz)
  """ user Kernel User API """
  connection = vistAClient.getConnection()
  menuUtil = VistAMenuUtil(duz=1)
  menuUtil.gotoSystemMenu(vistAClient)
  connection.send('Prog\r')
  connection.expect('Select Programmer Options')
  connection.send('^\r')
  menuUtil.exitSystemMenu(vistAClient)
  vistAClient.waitForPrompt()
  connection.send('W $$NAME^XUSER(%s)\r' % inputDuz)
  connection.expect('\)') # get rid of the echo
  vistAClient.waitForPrompt()
  result = connection.before.strip(' \r\n')
  connection.send('\r')
  return result

""" function to add an entry to PACAKGE HISTORY """
def addPackagePatchHistory(packageName, version, seqNo,
                           patchNo, vistAClient, inputDuz):
  logger.info("Adding %s, %s, %s, %s to Package Patch history" %
              (packageName, version, seqNo, patchNo))
  connection = vistAClient.getConnection()
  menuUtil = VistAMenuUtil(duz=1)
  menuUtil.gotoFileManEditEnterEntryMenu(vistAClient)
  connection.send("9.4\r") # package file
  connection.expect("EDIT WHICH FIELD: ")
  connection.send("VERSION\r")
  connection.expect("EDIT WHICH VERSION SUB-FIELD: ")
  connection.send("PATCH APPLICATION HISTORY\r")
  connection.expect("EDIT WHICH PATCH APPLICATION HISTORY SUB-FIELD: ")
  connection.send("ALL\r")
  connection.expect("THEN EDIT VERSION SUB-FIELD: ")
  connection.send("\r")
  connection.expect("THEN EDIT FIELD: ")
  connection.send("\r")
  connection.expect("Select PACKAGE NAME: ")
  connection.send("%s\r" % packageName)
  connection.expect("Select VERSION: %s//" % version)
  connection.send("\r")
  connection.expect("Select PATCH APPLICATION HISTORY: ")
  connection.send("%s SEQ #%s\r" % (patchNo, seqNo))
  connection.expect("Are you adding .*\? No//")
  connection.send("YES\r")
  connection.expect("DATE APPLIED: ")
  connection.send("T\r")
  connection.expect("APPLIED BY: ")
  connection.send("`%s\r" % inputDuz)
  connection.expect("DESCRIPTION:")
  connection.send("\r")
  connection.expect("Select PATCH APPLICATION HISTORY: ")
  connection.send("\r")
  connection.expect("Select PACKAGE NAME: ")
  connection.send("\r")
  menuUtil.exitFileManMenu(vistAClient)

""" class KIDSInstallerFactory
  create KIDS installer via Factory methods
"""
class KIDSInstallerFactory(object):
  installerDict = {}
  @staticmethod
  def createKIDSInstaller(kidsFile, kidsInstallName,
                          seqNo=None, logFile=None,
                          multiBuildList=None, duz=DEFAULT_INSTALL_DUZ,
                          **kargs):
    return KIDSInstallerFactory.installerDict.get(
                  kidsInstallName,
                  DefaultKIDSBuildInstaller)(kidsFile,
                                             kidsInstallName,
                                             seqNo, logFile,
                                             multiBuildList, duz,
                                             **kargs)

  @staticmethod
  def registerKidsInstaller(kidsInstallName, kidsInstaller):
    KIDSInstallerFactory.installerDict[kidsInstallName] = kidsInstaller

""" Test code """
def createTestClient():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='Default KIDS Installer',
                                   parents=[testClientParser])
  result = parser.parse_args();
  print (result)
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  return testClient

def testAddPackagePatchHistory():
  testClient = createTestClient()
  with testClient:
    addPackagePatchHistory("LAB SERVICE", "5.2", "288", "334",
                           testClient, 17)

""" Test Function getPersonNameByDuz """
def testGetPersonNameByDuz():
  testClient = createTestClient()
  initConsoleLogging()
  with testClient:
    result = getPersonNameByDuz(1, testClient)
    print ("Name is [%s]" % result)

""" main entry """
def main():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='Default KIDS Installer',
                                   parents=[testClientParser])
  parser.add_argument('kidsFile', help='path to KIDS Build file')
  parser.add_argument('-l', '--logFile', default=None, help='path to logFile')
  parser.add_argument('-r', '--reinstall', default=False, action='store_true',
                help='whether re-install the KIDS even it is already installed')
  parser.add_argument('-t', '--tglobalprint', default=None,
                help='folder to hold a printout of Transport global information')
  parser.add_argument('-g', '--globalFiles', default=None, nargs='*',
                help='list of global files that need to import')
  parser.add_argument('-d', '--duz', default=DEFAULT_INSTALL_DUZ, type=int,
                help='installer\'s VistA instance\'s DUZ')

  result = parser.parse_args();
  print (result)
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  initConsoleLogging()
  with testClient:
    kidsFile = os.path.abspath(result.kidsFile)
    from KIDSBuildParser import KIDSBuildParser
    kidsParser = KIDSBuildParser(None)
    kidsParser.unregisterSectionHandler(KIDSBuildParser.ROUTINE_SECTION)
    kidsParser.parseKIDSBuild(kidsFile)
    installNameList = kidsParser.installNameList
    installName = installNameList[0]
    multiBuildList = installNameList
    if len(installNameList) == 1:
      multiBuildList = None
    defaultKidsInstall = DefaultKIDSBuildInstaller(kidsFile,
                                           installName,
                                           logFile=result.logFile,
                                           multiBuildList=multiBuildList,
                                           duz = result.duz,
                                           globals=result.globalFiles,
                                           printTG=result.tglobalprint)
    defaultKidsInstall.runInstallation(testClient, result.reinstall)

if __name__ == "__main__":
  main()
