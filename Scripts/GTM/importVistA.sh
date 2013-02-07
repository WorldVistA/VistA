#!/usr/bin/env bash
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

# Import VistA Globals and Routines into GT.M

# Ensure env vars are setup for GT.M
if [[ ! -d $gtm_dist) || ! $gtm_dist ]]; then
    echo "gtm_dist doesn't exist"
fi
if [[ ! -d $gtmgbldir) || ! $gtmgbldir ]]; then
    echo "gtmgbldir doesn't exist"
fi
if [ ! $gtmroutines ]; then
    echo "gtmroutines doesn't exist"
fi

# Import routines
$gtm_dist/mumps -run ^%RI <"\r\n$vistaro\r\n$vistar/\r\n"

# Import globals
$gtm_dist/mumps -run %XCMD "W \$\$LIST^ZGI(\"$globallst\",\"$vistasourcedir/\")"
