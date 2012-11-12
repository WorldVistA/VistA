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

set(CMAKE_MAKE_PROGRAM "/" CACHE INTERNAL "This does not build")
set(CMAKE_INSTALL_PREFIX "/" CACHE INTERNAL "This does not install")
project(VISTA NONE)

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
option(USE_XINDEX_WARNINGS_AS_FAILURES "Use warnings as a failure condition for XINDEX tests?" OFF)
option(BUILD_REPORTS "Build Reports." OFF)
option(CLEAN_DATABASE "Overwrite the database file during build phase of testing? To remove this option, delete the CMake Cache" OFF)

# how much time to allocate in seconds for the process of importing globals
set(GLOBALS_IMPORT_TIMEOUT 3600 CACHE STRING "Timeout in seconds for importing globals")

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
else()
# append hard-coded guesses for linux
  list(APPEND _Cache_PATHS
    "/usr/bin"
    "/usr/local/bin"
  )
endif()
foreach(tool ccontrol CTerm)
  find_program(${tool} NAMES ${tool} DOC "Path to Cache ${tool}" PATHS ${_Cache_PATHS})
endforeach()

#-----------------------------------------------------------------------------
find_file(GTMPROFILE NAMES gtmprofile DOC "Path to the GTM Profile")
find_path(OSEHRA_PATH NAMES VistA-FOIA DOC "Path to the folder that contains the routines and globals from OSEHRA")
find_path(PRISTINE_CACHE_DAT_PATH NAMES CACHE.DAT DOC "Path to the folder that contains a pristine empty CACHE.DAT file")
#------ SET UP UNIT TEST ENV -----#
find_file(MUNIT_KIDS_FILE NAMES XT_7-3_81_TESTVER9.KID DOC "Path to the MUNIT KIDS file XT_7-3_81_TESTVER9.KID")
set(MUNIT_PACKAGE_INSTALL_NAME "XT*7.3*81" CACHE STRING "MUnit Kids build package install name")
  SET(MUNIT_INSTALLATION_SCRIPT "InstallMUnitKIDSBuild.py")
if(MUNIT_KIDS_FILE)
  file(TO_NATIVE_PATH ${MUNIT_KIDS_FILE} MUNIT_KIDS_FILE)
endif()

SET(SCRIPT_OUTPUT_DIR "${VISTA_BINARY_DIR}/UnitTest/")
SET(UNITTEST_LOG_DIR "${SCRIPT_OUTPUT_DIR}/Log")
file(MAKE_DIRECTORY "${UNITTEST_LOG_DIR}")

#if ccontrol is found, the Cache system and paths are used
if(ccontrol)
  SET(VENDER_NAME "Cache")
  if(NOT INSTANCE)
    # Detect Cache instances.
    if(WIN32)
      execute_process(
        COMMAND ${ccontrol} qlist nodisplay
        OUTPUT_FILE ${VISTA_BINARY_DIR}/cache_qlist.txt
        ERROR_VARIABLE err
        RESULT_VARIABLE failed
        TIMEOUT 30 # should never happen, listing is fast
        )
    else()
      execute_process(
        COMMAND ${ccontrol} qlist
        OUTPUT_FILE ${VISTA_BINARY_DIR}/cache_qlist.txt
        ERROR_VARIABLE err
        RESULT_VARIABLE failed
        TIMEOUT 30
        )
    endif()
    if(failed)
      string(REPLACE "\n" "\n  " err "  ${err}")
      message(FATAL_ERROR "Failed to run \"${ccontrol} qlist \": ${failed}\n${err}")
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
  set(VOLUME_SET "VISTA" CACHE STRING "Volume Set for new Vista Instance")

  if(WIN32)
    configure_file(${VISTA_SOURCE_DIR}/CacheVerifyTelnet.scp.in ${VISTA_BINARY_DIR}/CacheVerifyTelnet.scp)
    message(STATUS "Testing if Cache Telnet service is enable:")
    execute_process(COMMAND "@CTerm@" "/console=cn_iptcp:127.0.0.1[23]" "${VISTA_BINARY_DIR}/CacheVerifyTelnet.scp" "${VISTA_BINARY_DIR}/CacheVerifyTelnet.log" TIMEOUT 5 RESULT_VARIABLE rcode)
    message(STATUS "Testing if Cache Telnet service is enable: ${rcode}")
    if ( (rcode EQUAL 0) OR "${rcode}" MATCHES "timeout" )
      message(FATAL_ERROR "Error connecting to Cache ${INSTANCE} namespace ${NAMESPACE} via telnet, please enable the telnet setting via"
        " Cache Managements Portal->System->Security Management->Service to switch on %Service_telnet by checking enabled checkbox and save."
        " Also verify that telnet port is set to 23 via Configuration->Device Settings->Telnet Settings ")
    endif()
  endif()
endif()

#if gtmprofile.sh is found, the linux programs and GT.M testing evironment is used.
if(GTMPROFILE)
  SET(VENDER_NAME "GTM")
  get_filename_component(GTMDIR ${GTMPROFILE} PATH)

  #Finds the scripting program for the Linux Based system
  find_program(EXPECT_EXEC NAMES expect)
  set(UCI_NAME "PLA" CACHE STRING "GTM  UCI to store VistA")
  set(VOLUME_SET "PLA" CACHE STRING "Volume Set for new Vista Instance")

  #Creates variables for the routines and globals directorys within GT.M
  find_path (VISTA_ROUTINE_DIR NAMES Routines HINTS ${VISTA_SOURCE_DIR}/routines DOC "Path to the Routines folder within GT.M")
  find_path (VISTA_GLOBALS_DIR NAMES Globals HINTS ${VISTA_SOURCE_DIR}/globals DOC " Path to the folder that contains the GT.M database.dat")


  #Configures a .sh file to completely set up the environment variables beyond what sourcing the gtmprofile will
  configure_file(${VISTA_SOURCE_DIR}/GTMEnvironment.sh.in ${VISTA_BINARY_DIR}/GTMEnvironment.sh @ONLY)

  # Creates the reports folder with style guides for submitting to the OSEHR journal if the option is selected.
  if( BUILD_REPORTS )
    add_subdirectory( Reports )
  endif(BUILD_REPORTS)
endif()

option(USE_LOGIN "Sign into the VistA Instance using a name and password" OFF)
if(USE_LOGIN)
  set (USERNAME "admin" CACHE STRING "Username for instance")
  set (PASSWORD "cache" CACHE STRING "Password for instance")
endif()


# Glob through the Packages directory for the routines to test.
file(GLOB PACKAGES ${OSEHRA_PATH}/Packages/*)
foreach(package ${PACKAGES})
  get_filename_component(package_name ${package} NAME)
  string(REGEX MATCH ^[.] Packageflag ${package_name})
  string(REPLACE  " " "_" package_file_name "${package_name}")

  # Variables for creating the testing scripts based upon system and found files
  option(CHANGE_NAMESPACE OFF "When first connecting to the instance, change to the desired namespace")
  option(USE_LOGIN "Sign into the VistA Instance using a name and password" OFF)

  if(NOT Packageflag)
    file(GLOB routines "${package}/Routines/*.m")
    set(send_commands "")

    foreach(routine ${routines})
      get_filename_component(routine_name ${routine} NAME_WE)
      set(send_commands "${send_commands},${routine_name}")
    endforeach()
    string(REGEX REPLACE  "^," "" send_commands "${send_commands}")
    list(LENGTH routines NumberRoutines)
    string(REPLACE  " " "_" package_file_name "${package_name}")

    #Configures the CMAKE testing
    configure_file(${VISTA_SOURCE_DIR}/PythonRoutine.cmake.in ${VISTA_BINARY_DIR}/Testing/${package_file_name}Test.cmake @ONLY)
    #Creates the command that will be called for the Test
    add_test(XINDEX_${package_file_name} ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/Testing/${package_file_name}Test.cmake)
  endif()
endforeach()


IF(CLEAN_DATABASE)
  set(VISTA_SITE_NAME "DEMO.OSEHRA.ORG" CACHE STRING "Name to set for the site address when initializing VistA instance.  Default is 'DEMO.OSEHRA.ORG'")
  set(RoutineImportFile "${VISTA_BINARY_DIR}/routines.ro")
  configure_file(${VISTA_SOURCE_DIR}/ImportRG.cmake.in ${VISTA_BINARY_DIR}/ImportRG.cmake @ONLY)
  set(logfile "${VISTA_BINARY_DIR}/Testing/Log/RoutineImport.log")
  configure_file(${VISTA_SOURCE_DIR}/RoutineImport.py.in ${VISTA_BINARY_DIR}/RoutineImport.py)
  set(logfile "${VISTA_BINARY_DIR}/Testing/Log/GlobalImport.log")
  configure_file(${VISTA_SOURCE_DIR}/GlobalImport.py.in ${VISTA_BINARY_DIR}/GlobalImport.py)
  set(logfile "${VISTA_BINARY_DIR}/Testing/Log/Initialize.log")
  configure_file(${VISTA_SOURCE_DIR}/Initialize.py.in ${VISTA_BINARY_DIR}/Initialize.py)
  set(logfile "${VISTA_BINARY_DIR}/Testing/Log/PostImport.log")
  if(MUNIT_KIDS_FILE AND MUNIT_PACKAGE_INSTALL_NAME)
    configure_file(${VISTA_SOURCE_DIR}/${MUNIT_INSTALLATION_SCRIPT}.in ${VISTA_BINARY_DIR}/${MUNIT_INSTALLATION_SCRIPT})
  endif()
  set(MAKECOMMAND " ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/ImportRG.cmake" CACHE STRING "Import Routines and Globals into CACHE as Build Step" FORCE)
ELSE()
  set(MAKECOMMAND " ${CMAKE_COMMAND} -E echo No_Build_Required" CACHE STRING "No build process is required when CLEAN_CACHE if OFF" FORCE)
ENDIF()

configure_file(CTestCustom.cmake.in ${VISTA_BINARY_DIR}/CTestCustom.cmake)
include(CTest)

#-----------------------------------------------------------------------------#
##### SECTION TO SETUP AUTOMATIC SYSTEM TESTING #####
#-----------------------------------------------------------------------------#
option(SIK_SYSTEM_TESTING "Use Python and Sikuli to test Vitals and CPRS" OFF)
option(RAS_SYSTEM_TESTING "Use Python to test VistA via roll and scroll" OFF)
option(VISTA_SETUP_SITE "Prepopulate the database with sample data including users, patients, locations, etc. " ON)
if(VISTA_SETUP_SITE)
  set(logfile "${VISTA_BINARY_DIR}/Testing/Log/PostImport.log")
  configure_file("${VISTA_SOURCE_DIR}/PostImportSetupScript.py.in" "${VISTA_BINARY_DIR}/PostImportSetupScript.py")
  configure_file("${VISTA_SOURCE_DIR}/importUsers.py.in" "${VISTA_BINARY_DIR}/importUsers.py")
  configure_file("${VISTA_SOURCE_DIR}/ClinicSetup.py.in" "${VISTA_BINARY_DIR}/ClinicSetup.py")
endif()
if((SIK_SYSTEM_TESTING OR RAS_SYSTEM_TESTING) AND VISTA_SETUP_SITE)
  add_subdirectory(FunctionalTest)
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO GENERATE VISUAL CROSS REFERENCE DOCUMENTATION #####
#-----------------------------------------------------------------------------#
OPTION(ROUTINE_CALL_GRAPH "Build Rouine Call Graph." OFF)
if(ROUTINE_CALL_GRAPH)
  file(GLOB PACKAGES ${OSEHRA_PATH}/Packages/*)
  SET(SCRIPT_OUTPUT_DIR "${VISTA_BINARY_DIR}/Docs/CallerGraph")
  SET(CALLER_GRAPH_LOG_DIR "${SCRIPT_OUTPUT_DIR}/Log")
  file(MAKE_DIRECTORY "${CALLER_GRAPH_LOG_DIR}")
  foreach(package ${PACKAGES})
    get_filename_component(package_name ${package} NAME)
    if(IS_DIRECTORY ${package})
      file(GLOB routines "${package}/Routines/*.m")
      set(AllRoutines "")
      foreach(routine ${routines})
        get_filename_component(routine_name ${routine} NAME_WE)
        set(AllRoutines "${AllRoutines}AllRoutines.append(\"${routine_name}\")\n")
      endforeach()
      string(REPLACE  " " "_" package_file_name "${package_name}")
      set(logfile "@CALLER_GRAPH_LOG_DIR@/@package_file_name@.log")
      #Configures the python script with the name of the routine
      configure_file(${VISTA_SOURCE_DIR}/XindexCallerGraph.py.in
                     ${SCRIPT_OUTPUT_DIR}/${package_file_name}.py)

      configure_file(${VISTA_SOURCE_DIR}/XindexCallerGraph.cmake.in
                     ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake @ONLY)

      #Creates the command that will be called for the Test
      add_test(CALLERGRAPH_${package_file_name} ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake)
    endif()
  endforeach()
  configure_file(${VISTA_SOURCE_DIR}/FileManGlobalAttributes.py.in ${VISTA_BINARY_DIR}/FilemanGlobalAttributes.py)
  configure_file(${VISTA_SOURCE_DIR}/GetFilemanSchema.cmake.in ${VISTA_BINARY_DIR}/GetFilemanSchema.cmake @ONLY)
  add_test(CALLERGRAPH_GetFilemanSchema ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/GetFilemanSchema.cmake)
endif()
#-----------------------------------------------------------------------------#
##### SECTION TO RUN UNIT TESTING #####
#-----------------------------------------------------------------------------#
OPTION(AUTOMATED_UNIT_TESTING "Run Automated Unit Testing" OFF)
OPTION(INSTALL_MUNIT "Install MUNIT KIDS BUILD" OFF)
if(AUTOMATED_UNIT_TESTING AND CLEAN_DATABASE AND NOT INSTALL_MUNIT)
  message(WARNING "Current configuration will cause Dashboard submissions to fail all MUnit Tests. Either include INSTALL_MUNIT or remove CLEAN_DATABASE")
endif()
if(AUTOMATED_UNIT_TESTING)
  file(GLOB PACKAGES ${VISTA_SOURCE_DIR}/UnitTest/VistA-FOIA/Packages/*)
  # Set up the platform dependent script files
  if(INSTALL_MUNIT AND MUNIT_KIDS_FILE AND MUNIT_PACKAGE_INSTALL_NAME)
    message(STATUS "Installing MUnit KIDS Build")
    configure_file(${VISTA_SOURCE_DIR}/${MUNIT_INSTALLATION_SCRIPT}.in ${VISTA_BINARY_DIR}/${MUNIT_INSTALLATION_SCRIPT})
    execute_process(COMMAND "${PYTHON_EXECUTABLE}" "${VISTA_BINARY_DIR}/${MUNIT_INSTALLATION_SCRIPT}")
  endif()
  foreach(package ${PACKAGES})
    get_filename_component(package_name ${package} NAME)

    if(IS_DIRECTORY ${package})
      file(GLOB routines "${package}/*.m")
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
      configure_file("${VISTA_SOURCE_DIR}/RoutineImport.py.in" "${SCRIPT_OUTPUT_DIR}/${package_file_name}RoutineImport.py")
      set(logfile "${UNITTEST_LOG_DIR}/${package_file_name}.log")
      configure_file("${VISTA_SOURCE_DIR}/UnitTest.py.in" "${SCRIPT_OUTPUT_DIR}/${package_file_name}.py")
      configure_file("${VISTA_SOURCE_DIR}/UnitTest.cmake.in" "${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake" @ONLY)

      #Creates the command that will be called for the Test
      add_test(UNITTEST_${package_file_name} ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake)
    endif()
  endforeach()
endif()
