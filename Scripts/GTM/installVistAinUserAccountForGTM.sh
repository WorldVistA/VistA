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
if [ $arch == "i686" ]; then
    gtm_arch="x86_64"
else
    gtm_arch="x86"
fi

# Find GT.M:
# Use LSB path of /usr/lib/fis-gtm we can list the directories
# if > 1 directory fail
# Default GT.M install path is /usr/lib/fis-gtm/{gtm_ver}_{gtm_arch}
# where gtm_arch=(x86 | x86_64) for linux
# TODO: take GT.M path as the first argument to bypass logic and force GT.M
#       location
# list directory contents (1 per line) | count lines | strip leading and
#                                                      trailing whitespace

gtm_dirs=$(ls -1 /usr/lib/fis-gtm/ | wc -l | sed 's/^[ \t]*//;s/[ \t]*$//')
if [ gtm_dirs -gt 1 ]; then
    echo "More than one version of GT.M installed!"
    echo "Can't determine what version of GT.M to use"
    exit 1
fi

# Only one GT.M version found
export gtm_dist=/usr/lib/fis-gtm/$(ls -1 /usr/lib/fis-gtm/)

# TODO: implement arguments to allow multiple instances, script can probably
#       handle it
instance="FOIA"

# Make VistA Directories
# TODO: Move to new script?
# Routines are GT.M version independant
sudo mkdir -p /var/db/$instance/{r,etc,log,tmp,bin}
# xinetd scripts
sudo mkdir -p /var/db/$instance/etc/xinetd.d
# Globals, Objects, Journals, and GT.M version specific Routines are
# Version Specific
sudo mkdir -p /var/db/$instance/$gtmver/{g,j,o,r}

# Create profile for instance
# Required GT.M variables
echo "export gtm_dist=$gtmdist"                                                 >> /var/db/$instance/etc/env
echo "export gtm_log=/var/db/$instance/log"                                     >> /var/db/$instance/etc/env
echo "export gtm_tmp=/var/db/$instance/tmp"                                     >> /var/db/$instance/etc/env
echo "export gtm_prompt=\"${instance^^}>\""                                     >> /var/db/$instance/etc/env
echo "export gtmgbldir=/var/db/$instance/$gtmver/g/$instance.gld"               >> /var/db/$instance/etc/env

# 64bit GT.M can use a shared library instead of $gtm_dist
if [ $gtm_arch == "x86_64" ]; then
    echo "export gtmroutines=\"/var/db/$instance/$gtmver/o(/var/db/$instance/$gtmver/r /var/db/$instance/r)
                            \$gtm_dist/libgtmutil.so\""                         >> /var/db/$instance/etc/env
else
    echo "export gtmroutines=\"/var/db/$instance/$gtmver/o(/var/db/$instance/$gtmver/r /var/db/$instance/r)
                            \$gtm_dist\""                                       >> /var/db/$instance/etc/env
fi

# prog.sh - priviliged (programmer) user access
# Allow access to ZSY
echo "#!/bin/bash"                                                              >> /var/db/$instance/bin/prog.sh
echo "alias gtm=\"\$gtm_dist/mumps -dir\""                                      >> /var/db/$instance/bin/prog.sh
echo "alias GTM=\"\$gtm_dist/mumps -dir\""                                      >> /var/db/$instance/bin/prog.sh
echo "alias mumps=\"\$gtm_dist/mumps\""                                         >> /var/db/$instance/bin/prog.sh
echo "alias gde=\"\$gtm_dist/mumps -run GDE\""                                  >> /var/db/$instance/bin/prog.sh
echo "alias lke=\"\$gtm_dist/mumps -run LKE\""                                  >> /var/db/$instance/bin/prog.sh
echo "alias dse=\"\$gtm_dist/mumps -run DSE\""                                  >> /var/db/$instance/bin/prog.sh
echo "alias mupip=\"\$gtm_dist/mupip\""                                         >> /var/db/$instance/bin/prog.sh
echo "alias rundown=\"\$gtm_dist/mupip rundown -region \"*\"\""                 >> /var/db/$instance/bin/prog.sh

# tied.sh - unpriviliged user access
# $instance is their shell - no access to ZSY
# need to set users with /var/db/$instance/bin/tied.sh as their shell
echo "#!/bin/bash"                                                              >> /var/db/$instance/bin/tied.sh
echo "source /var/db/$instance/env"                                             >> /var/db/$instance/bin/tied.sh
echo "export SHELL=/bin/false"                                                  >> /var/db/$instance/bin/tied.sh
echo "export gtm_nocenable=true"                                                >> /var/db/$instance/bin/tied.sh
echo "exec \$gtm_dist/mumps -run ^ZU"                                           >> /var/db/$instance/bin/tied.sh


# Create Global mapping
echo "c -s DEFAULT -bl=4096 -al=200000 -f=/var/db/$instance/$gtmver/g/$instance.dat"     >> /var/db/$instance/etc/db.gde
echo "a -s TEMP    -bl=4096 -al=10000  -f=/var/db/$instance/$gtmver/g/TEMP.dat" >> /var/db/$instance/etc/db.gde
echo "c -r DEFAULT    -r=4080 -k=255"                                           >> /var/db/$instance/etc/db.gde
echo "a -r TEMP       -r=4080 -k=255 -d=TEMP"                                   >> /var/db/$instance/etc/db.gde
echo "a -n TMP        -r=TEMP"                                                  >> /var/db/$instance/etc/db.gde
echo "a -n TEMP       -r=TEMP"                                                  >> /var/db/$instance/etc/db.gde
echo "a -n UTILITY    -r=TEMP"                                                  >> /var/db/$instance/etc/db.gde
echo "a -n CacheTemp* -r=TEMP"                                                  >> /var/db/$instance/etc/db.gde
echo "sh -a"                                                                    >> /var/db/$instance/etc/db.gde

# Set permissions
sudo chown -R root:$instance /var/db/$instance
sudo chmod -R g+rw /var/db/$instance

# create the global directory
# TODO redirect output to file
$gtm_dist/mumps -run GDE < /var/db/$instance/etc/db.gde
