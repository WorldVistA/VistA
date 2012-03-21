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

#---------------------------------------------------------------------------
class PROMPT(object):
  """Wait for a VISTA> prompt in current namespace."""

class ConnectMUMPS(object):

  def ZN(self,namespace):
    self.wait('>')
    self.write('ZN "' + namespace + '"')
    self.namespace=namespace
    self.prompt=self.namespace + '>'

  def login(self,username,password):
    self.wait('Username:')
    self.write(username)
    self.wait('Password')
    self.write(password)

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

  def write(self,command ):
    global connection
    connection.write(command + '\r')

  def wait(self,command ):
    global connection
    if command is PROMPT:
      command = self.prompt
    log.write(connection.read_until(command))

  def multiwait(self,options):
    if isinstance(options,list):
      index=connection.expect(options)
      log.write(index[2])
      return index[0]
    else:
      raise IndexError('Input to multiwait function is not a list')

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

  def write(self,command ):
    connection.send(command + '\r')

  def wait(self,command ):
    global connection
    if command is PROMPT:
      command = self.prompt
    connection.expect(command)

  def multiwait(self,options):
    if isinstance(options,list):
      index=connection.expect(options)
      return index
    else:
      raise IndexError('Input to multiwait function is not a list')

class ConnectLinuxGTM(ConnectMUMPS):
  def __init__(self,logfile,instance,namespace,location='127.0.0.1'):
    global connection,log
    super(ConnectMUMPS,self).__init__()
    connection=pexpect.spawn('gtm', timeout=None)
    if len(namespace) == 0:
        self.prompt=os.getenv("gtm_prompt")
        print self.prompt
        if self.prompt==None:
          self.prompt="GTM>"
    connection.logfile_read = file(logfile,'w')
    self.type='GTM'

  def write(self,command ):
    connection.send(command + '\r')

  def wait(self,command ):
    print self.prompt
    global connection
    if command is PROMPT:
      command = self.prompt
    connection.expect(command)

  def multiwait(self,options):
    if isinstance(options,list):
      index=connection.expect(options)
      return index
    else:
      raise IndexError('Input to multiwait function is not a list')

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
