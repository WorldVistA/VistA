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

import xlrd
from xlrd import open_workbook,cellname,xldate_as_tuple
from datetime import datetime, date, time
import csv
import logging
import json
import re

def test_sheet(test_xls):
  book = open_workbook(test_xls)
  sheet0 = book.sheet_by_index(0)
  for rx in range(sheet0.nrows):
    for col_index in range(sheet0.ncols):
      print sheet0.cell(rx, col_index)
  # print sheet0.row(0)
  # print sheet0.col(0)
  # print
  # print sheet0.row_slice(0,1)
  # print sheet0.row_slice(0,1,2)
  # print sheet0.row_values(0,1)
  # print sheet0.row_values(0,1,2)
  # print sheet0.row_types(0,1)
  # print sheet0.row_types(0,1,2)

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

def convertToInt(value,index):
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
    bffName = "None"
    for bffValue in re.split("(,[ ]+|^)[0-9]+: ",value):
      bffValue = bffValue.strip()
      if re.match(',[ ]*',bffValue) or (bffValue == ''):
        continue
      if not (bffValue in returnArray):
        returnArray.append(bffValue);
      if not (bffValue in rootNode):
        rootNode[bffValue] = []
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

def RequirementsFieldsConvertFunc(x):
  if x in RequirementsFieldsConvert:
    return RequirementsFieldsConvert[x]
  return x

def convertExcelToJson(input, output):
  book = open_workbook(input)
  sheet = book.sheet_by_index(0)
  data_row = 1
  row_index= 0
  fields = None
  all_nodes = dict(); # all the nodes
  fields = sheet.row_values(row_index)
  fields = map(RequirementsFieldsConvertFunc, fields)
  # Read rest of the BFF data from data_row
  for row_index in xrange(data_row, sheet.nrows):
    curNode = dict()
    curNode['isRequirement'] = True
    for col_index in xrange(sheet.ncols):
      cell = sheet.cell(row_index, col_index)
      cType = cell.ctype
      convFunc = typeDictConvert.get(cell.ctype)
      cValue = cell.value
      if convFunc:
        cValue = convFunc(cValue,col_index)
      if not cValue:
        continue
      if type(cValue) == unicode:
        cValue = re.sub(r'[^\x00-\x7F]+','', cValue) #cValue.decode('unicode_escape').encode('ascii','ignore')
      curNode[fields[col_index]] = cValue
    if type(curNode['BFFlink']) is list:
      for BFFlink in curNode['BFFlink']:
        rootNode[BFFlink].append(curNode)
    else:
      rootNode[curNode['BFFlink']].append(curNode)

  with open(output, "w") as outputJson:
    json.dump(rootNode, outputJson)

def main():
  import argparse
  parser = argparse.ArgumentParser("Convert Requirements Excel SpreadSheet to JSON")
  parser.add_argument('input', help='input Requirements excel spreadsheet')
  parser.add_argument('output', help='output JSON file')
  result = parser.parse_args()
  convertExcelToJson(result.input, result.output)

if __name__ == '__main__':
  main()