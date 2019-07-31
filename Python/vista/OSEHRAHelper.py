#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
# Copyright 2017 Sam Habiel. writectrl methods.
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

## @package OSEHRAHelper
## OSEHRA test helper

'''
OSEHRAHelper provides classes that establish connections to VistA
and interaction methods such as write() and wait()

@copyright The Open Source Electronic Health Record Agent
@license http://www.apache.org/licenses/LICENSE-2.0
'''
from __future__ import print_function

from builtins import str
from builtins import range
from builtins import object
import sys
import os, errno
import telnetlib
import TestHelper
import time
import re
import logging
import csv

filedir = os.path.dirname(os.path.abspath(__file__))
pexpectdir = os.path.normpath(os.path.join(filedir, "../Pexpect"))
import socket
paramikoedir = os.path.normpath(os.path.join(filedir, "../"))
sys.path.append(pexpectdir)
sys.path.append(paramikoedir)

try:
  import pexpect
  no_pexpect = None
except ImportError as no_pexpect:
  pass

try:
  import paramiko
  no_paramiko = None
except ImportError as no_paramiko:
  pass

#---------------------------------------------------------------------------
# Initial Global Variables to use over the course of connecting

# connection=False
# log =False

#---------------------------------------------------------------------------
class PROMPT(object):
  """Wait for a VISTA> prompt in current namespace."""

class ConnectMUMPS(object):
  def exitToPrompt(self):
    self.write("Quit")
    while True:
      try:
        index2 = self.multiwait(["to continue","Option:",self.prompt, "want to halt","[0-9]+d[0-9]+"])
      except TIMEOUT:
        continue
      if index2 == 1:
        self.write("Continue")
        self.wait("Do you want to halt")
        self.write("Y")
        self.wait(self.prompt)
        break
      if index2 == 2:
        break
      if index2 == 3:
        self.write("Y")
      if index2 == 4:
        self.write("Q")
      self.write("^")
    self.MenuLocation=[]

  def ZN(self, namespace):
    self.wait('>')
    self.write('ZN "' + namespace + '"')
    self.namespace = namespace
    self.prompt = self.namespace + '>'

  def login(self, username, password):
    self.wait('Username:')
    self.write(username)
    self.wait('Password')
    self.write(password)

  def getenv(self, volume):
    self.write('D GETENV^%ZOSV W Y')
    if sys.platform == 'win32':
      match = self.wait_re(volume + ':.+\s', None)
      test = match[1].span()
      VistAboxvol = ''
      for i in range(test[0], test[1]):
        VistAboxvol = VistAboxvol + match[2][i]
      self.boxvol = VistAboxvol.strip()
    else:
      self.wait_re(volume + ':.+\s', None)
      self.boxvol = self.connection.after.strip()

  def IEN(self, file, objectname):
    self.write('S DUZ=1 D Q^DI')
    self.wait('OPTION')
    self.write('5')
    self.wait_re('FILE:')
    self.write(file)
    self.wait(file + ' NAME')
    self.write(objectname + '\r')
    self.wait_re('CAPTIONED OUTPUT?')
    self.write('N')
    self.wait_re('PRINT FIELD')
    self.write('NUMBER\r')
    self.wait('Heading')
    self.write('')
    self.wait('DEVICE')
    if sys.platform == 'win32':
      self.write('\r')
      match = self.wait_re('\r\n[0-9]+')
      test = match[1].span()
      number = ''
      for i in range(test[0], test[1]):
        number = number + match[2][i]
      number = number.lstrip('\r\n')
      self.IENumber = number
    else:
      self.write('')
      self.wait_re('\n[0-9]+')
      number = self.connection.after
      number = number.lstrip('\r\n')
      self.IENumber = number
    self.write('')

class ConnectWinCache(ConnectMUMPS):
  def __init__(self, logfile, instance, namespace, location='127.0.0.1'):
    super(ConnectMUMPS, self).__init__()
    self.connection = telnetlib.Telnet(location, 23)
    if len(namespace) == 0:
      namespace = 'VISTA'
    self.namespace = namespace
    self.prompt = self.namespace + '>'
    self.log = open(logfile, 'w')
    self.type = 'cache'
    path,filename = os.path.split(logfile)
    self.MenuLocation=[]
    self.lastconnection=""
    self.optionParentDict = []
    self.optionMenuTextDict = []

  def write(self, command):
    self.connection.write(command.encode('utf-8') + b'\r')
    logging.debug('connection.write:' + command)
    self.log.flush()

  def writectrl(self, command):
    self.connection.write(command.encode('utf-8'))
    logging.debug('connection.writectrl: ' + command)

  def wait(self, command, tout=15):
    logging.debug('connection.expect: ' + str(command))
    if command is PROMPT:
      command = self.namespace + '>'
    rbuf = self.connection.read_until(command.encode('utf-8'), tout).decode('utf-8')
    if rbuf.find(command) == -1:
        command=str(command)
        rbuf=str(rbuf)
        self.log.write('ERROR: expected: ' + command + 'actual: ' + rbuf)
        logging.debug('ERROR: expected: ' + command + 'actual: ' + rbuf)
        raise TestHelper.TestError('ERROR: expected: ' + command + 'actual: ' + rbuf)
    else:
        self.log.write(rbuf)
        logging.debug(rbuf)
        self.lastconnection=rbuf
        return 1

  def wait_re(self, command, timeout=30):
    logging.debug('connection.expect: ' + str(command))
    if command is PROMPT:
      command = self.prompt
    compCommand = re.compile(command,re.I)
    output = self.connection.expect([compCommand], timeout)
    self.match = output[1]
    self.before = output[2]
    if output[0] == -1 and output[1] == None:
      raise Exception("Timed out")
    if output[2]:
      self.log.write(output[2].decode('utf-8'))
      self.log.flush()
      self.lastconnection=output[2]
      return output

  def multiwait(self, options, tout=15):
    logging.debug('connection.expect: ' + str(options))
    encodedOptions = []
    if isinstance(options, list):
      for option in options:
        encodedOptions.append(option.encode('utf-8'))
      index = self.connection.expect(encodedOptions, tout)
      if index == -1:
        logging.debug('ERROR: expected: ' + str(options))
        raise TestHelper.TestError('ERROR: expected: ' + str(options))
      self.log.write(index[2].decode('utf-8'))
      self.lastconnection=index[2]
      return index[0]
    else:
      raise IndexError('Input to multiwait function is not a list')

  def startCoverage(self, routines=['*']):
    self.write('D ^%SYS.MONLBL')
    rval = self.multiwait(['Stop Monitor', 'Start Monitor'])
    if rval == 0:
        self.write('1')
        self.wait('Start Monitor')
        self.write('1')
    elif rval == 1:
        self.write('1')
    else:
        raise TestHelper.TestError('ERROR starting monitor, rbuf: ' + rval)
    for routine in routines:
        self.wait('Routine Name')
        self.write(routine)
    self.wait('Routine Name', tout=120)
    self.write('')
    self.wait('choice')
    self.write('2')
    self.wait('choice')
    self.write('1')
    self.wait('continue')
    self.write('\r')

  def stopCoverage(self, path, humanreadable='OFF'):
    newpath, filename = os.path.split(path)
    self.write('D ^%SYS.MONLBL')
    self.wait('choice')
    if humanreadable == 'ON':
      self.write('5')
      self.wait('summary')
      self.write('Y')
    else:
      self.write('6')
      self.wait('Routine number')
      self.write('*')
    self.wait('FileName')
    self.write(newpath + '/Coverage/' + filename.replace('.log', '.cmcov').replace('.txt', '.cmcov'))
    self.wait('continue')
    self.write('')
    self.wait('choice')
    self.write('1\r')

class ConnectLinuxCache(ConnectMUMPS):
  def __init__(self, logfile, instance, namespace, location='127.0.0.1'):
    super(ConnectMUMPS, self).__init__()
    self.connection = pexpect.spawn('ccontrol session ' + instance + ' -U ' + namespace, timeout=None)
    if len(namespace) == 0:
      namespace = 'VISTA'
    self.namespace = namespace
    self.prompt = self.namespace + '>'
    self.connection.logfile_read = open(logfile, 'w')
    self.type = 'cache'
    path,filename = os.path.split(logfile)
    self.MenuLocation=[]
    self.lastconnection=""
    self.optionParentDict = []
    self.optionMenuTextDict = []

  def write(self, command):
    self.connection.send(command + '\r')
    logging.debug('connection.write:' + command)

  def writectrl(self, command):
    self.connection.send(command)
    logging.debug('connection.writectrl: ' + command)

  def wait(self, command, tout=15):
    logging.debug('connection.expect: ' + str(command))
    if command is PROMPT:
      command = self.namespace + '>'
    rbuf = self.connection.expect_exact(command.encode('utf-8'), tout)
    if rbuf == -1:
        logging.debug('ERROR: expected: ' + command)
        raise TestHelper.TestError('ERROR: expected: ' + command)
    else:
        self.lastconnection=self.connection.before
        return 1

  def wait_re(self, command, timeout=15):
    logging.debug('connection.expect: ' + str(command))
    if not timeout: timeout = -1
    compCommand = re.compile(command,re.I)
    self.connection.expect(compCommand, timeout)
    self.lastconnection=self.connection.before

  def multiwait(self, options, tout=15):
    logging.debug('connection.expect: ' + str(options))
    if isinstance(options, list):
      index = self.connection.expect(options, tout)
      if index == -1:
        logging.debug('ERROR: expected: ' + options)
        raise TestHelper.TestError('ERROR: expected: ' + options)
      self.connection.logfile_read.write(options[index])
      self.lastconnection=self.connection.before
      return index
    else:
      raise IndexError('Input to multiwait function is not a list')

  def startCoverage(self, routines=['*']):
    self.write('D ^%SYS.MONLBL')
    rval = self.multiwait(['Stop Monitor', 'Start Monitor'])
    if rval == 0:
        self.write('1')
        self.wait('Start Monitor')
        self.write('1')
    elif rval == 1:
        self.write('1')
    else:
        raise TestHelper.TestError('ERROR starting monitor, rbuf: ' + rval)
    for routine in routines:
        self.wait('Routine Name')
        self.write(routine)
    self.wait('Routine Name', tout=120)
    self.write('')
    self.wait('choice')
    self.write('2')
    self.wait('choice')
    self.write('1')
    self.wait('continue')
    self.write('\r')

  def stopCoverage(self, path, humanreadable='OFF'):
    newpath, filename = os.path.split(path)
    self.write('D ^%SYS.MONLBL')
    self.wait('choice')
    if humanreadable == 'ON':
      self.write('5')
      self.wait('summary')
      self.write('Y')
    else:
      self.write('6')
      self.wait('Routine number')
      self.write('*')
    self.wait('FileName')
    self.write(newpath + '/Coverage/' + filename.replace('.log', '.cmcov').replace('.txt', '.cmcov'))
    self.wait('continue')
    self.write('')
    self.wait('choice')
    self.write('1\r')

class ConnectLinuxGTM(ConnectMUMPS):
  def __init__(self, logfile, instance, namespace, location='127.0.0.1'):
    super(ConnectMUMPS, self).__init__()
    gtm_command = os.getenv('gtm_dist')+'/mumps -dir'
    self.connection = pexpect.spawn(gtm_command, timeout=None)
    if len(namespace) == 0:
        self.prompt = os.getenv("gtm_prompt")
        if self.prompt == None:
          self.prompt = "GTM>"
    self.connection.logfile_read = open(logfile, 'w')
    self.type = 'GTM'
    path,filename = os.path.split(logfile)
    self.MenuLocation=[]
    self.lastconnection=""
    self.optionParentDict = []
    self.optionMenuTextDict = []
    self.coverageRoutines = ""

  def write(self, command):
    self.connection.send(command + '\r')
    logging.debug('connection.write: ' + command)

  def writectrl(self, command):
    self.connection.send(command)
    logging.debug('connection.writectrl: ' + command)

  def wait(self, command, tout=15):
    logging.debug('connection.expect: ' + str(command))
    if command is PROMPT:
      command = self.prompt
    rbuf = self.connection.expect_exact(command.encode('utf-8'), tout)
    logging.debug('RECEIVED: ' + command)
    if rbuf == -1:
        logging.debug('ERROR: expected: ' + command)
        raise TestHelper.TestError('ERROR: expected: ' + command)
    else:
        self.lastconnection=self.connection.before
        return 1

  def wait_re(self, command, timeout=None):
    logging.debug('connection.expect: ' + str(command))
    if not timeout: timeout = -1
    compCommand = re.compile(command,re.I)
    self.connection.expect(compCommand, timeout)
    self.lastconnection=self.connection.before

  def multiwait(self, options, tout=15):
    logging.debug('connection.expect: ' + str(options))
    if isinstance(options, list):
      index = self.connection.expect(options, tout)
      if index == -1:
        logging.debug('ERROR: expected: ' + str(options))
        raise TestHelper.TestError('ERROR: expected: ' + str(options))
      self.connection.logfile_read.write(options[index])
      self.lastconnection=self.connection.before
      return index
    else:
      raise IndexError('Input to multiwait function is not a list')

  def startCoverage(self, routines=['*']):
    self.write('K ^ZZCOVERAGE VIEW "TRACE":1:"^ZZCOVERAGE"')
    os.environ["ydb_trace_gbl_name"] = "^ZZCOVERAGE"
    os.environ["gtm_trace_gbl_name"] = "^ZZCOVERAGE"
    self.coverageRoutines = routines

  def stopCoverage(self, path, humanreadable='OFF'):
    mypath, myfilename = os.path.split(path)

    try:
      os.makedirs(os.path.join(mypath, 'Coverage'))
    except OSError as exception:
      if exception.errno != errno.EEXIST:
        raise

    self.write('VIEW "TRACE":0:"^ZZCOVERAGE"')
    self.wait(PROMPT)
    self.write('D ^%GO')
    self.wait('Global')
    self.write('ZZCOVERAGE')
    self.wait('Global')
    self.write('')
    self.wait('Label:')
    self.write('')
    self.wait('Format')
    self.write('ZWR')
    self.wait('device')
    self.write(mypath + '/Coverage/' + myfilename.replace('.log', '.mcov').replace('.txt', '.mcov'))
    self.write('')
    self.wait(PROMPT)
    if humanreadable == 'ON':
      try:
        self.write('W $T(GETRTNS^%ut1)')
        self.wait(',NMSPS',.01)
      except:
        print('Human readable coverage requires M-Unit 1.6')
        return
      self.write('')
      self.write('K NMSP')
      self.wait(PROMPT)
      for routine in self.coverageRoutines:
          self.write('S NMSP("' + routine + '")=""')
      self.write('K RTNS D GETRTNS^%ut1(.RTNS,.NMSP)')
      self.wait(PROMPT)
      self.write('K ^ZZCOHORT D RTNANAL^%ut1(.RTNS,"^ZZCOHORT")')
      self.wait(PROMPT)
      self.write('K ^ZZSURVIVORS M ^ZZSURVIVORS=^ZZCOHORT')
      self.wait(PROMPT)
      self.write('D COVCOV^%ut1("^ZZSURVIVORS","^ZZCOVERAGE")')
      self.wait(PROMPT)
      self.write('D COVRPT^%ut1("^ZZCOHORT","^ZZSURVIVORS","^ZZRESULT",-1)')
      self.wait(PROMPT)
      self.write('D ^%GO')
      self.wait('Global')
      self.write('ZZRESULT')
      self.wait('Global')
      self.write('')
      self.wait('Label:')
      self.write('')
      self.wait('Format')
      self.write('ZWR')
      self.wait('device')
      self.write(mypath + '/Coverage/coverageCalc.mcov')
      self.wait(PROMPT)
      self.write('WRITE ^ZZRESULT," ",@^ZZRESULT')
      self.wait(PROMPT)
      self.write('K ^ZZCOHORT,^ZZSURVIVORS,^ZZCOVERAGE,^ZZRESULT')
      self.wait(PROMPT)

class ConnectRemoteSSH(ConnectMUMPS):
  """
  This will provide a connection to VistA via SSH. This class handles any
  remote system (ie: currently there are not multiple versions of it for each
  remote OS).
  """

  def __init__(self, logfile, instance, namespace, location, remote_conn_details):
    super(ConnectMUMPS, self).__init__()

    self.type = str.lower(instance)
    self.namespace = str.upper(namespace)
    self.prompt = self.namespace + '>'

    # Create a new SSH client object
    client = paramiko.SSHClient()

    # Set SSH key parameters to auto accept unknown hosts
    client.load_system_host_keys()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    # Connect to the host
    client.connect(hostname=remote_conn_details.remote_address,
                   port=remote_conn_details.remote_port,
                   username=remote_conn_details.username,
                   password=remote_conn_details.password)

    # Create a client interaction class which will interact with the host
    from paramikoe import SSHClientInteraction
    interact = SSHClientInteraction(client, timeout=10, display=False)
    self.connection = interact
    self.connection.logfile_read = open(logfile, 'w')
    self.client = client  # apparently there is a deconstructor which disconnects (probably sends a FYN packet) when client is gone

  def write(self, command):
    time.sleep(.01)
    self.connection.send(command + '\r')
    logging.debug('connection.send:' + command)

  def writectrl(self, command):
    time.sleep(.01)
    self.connection.send(command)
    logging.debug('connection.writectrl: ' + command)

  def wait(self, command, tout=15):
    time.sleep(.01)
    logging.debug('connection.expect: ' + str(command))

    if command is PROMPT:
      command = self.namespace + '>'
    else:
      command = self.escapeSpecialChars(command)
      if command == '':
        command = '.*'  # fix for paramiko expect, it does not work with wait('')

    try:
        rbuf = self.connection.expect(command, tout)
    except socket.timeout:
        rbuf = -1

    if rbuf == -1:
        logging.debug('ERROR: expected: ' + command)
        print('ERROR: expected: ' + command)
        raise TestHelper.TestError('ERROR: expected: ' + command)
    else:
        return 1

  #paramikoe already accept regular expressions as input by default
  def wait_re(self, command, timeout=30):
    self.wait(command, timeout)

  def multiwait(self, options, tout=15):
    logging.debug('connection.expect: ' + str(options))

    temp_options = []
    for command in options:
        temp_options.append(self.escapeSpecialChars(command))
    options = temp_options

    time.sleep(.01)
    if isinstance(options, list):
      index = self.connection.expect(options, timeout=tout)
      if index == -1:
        logging.debug('ERROR: expected: ' + str(options))
        raise TestHelper.TestError('ERROR: expected: ' + str(options))
      return index
    else:
      raise IndexError('Input to multiwait function is not a list')

  def startCoverage(self, routines=['*']):
    if self.type == 'cache':
        self.write('D ^%SYS.MONLBL')
        rval = self.multiwait(['Stop Monitor', 'Start Monitor'])
        if rval == 0:
            self.write('1')
            self.wait('Start Monitor')
            self.write('1')
        elif rval == 1:
            self.write('1')
        else:
            raise TestHelper.TestError('ERROR starting monitor, rbuf: ' + rval)
        for routine in routines:
            self.wait('Routine Name')
            self.write(routine)
        self.wait('Routine Name', tout=120)
        self.write('')
        self.wait('choice')
        self.write('2')
        self.wait('choice')
        self.write('1')
        self.wait('continue')
        self.write('\r')
    else:
        self.write('K ^ZZCOVERAGE VIEW "TRACE":1:"^ZZCOVERAGE"')

  def stopCoverage(self, path):
    if self.type == 'cache':
        newpath, filename = os.path.split(path)
        self.write('D ^%SYS.MONLBL')
        self.wait('choice')
        self.write('5')
        self.wait('summary')
        self.write('Y')
        self.wait('FileName')
        self.write(newpath + '/' + filename.replace('.log', '.cmcov'))
        self.wait('continue')
        self.write('')
        self.wait('choice')
        self.write('1\r')
    else:
        path, filename = os.path.split(path)
        self.write('VIEW "TRACE":0:"^ZZCOVERAGE"')
        self.wait(PROMPT)
        self.write('D ^%GO')
        self.wait('Global')
        self.write('ZZCOVERAGE')
        self.wait('Global')
        self.write('')
        self.wait('Label:')
        self.write('')
        self.wait('Format')
        self.write('ZWR')
        self.wait('device')
        self.write(path + '/' + filename.replace('.log', '.mcov'))

  """
  Added to convert regex's into regular string matching. It replaces special
  characters such as '?' into '\?'
  """
  def escapeSpecialChars(self, string):
    re_chars = '?*.+-|^$\()[]{}'
    escaped_str = ''
    for c in string:
        if c in re_chars:
            escaped_str = escaped_str + '\\'
        escaped_str += c
    return escaped_str

def ConnectToMUMPS(logfile, instance='CACHE', namespace='VISTA', location='127.0.0.1', remote_conn_details=None):

    # self.namespace = namespace
    # self.location = location
    # print "You are using " + sys.platform
    # remote connections
    if remote_conn_details is not None:
      if no_paramiko:
        raise no_paramiko
      return ConnectRemoteSSH(logfile, instance, namespace, location, remote_conn_details)

    # local connections
    if sys.platform == 'win32':
      return ConnectWinCache(logfile, instance, namespace, location)
    elif (sys.platform == 'linux2' or sys.platform == 'cygwin'):
      if no_pexpect:
        raise no_pexpect
      if os.getenv('gtm_dist'):
        try:
          return ConnectLinuxGTM(logfile, instance, namespace, location)
        except pexpect.ExceptionPexpect as no_gtm:
           if (no_gtm):
             raise "Cannot find a MUMPS instance"
      else:
        try:
          return ConnectLinuxCache(logfile, instance, namespace, location)
        except pexpect.ExceptionPexpect as no_cache:
         if (no_cache):
           raise "Cannot find a MUMPS instance"
