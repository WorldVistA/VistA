#!/usr/bin/env python
# Unpack a M[UMPS] routine transfer format (^%RO) into .m files
#
#   python UnpackRO.py < routines.ro
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

def unpack(ro):
    # Write out the two header lines for human reference.
    sys.stdout.write(ro.readline())
    sys.stdout.write(ro.readline())

    m = None

    for line in ro:
        if line == '\n':
            # Routine terminated by blank line
            if m:
                m.close()
                m = None
        elif m:
            m.write(line)
        else:
            # Routine started by line with its name.  Some %RO
            # implementations add a '^' followed by more data;
            # ignore that.
            name,up,rest = line.partition('^')
            name = name.strip()
            m = open(name+'.m','w')
            # Report the new routine name for human reference.
            sys.stdout.write('%s\n' % name)
    if m:
        m.close()
        m = None

def main():
    # Read from standard input.
    ro = sys.stdin
    unpack(ro)

if __name__ == '__main__':
    main()
