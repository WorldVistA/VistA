#!/bin/sh
#
# More details at
# http://www.osehra.org/wiki/obtaining-testing-code
#
export DashboardsDir=$HOME/OSEHRA/Dashboards
mkdir -p $DashboardsDir
cd $DashboardsDir
git clone git://github.com/OSEHRA/OSEHRA-Automated-Testing.git
