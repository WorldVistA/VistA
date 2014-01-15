Installing GT.M
===============

.. role:: usertype
    :class: usertype

The GT.M binary and source code are available for download from SourceForge_.
This tutorial will use the binary package for GT.M for Linux systems. There
isn't much difference between the amd64 package and the x86 package as far as
installation goes.

Typically GT.M binary distributions follow the following convention:
gtm_V{versionid}_{platform}_{arch}_pro.tar.gz. An example using the latest
version of GT.M as of this writing is: ``gtm_V61000_linux_i686_pro.tar.gz``.

The downloaded file is a compressed package which will need to be extracted
before proceeding. The extraction can be in a location of your choice,
as during the installation process you will be able to set where the installed
files will be placed. We will follow the following convention for where to
install GT.M: /usr/lib/fis-gtm/{Version}_{Platform}. We will use the example:
``/usr/lib/fis-gtm/V61000_i686``

To create this folder structure

.. parsed-literal::

  $ :usertype:`sudo mkdir -p /usr/lib/fis-gtm/V61000_i686`

We now need to decompress the downloaded file. The directions below assume that
the downloaded GT.M distribution is in the current folder.

.. parsed-literal::

  $ :usertype:`tar xzf gtm_V61000_linux_i686_pro.tar.gz`

To install GT.M, run the ``configure.sh`` file from what was just extracted.
Since there will be changes made to the system, this step must be run as root or
using sudo privileges.  This will start an interactive series of questions
which will set up the GT.M installation for the system. See below for an
example of the start of the configuration script and the first prompt for the
user to enter information.

.. parsed-literal::

  $ :usertype:`sudo ./configure`
                       GT.M Configuration Script
  Copyright 2009, 2013 Fidelity National Information Services, Inc. Use of this
  software is restricted by the provisions of your license agreement.

  What user account should own the files? (bin)

For the first two options of the configuration, the account and group that
should own the GT.M files, type 'root'. At the prompt that asks
\"Should execution of GT.M be restricted to this group?\"  type 'n' for no,
which will let all users access the GT.M environment. See below for the entries
that should be set at this point in the configuration script.

.. parsed-literal::

  What user account should own the files? (bin) :usertype:`root`
  What group should own the files? (bin)        :usertype:`root`
  Should execution of GT.M be restricted to this group? (y or n)  :usertype:`n`
  In what directory should GT.M be installed?

The next prompt asks \"In what directory should GT.M be installed?\". Here
enter a directory that will be used to hold all of the GT.M files, these
instructions will put them into ``/usr/lib/fis-gtm/V61000_i686`` as described
above. If the folder that you specify does not exist, you will get a message
asking if you want to create it as part of the installation, you should answer
'y' for yes. If you give it a path to an existing folder, it will warn you that
some files may be overwritten during the installation process. Be sure to back
up important files in the specified directory in the case that something is lost
or select a different folder. If you created the directory earlier according to
these directions you should answer 'y'.

.. parsed-literal::

  In what directory should GT.M be installed? :usertype:`/usr/lib/fis-gtm/V61000_i686`
  Directory /usr/lib/fis-gtm/V61000_i686 exists.  If you proceed with this installation then
  some files will be over-written.  Is it okay to proceed? (y or n)    :usertype:`y`

The next prompt asks the user if they want to install UTF-8 (Unicode) support.
For VistA installations answer this question with 'n' for no. VistA doesn't
support running in a 100% UTF-8 environment.

.. parsed-literal::

  Installing GT.M...

  Should unicode support be installed? (y or n) :usertype:`n`

The next question asks if the user would like to create lowercase versions of
the utility M routines distributed with GT.M. We will answer 'n' for no to
ensure consistency in the M environment.

.. parsed-literal::

  All of the GT.M MUMPS routines are distributed with uppercase names.
  You can create lowercase copies of these routines if you wish, but
  to avoid problems with compatibility in the future, consider keeping
  only the uppercase versions of the files.

  Do you want uppercase and lowercase version of the MUMPS routines? (y or n) :usertype:`n`
  Compiling all of the MUMPS routines.  This may take a moment.

When installing GT.M in a 64 bit environment (amd64), an additional prompt will
be shown that asks if you want to remove the object files of the installed M
routines.  Removing these object files will make it necessary to add the
mentioned shared library to the gtmroutines environment variable instead of the
path to the GT.M distribution. Using the shared library is preferred in 64 bit
environments, so we recommend answering this question with 'n' for no.

.. parsed-literal::

  Object files of M routines placed in shared library /usr/lib/fis-gtm/V61000_amd64/libgtmutil.so
  Keep original .o object files (y or n)? :usertype:`n`


The installation of GT.M is nearly complete. The last prompt asks if the user
would like to remove the files in the current directory now that the
installation is finished. Answer the prompt with a 'y' for yes. The script will
then exit returning to the standard terminal prompt.

.. parsed-literal::

  Installation completed. Would you like all the temporary files
  removed from this directory? (y or n) :usertype:`y`
  $


Creation of Folder Structure
----------------------------

The next step is to create a directory that will contain the folders and files
necessary for VistA. We will roughly follow the process the
`createVistaInstance.sh`_ installation script uses to create a VistA instance.

We will create an instance owner user named 'vista' and create a home directory
for it:

.. parsed-literal::

  $ :usertype:`sudo useradd -c "vista instance owner" -m -U vista -s /bin/bash`

You should add yourself into the vista group by using the following command:

.. parsed-literal::

  $ :usertype:`sudo adduser YourUserName vista`

NOTE: you will need to logout and login again for this change to take effect.
You will need to do this before going any further.

Now we can create the required directory structure:

.. parsed-literal::

  $ :usertype:`sudo su vista -c "mkdir -p /home/vista/{r,r/V61000-i686,g,j,etc,etc/xinetd.d,log,tmp,bin,lib,www}"`

The directory structure follows community developed best practices by creating
directories for the following:

 * r - contains the M source code otherwise known as routines
 * r/V61000-i686 - contains the compiled object files \(\*.o\) for the routines
 * g - contains the M database otherwise known as globals
 * j - contains the M database journal files
 * etc - contains configuration files
 * etc/xinetd.d - contains the configuration files for xinetd.d
 * log - contains the GT.M logs
 * tmp - contains temporary files created by GT.M or VistA
 * bin - contains scripts used for running VistA
 * lib - contains symbolic links to GT.M and other libraries
 * www - contains any web applications developed for VistA

GT.M relies upon a collection of environment variables to tell it where the
routines and globals reside and other configuration information. We will define
a profile script which will contain the correct information so you won't have
to type it every time you want to use VistA.

We now have to create the symbolic link to the GT.M version we installed:

.. parsed-literal::

  $ :usertype:`sudo ln -s /usr/lib/fis-gtm/V61000_i686 /home/vista/lib/gtm`

In your favorite editor create the ``/home/vista/etc/profile`` file with the
following information:

.. parsed-literal::

  #!/bin/bash
  export gtm_dist=/home/vista/lib/gtm
  export gtm_log=/home/vista/log
  export gtm_tmp=/tmp
  export gtm_prompt=\"VISTA>\"
  export gtmgbldir=/home/vista/g/vista.gld
  export gtmroutines=\"/home/vista/r/V61000-i686(/home/vista/r) /home/vista/lib/gtm\"
  export gtm_zinterrupt='I \$\$JOBEXAM^ZU(\$ZPOSITION)'
  export gtm_lvnullsubs=2
  export PATH=$PATH:$gtm_dist

NOTE: If you installed a 64 bit GT.M and answered 'n' to this question during
GT.M installation: "Keep original .o object files" you will need to substitute
``/home/vista/lib/gtm`` with ``/home/vista/lib/gtm/libgtmutil.so``

The important bits of the above file are:

 * gtm_dist - the path to the GT.M installation
 * gtmgbldir - the path to the GT.M database
 * gtmroutines - the search path for routines (includes compiled object directories)
 * gtm_lvnullsubs - Don't allow null subscripts (follow the M standard)

All of the gtm variables are explained in the
`GT.M Administration and Operations Guide - Environment Variables`_

We now need to change the permissions of the above file to allow for execution,
and change the owner to the vista user and group.:

.. parsed-literal::

  $ :usertype:`chmod ug+x /home/vista/etc/profile`
  $ :usertype:`sudo chown vista:vista /home/vista/etc/profile`

We can now create a file that will create the initial database. This file
should be created at ``/home/vista/etc/db.gde`` with the following information:

.. parsed-literal::

  change -s DEFAULT -ACCESS_METHOD=BG -BLOCK_SIZE=4096 -ALLOCATION=200000 -EXTENSION_COUNT=1024 -GLOBAL_BUFFER_COUNT=4096 -LOCK_SPACE=400 -FILE=/home/vista/g/vista.dat
  add -s TEMP -ACCESS_METHOD=MM -BLOCK_SIZE=4096 -ALLOCATION=10000 -EXTENSION_COUNT=1024 -GLOBAL_BUFFER_COUNT=4096 -LOCK_SPACE=400 -FILE=/home/vista/g/TEMP.dat
  change -r DEFAULT -RECORD_SIZE=16368 -KEY_SIZE=1019 -JOURNAL=(BEFORE_IMAGE,FILE_NAME="/home/vista/j/vista.mjl") -DYNAMIC_SEGMENT=DEFAULT
  add -r TEMP -RECORD_SIZE=16368 -KEY_SIZE=1019 -NOJOURNAL -DYNAMIC_SEGMENT=TEMP
  add -n TMP -r=TEMP
  add -n TEMP -r=TEMP
  add -n UTILITY -r=TEMP
  add -n XTMP -r=TEMP
  add -n CacheTemp* -r=TEMP
  show -a

This file controls where the DEFAULT database is created. Creates another
database called 'TEMP' and maps TEMP, TMP, UTILITY, XTMP, and CacheTemp* to the
TEMP database. At the very end it will show the configuration for the databases.
All of these commands and options are explained in the
`GT.M Administration and Operations Guide - Global Directory Editor Commands`_.

We need to make sure ownership of the ``/home/vista/etc/db.gde`` file is
correct:

.. parsed-literal::

  $ :usertype:`sudo chown vista:vista /home/vista/etc/db.gde`

We can now use the ``db.gde`` file we just created to create the database definition
for us:

.. parsed-literal::

  $ :usertype:`sudo su vista -c "source /home/vista/etc/profile && /home/vista/lib/gtm/mumps -run GDE < /home/vista/etc/db.gde &> /home/vista/log/db.gde.log"`

This command will run as the vista user (``sudo su vista``), source the profile
we created earlier (to setup the required environment variables) and run the GDE
routine with ``/home/vista/etc/db.gde`` as its input
(``/home/vista/lib/gtm/mumps -run GDE < /home/vista/etc/db.gde``).

Now we can create the physical database files on disk with the following command:

.. parsed-literal::

  $ :usertype:`sudo su vista -c "source /home/vista/etc/profile && /home/vista/lib/gtm/mupip create"`

.. _SourceForge: http://sourceforge.net/projects/fis-gtm/
.. _`createVistaInstance.sh`: https://github.com/OSEHRA/VistA/blob/master/Scripts/Install/GTM/createVistaInstance.sh
.. _`GT.M Administration and Operations Guide - Environment Variables`: http://tinco.pair.com/bhaskar/gtm/doc/books/ao/UNIX_manual/ch03s02.html
.. _`GT.M Administration and Operations Guide - Global Directory Editor Commands`: http://tinco.pair.com/bhaskar/gtm/doc/books/ao/UNIX_manual/gdecmds.html
