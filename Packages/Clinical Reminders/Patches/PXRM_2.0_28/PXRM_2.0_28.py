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

from DefaultKIDSBuildInstaller import DefaultKIDSBuildInstaller

class CustomInstaller(DefaultKIDSBuildInstaller):
  def __init__(self, kidsFile, kidsInstallName,
               seqNo = None, logFile = None, multiBuildList=None,
               duz=17, **kargs):
    print kidsInstallName, seqNo
    assert kidsInstallName == "PXRM*2.0*28" and int(seqNo) == 22
    DefaultKIDSBuildInstaller.__init__(self, kidsFile,
                                       kidsInstallName,
                                       seqNo, logFile,
                                       multiBuildList,
                                       duz, **kargs)
  """
    @override DefaultKIDSBuildInstaller.runPostInstallationRoutine
  """
  def runPostInstallationRoutine(self, connection, **kargs):
    # handle the question asked during installing reminder process
    while True:
      index = connection.expect([" Select one of the following:",
                                 "Linking and enabling dialogs"],
                                timeout=120)
      if index == 0: # just quit the installation
        connection.expect("Enter response: ")
        connection.send("Q\r") # Quit installation
        continue
      else:
        break
