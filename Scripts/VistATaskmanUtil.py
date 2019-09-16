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

from __future__ import with_statement
from __future__ import division
from __future__ import print_function
from builtins import object
from past.utils import old_div
import sys
import os
import argparse
import time
from VistAMenuUtil import VistAMenuUtil
from LoggerManager import logger, initConsoleLogging, getTempLogFile
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from VistAPackageInfoFetcher import findChoiceNumber

def getBoxVolPair(vistAClient):
  connection = vistAClient.getConnection()
  vistAClient.waitForPrompt()
  connection.send("D GETENV^%ZOSV W Y\r")
  vistAClient.waitForPrompt()
  retValue = connection.lastconnection
  retValue = retValue.split('^')[-1].split('\r\n')[0]
  connection.send('\r')
  return retValue

class VistATaskmanUtil(object):
  """ Enum for taskman Status """
  TASKMAN_STATUS_UNKNOWN = -1
  TASKMAN_STATUS_RUNNING_CURRENT = 0
  TASKMAN_STATUS_RUNNING_BEHIND = 1
  TASKMAN_STATUS_WAIT = 2
  TASKMAN_STATUS_SHUTDOWN = 3
  TASKMAN_STATUS_ERROR_STATE = 4
  TASKMAN_STATUS_LAST = 5

  def __init__(self):
    pass

  def verifyTaskmanSiteParameter(self, vistAClient, autoFix=True):
    retValue = True
    connection = vistAClient.getConnection()
    menuUtil = VistAMenuUtil(duz=1)
    boxVolPair = getBoxVolPair(vistAClient)
    logger.debug("Box:Vol Pair is [%s] " % boxVolPair)
    menuUtil.gotoTaskmanEditParamMenu(vistAClient)
    connection.send("Site Parameters Edit\r")
    connection.expect("Select TASKMAN SITE PARAMETERS BOX-VOLUME PAIR: ")
    connection.send("?\r")
    connection.expect("Answer with TASKMAN SITE PARAMETERS BOX-VOLUME PAIR.*?:")
    connection.expect("You may enter a new TASKMAN SITE PARAMETERS")
    curBoxVol = connection.lastconnection.strip(' \r\n')
    curBoxVol = [x.strip(' ') for x in curBoxVol.split('\r\n')]
    logger.debug("Box:Vol Pair is [%s] " % curBoxVol)
    if boxVolPair not in curBoxVol :
      logger.error("taskman site parameter mismatch, current:[%s], correct:[%s]" %
                    (curBoxVol, boxVolPair))
      if autoFix:
        self.__fixTaskmanSiteParameter__(connection, curBoxVol[0], boxVolPair)
      else:
        retValue = False
    connection.expect("Select TASKMAN SITE PARAMETERS BOX-VOLUME PAIR: ")
    connection.send('\r')
    menuUtil.exitTaskmanEditParamMenu(vistAClient)
    return retValue

  def getTaskmanStatus(self, vistAClient):
    connection = vistAClient.getConnection()
    menuUtil = VistAMenuUtil(duz=1)
    menuUtil.gotoTaskmanMgrUtilMenu(vistAClient)
    connection.send("MTM\r") #  Monitor Taskman
    curStatus = self.__getTaskmanStatus__(connection)
    connection.send("^\r")
    menuUtil.exitTaskmanMgrUtilMenu(vistAClient)
    return curStatus

  @staticmethod
  def isTaskmanRunningCurrent(status):
    return status == VistATaskmanUtil.TASKMAN_STATUS_RUNNING_CURRENT

  @staticmethod
  def isTaskmanInWaitState(status):
    return status == VistATaskmanUtil.TASKMAN_STATUS_WAIT

  def waitTaskmanToCurrent(self, vistAClient, timeOut=120):
    DEFAULT_POLL_INTERVAL = 1 # 1 seconds
    MaxRetry = old_div(timeOut,DEFAULT_POLL_INTERVAL)
    startRetry = 0
    connection = vistAClient.getConnection()
    menuUtil = VistAMenuUtil(duz=1)
    menuUtil.gotoTaskmanMgrUtilMenu(vistAClient)
    connection.send("MTM\r") #  Monitor Taskman
    while startRetry < MaxRetry:
      curStatus = self.__getTaskmanStatus__(connection)
      if self.isTaskmanRunningCurrent(curStatus):
        break;
      else:
        startRetry += 1
        time.sleep(DEFAULT_POLL_INTERVAL)
        connection.send("\r")
    if startRetry >= MaxRetry:
      logger.error("Time out while waiting Taskman to Current")
    connection.send("^\r")
    menuUtil.exitTaskmanMgrUtilMenu(vistAClient)

  def stopTaskman(self, vistAClient, shutdownSubMgrs=True,
                  shutdownActJobs=True):
    connection = vistAClient.getConnection()
    menuUtil = VistAMenuUtil(duz=1)
    connection.send('D GROUP^ZTMKU("SSUB(NODE)")\n')
    vistAClient.waitForPrompt()
    connection.send('D GROUP^ZTMKU("SMAN(NODE)")\n')
    # menuUtil.gotoTaskmanMgrUtilMenu(vistAClient)
    # connection.send("Stop Task Manager\r")
    # connection.expect("Are you sure you want to stop TaskMan\? ")
    # connection.send("YES\r")
    # connection.expect("Should active submanagers shut down after finishing their current tasks\? ")
    # if shutdownSubMgrs:
      # connection.send("YES\r")
    # else:
      # connection.send("NO\r")
    # connection.expect("Should active jobs be signaled to stop\? ")
    # if shutdownActJobs:
      # connection.send("YES\r")
    # else:
      # connection.send("NO\r")
    # menuUtil.exitTaskmanMgrUtilMenu(vistAClient)
    logger.info("Wait 30 seconds for Taskman to stop")
    time.sleep(30)

  def placeTaskmanToWait(self, vistAClient, shutdownSubMgrs=True):
    connection = vistAClient.getConnection()
    menuUtil = VistAMenuUtil(duz=1)
    menuUtil.gotoTaskmanMgrUtilMenu(vistAClient)
    connection.send("Place Taskman in a WAIT State\r")
    connection.expect("Should active submanagers shut down after finishing their current tasks\? ")
    if shutdownSubMgrs:
      connection.send("YES\r")
    else:
      connection.send("NO\r")
    menuUtil.exitTaskmanMgrUtilMenu(vistAClient)
    logger.info("Wait 10 seconds for Taskman to wait state")
    time.sleep(10)

  def removeTaskmanFromWait(self, vistAClient):
    connection = vistAClient.getConnection()
    menuUtil = VistAMenuUtil(duz=1)
    menuUtil.gotoTaskmanMgrUtilMenu(vistAClient)
    connection.send("Remove Taskman from WAIT State\r")
    menuUtil.exitTaskmanMgrUtilMenu(vistAClient)
    logger.info("Wait 10 seconds for Taskman to start")
    time.sleep(10)

  def shutdownAllTasks(self, vistAClient):
    self.stopMailManBackgroundFiler(vistAClient)
    self.stopHL7BackgroundFiler(vistAClient)
    self.stopTaskman(vistAClient)

  def stopMailManBackgroundFiler(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.send("D STOP^XMKPL\n")
    connection.expect("Are you sure you want the Background Filers to stop delivering mail\? ")
    connection.send("YES\r")
    vistAClient.waitForPrompt()
    logger.info("Wait 30 seconds for Mailman background filer to stop")
    time.sleep(30)

  def stopHL7BackgroundFiler(self, vistAClient):
    connection = vistAClient.getConnection()
    connection.send("D LLP^HLCS2(1)\n")
    vistAClient.waitForPrompt()
    connection.send("D STOPLM^HLCSLM\n")
    vistAClient.waitForPrompt()
    logger.info("Wait 30 seconds for HL7 background filer to stop")
    time.sleep(30)

  """ Start taskman, it will not restart taskman if it is already started """
  def startTaskman(self, vistAClient, waitToCurrent=True):
    self.verifyTaskmanSiteParameter(vistAClient)
    connection = vistAClient.getConnection()
    menuUtil = VistAMenuUtil(duz=1)
    menuUtil.gotoTaskmanMgrUtilMenu(vistAClient)
    connection.send("Restart Task Manager\r")
    index = connection.expect(["ARE YOU SURE YOU WANT TO RESTART ANOTHER TASKMAN\?",
                               "ARE YOU SURE YOU WANT TO RESTART TASKMAN\?"])
    if index == 0:
      connection.send("NO\r")
    elif index == 1:
      connection.send("YES\r")
      connection.expect("Restarting...TaskMan restarted\!")
    menuUtil.exitTaskmanMgrUtilMenu(vistAClient)
    curStatus = self.getTaskmanStatus(vistAClient)
    if self.isTaskmanInWaitState(curStatus):
      self.removeTaskmanFromWait(vistAClient)
    if waitToCurrent:
      if not self.isTaskmanRunningCurrent(curStatus):
        self.waitTaskmanToCurrent(vistAClient)

  """
    Internal Implementation
  """
  """ Fixed the BOX-VOLUME Pair """
  def __fixTaskmanSiteParameter__(self, connection, curBoxVol, boxVol):
    connection.expect("Select TASKMAN SITE PARAMETERS BOX-VOLUME PAIR: ")
    connection.send("%s\r" % curBoxVol)
    while True:
      index = connection.expect(["BOX-VOLUME PAIR: %s//" % curBoxVol,
                                 "CHOOSE [0-9]+-[0-9]+"])
      if index == 0:
        break
      else:
        choice = findChoiceNumber(connection.lastconnection, curBoxVol)
        if choice:
          connection.send('%s\r' % choice)
        else:
          connection.send('\r') # no match continue
    connection.send("%s\r" % boxVol)
    connection.expect(["//", ': '])
    connection.send("^\r")

  def __getTaskmanStatus__(self, connection):
    connection.expect("Checking Taskman. ")
    connection.expect("Taskman is ")
    connection.expect("Checking the Status List:")
    statusString = connection.lastconnection.strip(' \r\n').split('\r\n')[0]
    logger.debug("Status String is %s" % statusString)
    connection.expect("Node        weight  status      time       \$J")
    connection.expect("Checking the Schedule List:")
    detailedStatus = connection.lastconnection.strip(' \r\n')
    logger.debug("Detailed Status String is %s" % detailedStatus)
    connection.expect("Enter monitor action: UPDATE//")
    return self.__taskmanStatusStringToEnum__(statusString, detailedStatus)

  """ map taskman status to enum """
  def __taskmanStatusStringToEnum__(self, statusString, detailedStatus):
    if ( (statusString == "shutting down not running.." or
          statusString == "not running..") and
        detailedStatus == "The Status List is empty."):
      return self.TASKMAN_STATUS_SHUTDOWN

    if (statusString == "current.." and
        detailedStatus.find("Main Loop") >= 0):
      return self.TASKMAN_STATUS_RUNNING_CURRENT

    if (detailedStatus.find("WAIT") >=0 and
        detailedStatus.find("Taskman Waiting") >=0):
      return self.TASKMAN_STATUS_WAIT

    return self.TASKMAN_STATUS_UNKNOWN

DEFAULT_OUTPUT_LOG_FILE_NAME = "TaskmanUtil.log"

def main():
  import logging
  initConsoleLogging(logging.INFO)
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA Taskman Utilities',
                                   parents=[testClientParser])
  parser.add_argument('-a', '--action', required=True,
                      choices=['Start', 'Stop', 'Shutdown'],
    help='Start:Start Taskman, Stop:Stop Taskman, Shutdown:Shutdown all tasks')
  result = parser.parse_args();
  print(result)
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  with testClient as vistAClient:
    logFilename = getTempLogFile(DEFAULT_OUTPUT_LOG_FILE_NAME)
    print("Log File is %s" % logFilename)
    vistAClient.setLogFile(logFilename)
    taskmanUtil = VistATaskmanUtil()
    actionMap = {"Start": taskmanUtil.startTaskman,
                 "Stop": taskmanUtil.stopTaskman,
                 "Shutdown": taskmanUtil.shutdownAllTasks}
    actionMap[result.action](vistAClient)

if __name__ == '__main__':
  main()
