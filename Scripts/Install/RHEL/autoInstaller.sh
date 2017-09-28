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

    This script will automatically create a VistA instance for GT.M on
    RHEL-like Distros

    DEFAULTS:
      Alternate VistA-M repo = https://github.com/OSEHRA/VistA-M.git
      Install EWD.js = false
      Create Development Directories = false
      Instance Name = OSEHRA
      Post Install hook = none
      Skip Testing = false

    OPTIONS:
      -h    Show this message
      -a    Alternate VistA-M repo (zip or git format) (Must be in OSEHRA format)
      -r    Alternate VistA-M repo branch (git format only)
      -b    Skip bootstrapping system (used for docker)
      -c    Path to Caché installer
      -d    Create development directories (s & p) (GT.M only)
      -e    Install EWD.js (assumes development directories)
      -g    Use GT.M
      -i    Instance name
      -p    Post install hook (path to script)
      -s    Skip testing

EOF
}

while getopts ":ha:c:bedgi:p:sr:" option
do
    case $option in
        h)
            usage
            exit 1
            ;;
        a)
            repoPath=$OPTARG
            ;;
        b)
            bootstrap=false
            ;;
        c)
            cacheinstallerpath=$OPTARG
            ;;
        d)
            developmentDirectories=true
            ;;
        e)
            installEWD=true
            developmentDirectories=true
            ;;
        g)
            installgtm=true
            ;;
        i)
            instance=$(echo $OPTARG |tr '[:upper:]' '[:lower:]')
            ;;
        p)
            postInstall=true
            postInstallScript=$OPTARG
            ;;
        r)
            branch=$OPTARG
            ;;
        s)
            skipTests=true
            ;;
    esac
done

# Set defaults for options
if [[ -z $repoPath ]]; then
    repoPath="https://github.com/OSEHRA/VistA-M.git"
fi

if [[ -z $bootstrap ]]; then
    bootstrap=true
fi

if [[ -z $developmentDirectories ]]; then
    developmentDirectories=false
fi

if [[ -z $installEWD ]]; then
    installEWD=false
fi

if [[ -z $installgtm ]]; then
    installgtm=false
fi

if [[ -z $instance ]]; then
    instance=osehra
fi

if [[ -z $postInstall ]]; then
    postInstall=false
fi

if [ -z $skipTests ]; then
    skipTests=false
fi

if [ -z $cacheinstallerpath ]; then
    cacheinstallerpath=false;
fi

# Quit if no M environment viable
if [[ ! $installgtm || ! $cacheinstallerpath ]]; then
    echo "You need to either provide a path to the Caché installer or install GT.M!"
    exit 1
fi

# Summarize options
echo "Using $repoPath for routines and globals"
echo "Create development directories: $developmentDirectories"
echo "Installing an instance named: $instance"
echo "Installing EWD.js: $installEWD"
echo "Post install hook: $postInstall"
echo "Skip Testing: $skipTests"
echo "Skip bootstrap: $bootstrap"

# Get primary username if using sudo, default to $username if not sudo'd
if $bootstrap; then
    if [[ -n "$SUDO_USER" ]]; then
        primaryuser=$SUDO_USER
    elif [[ -n "$USERNAME" ]]; then
        primaryuser=$USERNAME
    else
        echo Cannot find a suitable username to add to VistA group
        exit 1
    fi
else
    primaryuser="root"
fi

echo This script will add $primaryuser to the VistA group

# Abort provisioning if it appears that an instance is already installed.
test -d /home/$instance/g &&
{ echo "VistA already Installed. Aborting."; exit 0; }

# Install the epel repo (needed for cmake28)
if $bootstrap; then
    cat > /etc/yum.repos.d/epel.repo << EOF
    [epel]
    name=epel
    baseurl=http://download.fedoraproject.org/pub/epel/6/\$basearch
    enabled=1
    gpgcheck=0
EOF
fi

# extra utils - used for cmake and dashboards and initial clones
if $bootstrap; then
    echo "Updating operating system"
    yum update -y > /dev/null
    yum install -y cmake28 git dos2unix > /dev/null
    yum install -y http://libslack.org/daemon/download/daemon-0.6.4-1.i686.rpm > /dev/null

    # Fix cmake28 links
    ln -s /usr/bin/cmake28 /usr/bin/cmake
    ln -s /usr/bin/ctest28 /usr/bin/ctest
    ln -s /usr/bin/ccmake28 /usr/bin/ccmake
    ln -s /usr/bin/cpack28 /usr/bin/cpack
fi

# Clone repos - Dashboard
if ! $skipTests; then
    cd /usr/local/src
    rm -rf VistA-Dashboard
    git clone -q https://github.com/OSEHRA/VistA -b dashboard VistA-Dashboard
fi

# See if vagrant folder exists if it does use it. if it doesn't clone the repo
if [ -d /vagrant ]; then
    scriptdir=/vagrant

    # Fix line endings
    find /vagrant -name \"*.sh\" -type f -print0 | xargs -0 dos2unix > /dev/null 2>&1
    dos2unix /vagrant/EWD/etc/init.d/ewdjs > /dev/null 2>&1
    dos2unix /vagrant/GTM/etc/init.d/vista > /dev/null 2>&1
    dos2unix /vagrant/GTM/etc/xinetd.d/vista-rpcbroker > /dev/null 2>&1
    dos2unix /vagrant/GTM/etc/xinetd.d/vista-vistalink > /dev/null 2>&1
    dos2unix /vagrant/GTM/gtminstall_SHA1 > /dev/null 2>&1
else
    if $bootstrap; then
        git clone -q https://github.com/OSEHRA/VistA
        scriptdir=/usr/local/src/VistA/Scripts/Install
    else
        scriptdir=/opt/vista
    fi
fi

# bootstrap the system
if $bootstrap; then
    cd $scriptdir
    ./RHEL/bootstrapRHELserver.sh
else
    # move back to the /opt/vista directory
    cd /opt/vista
fi

# Ensure scripts know if we are RHEL like or Ubuntu like
export RHEL=true;

# Install GT.M if requested
if $installgtm; then
    cd GTM
    if $bootstrap; then
        ./install.sh
    else
        ./install.sh -s
    fi
    # Create the VistA instance
    if $bootstrap; then
        ./createVistaInstance.sh -i $instance
    else
        ./createVistaInstance.sh -i $instance -f
    fi
fi

# Install Caché if requested
if $cacheinstallerpath; then
    echo "Cache installer path:" $cacheinstallerpath
fi

# Modify the primary user to be able to use the VistA instance
usermod -a -G $instance $primaryuser
chmod g+x /home/$instance

# Setup environment variables so the dashboard can build
# have to assume $basedir since this sourcing of this script will provide it in
# future commands
source /home/$instance/etc/env

# Get running user's home directory
# http://stackoverflow.com/questions/7358611/bash-get-users-home-directory-when-they-run-a-script-as-root
if $bootstrap; then
    USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
else
    USER_HOME=/root
fi

# source env script during running user's login
echo "source $basedir/etc/env" >> $USER_HOME/.bashrc

# Build a dashboard and run the tests to verify installation
# These use the Dashboard branch of the VistA repository
# The dashboard will clone VistA and VistA-M repos
# run this as the $instance user
if $skipTests; then
    # Clone VistA-M repo
    cd /usr/local/src
    if [[ $repoPath == *.git ]]; then
        if ! [ -z $branch ]; then
            git clone --depth 1 $repoPath -b $branch VistA-Source
        else
            git clone --depth 1 $repoPath VistA-Source
        fi
    else
        curl -fsSL --progress-bar $repoPath -o VistA-M-master.zip
        unzip -q VistA-M-master.zip
        rm VistA-M-master.zip
        dir=$(ls -1)
        mv $dir VistA-Source
    fi

    # Go back to the $basedir
    cd $basedir

    # Perform the import
    su $instance -c "source $basedir/etc/env && $scriptdir/GTM/importVistA.sh"

    # Run ZTMGRSET accepting the defaults
    su $instance -c "mumps -run %XCMD 'D ^ZTMGRSET' << EOF
8




Y
EOF"
else
    # Attempt to bypass huge git clone by getting the zip files and unzipping them where they go
    su $instance -c "source $basedir/etc/env && mkdir -p $basedir/Dashboard"
    cd $basedir/Dashboard
    echo "Downloading OSEHRA VistA"
    curl -fsSL --progress-bar https://github.com/OSEHRA/VistA/archive/master.zip -o VistA-master.zip
    unzip -q VistA-master.zip
    rm VistA-master.zip
    mv VistA-master VistA
    echo "Downloading OSEHRA VistA-M"
    curl -fsSL --progress-bar https://github.com/OSEHRA/VistA-M/archive/master.zip -o VistA-M-master.zip
    unzip -q VistA-M-master.zip
    rm VistA-M-master.zip
    mv VistA-M-master VistA-M

    # create random string for build identification
    # source: http://ubuntuforums.org/showthread.php?t=1775099&p=10901169#post10901169
    export buildid=`tr -dc "[:alpha:]" < /dev/urandom | head -c 8`

    # Import VistA and run tests using OSEHRA automated testing framework
    su $instance -c "source $basedir/etc/env && ctest -S $scriptdir/test.cmake -V"
    # Tell users of their build id
    echo "Your build id is: $buildid you will need this to identify your build on the VistA dashboard"

    # Compile routines
    echo "Compiling routines"
    cd $basedir/r/$gtmver
    for routine in $basedir/r/*.m; do
        mumps ${routine} >> $basedir/log/compile.log 2>&1
    done
    echo "Done compiling routines"
fi

# Enable journaling
su $instance -c "source $basedir/etc/env && $basedir/bin/enableJournal.sh"

# if we are running on docker we must shutdown gracefully or else corruption will occur
# there is also no need to restart xinetd if we are running in docker as we are going to
# shut it down
if $bootstrap; then
    # Restart xinetd
    service xinetd restart
else
    service ${instance}vista stop
fi

# Add p and s directories to gtmroutines environment variable
if $developmentDirectories; then
    su $instance -c "mkdir $basedir/{p,p/$gtmver,s,s/$gtmver}"
    perl -pi -e 's#export gtmroutines=\"#export gtmroutines=\"\$basedir/p/\$gtmver\(\$basedir/p\) \$basedir/s/\$gtmver\(\$basedir/s\) #' $basedir/etc/env
fi

# Install EWD.js
if $installEWD; then
    cd $scriptdir/EWD
    ./ewdjs.sh
    cd $basedir
fi

# Post install hook
if $postInstall; then
    su $instance -c "source $basedir/etc/env && $postInstallScript"
fi

# Ensure group permissions are correct
chmod -R g+rw /home/$instance
