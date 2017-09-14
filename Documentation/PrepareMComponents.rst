Prepare M source for Import into instance
=========================================

.. role:: usertype
    :class: usertype

To acquire the VistA-M source tree, follow the instructions in
ObtainingVistAMCode_

The following step is only required for InterSystems Caché Single-User or small
license count licenses:

Edit `ZU.m`_,  located in /Packages/Kernel/Routines/, and comment out the code
followed by JOBCHK tag by placing a semi-colon (;) right after JOBCHK tag.

.. parsed-literal::

  JOBCHK :usertype:`;` I $$AVJ^%ZOSV()<3 W $C(7),!!,"\*\* TROUBLE \*\* - \*\* CALL IRM NOW! \*\*" G H

Similarly, edit `ZUONT.m`_, also located in /Packages/Kernel/Routines/, and comment out the following code.

.. parsed-literal::

   :usertype:`;` I $$AVJ^%ZOSV()<3 W $C(7),!!,"\*\* TROUBLE \*\* - \*\* CALL IRM NOW! \*\*" G HALT

Note: If somehow ZU.m does not exist, it is OK to just make change to ZUONT.m.

Within the VistA-M source tree, there is a Packages folder which contains all of
the VistA M components divided by package name. Inside each package directory
lies a 'Routines' directory and a 'Globals' directory. The 'Routines' directory
contains the routines, while the latter contains globals divided into the
FileMan files they contain.

We have written a python file, found in the Scripts directory in
`VistA Testing Source Repository`_, which will create the two necessary files
that will be used to perform the actual import process.  The required
arguments are a list of the full path to directories that contain M components
files. During the execution, these directories, and all subdirectories below
them, will be searched for components to pack.

An example usage follows

.. parsed-literal::
  cd </path/to/VistA>
  VistA$ :usertype:`python Scripts/PrepareMComponentsForImport.py "C:/path-to/VistA-M" "Scripts"`

The script will find all files in the VistA-M directory that have the extension
\'.m\' and passes those names to the python script PackRO.py to pack them into
file routine.ro.  It will also find two OSEHRA specific routines ZGI and ZGO
which are used to import and export globals.  These routines are found in the
VistA/Scripts directory.  The scripts last step is to find all files that have
the extension \'.zwr\' and write the file location of those globals in a file
called 'globals.lst'. This 'globals.lst' will be read by the OSEHRA ZGI routine
during a later import step.

.. _ZUONT.m: http://code.osehra.org/gitweb?p=VistA-M.git;a=blob;f=Packages/Kernel/Routines/ZUONT.m
.. _ZU.m: http://code.osehra.org/gitweb?p=VistA-M.git;a=blob;f=Packages/Kernel/Routines/ZU.m
.. _`VistA Testing Source Repository`: http://code.osehra.org/VistA.git
.. _`ObtainingVistAMCode`: ObtainingVistAMCode.rst
