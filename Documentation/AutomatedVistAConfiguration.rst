Automated VistA Import and Configuration
========================================

The manual steps for the Caché and GTM importing process can be found at ImportCache_ and ImportGT.M_.
The ImportRG script runs files that mirror these scripts and will introduce the same codebase into the database.

The process for importing VistA-M routines and globals into Caché and GTM has been automated. These files are configured and prepared during the setup
of the VistA repository after selecting the TEST_VISTA_FRESH_ option.  The TEST_VISTA_FRESH option also uses this import and configuration during the \'build\'
step of a CTest dashboard submission. To execute the automated import and configuration via the command line, execute the following steps from a gitbash (Windows) or linux shell:

.. parsed-literal::

  $ cd  VistA/bin

  $ cmake -P Testing/Setup/ImportRG.cmake

Note that during the execution of the ImportRG script, in addition to the Routine and Global imports, three additional setup scripts are executed automatically:

=============================  ================================================================
   Script Name                                 Purpose
=============================  ================================================================
   PostImportSetupScript.py       Sets up VistA with an institution, domain, and user accounts
   ImportUsers.py                        Imports test patients into VistA
   ClinicSetup.py                  Sets up a clinic for appointment scheduling
=============================  ================================================================

.. _TEST_VISTA_FRESH: SetupTestingEnvironment.rst#test_vista_fresh-and-test_vista_setup
.. _ImportCache: ImportCache.rst#retrieving-the-code-from-git-and-importing-into-cach
.. _ImportGT.M: ImportGTM.rst#retrieving-the-code-from-git-and-importing-into-gtm
