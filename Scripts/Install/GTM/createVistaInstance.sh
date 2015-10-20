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

# Create directories for instance Routines, Objects, Globals, Journals,
# Temp Files
# This utility requires root privliges

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Options
# used http://rsalveti.wordpress.com/2007/04/03/bash-parsing-arguments-with-getopts/
# for guidance

usage()
{
    cat << EOF
    usage: $0 options

    This script will create a VistA instance for GT.M

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

echo "Creating $instance..."

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
gtm_dist=/opt/lsb-gtm/$(ls -1 /opt/lsb-gtm/)
gtmver=$(ls -1 /opt/lsb-gtm/)

# TODO: implement argument for basedir
# $basedir is the base directory for the instance
# examples of $basedir are: /home/$instance, /opt/$instance, /var/db/$instance
basedir=/home/$instance

# Create $instance User/Group
# $instance user is a programmer user
# $instance group is for permissions to other users
# $instance group is auto created by adduser script
useradd -c "$instance instance owner" -m -U $instance -s /bin/bash
useradd -c "Tied user account for $instance" -M -N -g $instance -s /home/$instance/bin/tied.sh -d /home/$instance ${instance}tied
useradd -c "Programmer user account for $instance" -M -N -g $instance -s /home/$instance/bin/prog.sh -d /home/$instance ${instance}prog

# Change password for tied accounts
echo ${instance}tied:tied | chpasswd
echo ${instance}prog:prog | chpasswd

# Make instance Directories
su $instance -c "mkdir -p $basedir/{r,r/$gtmver,g,j,etc,etc/xinetd.d,log,tmp,bin,lib,www,backup}"

# Copy standard etc and bin items from repo
su $instance -c "cp -R etc $basedir"
su $instance -c "cp -R bin $basedir"

# Modify xinetd.d scripts to reflect $instance
perl -pi -e 's/foia/'$instance'/g' $basedir/bin/*.sh
perl -pi -e 's/foia/'$instance'/g' $basedir/etc/xinetd.d/vista-*

# Modify init.d script to reflect $instance
perl -pi -e 's/foia/'$instance'/g' $basedir/etc/init.d/vista

# Create symbolic link to enable brokers
ln -s $basedir/etc/xinetd.d/vista-rpcbroker /etc/xinetd.d/$instance-vista-rpcbroker
ln -s $basedir/etc/xinetd.d/vista-vistalink /etc/xinetd.d/$instance-vista-vistalink

# Create startup service
ln -s $basedir/etc/init.d/vista /etc/init.d/${instance}vista

# Install init script
if [[ $ubuntu || -z $RHEL ]]; then
    update-rc.d ${instance}vista defaults
fi

if [[ $RHEL || -z $ubuntu ]]; then
    chkconfig --add ${instance}vista
fi

# Symlink libs
su $instance -c "ln -s $gtm_dist $basedir/lib/gtm"

# Create profile for instance
# Required GT.M variables
echo "export gtm_dist=$basedir/lib/gtm"         >> $basedir/etc/env
echo "export gtm_log=$basedir/log"              >> $basedir/etc/env
echo "export gtm_tmp=$basedir/tmp"              >> $basedir/etc/env
echo "export gtm_prompt=\"${instance^^}>\""     >> $basedir/etc/env
echo "export gtmgbldir=$basedir/g/$instance.gld" >> $basedir/etc/env
echo "export gtm_zinterrupt='I \$\$JOBEXAM^ZU(\$ZPOSITION)'" >> $basedir/etc/env
echo "export gtm_lvnullsubs=2"                  >> $basedir/etc/env
echo "export gtm_zquit_anyway=1"                >> $basedir/etc/env
echo "export PATH=\$PATH:\$gtm_dist"            >> $basedir/etc/env
echo "export basedir=$basedir"                  >> $basedir/etc/env
echo "export gtm_arch=$gtm_arch"                >> $basedir/etc/env
echo "export gtmver=$gtmver"                    >> $basedir/etc/env
echo "export instance=$instance"                >> $basedir/etc/env

# Ensure correct permissions for env
chown $instance:$instance $basedir/etc/env

# Source envrionment in bash shell
echo "source $basedir/etc/env" >> $basedir/.bashrc

# Setup base gtmroutines
if [[ $gtmver == *"6.2"* ]]; then
    echo "Adding gtmroutines for GT.M >= 6.2"
    gtmroutines="\$basedir/r/\$gtmver*($basedir/r)"
else
    echo "Adding gtmroutines for GT.M < 6.2"
    gtmroutines="\$basedir/r/\$gtmver(\$basedir/r)"
fi

# 64bit GT.M can use a shared library instead of $gtm_dist
if [ $gtm_arch == "x86_64" ]; then
    echo "export gtmroutines=\"$gtmroutines $basedir/lib/gtm/libgtmutil.so $basedir/lib/gtm\"" >> $basedir/etc/env
else
    echo "export gtmroutines=\"$gtmroutines $basedir/lib/gtm\"" >> $basedir/etc/env
fi

# prog.sh - priviliged (programmer) user access
# Allow access to ZSY
echo "#!/bin/bash"                              >> $basedir/bin/prog.sh
echo "source $basedir/etc/env"                  >> $basedir/bin/prog.sh
echo "export SHELL=/bin/bash"                   >> $basedir/bin/prog.sh
echo "#These exist for compatibility reasons"   >> $basedir/bin/prog.sh
echo "alias gtm=\"\$gtm_dist/mumps -dir\""      >> $basedir/bin/prog.sh
echo "alias GTM=\"\$gtm_dist/mumps -dir\""      >> $basedir/bin/prog.sh
echo "alias gde=\"\$gtm_dist/mumps -run GDE\""  >> $basedir/bin/prog.sh
echo "alias lke=\"\$gtm_dist/mumps -run LKE\""  >> $basedir/bin/prog.sh
echo "alias dse=\"\$gtm_dist/mumps -run DSE\""  >> $basedir/bin/prog.sh
echo "\$gtm_dist/mumps -dir"                    >> $basedir/bin/prog.sh

# Ensure correct permissions for prog.sh
chown $instance:$instance $basedir/bin/prog.sh
chmod +x $basedir/bin/prog.sh

# tied.sh - unpriviliged user access
# $instance is their shell - no access to ZSY
# need to set users with $basedir/bin/tied.sh as their shell
echo "#!/bin/bash"                              >> $basedir/bin/tied.sh
echo "source $basedir/etc/env"                  >> $basedir/bin/tied.sh
echo "export SHELL=/bin/false"                  >> $basedir/bin/tied.sh
echo "export gtm_nocenable=true"                >> $basedir/bin/tied.sh
echo "exec \$gtm_dist/mumps -run ^ZU"           >> $basedir/bin/tied.sh

# Ensure correct permissions for tied.sh
chown $instance:$instance $basedir/bin/tied.sh
chmod +x $basedir/bin/tied.sh

# Create Global mapping
# Thanks to Sam Habiel, Gus Landis, and others for the inital values
echo "c -s DEFAULT    -ACCESS_METHOD=BG -BLOCK_SIZE=4096 -ALLOCATION=200000 -EXTENSION_COUNT=1024 -GLOBAL_BUFFER_COUNT=4096 -LOCK_SPACE=400 -FILE=$basedir/g/$instance.dat" >> $basedir/etc/db.gde
echo "a -s TEMP       -ACCESS_METHOD=MM -BLOCK_SIZE=4096 -ALLOCATION=10000 -EXTENSION_COUNT=1024 -GLOBAL_BUFFER_COUNT=4096 -LOCK_SPACE=400 -FILE=$basedir/g/temp.dat" >> $basedir/etc/db.gde
echo "c -r DEFAULT    -RECORD_SIZE=16368 -KEY_SIZE=1019 -JOURNAL=(BEFORE_IMAGE,FILE_NAME=\"$basedir/j/$instance.mjl\") -DYNAMIC_SEGMENT=DEFAULT" >> $basedir/etc/db.gde
echo "a -r TEMP       -RECORD_SIZE=16368 -KEY_SIZE=1019 -NOJOURNAL -DYNAMIC_SEGMENT=TEMP"   >> $basedir/etc/db.gde
echo "a -n TMP        -r=TEMP"                  >> $basedir/etc/db.gde
echo "a -n TEMP       -r=TEMP"                  >> $basedir/etc/db.gde
echo "a -n UTILITY    -r=TEMP"                  >> $basedir/etc/db.gde
echo "a -n XTMP       -r=TEMP"                  >> $basedir/etc/db.gde
echo "a -n CacheTemp* -r=TEMP"                  >> $basedir/etc/db.gde
echo "sh -a"                                    >> $basedir/etc/db.gde

# Ensure correct permissions for db.gde
chown $instance:$instance $basedir/etc/db.gde

# create the global directory
# have to source the environment first to have GTM env vars available
su $instance -c "source $basedir/etc/env && \$gtm_dist/mumps -run GDE < $basedir/etc/db.gde > $basedir/log/GDEoutput.log 2>&1"

# Create the database
echo "Creating databases"
su $instance -c "source $basedir/etc/env && \$gtm_dist/mupip create > $basedir/log/createDatabase.log 2>&1"
echo "Done Creating databases"

# Set permissions
chown -R $instance:$instance $basedir
chmod -R g+rw $basedir

# Add firewall rules
if [[ $RHEL || -z $ubuntu ]]; then
    sudo iptables -I INPUT 1 -p tcp --dport 9430 -j ACCEPT # RPC Broker
    sudo iptables -I INPUT 1 -p tcp --dport 8001 -j ACCEPT # VistALink
    sudo service iptables save
fi

echo "VistA instance $instance created!"
