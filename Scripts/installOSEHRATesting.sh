#!/bin/sh
#
# More details at
# http://www.osehra.org/wiki/obtaining-testing-code
#
export DashboardsDir=$HOME/OSEHRA/Dashboards
mkdir -p $DashboardsDir
cd $DashboardsDir
git clone git://github.com/OSEHR/OSEHRA-Automated-Testing.git
cd OSEHRA-Automated-Testing
git checkout --track origin/UseCaseTesting
ln -s $DashboardsDir/OSEHRA-Automated-Testing/DashboardScripts/vista_common.cmake $HOME/OSEHRA/VistA-installation-scripts/Scripts

