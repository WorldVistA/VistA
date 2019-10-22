#!/usr/bin/env python

# A JSON file Parser class to parse VistA FileMan db calls json file and generate
# the FileMan db call dependencies among packages.
#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
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
# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4

from builtins import object
import argparse
import json

from CrossReference import CrossReference, Routine, Package, Global
from CrossReference import PlatformDependentGenericRoutine
from CrossReference import FileManField, FileManFile, FileManFieldFactory

from LogManager import logger

"""
  need to ignore some dialog function
  as the input is indeed the dialog file IEN, not fileman file
"""
IGNORE_CALL_LIST = ("BLD^DIALOG", "EZBLD^DIALOG")

class FileManDbCallParser(object):
    """
      A python class to parse fileman db call in JSON Format
      and integrate with cross reference
    """
    def __init__(self, crossRef):
        self._crossRef = crossRef

    def getCrossReference(self):
        return self._crossRef

    def parseFileManDbJSONFile(self, dbJsonFile):
        logger.progress("Start parsing JSON file [%s]" % dbJsonFile)
        with open(dbJsonFile, 'r') as jsonFile:
            dbCallJson = json.load(jsonFile)
            for pkgItem in dbCallJson:
                # find all the routines under that package
                routines = pkgItem['routines']
                for rtn in routines:
                    rtnName = rtn['name']
                    routine = self._crossRef.getRoutineByName(rtnName)
                    if not routine:
                        logger.warn("Cannot find routine [%s]" % rtnName)
                        continue
                    fileManGlobals = rtn['Globals']
                    self._addFileManGlobals(routine, fileManGlobals)
                    fileManFileNos = rtn['FileMan calls']
                    self._addFileManDBCalls(routine, fileManFileNos)

    def _addFileManGlobals(self, routine, fileManGlobals):
        for fileManGbl in fileManGlobals:
            fileManFile = self._crossRef.getGlobalByName(fileManGbl)
            if not fileManFile and fileManGbl[-1] == '(':
                fileManGblAlt = fileManGbl[:-1]
                fileManFile = self._crossRef.getGlobalByName(fileManGblAlt)
            if fileManFile:
                routine.addFilemanDbCallGlobal(fileManFile)
            else: # ignore non-fileman global, could be false positive
                logger.warning("global [%s] is not a valid Fileman file for"
                                " routine %s" % (fileManGbl, routine))
                return

    def isFunctionIgnored(self, callDetail):
        for item in IGNORE_CALL_LIST:
            if callDetail.startswith(item):
                return True
        return False

    def _addFileManDBCalls(self, routine, callLists):
        for callDetail in callLists:
            if self.isFunctionIgnored(callDetail):
                continue
            fnIdx = callDetail.find('(')
            if fnIdx < 0:
                logger.error("Cannot extract fileman number from %s" % callDetail)
                continue
            callTag = callDetail[:fnIdx]
            fileNo = callDetail[fnIdx+1:]
            fileManFile = self._crossRef.getGlobalByFileNo(fileNo)
            if fileManFile:
                routine.addFilemanDbCallGlobal(fileManFile, callTag)
            else:
                if self._crossRef.isFileManSubFileByFileNo(fileNo): # subfile
                    subFile = self._crossRef.getFileManSubFileByFileNo(fileNo)
                    rootFile = self._crossRef.getSubFileRootByFileNo(fileNo)
                    assert rootFile
                    routine.addFilemanDbCallGlobal(subFile, callTag)
                else:
                    logger.warning("file #%s[%s] is not a valid fileman file, for"
                                    " routine [%s]" % (fileNo, callDetail, routine))


def createFileManDBFileAugumentParser(isRequired=True):
    parser = argparse.ArgumentParser(add_help=False) # no help page
    argGroup = parser.add_argument_group("FileMan DB Calls JSON file Parser Auguments")
    argGroup.add_argument('-db', '--filemanDbJson', required=isRequired,
                        help='fileman db call information in JSON format')
    return parser

def parseFileManDBJSONFile(crossRef, fileManJsonFile, isRequired=True):
    fileDbCallParser = FileManDbCallParser(crossRef)
    fileDbCallParser.parseFileManDbJSONFile(fileManJsonFile)
    return fileDbCallParser
