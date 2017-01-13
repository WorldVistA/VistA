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
add_delphi_project(CPRSChart)
#add_dependencies(CPRSChart ORDateLibXE3)

set(BUILD_DELPHI_XuDigSig_DIR "${CMAKE_CURRENT_SOURCE_DIR}/XuDigSig" CACHE PATH "Path to Folder that contains the MPL licensed files or local replacements")
if(NOT BUILD_DELPHI_XuDigSig_DIR)
  message(WARNING "The CPRSv29 source on the FOIA site contained code that was
released under the 1.1 version of the Mozilla Public license. These files
have been replaced by OSEHRA written files found in the CPRS-Chart/XuDigSig
directory.  To utilize the original files, download/clone them from
  https://github.com/OSEHRA-Sandbox/CPRSv29-XUDigSig
Then, set BUILD_DELPHI_XuDigSig_DIR to be the path to the folder that contains
these files. See the README for more details.")
endif()
