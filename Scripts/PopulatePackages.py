#!/usr/bin/env python
# Populate package directories.
#
#   python PopulatePackages.py < packages.csv
#
# The input packages.csv table must have these columns:
#
#   Package Name,Directory Name,Prefixes,File Numbers,File Names,Globals
#
# Rows with an empty package name specify additional prefixes and
# globals for the most recently named package.  Prepend '!' to exclude
# a prefix.
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
import csv
import glob

class Package:
    def __init__(self, name, path):
        self.name = name
        self.path = path.strip().replace('/',os.path.sep)
        self.included = set()
        self.excluded = set()
        self.globals = set()
    def add_namespace(self, ns):
        if ns:
            if ns[0] in ('-','!'):
                self.excluded.add(ns[1:])
            else:
                self.included.add(ns)
    def add_number(self, n):
        if n:
            if n[0] == '.':
                n = '0' + n
            self.globals.add(n) # numbers work just like globals
    def add_global(self, g):
        if g:
            self.globals.add(g)

def order_long_to_short(l,r):
    if len(l) > len(r):
        return -1
    elif len(l) < len(r):
        return +1
    else:
        return cmp(l,r)

def place(src,dst):
    sys.stdout.write('%s => %s\n' % (src,dst))
    d = os.path.dirname(dst)
    if d:
        try: os.makedirs(d)
        except OSError: pass
    os.rename(src,dst)

#-----------------------------------------------------------------------------

def populate(input):
    packages_csv = csv.DictReader(input)
    # Parse packages and namespaces from CSV table on stdin.
    packages = []
    pkg = None
    for fields in packages_csv:
        if fields['Package Name']:
            pkg = Package(fields['Package Name'], fields['Directory Name'])
            packages.append(pkg)
        if pkg:
            pkg.add_namespace(fields['Prefixes'])
            pkg.add_number(fields['File Numbers'])
            pkg.add_global(fields['Globals'])

    # Construct "namespace => path" map.
    namespaces = {}
    for p in packages:
        for ns in p.included:
            namespaces[ns] = p.path
        for ns in p.excluded:
            if not namespaces.has_key(ns):
                namespaces[ns] = None

    #-----------------------------------------------------------------------------

    # Collect routines and globals in current directory.
    routines = set(glob.glob('*.m'))
    globals = set(glob.glob('*.zwr'))

    #-----------------------------------------------------------------------------

    # Map by package namespace (prefix).
    for ns in sorted(namespaces.keys(),order_long_to_short):
        path = namespaces[ns]
        gbls = [gbl for gbl in globals if gbl.startswith(ns)]
        rtns = [rtn for rtn in routines if rtn.startswith(ns)]
        if (rtns or gbls) and not path:
            sys.stderr.write('Namespace "%s" has no path!\n' % ns)
            continue
        routines.difference_update(rtns)
        globals.difference_update(gbls)
        for src in sorted(rtns):
            place(src,os.path.join(path,'Routines',src))
        for src in sorted(gbls):
            place(src,os.path.join(path,'Globals',src))

    # Map globals explicitly listed in each package.
    for p in packages:
        gbls = [gbl for gbl in globals
                if gbl[:-4].split('+')[0].split('-')[0] in p.globals]
        globals.difference_update(gbls)
        for src in sorted(gbls):
            place(src,os.path.join(p.path,'Globals',src))

    # Put leftover routines and globals in Uncategorized package.
    for src in routines:
        place(src,os.path.join('Uncategorized','Routines',src))
    for src in globals:
        place(src,os.path.join('Uncategorized','Globals',src))

def main():
    populate(sys.stdin)

if __name__ == '__main__':
    main()
