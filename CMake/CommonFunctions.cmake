#---------------------------------------------------------------------------
# Copyright 2011-2012 The Open Source Electronic Health Record Agent
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
# Define a function for parsing and reporting XINDEX output results
function(ReportXINDEXResult PACKAGE_NAME PACKAGES_DIR VENDOR_NAME GREP_EXEC OUTPUT USE_XINDEX_WARNINGS_AS_FAILURES)
   if(USE_XINDEX_WARNINGS_AS_FAILURES)
     set(FAILURE_CONDITION "F -|W -")
   else()
     set(FAILURE_CONDITION "F -")
   endif()
   set(test_passed TRUE)
   if(ARGC GREATER 6)
     set(source_flag TRUE)
   endif()
   string(REPLACE "_" " " PACKAGE_NAME ${PACKAGE_NAME})
   foreach (line ${OUTPUT})
      # the XINDEX will always check the integrity of the routine using checksum
      if(line MATCHES "^[A-Z0-9%][^ ]+ +\\* \\* .*[cC]hecksum:.*")
        string(REGEX MATCH "^[A-Z0-9%]+[^ ]" routine_name "${line}")
      elseif(line MATCHES ${FAILURE_CONDITION})
        # also assume the file name is ${PACKAGE_NAME}.${routinename}
        set(ExceptionFound FALSE)
        if (EXISTS ${PACKAGES_DIR}/${PACKAGE_NAME}/XINDEXException/${VENDOR_NAME}.${routine_name})
          file(STRINGS ${PACKAGES_DIR}/${PACKAGE_NAME}/XINDEXException/${VENDOR_NAME}.${routine_name} ExceptionList)
          foreach (Exception ${ExceptionList})
            string(STRIP "${line}" newline)
            # this is quite stricty to ensure the text is the exactly the same
            if ("${Exception}" STREQUAL "${newline}")
              set(ExceptionFound TRUE)
              break()
            endif()
          endforeach()
        endif()
        if (NOT ExceptionFound)
          string(REGEX MATCH ^\ \ \ [A-Z0-9]+ tag ${line})
          message("${routine_name} in package ${PACKAGE_NAME}:\n${line}")
          if(tag AND GREP_EXEC AND source_flag)
            string(REGEX MATCH "\\+[0-9]+" position ${line})
            string(STRIP ${tag} tag)
            execute_process(COMMAND ${GREP_EXEC} -n -h ^${tag}
                            "${ARGV6}/Packages/${PACKAGE_NAME}/Routines/${routine_name}.m"
                            OUTPUT_VARIABLE linematch)
            if(linematch)

              string(REGEX MATCH ^[0-9]+ linenumber ${linematch})
              math(EXPR errorposition ${linenumber}${position})
              message("Error is found in ${routine_name}.m on line: ${errorposition}\n")
            endif()
          endif()
          set(test_passed FALSE)
        endif()
      endif()
   endforeach()
   if(test_passed)
     string(REPLACE ";" "\n" OUTPUT "${OUTPUT}")
     message("${PACKAGE_NAME} Passed:\n${OUTPUT}")
   else()
     message(FATAL_ERROR "${PACKAGE_NAME} has XINDEX Errors")
   endif()
endfunction()

# Define a function for parsing and reporting munit output results
function(ReportUnitTestResult PACKAGE_NAME DIRNAME OUTPUT)
   set(test_passed TRUE)
   set(routine_name "NONE")
   foreach (line ${OUTPUT})
     # Matches the command that runs the test, keeps the routine name
     if(line MATCHES ">D [A-Z0-9]*\\^[%a-zA-Z0-9]+")
       string(REGEX MATCH "[%a-zA-Z0-9]+$" routine_name "${line}")
     # Captures and prints the failure message
     elseif(line MATCHES "^ ?[^\\^]+\\^${routine_name}+")
       message("${routine_name}: ${line}")
       if(NOT ${line} MATCHES [iI]ntentional)
         set(test_passed FALSE)
       endif()
     # Matches the second part of the results line, checking for errors
     elseif(line MATCHES "encountered [1-9]+ error")
       message("M Error(s) encountered in ${routine_name} in package ${PACKAGE_NAME}")
       set(test_passed FALSE)
     endif()
   endforeach()
   if(test_passed)
     string(REPLACE ";" "\n" OUTPUT "${OUTPUT}")
     message("${PACKAGE_NAME} Passed:\n${OUTPUT}")
   else()
     message(FATAL_ERROR "${PACKAGE_NAME} unit test Errors")
   endif()
endfunction()

function(FindPackages SOURCE_DIR)
  file(STRINGS "${SOURCE_DIR}/Packages.csv" packages_csv REGEX "^[^,]")
  list(REMOVE_AT packages_csv 0) # skip column label row
  foreach(packages_csv_output IN LISTS packages_csv)
    if(packages_csv_output MATCHES "^[^,]+,([^,]+),")
      set(package_directory_name "${CMAKE_MATCH_1}")
      string(REPLACE  " " "_" package_directory_name_clean "${package_directory_name}")
      list(APPEND packages_tmp ${package_directory_name_clean})
    endif()
  endforeach()
  set(PACKAGES ${packages_tmp} PARENT_SCOPE)

endfunction()

function(SetVendorArgsConfig VendorArg VendorName Namespace Instance UserName Password)
  set(vendor_args "")
  if(VendorName STREQUAL "Cache")
    list(APPEND vendor_args -S 1 -CN ${Namespace} -CI ${Instance})
    string(STRIP "${UserName}" cacheusr)
    string(LENGTH "${cacheusr}" userLen)
    if(userLen)
      list(APPEND vendor_args -CU "${UserName}" -CP "${Password}")
    endif()
  elseif(VendorName STREQUAL "GTM")
    list(APPEND vendor_args -S 2)
  endif()
  set(${VendorArg} "${vendor_args}" PARENT_SCOPE)
endfunction()

function(SetVendorArgs VendorArg)
  set(vendor_args "")
  SetVendorArgsConfig(vendor_args "${VENDOR_NAME}" "${VISTA_CACHE_NAMESPACE}"
                     "${VISTA_CACHE_INSTANCE}" "${VISTA_CACHE_USERNAME}"
                     "${VISTA_CACHE_PASSWORD}")
  set(${VendorArg} "${vendor_args}" PARENT_SCOPE)
endfunction()
