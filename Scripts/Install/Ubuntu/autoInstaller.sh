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

    This script will automatically create a VistA instance for GT.M on Ubuntu

    OPTIONS:
      -h    Show this message
      -i    Instance name
EOF
}

while getopts ":i:" option
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
    echo "No instance specified using defaults"
    instance=osehra
fi

echo "Autoinstalling an $instance instance"

# Get primary username. Vagrant always does a sudo to run this script
# TODO: determine if root is a valid user
if [[ -n "$SUDO_USER" ]]; then
    primaryuser=$SUDO_USER
elif [[ -n "$USERNAME" ]]; then
    primaryuser=$USERNAME
else
    echo Cannot find a suitable username to add to VistA group
    exit 1
fi

echo This script will add $primaryuser to the VistA group

# Abort provisioning if toolchain is already installed.
test -d /home/$instance/g &&
{ echo "VistA already Installed. Aborting."; exit 0; }

# control interactivity of debian tools
export DEBIAN_FRONTEND="noninteractive"

# extra utils - used for cmake and dashboards and initial clones
# Amazon EC2 requires to updates to get everything
apt-get update
apt-get update
apt-get install -y build-essential cmake-curses-gui git dos2unix

# Clone repos
cd /usr/local/src
git clone https://github.com/OSEHRA/VistA -b dashboard VistA-Dashboard

# Ensure that line endings are correct
dos2unix /vagrant/Ubuntu/*.sh
dos2unix /vagrant/GTM/*.sh
dos2unix /vagrant/GTM/gtminstall_SHA1
dos2unix /vagrant/GTM/etc/xinetd.d/*
dos2unix /vagrant/GTM/bin/*.sh

# bootstrap the system
cd /vagrant
./Ubuntu/bootstrapUbuntuServer.sh

# Install GTM
cd GTM
./install.sh

# Create the VistA instance
./createVistaInstance.sh -i $instance

# Modify the primary user to be able to use the VistA instance
adduser $primaryuser $instance

# Setup environment variables so the dashboard can build
# have to assume $basedir since this sourcing of this script will provide it in
# future commands
source /home/$instance/etc/env

# Get user's home directory
# http://stackoverflow.com/questions/7358611/bash-get-users-home-directory-when-they-run-a-script-as-root
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

# source env script during vagrant login
echo "source $basedir/etc/env" >> $USER_HOME/.bashrc

# create random string for build identification
# source: http://ubuntuforums.org/showthread.php?t=1775099&p=10901169#post10901169
export buildid=`tr -dc "[:alpha:]" < /dev/urandom | head -c 8`
echo "Your build id is: $buildid you will need this to identify your build on the VistA dashboard"

# Build a dashboard and run the tests to verify installation
# These use the Dashboard branch of the VistA repository
# The dashboard will clone VistA and VistA-M repos
# run this as the $instance user
su $instance -c "source $basedir/etc/env && ctest -S /vagrant/Ubuntu/test.cmake -V"

# Restart xinetd
service xinetd restart

# Add p and s directories to gtmroutines environment variable
perl -pi -e 's#export gtmroutines=\"#export gtmroutines=\"\$basedir/p/\$gtmver\(\$basedir/p\) \$basedir/s/\$gtmver\(\$basedir/s\) #' $basedir/etc/env

# Remind users of their build id
echo "Your build id is: $buildid you will need this to identify your build on the VistA dashboard"
