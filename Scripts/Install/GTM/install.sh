#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2017 The Open Source Electronic Health Record Agent
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

# Install GT.M/YottaDB using ydbinstall script
# This utility requires root privliges

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Options
# instance = name of instance
# used http://rsalveti.wordpress.com/2007/04/03/bash-parsing-arguments-with-getopts/
# for guidance

usage()
{
    cat << EOF
    usage: $0 options

    This script will automatically install GT.M/YottaDB

    DEFAULTS:
      GT.M Version = V6.3-002
      YottaDB Version = r1.10

    OPTIONS:
      -h    Show this message
      -v    GT.M/YottaDB version to install
      -y    Install YottaDB instead of GT.M
      -s    Skip setting shared memory parameters

EOF
}

while getopts "hsyv:" option
do
    case $option in
        h)
            usage
            exit 1
            ;;
        s)
            sharedmem=false
            ;;
        v)
            gtm_ver=$OPTARG
            ;;
        y)
            installYottaDB="true"
    esac
done

# Set defaults for options
# GT.M
if [ -z $gtm_ver ] && [ -z $installYottaDB ]; then
    gtm_ver="V6.3-002"
fi

# YottaDB
if [ $installYottaDB ] && [ -z $gtm_ver ]; then
    gtm_ver="r1.10"
fi

if [ -z $sharedmem ]; then
    sharedmem=true
fi

# Download ydbinstall
echo "Downloading ydbinstall"
curl -s -L https://raw.githubusercontent.com/YottaDB/YottaDB/master/sr_unix/ydbinstall.sh -o ydbinstall

# Verify hash as we are going to make it executable
sha1sum -c --status ydbinstall_SHA1
if [ $? -gt 0 ]; then
    echo "Something went wrong downloading ydbinstall"
    exit $?
fi

# Get kernel.shmmax to determine if we can use 32k strings
# ${#...} is to compare lengths of strings before trying to use them as numbers
# Ubuntu 16.04 box seems to have a shared memory of 18446744073692774399!!!
# Bash just starts crying...
if $sharedmem; then
    shmmax=$(sysctl -n kernel.shmmax)
    shmmin=67108864

    if [ ${#shmmax} -ge ${#shmmin} ] || [ $shmmax -ge $shmmin ]; then
        echo "Current shared memory maximum is equal to or greater than 64MB"
        echo "Current shmmax is: " $shmmax
    else
        echo "Current shared memory maximum is less than 64MB"
        echo "Current shmmax is: " $shmmax
        echo "Setting shared memory maximum to 64MB"
        echo "kernel.shmmax = $shmmin" >> /etc/sysctl.conf
        sysctl -w kernel.shmmax=$shmmin
    fi
fi

# Make it executable
chmod +x ydbinstall

# Determine processor architecture - used to determine if we can use GT.M
#                                    Shared Libraries
# Changed to support ARM chips as well as x64/x86.
arch=$(uname -m | tr -d _)
if [ $arch == "x8664" ]; then
    gtm_arch="x86_64"
else
    gtm_arch=$arch
fi

# Accept most defaults for ydbinstall
# --ucaseonly-utils - override default to install only uppercase utilities
#                     this follows VistA convention of uppercase only routines
if [ "$installYottaDB" = "true" ] ; then
    ./ydbinstall --ucaseonly-utils --installdir /opt/yottadb/"$gtm_ver"_"$gtm_arch" $gtm_ver
else
    ./ydbinstall --gtm --ucaseonly-utils --installdir /opt/lsb-gtm/"$gtm_ver"_"$gtm_arch" $gtm_ver
fi
# Remove ydbinstall script as it is unnecessary
rm ./ydbinstall


# Link GT.M shared library where the linker can find it and refresh the cache
if [[ $RHEL || -z $ubuntu ]]; then
    echo "/usr/local/lib" >> /etc/ld.so.conf
fi

rm -f /usr/local/lib/libgtmshr.so
if [ "$installYottaDB" = "true" ] ; then
    ln -s /opt/yottadb/"$gtm_ver"_"$gtm_arch"/libgtmshr.so /usr/local/lib
else
    ln -s /opt/lsb-gtm/"$gtm_ver"_"$gtm_arch"/libgtmshr.so /usr/local/lib
fi
ldconfig
if [ "$installYottaDB" = "true" ] ; then
    echo "Done installing YottaDB"
else
    echo "Done installing GT.M"
fi
