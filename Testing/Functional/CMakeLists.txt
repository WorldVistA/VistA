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

if(TEST_VISTA_FUNCTIONAL_SIK)
  # CPRS only runs on Windows, Thus the Sikuli and GUI test will be added only for those types of machines
  if(WIN32)
    file(GLOB SIKULI_FOLDERS ${CMAKE_CURRENT_SOURCE_DIR}/Sikuli/*.sikuli)
    find_program(SIKULI_EXECUTABLE Sikuli-IDE.bat DOC "Path to the Sikul-IDE.bat file" HINTS "C:/Program Files/Sikuli X/" "C:/Program Files (x86)/Sikuli X/" )
    mark_as_advanced(SIKULI_EXECUTABLE)
    if(NOT SIKULI_EXECUTABLE)
      mark_as_advanced(CLEAR SIKULI_EXECUTABLE)
    endif()

    find_program(CPRS_EXECUTABLE CPRSChart.exe DOC "Path to the CPRSChart.exe file")
    mark_as_advanced(CPRS_EXECUTABLE)

    if(NOT CPRS_EXECUTABLE)
      mark_as_advanced(CLEAR CPRS_EXECUTABLE)
    endif()

    find_program(VITALS_MANAGER_EXECUTABLE VitalsManager.exe DOC "Path to the VitalsManager.exe file")
    mark_as_advanced(VITALS_MANAGER_EXECUTABLE)

    if(NOT VITALS_MANAGER_EXECUTABLE)
      mark_as_advanced(CLEAR VITALS_MANAGER_EXECUTABLE)
    endif()
    foreach(sikuli ${SIKULI_FOLDERS})
      get_filename_component(sikuli_name "${sikuli}" NAME_WE)
      #  Configure the Sikuli files to contain the paths found above
      configure_file("${sikuli}/${sikuli_name}.py.in" "${CMAKE_CURRENT_BINARY_DIR}/Sikuli/${sikuli_name}.sikuli/${sikuli_name}.py")
      configure_file("${sikuli}/${sikuli_name}.html.in" "${CMAKE_CURRENT_BINARY_DIR}/Sikuli/${sikuli_name}.sikuli/${sikuli_name}.html")
      add_test(FT_${sikuli_name}Sikuli "@SIKULI_EXECUTABLE@" -s -r "${CMAKE_CURRENT_BINARY_DIR}/Sikuli/${sikuli_name}.sikuli")
      set_tests_properties(FT_${sikuli_name}Sikuli PROPERTIES FAIL_REGULAR_EXPRESSION "FindFailed")
    endforeach()
  endif()
endif()

if(TEST_VISTA_FUNCTIONAL_RAS)
  file(GLOB packages ${VISTA_SOURCE_DIR}/Packages/*)
  SET(LOG_LEVEL "INFO" CACHE STRING "Logging Level used by OATs internal logger")
  foreach(package ${packages})
    if(IS_DIRECTORY ${package}/Testing/RAS/)
      file(GLOB rastests ${package}/Testing/RAS/*_test.py)
      foreach(rastest ${rastests})
        get_filename_component(rastest_name "${rastest}" NAME_WE)
        configure_file("${CMAKE_CURRENT_SOURCE_DIR}/RAS/RASTest.cmake.in" "${CMAKE_CURRENT_BINARY_DIR}/RAS_${rastest_name}.cmake" @ONLY)
        add_test(RAS_${rastest_name} ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/RAS_${rastest_name}.cmake)
      endforeach()
      file(GLOB RASUnitTests ${package}/Testing/RAS/UT*.py)
      set(vendor_args "")
      if(CCONTROL_EXECUTABLE)
          list(APPEND vendor_args -S 1 -CN "${VISTA_CACHE_NAMESPACE}" -CI "${VISTA_CACHE_INSTANCE}")
          if(VISTA_CACHE_USERNAME)
              list(APPEND vendor_args -CU "${VISTA_CACHE_USERNAME}" -CP "${VISTA_CACHE_PASSWORD}")
          endif()
      endif()
      if(GTM_DIST)
          list(APPEND vendor_args -S 2)
      endif()
      foreach(RASUnitTest ${RASUnitTests})
          get_filename_component(RASUnitTestName "${RASUnitTest}" NAME_WE)
          add_test(RASUnitTest_${RASUnitTestName} ${PYTHON_EXECUTABLE} ${RASUnitTest} ${vendor_args})
          set_tests_properties(RASUnitTest_${RASUnitTestName}
                               PROPERTIES FAIL_REGULAR_EXPRESSION "FAILED")
      endforeach()
    endif()
  endforeach()
endif()
