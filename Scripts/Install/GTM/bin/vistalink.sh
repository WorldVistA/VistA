#!/bin/bash
#
# This is a file to run VistALink as a Linux service
#
export HOME=/home/foia
export REMOTE_HOST=`echo $REMOTE_HOST | sed 's/::ffff://'`
source $HOME/etc/env

LOG=$HOME/log/vistalink.log

echo "$$ Job begin `date`" >> ${LOG}
echo "$$ ${gtm_dist}/mumps -run GTMLNX^XOBVTCP" >> ${LOG}
${gtm_dist}/mumps -run GTMLNX^XOBVTCP 2>> ${LOG}
echo "$$ Vistalink stopped with exit code $?" >> ${LOG}
echo "$$ Job ended `date`"
