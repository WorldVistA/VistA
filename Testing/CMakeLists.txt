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
SET(SCRIPT_OUTPUT_DIR "${VISTA_BINARY_DIR}/UnitTest/")
SET(UNITTEST_LOG_DIR "${SCRIPT_OUTPUT_DIR}/Log")
file(MAKE_DIRECTORY "${UNITTEST_LOG_DIR}")
include(CommonFunctions)

if(GTM_DIST)
  include(UseGTM)
elseif(CCONTROL_EXECUTABLE)
  include(UseCache)
endif()

#---------------------------------------------------------------------------------#
##### SECTION TO GENERATE FILES FOR COVERAGE (Using CMake V 2.8.9 and Higher) #####
#---------------------------------------------------------------------------------#

if(${CMAKE_VERSION} VERSION_GREATER 2.8.8)

  if(EXISTS "${TEST_VISTA_OUTPUT_DIR}/Coverage/routines.ro")
    file(REMOVE "${TEST_VISTA_OUTPUT_DIR}/Coverage/routines.ro")
  endif()

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

    if(EXISTS "${TEST_VISTA_OUTPUT_DIR}/Coverage/")
      message("Removing old coverage data")
      file(REMOVE_RECURSE "${TEST_VISTA_OUTPUT_DIR}/Coverage/")
    endif()
    file(MAKE_DIRECTORY "${TEST_VISTA_OUTPUT_DIR}/Coverage")
    file(MAKE_DIRECTORY "${TEST_VISTA_OUTPUT_DIR}/Coverage/CoverageSource")

    set(TEST_VISTA_COVERAGE_SUBSET_DIR CACHE PATH "Path to a folder with routines to calculate coverage for" )
    mark_as_advanced(TEST_VISTA_COVERAGE_SUBSET_DIR)
    set(VendorArgs "")
    SetVendorArgs(VendorArgs)
    message("${TEST_VISTA_COVERAGE_SUBSET}")
    set(ARGUMENTS "${VendorArgs}" "-o" "${TEST_VISTA_OUTPUT_DIR}/Coverage/routines.ro" "-r")
    if(TEST_VISTA_COVERAGE_SUBSET_DIR)
      set(TEST_VISTA_COVERAGE_SUBSET "[")
      file(GLOB_RECURSE TEST_VISTA_COVERAGE_SUBSET_PATHS "${TEST_VISTA_COVERAGE_SUBSET_DIR}/*.m")
      foreach(path ${TEST_VISTA_COVERAGE_SUBSET_PATHS})
        get_filename_component(routine_name ${path} NAME_WE)
        set(TEST_VISTA_COVERAGE_SUBSET "${TEST_VISTA_COVERAGE_SUBSET},'${routine_name}'")
        set(ARGUMENTS ${ARGUMENTS} "${routine_name}")
      endforeach()
      set(TEST_VISTA_COVERAGE_SUBSET "${TEST_VISTA_COVERAGE_SUBSET}]")
      STRING(REPLACE "[," "[" TEST_VISTA_COVERAGE_SUBSET ${TEST_VISTA_COVERAGE_SUBSET})
    else()
      set(TEST_VISTA_COVERAGE_SUBSET "['*']")
      set(ARGUMENTS ${ARGUMENTS} "*")
    endif()

    if(NOT TEST_VISTA_COVERAGE_READABLE AND "${VENDOR_NAME}" STREQUAL "Cache")
      file(WRITE ${VISTA_BINARY_DIR}/cache_coverage.cmcov "packages:${TEST_VISTA_OUTPUT_DIR}/Coverage/CoverageSource\r\ncoverage_dir:${TEST_VISTA_OUTPUT_DIR}/Coverage")
    elseif(NOT TEST_VISTA_COVERAGE_READABLE AND "${VENDOR_NAME}" STREQUAL "GTM")
      file(WRITE ${VISTA_BINARY_DIR}/gtm_coverage.mcov "packages:${TEST_VISTA_OUTPUT_DIR}/Coverage/CoverageSource\r\ncoverage_dir:${TEST_VISTA_OUTPUT_DIR}/Coverage")
    endif()

    add_test(COV_PrepareSource ${PYTHON_EXECUTABLE} "${CMAKE_SOURCE_DIR}/Scripts/VistACoveragePrep.py" ${ARGUMENTS})
  endif()
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO SETUP THE XINDEX TESTING` #####
#-----------------------------------------------------------------------------#

option(TEST_VISTA_XINDEX "Run XINDEX on every routine in every package" ON)
if(TEST_VISTA_XINDEX)
  FindPackages(${VISTA_SOURCE_DIR})
  list(APPEND PACKAGES "Uncategorized")
  foreach(package_file_name ${PACKAGES})
    #Configures the CMAKE testing
    set(LOGFILENAME "${TEST_VISTA_OUTPUT_DIR}/${package_file_name}Test.log")
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/XINDEXScript.cmake.in ${VISTA_BINARY_DIR}/Testing/XINDEX/${package_file_name}Test.cmake @ONLY)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/XINDEXScript.py.in ${VISTA_BINARY_DIR}/Testing/XINDEX/${package_file_name}Test.py @ONLY)
    #Creates the command that will be called for the Test
    add_test(XINDEX_${package_file_name} ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/Testing/XINDEX/${package_file_name}Test.cmake)
  endforeach()
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO RUN UNIT TESTING #####
#-----------------------------------------------------------------------------#
OPTION(TEST_VISTA_MUNIT "Run Automated Unit Testing" OFF)
if(TEST_VISTA_MUNIT)
  file(GLOB PACKAGES ${VISTA_SOURCE_DIR}/Packages/*)
  # Set up the platform dependent script files
  foreach(package ${PACKAGES})
    get_filename_component(package_name ${package} NAME)
    if(IS_DIRECTORY ${package}/Testing/MUnit)
      file(GLOB UNIT_TEST_FILES "${VISTA_SOURCE_DIR}/Packages/${package_name}/Testing/MUnit/*.m.in" )
      foreach(testfile ${UNIT_TEST_FILES})
        get_filename_component(routine_name ${testfile} NAME_WE)
        configure_file("${testfile}" "${VISTA_SOURCE_DIR}/Packages/${package_name}/Testing/MUnit/${routine_name}.m")
      endforeach()
      file(STRINGS "${package}/Testing/MUnit/TestList" routines )
      set(send_commands "")
      foreach(routine_command ${routines})
        set(send_commands "${send_commands}VistA.write('${routine_command}')\n")
        set(send_commands "${send_commands}VistA.wait(PROMPT,60)\n")
      endforeach()
      string(REPLACE  " " "_" package_file_name "${package_name}")
      #Configures the python script with the name of the routine
      set(RoutineImportFile "${SCRIPT_OUTPUT_DIR}/${package_file_name}Routines.ro")
      set(logfile "${UNITTEST_LOG_DIR}/${package_file_name}RoutineImport.log")
      set(RoutineImportDir ${TEST_VISTA_GTM_ROUTINE_DIR})
      configure_file("${CMAKE_CURRENT_SOURCE_DIR}/Setup/RoutineImport.py.in" "${SCRIPT_OUTPUT_DIR}/${package_file_name}RoutineImport.py")
      set(logfile "${UNITTEST_LOG_DIR}/${package_file_name}.log")
      configure_file("${CMAKE_CURRENT_SOURCE_DIR}/UnitTest.py.in" "${SCRIPT_OUTPUT_DIR}/${package_file_name}.py")
      configure_file("${CMAKE_CURRENT_SOURCE_DIR}/UnitTest.cmake.in" "${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake" @ONLY)
      #Creates the command that will be called for the Test
      add_test(UNITTEST_${package_file_name} ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake)
      set_tests_properties(UNITTEST_${package_file_name} PROPERTIES FAIL_REGULAR_EXPRESSION "QUITTING")
    endif()
  endforeach()
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO SETUP THE FILEMAN "VERIFY FIELDS" TESTING #####
#-----------------------------------------------------------------------------#
option(TEST_VISTA_VERIFYFIELDS "Run the 'Verify Fields' FileMan Utility on every file in each package" OFF)
mark_as_advanced(TEST_VISTA_VERIFYFIELDS)
if(TEST_VISTA_VERIFYFIELDS)
  FindPackages(${VISTA_SOURCE_DIR})
  foreach(package_file_name ${PACKAGES})
    # Configures the CMAKE testing
    set(LOGFILENAME "${TEST_VISTA_OUTPUT_DIR}/${package_file_name}VFTest.log")
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/VerifyFields.py.in ${VISTA_BINARY_DIR}/Testing/VerifyFields/${package_file_name}VFTest.py @ONLY)
    # Creates the command that will be called for the Test
    add_test(VerifyFields_${package_file_name} ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/VerifyFields/${package_file_name}VFTest.py)
  endforeach()
endif()

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
# this option is reserved for dashboard submission
if (TEST_VISTA_OTJ_SUBMISSION)
  add_subdirectory(OTJ)
endif()



#-----------------------------------------------------------------------------#
##### SECTION TO RUN PACKAGE PREFIX PARSING TESTING #####
#-----------------------------------------------------------------------------#
add_test(PYTHON_PrefixParser ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/Python/PrefixParserTest.py "Uncategorized" "${CMAKE_CURRENT_SOURCE_DIR}/Python/PackagePrefixSample.csv")

#-----------------------------------------------------------------------------#
##### SECTION TO RUN PYTHON UNIT TEST(s) under Scripts/Testing/PyUnit #####
#-----------------------------------------------------------------------------#
file(GLOB PyUnitTests ${VISTA_SOURCE_DIR}/Scripts/Testing/PyUnit/Test*.py)
set(VendorArgs "")
SetVendorArgs(VendorArgs)
foreach(PyUnitTest ${PyUnitTests})
  get_filename_component(PyUnitTestName "${PyUnitTest}" NAME_WE)
  if(${PyUnitTestName} STREQUAL "TestSSEP")
    set(ARGUMENTS
      "-ha" "${VISTA_TCP_HOST}"
      "-hp" "${VISTA_TCP_PORT}"
      "-l"  "${CMAKE_CURRENT_BINARY_DIR}/Temporary/TestSSEP.log"
      "${VendorArgs}"
      )
  elseif("${PyUnitTestName}" MATCHES "TestClient$")
    set(ARGUMENTS "${VendorArgs}")
  endif()
  add_test(PyUnitTest_${PyUnitTestName} ${PYTHON_EXECUTABLE} ${PyUnitTest} ${ARGUMENTS})
  set_tests_properties(PyUnitTest_${PyUnitTestName}
                       PROPERTIES FAIL_REGULAR_EXPRESSION "FAILED")
endforeach()

#-----------------------------------------------------------------------------#
##### SECTION TO RUN MENU TRAVERSAL TESTING #####
#-----------------------------------------------------------------------------#
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/Python/MenuTraversalTest.py.in" "${CMAKE_CURRENT_BINARY_DIR}/Python/MenuTraversalTest.py")
add_test(PYTHON_MenuTraversal ${PYTHON_EXECUTABLE} "${CMAKE_CURRENT_BINARY_DIR}/Python/MenuTraversalTest.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/Python/MenuTraversalSmokeTest.py.in" "${CMAKE_CURRENT_BINARY_DIR}/Python/MenuTraversalSmokeTest.py")

#-----------------------------------------------------------------------------#
##### SECTION TO ADD USER GENERATED TESTS #####
#-----------------------------------------------------------------------------#
option(TEST_VISTA_USERTEST "Add tests from the Testing/UserTest/CMakeLists.txt file?" OFF)
if(TEST_VISTA_USERTEST)
  add_subdirectory(UserTest)
endif()
