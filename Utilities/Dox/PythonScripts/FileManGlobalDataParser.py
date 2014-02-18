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
from ZWRGlobalParser import getKeys, sortDataEntryFloatFirst, printGlobal
from ZWRGlobalParser import convertToType, createGlobalNodeByZWRFile
from FileManSchemaParser import FileManSchemaParser

FILE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(FILE_DIR, "../../../Scripts"))
print SCRIPTS_DIR
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)

from FileManDateTimeUtil import fmDtToPyDt

class FileManFileData(object):
  def __init__(self, fileNo, name):
    self._fileNo = fileNo
    self._name = name
    self._data = {}
  @property
  def data(self):
    return self._data
  @property
  def name(self):
    return self._name
  @property
  def fileNo(self):
    return self._fileNo
  def addFileManDataEntry(self, ien, dataEntry):
    self._data[ien] = dataEntry
  def __repr__(self):
    return "%s, %s, %s" % (self._fileNo, self._name, self._data)

class FileManDataEntry(object):
  def __init__(self, fileNo, ien):
    self._ien = ien
    self._data = []
    self._fileNo = fileNo
  @property
  def data(self):
    return self._data
  def addData(self, data):
    self._data.append(data)
  def __repr__(self):
    return "%s: %s: %s" % (self._fileNo, self._ien, self._data)

class FileManDataField(object):
  def __init__(self, fieldId, type, name, value):
    self._fieldId = fieldId
    self._type = type
    self._name = name
    self._value = value
  @property
  def name(self):
    return self._name
  @property
  def type(self):
    return self._type
  @property
  def value(self):
    return self._value
  @value.setter
  def value(self, value):
    self._value = value
  def __repr__(self):
    return "%s: %s" % (self._name, self._value)

def printFileManFileData(fileManData, level=0):
  curIndent = "\t"*(level+1)
  if level == 0:
    print "File#: %s, Name: %s" % (fileManData.fileNo, fileManData.name)
  for ien in getKeys(fileManData.data.keys(), float):
    dataEntry = fileManData.data[ien]
    if level == 0:
      print "FileEntry#: %s" % ien
    else:
      print
    for dataField in dataEntry.data:
      if dataField.type == FileManField.FIELD_TYPE_SUBFILE_POINTER:
        if dataField.value:
          print "%s%s:" % (curIndent, dataField.name)
          printFileManFileData(dataField.value, level+1)
      elif dataField.type == FileManField.FIELD_TYPE_WORD_PROCESSING:
        wdList = dataField.value
        if wdList:
          print "%s%s:" % (curIndent, dataField.name)
          for item in wdList:
            print "%s\t%s" % (curIndent, item)
      else:
        print "%s%s: %s" % (curIndent, dataField.name, dataField.value)
    print


def test_FileManDataEntry():
  fileManData = FileManFileData('1', 'TEST FILE 1')
  dataEntry = FileManDataEntry("Test",1)
  dataEntry.addData(FileManDataField('0.1', 0, 'NAME', 'Test'))
  dataEntry.addData(FileManDataField('1', 0, 'TAG', 'TST'))
  dataEntry.addData(FileManDataField('2', 1, 'ROUTINE', 'TEST1'))
  dataEntry.addData(FileManDataField('3', 2, 'INPUT TYPE', '1'))
  subFileData = FileManFileData('1.01', 'TEST FILE SUB-FIELD')
  subDataEntry = FileManDataEntry("1.01", 1)
  subDataEntry.addData(FileManDataField('.01',0,  'NAME', 'SUBTEST'))
  subDataEntry.addData(FileManDataField('1', 1, 'DATA', '0'))
  subFileData.addFileManDataEntry('1', subDataEntry)
  subDataEntry = FileManDataEntry("1.01", 2)
  subDataEntry.addData(FileManDataField('.01', 0, 'NAME', 'SUBTEST1'))
  subDataEntry.addData(FileManDataField('1', 1, 'DATA', '1'))
  subFileData.addFileManDataEntry('2', subDataEntry)
  dataEntry.addData(FileManDataField('4', 9, 'SUB-FIELD', subFileData))
  fileManData.addFileManDataEntry('1', dataEntry)
  printFileManFileData(fileManData)

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
    self._glbData = {} # fileNo => FileManData

  @property
  def outFileManData(self):
    return self._glbData
  def parseZWRGlobalDataBySchema(self, inputFileName, allSchemaDict, fileNumber, subscript):
    self._dataRoot = createGlobalNodeByZWRFile(inputFileName)
    self._allSchemaDict = allSchemaDict
    schemaFile = allSchemaDict[fileNumber]
    if subscript and subscript in self._dataRoot:
      dataRoot = self._dataRoot[subscript]
      self._glbData[fileNumber] = FileManFileData(fileNumber, schemaFile.getFileManName())
      self._parseDataBySchema(dataRoot, schemaFile, self._glbData[fileNumber])
    else: # assume this is for all files in the entry
      for fileNo in getKeys(self._dataRoot, float):
        dataRoot = self._dataRoot[fileNo]
        self._glbData[fileNo] = FileManFileData(fileNo, schemaFile.getFileManName())
        self._parseDataBySchema(dataRoot, schemaFile, self._glbData[fileNo])

  def _parseDataBySchema(self, dataRoot, fileSchema, outGlbData):
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
      outDataEntry = FileManDataEntry(fileSchema.getFileNo(), ien)
      dataKeys = [x for x in dataEntry]
      sortedKey = sorted(dataKeys, cmp=sortDataEntryFloatFirst)
      for locKey in sortedKey:
        if locKey in locFieldDict:
          fieldDict = locFieldDict[locKey] # a dict of {pos: field}
          curDataRoot = dataEntry[locKey]
          if len(fieldDict) == 1:
            fieldAttr = fieldDict.values()[0]
            if fieldAttr.isSubFilePointerType(): # Multiple
              self._parseSubFileField(curDataRoot, fieldAttr, outDataEntry)
            else:
              self._parseSingleDataValueField(curDataRoot, fieldAttr, outDataEntry)
          else:
            self._parseDataValueField(curDataRoot, fieldDict, outDataEntry)
      logging.debug("adding %s" % ien)
      outGlbData.addFileManDataEntry(ien, outDataEntry)

  def _parseSingleDataValueField(self, dataEntry, fieldAttr, outDataEntry):
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
      self._parseIndividualFieldDetail(dataValue, fieldAttr, outDataEntry)

  def _parseDataValueField(self, dataRoot, fieldDict, outDataEntry):
    values = dataRoot.value
    if not values: return # this is very import to check
    for idx, value in enumerate(values, 1):
      if value and str(idx) in fieldDict:
        fieldAttr = fieldDict[str(idx)]
        self._parseIndividualFieldDetail(value, fieldAttr, outDataEntry)

  def _parseIndividualFieldDetail(self, value, fieldAttr, outDataEntry):
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
    elif fieldAttr.getType() == FileManField.FIELD_TYPE_DATE_TIME: # datetime
      if value.find(',') >=0:
        fieldDetail = horologToDateTime(value)
      else:
        outDt = fmDtToPyDt(value)
        if outDt:
          fieldDetail = outDt
        else:
          logger.warn("Could not parse Date/Time: %s" % value)

    outDataEntry.addData(FileManDataField(fieldAttr.getFieldNo(),
                                          fieldAttr.getType(),
                                          fieldAttr.getName(),
                                          fieldDetail))
    logging.debug("%s: %s" % (fieldAttr.getName(), fieldDetail))

  def _parseSubFileField(self, dataRoot, fieldAttr, outDataEntry):
    logging.debug ("%s" % (fieldAttr.getName() + ':'))
    subFile = fieldAttr.getPointedToSubFile()
    if fieldAttr.hasSubType(FileManField.FIELD_TYPE_WORD_PROCESSING):
      outLst = self._parsingWordProcessingNode(dataRoot)
      outDataEntry.addData(FileManDataField(fieldAttr.getFieldNo(),
                                           FileManField.FIELD_TYPE_WORD_PROCESSING,
                                           fieldAttr.getName(),
                                           outLst))
    elif subFile:
      subFileData = FileManFileData(subFile.getFileNo(), subFile.getFileManName())
      self._parseDataBySchema(dataRoot, subFile, subFileData)
      outDataEntry.addData(FileManDataField(fieldAttr.getFieldNo(),
                                            FileManField.FIELD_TYPE_SUBFILE_POINTER,
                                            fieldAttr.getName(),
                                            subFileData))
    else:
      logging.info ("Sorry, do not know how to intepret the schema %s" % fieldAttr)

  def _parsingWordProcessingNode(self, dataRoot):
    outLst = []
    for key in getKeys(dataRoot, int):
      if '0' in dataRoot[key]:
        outLst.append("%s" % dataRoot[key]['0'].value)
    return outLst


def createArgParser():
  import argparse
  parser = argparse.ArgumentParser(description='FileMan Global Data Parser')
  parser.add_argument('ddFile', help='path to ZWR file contains DD global')
  parser.add_argument('gdFile', help='path to ZWR file contains Globals data')
  parser.add_argument('fileNo', help='FileMan File Number')
  parser.add_argument('subscript', help='The first subscript of the global root')
  return parser

def testGlobalParser():
  parser = createArgParser()
  result = parser.parse_args()
  print result
  schemaParser = FileManSchemaParser()
  allSchemaDict = schemaParser.parseSchemaDDFile(result.ddFile)
  glbDataParser = FileManGlobalDataParser()
  glbDataParser.parseZWRGlobalDataBySchema(result.gdFile,
                                           allSchemaDict,
                                           result.fileNo,
                                           result.subscript)
  for fileNo in getKeys(glbDataParser.outFileManData.iterkeys(), float):
    printFileManFileData((glbDataParser.outFileManData[fileNo]))


def horologToDateTime(input):
  """
    convert Mumps Horolog time to python datatime
  """
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
  #test_horologToDateTime()
  #test_FileManDataEntry()
  testGlobalParser()

if __name__ == '__main__':
  main()
