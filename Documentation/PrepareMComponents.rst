Prepare M source for Import into instance
=========================================

.. role:: usertype
    :class: usertype

To acquire the VistA-M source tree, follow the instructions in
ObtainingVistAMCode_

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

.. _`VistA Testing Source Repository`: http://code.osehra.org/VistA.git
.. _`ObtainingVistAMCode`: ObtainingVistAMCode.rst
