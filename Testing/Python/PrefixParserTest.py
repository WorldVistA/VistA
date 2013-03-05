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

### set up the IO that is need by unit test
import sys,os
sys.path = [os.path.dirname(__file__)+'/../../Python/vista'] + sys.path

print ('sys.argv is %s' % sys.argv)
if len(sys.argv) <= 1:
  print ('Need the two arguments:packagename,packages_csv_file ')
  sys.exit()

from ParseCSVforPackagePrefixes import FindPackagePrefixes
ExpectedOutput = ["'%", "'ABC", "'BCD", "'DEF", 'ABCD', "'CDEH", 'DEFG']
TestOutput = FindPackagePrefixes(sys.argv[1],sys.argv[2])

if ExpectedOutput == TestOutput:
  print "Output of test matches the expected output"
  sys.exit(0)
else:
  print "Error:  Expected output was: " + str(ExpectedOutput) + ".  Test output was: " + str(TestOutput)
  sys.exit(1)