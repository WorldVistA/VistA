#---------------------------------------------------------------------------
# Copyright 2011 The Open Source Electronic Health Record Agent
# Copyright 2024 Sam Habiel. Increase timeout for CALLGRAPH job.
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

if(POLICY CMP0012)
  cmake_policy(SET CMP0012 NEW)
endif()

find_package(Java REQUIRED)
include(UseJava)

find_program(DOT_EXECUTABLE NAMES dot REQUIRED)
set(DOCUMENT_VISTA_DIR_PREFIX "" CACHE STRING "String to append to each output directory")
mark_as_advanced(DOCUMENT_VISTA_DIR_PREFIX)
set(DOCUMENT_VISTA_DOX_OUTPUT_DIR "${DOCUMENT_VISTA_OUTPUT_DIR}/${DOCUMENT_VISTA_DIR_PREFIX}dox")
set(DOCUMENT_VISTA_FILES_OUTPUT_DIR "${DOCUMENT_VISTA_OUTPUT_DIR}/${DOCUMENT_VISTA_DIR_PREFIX}vivian-data")
set(DOCUMENT_VISTA_PDF_OUTPUT_DIR "${DOCUMENT_VISTA_DOX_OUTPUT_DIR}/PDF")

set(DOCUMENT_VISTA_M_DIR "" CACHE PATH
  "Path to the folder that contains the routines and globals from OSEHRA")
STRING(REGEX REPLACE "\\\\" "/" DOCUMENT_VISTA_M_DIR ${DOCUMENT_VISTA_M_DIR})
if(NOT EXISTS ${DOCUMENT_VISTA_M_DIR})
  message(WARNING "DOCUMENT_VISTA_M_DIR is required.")
endif()

set(DOCUMENT_VISTA_OUTPUT_DIR "" CACHE PATH
  "Path to the directory where ViViaN and DOX files will be generated")
STRING(REGEX REPLACE "\\\\" "/" DOCUMENT_VISTA_OUTPUT_DIR ${DOCUMENT_VISTA_OUTPUT_DIR})
file(MAKE_DIRECTORY "${DOCUMENT_VISTA_OUTPUT_DIR}")
if(NOT EXISTS ${DOCUMENT_VISTA_OUTPUT_DIR})
  message(WARNING "DOCUMENT_VISTA_OUTPUT_DIR is required.")
endif()

set(DOCUMENT_VISTA_ICR_OUTPUT_DIR "${DOCUMENT_VISTA_FILES_OUTPUT_DIR}/ICR")
set(ICR_FILE "" CACHE FILEPATH "ICR File from http://foia-vista.osehra.org/VistA_Integration_Agreement/")
if(NOT EXISTS ${ICR_FILE})
  message(WARNING "ICR_FILE is required.")
else()
  # Get file name without directory or longest extension
  get_filename_component(ICR_JSON_FILE ${ICR_FILE} NAME_WE)
  set(ICR_JSON_FILE "${DOCUMENT_VISTA_FILES_OUTPUT_DIR}/${ICR_JSON_FILE}.JSON")
  STRING(REGEX REPLACE "\\\\" "/" ICR_JSON_FILE ${ICR_JSON_FILE})
endif()

set(PYTHONSCRIPTS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/PythonScripts")
set(GENERATE_DOX "TRUE" CACHE BOOL "Generate the DOX pages")
mark_as_advanced(GENERATE_DOX)

set(GENERATE_VIVIAN "TRUE" CACHE BOOL "Generate ViViaN data")
mark_as_advanced(GENERATE_VIVIAN)

set(GENERATE_PDF_BUNDLE "FALSE" CACHE BOOL "Generate PDF bundle")

if(GENERATE_PDF_BUNDLE)
  set(GENERATE_PDF "-pdf")
else()
  set(GENERATE_PDF "")
endif()

if (NOT GENERATE_DOX AND NOT GENERATE_VIVIAN)
  message(SEND_ERROR "Must select GENERATE_DOX and/or GENERATE_VIVIAN.")
endif()

if (NOT GENERATE_DOX AND GENERATE_PDF_BUNDLE)
  message(SEND_ERROR "Must select GENERATE_DOX to generate PDF Bundle")
endif()

set(SCRIPT_OUTPUT_DIR "${CMAKE_BINARY_DIR}/Docs/CallerGraph")
set(LOG_OUTPUT_DIR "${CMAKE_BINARY_DIR}/Log")

# 0. Install the Enhanced XINDEX patch
if (GENERATE_DOX OR GENERATE_VIVIAN)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/XINDEXInstall.cmake.in ${SCRIPT_OUTPUT_DIR}/XINDEXInstall.cmake @ONLY)
  add_test(XINDEX_Install ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/XINDEXInstall.cmake)
endif()

# 1. Generate XINDEX based cross reference output used by:
#    GeneratePackageDep (ViViaN) and WebPageGenerator (DOX)
if (GENERATE_DOX OR GENERATE_VIVIAN)
  FindPackages(${DOCUMENT_VISTA_M_DIR})
  set(CALLER_GRAPH_LOG_DIR "${SCRIPT_OUTPUT_DIR}/Log")
  file(MAKE_DIRECTORY "${CALLER_GRAPH_LOG_DIR}")
  foreach(package_file_name ${PACKAGES})
    string(REPLACE  "_" " " packageDirName "${package_file_name}")
    FindPackageInfo(${DOCUMENT_VISTA_M_DIR} ${packageDirName})
    set(package "${DOCUMENT_VISTA_M_DIR}/Packages/${packageDirName}")
    if(IS_DIRECTORY ${package})
      file(GLOB routines "${package}/Routines/*.m")
      set(AllRoutines "")
      foreach(routine ${routines})
        get_filename_component(routine_name ${routine} NAME_WE)
        set(AllRoutines "${AllRoutines}AllRoutines.append(\"${routine_name}\")\n")
      endforeach()
      list(FIND PACKAGES ${package_file_name} PACKAGE_INDEX)
      list(GET PACKAGES_INTERNAL ${PACKAGE_INDEX} PACKAGE_INTERNAL_NAME)
      set(logfile "${CALLER_GRAPH_LOG_DIR}/${package_file_name}.log")
      #Configures the python script with the name of the routine
      configure_file(${CMAKE_CURRENT_SOURCE_DIR}/XindexCallerGraph.py.in
                     ${SCRIPT_OUTPUT_DIR}/${package_file_name}.py)

      configure_file(${CMAKE_CURRENT_SOURCE_DIR}/XindexCallerGraph.cmake.in
                     ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake @ONLY)

      # Creates the command that will be called for the Test
      add_test(CALLERGRAPH_${package_file_name} ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake)
      set_tests_properties(CALLERGRAPH_${package_file_name} PROPERTIES TIMEOUT 7200)
    endif()
  endforeach()
endif()

# 2. Generate Fileman Schema used by:
#    GeneratePackageDep (ViViaN) and WebPageGenerator (DOX)
if (GENERATE_DOX OR GENERATE_VIVIAN)
  set(FILEMAN_SCHEMA_DIR "${CMAKE_BINARY_DIR}/Docs/Schema")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/FileManGlobalAttributes.py.in ${SCRIPT_OUTPUT_DIR}/FilemanGlobalAttributes.py)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/GetFilemanSchema.cmake.in ${SCRIPT_OUTPUT_DIR}/GetFilemanSchema.cmake @ONLY)
  add_test(GetFilemanSchema ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/GetFilemanSchema.cmake)
  set_tests_properties(GetFilemanSchema PROPERTIES TIMEOUT 7200)
  set(FILEMANDBCALL_JSON "${DOCUMENT_VISTA_FILES_OUTPUT_DIR}/filemanDBCall.json")
endif()

# 3. Download, compile and run 'M Routine Analyzer' tool
# Creates 'filemanDBCall.json', which is used by WebPageGenerator (DOX)
if (GENERATE_DOX)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/MRoutineAnalyzer.cmake.in ${SCRIPT_OUTPUT_DIR}/MRoutineAnalyzer.cmake @ONLY)
  add_test(MRoutineAnalyzer ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/MRoutineAnalyzer.cmake)
  set_tests_properties(MRoutineAnalyzer
                        PROPERTIES FAIL_REGULAR_EXPRESSION "SEVERE")
endif()

# 4. Run FileMan Global Data Parser script
# Generates ViViaN data and 'Routine-Ref.json' for the WebPageGenerator (DOX)
if (GENERATE_DOX OR GENERATE_VIVIAN)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/FileManGlobalDataParser.cmake.in ${SCRIPT_OUTPUT_DIR}/FileManGlobalDataParser.cmake @ONLY)
  add_test(FileManGlobalDataParser ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/FileManGlobalDataParser.cmake)
  set_tests_properties(FileManGlobalDataParser PROPERTIES TIMEOUT 18000)
endif()

# 5. Run ICR Parser Script to parse and convert the downloaded ICR text file
# to json (DOX), html (ViViaN) and pdf (DOX)
if (GENERATE_DOX OR GENERATE_VIVIAN)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/ICRParser.cmake.in ${SCRIPT_OUTPUT_DIR}/ICRParser.cmake @ONLY)
  add_test(ICRParser ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/ICRParser.cmake)
endif()

# 6. Write repository information to 'filesInfo.json'.
# Data is displayed in both ViViaN and DOX (GenerateIndexPage)
if (GENERATE_DOX OR GENERATE_VIVIAN)
  set(FILESINFO_JSON "${DOCUMENT_VISTA_FILES_OUTPUT_DIR}/filesInfo.json")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/GenerateRepoInfo.cmake.in ${SCRIPT_OUTPUT_DIR}/GenerateRepoInfo.cmake @ONLY)
  add_test(GenerateRepoInfo ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/GenerateRepoInfo.cmake)
endif()

if (GENERATE_DOX)
  file(MAKE_DIRECTORY "${DOCUMENT_VISTA_DOX_OUTPUT_DIR}")
  file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/Web/code_pretty_scripts" DESTINATION "${DOCUMENT_VISTA_DOX_OUTPUT_DIR}")

# 7. Run the Graph Generator script
# Uses 'dot' to generate graphs and legends for the WebPageGenerator (DOX)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/GraphGenerator.cmake.in ${SCRIPT_OUTPUT_DIR}/GraphGenerator.cmake @ONLY)
  add_test(GraphGenerator ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/GraphGenerator.cmake)
  set_tests_properties(GraphGenerator PROPERTIES TIMEOUT 7200)

# 8. Run the Web Page Generator script to create DOX pages and PDF bundles
  set(ROUTINEREF_JSON "${DOCUMENT_VISTA_FILES_OUTPUT_DIR}/Routine-Ref.json")
  set(PACKAGEDEP_JSON "${DOCUMENT_VISTA_FILES_OUTPUT_DIR}/PackageDep.json") # TODO: Where is this file used?
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/WebPageGenerator.cmake.in ${SCRIPT_OUTPUT_DIR}/WebPageGenerator.cmake @ONLY)
  add_test(WebPageGenerator ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/WebPageGenerator.cmake)
  set_tests_properties(WebPageGenerator PROPERTIES TIMEOUT 28000)
endif()

if(GENERATE_VIVIAN)
  # 9. Run Package Dependency Generator script
  # Generates PackageDependency file used in ViViaN
  set(PACKAGEDEP_JSON "${DOCUMENT_VISTA_FILES_OUTPUT_DIR}/pkgdep.json")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/GeneratePackageDep.cmake.in ${SCRIPT_OUTPUT_DIR}/GeneratePackageDep.cmake @ONLY)
  add_test(GeneratePackageDep ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/GeneratePackageDep.cmake)
  set_tests_properties(GeneratePackageDep PROPERTIES TIMEOUT 7200)

  # 10. Run Requirements parser to generate the data needed for the BFF & Requirements page
  # to json and html (ViViaN)
  # 10/13/2020 - Comment out as files lost after OSEHRA's demise
  #set(DOCUMENT_VISTA_REQUIREMENTS_OUTPUT_DIR "${DOCUMENT_VISTA_FILES_OUTPUT_DIR}")
  #set(DOCUMENT_VISTA_REQUIREMENTS_INPUT CACHE FILEPATH "")
  #mark_as_advanced(DOCUMENT_VISTA_REQUIREMENTS_INPUT)
  #set(DOCUMENT_VISTA_REQUIREMENTS_PASTDATA CACHE FILEPATH "")
  #mark_as_advanced(DOCUMENT_VISTA_REQUIREMENTS_PASTDATA)
  #file(MAKE_DIRECTORY "${DOCUMENT_VISTA_REQUIREMENTS_OUTPUT_DIR}/requirements")
  #configure_file(${CMAKE_CURRENT_SOURCE_DIR}/RequirementsParser.cmake.in ${SCRIPT_OUTPUT_DIR}/RequirementsParser.cmake @ONLY)
  #add_test(RequirementsParser ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/RequirementsParser.cmake)

# 11. Run a task to generate the DataTables display of the name and numberspace information
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/NameNumberspaceGen.cmake.in ${SCRIPT_OUTPUT_DIR}/NameNumberspaceGen.cmake @ONLY)
  add_test(GenerateNameNumberDisplay ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/NameNumberspaceGen.cmake)
endif()
