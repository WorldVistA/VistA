#!/bin/sh
#
# More details at
# http://www.osehra.org/wiki/importing-osehra-code-base-gtm
#
export DashboardsDir=$HOME/OSEHRA/Dashboards
mkdir -p $DashboardsDir
cd $DashboardsDir
git clone git://code.osehra.org/VistA-FOIA.git
