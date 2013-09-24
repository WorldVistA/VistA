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
from __future__ import with_statement
import os # to get gtm environment variables
import sys
import subprocess
import re
import argparse
from LoggerManager import logger, initConsoleLogging


""" Utility class to find out the OS platform """
def isLinuxSystem():
  return sys.platform.startswith("linux")
def isWindowsSystem():
  return sys.platform.startswith("win")

""" import right pexpect package """
filedir = os.path.dirname(os.path.abspath(__file__))
pexpectdir = os.path.normpath(os.path.join(filedir, "../Python/Pexpect"))
sys.path.append(pexpectdir)
if isLinuxSystem():
  import pexpect
  from pexpect import TIMEOUT, ExceptionPexpect
else:
  from pexpect import TIMEOUT
  from winpexpect import winspawn

DEFAULT_TIME_OUT_VALUE = 30
CACHE_PROMPT_END = ">"

""" Base class of a VistA Test Client
"""
class VistATestClient(object):
  PLATFORM_NONE = 0
  CACHE_ON_WINDOWS = 1
  CACHE_ON_LINUX = 2
  GTM_ON_LINUX = 3
  PLATFORM_LAST = 4
  def __init__(self, platform, prompt = None, namespace = None):
    self._connection = None
    assert int(platform) > self.PLATFORM_NONE and int(platform) < self.PLATFORM_LAST
    self._platform = platform
    self._prompt = prompt
    self._namespace = namespace
    self._instance = None
  def createConnection(self, command, instance,
                       username = None, password = None):
    pass
  def waitForPrompt(self, timeout=None):
    self._connection.expect(self._prompt, timeout)
  def getConnection(self):
    return self._connection
  def getPrompt(self):
    return self._prompt
  def getNamespace(self):
    return self._namespace
  def getPlatForm(self):
    return self._platform
  def isCache(self):
    return (self._platform == self.CACHE_ON_WINDOWS or
            self._platform == self.CACHE_ON_LINUX)
  def isGTM(self):
    return self._platform == self.GTM_ON_LINUX
  def setLogFile(self, logFilename):
    self._connection.logfile = open(logFilename, 'wb')
  def getInstanceName(self):
    return self._instance
  """ Implementation context manager methods """
  def __enter__(self):
    return self
  def __exit__(self, exc_type, exc_value, traceback):
    logger.debug("__exit__ is called %s,%s,%s" % (exc_type, exc_value, traceback))
    connection = self._connection
    if exc_type is KeyboardInterrupt:
      connection.terminate()
      return True
    if connection is not None and connection.isalive():
    # try to close the connection gracefully
      try:
        for i in range(0,3):
          connection.send("^\r") # get out of the MENU prompt by sending ^
          connection.send("\r") # get out of the MENU prompt by sendng \r
        connection.send("Q\r") # clean up any stack
        self.waitForPrompt(1) # wait for VistA prompt for 1 seconds
        connection.send("H\r") # Halt VistA connection
      except Exception as ex:
        logger.error(ex)
      if isLinuxSystem():
        if connection.isalive():
          """ pexpect close() will close all open handlers and is non-blocking """
          try:
            connection.close()
          except ExceptionPexpect as ose:
            logger.error(ose)
    connection.terminate()
    return
  def __del__(self):
    if self._connection is not None:
      self._connection.terminate()

""" implementation of GTM test client in linux """
class VistATestClientGTMLinux(VistATestClient):
  DEFAULT_GTM_PROMPT = "GTM>"
  DEFAULT_GTM_COMMAND = "mumps -direct"

  def __init__(self):
    gtm_prompt = os.getenv("gtm_prompt")
    if not gtm_prompt:
      gtm_prompt = self.DEFAULT_GTM_PROMPT
    gtm_dist = os.getenv("gtm_dist")
    if gtm_dist:
      self.DEFAULT_GTM_COMMAND = os.path.join(gtm_dist,
                                              self.DEFAULT_GTM_COMMAND)
    VistATestClient.__init__(self, self.GTM_ON_LINUX, gtm_prompt, None)
  def createConnection(self, command, instance,
                       username = None, password = None):
    if not command:
      command = self.DEFAULT_GTM_COMMAND
    self._connection = pexpect.spawn(command, timeout = DEFAULT_TIME_OUT_VALUE)
    assert self._connection.isalive()

""" common base class for cache test client """
class VistATestClientCache(VistATestClient):
  def __init__(self, platform, prompt = None, namespace = None):
    VistATestClient.__init__(self, platform, prompt, namespace)
  def __changeNamesapce__(self):
    self._connection.expect('>')
    self._connection.send("znspace \"%s\"\r" % self.getNamespace())
  def __signIn__(self, username, password):
    child = self._connection
    child.expect("Username:")
    child.send("%s\r" % username)
    child.expect("Password:")
    child.send("%s\r" % password)

""" Implementation of Cache on windows system
    Make sure that plink is in you %path%
"""
class VistATestClientCacheWindows(VistATestClientCache):
  DEFAULT_WIN_TELNET_CMD =  "plink.exe -telnet 127.0.0.1 -P 23"
  def __init__(self, namespace):
    assert namespace, "Must provide a namespace"
    prompt = namespace + CACHE_PROMPT_END
    VistATestClientCache.__init__(self, self.CACHE_ON_WINDOWS, prompt, namespace)
  def createConnection(self, command, instance,
                       username = None, password = None):
    if not command:
      command = self.DEFAULT_WIN_TELNET_CMD
    self._instance = instance
    self._connection = winspawn(command, timeout = DEFAULT_TIME_OUT_VALUE)
    assert self._connection.isalive()
    if username and password:
      self.__signIn__(username, password)
    self.__changeNamesapce__()

""" Implementation of Cache on Linux system """
class VistATestClientCacheLinux(VistATestClientCache):
  DEFAULT_CACHE_CMD = "ccontrol session"
  def __init__(self, namespace):
    assert namespace, "Must provide a namespace"
    prompt = namespace + CACHE_PROMPT_END
    VistATestClientCache.__init__(self, self.CACHE_ON_LINUX, prompt, namespace)
  def createConnection(self, command, instance,
                       username = None, password = None):
    if not command:
      assert instance
      command = "%s %s" % (self.DEFAULT_CACHE_CMD, instance)
    self._instance = instance
    self._connection = pexpect.spawn(command, timeout = DEFAULT_TIME_OUT_VALUE)
    assert self._connection.isalive()
    if username and password:
      self.__signIn__(username, password)
    self.__changeNamesapce__()

""" constants for default value """
DEFAULT_NAMESPACE = "VISTA"
DEFAULT_INSTANCE = "CACHE"

""" generate argument parse for VistATestClientFactory """
def createTestClientArgParser():
  parser = argparse.ArgumentParser(add_help=False) # no help page
  argGroup = parser.add_argument_group('Connection Auguments',
                            "Argument for connecting to a VistA instance")
  argGroup.add_argument('-S', '--system', required=True, choices=[1,2], type=int,
                      help='1: Cache, 2: GTM')
  argGroup.add_argument('-CN', '--namespace', default=DEFAULT_NAMESPACE,
                help="namespace for Cache, default is %s" % DEFAULT_NAMESPACE)
  argGroup.add_argument('-CI', '--instance', default = DEFAULT_INSTANCE,
                help='Cache instance name, default is %s' % DEFAULT_INSTANCE)
  argGroup.add_argument('-CU', '--cacheuser', default=None,
                help='Cache username for authentication, default is None')
  argGroup.add_argument('-CP', '--cachepass', default=None,
                help='Cache password for authentication, default is None')
  return parser

class VistATestClientFactory(object):
  """ constants for SYSTEM """
  SYSTEM_NONE = 0
  SYSTEM_CACHE = 1
  SYSTEM_GTM = 2
  SYSTEM_LAST = 3

  @staticmethod
  def createVistATestClientWithArgs(arguments):
    return VistATestClientFactory.createVistATestClient(
                                 system=arguments.system,
                                 namespace=arguments.namespace,
                                 instance=arguments.instance,
                                 username=arguments.cacheuser,
                                 password=arguments.cachepass)
  @staticmethod
  def createVistATestClient(system, prompt = None,
                    namespace = DEFAULT_NAMESPACE, instance = DEFAULT_INSTANCE,
                    command = None, username = None, password = None):
    testClient = None
    assert (system > VistATestClientFactory.SYSTEM_NONE and
            system < VistATestClientFactory.SYSTEM_LAST)
    if VistATestClientFactory.SYSTEM_CACHE == system:
      if isLinuxSystem():
        testClient = VistATestClientCacheLinux(namespace)
      elif isWindowsSystem():
        testClient = VistATestClientCacheWindows(namespace)
    elif VistATestClientFactory.SYSTEM_GTM == system:
      if isLinuxSystem():
        testClient = VistATestClientGTMLinux()
    if not testClient:
      raise Exception ("Could not create VistA Test Client")
    testClient.createConnection(command, instance, username, password)
    return testClient

def main():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA Test Client Demo',
                                   parents=[testClientParser])
  result = parser.parse_args();
  print (result)
  import logging
  initConsoleLogging(logging.INFO)
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  """ this is to test the context manager to make sure the resource
      is clean up even there is an exception
  """
  with testClient as client:
    raise Exception("Test Exception")

if __name__ == '__main__':
  main()
