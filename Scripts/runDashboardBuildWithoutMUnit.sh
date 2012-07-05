#!/bin/sh
source $HOME/OSEHRA/VistA-installation-scripts/Scripts/setupEnvironmentVariables.sh
export VistAGlobalsDir=$VistADir/g
export DashboardsDir=$HOME/OSEHRA/Dashboards
export PATH=$PATH:$gtm_dist:$HOME/local/bin
mkdir -p $DashboardsDir/Logs
$HOME/local/bin/ctest \
-S $HOME/OSEHRA/VistA-installation-scripts/Scripts/runDashboardBuildWithoutMUnit.cmake \
-VV > $DashboardsDir/Logs/build.log
