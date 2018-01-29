Automated VistA Import and Configuration
========================================

The process for importing VistA-M routines and globals into Caché and GTM has
been automated. The automated import and configuration scripts are configured
and prepared during the setup of the VistA repository after selecting the
TEST_VISTA_FRESH_ option.

First, the ImportRG script executes the script described in
`Generate Import Files`_.

Next, it executes scripts that mirror the steps for the Caché and GTM importing
process that can be found at ImportCache_ and ImportGT.M_. The ImportRG script
will introduce the same codebase into the database as the the manual processes.

To execute the automated import and configuration via the command line, execute
the following steps from a gitbash (Windows) or linux shell:

.. parsed-literal::

  $ cd  VistA/bin

  $ cmake -P Testing/Setup/ImportRG.cmake


Automated VistA Setup
=====================

If the `TEST_VISTA_SETUP` option was selected, then during the execution of the
ImportRG script, three additional setup scripts are executed automatically:

=============================  ================================================================
   Script Name                                 Purpose
=============================  ================================================================
   PostImportSetupScript.py       Sets up VistA with an institution, domain, and user accounts
   ImportUsers.py                        Imports test patients into VistA
   ClinicSetup.py                  Sets up a clinic for appointment scheduling
=============================  ================================================================

.. _`Generate Import Files`: PrepareMComponents.rst#generate_import_files
.. _TEST_VISTA_FRESH: SetupTestingEnvironment.rst#test_vista_fresh-and-test_vista_setup
.. _ImportCache: ImportCache.rst#retrieving-the-code-from-git-and-importing-into-cach
.. _ImportGT.M: ImportGTM.rst#retrieving-the-code-from-git-and-importing-into-gtm
