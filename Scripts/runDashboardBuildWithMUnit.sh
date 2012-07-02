#!/bin/sh
export VistADir=$HOME/VistA-Instance
export DashboardsDir=$HOME/OSEHRA/Dashboards
export VistAGlobalsDir=$VistADir/g
export VistARoutines=$VistADir/r
export gtm_dist=/usr/lib/fis-gtm/V5.5-000_x86_64
export gtmprofilefile=$gtm_dist/gtmprofile
source $gtmprofilefile
export gtmgbldir=$VistADir/g/database
export gtmroutines="$VistADir/o($VistADir/r) $gtm_dist/libgtmutil.so"
mkdir -p $DashboardsDir/Logs
$HOME/local/bin/ctest \
-S $HOME/OSEHRA/VistA-installation-scripts/Scripts/runDashboardBuildWithMUnit.cmake \
-VV > $DashboardsDir/Logs/build.log
