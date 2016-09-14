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
    for item in gNode:
      printGlobal(gNode[item])
  else:
    return

def main():
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

if __name__ == '__main__':
  main()
