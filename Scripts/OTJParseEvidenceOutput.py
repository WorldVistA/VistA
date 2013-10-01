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

import os,sys,argparse,re,fnmatch
from PatchInfoParser import installNameToDirName
from VistATestClient import VistATestClientFactory, createTestClientArgParser
routinefound = re.compile('^[A-Z0-9]+\.[A-Za-z]')
searchers=[]

# Search array is the properly escaped search strings from the Final Review
searcharray=['////','DIC\(0\)','\^UTILITY','\^TMP','\^XTMP','\%','\$I','U\=','K \^','\^\(','IO']
regexsearcharray=['////','DIC\(0\)','\^UTILITY','\^TMP','\^XTMP','\%','\$I','U\=','K \^','\^\(','S[:0-9A-Z=]* IO\=','K[:A-Z0-9=]* IO']

def findGTMRoutinesDir():
  return os.getenv("gtmroutines").split(')')[0].split("(")[1]

def GTMRFind(outputDir,outputfilename,routineset):
  outputfilepath = os.path.join(outputDir,outputfilename)
  outputfile = open(outputfilepath,"w")
  for searchstring in regexsearcharray:
    searchers.append( re.compile(searchstring))
  routinedir = findGTMRoutinesDir()
  for root,dirnames,filenames in os.walk(routinedir):
    for filename in fnmatch.filter(filenames,'*.m'):
      routinename = filename.replace(".m","")
      if routinename in routineset:
        outputfile.write(filename+ "\n")
        routine = open(routinedir+"/"+filename,'r')
        for line in routine:
          for index in range(0,len(regexsearcharray)):
            if searchers[index].search(line):
              outputfile.write(line)

def WriteRCheck(testClient,outputDir,filename,routinelist=['*']):
  logpath = os.path.join(outputDir,"RCHECK.log")
  testClient.setLogFile(logpath)
  connection = testClient.getConnection()
  testClient.waitForPrompt()
  connection.send("DO ^%RCHECK\r")
  for routine in routinelist:
    connection.expect("Routine")
    connection.send(routine+"\r")
  connection.expect("Routine")
  connection.send("\r")
  connection.expect("Device")
  outputfile = os.path.join(outputDir,filename)
  connection.send(outputfile + "\r")
  connection.expect("Parameters")
  connection.send("\r")
  connection.expect([testClient.getPrompt(),"overwrite it"],600)
  connection.send('\r')
  testClient.waitForPrompt()
  connection.send("\r")

def WriteRFind(testClient,outputDir,filename,routinelist=['*']):
  connection = testClient.getConnection()
  testClient.waitForPrompt()
  logpath = os.path.join(outputDir,"RFind.log")
  testClient.setLogFile(logpath)
  command = 'D ^%RFIND\r'
  connection.send(command.replace('\\',''))
  for searchstring in searcharray:
    connection.expect("Search For")
    connection.send(searchstring.replace('\\','')+"\r")
  connection.expect("Search For")
  connection.send("\r")
  connection.expect("Exact Upper/Lowercase Match")
  connection.send("\r")
  connection.expect("Show all searched routines")
  connection.send("\r")
  for routine in routinelist:
    connection.expect("Routine")
    connection.send(routine+"\r")
  connection.expect("Routine")
  connection.send("\r")
  connection.expect("Device")
  outputfile = os.path.join(outputDir,filename)
  connection.send(outputfile + "\r")
  connection.expect("Parameters")
  connection.send("\r")
  connection.expect([testClient.getPrompt(),"overwrite it"],600)
  connection.send("\r")
  testClient.waitForPrompt()
  connection.send("\r")

def XINDEXParser(outputDir,installname):
  NEKsearchstring = "^>>"
  Routinenamestring= "INDEX OF [A-Z0-9]"
  sourcefile= os.path.join(outputDir,installNameToDirName(installname))
  try:
    NEKoutputDir= os.path.join(outputDir,"NotExplicitlyKilled")
    os.mkdir(NEKoutputDir)
  except:
    pass
  outputfile= os.path.join(NEKoutputDir,installNameToDirName(installname))
  xindexoutput = open(sourcefile + ".log",'r')
  notexplicitlykilled = open(outputfile + "NEK.log",'w')
  for line in xindexoutput:
    if re.search(Routinenamestring,line) or re.search(NEKsearchstring,line):
      notexplicitlykilled.write(line + "\r")
    elif re.search("CROSS-REFERENCING ALL ROUTINES",line):
      break

def RFindParser(rfindinput,searchers,filearray,routineset=False):
  routine=''
  # Open the RFind output file and read each line
  rfindfile=open(rfindinput,'r')
  for line in rfindfile:
    # If finding a line with a routine name, write out the status
    if routinefound.search(line):
      routine,ext = line.split('.')
      # check to see if a routine set is given, and if the routine is in the set
      if routine in routineset:
        print "Writing findings for "+ routine
    else:
      # Once a routine is found, check the next lines for the strings in the searcharray
      for index in range(0,len(regexsearcharray)):
        if searchers[index].search(line):
          # If it matches and routine is in routine set, write to the correct file.
          if routine in routineset:
            filearray[index].write(routine+': '+line)

def RCheckParser(rcheckinput,outputDir,routineset):
  rcheckfile=open(rcheckinput,'r')
  rcheckresults = open(os.path.join(outputDir,"RCheckParsedresults.txt"),'w')
  # Open the RCheck output file and read each line
  for line in rcheckfile:
    if routinefound.search(line):
      # When a routinename is found, split over the extension to separate the
      # routine name from the potential error
      routine,errorline = line.split('.INT')
      # Check for the routineset being passed and if the routine is in it.
      if routine in routineset:
        if re.search('Error [0-9]+',line):
          rcheckresults.write(line)
          print "An error has been found in " + routine

def ParseOutput(outputDir,FindFile,CheckFile,RoutineSet):
  filearray = [open(outputDir+'fourslash.txt','w'),open(outputDir+'dic0.txt','w'),open(outputDir+'utility.txt','w'),open(outputDir+'tmp.txt','w'),
               open(outputDir+'xtmp.txt','w'),open(outputDir+'percent.txt','w'),open(outputDir+'dollari.txt','w'),open(outputDir+'uequals.txt','w'),
               open(outputDir+'Kcarat.txt','w'),open(outputDir+'nakedreference.txt','w'),open(outputDir+'IOSet.txt','w'),open(outputDir+'IOKill.txt','w'),]

  # Compile the regular expressions in the searcharray
  for searchstring in regexsearcharray:
    searchers.append( re.compile(searchstring))
  #Parse only the files that are given in the command.
  if FindFile:
    RFindParser(FindFile,searchers,filearray,RoutineSet)
  if CheckFile:
    RCheckParser(CheckFile,outputDir,RoutineSet)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='RFind output parser for OTJ Final Review')
    parser.add_argument('-rs', required=False, dest='routineset',
                        help='Directory which holds files of routines to limit search.')
    parser.add_argument('-find', required=False, dest='Ffile',
                        help='Filepath to the Output file of the RFind function.')
    parser.add_argument('-check', required=False, dest='Cfile',
                        help='Filepath to the Output file of the RCheck function.')
    parser.add_argument('-o', required=False, dest='outputDir', default='',
                        help='Directory to store the output text files .')
    result = vars(parser.parse_args())
    ParseOutput(result['outputDir'],result['Ffile'],result['Cfile'],result['routineset'])

