===========================================================================
Instructions for Generating ViViaN and Visual Cross Reference Documentation
===========================================================================

.. sectnum::


Introduction
-------------
This document describes the steps required to generate the Visualizing VistA
and Namespace (ViViaN) tool and the Visual Cross Reference Documentation (DOX)
pages.

The document comprises 5 sections:

1. `Install and Setup Required Components`_
2. `Configure Scripts`_
3. `Generate ViViaN Data and DOX`_
4. `Format Data`_
5. `Review the Results`_



Automated Generation
********************


**Cache Systems Only**

OSEHRA has generated a  set of scripts to be run by Docker to automatically
generate the ViViaN and DOX pages.  To see the documentation and setup required
for that process, see `Docker and ViViaN`_



Install and Setup Required Components
-------------------------------------

Machine requirements
********************

* OS: Windows with Cache or Linux with GT.M or Cache
* CPU: At least Pentium 1.5GHZ
* Hard drive: at least 35GB free disk space
  (Note: The VistA-M repository is ~20GB and the generated files are ~8GB)
* Memory: at least 2GB


Required Tools
**************

+-----------------------------+---------------------------------------------------------------+
|    Tools                    |                        Web Link                               |
+-----------------------------+---------------------------------------------------------------+
|   CMake (2.8+)              | www.cmake.org                                                 |
+-----------------------------+---------------------------------------------------------------+
| Python 2.7 or 3 (preferred) | www.python.org                                                |
+-----------------------------+---------------------------------------------------------------+
|       Git                   | www.git-scm.com                                               |
+-----------------------------+---------------------------------------------------------------+
| Java Platform (JDK)         | www.oracle.com/technetwork/java/javase/downloads/index.html   |
+-----------------------------+---------------------------------------------------------------+
|    Dot (Graphviz)           | www.graphviz.org                                              |
+-----------------------------+---------------------------------------------------------------+
| ReportLab open-source (PDF) | bitbucket.org/rptlab/reportlab                                |
+-----------------------------+---------------------------------------------------------------+

In addition, a webserver that can handle PHP is required to host the ViViaN
pages. For example, WampServer_ can be used on Windows.


Source Files
************

Download the latest FOIA released ICR_.


OSEHRA Source Repositories
**************************

+-----------------+--------------------------------------------------------+
|   Code Bases    |   Web Link                                             |
+-----------------+--------------------------------------------------------+
|   VistA         | https://github.com/OSEHRA/VistA                        |
+-----------------+--------------------------------------------------------+
|   ViViaN        | https://github.com/OSEHRA-Sandbox/Product-Management   |
+-----------------+--------------------------------------------------------+

Use Git to make a local clone of these repositories. For example, to download
the VistA repository:

.. parsed-literal::

  $ git clone https://github.com/OSEHRA/VistA
  Cloning into 'VistA'...
  .
  .
  .

Vista-M Repository
******************

OSEHRA VistA
++++++++++++

If the desired version of VistA to generate ViViaN and the Dox pages from is
the OSEHRA version, see ObtainingVistAMCode_ to obtain the source code. Next,
follow the instructions below based upon which type of MUMPS database will be
utilized for the VistA installation:

Caché
~~~~~
If necessary, OSEHRA has compiled a set of instructions on how to install the
Caché instance: InstallCache_.

To import the MUMPS code from the OSEHRA VistA-M Repository into a Caché
instance, see `Automated VistA Configuration`_.

Instructions for additional configuration of the Caché environment can be
found here: ConfigureCache_.

GT.M
~~~~
To import the OSEHRA VistA-M code into the GT.M environment, see
`Automated VistA Configuration`_.

Other VistA
+++++++++++

To generate ViViaN and the DOX pages with a different VistA setup, such as a
FOIA release or release from another vendor, the routines and globals will need
to be placed into the structure of the VistA-M repository. See
`Populate M Repository`_ for instructions on how to populate the VistA-M
repository from an installed MUMPS environment.


Configure Scripts
-----------------

OSEHRA has created a collection of Python scripts that generate the backend
data for ViViaN as well as the DOX pages. While it would be possible to
manually run each script, it is not recommended. Instead, a CMake project has
been developed to simplify the configuration process and to help to ensure
uniformity across both ViViaN and the DOX pages. Once configured, the CMake
project generates a "test" for each script. When executed, the test will
launch the corresponding script with all required parameters. The testing
framework also ensures all required directories exist and creates log files
for any errors.

Begin the configuration process by launching the CMake-GUI. Set the two paths
at the top of the window so that the source code points to the VistA
repository. The binaries path can be set to any directory, preferably one
outside of the VistA repository tree.

.. figure:: http://code.osehra.org/content/named/SHA1/82B12B-launchCmakeGUI.png
   :align: center
   :alt:  Initial CMake-GUI page

Once those are set, click the \"Configure\" button. The application will then
prompt to specify a generator. As the generator is not used, selecting the
default option (Borland Makefile on a Windows environment and Unix Makefiles on
a Linux system) is suffcient. Click \"Finish\" after the selection is made to
continue the configuration process.

.. figure:: http://code.osehra.org/content/named/SHA1/D76CF0-selectGenerator.png
   :align: center
   :alt:  Generator selection

Following generator selection, the interface will produce a highlighted display
with two options:

.. figure:: http://code.osehra.org/content/named/SHA1/8262A6-initialCMakeGUI.png
   :align: center
   :alt:  Result of first CMake configuration

Select `DOCUMENT_VISTA` and click the \"Configure\" button again. The CMake-GUI
will be updated with the following entries:

.. figure:: http://code.osehra.org/content/named/SHA1/0D2EBC-configureCMakeGUI.png
   :align: center
   :alt:  Result of CMake configuration after DOCUMENT_VISTA is selected

Some variables are optional or have reasonable default values. Others will need
to be adjusted or set for each specific system. To aid in the configuration
process, variables have a tooltip which explains in greater detail what the
variable should contain.

If set, the `GENERATE_PDF_BUNDLE` variable creates a PDF version of all the
Package, Routine, Global, Sub-File and ICR pages. The PDFs are be organized by
package and are available to download from a link on the DOX Package pages.
This option increases the generation time significantly, and, therefore is not
selected by default.

The following variables are required for both Cache and GT.M environments.

+---------------------------+---------------------------------------------------------------+
| Variable Name             |       Description                                             |
+---------------------------+---------------------------------------------------------------+
| DOT_EXECUTABLE            | Dot executable                                                |
+---------------------------+---------------------------------------------------------------+
| GIT_EXECUTABLE            | Git executable                                                |
+---------------------------+---------------------------------------------------------------+
| PYTHON_EXECUTABLE         | Python executable                                             |
+---------------------------+---------------------------------------------------------------+
| LOCAL_DOX_LINKS           | Enable to create links to the local DOX pages instead of the  |
|                           | pages found at http://code.osehra.org/dox                     |
+---------------------------+---------------------------------------------------------------+
| ICR_FILE                  | Path to downloaded ICR_ File                                  |
+---------------------------+---------------------------------------------------------------+
| DOCUMENT_VISTA_M_DIR      | Path to VistA-M directory                                     |
+---------------------------+---------------------------------------------------------------+
| DOCUMENT_VISTA_OUTPUT_DIR | Path where ViViaN data and DOX pages will be generated.       |
|                           | ViViaN expects this to be in the ``Visual/files`` subdirectory|
|                           | of the ViViaN repository. Depending on the setup of the       |
|                           | development environment, it may make more sense to generate   |
|                           | files in a different directory and create a symbolic link.    |
|                           | See `Format Data`_.                                           |
+---------------------------+---------------------------------------------------------------+

**NOTE:** The CMake-GUI attempts to find the GIT_EXECUTABLE and
PYTHON_EXECUTABLE during configuration, to see the default values, click on the
\"Advanced\" toggle in the CMake-GUI.

These variables are Cache- or GT.M- specific.

+------------------------+------------------------------------+------------------------------------+
|   Variable Name        |     Value for Testing in Caché     |     Value for Testing in GT.M      |
+------------------------+------------------------------------+------------------------------------+
| CCONTROL_EXECUTABLE    |      Path to CControl Executable   |                    N/A             |
+------------------------+------------------------------------+------------------------------------+
| CTERM_EXECUTABLE       |      Path to CTerm Executable      |                    N/A             |
+------------------------+------------------------------------+------------------------------------+
| VISTA_CACHE_NAMESPACE  |      Namespace of VistA routines   |                    N/A             |
+------------------------+------------------------------------+------------------------------------+
| VISTA_CACHE_INSTANCE   |      Caché Instance Name           |                    N/A             |
+------------------------+------------------------------------+------------------------------------+
| VISTA_CACHE_USERNAME   |      Login Username for Caché      |                    N/A             |
|                        |      (if necessary)                |                                    |
+------------------------+------------------------------------+------------------------------------+
| VISTA_CACHE_PASSWORD   | Login Password for Caché           |                    N/A             |
|                        | (if necessary)                     |                                    |
+------------------------+------------------------------------+------------------------------------+
| GTM_DIST               |               N/A                  |     Path to GTM distribution Dir   |
+------------------------+------------------------------------+------------------------------------+

**NOTE:** The VISTA_CACHE_PASSWORD is stored and used in plain-text form.


Once the options are set, press \"Configure\" again and then \"Generate\".

.. figure:: http://code.osehra.org/content/named/SHA1/563C00-generateCMakeGUI.png
   :align: center
   :alt:  Result of CMake generate


The \"Generate\" will only add a single line to the output window saying

.. parsed-literal::

   Generating done.

This lets you know that the tests are ready to be run from the command line.

To verify that files are generated correctly, navigate to the build directory
from the command line and enter the following command:

.. parsed-literal::

 $ ctest -N

  Test   #1: XINDEX_Install
  Test   #2: CALLERGRAPH_Accounts_Receivable
  Test   #3: CALLERGRAPH_Adverse_Reaction_Tracking
  Test   #4: CALLERGRAPH_Asists

  ...

  Test #122: CALLERGRAPH_Vendor_-_Audiofax_Inc
  Test #123: CALLERGRAPH_Virtual_Patient_Record
  Test #124: CALLERGRAPH_VistALink
  Test #125: CALLERGRAPH_VistALink_Security
  Test #126: CALLERGRAPH_VistA_Integration_Adapter
  Test #127: CALLERGRAPH_VistA_System_Monitor
  Test #128: CALLERGRAPH_VistA_Web
  Test #129: CALLERGRAPH_Visual_Impairment_Service_Team
  Test #130: CALLERGRAPH_Voluntary_Timekeeping
  Test #131: CALLERGRAPH_Web_Services_Client
  Test #132: CALLERGRAPH_Womens_Health
  Test #133: CALLERGRAPH_Wounded_Injured_and_Ill_Warriors
  Test #134: GetFilemanSchema
  Test #135: MRoutineAnalyzer
  Test #136: FileManGlobalDataParser
  Test #137: ICRParser
  Test #138: GenerateRepoInfo
  Test #139: GraphGenerator
  Test #140: WebPageGenerator
  Test #141: GeneratePackageDep
  Test #142: RequirementsParser
  Test #143: GenerateNameNumberDisplay


Generate ViViaN Data and DOX
----------------------------

The next step is to run the `ctest` command to execute the tests and generate
the ViViaN data and DOX output. Depending upon the machine power, it could take
several hours for all of the scripts to finish. The command to start the tests
running is the same as above, without the -N notation:

.. parsed-literal::

  $ ctest

  ...

        Start   1: XINDEX_Install
  1/143 Test   #1: XINDEX_Install ......................................................   Passed   21.83 sec
        Start   2: CALLERGRAPH_Accounts_Receivable
  2/143 Test   #2: CALLERGRAPH_Accounts_Receivable ......................................   Passed   21.83 sec
        Start   3: CALLERGRAPH_Adverse_Reaction_Tracking
  3/143 Test   #3: CALLERGRAPH_Adverse_Reaction_Tracking ................................   Passed    4.04 sec
        Start   4: CALLERGRAPH_Asists
  4/143 Test   #4: CALLERGRAPH_Asists ...................................................   Passed    3.35 sec
        Start   5: CALLERGRAPH_Authorization_Subscription
  5/143 Test   #5: CALLERGRAPH_Authorization_Subscription ...............................   Passed    0.98 sec

  ...

        Start 134: GetFilemanSchema
  134/143 Test #134: GetFilemanSchema ...................................................   Passed  736.81 sec
        Start 135: MRoutineAnalyzer
  135/143 Test #135: MRoutineAnalyzer ...................................................   Passed   59.94 sec
        Start 136: FileManGlobalDataParser
  136/143 Test #136: FileManGlobalDataParser ............................................   Passed  2962.67 sec
        Start 137: ICRParser
  137/143 Test #137: ICRParser ..........................................................   Passed   40.28 sec
      Start 138: GenerateRepoInfo
  138/143 Test #138: GenerateRepoInfo ...................................................   Passed   0.25 sec
        Start 138: GraphGenerator
  139/143 Test #139: GraphGenerator ......................................................  Passed  651.08 sec
        Start 140: WebPageGenerator
  139/140 Test #140: WebPageGenerator ...................................................   Passed  3219.08 sec

  ...

To run tests with more output printed to the console, use the verbose option:

.. parsed-literal::

  $ ctest -VV

Although tests are expected to run in order and depend on output from previous
tests, it is possible, if necessary, to run tests individually. For example, to
just run **ICRParser**:

.. parsed-literal::

  $ ctest -R ICRParser

Each test and corresponding Python script is described below.

1. The **CALLERGRAPH_** scripts are found in the ``Docs\CallerGraph``
   subdirectory of the build directory. These scripts generate XINDEX based
   cross reference output that is used by **WebPageGenerator** and
   **GeneratePackageDep**.

2. The **GetFilemanSchema** test executes the ``FilemanGlobalAttributes.py``
   script from the ``Docs\CallerGraph`` subdirectory of the build directory.
   This script generates Fileman Schema used by `WebPageGenerator` and
   **GeneratePackageDep**.

3. The **MRoutineAnalyzer** test is unique in that it does not execute a Python
   script. Instead, it downloads and executes a version of the RGI/PwC tool
   called the `M Routine Analyzer`_ which has been modified by Jason Li. This
   tool creates a JSON file containing information about the database calls
   that routines make to query FileMan for data. The output file,
   ``filemanDBCall.json``, is used by **WebPageGenerator** and
   **GeneratePackageDep**.

4. The **FileManGlobalDataParser** test runs the FileManGlobalDataParser script
   from VistA's ``Utilities/Dox/PythonScripts`` directory. The script generates
   the backend data for ViViaN as well as ``Routine-Ref.json``, which is used
   by **WebPageGenerator**.

5. The **ICRParser** test runs the ICRParser script from VistA's
   ``Utilities/Dox/PythonScripts`` directory. This script parses and converts
   the FOIA released ICR_ text file to JSON (used by DOX), HTML (used by
   ViViaN) and PDF (used by DOX package download).

6. The **GeneratePackageDep** test runs the CrossReferenceBuilder file which
   reads the Schema and Callergraph log files and generates the ``pkgdep.json``
   file which is used by ViViaN

7. The **WebPageGenerator** test runs a Python script of the same name from the
   ``Utilities/Dox/PythonScripts`` directory in the VistA repository. This
   script uses output from the previous test to generate the html DOX pages.
   This script also generates PDF package bundles that can be downloaded from
   the DOX package pages.

8. The **RequirementsParser** test runs a Python script of the same name from
   the ``Utilities/Dox/PythonScripts`` directory in the VistA repository. This
   script uses an Excel spreadsheet of "unfulfilled requirements" information
   to generate a JSON listing of information and pages summarizing the
   requirements.  These output pages are utilized by the BFF & Requirements
   page.

**NOTE:** After running tests, CTest automatically creates the
``Testing/Temporary`` subfolder in the binary directory. This folder contains
two files: ``LastTest.log`` (test output) and ``LastTestsFailed.log`` (list of
failed tests).

Generate DOX or ViViaN Separately
---------------------------------

It is possible to configure the scripts to only generate the DOX pages or the
ViViaN backend data. After following the instructions in `Configure Scripts`_,
uncheck either the `GENERATE_DOX` or `GENERATE_VIVIAN` variable under the
\"Advanced\" section in the CMake-GUI. Select \"Configure\" again and then
\"Generate\".

**NOTE:** PDF bundles are only generated if `GENERATE_DOX` and
`GENERATE_PDF_BUNDLE` are both selected.

.. figure:: http://code.osehra.org/content/named/SHA1/138DF2-buildViViaNOnly.png
   :align: center
   :alt:  Set CMake variables in the CMake-GUI to only generate ViViaN


Format Data
-----------

After the data parse scripts have been run successfully, a series of file
manipulation steps are necessary to get all of the generated files into the
correct locations. All of these changes are made in the Visual directory of the
Product-Management (ViViaN) repository.

1. If needed, generate a symbolic link ``files`` pointing to the
   DOCUMENT_VISTA_OUTPUT_DIR specified during configuration.
2. Update ``PackageCategories.json``, ``Packages.csv``,
   ``scripts/PackageDes.json`` if needed.
4. [Optional] Run ``check_him_data.py`` to update ``himData.json``.


Source Code Highlighting
************************

To enable the color highlighting of the M routine source page copy the
``code_pretty_scripts`` directory from the ``VistA/Utilities/Dox/Web`` folder
into the `files/dox` directory.  The folder contains code taken from the
`google_code_prettify`_ repository which is released under the Apache 2.0
license.


ViViaN Setup Script
*******************

Finally, execute the setup script from the ViViaN scripts
(``Product-Management/Visual/scripts``) directory: ``python setup.py`` to
generate other JSON and csv files. The script does not take any input parameters
but requires:

* ``files`` directory created above
* ``PackageCategories.json``, ``Packages.csv``, ``scripts/PackageDes.json`` and
  ``himData.json``.
* A version of the 'VHA Business Function Framework' spreadsheet in the
  ``scripts/`` directory, currently ``BFF_version_2-12.xlsx``
* The xlrd_ package to be installed in the Python environment

The setup script creates the following in the ``files`` directory:
``menu_autocomplete.json``, ``option_autocomplete.json``,
``PackageInterface.csv``, ``packages.json``, ``packages_autocomplete.json``,
``install_autocomplete.json`` and `bff.json`.

The setup script also copies ``himData.json`` to the ``files`` directory.

Review the Results
------------------

To review ViViaN, open the ``index.php`` file from your favorite web browser.

.. figure:: http://code.osehra.org/content/named/SHA1/0F8FA8-localVivian.png
   :align: center
   :alt:  Local ViViaN

To review the DOX pages, open the ``files/dox/index.html`` file from your
favorite web browser.

.. figure:: http://code.osehra.org/content/named/SHA1/60275D-localDox.png
   :align: center
   :alt:  Local copy of Dox pages

.. _WampServer: http://www.wampserver.com/en/
.. _ICR: http://foia-vista.osehra.org/VistA_Integration_Agreement
.. _`Populate M Repository`: ./populateMRepo.rst
.. _`Docker and ViViaN`: ./generateDockerViViaNAndDox.rst
.. _InstallCache: InstallCache.rst
.. _ConfigureCache: ConfigureCache.rst
.. _`Automated VistA Configuration`: AutomatedVistAConfiguration.rst
.. _`M Routine Analyzer`: https://github.com/jasonli2000/rgivistatools/tree/fileman_json
.. _`google_code_prettify`: https://github.com/google/code-prettify
.. _xlrd: https://pypi.python.org/pypi/xlrd
