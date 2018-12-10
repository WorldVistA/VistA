#!/usr/bin/env python
# Automatically generate XINDEX Exception file list based on CTest log files
# Please run CTest to generate the log files first before running this script
#
# To generate XINDEX Exception file list for routine(s) under package FOO
# python XindexExceptGen.py -l <logDir> -v <VistADir>
#                           -p Foo -r <routine1> <routine2> <routine3> ...
# where
#    logDir is the directory that contains all XINDEX log files, normally under
#           <CMAKE_BUILD_DIR>/Testing/Temporary/
#    VistADir is the directory that contains the VistA.git source tree
# To generate XINDEX Exception file list for packages Foo1 Foo2 Foo3
# python XindexExceptGen.py -l <logDir> -v <VistADir>
#                           -p Foo1 Foo2 Foo3
#
# Refer to  python XindexExceptGen.py -h for more information
#---------------------------------------------------------------------------
# Copyright 2011 The Open Source Electronic Health Record Agent
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
import re
import os.path
import argparse
import glob

# Regular expression to grep routines from the log file
Routine= re.compile('^(?P<routine>%?[a-zA-Z|0-9][^ ]+) +\* \* .*[cC]hecksum:.*')


# Function to generate the XindexException File List
# @logFileName, the logFileName generated during CTest XINDEX run.
# @packageDir, the path to the exception files for this package
# @MType, set to 1 when generating for Cache, 2 for GT.M
# @WarnFlag, a bool to control generation of "W -" exceptions. If true, warnings are generated
# @routineSet, the routineSet that need to be added, if empty, then all need to be added

def generateXindexExceptionList(logFileName, packageDir, MType, WarnFlag,
                                routineSet=None):
    # regular expression to grep error message from the log file
    if WarnFlag:
      ErrWarn=re.compile('W - |F -')
    else:
      ErrWarn=re.compile('F -')
    # Exception File List key file name, value is the file contents
    exceptionFileList = dict()
    newExceptions = dict()
    isSetEmpty = routineSet == None or len(routineSet)== 0
    packageLogFile = open(logFileName,'r')
    currentRoutineName = ""
    for line in packageLogFile:
#        find all the routines names
        newRoutineName=Routine.search(line)
        if(newRoutineName):
            if (newRoutineName != currentRoutineName):
                currentRoutineName=newRoutineName.group('routine')
        else:
            ErrWarnLine = ErrWarn.search(line)
            if ErrWarnLine and (isSetEmpty or currentRoutineName in routineSet):
                # we found out the ErrWarnLine
                # check if the file is already exist and open
                if MType == "1":
                  outputFilename="Cache." + currentRoutineName
                else:
                  outputFilename="GTM." + currentRoutineName
                if outputFilename in exceptionFileList:
                    fileContents = exceptionFileList[outputFilename]
                else:
                    absPath = os.path.join(packageDir, outputFilename)
                    existingFile = os.path.exists(absPath)
                    if existingFile:
                        with open(absPath, "rb") as file:
                            # Read in file, remove all trailing whitespace
                            exceptionFileList[outputFilename] = [exception.rstrip() for exception in file]
                # Remove whitespace
                line = line.strip()
                # Look for this line *exactly* - case sensitive
                if not existingFile or line not in exceptionFileList[outputFilename]:
                    if outputFilename not in newExceptions:
                        newExceptions[outputFilename] = []
                    # Only add line to exception file once
                    if line not in newExceptions[outputFilename]:
                        newExceptions[outputFilename].append(line)
    packageLogFile.close()

    # Make sure the directory exists
    if newExceptions and not os.path.exists(packageDir):
        os.makedirs(packageDir)
    # Write out the new exceptions
    for filename, exceptionList in newExceptions.iteritems():
        absPath = os.path.join(packageDir, filename)
        with open(absPath, "ab") as file:  # Open in binary mode to preserve line endings
            file.write("\r\n".join(exceptionList))
            file.write("\r\n")  # Make sure there's a newline at the end of file

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='XIndex Exception List file generator')
    parser.add_argument('-l', required=True, dest='logDir',
                        help='Input XINDEX log files directory generated by CTest, nomally under '
                             'CMAKE_BUILD_DIR/Testing/Temporary/')
    parser.add_argument('-v', required=True, dest="VistADir",
                        help="Path to the VistA Source tree")
    parser.add_argument('-s', required=True, dest="MType",
                        help="Type of M environment (1 for Cache, 2 for GT.M)")
    parser.add_argument('-a', dest="allPackage", action='store_true',
                        help='All packages')
    parser.add_argument('-w', dest="WarnFlag", action='store_true',
                        help='Generate exceptions for Warnings in output files')
    parser.add_argument('-p', dest='packageName', nargs='*',
                        help='only specified package names')
    parser.add_argument('-r', nargs='*', dest='routinesNames',
                        help='Specified routines under one package')
    result = vars(parser.parse_args())

    searchFiles=[]
    routines=set()
    if (result['allPackage']):
        logFilenamePattern="*Test.log"
        searchFiles = glob.glob(os.path.join(result['logDir'],logFilenamePattern))
    else:
        # If don't choose all packages, must specify package name
        if (not result['packageName']):
            exit -1;
        for package in result['packageName']:
            searchFiles.append(os.path.join(result['logDir'],package.replace(' ', '_')+'Test.log'))
        if (len(result['packageName']) == 1):
            routines=result['routinesNames']

    vistADir = result['VistADir']
    for logFile in searchFiles:
        packageName = os.path.basename(logFile)
        # assume the package name is in the following format
        packageName = packageName[0:packageName.find("Test.log")]
        if packageName == "Last":
            # Skip 'LastTest.log'
            continue
        packageDir = os.path.join(vistADir, "Packages", packageName.replace('_',' '), "XINDEXException")
        generateXindexExceptionList(logFile, packageDir, result['MType'], result['WarnFlag'], routines)
