Installing GT.M
===============

.. role:: usertype
    :class: usertype

The GT.M system is available for download from SourceForge_. This will download a compressed package which will need to be extracted before proceeding. The extraction can be in a location of your choice, as during the installation process you will be able to set where the installed files will be placed.  To have a common place where the GT.M files will be placed, we first create a folder within the /opt/ directory which will hold the files. The command used to create the folder is shown below.

.. parsed-literal::

  $ :usertype:`sudo mkdir /opt/gtm`

The next step is to unzip and untar the downloaded files, which is assumed to be in the Downloads directory.

.. parsed-literal:

  $ :usertype:`gunzip gtm_V54002B_linus_i686_pro.tar.gz`
  $ :usertype:`tar -xf gtm_V54002B_linus_i686_pro.tar`
  $ :usertype:`ls`
  arch.gtc          GENOUT.m                Libgtmshr.so
  bin               GENOUT.o                lke
  CHK2LEV.m         geteuid                 lke.hlp

To install GT.M, run the configure.sh file from what was just extracted. Since there will be changes made to the system, this step must be run as root or using sudo privileges.  This will start an interactive series of questions which will set up the GT.M installation for the system. See below for an example of the start of the configuration script and the first prompt for the user to enter information.

.. parsed-literal::

  ~/Downloads$ :usertype:`sudo ./configure`
                       GT.M Configuration Script
  Copyright 2009, 2011 Fidelity National Information Services, Inc. Use of this
  software is restricted by the provisions of your license agreement.

  What user account should own the files? (bin)

For the first two options of the configuration, the account and group that would own the GT.M files, accept the default values. At the prompt that asks \"Should execution of GT.M be restricted to this group?\"  enter n, which will let all users access the GT.M environment. See below for the entries that should be set at this point in the configuration script.

.. parsed-literal::

  What user account should own the files? (bin) :usertype:`<ENTER>`
  What group should own the files? (bin)        :usertype:`<ENTER>`
  Should execution of GT.M be restricted to this group? (y or n)  :usertype:`N`
  In what directory should GT.M be installed?

The next prompt asks \"In what directory should GT.M be installed?\". Here enter a directory that will be used to hold all of the GT.M files, these instructions will put them into /opt/gtm. If the folder that you specify does not exist, you will get a message asking if you want to create it as part of the installation, you should answer yes. If you give it a path to an existing folder, it will warn you that some files may be overwritten during the installation process. Be sure to back up important files in the case that something is lost.

.. parsed-literal::

  In what directory should GT.M be installed? :usertype:`/opt/gtm`
  Directory /opt/gtm exists.  If you proceed with this intallation then
  some files will be over-written.  Is it okay to proceed? (y or n)    :usertype:`Y`

The next prompt asks the user if they want to install Unicode support. If you feel it will be necessary, it can be installed, but we will not do it in these instructions. Enter your answer to proceed.

.. parsed-literal::

  Installing GT.M...

  Should unicode support be installed? (y or n) :usertype:`n`

  All of the GT.M MUMPS routines are distributed with uppercase names.
  You can create lowercase copies of these routines if you wish, but
  to avoid problems with compatibility in the future, consider keeping
  only the uppercase versions of the files.

  Do you want uppercase and lowercase version of the MUMPS routines? (y or n)

Now that files are being installed, it asks if the user would like to keep both uppercase and lowercase versions of the MUMPS routines. We will answer no to maintain consistency between MUMPS and VistA. This will ensure that routine names for both environments are kept entirely in uppercase.

.. parsed-literal::

  Do you want uppercase and lowercase version of the MUMPS routines? (y or n) :usertype:`n`
  Compiling all of the MUMPS routines.  This may take a moment.

  GTM>
  %GDE-I-GDUSEDEFS, Using defaults for Global Directory
          /opt/gtm/gtmhelp.gld
  GDE>
  GDE>
  GDE>
  %GDE-I-VERIFY, Verification OK

  %GDE-I-GDCREATE, Creating Global Directory file
          /opt/gtm/gtmhelp.gld

  GDE>
  GDE>
  GDE>
  %GDE-I-VERIFY, Verification OK

  %GDE-I-GDCREATE, Creating Global Directory file
          /opt/gtm/gtmhelp.gld

  Installation completed. Would you like all the temporary files
  removed from this directory? (y or n)

Now the installation of GT.M is complete. The last prompt asks if the user would like to remove the files in the current directory now that the installation is finished. Answer the prompt with a y or n with your preference. The script will then exit returning to the standard terminal prompt.

.. parsed-literal::

  Installation completed. Would you like all the temporary files
  removed from this directory? (y or n) :usertype:`y`
  ~/Downloads$


Creation of Folder Structure
----------------------------

The next step is to create a directory that contains the folders and files needed to hold the VistA routines and globals that GT.M will use. We will create this folder in the /Downloads directory, but this is not the only location. This location will be used as the database directory for VistA. Make a folder called VistA. Inside of that VistA folder, create another folder named r. The r folder will hold the routines that GT.M will use when running VistA. These steps are shown below.

.. parsed-literal::

  ~/Downloads$        :usertype:`mkdir VistA`
  ~/Downloads$        :usertype:`cd VistA`
  ~/Downloads/VistA$  :usertype:`mkdir r`
  ~/Downloads/VistA$  :usertype:`mkdir o`
  ~/Downloads/VistA$

The next step is to define and create the database that will be used to hold the information needed in the VistA instance. The first step is to source the gtmprofile that was created in the installation of GT.M: source  /opt/gtm/gtmprofile

Once this is done we need to alter two environment variables that were just created to point the routines and globals to where the OSEHRA code base will reside. This will set up the environment variables needed to utilize GT.M from the command line. We will be changing the gtmgbldir entry and the gtmroutines entry. These control where the GT.M instance will look for globals and routines when it is running. These entries are set using the export command from the Linux terminal. The gtmgbldir should be set to the path to the VistA folder that was created above followed by \'database\'.  The gtmroutines will be set to contain two paths. The first is the path to the GT.M installation, in our case in the directory /opt/gtm/, and the path to the r folder within the VistA folder.
::

  export gtmgbldir =/path/to/VistA/database
  export gtmroutines="/home/osehra/Downloads/VistA/o(/home/osehra/Downloads/VistA/r) /opt/gtm/ \"

The example usage of these commands are found below:

.. parsed-literal::

  ~/Downloads$ :usertype:`source /opt/gtm/gtmprofile`
  ~/Downloads$ :usertype:`export gtmgbldir=/home/osehra/Downloads/VistA/database`
  ~/Downloads$ :usertype:`export gtmroutines="/home/osehra/Downloads/VistA/o(/home/osehra/Downloads/VistA/r) /opt/gtm."`
  ~/Downloads$

The next step is to run the GT.M Global Directory Editor (GDE), accessed via the command:

.. parsed-literal::

  ~/Downloads$ :usertype:`mumps -r GDE`
  %GED-I-LOADGD, Loading Global Directory file
          /home/osehra/Downloads/VistA/database.gld
  %GDE-I-VERIFY, Verification OK

  GDE>

This command starts the GDE and will change the prompt from the standard terminal one to \"GDE>\". Within the GDE environment, the default database location needs to be changed. Enter the command:::

  change -s DEFAULT -f=/home/$user/Downloads/VistA/database

replacing $user with your user name. After that command type exit and the changes will be applied.

.. parsed-literal::

  GDE> :usertype:`change \-s DEFAULT \-f=/home/osehra/Downloads/VistA/database`
  GDE> :usertype:`exit`
  %GDE-I-VERIFY, Verification OK

  %GDE-I-GDCREATE, Creating Global Directory file
          /home/osehra/Downloads/VistA/database.gld
  ~/Downloads$

The next step is to create the database that is used from within the VistA folder. This is done using the mupip command. Mupip stands for MUMPS Peripheral Interchange Program. It is used to manage the database and the global directories. We will use mupip to create a database and the Database Structure Editor (DSE) to configure the database in one command.::

  mupip create && dse change -f -key_max=2046 -rec=4096

The \"mupip create\" is what actually creates the database while the \"dse change -f -key_max=1023 -rec=4096\" changes the maximum size of a key which contains a global reference. If this is left at the default value of 255, certain globals will not be able to be imported.

.. parsed-literal::

  ~/Downloads$ :usertype:`cd VistA`
  ~/Downloads/VistA$ :usertype:`mupip create && dse change -f -key_max=1023 -rec=4096`
  Created file /home/osehra/Downloads/VistA/database.dat

  File    /home/osehra/Downloads/VistA/database.dat
  Region  DEFAULT

  ~/Downloads/VistA$

Now, the environment is set up to import the routines and globals from the OSEHRA code base.

.. _SourceForge: http://sourceforge.net/projects/fis-gtm/
