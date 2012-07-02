#!/bin/sh
#
# Install the M-Unit KIDS file.
#
mkdir -p $HOME/OSEHRA/Dashboards
cd $HOME/OSEHRA/Dashboards
git clone git://github.com/OSEHR/M-Tools.git
cd M-Tools
cd "Utilities XT_7.3_81 not yet released"
pwd
# Remove the top two lines
sed -e '1,2 d' XT_7-3_81_TESTVER9.KID > ../XT_7-3_81_TESTVER9.KID
