Retrieving the code from Git and Importing into GT.M
=====================================================

.. role:: usertype
    :class: usertype

To acquire the VistA-M source tree, follow the instructions in
ObtainingVistAMCode_.  To prepare the M components for import into the VistA
instance, follow the steps found in the PrepareMComponents_ document.

.. _PrepareMComponents: PrepareMComponents.rst

Import the Routines
-------------------
Importing the routines is done using the MUMPS routine named %RI. This is the
MUMPS standard routine to import routines from a .RO file like what was created
when the Python scripts were run. To start the GT.M instance in the terminal,
simply enter the command:  ``mumps -dir``.

**Note**: If ``mumps`` isn't found when the command is run,  look for the
environment variable called ``gtm_dist``. The executable will be found in that
directory.


.. parsed-literal::

  ~/Downloads$ :usertype:`mumps -dir`

  GTM>


When the ``GTM>`` prompt is there, you are in the GT.M environment and can
execute the %RI routine using the command D ^%RI.


.. parsed-literal::

  GTM> :usertype:`D ^%RI`

  Routine Input Utility - Converts RO files to \*.m files.

  Formfeed delimited <No>?


The routines.ro file that was created earlier is not formfeed delimited, so the
default option for the first prompt is the correct one to choose. When the
prompt asks for an ``Input Device``, enter the path to the routines.ro that was
created in the earlier step. Our path to the routines.ro is shown entered below.


.. parsed-literal::

  Formfeed delimited <No>? :usertype:`<ENTER>`
  Input Device: <terminal>: :usertype:`/home/osehra/Downloads/VistA/routines.ro`

  Routines



  Output directory:

This brings the prompt asking for the output directory. The path entered here
should point to the r folder that was used to set the gtmroutines environment
variable in the previous step.   In our case, the directory was:::

  /home/osehra/Downloads/VistA/r/

This is the location where the %RI routine will store the routines that it
imports from routines.ro.

The ``Output directory`` must include the "r" subdirectory string and must
finish with a slash "/". After entering the path, the names of the routines
that are imported are shown on the terminal window as they are processed. When
the routine is finished, it will display the amount of lines restored and the
number of routines processed, then show the GT.M prompt.


.. parsed-literal::
  Output directory:  :usertype:`/home/osehra/Downloads/VistA/r/`

  PRCA219P  PRCAACC   PRCAAPI   PRCAAPR   PRCAAPR1  PRCAATR   PRCABD    PRCABIL
  PRCABIL1  PRCABIL2  PRCABIL3  PRCABIL4  PRCABJ    PRCABJ1   PRCABJV   PRCABP1
  .
  .
  .
  WVYNOTP   WIIACT4   WIIADT1   WIIELG    WIIGATD   WIILM     WIILM01   WIILM02
  WIILM03   WIILM04   WIISERV

  Restored 2349289 lines in 26037 routines

Once the import process finishes, you can verify if it was succesful by
visiting the "Output directory" from a terminal and using the "ls" command.
This command should show  a large collection of ``*.m`` files that were created
during the import process.

If you expect to use this testing beyond the XINDEX capacity, there is another
.ro file that you should import.  It is found in the Testing/Setup directory
called \"ZTLOAD1.ro\". It contains a new copy of the ZTLOAD1.m file which
contains modifications that remove some transaction processing code that fails
only on the GT.M platform.

.. parsed-literal::

  Formfeed delimited <No>? :usertype:`<ENTER>`
  Input Device: <terminal>: :usertype:`/home/osehra/Downloads/VistA/Testing/Setup/ZTLOAD1.ro`

  Routines

  Output directory:  :usertype:`/home/osehra/Downloads/VistA/r/`

  ZTLOAD1

  Restored ...

The next step is to use the newly imported ZGI routine to import the VistA
globals from the repository.  This ZGI routine should have been imported in the
``routines.ro`` file which was created in the PrepareMComponents_ step.

If it is not found in the local instance, you can find ZGI in the ``Scripts``
directory of the VistA repository.  A ``.ro`` file for this routine can be
created by using the command from PrepareMComponents_, but only pass the path
to the ``VistA/Scripts`` directory as the arguments to the
``PrepareMComponentsforImport.py`` file.  That ``.ro`` file can be imported
with the same process as the above files.

Once ZGI is available, execute the ``LIST`` entry point of the ZGI routine
using the MUMPS ``WRITE`` command to start the import.  An example follows:

.. parsed-literal::

 GTM> :usertype:`W $$LIST^ZGI("/path-to/VistA/globals.lst")`

This will take the globals.lst file and use the entries in it to tell GT.M to
import that .zwr file.

While the routine is running, the names of the .zwr files will be printed to
the screen as they are being processed. This is going through the OSEHRA Code
base and importing all of the .zwr files from each package. The final package
imported is the ``Wounded Injured and Ill Warriors``. After the last global is
imported, the program will return to the GT.M prompt.

Configure the VistA Environment
---------------------------------
Some configuration within the VistA environment is necessary before you have a
full VistA instance.

The text below shows the routine that need to be run to configure the VistA
instance. The ZTMGRSET routine will configure the VistA instance by renaming
some system-specific routines. This is done using the command:


.. parsed-literal::

  GTM> :usertype:`D ^ZTMGRSET`


  ZTMGRSET Version 8.0 Patch level **34,36,69,94,121,127,136,191,275,355,446**
  HELLO! I exist to assist you in correctly initializing the current account.
  Which MUMPS system should I install?

  1 = VAX DSM(V6), VAX DSM(V7)
  2 = MSM-PC/PLUS, MSM for NT or UNIX
  3 = Cache (VMS, NT, Linux), OpenM-NT
  4 = Datatree, DTM-PC, DT-MAX
  5 =
  6 =
  7 = GT.M (VMS)
  8 = GT.M (Unix)
  System: :usertype:`8`

  I will now rename a group of routines specific to your operating system.
  Routine:  ZOSVGUX Loaded, Saved as    %ZOSV

  Routine:  ZIS4GTM Loaded, Saved as    %ZIS4
  Routine:  ZISFGTM Loaded, Saved as    %ZISF
  Routine:  ZISHGTM Loaded, Saved as    %ZISH
  Routine:  XUCIGTM Loaded, Saved as    %XUCI
  Routine: ZOSV2GTM Loaded, Saved as   %ZOSV2
  Routine:  ZISTCPS Loaded, Saved as %ZISTCPS

  NAME OF MANAGER'S UCI,VOLUME SET: VAH,ROU// :usertype:`PLA,PLA`
  The value of PRODUCTION will be used in the GETENV api.
  PRODUCTION (SIGN-ON) UCI,VOLUME SET: VAH,ROU// :usertype:`PLA,PLA`
  The VOLUME name must match the one in PRODUCTION.
  NAME OF VOLUME SET: PLA//:usertype:`PLA`
  The temp directory for the system: '/tmp/'// :usertype:`<ENTER>`
  ^%ZOSF setup


  Now to load routines common to all systems.
  Routine:   ZTLOAD Loaded, Saved as  %ZTLOAD
  Routine:  ZTLOAD1 Loaded, Saved as %ZTLOAD1
  Routine:  ZTLOAD2 Loaded, Saved as %ZTLOAD2
  Routine:  ZTLOAD3 Loaded, Saved as %ZTLOAD3
  Routine:  ZTLOAD4 Loaded, Saved as %ZTLOAD4
  Routine:  ZTLOAD5 Loaded, Saved as %ZTLOAD5
  Routine:  ZTLOAD6 Loaded, Saved as %ZTLOAD6
  Routine:  ZTLOAD7 Loaded, Saved as %ZTLOAD7
  Routine:      ZTM Loaded, Saved as     %ZTM
  Routine:     ZTM0 Loaded, Saved as    %ZTM0
  Routine:     ZTM1 Loaded, Saved as    %ZTM1
  Routine:     ZTM2 Loaded, Saved as    %ZTM2
  Routine:     ZTM3 Loaded, Saved as    %ZTM3
  Routine:     ZTM4 Loaded, Saved as    %ZTM4
  Routine:     ZTM5 Loaded, Saved as    %ZTM5
  Routine:     ZTM6 Loaded, Saved as    %ZTM6
  Routine:     ZTMS Loaded, Saved as    %ZTMS
  Routine:    ZTMS0 Loaded, Saved as   %ZTMS0
  Routine:    ZTMS1 Loaded, Saved as   %ZTMS1
  Routine:    ZTMS2 Loaded, Saved as   %ZTMS2
  Routine:    ZTMS3 Loaded, Saved as   %ZTMS3
  Routine:    ZTMS4 Loaded, Saved as   %ZTMS4
  Routine:    ZTMS5 Loaded, Saved as   %ZTMS5
  Routine:    ZTMS7 Loaded, Saved as   %ZTMS7
  Routine:    ZTMSH Loaded, Saved as   %ZTMSH
  Routine:     ZTER Loaded, Saved as    %ZTER
  Routine:    ZTER1 Loaded, Saved as   %ZTER1
  Routine:      ZIS Loaded, Saved as     %ZIS
  Routine:     ZIS1 Loaded, Saved as    %ZIS1
  Routine:     ZIS2 Loaded, Saved as    %ZIS2
  Routine:     ZIS3 Loaded, Saved as    %ZIS3
  Routine:     ZIS5 Loaded, Saved as    %ZIS5
  Routine:     ZIS6 Loaded, Saved as    %ZIS6
  Routine:     ZIS7 Loaded, Saved as    %ZIS7
  Routine:     ZISC Loaded, Saved as    %ZISC
  Routine:     ZISP Loaded, Saved as    %ZISP
  Routine:     ZISS Loaded, Saved as    %ZISS
  Routine:    ZISS1 Loaded, Saved as   %ZISS1
  Routine:    ZISS2 Loaded, Saved as   %ZISS2
  Routine:   ZISTCP Loaded, Saved as  %ZISTCP
  Routine:   ZISUTL Loaded, Saved as  %ZISUTL
  Routine:     ZTPP Loaded, Saved as    %ZTPP
  Routine:     ZTP1 Loaded, Saved as    %ZTP1
  Routine:   ZTPTCH Loaded, Saved as  %ZTPTCH
  Routine:   ZTRDEL Loaded, Saved as  %ZTRDEL
  Routine:   ZTMOVE Loaded, Saved as  %ZTMOVE
  Want to rename the FileMan routines: No// :usertype:`Y`
  Routine:     DIDT Loaded, Saved as      %DT
  Routine:    DIDTC Loaded, Saved as     %DTC
  Routine:    DIRCR Loaded, Saved as     %RCR
  Setting ^%ZIS('C')

  Now, I will check your % globals...........

  ALL DONE
  GTM>

After loading a few routines, the configuration will ask you for the names of
the box/volume pair of the system, the name of the manager\'s namespace, and
the temp directory.  shows the default answers being accepted for these
prompts. They can be set if you need a specific name, but we used the defaults
of PLA for all names and the /tmp/ directory for the system.

Note: The NAME OF MANAGER'S UCI, VOLUME SET and
PRODUCTION (SIGN-ON) UCI,VOLUME SET prompts should be set to PLA,PLA if more
than XINDEX functionality is desired.

It will load and save some other routines, then ask if you
\"Want to rename the FileMan routines:.\" We answer this option with a YES. The
routine then loads three more routines, checks the % globals, and exits. Now
you are ready to start testing the OSEHRA Code base.

Some developers have encountered errors being displayed during the configuation
process.  See the second entry on the Troubleshooting Page to see if the errors
are the same and find any solutions.

.. _`ObtainingVistAMCode`: ObtainingVistAMCode.rst
