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

import glob
import re
import os
import os.path
import sys
import subprocess
import re
import csv
import argparse
import json

from datetime import datetime, date, time
from CrossReference import CrossReference, Routine, Package, Global
from CrossReference import PlatformDependentGenericRoutine
from CrossReference import FileManField, FileManFile, FileManFieldFactory

from LogManager import logger, initConsoleLogging

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
        logger.info("Start parsing JSON file [%s]" % dbJsonFile)
        with open(dbJsonFile, 'r') as jsonFile:
            dbCallJson = json.load(jsonFile)
            for pkgItem in dbCallJson:
                """ find all the routines under that package """
                routines = pkgItem['routines']
                for rtn in routines:
                    rtnName = rtn['name']
                    routine = self._crossRef.getRoutineByName(rtnName)
                    if not routine:
                        logger.warn("Can not find routine [%s]" % rtnName)
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
                logger.debug("Classic: Adding fileMan:[%s] to routine:[%s]" %
                    (fileManFile, routine.getName()))
                routine.addFilemanDbCallGlobal(fileManFile)
            else: # ignore non-fileman global, could be false positive
                logger.error("global [%s] is not a valid Fileman file for"
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
                logger.debug("Ignore call detail %s" % callDetail)
                continue
            fnIdx = callDetail.find('(')
            if fnIdx < 0:
                logger.error("Can not extract fileman number from %s" %
                    callDetail)
                continue
            callTag = callDetail[:fnIdx]
            fileNo = callDetail[fnIdx+1:]
            fileManFile = self._crossRef.getGlobalByFileNo(fileNo)
            if fileManFile:
                logger.debug("FileMan: Adding fileMan:[%s] to routine:[%s]" %
                    (fileNo, routine.getName()))
                routine.addFilemanDbCallGlobal(fileManFile, callTag)
            else:
                if self._crossRef.isFileManSubFileByFileNo(fileNo): # subfile
                    subFile = self._crossRef.getFileManSubFileByFileNo(fileNo)
                    rootFile = self._crossRef.getSubFileRootByFileNo(fileNo)
                    assert rootFile
                    logger.debug("FileMan: Adding subFile:[%s] to routine:[%s]" %
                        (subFile, routine.getName()))
                    routine.addFilemanDbCallGlobal(subFile, callTag)
                else:
                    logger.error("file #%s[%s] is not a valid fileman file, for"
                        " routine [%s]" % (fileNo, callDetail, routine))

""" main entry """
from CallerGraphParser import createCallGraphLogAugumentParser
from CallerGraphParser import parseAllCallGraphLogWithArg
from DataDictionaryParser import createDataDictionaryAugumentParser
from DataDictionaryParser import parseDataDictionaryLogFile


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

if __name__ == '__main__':
    callLogArgParser = createCallGraphLogAugumentParser()
    dataDictArgParser = createDataDictionaryAugumentParser()
    filemanDBJsonArgParser = createFileManDBFileAugumentParser()
    parser = argparse.ArgumentParser(
          description='VistA Cross-Reference FileMan DB Call JSON Files Parser',
          parents=[callLogArgParser, dataDictArgParser, filemanDBJsonArgParser])
    result = parser.parse_args();
    initConsoleLogging()
    logFileParser = parseAllCallGraphLogWithArg(result)
    crossRef = logFileParser.getCrossReference()
    DDFileParser = parseDataDictionaryLogFile(crossRef, result.fileSchemaDir)
    fileDbCallParser = parseFileManDBJSONFile(crossRef, result.filemanDbJson)
    logger.info("Total # of fileman subfiles are %s" %
                len(crossRef.getAllFileManSubFiles()))
