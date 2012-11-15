Howto Populate Packages
=======================

This document describes how to populate the ``Packages/`` directory structure
with new patches.

Populate Top Level
------------------

Copy new VistA patch files (.TXT/.KID) into the ``Packages/`` directory.
For example, one may move VA patches out of the ``FOIA/`` directory::

 find FOIA -type f -exec mv -n {} Packages ';'
 find FOIA -type d |sort -r |while read line; do rmdir "$line"; done

The top-level directory is a staging area for the next step.

Populate Directory Structure
----------------------------

Run the ``Scripts/PopulatePatchesByPackage.py`` script.  Redirect to its
standard input the ``Packages.csv`` file::

 cd Packages
 python ../Scripts/PopulatePatchesByPackage.py < ../Packages.csv
 cd ..

The script will move all ``*.TXT``, ``*.txt``, ``*.KID``, and ``*.KIDs`` files
into the directory structure (files with other extensions will not be moved).
It organizes files by patch and patches by package.

Files not identified as part of a patch will be moved to the
``Packages/Uncategorized/`` directory.  Manually classify the uncategorized
files and move them to their respective patch directories.  List every manual
move in the commit message to make it clear that files were manually placed.
