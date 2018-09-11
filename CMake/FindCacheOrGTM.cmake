#---------------------------------------------------------------------------
# Copyright 2018 The Open Source Electronic Health Record Alliance
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

include(CommonFunctions)

if(GTM_DIST)
  include(UseGTM)
elseif(CCONTROL_EXECUTABLE)
  include(UseCache)
endif()
