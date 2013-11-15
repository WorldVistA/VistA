Overview
========

.. role:: usertype
    :class: usertype

The scripts in this directory perform tasks intended to stand up a full VistA
instance in a fresh RHEL based or Ubuntu based Linux environment.

Vagrant Integration
===================

Vagrant has been integrated for GTM/Ubuntu. Goto the Scripts/Install/Ubuntu
directory and type "vagrant up" to provision a new Virtual Machine (VM) running
Ubuntu 12.04 LTS and GTM 6.x automatically. This procedure also performs a
"dashboard" build which runs the current OSEHRA testing suite for VistA and
submits it to the dashboard_. This will take about 30 minutes to complete.
Further Vagrant information_.

Bootstrapping
=============

The bootstrap scripts install basic packages require for VistA to function and
update the distro to the latest version.

RHEL:

.. parsed-literal::

    ~/Development/VistA$ :usertype:`Scripts/Install/RHEL/bootstrapRHELserver.sh`

Ubuntu:

.. parsed-literal::
    ~/Development/VistA$ :usertype:`sudo Scripts/Install/Ubuntu/bootstrapUbuntuserver.sh`

Install M environment
=====================

There are scripts for Intersystems Caché and Fidelity Information Systems GT.M
included in the Cache and GTM folders respectively.

Since each M implementation requires different steps to prepare the environment
the steps will vary slightly.

GT.M
----

You must change into the GTM directory (Scripts/Install/GTM) before running the
scripts.

    1. sudo install.sh
    2. sudo createVistaInstance.sh

Caché
-----

This is currently a work in progress. The scripts function but makes lots of
assumptions about the environment. Customization of these scripts will be
required for them to work.

Change into the Cache directory (Scripts/Install/Cache) before running the
scripts.

    1. createDaemonAccount.sh
    2. configureFirewall.sh
    3. install.sh

Repository Directory Layout
===========================

* Scripts/Install/Cache - Contains all scripts specific to the Caché M
  environment

    * etc/init.d - init scripts specific to Caché

* Scripts/Install/Common - Contains all scripts not specific to any M
  environment

* Scripts/Install/Dashboard - Scripts for submitting to the OSEHRA Dashboard

    * Scripts are experimental quality

* Scripts/Install/GTM - Contains all scripts specific to the GT.M M environment

    * etc/init.d - init script to start VistA upon system boot
    * etc/xinetd.d - scripts for RPC broker and VistALink
    * bin - scripts for VistA services

* Scripts/Install/RHEL - Contains all scripts specific to RHEL based Linux
  distros

    * CentOS is the primary platform used by developers for testing

* Scripts/Install/Ubuntu - Contains all scripts specific to Ubuntu based Linux
  distros

    * Ubuntu 12.04 LTS is the primary platform used by developers for testing

VistA Directory Layout
======================

GT.M
----

$instance is the name of the VistA environment being installed. Currently
hard-coded to FOIA

* /home/$instance - Root directory for VistA environment

    * bin - Scripts specific to this VistA environment

        * prog.sh - Programmer mode script. Dumps user to $instance>
        * tied.sh - Regular user script. Forces user into ^ZU

    * etc - Configuration files for VistA environment

        * db.gde - Script to create GT.M Global Directory
        * env - Setup environment variables for this VistA environment
        * xinetd.d - Scripts copied from Scripts/Install/GTM/xinetd.d directory
        * init.d - Scripts copied from Scripts/Install/GTM/etc/init.d directory

    * log - Setup as the GT.M log directory and contains logs from xinetd
      scripts

    * lib - stores symlinks to any libraries used by this installation

    * r - Routines from source VistA distribution

    * r/$gtmver - Stores object files per GT.M version

    * tmp - Used for VistA temp files

    * g - contains the GT.M .gld and .dat for the VistA environment

    * j - contains the journals for the VistA environment

    * s - contains secondary development

    * s/$gtmver - Stores object files per GT.M version

    * p - contains primary development

    * s/$gtmver - Stores object files per GT.M version

Caché
-----

This is a work in progress. The goal is to use similar structures for GT.M and
Caché where appropriate.

* /opt/$instance - Root directory for the VistA environment $instance is
  hard-coded to cacheprod for now.

    * bin - Scripts specific to this VistA environment

        * prog.sh - Programmer mode script. Dumps user to $namespace>
        * tied.sh - Regular user script. Forces user into ^ZU

    * etc - Configuration files for VistA environment

        * xinetd.d - Scripts copied from common folder in the repository
        * init.d - Scripts copied from Cache/etc/init.d in the repository

    * log - contains logs from xinetd scripts

    * $cachever - Example $cachever: 2011.1.2.701. Used to store items specific
      to a Caché version

        * g - contains the CACHE.DAT for the VistA environment
        * j - contains the journals for the VistA environment

.. _dashboard: http://code.osehra.org/CDash/index.php?project=Open+Source+EHR
.. _information: Vagrant.rst
