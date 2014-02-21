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
    if level == 0:
      print "FileEntry#: %s, Name: %s" % (ien, dataEntry.name)
    else:
      print
    for fldId in sorted(dataEntry.fields.keys(), key=lambda x: float(x)):
      dataField = dateEntry.fields[fldId]
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

def safeFileName(name):
  import base64
  return base64.urlsafe_b64encode(name)

outDir = "C:/Users/Jason.li/git/Prod-Manage/Visual/rpc"
header="""
<link rel="stylesheet" href="http://tablesorter.com/themes/blue/style.css" type="text/css" id=""/>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="http://tablesorter.com/__jquery.tablesorter.js"></script>
<script type="text/javascript" id="js">
  $(document).ready(function() {
  // call the tablesorter plugin
  $("#rpctable").tablesorter({
    // sort on the first column and third column, order asc
    sortList: [[0,0],[2,0]]
  });
}); </script>
"""

dthead = """
<link rel="stylesheet" href="../datatable/css/demo_page.css" type="text/css" id=""/>
<link rel="stylesheet" href="../datatable/css/demo_table.css" type="text/css" id=""/>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../datatable/js/jquery.dataTables.js"></script>
<script type="text/javascript" id="js">
  $(document).ready(function() {
  // call the tablesorter plugin
      $("#rpctable").dataTable({
        "bInfo": true,
        "iDisplayLength": 25,
        "sPaginationType": "full_numbers"
      });

}); </script>
"""

dthead_rpc = """
<link rel="stylesheet" href="../datatable/css/demo_page.css" type="text/css" id=""/>
<link rel="stylesheet" href="../datatable/css/demo_table.css" type="text/css" id=""/>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../datatable/js/jquery.dataTables.js"></script>
<script type="text/javascript" id="js">
  $(document).ready(function() {
  // call the tablesorter plugin
      $("#rpctable").dataTable({
        "bPaginate": false,
        "bLengthChange": false,
        "bInfo": false,
        "bSort": false
      });

}); </script>
"""

def writeTableInfo(output):
  #output.write("<table id=\"rpctable\" class=\"tablesorter\">\n")
  output.write("<div id=\"demo\">")
  output.write("<table id=\"rpctable\" class=\"display\">\n")
  output.write("<thead>\n")
  output.write("<tr>\n")
  for name in ("Name", "Tag", "Routine", "Availability"):
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</thead>\n")

def writeTableInfoRPC(output):
  #output.write("<table id=\"rpctable\" class=\"tablesorter\">\n")
  output.write("<div id=\"demo\">")
  output.write("<table id=\"rpctable\" class=\"display\">\n")
  output.write("<thead>\n")
  output.write("<tr>\n")
  for name in ("Name", "Value"):
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</thead>\n")

def generateRPCListHtml(dataEntryLst, outputName):
  with open("%s/%s.html" % (outDir, outputName), 'w+') as output:
      output.write("<html>\n")
      output.write("%s\n" % dthead)
      output.write("<body id=\"dt_example\">")

      output.write("""<div id="container" style="width:80%">""")
      output.write("<h1>Package: %s RPC List</h1>" % (getPackageHRefLink(outputName)))
      writeTableInfo(output)
      """ table body """
      output.write("<tbody>\n")
      for dataEntry in dataEntryLst:
        tableRow = ["", "", "", ""]
        allFields = dataEntry.fields
        for fldId in allFields.iterkeys():
          for idx, id in enumerate(('.01', '.02', '.03', '.05')):
            if id in fldId:
              value = allFields[fldId].value
              if id == '.01':
                value = "<a href=\"%s.html\">%s</a>" % (safeFileName(value), value)
              elif id == '.03': # routine
                value = getRoutineHRefLink(value)
              tableRow[idx] = value
              continue
        output.write("<tr>\n")
        for item in tableRow:
          output.write("<td>%s</td>\n" % item)
        output.write("</tr>\n")
      output.write("</tbody>\n")
      output.write("</table>\n")
      output.write("</div>\n")
      output.write("</div>\n")
      output.write ("</body></html>\n")

dox_url = "http://code.osehra.org/dox/"
def getRoutineHRefLink(routineName):
  from WebPageGenerator import getRoutineHtmlFileName
  value = "<a href=\"%s%s\">%s</a>" % (dox_url,
                                       getRoutineHtmlFileName(routineName),
                                       routineName)
  return value
def getPackageHRefLink(pkgName):
  from WebPageGenerator import getPackageHtmlFileName
  value = "<a href=\"%s%s\">%s</a>" % (dox_url,
                                       getPackageHtmlFileName(pkgName),
                                       pkgName)
  return value

def convertFileManDataToHtml(fileManData):
  for ien in getKeys(fileManData.dataEntries.keys(), float):
    dataEntry = fileManData.dataEntries[ien]
    with open("%s/%s.html" % (outDir, safeFileName(dataEntry.name)), 'w') as output:
      output.write ("<html>")
      output.write ("%s\n" % dthead_rpc)
      output.write("<body id=\"dt_example\">")
      output.write("""<div id="container" style="width:80%">""")
      output.write ("<h1>%s (%s)</h1>\n" % (dataEntry.name, ien))
      writeTableInfoRPC(output)
      """ table body """
      output.write("<tbody>\n")
      fileManDataEntryToHtml(output, dataEntry, True)
      output.write("</tbody>\n")
      output.write("</table>\n")
      output.write("</div>\n")
      output.write("</div>\n")
      output.write ("</body></html>")

def convertFileManSubFileDataToHtml(output, fileManData):
  output.write ("<ol>")
  for ien in getKeys(fileManData.dataEntries.keys(), float):
    dataEntry = fileManData.dataEntries[ien]
    fileManDataEntryToHtml(output, dataEntry, False)
  output.write ("</ol>")

import cgi
def fileManDataEntryToHtml(output, dataEntry, isRoot):
  if not isRoot:
    output.write ("<li>")
  for fldId in sorted(dataEntry.fields.keys(), key=lambda x: float(x)):
    if isRoot:
      output.write ("<tr>\n")
    dataField = dataEntry.fields[fldId]
    fieldType = dataField.type
    name, value = dataField.name, dataField.value
    """ hack for RPC """
    if isRoot and fldId == '.03' and dataField.name == "ROUTINE":
      value = getRoutineHRefLink(value)
    if fieldType == FileManField.FIELD_TYPE_SUBFILE_POINTER:
      if dataField.value and dataField.value.dataEntries:
        if isRoot:
          output.write("<td>%s</td>" % name)
          output.write("<td>")
        else:
          output.write ("<dt>%s:</dt>" % name)
          output.write ("<dd>")
        convertFileManSubFileDataToHtml(output, dataField.value)
        if isRoot:
          output.write("</td>")
        else:
          output.write ("</dd>")
        continue
    if fieldType == FileManField.FIELD_TYPE_WORD_PROCESSING:
      value = "\n".join(value)
      value = "<pre>\n" + cgi.escape(value) + "\n</pre>\n"
    if isRoot:
      output.write ("<td>%s</td>" % name)
      output.write ("<td>%s</td>" % value)
      output.write ("</tr>")
    else:
      output.write ("<dt>%s:</dt>" % name)
      output.write ("<dd>%s</dd>" % value)
  if not isRoot:
    output.write("</li>")

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
    self._glbData = {} # fileNo => FileManData

  @property
  def outFileManData(self):
    return self._glbData

  @property
  def crossRef(self):
    return self._crossRef

  def parseZWRGlobalDataBySchema(self, inputFileName, allSchemaDict,
                                 fileNumber, subscript):
    self._dataRoot = createGlobalNodeByZWRFile(inputFileName)
    self._allSchemaDict = allSchemaDict
    schemaFile = allSchemaDict[fileNumber]
    if subscript and subscript in self._dataRoot:
      dataRoot = self._dataRoot[subscript]
      self._glbData[fileNumber] = FileManFileData(fileNumber,
                                                  schemaFile.getFileManName())
      self._parseDataBySchema(dataRoot, schemaFile, self._glbData[fileNumber])
    else: # assume this is for all files in the entry
      for fileNo in getKeys(self._dataRoot, float):
        dataRoot = self._dataRoot[fileNo]
        self._glbData[fileNo] = FileManFileData(fileNo,
                                                schemaFile.getFileManName())
        self._parseDataBySchema(dataRoot, schemaFile, self._glbData[fileNo])
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
    return
    """ Replace self-reference with meaningful data """
    selfRefPtr = set()
    for fileNo in self._glbData.iterkeys():
      fileManData = self._glbData[fileNo]
      for ien in fileManData.dataEntries:
        dataEntry = fileManData.dataEntries[ien]
        for fileField in dataEntry.fields.itervalues():
          if fileField.type == FileManField.FIELD_TYPE_FILE_POINTER:
            pass

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
              self._parseSingleDataValueField(curDataRoot, fieldAttr,
                                              outDataEntry)
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

    outDataEntry.addField(FileManDataField(fieldAttr.getFieldNo(),
                                          fieldAttr.getType(),
                                          fieldAttr.getName(),
                                          fieldDetail))
    if fieldAttr.getFieldNo() == '.01':
      logging.debug("Setting dataEntry name as %s" % fieldDetail)
      outDataEntry.name = fieldDetail
    logging.debug("%s: %s" % (fieldAttr.getName(), fieldDetail))

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

  def outputFileManData(self, html=False):
    fileManDataMap = self._glbData
    for fileNo in getKeys(fileManDataMap.iterkeys(), float):
      fileManData = fileManDataMap[fileNo]
      if not html:
        printFileManFileData(fileManData)
      else:
        if fileNo == '8994':
          if self._crossRef:
            allPackages = self._crossRef.getAllPackages()
            for package in allPackages.itervalues():
              if package.rpcs:
                logging.info("generating RPC list for package: %s" % package.getName())
                generateRPCListHtml(package.rpcs, package.getName())
          convertFileManDataToHtml(fileManData)


def testGlobalParser(crosRef=None):
  parser = createArgParser()
  result = parser.parse_args()
  print result
  from InitCrossReferenceGenerator import parseCrossRefGeneratorWithArgs
  crosRef = parseCrossRefGeneratorWithArgs(result)
  schemaParser = FileManSchemaParser()
  allSchemaDict = schemaParser.parseSchemaDDFile(result.ddFile)
  glbDataParser = FileManGlobalDataParser(crosRef)
  glbDataParser.parseZWRGlobalDataBySchema(result.gdFile,
                                           allSchemaDict,
                                           result.fileNo,
                                           result.subscript)
  glbDataParser.outputFileManData(html=True)


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
  return parser


def main():
  from LogManager import initConsoleLogging
  initConsoleLogging(formatStr='%(message)s')
  #test_horologToDateTime()
  #test_FileManDataEntry()
  testGlobalParser()

if __name__ == '__main__':
  main()
