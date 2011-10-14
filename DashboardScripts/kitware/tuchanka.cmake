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
 #Client maintainer: me@mydomain.net
set(CTEST_SITE "tuchanka.kitware")
set(CTEST_BUILD_NAME "Win32-Cache")
set(dashboard_cache "
CLEAN_CACHE:BOOL=ON
VISTA_Path:PATH=C:/InterSystems/TryCache/mgr/VistA
PRISTINE_CACHE_DAT_PATH:PATH=C:/Users/joe.snyder/Desktop/EmptyCache
CControl:PATH=C:/InterSystems/TryCache/bin/ccontrol.exe
CTerm:FILEPATH=C:/InterSystems/TryCache/bin/CTerm.exe
 ")
set(CTEST_DASHBOARD_ROOT C:/Users/joe.snyder/Dashboards/)
set(CTEST_GIT_COMMAND "C:/Program Files (x86)/Git/bin/git.exe")
set(CTEST_TEST_ARGS PARALLEL_LEVEL 8)
include(${CTEST_SCRIPT_DIRECTORY}/../vista_common.cmake)
