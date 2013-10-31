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
    self.value = value.split('^')
  def __len__(self):
    return len(self.value)
  def __contains__(self, elt):
    return elt in self.value
  def __getitem__(self, key):
    return self.value[key]

class GlobalNode(object):
  def __init__(self, id, value):
    self.dict = {}
    self.value = ItemValue(value)
  def get(self, key, default=None):
    return self.dict.get(key, default)
  def __contains__(self, elt):
    return elt in self.dict
  def __getitem__(self, key):
    return self.dict[key]
  def __setitem__(self, key, value):
    self.dict[key] = value
  def __iter__(self):
    return iter(self.dict)
  def __len__(self):
    return len(self.dict)

def main():
  gn = GlobalNode("root^test")
  for i in range(len(gn.value)):
    print gn.value[i]
  gn['test'] = GlobalNode("-1")
  for i in xrange(0,5):
    gn['test'][i] = GlobalNode(str(i)+'^')
    print len(gn['test'][i].value)
  print len(gn)
  print len(gn['test'])
  print gn['test'].get(6)
  print 2 in gn['test']

if __name__ == '__main__':
  main()
