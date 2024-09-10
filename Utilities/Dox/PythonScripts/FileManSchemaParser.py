#---------------------------------------------------------------------------
# Copyright 2014 The Open Source Electronic Health Record Agent
# Copyright 2024 Sam Habiel. Python 3.12 changes.
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
import re
from builtins import object
from future.utils import itervalues
from CrossReference import FileManFile, FileManFieldFactory
from CrossReference import FileManField, Global
from LogManager import logger
from UtilityFunctions import getKeys
from ZWRGlobalParser import readGlobalNodeFromZWRFileV2

FILE_REGEX = re.compile("P(?P<file>[0-9.]+)('?)")
SUBFILE_REGEX = re.compile("(?P<subFile>^[0-9.]+)")

# Utility Function to set the Type/Specifier
def setTypeAndSpecifer(types, specifier, values):
  if values and len(values) == 3:
    if values[0] and values[0] not in types:
      types.append(values[0])
    if values[1] and values[1] not in types:
      types.append(values[1])
    if values[2] and values[2] not in specifier:
      specifier.append(values[2])

# A Tuple of two elements:
#  1. Matching string
#  2. Argument if present, in the form of
#    (Type, subType, Extra Specifier)
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
    self._zeroFiles = ['0'] # all file and subfile WRT file zero
    self._subFiles = set() # all the subFiles
    self._noPointedToFiles = {} # global Name => global
    self._fileDep = {} # fileNo => list of files
    self._sccSet = set() # Set of 'Strongly Connected Components'

  @property
  def sccSet(self):
    return self._sccSet

  def _generateSCCSet(self):
    """
      generate a set of set that contains
      files that are Strongly Connected Components
    """
    out = set()
    allFiles = set(self._fileDep.keys())
    for values in itervalues(self._fileDep):
      allFiles.update(values)
    for key in allFiles:
      self._fileDep.setdefault(key, set())
    for scc in strongly_connected_components(allFiles, self._fileDep):
      out |= scc
    return out

  def parseSchemaDDFileV2(self, inputDDZWRFile):
    for ddRoot in readGlobalNodeFromZWRFileV2(inputDDZWRFile, '^DD'):
      files = getKeys(ddRoot, float) # sort files by float value
      for file in files:
        if file not in self._allSchema:
          self._allSchema[file] = Global("", file, "")
        self._generateFileSchema(ddRoot[file], self._allSchema[file])
    self._updateMultiple()
    self._sccSet = self._generateSCCSet()
    return self._allSchema


  def _parseSubFilesNode(self, rootNode, fileNo):
    """ Get the subFiles used in the file """
    for key in getKeys(rootNode['SB'], float):
      assert key in self._allSchema
      assert self._allSchema[key].isSubFile()
      assert self._allSchema[key].getParentFile().getFileNo() == fileNo
      self._subFiles.add(key)

  def _generateFileSchema(self, rootNode, fileSchema):
    """
      handle the "PT" and "SB" subscript first
    """
    for key in getKeys(rootNode, float):
      if key == '0':
        continue # ignore the fields 0
      field = self._parseSchemaField(key, rootNode[key], fileSchema)
      if field:
        fileSchema.addFileManField(field)
    if 'SB' in rootNode:
      self._parseSubFilesNode(rootNode, fileSchema.getFileNo())

  def _parseSchemaField(self, fieldNo, rootNode, fileSchema):
    if '0' not in rootNode:
      logger.warning('%s does not have a 0 subscript' % rootNode)
      return None
    zeroFields = rootNode["0"].value
    if not zeroFields:
      logger.warning("No value: %s for %s" % (zeroFields, rootNode['0']))
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
          types = [multipleType]
        if multipleType in types and types[0] != multipleType:
          types.remove(multipleType)
          types.insert(0, multipleType)
          if not subFile:
            subFile = filePointedTo
    if not types:
      logger.debug('Cannot determine the type for %s, fn: %s, file:%s' %
                   (zeroFields, fieldNo, fileSchema.getFileNo()))
      types = [FileManField.FIELD_TYPE_NONE]
    if types and types[0]  == FileManField.FIELD_TYPE_SUBFILE_POINTER:
      if subFile and subFile == fileSchema.getFileNo():
        logger.warning("Recursive subfile pointer for %s" % subFile)
        types = [FileManField.FIELD_TYPE_NONE]
    fileField = FileManFieldFactory.createField(fieldNo, zeroFields[0],
                                                types[0], location)
    if specifier:
      fileField.setSpecifier(specifier)
    self._setFieldSpecificData(zeroFields, fileField, rootNode,
                              fileSchema, filePointedTo, subFile)
    return fileField

  def _addToFileDepDict(self, fileNo, pointedToFile):
    if fileNo == pointedToFile:
      return # ignore self pointed files
    self._fileDep.setdefault(fileNo, set()).add(pointedToFile)

  def _setFieldSpecificData(self, zeroFields, fileField, rootNode,
                           fileSchema, filePointedTo, subFile):
    if fileField.getType() == FileManField.FIELD_TYPE_FILE_POINTER:
      fileGlobalRoot = ""
      if len(zeroFields) >= 3:
        fileGlobalRoot = zeroFields[2]
      if filePointedTo:
        if filePointedTo not in self._allSchema:
          # create a new fileman file
          self._allSchema[filePointedTo] = Global(fileGlobalRoot,
                                                  filePointedTo,
                                                  "")
        pointedToFile = self._allSchema[filePointedTo]
        # assert pointedToFile.isRootFile()
        fileField.setPointedToFile(pointedToFile)
        globalName = pointedToFile.getName()
        fileNo = fileSchema.getFileNo()
        if fileSchema.isSubFile():
          fileNo = fileSchema.getRootFile().getFileNo()
        self._addToFileDepDict(fileNo,
                               pointedToFile.getFileNo())
        if fileGlobalRoot:
          if not globalName:
            pointedToFile.setName(fileGlobalRoot)
          elif globalName != fileGlobalRoot:
            logger.warning("%s: FileMan global root mismatch '%s' : '%s'" %
                          (zeroFields, globalName, fileGlobalRoot))
        else:
          logger.info("@TODO, find file global root for # %s" % filePointedTo)
      elif fileGlobalRoot:
        self._noPointedToFiles[fileGlobalRoot] = Global(fileGlobalRoot)
        logger.info("@TODO, set the file number for %s" % fileGlobalRoot)
      else:
        logger.warning("No pointed to file set for file:%s: field:%r 0-index:%s" %
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
        logger.warning("No subfile is set for file:%s, field:%r 0-index:%s" %
                     (fileSchema.getFileNo(), fileField, zeroFields))
    elif fileField.getType() == FileManField.FIELD_TYPE_SET and not subFile and zeroFields[2]:
      setDict = dict([x.split(':') for x in zeroFields[2].rstrip(';').split(';')])
      fileField.setSetMembers(setDict)
    elif fileField.getType() == FileManField.FIELD_TYPE_VARIABLE_FILE_POINTER:
      if "V" in rootNode: # parsing variable pointer
        vptrs = parsingVariablePointer(rootNode['V'])
        vpFileSchemas = []
        if vptrs:
          for x in vptrs:
            if x not in self._allSchema:
              self._allSchema[x] = Global("", x, "")
            pointedToFile = self._allSchema[x]
            if pointedToFile.isSubFile():
              logger.error("Field: %r point to subFile: %s, parent: %s" %
                           (fileField, pointedToFile,
                            pointedToFile.getParentFile()))
            else:
              fileNo = fileSchema.getFileNo()
              if fileSchema.isSubFile():
                fileNo = fileSchema.getRootFile().getFileNo()
              self._addToFileDepDict(fileNo,
                                     pointedToFile.getFileNo())
            vpFileSchemas.append(self._allSchema[x])
          fileField.setPointedToFiles(vpFileSchemas)

  @staticmethod
  def parseFieldTypeSpecifier(type):
    typeField = type
    if not typeField:
      return [FileManField.FIELD_TYPE_NONE], None, None, None
    types, specifier = [], []
    filePointedTo = None # Handle specific case of pointed to file
    result = FILE_REGEX.search(typeField)
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
        typeField = typeField.replace(match, '') # get rid of the match
    subFile = None
    result = SUBFILE_REGEX.search(typeField)
    if result:
      subFile = result.group('subFile')
      if (FileManField.FIELD_TYPE_SUBFILE_POINTER not in types and
         FileManField.FIELD_TYPE_COMPUTED not in types):
        types.insert(0, FileManField.FIELD_TYPE_SUBFILE_POINTER)
    return types, specifier, filePointedTo, subFile

  def _updateMultiple(self):
    allSchemaDict = self._allSchema
    for schema in itervalues(allSchemaDict):
      allFields = schema.getAllFileManFields()
      if not allFields:
        continue
      for detail in itervalues(schema.getAllFileManFields()):
        if detail.getType() == FileManField.FIELD_TYPE_SUBFILE_POINTER:
          subFile = detail.getPointedToSubFile()
          if subFile:
            subFileNo = subFile.getFileNo()
            if subFileNo in allSchemaDict and subFile.hasField('.01'):
              subType = subFile.getField('.01').getType()
              if (not detail.hasSubType(subType) and
                  subType != FileManField.FIELD_TYPE_NONE):
                detail.addSubType(subType)

def createArgParser():
  import argparse
  parser = argparse.ArgumentParser(description='FileMan Schema Parser')
  parser.add_argument('ddFile', help='path to ZWR file contains DD global')
  return parser

def parsingVariablePointer(vpRoot):
  intKey = getKeys(vpRoot)
  outVptr = []
  for key in intKey:
    if '0' in vpRoot[key]:
      value = vpRoot[key]['0'].value
      if value:
        value = value.split('^')[0]
        outVptr.append(value)
  return outVptr

def strongly_connected_components(vertice, edges):
  """
  Algorithm that uses Tarjan's strongly connected components algorithm
  refer to:
  http://en.wikipedia.org/wiki/Tarjan's_strongly_connected_components_algorithm
  """
  stack = []
  index = {} # dictionary that stores index for each vertice
  lowindex = {} # store lowindex for each vertice
  stackset = set()

  def visit(v):
    if v not in edges:
      yield set([v])
    index[v] = len(index)
    lowindex[v] = index[v]
    stack.append(v)
    stackset.add(v)
    for w in edges[v]:
      if w not in index:
        for scc in visit(w):
          yield scc
        lowindex[v] = min(lowindex[v], lowindex[w])
      elif w in stackset:
        lowindex[v] = min(lowindex[v], index[w])
    if lowindex[v] == index[v]: # found out a scc
      indexv = stack.index(v)
      scc = set(stack[indexv:])
      del stack[indexv:]
      stackset.difference_update(scc)
      yield scc

  for v in vertice:
    if v not in index:
      for scc in visit(v):
        yield scc
