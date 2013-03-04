.. title: OSEHRA VistA

============
OSEHRA VistA
============

This source tree contains patches, tests, and tools for VistA, the Veterans
Health Information Systems and Technology Architecture.  It is maintained by
OSEHRA, the Open Source Electronic Health Record Agent.

-------
Purpose
-------

The OSEHRA `VistA-FOIA Source Tree`_ contains a static representation of VistA.
VistA is built on a database platform that houses both code and data so it
requires programmatic operations to apply changes while maintaining consistency.
Patches in this source tree may be applied to a running VistA instance to keep
it up to date.

------
Layout
------

The source tree is organized as follows:

* ``Packages.csv``: A spreadsheet recording VistA packages.  For each
  package it has a name, namespaces, file numbers and names, and a
  directory name for this source tree.

* ``CMake/``: CMake build system modules.

* ``Documentation/``: OSEHRA VistA documentation pages.

* ``Scripts/``: Contains scripts to process VistA patch files, populate
  the ``Packages/`` directory layout, analyze dependencies, and compute
  an order for patch installation.

* ``Packages/<package>/Patches/<patch>/``: Holds distribution files for one patch.
  The ``<package>`` directory name matches that in ``Packages.csv``.
  The ``<patch>`` directory name is derived from the patch build name.
  For example, directory ``Packages/Kernel/Patches/XU_8.0_431`` holds files for
  KERNEL patch ``XU*8.0*431``.

* ``Packages/Order Entry Results Reporting/CPRS``: Delphi sources for the
  "Computerized Patient Record System".

* ``Packages/RPC Broker/BDK``: Delphi sources for the
  "Broker Development Kit".

* ``Packages/MultiBuilds/``: Holds distribution files for multi-build patches.
  Since these may contain builds from multiple packages we do not keep them
  under a specific package directory.

* ``Packages/Uncategorized/``: Holds files with no clear package category.
  In particular, it contains ``*.csv`` spreadsheets derived from the
  `VA FOIA Spreadsheets`_.  See ``Scripts/HowtoUpdateSpreadsheets.rst``
  to update them.

* ``FOIA/``: Holds files downloaded from the `VA VistA FOIA Site`_.
  See ``Scripts/HowtoDownloadPatches.rst`` to populate it.
  See ``Scripts/HowtoPopulatePackages.rst`` to move files to ``Packages/``.

-----
Links
-----

* OSEHRA Homepage: http://osehra.org
* OSEHRA Repositories: http://code.osehra.org
* OSEHRA Github: https://github.com/OSEHRA
* OSEHRA Gitorious: https://gitorious.org/osehra
* VA VistA Document Library: http://www.va.gov/vdl

.. _`VA VistA FOIA Site`: https://downloads.va.gov/files/FOIA
.. _`VA FOIA Spreadsheets`: https://downloads.va.gov/files/FOIA/Software/DBA_VistA_FOIA_System_Files
.. _`VistA-FOIA Source Tree`: http://code.osehra.org/VistA-FOIA.git
