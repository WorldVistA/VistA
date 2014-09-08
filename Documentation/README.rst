.. figure::
   http://code.osehra.org/content/named/SHA1/50394d75-OSEHRAllianceLogo.png
   :align: center

**************************
OSEHRA VistA Documentation
**************************

This page is the main page to find documentation regarding the capabilities of
the OSEHRA VistA source tree.  This source tree contains a wide range of
utilities that are useful for generating or maintaining a VistA instance or
programs related to one.

.. contents::

Build CPRS
----------

To build the Computerized Patient Record System (CPRS) from the OSEHRA VistA
source tree, see the following file for instructions:

  * `BUILD-Delphi`_

Automatic Patching
-------------------

To learn more about, and utilize, the automatic patching of a VistA instance
from the files in the VistA source tree, follow the instructions in:

  * `PatchSequenceApply`_

Instructions for Establishing and Testing a VistA Installation
--------------------------------------------------------------

These pages describe the steps required to obtain the OSEHRA open source VistA
codebase from the OSEHRA code repository, establish a working test environment,
execute the tests, and view the results on the OSEHRA Software Quality
Dashboard.

The first section consists of instructions on acquiring the source code and
other auxiliary programs:

  * ObtainingandInstallAuxPrograms_
  * ObtainingTestingCode_

If the VistA instance to be generate is going to be imported from the OSEHRA
VistA-M repository, see the two following files for instructions on obtaining
and preparing the M code for import:

 * ObtainingVistAMCode_
 * PrepareMComponents_

For the next sections, follow the instructions based upon which type of
MUMPS database will be utilized for the VistA installation:

Caché
`````
  If necessary, OSEHRA has compiled a set of instructions on how to install the
  Caché instance:

  * InstallCache_

  To install a downloaded CACHE.DAT file as the source of the VistA MUMPS code
  and follow the instructions here:

  * InstallCacheDat_

  For the instructions to import the MUMPS code from the OSEHRA VistA-M
  Repository into a Caché instance, see

  * ImportCache_

GT.M
````
  For instructions on the installation of a FIS-GT.M environment, see

  * InstallGTM_

  And to import the OSEHRA VistA-M code into the GT.M environment, see

  * ImportGTM_

The last sections are common to both types of systems and utilize the OSEHRA
Testing Harness:

  * SetupTestingEnvironment_
  * RunningandUploadingTests_

  For information on how to add to the OSEHRA Testing Harness, see:

    * AddingTests_

Once the tests have been run and submitted, the results can be seen on the
OSEHRA Dashboard, for more information see:

  * ReviewingResults_

The import and simple configuration of the M components of VistA has been
automated. See the following file for the information needed to set up this
utility.

  * AutomatedVistAConfiguration_

For initialization and setup of an imported VistA instance (general setup and
adding a user)  without using the OSEHRA Utilities, see:

  * Initialization_

Generating the OSEHRA VistA-M Dox Pages
----------------------------------------

The OSEHRA VistA source tree is also used in the generation of the Dox pages
which can be found at `code.osehra.org/dox`_. For instructions on how to set up
and execute the steps necessary to generate the HTML files, see setupDox_.


Automated Virtual Machine (VM) creation and VistA installation
--------------------------------------------------------------

Using the power of Vagrant_ there is a Vagrantfile in the
``Scripts/Install/Ubuntu`` directory that can be used to create a VM with VistA
installed and runs a selection of unit tests. This type of VM creation is
designed with DevOps in mind, but can be useful to try VistA out for the first
time, demo system, among many other uses. However, DO NOT use this VM for
production purposes!

  * Overview_

For more information regarding using Vagrant with cloud providers:

  * `Amazon Web Services`_
  * Rackspace_

Troubleshooting
---------------

To report a problem or see potential solutions visit the `Troubleshooting Page`_

Standards
---------

OSEHRA mantains the Standards and Conventions for software in the Standards
directory and includes:

  * `M Standards and Conventions`_

.. _`Troubleshooting Page`:
   http://www.osehra.org/wiki/troubleshooting-installation-and-testing
.. _ObtainingandInstallAuxPrograms: ObtainingandInstallAuxPrograms.rst
.. _ObtainingVistAMCode: ObtainingVistAMCode.rst
.. _ChoosingMUMPSEnvironment: ChoosingMUMPSEnvironment.rst
.. _InstallCache: InstallCache.rst
.. _InstallCacheDat: InstallCacheDat.rst
.. _ImportCache: ImportCache.rst
.. _InstallGTM: InstallGTM.rst
.. _ImportGTM: ImportGTM.rst
.. _ObtainingTestingCode: ObtainingTestingCode.rst
.. _SetupTestingEnvironment: SetupTestingEnvironment.rst
.. _RunningandUploadingTests: RunningandUploadingTests.rst
.. _AddingTests: AddingTests.rst
.. _ReviewingResults: ReviewingResults.rst
.. _AutomatedVistAConfiguration: AutomatedVistAConfiguration.rst
.. _PrepareMComponents: PrepareMComponents.rst
.. _Initialization: Initialization.rst
.. _Vagrant: http://www.vagrantup.com
.. _Overview: Install/Vagrant.rst
.. _`Amazon Web Services`: Install/AWS.rst
.. _Rackspace: Install/Rackspace.rst
.. _`M Standards and Conventions`: Standards/SAC.rst
.. _`PatchSequenceApply`: ../Scripts/PatchSequenceApply.rst
.. _`BUILD-Delphi`: ../BUILD-Delphi.rst
.. _`code.osehra.org/dox`: http://code.osehra.org/dox/index.html
.. _setupDox: setupDox.rst
