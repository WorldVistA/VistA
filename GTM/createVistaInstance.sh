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

# Create directories for VistA Routines, Objects, Globals, Journals, Temp Files
# This utility requires root privliges

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Determine processor architecture - used to determine if we can use GT.M
#                                    Shared Libraries
# Default to x86 (32bit) - algorithm similar to gtminstall script
arch=$(uname -m | tr -d _)
if [ $arch == "x8664" ]; then
    gtm_arch="x86_64"
else
    gtm_arch="x86"
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
export gtm_dist=/opt/lsb-gtm/$(ls -1 /opt/lsb-gtm/)
export gtmver=$(ls -1 /opt/lsb-gtm/)

# TODO: implement arguments to allow multiple instances, script can probably
#       handle it
# $instance must be lowercase - this script depends on it!
# if $instance must be uppercase that is the exception and the scripts must
#    uppercase it when necessary
instance="foia"

# Create $instance User/Group
# $instance user is a programmer user
# $instance group is for permissions to other users
# $instance group is auto created by adduser script
adduser -c "$instance VistA instance owner" -m -U $instance


# Make VistA Directories
# TODO: Move to new script?
# Routines are GT.M version independant
mkdir -p /opt/$instance/{r,etc,log,tmp,bin}
# xinetd scripts
mkdir -p /opt/$instance/etc/xinetd.d
# Globals, Objects, Journals, and GT.M version specific Routines are
# Version Specific
mkdir -p /opt/$instance/$gtmver/{g,j,o,r}

# Create profile for instance
# Required GT.M variables
echo "export gtm_dist=$gtm_dist"                                 >> /opt/$instance/etc/env
echo "export gtm_log=/opt/$instance/log"                        >> /opt/$instance/etc/env
echo "export gtm_tmp=/opt/$instance/tmp"                        >> /opt/$instance/etc/env
echo "export gtm_prompt=\"${instance^^}>\""                     >> /opt/$instance/etc/env
echo "export gtmgbldir=/opt/$instance/$gtmver/g/$instance.gld"  >> /opt/$instance/etc/env

# 64bit GT.M can use a shared library instead of $gtm_dist
if [ $gtm_arch == "x86_64" ]; then
    echo "export gtmroutines=\"/opt/$instance/$gtmver/o(/opt/$instance/$gtmver/r /opt/$instance/r) \$gtm_dist/libgtmutil.so\""  >> /opt/$instance/etc/env
else
    echo "export gtmroutines=\"/opt/$instance/$gtmver/o(/opt/$instance/$gtmver/r /opt/$instance/r) \$gtm_dist\""                >> /opt/$instance/etc/env
fi

# prog.sh - priviliged (programmer) user access
# Allow access to ZSY
echo "#!/bin/bash"                                              >> /opt/$instance/bin/prog.sh
echo "alias gtm=\"\$gtm_dist/mumps -dir\""                      >> /opt/$instance/bin/prog.sh
echo "alias GTM=\"\$gtm_dist/mumps -dir\""                      >> /opt/$instance/bin/prog.sh
echo "alias mumps=\"\$gtm_dist/mumps\""                         >> /opt/$instance/bin/prog.sh
echo "alias gde=\"\$gtm_dist/mumps -run GDE\""                  >> /opt/$instance/bin/prog.sh
echo "alias lke=\"\$gtm_dist/mumps -run LKE\""                  >> /opt/$instance/bin/prog.sh
echo "alias dse=\"\$gtm_dist/mumps -run DSE\""                  >> /opt/$instance/bin/prog.sh
echo "alias mupip=\"\$gtm_dist/mupip\""                         >> /opt/$instance/bin/prog.sh
echo "alias recover=\"\$gtm_dist/mupip -recover -backward $instance.mjl" >> /opt/$instance/bin/prog.sh
echo "alias backup=\"\$gtm_dist/mupip backup -online \"*\""             >> /opt/$instance/bin/prog.sh

# tied.sh - unpriviliged user access
# $instance is their shell - no access to ZSY
# need to set users with /var/db/$instance/bin/tied.sh as their shell
echo "#!/bin/bash"                      >> /opt/$instance/bin/tied.sh
echo "source /opt/$instance/etc/env"    >> /opt/$instance/bin/tied.sh
echo "export SHELL=/bin/false"          >> /opt/$instance/bin/tied.sh
echo "export gtm_nocenable=true"        >> /opt/$instance/bin/tied.sh
echo "exec \$gtm_dist/mumps -run ^ZU"   >> /opt/$instance/bin/tied.sh


# Create Global mapping
echo "c -s DEFAULT -bl=4096 -al=200000 -f=/opt/$instance/$gtmver/g/$instance.dat"   >> /opt/$instance/etc/db.gde
echo "a -s TEMP    -bl=4096 -al=10000  -f=/opt/$instance/$gtmver/g/TEMP.dat"        >> /opt/$instance/etc/db.gde
echo "c -r DEFAULT    -r=4080 -k=255"                                               >> /opt/$instance/etc/db.gde
echo "a -r TEMP       -r=4080 -k=255 -d=TEMP"                                       >> /opt/$instance/etc/db.gde
echo "a -n TMP        -r=TEMP"                                                      >> /opt/$instance/etc/db.gde
echo "a -n TEMP       -r=TEMP"                                                      >> /opt/$instance/etc/db.gde
echo "a -n UTILITY    -r=TEMP"                                                      >> /opt/$instance/etc/db.gde
echo "a -n CacheTemp* -r=TEMP"                                                      >> /opt/$instance/etc/db.gde
echo "sh -a"                                                                        >> /opt/$instance/etc/db.gde

# Set permissions
chown -R $instance:$instance /opt/$instance
chmod -R g+rw /opt/$instance

# create the global directory
# TODO redirect output to file
# have to source the environment first to have GTM env vars available
source /opt/$instance/etc/env
$gtm_dist/mumps -run GDE < /opt/$instance/etc/db.gde

# Create the database
$gtm_dist/mupip create
