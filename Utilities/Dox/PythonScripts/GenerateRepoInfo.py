# ---------------------------------------------------------------------------
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
# ---------------------------------------------------------------------------

import os
import subprocess
from datetime import datetime

from LogManager import initLogging, logger

def run(result):
    with open(result.outputfile, 'w') as file:
        if os.path.exists(os.path.join(result.MRepositDir, '.git')):
            os.chdir(result.MRepositDir)
            gitCommand = "\"" + result.git + "\"" + " rev-parse --verify HEAD"
            result = subprocess.check_output(gitCommand, shell=True)
            sha1Key = result.strip()
        else:
            sha1Key = "Non-Git Directory"
        file.write("""{
        "date": "%s",
        "sha1": "%s"
        }""" % (datetime.today().date(), sha1Key))


def createArgParser():
    import argparse
    parser = argparse.ArgumentParser(description='Generate Repository Info')
    parser.add_argument('-mr', '--MRepositDir', required=True,
                        help='VistA M Component Git Repository Directory')
    parser.add_argument('-outputfile', required=True,
                        help='Full path to output file')
    parser.add_argument('-lf', '--logFileDir', required=True,
                        help='Logfile directory')
    parser.add_argument('-git', required=True, help='Git executable')
    return parser


if __name__ == '__main__':
    parser = createArgParser()
    result = parser.parse_args()
    initLogging(result.logFileDir, "GenerateRepoInfo.log")
    logger.debug(result)
    run(result)
