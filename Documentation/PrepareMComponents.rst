Prepare M Components for Import
===============================

.. role:: usertype
    :class: usertype


The VistA-FOIA source tree contains VistA M components including routines and globals represented as host files.
These files must be prepared for import into a M database instance to run VistA. The Packages folder contains all
of the VistA FOIA software divided by package name. Inside each package directory lies a Routines directory and a
Globals directory. The latter contains globals divided up by the FileMan files they contain.

Execute the following two commands to prepare the data for import.  One command utilizes a python file called PackRO.py, found in the
Scripts directory of the VistA source tree.

.. parsed-literal::

  VistA-FOIA$ :usertype:`git ls-files -- "\*.m" | python /path-to/VistA/Scripts/PackRO.py > VistAroutines.ro`

This will create a very large .ro file which contains the contents of the .m files that are contained in the source tree.

.. parsed-literal::

  VistA-FOIA$ :usertype:`git ls-files -- "\*.zwr" > globals.lst`

The globals.lst will contain a list of paths to the .zwr files in the source tree.

The first command lists all the files that have the extension \'.m\' and passes those names to the python script PackRO.py to pack them into a file named VistAroutines.ro. The second command lists all files that have the extension \'.zwr\' and writes those into a file named globals.lst. This list will be read by the OSEHRA ZGI routine during the import step.

Also, there is a set of OSEHRA routines that have been written to handle the importing and exporting of globals in the ZWR format.
These two routines are found in the Scripts directory of the VistA source tree.  They must be packed and imported like the
other VistA routines before the globals can be imported.

To pack the routines, run a modified version of the pack command found above:

.. parsed-literal::

  VistA$ :usertype:`git ls-files -- "Scripts/\*.m" | python Scripts/PackRO.py > OSEHRAroutines.ro`
