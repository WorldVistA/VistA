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

# Abort provisioning if toolchain is already installed.
test -d /opt/lsb-gtm/V6.0-002_x86 &&
test -d /home/foia/g &&
{ echo "VistA already Installed. Aborting."; exit 0; }

# extra utils - used for cmake and dashboards and initial clones
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

# Modify the Vagrant user to be able to use the VistA instance
# add vagrant user to foia group
adduser vagrant foia

# source env script during vagrant login
echo "source /home/foia/etc/env" >> /home/vagrant/.bashrc

# Setup environment variables so the dashboard can build
source /home/foia/etc/env

# create random string for build identification
# source: http://ubuntuforums.org/showthread.php?t=1775099&p=10901169#post10901169
export buildid=`tr -dc "[:alpha:]" < /dev/urandom | head -c 8`
echo "Your build id is: $buildid you will need this to identify your build on the VistA dashboard"

# Build a dashboard and run the tests to verify installation
# These use the Dashboard branch of the VistA repository
# The dashboard will clone VistA and VistA-M repos
cd ~
ctest -S /vagrant/test.cmake

# Restart xinetd
service xinetd restart

# Remind users of their build id
echo "Your build id is: $buildid you will need this to identify your build on the VistA dashboard"
