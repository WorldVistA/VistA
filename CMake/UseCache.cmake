#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
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

#-----------------------------------------------------------------------------
#------ SET UP UNIT TEST ENV -----#
#-----------------------------------------------------------------------------
set(VISTA_CACHE_USERNAME "" CACHE STRING "Username for instance")
set(VISTA_CACHE_PASSWORD "" CACHE STRING "Password for instance")
set(VENDOR_NAME "Cache")
if(NOT VISTA_CACHE_INSTANCE)
  # Detect Cache instances.
  if(WIN32)
    execute_process(
      COMMAND ${CCONTROL_EXECUTABLE} qlist nodisplay
      OUTPUT_FILE ${VISTA_BINARY_DIR}/cache_qlist.txt
      ERROR_VARIABLE err
      RESULT_VARIABLE failed
      TIMEOUT 30 # should never happen, listing is fast
      )
  else()
    execute_process(
      COMMAND ${CCONTROL_EXECUTABLE} qlist
      OUTPUT_FILE ${VISTA_BINARY_DIR}/cache_qlist.txt
      ERROR_VARIABLE err
      RESULT_VARIABLE failed
      TIMEOUT 30
      )
  endif()
  if(failed)
    string(REPLACE "\n" "\n  " err "  ${err}")
    message(FATAL_ERROR "Failed to run \"${CCONTROL_EXECUTABLE} qlist \": ${failed}\n${err}")
  endif()
  file(STRINGS ${VISTA_BINARY_DIR}/cache_qlist.txt qlist)
  set(VISTA_CACHE_INSTANCES "")
  foreach(VISTA_CACHE_INSTANCE ${qlist})
    string(REPLACE "^" ";" VISTA_CACHE_INSTANCE "${VISTA_CACHE_INSTANCE}")
    list(GET VISTA_CACHE_INSTANCE 0 name)
    list(GET VISTA_CACHE_INSTANCE 1 ${name}_DIRECTORY)
    list(GET VISTA_CACHE_INSTANCE 2 ${name}_VERSION)
    list(GET VISTA_CACHE_INSTANCE 6 ${name}_WEB_PORT)
    list(APPEND VISTA_CACHE_INSTANCES ${name})
  endforeach()

  # Select a default instance.
  set(default "")
  foreach(guess CACHEWEB TRYCACHE)
    if(${guess}_DIRECTORY)
      set(default ${guess})
      break()
    endif()
  endforeach()
  if(VISTA_CACHE_INSTANCES AND NOT default)
    list(GET VISTA_CACHE_INSTANCES 0 default)
  endif()

  # Present an INSTANCE option.
  set(VISTA_CACHE_INSTANCE "${default}" CACHE STRING "Cache instance name")
  set_property(CACHE VISTA_CACHE_INSTANCE PROPERTY STRINGS "${VISTA_CACHE_INSTANCES}")
endif()
message(STATUS "Using Cache instance ${VISTA_CACHE_INSTANCE}")

# Select a namespace for VistA
set(VISTA_CACHE_NAMESPACE "VISTA" CACHE STRING "Cache namespace to store VistA")

if(WIN32)
  configure_file(${VISTA_SOURCE_DIR}/Testing/CacheVerifyTelnet.scp.in ${VISTA_BINARY_DIR}/CacheVerifyTelnet.scp)
  message(STATUS "Testing if Cache Telnet service is enable:")
  execute_process(COMMAND "@CTERM_EXECUTABLE@" "/console=cn_iptcp:127.0.0.1[23]" "${VISTA_BINARY_DIR}/CacheVerifyTelnet.scp" "${VISTA_BINARY_DIR}/CacheVerifyTelnet.log" TIMEOUT 5 RESULT_VARIABLE rcode)
  message(STATUS "Testing if Cache Telnet service is enable: ${rcode}")
  if ( (rcode EQUAL 0) OR "${rcode}" MATCHES "timeout" )
    message(FATAL_ERROR "Error connecting to Cache ${VISTA_CACHE_INSTANCE} namespace ${VISTA_CACHE_NAMESPACE} via telnet, please enable the telnet setting via"
      " Cache Managements Portal->System->Security Management->Service to switch on %Service_telnet by checking enabled checkbox and save."
      " Also verify that telnet port is set to 23 via Configuration->Device Settings->Telnet Settings ")
  endif()
endif()

#-----------------------------------------------------------------------------#
##### SECTION TO SETUP THE REFRESH OF THE DATABASE #####
#-----------------------------------------------------------------------------#

if(TEST_VISTA_FRESH)
  set(TEST_VISTA_SETUP_VOLUME_SET "VISTA" CACHE STRING "Volume Set for new Vista Instance")
  set(TEST_VISTA_FRESH_CACHE_DAT_VISTA "" CACHE FILEPATH "Path to the CACHE.dat file with the imported VistA")
  set(TEST_VISTA_FRESH_CACHE_DAT_EMPTY "" CACHE FILEPATH "Path to an empty ******.DAT file for replacement")

  list(APPEND freshinfo TEST_VISTA_SETUP_VOLUME_SET)
  list(APPEND freshinfo TEST_VISTA_FRESH_CACHE_DAT_VISTA)
  list(APPEND freshinfo TEST_VISTA_FRESH_CACHE_DAT_EMPTY)

  if(TEST_VISTA_FRESH_CACHE_DAT_VISTA)
    get_filename_component(filename ${TEST_VISTA_FRESH_CACHE_DAT_VISTA} NAME)
    string(TOLOWER ${filename} filename_lower)
    if(${filename_lower} STREQUAL "cache.dat")
      get_filename_component(TEST_VISTA_FRESH_CACHE_DIR_VISTA ${TEST_VISTA_FRESH_CACHE_DAT_VISTA} PATH)
    else(${filename_lower} STREQUAL "cache.dat")
      message(SEND_ERROR "${TEST_VISTA_FRESH_CACHE_DAT_VISTA} does not point to a file called 'cache.dat'.  Fix the path to point to a correct file.")
    endif(${filename_lower} STREQUAL "cache.dat")
  endif(TEST_VISTA_FRESH_CACHE_DAT_VISTA)
endif()
