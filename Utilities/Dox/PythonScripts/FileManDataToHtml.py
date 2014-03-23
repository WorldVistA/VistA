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
import glob
import cgi
import re
import json

FILE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(FILE_DIR, "../../../Scripts"))
print SCRIPTS_DIR
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)

from FileManDateTimeUtil import fmDtToPyDt
from ZWRGlobalParser import getKeys
from CrossReference import FileManField
from WebPageGenerator import getRoutineHtmlFileName, normalizePackageName
from WebPageGenerator import getPackageHtmlFileName

def safeFileName(name):
  """ convert to base64 encoding """
  import base64
  return base64.urlsafe_b64encode(name)

def safeElementId(name):
  import base64
  """
  it turns out that '=' is not a valid html element id
  remove the padding
  """
  return base64.b64encode(name, ["_", "_"]).replace('=','')
"""
  html header using JQuery Table Sorter Plugin
  http://tablesorter.com/docs/
"""

table_sorter_header="""
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

"""
  html header using JQuery DataTable Plugin
  https://datatables.net/
"""
data_table_reference = """
<link rel="stylesheet" href="../datatable/css/demo_page.css" type="text/css" id=""/>
<link rel="stylesheet" href="../datatable/css/demo_table.css" type="text/css" id=""/>
<link rel="stylesheet" href="../style.css" type="text/css" id=""/>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../datatable/js/jquery.dataTables.js"></script>
"""

from string import Template

data_table_list_init_setup = Template("""
<script type="text/javascript" id="js">
  $$(document).ready(function() {
  // call the tablesorter plugin
      $$("#${tableName}").dataTable({
        "bInfo": true,
        "iDisplayLength": 25,
        "sPaginationType": "full_numbers",
        "bStateSave": true,
        "bAutoWidth": true
      });
}); </script>
""")

data_table_large_list_init_setup = Template("""
<script type="text/javascript" id="js">
  $$(document).ready(function() {
  // call the tablesorter plugin
      $$("#${tableName}").dataTable({
        "bProcessing": true,
        "bStateSave": true,
        "iDisplayLength": 10,
        "sPaginationType": "full_numbers",
        "bDeferRender": true,
        "sAjaxSource": "${ajexSrc}"
      });
}); </script>
""")

data_table_record_init_setup = Template("""
<script type="text/javascript" id="js">
  $$(document).ready(function() {
  // call the tablesorter plugin
      $$("#${tableName}").dataTable({
        "bPaginate": false,
        "bLengthChange": false,
        "bInfo": false,
        "bStateSave": true,
        "bSort": false
      });
}); </script>
""")

def test_sub():
  print data_table_large_list_init_setup.substitute(ajexSrc="Test", tableName="Test")
  print data_table_list_init_setup.substitute(tableName="Test")
  print data_table_record_init_setup.substitute(tableName="Test")

def outputDataListTableHeader(output, tName):
  output.write("%s\n" % data_table_reference)
  initSet = data_table_list_init_setup.substitute(tableName=tName)
  output.write("%s\n" % initSet)

def outputLargeDataListTableHeader(output, src, tName):
  output.write("%s\n" % data_table_reference)
  initSet = data_table_large_list_init_setup.substitute(ajexSrc=src,
                                                        tableName=tName)
  output.write("%s\n" % initSet)

def outputDataRecordTableHeader(output, tName):
  output.write("%s\n" % data_table_reference)
  initSet = data_table_record_init_setup.substitute(tableName=tName)
  output.write("%s\n" % initSet)

def outputFileEntryTableList(output, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName)
  output.write("<thead>\n")
  output.write("<tr>\n")
  for name in ("Name", "Value"):
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</thead>\n")

dox_url = "http://code.osehra.org/dox/"
def getDataEntryHtmlFile(dataEntry, ien, fileNo):
  entryName = str(dataEntry.name)
  return getDataEntryHtmlFileByName(entryName, ien, fileNo)

def getDataEntryHtmlFileByName(entryName, ien, fileNo):
  entryName = entryName[:20] # max 20 chars
  return ("%s-%s" % (fileNo, ien)) + ".html"

def getFileHtmlLink(dataEntry, value, **kargs):
  entryName = str(value)
  htmlFile = getDataEntryHtmlFileByName(entryName, dataEntry.ien,
                                        dataEntry.fileNo)
  return "<a href=\"%s\">%s</a>" % (htmlFile, value)
def getRoutineName(inputString):
  tagRoutine = inputString.split('^')
  if len(tagRoutine) == 1:
    return inputString
  else:
    return tagRoutine[-1]
def getRoutineHRefLink(dataEntry, routineName, **kargs):
  rtnName = getRoutineName(routineName)
  crossRef = None
  if 'crossRef' in kargs:
    crossRef = kargs['crossRef']
    if crossRef and not crossRef.getRoutineByName(rtnName):
      return routineName
  pos = routineName.find(rtnName)
  return routineName[:pos] + "<a href=\"%s%s\">%s</a>" % (dox_url,
                                      getRoutineHtmlFileName(rtnName),
                                      rtnName) + routineName[pos+len(rtnName):]
def getPackageHRefLink(pkgName):
  value = "<a href=\"%s%s\">%s</a>" % (dox_url,
                                       getPackageHtmlFileName(pkgName),
                                       pkgName)
  return value

def getWordProcessingDataBrief(dataEntry, value, **kargs):
  return getWordProcessingData(value, False)
def getWordProcessingData(value, isList=True):
  outValue = " ".join(value)
  if isList:
    outValue = "<pre>\n" + cgi.escape(outValue) + "\n</pre>\n"
  return outValue
def getFileManFilePointerLink(dataEntry, value, **kargs):
  if value:
    fields = value.split('^')
    if len(fields) == 3: # fileNo, ien, name
      refFile = getDataEntryHtmlFileByName(fields[2], fields[1], fields[0])
      value = '<a href="%s">%s</a>' % (refFile, fields[-1])
    elif len(fields) == 2:
      value = 'File: %s, IEN: %s' % (fields[0], fields[1])
    else:
      logging.error("Unknown File Pointer Value %s" % value)
  return value
"""
fields and logic to convert to html for RPC List
"""
rpc_list_fields = (
       ("Name", '.01', getFileHtmlLink), # Name
       ("Tag", '.02', None), # Tag
       ("Routine", '.03', getRoutineHRefLink), # Routine
       ("Availability", '.05', None),# Availability
       #("Description", '1', getWordProcessingDataBrief),# Description
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
       #("Description", '3.5', getWordProcessingDataBrief), # Description
   )
def outputDataTableHeader(output, name_list, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName)
  output.write("<thead>\n")
  output.write("<tr>\n")
  for name in name_list:
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</thead>\n")

def outputCustomDataTableHeader(output, name_list, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName)
  output.write("<thead>\n")
  for name in name_list:
    output.write("<tr>\n")
    output.write("%s\n" % name)
    output.write("</tr>\n")
  output.write("</thead>\n")

def writeTableListInfo(output, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName)
  output.write("<thead>\n")
  output.write("<tr>\n")
  for name in ("Name", "IEN"):
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</thead>\n")
def isFilePointerType(dataEntry):
  if dataEntry and dataEntry.type:
    return ( dataEntry.type == FileManField.FIELD_TYPE_FILE_POINTER or
             dataEntry.type == FileManField.FIELD_TYPE_VARIABLE_FILE_POINTER )
  return False
regexRtnCode = re.compile("( ?D |[ :']\$\$)(?P<tag>([A-Z0-9][A-Z0-9]*)?)\^(?P<rtn>[A-Z%][A-Z0-9]+)")
def getMumpsRoutineHtmlLinks(inputString, crosRef=None):
  """
    For a giving Mumps code, it use regular expression
    to parse the code section and identify all the possible routines
    and covert html routines to html format
  """
  output = ""
  pos = 0
  endpos = 0
  for result in regexRtnCode.finditer(inputString):
    if result:
      routine = result.group('rtn')
      if routine:
        tag = result.group('tag')
        start, end = result.span('rtn')
        endpos = result.end()
        output += (inputString[pos:start] +
                   getRoutineHRefLink(None, routine, crossRef=crosRef) +
                   inputString[end:endpos])
        pos = endpos
  if endpos != 0 and endpos < len(inputString):
    output += inputString[endpos:]
  if output:
    return output
  else:
    return inputString
def convertFilePointerToHtml(inputValue):
  value = inputValue
  name = inputValue
  fields = inputValue.split('^')
  if len(fields) == 3: # fileNo, ien, name
    refFile = getDataEntryHtmlFileByName(fields[2], fields[1], fields[0])
    value = '<a href="%s">%s</a>' % (refFile, fields[-1])
    name = fields[-1]
  elif len(fields) == 2:
    value = 'File: %s, IEN: %s' % (fields[0], fields[1])
    name = value
  else:
    logging.error("Unknown File Pointer Value %s" % inputValue)
  return value, name
def test_convertFilePointerToHtml():
  input = ('1^345^Testing', '2^345', '5')
  for one in input:
    print convertFilePointerToHtml(one)

class FileManDataToHtml(object):
  """
    class to Genetate HTML pages based on FileManData
  """
  def __init__(self, crossRef, outDir):
    self.crossRef = crossRef
    self.outDir = outDir
  def outputFileManDataAsHtml(self, fileManDataMap):
    """
      This is the entry pointer to generate Html output
      format based on FileMan Data object
      @TODO: integrate with FileManFileOutputFormat.py
    """
    outDir = self.outDir
    crossRef = self.crossRef
    for fileNo in getKeys(fileManDataMap.iterkeys(), float):
      fileManData = fileManDataMap[fileNo]
      if fileNo == '8994':
        if crossRef:
          allPackages = crossRef.getAllPackages()
          allRpcs = []
          for package in allPackages.itervalues():
            if package.rpcs:
              logging.info("generating RPC list for package: %s"
                           % package.getName())
              self._generateRPCListHtml(package.rpcs, package.getName())
              allRpcs.extend(package.rpcs)
          if allRpcs:
            self._generateRPCListHtml(allRpcs, "All")
      elif fileNo == '101':
        if crossRef:
          allPackages = crossRef.getAllPackages()
          allHl7s = []
          for package in allPackages.itervalues():
            if package.hl7:
              logging.info("generating HL7 list for package: %s"
                           % package.getName())
              self._generateHL7ListByPackage(package.hl7, package.getName())
              allHl7s.extend(package.hl7)
          if allHl7s:
            self._generateHL7ListByPackage(allHl7s, "All")
      elif fileNo == '19':
        """ generate all option list """
        allOptionList = []
        allMenuList = []
        for ien in getKeys(fileManData.dataEntries.keys(), float):
          dataEntry = fileManData.dataEntries[ien]
          allOptionList.append(dataEntry)
          if '4' in dataEntry.fields:
            if dataEntry.fields['4'].value == 'menu':
              allMenuList.append(dataEntry)
          else:
            logging.error("ien: %s of file 19 does not have a type" % ien)
        self._generateDataListByPackage(allOptionList, "All", option_list_fields,
                                        "Option")
        self._generateDataListByPackage(allMenuList, "All", menu_list_fields,
                                        "Menu")
        self._generateMenuDependency(allMenuList, allOptionList)
      self._generateDataTableHtml(fileManData, fileNo)
      self._convertFileManDataToHtml(fileManData)

  def _generateMenuDependency(self, allMenuList, allOptionList):
    menuDict = dict((x.ien, x) for x in allOptionList)
    menuDepDict = dict((x, set()) for x in allMenuList)
    for dataEntry in allMenuList:
      if '10' in dataEntry.fields:
        menuData = dataEntry.fields['10'].value
        if menuData and menuData.dataEntries:
          for subIen in menuData.dataEntries:
            subEntry = menuData.dataEntries[subIen]
            value = subEntry.name
            childIen = value.split('^')[1]
            if childIen in menuDict:
              menuDepDict[dataEntry].add(menuDict[childIen])
              logging.info("Adding %s to %s" % (menuDict[childIen].name,
                                                dataEntry.name))
            else:
              logging.error("Could not find %s: value: %s" % (childIen, value))
    """ discard any menu does not have any child """
    leafMenus = set()
    for entry in menuDepDict:
      if len(menuDepDict[entry]) == 0:
        leafMenus.add(entry)
    for entry in leafMenus:
      del menuDepDict[entry]
    """ find the top level menu, menu without any parent """
    allChildSet = reduce(set.union, menuDepDict.itervalues())
    rootSet = set(allMenuList) - allChildSet
    leafSet = allChildSet - set(allMenuList)
    for rootMenu in rootSet:
      logging.info("Root Menu: %s, %s" % (rootMenu.name, rootMenu.ien))
    for leafMenu in leafSet:
      logging.info("leaf Menu: %s, %s" % (leafMenu.name, leafMenu.ien))

    """ generate the json file based on root menu """
    for item in rootSet:
      outJson = {}
      outJson['name'] = item.name
      outJson['ien'] = item.ien
      if '1' in item.fields:
        outJson['name'] = item.fields['1'].value
        outJson['option'] = item.name
      if '3' in item.fields:
        outJson['lock'] = item.fields['3'].value
      if item in menuDepDict:
        self._addChildMenusToJson(menuDepDict[item], menuDepDict, outJson)
      with open(os.path.join(self.outDir, "VistAMenu-%s.json" % item.ien), 'w') as output:
        logging.info("Generate File: %s" % output.name)
        json.dump(outJson, output)

  def _addChildMenusToJson(self, children, menuDepDict, outJson):
    for item in children:
      childDict = {}
      childDict['name'] = item.name
      childDict['ien'] = item.ien
      if '1' in item.fields:
        childDict['name'] = item.fields['1'].value
        childDict['option'] = item.name
      if '3' in item.fields:
        childDict['lock'] = item.fields['3'].value
      if item in menuDepDict:
        self._addChildMenusToJson(menuDepDict[item], menuDepDict, childDict)
      logging.debug("Adding child %s to parent %s" % (childDict['name'], outJson['name']))
      outJson.setdefault('children',[]).append(childDict)
  def _generateRPCListHtml(self, dataEntryLst, pkgName):
    """
      Specific logic to handle RPC List
      @TODO move the logic to a specific file
    """
    return self._generateDataListByPackage(dataEntryLst,
                                     pkgName, rpc_list_fields, "RPC")

  def _generateHL7ListByPackage(self, dataEntryLst, pkgName):
    """
      Specific logic to handle HL7 List
      @TODO move the logic to a specific file
    """
    return self._generateDataListByPackage(dataEntryLst, pkgName,
                                           hl7_list_fields, "HL7",
                                           hl7_table_header_fields)

  def _generateDataListByPackage(self, dataEntryLst, pkgName, list_fields,
                                 listName, custom_header=None):
    outDir = self.outDir
    with open("%s/%s-%s.html" % (outDir, pkgName, listName), 'w+') as output:
      output.write("<html>\n")
      tName = safeElementId("%s-%s" % (listName, pkgName))
      outputDataListTableHeader(output, tName)
      output.write("<body id=\"dt_example\">")
      output.write("""<div id="container" style="width:80%">""")
      output.write("<h1>Package: %s %s List</h1>" %
                   (getPackageHRefLink(pkgName), listName))
      if not custom_header:
        outputDataTableHeader(output, [x[0] for x in list_fields], tName)
      else:
        outputCustomDataTableHeader(output, custom_header, tName)
      """ table body """
      output.write("<tbody>\n")
      for dataEntry in dataEntryLst:
        tableRow = [""]*len(list_fields)
        allFields = dataEntry.fields
        output.write("<tr>\n")
        for idx, id in enumerate(list_fields):
          if id[1] in allFields:
            value = allFields[id[1]].value
            if id[-1]:
              value = id[-1](dataEntry, value, crossRef=self.crossRef)
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
  def _generateDataTableHtml(self, fileManData, fileNo):
    outDir = self.outDir
    isLargeFile = len(fileManData.dataEntries) > 4500
    tName = normalizePackageName(fileManData.name)
    with open("%s/%s.html" % (outDir, fileNo), 'w') as output:
      output.write("<html>\n")
      if isLargeFile:
        ajexSrc = "%s_array.txt" % fileNo
        outputLargeDataListTableHeader(output, ajexSrc, tName)
      else:
        outputDataListTableHeader(output, tName)
      output.write("<body id=\"dt_example\">")
      output.write("""<div id="container" style="width:80%">""")
      output.write("<h1>File %s(%s) Data List</h1>" % (tName, fileNo))
      writeTableListInfo(output, tName)
      if not isLargeFile:
        output.write("<tbody>\n")
        for ien in getKeys(fileManData.dataEntries.keys(), float):
          dataEntry = fileManData.dataEntries[ien]
          if not dataEntry.name:
            logging.warn("no name for %s" % dataEntry)
            continue
          name = dataEntry.name
          if isFilePointerType(dataEntry):
            link, name = convertFilePointerToHtml(dataEntry.name)
          dataHtmlLink = "<a href=\"%s\">%s</a>" % (getDataEntryHtmlFile(dataEntry, ien, fileNo),
                                                    name)
          tableRow = [dataHtmlLink, dataEntry.ien]
          output.write("<tr>\n")
          """ table body """
          for item in tableRow:
            output.write("<td>%s</td>\n" % item)
          output.write("</tr>\n")
      output.write("</tbody>\n")
      output.write("</table>\n")
      output.write("</div>\n")
      output.write("</div>\n")
      output.write ("</body></html>\n")
    if isLargeFile:
      logging.info("Ajex source file: %s" % ajexSrc)
      """ Write out the data file in JSON format """
      outJson = {"aaData": []}
      with open(os.path.join(outDir, ajexSrc), 'w') as output:
        outArray =  outJson["aaData"]
        for ien in getKeys(fileManData.dataEntries.keys(), float):
          dataEntry = fileManData.dataEntries[ien]
          if not dataEntry.name:
            logging.warn("no name for %s" % dataEntry)
            continue
          name = dataEntry.name
          if isFilePointerType(dataEntry):
            link, name = convertFilePointerToHtml(dataEntry.name)
          dataHtmlLink = "<a href=\"%s\">%s</a>" % (getDataEntryHtmlFile(dataEntry, ien, fileNo),
                                                    name)
          outArray.append([dataHtmlLink, ien])
        json.dump(outJson, output)

  def _convertFileManDataToHtml(self, fileManData):
    outDir = self.outDir
    for ien in getKeys(fileManData.dataEntries.keys(), float):
      tName = safeElementId("%s-%s" % (fileManData.fileNo, ien))
      dataEntry = fileManData.dataEntries[ien]
      if not dataEntry.name:
        logging.warn("no name for %s" % dataEntry)
        continue
      name = dataEntry.name
      if isFilePointerType(dataEntry):
        link, name = convertFilePointerToHtml(dataEntry.name)
      outHtmlFileName = getDataEntryHtmlFile(dataEntry, ien, fileManData.fileNo)
      with open("%s/%s" % (outDir, outHtmlFileName), 'w') as output:
        output.write ("<html>")
        outputDataRecordTableHeader(output, tName)
        output.write("<body id=\"dt_example\">")
        output.write("""<div id="container" style="width:80%">""")
        output.write ("<h1>%s (%s) &nbsp;&nbsp;  %s (%s)</h1>\n" % (name, ien,
                                                          fileManData.name,
                                                          fileManData.fileNo))
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
      output.write ("<li>\n")
    for fldId in sorted(dataEntry.fields.keys(), key=lambda x: float(x)):
      dataField = dataEntry.fields[fldId]
      fieldType = dataField.type
      name, value = dataField.name, dataField.value
      if fieldType == FileManField.FIELD_TYPE_MUMPS:
        value = getMumpsRoutineHtmlLinks(value, self.crossRef)
      elif fieldType == FileManField.FIELD_TYPE_FREE_TEXT and dataField.name.find("ROUTINE") >=0:
        value = getRoutineHRefLink(dataEntry, str(value), crossRef=self.crossRef)
      elif fieldType == FileManField.FIELD_TYPE_SUBFILE_POINTER:
        if value and value.dataEntries:
          if isRoot:
            output.write ("<tr>\n")
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

def test_safeElementId():
  for input in ("01", "1.0", "99999.4"):
    print safeElementId(input)

def test_getRoutineName():
  for input in (
      '%ZTLOAD',
      '^%ZTLOAD1',
      'TST^ZNTLFF',
      ):
    print getRoutineName(input)

def test_getMumpsRoutineHtmlLink():
  for input in (
    'D ^TEST1',
    'D ^%ZOSV',
    'D TAG^TEST2',
    'Q $$TST^%RRST1',
    'D ACKMSG^DGHTHLAA',
    'S XQORM(0)="1A",XQORM("??")="D HSTS^ORPRS01(X)"',
    'I $$TEST^ABCD D ^EST Q:$$ENG^%INDX K ^DD(0)',
    'S DUZ=1 K ^XUTL(0)',
    """W:'$$TM^%ZTLOAD() *7,!!,"WARNING -- TASK MANAGER DOESN'T!!!!",!!,*7""",
  ):
    print getMumpsRoutineHtmlLinks(input)

def main():
  test_sub()
  test_safeElementId()
  test_convertFilePointerToHtml()
  test_getMumpsRoutineHtmlLink()
  test_getRoutineName()

if __name__ == '__main__':
  main()
