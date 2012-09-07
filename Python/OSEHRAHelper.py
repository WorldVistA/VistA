r"""Class to Connect to a VistA EHR automatically."""
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
import sys
import os
import telnetlib
try:
  import pexpect
  no_pexpect = None
except ImportError, no_pexpect:
  pass

#---------------------------------------------------------------------------
#Initial Global Variables to use over the course of connecting

connection=False
log =False

DEFAULT_TIMEOUT = 60 # system wise default timeout value is 30 seconds
#---------------------------------------------------------------------------
class PROMPT(object):
  """Wait for a VISTA> prompt in current namespace."""

class ConnectMUMPS(object):
  def __init__(self):
    self.timeout = DEFAULT_TIMEOUT
  def ZN(self,namespace):
    self.wait('>')
    self.write('ZN "' + namespace + '"')
    self.namespace=namespace
    self.prompt=self.namespace + '>'
  def settimeout(self, timeout):
    self.timeout = timeout
  def login(self,username,password):
    self.wait('Username:')
    self.write(username)
    self.wait('Password')
    self.write(password)
  def getMatch(self):
    return None
  def getBefore(self):
    return None

  def getenv(self,volume):
    self.write('D GETENV^%ZOSV W Y')
    if sys.platform=='win32':
      match=connection.expect([volume + ':[0-9A-Za-z-]+'],self.timeout)
      test=match[1].span()
      VistAboxvol=''
      for i in range(test[0],test[1]):
        VistAboxvol = VistAboxvol + match[2][i]
      self.boxvol=VistAboxvol
    else:
      connection.expect([volume + ':[0-9A-Za-z-]+'])
      print connection.after
      self.boxvol=connection.after

  def IEN(self,file,objectname):
    self.write('S DUZ=1 D Q^DI')
    self.wait('OPTION')
    self.write('5')
    self.wait('FILE:')
    self.write(file)
    self.wait(file + ' NAME')
    self.write(objectname + '\r')
    self.wait('CAPTIONED OUTPUT?')
    self.write('N')
    self.wait('PRINT FIELD')
    self.write('NUMBER\r')
    self.wait('Heading')
    self.write('')
    self.wait('DEVICE')
    if sys.platform=='win32':
      self.write('\r')
      match=connection.expect(['\r\n[0-9]+'],self.timeout)
      test=match[1].span()
      number=''
      for i in range(test[0],test[1]):
        number = number + match[2][i]
      number=number.lstrip('\r\n')
      self.IENumber = number
    else:
      self.write('')
      connection.expect(['\n[0-9]+'])
      number=connection.after
      number=number.lstrip('\r\n')
      self.IENumber = number
    self.write('')

class ConnectWinCache(ConnectMUMPS):
  def __init__(self,logfile,instance,namespace,location='127.0.0.1'):
    global connection,log
    super(ConnectMUMPS,self).__init__()
    connection=telnetlib.Telnet(location,23)
    if len(namespace) ==0:
      namespace='VISTA'
    self.namespace=namespace
    self.prompt=self.namespace + '>'
    log=file(logfile,'w')
    self.type='cache'
    self.timeout = DEFAULT_TIMEOUT

  def write(self,command):
    global connection
    connection.write(command + '\r')
    log.write(command + '\r')
    log.flush()

  def wait(self,command,timeout=None):
    global connection
    if command is PROMPT:
      command = self.prompt
    if not timeout: timeout = self.timeout
    output = connection.expect([command],timeout)
    self.match = output[1]
    self.before = output[2]
    if output[2]:
      log.write(output[2])
      log.flush()
    if output[0] == -1 and output[1] == None:
      raise Exception("Timed out")
  def multiwait(self,options, timeout=None):
    if isinstance(options,list):
      if not timeout: timeout = self.timeout
      index=connection.expect(options,timeout)
      self.match = index[1]
      self.before = index[2]
      if index[2]:
        log.write(index[2])
        log.flush()
      if index[0] == -1 and index[1] == None:
        raise Exception("Timed out")
      return index[0]
    else:
      raise IndexError('Input to multiwait function is not a list')
  def getMatch(self):
    return self.match
  def getBefore(self):
    return self.before

class ConnectLinuxCache(ConnectMUMPS):
  def __init__(self,logfile,instance,namespace,location='127.0.0.1'):
    global connection,log
    super(ConnectMUMPS,self).__init__()
    connection=pexpect.spawn('ccontrol session ' + instance + ' -U ' + namespace,timeout=None)
    if len(namespace) == 0:
      namespace='VISTA'
    self.namespace=namespace
    self.prompt=self.namespace + '>'
    connection.logfile_read = file(logfile,'w')
    self.type='cache'
    connection.timeout = DEFAULT_TIMEOUT

  def write(self,command ):
    connection.send(command + '\r')

  def wait(self,command,timeout=None):
    global connection
    if command is PROMPT:
      command = self.prompt
    if not timeout: timeout = -1
    connection.expect(command, timeout)

  def multiwait(self,options,timeout=None):
    if isinstance(options,list):
      if not timeout: timeout = -1
      index=connection.expect(options, timeout)
      return index
    else:
      raise IndexError('Input to multiwait function is not a list')
  def getMatch(self):
    return connection.match
  def getBefore(self):
    return connection.before

class ConnectLinuxGTM(ConnectMUMPS):
  def __init__(self,logfile,instance,namespace,location='127.0.0.1'):
    global connection,log
    super(ConnectMUMPS,self).__init__()
    connection=pexpect.spawn('gtm', timeout=None)
    if len(namespace) == 0:
        self.prompt=os.getenv("gtm_prompt")
        if self.prompt==None:
          self.prompt="GTM>"
    connection.logfile_read = file(logfile,'w')
    self.type='GTM'
    connection.timeout = DEFAULT_TIMEOUT

  def write(self,command ):
    connection.send(command + '\r')

  def wait(self,command,timeout=None):
    global connection
    if command is PROMPT:
      command = self.prompt
    if not timeout: timeout = -1
    connection.expect(command, timeout)

  def multiwait(self,options,timeout=None):
    if isinstance(options,list):
      if not timeout: timeout = -1
      index=connection.expect(options, timeout)
      return index
    else:
      raise IndexError('Input to multiwait function is not a list')
  def getMatch(self):
    return connection.match
  def getBefore(self):
    return connection.before

def ConnectToMUMPS(logfile,instance='CACHE',namespace='VISTA',location='127.0.0.1'):

    global connection
    #self.namespace = namespace
    #self.location = location
    #print "You are using " + sys.platform
    if sys.platform == 'win32':
      return ConnectWinCache(logfile,instance,namespace,location)
    elif sys.platform == 'linux2':
      if no_pexpect:
        raise no_pexpect
      try:
        return ConnectLinuxCache(logfile,instance,namespace,location)
      except pexpect.ExceptionPexpect, no_cache:
        pass
      try:
        return ConnectLinuxGTM(logfile,instance,namespace,location)
      except pexpect.ExceptionPexpect, no_gtm:
         if (no_cache and no_gtm):
           raise "Cannot find a MUMPS instance"
