The scripts in this directory perform intermediate tasks intended to stand up a
full VistA instance in a fresh Linux installation.

The scripts must be run in the following order


      0) bootstrapREHLserver.sh
      1) installREHLPackages.sh
      2) setupREHLTimeZone.sh
      3) installGTM.sh
      4) installCMakeinUserAccount.sh
      5) installVistAinUserAccount.sh
      6) installVistAFOIARepository.sh
      7) installOSEHRATesting.sh
      8) installMUnit.sh
      9) installBashConfiguration.sh

Once all this environment is setup
a Dashboar build can be triggered by calling:

         runDashboardBuildWithoutMUnit.sh

and once it has created a VistA database, we can
then invoke the one that uses MUnit:

        runDashboardBuildWithMUnit.sh


#
# The following scripts are optional,
# all these tasks are actually performed
# by CMake as part of the set up of the
# testing infrastructure and the process
# of running the Experimental of Nightly
# build.
#
# importingVistAFOIAintoGTM.sh
