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
import sys,os,re,time,argparse
SCRIPTS_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPTS_DIR)
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from VistARoutineExport import VistARoutineExport
from VistAMComponentExtractor import ROUTINE_EXTRACT_EXCLUDE_LIST

testClientParser = createTestClientArgParser()
parser = argparse.ArgumentParser(description='Coverage Preparation Script',
                                 parents=[testClientParser])
parser.add_argument('-o', '--outputFile',
                  help='Output File Name to store routine export information')
parser.add_argument('-r', '--routines', nargs='*',
                      help='only specified routine names')
result = parser.parse_args();
testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
assert testClient
with testClient as vistAClient:
  vistAClient.setLogFile("CoveragePrep.log")
  RoutineExport = VistARoutineExport()
  if result.routines== ['*']:
    RoutineExport.exportRoutines(testClient,result.outputFile,result.routines,ROUTINE_EXTRACT_EXCLUDE_LIST)
  else:
    RoutineExport.exportRoutines(testClient,result.outputFile,result.routines,None)
  import UnpackRO
  path, filename = os.path.split(result.outputFile)
  UnpackRO.unpack(open(result.outputFile,'r'), sys.stdout, path+'/CoverageSource/')