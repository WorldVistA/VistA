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

from DefaultKIDSPatchInstaller import DefaultKIDSPatchInstaller

""" This is an example of custom installer to handle post install questions
    Requirement for custom installer python script:
    1. Must be a class named CustomInstaller
    2. The constructor __init__ takes the exact arguments as the
       DefaultKIDSPatchInstaller
    3. Prefer to be a subclass of DefaultKIDSPatchInstaller
    4. Refer to DefaultKIDSPatchInstaller for methods to override
    5. If not a subclass of DefaultKIDSPatchInstaller, must have a method
       named runInstallation, and take an argument connection
       from VistATestClient.
"""
class CustomInstaller(DefaultKIDSPatchInstaller):
  def __init__(self, kidsFile, kidsInstallName,
               seqNo = None, logFile = None, multiBuildList=None,
               duz=17, **kargs):
    print kidsInstallName, seqNo
    assert kidsInstallName == "XU*8.0*599" and int(seqNo) == 481
    DefaultKIDSPatchInstaller.__init__(self, kidsFile,
                                       kidsInstallName,
                                       seqNo, logFile,
                                       multiBuildList,
                                       duz, **kargs)
  """
    @override DefaultKIDSPatchInstaller.runPostInstallationRoutine
  """
  def runPostInstallationRoutine(self, connection, **kargs):
    connection.expect("ZTMGRSET Version")
    connection.expect("Should I continue\? N//")
    connection.send("Y\r")
    connection.expect("System: [0-9]+//")
    connection.send("\r")
    connection.expect("Patch number to load: ")
    connection.send("599\r")
