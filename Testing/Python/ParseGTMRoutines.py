#!/usr/bin/env python
#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
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
import re

def remove_duplicates_preserve_order(items):
  found = set([])
  keep = []
  for item in items:
    if item not in found:
      found.add(item)
      keep.append(item)

  return keep

def check_dir(element, final_list):
  #replace all "\\ " with " " as os.path cannot check escaped spaces
  elementPath = re.subn(r'\\\s', ' ', element)[0]
  if os.path.isdir(elementPath):
    final_list.append(elementPath)

def parse_gtmroutines():
  var = os.getenv('gtmroutines')
  final_list = extract_m_source_dirs(var)
  final_str = ';'.join(final_list)
  print final_str

def extract_m_source_dirs(var):
  #First, replace unescaped spaces with semicolons
  tmp = var.replace(" ",";").replace("\;","\ ")
  tmpl = tmp.split(";")
  num_elements = len(tmpl)
  final_list = []
  for ind in xrange(num_elements):
    element = tmpl[ind]
    element = element.strip(")")
    paren_check = [m.start() for m in re.finditer("\(",element)]
    if not paren_check:
      check_dir(element, final_list)
    else:
      stripElement = element[paren_check[0]+1:]
      check_dir(stripElement, final_list)

  # Remove duplicates, and print the semicolon separated string
  final_list = remove_duplicates_preserve_order(final_list)
  return final_list

if __name__ == "__main__":
  parse_gtmroutines()
