#---------------------------------------------------------------------------
# Copyright 2017 The Open Source Electronic Health Record Agent
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

import os
import subprocess
from datetime import datetime

def __generateGitRepositoryKey__(git, mDir, outputFile):
    sha1Key = __getGitRepositLatestSha1Key__(git, mDir)
    outputFile.write("""{
    "date": "%s",
    "sha1": "%s"
    }""" % (datetime.today().date(), sha1Key))

def __getGitRepositLatestSha1Key__(git, mDir):
    gitCommand = "\"" + git + "\"" + " rev-parse --verify HEAD"
    os.chdir(mDir)
    if os.path.exists(os.path.join(mDir,'.git')):
      result = subprocess.check_output(gitCommand, shell=True)
      return result.strip()
    return "Non-Git Directory"

def run(result):
    outputFile = open(os.path.join(result.outdir, "filesInfo.json"), 'wb')
    __generateGitRepositoryKey__(result.git, result.MRepositDir, outputFile)

def createArgParser():
    import argparse
    parser = argparse.ArgumentParser(description='Generate Repository Info')
    parser.add_argument('-mr', '--MRepositDir', required=True,
                        help='VistA M Component Git Repository Directory')
    parser.add_argument('-outdir', required=True,
                        help='top directory to generate output in html')
    parser.add_argument('-git', required=True, help='Git excecutable')
    return parser

def main():
    from LogManager import initConsoleLogging
    initConsoleLogging(formatStr='%(asctime)s %(message)s')
    parser = createArgParser()
    result = parser.parse_args()
    run(result)

if __name__ == '__main__':
    main()
