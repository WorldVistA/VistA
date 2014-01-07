VistA Initialization
====================
.. role:: usertype
    :class: usertype

The OSEHRA testing harness has a Python file that will perform a large
amount of VistA work to initalize the instance as a hospital.  It
starts Taskman, the RPC Listener, and adds doctors, nurses and a patient.

The file is called ``PostImportSetupScript.py.in`` and can be found in the
``Testing/Setup`` directory of the VistA source tree.

The file is created when running a ``Configure`` step via CMake in an OSEHRA
testing harness setup that has the TEST_VISTA_FRESH_ option selected.  The file
can be executed with the following command from the VistA Binary directory:

.. parsed-literal::

  user\@machine VistA-build/$ :usertype:`python Testing/Setup/PostImportSetupScript.py`

It is highly recommended that you use this script to set up a test instance.
In the event that it cannot be run, this page will go over the setup steps
which will allow you to connect CPRS to the VistA instance and start the Task
Manager.


Edit NULL Device
----------------

CPRS is one of many users of the VistA NULL device, but the ``$I`` value, which
contains the name or path to the device, is correct only for a VMS platform.
It is necessary to change it to match the local platform before it is able
to be accessed correctly.  The Sign-On capability also needs to be removed from
the device.

.. parsed-literal::

 VISTA> :usertype:`S DUZ=1 D Q^DI`


 VA FileMan 22.0


 Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES



 INPUT TO WHAT FILE: DEVICE// :usertype:`DEVICE`       (52 entries)
 EDIT WHICH FIELD: ALL// :usertype:`$I`
 THEN EDIT FIELD: :usertype:`SIGN-ON/SYSTEM DEVICE`
 THEN EDIT FIELD:


 Select DEVICE NAME: :usertype:`NULL`
     1   NULL      NT SYSTEM     NLA0:
     2   NULL  GTM-UNIX-NULL    Bit Bucket (GT.M-Unix)     /dev/null
     3   NULL-DSM      Bit Bucket     _NLA0:
 CHOOSE 1-3: :usertype:`1` NULL    NT SYSTEM     NLA0:

On Windows
**********

On Windows machines, the ``$I`` value should be set to ``//./nul``

.. parsed-literal::

 $I: NLA0:// :usertype:`//./nul`
 SIGN-ON/SYSTEM DEVICE: YES// :usertype:`NO`  NO


 Select DEVICE NAME: :usertype:`<enter>`

 Select OPTION: :usertype:`<enter>`

 VISTA>


On Linux
********

On Linux machines, the ``$I`` value should be set to ``/dev/null``

.. parsed-literal::

 $I: NLA0:// :usertype:`/dev/null`          This $I in use by other Devices.
 SIGN-ON/SYSTEM DEVICE: NO// :usertype:`N`  NO


 Select DEVICE NAME: :usertype:`<enter>`

 Select OPTION: :usertype:`<enter>`

 VISTA>


Set up a Domain
---------------

Next, a domain should be set up for the VistA instance.  A domain name is
typically used to uniquely identify an instance on a network.  While this
is not necessary to do for test instances, it is recommended that a new domain
be added.  The OSEHRA script adds a domain called ``DEMO.OSEHRA.ORG``, and this
example will do the same.

First we add the entry to the ``DOMAIN`` file through FileMan

.. parsed-literal::

  VISTA> :usertype:`S DUZ=1 D Q^DI`


  VA FileMan 22.0


  Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES



  INPUT TO WHAT FILE: // :usertype:`DOMAIN`
                                         (70 entries)
  EDIT WHICH FIELD: ALL// :usertype:`ALL`


  Select DOMAIN NAME: :usertype:`DEMO.OSEHRA.ORG`
    Are you adding 'DEMO.OSEHRA.ORG' as a new DOMAIN (the 71ST)? No// :usertype:`Y`  (Yes)
  FLAGS: :usertype:`^`

  Select DOMAIN NAME: :usertype:`<enter>`

  Select OPTION: :usertype:`<enter>`
  VISTA>

The next step is to find the IEN of the newly created domain. This can be done
by inquiring about the entry using FileMan and printing the Record Number:

.. parsed-literal::

  VISTA> :usertype:`S DUZ=1 D Q^DI`


  VA FileMan 22.0


  Select OPTION: :usertype:`5`  INQUIRE TO FILE ENTRIES



  OUTPUT FROM WHAT FILE: DOMAIN// :usertype:`DOMAIN`   (71 entries)
  Select DOMAIN NAME: :usertype:`DEMO.OSEHRA.ORG`
  ANOTHER ONE:
  STANDARD CAPTIONED OUTPUT? Yes// :usertype:`Y`  (Yes)
  Include COMPUTED fields:  (N/Y/R/B): NO// :usertype:`Record Number (IEN)`

  NUMBER: 76                              NAME: DEMO.OSEHRA.ORG

  Select DOMAIN NAME: :usertype:`^`




 Select OPTION: :usertype:`^`
 VISTA>


Then we propogate that entry to the ``Kernel System Parameters`` and
``RPC Broker Site Parameters`` files.  The value that is being set should
be the same as the ``NUMBER`` value from the above result.

.. parsed-literal::

  VISTA> :usertype:`S $P(^XWB(8994.1,1,0),"^")=76`
  VISTA> :usertype:`S $P(^XTV(8989.3,1,0),"^")=76`

Once that is done, those two files need to be re-indexed through FileMan.

.. parsed-literal::

 VISTA> :usertype:`D Q^DI`


 VA FileMan 22.0


 Select OPTION: :usertype:`UTILITY FUNCTIONS`
 Select UTILITY OPTION: :usertype:`RE-INDEX FILE`

 MODIFY WHAT FILE: RPC BROKER SITE PARAMETERS// :usertype:`8994.1`  RPC BROKER SITE PARAMETERS
                                         (1 entry)

 THERE ARE 5 INDICES WITHIN THIS FILE
 DO YOU WISH TO RE-CROSS-REFERENCE ONE PARTICULAR INDEX? No// :usertype:`No`  (No)
 OK, ARE YOU SURE YOU WANT TO KILL OFF THE EXISTING 5 INDICES? No// :usertype:`Y`  (Yes)
 DO YOU THEN WANT TO 'RE-CROSS-REFERENCE'? Yes// :usertype:`Y`  (Yes)
 ...SORRY, LET ME THINK ABOUT THAT A MOMENT...
 FILE WILL NOW BE 'RE-CROSS-REFERENCED'......


 Select UTILITY OPTION: :usertype:`RE-INDEX FILE`

 MODIFY WHAT FILE: RPC BROKER SITE PARAMETERS// :usertype:`8989.3`  KERNEL SYSTEM PARAMETERS
                                         (1 entry)
 THERE ARE 14 INDICES WITHIN THIS FILE
 DO YOU WISH TO RE-CROSS-REFERENCE ONE PARTICULAR INDEX? No// :usertype:`N`  (No)
 OK, ARE YOU SURE YOU WANT TO KILL OFF THE EXISTING 14 INDICES? No// :usertype:`Y`  (Yes)
 DO YOU THEN WANT TO 'RE-CROSS-REFERENCE'? Yes// :usertype:`Y` (Yes)
 ...HMMM, THIS MAY TAKE A FEW MOMENTS...
 FILE WILL NOW BE 'RE-CROSS-REFERENCED'.................


 Select UTILITY OPTION: :usertype:`<enter>`

 Select OPTION: :usertype:`<enter>`

 VISTA>

Set Box-Volume pair
-------------------

The first step is to find the box volume pair for the local machine.

.. parsed-literal::

  VISTA> :usertype:`D GETENV^%ZOSV W Y`

which will print out a message with four parts separated by ``^`` that could
look something like:

.. parsed-literal::

  VISTA^VISTA^palaven^VISTA:CACHE

The Box-Volume pair is the final piece of that string and contains two bits of
information. The first piece is the Volume Set, which is used to determine
where the VistA system will be able to find the routines.

The second bit of info is the BOX, which references the system that the
instance is on. In a Caché system, it would be the name of the Caché
instance while on GT.M, it should reference the hostname of the machine.

The Volume Set result needs to be altered in the ``VOLUME SET`` file,
and we will reuse some setup by writing over the name of the first entry that
is already in the VistA system.  The first entry, the entry with an IEN of 1,
can be selected by entering ```1``.

Then we rename the first Box-Volume pair in the ``TaskMan Site Parameters``
file to match what was found above.

For this demonstration instance, the Volume Set will be ``VISTA`` which is the
Caché namespace that holds the files.  On GT.M instances, the default value of
``PLA`` can be maintained.

.. parsed-literal::

  VISTA> :usertype:`S DUZ=1 D Q^DI`


  VA FileMan 22.0

  Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES

  INPUT TO WHAT FILE: DEVICE// :usertype:`14.5`  VOLUME SET  (1 entry)
  EDIT WHICH FIELD: ALL// :usertype:`VOLUME SET`
  THEN EDIT FIELD: :usertype:`TASKMAN FILES UCI`
  THEN EDIT FIELD: :usertype:`<enter>`


  Select VOLUME SET: :usertype:`\`1`  PLA
  VOLUME SET: PLA// :usertype:`VISTA`
  TASKMAN FILES UCI: PLA// :usertype:`VISTA`


  Select VOLUME SET: :usertype:`<enter>`


  INPUT TO WHAT FILE: TASKMAN SITE PARAMETERS// :usertype:`14.7`  TASKMAN SITE PARAMETERS
                                          (1 entry)
  EDIT WHICH FIELD: ALL// :usertype:`<enter>`


  Select TASKMAN SITE PARAMETERS BOX-VOLUME PAIR: :usertype:`\`1`  PLA:PLAISCSVR
  BOX-VOLUME PAIR: PLA:PLAISCSVR// :usertype:`VISTA:CACHE`
  RESERVED: :usertype:`^`


  Select TASKMAN SITE PARAMETERS BOX-VOLUME PAIR: :usertype:`<enter>`
  Select OPTION: :usertype:`<enter>`


Next, Edit the ``Kernel System Parameters`` file to add the new Volume Set to
the ``DEMO.OSEHRA.ORG`` domain and set some constraints about signing on.

.. parsed-literal::

 Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES



 INPUT TO WHAT FILE: RPC BROKER SITE PARAMETERS// :usertype:`KERNEL SYSTEM PARAMETERS`
                                          (1 entry)
 EDIT WHICH FIELD: ALL// :usertype:`VOLUME SET`    (multiple)
   EDIT WHICH VOLUME SET SUB-FIELD: ALL// :usertype:`<enter>`
 THEN EDIT FIELD: :usertype:`<enter>`


 Select KERNEL SYSTEM PARAMETERS DOMAIN NAME: :usertype:`DEMO.OSEHRA.ORG`
         ...OK? Yes// :usertype:`Y` (Yes)

 Select VOLUME SET: PLA// :usertype:`VISTA`
  Are you adding 'VISTA' as a new VOLUME SET (the 2ND for this KERNEL SYSTEM PARAMETERS)? No// :usertype:`Y`
  (Yes)
  MAX SIGNON ALLOWED: :usertype:`500`
  LOG SYSTEM RT?: :usertype:`N`  NO
 Select VOLUME SET: :usertype:`<enter>`


 Select KERNEL SYSTEM PARAMETERS DOMAIN NAME: :usertype:`<enter>`

 Select OPTION: :usertype:`<enter>`

Setup RPC Broker
----------------

The next step is to edit entries in the ``RPC Broker Site Parameters`` file
and the ``Kernel System Parameters`` file.  The RPC Broker steps will set up
information that references both the the Port that the listener will listen
on and the Box Volume pair of the instance.

.. parsed-literal::

 VISTA> :usertype:`S DUZ=1 D Q^DI`


 VA FileMan 22.0


 Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES

 INPUT TO WHAT FILE: VOLUME SET// :usertype:`8994.1`  RPC BROKER SITE PARAMETERS
                                         (1 entry)
 EDIT WHICH FIELD: ALL// :usertype:`LISTENER`    (multiple)
    EDIT WHICH LISTENER SUB-FIELD: ALL// :usertype:`<enter>`
 THEN EDIT FIELD: :usertype:`<enter>`


 Select RPC BROKER SITE PARAMETERS DOMAIN NAME: :usertype:`DEMO.OSEHRA.ORG`
         ...OK? Yes// :usertype:`Y`   (Yes)

 Select BOX-VOLUME PAIR: // :usertype:`VISTA:CACHE`
  BOX-VOLUME PAIR: VISTA:CACHE//
  Select PORT: :usertype:`9210`
  Are you adding '9210' as a new PORT (the 1ST for this LISTENER)? No// :usertype:`Y`  (Yes)
    TYPE OF LISTENER: :usertype:`1`  New Style

The final questions of this section asks if the listener should be started
and then if it should be controlled by the Listener starter.

The answer to these questions is dependent on the MUMPS platform that is in
use:



On Caché
********

Caché systems can use the Listener Starter to control the RPC Broker Listener.

.. parsed-literal::

    STATUS: STOPPED// :usertype:`1` START
          Task: RPC Broker Listener START on VISTA-VISTA:CACHE, port 9210
          has been queued as task 1023
    CONTROLLED BY LISTENER STARTER: :usertype:`1`  YES

 Select RPC BROKER SITE PARAMETERS DOMAIN NAME: :usertype:`<enter>`

On GT.M
*******

Since GT.M systems do not use the Listener as Caché systems, we will answer
"No" or "0" to both of those questions.  More information on setting up the
listener for GT.M will follow.

.. parsed-literal::

    STATUS: STOPPED// :usertype:`<enter>`
    CONTROLLED BY LISTENER STARTER: :usertype:`0`  No

 Select RPC BROKER SITE PARAMETERS DOMAIN NAME: :usertype:`<enter>`


Start RPC Broker
----------------

On Caché
********

The OSEHRA setup scrpt will also start the RPC Broker Listener which
CPRS uses to communicate with the VistA instance.  These steps only happen on
platforms with a Caché instance.  They create a task for the
XWB Listener Starter that will be run when the Task Manager is started.

.. parsed-literal::

  VISTA> :usertype:`S DUZ=1 D ^XUP`

  Setting up programmer environment
  This is a TEST account.

  Terminal Type set to: C-VT220

  Select OPTION NAME: :usertype:`Systems Manager Menu`  EVE     Systems Manager Menu


          Core Applications ...
          Device Management ...
          Menu Management ...
          Programmer Options ...
          Operations Management ...
          Spool Management ...
          Information Security Officer Menu ...
          Taskman Management ...
          User Management ...
          Application Utilities ...
          Capacity Planning ...
          HL7 Main Menu ...


  You have PENDING ALERTS
          Enter  "VA to jump to VIEW ALERTS option

  Select Systems Manager Menu <TEST ACCOUNT> Option: :usertype:`Taskman Management`


          Schedule/Unschedule Options
          One-time Option Queue
          Taskman Management Utilities ...
          List Tasks
          Dequeue Tasks
          Requeue Tasks
          Delete Tasks
          Print Options that are Scheduled to run
          Cleanup Task List
          Print Options Recommended for Queueing


  You have PENDING ALERTS
          Enter  "VA to jump to VIEW ALERTS option

  Select Taskman Management <TEST ACCOUNT> Option: :usertype:`Schedule/Unschedule Options`

  Select OPTION to schedule or reschedule: :usertype:`XWB LISTENER STARTER`       Start All RP
  C Broker Listeners
         ...OK? Yes// :usertype:`Y`  (Yes)
      (R)

After answering that question another ScreenMan form will open with six
options.  To have the XWB Listener Starter be run on the start up of Taskman,
enter ``STARTUP`` as the value for ``SPECIAL QEUEING``:

.. parsed-literal::
                          Edit Option Schedule
    Option Name: XWB LISTENER STARTER
    Menu Text: Start All RPC Broker Listeners            TASK ID:
  __________________________________________________________________________

    QUEUED TO RUN AT WHAT TIME:

  DEVICE FOR QUEUED JOB OUTPUT:

   QUEUED TO RUN ON VOLUME SET:

        RESCHEDULING FREQUENCY:

               TASK PARAMETERS:

        ----> SPECIAL QUEUEING:

  _______________________________________________________________________________
  Exit     Save     Next Page     Refresh

  Enter a command or '^' followed by a caption to jump to a specific field.

The final result should look like this:

.. parsed-literal::

                          Edit Option Schedule
    Option Name: XWB LISTENER STARTER
    Menu Text: Start All RPC Broker Listeners            TASK ID:
  __________________________________________________________________________

    QUEUED TO RUN AT WHAT TIME:

  DEVICE FOR QUEUED JOB OUTPUT:

   QUEUED TO RUN ON VOLUME SET:

        RESCHEDULING FREQUENCY:

               TASK PARAMETERS:

              SPECIAL QUEUEING: STARTUP

  _______________________________________________________________________________
  Exit     Save     Next Page     Refresh

  Enter a command or '^' followed by a caption to jump to a specific field.


  COMMAND:                                      Press <PF1>H for help    Insert

To save the information put the ScreenMan form, navigate to the ``COMMAND`` entry
point and enter ``S`` or ``Save``.  The same input location is used to exit, with
an ``E`` or ``Exit`` to leave the form.

.. parsed-literal::
  Select OPTION to schedule or reschedule: :usertype:`<enter>`


          Schedule/Unschedule Options
          One-time Option Queue
          Taskman Management Utilities ...
          List Tasks
          Dequeue Tasks
          Requeue Tasks
          Delete Tasks
          Print Options that are Scheduled to run
          Cleanup Task List
          Print Options Recommended for Queueing


  You have PENDING ALERTS
          Enter  "VA to jump to VIEW ALERTS option

  Select Taskman Management <TEST ACCOUNT> Option: :usertype:`<enter>`

  Select Systems Manager Menu <TEST ACCOUNT> Option: :usertype:`<enter>`


On GT.M
*******

The process is a bit more complicated, but OSEHRA has a
`wiki page`_ which describes the process of the set up.


Start TaskMan
------------------------

The Task Manager is an integral part of a running VistA instance. It lets
actions and users schedule tasks to be performed at certain times or after
certain trigger events.  The XWB Listener Starter example is one example
of scheduling a task.

The OSEHRA script uses the ``TaskMan Management Utilities`` menu to control
TaskMan:

.. parsed-literal::

  VISTA> :usertype:`S DUZ=1 D ^XUP`

  Setting up programmer environment
  This is a TEST account.

  Terminal Type set to: C-VT220

  Select OPTION NAME: :usertype:`TASKMAN MANAGEMENT UTILITIES`  XUTM UTIL     Taskman Manageme
  nt Utilities


   MTM    Monitor Taskman
          Check Taskman's Environment
          Edit Taskman Parameters ...
          Restart Task Manager
          Place Taskman in a WAIT State
          Remove Taskman from WAIT State
          Stop Task Manager
          Taskman Error Log ...
          Clean Task File
          Problem Device Clear
          Problem Device report.
          SYNC flag file control


  You've got PRIORITY mail!


  Select Taskman Management Utilities <TEST ACCOUNT> Option: :usertype:`Restart Task Manager`
  ARE YOU SURE YOU WANT TO RESTART TASKMAN? NO// :usertype:`Y`  (YES)
  Restarting...TaskMan restarted!


   MTM    Monitor Taskman
          Check Taskman's Environment
          Edit Taskman Parameters ...
          Restart Task Manager
          Place Taskman in a WAIT State
          Remove Taskman from WAIT State
          Stop Task Manager
          Taskman Error Log ...
          Clean Task File<F5>
          Problem Device Clear
          Problem Device report.
          SYNC flag file control


  You've got PRIORITY mail!

  Select Taskman Management Utilities <TEST ACCOUNT> Option: :usertype:`^`


Add User
--------

The next step is to create a user that can sign on to the CPRS GUI.
The things to make sure that this new user has are

 * A Secondary menu option of "OR CPRS GUI CHART"
 * CPRS Tab Access
 * An ACCESS CODE
 * A VERIFY CODE
 * Service/Section (required for any user)

The menu option ensures that the user has the proper permissions to access
CPRS after signing in with their ACCESS and VERIFY codes.  The Tab access
can limit the amount of things a user can access once they have signed in.

The adding of the user is done through the User Management menu in the
menu system, which will ask for information in a series of prompts then will
open a Screenman form to complete the task.

The following steps will add a generic ``CPRS,USER`` person who will be able to
sign into CPRS.

.. parsed-literal::
  VISTA> :usertype:`S DUZ=1 D ^XUP`

  Setting up programmer environment
  This is a TEST account.

  Terminal Type set to: C-VT220

  Select OPTION NAME:  :usertype:`Systems Manager Menu`


          Core Applications ...
          Device Management ...
          Menu Management ...
          Programmer Options ...
          Operations Management ...
          Spool Management ...
          Information Security Officer Menu ...
          Taskman Management ...
          User Management ...
          Application Utilities ...
          Capacity Planning ...
          HL7 Main Menu ...


  You have PENDING ALERTS
          Enter  "VA to jump to VIEW ALERTS option

  Select Systems Manager Menu <TEST ACCOUNT> Option: :usertype:`User Management`


          Add a New User to the System
          Grant Access by Profile
          Edit an Existing User
          Deactivate a User
          Reactivate a User
          List users
          User Inquiry
          Switch Identities
          File Access Security ...
             \**> Out of order:  ACCESS DISABLED
          Clear Electronic signature code
          Electronic Signature Block Edit
          List Inactive Person Class Users
          Manage User File ...
          OAA Trainee Registration Menu ...
          Person Class Edit
          Reprint Access agreement letter


  You have PENDING ALERTS
          Enter  "VA to jump to VIEW ALERTS option

  Select User Management <TEST ACCOUNT> Option: :usertype:`Add a New User to the System`
  Enter NEW PERSON's name (Family,Given Middle Suffix): :usertype:`CPRS,USER`
    Are you adding 'CPRS,USER' as a new NEW PERSON (the 56TH)? No// :usertype:`Y`  (Yes)
  Checking SOUNDEX for matches.
  No matches found.
  Now for the Identifiers.
  INITIAL: :usertype:`UC`
  SSN: :usertype:`000000002`
  SEX: :usertype:`M`  MALE
  NPI:

Once in the ScreenMan form, you will need to set the necessary
information mentioned above. Four pieces of information are able to be set
on the first page of the ScreenMan form.  The arrows are for emphasis to
highlight where information needs to be entered and will not show up in the
terminal window.

To add an access or verify codes, you need to first answer ``Y`` to the
``Want to edit ...`` questions, it will then prompt you to change the codes.

.. parsed-literal::
                             Edit an Existing User
 NAME: CPRS,USER                                                     Page 1 of 5
 _______________________________________________________________________________
    NAME... CPRS,USER                                   INITIAL: UC
     TITLE:                                           NICK NAME:
       SSN: 000000002                                       DOB:
    DEGREE:                                           MAIL CODE:
   DISUSER:                                     TERMINATION DATE:
   Termination Reason:

            PRIMARY MENU OPTION:
  Select SECONDARY MENU OPTIONS:   <---
 Want to edit ACCESS CODE (Y/N):   <---  FILE MANAGER ACCESS CODE:
 Want to edit VERIFY CODE (Y/N):   <---

               Select DIVISION:
          ---> SERVICE/SECTION:
 _______________________________________________________________________________
  Exit     Save     Next Page     Refresh

 Enter a command or '^' followed by a caption to jump to a specific field.


 COMMAND:                                     Press <PF1>H for help    Insert

To change to other pages, press the down arrow key or <TAB> until the cursor
reaches the COMMAND box.  Then type ``N`` or ``Next Page`` and press <ENTER> to
display the next page.

There is nothing that needs to be set on the second or third pages, but the
CPRS Tab Access is set on the fourth page. Navigate the cursor to the location
under the ``Name`` header and enter ``COR``, which stands ``for Core Tab Access``,
and enter an effective date of yesterday, ``T-1`` is the notation to use.

.. parsed-literal::
                             Edit an Existing User
 NAME: CPRS,USER                                                     Page 4 of 5
 _______________________________________________________________________________
 RESTRICT PATIENT SELECTION:        OE/RR LIST:

 CPRS TAB ACCESS:
   Name  Description                          Effective Date  Expiration Date
 ->








 _______________________________________________________________________________





 COMMAND:                                       Press <PF1>H for help

Once that is done, save and exit the ScreenMan form via the COMMAND box and
then answer the final questions regarding access letters, security keys
and mail groups:

.. parsed-literal::
 Exit     Save     Next Page     Refresh

 Enter a command or '^' followed by a caption to jump to a specific field.


 COMMAND: :usertype:`E`                                     Press <PF1>H for help    Insert

 Print User Account Access Letter? :usertype:`NO`
 Do you wish to allocate security keys? NO// :usertype:`NO`
 Do you wish to add this user to mail groups? NO// :usertype:`NO`

 *<snip>*
 Select User Management <TEST ACCOUNT> Option: :usertype:`^<enter>`
 VISTA>

At this point, CPRS can successfully connect to the local VistA instance and
the ``CPRS,USER`` will be able to sign on and interact with the GUI.  For
instructions on how to set up the CPRS connection command or to download
the executable, see `GUI page`_.

.. _TEST_VISTA_FRESH: SetupTestingEnvironment.rst
.. _`wiki page`: http://wiki.osehra.org/pages/viewpage.action?pageId=3047628#Developmentenvironmentinstall%28OSEHRAVM%29-Configurexinetd
.. _`GUI page`: http://www.osehra.org/document/guis-used-automatic-functional-testing
