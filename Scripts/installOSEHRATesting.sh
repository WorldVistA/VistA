#!/bin/sh
#
# More details at
# http://www.osehra.org/wiki/obtaining-testing-code
#
export DashboardsDir=$HOME/OSEHRA/Dashboards
mkdir -p $DashboardsDir
cd $DashboardsDir
git clone git://github.com/OSEHRA/OSEHRA-Automated-Testing.git
ln -s $DashboardsDir/OSEHRA-Automated-Testing/DashboardScripts/vista_common.cmake $HOME/OSEHRA/VistA-installation-scripts/Scripts

