The scripts in this directory perform intermediate tasks intended to stand up a
full VistA instance in a fresh Linux installation.

The scripts must be run in the following order


      1) bootstrapREHLserver.sh
      2) installREHLPackages.sh
      3) setupREHLTimeZone.sh

if using GTM:

      1) installGTM.sh
      2) GTM/installVistAinUserAccountForGTM.sh
      3) GTM/installBashConfigurationForGTM.sh

if using Cache:

      1) Cache/configureCache.sh
      2) Cache/createCacheUser.sh

continue for any case (GTM or Cache):

      1) installCMakeinUserAccount.sh
      2) installVistAinUserAccount.sh
      3) installVistAFOIARepository.sh
      4) installOSEHRATesting.sh
      5) installMUnit.sh
      6) installBashConfiguration.sh

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
# restoreVistAInstanceFromBackupForGTM.sh
