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

# Ensure presence of required variables
if [[ -z $instance && $gtmver && $gtm_dist ]]; then
    echo "The required variables are not set (instance, gtmver, gtm_dist)"
fi

# Import routines
echo "Copying routines"
OLDIFS=$IFS
IFS=$'\n'
for routine in $(cd /usr/local/src/VistA-Source && git ls-files -- \*.m); do
    cp /usr/local/src/VistA-Source/${routine} $basedir/r
done
echo "Done copying routines"

# Compile routines
echo "Compiling routines"
cd $basedir/r/$gtmver
for routine in $basedir/r/*.m; do
    mumps ${routine} >> $basedir/log/compile.log 2>&1
done
echo "Done compiling routines"

# Import globals
echo "Importing globals"
for global in $(cd /usr/local/src/VistA-Source && git ls-files -- \*.zwr); do
    mupip load \"/usr/local/src/VistA-Source/${global}\" >> $basedir/log/loadGloabls.log 2>&1
done
echo "Done importing globals"

# reset IFS
IFS=$OLDIFS
