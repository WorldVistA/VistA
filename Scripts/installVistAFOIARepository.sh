#!/bin/sh
#
# More details at
# http://www.osehra.org/wiki/importing-osehra-code-base-gtm
#
cd $HOME
mkdir -p $HOME/OSEHRA
cd $HOME/OSEHRA
git clone git://code.osehra.org/VistA-FOIA.git
cd VistA-FOIA
git ls-files -- "*.m" | python Scripts/PackRO.py > routines.ro
git ls-files -- "*.zwr" > globals.lst
