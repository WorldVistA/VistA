Running and Uploading OSEHRA Tests
===================================

.. role:: usertype
    :class: usertype

The configuration process sets up the test environment and prepares the system
to perform the test functions. Once configuration is complete the tests are
ready to be run.

Testing is run from a command prompt, such as the Terminal in Linux and either
the Cygwin Shell , Git Bash Shell, or the Windows command prompt in Windows.

From any of these options, changing directory (cd) to the Testing Binary
Directory of your test installation and entering \"ctest\" will run every test
that has been created. Other ctest options allow or disallow specific tests or
groups of tests to be run.

To see usage information for ctest along with the list of available options
enter `ctest --help`.


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

To display the tests that are currently available without actually performing
the tests, enter `ctest -N`

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

Entering the command `ctest -R <string>` allows you to specify a test by
regular expression match of the string that is passed along with it.

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

Among the most useful options to ctest is `-D`. The command
`ctest \-D <Configuration>`, with <Configuration> set to
either Experimental, Nightly, or Continuous , will perform
the testing and submit the test results to the OSEHRA Dashboard hosted at:

 http://code.osehra.org/CDash/index.php?project=Open+Source+EHR

CTest options can be combined.  The following shows an example of combining the
`-D` option for test execution and reporting with the `-R` option for
selectively executing a set of tests.

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

The GT.M version doesn\'t automatically source the gtmprofile for manual
testing. It is recommended that you add lines to the .bashrc file to make
sure the environment is set up correctly:

.. parsed-literal::

  source /opt/gtm/gtmprofile
  export gtmgbldir="/home/osehra/Downloads/VistA/database"
  export gtmroutines="/home/osehra/Downloads/VistA/o(/home/osehra/Downloads/VistA/r) ${gtm_dist}

CTest and Code Coverage
-------------------------

When running a "-D" submission, CTest executes a specific series of steps:

.. parsed-literal::

 Start -> Update^ -> Configure -> Build -> Test -> Coverage -> Submit

 ^: Update runs on a "Nightly" dashboard only

By appending one of these steps onto the "Experimental" string used in the
CTest command, we can tell CTest to run only that specific step of the process.
This capability is used to be able to display the coverage in the terminal,
eliminating the need to submit a build to the OSEHRA Dashboard.

To see the other steps that can be executed, run `ctest -D help`:

.. parsed-literal::

  $ :usertype:`ctest -D help`
  CTest -D called with incorrect option: help
  Available options are:
    ctest -D Continuous
    ctest -D Continuous(Start|Update|Configure|Build)
    ctest -D Continuous(Test|Coverage|MemCheck|Submit)
    ctest -D Experimental
    ctest -D Experimental(Start|Update|Configure|Build)
    ctest -D Experimental(Test|Coverage|MemCheck|Submit)
    ctest -D Nightly
    ctest -D Nightly(Start|Update|Configure|Build)
    ctest -D Nightly(Test|Coverage|MemCheck|Submit)
    ctest -D NightlyMemoryCheck


To run the coverage calculation, we will append the string "Coverage" to a
command line invocation of CTest using the "-D" option and an "Experimental"
model, using a command like:

.. parsed-literal::

  ctest -D ExperimentalCoverage

After running any tests, CTest will print some information about the testing
instance, normally used to identify your submission on the Dashboard, then
calculate the coverage result and print out the totals of each category that it
tracks.  CTest maintains the following four metrics:

* Number of lines covered

* Number of lines not covered

* Total number of lines in code

* Percentage of coverage (# of covered lines/total lines)

An example output looks like this:

.. parsed-literal::

  $ :usertype:`ctest -D ExperimentalCoverage`

     Site: PALAVEN
     Build name: Win32-Cache-FOIA-March2014
     Performing coverage

     Accumulating results (each . represents one file):
     ...............................................
             Covered LOC:         1162
       Not covered LOC:     2971
       Total LOC:           4133
       Percentage Coverage: 28.12%

This command does create XML files for more detailed information, which are
usually submitted to and parsed by the Dashboard.  The files can  be found in a
timestamped folder in the Testing directory of the build tree.

The `Coverage.xml` file contains the summary of each routine, while the
CoverageLog files, which are numbered eg, `CoverageLog-0.xml`, contains the
line-by-line results for each routine.  This displays the file, the number of
times each line was executed, and then the line itself.

A `Coverage.xml` example segment:

.. parsed-literal::

        <Coverage>
  <StartDateTime>Apr 24 17:10 Eastern Daylight Time</StartDateTime>
  <StartTime>1398373819</StartTime>
  <File Name="A1AEAU.m" FullPath="./Packages/Patch_Module/Testing/MUnit/A1AEAU.m" Covered="true">
    <LOCTested>0</LOCTested>
    <LOCUnTested>43</LOCUnTested>
    <PercentCoverage>0.00</PercentCoverage>
    <CoverageMetric>0.19</CoverageMetric>
  </File>

A `CoverageLog-0.xml` example segment:

.. parsed-literal::

        <CoverageLog>
  <StartDateTime>Apr 24 17:10 Eastern Daylight Time</StartDateTime>  <StartTime>1398373819</StartTime>
  <File Name="A1AEAU.m" FullPath="./Packages/Patch_Module/Testing/MUnit/A1AEAU.m">
    <Report>
    <Line Number="0" Count="-1">A1AEAU  ; RMO,MJK/ALBANY ; DHCP Problem/Patch File Edits ;24 NOV 87 11:00 am</Line>
    <Line Number="1" Count="-1">  ;;2.4;PATCH MODULE;;Mar 28, 2014;Build 8</Line>
    <Line Number="2" Count="-1">  ;;Version 2.2;PROBLEM/PATCH REPORTING;;12/02/92</Line>
    <Line Number="3" Count="0">  G:$D(^DOPT(&quot;A1AEAU&quot;,6)) A S ^DOPT(&quot;A1AEAU&quot;,0)=&quot;Authorized Users Menu Option^1N^&quot; F I=1:1 S X=$T(@I) Q:X=&quot;&quot;  S ^DOPT(&quot;A1AEAU&quot;,I,0)=$P(X,&quot;;;&quot;,2,99)</Line>
    <Line Number="4" Count="0">  S DIK=&quot;^DOPT(&quot;&quot;A1AEAU&quot;&quot;,&quot; D IXALL^DIK</Line>
    <Line Number="5" Count="0">A  W !! S DIC=&quot;^DOPT(&quot;&quot;A1AEAU&quot;&quot;,&quot;,DIC(0)=&quot;AEQM&quot; D ^DIC Q:Y&lt;0  D @+Y G A</Line>
    <Line Number="6" Count="-1">  ;</Line>
    <Line Number="7" Count="-1">1  ;;Entry/Edit Authorized Users</Line>
    <Line Number="8" Count="0">  S DIC(&quot;S&quot;)=&quot;I $D(^A1AE(11007,+Y,&quot;&quot;PH&quot;&quot;,DUZ,0))&quot; D PKG^A1AEUTL Q:&apos;$D(A1AEPK)  W !!,&quot;Adding Authorized Users to: &quot;,A1AEPKNM,! S DA=A1AEPKIF,DIE=&quot;^A1AE(11007,&quot;,DR=&quot;[A1AE ADD/EDIT USERS]&quot;,DIE(&quot;NO^&quot;)=&quot;&quot; D ^DIE K DIE(&quot;NO^&quot;),DE,DQ,DIE D KEY^A1AEKEY</Line>
    <Line Number="9" Count="0">  Q</Line>

The "Count" parameter is what indicates the amount of times that the line was
executed.  A count that has a value of "-1" indicates that the line should not
be executed and will not count as part of the total number of lines.

Dashboard Submissions via Scripting
---------------------------------------

Another useful CTest option is "-S" which uses a series of CMake files as
scripts to run a dashboard submission. This option is most useful for Nightly
submissions to the dashboard, as it can maintain separate repositories
from your development environment.

**WARNING**

**The use of these scripts will always use the TEST_VISTA_FRESH capability,
which will import the code found in the VistA-M repository into your GT.M or
Caché instance.  DO NOT use these files if you have made changes that you do
not want to overwrite**

The files are broken up into two parts

 * <machine_name>.cmake
     * A machine specific file that contains the variables and information
       typically setup during configuration.
 * vista_common.cmake
     * A file that is included by the machine script. It takes the variables
       set above and creates a CMake cache. It then updates, or clones,
       the needed respositories and then performs a dashboard submission.

The VistA repository has a branch called 'dashboard' that contains the
`vista_common.cmake` file mentioned above.  It also has a template for the
machine specfic script, which can be found in the commented header of the
`vista_common.cmake file`. It is recommended that you clone this branch in
a separate repository
which can be done with the following command

.. parsed-literal::

    Downloads$ :usertype:`git clone git://github.com/OSEHRA/VistA.git -b dashboard vista-scripts`

This will clone the 'dashboard' branch into a folder called vista-scripts.

These machine files should contain the same information regarding the same
variables that one would set using the CMake GUI or the ccmake program. A good
resource for creating these files can be found at the dashboard, as the two
files are uploaded as 'notes' when the submission is sent to the OSEHRA
dashboard.  These notes can be found by utilizing the "Advanced view" toggle
in the upper righthand corner of the webpage and clicking on the icon next to
one of the "Nightly Expected" build names that looks like a small sheet of paper.


Once the machine file is fully finished, the process of starting the build
mirrors the above dashboard submission.

The text below shows an example command and the beginning of what is printed to
the screen:

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
