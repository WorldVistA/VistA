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
from builtins import object
import argparse
import codecs
import os
import sys

class SplitZWR(object):
    def __init__(self, filepath, maxSize):
        self.maxSize = maxSize
        self.dir = os.path.dirname(filepath)
        nameSplit = os.path.basename(filepath).split('+',1)
        if len(nameSplit) > 1:
           self.num, self.name = nameSplit
        else:
           self.num=0
           self.name=nameSplit[0]
        self.input = codecs.open(filepath, 'r', encoding='ISO-8859-1', errors='ignore')
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
        self.outFile = codecs.open(outPath, 'w', encoding="ISO-8859-1", errors='ignore')
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

def _splitOne(args):
    # module-level worker so multiprocessing can pickle it
    f, maxSize = args
    splitZWR(f, maxSize)

def splitZWRFiles(files, maxSize, jobs=None):
    """Split each file in `files` (already size-filtered) into <=maxSize pieces.

    Output is identical regardless of `jobs`: every input file is independent
    (its output names/bytes depend only on that file), so worker count and
    scheduling order cannot affect the produced files -- only the interleaving
    of the progress lines on stdout.
    """
    if not files:
        return
    if jobs is None:
        jobs = os.cpu_count() or 1
    jobs = max(1, min(jobs, len(files)))
    if jobs == 1:
        for f in files:
            splitZWR(f, maxSize)
        return
    # biggest first so long-running files don't tail the run; safe to reorder
    files = sorted(files, key=lambda f: os.stat(f).st_size, reverse=True)
    from multiprocessing import Pool
    pool = Pool(processes=jobs)
    try:
        # consume the iterator so any worker exception propagates and aborts,
        # matching the fail-fast behavior of the serial loop
        for _ in pool.imap_unordered(_splitOne,
                                     [(f, maxSize) for f in files],
                                     chunksize=1):
            pass
    finally:
        pool.close()
        pool.join()

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
    parser.add_argument('--jobs', dest='jobs', action='store', type=int,
                        default=1, metavar='<N>',
                        help='number of parallel workers (default 1)')
    config = parser.parse_args()

    maxSize = int(config.size) << 20
    files = config.files[0]
    if config.stdin:
        files.extend([a.rstrip() for a in sys.stdin])

    toSplit = []
    for f in files:
        if "DD.zwr" in f:
            continue
        if f[-4:].lower() != '.zwr':
            sys.stderr.write('Skipping non-.zwr file: %s\n' % f)
            continue
        if os.stat(f).st_size > maxSize:
            toSplit.append(f)
    splitZWRFiles(toSplit, maxSize, jobs=config.jobs)

if __name__ == '__main__':
    main()
