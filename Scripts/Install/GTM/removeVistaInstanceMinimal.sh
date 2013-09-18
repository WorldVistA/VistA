#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2013 The Open Source Electronic Health Record Agent
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

# Remove directories for instance Routines, Objects, Globals, Journals,
# Temp Files
# This utility requires root privliges

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Find GT.M:
# Use path of /opt/lsb-gtm we can list the directories
# if > 1 directory fail
# Default GT.M install path is /usr/lib/fis-gtm/{gtm_ver}_{gtm_arch}
# where gtm_arch=(x86 | x86_64) for linux
# TODO: take GT.M path as the an argument to bypass logic and force GT.M
#       location
# list directory contents (1 per line) | count lines | strip leading and
#                                                      trailing whitespace

gtm_dirs=$(ls -1 /opt/lsb-gtm/ | wc -l | sed 's/^[ \t]*//;s/[ \t]*$//')
if [ $gtm_dirs -gt 1 ]; then
    echo "More than one version of GT.M installed!"
    echo "Can't determine what version of GT.M to use"
    exit 1
fi

# Only one GT.M version found
export gtmver=$(ls -1 /opt/lsb-gtm/)

# TODO: implement arguments to allow multiple instances, script can probably
#       handle it
# $instance must be lowercase - this script depends on it!
# if $instance must be uppercase that is the exception and the scripts must
#    uppercase it when necessary
instance="foia"

# TODO: implement argument for basedir
# $basedir is the base directory for the instance
# examples of $basedir are: /home/$instance, /opt/$instance, /var/db/$instance
basedir=/home/$instance

# Remove instance directories
rm -f $basedir/r/*.m
rm -f $basedir/r/$gtmver/*.o
rm -f $basedir/g/*.dat
rm -f $basedir/j/*.mjl

# Re-create the databases
$gtm_dist/mupip create
