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
import time

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
    assert kidsInstallName == "VA FILEMAN 22.2"
    DefaultKIDSBuildInstaller.__init__(self, kidsFile,
                                       kidsInstallName,
                                       seqNo, logFile,
                                       multiBuildList,
                                       duz, **kargs)
  """
    @override DefaultKIDSBuildInstaller.__gotoKIDSMainMenu__
    to  stop Taskman and to prevent logons so that the VA FileMan patch can be installed
  """
  def __handleKIDSInstallQuestions__(self, connection, connection2=None):
    connection.send("Install\r")
    connection.expect("Select INSTALL NAME:")
    self.inhibitLogons(connection2)
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

  def inhibitLogons(self,connection):
    connection.expect(">")
    connection.send("S DUZ= 1 D Q^DI\r")
    connection.expect("Select OPTION")
    connection.send("ENTER OR EDIT FILE ENTRIES\r")
    connection.expect(inputRegEx)
    connection.send("VOLUME SET\r")
    connection.expect("EDIT WHICH FIELD")
    connection.send("INHIBIT LOGONS\r\r")
    connection.expect("Select VOLUME SET")
    connection.send("`1\r")
    connection.expect("INHIBIT LOGONS?")
    connection.send("YES\r")

  def __gotoKIDSMainMenu__(self, vistATestClient):
    menuUtil = VistAMenuUtil(self._duz)
    connection = vistATestClient.getConnection()
    connection.send("D STOP^ZTMKU\r")
    connection.expect("Are you sure")
    connection.send("Y\r")
    connection.expect("Should active")
    connection.send("Y\r")
    connection.expect("Should active")
    connection.send("Y\r")
    time.sleep(30)
    menuUtil.gotoKidsMainMenu(vistATestClient)

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
    connection.send("D ^ZTMB\r")
    connection.expect(vistATestClient.getPrompt())
    connection.send("D Q^DI\r")
    connection.expect("Select OPTION")
    connection.send("ENTER OR EDIT FILE ENTRIES\r")
    connection.expect(inputRegEx)
    connection.send("VOLUME SET\r")
    connection.expect("EDIT WHICH FIELD")
    connection.send("INHIBIT LOGONS\r\r")
    connection.expect("Select VOLUME SET")
    connection.send("`1\r")
    connection.expect("INHIBIT LOGONS?")
    connection.send("NO\r\r\r")
