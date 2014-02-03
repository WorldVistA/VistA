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

# Options
# instance = name of instance
# used http://rsalveti.wordpress.com/2007/04/03/bash-parsing-arguments-with-getopts/
# for guidance
usage()
{
    cat << EOF
    usage: $0 options

    This script will remove a VistA instance for GT.M

    OPTIONS:
      -h    Show this message
      -i    Instance name
EOF
}

while getopts ":hi:" option
do
    case $option in
        h)
            usage
            exit 1
            ;;
        i)
            instance=$(echo $OPTARG |tr '[:upper:]' '[:lower:]')
            ;;
    esac
done

if [[ -z $instance ]]
then
    usage
    exit 1
fi

# Make sure we are in the group we need to be to modify the instance
if [[ $USER -ne $instance && $basedir && $gtm_dist && $instance ]]; then
    echo "This script must be run as $instance and have the following variables
    defined:
    \$basedir
    \$instance
    \$gtm_dist" 1>&2
    exit 1
fi

echo "Removing $instance..."

# Shutdown the vista instance nicely
processes=$(pgrep mumps)
if [ ! -z "${processes}" ] ; then
    echo "Stopping any remaining M processes nicely"
    for i in ${processes}
    do
        mupip stop ${i}
    done

    # Wait for process to react to mupip stop instead of force kill later
    sleep 5
fi

# Look for M processes that are still running
processes=$(pgrep mumps)
if [ ! -z "${processes}" ] ; then
    echo "M process are being shutdown forcefully!"
    pkill -9 mumps
fi

# Remove instance directories
rm -f $basedir/r/*.m
rm -f $basedir/r/$gtmver/*.o
rm -f $basedir/g/*.dat
rm -f $basedir/j/*.mjl

# Re-create the databases
$gtm_dist/mupip create

echo "Done removing $instance"
