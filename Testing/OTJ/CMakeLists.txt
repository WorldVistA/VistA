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

if(TEST_VISTA_OTJ_SUBMISSION)
  # create log directory for OTJ submission
  set(OTJ_CMAKE_DIR "${VISTA_BINARY_DIR}/OTJ")
  if(NOT EXISTS "${OTJ_CMAKE_DIR}")
    file(MAKE_DIRECTORY "${OTJ_CMAKE_DIR}")
  endif()
  set(OTJ_LOG_DIR "${OTJ_CMAKE_DIR}/Log")
  if(NOT EXISTS "${OTJ_LOG_DIR}")
    file(MAKE_DIRECTORY "${OTJ_LOG_DIR}")
  endif()
  file(GLOB OTJ_FOLDERS ${CMAKE_CURRENT_SOURCE_DIR}/*)
  foreach(OTJ_FOLDER ${OTJ_FOLDERS})
    if(IS_DIRECTORY "${OTJ_FOLDER}")
      get_filename_component(submission "${OTJ_FOLDER}" NAME)
      get_filename_component(OTJ_SUBMISSION_DIR "${OTJ_FOLDER}" ABSOLUTE)
      string(REPLACE " " "_" submission_name ${submission})
      # configure the cmake file
      configure_file("${CMAKE_CURRENT_SOURCE_DIR}/OTJTestDriver.cmake.in" "${OTJ_CMAKE_DIR}/OTJ_${submission_name}.cmake" @ONLY)
    endif()
  endforeach()
endif()
