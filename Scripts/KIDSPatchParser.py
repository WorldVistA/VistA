#!/usr/bin/env python
# Parse KIDS files (.KID)
#
#
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
import sys
import os

def unpack(kid, routineDir):
    # method variables
    routineLines = 0
    routineName = ""
    routine = None
    output = sys.stdout

    with open(kid, 'r') as f:
        for line in f:
            # identifier is the line preceding the data (RTN,BLD,KRN,RPC,etc) that provides processing information
            # actual data is always on the next line
            # Handle Routines Block
            if line.startswith('''"RTN"'''):
                if '''"RTN")''' in line:
                    # Next line contains the number of routines in the build
                    line = f.next()
                    numberOfRoutines = line
                    output.write('Number of routines:  ' + numberOfRoutines)
                    line = f.next()
                    #output.write("line before while:  " + line)
                # Loop over RTN section
                while line.startswith('''"RTN",'''):
                    identifier = line.split(',')
                    if len(identifier) == 2:
                        # Beginning of Routine Header
                        # "RTN","RoutineName")
                        # Data (line+1): Unknown^Unknown^ChecksumAfter^ChecksumBefore
                        line = f.next()
                        routineHeader = line.strip()
                        routineName = identifier[1].strip()
                        routineName = routineName.strip(')\"')
                        output.write('Routine Header:  ' + routineHeader + "\n")
                        output.write('Routine Name:  ' + routineName + "\n")
                        if routine:
                            routine.close()
                            routine = None
                        routine = open(routineDir + "/" + routineName + ".m", 'w')
                        if identifier[1].strip(' \n\")') != routineName:
                            output.write('identifier:  ' + identifier[1] + "\n")
                            output.write('Number of lines in routine: ' + str(routineLines) + "\n")
                            routineLines = 0
                    if len(identifier) == 4:
                        routineLines += 1
                        # Actual Routine Data
                        # "RTN","RoutineName",LineNumber,0)
                        # Data (line+1): Line of M code
                        line = f.next()
                        code = line
                        routine.write(code)
                    line=f.next()

def main():
    unpack(sys.argv[1], sys.argv[2])

if __name__ == '__main__':
    main()
