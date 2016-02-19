=================================
Populate the VistA-M Repository
=================================

.. role:: usertype
    :class: usertype

The VistA-M repository is used for many things within the OSEHRA Testing
Harness.  While most of these uses assume that the OSEHRA code is the desired
version of VistA to set up, this is not always the case.  There are times when
the structure of the VistA-M repository is needed but the content should belong
to a more recent FOIA release or the release of a community vendor.

Extract Routines and Globals
----------------------------

OSEHRA has written a Python script that will export the routines and globals
from an installed M[UMPS] environment and store the extracted files in the file
structure of the VistA-M repository. This script is named
`VistAMComponentExtractor.py` and is found in the `Scripts` directory of the
OSEHRA VistA repository.

Running `python VistAMComponentExtractor.py -h` will show the help for the
function and all necessary arguments:

.. parsed-literal::

 $ python VistAMComponentExtractor.py -h
   usage: VistAMComponentExtractor.py [-h] -S {1,2} [-CN NAMESPACE]
                                   [-CI INSTANCE] [-CU CACHEUSER]
                                   [-CP CACHEPASS] [-HN HOSTNAME]
                                   [-HT HOSTPORT] -o OUTPUTDIR -r VISTAREPO -l
                                   LOGDIR [-ro ROUTINEOUTDIR]

 VistA M Component Extractor

 optional arguments:
   -h, --help            show this help message and exit
   -o OUTPUTDIR, --outputDir OUTPUTDIR
                         output Dir to store global/routine export files
   -r VISTAREPO, --vistARepo VISTAREPO
                         path to the top directory of VistA-M repository
   -l LOGDIR, --logDir LOGDIR
                         path to the top directory to store the log files
   -ro ROUTINEOUTDIR, --routineOutDir ROUTINEOUTDIR
                        path to the directory where GT. M stores routines

 Connection Arguments:
   Argument for connecting to a VistA instance

   -S {1,2}, --system {1,2}
                         1: Cache, 2: GTM
   -CN NAMESPACE, --namespace NAMESPACE
                         namespace for Cache, default is VISTA
   -CI INSTANCE, --instance INSTANCE
                         Cache instance name, default is CACHE
   -CU CACHEUSER, --cacheuser CACHEUSER
                         Cache username for authentication, default is None
   -CP CACHEPASS, --cachepass CACHEPASS
                         Cache password for authentication, default is None
   -HN HOSTNAME, --hostname HOSTNAME
                         Cache telnet host, default is localhost(127.0.0.1)
   -HT HOSTPORT, --hostport HOSTPORT
                        Cache telnet service port, default is 23


An Intersystems Caché environment would use a `-S` value of 1 and would not
require the `-ro` argument, but may require a significant amount of connection
arguments.  An example usage from within a GitBash shell
could look like this:

.. parsed-literal::

  $python VistAMComponentExtractor.py -S 1 -CN "GOLD" -HT 25 -o ~/Desktop/Log
    -r ~/Work/OSEHRA/VistA-M -l ~/Desktop/Log

While a call on a system with GT.M, `-S 2`, could look like this utilizing the
`-ro` to send in the routine storage directory of GT.M:

.. parsed-literal::

  $python VistAMComponentExtractor.py -S 2 -ro ~/VistA-Instance/r/
  -o ~/Desktop/Log -r ~/Work/OSEHRA/VistA-M -l ~/Desktop/Log

Once the command is entered, the script proceeds to stop the VistA's background
tasks and then exports the routines and globals.  All current files (.zwr and .m)
are removed from the VistA-M source tree and the exported files are sorted
into their correct package folder. The entire process should take
approximately one hour.

An example start of the execution of the extractor script can be seen below:

.. parsed-literal::
  $python VistAMComponentExtractor.py -S 1 -CN "GOLD" -HT 25 -o ~/Desktop/Log
    -r ~/Work/OSEHRA/VistA-M -l ~/Desktop/Log
   2014-10-27 09:48:01,664 INFO Wait 30 seconds for Mailman backgroud filer to stop
   2014-10-27 09:48:33,326 INFO Wait 30 seconds for HL7 backgroud filer to stop
   2014-10-27 09:49:04,099 INFO Wait 30 seconds for Taskman to stop
   2014-10-27 09:49:34,105 INFO Extracting All Routines from VistA instance to /home/jasonli/Desktop/Log/Routines.ro
   2014-10-27 09:50:21,562 INFO Import ZGO routine to VistA instance
   <SNIP>

Update Packages.csv
-------------------

After the extraction of the routines and globals, the Packages.csv file found
in the top-level directory of the VistA-M source tree needs to be updated to
account for the new files in the Uncategorized directory.

This work may include:

* Adding/removing prefixes to existing packages
* Adding entirely new packages.
* Adding global entries to existing packages

Once Packages.csv has been updated, move the contents of the Uncategorized
`Routines` and `Globals` directories to the `Packages` directory.  We can
then re-sort the contents using the `PopulatePackages.py` script found in
the `Scripts` directory in the VistA source tree.

From the `Packages` directory run the following command:

.. parsed-literal::

 $ python ~/Work/OSEHRA/Scripts/PopulatePackages.py < ../Packages.csv

This will take the contents of the Packages.csv and use it to separate the
files in the current directory into their proper subdirectory.

An example run of the command is shown below:

.. parsed-literal::

 $ python ~/Work/OSEHRA/VistA/Scripts/PopulatePackages.py < ../Packages.csv
 21+PERIOD OF SERVICE.zwr => Registration/Globals/21+PERIOD OF SERVICE.zwr
 404.92+SCHEDULING REPORT DEFINITION.zwr => Scheduling/Globals/404.92+SCHEDULING REPORT DEFINITION.zwr
 82.13+DRG CC EXCLUSIONS.zwr => Uncategorized/Globals/82.13+DRG CC EXCLUSIONS.zwr
 PSPPI.zwr => Uncategorized/Globals/PSPPI.zwr
 QIP.zwr => Uncategorized/Globals/QIP.zwr
 GMR.zwr => Uncategorized/Globals/GMR.zwr
 DOPT.zwr => Uncategorized/Globals/DOPT.zwr
 XOB.zwr => Uncategorized/Globals/XOB.zwr
 ERRORS.zwr => Uncategorized/Globals/ERRORS.zwr
 DOSV.zwr => Uncategorized/Globals/DOSV.zwr
 MPR.zwr => Uncategorized/Globals/MPR.zwr

 $

In this example, some globals are moved into their respective packages while
others are moved back into the Uncategorized package.


Troubleshooting
---------------

Script Errors on Background Process Shutdown
++++++++++++++++++++++++++++++++++++++++++++

During the run of the VistAMComponentExtractor, the script attempts to shut
down some background processes within the VistA environment.  It accesses the
EVE menu to attempt to stop TaskMan, the MailMan background filer, and the HL7
background filer by accessing the XUP menus as the DUZ=1 user and accessing the
EVE menu.

In order to shut down the Mailman background filer,  the script attempts to
access the ``MailMan Master Menu`` which isn't one of the EVE options.
The DUZ=1 user needs to be given a ``SECONDARY MENU OPTION`` of ``XMMASTER`` in
order to access this menu from the EVE menu:

.. parsed-literal::

  VISTA> :usertype:`S DUZ=1 D Q^DI`

  VA FileMan 22.0


  Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES



  Input to what File: NEW PERSON// :usertype:`NEW PERSON`         (60 entries)
  EDIT WHICH FIELD: ALL// :usertype:`SECONDARY MENU OPTIONS`    (multiple)
     EDIT WHICH SECONDARY MENU OPTIONS SUB-FIELD: ALL//:usertype:`<enter>`
  THEN EDIT FIELD: :usertype:`<enter>`


  Select NEW PERSON NAME: :usertype:`\`1` USER,ONE     DBA
  Select SECONDARY MENU OPTIONS: :usertype:`XMMASTER`       MailMan Master Menu
    Are you adding 'XMMASTER' as a new SECONDARY MENU OPTIONS? No// :usertype:`Y`  (Yes)
    SYNONYM: :usertype:`<enter>`
  Select SECONDARY MENU OPTIONS: :usertype:`^`


Exporting to non-"VistA-M" directory
++++++++++++++++++++++++++++++++++++

If the wish is to export into a directory that isn't a copy of the VistA-M
repository, some things will be required to be available in order for the
script to proceed.

The minimal structure of an output directory requires the presence of:

* A directory named ``Packages``
* A copy of the ``Packages.csv`` file from the top level of the VistA
  repository

If these objects are not found, the script will throw an assertion error and
the execution of the script will stop.
