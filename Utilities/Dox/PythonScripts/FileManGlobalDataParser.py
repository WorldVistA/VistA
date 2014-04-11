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
from ZWRGlobalParser import readGlobalNodeFromZWRFileV2
from FileManSchemaParser import FileManSchemaParser

FILE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(FILE_DIR, "../../../Scripts"))
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)

from FileManDateTimeUtil import fmDtToPyDt
import glob

regexRtnCode = re.compile("( ?[DQI] |[:',])(\$\$)?(?P<tag>"
                         "([A-Z0-9][A-Z0-9]*)?)\^(?P<rtn>[A-Z%][A-Z0-9]+)")
def getMumpsRoutine(mumpsCode):
  """
    For a given mumpsCode, parse the routine and tag information
    via regular expression.
    return an iterator with (routine, tag, rtnpos)
  """
  pos = 0
  endpos = 0
  for result in regexRtnCode.finditer(mumpsCode):
    if result:
      routine = result.group('rtn')
      if routine:
        tag = result.group('tag')
        start, end = result.span('rtn')
        endpos = result.end()
        pos = endpos
        yield (routine, tag, start)
  raise StopIteration

def test_getMumpsRoutine():
  for input in (
    ('D ^TEST1', [('TEST1','',3)]),
    ('D ^%ZOSV', [('%ZOSV','',3)]),
    ('D TAG^TEST2',[('TEST2','TAG',6)]),
    ('Q $$TST^%RRST1', [('%RRST1','TST',8)]),
    ('D ACKMSG^DGHTHLAA',[('DGHTHLAA','ACKMSG',9)]),
    ('S XQORM(0)="1A",XQORM("??")="D HSTS^ORPRS01(X)"',[('ORPRS01','HSTS',36)]),
    ('I $$TEST^ABCD D ^EST Q:$$ENG^%INDX K ^DD(0)',
     [
       ('ABCD','TEST',9),
       ('EST','',17),
       ('%INDX','ENG',29)
     ]
    ),
    ('S DUZ=1 K ^XUTL(0)', None),
    ("""W:'$$TM^%ZTLOAD() *7,!!,"WARNING -- TASK MANAGER DOESN'T!!!!",!!,*7""",
     [('%ZTLOAD','TM',8)]
    ),
    ("""W "This is a Test",$$TM^ZTLOAD()""",[('ZTLOAD','TM',24)]),
    ("""D ^PSIVXU Q:$D(XQUIT) D EN^PSIVSTAT,NOW^%DTC S ^PS(50.8,1,.2)=% K %""",
     [
       ('PSIVXU','',3),
       ('PSIVSTAT','EN',27),
       ('%DTC','NOW',40)
     ]
    ),
    ("""D ^TEST1,EN^TEST2""",
     [
       ('TEST1','',3),
       ('TEST2','EN',12)
     ]
    ),
  ):
    for idx, (routine,tag,pos) in enumerate(getMumpsRoutine(input[0])):
      assert (routine, tag, pos) == input[1][idx], "%s: %s" % ((routine, tag, pos), input[1][idx])

class FileManFileData(object):
  """
    Class to represent FileMan File data WRT
    either a FileMan file or a subFile
  """
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
  """
  One FileMan File DataEntry
  """
  def __init__(self, fileNo, ien):
    self._ien = ien
    self._data = {}
    self._fileNo = fileNo
    self._name = None
    self._type = None
  @property
  def fields(self):
    return self._data
  @property
  def name(self):
    return self._name
  @property
  def type(self):
    return self._type
  @property
  def ien(self):
    return self._ien
  @property
  def fileNo(self):
    return self._fileNo
  @name.setter
  def name(self, name):
    self._name = name
  @type.setter
  def type(self, type):
    self._type = type
  def addField(self, fldData):
    self._data[fldData.id] = fldData
  def __repr__(self):
    return "%s: %s: %s" % (self._fileNo, self._ien, self._data)

class FileManDataField(object):
  """
    Represent an individual field in a FileMan DataEntry
  """
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
    locInfo = loc.split(';')
    if len(locInfo) != 2:
      logging.error("Unknown location info %s for %r" % (loc, fldAttr))
      continue
    index,pos = locInfo
    if index not in locFieldDict:
      locFieldDict[index] = {}
    locFieldDict[index][pos] = fldAttr
  return locFieldDict

"""
  hard code initial map due to the way the ^DIC is extracted
"""
initGlobalLocationMap = {
    x: "^DIC(" + x for x in (
          '.2', '3.1', '3.4', '4', '4.001', '4.005',
          '4.009', '4.05', '4.1', '4.11', '4.2', '4.2996',
          '5', '7', '7.1', '8', '8.1', '8.2', '9.2', '9.4',
          '9.8', '10', '10.2', '10.3', '11', '13', '19', '19.1',
          '19.2', '19.8', '21', '22', '23', '25','30', '31', '34',
          '35', '36', '37', '39.1', '39.2', '39.3', '40.7', '40.9',
          '42', '42.4', '42.55', '43.4', '45.1', '45.3', '45.6',
          '45.61', '45.68', '45.7', '45.81', '45.82', '45.88', '45.89',
          '47', '49', '51.5', '68.4', '81.1', '81.2', '81.3', '150.9',
          '194.4', '194.5', '195.1', '195.2', '195.3', '195.4', '195.6',
          '213.9', '220.2', '220.3', '220.4', '620', '625', '627', '627.5',
          '627.9', '6910', '6910.1', '6921', '6922',
          )
  }
""" handle file# 0 or the schema file """
initGlobalLocationMap['0'] = '^DD('

class FileManGlobalDataParser(object):
  def __init__(self, crossRef=None):
    self._dataRoot = None
    self._allSchemaDict = None
    self._crossRef = crossRef
    self._curFileNo =  None
    self._glbData = {} # fileNo => FileManData
    self._pointerRef = {}
    self._fileKeyIndex = {} # File: => ien => Value
    self._glbLocMap = initGlobalLocationMap # File: => Global Location
    self._fileParsed = set() # set of files that has been parsed
    self._rtnRefDict = {} # dict of rtn => fileNo => Details
  @property
  def outFileManData(self):
    return self._glbData
  @property
  def crossRef(self):
    return self._crossRef
  @property
  def globalLocationMap(self):
    return self._glbLocMap
  def getFileNoByGlobalLocation(self, glbLoc):
    """
      get the file no by global location
      return fileNo if found, otherwise return None
    """
    outLoc = normalizeGlobalLocation(glbLoc)
    for key, value in self._glbLocMap.iteritems():
      if value == outLoc:
        return key
    return None
  def getFileManFileNameByFileNo(self, fileNo):
    if self._crossRef:
      fileManFile = self._crossRef.getGlobalByFileNo(fileNo)
      if fileManFile:
        return fileManFile.getFileManName()
    return ""
  def _createDataRootByZWRFile(self, inputFileName):
    self._dataRoot = createGlobalNodeByZWRFile(inputFileName)

  def getAllFileManZWRFiles(self, dirName, pattern):
    searchFiles = glob.glob(os.path.join(dirName, pattern))
    outFiles = {}
    for file in searchFiles:
      fileName = os.path.basename(file)
      if fileName == 'DD.zwr':
        outFiles['0'] = {'name': 'Schema File',
                         'path': os.path.normpath(os.path.abspath(file))}
        continue
      result = re.search("(?P<fileNo>^[0-9.]+)(-[1-9])?\+(?P<des>.*)\.zwr$", fileName)
      if result:
        "ignore split file for now"
        if result.groups()[1]:
          logging.info("Ignore file %s" % fileName)
          continue
        fileNo = result.group('fileNo')
        if fileNo.startswith('0'): fileNo = fileNo[1:]
        globalDes = result.group('des')
        outFiles[fileNo] = {'name': globalDes,
                            'path': os.path.normpath(os.path.abspath(file))}
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
      ddFile = allFiles[fileNo]['path']
      glbDes = allFiles[fileNo]['name']
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

  def generateFileIndex(self, inputFileName, allSchemaDict,
                        fileNumber):
    self._allSchemaDict = allSchemaDict
    schemaFile = allSchemaDict[fileNumber]
    if not schemaFile.hasField('.01'):
      logging.error("File does not have a .01 field, ignore")
      return
    keyField = schemaFile.getFileManFieldByFieldNo('.01')
    keyLoc = keyField.getLocation()
    if not keyLoc:
      logging.error(".01 field does not have a location")
      return
    self._curFileNo = fileNumber
    glbLoc = self._glbLocMap[fileNumber]
    for dataRoot in readGlobalNodeFromZWRFileV2(inputFileName, glbLoc):
      if not dataRoot: continue
      self._dataRoot = dataRoot
      fileDataRoot = dataRoot
      (ien, detail) = self._getKeyNameBySchema(fileDataRoot, keyLoc, keyField)
      if detail:
        self._addFileKeyIndex(fileNumber, ien, detail)
      elif ien:
        logging.info("No name associated with ien: %s, file: %s" % (ien, fileNumber))
      else:
        logging.info("No index for data with ien: %s, file: %s" % (ien, fileNumber))

  def _getKeyNameBySchema(self, dataRoot, keyLoc, keyField):
    floatKey = getKeys(dataRoot, float)
    logging.debug('Total # of entry is %s' % len(floatKey))
    for ien in floatKey:
      if float(ien) <=0:
        continue
      dataEntry = dataRoot[ien]
      index, loc = keyLoc.split(';')
      if not index or index not in dataEntry:
        continue
      dataEntry = dataEntry[index]
      if not dataEntry.value:
        return (ien, None)
      values = dataEntry.value.split('^')
      dataValue = None
      if convertToType(loc, int):
        intLoc = int(loc)
        if intLoc > 0 and intLoc <= len(values):
          dataValue = values[intLoc-1]
      else:
        dataValue = str(dataEntry.value)
      if dataValue:
        return (ien, self._parseIndividualFieldDetail(dataValue, keyField, None))
    return (None, None)

  def parseZWRGlobalFileBySchemaV2(self, inputFileName, allSchemaDict,
                                   fileNumber, glbLoc=None):
    self._allSchemaDict = allSchemaDict
    schemaFile = allSchemaDict[fileNumber]
    self._glbData[fileNumber] = FileManFileData(fileNumber,
                                  self.getFileManFileNameByFileNo(fileNumber))
    self._curFileNo = fileNumber
    if not glbLoc:
      glbLoc = self._glbLocMap.get(fileNumber)
      logging.info("File: %s global loc: %s" % (fileNumber, glbLoc))
    elif fileNumber in self._glbLocMap:
      logging.info("global loc %s, %s" % (glbLoc, self._glbLocMap[fileNumber]))
    for dataRoot in readGlobalNodeFromZWRFileV2(inputFileName, glbLoc):
      if not dataRoot:
        continue
      self._dataRoot = dataRoot
      fileDataRoot = dataRoot
      self._parseDataBySchema(fileDataRoot, schemaFile,
                              self._glbData[fileNumber])
    self._resolveSelfPointer()
    if self._crossRef:
      self._updateCrossReference()

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
                                   self.getFileManFileNameByFileNo(fileNumber))
      self._parseDataBySchema(fileDataRoot, schemaFile,
                              self._glbData[fileNumber])
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
    if '101' in self._glbData:
      self._updateHL7Reference()

  def outRtnReferenceDict(self):
    if len(self._rtnRefDict):
      import json
      """ generate the dependency in json file """
      with open(os.path.join(self.outDir, "Routine-Ref.json"), 'w') as output:
        logging.info("Generate File: %s" % output.name)
        json.dump(self._rtnRefDict, output)

  def _updateHL7Reference(self):
    protocol = self._glbData['101']
    for ien in sorted(protocol.dataEntries.keys(), key=lambda x: float(x)):
      protocolEntry = protocol.dataEntries[ien]
      if '4' in protocolEntry.fields:
        type = protocolEntry.fields['4'].value
        if type != 'event driver' and type != 'subscriber':
          continue
        # only care about the event drive and subscriber type
        entryName = protocolEntry.name
        namespace, package = \
          self._crossRef.__categorizeVariableNameByNamespace__(entryName)
        if package:
          package.hl7.append(protocolEntry)
          logging.info("Adding HL7: %s to Package: %s" %
                       (entryName, package.getName()))
        elif '12' in protocolEntry.fields: # check the packge it belongs
          pass
        else:
          logging.warn("Can not find a package for HL7: %s" % entryName)
        for field in ('771', '772'):
          if field not in protocolEntry.fields:
            continue
          hl7Rtn = protocolEntry.fields[field].value
          if not hl7Rtn:
            continue
          for rtn, tag, pos in getMumpsRoutine(hl7Rtn):
            hl7Info = {"name": entryName,
                       "ien": ien}
            if tag:
              hl7Info['tag'] = tag
            self._rtnRefDict.setdefault(rtn,{}).setdefault('101',[]).append(hl7Info)

  def _updateRPCRefence(self):
    rpcData = self._glbData['8994']
    for ien in sorted(rpcData.dataEntries.keys(), key=lambda x: float(x)):
      rpcEntry = rpcData.dataEntries[ien]
      rpcRoutine = None
      if rpcEntry.name:
        namespace, package = \
        self._crossRef.__categorizeVariableNameByNamespace__(rpcEntry.name)
        if package:
          package.rpcs.append(rpcEntry)
          logging.info("Adding RPC: %s to Package: %s" %
                      (rpcEntry.name, package.getName()))

        if '.03' in rpcEntry.fields:
          rpcRoutine = rpcEntry.fields['.03'].value
        else:
          if rpcRoutine:
            """ try to categorize by routine called """
            namespace, package = \
            self._crossRef.__categorizeVariableNameByNamespace__(rpcRoutine)
            if package:
              package.rpcs.append(rpcEntry)
              logging.info("Adding RPC: %s to Package: %s based on routine calls" %
                          (rpcEntry.name, package.getName()))
          else:
            logging.error("Can not find package for RPC: %s" %
                          (rpcEntry.name))
        """ Generate the routine referenced based on RPC Call """
        if rpcRoutine:
          rpcInfo = {"name": rpcEntry.name,
                     "ien" : ien
                    }
          if '.02' in rpcEntry.fields:
            rpcTag = rpcEntry.fields['.02'].value
            rpcInfo['tag'] = rpcTag
          self._rtnRefDict.setdefault(rpcRoutine,{}).setdefault('8994',[]).append(rpcInfo)

  def _resolveSelfPointer(self):
    """ Replace self-reference with meaningful data """
    for fileNo in self._pointerRef:
      if fileNo in self._glbData:
        fileData = self._glbData[fileNo]
        for ien, fields in self._pointerRef[fileNo].iteritems():
          if ien in fileData.dataEntries:
            name = fileData.dataEntries[ien].name
            if not name: name = str(ien)
            for field in fields:
              field.value = "^".join((field.value, name))
    del self._pointerRef
    self._pointerRef = {}


  def _parseFileDetail(self, dataEntry, ien):
    if 'GL' in dataEntry:
      loc = dataEntry['GL'].value
      loc = normalizeGlobalLocation(loc)
      self._glbLocMap[ien] = loc

  def _parseDataBySchema(self, dataRoot, fileSchema, outGlbData):
    """ first sort the schema Root by location """
    locFieldDict = sortSchemaByLocation(fileSchema)
    """ for each data entry, parse data by location """
    floatKey = getKeys(dataRoot, float)
    for ien in floatKey:
      if float(ien) <=0:
        continue
      #if level == 0 and int(ien) != 160: continue
      dataEntry = dataRoot[ien]
      outDataEntry = FileManDataEntry(fileSchema.getFileNo(), ien)
      dataKeys = [x for x in dataEntry]
      sortedKey = sorted(dataKeys, cmp=sortDataEntryFloatFirst)
      for locKey in sortedKey:
        if locKey == '0' and fileSchema.getFileNo() == '1':
          self._parseFileDetail(dataEntry[locKey], ien)
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
      outGlbData.addFileManDataEntry(ien, outDataEntry)
      if fileSchema.getFileNo() == self._curFileNo:
        self._addFileKeyIndex(self._curFileNo, ien, outDataEntry.name)

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
    if not value.strip(' '):
      return
    value = value.strip(' ')
    fieldDetail = value
    pointerFileNo = None
    if fieldAttr.isSetType():
      setDict = fieldAttr.getSetMembers()
      if setDict and value in setDict:
        fieldDetail = setDict[value]
    elif fieldAttr.isFilePointerType() or fieldAttr.isVariablePointerType():
      fileNo = None
      ien = None
      if fieldAttr.isFilePointerType():
        filePointedTo = fieldAttr.getPointedToFile()
        if filePointedTo:
          fileNo = filePointedTo.getFileNo()
          ien = value
        else:
          fieldDetail = 'No Pointed to File'
      else: # for variable pointer type
        vpInfo = value.split(';')
        if len(vpInfo) != 2:
          logging.error("Unknown variable pointer format: %s" % value)
          fieldDetail = "Unknow Variable Pointer"
        else:
          fileNo = self.getFileNoByGlobalLocation(vpInfo[1])
          ien = vpInfo[0]
          if not fileNo:
            logging.warn("Could not find File for %s" % value)
            fieldDetail = 'Global Root: %s, IEN: %s' % (vpInfo[1], ien)
      if fileNo and ien:
        fieldDetail = '^'.join((fileNo, ien))
        idxName = self._getFileKeyIndex(fileNo, ien)
        if idxName:
          idxes = str(idxName).split('^')
          if len(idxes) == 1:
            fieldDetail = '^'.join((fieldDetail, str(idxName)))
          elif len(idxes) == 3:
            fieldDetail = '^'.join((fieldDetail, str(idxes[-1])))
        elif fileNo == self._curFileNo:
          pointerFileNo = fileNo
        else:
          logging.warn("Can not find value for %s, %s" % (ien, fileNo))
    elif fieldAttr.getType() == FileManField.FIELD_TYPE_DATE_TIME: # datetime
      if value.find(',') >=0:
        fieldDetail = horologToDateTime(value)
      else:
        outDt = fmDtToPyDt(value)
        if outDt:
          fieldDetail = outDt
        else:
          logging.warn("Could not parse Date/Time: %s" % value)
    elif fieldAttr.getName().upper().startswith("TIMESTAMP"): # timestamp field
      if value.find(',') >=0:
        fieldDetail = horologToDateTime(value)
    if outDataEntry:
      dataField = FileManDataField(fieldAttr.getFieldNo(),
                                   fieldAttr.getType(),
                                   fieldAttr.getName(),
                                   fieldDetail)
      if pointerFileNo:
        self._addDataFieldToPointerRef(pointerFileNo, value, dataField)
      outDataEntry.addField(dataField)
      if fieldAttr.getFieldNo() == '.01':
        outDataEntry.name = fieldDetail
        outDataEntry.type = fieldAttr.getType()
    return fieldDetail

  def _addDataFieldToPointerRef(self, fileNo, ien, dataField):
    self._pointerRef.setdefault(fileNo, {}).setdefault(ien, set()).add(dataField)

  def _addFileKeyIndex(self, fileNo, ien, value):
    ienDict = self._fileKeyIndex.setdefault(fileNo, {})
    if ien not in ienDict:
      ienDict[ien] = value

  def _getFileKeyIndex(self, fileNo, ien):
    if fileNo in self._fileKeyIndex:
      if ien in self._fileKeyIndex[fileNo]:
        return self._fileKeyIndex[fileNo][ien]
    return None

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
  from FileManDataToHtml import FileManDataToHtml
  crossRef = parseCrossRefGeneratorWithArgs(result)
  glbDataParser = FileManGlobalDataParser(crossRef)
  #glbDataParser.parseAllZWRGlobaFilesBySchema(result.MRepositDir, allSchemaDict)

  allFiles = glbDataParser.getAllFileManZWRFiles(os.path.join(result.MRepositDir,
                                                     'Packages'),
                                                   "*/Globals/*.zwr")
  assert '0' in allFiles and '1' in allFiles and set(result.fileNos).issubset(allFiles)
  schemaParser = FileManSchemaParser()
  allSchemaDict = schemaParser.parseSchemaDDFileV2(allFiles['0']['path'])
  isolatedFiles = schemaParser.isolatedFiles
  glbDataParser.parseZWRGlobalFileBySchemaV2(allFiles['1']['path'],
                                             allSchemaDict, '1', '^DIC(')
  for fileNo in result.fileNos:
    assert fileNo in glbDataParser.globalLocationMap
  if result.outdir:
    glbDataParser.outDir = result.outdir
  htmlGen = FileManDataToHtml(crossRef, result.outdir)
  if not result.all or set(result.fileNos).issubset(isolatedFiles):
    for fileNo in result.fileNos:
      gdFile = allFiles[fileNo]['path']
      logging.info("Parsing file: %s at %s" % (fileNo, gdFile))
      glbDataParser.parseZWRGlobalFileBySchemaV2(gdFile,
                                                 allSchemaDict,
                                                 fileNo)
      if result.outdir:
        htmlGen.outputFileManDataAsHtml(glbDataParser.outFileManData)
      else:
        fileManDataMap = glbDataParser.outFileManData
        for file in getKeys(fileManDataMap.iterkeys(), float):
          printFileManFileData(fileManDataMap[file])
      del glbDataParser.outFileManData[fileNo]
    glbDataParser.outRtnReferenceDict()
    return
  """ Also generate all required files as well """
  sccSet = schemaParser.sccSet
  fileSet = set(result.fileNos)
  for idx, value in enumerate(sccSet):
    fileSet.difference_update(value)
    if not fileSet:
      break
  for i in xrange(0,idx+1):
    fileSet = sccSet[i]
    fileSet &= set(allFiles.keys())
    fileSet -= isolatedFiles
    fileSet.discard('757')
    if len(fileSet) > 1:
      for file in fileSet:
        zwrFile = allFiles[file]['path']
        globalSub = allFiles[file]['name']
        logging.info("Generate file key index for: %s at %s" % (file, zwrFile))
        glbDataParser.generateFileIndex(zwrFile, allSchemaDict, file)
    for file in fileSet:
      zwrFile = allFiles[file]['path']
      globalSub = allFiles[file]['name']
      logging.info("Parsing file: %s at %s" % (file, zwrFile))
      glbDataParser.parseZWRGlobalFileBySchemaV2(zwrFile,
                                                 allSchemaDict,
                                                 file)
      if result.outdir:
        htmlGen.outputFileManDataAsHtml(glbDataParser.outFileManData)
      del glbDataParser.outFileManData[file]


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
  input = (
      ('57623,29373', datetime(1998,10,7,8,9,33)),
  )
  for one, two in input:
    assert horologToDateTime(one) == two, "%s, %s" % (one, two)

def normalizeGlobalLocation(input):
  if not input:
    return input
  result = input
  if input[0] != '^':
    result = '^' + result
  if input[-1] == ',':
    result = result[0:-1]
  return result

def test_normalizeGlobalLocation():
  input = (
      ('DIPT(', '^DIPT('),
      ('^DIPT(', '^DIPT('),
      ('DIPT("IX",', '^DIPT("IX"'),
  )
  for one, two in input:
    assert normalizeGlobalLocation(one) == two, "%s, %s" % (one, two)

def createArgParser():
  import argparse
  from InitCrossReferenceGenerator import createInitialCrossRefGenArgParser
  initParser = createInitialCrossRefGenArgParser()
  parser = argparse.ArgumentParser(description='FileMan Global Data Parser',
                                   parents=[initParser])
  #parser.add_argument('ddFile', help='path to ZWR file contains DD global')
  #parser.add_argument('gdFile', help='path to ZWR file contains Globals data')
  parser.add_argument('fileNos', help='FileMan File Numbers', nargs='+')
  #parser.add_argument('glbRoot', help='Global root location for FileMan file')
  parser.add_argument('-outdir', help='top directory to generate output in html')
  parser.add_argument('-all', action='store_true',
                      help='generate all dependency files as well')
  return parser

def unit_test():
  test_normalizeGlobalLocation()
  test_horologToDateTime()
  test_getMumpsRoutine()

def main():
  from LogManager import initConsoleLogging
  initConsoleLogging(formatStr='%(asctime)s %(message)s')
  unit_test()
  #test_FileManDataEntry()
  testGlobalParser()

if __name__ == '__main__':
  main()
