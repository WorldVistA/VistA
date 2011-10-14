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

include(CTest)
set(BUILD_TESTING "ON" CACHE INTERNAL "Always build testing")

#options that will show up on the CMake Gui that allows customization of the project
option(BUILD_REPORTS "Build Reports." OFF)
option(WARNING_FAILURE "Use the XINDEX Condition output of warning as a failure condition for testing" ON)
mark_as_advanced(WARNING_FAILURE)

#-----------------------------------------------------------------------------
# Find InterSystems Cache
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
endif()
foreach(tool CControl CTerm)
  find_program(${tool} NAMES ${tool} DOC "Path to Cache ${tool}" PATHS ${_Cache_PATHS})
endforeach()

#-----------------------------------------------------------------------------
find_file(GTMPROFILE NAMES gtmprofile DOC "Path to the GTM Profile")
find_path(OSEHRA_PATH NAMES VistA-FOIA DOC "Path to the folder that contains the routines and globals from OSEHRA")
find_path(PRISTINE_CACHE_DAT_PATH NAMES CACHE.DAT DOC "Path to the folder that contains a pristine empty CACHE.DAT file")

set(FAILURE_CONDITIONS "F -" "W -")

#if CTerm is found, the Cache system and paths are used
if(CControl AND CTerm)
  if(NOT INSTANCE)
    # Detect Cache instances.
    execute_process(
      COMMAND ${CControl} qlist nodisplay
      OUTPUT_FILE ${VISTA_BINARY_DIR}/cache_qlist.txt
      ERROR_VARIABLE err
      RESULT_VARIABLE failed
      TIMEOUT 30 # should never happen, listing is fast
      )
    if(failed)
      string(REPLACE "\n" "\n  " err "  ${err}")
      message(FATAL_ERROR "Failed to run \"${CControl} qlist nodisplay\": ${failed}\n${err}")
    endif()
    file(STRINGS ${VISTA_BINARY_DIR}/cache_qlist.txt qlist)
    set(instances "")
    foreach(instance ${qlist})
      string(REPLACE "^" ";" instance "${instance}")
      list(GET instance 0 name)
      list(GET instance 1 ${name}_DIRECTORY)
      list(GET instance 2 ${name}_VERSION)
      list(GET instance 6 ${name}_WEB_PORT)
      list(APPEND instances ${name})
    endforeach()

    # Select a default instance.
    set(default "")
    foreach(guess CACHEWEB TRYCACHE)
      if(${guess}_DIRECTORY)
        set(default ${guess})
        break()
      endif()
    endforeach()
    if(instances AND NOT default)
      list(GET instances 0 default)
    endif()

    # Present an INSTANCE option.
    set(INSTANCE "${default}" CACHE STRING "Cache instance name")
    set_property(CACHE INSTANCE PROPERTY STRINGS "${instances}")
  endif()
  message(STATUS "Using Cache instance ${INSTANCE}")

  find_path(VISTA_Path NAMES mgr DOC "Path to the VistA folder within Cache")

  # Creates the reports folder with style guides for submitting to the OSEHR journal if the option is selected
  if( BUILD_REPORTS )
    add_subdirectory( Reports )
  endif()

  # Select a namespace for VistA
  set(NAMESPACE "VISTA" CACHE STRING "Cache namespace to store VistA")

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
    add_test(XINDEX_${package_file_name} ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/Testing/${package_file_name}Test.cmake)

    #Sets a custom failure condition so that the test will fail if "W -" or "F -" is found in the test output
    set_property(TEST XINDEX_${package_file_name} PROPERTY FAIL_REGULAR_EXPRESSION "${FAILURE_CONDITIONS}" )

  endforeach()

  #end the program
  return()
endif()


#if gtmprofile.sh is found, the linux programs and GT.M testing evironment is used.
if(GTMPROFILE)

#Finds the scripting program for the Linux Based system
find_program(EXPECT_EXEC NAMES expect)

#Creates variables for the routines and globals directorys within GT.M
find_path (VISTA_ROUTINE_DIR NAMES Routines HINTS ${VISTA_SOURCE_DIR}/routines DOC "Path to the Routines folder within GT.M")
find_path (VISTA_GLOBALS_DIR NAMES Globals HINTS ${VISTA_SOURCE_DIR}/globals DOC " Path to the folder that contains the GT.M database.dat")


#Configures a .sh file to completely set up the environment variables beyond what sourcing the gtmprofile will
configure_file(${VISTA_SOURCE_DIR}/GTMEnvironment.sh.in ${VISTA_BINARY_DIR}/GTMEnvironment.sh @ONLY)

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
add_test( XINDEX_${package_file_name} ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/Testing/${package_file_name}.cmake)

 #Sets the failure conditions for the test, if either is found in the output the test is deemed to have failed.
set_property(TEST XINDEX_${package_file_name} PROPERTY FAIL_REGULAR_EXPRESSION "${FAILURE_CONDITIONS}")
endforeach()
#Configures a .sh File that can be used to automatically set up the proper environment and start a test that submits a Nightly test.
configure_file(${VISTA_SOURCE_DIR}/Nightly.sh.in ${VISTA_BINARY_DIR}/Nightly.sh @ONLY)
endif(GTMPROFILE)
