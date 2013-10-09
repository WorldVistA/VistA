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

#-----------------------------------------------------------------------------#
##### SECTION TO GENERATE VISUAL CROSS REFERENCE DOCUMENTATION #####
#-----------------------------------------------------------------------------#
if(TEST_VISTA_DOX_CALLERGRAPH)
  if(TEST_VISTA_FRESH_M_DIR)
    file(GLOB PACKAGES ${TEST_VISTA_FRESH_M_DIR}/Packages/*)
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
        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/XindexCallerGraph.py.in
                       ${SCRIPT_OUTPUT_DIR}/${package_file_name}.py)

        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/XindexCallerGraph.cmake.in
                       ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake @ONLY)

        #Creates the command that will be called for the Test
        add_test(CALLERGRAPH_${package_file_name} ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/${package_file_name}.cmake)
      endif()
    endforeach()
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/FileManGlobalAttributes.py.in ${SCRIPT_OUTPUT_DIR}/FilemanGlobalAttributes.py)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/GetFilemanSchema.cmake.in ${SCRIPT_OUTPUT_DIR}/GetFilemanSchema.cmake @ONLY)
    add_test(CALLERGRAPH_GetFilemanSchema ${CMAKE_COMMAND} -P ${SCRIPT_OUTPUT_DIR}/GetFilemanSchema.cmake)
  else()
    message(WARNING "Callergraph tests cannot be added until the TEST_VISTA_FRESH_M_DIR variable has been defined.")
  endif()
endif()