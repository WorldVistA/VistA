#!/bin/sh
#
# More details at
# http://www.osehra.org/wiki/obtaining-testing-code
#
mkdir -p $HOME/OSEHRA
cd $HOME/OSEHRA
git clone git://github.com/OSEHRA/OSEHRA-Automated-Testing.git
mkdir -p OSEHRA-Automated-Testing-Build
cd $HOME/OSEHRA/OSEHRA-Automated-Testing-Build
$HOME/local/bin/ccmake $HOME/OSEHRA/OSEHRA-Automated-Testing
