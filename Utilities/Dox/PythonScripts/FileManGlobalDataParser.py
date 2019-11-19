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
import functools
import gc
import glob
import json
import os
import re
import sys
from builtins import object
from builtins import str
from datetime import datetime
from future.utils import iteritems
from future.utils import itervalues
from future.utils import listvalues

# Necessary to find FileManDateTimeUtil for import
FILE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(FILE_DIR, "../../../Scripts"))
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)
from FileManDateTimeUtil import fmDtToPyDt

from CrossReference import FileManField
from FileManSchemaParser import FileManSchemaParser
from LogManager import initLogging, logger
from UtilityFunctions import getDOXURL, getViViaNURL
from UtilityFunctions import convertToType, getKeys, sortDataEntryFloatFirst
from ZWRGlobalParser import createGlobalNodeByZWRFile
from ZWRGlobalParser import readGlobalNodeFromZWRFileV2


# These are used to capture install entries that don't use the
# package prefix as their install name or have odd capitalization
# after being passed through the title function
INSTALL_DEPENDENCY_DICT = {"MultiBuild": {} }
INSTALL_PACKAGE_FIX = {"VA FILEMAN 22.0": "VA FileMan",
                       "DIETETICS 5.5" : "Dietetics"
                      }
INSTALL_RENAME_DICT = {"Kernel Public Domain" : "Kernel",
                           "Kernel - Virgin Install" : "Kernel",
                           #"DIETETICS " : "Dietetics",
                           "Rpc Broker": "RPC Broker",
                           "Pce Patient Care Encounter": "PCE Patient Care Encounter",
                           "Sagg" : "SAGG Project",
                           "Sagg Project" : "SAGG Project",
                           "Emergency Department" : "Emergency Department Integration Software",
                           "Gen. Med. Rec. - Vitals" : "General Medical Record - Vitals",
                           "Gen. Med. Rec. - I/O" : "General Medical Record - IO",
                           "Mailman" : "MailMan",
                           "Bar Code Med Admin" : "Barcode Medication Administration",
                           "Ifcap" : "IFCAP",
                           "Master Patient Index Vista" : "Master Patient Index VistA",
                           "Consult/Request Tracking" : "Consult Request Tracking",
                           "Outpatient Pharmacy Version" : "Outpatient Pharmacy",
                           "Clinical Info Resource Network" : "Clinical Information Resource Network",
                           "Dss Extracts" : "DSS Extracts",
                           "Automated Info Collection Sys" : "Automated Information Collection System",
                           "Text Integration Utilities" : "Text Integration Utility",
                           "Drug Accountability V." : "Drug Accountability",
                           "Women'S Health" : "Womens Health",
                           "Health Data & Informatics" : "Health Data and Informatics",
                           "Capacity Management - Rum" : "Capacity Management - RUM",
                           "Authorization/Subscription" : "Authorization Subscription",
                           "Pharmacy Data Management Host" : "Pharmacy Data Management",
                           "Equipment/Turn-In Request" : "Equipment Turn-In Request",
                           "Pbm" : "Pharmacy Benefits Management",
                           "Cmoph" : "CMOP",
                           "Cmop" : "CMOP"
                          }


REGEX_RTN_CODE = re.compile("( ?[DQI] |[:',])(\$\$)?(?P<tag>"
                         "([A-Z0-9][A-Z0-9]*)?)\^(?P<rtn>[A-Z%][A-Z0-9]+)")
ZWR_FILE_REGEX = re.compile("(?P<fileNo>^[0-9.]+)(-[1-9])?\+(?P<des>.*)\.zwr$")
PACKAGE_CHANGE_REGEX = re.compile("\*+")
PACKAGE_NAME_VAL_REGEX = re.compile("(?P<packageName>[A-Z./ \&\-\']+) (?P<packageVal>[.0-9]+)")

def getMumpsRoutine(mumpsCode):
  """
    For a given mumpsCode, parse the routine and tag information
    via regular expression.
    return an iterator with (routine, tag, rtnpos)
  """
  for result in REGEX_RTN_CODE.finditer(mumpsCode):
    if result:
      routine = result.group('rtn')
      if routine:
        tag = result.group('tag')
        start, end = result.span('rtn')
        yield (routine, tag, start)

class FileManFileData(json.JSONEncoder):
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


class FileManDataEntry(json.JSONEncoder):
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


class FileManDataField(json.JSONEncoder):
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

def sortSchemaByLocation(fileSchema):
  locFieldDict = {}
  for fldAttr in itervalues(fileSchema.getAllFileManFields()):
    loc = fldAttr.getLocation()
    if not loc:
      continue
    locInfo = loc.split(';')
    if len(locInfo) != 2:
      logger.error("Unknown location info %s for %r" % (loc, fldAttr))
      continue
    index, pos = locInfo
    if index not in locFieldDict:
      locFieldDict[index] = {}
    locFieldDict[index][pos] = fldAttr
  return locFieldDict

# hard code initial map due to the way the ^DIC is extracted
initGlobalLocationMap = {
    x: "^DIC(" + x for x in (
          '.2', '3.1', '3.4', '4', '4.001', '4.005',
          '4.009', '4.05', '4.1', '4.11', '4.2', '4.2996',
          '5', '7', '7.1', '8', '8.1', '8.2', '9.2', '9.4',
          '9.8', '10', '10.2', '10.3', '11', '13', '19', '19.1',
          '19.2', '19.8', '21', '22', '23', '25', '30', '31', '34',
          '35', '36', '37', '39.1', '39.2', '39.3', '40.7', '40.9',
          '42', '42.4', '42.55', '43.4', '45.1', '45.3', '45.6',
          '45.61', '45.68', '45.7', '45.81', '45.82', '45.88', '45.89',
          '47', '49', '51.5', '68.4', '81.1', '81.2', '81.3', '150.9',
          '194.4', '194.5', '195.1', '195.2', '195.3', '195.4', '195.6',
          '213.9', '220.2', '220.3', '220.4', '620', '625', '627', '627.5',
          '627.9', '6910', '6910.1', '6921', '6922',
          )
  }
# handle file# 0 or the schema file
initGlobalLocationMap['0'] = '^DD('

class FileManGlobalDataParser(object):
  def __init__(self, MRepositDir, crossRef):
    self.patchDir = None
    self.MRepositDir = MRepositDir
    self._dataRoot = None
    self._crossRef = crossRef
    self._curFileNo =  None
    self._glbData = {} # fileNo => FileManData
    self._pointerRef = {}
    self._fileKeyIndex = {} # File: => ien => Value
    self._glbLocMap = initGlobalLocationMap # File: => Global Location
    self._rtnRefDict = {} # dict of rtn => fileNo => Details
    self.allFiles = self._getAllFileManZWRFiles()  # Dict of fileNum => Global file
    self.schemaParser = FileManSchemaParser()
    self._allSchemaDict = self.schemaParser.parseSchemaDDFileV2(self.allFiles['0']['path'][0])

  @property
  def outFileManData(self):
    return self._glbData

  @property
  def globalLocationMap(self):
    return self._glbLocMap

  def getFileNoByGlobalLocation(self, glbLoc):
    """
      get the file no by global location
      return fileNo if found, otherwise return None
    """
    outLoc = normalizeGlobalLocation(glbLoc)
    for key, value in iteritems(self._glbLocMap):
      if value == outLoc:
        return key
    return None

  def getFileManFileNameByFileNo(self, fileNo):
    fileManFile = self._crossRef.getGlobalByFileNo(fileNo)
    if fileManFile:
      return fileManFile.getFileManName()
    return ""

  def _createDataRootByZWRFile(self, inputFileName):
    self._dataRoot = createGlobalNodeByZWRFile(inputFileName)

  def _getAllFileManZWRFiles(self):
    dirName = os.path.join(self.MRepositDir, 'Packages')
    pattern = "*/Globals/*.zwr"
    searchFiles = glob.glob(os.path.join(dirName, pattern))
    outFiles = {}
    for file in searchFiles:
      fileName = os.path.basename(file)
      if fileName == 'DD.zwr':
        outFiles['0'] = {'name': 'Schema File',
                         'path': [os.path.normpath(os.path.abspath(file))]}
        continue
      result = ZWR_FILE_REGEX.search(fileName)
      if result:
        fileNo = result.group('fileNo')
        if fileNo.startswith('0'):
          fileNo = fileNo[1:]
        globalDes = result.group('des')
        if fileNo not in outFiles:
          outFiles[fileNo] = {'name': globalDes,
                              'path': [os.path.normpath(os.path.abspath(file))]}
        else:
          outFiles[fileNo]['path'].append( os.path.normpath(os.path.abspath(file)))
    return outFiles

  def generateFileIndex(self, inputFileName, fileNumber):
    schemaFile = self._allSchemaDict[fileNumber]
    if not schemaFile.hasField('.01'):
      logger.error("File %s does not have a .01 field, ignore" % fileNumber)
      return
    keyField = schemaFile.getFileManFieldByFieldNo('.01')
    keyLoc = keyField.getLocation()
    if not keyLoc:
      logger.error("File %s .01 field does not have a location, ignore" % fileNumber)
      return
    self._curFileNo = fileNumber
    if fileNumber in self._glbLocMap:
      glbLoc = self._glbLocMap[fileNumber]
      for dataRoot in readGlobalNodeFromZWRFileV2(inputFileName, glbLoc):
        if not dataRoot:
          continue
        self._dataRoot = dataRoot
        fileDataRoot = dataRoot
        (ien, detail) = self._getKeyNameBySchema(fileDataRoot, keyLoc, keyField)
        if detail:
          self._addFileKeyIndex(fileNumber, ien, detail)

  def generateFileFieldMap(self, inputFileList, fileNumber, fieldNo):
    """
    Generate a map Field Value => IEN
    """
    schemaFile = self._allSchemaDict[fileNumber]
    if not schemaFile.hasField(fieldNo):
      logger.error("File does not have a [%s] field, ignore", fieldNo)
      return dict()
    keyField = schemaFile.getFileManFieldByFieldNo(fieldNo)
    keyLoc = keyField.getLocation()
    if not keyLoc:
      logger.error("[%s] field does not have a location", fieldNo)
      return dict()
    glbLoc = self._glbLocMap[fileNumber]
    fieldMap = {}
    for inputFileName in inputFileList:
      for dataRoot in readGlobalNodeFromZWRFileV2(inputFileName, glbLoc):
        if not dataRoot:
          continue
        fileDataRoot = dataRoot
        (ien, detail) = self._getKeyNameBySchema(fileDataRoot, keyLoc, keyField)
        if detail:
          fieldMap[detail] = ien
    return fieldMap

  def _getKeyNameBySchema(self, dataRoot, keyLoc, keyField):
    floatKey = getKeys(dataRoot, float)
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

  def parseZWRGlobalFileBySchemaV2(self, inputFileName, fileNumber, glbLoc=None):
    schemaFile = self._allSchemaDict[fileNumber]
    self._glbData[fileNumber] = FileManFileData(fileNumber,
                                                self.getFileManFileNameByFileNo(fileNumber))
    self._curFileNo = fileNumber
    if not glbLoc:
      glbLoc = self._glbLocMap.get(fileNumber)
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

  def _updateCrossReference(self):
    if '8994' in self._glbData:
      self._updateRPCRefence()
    if '101' in self._glbData:
      self._updateHL7Reference()
    if '779.2' in self._glbData:
      self._updateHLOReference()
    if '9.6' in self._glbData:
      self._updateBuildReference()
    if '9.7' in self._glbData:
      self._updateInstallReference()

  def outRtnReferenceDict(self):
    if self._rtnRefDict:
      # generate the dependency in json file
      with open(os.path.join(self.outdir, "Routine-Ref.json"), 'w') as output:
        logger.info("Generate File: %s" % output.name)
        json.dump(self._rtnRefDict, output)

  def _updateBuildReference(self):
    build = self._glbData['9.6']
    for ien in sorted(list(build.dataEntries), key=lambda x: float(x)):
      if not build.dataEntries[ien].name in INSTALL_DEPENDENCY_DICT:
        INSTALL_DEPENDENCY_DICT[build.dataEntries[ien].name] = {"ien":ien, "multi": -1}
      if '10' in build.dataEntries[ien].fields:
        INSTALL_DEPENDENCY_DICT[build.dataEntries[ien].name]['multi']= 1
        multibuilds = build.dataEntries[ien].fields['10'].value.dataEntries
        INSTALL_DEPENDENCY_DICT[build.dataEntries[ien].name]['builds']= []
        for data in multibuilds:
          INSTALL_DEPENDENCY_DICT[build.dataEntries[ien].name]['builds'].append(multibuilds[data].fields['.01'].value)
      if '11' in build.dataEntries[ien].fields:
        INSTALL_DEPENDENCY_DICT[build.dataEntries[ien].name]['builds']= []
        reqBuilds = build.dataEntries[ien].fields['11'].value.dataEntries
        for data in reqBuilds:
          INSTALL_DEPENDENCY_DICT[build.dataEntries[ien].name]['builds'].append(reqBuilds[data].fields['.01'].value)

  def _updateHLOReference(self):
    hlo = self._glbData['779.2']
    for ien in sorted(list(hlo.dataEntries.keys()), key=lambda x: float(x)):
      hloEntry = hlo.dataEntries[ien]
      entryName = hloEntry.name
      namespace, package = \
        self._crossRef.__categorizeVariableNameByNamespace__(entryName)
      if package:
        package.hlo.append(hloEntry)


  def _updateHL7Reference(self):
    protocol = self._glbData['101']
    for ien in sorted(list(protocol.dataEntries), key=lambda x: float(x)):
      protocolEntry = protocol.dataEntries[ien]
      if '4' in protocolEntry.fields:
        type = protocolEntry.fields['4'].value
        if (type != 'event driver' and type != 'subscriber'):
          entryName = protocolEntry.name
          namespace, package = \
            self._crossRef.__categorizeVariableNameByNamespace__(entryName)
          if package:
            package.protocol.append(protocolEntry)
        # only care about the event drive and subscriber type
        elif (type == 'event driver' or type == 'subscriber'):
          entryName = protocolEntry.name
          namespace, package = \
            self._crossRef.__categorizeVariableNameByNamespace__(entryName)
          if package:
            package.hl7.append(protocolEntry)
          elif '12' in protocolEntry.fields: # check the packge it belongs
            pass
          else:
            logger.warn("Cannot find a package for HL7: %s" % entryName)
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
              self._rtnRefDict.setdefault(rtn, {}).setdefault('101', []).append(hl7Info)

  def _updateRPCRefence(self):
    rpcData = self._glbData['8994']
    for ien in sorted(list(rpcData.dataEntries.keys()), key=lambda x: float(x)):
      rpcEntry = rpcData.dataEntries[ien]
      rpcRoutine = None
      if rpcEntry.name:
        namespace, package = \
        self._crossRef.__categorizeVariableNameByNamespace__(rpcEntry.name)
        if package:
          package.rpcs.append(rpcEntry)
        if '.03' in rpcEntry.fields:
          rpcRoutine = rpcEntry.fields['.03'].value
        else:
          if rpcRoutine:
            # try to categorize by routine called
            namespace, package = \
            self._crossRef.__categorizeVariableNameByNamespace__(rpcRoutine)
            if package:
              package.rpcs.append(rpcEntry)
          else:
            logger.error("Cannot find package for RPC: %s" %
                          (rpcEntry.name))
        # Generate the routine referenced based on RPC Call
        if rpcRoutine:
          rpcInfo = {"name": rpcEntry.name,
                     "ien" : ien
                    }
          if '.02' in rpcEntry.fields:
            rpcTag = rpcEntry.fields['.02'].value
            rpcInfo['tag'] = rpcTag
          self._rtnRefDict.setdefault(rpcRoutine, {}).setdefault('8994', []).append(rpcInfo)

  def _findInstallPackage(self,packageList, installEntryName,checkNamespace=True):
    package=None
    # checkNamespace is used by the "version change" check to match the
    # package name in the install name but not the namespace in the install
    # name, which should help eliminate multibuilds from being found as
    # package changes
    if checkNamespace:
      namespace, package = self._crossRef.__categorizeVariableNameByNamespace__(installEntryName)
    # A check to remove the mis-categorized installs which happen to fall in a namespace
    if installEntryName in INSTALL_PACKAGE_FIX:
      package = INSTALL_PACKAGE_FIX[installEntryName]
    # If it cannot match a package by namespace, capture the name via Regular Expression
    if package is None:
      pkgMatch = re.match("[A-Z./ \&\-\']+", installEntryName)
      if pkgMatch:
        # if a match is found, switch to title case and remove extra spaces
        targetName = pkgMatch.group(0).title().strip()
        # First check it against the list of package names
        if targetName in packageList:
          package = targetName
        # Then check it against the dictionary above for some odd spellings or capitalization
        elif targetName in INSTALL_RENAME_DICT:
          package = INSTALL_RENAME_DICT[targetName]
        # If all else fails, assign it to the "Unknown"
        else:
          package = "Unknown"
    package = str(package).strip()
    return package

  def _updateInstallReference(self):
    if not os.path.exists(self.outdir+"/9_7"):
      os.mkdir(self.outdir+"/9_7")
    installData = self._glbData['9.7']
    output = os.path.join(self.outdir, "install_information.json")
    installJSONData = {}
    packageList = self._crossRef.getAllPackages()
    with open(output, 'w') as installDataOut:
      for ien in sorted(list(installData.dataEntries.keys()), key=lambda x: float(x)):
        installItem = {}
        installEntry = installData.dataEntries[ien]
        package = self._findInstallPackage(packageList, installEntry.name)
        # if this is the first time the package is found, add an entry in the install JSON data.
        if package not in installJSONData:
          installJSONData[package]={}
        if installEntry.name:
          installItem['name'] = installEntry.name
          installItem['ien'] = installEntry.ien
          installItem['label'] = installEntry.name
          installItem['value'] = installEntry.name
          installItem['parent']= package
          if installEntry.name in INSTALL_DEPENDENCY_DICT:
            installItem['BUILD_ien'] = INSTALL_DEPENDENCY_DICT[installEntry.name]["ien"]
            installchildren = []
            if 'multi' in INSTALL_DEPENDENCY_DICT[installEntry.name]:
              installItem['multi'] = INSTALL_DEPENDENCY_DICT[installEntry.name]['multi']
            if 'builds' in INSTALL_DEPENDENCY_DICT[installEntry.name]:
                for child in INSTALL_DEPENDENCY_DICT[installEntry.name]['builds']:
                  childPackage = self._findInstallPackage(packageList, child)
                  childEntry = {"name": child, "package": childPackage}
                  if child in INSTALL_DEPENDENCY_DICT:
                      if 'multi' in INSTALL_DEPENDENCY_DICT[child]:
                        childEntry['multi'] = INSTALL_DEPENDENCY_DICT[child]['multi']
                  installchildren.append(childEntry)
                installItem['children'] = installchildren
          if '11' in installEntry.fields:
            installItem['installDate'] = installEntry.fields['11'].value.strftime("%Y-%m-%d")
          if '1' in installEntry.fields:
            installItem['packageLink'] = installEntry.fields['1'].value
          if '40' in installEntry.fields:
            installItem['numRoutines'] = len(installEntry.fields['40'].value.dataEntries)
          if '14' in installEntry.fields:
            installItem['numFiles'] = len(installEntry.fields['14'].value.dataEntries)
          # Checks for the absence of asterisks which usually denotes a package change, also make it more specific to
          # eliminate the multibuilds that are being marked as package changes
          testMatch = PACKAGE_CHANGE_REGEX.search(installEntry.name)
          if testMatch is None:
            # Assume a package switch name will be just a package name and a version
            capture = PACKAGE_NAME_VAL_REGEX.match(installEntry.name)
            if capture:
              checkPackage = self._findInstallPackage(packageList, capture.groups()[0], False)
              if ((checkPackage != "Unknown") or (len(capture.groups()[0]) <= 4)):
                installItem['packageSwitch'] = True
          installJSONData[package][installEntry.name] = installItem
      logger.info("About to dump data into %s" % output)
      json.dump(installJSONData, installDataOut)

  def _resolveSelfPointer(self):
    """ Replace self-reference with meaningful data """
    for fileNo in self._pointerRef:
      if fileNo in self._glbData:
        fileData = self._glbData[fileNo]
        for ien, fields in iteritems(self._pointerRef[fileNo]):
          if ien in fileData.dataEntries:
            name = fileData.dataEntries[ien].name
            if not name:
              name = str(ien)
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
    # for each data entry, parse data by location
    floatKey = getKeys(dataRoot, float)
    for ien in floatKey:
      if float(ien) <=0:
        continue
      dataEntry = dataRoot[ien]
      outDataEntry = FileManDataEntry(fileSchema.getFileNo(), ien)
      dataKeys = [x for x in dataEntry]
      sortedKey = sorted(dataKeys, key=functools.cmp_to_key(sortDataEntryFloatFirst))
      for locKey in sortedKey:
        if locKey == '0' and fileSchema.getFileNo() == '1':
          self._parseFileDetail(dataEntry[locKey], ien)
        if locKey in locFieldDict:
          fieldDict = locFieldDict[locKey] # a dict of {pos: field}
          curDataRoot = dataEntry[locKey]
          if len(fieldDict) == 1:
            fieldAttr = listvalues(fieldDict)[0]
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
    if not values:
      return # this is very import to check
    for idx, value in enumerate(values, 1):
      if value and str(idx) in fieldDict:
        fieldAttr = fieldDict[str(idx)]
        self._parseIndividualFieldDetail(value, fieldAttr, outDataEntry)

  def _parseIndividualFieldDetail(self, value, fieldAttr, outDataEntry):
    value = value.strip(' ')
    if not value:
      return ""
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
          logger.error("Unknown variable pointer format: %s" % value)
          fieldDetail = "Unknow Variable Pointer"
        else:
          fileNo = self.getFileNoByGlobalLocation(vpInfo[1])
          ien = vpInfo[0]
          if not fileNo:
            logger.warn("Could not find File for %s" % value)
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
    elif fieldAttr.getType() == FileManField.FIELD_TYPE_DATE_TIME: # datetime
      if value.find(',') >=0:
        fieldDetail = horologToDateTime(value)
      else:
        outDt = fmDtToPyDt(value)
        if outDt:
          fieldDetail = outDt
        else:
          logger.warn("Could not parse Date/Time: %s" % value)
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
      logger.warning("Do not know how to intepret the schema %s" % fieldAttr)

  def _parsingWordProcessingNode(self, dataRoot):
    outLst = []
    for key in getKeys(dataRoot, int):
      if '0' in dataRoot[key]:
        outLst.append("%s" % dataRoot[key]['0'].value)
    return outLst

def run(args):
  from InitCrossReferenceGenerator import parseCrossRefGeneratorWithArgs
  from FileManDataToHtml import FileManDataToHtml

  logger.progress("Start FileMan Global Data Parser")

  # Ensure that output directory exists
  if not os.path.exists(os.path.join(args.outDir, "dox")):
    os.makedirs(os.path.join(args.outDir, "dox"))

  crossRef = parseCrossRefGeneratorWithArgs(args)

  # Populate glbDataParse
  logger.progress("Populate global data parser")
  glbDataParser = FileManGlobalDataParser(args.MRepositDir, crossRef)
  glbDataParser.parseZWRGlobalFileBySchemaV2(glbDataParser.allFiles['1']['path'][0], '1', '^DIC(')
  del glbDataParser.outFileManData['1']
  glbDataParser.outdir = args.outDir
  glbDataParser.patchDir = args.patchRepositDir

  logger.progress("Fileman data to html")
  _doxURL = getDOXURL(args.local)
  _vivianURL = getViViaNURL(args.local)
  htmlGen = FileManDataToHtml(crossRef, glbDataParser.schemaParser,
                              args.outDir, _doxURL, _vivianURL)

  if not args.all:
    logger.progress("Checking files...")
    assert set(args.fileNos).issubset(glbDataParser.allFiles)
    for fileNo in args.fileNos:
        assert fileNo in glbDataParser.globalLocationMap
    logger.progress("Process files...")
    processFiles(glbDataParser, htmlGen, args.fileNos)
  else:
    # Start with 'Strongly connected components'
    fileSet = glbDataParser.schemaParser.sccSet

    # Add files we're specifically interested int
    fileSet.add('101')    #Protocol
    fileSet.add('8994')   #Remote Procedure
    fileSet.add('19')     #Option
    fileSet.add('779.2')  #HLO Application
    fileSet.add('9.6')    #Build (needs to be before install)
    fileSet.add('9.7')    #Install
    fileSet.add('.5')     #Function
    fileSet.add('409.61') #List Template
    fileSet.add('19.1')   #Security Key
    fileSet.add('9.2')    #Help Frame
    fileSet.add('.403')   #Form
    fileSet.add('.401')   #Sort Template
    fileSet.add('771')    #HL7 APPLICATION PARAMETER

    # Make sure to only use files that are in glbDataParser.allFiles.keys()
    fileSet &= set(glbDataParser.allFiles.keys())
    n = 0
    numFiles = len(fileSet)
    fileList = list(fileSet)
    fileList.sort()
    for file in fileList:
      n += 1
      logger.progress("Processing %s (file %d/%d)" % (file, n, numFiles))
      for zwrFile in glbDataParser.allFiles[file]['path']:
        glbDataParser.generateFileIndex(zwrFile, file)
    logger.progress("Process files...")
    processFiles(glbDataParser, htmlGen, fileList)

  glbDataParser.outRtnReferenceDict()

def processFiles(glbDataParser, htmlGen, files):
  for file in files:
    for zwrFile in glbDataParser.allFiles[file]['path']:
      logger.progress("Parsing file: %s at %s" % (file, zwrFile))
      glbDataParser.parseZWRGlobalFileBySchemaV2(zwrFile, file)
    htmlGen.outputFileManDataAsHtml(file, glbDataParser)
    glbDataParser.outFileManData.pop(file)
    gc.collect()

def horologToDateTime(input):
  """
    convert Mumps Horolog time to python datatime
  """
  from datetime import timedelta
  originDt = datetime(1840, 12, 31, 0, 0, 0)
  if input.find(',') < 0: # invalid format
    return None
  days, seconds = input.split(',')
  return originDt + timedelta(int(days), int(seconds))

def normalizeGlobalLocation(input):
  if not input:
    return input
  result = input
  if input[0] != '^':
    result = '^' + result
  if input[-1] == ',':
    result = result[0:-1]
  return result

def createArgParser():
  import argparse
  from InitCrossReferenceGenerator import createInitialCrossRefGenArgParser
  initParser = createInitialCrossRefGenArgParser()
  parser = argparse.ArgumentParser(description='FileMan Global Data Parser',
                                   parents=[initParser])
  parser.add_argument('-o', '--outDir', required=True,
                      help='top directory to generate output in html')
  parser.add_argument('-lf', '--logFileDir', required=True,
                      help='Logfile directory')
  parser.add_argument('-local', help='Use links to local DOX pages')
  # Require 'fileNos' or 'all'
  group = parser.add_mutually_exclusive_group(required=True)
  group.add_argument('-all', action='store_true',
                      help='generate all dependency files ')
  group.add_argument('-f', '--fileNos', help='FileMan File Numbers', nargs='+')
  return parser

def main():
  parser = createArgParser()
  result = parser.parse_args()
  initLogging(result.logFileDir, "FileManGlobalDataParser.log")
  logger.debug(result)
  run(result)

if __name__ == '__main__':
  main()
