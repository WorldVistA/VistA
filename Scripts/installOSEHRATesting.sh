#!/bin/sh
#
# More details at
# http://www.osehra.org/wiki/obtaining-testing-code
#
export DashboardsDir=$HOME/OSEHRA/Dashboards
mkdir -p $DashboardsDir
cd $DashboardsDir
git clone git@github.com:OSEHR/OSEHRA-Automated-Testing.git
git checkout --track UseCaseTesting
ln -s $DashboardsDir/OSEHRA-Automated-Testing/DashboardScripts/vista_common.cmake $HOME/OSEHRA/VistA-installation-scripts/Scripts

