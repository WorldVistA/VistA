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
import logging

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
        outId = "%s,%s" % (self.parent.getIndex(), self.subscript)
    else:
      outId = "%s(" % self.subscript
    return outId
  def __str__(self):
    return "%s)=%s" % (self.getIndex(), self.value)

def printGlobal(gNode):
  if gNode is not None:
    if gNode.value.value is not None: # skip intermediate node
      logging.info(gNode)
    for item in sorted(gNode, cmp=sortDataEntryFloatFirst):
      printGlobal(gNode[item])
  else:
    return

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

def test_sortDataEntryFloatFirst():
  initLst = ['PRE', 'DIST', '22', '1', '0', 'INIT', 'VERSION', '4', 'INI']
  sortedLst = sorted(initLst, cmp=sortDataEntryFloatFirst)
  print initLst, sortedLst

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
      if idx == 2: globalRoot = GlobalNode(subscript=line[:line.find('(')])
      createGlobalNode(line, globalRoot)
  return globalRoot

def readGlobalNodeFromZWRFile(inputFileName, indx=1):
  with open(inputFileName, "r") as input:
    initRoot = None
    globalRoot, preSubscript, curSubscript = None, None, None
    for idx, line in enumerate(input,0):
      if idx <=1:
        continue
      line = line.strip('\r\n')
      if idx == 2:
        initRoot = GlobalNode(subscript=line[:line.find('(')])
        globalRoot = initRoot
      subscripts = findSubscriptValue(line)[0]
      if not subscripts or len(subscripts) <= indx: continue
      preSubscript = curSubscript
      curSubscript = subscripts[indx]
      if curSubscript != preSubscript and preSubscript is not None:
        retNode = globalRoot
        for idx in xrange(indx):
          retNode = retNode[subscripts[idx]]
        retNode = retNode[preSubscript]
        globalRoot = initRoot
        createGlobalNode(line, globalRoot)
        yield retNode
      else:
        createGlobalNode(line, globalRoot)

def test_createGlobalNodeByZWRFile(inputFileName):
  printGlobal(createGlobalNodeByZWRFile(inputFileName))

def test_readGlobalNodeFromZWRFile(inputFileName):
  for globalRoot in readGlobalNodeFromZWRFile(inputFileName):
    logging.info(globalRoot)

def findSubscriptValue(inputLine):
  start = inputLine.find("(")
  if start <= 0:
    return None, None
  pos = inputLine.find(")=\"")
  if pos >= start:
    nodeIndex = [x.strip('"') for x in inputLine[start+1:pos].split(",")]
    nodeValue = inputLine[pos+3:-1]
    return nodeIndex, nodeValue
  else:
    return None, None

def createGlobalNode(inputLine, globalRoot):
  nodeIndex, nodeValue = findSubscriptValue(inputLine)
  if nodeIndex:
    if len(nodeValue) > 0:
      nodeValue.replace('""""', '""')
    nodeIdx = globalRoot
    for idx in nodeIndex[:-1]:
      if idx not in nodeIdx:
        nodeIdx[idx] = GlobalNode()
      nodeIdx = nodeIdx[idx]
    nodeIdx[nodeIndex[-1]] = GlobalNode(nodeValue)
  else:
    return

def main():
  from LogManager import initConsoleLogging
  import sys
  from datetime import datetime
  initConsoleLogging(formatStr='%(message)s')
  #testGlobalNode()
  #test_createGlobalNodeByZWRFile(sys.argv[1])
  logging.info(datetime.now())
  test_readGlobalNodeFromZWRFile(sys.argv[1])
  logging.info(datetime.now())

if __name__ == '__main__':
  main()
