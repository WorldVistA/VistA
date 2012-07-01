#!/bin/sh
cd ~
VistADir=$HOME/VistA
gtm_dist=/usr/lib/fis-gtm/V5.5-000_x86_64
mkdir -p $VistADir
mkdir -p $VistADir/r
mkdir -p $VistADir/o
source $gtm_dist/gtmprofile
export gtmgbldir=$VistADir/database
export gtmroutines="$VistADir/o($VistADir/r) $gtm_dist/libgtmutil.so"
echo "change -s DEFAULT -f=$VistADir/database" | $gtm_dist/mumps -r GDE
$gtm_dist/mupip create
$gtm_dist/dse change -f -key_max=1023 -rec=4096

