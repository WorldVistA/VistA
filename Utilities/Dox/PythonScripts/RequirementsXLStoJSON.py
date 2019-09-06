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

from past.builtins import basestring
from builtins import map
from builtins import range
import xlrd
from xlrd import open_workbook, cellname, xldate_as_tuple
from datetime import datetime, date, time
import csv
import json
import re
import sys

rootNode = {}
rootNode["None"] = []

typeDict = {
  xlrd.XL_CELL_NUMBER: "Number",
  xlrd.XL_CELL_TEXT: "Text",
  xlrd.XL_CELL_DATE: "Date",
  xlrd.XL_CELL_BLANK: "Blank",
  xlrd.XL_CELL_EMPTY: "Empty",
  xlrd.XL_CELL_ERROR: "Error",
  xlrd.XL_CELL_BOOLEAN: "Boolean",
}

def convertToInt(value, index):
  try:
    return int(value)
  except ValueError as ve:
    return value

def convertToDate(value):
  date_value = xldate_as_tuple(value, 0)
  return datetime(*date_value).strftime("%Y-%m-%d")

def convertToBool(value):
  if value:
    return "TRUE"
  return "FALSE"

# Removes any bracketed numbers from the name, if it exists
def checkEmpty(value, index):
  if index == 5:
    return ["None"]

def parseStringVal(value, index):
  if index == 5:
    returnArray=[]
    for bffValue in re.split("(,[ ]+|^)[0-9]+: ", value):
      bffValue = bffValue.strip()
      if re.match(',[ ]*', bffValue) or (bffValue == ''):
        continue
      if not (bffValue in returnArray):
        returnArray.append(bffValue);
      if not (bffValue in rootNode):
        rootNode[bffValue] = []
    return returnArray
  elif index == 4:
    returnArray=[]
    for nsrEntry in value.split("\n"):
      if not (nsrEntry in returnArray):
        returnArray.append(nsrEntry);
    return returnArray
  if not (value.find(" [") == -1):
    return value[:value.find(" [")]
  return value

typeDictConvert = {
  xlrd.XL_CELL_NUMBER: convertToInt,
  xlrd.XL_CELL_TEXT: parseStringVal,
  xlrd.XL_CELL_DATE: convertToDate,
  xlrd.XL_CELL_BLANK: checkEmpty,
  xlrd.XL_CELL_EMPTY: checkEmpty,
  xlrd.XL_CELL_ERROR: None,
  xlrd.XL_CELL_BOOLEAN: convertToBool,
}

# convert the excel name fields to standard json output name
RequirementsFieldsConvert = {
  "RDM RDNG ID" : 'busNeedId',
  "ID" : 'busNeedId',
  "ARTIFACT TYPE" : 'type',
  "RDNG Artifact" : 'type',
  "NAME" : 'name',
  "PRIMARY TEXT": 'description',
  "NEW SERVICE REQUEST (NSR)": 'NSRLink',
  "BUSINESS FUNCTION (BFF)":"BFFlink",
  "Summary" : 'name',
  "Full Description": 'description',
  "NSR": 'NSRLink',
  "Associated BFF(s)":"BFFlink"
}

def checkReqForUpdate(curNode, pastJSONObj, curDate):
  diffFlag=False
  foundDate = curDate
  noHistory=False;
  BFFList = []
  if isinstance(curNode['BFFlink'], list):
    for BFFlink in curNode['BFFlink']:
      BFFList.append(BFFlink)
  else:
    BFFList.append(curNode['BFFlink'])
  # Check past information for the object and compare the two
  # Remove all recentUpdate attributes
  for BFFEntry in BFFList:
    if pastJSONObj:
      diffFlag=False;
      noHistory=False;
      if BFFEntry in pastJSONObj:
        ret = [x for x in pastJSONObj[BFFEntry] if x['name'] == curNode['name']]
        if ret:
          for entry in ret:
            diffFlag=False
            if "dateUpdated" in entry:
              foundDate=entry["dateUpdated"]
            for val in curNode:
              if val in ["recentUpdate", "dateUpdated"]:
                continue
              oldVal = entry[val] if (val in entry) else None
              newVal = curNode[val]
              if isinstance(oldVal, list):
                oldVal.sort()
                newVal.sort()
              if not (oldVal == newVal):
                diffFlag= True
          else:
            noHistory = True
    if diffFlag:
      curNode['recentUpdate'] = "Update"
      curNode['dateUpdated']  = curDate
    else:
      curNode['recentUpdate'] = "None" if (noHistory) else "New Requirement"
      curNode['dateUpdated']= foundDate
    rootNode[BFFEntry].append(curNode)

def RequirementsFieldsConvertFunc(x):
  if x in RequirementsFieldsConvert:
    return RequirementsFieldsConvert[x]
  return x

def convertExcelToJson(input, output, pastData, curDate):
  pastJSONObj={}
  if pastData:
    with open(pastData, "r") as pastJSON:
      pastJSONObj = json.load(pastJSON)
  book = open_workbook(input)
  sheet = book.sheet_by_index(0)
  data_row = 1
  row_index= 0
  fields = None
  all_nodes = dict(); # all the nodes
  fields = sheet.row_values(row_index)
  fields = list(map(RequirementsFieldsConvertFunc, fields))
  # Read rest of the BFF data from data_row
  for row_index in range(data_row, sheet.nrows):
    curNode = dict()
    curNode['isRequirement'] = True
    curNode['isRequirement'] = True
    for col_index in range(sheet.ncols):
      cell = sheet.cell(row_index, col_index)
      cType = cell.ctype
      convFunc = typeDictConvert.get(cell.ctype)
      cValue = cell.value
      replaceFlag = False
      try:
          replaceFlag = isinstance(cValue, basestring)
      except NameError:
          replaceFlag = isinstance(cValue, str)
      if replaceFlag:
        cValue = re.sub(r'[^\x00-\x7F]+', '', cValue) #cValue.decode('unicode_escape').encode('ascii','ignore')
      if convFunc:
        cValue = convFunc(cValue, col_index)
      if not cValue:
        continue
      curNode[fields[col_index]] = cValue
    checkReqForUpdate(curNode, pastJSONObj, curDate)

  with open(output, "w") as outputJson:
    json.dump(rootNode, outputJson)
