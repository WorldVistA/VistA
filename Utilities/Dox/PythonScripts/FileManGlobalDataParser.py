#---------------------------------------------------------------------------
# Copyright 2014 The Open Source Electronic Health Record Agent
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
import sys
import re
from datetime import datetime
import logging
from CrossReference import FileManField
from ZWRGlobalParser import getKeys, sortDataEntryFloatFirst
from ZWRGlobalParser import convertToType, createGlobalNodeByZWRFile
from FileManSchemaParser import FileManSchemaParser

class FileManDataEntry(object):
  def __init__(self, name, ien):
    self._ien = ien
    self._data = []
    self._name = name
  def addData(self, data):
    self._data.append(data)
  def __repr__(self):
    return "\n%s: %s: \n%s" % (self._name, self._ien, self._data)

class SingleValueData(object):
  def __init__(self, fieldId, type, name, value):
    self._fieldId = fieldId
    self._type = type
    self._name = name
    self._value = value
  def __repr__(self):
    return "%s: %s" % (self._name, self._value)

class MultipleValueData(object):
  def __init__(self, fieldId, name):
    self._fieldId = fieldId
    self._name = name
    self._data = []
  def addData(self, data):
    self._data.append(data)
  def __repr__(self):
    return "%s: %s" % (self._name, self._data)

def test_FileManDataEntry():
  dataEntry = FileManDataEntry("Test", 1)
  dataEntry.addData(SingleValueData('0.1', 'NAME', 'Test'))
  dataEntry.addData(SingleValueData('1', 'TAG', 'TST'))
  dataEntry.addData(SingleValueData('2', 'ROUTINE', 'TEST1'))
  dataEntry.addData(SingleValueData('3', 'INPUT TYPE', '1'))
  multiValue = MultipleValueData('4', 'GROUP')
  subDataEntry = FileManDataEntry("SubTest", 1)
  subDataEntry.addData(SingleValueData('.01', 'NAME', 'SUBTEST'))
  subDataEntry.addData(SingleValueData('1', 'DATA', '0'))
  multiValue.addData(subDataEntry)
  subDataEntry = FileManDataEntry("SubTest", 2)
  subDataEntry.addData(SingleValueData('.01', 'NAME', 'SUBTEST1'))
  subDataEntry.addData(SingleValueData('1', 'DATA', '1'))
  multiValue.addData(subDataEntry)
  dataEntry.addData(multiValue)
  import pprint
  pprint.pprint(dataEntry)

def sortSchemaByLocation(fileSchema):
  locFieldDict = {}
  for fldAttr in fileSchema.getAllFileManFields().itervalues():
    loc = fldAttr.getLocation()
    if not loc: continue
    index,pos = loc.split(';')
    if index not in locFieldDict:
      locFieldDict[index] = {}
    locFieldDict[index][pos] = fldAttr
  return locFieldDict

class FileManGlobalDataParser(object):
  def __init__(self):
    self._dataRoot = None
    self._allSchemaDict = None
    self._glbDataDict = {}
    self._outDataRoot = None
    self._curData = None

  def parseZWRGlobalDataBySchema(self, inputFileName, allSchemaDict, fileNumber):
    self._dataRoot = createGlobalNodeByZWRFile(inputFileName)
    self._allSchemaDict = allSchemaDict
    self._outDataRoot = self._glbDataDict
    self._curData = None
    self._parseDataBySchema(self._dataRoot, self._allSchemaDict[fileNumber])

  def _parseDataBySchema(self, dataRoot, fileSchema):
    """ first sort the schema Root by location """
    locFieldDict = sortSchemaByLocation(fileSchema)
    """ for each data entry, parse data by location """
    floatKey = getKeys(dataRoot, float)
    logging.debug('Total # of entry is %s' % len(floatKey))
    for ien in floatKey:
      if float(ien) <=0:
        continue
      #if level == 0 and int(ien) != 160: continue
      dataEntry = dataRoot[ien]
      self._curData = FileManDataEntry(fileSchema.getFileNo(), ien)
      dataKeys = [x for x in dataEntry]
      sortedKey = sorted(dataKeys, cmp=sortDataEntryFloatFirst)
      for locKey in sortedKey:
        if locKey in locFieldDict:
          fieldDict = locFieldDict[locKey] # a dict of {pos: field}
          curDataRoot = dataEntry[locKey]
          if len(fieldDict) == 1:
            fieldAttr = fieldDict.values()[0]
            if fieldAttr.isSubFilePointerType(): # Multiple
              self._parseSubFileField(curDataRoot, fieldAttr)
            else:
              self._parseSingleDataValueField(curDataRoot, fieldAttr)
          else:
            self._parseDataValueField(curDataRoot, fieldDict)
      self._outDataRoot[ien] = self._curData

  def _parseSingleDataValueField(self, dataEntry, fieldAttr):
    values = dataEntry.value
    if not values: return
    location = fieldAttr.getLocation()
    dataValue = None
    if location:
      index, loc = location.split(';')
      if loc:
        if convertToType(loc, int):
          intLoc = int(loc)
          if intLoc > 0 and intLoc <= len(values):
            dataValue = values[intLoc-1]
        else:
          dataValue = str(dataEntry.value)
    else:
      dataValue = str(dataEntry.value)
    if dataValue:
      self._parseIndividualFieldDetail(dataValue, fieldAttr)

  def _parseDataValueField(self, fieldDict):
    values = self._curDataRoot.value
    if not values: return # this is very import to check
    for idx, value in enumerate(values, 1):
      if value and str(idx) in fieldDict:
        fieldAttr = fieldDict[str(idx)]
        parseIndividualFieldDetail(value, fieldAttr)

  def _parseIndividualFieldDetail(self, value, fieldAttr):
    if not value: return
    value = value.strip(' ')
    if not value: return
    fieldDetail = value
    if fieldAttr.isSetType():
      setDict = fieldAttr.getSetMembers()
      if setDict and value in setDict:
        fieldDetail = setDict[value]
    elif fieldAttr.isFilePointerType():
      filePointedTo = fieldAttr.getPointedToFile()
      if filePointedTo:
        fieldDetail = 'File: %s, IEN: %s' % (filePointedTo.getFileNo(), value)
      else:
        fieldDetail = 'No Pointed to File'
    self._curData.addData(SingleValueData(fieldAttr.getFieldNo(),
                                          fieldAttr.getType(),
                                          fieldAttr.getName(),
                                          fieldDetail))
    logging.debug("%s: %s" % (fieldAttr.getName(), fieldDetail))

  def _parseSubFileField(self, dataRoot, fieldAttr):
    logging.debug ("%s" % (fieldAttr.getName() + ':'))
    subFile = fieldAttr.getPointedToSubFile()
    if fieldAttr.hasSubType(FileManField.FIELD_TYPE_WORD_PROCESSING):
      outLst = self._parsingWordProcessingNode(dataRoot)
      self.curData.addData(SingleValueData(fieldAttr.getFieldNo(),
                                           fieldAttr.getType(),
                                           fieldAttr.getName(),
                                           outLst))
    elif subFile:
      self._outDataRoot = self._curData
      self._parseDataBySchema(dataRoot, subFile)
    else:
      logging.info ("Sorry, do not know how to intepret the schema %s" % fieldAttr)

  def _parsingWordProcessingNode(self, dataRoot):
    outLst = []
    for key in sorted(dataRoot, key=lambda x: int(x)):
      if '0' in dataRoot[key]:
        outLst.append(dataRoot[key]['0'].value)
    return outLst


def createArgParser():
  import argparse
  parser = argparse.ArgumentParser(description='FileMan Global Data Parser')
  parser.add_argument('ddFile', help='path to ZWR file contains DD global')
  parser.add_argument('gdFile', help='path to ZWR file contains Globals data')
  parser.add_argument('fileNo', help='fileManFileNo')
  return parser

def testGlobalParser():
  parser = createArgParser()
  result = parser.parse_args()
  print result
  schemaParser = FileManSchemaParser()
  allSchemaDict = schemaParser.parseSchemaDDFile(result.ddFile)
  parseZWRGlobalDataBySchema(result.gdFile, allSchemaDict, result.fileNo)

def horologToDateTime(input):
  from datetime import timedelta
  originDt = datetime(1840,12,31,0,0,0)
  if input.find(',') < 0: # invalid format
    return None
  days, seconds = input.split(',')
  return originDt + timedelta(int(days), int(seconds))

def test_horologToDateTime():
  input = '57623,29373'
  logging.info(horologToDateTime(input))

def main():
  from LogManager import initConsoleLogging
  initConsoleLogging(formatStr='%(message)s')
  test_horologToDateTime()
  #test_FileManDataEntry()
  #testGlobalParser()

if __name__ == '__main__':
  main()
