How to use DefaultKIDSBuildInstaller.py
=======================================

This document describes the usage of DefaultKIDSBuildInstaller python module

Description
-----------

As the name indicates, this module is mainly used to automatically install a KIDS Build
on a running VistA instance.

This script is intended to be used for development only, and use it at you own risk.
Please do **NOT** try it on production environment!

Before running the script, please make sure

* Already setup the required environment. If not, please refer to `Setup Script Environment <HowtoSetupEnv.rst>`__.
* VistA Taskman is up and running.
* Required patches are already installed, and in right order.
* Already backup the current VistA instance.

Install a KIDS build
--------------------

command::

  python DefaultKIDSBuildInstaller.py <path_to_kids_build_file> <VistA_connection_arguments>

Sample on GTM/Linux::

  $ python DefaultKIDSBuildInstaller.py /tmp/XU-8_SEQ-UNK_PAT-999.KID -S 2

It will print out KIDS installation messages to the terminal.

To re-install a KIDS build, just append ``-r`` to the above command.

To import a global before installing the KIDS build, append ``-g <patch_to_global_file>`` to the above command.

To print the transport globals of the KIDS build, append ``-t <path_to_output_dir>`` to the above command
