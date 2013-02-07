#!/bin/sh
export VistADir=$HOME/VistA-Instance
export VistARoutines=$VistADir/r
export gtm_dist=/usr/lib/fis-gtm/V5.5-000_x86_64
export gtmprofilefile=$gtm_dist/gtmprofile
source $gtmprofilefile
export gtmgbldir=$VistADir/g/database
export gtmroutines="$VistADir/o($VistADir/r) $gtm_dist/libgtmutil.so"
export gtm_tmp=/tmp
alias GDE="$gtm_dist/mumps -r GDE"
alias LKE="$gtm_dist/mumps -r LKE"
alias gtm="$gtm_dist/mumps -direct"
alias rundown='$gtm_dist/mupip rundown -r "*"'
alias mupip="$gtm_dist/mupip"
