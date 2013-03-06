Retrieving the code from Git and Importing into Caché
==========================================================

.. role:: usertype
    :class: usertype

Starting from an empty instance of Caché, we need to retrieve the routines and globals that will populate the VistA environment from the OSEHRA Code Repository at code.osehra.org. Begin by bringing up a Git Bash terminal from the installed Git system.

The git interface is a command-prompt interface with much of the functionality that should be familiar to Linux users; commands like \"ls\" and \"cd\" perform as they would in Cygwin shell or a Linux terminal. Git specific actions are always preceded by the \"git\" command on the input line. The command \"git --help\" displays a list of the most common commands.

To obtain a copy of the repository, create a directory (Folder) to hold the repository code and \"cd\" into that directory. Enter the commands

.. parsed-literal::


  $ :usertype:`git clone git://code.osehra.org/VistA-FOIA.git`
  Cloning into 'VistA-FOIA'...
  .
  .
  .
  $
  $ :usertype:`cd VistA-FOIA`


to make a local clone of the remote repository.


Packing Routines and Globals
----------------------------

Within the Git repository, you can see the folders that contain all that is necessary to prepare the routines and globals to be imported into the Caché instance. The Packages folder contains all of the VistA FOIA software divided by package name.  Inside each package directory lies a Routines directory and a Globals directory. The latter contains globals divided up by the FileMan files they contain. The Scripts folder contains OSEHRA python scripts and helper routines. The python scripts are used to pack and unpack the routines.ro file, while the routines are used to import and export the globals from the MUMPS environment.

Execute the following two commands to prepare the data for import .

.. parsed-literal::


  VistA-FOIA$ :usertype:`git ls-files -- "*.m" | python Scripts/PackRO.py > routines.ro`

  VistA-FOIA$ :usertype:`git ls-files -- "*.zwr" > globals.lst`



The first command lists all the files that have the extension \'.m\' and passes those names to the python script PackRO.py to pack them into file routine.ro in routine transfer format. The second command lists all files that have the extension \'.zwr\' and writes those into globals.lst. This list will be read by the OSEHRA ZGI routine during the import step.

Import routines and globals into Caché
--------------------------------------

The next set of steps is to import the routines and globals into the Caché instance and then configure the instance to the point where testing can be performed. All of these steps are performed from the Caché terminal. Right click on the Caché icon and select terminal from the pop-up as shown to bring up a Caché terminal.


The first step is to change from the default \"USER\" namespace to the namespace that you created earlier. Entering \"D ^%CD\" will bring up a prompt to accept the name of the new namespace that you want to enter. For demonstration purposes, we will assume that the namespace is called \"VISTA\".


.. parsed-literal::

  USER> :usertype:`D ^%CD`

  Namespace: :usertype:`VISTA`
  Youre in namespace VISTA
  Default directory is c:\intersystems\trycache\mgr\vista\
  VISTA>


The %RI routine is a MUMPS routine that is used to import other routines from a specific file type. When prompted for a device, enter the path to the routines.ro file and press <Enter> to accept the default parameters, read-only mode. The terminal will then display a warning saying
\"This file may not be a %RO output file.\" This is an expected warning due to how we are creating the routines.ro file. At the prompt, enter \"Yes\" to continue and then enter then <Enter> to accept the 0th option (Caché) for the routines write type. To fully import the routines, enter
\"All Routines\" at the Routine Input Option, and answer \"YES\" to \"replace similarly named routines.\" All other options may be answered with <Enter> to accept the default value.

.. parsed-literal::

  VISTA> :usertype:`D ^%RI`
  Input routine from Sequential
  Device: (path to routines.ro)
  Parameters? "R" =>  (enter)

    *****  W A R N I N G *****

  File Header: Routines
  Date Stamp:

  This file many not be a %RO output file.
  Override and use this File with %RI? No =>  <Yes>
  %RI has detected a routine written with UNKNOWN mode.
     0) Cache
     .
     .
     .
     11) MVBASIC

  Please enter a number from the above list: :usertype:`0`

  File written by OLD with description:
  Routines
  ( All Select Enter List Quit )

  Routine Input Option: :usertype:`All`

  If a selected routiens has the same name as one already on file,
  shall it replace the one on file? No => :usertype:`Yes`
  Recompile? Yes => :usertype:`Yes`
  Display Syntax Errors? Yes => :usertype:`Yes`


The system will respond with a list of all that have been processed and then displays the VistA prompt . In the listing, the symbols next to the routine name have meaning:

^ indicates routines which will replace those now on file.

@ indicates routines which have been [re]compiled.

\- indicates routines which have not been filed.


The next step is to import the Globals using the newly imported ZGI routine. Enter

.. parsed-literal::

  VISTA> :usertype:`D LIST^ZGI("c:/path/to/VistA-FOIA/globals.lst","c:/path/to/VistA-FOIA/")`

where \"path\\to\" is replaced with the path to the code download . This routine will go through all of the globals contained in the list file and import them into the VistA instance . The last package to be imported is the Wounded Injured and Ill Warriors.  The example below will demonstrate the command and the first/last globals to be imported.

.. parsed-literal::

  VISTA> :usertype:`D LIST^ZGI("C:/Users/joe.snyder/Desktop/testbin/globals.lst","C:/Users/joe.snyder/Desktop/VistA-FOIA/")`

  C:/Users/joe.snyder/Desktop/VistA-FOIA/Packages/Accounts Receivable/Globals/340+AR DEBTOR.zwr

  C:/Users/joe.snyder/Desktop/VistA-FOIA/Packages/Accounts Receivable/Globals/341+AR EVENT.zwr

  C:/Users/joe.snyder/Desktop/VistA-FOIA/Packages/Accounts Receivable/Globals/341.1+AR EVENT TYPE.zwr

  .
  .
  .

  C:/Users/joe.snyder/Desktop/VistA-FOIA/Packages/Womens Health/Globals/790.72+WV AGE RANGE DEFAULT.zwr

  C:/Users/joe.snyder/Desktop/VistA-FOIA/Packages/Womens Health/Globals/WV.zwr

  C:/Users/joe.snyder/Desktop/VistA-FOIA/Packages/Wounded Injured and Ill Warriors/Globals/987.5+WII ADMISSIONS DISCHARGES.zwr

  C:/Users/joe.snyder/Desktop/VistA-FOIA/Packages/Wounded Injured and Ill Warriors/Globals/987.6+WII PARAMETERS.zwr

  C:/Users/joe.snyder/Desktop/VistA-FOIA/Packages/Wounded Injured and Ill Warriors/Globals/WII.zwr


  VISTA>


Configure the VistA Environment
-------------------------------

At this point, all routines and globals are imported and the environment is ready to be configured.  Enter \"D ^ZTMGRSET\"
to initialize the current instance for use. Choose the default, Caché environment. Some routines are loaded and a series of prompts are shown on the screen.  The NAME OF MANAGER'S NAMESPACE, PRODUCTION (SIGN-ON) NAMESPACE, and NAME OF THIS CONFIGURATION prompts should be answered with the name of the namespace that was created earlier (VISTA in this configuration), . At the fourth prompt, \"Want to rename the FileMan routines,\" enter \"Y\" to rename the routines.

.. parsed-literal::

  VISTA> :usertype:`D ^ZTMGRSET`

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

  System: :usertype:`3`



  I will now rename a group of routines specific to your operating system.

  Routine:  ZOSVONT Loaded, Saved as    %ZOSV

  Routine:  ZIS4ONT Loaded, Saved as    %ZIS4

  .
  .
  .

  Routine: ZOSVKSOS Loaded, Saved as %ZOSVKSS

  Routine:  ZOSVKSD Loaded, Saved as %ZOSVKSD


  NAME OF MANAGER'S NAMESPACE: %SYS// :usertype:`VISTA`

  PRODUCTION (SIGN-ON) NAMESPACE: VAH// :usertype:`VISTA`

  NAME OF THIS CONFIGURATION: ROU// :usertype:`VISTA`



  ALL SET UP


  Now to load routines common to all systems.

  Routine:   ZTLOAD Loaded, Saved as  %ZTLOAD

  .
  .
  .

  Routine:   ZTPTCH Loaded, Saved as  %ZTPTCH

  Routine:   ZTRDEL Loaded, Saved as  %ZTRDEL

  Routine:   ZTMOVE Loaded, Saved as  %ZTMOVE

  Want to rename the FileMan routines: No//   :usertype:`YES`

  Routine:     DIDT Loaded, Saved as      %DT

  Routine:    DIDTC Loaded, Saved as     %DTC

  Routine:    DIRCR Loaded, Saved as     %RCR

  Installing ^%Z editor

  Setting ^%ZIS('C')



  Now, I will check your % globals...........


  ALL DONE

  VISTA>


The final step needed for the testing is to alter a device within the File Manager. We need to change the $I value of the TELNET device to let the Caché terminal function as a display for the XINDEX routine.

The first step is to identify yourself as a programmer and gain permissions to change the files attributes.  Enter \"VISTA> S DUZ=1 D Q^DI\"

to first get access to the File Manager and then to start the File Manager. At the Select OPTION prompt, enter \"1\" to edit the file entries; at the INPUT TO WHAT FILE: prompt, enter the word \"DEVICE\"; and at the EDIT WHICH FIELD: prompt enter \"$I\". Enter <Enter> to end the field queries. The system will respond with a Select DEVICE NAME: prompt, enter \"TELNET\" to bring up an option menu and then enter the option that does not reference GT.M or UNIX. Finally, the system will respond with $I: TNA//.  Enter \|TNT\|, and press enter until the VISTA prompt is reached.

.. parsed-literal::

  VISTA> :usertype:`S DUZ=1 D Q^DI`

  VA FileMan 22.0

  Select OPTION: :usertype:`1`

  INPUT TO WHAT FILE: :usertype:`DEVICE`
  EDIT WHICH FIELD: ALL// :usertype:`$I`
  THEN EDIT FIELD: :usertype:`<ENTER>`

  Select DEVICE NAME: :usertype:`TELNET`
       1  TELNET    TELNET    TNA
       2  TELNET   GTM-UNIX-TELNET    TELNET   /dev/pts
  CHOOSE 1-2:  :usertype:`1`
  $I: TNA// :usertype:`|TNT|`

  Select DEVICE NAME: :usertype:`<ENTER>`

  Select OPTION:  :usertype:`<ENTER>`

  VISTA>
