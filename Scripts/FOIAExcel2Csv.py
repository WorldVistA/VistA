#---------------------------------------------------------------------------
# Copyright 2014-2019 The Open Source Electronic Health Record Alliance
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
from __future__ import print_function
from builtins import range
import xlrd
from xlrd import open_workbook,cellname,xldate_as_tuple
from datetime import datetime, date, time
import csv
import logging

def test_sheet(test_xls):
  book = open_workbook(test_xls)
  sheet0 = book.sheet_by_index(0)
  print(sheet0.row(0))
  print(sheet0.col(0))
  print()
  print(sheet0.row_slice(0,1))
  print(sheet0.row_slice(0,1,2))
  print(sheet0.row_values(0,1))
  print(sheet0.row_values(0,1,2))
  print(sheet0.row_types(0,1))
  print(sheet0.row_types(0,1,2))

typeDict = {
  xlrd.XL_CELL_NUMBER: "Number",
  xlrd.XL_CELL_TEXT: "Text",
  xlrd.XL_CELL_DATE: "Date",
  xlrd.XL_CELL_BLANK: "Blank",
  xlrd.XL_CELL_EMPTY: "Empty",
  xlrd.XL_CELL_ERROR: "Error",
  xlrd.XL_CELL_BOOLEAN: "Boolean",
}

def convertToInt(value):
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

typeDictConvert = {
  xlrd.XL_CELL_NUMBER: convertToInt,
  xlrd.XL_CELL_TEXT: None,
  xlrd.XL_CELL_DATE: convertToDate,
  xlrd.XL_CELL_BLANK: None,
  xlrd.XL_CELL_EMPTY: None,
  xlrd.XL_CELL_ERROR: None,
  xlrd.XL_CELL_BOOLEAN: convertToBool,
}

def convertExcelToCsv(input, output):
  book = open_workbook(input)
  sheet = book.sheet_by_index(0)
  isHeader = False
  data_row = 0
  fields = None
  for row_index in range(sheet.nrows):
    row_types = sheet.row_types(row_index)
    assert len(row_types) == sheet.ncols
    """ Try to identify the header of file """
    for idx,row_type in enumerate(row_types):
      if idx == 0 and (row_type == xlrd.XL_CELL_NUMBER or
                       row_type == xlrd.XL_CELL_TEXT):
        """ This is to fix a typo in FOIA excel sheet
            The first field should be ID, but right now
            It is 7.0 and it is a number type
        """
        isHeader = True
        continue
      elif row_type != xlrd.XL_CELL_TEXT:
        isHeader = False
        break
      else:
        isHeader = True
    if isHeader:
      data_row = row_index + 1
      fields = sheet.row_values(row_index)
      break
  if not isHeader:
    logging.error("No Valid Header for CSV file output")
    return
  with open(output, "w") as outCsv:
    csvWrt = csv.writer(outCsv, lineterminator="\n")
    csvWrt.writerow(fields)
    for row_index in range(data_row, sheet.nrows):
      curRow = []
      for col_index in range(sheet.ncols):
        cell = sheet.cell(row_index, col_index)
        name = cellname(row_index, col_index)
        cType = typeDict.get(cell.ctype, "Unknown")
        convFunc = typeDictConvert.get(cell.ctype)
        cValue = cell.value
        if convFunc:
          cValue = convFunc(cValue)
        curRow.append(cValue)
      """ get rid of rows just with ID field """
      if int(curRow[0]) and curRow[1:] == [''] * (len(curRow)-1):
        logging.debug("Ignore empty row %s " % curRow)
        continue
      csvWrt.writerow(curRow)
  with open(output, 'r') as csvFile:
    csvReader = csv.reader(csvFile)
    for row in csvReader:
      logging.debug(','.join(row))

def main():
  import argparse
  parser = argparse.ArgumentParser("Convert FOIA Excel SpreadSheet to csv")
  parser.add_argument('input', help='input excel spreadsheet')
  parser.add_argument('output', help='output csv file')
  result = parser.parse_args()
  print (result)
  convertExcelToCsv(result.input, result.output)

if __name__ == '__main__':
  main()
