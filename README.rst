Overview
========

The scripts in this directory perform tasks intended to stand up a full VistA instance in a fresh RHEL based or Ubuntu based Linux environment.

Bootstrapping
=============
The bootstrap scripts install basic packages require for VistA to function and update the distro to the latest version.

RHEL:
    sudo RHEL/bootstrapRHELserver.sh
Ubuntu:
    sudo Ubuntu/bootstrapUbuntuserver.sh

Install M environment
=====================
There are scripts for Intersystems Caché and Fidelity Information Systems GT.M included in the Cache and GTM folders respectively.

Since each M implementation requires different steps to prepare the environment the steps will vary slightly.

GT.M
----
You must change into the GTM directory before running the scripts.

    1. sudo install.sh
    2. sudo createVistaInstance.sh
    3. (Optional & very BETA - you've been warned) sudo importVista.sh

Caché
-----
This is currently a work in progress. The basic structure is there, but untested.

Change into the Cache directory before running the scripts.

    1. createDaemonAccount.sh
    2. configureFirewall.sh
    3. install.sh

Repository Directory Layout
===========================
* Cache - Contains all scripts specific to the Caché M environment
    * etc/init.d - init scripts specific to Caché
* Common - Contains all scripts not specific to any M environment
    * Mostly contains init scripts for RPC Broker, VistALink, etc.
* Dashboard - Scripts for submitting to the OSEHRA Dashboard
    * Scripts are experimental quality
* GTM - Contains all scripts specific to the GT.M M environment
    * etc/init.d - init script to start VistA upon system boot
    * bin - scripts for manipulating the GT.M VistA instance
        * TODO item
* RHEL - Contains all scripts specific to RHEL based Linux distros
    * CentOS will be tested
* Ubuntu - Contains all scripts specific to Ubuntu based Linux distros
    * Tested using Ubuntu 12.04 LTS

VistA Directory Layout
======================

GT.M
----
$instance is the name of the VistA environment being installed. Currently hard coded to FOIA

* /opt/$instance - Root directory for VistA environment
    * bin - Scripts specific to this VistA environment
        * prog.sh - Programmer mode script. Dumps user to $instance>
        * tied.sh - Regular user script. Forces user into ^ZU
    * etc - Configuration files for VistA environment
        * db.gde - Script to create GT.M Global Directory
        * env - Setup environment variables for this VistA environment
        * xinetd.d - Scripts copied from Common folder in the repository
        * init.d - Scripts copied from GTM/etc/init.d in the repository
    * log - Setup as the GT.M log directory and contains logs from xinetd scripts
    * r - Routines from source VistA distribution
    * tmp - Used for VistA temp files
    * $gtmver - Example $gtmver: V6.0-000_x86_64. Used to store items specific to a GT.M version
        * g - contains the GT.M .gld and .dat for the VistA environment
        * j - contains the journals for the VistA environment
        * o - contains the objects for the VistA environment
        * r - contains any GT.M version specific routines for the VistA environment

Caché
-----
This is a work in progress. The goal is to use similar structures for GT.M and Caché where appropriate.

* /opt/$namespace - Root directory for the VistA environment $namespace is equivalent to GT.M $instance
    * bin - Scripts specific to this VistA environment
        * prog.sh - Programmer mode script. Dumps user to $namespace>
        * tied.sh - Regular user script. Forces user into ^ZU
    * etc - Configuration files for VistA environment
        * xinetd.d - Scripts copied from common folder in the repository
        * init.d - Scripts copied from Cache/etc/init.d in the repository
    * log - contains logs from xinetd scripts
    * $cachever - Example $cachever: 2011.1.2.701. Used to store items specific to a Caché version
        * g - contains the CACHE.DAT for the VistA environment
        * j - contains the journals for the VistA environment
