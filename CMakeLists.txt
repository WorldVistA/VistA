#---------------------------------------------------------------------------
# Copyright 2012-2013 The Open Source Electronic Health Record Agent
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
cmake_minimum_required(VERSION 2.8.0)
project(VISTA NONE)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake ${CMAKE_MODULE_PATH})

include(CTest)

if(WIN32)
  option(BUILD_DELPHI "Build Delphi Software (BDK, CPRS)" OFF)
endif()

if(BUILD_DELPHI)
  include(Delphi)
  add_subdirectory("Packages/RPC Broker/BDK" BDK)
  add_subdirectory("Packages/Order Entry Results Reporting/CPRS" CPRS)
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO CONFIGURE OSEHRA AUTOMATED TESTING HARNESS #####
#-----------------------------------------------------------------------------#
option(TEST_VISTA "Use this option to create and use the OSEHRA Automated Testing harness" OFF)
if(TEST_VISTA)
  add_subdirectory(Testing)

  #-----------------------------------------------------------------------------#
  ##### SECTION TO GENERATE VISUAL CROSS REFERENCE DOCUMENTATION #####
  #-----------------------------------------------------------------------------#
  OPTION(TEST_VISTA_DOX_CALLERGRAPH "Enables callergraph tests to create output to generate Dox pages." OFF)
  if(TEST_VISTA_DOX_CALLERGRAPH)
    add_subdirectory(Utilities/Dox)
  endif()
endif()
