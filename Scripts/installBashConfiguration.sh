#!/bin/sh
#
#  Add configuration lines to the .bashrc file.
#
echo "" >> $HOME/.bashrc
echo '# OSEHRA User specific aliases and functions' >> $HOME/.bashrc
echo 'export PATH=$PATH:$HOME/local/bin' >> $HOME/.bashrc
