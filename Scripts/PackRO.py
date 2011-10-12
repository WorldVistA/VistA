#!/usr/bin/env python
# Pack .m files into M[UMPS] routine transfer format (^%RO)
#
#   python PackRO.py *.m > routines.ro
#
# or
#
#   ls *.m | python PackRO.py > routines.ro
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

sys.stdout.write('Routines\n\n')
files = sys.argv[1:]
if not files:
    files = [a.rstrip() for a in sys.stdin]
for f in files:
    if not f.endswith('.m'):
        sys.stderr.write('Skipping non-.m file: %s\n' % f)
        continue
    n = os.path.basename(f)[:-2]
    m = open(f,"r")
    sys.stdout.write('%s\n'%n)
    for line in m:
        sys.stdout.write(line)
    sys.stdout.write('\n')
sys.stdout.write('\n')
sys.stdout.write('\n')
