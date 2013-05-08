Running and Uploading OSEHRA Tests
===================================

.. role:: usertype
    :class: usertype

The configuration process sets up the test environment and prepares the system to perform the test functions. Once configuration is complete the tests are ready to be run.

Testing is run from a command prompt, such as the Terminal in Linux and either the Cygwin Shell , Git Bash Shell, or the Windows command prompt in Windows. From any of these options, changing directory (cd) to the Testing Binary Directory of your test installation and entering \"ctest\" will run every test that has been created. Other ctest options allow or disallow specific tests or groups of tests to be run.
To see usage information for ctest along with the list of available options enter \"ctest --help\".


.. parsed-literal::

  $ :usertype:`ctest -help`
  ctest version 2.8.10.1
  Usage

    ctest [options]

  Options
    -C <cfg>, --build-config <cfg>
                                = Choose configuration to test.
    -V,--verbose                = Enable verbose output from tests.
    -VV,--extra-verbose         = Enable more verbose output from tests.
    --debug                     = Displaying more verbose internals of CTest.
    --output-on-failure         = Output anything outputted by the test program
                                  if the test should fail.  This option can
                                  also be enabled by setting the environment
                                  variable CTEST_OUTPUT_ON_FAILURE
    -F                          = Enable failover.
    -j <jobs>, --parallel <jobs>= Run the tests in parallel using thegiven
                                  number of jobs.
    -Q,--quiet                  = Make ctest quiet.
    -O <file>, --output-log <file>
                                = Output to log file
    -N,--show-only              = Disable actual execution of tests.
    -L <regex>, --label-regex <regex>
                                = Run tests with labels matching regular
                                  expression.
    -R <regex>, --tests-regex <regex>
                                = Run tests matching regular expression.
    .
    .
    .

To display the tests that are currently available without actually performing the tests, enter \"ctest \-.\"

.. parsed-literal::

  $ :usertype:`ctest -N`
  Test project C:/Users/joe.snyder/Work/OSEHRA/VistA-build
    Test   #1: XINDEX_Accounts_Receivable
    Test   #2: XINDEX_Adverse_Reaction_Tracking
    Test   #3: XINDEX_Asists
    Test   #4: XINDEX_Authorization_Subscription
    Test   #5: XINDEX_Auto_Replenishment_Ward_Stock
    Test   #6: XINDEX_Automated_Information_Collection_System
    Test   #7: XINDEX_Automated_Lab_Instruments
    Test   #8: XINDEX_Automated_Medical_Information_Exchange
    Test   #9: XINDEX_Barcode_Medication_Administration
    Test  #10: XINDEX_Beneficiary_Travel
    Test  #11: XINDEX_Capacity_Management\_-_RUM
    Test  #12: XINDEX_Capacity_Management_Tools
    Test  #13: XINDEX_Care_Management
    Test  #14: XINDEX_Clinical_Case_Registries
    Test  #15: XINDEX_Clinical_Information_Resource_Network
    Test  #16: XINDEX_Clinical_Monitoring_System
    Test  #17: XINDEX_Clinical_Procedures
    Test  #18: XINDEX_Clinical_Reminders
    Test  #19: XINDEX_CMOP
    Test  #20: XINDEX_Consult_Request_Tracking
    Test  #21: XINDEX_Controlled_Substances
    Test  #22: XINDEX_CPT_HCPCS_Codes
    Test  #23: XINDEX_Dental
    Test  #24: XINDEX_Dietetics
    Test  #25: XINDEX_DRG_Grouper
    Test  #26: XINDEX_Drug_Accountability
    Test  #27: XINDEX_DSS_Extracts
    Test  #28: XINDEX_E_Claims_Management_Engine
    Test  #29: XINDEX_EEO_Complaint_Tracking
    Test  #30: XINDEX_Electronic_Signature
    Test  #31: XINDEX_Emergency_Department_Integration_Software
    Test  #32: XINDEX_Engineering
    Test  #33: XINDEX_Enrollment_Application_System
    .
    .
    .

Entering the command \"ctest \-R <string>\" allows you to specify a test by regular expression match of the string that is passed along with it.

.. parsed-literal::

  $ :usertype:`ctest -R NDBI`
  Test project C:/Users/joe.snyder/Work/OSEHRA/VistA-build
      Start 76: XINDEX_NDBI
  1/1 Test #76: XINDEX_NDBI ......................***Failed    2.69 sec

  0% tests passed, 1 tests failed out of 1

  Total Test time (real) =   2.89 sec

  The following tests FAILED:
           76 - XINDEX_NDBI (Failed)
  Errors while running CTest

Among the most useful options to ctest is \"\-D.\" The command \"ctest \-D <Configuration>,\" with <Configuration> set to either Experimental, Nightly, or Continuous , will perform the testing and submit the test results to the OSEHRA Dashboard hosted at,

 http://code.osehra.org/CDash/index.php?project=Open+Source+EHR

CTest options can be combined.  The following shows an example of combining the \"-D\"option for test execution and reporting with the \"-R\" option for selectively executing a set of tests.

.. parsed-literal::

  $ :usertype:`ctest -R NDBI -D Experimental`
     Site: PALAVEN.kitware
     Build name: Win32-
  Create new tag: 20121217-2217 - Experimental
  Configure project
     Each . represents 1024 bytes of output
      . Size of output: 0K
  Build project
     Each symbol represents 1024 bytes of output.
     '!' represents an error and '*' a warning.
      . Size of output: 0K
     0 Compiler errors
     0 Compiler warnings
  Test project C:/Users/joe.snyder/Work/OSEHRA/VistA-build
      Start 76: XINDEX_NDBI
  1/1 Test #76: XINDEX_NDBI ......................***Failed    2.69 sec

  0% tests passed, 1 tests failed out of 1

  Total Test time (real) =   2.89 sec

  The following tests FAILED:
           76 - XINDEX_NDBI (Failed)
  Performing coverage
   Cannot find any coverage files. Ignoring Coverage request.
  Submit files (using http)
     Using HTTP submit method
     Drop site:http://code.osehra.org/CDash/submit.php?project=Open+Source+EHR
     Uploaded: C:/Users/joe.snyder/Work/OSEHRA/VistA-build/Test
  ing/20121217-2217/Build.xml
     Uploaded: C:/Users/joe.snyder/Work/OSEHRA/VistA-build/Test
  ing/20121217-2217/Configure.xml
     Uploaded: C:/Users/joe.snyder/Work/OSEHRA/VistA-build/Test
  ing/20121217-2217/Test.xml
     Submission successful
  Errors while running CTest

**Note For Linux Users:**

The GT.M version doesn\'t automatically source the gtmprofile for manual testing. It is recommended that you add lines to the .bashrc file to make sure the environment is set up correctly:

.. parsed-literal::

  source /opt/gtm/gtmprofile
  export gtmgbldir="/home/osehra/Downloads/VistA/database"
  export gtmroutines="/home/osehra/Downloads/VistA/o(/home/osehra/Downloads/VistA/r) ${gtm_dist}


Dashboard Submissions via Scripting
---------------------------------------

Another useful CTest option is "-S" which uses a series of CMake files as scripts to run a dashboard submission.
This option is most useful for Nightly submissions to the dashboard, as it can maintain separate repositories
from your development environment.

**WARNING**

**The use of these scripts will always use the TEST_VISTA_FRESH capability, which will import the code found in the VistA-M repository
into your GT.M or Caché instance.  DO NOT use these files if you have made changes that you do not want to overwrite**

The files are broken up into two parts

 * <machine_name>.cmake
     * A machine specific file that contains the variables and information typically setup during configuration.
 * vista_common.cmake
     * A file that is included by the machine script. It takes the variables set above and creates a CMake cache. It then updates, or clones,
       the needed respositories and then performs a dashboard submission.

The VistA repository has a branch called 'dashboard' that contains the vista_common.cmake file mentioned above.  It also has a template for the machine
specfic script, which can be found in the commented header of the vista_common.cmake file. It is recommended that you clone this branch in a separate repository
which can be done with the following command

.. parsed-literal::

    Downloads$ :usertype:`git clone git://github.com/OSEHRA/VistA.git -b dashboard vista-scripts`

This will clone the 'dashboard' branch into a folder called vista-scripts.

These machine files should contain the same information regarding the same variables that one would set using the CMake GUI or the ccmake program.
A good resource for creating these files can be found at the dashboard, as the two files are uploaded as 'notes' when the submission is sent to the
OSEHRA dashboard.  These notes can be found by utilizing the "Advanced view" toggle in the upper righthand corner of the webpage and clicking on the
icon next to one of the "Nightly Expected" build names that looks like a small sheet of paper.


Once the machine file is fully finished, the process of starting the build mirrors the above dashboard submission.

The text below shows an example command and the beginning of what is printed to the screen:

.. parsed-literal::

  vista-scripts$ :usertype:`ctest -S tuchanka.cmake -VV`
  * Extra verbosity turned on
  Reading Script: C:/Users/joe.snyder/Work/OSEHRA/vista-scripts/tuchanka.cmake
  Dashboard script configuration:
    CTEST_SITE=[TUCHANKA.kitware]
    CTEST_BUILD_NAME=[Win32-Cache]
    CTEST_SOURCE_DIRECTORY=[C:/Users/joe.snyder/Dash/VistA]
    CTEST_BINARY_DIRECTORY=[C:/Users/joe.snyder/Dash/VistA-build]
    CTEST_CMAKE_GENERATOR=[Borland Makefiles]
    CTEST_BUILD_CONFIGURATION=[Debug]
    CTEST_GIT_COMMAND=[C:/Program Files (x86)/Git/bin/git.exe]
    CTEST_CHECKOUT_COMMAND=[]
    CTEST_CONFIGURE_COMMAND=[]
    CTEST_SCRIPT_DIRECTORY=[C:/Users/joe.snyder/Work/OSEHRA/vista-scripts]
    CTEST_USE_LAUNCHERS=[1]
    dashboard_M_dir=[C:/Users/joe.snyder/Dash/VistA-M]


  Clearing build tree...
