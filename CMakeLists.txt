#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
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
cmake_minimum_required(VERSION 2.8)
project(VistaDelphi NONE)

function(add_delphi_build p t)
  file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}" SOURCE)
  configure_file(${p}.dproj.in ${p}.dproj @ONLY)
  configure_file(${p}.${t}.in ${p}.${t} @ONLY)
  add_custom_target(${p} ALL COMMAND msbuild ${p}.dproj)
endfunction()

function(add_delphi_package package)
  add_delphi_build(${package} dpk)
endfunction()

function(add_delphi_project project)
  add_delphi_build(${project} dpr)
endfunction()

add_subdirectory(BDK)
add_subdirectory(CPRS)
