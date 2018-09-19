How to use PatchSequenceApply.py
================================

This document describes the usage of PatchSequenceApply python module

Description
-----------

This module is mainly used to automatically apply a series of Patches in sequence order
on a running VistA instance.

This script is intended to be used for development only, and use it at you own risk.
Please do **NOT** try it on production environment!

Before running the script, please make sure

* Already setup the required environment. If not, please refer to `Setup Script Environment`_
* Already backup the current VistA instance.

With provided patches top directory, this script will first generate a valid patch sequence order
based on topologic sort (refer to PatchOrderGenerator_ for more detail), query the running
VistA instance to filter out patches that are already installed, then generate a list of patches in
valid sequence order and finally apply those patches in order.

It will print out error and exit if

* No valid sequences order exists.
* Could not install patches to the running VistA due to

  * Required patches are not installed.
  * Patch might be out of order.

Generate patch sequence order
-----------------------------

It is highly recommended to print out a list of patches in sequence order first before actally
installing any of the patches.

Command::

  python PatchSequenceApply.py -p <path_to_top_patches_dir> -l <path_to_log_dir> <VistA_connection_arguments>

Sample output::

  python PatchSequenceApply.py -p ../Packages -l /tmp/ -S 2
  ..............
  Total patches are 114
  ECX*3.0*140, ECX, /home/jasonli/git/VistA/Packages/DSS Extracts/Patches/ECX_3.0_140/ECX-3_SEQ-125_PAT-140.KID
  LEX*2.0*84, LEX, /home/jasonli/git/VistA/Packages/Lexicon Utility/Patches/LEX_2.0_84/LEX-2_SEQ-76_PAT-84.KID
  PSJ*5.0*278, PSJ, /home/jasonli/git/VistA/Packages/Inpatient Medications/Patches/PSJ_5.0_278/PSJ-5_SEQ-237_PAT-278.KID
  GMRC*3.0*74, GMRC, /home/jasonli/git/VistA/Packages/Consult Request Tracking/Patches/GMRC_3.0_74/GMRC-3_SEQ-66_PAT-74.KID
  OR*3.0*362, OR, /home/jasonli/git/VistA/Packages/Order Entry Results Reporting/Patches/OR_3.0_362/OR-3_SEQ-309_PAT-362.KID
  .............
  PSO*7.0*374, PSO, /home/jasonli/git/VistA/Packages/Outpatient Pharmacy/Patches/PSO_7.0_374/PSO-7_SEQ-350_PAT-374.KID
  PRCA*4.5*292, PRCA, /home/jasonli/git/VistA/Packages/Accounts Receivable/Patches/PRCA_4.5_292/PRCA-4P5_SEQ-258_PAT-292.KID
  IB*2.0*474, IB, /home/jasonli/git/VistA/Packages/Integrated Billing/Patches/IB_2.0_474/IB-2_SEQ-449_PAT-474.KID
  PSS*1.0*150, PSS, /home/jasonli/git/VistA/Packages/Pharmacy Data Management/Patches/PSS_1.0_150/PSS-1_SEQ-154_PAT-150.KID
  IB*2.0*457, IB, /home/jasonli/git/VistA/Packages/Integrated Billing/Patches/IB_2.0_457/IB-2_SEQ-450_PAT-457.KID

Apply patches
-------------

There are a few ways to customize on how to apply the patches in order:

1. Specify the number of patches to apply

   * just append ``-i -n <number of patches>`` to the above command, the default is just one patch if ``-n`` option is not provided.
   * ``-i -n all`` will apply all the patches

2. Apply patches up to specified patch installation name

   * just append ``-i -u <patch_install_name>``

3. Apply the specified patch and all required patches only

   * just append ``-i -o <patch_install_name>``
   * this option will ignore the dependencies that specified in the CSV files (see PatchOrderGenerator_ for more detail)


Potential Issues
----------------

The automatic patching is certainly not a foolproof system.  The entries below
list a few of the issues that OSEHRA has come across while using the framework
and some potential solutions for those problems.

Required patch is not installed
###############################

This problem arises when the available set of patches requires the install of
a particular file, but it isn't found among the currently available patches.

Example:
++++++++

From PatchSequenceApply output:

::

  2016-01-20 10:41:53,365 INFO Checking for patch info PSN*4.0*455
  2016-01-20 10:41:54,112 ERROR dep PSN*4.0*453 is not installed for PSN*4.0*455 c:\Users\softhat\Desktop\wget\Oct2015\NDF4P455.KIDs
  2016-01-20 10:41:54,112 ERROR Can not install patch PSN*4.0*455

Resolution:
+++++++++++

Download the patch, if available, from foia-vista.osehra.org or another source
and place it in the directory with the target patch.


Patch requires additional global information
#############################################

Certain patches require an update to the globals to be installed prior to the
installation of the patch.  This global file is typically stored as a ``*.GBL``
and sent along with the patch. The framework is able to install the global file
prior to patching, but an update is necessary to one of the framework's Python
files.

Example:
++++++++

From VistAInteraction.log:

::

   Running checksum routine on the ^LEXM import global, please wait
   Missing import global ^LEXM.

        Please obtain a copy of the import global ^LEXM contained in the
        global host file LEX_2_101.GBL before continuing with the LEX*2.0*101
        installation.

   LEX*2.0*101 Build will not be installed, Transport Global deleted!
               Jan 20, 2016@13:41:25

Resolution:
+++++++++++

Acquire global file and place it in the same directory as the patch.  Alter the
``KIDS_SINGLE_FILE_ASSOCIATION_DICT`` structure within the
``KIDSAssociatedFilesMapping.py`` file.  This should have a mapping of the
global file name to the install name.  For the above example, the following
would be added to the dictionary:

::

  "LEX_2_101.GBLs": "LEX*2.0*101"

Patch is unable to be parsed
#############################

This error is found when the parser of the KIDS builds comes across a
malformed KIDS file. This could be due to missing or extra lines or may even
be an end-of-line formatting issue.

Example:
++++++++

::

  File "c:\Users\joe.snyder\Work\OSEHRA\VistA\Scripts\KIDSBuildParser.py", line 708, in __onEndSectionStart__
    assert self.END_LINE.search(line2), "Wrong end of line format %s" % line2
  AssertionError: Wrong end of line format

Resolution:
+++++++++++
Searching the output leads to the following set of warnings regarding a specific patch:

::

  2016-01-20 11:16:25,438 INFO Parsing KIDS file c:\Users\softhat\Desktop\wget\Sep2015\XU_8_655_SEQ_518.KIDs
  2016-01-20 11:16:25,582 WARNING Can not parse  ;;
  2016-01-20 11:16:25,584 WARNING Can not parse 8.0^22.0
  2016-01-20 11:16:25,584 WARNING Can not parse SECID^F^^205;1^K:$L(X)>40!($L(X)<3) X

Checking this location reveals that an extra line has been added to the text of
the KIDS build. Remove the extra text and restart the PatchSequencyApply script
to restart the parsing.

Installer timeout
#################

The script of the installer expects a specific set of questions to be asked. If
more questions are included, either as part of a pre/post install routine or as
part of the install process, the script will not be able to answer the question
and the patching process will stop.

Example:
++++++++

From PatchSequenceApply output:

::

  pexpect.TIMEOUT: Timeout exceeded in read_nonblocking().
  <winpexpect.winspawn object at 0x02363790>
  version: 2.6 (1)
  command: plink.exe
  args: ['plink.exe', '-telnet', '127.0.0.1', '-P', '23']
  searcher: searcher_re:
    0: re.compile("Install\ Started\ for\ MAG\*3\.0\*163\ \:")
    1: re.compile("MAG\*3\.0\*163\ Installed\.")
    2: re.compile("Running Pre-Install Routine:")
    3: re.compile("Running Post-Install Routine:")
    4: re.compile("Starting Menu Rebuild:")
    5: re.compile("Installing Routines:")
    6: re.compile("Installing Data:")
    7: re.compile("Menu Rebuild Complete:")
    8: re.compile("Installing PACKAGE COMPONENTS:")
    9: re.compile("Send mail to: ")
    10: re.compile("Select Installation ")
    11: re.compile("Install Completed")
  buffer (last 100 chars):            ?[23;1H    0?[12;43H
  Update Imaging Index Terms with the latest Distribution (Y/N)? Y//
  before (last 100 chars):            ?[23;1H    0?[12;43H
  Update Imaging Index Terms with the latest Distribution (Y/N)? Y//
  <SNIP>

The timeout here required an update to the running of the pre-install routine
to answer the new question.

Resolution:
+++++++++++

The Patching process can be extended to allow questions like this to be
answered via the use of a 'Custom Installer'.  The custom installer is a
Python file which is added to the same directory as the patch. There are
some_ examples_ of Custom Installers available within the OSEHRA VistA
repository already.  The general structure of the file consists of a class
called ``CustomInstaller`` which extends upon the ``DefaultKIDSBuildInstaller``
class. Within that class, functions should be added which override or extend
the functions found in ``DefaultKIDSBuildInstaller`` to account for the new
information.

Writing a custom installer
~~~~~~~~~~~~~~~~~~~~~~~~~~

The Custom Installer does need a specific name in order to be picked up by the
automatic patching framework.  It should have the same name as the KIDS install
name of the patch, with the asterisks, ``*``, being replaced with underscores,
``_``. In the above example, the patch name is ``MAG*3.0*163``, which leads to
the custom installer file being named ``MAG_3.0_163.py``.

The declaration of the ``CustomInstaller`` class is essentially the same for
all instances with a single command that should be made specific to each
installer.  Just before the ``DefaultKIDSBuildInstaller.__init__`` function is
run, the program asserts that some information matches hard-coded text values
in the script, specicially the KIDS Install Name and the Sequence Number of the
patch.  Set these values for the specific patch. In the above example, the
patch name is ``MAG*3.0*163`` while the sequence number, taken from the
accompanying text file, is ``119``.

The next and final bit of customization is to write the functions or new
commands to answer the new prompts. For the above case, this would require
changing the ``runPreInstallationRoutine`` function.

::

  def runPreInstallationRoutine(self, connection, **kargs):
    connection.expect("Update Imaging Index Terms with the latest Distribution")
    connection.send("Y\r")

Another scenario, which has been encountered already, is the presence of an
additional prompt during the actual install process.  The custom installer used
in that scenario copied and modified the ``__handleKIDSInstallQuestions__``
function.  Here, new actions were added to the ``KidsMenuActionList`` list
which is used to monitor the progress of the install.

::

  def __handleKIDSInstallQuestions__(self, connection):
    connection.send("Install\r")
    connection.expect("Select INSTALL NAME:")
    <snip>
    if not result:
      return False
    kidsMenuActionLst = self.KIDS_MENU_OPTION_ACTION_LIST
    # Custom lines for the patch
    kidsMenuActionLst.append(("Maximum number of registry update subtasks", "", False))
    kidsMenuActionLst.append(("Suspend the post-install during the peak hours", "", False))
    kidsMenuActionLst.append(("Date/Time to run the new registry initialize task", "", False))
    # End custom lines
    while True:
    ...

Parsing reports a dependency cycle
###################################

The automatic patching framework attempts to install the KIDS builds with the
proper order. It takes into account the KIDS builds that are listed as required
in the documentation, the sequence number of the patch, and even order within a
multibuild KIDS patch.  If a cycle is detected, the framework will not install
the available patches until the cycle is broken.


Example
+++++++++
::

  2018-09-19 16:02:22,858 ERROR This is a cycle among these items:
  'ECX*3.0*153'
  'DG*5.3*895'
  'PSN*4.0*434'
  'PSN*4.0*433'
  'PSN*4.0*432'
  'PSN*4.0*365'
  'PXRM*2.0*57'
  'IB*2.0*538'
  'SD*5.3*620'
  'DVBA*2.7*191'
  'PSJ*5.0*304'
  'GMPL*2.0*46'
  'DENT*1.2*67'
  'XU*8.0*638'
  'LR*5.2*438'
  'VPR*1.0*4'
  'SD*5.3*621'
  'IBD*3.0*66'
  'OR*3.0*398'
  'XT*7.3*137'
  2018-09-19 16:02:22,858 ERROR Failed to sort patches: DAG is NOT acyclic
  2018-09-19 16:02:22,859 INFO Total patches are 0


Resolution
++++++++++

The above problem is a convergence of the extra dependencies causing a cycle of
dependencies.

Unfortunately, the solution so far have been to remove available information
from the parser's reach.  Tne solution for the above problem was to remove
patches from the most recent spreadsheet.


.. _some: https://github.com/OSEHRA/VistA/blob/master/Packages/Kernel/Patches/XU_8.0_599/XU_8.0_599.py
.. _examples: https://github.com/OSEHRA/VistA/blob/master/Packages/Clinical%20Reminders/Patches/PXRM_2.0_28/PXRM_2.0_28.py
.. _PatchOrderGenerator: PatchOrderGenerator.rst
.. _`Setup Script Environment`: HowtoSetupEnv.rst
