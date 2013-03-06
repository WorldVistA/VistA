Set up the Testing Environment
===============================

.. role:: usertype
    :class: usertype

To configure the environment for testing, start the cmake-gui.exe. Once it has started, set the two paths at the top of the window so that the source code points to the Testing Source Directory from step 1 above.
This directory will point to a directory (folder) containing CMakeLists.txt file. The Binaries path can go to a folder of your choice,
but note that whatever directory is provided will be the Testing Binary Directory, and after configuration, it will contain CMake files defining the tests to be run.

.. figure:: http://code.osehra.org/content/named/SHA1/40eae47a-cmakeGUIHighlights.png
   :align: center
   :alt:  Initial cmake-gui page.

Once those are set, click the Configure button. The interface will then ask you to specify a generator. These are normally used to check for working C and C++ compilers.
For VistA testing, the generator does nothing and it therefore not used. We recommend using the Borland Makefile if on a Windows environment and the Unix Makefiles in a Linux system. Click finish after the selection is made to continue the configuration process.

.. figure:: http://code.osehra.org/content/named/SHA1/24c3b506-cmakeGUIWinGeneratorSelection.png
   :align: center
   :alt:  Generator selection.

Following generator selection, the interface will produce a highlighted display such as for Linux:


.. figure:: http://code.osehra.org/content/named/SHA1/7433a9bf-cmakeGUILinuxPostConfig.png
   :align: center
   :alt:  Linux interface after generator selection is complete.

and for Windows:

.. figure:: http://code.osehra.org/content/named/SHA1/f943a02c-cmakeGUIWinPostConfig.png
   :align: center
   :alt:  Windows interface after generator selection is complete.

The entries in the window are the variables which can be set to control the testing process. Most of the values should be set correctly by the automated configuration process, but the
scripting environment and the location of the VistA source code may need to be set appropriately. To aid in the configuring, most variables have a mouse-over tip which explains in greater
detail what the variable should contain.  NOTE: The "Found" messages for each of the programs will only be displayed on the initial configuration of the system.  To see the variables at a
later date, follow the instructions at the bottom of this page.

The variables found after the first configure are very straight forward.

     =====================   ======================================  ======================================
      Variable Name               Value for Testing in Caché              Value for Testing in GT.M
     =====================   ======================================  ======================================
       BUILD_DELPHI            \"On\" to build CPRS from Source       \"On\" to build CPRS from Source
       BUILD_TESTING                            ON                                   ON
       TEST_VISTA             \"On\" to use OSEHRA Testing Harness   \"On\" to use OSEHRA Testing Harness
     =====================   ======================================  ======================================

Once the options are chosen are set, press \"Configure\" again and a new set of variables will be shown in the window.

TEST_VISTA Variables
--------------------


Selecting the TEST_VISTA option and re-configuring will present a screen like below:


.. figure:: http://code.osehra.org/content/named/SHA1/2e0050ac-cmakeGUITestVistAConfig.png
   :align: center
   :alt:  After turning the TEST_VISTA option on, and reconfiguring


The following table has a list of some of the important variables to be set prior to testing and the description of the variable.  These variables are either used to determine what VistA system is currently installed or are common to both systems.


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
                                  (if neccesary)
      GTM_DIST                             N/A                        Path to GTM distribution Dir
     ========================   ===================================  ==================================

One thing to note, is that the VISTA_CACHE_PASSWORD is stored and used in plain-text form

To see the value that is set for GIT_EXECUTABLE or PYTHON_EXECUTABLE after configuration, click on the \"Advanced\" toggle in the CMake GUI.


.. figure:: http://code.osehra.org/content/named/SHA1/99c54e3d-cmakeGUIAdvancedHighlight.png
    :align: center
    :alt:  CMake GUI with the Advance toggle labeled

This toggle is used to display other variables that have been configured, but should not require modification to run the testing.  This is where CMake will place
the GIT_EXECUTABLE and PYTHON_EXECUTABLE variables and their found values.  Example values are shown below:

.. figure:: http://code.osehra.org/content/named/SHA1/4e86850b-cmakeGUIAdvancedGitHighlight.png
    :align: center
    :alt: Advanced variables with GIT_EXECUTABLE highlighted

.. figure:: http://code.osehra.org/content/named/SHA1/7617227f-cmakeGUIAdvancedPythonHighlight.png
    :align: center
    :alt: Advanced Variables with PYTHON_EXECUTABLE highlighted


There are a large amount of options that are shown after the first configuration, this document will walk through the options, explain what each will do, and show variables that will appear
after selecting the options.

XINDEX Testing
``````````````

Running XINDEX on the routines in the VistA instance is the default testing in the OSEHRA Harness.  It does not have an explicit option but does have a few variables that influence
the testing procedure.

.. figure:: http://code.osehra.org/content/named/SHA1/27b575fd-cmakeGUIXINDEXHighlights.png
   :align: center
   :alt:  Highlighted variables that change the XINDEX testing.

The TEST_VISTA_FRESH_M_DIR is the path to the directory with OSEHRA M repository checkout.  This repository is parsed to determine the Packages and routines to test.
The TEST_VISTA_XINDEX_WARNINGS_AS_FAILURES is an option which changes the failure condition of the XINDEX tests.  With this option off, the test will fail if the XINDEX report
returns a fatal error, "F -" in the output.  This option will cause a warning in the output "W -" as a failure condition.  The GREP_EXECUTABLE is used to find and print
the line position of a returned error or warning in the source file during the reporting of the error. It can be found among the advanced variables like PYTHON_EXECTUABLE.
The these variables are set in the following manner:

     =======================================   ===================================  ======================================
      Variable Name                                 Value for Testing in Caché          Value for Testing in GT.M
     =======================================   ===================================  ======================================
     TEST_VISTA_FRESH_M_DIR                      Path to OSEHRA M repository           Path to OSEHRA M repository
     TEST_VISTA_XINDEX_WARNINGS_AS_FAILURES               ON/OFF                                  ON/OFF
     TEST_VISTA_OUTPUT_DIR                       Path to folder where log files        Path to folder where log files
                                                 will be stored                        will be stored
     GREP_EXECUTABLE                             Path to Grep Executable               Path to GREP Executable
     =======================================   ===================================  ======================================



TEST_VISTA_COVERAGE
```````````````````

**This capability is only available on systems that have a CMake version that is 2.8.9 or higher.  This option will not show up with earlier versions of CMake.**

The TEST_VISTA_COVERAGE option is used to enable a coverage calculation using the OSEHRA tests.  It keeps track of the lines of code that are executed during the tests and writes files
that can be parsed by the testing sofware and displayed on the dashboard after submission.  The coverage is available for three types of OSEHRA Testing: XINDEX, MUnit, and the
Roll-and-Scroll (RAS) tests.


.. figure:: http://code.osehra.org/content/named/SHA1/50006d42-cmakeGUICoverageHighlight.png
   :align: center
   :alt:  Highlighting the TEST_VISTA_COVERAGE option.

While there are no more variables to set after selecting the TEST_VISTA_COVERAGE option, it does display warnings during the configuration.  These messages warn that the tests will take longer
and will create other files in addition to the standard log files.  There is a warning that is specific to Caché environments, it warns that an Advanced Memory variable may need to be changed
have the monitor be used.  It give the variable to change and how to test it.  The GT.M users will only see the timing warning.

.. figure:: http://code.osehra.org/content/named/SHA1/f12fcd48-cmakeGUICoverageWarnings.png
   :align: center
   :alt:  After selecting the TEST_VISTA_COVERAGE options, warnings are displayed in the output with the Caché specific warning.

This option will create files in the binary directory with the extension of .mcov (GT.M M Coverage) or .cmcov (Caché M coverage).




TEST_VISTA_FRESH and TEST_VISTA_SETUP
``````````````````````````````````````

There is an option that is not needed to run the testing but may become useful. The TEST_VISTA_FRESH option will show up during configuration of the VistA Testing.  It uses a series of
Python scripts to clean the database of the VistA instance.   This would all be done during the build phase of a nightly dashboard submission.

This combination can also configure the VistA instance and set up a fictional environment within VistA with fake patients, doctors and nurses, and a simple clinic.
This information is required to be there for the functional tests to complete successfully.

.. figure:: http://code.osehra.org/content/named/SHA1/819c659c-cmakeGUIFreshHighlight.png
   :align: center
   :alt:  The CMake-GUI with the TEST_VISTA_FRESH option highlighted.


To utilize this option on Caché, the TEST_VISTA_FRESH checkbox must be checked to tell CMake to configure the correct files. You will also need to create a new cache.dat using the steps
from earlier and set the TEST_VISTA_FRESH_CACHE_DAT_EMPTY to point to the location of that newly created cache.dat.  It will then shut down the Caché instance,
copy the empty database in place of the old one, restart Caché, then collect and import the OSEHRA routines and globals.


.. figure:: http://code.osehra.org/content/named/SHA1/40410f24-cmakeGUIFreshWinConfigure.png
   :align: center
   :alt: The CMake-GUI on Windows/Caché after configuration.

For GT.M, the overall process is the same, but has some internal actions that make it GT.M specific.  Instead of a the Caché variables, we ask for the TEST_VISTA_FRESH_GTM_GLOBALS_DAT and
the TEST_VISTA_FRESH_GTM_ROUTINE_DIR.  The TEST_VISTA_FRESH_GTM_GLOBALS_DAT is the path to the database.dat that contains the VistA globals.  This file will be deleted and recreated
automatically via the 'MUPIP' command.  The  TEST_VISTA_FRESH_GTM_ROUTINE_DIR is the path to the folder that contains the VistA routines.  This folder will be removed and recreated so that all routines within the GT.M instance will be from the latest import.  The other GT.M specific variable is the TEST_VISTA_SETUP_UCI_NAME which is used during the configuring of the VistA instance.

.. figure:: http://code.osehra.org/content/named/SHA1/93943892-cmakeGUIFreshLinuxConfigure.png
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
      TEST_VISTA_FRESH_CACHE_DAT_EMPTY             Path to an empty CACHE.dat                            N/A
      TEST_VISTA_FRESH_CACHE_DAT_VISTA           Path to CACHE.dat that holds VistA                      N/A
      TEST_VISTA_FRESH_GTM_GLOBALS_DAT                          N/A                           Path to the database.dat with VistA
      TEST_VISTA_FRESH_GTM_ROUTINE_DIR                          N/A                           Path to folder that contains VistA
                                                                                              routines
      TEST_VISTA_SETUP_UCI_NAME                                 N/A                           UCI name of VistA isntance
     ========================================   ==========================================   =======================================


TEST_VISTA_FUNCTIONAL_SIK
`````````````````````````

The OSEHRA Testing harness also the ability to use an open-source tool called Sikuli to test the CPRS and Vitals Manager interface.  Sikuli is a cross-platform GUI testing system which uses
OpenCV and Jython, a combination of Java and Python, to match a script of supplied screenshots and act upon them.  Due to the limitations of CPRS, this tool will only be utilzed on Windows
environments.  If the
the Sikuli test starts and will look to click on icon s on the user's desktop to start both programs.  The scripts also cause VistA to expect to interact with certain versions of each of
the software.  Those versions are available for download from the `OSEHRA website`_.  The instructions for setting up the short cuts are also on that website.

When running the CMake GUI, the option to use the CPRS Functional Testing is called TEST_VISTA_FUNCTIONAL_SIK

.. figure:: http://code.osehra.org/content/named/SHA1/eda76241-cmakeGUIFunctionalSIK.png
    :align: center
    :alt: Showing the TEST_VISTA_FUNCTIONAL_SIK option in the CMake-GUI

After Pressing configure you can see some new variables come up on Windows. Since the CPRS executable can only be run within a Windows environment, this option will do nothing on a Linux/GTM
or Linux/Caché environment.

.. figure:: http://code.osehra.org/content/named/SHA1/231d5fdd-cmakeGUIFunctionalSIKConfigure.png
    :align: center
    :alt: Showing the variables needed for the TEST_VISTA_FUNCTIONAL_SIK.


Those variables ask for path to the two GUIs that were either downloaded from the above line or already on the system.

     =======================================   ========================================
      Variable Name                              Value for Testing in Windows/Caché
     =======================================   ========================================
      CPRS_EXECUTABLE                           Path to the CPRSChart.exe
      VITALS_MANAGER_EXECUTABLE                 Path to the VitalsManager.exe
     =======================================   ========================================


TEST_VISTA_FUNCTIONAL_RAS
`````````````````````````

The VistA repository also has the capability to test the local VistA instance through the Roll and Scroll (RAS) menu interface.

.. figure:: http://code.osehra.org/content/named/SHA1/76b362b2-cmakeGUIFunctionalRAS.png
    :align: center
    :alt: Showing the TEST_VISTA_FUNCTIONAL_RAS option in the CMake GUI.

There are currently two test suites that utilize the RAS functionality:  Scheduling and Problem List.  This option does not require any other
variables to be set.


EXAMPLE TESTING SETUP
---------------------

After some number of rounds of configuration, no new variables will appear after a configuration step.  Once this happens, the \"Generate\" button can be pressed,
and the tests will be generated.

The following figure is an example of a fully configured testing environment, ready for the \"Generate\" step.

.. figure:: http://code.osehra.org/content/named/SHA1/3690a391-cmakeGUIFullEnvironment.png
    :align: center
    :alt: A fully configured instance of the OSEHRA harness.

The \"Generate\" will only add a single line to the output window saying

.. parsed-literal::

   Generating done.

This lets you know that the tests are ready to be run from the command line.
