Set up the Testing Environment
===============================

.. role:: usertype
    :class: usertype

To configure the environment for testing, start the cmake-gui.exe. Once it has
started, set the two paths at the top of the window so that the source code
points to the Testing Source Directory from step 1 above. This directory will
point to a directory (folder) containing CMakeLists.txt file. The Binaries path
can go to a folder of your choice, but note that whatever directory is provided
will be the Testing Binary Directory, and after configuration, it will contain
CMake files defining the tests to be run.

.. figure:: http://code.osehra.org/content/named/SHA1/40eae47a-cmakeGUIHighlights.png
   :align: center
   :alt:  Initial cmake-gui page.

Once those are set, click the Configure button. The interface will then ask you
to specify a generator. These are normally used to check for working C and C++
compilers. For VistA testing, the generator does nothing and it therefore not
used. We recommend using the Borland Makefile if on a Windows environment and
the Unix Makefiles in a Linux system. Click finish after the selection is made
to continue the configuration process.

.. figure:: http://code.osehra.org/content/named/SHA1/90296018-cmakeGUIGeneratorSelection.png
   :align: center
   :alt:  Generator selection.

Following generator selection, the interface will produce a highlighted display
with the following entries:


.. figure:: http://code.osehra.org/content/named/SHA1/a7eb8bba-cmakeGUIPostInitConfig.png
   :align: center
   :alt:  Result of first CMake configuration

The entries in the window are the variables which can be set to control the
testing process. Most of the values should be set correctly by the automated
configuration process, but the scripting environment and the location of the
VistA source code may need to be set appropriately. To aid in the configuring,
most variables have a mouse-over tip which explains in greater detail what the
variable should contain.  NOTE: The "Found" messages for each of the programs
will only be displayed on the initial configuration of the system.  To see the
variables at a later date, follow the instructions at the bottom of this page.

The variables found after the first configure are very straight forward.


=====================   ======================================  ======================================
 Variable Name               Value for Testing in Caché              Value for Testing in GT.M
=====================   ======================================  ======================================
BUILD_DELPHI             \"On\" to build CPRS from Source        \"On\" to build CPRS from Source
BUILD_TESTING                            ON                                   ON
TEST_VISTA               \"On\" to use OSEHRA Testing Harness    \"On\" to use OSEHRA Testing Harness
=====================   ======================================  ======================================

Once the options are chosen are set, press \"Configure\" again and a new set of
variables will be shown in the window.

TEST_VISTA Variables
--------------------


Selecting the TEST_VISTA option and re-configuring will present a screen like below:


.. figure:: http://code.osehra.org/content/named/SHA1/23b21cb2-cmakeGUITestVistAConfig.png
   :align: center
   :alt:  After turning the TEST_VISTA option on, and reconfiguring


The following table has a list of some of the important variables to be set
prior to testing and the description of the variable.  These variables are
either used to determine what VistA system is currently installed or are
common to both systems.


========================   ===================================  ==================================
   Variable Name              Value for Testing in Caché            Value for Testing in GT.M
========================   ===================================  ==================================
GIT_EXECUTABLE              Path to Git Executable                Path to Git Executable
PYTHON_EXECUTABLE           Path to Python Executable             Path to Python Executable
CCONTROL_EXECUTABLE         Path to CControl Executable                      N/A
CTERM_EXECUTABLE            Path to CTerm Executable                         N/A
VISTA_CACHE_NAMESPACE       Namespace of VistA routines                      N/A
VISTA_CACHE_INSTANCE        Caché Instance Name                              N/A
VISTA_CACHE_USERNAME        Login Username for Caché                         N/A
                            (if necessary)
VISTA_CACHE_PASSWORD        Login Password for Caché                         N/A
                            (if necessary)
GTM_DIST                             N/A                          Path to GTM distribution Dir
========================   ===================================  ==================================

One thing to note, is that the VISTA_CACHE_PASSWORD is stored and used in plain-text form

To see the value that is set for GIT_EXECUTABLE or PYTHON_EXECUTABLE after
configuration, click on the \"Advanced\" toggle in the CMake GUI.


.. figure:: http://code.osehra.org/content/named/SHA1/39a0d777-cmakeGUIAdvancedcallout.png
    :align: center
    :alt:  CMake GUI with the Advance toggle labeled

This toggle is used to display other variables that have been configured, but
should not require modification to run the testing.  This is where CMake will
place the GIT_EXECUTABLE and PYTHON_EXECUTABLE variables and their found
values.  Example values are shown below:

.. figure:: http://code.osehra.org/content/named/SHA1/81e072fe-cmakeGUIAdvancedcalloutconfig.png
    :align: center
    :alt: Advanced Variables separated from others


There are a large amount of options that are shown after the first
configuration, this document will walk through the options, explain what each
will do, and show variables that will appear after selecting the options.

XINDEX Testing
``````````````

Running XINDEX on the routines in the VistA instance is the default testing in the OSEHRA Harness.

.. figure:: http://code.osehra.org/content/named/SHA1/16276ce0-cmakeGUIXINDEXcallout.png
   :align: center
   :alt:  Highlighted variables that change the XINDEX testing.

The TEST_VISTA_XINDEX option controls the running of the XINDEX tests. Setting
this option to ON runs XINDEX on every routine in every package. Setting this
option to OFF disables XINDEX testing.

The TEST_VISTA_FRESH_M_DIR is not a required variable for setting up the XINDEX
testing. The TEST_VISTA_XINDEX_WARNINGS_AS_FAILURES is an option which changes
the failure condition of the XINDEX tests.  With this option off, the test will
fail if the XINDEX report returns a fatal error, "F -" in the output.  This
option will cause a warning in the output "W -" as a failure condition.

Another non-required option is ``TEST_VISTA_XINDEX_IGNORE_EXCEPTIONS``.  This
option will cause the reporting function to skip the checking of the errors
against the XINDEXExceptions, thus reporting each found error to the test's
result.

The GREP_EXECUTABLE is used to find and print the line position of a returned
error or warning in the source file during the reporting of the error. It can
be found among the advanced variables like PYTHON_EXECTUABLE. The these
variables are set in the following manner:

=======================================   ===================================  ======================================
Variable Name                                 Value for Testing in Caché          Value for Testing in GT.M
=======================================   ===================================  ======================================
TEST_VISTA_XINDEX                                    ON/OFF                                  ON/OFF
TEST_VISTA_XINDEX_WARNINGS_AS_FAILURES               ON/OFF                                  ON/OFF
TEST_VISTA_XINDEX_IGNORE_EXCEPTIONS                  ON/OFF                                  ON/OFF
TEST_VISTA_OUTPUT_DIR                       Path to folder where log files        Path to folder where log files
                                            will be stored                        will be stored
GREP_EXECUTABLE                             Path to Grep Executable               Path to Grep Executable
=======================================   ===================================  ======================================

TEST_VISTA_COVERAGE
```````````````````

**This capability is only available on systems that have a CMake version that
is 2.8.9 or higher.  This option will not show up with earlier versions of CMake.**

The TEST_VISTA_COVERAGE option is used to enable a coverage calculation using
the OSEHRA tests.  It keeps track of the lines of code that are executed during
the tests and writes files that can be parsed by the testing software and
displayed on the dashboard after submission.  The coverage is available for
three types of OSEHRA Testing: XINDEX, MUnit, and the Roll-and-Scroll (RAS)
tests.  The RAS tests currently execute coverage automatically, while the other
types require the setting of a CMake option to start capturing information
about the coverage of the test.


.. figure:: http://code.osehra.org/content/named/SHA1/033ec97b-cmakeGUICoveragecallout.png
   :align: center
   :alt:  Highlighting the TEST_VISTA_COVERAGE option.

There are two options which affect the OSEHRA Coverage capability.
To turn on the coverage for the other types of testing, one should set the
``TEST_VISTA_COVERAGE`` option to be ON.

The second option to set is named ``TEST_VISTA_COVERAGE_READABLE``.
It is set to ON by default and appears when the RAS tests have been selected.
The format of output found in the coverage log file for the RAS tests depends
on the value of ``TEST_VISTA_COVERAGE_READABLE``.  If set to ON, it will
write out a human-readable coverage format.  If the option is turned to OFF,
it will write out a comma separated (CSV) formatted file.

In order to use the CTest parsing of the coverage files for an OSEHRA dashboard
submission, it is necessary to turn the ``TEST_VISTA_COVERAGE_READABLE`` option
to OFF. Only when it is set to OFF will this option create files in the
top-level of the binary directory with the extension of .mcov (GT.M M Coverage)
or .cmcov (Caché M coverage), which both triggers and contains the information
needed by the CTest coverage parsing.

========================================   ===================================  ======================================
Variable Name                                  Human-readable Coverage                    CTest-parsed Coverage
========================================   ===================================  ======================================
TEST_VISTA_COVERAGE                                       ON                                     ON
TEST_VISTA_COVERAGE_READABLE (RAS only)                   ON                                     OFF
========================================   ===================================  ======================================

Advanced Coverage Variables
'''''''''''''''''''''''''''

There is one additional variable which can be set when using the OSEHRA
coverage functionality. ``TEST_VISTA_COVERAGE_SUBSET_DIR``, which can be found
in the "advanced" section of available CMake variables, allows the focus of the
coverage calculations to be narrowed.

When this variable is set with the value of a path to a folder which contains
any number of routine files (``*******.m``), CTest will search (recusively)
through the directory for all .m files.  These found files will be the only
routines that are used in the coverage calcuations.  If this variable is not
used, CTest will calculate coverage over the entirety of the VistA-M routine
content.

This functionality is especially helpful when calculating the coverage level of
a project that is going through the OSEHRA Certification process.

=======================================   ===================================  ======================================
Variable Name                                 Human Readable Coverage                    CTest-parsed Coverage
=======================================   ===================================  ======================================
TEST_VISTA_COVERAGE_SUBSET_DIR               Path to folder with .m files            Path to folder with .m files
=======================================   ===================================  ======================================

CMake Warnings during Configuration
'''''''''''''''''''''''''''''''''''

When the ``TEST_VISTA_COVERAGE`` option has been selected, CMake will show some
warnings during the configure step.  These messages are in place to warn
that the tests may take longer and will create other output files in addition
to the standard test log files.

Finally, there is a separate warning that is specific to Caché environments, it
warns that an Advanced Memory variable may need to be changed in order for the
monitor to be started.  It gives the variable to change and how to test it.
GT.M users of ``TEST_VISTA_COVERAGE`` will only see the timing warning during
the configure step.

.. figure:: http://code.osehra.org/content/named/SHA1/32e5ac54-cmakeGUICoverageWarnings.png
   :align: center
   :alt:  After selecting the TEST_VISTA_COVERAGE options, warnings are displayed
          in the output with the Caché specific warning.

TEST_VISTA_FRESH and TEST_VISTA_SETUP
``````````````````````````````````````

The TEST_VISTA_FRESH option will show up during configuration of the VistA
Testing.  When this option is selected, a series of Python scripts will be
configured to clean the database of the VistA instance. These scripts would be
executed during the build phase of a nightly dashboard submission.

The TEST_VISTA_SETUP option can be used to configure the VistA instance and
set up a fictional environment within VistA with fake patients, doctors and
nurses, and a simple clinic. This information is required to be there for the
functional tests to complete successfully.

.. figure:: http://code.osehra.org/content/named/SHA1/6b856178-cmakeGUIFreshcallout.png
   :align: center
   :alt:  The CMake-GUI with the TEST_VISTA_FRESH option highlighted.


To utilize this option on Caché, the TEST_VISTA_FRESH checkbox must be checked
to tell CMake to configure the correct files. You will also need to create a
new (empty) cache.dat and set the TEST_VISTA_FRESH_CACHE_DAT_EMPTY to point to
the location of that newly created cache.dat.  It will then shut down the Caché
instance, copy the empty database in place of the old one, restart Caché, then
collect and import the OSEHRA routines and globals.

**For more help with the generation of the empty cache.dat file:**

See the instructions found in the ``Configuring Caché`` section of the
`Install Caché`_ document.

.. figure:: http://code.osehra.org/content/named/SHA1/974956f3-cmakeGUIFreshcalloutconfigureCache.png
   :align: center
   :alt: The CMake-GUI on Windows/Caché after configuration.

For GT.M, the overall process is the same, but has some internal actions that
make it GT.M specific.  Instead of a the Caché variables, we ask for the
TEST_VISTA_FRESH_GTM_GLOBALS_DAT and the TEST_VISTA_FRESH_GTM_ROUTINE_DIR.
The TEST_VISTA_FRESH_GTM_GLOBALS_DAT is the path to the database.dat that
contains the VistA globals.  This file will be deleted and recreated
automatically via the 'mupip' command.  The  TEST_VISTA_FRESH_GTM_ROUTINE_DIR
is the path to the folder that contains the VistA routines.  This folder will
be removed and recreated so that all routines within the GT.M instance will be
from the latest import.  The other GT.M specific variable is the
TEST_VISTA_SETUP_UCI_NAME which is used during the configuring of the VistA
instance.

.. figure:: http://code.osehra.org/content/named/SHA1/f90b6a3d-cmakeGUIFreshcalloutconfigureGTM.png
   :align: center
   :alt: The CMake-GUI on Linux/GTM after configuration.


If you plan to use these options, there are more variables that need to be set:

========================================   ==========================================   =======================================
   Variable Name                             Value for Testing in Caché                    Value for Testing in GT.M
========================================   ==========================================   =======================================
TEST_VISTA_SETUP_PRIMARY_HFS_DIRECTORY       Path to temporary directory                 Path to temporary directory
                                             (@ will use process directory)              (@ will use process directory)
TEST_VISTA_SETUP_SITE_NAME                   Name for VistA site                         Name for VistA site
TEST_VISTA_SETUP_VOLUME_SET                  Volume set of Instance                      Volume set of VistA instance
TEST_VISTA_GLOBAL_IMPORT_TIMEOUT             Length of Timeout for Global Import         Length of Timeout for Global Import
TEST_VISTA_FRESH                                         ON                                        ON
TEST_VISTA_FRESH_M_DIR                       Path to VistA-M directory                   Path to VistA-M directory
                                             (or similar repository)                     (or similar repository)
TEST_VISTA_FRESH_CACHE_DAT_EMPTY             Path to an empty CACHE.dat                            N/A
TEST_VISTA_FRESH_CACHE_DAT_VISTA           Path to CACHE.dat that holds VistA                      N/A
TEST_VISTA_FRESH_GTM_GLOBALS_DAT                          N/A                           Path to the database.dat with VistA
TEST_VISTA_FRESH_GTM_ROUTINE_DIR                          N/A                           Path to folder that contains VistA
                                                                                        routines
TEST_VISTA_SETUP_UCI_NAME                                 N/A                           UCI name of VistA isntance
========================================   ==========================================   =======================================


TEST_VISTA_FUNCTIONAL_SIK
`````````````````````````

The OSEHRA Testing harness also the ability to use an open-source tool called
Sikuli to test the CPRS and Vitals Manager interface.  Sikuli is a
cross-platform GUI testing system which uses OpenCV and Jython, a combination
of Java and Python, to match a script of supplied screenshots and act upon
them.  Due to the limitations of CPRS, this tool will only be utilzed on
Windows environments.  When Sikuli test starts, it will look to click on icons
on the user's desktop to start both programs.  The scripts also cause VistA to
expect to interact with certain versions of each of the software.  Those
versions are available for download from the `OSEHRA website`_.  The
instructions for setting up the short cuts are also on that website.

When running the CMake GUI, the option to use the CPRS Functional Testing is
called TEST_VISTA_FUNCTIONAL_SIK

.. figure:: http://code.osehra.org/content/named/SHA1/2e0fece6-cmakeGUIFunctionalSIKcallout.png
    :align: center
    :alt: Showing the TEST_VISTA_FUNCTIONAL_SIK option in the CMake-GUI

After pressing configure you can see some new variables come up on Windows.
Since the CPRS executable can only be run within a Windows environment, this
option will do nothing on a Linux/GTM or Linux/Caché environment.

.. figure:: http://code.osehra.org/content/named/SHA1/6bce6bd0-cmakeGUIFunctionalSIKcalloutconfigure.png
    :align: center
    :alt: Showing the variables needed for the TEST_VISTA_FUNCTIONAL_SIK.

Those variables ask for path to the two GUIs that were either downloaded from
the above link or already on the system.

=======================================   ========================================
Variable Name                              Value for Testing in Windows/Caché
=======================================   ========================================
CPRS_EXECUTABLE                            Path to the CPRSChart.exe
VITALS_MANAGER_EXECUTABLE                  Path to the VitalsManager.exe
=======================================   ========================================


TEST_VISTA_FUNCTIONAL_RAS
`````````````````````````

The VistA repository also has the capability to test the local VistA instance
through the Roll and Scroll (RAS) menu interface.

.. figure:: http://code.osehra.org/content/named/SHA1/315f8402-cmakeGUIFunctionalRAScallout.png
    :align: center
    :alt: Showing the TEST_VISTA_FUNCTIONAL_RAS option in the CMake GUI.

The number of test suites that utilize the RAS functionality: look for a
\"Testing/RAS\" directory in the package directory to see the tests that will
run.  This option does not require any other variables to be set.

**Note**: The RAS tests will run and save the coverage results to a local file
each time the test is run.

TEST_VISTA_MUNIT
`````````````````
The OSEHRA Testing harness also contains the capability to run unit tests on
the M[umps] code.  It utilizes a framework developed by Joel Ivey called MUnit,
which is part of the M-Tools_ package. There is no explicit option to show the
MUnit variables in CMake, they will show in the first configure after selecting
the TEST_VISTA option.

.. figure:: http://code.osehra.org/content/named/SHA1/3e177b9a-cmakeGUIMunitcallout.png
    :align: center
    :alt: Highlighting the MUnit options that appear after selecting TEST_VISTA

There is just one CMake variable that relates to the Automated MUnit testing.
The option, TEST_VISTA_MUNIT, determines if the MUnit tests are added to the
CTest test list.

========================================   ==========================================   =======================================
Variable Name                              Value for Testing in Caché                   Value for Testing in GT.M
========================================   ==========================================   =======================================
TEST_VISTA_MUNIT                                            ON                                           ON
========================================   ==========================================   =======================================

EXAMPLE TESTING SETUP
---------------------

After some number of rounds of configuration, no new variables will appear
after a configuration step.  Once this happens, the \"Generate\" button can be
pressed, and the tests will be generated.

The following figure is an example of a fully configured testing environment,
ready for the \"Generate\" step.

.. figure:: http://code.osehra.org/content/named/SHA1/a363cdbc-cmakeGUIFullEnvironment.png
    :align: center
    :alt: A fully configured instance of the OSEHRA harness.

The \"Generate\" will only add a single line to the output window saying

.. parsed-literal::

   Generating done.

This lets you know that the tests are ready to be run from the command line.

.. _`OSEHRA website`: http://www.osehra.org/document/guis-used-automatic-functional-testing
.. _M-Tools: https://github.com/OSEHRA-Sandbox/M-Tools/
.. _`Install Caché`: installCache.rst
