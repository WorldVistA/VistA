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

from builtins import object
import re
import sys
# constant for reuse
DD_OUTPUT_FROM_WHAT_FILE = "OUTPUT FROM WHAT FILE:"
DD_INPUT_TO_WHAT_FILE = "INPUT TO WHAT FILE:"

"""
  Utilitity Class to access VistA Menus System
"""
class VistAMenuUtil(object):
  def __init__(self, duz):
    self._duz = duz
    pass
  """
    If not specified,
      in goto***Menu function call, vistAClient should be in ready state.
      after exit***Menu function call, vistAClient should also be in ready state.
  """
  """
    EVE System Menu
  """
  def gotoSystemMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    vistAClient.waitForPrompt()
    connection.send("K  \r")
    vistAClient.waitForPrompt()
    connection.send("S DUZ=%s D ^XUP\r" % self._duz)
    connection.expect("Select OPTION NAME: ")
    connection.send("EVE\r")
    connection.expect("CHOOSE 1-")
    connection.send("1\r")
    index = connection.expect(["Select Systems Manager Menu ", "to continue"])
    if index == 1:
      connection.send("\r")
      connection.expect("Select Systems Manager Menu ")

  def exitSystemMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select Systems Manager Menu ")
    connection.send("\r")
    connection.expect("Do you really want to halt\?")
    connection.send("\r")
    vistAClient.waitForPrompt()
    connection.send("\r")

  """ Programmer Options """
  def gotoProgrammerMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoSystemMenu(vistAClient)
    connection.send("Programmer Options\r")
    connection.expect("Select Programmer Options ")

  def exitProgrammerMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select Programmer Options ")
    connection.send("\r")
    self.exitSystemMenu(vistAClient)

  """ KIDS Menu SubSection """
  def gotoKidsMainMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoProgrammerMenu(vistAClient)
    connection.send("KIDS\r")
    connection.expect("Select Kernel Installation \& Distribution System ")

  def exitKidsMainMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select Kernel Installation \& Distribution System")
    connection.send("\r")
    self.exitProgrammerMenu(vistAClient)

  def gotoKidsUtilMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoKidsMainMenu(vistAClient)
    connection.send("Utilities\r")
    connection.expect("Select Utilities ")

  def exitKidsUtilMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.send("\r")
    self.exitKidsMainMenu(vistAClient)

  """ Taskman Menu SubSection """
  def gotoTaskmanMainMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoSystemMenu(vistAClient)
    connection.send("Taskman Management\r")
    connection.expect("Select Taskman Management ")

  def exitTaskmanMainMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select Taskman Management ")
    connection.send("\r")
    self.exitSystemMenu(vistAClient)

  def gotoTaskmanMgrUtilMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoTaskmanMainMenu(vistAClient)
    connection.send("Taskman Management Utilities\r")
    connection.expect("Select Taskman Management Utilities ")

  def exitTaskmanMgrUtilMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select Taskman Management Utilities ")
    connection.send("\r")
    self.exitTaskmanMainMenu(vistAClient)

  def gotoTaskmanEditParamMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoTaskmanMgrUtilMenu(vistAClient)
    connection.send("Edit Taskman Parameters\r")
    connection.expect("Select Edit Taskman Parameters ")

  def exitTaskmanEditParamMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select Edit Taskman Parameters ")
    connection.send("\r")
    self.exitTaskmanMgrUtilMenu(vistAClient)

  """ HL7 Menu SubSection """
  def gotoHL7MainMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoSystemMenu(vistAClient)
    connection.send("HL7 Main Menu\r")
    connection.expect("Select HL7 Main Menu ")

  def exitHL7MainMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select HL7 Main Menu ")
    connection.send("\r")
    self.exitSystemMenu(vistAClient)

  def gotoHL7FilerLinkMgrMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoHL7MainMenu(vistAClient)
    connection.send("Filer and Link Management Options\r")
    connection.expect("Select Filer and Link Management Options ")

  def exitHL7FilerLinkMgrMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select Filer and Link Management Options ")
    connection.send("\r")
    self.exitHL7MainMenu(vistAClient)

  """ Mailman Menu Sub-Section """

  def gotoMailmanMasterMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoSystemMenu(vistAClient)
    connection.send("Mailman Master Menu\r")
    connection.expect("Select MailMan Master Menu ")

  def exitMailmanMasterMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select MailMan Master Menu ")
    connection.send("\r")
    self.exitSystemMenu(vistAClient)

  def gotoMailmanManageMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoMailmanMasterMenu(vistAClient)
    connection.send("Manage Mailman\r")
    index = connection.expect(["to continue","Select Manage Mailman "])
    if index == 0:
      connection.send("^\r")
      connection.expect("Select Manage Mailman ")

  def exitMailmanManageMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select Manage Mailman ")
    connection.send("\r")
    self.exitMailmanMasterMenu(vistAClient)

  def gotoMailmanLocalDeliveryMgrMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoMailmanManageMenu(vistAClient)
    connection.send("Local Delivery Management\r")
    connection.expect("Select Local Delivery Management ")

  def exitMailmanLocalDeliveryMgrMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.expect("Select Local Delivery Management ")
    connection.send("\r")
    self.exitMailmanManageMenu(vistAClient)

  """
    FileMan Menu Section
  """
  def gotoFileManMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    vistAClient.waitForPrompt()
    connection.send("S DUZ=%s D Q^DI\r" % self._duz)
    connection.expect("Select OPTION:")

  def exitFileManMenu(self, vistAClient, waitOption=True):
    connection = vistAClient.getConnection()
    if waitOption:
      connection.expect("Select OPTION: ")
    connection.send("\r")
    vistAClient.waitForPrompt()
    connection.send("\r")

  def gotoFileManEditEnterEntryMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoFileManMenu(vistAClient)
    connection.send("1\r" )# enter or edit entry
    connection.expect(DD_INPUT_TO_WHAT_FILE)

  def gotoFileManPrintFileEntryMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoFileManMenu(vistAClient)
    connection.send("2\r" ) # print file entry
    connection.expect(DD_OUTPUT_FROM_WHAT_FILE)

  def gotoFileManSearchFileEntryMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoFileManMenu(vistAClient)
    connection.send("3\r") # search file entry
    connection.expect(DD_OUTPUT_FROM_WHAT_FILE)

  def gotoFileManInquireFileEntryMenu(self, vistAClient):
    connection = vistAClient.getConnection()
    self.gotoFileManMenu(vistAClient)
    connection.send("5\r" ) # inquiry file entry
    connection.expect(DD_OUTPUT_FROM_WHAT_FILE)
