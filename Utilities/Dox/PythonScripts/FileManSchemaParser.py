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
from ZWRGlobalParser import readGlobalNodeFromZWRFile, printGlobal

"""
  Utility Function to set the Type/Specifier
"""
def setTypeAndSpecifer(types, specifier, values):
  if values and len(values) == 3:
    if values[0] and values[0] not in types: types.append(values[0])
    if values[1] and values[1] not in types: types.append(values[1])
    if values[2] and values[2] not in specifier: specifier.append(values[2])
"""
  A Tuple of two elements:
  1. Matching string
  4. Argument if present, in the form of
     (Type, subType, Extra Specifier)
"""
FIELD_TYPE_MAP_LIST = (
  ('Cm',
   (FileManField.FIELD_TYPE_COMPUTED,
    None,
    FileManField.FIELD_SPECIFIER_MULTILINE)
  ),
  ('DC',
    (FileManField.FIELD_TYPE_COMPUTED,
     FileManField.FIELD_TYPE_DATE_TIME,
     None)
  ),
  ('BC',
    (FileManField.FIELD_TYPE_COMPUTED,
     FileManField.FIELD_TYPE_BOOLEAN,
     None)
  ),
  ('WL',
   (FileManField.FIELD_TYPE_WORD_PROCESSING,
    None,
    FileManField.FIELD_SPECIFIER_NO_WORD_WRAPPING)
  ),
  ('C',
   (FileManField.FIELD_TYPE_COMPUTED,
    None,
    None)
  ),
  ('D',
   (FileManField.FIELD_TYPE_DATE_TIME,
    None,
    None)
  ),
  ('F',
   (FileManField.FIELD_TYPE_FREE_TEXT,
    None,
    None)
  ),
  ('N',
   (FileManField.FIELD_TYPE_NUMBER,
    None,
    None)
  ),
  ('P',
   (FileManField.FIELD_TYPE_FILE_POINTER,
    None,
    None)
  ),
  ('S',
   (FileManField.FIELD_TYPE_SET,
    None,
    None)
  ),
  ('W',
    (FileManField.FIELD_TYPE_WORD_PROCESSING,
     None,
     None)
  ),
  ('V',
   (FileManField.FIELD_TYPE_VARIABLE_FILE_POINTER,
    None,
    None)
  ),
  ('K',
   (FileManField.FIELD_TYPE_MUMPS,
    None,
    None)
  ),
  ('A',
   (None,
    None,
    FileManField.FIELD_SPECIFIER_NEW_ENTRY_NO_ASK)
  ),
  ('M',
   (None,
    None,
    FileManField.FIELD_SPECIFIER_MULTIPLE_ASKED)
  ),
  ('R',
   (None,
    None,
    FileManField.FIELD_SPECIFIER_REQUIRED)
  ),
  ('O',
   (None,
    None,
    FileManField.FIELD_SPECIFIER_OUTPUT_TRANSFORM)
  ),
  ('a',
   (None,
    None,
    FileManField.FIELD_SPECIFIER_AUDIT)
  ),
  ('e',
   (None,
    None,
    FileManField.FIELD_SPECIFIER_AUDIT_EDIT_DELETE)
  ),
  ('I',
   (None,
    None,
    FileManField.FIELD_SPECIFIER_UNEDITABLE)
  ),
  ('X',
   (None,
    None,
    FileManField.FIELD_SPECIFIER_EDIT_PROG_ONLY)
  ),
  ('*',
   (None,
    None,
    FileManField.FIELD_SPECIFIER_POINTER_SCREEN)
  ),
)

class FileManSchemaParser(object):
  def __init__(self):
    self._allSchema = {} # a dict of all schema
    self._ddRoot = None # global Root by reading the zwr file
    self._zeroFiles = ['0'] # all file and subfile WRT file zero
    self._subFiles = set() # all the subFiles

  def _readZeroFile(self, inputDDZWRFile):
    for globalRoot in readGlobalNodeFromZWRFile(inputDDZWRFile):
      if '0' in globalRoot:
        printGlobal(globalRoot)
        break

  def parseSchemaDDFile(self, inputDDZWRFile):
    self._ddRoot = createGlobalNodeByZWRFile(inputDDZWRFile)
    assert self._ddRoot.subscript == "^DD"
    #self._generateFileZeroSchema()
    self._generateSchema()
    self._updateMultiple()
    return self._allSchema

  def parseSchemaDDFileV2(self, inputDDZWRFile):
    for ddRoot in readGlobalNodeFromZWRFile(inputDDZWRFile):
      self._ddRoot = ddRoot
      #logging.info("Printing Global Node:")
      #printGlobal(ddRoot)
      self._generateSchema()
    return self._allSchema
  def _generateFileZeroSchema(self):
    while (len(self._zeroFiles) > 0):
      file = self._zeroFiles.pop(0)
      if file not in self._allSchema:
        self._allSchema[file] = FileManFile(file, "")
      self._generateFileSchema(self._ddRoot[file], self._allSchema[file])

  def _generateSchema(self):
    files = getKeys(self._ddRoot, float) # sort files by float value
    logging.info("Parsing files %s" % files)
    for file in files:
      if file not in self._allSchema:
        self._allSchema[file] = FileManFile(file, "")
      self._generateFileSchema(self._ddRoot[file], self._allSchema[file])

  def _parseSubFilesNode(self, rootNode):
    """ Get the subFiles used in the file """
    for key in getKeys(rootNode['SB'], float):
      logging.info("Adding subfiles: %s" % key)
      assert key in self._allSchema
      assert self._allSchema[key].isSubFile()
      self._subFiles.add(key)
  def _generateFileSchema(self, rootNode, fileSchema):
    """
      handle the "PT" and "SB" subscript first
    """
    for key in getKeys(rootNode, float):
      if key == '0': continue # ignore the fields 0
      field = self._parseSchemaField(key, rootNode[key], fileSchema)
      if field:
        fileSchema.addFileManField(field)
    if 'SB' in rootNode:
      self._parseSubFilesNode(rootNode)

  def _parseSchemaField(self, fieldNo, rootNode, fileSchema):
    if '0' not in rootNode:
      logging.warn('%s does not have a 0 subscript' % rootNode)
      return None
    zeroFields = rootNode["0"].value
    if not zeroFields:
      logging.warn("No value: %s for %s" % (zeroFields, rootNode['0']))
      return None
    zeroFields = zeroFields.split('^')
    if len(zeroFields) < 2:
      return FileManFieldFactory.createField(fieldNo, zeroFields[0],
                                             FileManField.FIELD_TYPE_NONE, None)
    types, specifier, filePointedTo, subFile = \
        self.parseFieldTypeSpecifier(zeroFields[1])
    location = None
    if len(zeroFields) >= 4 and zeroFields[3]:
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
      logging.warn('Can not determine the type for %s, fn: %s, file:%s' %
                   (zeroFields, fieldNo, fileSchema.getFileNo()))
      types = [FileManField.FIELD_TYPE_NONE]
    if types and types[0]  == FileManField.FIELD_TYPE_SUBFILE_POINTER:
      if subFile and subFile == fileSchema.getFileNo():
        logging.error("recursive subfile pointer for %s" % subFile)
        types = [FileManField.FIELD_TYPE_NONE]
    logging.debug('%s is %s, %s, %s, %s' %
                 (zeroFields[1], types, specifier, filePointedTo, subFile))
    fileField = FileManFieldFactory.createField(fieldNo, zeroFields[0],
                                                types[0], location)
    if specifier:
      fileField.setSpecifier(specifier)
      logging.debug("Adding specifier: %s to %r" % (specifier, fileField))
    self._setFieldSpecificData(zeroFields, fileField, rootNode,
                              fileSchema, filePointedTo, subFile)
    return fileField

  def _setFieldSpecificData(self, zeroFields, fileField, rootNode,
                           fileSchema, filePointedTo, subFile):
    if fileField.getType() == FileManField.FIELD_TYPE_FILE_POINTER:
      if filePointedTo:
        if filePointedTo in self._allSchema:
          fileField.setPointedToFile(self._allSchema[filePointedTo])
        else:
          logging.info("%r: filePointedTo: %s" % (fileField, filePointedTo))
          """ try to set the global location here """
          if len(zeroFields) >= 3:
            fileGlobalRoot = zeroFields[2]
            logging.info("@TODO, find the file @ %s" % fileGlobalRoot)
          else:
            logging.warn("Could not find pointed to file: %s" % filePointedTo)
      else:
        """ try to set the global location here """
        if len(zeroFields) >= 3:
          fileGlobalRoot = zeroFields[2]
          logging.info("@TODO, find the file @ %s" % fileGlobalRoot)
        else:
          logging.warn("No pointed to file set for file:%s: field:%r 0-index:%s" %
                       (fileSchema.getFileNo(), fileField, zeroFields))
    elif fileField.getType() == FileManField.FIELD_TYPE_SUBFILE_POINTER:
      if subFile:
        if subFile not in self._allSchema:
          self._allSchema[subFile] = FileManFile(subFile, "", fileSchema)
        subFileSchema = self._allSchema[subFile]
        subFileSchema.setParentFile(fileSchema)
        fileSchema.addFileManSubFile(subFileSchema)
        fileField.setPointedToSubFile(subFileSchema)
      else:
        logging.warn("No subfile is set for file:%s, field:%r 0-index:%s" %
                     (fileSchema.getFileNo(), fileField, zeroFields))
    elif fileField.getType() == FileManField.FIELD_TYPE_SET and not subFile:
      setDict = dict([x.split(':') for x in zeroFields[2].rstrip(';').split(';')])
      fileField.setSetMembers(setDict)
    elif fileField.getType() == FileManField.FIELD_TYPE_VARIABLE_FILE_POINTER:
      if "V" in rootNode: # parsing variable pointer
        vptrs = parsingVariablePointer(rootNode['V'])
        vpFileSchemas = []
        if vptrs:
          for x in vptrs:
            if x not in self._allSchema:
              self._allSchema[x] = FileManFile(x, "")
            if self._allSchema[x].isSubFile():
              logging.info("Field: %s point to subFile: %s" % (fileField, x))
            vpFileSchemas.append(self._allSchema[x])
          fileField.setPointedToFiles(vpFileSchemas)
    elif fileField.getType() == FileManField.FIELD_TYPE_COMPUTED:
      if len(zeroFields) >= 5:
        logging.debug("Computed Mumps Code: %s for %r" %
                      ("".join(zeroFields[4:]), fileField))

  @staticmethod
  def parseFieldTypeSpecifier(typeField):
    if not typeField:
      return [FileManField.FIELD_TYPE_NONE], None, None, None
    types, specifier = [], []
    filePointedTo = None # Handle specific case of pointed to file
    result = re.search("P(?P<file>[0-9.]+)('?)", typeField)
    if result:
      types.append(FileManField.FIELD_TYPE_FILE_POINTER)
      filePointedTo = result.group('file')
      float(filePointedTo) # this is to make sure that file # is a float
      if len(result.groups()) > 1:
        specifier.append(FileManField.FIELD_SPECIFIER_LAYGO_NOT_ALLOWED)
      typeField = typeField[:result.span()[0]] + typeField[result.span()[1]:]
    for match, args in FIELD_TYPE_MAP_LIST:
      if match in typeField:
        setTypeAndSpecifer(types, specifier, args)
        typeField = typeField.replace(match,'') # get rid of the match
    subFile = None
    result = re.search("(?P<subFile>^[0-9.]+)", typeField)
    if result:
      subFile = result.group('subFile')
      if FileManField.FIELD_TYPE_SUBFILE_POINTER not in types:
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
              if (not detail.hasSubType(subType) and
                  subType != FileManField.FIELD_TYPE_NONE):
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
    if '7.5' in rootNode:
      print "PRE-LOOKUP: %s" % "".join(rootNode['7.5'].value)
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
  #allSchemaDict = schemaParse.parseSchemaDDFile(result.ddFile)
  allSchemaDict = schemaParse.parseSchemaDDFileV2(result.ddFile)
  # Find all the word processing multiple
  # printAllSchemas(allSchemaDict)
  allSchemaDict['2'].printFileManInfo()
  allSchemaDict['1'].printFileManInfo()

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
  for typeField in (".2LAP", "M66.021A", "MP200'X",
                    "Cm", "BC", "9002313.59902PA", "RF",
                    "WL", "200.34P", "*P21'Xa"):
    logging.info("%s: %s" % (typeField,
                  FileManSchemaParser.parseFieldTypeSpecifier(typeField)))

def main():
  from LogManager import initConsoleLogging
  initConsoleLogging(formatStr='%(message)s')
  #test_parseFieldTypeSpecifier()
  testDDZWRFile()

if __name__ == '__main__':
  main()
