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
# vista Common Dashboard Script
#
# This script contains basic dashboard driver code common to all
# clients.
#
# Put this script in a directory such as "~/Dashboards/Scripts" or
# "c:/Dashboards/Scripts".  Create a file next to this script, say
# 'my_dashboard.cmake', with code of the following form:
#
#set(CTEST_SITE "machine.site")
#set(CTEST_BUILD_NAME "Platform-MEnvironment")
#set(dashboard_cache "
#Cache Specific
# VISTA_Path:PATH=
# PRISTINE_CACHE_DAT_PATH:PATH=
# CLEAN_CACHE:BOOL=
#GT.M Specific
# GTMPROFILE:PATH=
# VISTA_GLOBALS_DIR:PATH=
# VISTA_ROUTINE_DIR:PATH=
# ")
#here the files from git will be placed
# set(CTEST_DASHBOARD_ROOT {               })
#Path to the Git Executable.
# set(CTEST_GIT_COMMAND {                  })
# include(${CTEST_SCRIPT_DIRECTORY}/vista_common.cmake)


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
#   dashboard_model           = Nightly | Experimental | Continuous
#   dashboard_root_name       = Change name of "My Tests" directory
#   dashboard_source_name     = Name of source directory (vista)
#   dashboard_binary_name     = Name of binary directory (vista-build)
#   dashboard_cache           = Initial CMakeCache.txt file content
#   dashboard_cvs_tag         = CVS tag to checkout (ex: vista-5-6)
#   dashboard_do_coverage     = True to enable coverage (ex: gcov)
#   dashboard_do_memcheck     = True to enable memcheck (ex: valgrind)
#   CTEST_UPDATE_COMMAND      = path to svn command-line client
#   CTEST_BUILD_FLAGS         = build tool arguments (ex: -j2)
#   CTEST_DASHBOARD_ROOT      = Where to put source and build trees
#   CTEST_TEST_CTEST          = Whether to run long CTestTest* tests
#   CTEST_TEST_TIMEOUT        = Per-test timeout length
#   CTEST_TEST_ARGS           = ctest_test args (ex: PARALLEL_LEVEL 4)
#   CMAKE_MAKE_PROGRAM        = Path to "make" tool to use
#
# Options to configure builds from experimental git repository:
#   dashboard_git_url      = Custom git clone url
#   dashboard_git_branch   = Custom remote branch to track
#   dashboard_git_crlf     = Value of core.autocrlf for repository
#

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

set(CTEST_PROJECT_NAME vista)
set(dashboard_user_home "$ENV{HOME}")
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")

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


if(NOT DEFINED CTEST_CONFIGURATION_TYPE)
  set(CTEST_CONFIGURATION_TYPE Debug)
endif()

# Choose CTest reporting mode.
if(NOT "${CTEST_CMAKE_GENERATOR}" MATCHES "Make")
  # Launchers work only with Makefile generators.
  set(CTEST_USE_LAUNCHERS 0)
elseif(NOT DEFINED CTEST_USE_LAUNCHERS)
  # The setting is ignored by CTest < 2.8 so we need no version test.
  set(CTEST_USE_LAUNCHERS 1)
endif()

# Configure testing.
if(NOT DEFINED CTEST_TEST_CTEST)
  set(CTEST_TEST_CTEST 1)
endif()
if(NOT CTEST_TEST_TIMEOUT)
  set(CTEST_TEST_TIMEOUT 1500)
endif()

# Path to OSEHRA code base:  OSEHRA_PATH:PATH=C:/cygwin/home/joe.snyder/VistAFOIA/VistA-FOIA


# Select Git source to use.
if(NOT DEFINED foia_git_url)
  set(foia_git_url "git://code.osehra.org/VistA-FOIA.git")
endif()

if(NOT DEFINED testing_git_url)
  set(testing_git_url "git://code.osehra.org/OSEHRA-Automated-Testing.git")
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

# Look for a GIT command-line client.
if(NOT DEFINED CTEST_GIT_COMMAND)
  find_program(CTEST_GIT_COMMAND NAMES git git.exe git.cmd)
endif()

if(NOT EXISTS ${CTEST_GIT_COMMAND})
  message(FATAL_ERROR "No Git Found.")
endif()

# Select a source directory name.
if(NOT DEFINED CTEST_SOURCE_DIRECTORY)
  if(DEFINED dashboard_source_name)
    set(CTEST_SOURCE_DIRECTORY ${CTEST_DASHBOARD_ROOT}/${dashboard_source_name})
  else()
    set(CTEST_SOURCE_DIRECTORY ${CTEST_DASHBOARD_ROOT}/OSEHRA-Automated-Testing)
  endif()
endif()

#Select VistA Code Base Directory
if(NOT DEFINED CTEST_VISTA_CODE_DIRECTORY)
  set(CTEST_VISTA_CODE_DIRECTORY ${CTEST_DASHBOARD_ROOT}/VistA-FOIA)
endif()

# Select a build directory name.
if(NOT DEFINED CTEST_BINARY_DIRECTORY)
  if(DEFINED dashboard_binary_name)
    set(CTEST_BINARY_DIRECTORY ${CTEST_DASHBOARD_ROOT}/${dashboard_binary_name})
  else()
    set(CTEST_BINARY_DIRECTORY ${CTEST_SOURCE_DIRECTORY}-build)
  endif()
endif()

# Delete source tree if it is incompatible with current VCS.
if(EXISTS ${CTEST_SOURCE_DIRECTORY})
  if(CTEST_GIT_COMMAND)
    if(NOT EXISTS "${CTEST_SOURCE_DIRECTORY}/.git")
      set(vcs_refresh "because it is not managed by git.")
    endif()
  endif()
  if(vcs_refresh AND "${CTEST_SOURCE_DIRECTORY}" MATCHES "/vista[^/]*")
    message("Deleting source tree\n  ${CTEST_SOURCE_DIRECTORY}\n${vcs_refresh}")
    file(REMOVE_RECURSE "${CTEST_SOURCE_DIRECTORY}")
  endif()
endif()

# Support initial checkout if necessary.
get_filename_component(_name "${CTEST_SOURCE_DIRECTORY}" NAME)
# Generate an initial checkout script.
set(ctest_checkout_script ${CTEST_DASHBOARD_ROOT}/${_name}-init.cmake)
file(WRITE ${ctest_checkout_script} "# git repo init script for ${_name}

if(EXISTS \"${CTEST_SOURCE_DIRECTORY}/.git\")
 execute_process(
  COMMAND \"${CTEST_GIT_COMMAND}\" pull
  WORKING_DIRECTORY \"${CTEST_SOURCE_DIRECTORY}\"
  )
else()
  execute_process(
  COMMAND \"${CTEST_GIT_COMMAND}\" clone ${git_branch_new} \"${testing_git_url}\"
          \"${CTEST_SOURCE_DIRECTORY}\"
  )
endif()


if(EXISTS \"${CTEST_VISTA_CODE_DIRECTORY}/.git\")
execute_process(
  COMMAND \"${CTEST_GIT_COMMAND}\" pull
  WORKING_DIRECTORY \"${CTEST_VISTA_CODE_DIRECTORY}\"
  )
else()
  execute_process(
  COMMAND \"${CTEST_GIT_COMMAND}\" clone ${git_branch_new} \"${foia_git_url}\"
          \"${CTEST_VISTA_CODE_DIRECTORY}\"
  )
endif()

")
set(CTEST_CHECKOUT_COMMAND "\"${CMAKE_COMMAND}\" -P \"${ctest_checkout_script}\"")
# CTest delayed initialization is broken, so we put the
# CTestConfig.cmake info here.
set(CTEST_NIGHTLY_START_TIME "00:00:00 EST")
set(CTEST_DROP_METHOD "http")
set(CTEST_DROP_SITE "code.osehra.org")
set(CTEST_DROP_LOCATION "/CDash/submit.php?project=Open+Source+EHR")
set(CTEST_DROP_SITE_CDASH TRUE)

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
foreach(v
    CTEST_SITE
    CTEST_BUILD_NAME
    CTEST_SOURCE_DIRECTORY
    CTEST_BINARY_DIRECTORY
    CTEST_CMAKE_GENERATOR
    CTEST_GIT_COMMAND
    CTEST_CHECKOUT_COMMAND
    CTEST_SCRIPT_DIRECTORY
    CTEST_USE_LAUNCHERS
    )
  set(vars "${vars}  ${v}=[${${v}}]\n")
endforeach(v)
message("Dashboard script configuration:\n${vars}\n")

# Avoid non-ascii characters in tool output.
set(ENV{LC_ALL} C)
set(CMAKE_MAKE_PROGRAM "${CMAKE_COMMAND} -P  ${CTEST_BINARY_DIRECTORY}/ImportRG.cmake")
set(CTEST_BUILD_COMMAND "\"${CMAKE_COMMAND}\" -P  ${CTEST_BINARY_DIRECTORY}/ImportRG.cmake")
# Helper macro to write the initial cache.
macro(write_cache)
  file(WRITE ${CTEST_BINARY_DIRECTORY}/CMakeCache.txt "
SITE:STRING=${CTEST_SITE}
BUILDNAME:STRING=${CTEST_BUILD_NAME}
CTEST_USE_LAUNCHERS:BOOL=${CTEST_USE_LAUNCHERS}
DART_TESTING_TIMEOUT:STRING=${CTEST_TEST_TIMEOUT}
GIT_EXEC:STRING=${CTEST_GIT_COMMAND}
CMAKE_MAKE_PROGRAM:STRING=${CMAKE_COMMAND} -P  ${CTEST_BINARY_DIRECTORY}/ImportRG.cmake
OSEHRA_PATH:STRING=${CTEST_VISTA_CODE_DIRECTORY}
OSEHRA_PATH:STRING=${CTEST_VISTA_CODE_DIRECTORY}
${dashboard_cache}

")
endmacro(write_cache)

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

# CTest 2.6 crashes with message() after ctest_test.
macro(safe_message)
  if(NOT "${CMAKE_VERSION}" VERSION_LESS 2.8 OR NOT safe_message_skip)
    message(${ARGN})
  endif()
endmacro()

if(COMMAND dashboard_hook_init)
  dashboard_hook_init()
endif()

set(dashboard_done 0)
while(NOT dashboard_done)
  if(dashboard_continuous)
    set(START_TIME ${CTEST_ELAPSED_TIME})
  endif()
  set(ENV{HOME} "${dashboard_user_home}")

  # Start a new submission.
  if(COMMAND dashboard_hook_start)
    dashboard_hook_start()
  endif()
  ctest_start(${dashboard_model})

  # Always build if the tree is fresh.
  set(dashboard_fresh 0)
  if(NOT EXISTS "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt")
    set(dashboard_fresh 1)
    safe_message("Starting fresh build...")
    write_cache()
  endif()

  # Look for updates.
  ctest_update(RETURN_VALUE count)
  set(CTEST_CHECKOUT_COMMAND) # checkout on first iteration only
  safe_message("Found ${count} changed files")

  if(dashboard_fresh OR NOT dashboard_continuous OR count GREATER 0)
    ctest_configure()
    ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})

    if(COMMAND dashboard_hook_build)
      dashboard_hook_build()
    endif()
    ctest_build()
    ctest_submit(PARTS Build Update Configure Notes)

    if(COMMAND dashboard_hook_test)
      dashboard_hook_test()
    endif()
    ctest_test(${CTEST_TEST_ARGS} )
    ctest_submit(PARTS Test)
    set(safe_message_skip 1) # Block furhter messages

    if(dashboard_do_coverage)
      ctest_coverage()
      ctest_submit(PARTS Coverage)
    endif()
    if(dashboard_do_memcheck)
      ctest_memcheck()
      ctest_submit(PARTS MemCheck)
    endif()
    if(COMMAND dashboard_hook_submit)
      dashboard_hook_submit()
    endif()
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
