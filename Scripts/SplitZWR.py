#!/usr/bin/env python
# Split a .zwr files into pieces of maximum size:
#
#   python SplitZWR.py --size <MiB> *.zwr
#
# or
#
#   ls *.zwr | python SplitZWR.py --size <MiB> --stdin
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
import argparse
import os
import sys

class SplitZWR:
    def __init__(self, filepath, maxSize):
        self.maxSize = maxSize
        self.dir = os.path.dirname(filepath)
        self.num, self.name = os.path.basename(filepath).split('+',1)
        self.input = open(filepath, 'r')
        self.headers = []
        while len(self.headers) < 2:
            self.headers.append(self.input.readline())
        self.hdrSize = sum([len(l) for l in self.headers])
        self.outSize = self.maxSize
        self.outFile = None
        self.index = 0

    def new_file(self):
        self.index += 1
        outName = '%s-%d+%s' % (self.num, self.index, self.name)
        outPath = os.path.join(self.dir, outName)
        self.outFile = open(outPath, 'w')
        self.outFile.writelines(self.headers)
        self.outSize = self.hdrSize
        sys.stdout.write(' %s\n' % outPath)

    def do_line(self, line):
        if self.outSize + len(line) > self.maxSize:
            self.new_file()
        self.outSize += len(line)
        self.outFile.write(line)

    def run(self):
        for line in self.input:
            self.do_line(line)

def splitZWR(f, maxSize):
    sys.stdout.write('Splitting "%s":\n' % f)
    SplitZWR(f, maxSize).run()
    os.remove(f)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--size', dest='size', action='store',
                        type = int, required=True,
                        metavar='<MiB>', help='max output file size in MiB')
    parser.add_argument('--stdin', dest='stdin',
                        action='store_const', const=True, default=False,
                        help='read files to split from standard input lines')
    parser.add_argument('files', action='append', nargs='*', metavar='<files>',
                        help='files to split')
    config = parser.parse_args()

    maxSize = int(config.size) << 20
    files = config.files[0]
    if config.stdin:
        files.extend([a.rstrip() for a in sys.stdin])

    for f in files:
        if f[-4:].lower() != '.zwr':
            sys.stderr.write('Skipping non-.zwr file: %s\n' % f)
            continue
        if os.stat(f).st_size > maxSize:
            splitZWR(f, maxSize)

if __name__ == '__main__':
    main()
