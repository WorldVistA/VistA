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
from ZWRGlobalParser import readGlobalNodeFromZWRFile
from FileManSchemaParser import FileManSchemaParser

FILE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(FILE_DIR, "../../../Scripts"))
print SCRIPTS_DIR
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)

from FileManDateTimeUtil import fmDtToPyDt
import glob

class FileManFileData(object):
  def __init__(self, fileNo, name):
    self._fileNo = fileNo
    self._name = name
    self._data = {}
  @property
  def dataEntries(self):
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
    self._data = {}
    self._fileNo = fileNo
    self._name = None
  @property
  def fields(self):
    return self._data
  @property
  def name(self):
    return self._name
  @property
  def ien(self):
    return self._ien
  @name.setter
  def name(self, name):
    self._name = name
  def addField(self, fldData):
    self._data[fldData.id] = fldData
  def __repr__(self):
    return "%s: %s: %s" % (self._fileNo, self._ien, self._data)

class FileManDataField(object):
  def __init__(self, fieldId, type, name, value):
    self._fieldId = fieldId
    self._type = type
    self._name = name
    self._value = value
  @property
  def id(self):
    return self._fieldId
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
  for ien in getKeys(fileManData.dataEntries.keys(), float):
    dataEntry = fileManData.dataEntries[ien]
    printFileManDataEntry(dataEntry, ien, level)

def printFileManDataEntry(dataEntry, ien, level):
  curIndent = "\t"*(level+1)
  if level == 0:
    print "FileEntry#: %s, Name: %s" % (ien, dataEntry.name)
  else:
    print
  for fldId in sorted(dataEntry.fields.keys(), key=lambda x: float(x)):
    dataField = dataEntry.fields[fldId]
    if dataField.type == FileManField.FIELD_TYPE_SUBFILE_POINTER:
      if dataField.value and dataField.value.dataEntries:
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
  dataEntry.addField(FileManDataField('0.1', 0, 'NAME', 'Test'))
  dataEntry.addField(FileManDataField('1', 0, 'TAG', 'TST'))
  dataEntry.addField(FileManDataField('2', 1, 'ROUTINE', 'TEST1'))
  dataEntry.addField(FileManDataField('3', 2, 'INPUT TYPE', '1'))
  subFileData = FileManFileData('1.01', 'TEST FILE SUB-FIELD')
  subDataEntry = FileManDataEntry("1.01", 1)
  subDataEntry.addField(FileManDataField('.01',0,  'NAME', 'SUBTEST'))
  subDataEntry.addField(FileManDataField('1', 1, 'DATA', '0'))
  subFileData.addFileManDataEntry('1', subDataEntry)
  subDataEntry = FileManDataEntry("1.01", 2)
  subDataEntry.addField(FileManDataField('.01', 0, 'NAME', 'SUBTEST1'))
  subDataEntry.addField(FileManDataField('1', 1, 'DATA', '1'))
  subFileData.addFileManDataEntry('2', subDataEntry)
  dataEntry.addField(FileManDataField('4', 9, 'SUB-FIELD', subFileData))
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
  def __init__(self, crossRef=None):
    self._dataRoot = None
    self._allSchemaDict = None
    self._crossRef = crossRef
    self._curFileNo =  None
    self._glbData = {} # fileNo => FileManData
    self._selfRef = {}

  @property
  def outFileManData(self):
    return self._glbData

  @property
  def crossRef(self):
    return self._crossRef

  def _createDataRootByZWRFile(self, inputFileName):
    self._dataRoot = createGlobalNodeByZWRFile(inputFileName)

  def getAllFileManZWRFiles(self, dirName, pattern):
    searchFiles = glob.glob(os.path.join(dirName, pattern))
    outFiles = {}
    for file in searchFiles:
      fileName = os.path.basename(file)
      result = re.search("(?P<fileNo>^[0-9.]+)(-[1-9])?\+(?P<des>.*)\.zwr$", fileName)
      if result:
        "ignore split file for now"
        if result.groups()[1]:
          logging.info("Ignore file %s" % fileName)
          continue
        fileNo = result.group('fileNo')
        if fileNo.startswith('0'): fileNo = fileNo[1:]
        globalDes = result.group('des')
        outFiles[fileNo] = (globalDes, os.path.normpath(os.path.abspath(file)))
    return outFiles

  def parseAllZWRGlobaFilesBySchema(self, mRepositDir, allSchemaDict):
    """ Parsing all ZWR Global Files via Schema
    """
    allFiles = self.getAllFileManZWRFiles(os.path.join(mRepositDir,
                                                       'Packages'),
                                                     "*/Globals/*.zwr")
    allFileManGlobal = self._crossRef.getAllFileManGlobals()
    sizeLimit = 59*1024*1024 # 1 MiB
    for key in sorted(allFileManGlobal.keys()):
      fileManFile = allFileManGlobal[key]
      fileNo = fileManFile.getFileNo()
      if fileNo not in allFiles:
        continue
      ddFile = allFiles[fileNo][1]
      glbDes = allFiles[fileNo][0]
      self._createDataRootByZWRFile(ddFile)
      if not self._dataRoot:
        logging.warn("not data for file %s" % ddFile)
        continue
      globalName = fileManFile.getName()
      parts = globalName.split('(')
      rootName, subscript = (None, None)
      if len(parts) > 1:
        rootName = parts[0]
        subscript = parts[1].strip('"')
      else:
        rootName = parts[0]
        subscript = rootName
      assert rootName == self._dataRoot.subscript
      logging.info("File: %s, root: %s, sub: %s" % (ddFile, rootName, subscript))
      self.parseZWRGlobalDataBySchema(self._dataRoot, allSchemaDict,
                                      fileNo, subscript)
      self._glbData = {}

  def parseZWRGlobalFileBySchema(self, inputFileName, allSchemaDict,
                                 fileNumber, subscript):
    self._createDataRootByZWRFile(inputFileName)
    self.parseZWRGlobalDataBySchema(dataRoot, allSchemaDict,
                                    fileNumber, subscript)

  def parseZWRGlobalFileBySchemaV2(self, inputFileName, allSchemaDict,
                                 fileNumber, subscript):
    self._allSchemaDict = allSchemaDict
    schemaFile = allSchemaDict[fileNumber]
    self._glbData[fileNumber] = FileManFileData(fileNumber,
                                                schemaFile.getFileManName())
    self._curFileNo = fileNumber
    for dataRoot in readGlobalNodeFromZWRFile(inputFileName):
      if not dataRoot: continue
      self._dataRoot = dataRoot
      fileDataRoot = dataRoot
      if subscript:
        if subscript in dataRoot:
          logging.info("using subscript %s" % subscript)
          fileDataRoot = dataRoot[subscript]
      self._parseDataBySchema(fileDataRoot, schemaFile, self._glbData[fileNumber])
    self._resolveSelfPointer()
    if self._crossRef:
      self._updateCrossReference()
    for value in self._glbData.itervalues():
      printFileManFileData(value)

  def parseZWRGlobalDataBySchema(self, dataRoot, allSchemaDict,
                                 fileNumber, subscript):
    self._allSchemaDict = allSchemaDict
    schemaFile = allSchemaDict[fileNumber]
    fileDataRoot = dataRoot
    if subscript:
      if subscript in dataRoot:
        logging.info("using subscript %s" % subscript)
        fileDataRoot = dataRoot[subscript]
      self._glbData[fileNumber] = FileManFileData(fileNumber,
                                                  schemaFile.getFileManName())
      self._parseDataBySchema(fileDataRoot, schemaFile, self._glbData[fileNumber])
    else: # assume this is for all files in the entry
      for fileNo in getKeys(self._dataRoot, float):
        fileDataRoot = self._dataRoot[fileNo]
        self._glbData[fileNo] = FileManFileData(fileNo,
                                                schemaFile.getFileManName())
        self._parseDataBySchema(fileDataRoot, schemaFile, self._glbData[fileNo])
    self._resolveSelfPointer()
    if self._crossRef:
      self._updateCrossReference()

  def _updateCrossReference(self):
    if '8994' in self._glbData:
      self._updateRPCRefence()

  def _updateRPCRefence(self):
    rpcData = self._glbData['8994']
    for ien in sorted(rpcData.dataEntries.keys(), key=lambda x: float(x)):
      rpcEntry = rpcData.dataEntries[ien]
      if rpcEntry.name:
        namespace, package = \
        self._crossRef.__categorizeVariableNameByNamespace__(rpcEntry.name)
        if package:
          package.rpcs.append(rpcEntry)
          logging.info("Adding RPC: %s to Package: %s" %
                      (rpcEntry.name, package.getName()))
        else:
          """ try to categorize by routine called """
          if '.03' in rpcEntry.fields:
            rpcRoutine = rpcEntry.fields['.03'].value
            namespace, package = \
            self._crossRef.__categorizeVariableNameByNamespace__(rpcRoutine)
            if package:
              package.rpcs.append(rpcEntry)
              logging.info("Adding RPC: %s to Package: %s" %
                          (rpcEntry.name, package.getName()))
          else:
            logging.error("Can not find package for RPC: %s" %
                          (rpcEntry.name))


  def _resolveSelfPointer(self):
    """ Replace self-reference with meaningful data """
    for fileNo in self._selfRef:
      if fileNo in self._glbData:
        fileData = self._glbData[fileNo]
        for ien, fields in self._selfRef[fileNo].iteritems():
          if ien in fileData.dataEntries:
            name = fileData.dataEntries[ien].name
            for field in fields:
              field.value = ";".join((field.value, name))

  def _parseDataBySchema(self, dataRoot, fileSchema, outGlbData):
    """ first sort the schema Root by location """
    locFieldDict = sortSchemaByLocation(fileSchema)
    """ for each data entry, parse data by location """
    floatKey = getKeys(dataRoot, float)
    logging.info('Total # of entry is %s' % len(floatKey))
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
              self._parseSingleDataValueField(curDataRoot, fieldAttr,
                                              outDataEntry)
          else:
            self._parseDataValueField(curDataRoot, fieldDict, outDataEntry)
      logging.debug("adding %s" % ien)
      outGlbData.addFileManDataEntry(ien, outDataEntry)

  def _parseSingleDataValueField(self, dataEntry, fieldAttr, outDataEntry):
    if not dataEntry.value:
      return
    values = dataEntry.value.split('^')
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
    if not dataRoot.value:
      return
    values = dataRoot.value.split('^')
    if not values: return # this is very import to check
    for idx, value in enumerate(values, 1):
      if value and str(idx) in fieldDict:
        fieldAttr = fieldDict[str(idx)]
        self._parseIndividualFieldDetail(value, fieldAttr, outDataEntry)

  def _parseIndividualFieldDetail(self, value, fieldAttr, outDataEntry):
    logging.debug("Parsing Individual Field Detail: %s" % value)
    if not value.strip(' '):
      return
    value = value.strip(' ')
    fieldDetail = value
    selfPointer = False
    if fieldAttr.isSetType():
      setDict = fieldAttr.getSetMembers()
      if setDict and value in setDict:
        fieldDetail = setDict[value]
    elif fieldAttr.isFilePointerType():
      filePointedTo = fieldAttr.getPointedToFile()
      if filePointedTo:
        fileNo = filePointedTo.getFileNo()
        if fileNo == self._curFileNo:
          selfPointer = True
        fieldDetail = ';'.join((filePointedTo.getFileNo(), value))
      else:
        fieldDetail = 'No Pointed to File'
    elif fieldAttr.isVariablePointerType():
      vpInfo = value.split(';')
      if len(vpInfo) != 2:
        logging.error("Unknown variable pointer format: %s" % value)
        fieldDetail = "Unknow Variable Pointer"
      else:
        fieldDetail = 'Global Root: %s, IEN: %s' % (vpInfo[1], vpInfo[0])
    elif fieldAttr.getType() == FileManField.FIELD_TYPE_DATE_TIME: # datetime
      if value.find(',') >=0:
        fieldDetail = horologToDateTime(value)
      else:
        outDt = fmDtToPyDt(value)
        if outDt:
          fieldDetail = outDt
        else:
          logging.warn("Could not parse Date/Time: %s" % value)
    elif fieldAttr.getName().upper() == "TIMESTAMP": # timestamp field
      if value.find(',') >=0:
        fieldDetail = horologToDateTime(value)
    logging.debug("Field Detail is %s" % fieldDetail)
    dataField = FileManDataField(fieldAttr.getFieldNo(),
                                 fieldAttr.getType(),
                                 fieldAttr.getName(),
                                 fieldDetail)
    if selfPointer:
      self._addDataFieldToSelfRef(value, dataField)
    outDataEntry.addField(dataField)
    if fieldAttr.getFieldNo() == '.01':
      logging.debug("Setting dataEntry name as %s" % fieldDetail)
      outDataEntry.name = fieldDetail
    logging.debug("%s: %s" % (fieldAttr.getName(), fieldDetail))

  def _addDataFieldToSelfRef(self, ien, dataField):
      self._selfRef.setdefault(self._curFileNo, {}).setdefault(ien, set()).add(dataField)

  def _parseSubFileField(self, dataRoot, fieldAttr, outDataEntry):
    logging.debug ("%s" % (fieldAttr.getName() + ':'))
    subFile = fieldAttr.getPointedToSubFile()
    if fieldAttr.hasSubType(FileManField.FIELD_TYPE_WORD_PROCESSING):
      outLst = self._parsingWordProcessingNode(dataRoot)
      outDataEntry.addField(FileManDataField(fieldAttr.getFieldNo(),
                                       FileManField.FIELD_TYPE_WORD_PROCESSING,
                                       fieldAttr.getName(),
                                       outLst))
    elif subFile:
      subFileData = FileManFileData(subFile.getFileNo(),
                                    subFile.getFileManName())
      self._parseDataBySchema(dataRoot, subFile, subFileData)
      outDataEntry.addField(FileManDataField(fieldAttr.getFieldNo(),
                                        FileManField.FIELD_TYPE_SUBFILE_POINTER,
                                        fieldAttr.getName(),
                                        subFileData))
    else:
      logging.info ("Sorry, do not know how to intepret the schema %s" %
                    fieldAttr)

  def _parsingWordProcessingNode(self, dataRoot):
    outLst = []
    for key in getKeys(dataRoot, int):
      if '0' in dataRoot[key]:
        outLst.append("%s" % dataRoot[key]['0'].value)
    return outLst


def testGlobalParser(crosRef=None):
  parser = createArgParser()
  result = parser.parse_args()
  print result
  from InitCrossReferenceGenerator import parseCrossRefGeneratorWithArgs
  from FileManDataToHtml import outputFileManDataAsHtml
  crossRef = parseCrossRefGeneratorWithArgs(result)
  schemaParser = FileManSchemaParser()
  allSchemaDict = schemaParser.parseSchemaDDFileV2(result.ddFile)
  glbDataParser = FileManGlobalDataParser(crossRef)
  #glbDataParser.parseAllZWRGlobaFilesBySchema(result.MRepositDir, allSchemaDict)

  glbDataParser.parseZWRGlobalFileBySchemaV2(result.gdFile,
                                           allSchemaDict,
                                           result.fileNo,
                                           result.subscript)
  if result.outdir:
    outputFileManDataAsHtml(glbDataParser.outFileManData, result.outdir, crossRef)

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

def createArgParser():
  import argparse
  from InitCrossReferenceGenerator import createInitialCrossRefGenArgParser
  initParser = createInitialCrossRefGenArgParser()
  parser = argparse.ArgumentParser(description='FileMan Global Data Parser',
                                   parents=[initParser])
  parser.add_argument('ddFile', help='path to ZWR file contains DD global')
  parser.add_argument('gdFile', help='path to ZWR file contains Globals data')
  parser.add_argument('fileNo', help='FileMan File Number')
  parser.add_argument('subscript', help='The first subscript of the global root')
  parser.add_argument('outdir', help='top directory to generate output in html')
  return parser


def main():
  from LogManager import initConsoleLogging
  initConsoleLogging(formatStr='%(message)s')
  #test_horologToDateTime()
  #test_FileManDataEntry()
  testGlobalParser()

if __name__ == '__main__':
  main()
