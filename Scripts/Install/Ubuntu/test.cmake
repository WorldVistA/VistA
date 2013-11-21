# Set the site name with {randomString}.vagrant to identify all vagrant builds
set(CTEST_SITE "$ENV{buildid}.vagrant")

# Hardset buildname with {OS}-{Mversion}_{arch} convention
set(CTEST_BUILD_NAME "Ubuntu12.04-GTM$ENV{gtmver}")

# Set build type to experimental by default
set(dashboard_model "Experimental")

# Build CMakeCache
set(dashboard_CMakeCache "#Path to a program.
CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make
#Value Computed by CMake
CMAKE_PROJECT_NAME:STATIC=VISTA
#Path to a program.
GITCOMMAND:FILEPATH=/usr/bin/git
#git command line client
GIT_EXECUTABLE:FILEPATH=/usr/bin/git
#Path to the grep executable for finding the line number of the
# found errors
GREP_EXECUTABLE:FILEPATH=/bin/grep
#GT.M Distribution Directory
GTM_DIST:PATH=$ENV{gtm_dist}
#Command to build the project
MAKECOMMAND:STRING=/usr/bin/make -i
#Path to a program.
PYTHON_EXECUTABLE:FILEPATH=/usr/bin/python
#Path to scp command, used by CTest for submitting results to
# a Dart server
SCPCOMMAND:FILEPATH=/usr/bin/scp
#Use this option to create and use the OSEHRA Automated Testing
# harness
TEST_VISTA:BOOL=ON
#On Cache, output the coverage report in a summary table
TEST_VISTA_COVERAGE_READABLE:BOOL=ON
#Enables callergraph tests to create output to generate Dox pages.
TEST_VISTA_DOX_CALLERGRAPH:BOOL=OFF
#Overwrite the database file during build phase of testing? To
# remove this option, delete the CMake Cache
TEST_VISTA_FRESH:BOOL=ON
#Command to run in place of the ImportRG refresh.
TEST_VISTA_FRESH_CUSTOM_COMMAND:STRING=\"/bin/bash\" \"/vagrant/GTM/removeVistaInstanceMinimal.sh\" \"-i $ENV{instance}\"
#Use a custom script to refresh the VistA Databases
TEST_VISTA_FRESH_CUSTOM_REFRESH:BOOL=ON
#Timeout in seconds for importing globals
TEST_VISTA_FRESH_GLOBALS_IMPORT_TIMEOUT:STRING=3600
# Path to the GT.M database.dat
TEST_VISTA_FRESH_GTM_GLOBALS_DAT:FILEPATH=$ENV{basedir}/g
#Path to the Routines folder within GT.M
TEST_VISTA_FRESH_GTM_ROUTINE_DIR:PATH=$ENV{basedir}/r
#Use Python to test VistA via roll and scroll
TEST_VISTA_FUNCTIONAL_RAS:BOOL=ON
#Use Python and Sikuli to test Vitals and CPRS
TEST_VISTA_FUNCTIONAL_SIK:BOOL=OFF
#Run Automated Unit Testing
TEST_VISTA_MUNIT:BOOL=OFF
#Prepopulate the database with sample data including users, patients,
# locations, etc. 
TEST_VISTA_SETUP:BOOL=ON
#Install MUNIT KIDS BUILD
TEST_VISTA_SETUP_MUNIT:BOOL=OFF
#Path to the MUNIT KIDS file XT_7-3_81_TESTVER9.KID
TEST_VISTA_SETUP_MUNIT_PATCH_FILE:FILEPATH=TEST_VISTA_SETUP_MUNIT_PATCH_FILE-NOTFOUND
#MUnit Kids build package install name
TEST_VISTA_SETUP_MUNIT_PATCH_NAME:STRING=XT*7.3*81
#Absolute path to the system temp directory.  The default of '@'
# will cause the system to use the working directory of the process
# as the temp directory.  This path has a limit of 50 characters.
#  Avoid Windows paths with a '~' 
TEST_VISTA_SETUP_PRIMARY_HFS_DIRECTORY:PATH=@
#Name to set for the site address when initializing VistA instance.
#  Default is 'DEMO.OSEHRA.ORG'
TEST_VISTA_SETUP_SITE_NAME:STRING=DEMO.OSEHRA.ORG
#GTM  UCI to store VistA
TEST_VISTA_SETUP_UCI_NAME:STRING=PLA
#Volume Set for new Vista Instance
TEST_VISTA_SETUP_VOLUME_SET:STRING=PLA
#Use warnings as a failure condition for XINDEX tests?
TEST_VISTA_XINDEX_WARNINGS_AS_FAILURES:BOOL=OFF
#Run XINDEX Tests
TEST_VISTA_XINDEX:BOOL=OFF
#Server address of the machine that will have the VistA TCP listener
VISTA_TCP_HOST:STRING=127.0.0.1
#Port number of the opened TCP listener.
#VISTA_TCP_PORT:STRING=9210
#Always build testing
BUILD_TESTING:INTERNAL=ON")
#Where the files from git will be placed
set(CTEST_DASHBOARD_ROOT $ENV{HOME}/Dashboard)
# Include the common dashboard script.
include(/usr/local/src/VistA-Dashboard/vista_common.cmake)
