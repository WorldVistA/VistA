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
test -d /opt/lsb-gtm/V6.0-002_x86 &&
test -d /home/foia/g &&
{ echo "VistA already Installed. Aborting."; exit 0; }

# extra utils - used for cmake and dashboards and initial clones
apt-get update
apt-get install -y build-essential cmake-curses-gui git

# Clone repos
cd /usr/local/src
git clone https://github.com/OSEHRA/VistA
git clone https://github.com/OSEHRA/VistA -b dashboard VistA-Dashboard

# bootstrap the system
cd /usr/local/src/VistA/Scripts/Install/
./Ubuntu/bootstrapUbuntuServer.sh

# Install GTM
cd GTM
./install.sh

# Create the VistA instance
./createVistaInstance.sh

# Modify the primary user to be able to use the VistA instance
adduser $primaryuser foia

# Setup environment variables so the dashboard can build
source /home/foia/etc/env

# Get user's home directory
# http://stackoverflow.com/questions/7358611/bash-get-users-home-directory-when-they-run-a-script-as-root
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

# source env script during vagrant login
echo "source /home/foia/etc/env" >> $USER_HOME/.bashrc

# create random string for build identification
# source: http://ubuntuforums.org/showthread.php?t=1775099&p=10901169#post10901169
export buildid=`tr -dc "[:alpha:]" < /dev/urandom | head -c 8`
echo "Your build id is: $buildid you will need this to identify your build on the VistA dashboard"

# Build a dashboard and run the tests to verify installation
# These use the Dashboard branch of the VistA repository
# The dashboard will clone VistA and VistA-M repos
cd ~
ctest -S /vagrant/test.cmake -V

# Restart xinetd
service xinetd restart

# Add p and s directories to gtmroutines environment variable
perl -pi -e 's#export gtmroutines=\"#export gtmroutines=\"\$basedir/p/\$gtmver\(\$basedir/p\) \$basedir/s/\$gtmver\(\$basedir/s\) #' /home/foia/etc/env

# Remind users of their build id
echo "Your build id is: $buildid you will need this to identify your build on the VistA dashboard"
