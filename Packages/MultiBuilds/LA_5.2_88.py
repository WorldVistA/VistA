#---------------------------------------------------------------------------
# Copyright 2016 The Open Source Electronic Health Record Agent
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

from DefaultKIDSBuildInstaller import DefaultKIDSBuildInstaller
from VistAMenuUtil import VistAMenuUtil
import re

inputRegEx = re.compile("INPUT TO WHAT FILE", re.I)

""" This is an example of custom installer to handle post install questions
    Requirement for custom installer python script:
    1. Must be a class named CustomInstaller
    2. The constructor __init__ takes the exact arguments as the
       DefaultKIDSBuildInstaller
    3. Preferred to be a subclass of DefaultKIDSBuildInstaller
    4. Refer to DefaultKIDSBuildInstaller for methods to override
    5. If not a subclass of DefaultKIDSBuildInstaller, must have a method
       named runInstallation, and take an argument connection
       from VistATestClient.
"""
class CustomInstaller(DefaultKIDSBuildInstaller):
  def __init__(self, kidsFile, kidsInstallName,
               seqNo = None, logFile = None, multiBuildList=None,
               duz=17, **kargs):
    print kidsInstallName, seqNo
    assert kidsInstallName == "LA*5.2*88"
    DefaultKIDSBuildInstaller.__init__(self, kidsFile,
                                       kidsInstallName,
                                       seqNo, logFile,
                                       multiBuildList,
                                       duz, **kargs)
  """
    @override DefaultKIDSBuildInstaller.__gotoKIDSMainMenu__
    to  stop Taskman and to prevent logons so that the VA FileMan patch can be installed
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

    """ Requires the installer account to have the ZTMQ security key"""
    menuUtil = VistAMenuUtil(duz=17)
    menuUtil.gotoSystemMenu(vistAClient)
    connection.send("Allocation of Security\r")
    connection.expect("Allocate key")
    connection.send("ZTMQ\r\r")
    connection.expect("Holder of key")
    connection.send(" \r\r")
    connection.expect("Do you wish to proceed")
    connection.send("Y\r")

  def __handleKIDSInstallQuestions__(self, connection, connection2=None):
    connection.send("Install\r")
    connection.expect("Select INSTALL NAME:")
    connection.send(self._kidsInstallName+"\r")
    """ handle any questions before general KIDS installation questions"""
    result = self.handleKIDSInstallQuestions(connection)
    if not result:
      return False
    kidsMenuActionLst = self.KIDS_MENU_OPTION_ACTION_LIST
    kidsMenuActionLst.append(("using the Lab UI","Yes",False))
    kidsMenuActionLst.append(("Lab UI COTS driver been upgraded","Yes",False))
    while True:
      index = connection.expect([x[0] for x in kidsMenuActionLst])
      sendCmd = kidsMenuActionLst[index][1]
      if sendCmd != None:
        connection.send("%s\r" % sendCmd)
      if kidsMenuActionLst[index][2]:
        break
    return True
    connection.send("NO\r\r\r")
