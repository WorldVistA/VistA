#!/bin/sh
cd ~
VistADir=$HOME/VistA
gtm_dist=/usr/lib/fis-gtm/V5.5-000_x86_64
mkdir -p $VistADir
mkdir -p $VistADir/r
source $gtm_dist/gtmprofile
export gtmgbldir=$VistADir/database
export gtmroutines=$VistADir/r
$gtm_dist/mumps -r GDE

