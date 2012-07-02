#!/bin/sh
export VistADir=$HOME/VistA
export gtm_dist=/usr/lib/fis-gtm/V5.5-000_x86_64
source $gtm_dist/gtmprofile
export gtmgbldir=$VistADir/database
export gtmroutines="$VistADir/o($VistADir/r) $gtm_dist/libgtmutil.so"
