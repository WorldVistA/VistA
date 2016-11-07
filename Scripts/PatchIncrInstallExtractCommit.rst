PatchIncrInstallExtractCommit
=============================

**At this point, this utility is only able be run on an Intersystems Caché
environment**

The ``PatchIncInstallExtractCommit.py`` script is used to tie together the
aspects of the OSEHRA auto-patching framework with the repository generation
capability of the OSEHRA testing framework.  The script here will take an input
file with a series of variables and will execute a series of steps:

* install a patch
* export the routines and globals
* commit the changes to a VistA-M branch

These steps could be set to be repeated until there are no more patches to
install in a given directory.

Assumptions
-----------

There are a few assumptions that the script makes:

*  **The M[UMPS] environment is a Caché instance**
* The VistA-M directory has been cloned via Git

Input File
----------

The ``PatchIncrInstallExtractCommit.py`` script takes one input file which
is a JSON formatted file with a series of customized information for the
script to utilize.  A sample file with the correct format is provide in the
``PatchIncrInstallExtractCommit.sample.json`` file.  We will break down each
section and explain what information is needed in each section

VistA_Connection
################

The information here contains the content that the script will need to connect
to the Caché environment.  This information is the same as the some of the
other scripts in this directory and has the same defaults:

+-----------------------------+--------------------------------------+
|       JSON Key              |     Expected Value (default value)   |
+=============================+======================================+
|        system               |   1 for Caché                        |
+-----------------------------+--------------------------------------+
|       instance              |   Name of Caché instance ("CACHE")   |
|                             |                                      |
+-----------------------------+--------------------------------------+
|       namespace             |   Name of Caché namespace ("VistA")  |
|                             |                                      |
+-----------------------------+--------------------------------------+
|       username              |   Username for a Caché user          |
|                             |   (if needed)                        |
+-----------------------------+--------------------------------------+
|       password              |   Password for a Caché user          |
|                             |   (if needed)                        |
+-----------------------------+--------------------------------------+
|       useSudo               |   Use ``sudo`` when starting and     |
|                             |   stopping the M[UMPS] environment   |
|                             |   in a Linux environment             |
+-----------------------------+--------------------------------------+

**Note** Ensure that the ``ccontrol`` executable can be found in the system
path.  The script will not function correctly if that file is not found.

Patch_Apply
###########

The next set of information should contain the local paths for the patches that
are going to be installed.  The ``input_patch_dir`` should be the full path to
a directory which contains the ``.KIDS`` files that should be installed into
the system.  The ``log_dir`` is where the output files of the
automated patch installation steps will be found and the value of
``continuous`` will determine if the script stops after a single patch or
continues until every available patch has been installed.

+-----------------------------+--------------------------------------+
|       JSON Key              |     Expected Value                   |
+=============================+======================================+
|        log_dir              | Path to a directory to store         |
|                             | log files                            |
+-----------------------------+--------------------------------------+
|      input_patch_dir        | Path to a directory where KIDS       |
|                             | patches are found                    |
+-----------------------------+--------------------------------------+
|        continuous           | ``true``  to install all patches, one|
|                             | after another.                       |
|                             | ``false`` to install one patch in the|
|                             | run and return                       |
+-----------------------------+--------------------------------------+

M_Extract
#########

Once the patch is installed, the scripts will stop the M[UMPS] instance and
attempt to export the routines and globals to a copy of the VistA-M repository.
The first two entries, ``temp_output_dir`` and ``log_dir``, will both hold the
temporary files for the export and logs of the interactions.  The ``M_repo`` is
used to give the local path to the cloned instance of the VistA-M repository.
The ``commit_msg_dir`` will be used to store a series of ``.msg`` files.  These
files are used to populate the commit message for each update of the VistA-M
repository.

+-----------------------------+--------------------------------------+
|       JSON Key              |     Expected Value                   |
+=============================+======================================+
|        temp_output_dir      |    Path to store interim files of    |
|                             |    exported VistA files              |
+-----------------------------+--------------------------------------+
|        log_dir              |    Path to a directory to store      |
|                             |    log files                         |
+-----------------------------+--------------------------------------+
|        M_repo               |    Path to the VistA-M directory     |
+-----------------------------+--------------------------------------+
|        M_repo_branch        |    Name of the branch of the VistA-M |
|                             |    repository to commit to           |
+-----------------------------+--------------------------------------+
|        commit_msg_dir       | Directory which will contain commit  |
|                             | messages for installed patches       |
+-----------------------------+--------------------------------------+

Backup
######

In addition to exporting the routines and globals, the script can take a
copy of the Cache.dat file and keep a back-up of the instance after each
install, in the case that something goes wrong with an install.  This feature
can be disabled by deleting the section from the JSON file.

+-----------------------------+--------------------------------------+
|       JSON Key              |     Expected Value                   |
+=============================+======================================+
|        backup_dir           | Path to a directory to store a zipped|
|                             | copy of a CACHE.dat file             |
+-----------------------------+--------------------------------------+
|        cache_dat_dir        | Path to the directory where the VistA|
|                             | CACHE.dat can be found               |
+-----------------------------+--------------------------------------+
|        auto_recover         | Attempt to replace a CACHE.dat if the|
|                             | install fails                        |
+-----------------------------+--------------------------------------+

Example
#######

A fully configured instance of the file would look something like the following

.. parsed-literal::

  {
    "VistA_Connection":
    {
      "system": 1,
      "instance": "CACHE",
      "namespace": "OSEHRA",
      "username": "softhat",
      "password": "Pa$$word12#$",
      "useSudo": true
    },
    "Patch_Apply":
    {
      "log_dir": "/home/softhat/tmp",
      "input_patch_dir": "/home/softhat/work/VistA/Packages/",
      "continuous": true
    },
    "M_Extract":
    {
      "temp_output_dir":  "/home/softhat/tmp",
      "log_dir": "/home/softhat/tmp",
      "M_repo": "/home/softhat/work/VistA-M/",
      "M_repo_branch": "testBranch",
      "commit_msg_dir":  "/home/softhat/tmp"
    },
    "Backup":
    {
      "backup_dir":  "/home/softhat/tmp",
      "cache_dat_dir": "/opt/cache/mgr/OSEHRA",
      "auto_recover": true
    }
  }

Usage
-----

The command line signature of the ``PatchIncrInstallExtractCommit.py`` is very
simple.  You simply supply the configuration file as an argument.

.. parsed-literal::

  $ python PatchIncrInstallExtractCommit.py -h
  usage: PatchIncrInstallExtractCommit.py [-h] configFile

  Incremental install Patch, extract M Comp and commit

  positional arguments:
    configFile  Configuration file in JSON format

  optional arguments:
    -h, --help  show this help message and exit

An example command and a few lines of output would look like this:

.. parsed-literal::

 $ python PatchIncrInstallExtractCommit.py PatchIncrInstallExtractCommit.sample.json
 2016-11-07 10:41:56,971 INFO installNames is ['GMTS*2.7*117']
 2016-11-07 10:41:58,966 INFO No need to recover.
 2016-11-07 10:42:00,706 INFO Total # of KIDS Builds are 1542
 2016-11-07 10:42:00,707 INFO Total # of KIDS Info are 2047
 2016-11-07 10:42:00,707 INFO Total # of Global files are 29
 2016-11-07 10:42:00,707 INFO Total # of Python files are 16
 2016-11-07 10:42:00,707 INFO Total # of CSV files are 6
