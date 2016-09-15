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
"""
  A Python dictionary to specify the format to
  output FileMan File data entry in html format.
  The key of the dictionary is FileMan File Number in string format
  The Value of the dictionary is a dictionary of various key/value.
    1. Key "Name": Special Fields or function to display the entry, the default
       is to use the .01 field if not specified here.
    2. Key "Fields": A List of fields in order for displaying a summary
       of the data entry.
    3. Key "Category": A Function to categorize the data entry by package,
       default is None
"""

FILEMAN_FILE_OUTPUT_FORMAT = {
      "8994" : { # REMOTE PROCEDURE FILE # 8994
                "Fields": [
                    { 'id': '.01', }, # Name
                    { 'id': '.02', }, # Tag
                    { 'id': '.03', 'func': None}, # Routine
                    { 'id': '.05', }, # Availability
                  ],
                "Category": None, # Categorize by package
               },

    }
