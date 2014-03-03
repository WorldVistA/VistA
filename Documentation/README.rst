.. figure::
   http://code.osehra.org/content/named/SHA1/c0286b38-OSEHRA_LogoText.png
   :align: center

Instructions for Establishing and Testing the OSEHRA Code Base
---------------------------------------------------------------

These pages describe the steps required to obtain the OSEHRA open source VistA
codebase from the OSEHRA code repository, establish a working test environment,
execute the tests, and view the results on the OSEHRA Software Quality
Dashboard.

The instructions comprise of the following sections:

  * ObtainingandInstallAuxPrograms_
  * ObtainingVistAMCode_
  * ObtainingTestingCode_
  * PrepareMComponents_
  * ChoosingMUMPSEnvironment_

For the following two sections, follow the instructions based upon which type of
MUMPS database will be utilized:

Caché:

  * InstallCache_
  * If you are using a downloaded CACHE.DAT file, see InstallCacheDat_
  * To import from the OSEHRA VistA-M Repository, see ImportCache_

GT.M:

  * InstallGTM_
  * ImportGTM_

The last sections are common to both types of systems and utilize the OSEHRA
Testing Harness:

  * SetupTestingEnvironment_
  * RunningandUploadingTests_
  * ReviewingResults_

The import and simple configuration of the M components of VistA has been
automated. See AutomatedVistAConfiguration_ for more details.

For Initialization and Setup without using the OSEHRA Utilities, see:

  * Initialization_

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

Troubleshooting:
````````````````

To report a problem or see potential solutions visit the `Troubleshooting Page`_

Standards;
``````````

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
.. _ReviewingResults: ReviewingResults.rst
.. _AutomatedVistAConfiguration: AutomatedVistAConfiguration.rst
.. _PrepareMComponents: PrepareMComponents.rst
.. _Initialization: Initialization.rst
.. _Vagrant: http://www.vagrantup.com
.. _Overview: Install/Vagrant.rst
.. _`Amazon Web Services`: Install/AWS.rst
.. _Rackspace: Install/Rackspace.rst
.. _`M Standards and Conventions`: Standards/SAC.rst
