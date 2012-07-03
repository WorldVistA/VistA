#!/bin/bash
#
#  This is a file to run RPCBroker as a Linux service
#
source $HOME/OSEHRA/VistA-installation-scripts/Scripts/setupEnvironmentVariables.sh

LOG=$VistADir/inet/Logs/cprs.log

echo "$$ Job begin `date`"                                      >>  ${LOG}
echo "$$  ${gtm_dist}/mumps -run GTMLNX^XWBTCPM"                >>  ${LOG}

${gtm_dist}/mumps -run GTMLNX^XWBTCPM "${CPRS_BANNER}"         2>>  ${LOG}
echo "$$  RPCBroker stopped with exit code $?"                  >>  ${LOG}
echo "$$ Job ended `date`"
