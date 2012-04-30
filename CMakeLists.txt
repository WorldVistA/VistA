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
cmake_minimum_required(VERSION 2.8)
project(VistA-FOIA NONE)

# Check the environment
if(NOT "${CMAKE_GENERATOR}" MATCHES "Borland Makefiles")
  message(FATAL_ERROR "This project works only with CMake's \"Borland Makefiles\" generator")
endif()
execute_process(COMMAND ${CMAKE_MAKE_PROGRAM} -h OUTPUT_VARIABLE output ERROR_VARIABLE output)
if(NOT "x${output}" MATCHES "MAKE Version[^\n]*Borland")
  message(FATAL_ERROR "Make tool \"${CMAKE_MAKE_PROGRAM}\" is not a Borland make!  Fix your PATH.")
endif()
if(NOT DEFINED ENV{BDS} OR
   NOT DEFINED ENV{FrameworkDir} OR
   NOT DEFINED ENV{FrameworkVersion})
  message(FATAL_ERROR
    "The environment is missing BDS or FrameworkDir or FrameworkVersion.\n"
    "Run CMake from an environment with \"rsvars.bat\" loaded such as the RAD Studio prompt.")
endif()
if(NOT EXISTS $ENV{FrameworkDir}$ENV{FrameworkVersion}/Borland.Delphi.Targets)
  message(FATAL_ERROR "The framework directory in the current environment (%FrameworkDir%%FrameworkVersion%):
  $ENV{FrameworkDir}$ENV{FrameworkVersion}
does not contain \"Borland.Delphi.Targets\".
Note that Delphi 2007 installs its framework files incorrectly on 64-bit Windows, as documented at
  http://qc.embarcadero.com/wc/qcmain.aspx?d=54409
")
endif()

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build Configuration (Debug,Release)" FORCE)
endif()

function(add_delphi_build p t)
  file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}" SOURCE)
  configure_file(${p}.dproj.in ${p}.dproj @ONLY)
  configure_file(${p}.${t}.in ${p}.${t} @ONLY)
  add_custom_target(${p} ALL COMMAND msbuild /p:Configuration=$<CONFIGURATION> ${p}.dproj)
endfunction()

function(add_delphi_package package)
  add_delphi_build(${package} dpk)
endfunction()

function(add_delphi_project project)
  add_delphi_build(${project} dpr)
endfunction()

add_subdirectory("Packages/RPC Broker/BDK" BDK)
add_subdirectory("Packages/Order Entry Results Reporting/CPRS" CPRS)

include(CTest)
if(BUILD_TESTING)
  add_subdirectory("Testing/CPRS" CPRSTesting)
endif()
