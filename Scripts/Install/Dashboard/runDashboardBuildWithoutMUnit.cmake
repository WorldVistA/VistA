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

#Client maintainer: name@email
set(CTEST_SITE "$ENV{HOST_NAME}.vagrant")
set(CTEST_BUILD_NAME "Ubuntu16.04-GT.M")
set(dashboard_cache "
GTMPROFILE:PATH=$ENV{gtmprofilefile}
VISTA_GLOBALS_DIR:PATH=$ENV{VistAGlobalsDir}
VISTA_ROUTINE_DIR:PATH=$ENV{VistARoutines}
AUTOMATED_UNIT_TESTING:BOOL=OFF
INSTALL_MUNIT:BOOL=OFF
MUNIT_KIDS_FILE:FILEPATH="$ENV{HOME}/OSEHRA/Dashboards/M-Tools/XT_7-3_81.KID"
MUNIT_PACKAGE_INSTALL_NAME:STRING=XT*7.3*81
CLEAN_DATABASE:BOOL=ON
USE_XINDEX_WARNINGS_AS_FAILURES:BOOL=ON
VISTA_CPRS_FUNCTIONAL_TESTING:BOOL=OFF
 ")
#Where the files from git will be placed
set(CTEST_DASHBOARD_ROOT $ENV{HOME}/OSEHRA/Dashboards)

#Path to the Git Executable.
set(CTEST_GIT_COMMAND /usr/bin/git)
include(${CTEST_SCRIPT_DIRECTORY}/vista_common.cmake)
