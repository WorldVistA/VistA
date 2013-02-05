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

if(SIK_SYSTEM_TESTING)
  # CPRS only runs on Windows, Thus the Sikuli and GUI test will be added only for those types of machines
  if(WIN32)
    file(GLOB SIKULI_FOLDERS ${CMAKE_CURRENT_SOURCE_DIR}/Sikuli/*.sikuli)
    find_program(SIKULI_EXECUTABLE Sikuli-IDE.bat DOC "Path to the Sikul-IDE.bat file" HINTS "C:/Program Files/Sikuli X/" "C:/Program Files (x86)/Sikuli X/" )
    find_program(CPRS_EXECUTABLE CPRSChart.exe DOC "Path to the CPRSChart.exe file")
    find_program(VITALS_MANAGER_EXECUTABLE VitalsManager.exe DOC "Path to the VitalsManager.exe file")

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

if(RAS_SYSTEM_TESTING)
  file(GLOB packages ${VISTA_SOURCE_DIR}/Packages/*)
  foreach(package ${packages})
    if(IS_DIRECTORY ${package}/Testing/RAS/)
      file(GLOB rastests ${package}/Testing/RAS/*test*.py)
      foreach(rastest ${rastests})
        get_filename_component(rastest_name "${rastest}" NAME_WE)
        configure_file("${CMAKE_CURRENT_SOURCE_DIR}/RAS/RASTest.cmake.in" "${CMAKE_CURRENT_BINARY_DIR}/RAS_${rastest_name}.cmake" @ONLY)
        add_test(RAS_${rastest_name} ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/RAS_${rastest_name}.cmake)
      endforeach()
    endif()
  endforeach()
endif()
