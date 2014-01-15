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

## RPC Broker Check
##

'''
This command makes sure that the RPC Broker is listening before
running the tests created for the SSEP

@copyright The Open Source Electronic Health Record Agent
@license http://www.apache.org/licenses/LICENSE-2.0
'''

import sys
import os
import time


def CheckRPCListener(VistA,tcp_host,tcp_port):
  VistA.send('D CALL^XWBTCPMT\r')
  VistA.expect('IP ADDRESS')
  VistA.send(tcp_host+ '\r')
  VistA.expect('PORT')
  VistA.send(str(tcp_port)+ '\r')
  index = VistA.expect(['Success','Failed'])
  return index

if __name__ == "__main__":
  import argparse
  curDir = os.path.dirname(os.path.abspath(__file__))
  scriptDir = os.path.normpath(os.path.join(curDir, "../../"))
  if scriptDir not in sys.path:
    sys.path.append(scriptDir)
  from VistATestClient import createTestClientArgParser,VistATestClientFactory

  # Arg Parser to get address and port of RPC Listener along with a log file
  # Inherits the connection arguments of the testClientParser

  testClientParser = createTestClientArgParser()
  ssepTestParser= argparse.ArgumentParser(description='Test the M2M broker via XML files',
                                           parents=[testClientParser])
  ssepTestParser.add_argument("-ha",required=True,dest='host',
                              help='Address of the host where RPC Broker is listening')
  ssepTestParser.add_argument("-hp",required=True,dest='port',
                              help='Port of the host machine where RPC Broker is listening')

  # A global variable so that each test is able to use the port and address of the host
  global results
  results = ssepTestParser.parse_args()
  testClient = VistATestClientFactory.createVistATestClientWithArgs(results)
  assert testClient
  with testClient:
    # If checkresult == 0, RPC listener is set up correctly and tests should be run
    # else, don't bother running the tests
    print "Testing connection to RPC Listener on host: " + results.host + " and port: " + results.port
    checkresult = CheckRPCListener(testClient.getConnection(),results.host,results.port)
    if checkresult == 0:
      print "Connection Successful"
    else:
      print "Connection Unsuccessful"
