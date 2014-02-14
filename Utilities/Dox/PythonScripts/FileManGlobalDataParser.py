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
from ZWRGlobalParser import getKeys, sortDataEntryFloatFirst, createGlobalNodeByZWRFile
from ZWRGlobalParser import createGlobalNodeByZWRFile
from FileManSchemaParser import FileManSchemaParser, parsingWordProcessingNode

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

def parseDataBySchema(dataRoot, fileSchemaDict, fileNumber, level=0):
  """ first sort the schema Root by location """
  indent = "\t" * level
  locFieldDict = sortSchemaByLocation(fileSchemaDict[fileNumber])
  """ for each data entry, parse data by location """
  floatKey = getKeys(dataRoot, float)
  for ien in floatKey:
    if float(ien) <=0:
      continue
    #if level == 0 and int(ien) != 160: continue
    dataEntry = dataRoot[ien]
    logging.info ('%s------------------' % indent)
    logging.info ('%sFileEntry: %s' % (indent, ien))
    logging.info ('%s------------------' % indent)
    dataKeys = [x for x in dataEntry]
    sortedKey = sorted(dataKeys, cmp=sortDataEntryFloatFirst)
    for locKey in sortedKey:
      if locKey in locFieldDict:
        fieldDict = locFieldDict[locKey] # a dict of {pos: field}
        if len(fieldDict) == 1:
          fieldAttr = fieldDict.values()[0]
          if fieldAttr.isSubFilePointerType(): # Multiple
            parseSubFileField(dataEntry[locKey], fieldAttr, fileSchemaDict, level)
          else:
            parseSingleDataValueField(dataEntry[locKey], fieldAttr, level)
        else:
          parseDataValueField(dataEntry[locKey], fieldDict, level)

def parseSingleDataValueField(dataEntry, fieldAttr, level):
  values = dataEntry.value
  if not values: return
  indent = "\t" * level
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
    parseIndividualFieldDetail(dataValue, fieldAttr, level)

def parseDataValueField(dataRoot, fieldDict, level):
  indent = "\t" * level
  values = dataRoot.value
  if not values: return # this is very import to check
  for idx, value in enumerate(values, 1):
    if value and str(idx) in fieldDict:
      fieldAttr = fieldDict[str(idx)]
      parseIndividualFieldDetail(value, fieldAttr, level)

def parseIndividualFieldDetail(value, fieldAttr, level):
  if not value: return
  value = value.strip(' ')
  if not value: return
  indent = "\t" * level
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
  logging.info ("%s%s: %s" % (indent, fieldAttr.getName(), fieldDetail))

def parseSubFileField(dataRoot, fieldAttr, fileSchemaDict, level):
  indent = "\t"*level
  logging.info ("%s%s" % (indent, fieldAttr.getName() + ':'))
  subFile = fieldAttr.getPointedToSubFile()
  if fieldAttr.hasSubType(FileManField.FIELD_TYPE_WORD_PROCESSING):
    parsingWordProcessingNode(dataRoot, level+1)
  elif subFile:
    parseDataBySchema(dataRoot, fileSchemaDict, subFile.getFileNo(), level+1)
  else:
    logging.info ("Sorry, do not know how to intepret the schema %s" % fieldAttr)

def parseZWRGlobalDataBySchema(inputFileName, allSchemaDict, fileNumber):
  glbDataRoot = createGlobalNodeByZWRFile(inputFileName)
  parseDataBySchema(glbDataRoot[fileNumber], allSchemaDict, fileNumber)

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

def main():
  from LogManager import initConsoleLogging
  initConsoleLogging(formatStr='%(message)s')
  testGlobalParser()

if __name__ == '__main__':
  main()
