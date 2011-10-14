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
cd /home/joseph/Downloads/OSEHRA-Automated-Testing
GTMPROFILE=/opt/lsb-gtm/V5.4-000A_x86_64/gtmprofile
VISTA_GLOBALS_DIR=/home/joseph/vista
VISTA_ROUTINES_DIR=/home/joseph/vista/r
. $GTMPROFILE
gtmgbldir="$VISTA_GLOBALS_DIR/database"
gtmroutines="${gtmroutines} $VISTA_ROUTINES_DIR"
export GTMPROFILE VISTA_GLOBALS_DIR VISTA_ROUTINES_DIR gtmgbldir gtmroutines
ctest -S DashboardScripts/kitware/joseph-desktop.cmake -VV -O joseph-desktop.log
