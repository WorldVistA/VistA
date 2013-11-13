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
import socket
import sys,os
import unittest

def createAndConnect(host="127.0.0.1", port=9210):
  print "Connect to host %s, port %s" % (host, port)
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  sock.connect((host, port))
  sock.setblocking(0) # non-blocking
  return sock

def sendDivGet(sock):
  inputfile = "divget.xml"
  sendRequestByFile(inputfile, sock)

def sendDivSet(sock):
  inputfile = "divset.xml"
  sendRequestByFile(inputfile, sock)

def sendGetUserInfo(sock):
  inputfile = "getuserinfo.xml"
  sendRequestByFile(inputfile, sock)

def sendIamHere(sock):
  inputfile = "im_here.xml"
  sendRequestByFile(inputfile, sock)

def sendGetPatientList(sock):
  inputfile = "getpatientlist.xml"
  sendRequestByFile(inputfile, sock)

def sendGetPatientVitals(sock):
  inputfile = "getpatientvitals.xml"
  sendRequestByFile(inputfile, sock)

def sendIntroMsgGet(sock):
  inputfile = "getintromessage.xml"
  sendRequestByFile(inputfile, sock)

def createORContext(sock):
  inputfile = "createorguichartcontext.xml"
  sendRequestByFile(inputfile,sock)

def createSignonContext(sock):
  inputfile = "createSignonContext.xml"
  sendRequestByFile(inputfile,sock)

def signInAlexander(sock):
  inputfile = "signon.xml"
  sendRequestByFile(inputfile,sock)

def sendRequestByFile(inputfile, sock):
  sock.settimeout(5)
  if os.path.dirname(__file__)+ "/" == "/":
    commandfile = inputfile
  else:
    commandfile = os.path.dirname(__file__)+ "/" + inputfile
  with open(commandfile,'r') as input:
    for line in input:
      sock.send(line)
  sock.send(chr(4))

def getResponse(sock, timeout=10):
  sock.settimeout(10)
  output = ""
  while True:
    data=sock.recv(256)
    if data:
      output = output + data
      if chr(4) in data:
        break
  return output

def runRPC(self,rpcfilename, signon):
  if os.path.dirname(__file__)+ "/" == "/":
    resultsfile = rpcfilename.replace(".xml","_results.xml")
  else:
    resultsfile = os.path.dirname(__file__)+ "/" + rpcfilename.replace(".xml","_results.xml")
  correct_response = open(resultsfile,'r').read()
  sock = createSocket()
  if signon:
    createSignonContext(sock)
    getResponse(sock)
    signInAlexander(sock)
    getResponse(sock)
    createORContext(sock)
    getResponse(sock)
  sendRequestByFile(rpcfilename,sock)
  response = getResponse(sock)
  print "Response from " + rpcfilename
  print response
  self.assertEquals(response[:-1],correct_response, msg= "Didn't find a correct response to '" + rpcfilename + "'" )
  sock.close()

def createSocket():
  sock = None
  if len(sys.argv) > 1:
    if len(sys.argv) >= 3:
      host = sys.argv[1]
      port = int(sys.argv[2])
      sock = createAndConnect(host, port)
      return sock
    else:
      sock = createAndConnect(host=sys.argv[1])
      return sock
  else:
    sock = createAndConnect()
    return sock

class TestM2MBroker(unittest.TestCase):

  def test_IamHere_NoSignon(self):
    runRPC(self,"imhere.xml",False)
  def test_IamHere_Signon(self):
    runRPC(self,"imhere.xml",True)
  def test_GetIntroMessage_NoSignon(self):
    runRPC(self,"getintromessage.xml",False)
  def test_GetPatientList_Signon(self):
    runRPC(self,"getpatientlist.xml",True)
  def test_GetPatientList_NoSignon(self):
    runRPC(self,"patientlisterror.xml",False)
  def test_GetPatientVitals_NoSignon(self):
    runRPC(self,"getpatientvitals.xml",False)

def main():
  from RPCBrokerCheck import CheckRPCListener
  checkresult = CheckRPCListener()
  if checkresult == 0:
    suite = unittest.TestLoader().loadTestsFromTestCase(TestM2MBroker)
    unittest.TextTestRunner(verbosity=2).run(suite)
  else:
    print "FAILED: The RPC listener is not set up as needed."

if __name__ == "__main__":
  main()
