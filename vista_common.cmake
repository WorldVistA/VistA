#---------------------------------------------------------------------------
# Copyright 2011-2013 The Open Source Electronic Health Record Agent
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
# OSEHRA VistA Common Dashboard Script
#
# This script contains basic dashboard driver code common to all
# clients.
#
# Put this script in a directory such as "~/Dashboards/Scripts" or
# "c:/Dashboards/Scripts".  Create a file next to this script, say
# 'my_dashboard.cmake', with code of the following form:
#
#   # Client maintainer: me@mydomain.net
#   set(CTEST_SITE "machine.site")
#   set(CTEST_BUILD_NAME "Platform-MEnvironment")
#
#   # GT.M only:
#   set(TEST_VISTA_FRESH_GTM_ROUTINE_DIR "/path/to/database/r")
#   set(TEST_VISTA_FRESH_GTM_GLOBALS_DAT "/path/to/database/g.dat")
#
#   # Cache only:
#   set(VISTA_CACHE_NAMESPACE "VISTA")
#   set(TEST_VISTA_FRESH_CACHE_DAT_VISTA "/path/to/database/cache.dat")
#   set(TEST_VISTA_FRESH_CACHE_DAT_EMPTY "/path/to/database/empty.dat")
#   # (Copy an empty cache.dat to create empty.dat)
#
#   # Include the common dashboard script.
#   include(${CTEST_SCRIPT_DIRECTORY}/vista_common.cmake)
#
# Then run a scheduled task (cron job) with a command line such as
#
#   ctest -S ~/Dashboards/Scripts/my_dashboard.cmake -V
#
# By default the source and build trees will be placed in the path
# "../MyTests/" relative to your script location.
#
# The following variables may be set before including this script
# to configure it:
#
#   dashboard_model       = Nightly | Experimental | Continuous
#   dashboard_root_name   = Change name of "My Tests" directory
#   dashboard_source_name = Name of source directory (VistA)
#   dashboard_binary_name = Name of binary directory (VistA-build)
#   dashboard_CMakeCache  = Initial CMakeCache.txt file content
#   dashboard_do_coverage = True to enable coverage (ex: gcov)
#   dashboard_do_memcheck = True to enable memcheck (ex: valgrind)
#   CTEST_GIT_COMMAND     = path to git command-line client
#   CTEST_BUILD_FLAGS     = build tool arguments (ex: -j2)
#   CTEST_DASHBOARD_ROOT  = Where to put source and build trees
#   CTEST_TEST_TIMEOUT    = Per-test timeout length
#   CTEST_TEST_ARGS       = ctest_test args (ex: PARALLEL_LEVEL 4)
#   CMAKE_MAKE_PROGRAM    = Path to "make" tool to use
#
# Options to configure Git:
#   dashboard_git_url      = Custom git clone url
#   dashboard_git_branch   = Custom remote branch to track
#   dashboard_git_crlf     = Value of core.autocrlf for repository
#   dashboard_git_M_url    = Custom git clone url for M reference repo
#   dashboard_git_M_branch = Custom remote M branch to track
#
# For GT.M, run the dashboard script in an environment with variables
# gtm_dist, gtmroutines, gtmgbldir, gtm_icu_version, and gtm_tmp.

cmake_minimum_required(VERSION 2.8.2 FATAL_ERROR) # 2.8.[01] will NOT work!

set(CTEST_PROJECT_NAME VistA)

# Select the top dashboard directory.
if(NOT DEFINED dashboard_root_name)
  set(dashboard_root_name "MyTests")
endif()
if(NOT DEFINED CTEST_DASHBOARD_ROOT)
  get_filename_component(CTEST_DASHBOARD_ROOT "${CTEST_SCRIPT_DIRECTORY}/../${dashboard_root_name}" ABSOLUTE)
endif()

# Select the model (Nightly, Experimental, Continuous).
if(NOT DEFINED dashboard_model)
  set(dashboard_model Nightly)
endif()
if(NOT "${dashboard_model}" MATCHES "^(Nightly|Experimental|Continuous)$")
  message(FATAL_ERROR "dashboard_model must be Nightly, Experimental, or Continuous")
endif()

# Select a generator.
if(NOT CTEST_CMAKE_GENERATOR)
  if(WIN32)
    # Default to a generator that requires no real build system.
    set(CTEST_CMAKE_GENERATOR "Borland Makefiles")
  else()
    set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
  endif()
endif()

# Default to a Debug build.
if(NOT DEFINED CTEST_BUILD_CONFIGURATION)
  set(CTEST_BUILD_CONFIGURATION Debug)
endif()

# Choose CTest reporting mode.
if(NOT "${CTEST_CMAKE_GENERATOR}" MATCHES "Make")
  # Launchers work only with Makefile generators.
  set(CTEST_USE_LAUNCHERS 0)
elseif(NOT DEFINED CTEST_USE_LAUNCHERS)
  set(CTEST_USE_LAUNCHERS 1)
endif()

# Configure testing.
if(NOT CTEST_TEST_TIMEOUT)
  set(CTEST_TEST_TIMEOUT 1500)
endif()

# Select Git source to use.
if(NOT DEFINED dashboard_git_url)
  set(dashboard_git_url "git://code.osehra.org/VistA.git")
endif()
if(NOT DEFINED dashboard_git_branch)
  set(dashboard_git_branch master)
endif()
if(NOT DEFINED dashboard_git_crlf)
  if(UNIX)
    set(dashboard_git_crlf false)
  else(UNIX)
    set(dashboard_git_crlf true)
  endif(UNIX)
endif()
if(NOT DEFINED dashboard_git_M_url)
  set(dashboard_git_M_url "git://code.osehra.org/VistA-M.git")
endif()
if(NOT DEFINED dashboard_git_M_branch)
  set(dashboard_git_M_branch master)
endif()

# Configure GT.M.
if(NOT GTM_DIST
    AND DEFINED ENV{gtm_dist}
    AND IS_DIRECTORY "$ENV{gtm_dist}")
  set(GTM_DIST "$ENV{gtm_dist}")
endif()

# Look for a GIT command-line client.
if(NOT DEFINED CTEST_GIT_COMMAND)
  find_program(CTEST_GIT_COMMAND
    NAMES git git.cmd
    PATH_SUFFIXES Git/cmd Git/bin
    )
endif()

if(NOT CTEST_GIT_COMMAND)
  message(FATAL_ERROR "CTEST_GIT_COMMAND not available!")
endif()

# Select a source directory name.
if(NOT DEFINED CTEST_SOURCE_DIRECTORY)
  if(DEFINED dashboard_source_name)
    set(CTEST_SOURCE_DIRECTORY ${CTEST_DASHBOARD_ROOT}/${dashboard_source_name})
  else()
    set(CTEST_SOURCE_DIRECTORY ${CTEST_DASHBOARD_ROOT}/VistA)
  endif()
endif()

# Select a build directory name.
if(NOT DEFINED CTEST_BINARY_DIRECTORY)
  if(DEFINED dashboard_binary_name)
    set(CTEST_BINARY_DIRECTORY ${CTEST_DASHBOARD_ROOT}/${dashboard_binary_name})
  else()
    set(CTEST_BINARY_DIRECTORY ${CTEST_SOURCE_DIRECTORY}-build)
  endif()
endif()

# Support initial checkout if necessary.
if(NOT EXISTS "${CTEST_SOURCE_DIRECTORY}"
    AND NOT DEFINED CTEST_CHECKOUT_COMMAND)
  get_filename_component(_name "${CTEST_SOURCE_DIRECTORY}" NAME)

  # Generate an initial checkout script.
  set(ctest_checkout_script ${CTEST_DASHBOARD_ROOT}/${_name}-init.cmake)
  file(WRITE ${ctest_checkout_script} "# git repo init script for ${_name}
execute_process(
  COMMAND \"${CTEST_GIT_COMMAND}\" clone -n -b ${dashboard_git_branch}
          -- \"${dashboard_git_url}\" \"${CTEST_SOURCE_DIRECTORY}\"
  )
if(EXISTS \"${CTEST_SOURCE_DIRECTORY}/.git\")
  execute_process(
    COMMAND \"${CTEST_GIT_COMMAND}\" config core.autocrlf ${dashboard_git_crlf}
    WORKING_DIRECTORY \"${CTEST_SOURCE_DIRECTORY}\"
    )
  execute_process(
    COMMAND \"${CTEST_GIT_COMMAND}\" checkout
    WORKING_DIRECTORY \"${CTEST_SOURCE_DIRECTORY}\"
    )
endif()
")
  set(CTEST_CHECKOUT_COMMAND "\"${CMAKE_COMMAND}\" -P \"${ctest_checkout_script}\"")
endif()

#-----------------------------------------------------------------------------

# Select VistA M reference directory.
if(NOT DEFINED dashboard_M_dir)
  set(dashboard_M_dir ${CTEST_DASHBOARD_ROOT}/VistA-M)
endif()

# Checkout VistA M reference directory.
if(NOT EXISTS "${dashboard_M_dir}")
  get_filename_component(_name "${dashboard_M_dir}" NAME)
  get_filename_component(_dir "${dashboard_M_dir}" PATH)
  file(MAKE_DIRECTORY "${_dir}")
  execute_process(
    COMMAND "${CTEST_GIT_COMMAND}" clone -n -b ${dashboard_git_M_branch}
            -- "${dashboard_git_M_url}" "${_name}"
    WORKING_DIRECTORY "${_dir}"
    )
  if(EXISTS "${dashboard_M_dir}/.git")
    execute_process(
      COMMAND "${CTEST_GIT_COMMAND}" config core.autocrlf ${dashboard_git_crlf}
      WORKING_DIRECTORY "${dashboard_M_dir}"
      )
    execute_process(
      COMMAND "${CTEST_GIT_COMMAND}" checkout
      WORKING_DIRECTORY "${dashboard_M_dir}"
      )
  endif()
endif()

macro(dashboard_update_M)
  # Update the M components repo recording the before and after versions.
  execute_process(
    COMMAND "${CTEST_GIT_COMMAND}" rev-parse HEAD
    WORKING_DIRECTORY "${dashboard_M_dir}"
    OUTPUT_VARIABLE dashboard_M_update_before
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  ctest_update(SOURCE "${dashboard_M_dir}")
  execute_process(
    COMMAND "${CTEST_GIT_COMMAND}" rev-parse HEAD
    WORKING_DIRECTORY "${dashboard_M_dir}"
    OUTPUT_VARIABLE dashboard_M_update_after
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  # Log the versions updated.
  execute_process(
    COMMAND "${CTEST_GIT_COMMAND}" log --stat ${dashboard_M_update_before}..${dashboard_M_update_after}
    WORKING_DIRECTORY "${dashboard_M_dir}"
    OUTPUT_VARIABLE dashboard_M_update_log
    ERROR_VARIABLE  dashboard_M_update_log
    )
  set(_log "${CTEST_BINARY_DIRECTORY}/Testing/Temporary/UpdateMComponents.log")
  file(WRITE "${_log}"
    "\"${CTEST_GIT_COMMAND}\" log --stat ${dashboard_M_update_before}..${dashboard_M_update_after}\n"
    "${dashboard_M_update_log}")
  # Submit the update log as a note.
  list(APPEND CTEST_NOTES_FILES "${_log}")
endmacro()

#-----------------------------------------------------------------------------

# Send the main script as a note.
list(APPEND CTEST_NOTES_FILES
  "${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}"
  "${CMAKE_CURRENT_LIST_FILE}"
  )

# Check for required variables.
foreach(req
    CTEST_CMAKE_GENERATOR
    CTEST_SITE
    CTEST_BUILD_NAME
    )
  if(NOT DEFINED ${req})
    message(FATAL_ERROR "The containing script must set ${req}")
  endif()
endforeach(req)

# Print summary information.
set(vars "")
foreach(v
    CTEST_SITE
    CTEST_BUILD_NAME
    CTEST_SOURCE_DIRECTORY
    CTEST_BINARY_DIRECTORY
    CTEST_CMAKE_GENERATOR
    CTEST_BUILD_CONFIGURATION
    CTEST_GIT_COMMAND
    CTEST_CHECKOUT_COMMAND
    CTEST_CONFIGURE_COMMAND
    CTEST_SCRIPT_DIRECTORY
    CTEST_USE_LAUNCHERS
    dashboard_M_dir
    )
  set(vars "${vars}  ${v}=[${${v}}]\n")
endforeach(v)
message("Dashboard script configuration:\n${vars}\n")

# Avoid non-ascii characters in tool output.
set(ENV{LC_ALL} C)

# Helper macro to write the initial CMakeCache.txt
macro(write_CMakeCache)
  set(CMakeCache_build_type "")
  set(CMakeCache_make_program "")
  if(CTEST_CMAKE_GENERATOR MATCHES "Make")
    set(CMakeCache_build_type CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION})
    if(CMAKE_MAKE_PROGRAM)
      set(CMakeCache_make_program CMAKE_MAKE_PROGRAM:FILEPATH=${CMAKE_MAKE_PROGRAM})
    endif()
  endif()
  if(GTM_DIST)
    set(CMakeCache_GTM "
GTM_DIST:PATH=${GTM_DIST}
TEST_VISTA_FRESH_GTM_ROUTINE_DIR:PATH=${TEST_VISTA_FRESH_GTM_ROUTINE_DIR}
TEST_VISTA_FRESH_GTM_GLOBALS_DAT:FILEPATH=${TEST_VISTA_FRESH_GTM_GLOBALS_DAT}
")
  else()
    set(CMakeCache_GTM "")
  endif()
  if(VISTA_CACHE_NAMESPACE)
    set(CMakeCache_CACHE "
VISTA_CACHE_NAMESPACE:STRING=${VISTA_CACHE_NAMESPACE}
TEST_VISTA_FRESH_CACHE_DAT_EMPTY:FILEPATH=${TEST_VISTA_FRESH_CACHE_DAT_EMPTY}
TEST_VISTA_FRESH_CACHE_DAT_VISTA:FILEPATH=${TEST_VISTA_FRESH_CACHE_DAT_VISTA}
")
  else()
    set(CMakeCache_CACHE "")
  endif()
  file(WRITE ${CTEST_BINARY_DIRECTORY}/CMakeCache.txt "
SITE:STRING=${CTEST_SITE}
BUILDNAME:STRING=${CTEST_BUILD_NAME}
CTEST_USE_LAUNCHERS:BOOL=${CTEST_USE_LAUNCHERS}
DART_TESTING_TIMEOUT:STRING=${CTEST_TEST_TIMEOUT}
GIT_EXECUTABLE:FILEPATH=${CTEST_GIT_COMMAND}
TEST_VISTA:BOOL=ON
TEST_VISTA_FRESH:BOOL=ON
TEST_VISTA_FRESH_ALL:BOOL=ON
TEST_VISTA_FRESH_M_DIR:PATH=${dashboard_M_dir}
${CMakeCache_build_type}
${CMakeCache_make_program}
${CMakeCache_GTM}
${CMakeCache_CACHE}
${dashboard_CMakeCache}
")
endmacro(write_CMakeCache)

macro(dashboard_ctest_submit)
  if(NOT dashboard_no_submit)
    ctest_submit(${ARGN})
  endif()
endmacro()

# Start with a fresh build tree.
file(MAKE_DIRECTORY "${CTEST_BINARY_DIRECTORY}")
if(NOT "${CTEST_SOURCE_DIRECTORY}" STREQUAL "${CTEST_BINARY_DIRECTORY}")
  message("Clearing build tree...")
  ctest_empty_binary_directory(${CTEST_BINARY_DIRECTORY})
endif()

set(dashboard_continuous 0)
if("${dashboard_model}" STREQUAL "Continuous")
  set(dashboard_continuous 1)
endif()

if(COMMAND dashboard_hook_init)
  dashboard_hook_init()
endif()

set(dashboard_done 0)
while(NOT dashboard_done)
  if(dashboard_continuous)
    set(START_TIME ${CTEST_ELAPSED_TIME})
  endif()

  # Start a new submission.
  if(COMMAND dashboard_hook_start)
    dashboard_hook_start()
  endif()
  ctest_start(${dashboard_model})
  set(CTEST_CHECKOUT_COMMAND) # checkout on first iteration only

  # Always build if the tree is fresh.
  set(dashboard_fresh 0)
  if(NOT EXISTS "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt")
    set(dashboard_fresh 1)
    message("Starting fresh build...")
    write_CMakeCache()
  endif()

  # Look for updates.
  if(EXISTS "${dashboard_M_dir}/.git")
    dashboard_update_M()
  endif()
  if(EXISTS "${CTEST_SOURCE_DIRECTORY}/.git")
    ctest_update(RETURN_VALUE count)
  endif()

  message("Found ${count} changed files")
  if(dashboard_fresh OR NOT dashboard_continuous OR count GREATER 0)
    ctest_configure()

    # Load CTestCustom.cmake to get CTEST_BUILD_COMMAND computed
    # during configuration.
    ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})

    if(COMMAND dashboard_hook_build)
      dashboard_hook_build()
    endif()
    ctest_build()
    if(COMMAND dashboard_hook_test)
      dashboard_hook_test()
    endif()
    ctest_test(${CTEST_TEST_ARGS})

    if(dashboard_do_coverage)
      ctest_coverage()
    endif()
    if(dashboard_do_memcheck)
      ctest_memcheck()
    endif()
    dashboard_ctest_submit()
    if(COMMAND dashboard_hook_end)
      dashboard_hook_end()
    endif()
  endif()

  if(dashboard_continuous)
    # Delay until at least 5 minutes past START_TIME
    ctest_sleep(${START_TIME} 300 ${CTEST_ELAPSED_TIME})
    if(${CTEST_ELAPSED_TIME} GREATER 57600)
      set(dashboard_done 1)
    endif()
  else()
    # Not continuous, so we are done.
    set(dashboard_done 1)
  endif()
endwhile()
