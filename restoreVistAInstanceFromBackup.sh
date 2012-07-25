#!/bin/sh
export VistADir=$HOME/VistA-Instance
export VistABackup=$HOME/VistA-Instance-Backup
mv $VistADir /tmp
cp -a $VistABackup $VistADir
