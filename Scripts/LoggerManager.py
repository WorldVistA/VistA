#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
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
import logging
logger = logging.getLogger()

def initConsoleLogging(defaultLevel=logging.INFO,
                       formatStr = '%(asctime)s %(levelname)s %(message)s'):
  logger.setLevel(defaultLevel)
  consoleHandler = logging.StreamHandler(sys.stdout)
  formatter = logging.Formatter(formatStr)
  consoleHandler.setLevel(defaultLevel)
  consoleHandler.setFormatter(formatter)
  logger.addHandler(consoleHandler)

def initFileLogging(outputFileName, defaultLevel=logging.INFO,
                    formatStr = '%(asctime)s %(levelname)s %(message)s'):
  logger.setLevel(defaultLevel)
  fileHandle = logging.FileHandler(outputFileName, 'w')
  formatter = logging.Formatter(formatStr)
  fileHandle.setLevel(defaultLevel)
  fileHandle.setFormatter(formatter)
  logger.addHandler(fileHandle)
