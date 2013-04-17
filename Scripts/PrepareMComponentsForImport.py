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

import sys
import os
import PackRO
import argparse
import fnmatch


def files_in_tree(pattern, top):
  for dirpath, dirnames, filenames in os.walk(os.path.abspath(top)):
    for f in fnmatch.filter(filenames, pattern):
      yield os.path.join(dirpath, f)

parser = argparse.ArgumentParser(description='Prepare M components for Import')
parser.add_argument('MDir', metavar='<M_DIR>',nargs="+",help = "Path[s] to the M components source tree[s]")
parser.add_argument('-o' ,'--outputdir', default="", help = "Directory to store the output files")
parser.add_argument('-r','--relativedir' ,metavar='<RELATIVE_DIR>', help = "Make globals.lst paths relative to a supplied directory")
result = parser.parse_args()

for outputfile in ["routines.ro", "globals.lst"]:
  try:
    os.remove(outputfile)
  except OSError:
    pass

routputfile = open(os.path.join(result.outputdir,"routines.ro"),'w')
goutputfile = open(os.path.join(result.outputdir,"globals.lst"),'w')

routines=[]
globals=[]

for directory in result.MDir:
  print "Looking for routines in subdirectories below " + directory
  routines += [r for r in files_in_tree('*.m',directory)]
  print "Looking for globals in subdirectories below " + directory
  if result.relativedir:
    globals += [os.path.relpath(g,result.relativedir) for g in files_in_tree('*.zwr',directory)]
  else:
    globals += [g for g in files_in_tree('*.zwr',directory)]

print "Packing routines into routines.ro file"
PackRO.pack(routines[0:],routputfile)
print "Done!"

print "Packing global paths into globals.lst file"
for newglobal in globals:
  goutputfile.write(newglobal+'\n')
print "Done!"

routputfile.close()
goutputfile.close()
sys.exit(0)