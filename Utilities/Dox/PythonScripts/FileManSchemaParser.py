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
from CrossReference import FileManFile, FileManFieldFactory
from CrossReference import FileManField
from ZWRGlobalParser import createGlobalNodeByZWRFile, getKeys

"""
  Utility Function to set the Type/Specifier
"""
def setTypeAndSpecifer(types, specifier, values):
  if values and len(values) == 3:
    if values[0]: types.append(values[0])
    if values[1]: types.append(values[1])
    if values[2]: specifier.append(values[2])
"""
  A Tuple of four elements:
  1. Matching string
  3. Function to set some type, specifier.
  4. Argument function if present, in the form of
     (Type, subType, Specifier)
"""
FIELD_TYPE_MAP_LIST = (
  ('Cm', setTypeAndSpecifer, (FileManField.FIELD_TYPE_COMPUTED,
                              None,
                              FileManField.FIELD_SPECIFIER_MULTILINE)),
  ('DC', setTypeAndSpecifer, (FileManField.FIELD_TYPE_COMPUTED,
                              FileManField.FIELD_TYPE_DATE_TIME,
                              None)),
  ('BC', setTypeAndSpecifer, (FileManField.FIELD_TYPE_COMPUTED,
                              FileManField.FIELD_TYPE_BOOLEAN,
                              None)),
  ('WL', setTypeAndSpecifer, (FileManField.FIELD_TYPE_WORD_PROCESSING,
                              None,
                              FileManField.FIELD_SPECIFIER_NO_WORD_WRAPPING)),
  ('C', setTypeAndSpecifer, (FileManField.FIELD_TYPE_COMPUTED,
                             None,
                             None)),
  ('D', setTypeAndSpecifer, (FileManField.FIELD_TYPE_DATE_TIME,
                             None,
                             None)),
  ('F', setTypeAndSpecifer, (FileManField.FIELD_TYPE_FREE_TEXT,
                             None,
                             None)),
  ('N', setTypeAndSpecifer, (FileManField.FIELD_TYPE_NUMBER,
                             None,
                             None)),
  ('P', setTypeAndSpecifer, (FileManField.FIELD_TYPE_FILE_POINTER,
                             None,
                             None)),
  ('S', setTypeAndSpecifer, (FileManField.FIELD_TYPE_SET,
                             None,
                             None)),
  ('W', setTypeAndSpecifer, (FileManField.FIELD_TYPE_WORD_PROCESSING,
                             None,
                             None)),
  ('V', setTypeAndSpecifer, (FileManField.FIELD_TYPE_VARIABLE_FILE_POINTER,
                             None,
                             None)),
  ('K', setTypeAndSpecifer, (FileManField.FIELD_TYPE_MUMPS,
                             None,
                             None)),
  ('A', setTypeAndSpecifer, (FileManField.FIELD_TYPE_SUBFILE_POINTER,
                             None,
                             FileManField.FIELD_SPECIFIER_NEW_ENTRY_NO_ASK)),
  ('M', setTypeAndSpecifer, (FileManField.FIELD_TYPE_SUBFILE_POINTER,
                             None,
                             FileManField.FIELD_SPECIFIER_NEW_ENTRY_ASK_ANOTHER)),
  ('R', setTypeAndSpecifer, (None,
                             None,
                             FileManField.FIELD_SPECIFIER_REQUIRED)),
  ('O', setTypeAndSpecifer, (None,
                             None,
                             FileManField.FIELD_SPECIFIER_OUTPUT_TRANSFORM)),
  ('a', setTypeAndSpecifer, (None,
                             None,
                             FileManField.FIELD_SPECIFIER_AUDIT)),
  ('e', setTypeAndSpecifer, (None,
                             None,
                             FileManField.FIELD_SPECIFIER_AUDIT_EDIT_DELETE)),
  ('I', setTypeAndSpecifer, (None,
                             None,
                             FileManField.FIELD_SPECIFIER_UNEDITABLE)),
  ('X', setTypeAndSpecifer, (None,
                             None,
                             FileManField.FIELD_SPECIFIER_EDIT_PROG_ONLY)),
)

class FileManSchemaParser(object):
  def __init__(self):
    self._allSchema = {} # a dict of all schema
    self._ddRoot = None # global Root by reading the zwr file
  def parseSchemaDDFile(self, inputDDZWRFile):
    self._ddRoot = createGlobalNodeByZWRFile(inputDDZWRFile)
    self._generateSchema()
    self._updateMultiple()
    return self._allSchema
  def _generateSchema(self):
    files = getKeys(self._ddRoot, float) # sort files by float value
    for file in files: # create all the files
      self._allSchema[file] = FileManFile(file, "")
    for file in files:
      self._generateFileSchema(self._ddRoot[file], self._allSchema[file])

  def _generateFileSchema(self, rootNode, fileSchema):
    for key in getKeys(rootNode, float):
      if key == '0': continue # ignore the fields 0
      field = self._parseSchemaField(key, rootNode[key], fileSchema)
      if field:
        fileSchema.addFileManField(field)

  def _parseSchemaField(self, fieldNo, rootNode, fileSchema):
    if '0' not in rootNode:
      logging.warn('%s does not have a 0 subscript' % rootNode)
      return None
    zeroFields = rootNode["0"].value # read the location first
    if not zeroFields or len(zeroFields) < 2:
      logging.warn("Invalid value: %s for %s" % (zeroFields, rootNode['0']))
      return None
    types, specifier, filePointedTo, subFile = self._parseFieldTypeSpecifier(zeroFields[1])
    location = None
    if zeroFields[3]:
      location = zeroFields[3].strip(' ')
      if location == ';': # No location information
        location = None
      elif location.split(';')[-1] == '0': # 0 means multiple
        multipleType = FileManField.FIELD_TYPE_SUBFILE_POINTER
        if not types:
          logging.debug('Set type to be multiple for %s' % zeroFields)
          types = [multipleType]
        if multipleType in types and types[0] != multipleType:
          logging.debug('Change type to be multiple for %s' % zeroFields)
          types.remove(multipleType)
          types.insert(0, multipleType)
          if not subFile: subFile = filePointedTo
    if not types:
      logging.warn('Can not determine the type for %s' % zeroFields)
      types = [FileManField.FIELD_TYPE_NONE]
    if types and types[0]  == FileManField.FIELD_TYPE_SUBFILE_POINTER:
      if subFile and subFile == fileSchema.getFileNo():
        logging.error("recursive subfile pointer for %s" % subFile)
        types = [FileManField.FIELD_TYPE_NONE]
    logging.debug('%s is %s, %s, %s, %s' %
                 (zeroFields[1], types, specifier, filePointedTo, subFile))
    fileField = FileManFieldFactory.createField(fieldNo, zeroFields[0], types[0], location)
    """ @TODO Set the specifier attributes """
    if specifier:
      fileField.setSpecifier(specifier)
      logging.debug("Adding specifier: %s to %r" % (specifier, fileField))
    if fileField.getType() == FileManField.FIELD_TYPE_FILE_POINTER:
      if filePointedTo:
        if filePointedTo in self._allSchema:
          fileField.setPointedToFile(self._allSchema[filePointedTo])
        else:
          logging.warn("Could not find pointed to file: %s" % filePointedTo)
      else:
        logging.warn("No pointed to file set for file:%s: field:%r 0-index:%s" %
                     (fileSchema.getFileNo(), fileField, zeroFields))
    elif fileField.getType() == FileManField.FIELD_TYPE_SUBFILE_POINTER:
      if subFile:
        if subFile in self._allSchema:
          subFileSchema = self._allSchema[subFile]
          subFileSchema.setParentFile(fileSchema)
          fileSchema.addFileManSubFile(subFileSchema)
          fileField.setPointedToSubFile(subFileSchema)
        else:
          logging.warn("Could not find subfile: %s" % subFile)
      else:
        logging.warn("No subfile is set for file:%s, field:%r 0-index:%s" %
                     (fileSchema.getFileNo(), fileField, zeroFields))
    elif fileField.getType() == FileManField.FIELD_TYPE_SET and not subFile:
      setDict = dict([x.split(':') for x in zeroFields[2].rstrip(';').split(';')])
      fileField.setSetMembers(setDict)
    elif fileField.getType() == FileManField.FIELD_TYPE_VARIABLE_FILE_POINTER:
      if "V" in rootNode: # parsing variable pointer
        vptrs = parsingVariablePointer(rootNode['V'])
        if vptrs:
          vpFileSchemas = [self._allSchema.get(x) for x in vptrs]
          fileField.setPointedToFiles(vpFileSchemas)
    return fileField

  @staticmethod
  def _parseFieldTypeSpecifier(typeField):
    if not typeField:
      return [FileManField.FIELD_TYPE_NONE], None, None, None
    filePointedTo = None
    result = re.search('P(?P<file>[0-9.]+)', typeField)
    if result:
      filePointedTo = result.group('file')
      float(filePointedTo)
    types, specifier = [], []
    for match, func, args in FIELD_TYPE_MAP_LIST:
      if match in typeField:
        func(types, specifier, args)
        typeField = typeField.replace(match,'') # get rid of the match
    subFile = None
    result = re.search('(?P<subFile>^[0-9.]+)', typeField)
    if result:
      subFile = result.group('subFile')
      if FileManField.FIELD_TYPE_FILE_POINTER in types:
        filePointedTo = subFile
        subFile = None
      elif FileManField.FIELD_TYPE_SUBFILE_POINTER not in types:
        types.insert(0, FileManField.FIELD_TYPE_SUBFILE_POINTER)
    return types, specifier, filePointedTo, subFile

  def _updateMultiple(self):
    allSchemaDict = self._allSchema
    for file, schema in allSchemaDict.iteritems():
      allFields = schema.getAllFileManFields()
      if not allFields:
        logging.warn("file: %s does not have any fields" % file)
        continue
      for field, detail in schema.getAllFileManFields().iteritems():
        if detail.getType() == FileManField.FIELD_TYPE_SUBFILE_POINTER:
          subFile = detail.getPointedToSubFile()
          if subFile:
            subFileNo = subFile.getFileNo()
            if subFileNo in allSchemaDict and subFile.hasField('.01'):
              subType = subFile.getField('.01').getType()
              if subType != FileManField.FIELD_TYPE_NONE:
                logging.debug('Adding subType %s to %r' % (subType, detail))
                detail.addSubType(subType)

  def parseSchemaFieldAttributes(self, zeroFields, rootNode):
    """ handle extra attributes"""
    if len(zeroFields) >= 5 and zeroFields[4]:
      inputTrans = ""
      for txt in zeroFields[4:]:
        inputTrans += txt
      print "\tInput Transform: %s" % inputTrans
    if "3" in rootNode and rootNode["3"].value is not None:
      print "\tHELP-PROMPT: %s" % rootNode['3'].value
    if "DT" in rootNode and rootNode["DT"].value is not None:
      print "\tLast Modified: %s" % rootNode["DT"].value
    if "9.1" in rootNode and rootNode["9.1"].value is not None:
      print "\tCompute Algorithm: %s" % rootNode["9.1"].value
    if "1" in rootNode:
      if '0' in rootNode["1"]:
        parseCrossReference(rootNode)
    if "21" in rootNode:
      print "Description:"
      parsingWordProcessingNode(rootNode['21'])
    if "DEL" in rootNode:
      print "DELETE TEST:"
      parsingDelTest(rootNode['DEL'])

def createArgParser():
  import argparse
  parser = argparse.ArgumentParser(description='FileMan Schema Parser')
  parser.add_argument('ddFile', help='path to ZWR file contains DD global')
  return parser

def testDDZWRFile():
  parser = createArgParser()
  result = parser.parse_args();
  schemaParse = FileManSchemaParser()
  allSchemaDict = schemaParse.parseSchemaDDFile(result.ddFile)
  # Find all the word processing multiple
  printAllSchemas(allSchemaDict)
  #from FileManGlobalDataParser import parseDataBySchema
  #parseDataBySchema(schemaParse._ddRoot['200'], allSchemaDict, '0')

def printAllSchemas(allSchemaDict):
  files = getKeys(allSchemaDict.keys(), float)
  for file in files:
    allSchemaDict[file].printFileManInfo()

def parseCrossReference(globalRoot):
  pass
  #printGlobal(globalRoot['1'])

def parsingVariablePointer(globalRoot):
  intKey = getKeys(globalRoot)
  outVptr = []
  for key in intKey:
    if '0' in globalRoot[key]:
      outVptr.append(globalRoot[key]['0'].value[0])
  return outVptr

def parsingDelTest(globalRoot):
  intKey = getKeys(globalRoot)
  for key in intKey:
    if '0' in globalRoot[key]:
      print "\t%s,0)= %s" % (key, globalRoot[key]['0'].value)

def parsingWordProcessingNode(globalNode, level=1):
  indent = "\t"*level
  logging.debug("Processing Word Processing Data")
  for key in sorted(globalNode, key=lambda x: int(x)):
    if "0" in globalNode[key]:
      logging.info ("%s%s" % (indent, globalNode[key]["0"].value))

def test_parseFieldTypeSpecifier():
  for typeField in (".2LAP", "M66.021A", "MP8994",
                    "Cm", "BC", '9002313.59902PA', 'RF'):
    print FileManSchemaParser()._parseFieldTypeSpecifier(typeField)

def main():
  from LogManager import initConsoleLogging
  initConsoleLogging(formatStr='%(message)s')
  #test_parseFieldTypeSpecifier()
  testDDZWRFile()

if __name__ == '__main__':
  main()
