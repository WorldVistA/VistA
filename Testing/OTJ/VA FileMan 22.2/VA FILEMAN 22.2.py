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

import os
import sys

# add current dir to system path
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPT_DIR)

from VistAInitFileMan import installFileMan22_2
from DefaultKIDSBuildInstaller import DefaultKIDSBuildInstaller

FILEMAN_22V2_ROUTINE_IMPORT_FILE = os.path.join(SCRIPT_DIR,
                                                "VA-FILEMAN-22P2.RSA.sha1")

""" This is an example of custom installer to handle post install questions
    Requirement for custom installer python script:
    1. Must be a class named CustomInstaller
    2. The constructor __init__ takes the exact arguments as the
       DefaultKIDSBuildInstaller
    3. Prefer to be a subclass of DefaultKIDSBuildInstaller
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
    @override DefaultKIDSBuildInstaller.runInstallation
  """
  def runInstallation(self, vistATestClient, reinst=False):
    installFileMan22_2(vistATestClient, FILEMAN_22V2_ROUTINE_IMPORT_FILE)
    return True
