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
import sys,os,re,argparse,fnmatch
from PatchInfoParser import installNameToDirName
from OTJParseEvidenceOutput import ParseOutput,WriteRCheck,WriteRFind,XINDEXParser,GTMRFind,findGTMRoutinesDir
from KIDSBuildParser import KIDSBuildParser
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from DefaultKIDSBuildInstaller import DefaultKIDSBuildInstaller
routineset=[]

def PrintChecksumsbyBuildname(testClient,name,outputDir):
  resultsfolder= os.path.join(outputDir,"ChecksumResults")
  try:
    os.mkdir(resultsfolder)
  except:
    pass
  logpath = os.path.join(resultsfolder,installNameToDirName(name))
  testClient.setLogFile(logpath+"PostChecksums.log")
  connection = testClient.getConnection()
  connection.send("D CHECK1^XTSUMBLD\r")
  connection.expect("Build from")
  connection.send("Build\r")
  connection.expect("Select BUILD NAME")
  connection.send(name + "\r")
  testClient.waitForPrompt()
  connection.send("\r")

def FullXINDEX(testclient,outputDir,routinelist):
  resultsfolder= os.path.join(outputDir,"XINDEXResults")
  try:
    os.mkdir(resultsfolder)
  except:
    pass
  logpath = os.path.join(resultsfolder,"XINDEXAllRoutines")
  testclient.setLogFile(logpath+".log")
  connection = testclient.getConnection()
  connection.send("D ^XINDEX\r")
  if testclient.isCache():
    connection.expect("All Routines")
    connection.send("N\r")
  for routine in routinelist:
    connection.expect("Routine")
    connection.send(routine+"\r")
  connection.expect("Routine")
  connection.send("\r")
  connection.expect("BUILD NAME")
  connection.send("\r")
  connection.expect("INSTALL NAME")
  connection.send("\r")
  connection.expect("PACKAGE NAME")
  connection.send("\r")
  index = connection.expect(["Print more than compiled errors and warnings",testclient.getPrompt()])
  if index == 0:
    connection.send("\r")
    connection.expect("Print summary only")
    connection.send("\r")
    connection.expect("Print routines")
    connection.send("No\r")
    connection.expect("Print errors and warnings with each routine")
    connection.send("\r")
    connection.expect("Index all called routines")
    connection.send("N\r")
    connection.expect("DEVICE")
    connection.send(';;9999\r')
    if testclient.isCache():
      connection.expect('Right Margin:')
      connection.send('\r')
    connection.send('\r')
    connection.expect('continue:',1200)
    connection.send('\r')
    connection.expect('--- END ---',12000)
    XINDEXParser(resultsfolder,"XINDEXAllRoutines")
  else:
    print("No Routines were found prior to patch")
    connection.send('\r')

def XINDEXbyBuildname(testclient,installname,outputDir):
  resultsfolder= os.path.join(outputDir,"XINDEXResults")
  try:
    os.mkdir(resultsfolder)
  except:
    pass
  logpath = os.path.join(resultsfolder,installNameToDirName(installname))
  testclient.setLogFile(logpath+".log")
  connection = testclient.getConnection()
  connection.send("D ^XINDEX\r")
  if testclient.isCache():
    connection.expect("All Routines")
    connection.send("N\r")
  connection.expect("Routine")
  connection.send("\r")
  connection.expect("BUILD NAME")
  connection.send(installname+"\r")
  connection.expect("Include the compiled template routines")
  connection.send("N\r")
  connection.expect("Print more than compiled errors and warnings")
  connection.send("\r")
  connection.expect("Print summary only")
  connection.send("\r")
  connection.expect("Print routines")
  connection.send("No\r")
  connection.expect("Print the DDs, Functions, and Options")
  connection.send("\r")
  connection.expect("Print errors and warnings with each routine")
  connection.send("\r")
  connection.expect("Save parameters in ROUTINE file")
  connection.send("\r")
  connection.expect("Index all called routines")
  connection.send("N\r")
  connection.expect("DEVICE")
  connection.send(';;9999\r')
  if testclient.isCache():
    connection.expect('Right Margin:')
    connection.send('\r')
  connection.send('\r')
  connection.expect('continue:')
  connection.send('\r')
  connection.expect('--- END ---',120)
  XINDEXParser(resultsfolder,installname)

testClientParser = createTestClientArgParser()
parser = argparse.ArgumentParser(description='Processor for OTJ Evidence with a .KID submission',
                                 parents=[testClientParser])
parser.add_argument('-kb', required=True, dest='KIDSbuild',
                    help='Path to the .KIDS file')
parser.add_argument('-o', required=True, dest='outputDir',
                    help='Path to folder to store output files')
#parser.add_argument('-find', required=False, dest='Ffile',
#                    help='Filepath to the Output file of the RFind function.')
#parser.add_argument('-check', required=False, dest='Cfile',
#                    help='Filepath to the Output file of the RCheck function.')
result = parser.parse_args()

# Create a test client and run the KIDSBuildParser on the supplied KIDS build
testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
assert testClient
with testClient:
  KIDSParser = KIDSBuildParser(result.outputDir)
  KIDSParser.parseKIDSBuild(result.KIDSbuild)
  KIDSParser.printResult()
  for root,dirnames,filenames in os.walk(result.outputDir):
    for filename in fnmatch.filter(filenames,'*.m'):
      name,ext = filename.split('.')
      routineset.append(name)
  print "Writing out intial XINDEX information: Start"
  FullXINDEX(testClient,result.outputDir,routineset)
  print "Writing out intial XINDEX information: Done"
  resultsfolder = os.path.join(result.outputDir,"RCheck_RFind")
  try:
    os.mkdir(resultsfolder)
  except:
    pass
  if testClient.isCache():
    print "Writing out initial %RCheck information: Start"
    WriteRCheck(testClient,resultsfolder,"RCheckResultsPre.log",routineset)
    print "Writing out %RCheck information: Done"
    print "Writing out initial %RFind information: Start"
    WriteRFind(testClient,resultsfolder,"RFindResultsPre.log",routineset)
    print "Writing out %RFind information: Done"
  else:
    print "%RFIND is an InterSystems Cache Utility, performing a REGEX search through the gtmroutines directory in " + findGTMRoutinesDir()
    GTMRFind(resultsfolder,"RFindResultsPre.log",routineset)
  # Attempt to install the supplied KIDS build
  print "Installation of " + result.KIDSbuild+ " : START"
  KIDSInstaller = DefaultKIDSBuildInstaller(result.KIDSbuild,KIDSParser.installNameList[0],None,os.path.join(result.outputDir,'InstallLog.txt'),
                                            KIDSParser.installNameList,1,printTG=result.outputDir)

  KIDSInstaller.runInstallation(testClient)
  print "Installation of " + result.KIDSbuild+ " : DONE"
  # Run the XINDEX utility on each build that was installed by the KIDS build
  for name in KIDSParser.installNameList:
    print "Running XINDEX and finding Checksums for installed package: " + name
    XINDEXbyBuildname(testClient,name,result.outputDir)
    PrintChecksumsbyBuildname(testClient,name,result.outputDir)
  rfindpost=os.path.join(resultsfolder,"RFindResultsPost.log")
  rcheckpost= os.path.join(resultsfolder,"RCheckResultsPost.log")
  if testClient.isCache():
    print "Writing out post-install %RCheck information: Start"
    WriteRCheck(testClient,resultsfolder,"RCheckResultsPost.log",routineset)
    print "Writing out post-install %RCheck information: Done"
    print "Writing out post-install %RFind information: Start"
    WriteRFind(testClient,resultsfolder,"RFindResultsPost.log",routineset)
    print "Writing out post-install %RFind information: Done"
    print "Parsing Output"
    ParseOutput(resultsfolder+"/",rfindpost,rcheckpost,routineset)
  else:
    print "%RFIND is an InterSystems Cache Utility, performing a REGEX search through the gtmroutines directory in " + findGTMRoutinesDir()
    GTMRFind(resultsfolder,"RFindResultsPost.log",routineset)
    print "Parsing Output"
    ParseOutput(resultsfolder+"/",rfindpost,None,routineset)
