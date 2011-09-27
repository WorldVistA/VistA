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

set(CMAKE_MAKE_PROGRAM EMPTY CACHE string "N" FORCE)
project(VISTA NONE)


#options that will show up on the CMake Gui that allows customization of the project
option(BUILD_TESTING "Test the project" ON)
option(BUILD_REPORTS "Build Reports." OFF)
option(WARNING_FAILURE "Use the XINDEX Condition output of warning as a failure condition for testing" ON)
mark_as_advanced(WARNING_FAILURE)

#The next two options designate what system will be used as the Mumps Environment, this dicates the way routines are found.
find_program(CControl NAMES Ccontrol.exe HINTS "C:/InterSystems/TryCache/bin/" DOC "Path to the Ccontrol executable of Cache")
find_file(GTMPROFILE NAMES gtmprofile DOC "Path to the GTM Profile")

set(FAILURE_CONDITIONS "F -" "W -")

#if CControl is found, the Cache system and paths are used
if(CControl)

# Creates the Testing/Temporary/ directories used in CTest if the optino is selected
if(BUILD_TESTING)
    enable_testing()
    include(CTest)
endif(BUILD_TESTING)


# Creates the reports folder with style guides for submitting to the OSEHR journal if the option is selected
if( BUILD_REPORTS )
  add_subdirectory( Reports )
endif()

    find_program(AutoHK NAMES AutoHotKey.exe DOC "Path to the executable for AutoHotKey")                                                                                                #AutoHotKey is our Windows Driver to automate the XINDEX routine
    find_path(VISTA_Path NAMES mgr DOC "Path to the VistA folder within Cache")

    #Captures the name of the VistA instance and server for configuring.
    get_filename_component(INSTANCE ${VISTA_Path} NAME)
    get_filename_component(TEMP ${VISTA_Path} PATH)
    get_filename_component(TEMP ${TEMP} PATH)
    get_filename_component(SERVER ${TEMP} NAME)
    string(COMPARE EQUAL ${SERVER} "Cache" match)
    if (match )
    set(SERVER ${SERVER}Web)
    endif()



	#Calls the routines by the first letter of the name
    foreach( Letter A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

	#Configures the AHK script for testing, by replacing known variables in the .in file
    configure_file(${VISTA_SOURCE_DIR}/CacheXINDEXScript.ahk.in ${VISTA_BINARY_DIR}/Testing/${Letter}Test.ahk)

	#Configures the CMAKE testing
    configure_file(${VISTA_SOURCE_DIR}/WinRoutine.cmake.in ${VISTA_BINARY_DIR}/Testing/${Letter}Test.cmake @ONLY)

	#Creates the command that will be called for the Test
	add_test(${Letter}Test ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/Testing/${Letter}Test.cmake)

	#Sets a custom failure condition so that the test will fail if "W -" or "F -" is found in the test output
    set_property(TEST ${Letter}Test PROPERTY FAIL_REGULAR_EXPRESSION "${FAILURE_CONDITIONS}" )
    endforeach()

	#end the program
    return()
endif(CControl)


#if gtmprofile.sh is found, the linux programs and GT.M testing evironment is used.
if(GTMPROFILE)

#Finds the scripting program for the Linux Based system
find_program(EXPECT_EXEC NAMES expect)

#Creates variables for the routines and globals directorys within GT.M
find_path (VISTA_ROUTINE_DIR NAMES Routines HINTS ${VISTA_SOURCE_DIR}/routines DOC "Path to the Routines folder within GT.M")
find_path (VISTA_GLOBALS_DIR NAMES Globals HINTS ${VISTA_SOURCE_DIR}/globals DOC " Path to the Globals folder within GT.M")

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

#Goes into the Routines directory and grabs all files with the extension ".m", it should find all the routines in that folder
 file (GLOB ROUTINES ${VISTA_ROUTINE_DIR}/*.m)

 #For every value that was grabbed in the previous step
foreach(ROUTINE ${ROUTINES})

#The files name is taken, leaving the extension behind
get_filename_component(RFILE ${ROUTINE} NAME_WE)

#This matches the first character on the files name
string(REGEX MATCH ^. CHAR1 ${RFILE})

#An underscore ( _ ) is used as the file name's first charater to represent a routine that starst with the percent sign (%)
if(${CHAR1} STREQUAL "_")
#This replaces the underscore in the string with a percent sign
    string(REGEX REPLACE ^[_] % RFILE ${RFILE})
endif()

#Configures the Expect script with the name of the routine
configure_file(${VISTA_SOURCE_DIR}/XINDEXscript.exp.in ${VISTA_BINARY_DIR}/Testing/${RFILE}.exp)

#Configures the CMake file to be called by the correct test and call the correct script
configure_file(${VISTA_SOURCE_DIR}/RoutineTest.cmake.in ${VISTA_BINARY_DIR}/Testing/${RFILE}.cmake @ONLY)

#Adds the test to the list available
add_test( ${RFILE}Test ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/Testing/${RFILE}.cmake)

 #Sets the failure conditions for the test, if either is found in the output the test is deemed to have failed.
set_property(TEST ${RFILE}Test PROPERTY FAIL_REGULAR_EXPRESSION "${FAILURE_CONDITIONS}")
endforeach()
#Configures a .sh File that can be used to automatically set up the proper environment and start a test that submits a Nightly test.
configure_file(${VISTA_SOURCE_DIR}/Nightly.sh.in ${VISTA_BINARY_DIR}/Nightly.sh @ONLY)
endif(GTMPROFILE)
