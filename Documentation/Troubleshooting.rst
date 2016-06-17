Troubleshooting of Installation and Testing
=============================================


This page is for the aggregation of issues that have been experienced during
the setup and testing of the OSEHRA Code Base.  Check here first for solutions
to the problems that you are encountering.  If you cannot find a solution,
leave a comment with the details of your issue or create an issue on the JIRA
site found at http://issues.osehra.org/

1. I get a "GVSUBOFLOW" error while importing the Globals into the GT.M instance.
----------------------------------------------------------------------------------

The max size of a string is set during the creation of the database.dat in the
last step of the `Installing GT.M`_ process.  It is set via the argument:::

  -key_max=1023

To eliminate the overrun error: run the ``dse change`` command from within the
directory that contains the database.dat, but increase the ``-key_max`` value
to a larger number:

.. parsed-literal::

  dse change -f -key_max=2046 -rec=4096

2.  Errors appear during configuration of VistA on GT.M
--------------------------------------------------------

During the configuration of GT.M, developers have reported errors appearing
while the routines are being renamed for the system. This error occurs when
GT.M attempts to compile code that was not intended to run on the system.
These errors are to be expected and **will not** have a negative effect on
the running of the system.

A JIRA bug report has been filed which can be found in the
`OSEHRA JIRA instance`_ .

Example of Errors:

.. parsed-literal::

  I will now rename a group of routines specific to your operating system.
  > Routine:  ZOSVGUX Loaded, Saved as    %ZOSV
  >      . S (%,%1)=$ZGETDVI($I,"TT_ACCPORNAM")
  >                  ^-----
  >         At column 14, line 48, source module
  > /home/karthik/Downloads/VistA/r/ZIS4GTM.m
  > %GTM-E-FNOTONSYS, Function or special variable is not supported by this
  > operating system
  >
  > Routine:  ZIS4GTM Loaded, Saved as    %ZIS4
  > Routine:  ZISFGTM Loaded, Saved as    %ZISF
  > Routine:  ZISHGTM Loaded, Saved as    %ZISH
  > Routine:  XUCIGTM Loaded, Saved as    %XUCI
  > Routine: ZOSV2GTM Loaded, Saved as   %ZOSV2     O
  > NIO:(:SOCK:"AT"::512:512:10):30 Q:'$T  S POP=0 U NIO
  >             ^-----
  >         At column 9, line 25, source module
  > /home/karthik/Downloads/VistA/r/ZISTCPS.m
  > %GTM-E-DEVPARUNK, Deviceparameter unknown ...

3. M-Unit 1.3 reports error during installation
------------------------------------------------

The OSEHRA M-Unit tests check for and attempt to install a version of the
M-Unit Test software before each test is run. If the test reports an error
during the installation process, information will be displayed in the test run
but the best information will be found in the ``UnitTest/Log/`` within the
binary directory of the testing framework.  The ``VistAInteraction*`` files
in that directory contain the roll-and-scroll interactions and will display
any errors sent by the system.  Some known errors are found below:

a. ERROR #5002: Cache error: <UNDEFINED>zCreate+13^Config.CommonMapMethods.1 \*Properties
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

**Cache Only**
This is a known error which affects the M-Unit 1.3 release on more recent
Cache instances.  This error occurs when the framework attempts to generate a
set of routine and global mappings for the ``%ut*`` namespace.  To eliminate
this error, use the ``System Management Portal`` to configure a routine and
global mapping for the ``%ut*``.  Examples of generating the routine and global
mapping can be found in the `Install Cache`_ set of instructions.

After the mappings have been generated, run the test again and the KIDs patch
should install and the testing continue.



To request an update to this document, generate an issue in the OSEHRA JIRA
instance for the `OSEHRA Automated Testing`_ project.

.. _`OSEHRA JIRA instance`: http://issues.osehra.org/browse/VAF-2
.. _`OSEHRA Automated Testing`: http://issues.osehra.org/projects/OAT
.. _`Installing GT.M`:  InstallGTM.rst
.. _`Install Cache`:    InstallCache.rst
