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

# Installs Intersystems Caché 2011 in an automated way
# This utility requires root privliges

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# TODO: ensure we are on RHEL/CentOS

# hack for CentOS
cp /etc/redhat-release /etc/redhat-release.orig
echo "Red Hat Enterprise Linux (Santiago) release 6" > /etc/redhat-release

# TODO: clear GZIP environment variable

# setup instance name
instance=prod

# Need to know where script was ran from
scriptdir=`dirname $0`

# Path to Parameters File for silent/unattended install
parametersFile=/root/VistA-installation-scripts/Cache/parameters.isc

# CacheHome
CacheHome=/opt/cachesys/$instance

# unzip the cachekit in a temp directory
cachekit=/root/cache-2011.1.2.701-lnxrh5x64.tar.gz
tempdir=/tmp/cachekit2011.1.2.701
mkdir $tempdir
chmod og+rx $tempdir
cd $tempdir
tar xzf $cachekit

# Install Caché using the installFromParametersFile command
# This is how silent/automated installs work for *nix platforms
package/installFromParametersFile $parametersFile

# copy init scripts to $cacheHome
cp -R $scriptdir/etc $CacheHome/etc
ln -s $CacheHome/etc/init.d/cache /etc/init.d/cacheprod

# shutdown cache manually
ccontrol stop $instance quietly

# use init script to start Caché again
chkconfig --add cacheprod
chkconfig cacheprod on
service cacheprod start

# Clean up from install
cd $scriptdir
rm -rf $tempdir
mv /etc/redhat-release.orig /etc/redhat-release
