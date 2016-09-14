#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
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

class ItemValue(object):
  def __init__(self, value):
    self.value = value
    if value:
      self.value = value.split('^')
  def __len__(self):
    if self.value:
      return len(self.value)
    return 0
  def __contains__(self, elt):
    if self.value:
      return elt in self.value
    return False
  def __getitem__(self, key):
    if self.value:
      return self.value[key]
    return None
  def __str__(self):
    if self.value:
      return "^".join(self.value)
    elif self.value is None:
      return str(None)
    else:
      return ""

class GlobalNode(object):
  def __init__(self, value=None, subscript=None, parent=None):
    self.child = {}
    self.value = ItemValue(value)
    self.subscript = subscript
    self.parent=parent
  def isRoot(self):
    return self.parent is None
  def get(self, key, default=None):
    return self.child.get(key, default)
  def __contains__(self, elt):
    return elt in self.child
  def __getitem__(self, key):
    return self.child[key]
  def __setitem__(self, key, value):
    self.child[key] = value
    value.subscript = key
    value.parent = self
  def __iter__(self):
    return iter(self.child)
  def __len__(self):
    return len(self.child)
  def getIndex(self):
    if self.parent:
      if self.parent.isRoot():
        outId = "%s%s" % (self.parent.getIndex(), self.subscript)
      else:
        outId = "%s, %s" % (self.parent.getIndex(), self.subscript)
    else:
      outId = "%s(" % self.subscript
    return outId
  def __str__(self):
    return "%s) = %s" % (self.getIndex(), self.value)

def printGlobal(gNode):
  if gNode is not None:
    print gNode
    for item in sorted(gNode):
      printGlobal(gNode[item])
  else:
    return

def testGlobalNode():
  gn = GlobalNode("root^test", "^ZZTEST")
  for i in range(len(gn.value)):
    print gn.value[i]
  gn['test'] = GlobalNode("-1")
  for i in xrange(0,5):
    gn['test'][i] = GlobalNode(str(i)+'^')
    for j in xrange(0,5):
      gn['test'][i][j] = GlobalNode("^".join([str(i), str(j)]))
    print len(gn['test'][i].value)
  print len(gn)
  print len(gn['test'])
  print gn['test'].get(6)
  print gn['test'][2]
  print gn['test'][3]
  print 2 in gn['test']
  printGlobal(gn)

def getKeys(globalRoot, func=int):
  outKey = []
  for key in globalRoot:
    try:
      idx = func(key)
      outKey.append(key)
    except:
      pass
  return sorted(outKey, key=lambda x: func(x))

def createGlobalNodeByZWRFile(inputFileName):
  globalRoot = None
  with open(inputFileName, "r") as input:
    for idx, line in enumerate(input,0):
      if idx <=1:
        continue
      line = line.strip('\r\n')
      if idx == 2: globalRoot = GlobalNode(subscript=line[:line.find('(')-1])
      createGlobalNode(line, globalRoot)
  return globalRoot

def testDDZWRFile():
  inputFileName = "C:/Users/Jason.li/git/VistA-M/Packages/VA FileMan/Globals/DD.zwr"
  #inputFileName = "C:/Users/Jason.li/tmp/8894_test.zwr"
  #inputFileName = "C:/Users/Jason.li/tmp/200_test.zwr"
  #inputFileName = "C:/Users/Jason.li/tmp/0_test.zwr"
  #inputFileName = "C:/Users/Jason.li/tmp/801.41_test.zwr"
  globalRoot = createGlobalNodeByZWRFile(inputFileName)
  files = getKeys(globalRoot, float)
  allSchemaDict = {}
  for file in files:
    schema = generateSchema(globalRoot[file])
    if schema:
      allSchemaDict[file] = schema
  del globalRoot
  # Find all the word processing multiple
  for file, schema in allSchemaDict.iteritems():
    for field, detail in schema.iteritems():
      types = detail['type']
      subFile = detail['subfile']
      if types and len(types) == 1 and subFile:
        if subFile in allSchemaDict and '.01' in allSchemaDict[subFile]:
          subTypes = allSchemaDict[subFile]['.01']['type']
          types.extend(subTypes)

  #inputFileName = "C:/Users/Jason.li/git/VistA-M/Packages/RPC Broker/Globals/8994+REMOTE PROCEDURE.zwr"
  fileNumber = '9.7'
  inputFileName = "C:/Users/Jason.li/git/VistA-M/Packages/Kernel/Globals/9.7+Install.zwr"
  glbDataRoot = createGlobalNodeByZWRFile(inputFileName)
  parseDataBySchema(glbDataRoot[fileNumber], allSchemaDict, fileNumber)

def printAllSchemas(allSchemaDict):
  for file, schema in allSchemaDict.iteritems():
    print '----------------------------------'
    print "File: %s" % file
    print '----------------------------------'
    for field, valueDict in schema.iteritems():
      print ("Field: %s, Name: %s, Type: %s: Specifier: %s,"
             "Location: %s, Multiple#: %s, files: %s set: %s" %
             (field, valueDict['name'], valueDict['type'],
              valueDict['specifier'], valueDict['location'],
              valueDict['subfile'], valueDict['files'], valueDict['set']))

def sortSchemaByLocation(schemaRoot):
  locFields = {}
  for fldAttr in schemaRoot.itervalues():
    loc = fldAttr['location']
    if not loc: continue
    index,pos = loc.split(';')
    if index not in locFields:
      locFields[index] = {}
    locFields[index][pos] = fldAttr
  return locFields

def sortDataEntryFloatFirst(data1, data2):
  isData1Float = convertToType(data1, float)
  isData2Float = convertToType(data2, float)
  if isData1Float and isData2Float:
    return cmp(float(data1), float(data2))
  if isData1Float:
    return -1 # float first
  else:
    return cmp(data1, data2)

def convertToType(data1, convertFunc):
  try:
    convertFunc(data1)
    return True
  except ValueError:
    return False

def test_sortDataEntryFloatFirst():
  initLst = ['PRE', 'DIST', '22', '1', '0', 'INIT', 'VERSION', '4', 'INI']
  sortedLst = sorted(initLst, cmp=sortDataEntryFloatFirst)
  print initLst, sortedLst

schemaSet = set()
def parseDataBySchema(dataRoot, schemaRoot, fileNumber, level=0):
  """ first sort the schema Root by location """
  indent = "\t" * level
  schemaDict = sortSchemaByLocation(schemaRoot[fileNumber])
  """ for each data entry, parse data by location """
  intKey = getKeys(dataRoot)
  print "%s%s" % (indent, fileNumber)
  for ien in intKey:
    if int(ien) <=0:
      continue
    #if level == 0 and int(ien) != 160: continue
    dataEntry = dataRoot[ien]
    print '%s------------------' % indent
    print '%sFileEntry: %s' % (indent, ien)
    print '%s------------------' % indent
    dataKeys = [x for x in dataEntry]
    sortedKey = sorted(dataKeys, cmp=sortDataEntryFloatFirst)
    for key in sortedKey:
      if key in schemaDict:
        fieldDict = schemaDict[key]
        if len(fieldDict) == 1:
          fieldAttr = fieldDict.values()[0]
          if fieldAttr['subfile']:
            parseSubFileField(dataEntry[key], fieldAttr, schemaRoot, level)
          else:
            values = dataEntry[key].value
            if not values: continue
            location = fieldAttr['location']
            dataValue = None
            if location:
              index, loc = location.strip().split(';')
              if loc and convertToType(loc, int):
                intLoc = int(loc)
                if intLoc > 0 and intLoc <= len(values):
                  dataValue = values[intLoc-1]
            else:
              dataValue = str(dataEntry.value)
            if dataValue:
              parseIndividualFieldDetail(dataValue, fieldAttr, level)
        else:
          parseDataValueField(dataEntry[key], fieldDict, level)

def parseDataValueField(dataRoot, fieldDict, level):
  indent = "\t" * level
  values = dataRoot.value
  if not values: return # this is very import to check
  for idx, value in enumerate(values, 1):
    if value and str(idx) in fieldDict:
      schema = fieldDict[str(idx)]
      parseIndividualFieldDetail(value, schema, level)

def parseIndividualFieldDetail(value, schema, level):
  if not value: return
  value = value.strip()
  if not value: return
  indent = "\t" * level
  fieldDetail = value
  types = schema['type']
  if 'Set' in types and schema['set']:
    if value in schema['set']:
      fieldDetail = schema['set'][value]
  print "%s%s: %s" % (indent, schema['name'], fieldDetail)

def parseSubFileField(dataRoot, fieldAttr, schemaRoot, level):
  types = fieldAttr['type']
  subfile = fieldAttr['subfile']
  indent = "\t"*level
  print "%s%s" % (indent, fieldAttr['name'] + ':')
  if 'Word Processing' in types:
    parsingWordProcessingNode(dataRoot, level+1)
  elif subfile:
    parseDataBySchema(dataRoot, schemaRoot, subfile, level+1)
  else:
    print "Sorry, do not know how to intepret the schema %s" % fieldAttr

def generateSchema(globalRoot):
  """ read the 0 subscript node """
  #print globalRoot["0"].value
  fileSchema = {}
  for key in getKeys(globalRoot, float):
    if key == '0': continue
    field = parseSchemaField(key, globalRoot[key])
    if field:
      fileSchema[key] = field
  return fileSchema

def parseSchemaField(key, globalRoot):
  fieldLst = ['name', 'type',
              'specifier', 'location',
              'files', 'subfile', 'set']
  if '0' not in globalRoot:
    return None
  item = globalRoot["0"].value
  if not item or len(item) < 2:
    return None
  type, specifier, files, subFile = parseFieldTypeSpecifier(item[1])
  setDict = None
  if 'Set' in type and not subFile:
    setDict = dict([x.split(':') for x in item[2].rstrip(';').split(';')])
  if "V" in globalRoot:
    vptrs = parsingVariablePointer(globalRoot['V'])
    if vptrs:
      files.extend(vptrs)
  location = item[3]
  if item[3].strip(' ') == ';': # No location information
    location = None
  return dict(zip(fieldLst, [item[0], type, specifier, location, files, subFile, setDict]))
  """ handle extra attributes"""
  if len(item) >= 5 and item[4]:
    inputTrans = ""
    for txt in item[4:]:
      inputTrans += txt
    print "\tInput Transform: %s" % inputTrans
  if "3" in globalRoot and globalRoot["3"].value is not None:
    print "\tHELP-PROMPT: %s" % globalRoot['3'].value
  if "DT" in globalRoot and globalRoot["DT"].value is not None:
    print "\tLast Modified: %s" % globalRoot["DT"].value
  if "9.1" in globalRoot and globalRoot["9.1"].value is not None:
    print "\tCompute Algorithm: %s" % globalRoot["9.1"].value
  if "1" in globalRoot:
    if '0' in globalRoot["1"]:
      parseCrossReference(globalRoot)
  if "21" in globalRoot:
    print "Description:"
    parsingWordProcessingNode(globalRoot['21'])
  if "DEL" in globalRoot:
    print "DELETE TEST:"
    parsingDelTest(globalRoot['DEL'])

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

TYPE_LIST = [
  ('D', 'Date/Time'),
  ('C', 'Computed'),
  ('F', 'Free Text'),
  ('N', 'Numeric Valued'),
  ('P', 'Pointer'),
  ('W', 'Word Processing'),
  ('S', 'Set'),
  ('V', 'Variable Pointer'),
  ('K', 'Mumps'),
  #('A', 'Multiple'),
  #('M', 'Multiple'),
]

SPECIFIER_LIST = [
  ('R', 'Required'),
  ('O', 'Output Transform'),
  ('a', 'Audit'),
  ('e', 'Audit on edit/delete'),
  ('I', 'Uneditable'),
  ('X', 'Editing is not allowed'),
]

def parseFieldTypeSpecifier(typeField):
  types, specifier = [], []
  for match, type in TYPE_LIST:
    if match in typeField:
      types.append(type)
  # checkiing for P type
  files = []
  if 'Pointer' in types:
    result = re.search('P(?P<file>[0-9.]+)', typeField)
    if result:
      file = result.group('file')
      float(file)
      files.append(file)
  subFile = None
  result = re.search('(?P<subFile>^[0-9.]+)', typeField)
  if result:
    subFile = result.group('subFile')
    float(subFile)
    types.append('Multiple #%s' % subFile)
  if types:
    for match, specif in SPECIFIER_LIST:
      if match in typeField:
        specifier.append(specif)
  return types, specifier, files, subFile

def parsingWordProcessingNode(globalNode, level=1):
  indent = "\t"*level
  for key in sorted(globalNode, key=lambda x: int(x)):
    if "0" in globalNode[key]:
      print "%s%s" % (indent, globalNode[key]["0"].value)

def parsingInputParameterNode(globalNode):
  print parseMapValue(globalNode['0'].value, INPUT_PARAMETER_LIST)
  if "1" in globalNode:
    parsingWordProcessingNode(globalNode['1'])

def createGlobalNode(inputLine, globalNode):
  start = inputLine.find("(")
  if start <= 0:
    return
  pos = inputLine.find(")=\"")
  if pos >= 0:
    nodeIndex = [x.strip('"') for x in inputLine[start+1:pos].split(",")]
    nodeValue = inputLine[pos+3:-1]
    if len(nodeValue) > 0:
      nodeValue.replace('""""', '""')
    nodeIdx = globalNode
    for idx in nodeIndex[:-1]:
      if idx not in nodeIdx:
        nodeIdx[idx] = GlobalNode()
      nodeIdx = nodeIdx[idx]
    nodeIdx[nodeIndex[-1]] = GlobalNode(nodeValue)
  else:
    return

def main():
  #testGlobalNode()
  testDDZWRFile()
  #test_sortDataEntryFloatFirst()

if __name__ == '__main__':
  main()
