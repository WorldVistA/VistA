#---------------------------------------------------------------------------
# Copyright 2018 The Open Source Electronic Health Record Agent
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
set(USE_ORPHEUS OFF CACHE BOOL "Selecting this option will remove the NOORPHEUS conditional define.")
set(ORPHEUS "NOORPHEUS")
if(USE_ORPHEUS)
  message(WARNING "Selecting the USE_ORPHEUS option will cause the command line build of Vitals and VitalsManager to fail.\
  Open them in the RAD Studio and use the 'Tools -> GetIt Package Manager' to install Orpheus before building.")
  set(ORPHEUS "")
endif()
add_subdirectory("APP-VITALS")
add_subdirectory("APP-VITALSMANAGER")
add_subdirectory("DLL-VITALSVIEWENTER")