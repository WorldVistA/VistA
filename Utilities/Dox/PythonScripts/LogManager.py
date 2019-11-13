#!/usr/bin/env python

# A Python model to manage the logging
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

import logging
import os
import sys

logger = logging.getLogger()

FORMAT_STRING = '%(asctime)s %(levelname)s %(message)s'

# Logging Levels
# CRITICAL
# PROGESS
# ERROR
# WARNING (default, root)
# INFO
# DEBUG
# NOTSET (default, all others)

PROGESS_LOG_LEVEL = 49

def logProgress(self, message, *args, **kws):
    if self.isEnabledFor(PROGESS_LOG_LEVEL):
        self._log(PROGESS_LOG_LEVEL, message, args, **kws)

def initLogging(outputDir, outputFileName, level=logging.ERROR):
    # Use this level to display progress messages, is between CRITCAL and ERROR
    logging.addLevelName(PROGESS_LOG_LEVEL, "PROGRESS ---->")
    logging.Logger.progress = logProgress
    # Set root logging level. This level is checked first and then the
    # individual handers' levels are checked.
    logger.setLevel(level)
    formatter = logging.Formatter(FORMAT_STRING)
    if not os.path.exists(outputDir):
        os.makedirs(outputDir)
    _setupFileLogging(os.path.join(outputDir, outputFileName),
                      logging.DEBUG, formatter)
    _setupConsoleLogging(logging.ERROR, formatter)

def _setupFileLogging(filename, level, formatter):
    fileHandler = logging.FileHandler(filename, 'a')
    fileHandler.setLevel(level)
    fileHandler.setFormatter(formatter)
    logger.addHandler(fileHandler)

def _setupConsoleLogging(level, formatter):
    consoleHandler = logging.StreamHandler(sys.stdout)
    consoleHandler.setLevel(level)
    consoleHandler.setFormatter(formatter)
    logger.addHandler(consoleHandler)
