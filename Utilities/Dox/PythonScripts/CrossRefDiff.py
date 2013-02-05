#!/usr/bin/env python

# A logFileParser class to parse XINDEX log files and generate the routine/package information in CrossReference Structure
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
#----------------------------------------------------------------

from CrossReference import Global, Routine, Package
from LogManager import logger, initConsoleLogging

class CrossReferenceDiff(object):
  def __init__(self):
    pass
  def generateDiffReport(self, CrossRefA, CrossRefB):
    pass
