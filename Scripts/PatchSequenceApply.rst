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
   * ``-i -n "all"`` will apply all the patches

2. Apply patches up to specified patch installation name

   * just append ``-i -u <patch_install_name>``

3. Apply the specified patch and all required patches only

   * just append ``-i -o <patch_install_name>``
   * this option will ignore the dependencies that specified in the CSV files (see PatchOrderGenerator_ for more detail)

.. _PatchOrderGenerator: PatchOrderGenerator.rst
.. _`Setup Script Environment`: HowtoSetupEnv.rst
