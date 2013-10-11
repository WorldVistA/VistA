#---------------------------------------------------------------------------
# Copyright 2011 The Open Source Electronic Health Record Agent
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

find_program(GREP_EXECUTABLE NAMES grep DOC "Path to the grep executable for finding the line number of the found errors")
mark_as_advanced(GREP_EXECUTABLE)
if(NOT GREP_EXECUTABLE)
  mark_as_advanced(CLEAR GREP_EXECUTABLE)
endif()

if("${CMAKE_VERSION}" VERSION_LESS 2.8.2)
  find_program(GIT_EXECUTABLE NAMES git)
  if(NOT GIT_EXECUTABLE)
    mark_as_advanced(CLEAR GIT_EXECUTABLE)
  endif()
else()
  find_package(Git)
endif()

find_package(PythonInterp)
if(NOT PYTHONINTERP_FOUND)
   mark_as_advanced(CLEAR PYTHON_EXECUTABLE)
endif()

set(BUILD_TESTING "ON" CACHE INTERNAL "Always build testing")

#options that will show up on the CMake Gui that allows customization of the project
option(TEST_VISTA_XINDEX_WARNINGS_AS_FAILURES "Use warnings as a failure condition for XINDEX tests?" OFF)
option(TEST_VISTA_FRESH "Overwrite the database file during build phase of testing? To remove this option, delete the CMake Cache" OFF)


set(VISTA_TCP_HOST "127.0.0.1" CACHE STRING "Server address of the machine that will have the VistA TCP listener")
set(VISTA_TCP_PORT "9210" CACHE STRING "Port number of the opened TCP listener." )
set(TEST_VISTA_OUTPUT_DIR "${VISTA_BINARY_DIR}/Testing/Temporary/" CACHE PATH "Path to results directory Defaults to /Testing/Temporary/ within the Binary Dir.")

#-----------------------------------------------------------------------------
# Find InterSystems Cache
#-----------------------------------------------------------------------------
if(WIN32)
  # The InterSystems Cache installation directory appears only under instance
  # names which we do not know yet.  Try all of them.
  foreach(query "HKLM\\SOFTWARE\\InterSystems\\Cache\\Configurations"
      "HKLM\\SOFTWARE\\Wow6432Node\\InterSystems\\Cache\\Configurations")
    execute_process(COMMAND reg query "${query}" OUTPUT_VARIABLE out ERROR_VARIABLE err)
    string(REGEX REPLACE "\r?\n" ";" configs "${out}")
    foreach(config ${configs})
      list(APPEND _Cache_PATHS "[${config}\\Directory]/bin")
    endforeach()
  endforeach()
  # Hard-coded guesses.
  list(APPEND _Cache_PATHS
    "C:/InterSystems/Cache/bin"
    "C:/InterSystems/TryCache/bin"
    )
else()
# append hard-coded guesses for linux
  list(APPEND _Cache_PATHS
    "/usr/bin"
    "/usr/local/bin"
  )
endif()
foreach(tool ccontrol CTerm)
  string(TOUPPER ${tool} toolupper)
  find_program(${toolupper}_EXECUTABLE NAMES ${tool} DOC "Path to Cache ${tool}" PATHS ${_Cache_PATHS})
  mark_as_advanced(${toolupper}_EXECUTABLE)
endforeach()

#-----------------------------------------------------------------------------
# Find FIS-GT.M
#-----------------------------------------------------------------------------
if(UNIX)
  set(GTM_DIST "$ENV{gtm_dist}" CACHE PATH "GT.M Distribution Directory")
  if( NOT GTM_DIST AND "$ENV{gtm_dist}")
    set_property(CACHE GTM_DIST PROPERTY VALUE "$ENV{gtm_dist}")
  endif()
endif()

#-----------------------------------------------------------------------------
#------ SET UP UNIT TEST ENV -----#
#-----------------------------------------------------------------------------
find_file(TEST_VISTA_SETUP_MUNIT_PATCH_FILE NAMES XT_7-3_81_TESTVER9.KID DOC "Path to the MUNIT KIDS file XT_7-3_81_TESTVER9.KID")
set(TEST_VISTA_SETUP_MUNIT_PATCH_NAME "XT*7.3*81" CACHE STRING "MUnit Kids build package install name")
  SET(MUNIT_INSTALLATION_SCRIPT "InstallMUnitKIDSBuild.py")
if(TEST_VISTA_SETUP_MUNIT_PATCH_FILE)
  file(TO_NATIVE_PATH ${TEST_VISTA_SETUP_MUNIT_PATCH_FILE} TEST_VISTA_SETUP_MUNIT_PATCH_FILE)
endif()

SET(SCRIPT_OUTPUT_DIR "${VISTA_BINARY_DIR}/UnitTest/")
SET(UNITTEST_LOG_DIR "${SCRIPT_OUTPUT_DIR}/Log")
file(MAKE_DIRECTORY "${UNITTEST_LOG_DIR}")

if(GTM_DIST)
  include(UseGTM)
endif()

if(CCONTROL_EXECUTABLE)
  include(UseCache)
endif()

include(CommonFunctions)
FindPackages(${VISTA_SOURCE_DIR})
list(APPEND PACKAGES "Uncategorized")
foreach(package_file_name ${PACKAGES})
#Configures the CMAKE testing
  set(LOGFILENAME "@TEST_VISTA_OUTPUT_DIR@/@package_file_name@Test.log")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/XINDEXScript.cmake.in ${VISTA_BINARY_DIR}/Testing/${package_file_name}Test.cmake @ONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/XINDEXScript.py.in ${VISTA_BINARY_DIR}/Testing/${package_file_name}Test.py @ONLY)
  #Creates the command that will be called for the Test
  add_test(XINDEX_${package_file_name} ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/Testing/${package_file_name}Test.cmake)
endforeach()

#-----------------------------------------------------------------------------#
##### SECTION TO SETUP THE REFRESH OF THE DATABASE #####
#-----------------------------------------------------------------------------#

if(TEST_VISTA_FRESH)
  add_subdirectory(Setup)
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO SETUP AUTOMATIC SYSTEM TESTING #####
#-----------------------------------------------------------------------------#
option(TEST_VISTA_FUNCTIONAL_SIK "Use Python and Sikuli to test Vitals and CPRS" OFF)
option(TEST_VISTA_FUNCTIONAL_RAS "Use Python to test VistA via roll and scroll" OFF)
option(TEST_VISTA_SETUP "Prepopulate the database with sample data including users, patients, locations, etc. " ON)
if(TEST_VISTA_SETUP)
  set(logfile "${VISTA_BINARY_DIR}/Testing/Log/PostImport.log")
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/Setup/PostImportSetupScript.py.in" "${CMAKE_CURRENT_BINARY_DIR}/Setup/PostImportSetupScript.py")
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/Setup/importPats.py.in" "${CMAKE_CURRENT_BINARY_DIR}/Setup/importPats.py")
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/Setup/ClinicSetup.py.in" "${CMAKE_CURRENT_BINARY_DIR}/Setup/ClinicSetup.py")
endif()
if((TEST_VISTA_FUNCTIONAL_SIK OR TEST_VISTA_FUNCTIONAL_RAS) AND TEST_VISTA_SETUP)
  add_subdirectory(Functional)
  # Coverage reports will be in human readable form for functional tests, by default
  option(TEST_VISTA_COVERAGE_READABLE "On Cache, output the coverage report in a summary table" ON)
  file(MAKE_DIRECTORY "${TEST_VISTA_OUTPUT_DIR}/Coverage")
endif()

#---------------------------------------------------------------------------------#
##### SECTION TO GENERATE FILES FOR COVERAGE (Using CMake V 2.8.9 and Higher) #####
#---------------------------------------------------------------------------------#

if(${CMAKE_VERSION} VERSION_GREATER 2.8.8)

  if(EXISTS ${VISTA_BINARY_DIR}/gtm_coverage.mcov)
    file(REMOVE ${VISTA_BINARY_DIR}/gtm_coverage.mcov)
  elseif(EXISTS ${VISTA_BINARY_DIR}/cache_coverage.cmcov)
    file(REMOVE ${VISTA_BINARY_DIR}/cache_coverage.cmcov)
  endif()

  option(TEST_VISTA_COVERAGE "Create a coverage map of VistA based off the testing" OFF)
  if(TEST_VISTA_COVERAGE)
    find_path(TEST_VISTA_FRESH_M_DIR NAMES VistA-M DOC "Path to the folder that contains the routines and globals from OSEHRA")
    message(WARNING "Selecting the coverage option may cause the tests to run slower as there are more tasks to perform during a given test.
    This will also create new text files during the run.")

    file(MAKE_DIRECTORY "${TEST_VISTA_OUTPUT_DIR}/Coverage")

    if(NOT TEST_VISTA_COVERAGE_READABLE AND CCONTROL_EXECUTABLE)
      file(WRITE ${VISTA_BINARY_DIR}/cache_coverage.cmcov "packages:${TEST_VISTA_FRESH_M_DIR}/Packages\r\ncoverage_dir:${TEST_VISTA_OUTPUT_DIR}/Coverage")
    elseif(NOT TEST_VISTA_COVERAGE_READABLE AND GTM_DIST)
      file(WRITE ${VISTA_BINARY_DIR}/gtm_coverage.mcov "packages:${TEST_VISTA_FRESH_M_DIR}/Packages\r\ncoverage_dir:${TEST_VISTA_OUTPUT_DIR}/Coverage")
    endif()
  endif()
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO RUN UNIT TESTING #####
#-----------------------------------------------------------------------------#
OPTION(TEST_VISTA_MUNIT "Run Automated Unit Testing" OFF)
OPTION(TEST_VISTA_SETUP_MUNIT "Install MUNIT KIDS BUILD" OFF)
if(TEST_VISTA_MUNIT AND TEST_VISTA_FRESH AND NOT TEST_VISTA_SETUP_MUNIT)
  message(WARNING "Current configuration will cause Dashboard submissions to fail all MUnit Tests. Either include TEST_VISTA_SETUP_MUNIT or remove TEST_VISTA_FRESH")
endif()
if(TEST_VISTA_MUNIT)
  file(GLOB PACKAGES ${VISTA_SOURCE_DIR}/Packages/*)
  # Set up the platform dependent script files
  if(TEST_VISTA_SETUP_MUNIT AND TEST_VISTA_SETUP_MUNIT_PATCH_FILE AND TEST_VISTA_SETUP_MUNIT_PATCH_NAME)
    message(STATUS "Installing MUnit KIDS Build")
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Setup/${MUNIT_INSTALLATION_SCRIPT}.in ${CMAKE_CURRENT_BINARY_DIR}/Setup/${MUNIT_INSTALLATION_SCRIPT})
    execute_process(COMMAND "${PYTHON_EXECUTABLE}" "${CMAKE_CURRENT_BINARY_DIR}/Setup/${MUNIT_INSTALLATION_SCRIPT}")
  endif()
  foreach(package ${PACKAGES})
    get_filename_component(package_name ${package} NAME)
    if(IS_DIRECTORY ${package}/Testing/MUnit)
      file(STRINGS "${package}/Testing/MUnit/TestList" routines )
      set(send_commands "")
      foreach(routine ${routines})
        get_filename_component(routine_name ${routine} NAME_WE)
        set(send_commands "${send_commands}VistA.write('D ^${routine_name}')\n")
        set(send_commands "${send_commands}VistA.wait(PROMPT)\n")
      endforeach()
      string(REPLACE  " " "_" package_file_name "${package_name}")
      #Configures the python script with the name of the routine
      set(RoutineImportFile "${SCRIPT_OUTPUT_DIR}/${package_file_name}Routines.ro")
      set(logfile "${UNITTEST_LOG_DIR}/${package_file_name}RoutineImport.log")
      configure_file("${CMAKE_CURRENT_SOURCE_DIR}/Setup/RoutineImport.py.in" "${SCRIPT_OUTPUT_DIR}/${package_file_name}RoutineImport.py")
      set(logfile "${UNITTEST_LOG_DIR}/${package_file_name}.log")
      configure_file("${CMAKE_CURRENT_SOURCE_DIR}/UnitTest.py.in" "${SCRIPT_OUTPUT_DIR}/${package_file_name}.py")
      configure_file("${CMAKE_CURRENT_SOURCE_DIR}/UnitTest.cmake.in" "${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake" @ONLY)
      #Creates the command that will be called for the Test
      add_test(UNITTEST_${package_file_name} ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake)
    endif()
  endforeach()
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO RUN PACKAGE PREFIX PARSING TESTING #####
#-----------------------------------------------------------------------------#
add_test(PYTHON_PrefixParser ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/Python/PrefixParserTest.py "Uncategorized" "${CMAKE_CURRENT_SOURCE_DIR}/Python/PackagePrefixSample.csv")

#-----------------------------------------------------------------------------#
##### SECTION TO RUN PYTHON UNIT TEST(s) under Scripts/Testing/PyUnit #####
#-----------------------------------------------------------------------------#
file(GLOB PyUnitTests ${VISTA_SOURCE_DIR}/Scripts/Testing/PyUnit/Test*.py)
foreach(PyUnitTest ${PyUnitTests})
  get_filename_component(PyUnitTestName "${PyUnitTest}" NAME_WE)
  add_test(PyUnitTest_${PyUnitTestName} ${PYTHON_EXECUTABLE} ${PyUnitTest})
  set_tests_properties(PyUnitTest_${PyUnitTestName}
                       PROPERTIES FAIL_REGULAR_EXPRESSION "FAILED")
endforeach()
