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
    assert kidsInstallName == "PSN*4.0*533"
    DefaultKIDSBuildInstaller.__init__(self, kidsFile,
                                       kidsInstallName,
                                       seqNo, logFile,
                                       multiBuildList,
                                       duz, **kargs)
  """
    @override DefaultKIDSBuildInstaller.__gotoKIDSMainMenu__
    to  stop Taskman and to prevent logons so that the VA FileMan patch can be installed
  """

  def __gotoKIDSMainMenu__(self, vistATestClient):
    menuUtil = VistAMenuUtil(self._duz)
    connection = vistATestClient.getConnection()
    connection.send('S ^PS(56,1961,0)="MAGNESIUM/ZALCITABINE (DIDEOXYCYTIDINE,ddC)^255^3150^2^1^10624"\r')
    connection.expect(vistATestClient.getPrompt())
    connection.send('S ^PS(56,531,0)="LOMEFLOXACIN/MAGNESIUM^3183^255^2^1^28817^3141031"\r')
    connection.expect(vistATestClient.getPrompt())
    connection.send('S ^PS(56,513,0)="ENOXACIN/MAGNESIUM^2779^255^2^1^37112^3141031"\r')
    menuUtil.gotoKidsMainMenu(vistATestClient)