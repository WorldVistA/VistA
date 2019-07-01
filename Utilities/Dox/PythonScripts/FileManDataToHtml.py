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
#------------------------------------------------------------------------------

import os
import sys
import re
from datetime import datetime
import glob
import cgi
import urllib
import re
import json

from ZWRGlobalParser import getKeys
from json import JSONEncoder
from CrossReference import FileManField
from ZWRGlobalParser import readGlobalNodeFromZWRFileV2
from UtilityFunctions import getDataEntryHtmlFileName, getRoutineHRefLink
from UtilityFunctions import getPackageHtmlFileName, normalizePackageName
from FileManGlobalDataParser import FileManDataEntry, FileManDataField
from FileManGlobalDataParser import FileManFileData
from DataTableHtml import data_table_list_init_setup
from DataTableHtml import data_table_large_list_init_setup
from DataTableHtml import outputDataTableHeader
from DataTableHtml import outputCustomDataTableHeaderRows
from DataTableHtml import outputDataTableFooter
from DataTableHtml import writeTableListInfo, outputDataListTableHeader
from DataTableHtml import outputLargeDataListTableHeader
from DataTableHtml import outputDataRecordTableHeader
from DataTableHtml import outputFileEntryTableList, safeElementId
from LogManager import logger

DOX_URL = None
VIV_URL = None
FILE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(FILE_DIR, "../../../Scripts"))
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)

ZZSERVER_SUBMENU_REGEX = re.compile("19\^[9]+")


class OSEHRAEncoder(JSONEncoder):
  def default(self, o):
    if "FileManFileData" in str(type(o)):
      return "%s, %s, %s" % (o._fileNo, o._name, o._data)
    elif "FileManDataEntry" in str(type(o)):
      return "%s: %s: %s" % (o._fileNo, o._ien, o._data)
    elif "FileManDataField" in str(type(o)):
      return "%s: %s" % (o._name, o._value)
    elif "FileManField" in str(type(o)):
      return ("%s, %s, %s, %s, %s, %s, %s" % (o.getFieldNo(),
                            o.getName(),
                            o.getLocation(),
                            o.getTypeName(),
                            o.getType(),
                            o.getSubType(),
                            o.getSpecifier()))
    elif "datetime.datetime" in str(type(o)):
      return o.isoformat() #.strftime("%m/%d/%Y, %H:%M:%S")
    else:
      JSONEncoder.default(self,o)


def getFileHtmlLink(dataEntry, value, **kargs):
  htmlFile = getDataEntryHtmlFileName(dataEntry.ien, dataEntry.fileNo)
  return "<a href=\"%s/%s/%s\">%s</a>" % (VIV_URL, dataEntry.fileNo.replace(".","_"),htmlFile, value)

def _getRoutineHRefLink(dataEntry, routineName, **kargs):
  tagRoutine = routineName.split('^')
  if len(tagRoutine) == 1:
    rtnName = routineName
  else:
    rtnName = tagRoutine[-1]

  link = getRoutineHRefLink(rtnName, DOX_URL, **kargs)
  if link is None:
    return routineName
  pos = routineName.find(rtnName)
  return routineName[:pos] + link + routineName[pos+len(rtnName):]

def getPackageHRefLink(pkgName):
  value = "<a href=\"%s/%s\">%s</a>" % (DOX_URL,
                                       getPackageHtmlFileName(pkgName),
                                       pkgName)
  return value

def getWordProcessingDataBrief(dataEntry, value, **kargs):
  return " ".join(value)

def getFileManFilePointerLink(dataEntry, value, **kargs):
  if value:
    fields = value.split('^')
    if len(fields) == 3: # fileNo, ien, name
      refFile = getDataEntryHtmlFileName(fields[1], fields[0])
      value = '<a href="%s/%s/%s">%s</a>' % (VIV_URL, fields[0].replace(".","_"),refFile, fields[-1])
    elif len(fields) == 2:
      value = 'File: %s, IEN: %s' % (fields[0], fields[1])
    else:
      logger.error("Unknown File Pointer Value %s" % value)
  return value

""" Requires extra information to be made available on the run of the object.

    ("HL7 Type Tag", '1/.01', "771.2/.01" ,getFreeTextLink), # Action Tag

    In addition to the current file's location, found in entry 1, add the place
    where the information is available in the target file as part of the second entry.
    "{File Number}/{Field Number}"

"""
def getFreeTextLink(dataEntry, value, **kargs):
  if value:
    if 'glbData' in kargs:
      glbData = kargs['glbData']
      # Acquire the field and file of the target information
      file,field = kargs["targetField"].split("/");
      # Check if the target file hasn't already been parsed
      if file not in glbData.outFileManData:
        glbData._glbData[file] = FileManFileData(file,
                                  glbData.getFileManFileNameByFileNo(file))
        for pathName in glbData.allFiles[file]["path"]:
          # Taken from the FileManGlobalDataParser
          glbData._createDataRootByZWRFile(pathName)
          glbLoc = glbData._glbLocMap.get(file)
          for dataRoot in readGlobalNodeFromZWRFileV2(pathName, glbLoc):
            if not dataRoot:
              continue
            glbData._dataRoot = dataRoot
            fileDataRoot = dataRoot
            glbData._parseDataBySchema(fileDataRoot, glbData._allSchemaDict[file],
                                    glbData._glbData[file])
      # Once the information is available check for the target in any available
      # information in that file
      dataEntries = glbData.outFileManData[file].dataEntries
      for entry in dataEntries:
        if value == dataEntries[entry].fields[field].value:
          return '<a href="%s/%s/%s-%s.html">%s</a>' % (VIV_URL, dataEntries[entry].fileNo.replace(".","_"),
                                                        file, entry, value)
  return value

"""
fields and logic to convert to html for RPC List
"""
rpc_list_fields = (
       ("Name", '.01', getFileHtmlLink), # Name
       ("Tag", '.02', None), # Tag
       ("Routine", '.03', _getRoutineHRefLink), # Routine
       ("Availability", '.05', None),# Availability
       ("Description", '1', getWordProcessingDataBrief),# Description
   )

"""
fields and logic to convert to html for HL7 List
"""
hl7_list_fields = (
       ("Name", '.01', getFileHtmlLink), # Name
       ("Type", '4', None), # Type
       ("Transaction Message Type", '770.3', getFileManFilePointerLink), # Message Type
       ("Response Message Type", '770.11', getFileManFilePointerLink), # Message Type
       ("Event Type", '770.4', getFileManFilePointerLink), # Event Type
       ("Sender", '770.1', getFileManFilePointerLink),# Sending Application
       ("Receiver", '770.2', getFileManFilePointerLink),# Receiving Application
   )

hl7_table_header_fields = (
    ("""
      <th rowspan="2">Name</th>
      <th rowspan="2">Type</th>
      <th colspan="2">Message Type</th>
      <th rowspan="2">Event Type</th>
      <th rowspan="2">Sender</th>
      <th rowspan="2">Receiver</th>
     """),
    ("""
      <th>Transaction</th>
      <th>Response</th>
     """),
  )

hl7_column_names = ["Name", "Type", "Transaction","Response",
                    "Event Type", "Sender", "Receiver"]

"""
fields and logic to convert to html for Protocol List
"""
protocol_list_fields = (
       ("Name", '.01', getFileHtmlLink), # Name
       ("Type", '4', None), # Type
       ("Lock", '3', None), # Type
       ("Description", '3.5', getWordProcessingDataBrief), # Type
       ("Entry Action", '20', None), # Type
       ("Exit Action", '15', None), # Type
   )

"""
fields and logic to convert to html for HLO List
"""
HLO_list_fields = (
       ("Name", '.01', getFileHtmlLink), # Name
       ("Package", '2', getFileManFilePointerLink), # Type
       ("HL7 Type Tag", '1/.01', "771.2/.01" ,getFreeTextLink), # Action Tag
       ("Action Tag", '1/.04', None), # Action Tag
       ("Action Routine", '1/.05', _getRoutineHRefLink), # Action Routine
   )

HLO_table_header_fields = (
    ("""
      <th rowspan="2">Name</th>
      <th rowspan="2">Package</th>
      <th colspan="3">Actions</th>
    """),
    ("""
      <th>HL7 Message Type</th>
      <th>Action Tag</th>
      <th>Action Routine</th>
    """),
  )

HLO_column_names = ["Name", "Package", "HL7 Message Type",
                    "Action Tag", "Action Routine"]

"""
fields and logic to convert to html for option List
"""
option_list_fields = (
       ("Name", '.01', getFileHtmlLink), # Name
       ("Type", '4', None), # Type
       ("Lock", '3', None), # Lock
       #("Description", '3.5', getWordProcessingDataBrief), # Description
   )

menu_list_fields = (
       ("Name", '.01', getFileHtmlLink), # Name
       ("Menu Text", '1', None), # Menu Text
       ("Lock", '3', None), # Lock
       ("Type", '4', None),
       #("Description", '3.5', getWordProcessingDataBrief), # Description
   )

def isFilePointerType(dataEntry):
  if dataEntry and dataEntry.type:
    type = dataEntry.type
    return type == FileManField.FIELD_TYPE_FILE_POINTER or \
             type == FileManField.FIELD_TYPE_VARIABLE_FILE_POINTER
  return False

from FileManGlobalDataParser import getMumpsRoutine
def getMumpsRoutineHtmlLinks(inputString, crosRef=None):
  """
    For a giving Mumps code, it use regular expression
    to parse the code section and identify all the possible routines
    and covert html routines to html format
  """
  output = ""
  startpos = 0
  endpos = 0
  for routine, tag, start in getMumpsRoutine(inputString):
    if routine:
      output += (inputString[startpos:start] +
                 _getRoutineHRefLink(None, routine, crossRef=crosRef))
      startpos = start + len(routine)
  if startpos < len(inputString):
    output += inputString[startpos:]
  if output:
    return output
  else:
    return inputString

def convertFilePointerToHtml(inputValue):
  value = inputValue
  name = inputValue
  fields = inputValue.split('^')
  if len(fields) == 3: # fileNo, ien, name
    refFile = getDataEntryHtmlFileName(fields[1], fields[0])
    value = '<a href="%s/%s/%s">%s</a>' % (VIV_URL, fields[0].replace(".","_"), refFile, fields[-1])
    name = fields[-1]
  elif len(fields) == 2:
    value = 'File: %s, IEN: %s' % (fields[0], fields[1])
    name = value
  else:
    logger.error("Unknown File Pointer Value '%s'" % inputValue)
  return value, name


class FileManDataToHtml(object):
  """
    class to Genetate HTML pages based on FileManData
  """
  def __init__(self, crossRef, schemaParser, outDir, doxURL, vivURL):
    global DOX_URL
    global VIV_URL
    self.crossRef = crossRef
    self.schemaParser = schemaParser
    self.outDir = outDir
    DOX_URL = doxURL
    VIV_URL = vivURL
    # a map of a tuple of menu options (parent, child) which point to the synonym for the child option
    #
    #  Example: ('DGBT BENE TRAVEL MENU', 'DGBT TRAVEL REPORTS MENU') : [RPTS]
    #
    self.synonymMap = {}

  def outputFileManDataAsHtml(self, fileNo, gblDataParser):
    """
      This is the entry pointer to generate Html output
      format based on FileMan Data object
      @TODO: integrate with FileManFileOutputFormat.py
    """
    crossRef = self.crossRef
    fileManDataMap = gblDataParser.outFileManData
    self.dataMap = gblDataParser
    fileManData = fileManDataMap[fileNo]
    fileNoPathSafe = fileNo.replace('.','_')
    fileNoOutDir = os.path.join(self.outDir, fileNoPathSafe)
    if not os.path.exists(fileNoOutDir):
      os.mkdir(fileNoOutDir)
    if fileNo == '8994':
      if crossRef:
        allPackages = crossRef.getAllPackages()
        allRpcs = []
        for package in allPackages.itervalues():
          if package.rpcs:
            self._generateRPCListHtml(package.rpcs, package.getName(),
                                      fileNoOutDir)
            allRpcs.extend(package.rpcs)
        if allRpcs:
          self._generateRPCListHtml(allRpcs, "All", fileNoOutDir)
    elif fileNo == '101':
      menuOutDir = os.path.join(self.outDir, "menus", "101")
      if not os.path.exists(menuOutDir):
        os.makedirs(menuOutDir)
      allProtoMenuList = []
      if crossRef:
        allPackages = crossRef.getAllPackages()
        allHl7s = []
        allProtocols = []
        for ien in getKeys(fileManData.dataEntries.keys(), float):
          dataEntry = fileManData.dataEntries[ien]
          allProtocols.append(dataEntry)
          fields = dataEntry.fields
          if '4' in fields:
            if fields['4'].value == 'menu':
              allProtoMenuList.append(dataEntry)
        for package in allPackages.itervalues():
          if package.hl7:
            self._generateHL7ListByPackage(package.hl7, package.getName(),
                                           fileNoOutDir)
            allHl7s.extend(package.hl7)
          if package.protocol:
            self._generateProtocolListByPackage(package.protocol,
                                                package.getName(),
                                                fileNoOutDir)
        if allHl7s:
          self._generateHL7ListByPackage(allHl7s, "All", fileNoOutDir)
        if allProtocols:
          self._generateProtocolListByPackage(allProtocols, "All",
                                              fileNoOutDir)
      self._generateMenuDependency(allProtoMenuList, allProtocols,menuOutDir)
    elif fileNo == '779.2':
      if crossRef:
        allPackages = crossRef.getAllPackages()
        allHLOs = []
        for package in allPackages.itervalues():
          if package.hlo:
            self._generateHLOListByPackage(package.hlo, package.getName(),
                                           gblDataParser, fileNoOutDir)
            allHLOs.extend(package.hlo)
        if allHLOs:
          self._generateHLOListByPackage(allHLOs, "All", gblDataParser,
                                         fileNoOutDir)
    elif fileNo == '19':
      allOptionList = []
      allMenuList = []
      serverMenuList = []
      outJSON = {}
      menuOutDir = os.path.join(self.outDir, "menus", "19")
      if not os.path.exists(menuOutDir):
        os.makedirs(menuOutDir)
      for ien in getKeys(fileManData.dataEntries.keys(), float):
        dataEntry = fileManData.dataEntries[ien]
        allOptionList.append(dataEntry)
        fields = dataEntry.fields
        if '4' in fields:
          if fields['4'].value == 'menu':
            allMenuList.append(dataEntry)
          # Seperate list for the "server" OPTIONS
          elif fields['4'].value == 'server':
            serverMenuList.append(dataEntry);
        else:
          logger.error("ien: %s of file 19 does not have a type" % ien)

      self._generateDataListByPackage(allOptionList, "All",
                                      option_list_fields, "Option",
                                      [x[0] for x in option_list_fields],
                                      ["Name", "Lock"], fileNoOutDir)
      self._generateDataListByPackage(allMenuList, "All", menu_list_fields,
                                      "menus",
                                      [x[0] for x in menu_list_fields],
                                      ["Name", "Menu Text", "Lock"],
                                      fileNoOutDir)


      self._generateServerMenu(allMenuList, allOptionList, serverMenuList)
      self._generateMenuDependency(allMenuList, allOptionList,menuOutDir)

    allObjectsList = []
    outJSON = {}
    for ien in getKeys(fileManData.dataEntries.keys(), float):
      dataEntry = fileManData.dataEntries[ien]
      outJSON[ien] = dataEntry.fields
      allObjectsList.append(dataEntry)
    with open(os.path.join(self.outDir, "dox", "%s.json" % fileNoPathSafe), 'w') as output:
      json.dump(outJSON, output, ensure_ascii=False, cls=OSEHRAEncoder)

    self._generateDataTableHtml(fileManData, fileNo, fileNoOutDir)
    self._convertFileManDataToHtml(fileManData)

  def outputAllFileManDataAsHtml(self, gblDataParser):
    """
      This is the entry pointer to generate Html output
      format based on FileMan Data object
      @TODO: integrate with FileManFileOutputFormat.py
    """
    crossRef = self.crossRef
    fileManDataMap = gblDataParser.outFileManData
    self.dataMap = gblDataParser
    for fileNo in getKeys(fileManDataMap.iterkeys(), float):
      fileManData = fileManDataMap[fileNo]
      fileNoPathSafe = fileNo.replace('.','_')
      fileNoOutDir = os.path.join(self.outDir, fileNoPathSafe)
      if not os.path.exists(fileNoOutDir):
        os.mkdir(fileNoOutDir)
      if fileNo == '8994':
        if crossRef:
          allPackages = crossRef.getAllPackages()
          allRpcs = []
          for package in allPackages.itervalues():
            if package.rpcs:
              self._generateRPCListHtml(package.rpcs, package.getName(),
                                        fileNoOutDir)
              allRpcs.extend(package.rpcs)
          if allRpcs:
            self._generateRPCListHtml(allRpcs, "All", fileNoOutDir)
      elif fileNo == '101':
        menuOutDir = os.path.join(self.outDir, "menus", "101")
        if not os.path.exists(menuOutDir):
          os.makedirs(menuOutDir)
        allProtoMenuList = []
        if crossRef:
          allPackages = crossRef.getAllPackages()
          allHl7s = []
          allProtocols = []
          for ien in getKeys(fileManData.dataEntries.keys(), float):
            dataEntry = fileManData.dataEntries[ien]
            allProtocols.append(dataEntry)
            fields = dataEntry.fields
            if '4' in fields:
              if fields['4'].value == 'menu':
                allProtoMenuList.append(dataEntry)
          for package in allPackages.itervalues():
            if package.hl7:
              self._generateHL7ListByPackage(package.hl7, package.getName(),
                                             fileNoOutDir)
              allHl7s.extend(package.hl7)
            if package.protocol:
              self._generateProtocolListByPackage(package.protocol,
                                                  package.getName(),
                                                  fileNoOutDir)
          if allHl7s:
            self._generateHL7ListByPackage(allHl7s, "All", fileNoOutDir)
          if allProtocols:
            self._generateProtocolListByPackage(allProtocols, "All",
                                                fileNoOutDir)
        self._generateMenuDependency(allProtoMenuList, allProtocols,menuOutDir)
      elif fileNo == '779.2':
        if crossRef:
          allPackages = crossRef.getAllPackages()
          allHLOs = []
          for package in allPackages.itervalues():
            if package.hlo:
              self._generateHLOListByPackage(package.hlo, package.getName(),
                                             gblDataParser, fileNoOutDir)
              allHLOs.extend(package.hlo)
          if allHLOs:
            self._generateHLOListByPackage(allHLOs, "All", gblDataParser,
                                           fileNoOutDir)
      elif fileNo == '19':
        allOptionList = []
        allMenuList = []
        serverMenuList = []
        outJSON = {}
        menuOutDir = os.path.join(self.outDir, "menus", "19")
        if not os.path.exists(menuOutDir):
          os.makedirs(menuOutDir)
        for ien in getKeys(fileManData.dataEntries.keys(), float):
          dataEntry = fileManData.dataEntries[ien]
          allOptionList.append(dataEntry)
          fields = dataEntry.fields
          if '4' in fields:
            if fields['4'].value == 'menu':
              allMenuList.append(dataEntry)
            # Seperate list for the "server" OPTIONS
            elif fields['4'].value == 'server':
              serverMenuList.append(dataEntry);
          else:
            logger.error("ien: %s of file 19 does not have a type" % ien)

        self._generateDataListByPackage(allOptionList, "All",
                                        option_list_fields, "Option",
                                        [x[0] for x in option_list_fields],
                                        ["Name", "Lock"], fileNoOutDir)
        self._generateDataListByPackage(allMenuList, "All", menu_list_fields,
                                        "menus",
                                        [x[0] for x in menu_list_fields],
                                        ["Name", "Menu Text", "Lock"],
                                        fileNoOutDir)


        self._generateServerMenu(allMenuList, allOptionList, serverMenuList)
        self._generateMenuDependency(allMenuList, allOptionList,menuOutDir)

      allObjectsList = []
      outJSON = {}
      for ien in getKeys(fileManData.dataEntries.keys(), float):
        dataEntry = fileManData.dataEntries[ien]
        outJSON[ien] = dataEntry.fields
        allObjectsList.append(dataEntry)

      self._generateDataListByPackage(allObjectsList, "All",
                                      option_list_fields, "Function",
                                      [x[0] for x in option_list_fields],
                                      ["Name", "Lock"], fileNoOutDir)
      with open(os.path.join(self.outDir, "dox", "%s.json" % fileNoPathSafe), 'w') as output:
        json.dump(outJSON, output, ensure_ascii=False, cls=OSEHRAEncoder)

      self._generateDataTableHtml(fileManData, fileNo, fileNoOutDir)
      self._convertFileManDataToHtml(fileManData)

  def _generateServerMenu(self, allMenuList, allOptionList, serverMenuList):
    """
    Generates a virtual menu based upon content in serverMenuList
    All "SERVER" type options are sorted based upon value 12 or "Package"

    :param allMenuList: all available menus as dictionary
    :param allOptionList: all available options as dictionary
    :param serverMenuList: array of options that have "SERVER" type
    :return: None
    """
    # Add virtual menu for all "Server" type OPTIONS to be a child of
    menuArray = {}
    fileDataArray = {}
    package_name_dict = {"3": "Kernel",
                         "4": "MailMan",
                         "5": "Toolkit",
                         "14": "Lab Service",
                         "33": "Health Level Seven",
                         "49": "Integrated Billing",
                         "52": "IFCAP",
                         "53": "Accounts Receivable",
                         "73": "Network Health Exchange",
                         "82": "CMOP",
                         "85": "Patient Data Exchange",
                         "93": "Automated Med Information Exchange",
                         "99": "EEO Complaint Tracking",
                         "114": "Fee Basis",
                         "115": "Radiology/Nuclear Medicine",
                         "124": "Medicine",
                         "127": "Surgery",
                         "128": "Oncology",
                         "147": "Remote Order/Entry System",
                         "149": "Voluntary Timekeepting",
                         "165": "DSS Extracts",
                         "181": "Enrollment Application System",
                         "188": "Functional Independence",
                         "201": "Health Data & Informatics"}
    menuArray['0'] = FileManDataEntry(19, "9999990")
    menuArray['0'].addField(FileManDataField('1', 4, 'MENU TEXT', 'Unknown'))
    menuArray['0'].addField(FileManDataField('4', 2, 'TYPE', 'menu'))
    menuArray['0'].type = 'menu'
    menuArray['0'].name = "19^9999990"
    fileDataArray['0'] = FileManFileData("9999990", 'TMP' + "1")

    serverMenuEntry = FileManDataEntry(19, "9999999")
    serverMenuEntry.name = "ZZSERVERMENU"
    serverMenuEntry.addField(FileManDataField('3.6', 0, 'CREATOR', '200^1'))
    serverMenuEntry.addField(FileManDataField('1.1', 1, 'UPPERCASE MENU TEXT', 'SERVER VIRTUAL MENU'))
    serverMenuEntry.addField(FileManDataField('4', 2, 'TYPE', 'menu'))
    serverMenuEntry.addField(FileManDataField('1', 4, 'MENU TEXT', 'Server Virtual Menu'))
    serverMenuEntry.addField(FileManDataField('.01', 3, 'NAME', 'ZZSERVERMENU'))
    for menu in serverMenuList:
      if '12' in menu.fields:
        menuIEN = menu.fields['12'].value.split('^')[1]
        if menuIEN not in menuArray:
          menuArray[menuIEN] = FileManDataEntry(19, "999999" + menuIEN)
          menuArray[menuIEN].addField(FileManDataField('1', 4, 'MENU TEXT', package_name_dict[menuIEN]))
          menuArray[menuIEN].addField(FileManDataField('4', 2, 'TYPE', 'menu'))
          menuArray[menuIEN].type = 'menu'
          menuArray[menuIEN].name = "19^999999" + str(menuIEN)
          fileDataArray[menuIEN]= FileManFileData("999999" + str(menuIEN), 'TMP' + "2")
      else:
        menuIEN = '0'
      tmp = FileManDataEntry(19, menu.ien)
      tmp.name = "19^" + menu.ien
      fileDataArray[menuIEN].addFileManDataEntry(len(fileDataArray[menuIEN].dataEntries), tmp)
      menuArray[menuIEN].addField(FileManDataField('10', 5, 'MENU', fileDataArray[menuIEN]))

    index = 1
    test = FileManFileData("9999999", 'Server Virtual Menu')
    for menu in menuArray.keys():
      allOptionList.append(menuArray[menu])
      allMenuList.append(menuArray[menu])
      test.addFileManDataEntry(index, menuArray[menu])
      index += 1
    serverMenuEntry.addField(FileManDataField('10', 5, 'MENU', test))
    allMenuList.append(serverMenuEntry)

  def _generateMenuDependency(self, allMenuList, allOptionList, outDir):
    menuDict = dict((x.ien, x) for x in allOptionList)
    menuDepDict = dict((x, set()) for x in allMenuList)
    for dataEntry in allMenuList:
      if '10' in dataEntry.fields:
        menuData = dataEntry.fields['10'].value
        if menuData and menuData.dataEntries:
          for subIen in menuData.dataEntries:
            subEntry = menuData.dataEntries[subIen]
            if not ".01" in subEntry.fields:
              continue
            value = subEntry.name
            childIen = value.split('^')[1]
            if '2' in subEntry.fields:
              self.synonymMap[(dataEntry.name, menuDict[childIen].name)] =  "[" + subEntry.fields['2'].value+ "]"
            if childIen in menuDict:
              menuDepDict[dataEntry].add(menuDict[childIen])
            else:
              logger.error("Could not find %s: value: %s" % (childIen, value))
    """ discard any menu does not have any child """
    leafMenus = set()
    for entry in menuDepDict:
      if not menuDepDict[entry]:
        leafMenus.add(entry)
    for entry in leafMenus:
      del menuDepDict[entry]
    """ find the top level menu, menu without any parent """
    allChildSet = reduce(set.union, menuDepDict.itervalues())
    rootSet = set(allMenuList) - allChildSet
    leafSet = allChildSet - set(allMenuList)

    """ generate the json file based on root menu """
    for item in rootSet:
      outJson = {}
      outJson['name'] = item.name
      outJson['option'] = item.name
      outJson['ien'] = item.ien
      # Explicitly exclude the ZZSERVERMENU from having a link generated for it.
      outJson['hasLink'] = False if item.name == "ZZSERVERMENU" else True
      if '1' in item.fields:
        outJson['name'] = item.fields['1'].value
      if '3' in item.fields:
        outJson['lock'] = item.fields['3'].value
      if '4' in item.fields:
        outJson['type'] = item.fields['4'].value
      if item in menuDepDict:
        self._addChildMenusToJson(menuDepDict[item], menuDepDict, outJson, item)
      with open(os.path.join(outDir, "VistAMenu-%s.json" % item.ien), 'w') as output:
        json.dump(outJson, output)

  def _addChildMenusToJson(self, children, menuDepDict, outJson, parent):
    for item in children:
      synonym=''
      if (parent.name,item.name) in self.synonymMap:
        synonym = self.synonymMap[(parent.name,item.name)]
      childDict = {}
      childDict['name'] = synonym + item.name
      childDict['ien'] = item.ien
      if '1' in item.fields:
        childDict['name'] = synonym + item.fields['1'].value
        childDict['option'] = item.name
      # ZZSERVER submenus have a name of "19^99999*.  Prevent them from having a clickable link.
      childDict['hasLink'] = False if ZZSERVER_SUBMENU_REGEX.search(item.name) else True
      if '3' in item.fields:
        childDict['lock'] = item.fields['3'].value
      if '4' in item.fields:
        childDict['type'] = item.fields['4'].value
      if item in menuDepDict:
        self._addChildMenusToJson(menuDepDict[item], menuDepDict, childDict, item)
      outJson.setdefault('_children',[]).append(childDict)

  def _generateRPCListHtml(self, dataEntryLst, pkgName, fileNoOutDir):
    """
      Specific logic to handle RPC List
      @TODO move the logic to a specific file
    """
    columnNames = [x[0] for x in rpc_list_fields]
    searchColumnNames = ["Name", "Tag", "Routine", "Description"]
    return self._generateDataListByPackage(dataEntryLst, pkgName,
                                           rpc_list_fields, "RPC",
                                           columnNames, searchColumnNames,
                                           fileNoOutDir)

  def _generateHL7ListByPackage(self, dataEntryLst, pkgName, fileNoOutDir):
    """
      Specific logic to handle HL7 List
      @TODO move the logic to a specific file
    """
    searchColumnNames = ["Name", "Transaction", "Response",
                         "Event Type", "Sender", "Receiver"]
    return self._generateDataListByPackage(dataEntryLst, pkgName,
                                           hl7_list_fields, "HL7",
                                           hl7_column_names,
                                           searchColumnNames, fileNoOutDir,
                                           hl7_table_header_fields)

  def _generateProtocolListByPackage(self, dataEntryLst, pkgName, fileNoOutDir):
    """
      Specific logic to handle HL7 List
      @TODO move the logic to a specific file
    """
    columnNames = [x[0] for x in protocol_list_fields]
    searchColumnNames = ["Name", "Lock", "Description", "Entry Action", "Exit Action"]
    return self._generateDataListByPackage(dataEntryLst, pkgName,
                                           protocol_list_fields, "Protocols",
                                           columnNames, searchColumnNames, fileNoOutDir)

  def _generateHLOListByPackage(self, dataEntryLst, pkgName, fileManDataMap,
                                fileNoOutDir):
    """
      Specific logic to handle HLO List
      @TODO move the logic to a specific file
    """
    searchColumnNames = ["Name", "Package", "HL7 Message Type",
                         "Action Tag", "Action Routine"]
    return self._generateDataListByPackage(dataEntryLst, pkgName,
                                           HLO_list_fields, "HLO",
                                           HLO_column_names, searchColumnNames,
                                           fileNoOutDir,
                                           HLO_table_header_fields)

  def _generateDataListByPackage(self, dataEntryLst, pkgName, list_fields,
                                 listName, columnNames, searchColumnNames,
                                 fileNoOutDir, custom_header=None):
    filename = os.path.join(fileNoOutDir, "%s-%s.html" % (pkgName, listName))
    with open(filename, 'w') as output:
      output.write("<html>\n")
      if pkgName == "All":
        tName = "%s %s List" % (normalizePackageName(pkgName), listName)
      else:
        tName = normalizePackageName(pkgName)
      outputDataListTableHeader(output, tName, columnNames, searchColumnNames)
      output.write("<body id=\"dt_example\">")
      output.write("""<div id="container" style="width:80%">""")
      if pkgName == "All":
        pkgLinkName = pkgName
        output.write("<h1>%s %s List</h1>" % (pkgLinkName, listName))
      else:
        output.write("<h2 align=\"right\"><a href=\"./All-%s.html\">"
                     "All %s</a></h2>" % (listName, listName))
        pkgLinkName = getPackageHRefLink(pkgName)
        output.write("<h1>Package: %s %s List</h1>" % (pkgLinkName, listName))
      if not custom_header:
        outputDataTableHeader(output, columnNames, tName)
        outputDataTableFooter(output, columnNames, tName)
      else:
        outputCustomDataTableHeaderRows(output, custom_header, tName)
        outputDataTableFooter(output, columnNames, tName)
      """ table body """
      output.write("<tbody>\n")
      for dataEntry in dataEntryLst:
        tableRow = [""]*len(list_fields)
        allFields = dataEntry.fields
        output.write("<tr>\n")
        for idx, id in enumerate(list_fields):
          # If value has / in it, we take the first value as usual
          # but assume the information is a "multiple" field and
          # attempt to find the second bit of information within it
          idVal, multval = id[1].split('/') if (len(id[1].split('/')) > 1) else (id[1],None)
          if idVal in allFields:
            value = allFields[idVal].value
            if multval:  # and (multval in value.dataEntries["1"].fields)
              value = self.findSubValue(dataEntry, value,multval,id)
            if type(value) is list and id[0] != "Description":
              # Don't write out descriptions as lists
              tmpValue="<ul>"
              for entry in value:
                if id[-1]:
                  tmpValue += "<li>"+id[-1](dataEntry, entry,sourceField=id[1], targetField=id[-2], glbData=self.dataMap, crossRef=self.crossRef)+"</li>"
                else:
                  tmpValue += "<li>"+ entry +"</li>"
              value = tmpValue+"</ul>"
            else:
              if id[-1]:
                value = id[-1](dataEntry, value,sourceField=id[1], targetField=id[-2], glbData=self.dataMap, crossRef=self.crossRef)
            tableRow[idx] = value
        for item in tableRow:
          #output.write("<td class=\"ellipsis\">%s</td>\n" % item)
          output.write("<td>%s</td>\n" % item)
        output.write("</tr>\n")
      output.write("</tbody>\n")
      output.write("</table>\n")
      output.write("</div>\n")
      output.write("</div>\n")
      output.write ("</body></html>\n")

  def findSubValue(self,dataEntry,search,multval, id):
    vals = []
    for entry in search.dataEntries:
      if multval in search.dataEntries[entry].fields:
        vals.append(search.dataEntries[entry].fields[multval].value)
    return vals

  def _generateDataTableHtml(self, fileManData, fileNo, outDir):
    isLargeFile = len(fileManData.dataEntries) > 4500
    tName = normalizePackageName(fileManData.name)
    fieldNamesList =  self.schemaParser._allSchema[fileNo].getFieldNames()
    # Note: We are not normalizing fileNo here
    with open(os.path.join(outDir, "%s.html" % fileNo), 'w') as output:
      output.write("<html>\n")
      # All files are now "large files" and need the ajexSrc file
      ajexSrc = "%s_array.txt" % fileNo
      outputLargeDataListTableHeader(output, ajexSrc, tName, columns=fieldNamesList, searchColumnNames=fieldNamesList, hideColumnNames=[""] )
      output.write("<body id=\"dt_example\">")
      output.write("""<div id="container" style="width:80%">""")
      output.write("<h1>File %s(%s) Data List</h1>" % (tName, fileNo))
      outputDataTableHeader(output, fieldNamesList, tName)
      output.write("<tbody>\n")
      # Don't add rows to import from Ajex
      output.write("</tbody>\n")
      output.write("</table>\n")
      output.write("</div>\n")
      output.write("</div>\n")
      output.write ("</body></html>\n")
    """ Write out the data file in JSON format """
    outJson = {"aaData": self._getTableRows(fileManData, fileNo, fieldNamesList)}
    with open(os.path.join(outDir, ajexSrc), 'w') as output:
      # Ensure that the OSEHRA Encoder is used to write out data.
      json.dump(outJson, output,ensure_ascii=False, cls=OSEHRAEncoder)

  def _getTableRows(self, fileManData, fileNo, fieldsList):
    rows = []
    for ien in getKeys(fileManData.dataEntries.keys(), float):
      row = [""] * len(fieldsList)
      row[0] = ien
      dataEntry = fileManData.dataEntries[ien]
      name = dataEntry.name
      if isFilePointerType(dataEntry):
        link, name = convertFilePointerToHtml(name)
      dataHtmlLink = "<a href=\"%s/%s/%s\">%s</a>" % (VIV_URL, fileNo.replace(".","_"),
                                                      getDataEntryHtmlFileName(ien, fileNo),
                                                      str(name).replace("\xa0", ""))
      for field in dataEntry.fields:
        # Use index of field name to place data correctly in row
        row[fieldsList.index(dataEntry.fields[field].name)] = dataEntry.fields[field].value
        if field == '.01':
          row[fieldsList.index(dataEntry.fields[field].name)] = dataHtmlLink

      rows.append(row)
    return rows

  def _convertFileManDataToHtml(self, fileManData):
    fileManDataFileNo = fileManData.fileNo
    pathSafeFileManDataFileNo = fileManDataFileNo.replace(".", "_")
    for ien in getKeys(fileManData.dataEntries.keys(), float):
      dataEntry = fileManData.dataEntries[ien]
      name = dataEntry.name
      if not name:
        logger.warn("no name for %s" % dataEntry)
        continue
      outDir = self.outDir
      fileNo = dataEntry.fileNo
      if fileNo:
        outDir = os.path.join(self.outDir, fileNo.replace(".","_"))
      tName = safeElementId("%s-%s" % (pathSafeFileManDataFileNo, ien))
      if isFilePointerType(dataEntry):
        link, name = convertFilePointerToHtml(name)
      outHtmlFileName = getDataEntryHtmlFileName(ien, fileManDataFileNo)
      with open(os.path.join(outDir, outHtmlFileName), 'w') as output:
        output.write ("<html>")
        outputDataRecordTableHeader(output, tName)
        output.write("<body id=\"dt_example\">")
        output.write("""<div id="container" style="width:80%">""")
        output.write ("<h1>%s (%s) &nbsp;&nbsp;  %s (%s)</h1>\n" % (name, ien,
                                                                    fileManData.name,
                                                                    fileManDataFileNo))
        if fileNo in ['19','101']:
          # Todo: Check if the object exists in options/menus first.
          output.write("<a style='font-size: 15px;' href='%s/../vista_menus.php#%s?name=%s'>View in ViViaN Menu</a>" %
                          (VIV_URL, fileNo, urllib.quote_plus(name)))
        outputFileEntryTableList(output, tName)
        """ table body """
        output.write("<tbody>\n")
        self._fileManDataEntryToHtml(output, dataEntry, True)
        output.write("</tbody>\n")
        output.write("</table>\n")
        output.write("</div>\n")
        output.write("</div>\n")
        output.write ("</body></html>")

  def _convertFileManSubFileDataToHtml(self, output, fileManData):
    output.write ("<ol>\n")
    for ien in getKeys(fileManData.dataEntries.keys(), float):
      dataEntry = fileManData.dataEntries[ien]
      self._fileManDataEntryToHtml(output, dataEntry, False)
    output.write ("</ol>\n")

  def _fileManDataEntryToHtml(self, output, dataEntry, isRoot):
    if not isRoot:
      output.write("<li>\n")
    fields = dataEntry.fields.keys()
    fields.sort()
    for fldId in fields:
      dataField = dataEntry.fields[fldId]
      fieldType = dataField.type
      name = dataField.name
      value = dataField.value
      if fieldType == FileManField.FIELD_TYPE_MUMPS:
        value = getMumpsRoutineHtmlLinks(value, self.crossRef)
      elif fieldType == FileManField.FIELD_TYPE_FREE_TEXT and name.find("ROUTINE") >=0:
        value = _getRoutineHRefLink(dataEntry, str(value), crossRef=self.crossRef)
      elif fieldType == FileManField.FIELD_TYPE_SUBFILE_POINTER:
        if value and value.dataEntries:
          if isRoot:
            output.write("<tr>\n")
            output.write("<td>%s</td>\n" % name)
            output.write("<td>\n")
          else:
            output.write ("<dl><dt>%s:</dt>\n" % name)
            output.write ("<dd>\n")
          self._convertFileManSubFileDataToHtml(output, value)
          if isRoot:
            output.write("</td>\n")
            output.write ("</tr>\n")
          else:
            output.write ("</dd></dl>\n")
        continue
      elif (fieldType == FileManField.FIELD_TYPE_FILE_POINTER or
            fieldType == FileManField.FIELD_TYPE_VARIABLE_FILE_POINTER) :
        if value:
          origVal = value
          value, tmp = convertFilePointerToHtml(value)
      elif fieldType == FileManField.FIELD_TYPE_WORD_PROCESSING:
        value = "\n".join(value)
        value = "<pre>\n" + cgi.escape(value) + "\n</pre>\n"
      if isRoot:
        output.write ("<tr>\n")
        output.write ("<td>%s</td>\n" % name)
        output.write ("<td>%s</td>\n" % value)
        output.write ("</tr>\n")
      else:
        output.write ("<dt>%s:  &nbsp;&nbsp;%s</dt>\n" % (name, value))
        #output.write ("<dd>%s</dd>\n" % value)
    if not isRoot:
      output.write("</li>\n")
