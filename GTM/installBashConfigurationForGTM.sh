#!/bin/sh
#
#  Add configuration lines to the .bashrc file.
#
echo "" >> $HOME/.bashrc
echo '# OSEHRA User specific aliases and functions' >> $HOME/.bashrc
echo 'source $HOME/OSEHRA/VistA-installation-scripts/Scripts/setupEnvironmentVariables.sh' >> $HOME/.bashrc
echo 'export PATH=$PATH:$gtm_dist' >> $HOME/.bashrc
