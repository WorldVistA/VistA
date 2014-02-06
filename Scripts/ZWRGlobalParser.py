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
from LoggerManager import logger

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
    return ""

class GlobalNode(object):
  def __init__(self, value=None):
    self.dict = {}
    self.value = ItemValue(value)
    self.id = None
  def get(self, key, default=None):
    return self.dict.get(key, default)
  def __contains__(self, elt):
    return elt in self.dict
  def __getitem__(self, key):
    return self.dict[key]
  def __setitem__(self, key, value):
    self.dict[key] = value
    if self.id:
      value.id = self.id + ", " + str(key)
    else:
      value.id = str(key)
  def __iter__(self):
    return iter(self.dict)
  def __len__(self):
    return len(self.dict)
  def __str__(self):
    return "%s" % self.value

def printGlobal(gNode):
  if gNode is not None:
    print "Id is %s" % gNode.id, "Value is %s" % gNode.value
    for item in sorted(gNode):
      printGlobal(gNode[item])
  else:
    return

def testGlobalNode():
  gn = GlobalNode("root^test")
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

def testRPCZWRFile():
  inputFileName = "C:/Users/Jason.li/git/VistA-M/Packages/RPC Broker/Globals/8994+REMOTE PROCEDURE.zwr"
  globalRoot = GlobalNode()
  with open(inputFileName, "r") as input:
    for idx, line in enumerate(input,0):
      if idx <=1:
        continue
      line = line.strip('\r\n')
      createGlobalNode(line, globalRoot)
  intKey = []
  for key in sorted(globalRoot['8994']):
    try:
      idx = int(key)
      if idx > 0:
        intKey.append(key)
    except:
      pass
  for key in sorted(intKey, key=lambda x: int(x)):
    rpcRoot = globalRoot['8994'][key]
    rpcName = rpcRoot["0"].value[0]
    print '----------------------------------------'
    print "Print RPC Call %s" % key
    print '----------------------------------------'
    printRPCEntry(rpcRoot)
    #if rpcName.startswith('OR') or rpcName.startswith('OCX'):
    #  pass

class KeyValueMap(object):
  def __init__(self, key, valueMap=None):
    self.key = key
    self.valueMap = valueMap
  def apply(self, value):
    if self.valueMap and value in self.valueMap:
      return self.valueMap[value]
    return value

YesNoMap = {'0': 'No', '1': 'Yes'}
YESNOMAP = {'0': 'NO', '1': 'YES'}
TRUEFALSEMAP = {'0': 'FALSE', '1': 'TRUE'}
ZERO_LOC_LIST = (
    KeyValueMap("NAME"), KeyValueMap("TAG"),
    KeyValueMap("ROUTINE"), KeyValueMap("RETURN VALUE TYPE",
                                       {'1': 'SINGLE VALUE',
                                        '2': 'ARRAY',
                                        '3': 'WORD PROCESSING',
                                        '4': 'GLOBAL ARRAY',
                                        '5': 'GLOBAL INSTANCE',
                                       }),
    KeyValueMap("AVAILABILITY", {'P': 'PUBLIC',
                                 'S': 'SUBSCRIPTION',
                                 'A': 'AGREEMENT',
                                 'R': 'RESTRICTED'}),
    KeyValueMap("INACTIVE", {'0': 'ACTIVE',
                             '1': 'INACTIVE',
                             '2': 'LOCAL INACTIVE(ACTIVE REMOTELY)',
                             '3': 'REMOTE INACTIVE(ACTIVE LOCALLY)'}),
    KeyValueMap("CLIENT MANAGER", YESNOMAP),
    KeyValueMap("WORD WRAP ON", TRUEFALSEMAP),
    KeyValueMap("VERSION"),
    KeyValueMap("SUPPRESS RDV USER SETUP",YesNoMap),
    KeyValueMap("APP PROXY ALLOWED", YesNoMap) )

def parseMapValue(value, mapLst):
  locMap = zip([x.key for x in mapLst], value)
  for idx, (name, value) in enumerate(locMap):
    if mapLst[idx].valueMap:
      locMap[idx] = (name, mapLst[idx].apply(value))
  return locMap

def printRPCEntry(globalNode):
  # pass the rpc call detail by schema
  value = globalNode["0"].value
  print parseMapValue(value, ZERO_LOC_LIST)
  """ parsing description """
  if "1" in globalNode:
    print "Description:"
    parsingWordProcessingNode(globalNode["1"])
  """ parsing input parameter """
  if "2" in globalNode:
    print "Input Parameters:"
    for key in sorted(globalNode["2"]):
      try:
        idx = int(key)
        if idx > 0:
          parsingInputParameterNode(globalNode["2"][key])
      except ValueError as e:
        pass

  """ parsing return parameter """
  if "3" in globalNode:
    print "Return Parameter Description:"
    parsingWordProcessingNode(globalNode["3"])


def parsingWordProcessingNode(globalNode):
  for key in sorted(globalNode, key=lambda x: int(x)):
    if "0" in globalNode[key]:
      print globalNode[key]["0"].value

INPUT_PARAMETER_LIST = (
  KeyValueMap("INPUT PARAMETER"),
  KeyValueMap("PARAMETER TYPE",
             {'1': 'LITERAL', '2': 'LIST', '3': 'WORD PROCESSING', '4': 'REFERENCE'}),
  KeyValueMap("MAXUMUM DATA LENGTH"),
  KeyValueMap("REQUIRED", YESNOMAP),
  KeyValueMap("SEQUENCE NUMBER"),
)

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
    nodeIndex = inputLine[start+1:pos].split(",")
    nodeValue = inputLine[pos+3:-1]
    if len(nodeValue) > 0:
      nodeValue.replace('""', '\"')
    nodeIdx = globalNode
    for idx in nodeIndex[:-1]:
      if idx not in nodeIdx:
        nodeIdx[idx] = GlobalNode()
      nodeIdx = nodeIdx[idx]
    nodeIdx[nodeIndex[-1]] = GlobalNode(nodeValue)
  else:
    return

def main():
  testRPCZWRFile()

if __name__ == '__main__':
  main()
