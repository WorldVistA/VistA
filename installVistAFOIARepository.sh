#!/bin/sh
#
# More details at
# http://www.osehra.org/wiki/importing-osehra-code-base-gtm
#
export DashboardsDir=$HOME/OSEHRA/Dashboards
mkdir -p $DashboardsDir
cd $DashboardsDir
git clone git://code.osehra.org/VistA-FOIA.git
#
# switch position of two lines to solve problem with Locks.
#
sed -i.bak -e '82 i\
 TCOMMIT  ;' $HOME/OSEHRA/Dashboards/VistA-FOIA/Packages/Kernel/Routines/ZTLOAD1.m
sed -i.bak -e '84 d' $HOME/OSEHRA/Dashboards/VistA-FOIA/Packages/Kernel/Routines/ZTLOAD1.m
