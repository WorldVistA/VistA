#Client maintainer: joe.snyder@kitware.com
set(CTEST_SITE "joseph-desktop.kitware")
set(CTEST_BUILD_NAME "Ubuntu10.4-GT.M")
set(dashboard_cache "
GTMPROFILE:PATH=$ENV{GTMPROFILE}
VISTA_GLOBALS_DIR:PATH=$ENV{VISTA_GLOBALS_DIR}
VISTA_ROUTINE_DIR:PATH=$ENV{VISTA_ROUTINES_DIR}
 ")
#Where the files from git will be placed
set(CTEST_DASHBOARD_ROOT /home/joseph/Desktop/Dashboards)

#Path to the Git Executable.
set(CTEST_GIT_COMMAND /usr/bin/git)
include(${CTEST_SCRIPT_DIRECTORY}/../vista_common.cmake)
