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


cmake_minimum_required(VERSION 2.8.2)

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
option(BUILD_REPORTS "Build Reports." OFF)

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
#------ SET UP UNIT TEST ENV -----#
find_file(MUNIT_KIDS_FILE NAMES XT_7-3_81_TESTVER9.KID DOC "Path to the MUNIT KIDS file XT_7-3_81_TESTVER9.KID")
set(MUNIT_PACKAGE_INSTALL_NAME "XT*7.3*81" CACHE STRING "MUnit Kids build package install name")
if(CTerm)
  SET(MUNIT_INSTALLATION_SCRIPT "InstallMUnitKIDSBuild.scp")
  SET(ROUTINE_IMPORT_SCRIPT "RoutineImport.scp")
  SET(UNIT_TEST_CMAKE_FILE "UnitTestEnvSetup.cmake")
elseif(GTMPROFILE)
  SET(MUNIT_INSTALLATION_SCRIPT "InstallMUnitKIDSBuild.exp")
  SET(ROUTINE_IMPORT_SCRIPT "RoutineImportGTM.exp")
  SET(UNIT_TEST_CMAKE_FILE "UnitTestEnvSetupGTM.cmake")
endif()
if(MUNIT_KIDS_FILE)
  file(TO_NATIVE_PATH ${MUNIT_KIDS_FILE} MUNIT_KIDS_FILE)
endif()

SET(SCRIPT_OUTPUT_DIR "${VISTA_BINARY_DIR}/UnitTest/")
SET(UNITTEST_LOG_DIR "${SCRIPT_OUTPUT_DIR}/Log")
file(MAKE_DIRECTORY "${UNITTEST_LOG_DIR}")

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
  set(VOLUME_SET "VISTA" CACHE STRING "Volume Set for new Vista Instance")

  OPTION(CLEAN_CACHE "Overwrite the Cache.dat file during build phase of testing? To remove this option, delete the CMake Cache" OFF)

  configure_file(${VISTA_SOURCE_DIR}/CacheVerifyTelnet.scp.in ${VISTA_BINARY_DIR}/CacheVerifyTelnet.scp)
  message(STATUS "Testing if Cache Telnet service is enable:")
  execute_process(COMMAND "@CTerm@" "/console=cn_iptcp:127.0.0.1[23]" "${VISTA_BINARY_DIR}/CacheVerifyTelnet.scp" "${VISTA_BINARY_DIR}/CacheVerifyTelnet.log" TIMEOUT 5 RESULT_VARIABLE rcode)
  message(STATUS "Testing if Cache Telnet service is enable: ${rcode}")
  if ( (rcode EQUAL 0) OR "${rcode}" MATCHES "timeout" )
    message(FATAL_ERROR "Error connecting to Cache ${INSTANCE} namespace ${NAMESPACE} via telnet, please enable the telnet setting via"
      " Cache Managements Portal->System->Security Management->Service to switch on %Service_telnet by checking enabled checkbox and save."
      " Also verify that telnet port is set to 23 via Configuration->Device Settings->Telnet Settings ")
  endif()


  IF(CLEAN_CACHE AND CControl AND PRISTINE_CACHE_DAT_PATH)
    configure_file(${VISTA_SOURCE_DIR}/ImportRG.cmake.in ${VISTA_BINARY_DIR}/ImportRG.cmake)
    configure_file(${VISTA_SOURCE_DIR}/RoutineImport.scp.in ${VISTA_BINARY_DIR}/RoutineImport.scp)
    configure_file(${VISTA_SOURCE_DIR}/GlobalImport.scp.in ${VISTA_BINARY_DIR}/GlobalImport.scp)
    configure_file(${VISTA_SOURCE_DIR}/Initialize.scp.in ${VISTA_BINARY_DIR}/Initialize.scp)
    if(MUNIT_KIDS_FILE AND MUNIT_PACKAGE_INSTALL_NAME)
      configure_file(${VISTA_SOURCE_DIR}/${MUNIT_INSTALLATION_SCRIPT}.in ${VISTA_BINARY_DIR}/${MUNIT_INSTALLATION_SCRIPT})
    endif()
    set(MAKECOMMAND " ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/ImportRG.cmake" CACHE STRING "Import Routines and Globals into CACHE as Build Step" FORCE)
  ELSE()
    set(MAKECOMMAND " ${CMAKE_COMMAND} -E echo No_Build_Required" CACHE STRING "No build process is required when CLEAN_CACHE if OFF" FORCE)
  ENDIF()
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

  OPTION(CLEAN_DATABASE "Overwrite the database file during build phase of testing? To remove this option, delete the CMake Cache" OFF)
  if(CLEAN_DATABASE)
    configure_file(${VISTA_SOURCE_DIR}/GTMImportRG.cmake.in ${VISTA_BINARY_DIR}/GTMImportRG.cmake @ONLY)
    configure_file(${VISTA_SOURCE_DIR}/RoutineImportGTM.exp.in ${VISTA_BINARY_DIR}/RoutineImportGTM.exp)
    configure_file(${VISTA_SOURCE_DIR}/GlobalImportandInitializeGTM.exp.in ${VISTA_BINARY_DIR}/GlobalImportandInitializeGTM.exp)
    if(MUNIT_KIDS_FILE AND MUNIT_PACKAGE_INSTALL_NAME)
      configure_file(${VISTA_SOURCE_DIR}/${MUNIT_INSTALLATION_SCRIPT}.in ${VISTA_BINARY_DIR}/${MUNIT_INSTALLATION_SCRIPT})
    endif()
    set(MAKECOMMAND " ${CMAKE_COMMAND} -P ${VISTA_BINARY_DIR}/GTMImportRG.cmake" CACHE STRING "Import Routines and Globals into GT.M as Build Step" FORCE)
  else()
    set(MAKECOMMAND " ${CMAKE_COMMAND} -E echo No_Build_Required" CACHE STRING "No build process is required when CLEAN_CACHE if OFF" FORCE)
  endif()
endif()

# Glob through the Packages directory for the routines to test.
file(GLOB PACKAGES ${OSEHRA_PATH}/Packages/*)
foreach(package ${PACKAGES})
  get_filename_component(package_name ${package} NAME)
  string(REGEX MATCH ^[.] Packageflag ${package_name})
  string(REPLACE  " " "_" package_file_name "${package_name}")

  # Varibles for creating the testing scripts based upon system and found files
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

configure_file(CTestCustom.cmake.in ${VISTA_BINARY_DIR}/CTestCustom.cmake)
include(CTest)
#-----------------------------------------------------------------------------#
##### SECTION TO GENERATE VISUAL CROSS REFERENCE DOCUMENTATION #####
#-----------------------------------------------------------------------------#
OPTION(ROUTINE_CALL_GRAPH "Build Rouine Call Graph." OFF)
if(ROUTINE_CALL_GRAPH AND CTerm)
  file(GLOB PACKAGES ${OSEHRA_PATH}/Packages/*)
  SET(SCRIPT_OUTPUT_DIR "${VISTA_BINARY_DIR}/Docs/CallerGraph")
  SET(CALLER_GRAPH_LOG_DIR "${SCRIPT_OUTPUT_DIR}/Log")
  file(MAKE_DIRECTORY "${CALLER_GRAPH_LOG_DIR}")
  foreach(package ${PACKAGES})
    get_filename_component(package_name ${package} NAME)
    if(IS_DIRECTORY ${package})
      file(GLOB routines "${package}/Routines/*.m")
      set(send_commands "")
      foreach(routine ${routines})
        get_filename_component(routine_name ${routine} NAME_WE)
        set(send_commands "${send_commands}send: D ^XINDEX<CR>\n")
        set(send_commands "${send_commands}wait for:All Routines?\n")
        set(send_commands "${send_commands}send:No<CR>\n")
        set(send_commands "${send_commands}wait for:Routine:\n")
        set(send_commands "${send_commands}send:${routine_name}<CR>\n")
        set(send_commands "${send_commands}subroutine: $Run Xindex for one routine\n")
      endforeach()
      set(send_commands "${send_commands}goto:$exit\n")
      string(REPLACE  " " "_" package_file_name "${package_name}")

      #Configures the Expect script with the name of the routine
      configure_file(${VISTA_SOURCE_DIR}/CacheXINDEXCallerGraph.scp.in
                     ${SCRIPT_OUTPUT_DIR}/${package_file_name}.scp)

      configure_file(${VISTA_SOURCE_DIR}/CacheCallerGraph.cmake.in
                     ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake @ONLY)

      #Creates the command that will be called for the Test
      add_test(CALLERGRAPH_${package_file_name} ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake)
    endif()
  endforeach()
endif()
#-----------------------------------------------------------------------------#
##### SECTION TO RUN UNIT TESTING #####
#-----------------------------------------------------------------------------#
OPTION(AUTOMATED_UNIT_TESTING "Run Automated Unit Testing" ON)
OPTION(INSTALL_MUNIT "Install MUNIT KIDS BUILD" OFF)
if(VISTA_SOURCE_DIR AND AUTOMATED_UNIT_TESTING)
  file(GLOB PACKAGES ${VISTA_SOURCE_DIR}/UnitTest/VistA-FOIA/Packages/*)
  # Set up the platform dependent script files
  if(INSTALL_MUNIT AND MUNIT_KIDS_FILE AND MUNIT_PACKAGE_INSTALL_NAME)
    message(STATUS "Installing MUnit KIDS Build")
    configure_file(${VISTA_SOURCE_DIR}/${MUNIT_INSTALLATION_SCRIPT}.in ${VISTA_BINARY_DIR}/${MUNIT_INSTALLATION_SCRIPT})
    if(CTerm)
      execute_process(COMMAND "${CTerm}" "/console=cn_iptcp:127.0.0.1[23]" "${VISTA_BINARY_DIR}/InstallMUnitKIDSBuild.scp" "${UNITTEST_LOG_DIR}/InstallMUnitKIDSBuild.log")
    elseif(GTMPROFILE)
      execute_process(COMMAND "${EXPECT_EXEC}" "-f" "${VISTA_BINARY_DIR}/${MUNIT_INSTALLATION_SCRIPT}" "${UNITTEST_LOG_DIR}/InstallMUnitKIDSBuild.log")
    endif()
  endif()
  #configure_file(${VISTA_SOURCE_DIR}/${UNIT_TEST_CMAKE_FILE}.in ${VISTA_BINARY_DIR}/${UNIT_TEST_CMAKE_FILE} @ONLY)
  configure_file(${VISTA_SOURCE_DIR}/${ROUTINE_IMPORT_SCRIPT}.in ${VISTA_BINARY_DIR}/${ROUTINE_IMPORT_SCRIPT})

  if(GTMPROFILE)
    set(GTM_PROMPT "$ENV{gtm_prompt}")
  endif()
  foreach(package ${PACKAGES})
    get_filename_component(package_name ${package} NAME)

    if(IS_DIRECTORY ${package})
      file(GLOB routines "${package}/*.m")
      set(send_commands "")
      foreach(routine ${routines})
        get_filename_component(routine_name ${routine} NAME_WE)
        if(CTerm)
          set(send_commands "${send_commands}send: D ^${routine_name}<CR>\n")
          set(send_commands "${send_commands}wait for:${NAMESPACE}\n")
        elseif(GTMPROFILE)
          set(send_commands "${send_commands}send \"D ^${routine_name}\\n\"\n")
          set(send_commands "${send_commands}expect \"${GTM_PROMPT}\"")
        endif()
      endforeach()
      string(REPLACE  " " "_" package_file_name "${package_name}")
      #Configures the Expect script with the name of the routine
      SET(INPUT_UNIT_TEST_SCRIPT "")
      SET(INPUT_UNIT_TEST_CMAKE "")
      if(CTerm)
        SET(INPUT_UNIT_TEST_SCRIPT "CacheUnitTest.scp.in")
        SET(INPUT_UNIT_TEST_CMAKE "CacheUnitTest.cmake.in")
      elseif(GTMPROFILE)
        SET(INPUT_UNIT_TEST_SCRIPT "UnitTestGTM.exp.in")
        SET(INPUT_UNIT_TEST_CMAKE "UnitTestGTM.cmake.in")
      endif()
      configure_file(${VISTA_SOURCE_DIR}/${INPUT_UNIT_TEST_SCRIPT} ${SCRIPT_OUTPUT_DIR}/${package_file_name}.scp)
      configure_file(${VISTA_SOURCE_DIR}/${INPUT_UNIT_TEST_CMAKE} ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake @ONLY)

      #Creates the command that will be called for the Test
      add_test(UNITTEST_${package_file_name} ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake)
    endif()
  endforeach()
endif()
