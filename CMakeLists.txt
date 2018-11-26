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

if(${CMAKE_VERSION} VERSION_GREATER 3.1)
  cmake_policy(SET CMP0053 OLD)
endif()

# We do not install anything, so hide the install prefix option.
set(CMAKE_INSTALL_PREFIX "/" CACHE INTERNAL "This does not install")

# If we get here we either have a real build environment or the
# Borland Makefiles generator with no real make.  Determine whether we
# have a working build tool.
set(VISTA_HAVE_BUILD_TOOL 1)
if("${CMAKE_GENERATOR}" MATCHES "Borland Makefiles")
  execute_process(COMMAND ${CMAKE_MAKE_PROGRAM} -h OUTPUT_VARIABLE output ERROR_VARIABLE output)
  if("x${output}" MATCHES "MAKE Version[^\n]*Embarcadero")
    # This may be a Delphi build environment.
    option(BUILD_DELPHI "Build Delphi Software (BDK, CPRS)" OFF)
  else()
    # We do not really have a build tool.
    set(VISTA_HAVE_BUILD_TOOL 0)
  endif()
endif()

if(BUILD_DELPHI)
  include(Delphi)
  add_subdirectory("Packages/RPC Broker/BDK" BDK)
  add_subdirectory("Packages/General Medical Record - Vitals/Vitals Clients" Vitals)
  add_subdirectory("Packages/Order Entry Results Reporting/CPRS" CPRS)
endif()

set(BUILD_TESTING "ON" CACHE INTERNAL "Always build testing")

if(TEST_VISTA OR DOCUMENT_VISTA)
  set(VISTA_CMAKE_DIR "${VISTA_SOURCE_DIR}/CMake")
  set(VISTA_TESTING_DIR "${VISTA_SOURCE_DIR}/Testing")

  if("${CMAKE_VERSION}" VERSION_LESS 2.8.2)
    find_program(GIT_EXECUTABLE NAMES git)
    if(NOT GIT_EXECUTABLE)
      mark_as_advanced(CLEAR GIT_EXECUTABLE)
    endif()
  else()
    find_package(Git REQUIRED)
  endif()

  find_package(PythonInterp)
  if(NOT PYTHONINTERP_FOUND)
     mark_as_advanced(CLEAR PYTHON_EXECUTABLE)
  endif()

  set(VISTA_TCP_HOST "127.0.0.1" CACHE STRING "Server address of the machine that will have the VistA TCP listener")
  set(VISTA_TCP_PORT "9210" CACHE STRING "Port number of the opened TCP listener." )


  include(FindCacheOrGTM)
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO CONFIGURE OSEHRA AUTOMATED TESTING HARNESS #####
#-----------------------------------------------------------------------------#
option(TEST_VISTA "Use this option to create and use the OSEHRA Automated Testing harness" OFF)
if(TEST_VISTA)
  add_subdirectory(Testing)
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO GENERATE VISUAL CROSS REFERENCE DOCUMENTATION #####
#-----------------------------------------------------------------------------#
OPTION(DOCUMENT_VISTA "Use this option to generate VistA documentation (ViViaN and DOX)" OFF)
if(DOCUMENT_VISTA)
  add_subdirectory(Utilities/Dox)
endif()

#-----------------------------------------------------------------------------
# If we do not have a real build tool then tell ctest_build to run a
# rudimentary build through a CMake script.
set(cmake_build_script ${VISTA_BINARY_DIR}/CMake/Build.cmake)
get_property(cmake_build_scripts GLOBAL PROPERTY VISTA_BUILD_SCRIPTS)
if(NOT VISTA_HAVE_BUILD_TOOL)
  configure_file(CMake/Build.cmake.in ${cmake_build_script} @ONLY)
  set(MAKECOMMAND "${CMAKE_COMMAND} -P \"${cmake_build_script}\""
    CACHE INTERNAL "Basic build without a native build tool.")
  string(REPLACE "\"" "\\\"" mc_escaped "${MAKECOMMAND}")
  set(VISTA_CTEST_BUILD_COMMAND_CODE "set(CTEST_BUILD_COMMAND \"${mc_escaped}\")")
else()
  file(REMOVE ${cmake_build_script})
  get_property(type CACHE MAKECOMMAND PROPERTY TYPE)
  if("${type}" STREQUAL "INTERNAL")
    build_command(MAKECOMMAND_DEFAULT_VALUE CONFIGURATION "\${CTEST_CONFIGURATION_TYPE}")
    set(MAKECOMMAND "${MAKECOMMAND_DEFAULT_VALUE}" CACHE STRING "Command to build the project" FORCE)
  endif()
  set(VISTA_CTEST_BUILD_COMMAND_CODE "")
endif()
configure_file(CMake/CTestCustom.cmake.in CTestCustom.cmake)
