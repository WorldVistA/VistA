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
from CrossReference import FileManField, Global
from ZWRGlobalParser import createGlobalNodeByZWRFile, getKeys
from ZWRGlobalParser import readGlobalNodeFromZWRFileV2, printGlobal

FILE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(FILE_DIR, "../../../Scripts"))
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)

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
    self._noPointedToFiles = {} # global Name => global
    self._fileDep = {} # fileNo => list of files
    self._sccSet = []
    self._isolatedFile = set()

  @property
  def sccSet(self):
    return self._sccSet

  @property
  def isolatedFiles(self):
    return self._isolatedFile

  def _readZeroFile(self, inputDDZWRFile):
    for globalRoot in readGlobalNodeFromZWRFile(inputDDZWRFile):
      if '0' in globalRoot:
        printGlobal(globalRoot)
        break

  def _updateFileDepSet(self, file, deps, exclude):
    for depFile in [x for x in deps]:
      if depFile not in self._fileDep:
        logging.info("no dep information for file %s" % depFile)
        continue
      if depFile in exclude:
        logging.info("%s is in exclude list" % depFile)
        continue
      exclude.add(depFile)
      self._updateFileDepSet(depFile, self._fileDep[depFile], exclude)
      logging.info("defore update deps: %s" % deps)
      deps.update(self._fileDep[depFile])
      logging.info("after update deps: %s" % deps)

  def _updateFileDep(self):
    exclude = set()
    for file in self._fileDep.iterkeys():
      if file in exclude:
        continue
      exclude.add(file)
      self._updateFileDepSet(file, deps, exclude)

  def _generateNoPointerToFileList(self):
    depDict = self._fileDep
    noPointedToBy = sorted(reduce(set.union, depDict.itervalues()) -
                            set(depDict.iterkeys()), key=lambda x: float(x))
    # remove subfiles
    allNoPointedToBy = noPointedToBy
    noPointedToBy = [x for x in noPointedToBy if self._allSchema[x].isRootFile()]
    logging.info("SubFiles are %s" % (set(allNoPointedToBy) - set(noPointedToBy)))
    logging.info("Total # of Files that is not pointed to by any files: %s" %
                  len(noPointedToBy))
    logging.debug("List of files that is not pointed to by any files: %s" % noPointedToBy)

    """
      generate list of files that does not have any pointer
      and is not pointed by any files
    """
    allFiles = [x for x in self._allSchema if self._allSchema[x].isRootFile()]
    logging.info("Total # of Files: %s" % len(allFiles))
    allFilesWithPointedTo = [x for x in depDict if self._allSchema[x].isRootFile()]
    allFilesWithoutPointedTo = sorted(set(allFiles) - set(allFilesWithPointedTo), key=lambda x: float(x))
    logging.info("Total # of Files that is not pointed to by any files: %s" % len(allFilesWithoutPointedTo))
    logging.debug("Files that is not pointed to by any files: %s" % allFilesWithoutPointedTo)
    allFilePointerTo = reduce(set.union, depDict.itervalues())
    allFileNoPointerTo = set(allFiles) - allFilePointerTo
    logging.info("Total # of files that does not have file pointer: %s" % len(allFileNoPointerTo))
    logging.debug("Files that does not have pointer to files: %s" % allFileNoPointerTo)
    self._isolatedFile = set(allFilesWithoutPointedTo) & allFileNoPointerTo
    logging.info("Total # of Isolated Files: %s" % len(self._isolatedFile))
    logging.info("Isolated File List: %s" % sorted(self._isolatedFile, key=lambda x: float(x)))

  def _updateFileDepByFile(self, file, exclude):
    exclude.add(file)
    return self._updateFileDepSet(file, self._fileDep[file], exclude)

  def _topologicSort(self):
    from PatchOrderGenerator import topologicSort
    result = topologicSort(self._fileDep, '2')
    print result

  def parseSchemaDDFile(self, inputDDZWRFile):
    self._ddRoot = createGlobalNodeByZWRFile(inputDDZWRFile)
    assert self._ddRoot.subscript == "^DD"
    #self._generateFileZeroSchema()
    self._generateSchema()
    self._updateMultiple()
    self._updateFileDep()
    return self._allSchema

  def _generateSCCSet(self):
    """
      generate a list of set that contains
      a group of files that are Strongly Connected Components
    """
    outList = self._sccSet
    """ remove self dependency """
    allFiles = set(self._fileDep.keys())
    # special logic to reduce the dependency of file 101
    for key, values in self._fileDep.iteritems():
      #if key == '101':
      #  for item in ('200', '19', '9.4', '870', '123.5', '62.07', '62.05', '60', '61', '62', '123.1', '71', '19.1'):
      #    values.discard(item)
      #elif key == '771':
      #  values.discard('3.8')
      #elif '200' == key:
      #  values = set()
      allFiles.update(values)
    for key in allFiles:
      self._fileDep.setdefault(key,set())
    for scc in strongly_connected_components_iterative(allFiles, self._fileDep):
      outList.append(scc)
    return outList

  def parseSchemaDDFileV2(self, inputDDZWRFile):
    for ddRoot in readGlobalNodeFromZWRFileV2(inputDDZWRFile, '^DD'):
      self._ddRoot = ddRoot
      #logging.info("Printing Global Node:")
      #printGlobal(ddRoot)
      self._generateSchema()
    self._updateMultiple()
    self._generateNoPointerToFileList()
    outSCCLst = self._generateSCCSet()
    if '101' in self._fileDep:
      print self._fileDep['101']
    totalFiles = 0
    for idx, scc in enumerate(outSCCLst):
      scc = scc - self._isolatedFile
      print "%s: %s" % (idx, scc)
      totalFiles += len(scc)
      if '101' in scc:
        print "Total # files need to read at the same time is %s" % len(scc)
        print "Total Files before 101 is %s" % totalFiles
    #self._updateFileDepByFile('200', set())
    #print len(self._fileDep['200']), self._fileDep['200']
    return self._allSchema

  def _generateFileZeroSchema(self):
    while (len(self._zeroFiles) > 0):
      file = self._zeroFiles.pop(0)
      if file not in self._allSchema:
        self._allSchema[file] = Global("", file, "")
      self._generateFileSchema(self._ddRoot[file], self._allSchema[file])

  def _generateSchema(self):
    files = getKeys(self._ddRoot, float) # sort files by float value
    logging.debug("Parsing files %s" % files)
    for file in files:
      if file not in self._allSchema:
        self._allSchema[file] = Global("", file, "")
      self._generateFileSchema(self._ddRoot[file], self._allSchema[file])

  def _parseSubFilesNode(self, rootNode, fileNo):
    """ Get the subFiles used in the file """
    for key in getKeys(rootNode['SB'], float):
      logging.debug("Checking subfiles: %s" % key)
      assert key in self._allSchema
      assert self._allSchema[key].isSubFile()
      assert self._allSchema[key].getParentFile().getFileNo() == fileNo
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
      self._parseSubFilesNode(rootNode, fileSchema.getFileNo())

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

  def _addToFileDepDict(self, fileNo, pointedToFile):
    if fileNo == pointedToFile:
      return # ignore self pointed files
    logging.debug("File: %s - Adding Pointed to file %s"
                  % (fileNo, pointedToFile))
    self._fileDep.setdefault(fileNo, set()).add(pointedToFile)

  def _setFieldSpecificData(self, zeroFields, fileField, rootNode,
                           fileSchema, filePointedTo, subFile):
    if fileField.getType() == FileManField.FIELD_TYPE_FILE_POINTER:
      fileGlobalRoot = ""
      if len(zeroFields) >= 3:
        fileGlobalRoot = zeroFields[2]
      if filePointedTo:
        if filePointedTo not in self._allSchema:
          """ create a new fileman file """
          self._allSchema[filePointedTo] = Global(fileGlobalRoot,
                                                  filePointedTo,
                                                  "")
        pointedToFile = self._allSchema[filePointedTo]
        assert pointedToFile.isRootFile()
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
            logging.error("%s: FileMan global root mismatch %s: %s" %
                          (zeroFields, globalName, fileGlobalRoot))
        else:
          logging.info("@TODO, find file global root for # %s" % filePointedTo)
      elif fileGlobalRoot:
        self._noPointedToFiles[fileGlobalRoot] = Global(fileGlobalRoot)
        logging.info("@TODO, set the file number for %s" % fileGlobalRoot)
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
          logging.debug("variable points: %s" % vptrs)
          for x in vptrs:
            if x not in self._allSchema:
              self._allSchema[x] = Global("", x, "")
            pointedToFile = self._allSchema[x]
            if pointedToFile.isSubFile():
              logging.error("Field: %r point to subFile: %s, parent: %s" %
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
    elif fileField.getType() == FileManField.FIELD_TYPE_COMPUTED:
      if len(zeroFields) >= 5:
        logging.debug("Computed Mumps Code: %s for %r" %
                      ("".join(zeroFields[4:]), fileField))

  @staticmethod
  def parseFieldTypeSpecifier(type):
    typeField = type
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
      if (FileManField.FIELD_TYPE_SUBFILE_POINTER not in types and
         FileManField.FIELD_TYPE_COMPUTED not in types):
        types.insert(0, FileManField.FIELD_TYPE_SUBFILE_POINTER)
        logging.debug("Set to subFile type for %s" % type)
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
  #allSchemaDict['44.003'].printFileManInfo()
  #allSchemaDict['101'].printFileManInfo()
  #allSchemaDict['2'].printFileManInfo()
  #allSchemaDict['1'].printFileManInfo()

def printAllSchemas(allSchemaDict):
  files = getKeys(allSchemaDict.keys(), float)
  for file in files:
    allSchemaDict[file].printFileManInfo()

def parseCrossReference(globalRoot):
  pass
  #printGlobal(globalRoot['1'])

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
                    "WL", "200.34P", "*P21'Xa", "*P8'X", "CD8"):
    logging.info("%s: %s" % (typeField,
                  FileManSchemaParser.parseFieldTypeSpecifier(typeField)))

def strongly_connected_components(vertice, edges):
  """
  Algorithm that uses Tarjan's strongly connected components algorithm
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
      scc = set(stack[index[v]:])
      del stack[index[v]:]
      stackset.difference_update(scc)
      yield scc

  for v in vertice:
    if v not in index:
      for scc in visit(v):
        yield scc

def strongly_connected_components_iterative(vertices, edges):
  """
  This is a non-recursive version of strongly_connected_components_path.
  See the docstring of that function for more details.

  Example from Tarjan's paper [2]_.

  vertices = [1, 2, 3, 4, 5, 6, 7, 8]
  edges = {1: [2], 2: [3, 8], 3: [4, 7], 4: [5],
           5: [3, 6], 6: [], 7: [4, 6], 8: [1, 7]}
  set([6])
  set([3, 4, 5, 7])
  set([8, 1, 2])

  """
  identified = set()
  stack = []
  index = {}
  boundaries = []

  for v in vertices:
    if v not in index:
      #print "traversal vertice %s: edges: %s" % (v, edges[v])
      to_do = [('VISIT', v)]
      while to_do:
        operation_type, v = to_do.pop()
        if operation_type == 'VISIT':
          index[v] = len(stack)
          stack.append(v)
          boundaries.append(index[v])
          to_do.append(('POSTVISIT', v))
          # We reverse to keep the search order identical to that of
          # the recursive code;  the reversal is not necessary for
          # correctness, and can be omitted.
          try:
            to_do.extend(
                reversed([('VISITEDGE', w) for w in edges[v]]))
          except KeyError as ke:
            print "KeyError: %r" % ke
        elif operation_type == 'VISITEDGE':
          if v not in index:
            to_do.append(('VISIT', v))
          elif v not in identified:
            while index[v] < boundaries[-1]:
              boundaries.pop()
        else:
          # operation_type == 'POSTVISIT'
          if boundaries[-1] == index[v]:
            boundaries.pop()
            scc = set(stack[index[v]:])
            del stack[index[v]:]
            identified.update(scc)
            yield scc

import unittest

def test_strongly_connected_components_iterative():
  vertices = [1, 2, 3, 4, 5, 6, 7, 8]
  edges = {1: set([2]), 2: set([3, 8]), 3: [4, 7], 4: [5],
           5: [3, 6], 6: [], 7: [4, 6], 8: [1, 7]}
  expectedRet = [set([6]), set([3,4,5,7]), set([8,1,2])];
  for scc in  strongly_connected_components_iterative(vertices, edges):
    expRet =  expectedRet.pop(0)
    print scc, expRet
    assert scc == expRet;

def test_strongly_connected_components():
  vertices = [1, 2, 3, 4, 5, 6, 7, 8]
  edges = {1: set([2]), 2: set([3, 8]), 3: [4, 7], 4: [5],
           5: [3, 6], 6: [], 7: [4, 6], 8: [1, 7]}
  expectedRet = [set([6]), set([3,4,5,7]), set([8,1,2])];
  for scc in  strongly_connected_components(vertices, edges):
    expRet =  expectedRet.pop(0)
    print scc, expRet
    assert scc == expRet;

def main():
  from LogManager import initConsoleLogging
  initConsoleLogging(formatStr='%(asctime)s %(message)s')
  #test_parseFieldTypeSpecifier()
  test_strongly_connected_components()
  testDDZWRFile()

if __name__ == '__main__':
  main()
