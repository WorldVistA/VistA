#!/bin/sh
#
# More details at
# http://www.osehra.org/wiki/importing-osehra-code-base-gtm
#
cd $HOME
mkdir -p $HOME/OSEHRA
cd $HOME/OSEHRA
git clone git://github.com/OSEHR/M-Tools.git
cd M-Tools
cd "Utilities XT_7.3_81 not yet released"
pwd
# Remove the top two lines
sed -i.bak -e '1,2 d' XT_7-3_81_TESTVER9.KID
