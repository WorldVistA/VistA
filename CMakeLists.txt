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


cmake_minimum_required(VERSION 2.8.0)

set(CMAKE_MAKE_PROGRAM " " CACHE string "N" FORCE)
project(VISTA NONE)


#options that will show up on the CMake Gui that allows customization of the project
option(BUILD_TESTING "Test the project" ON)
option(BUILD_REPORTS "Build Reports." OFF)
option(WARNING_FAILURE "Use the XINDEX Condition output of warning as a failure condition for testing" ON)
mark_as_advanced(WARNING_FAILURE)

#The next two options designate what system will be used as the Mumps Environment, this dicates the way routines are found.
find_program(CTerm NAMES CTerm.exe HINTS "C:/InterSystems/TryCache/bin/" DOC "Path to the CTerm executable of Cache")
find_program(CControl NAMES CControl.exe HINTS "C:/InterSystems/TryCache/bin/" DOC "Path to the CControl executable of Cache")
find_file(GTMPROFILE NAMES gtmprofile DOC "Path to the GTM Profile")
find_path(OSEHRA_PATH NAMES VistA-FOIA DOC "Path to the folder that contains the routines and globals from OSEHRA")
find_path(PRISTINE_CACHE_DAT_PATH NAMES CACHE.DAT DOC "Path to the folder that contains a pristine empty CACHE.DAT file")

set(FAILURE_CONDITIONS "F -" "W -")

#if CTerm is found, the Cache system and paths are used
if(CTerm)

  find_path(VISTA_Path NAMES mgr DOC "Path to the VistA folder within Cache")

  # Creates the Testing/Temporary/ directories used in CTest if the option is selected
  if(BUILD_TESTING)
    enable_testing()
    include(CTest)
  endif(BUILD_TESTING)

  # Creates the reports folder with style guides for submitting to the OSEHR journal if the option is selected
  if( BUILD_REPORTS )
    add_subdirectory( Reports )
  endif()

  if( VISTA_Path )
    #Captures the name of the VistA instance and server for configuring.
    get_filename_component(INSTANCE ${VISTA_Path} NAME)
    get_filename_component(TEMP ${VISTA_Path} PATH)
    get_filename_component(TEMP ${TEMP} PATH)
    get_filename_component(SERVER ${TEMP} NAME)
    string(COMPARE EQUAL ${SERVER} "Cache" match)
    if ( match )
      set(SERVER ${SERVER}Web)
    endif()
  endif()

  OPTION(CLEAN_CACHE "Overwrite the Cache.dat file during build phase of testing? To remove this option, delete the CMake Cache" OFF)

  find_program(GIT_EXEC NAMES git.exe HINTS "C:/Program Files (x86)/Git/bin/" DOC "Path to the Git Executable")
  find_program(PYTHON_EXEC NAMES python.exe "C:/Python27/bin/" DOC "Path to the Python Executable")

  IF(CLEAN_CACHE AND CControl AND PRISTINE_CACHE_DAT_PATH)
    configure_file(${VISTA_SOURCE_DIR}/ImportRG.cmake.in ${VISTA_BINARY_DIR}/ImportRG.cmake)
    configure_file(${VISTA_SOURCE_DIR}/RoutineImport.scp.in ${VISTA_BINARY_DIR}/RoutineImport.scp)
    configure_file(${VISTA_SOURCE_DIR}/GlobalImport.scp.in ${VISTA_BINARY_DIR}/GlobalImport.scp)
    configure_file(${VISTA_SOURCE_DIR}/Initialize.scp.in ${VISTA_BINARY_DIR}/Initialize.scp)
    set(MAKECOMMAND " ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/ImportRG.cmake" CACHE STRING "Import Routines and Globals into CACHE as Build Step" FORCE)
  ELSE()
    set(MAKECOMMAND " ${CMAKE_COMMAND} -E echo No_Build_Required" CACHE STRING "No build process is required when CLEAN_CACHE if OFF" FORCE)
  ENDIF()


  file(GLOB PACKAGES ${OSEHRA_PATH}/Packages/*)
  foreach(package ${PACKAGES})
    #message(${package})
    get_filename_component(package_name ${package} NAME)
    file(GLOB routines "${package}/Routines/*.m")
    set(send_commands "")
    foreach(routine ${routines})
      get_filename_component(routine_name ${routine} NAME_WE)
      set(send_commands "${send_commands} wait for:Routine:\n send:${routine_name}<CR>\n")
    endforeach()
    string(REPLACE  " " "_" package_file_name "${package_name}")

    #Configures the Cache Terminal script for testing, by replacing known variables in the .in file
    configure_file(${VISTA_SOURCE_DIR}/CacheXINDEXScript.in ${VISTA_BINARY_DIR}/Testing/${package_file_name}Test.scp)

    #Configures the CMAKE testing
    configure_file(${VISTA_SOURCE_DIR}/WinRoutine.cmake.in ${VISTA_BINARY_DIR}/Testing/${package_file_name}Test.cmake @ONLY)

    #Creates the command that will be called for the Test
    add_test(${package_file_name}Test ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/Testing/${package_file_name}Test.cmake)

    #Sets a custom failure condition so that the test will fail if "W -" or "F -" is found in the test output
    set_property(TEST ${package_file_name}Test PROPERTY FAIL_REGULAR_EXPRESSION "${FAILURE_CONDITIONS}" )

  endforeach()

  #end the program
  return()
endif(CTerm)


#if gtmprofile.sh is found, the linux programs and GT.M testing evironment is used.
if(GTMPROFILE)

#Finds the scripting program for the Linux Based system
find_program(EXPECT_EXEC NAMES expect)

#Creates variables for the routines and globals directorys within GT.M
find_path (VISTA_ROUTINE_DIR NAMES Routines HINTS ${VISTA_SOURCE_DIR}/routines DOC "Path to the Routines folder within GT.M")
find_path (VISTA_GLOBALS_DIR NAMES Globals HINTS ${VISTA_SOURCE_DIR}/globals DOC " Path to the folder that contains the GT.M database.dat")


#Configures a .sh file to completely set up the environment variables beyond what sourcing the gtmprofile will
configure_file(${VISTA_SOURCE_DIR}/GTMEnvironment.sh.in ${VISTA_BINARY_DIR}/GTMEnvironment.sh @ONLY)

# Creates the Testing/Temporary/ directories used in CTest if the option is selected
if(BUILD_TESTING)
    enable_testing()
    include(CTest)
endif(BUILD_TESTING)


# Creates the reports folder with style guides for submitting to the OSEHR journal if the option is selected.
if( BUILD_REPORTS )
  add_subdirectory( Reports )
  endif(BUILD_REPORTS)


  file(GLOB PACKAGES ${OSEHRA_PATH}/Packages/*)
  foreach(package ${PACKAGES})
    #message(${package})
    get_filename_component(package_name ${package} NAME)
    file(GLOB routines "${package}/Routines/*.m")
    set(send_commands "")
    foreach(routine ${routines})
      get_filename_component(routine_name ${routine} NAME_WE)
      set(send_commands "${send_commands} send \"${routine_name}\\n\"\n")
    endforeach()
    #message(${send_commands})
    string(REPLACE  " " "_" package_file_name "${package_name}")

#Configures the Expect script with the name of the routine
configure_file(${VISTA_SOURCE_DIR}/XINDEXscript.exp.in ${VISTA_BINARY_DIR}/Testing/${package_file_name}.exp)

#Configures the CMake file to be called by the correct test and call the correct script
configure_file(${VISTA_SOURCE_DIR}/RoutineTest.cmake.in ${VISTA_BINARY_DIR}/Testing/${package_file_name}.cmake @ONLY)

#Adds the test to the list available
add_test( ${package_file_name}Test ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/Testing/${package_file_name}.cmake)

 #Sets the failure conditions for the test, if either is found in the output the test is deemed to have failed.
set_property(TEST ${package_file_name}Test PROPERTY FAIL_REGULAR_EXPRESSION "${FAILURE_CONDITIONS}")
endforeach()
#Configures a .sh File that can be used to automatically set up the proper environment and start a test that submits a Nightly test.
configure_file(${VISTA_SOURCE_DIR}/Nightly.sh.in ${VISTA_BINARY_DIR}/Nightly.sh @ONLY)
endif(GTMPROFILE)
