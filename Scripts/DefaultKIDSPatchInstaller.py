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
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from LoggerManager import logger
from VistAPackageInfoFetcher import VistAPackageInfoFetcher

DEFAULT_INSTALL_DUZ = 17 # VistA-FOIA user, "USER,SEVENTEEN"
""" Default Installer for KIDS Patches """
class DefaultKIDSPatchInstaller(object):
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
    in the subclass if just specific to that KIDS patch, or add it here if
    it is a general question
  """
  KIDS_MENU_OPTION_ACTION_LIST = [
      ("Incoming Mail Groups:", "", False),
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
    in the subclass if just specific to that KIDS patch, or add it here if
    it is a general question
  """
  KIDS_LOAD_QUESTION_ACTION_LIST = [
      ("OK to continue with Load","YES", False),
      ("Want to Continue with Load?","YES", False),
      ("Select Installation ","Install", True),
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
    @kidsFile: the path to KIDS patch file
    @kidsInstallName: the install name for the KIDS patch
    @seqNo: seqNo of the KIDS patch, default is None
    @logFile: logFile to store the log information for VistA interaction
    @multiBuildList: a python list of install names, only applies to
                     a multibuilds KIDS patch
    @duz: the applier's VistA DUZ, default is set to 17, in VistA FOIA
          it is USER SEVENTEEN
    @extra: any extra information that might be needed
  """
  def __init__(self, kidsFile, kidsInstallName, seqNo=None, logFile=None,
               multiBuildList = None, duz = DEFAULT_INSTALL_DUZ, extra=None):
    assert os.path.exists(kidsFile), ("kids file does not exist %s" % kidsFile)
    if len(kidsFile) >= self.KIDS_FILE_PATH_MAX_LEN:
      dest = os.path.join(tempfile.gettempdir(), os.path.basename(kidsFile))
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
    connection = vistATestClient.getConnection()
    vistATestClient.waitForPrompt()
    connection.send("S DUZ=%s D ^XUP\r" % self._duz)
    connection.expect("Select OPTION NAME: ")
    connection.send("EVE\r")
    connection.expect("CHOOSE 1-")
    connection.send("1\r")
    connection.expect("Select Systems Manager Menu ")
    connection.send("Programmer Options\r")
    connection.expect("Select Programmer Options ")
    connection.send("KIDS\r")

  """ load the KIDS build distribution file via menu
    must be called while in KIDS Main Menu
  """
  def __loadKIDSPatch__(self, connection):
    connection.expect("Select Kernel Installation & Distribution System ")
    connection.send("Installation\r")
    connection.expect("Select Installation ")
    connection.send("1\r") # load the distribution
    connection.expect("Enter a Host File:")
    connection.send(self._kidsFile+"\r")

  """ Answer all the KIDS install questions
  """
  def __handleKIDSInstallQuestions__(self, connection):
    connection.expect("Select INSTALL NAME:")
    connection.send(self._kidsInstallName+"\r")
    """ handle any questions before general KIDS installation questions"""
    self.handleKIDSInstallQuestions(connection)
    kidsMenuActionLst = self.KIDS_MENU_OPTION_ACTION_LIST
    while True:
      index = connection.expect([x[0] for x in kidsMenuActionLst])
      sendCmd = kidsMenuActionLst[index][1]
      if sendCmd != None:
        connection.send("%s\r" % sendCmd)
      if kidsMenuActionLst[index][2]:
        break
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
    connection.expect("Select Kernel Installation & Distribution System ")
    connection.send("Installation\r")
    connection.expect("Select Installation ")
    connection.send("Restart Install of\r") # restart install of package(s)
    connection.expect("Select INSTALL NAME: ")
    connection.send(self._kidsInstallName+"\r")

  """ go to the unload a distribution option """
  def __selectUnloadDistributionOption__(self, connection):
    connection.expect("Select Kernel Installation & Distribution System ")
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
  def normalInstallation(self, vistATestClient, reinst=True):
    logger.info("Start installing %s" % self._kidsInstallName)
    connection = vistATestClient.getConnection()
    self.__gotoKIDSMainMenu__(vistATestClient)
    self.__loadKIDSPatch__(connection)
    result = self.__handleKIDSLoadOptions__(connection, reinst)
    if not result:
      logger.error("Error handling KIDS Load Options %s, %s" %
                   (self._kidsInstallName, self._kidsFile))
      return False
    self.__handleKIDSInstallQuestions__(connection)
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
      index = connection.expect([x[0] for x in loadOptionActionList])
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
      idx = connection.expect(expectList)
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
      index = connection.expect(expectList, 1200) # timeout to be 1200 seconds
      status = expectList[index].replace("\\","")
      logger.info(status)
      callback = statusActionList[index][1]
      if callback:
        callback(connection, status)
      if statusActionList[index][2]:
        break
      else:
        continue
  """ This is the entry point of KIDS installer
    It defines the workflow of KIDS installation process
    @reinst: wether re-load the KIDS build file, default is True
    @return, True if no error, otherwise False
  """
  def runInstallation(self, vistATestClient, reinst=True):
    connection = vistATestClient.getConnection()
    self.__setupLogFile__(connection)
    infoFetcher = VistAPackageInfoFetcher(vistATestClient)
    installStatus = infoFetcher.getInstallationStatus(self._kidsInstallName)
    """ select KIDS installation workflow based on install status """
    if infoFetcher.isNotInstalled(installStatus):
      return self.normalInstallation(vistATestClient, reinst)
    elif infoFetcher.isInstallStarted(installStatus):
      return self.restartInstallation(vistATestClient)
    elif infoFetcher.isInstallCompleted(installStatus):
      logger.error("install %s is already completed!" %
                   self._kidsInstallName)
      return False
    return True
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
  """
  def handleKIDSInstallQuestions(self, connection, extra=None):
    pass
  """ intended to be implemented by subclass
    answer question related to pre install routine
  """
  def runPreInstallationRoutine(self, connection, extra=None):
    pass
  """ intended to be implemented by subclass
    answer question related to post install routine
  """
  def runPostInstallationRoutine(self, connection, extra=None):
    pass
  """ intended to be implemented by subclass """
  def extraFixWork(self, vistATestClient):
    pass
  """ default action for Send Mail To option
    please override or enhance it if more action is needed
  """
  def handleSendMailToOptions(self, connection, extra=None):
    connection.send("\r")
    connection.expect("Select basket to send to: ")
    connection.send("\r")
    connection.expect("Send ")
    connection.send("\r")

  """ default action for install completed
    please override or enhance it if more action is needed
  """
  def installCompleted(self, connection, extra=None):
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
  def handleInstallError(self, connection, extra=None):
    logger.error("Installation failed for %s" % self._kidsInstallName)
    connection.send("\r")


#---------------------------------------------------------------------------#
#  Utilities Functions
#---------------------------------------------------------------------------#
""" utility function to find the name associated the DUZ """
def getPersonNameByDuz(inputDuz, vistAClient):
  logger.info ("inputDuz is %s" % inputDuz)
  vistAClient.waitForPrompt()
  """ go to fileman options """
  connection = vistAClient.getConnection()
  connection.send("S DUZ=1 D Q^DI\r")
  connection.expect("Select OPTION: ")
  connection.send("3\r") # search file entry
  connection.expect("OUTPUT FROM WHAT FILE: ")
  connection.send("200\r")
  connection.expect("-A- SEARCH FOR NEW PERSON FIELD: ")
  connection.send("NUMBER\r")
  connection.expect("-A- CONDITION: ")
  connection.send("EQUALS\r")
  connection.expect("-A- EQUALS: ")
  connection.send("%s\r" %inputDuz)
  connection.expect("-B- SEARCH FOR NEW PERSON FIELD: ")
  connection.send("\r")
  connection.expect("IF: A// ")
  connection.send("\r")
  connection.expect("STORE RESULTS OF SEARCH IN TEMPLATE: ")
  connection.send("\r")
  connection.expect("SORT BY: NAME// ")
  connection.send("\r")
  connection.expect("START WITH NAME: FIRST// ")
  connection.send("\r")
  connection.expect("FIRST PRINT FIELD: ")
  connection.send(".01\r") # this is the fileman field number of NAME field
  connection.expect("THEN PRINT FIELD: ")
  connection.send("\r")
  connection.expect("Heading \(S/C\): NEW PERSON SEARCH// ")
  connection.send("@\r") # no heading
  connection.expect("DEVICE: ")
  connection.send("\r")
  connection.expect("Right Margin: [0-9]+//")
  connection.send("\r")
  connection.expect("Select OPTION: ")
  matchList = connection.before.split("\r\n")
  connection.send("\r")
  vistAClient.waitForPrompt()
  connection.send("\r")
  for line in matchList:
    if len(line.strip()) == 0:
      continue
    return line.strip() # return the very first non-empty line as result
  return None

""" function to add an entry to PACAKGE HISTORY """
def addPackagePatchHistory(packageName, version, seqNo,
                           patchNo, vistAClient, inputDuz):
  logger.info("Adding %s, %s, %s, %s to Package Patch history" %
              (packageName, version, seqNo, patchNo))
  appliedUser = getPersonNameByDuz(inputDuz, vistAClient)
  vistAClient.waitForPrompt()
  """ go to fileman options """
  connection = vistAClient.getConnection()
  connection.send("S DUZ=1 D Q^DI\r")
  connection.expect("Select OPTION: ")
  connection.send("1\r") # enter or edit entry
  connection.expect("INPUT TO WHAT FILE: ")
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
  connection.send("%s\r" % appliedUser)
  connection.expect("DESCRIPTION:")
  connection.send("\r")
  connection.expect("Select PATCH APPLICATION HISTORY: ")
  connection.send("\r")
  connection.expect("Select PACKAGE NAME: ")
  connection.send("\r")
  connection.expect("Select OPTION: ")
  connection.send("\r")
  vistAClient.waitForPrompt()
  connection.send("\r")

""" class KIDSInstallerFactory
  create KIDS installer via Factory methods
"""
class KIDSInstallerFactory(object):
  installerDict = {}
  @staticmethod
  def createKIDSInstaller(kidsFile, kidsInstallName,
                          seqNo=None, logFile=None,
                          multiBuildList=None):
    return KIDSInstallerFactory.installerDict.get(
                  kidsInstallName,
                  DefaultKIDSPatchInstaller)(kidsFile,
                                             kidsInstallName,
                                             seqNo, logFile,
                                             multiBuildList)

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
  assert testClient
  try:
    addPackagePatchHistory("LAB SERVICE", "5.2", "288", "334",
                           testClient, 17)
  finally:
    testClient.getConnection().terminate()
  sys.exit(0)

""" Test Function getPersonNameByDuz """
def testGetPersonNameByDuz():
  testClient = createTestClient()
  try:
    result = getPersonNameByDuz(17, testClient)
    print ("Name is [%s]" % result)
  finally:
    testClient.getConnection().terminate()
  sys.exit(0)

""" Test main entry """
def testMain():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='Default KIDS Installer',
                                   parents=[testClientParser])
  parser.add_argument('-k', '--kidsFile', required=True,
                    help='path to KIDS Build file')
  parser.add_argument('-i', '--install', required=True,
                      help='kids install name')
  parser.add_argument('-l', '--logFile', default = None,
                      help='logFile')
  result = parser.parse_args();
  print (result)
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  return testClient
  try:
    defaultKidsInstall = DefaultKIDSPatchInstaller(result.kidsFile,
                                                   result.install,
                                                   result.logFile)
    defaultKidsInstall.runInstallation(testClient)
  finally:
    testClient.getConnection().terminate()

if __name__ == "__main__":
  pass
  #testMain()
  #testGetPersonNameByDuz()
