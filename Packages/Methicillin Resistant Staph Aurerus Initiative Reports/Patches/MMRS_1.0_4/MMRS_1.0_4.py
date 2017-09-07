#---------------------------------------------------------------------------
# Copyright 2017 The Open Source Electronic Health Record Agent
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
    assert kidsInstallName == "MMRS*1.0*4"
    DefaultKIDSBuildInstaller.__init__(self, kidsFile,
                                       kidsInstallName,
                                       seqNo, logFile,
                                       multiBuildList,
                                       duz, **kargs)
    self.newPkgName= "MDRO INITIATIVE REPORTS"
  """
    @override DefaultKIDSBuildInstaller.__handleKIDSInstallQuestions__
  """
  def __handleKIDSInstallQuestions__(self, connection,connection2=None):
    connection.send("Install\r")
    connection.expect("Select INSTALL NAME:")
    connection.send(self._kidsInstallName+"\r")
    """ handle any questions before general KIDS installation questions"""
    result = self.handleKIDSInstallQuestions(connection)
    if not result:
      return False
    kidsMenuActionLst = self.KIDS_MENU_OPTION_ACTION_LIST
    kidsMenuActionLst.append(("Shall I write over","", False))
    while True:
      index = connection.expect([x[0] for x in kidsMenuActionLst])
      sendCmd = kidsMenuActionLst[index][1]
      if sendCmd != None:
        connection.send("%s\r" % sendCmd)
      if kidsMenuActionLst[index][2]:
        break
    return True
