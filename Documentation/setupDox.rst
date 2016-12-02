==========================================================================================
Instructions for Generating Visual Cross Reference Documentation with the OSEHRA Code Base
==========================================================================================

-------
Purpose
-------
This document describes the steps required to generate visual cross reference
documentation based on the OSEHRA open source VistA codebase from the OSEHRA
code repository.

The document comprises 4 sections corresponding to:

*  Setting up the environment
*  Generating necessary information
*  Run python script to generate the web based documentation.
*  Reviewing the results.

Setting up Environment
-----------------------
This documentation assumes that you have already set up the OSEHRA VistA
Testing Harness. If you have not done that yet, please follow the instructions
available under the
``Instructions for Establishing and Testing a VistA Installation`` section
of the `README.rst`_ in this same directory.

Summary of tools/code bases that are needed
*******************************************

+---------------+----------------+---------------+---------------+---------------+
| Tools (needed)| Web Link       | Cache/Win     | GT.M/Linux    | Cache/Linux   |
+---------------+----------------+---------------+---------------+---------------+
| Cmake(2.8)    | www.cmake.org  |       Y       |       Y       |      Y        |
+---------------+----------------+---------------+---------------+---------------+
| Python (2.7)  | www.python.org |      Y        |       Y       |      Y        |
+---------------+----------------+---------------+---------------+---------------+
|     Git       | www.git-scm.com|       Y       |       Y       |      Y        |
+---------------+----------------+---------------+---------------+---------------+

+-----------------+------------------+---------------+---------------+---------------+
| Tools (optional)| Web Link         | Cache/Win     | GT.M/Linux    | Cache/Linux   |
+-----------------+------------------+---------------+---------------+---------------+
|  Dot(Graphviz)  | www.graphviz.org |       Y       |      Y        |      Y        |
+-----------------+------------------+---------------+---------------+---------------+

+-----------------+------------------------+---------------+---------------+---------------+
|   Code Bases    |   Web Link             |   Cache/Win   |   GT.M/Linux  |  Cache/Linux  |
+-----------------+------------------------+---------------+---------------+---------------+
|   VistA         | code.osehra.org/gitweb |       Y       |      Y        |      Y        |
+-----------------+------------------------+---------------+---------------+---------------+
|   VistA-M       | code.osehra.org/gitweb |       Y       |      Y        |      Y        |
+-----------------+------------------------+---------------+---------------+---------------+

Terminology
***********

* **OSEHRA VISTA repository**: path to OSEHRA VistA code base directory.
* **VistA-M repository** : path to OSEHRA VistA-M code base directory
* **Cross Reference repository**: path to the Dox directory within the VistA repository
* **XINDEX Log Directory**: path to the generated XINDEX cross reference output directory.

Machine requirement:

* OS: Windows with Cache or Linux with GT.M or Cache
* CPU: At least Pentium 1.5GHZ
* Hard drive: at least 5 Gigabyte free disk space.
* Memory: at least 2G.


Generating Necessary Information
---------------------------------

Prepare M Source
****************

If the desired version of VistA to generate the Dox pages from is the OSEHRA
Certified version, then no other preparation is needed other than acquiring
the VistA-M source tree.

To generate the pages with a different VistA setup, such as a FOIA release or
release from another vendor, the routines and globals will need to be placed
into the structure of the VistA-M repository.

See `Prepare M Repository`_ for instructions on how to populate the VistA-M
repository from an installed MUMPS environment.

XINDEX based cross reference output and Fileman Schema
******************************************************
To configure the environment to to generate the XINDEX-based cross reference
output, please start the cmake-gui application from a previously set up testing
instance, and check the ``TEST_VISTA_DOX_CALLERGRAPH`` option.
Click the ``Configure`` and ``Generate`` buttons to finish.

.. figure::
   http://code.osehra.org/content/named/SHA1/e36229ab-DoxGUIWindows.png
   :align: center
   :alt:  Highlighted TEST_VISTA_DOX_CALLERGRAPH on Windows

Figure 1 - cmake-gui option for Windows

.. figure::
   http://code.osehra.org/content/named/SHA1/07f8c2f5-DoxGUILinux.png
   :align: center
   :alt:  Highlighted TEST_VISTA_DOX_CALLERGRAPH on Linux

Figure 2 - cmake-gui option for Linux

To verify that files are generated correctly, just go to the build directory
as specified in the cmake-gui, enter the following command:

.. parsed-literal::

 ctest -R CALLER -N

You should be able to see lines like below:

*The test number "TEST #..."  of the tests may be different*

.. parsed-literal::

  Test #156: CALLERGRAPH_Accounts_Receivable
  Test #157: CALLERGRAPH_Adverse_Reaction_Tracking
  Test #158: CALLERGRAPH_Asists
  Test #159: CALLERGRAPH_Authorization_Subscription
  Test #160: CALLERGRAPH_Auto_Replenishment_Ward_Stock
  Test #161: CALLERGRAPH_Automated_Information_Collection_System
  Test #162: CALLERGRAPH_Automated_Lab_Instruments
  Test #163: CALLERGRAPH_Automated_Medical_Information_Exchange
  Test #164: CALLERGRAPH_Barcode_Medication_Administration
  Test #165: CALLERGRAPH_Beneficiary_Travel
  Test #166: CALLERGRAPH_Capacity_Management\_-_RUM
  Test #167: CALLERGRAPH_Capacity_Management_Tools
  Test #168: CALLERGRAPH_Care_Management
  Test #169: CALLERGRAPH_Clinical_Case_Registries
  Test #170: CALLERGRAPH_Clinical_Information_Resource_Network
  Test #171: CALLERGRAPH_Clinical_Monitoring_System
  Test #172: CALLERGRAPH_Clinical_Procedures
  Test #173: CALLERGRAPH_Clinical_Reminders
  Test #174: CALLERGRAPH_CMOP


The next step is just to run the ctest command to generate the XINDEX output.
Depending upon the machine power, this could run from 10 minutes to more than
1 hour.  The command to start the tests running is the same as above, without
the -N notation:

.. parsed-literal::

  $ ctest -R CALLER

Once it is running, you should be able to see the progress output as below

Beginning of testing:

.. parsed-literal::

 $ ctest -R CALLER
        Start 156: CALLERGRAPH_Accounts_Receivable
  1/129 Test #156: CALLERGRAPH_Accounts_Receivable ......................................   Passed   41.86 sec
        Start 157: CALLERGRAPH_Adverse_Reaction_Tracking
  2/129 Test #157: CALLERGRAPH_Adverse_Reaction_Tracking ................................   Passed    9.76 sec
        Start 158: CALLERGRAPH_Asists
  3/129 Test #158: CALLERGRAPH_Asists ...................................................   Passed    7.92 sec
        Start 159: CALLERGRAPH_Authorization_Subscription
  4/129 Test #159: CALLERGRAPH_Authorization_Subscription ...............................   Passed    2.99 sec
        Start 160: CALLERGRAPH_Auto_Replenishment_Ward_Stock
  5/129 Test #160: CALLERGRAPH_Auto_Replenishment_Ward_Stock ............................   Passed    7.30 sec
        Start 161: CALLERGRAPH_Automated_Information_Collection_System

End of testing:

.. parsed-literal::

 121/129 Test #276: CALLERGRAPH_VistA_Web ................................................   Passed    1.12 sec
        Start 277: CALLERGRAPH_VistALink
 122/129 Test #277: CALLERGRAPH_VistALink ................................................   Passed    2.10 sec
        Start 278: CALLERGRAPH_VistALink_Security
 123/129 Test #278: CALLERGRAPH_VistALink_Security .......................................   Passed    1.63 sec
        Start 279: CALLERGRAPH_Visual_Impairment_Service_Team
 124/129 Test #279: CALLERGRAPH_Visual_Impairment_Service_Team ...........................   Passed    2.91 sec
        Start 280: CALLERGRAPH_Voluntary_Timekeeping
 125/129 Test #280: CALLERGRAPH_Voluntary_Timekeeping ....................................   Passed    6.57 sec
        Start 281: CALLERGRAPH_Web_Services_Client
 126/129 Test #281: CALLERGRAPH_Web_Services_Client ......................................   Passed    2.10 sec
        Start 282: CALLERGRAPH_Womens_Health
 127/129 Test #282: CALLERGRAPH_Womens_Health ............................................   Passed    7.50 sec
        Start 283: CALLERGRAPH_Wounded_Injured_and_Ill_Warriors
 128/129 Test #283: CALLERGRAPH_Wounded_Injured_and_Ill_Warriors .........................   Passed    1.63 sec
        Start 284: CALLERGRAPH_GetFilemanSchema
 129/129 Test #284: CALLERGRAPH_GetFilemanSchema .........................................   Passed  2000.42 sec

 100% tests passed, 0 test failed out of 129

All of the CALLERGRAPH tests should run successfully.  The GetFilemanSchema
test will take a fairly long time.  If the test runs longer than the CTest
timeout (25 minute runtime), it will stop execution and not all information
will be generated.  To run the script without a timeout, it can be executed
from the command line.

In the same directory as above, execute the following command:

.. parsed-literal::

  $ cmake -P Docs/CallerGraph/GetFilemanSchema.cmake

Fileman Database Calls
**********************

Finally, a single JSON file will need to be generated.  This file contains
information about the Database calls that routines make to query FileMan for
data.  This file is generated using a version of the RGI/PwC tool called the
`M Routine Analyzer`_ which has been modified by OSEHRA's Jason Li.

Download or clone the repository from the website that was linked above.  If
cloned using Git, be sure to switch to the ``fileman_json`` branch before
attempting to  compile the tool.

The ``M Routine Analyzer`` requires an environment variable which contains the
path to the repository of M code to query.  In most cases, this corresponds to
the `OSEHRA VistA-M Repository`_, but can be one of similar structure. The
program assumes that the path will be found in the ``VISTA-FOIA`` environment
variable.  This should be set prior to the running of the analysis.

**Warning:** a Bash/Windows shell will not allow environment variable names to
contain a hyphen character, ``-``.  To change the environment variable that the
tool looks for: change the string found in
``com/pwc/us/rgi/vista/repository/RepositoryInfo.java`` at `line 220`_.  Change
the text supplied as an argument in the ``System.getenv()`` call.  It should be
set to the preferred variable name.  Then you should compile the RepositoryInfo
class using the ``javac`` tool. The command to complie that class can be found
below:

::

  softhat@hostname: ~/rgivistatools/MParseAnalyze/src$
  $ javac com/pwc/us/rgi/vista/repository/RepositoryInfo.java

When an environment variable is generated and populated, compile the main java
file for the Routine Analyzer found in
``com/pwc/us/rgi/vista/tools/MRoutineAnalyzer.java``.

::

  softhat@hostname: ~/rgivistatools/MParseAnalyze/src$
  $ javac com/pwc/us/rgi/vista/tools/MRoutineAnalyzer.java

After compiling the tool, execute the class with a set of arguments:

::

  softhat@hostname: ~/rgivistatools/MParseAnalyze/src$
  $ java com/pwc/us/rgi/vista/tools/MRoutineAnalyzer repo filemancall -o ~/Work/OSEHRA/filemanDBCall.json

This will generate the Fileman Database JSON file at the path given to the
``-o`` argument.  Only basic status information will be printed to the screen
during the run of the analyzer.

Example run:

::

  softhat@hostname: ~/rgivistatools/MParseAnalyze/src$
  $ java com/pwc/us/rgi/vista/tools/MRoutineAnalyzer repo filemancall -o ~/Work/OSEHRA/filemanDBCall.json
    Oct 27, 2014 11:21:54 AM com.pwc.us.rgi.vista.tools.MRALogger logInfo
    INFO: Started filemancall.
    Oct 27, 2014 11:25:58 AM com.pwc.us.rgi.vista.tools.MRALogger logInfo
    INFO: Ended filemancall.

Generating HL7 and RPC interaction info
***************************************

An additional feature of the Dox pages is now available which connects the
information gathered for each routine with the Remote Procedure Calls (RPCs)
and HL7 messages the routine is used in.  To acquire this information,
run the ``FileManGlobalDataParser.py`` script to parse the information from
the ``REMOTE PROCEDURE`` and the ``PROTOCOL`` files.  This script can be found
in the ``Utilities/Dox/PythonScripts`` directory.

The usage information can be found by excuting the file with a ``-h`` argument

.. parsed-literal::

  $ python FileManGlobalDataParser.py -h
  usage: FileManGlobalDataParser.py [-h] -mr MREPOSITDIR -pr PATCHREPOSITDIR
                                  [-outdir OUTDIR] -gp GITPATH [-all]
                                  fileNos [fileNos ...]

  FileMan Global Data Parser
  positional arguments:
    fileNos               FileMan File Numbers

  optional arguments:
    -h, --help            show this help message and exit
    -outdir OUTDIR        top directory to generate output in html
    -gp GITPATH, --gitPath GITPATH
                        Path to the folder containing git excecutable
    -all                  generate all dependency files as well

  Initial CrossReference Generator Arguments:
    Argument for generating initial CrossReference

    -mr MREPOSITDIR, --MRepositDir MREPOSITDIR
                        VistA M Component Git Repository Directory
    -pr PATCHREPOSITDIR, --patchRepositDir PATCHREPOSITDIR
                        VistA Git Repository Directory

To generate the information for the Dox pages, we are going to supply two file
numbers to the script:

 ======================= =======================
         Numbers              Fileman File
 ======================= =======================
          101                  Protocol
          8994              Remote Procedure
 ======================= =======================

**Do not supply the** ``-all`` **argument to the command.**  An
example run of the command would look like the following:

.. parsed-literal::

  $ python FileManGlobalDataParser.py -mr ~/Work/OSEHRA/VistA-M -pr ~/Work/OSEHRA/VistA -gp /usr/local/bin -outdir ~/Work/OSEHRA/DataParserOut 101 8994

This command will write out a file called ``Routine-Ref.json`` which will need
to be supplied to the web page generation script.


Run python script to generate the web based documentation.
----------------------------------------------------------

OSEHRA has written a Python script to generate the HTML pages based upon the
results from the tests that were just run.  The python script can be found in
the OSEHRA VistA source tree in the ``Utilities/Dox/PythonScripts`` directory.

``WebPageGenerator.py`` is the python script that generates the Visual Cross
Reference pages. To get the help from the script, just type:

.. parsed-literal::

  $ [path to python]/python WebPageGenerator.py --help

That command will print the necessary arguments and flags that need to be set.

.. parsed-literal::

 $ python WebPageGenerator.py --help

 usage: WebPageGenerator.py [-h] -mr MREPOSITDIR -pr PATCHREPOSITDIR -xl
                           XINDEXLOGDIR -fs FILESCHEMADIR -db FILEMANDBJSON -o
                           OUTPUTDIR -gp GITPATH [-hd] [-dp DOTPATH] [-is]
                           [-lf OUTPUTLOGFILENAME] -rj RTNJSON [-dj DEPJSON]

 VistA Visual Cross-Reference Documentation Generator

 optional arguments:
  -h, --help            show this help message and exit
  -o OUTPUTDIR, --outputDir OUTPUTDIR
                        Output Web Page directory
  -gp GITPATH, --gitPath GITPATH
                        Path to the folder containing git excecutable
  -hd, --hasDot         is Dot installed
  -dp DOTPATH, --dotPath DOTPATH
                        path to the folder containing dot excecutable
  -is, --includeSource  generate routine source code page?
  -lf OUTPUTLOGFILENAME, --outputLogFileName OUTPUTLOGFILENAME
                        the output Logging file
  -rj RTNJSON, --rtnJson RTNJSON
                        routine reference in VistA Data file in JSON format
  -dj DEPJSON, --depJson DEPJSON
                        JSON file to store Package dependency information

 Initial CrossReference Generator Arguments:
  Argument for generating initial CrossReference

  -mr MREPOSITDIR, --MRepositDir MREPOSITDIR
                        VistA M Component Git Repository Directory
  -pr PATCHREPOSITDIR, --patchRepositDir PATCHREPOSITDIR
                        VistA Git Repository Directory

 Call Graph Log Parser Releated Arguments:
  Argument for Parsing XINDEX Call Graph logs

  -xl XINDEXLOGDIR, --xindexLogDir XINDEXLOGDIR
                        Input XINDEX log files directory, nomally
                        under${CMAKE_BUILD_DIR}/Docs/CallerGraph/

 Data Dictionary Parser Auguments:
  -fs FILESCHEMADIR, --fileSchemaDir FILESCHEMADIR
                        VistA File Man Schema log Directory

 FileMan DB Calls JSON file Parser Auguments:
  -db FILEMANDBJSON, --filemanDbJson FILEMANDBJSON
                        fileman db call information in JSON format

The following arguments are not optional, and must be set in the command
before it is able to run successfully.

* ``-xl`` or ``--xindexLogDir`` - path to the directory contains all the
  XINDEX-based cross reference output that are generated from ctest run
*  ``-fs`` or ``--fileSchemaDir`` - path to VistA FileMan Schema log Directory.

  *Note: both of the above directories are found in underneath the Build directory
  of the Testing Harness in the `Docs` directory*

* ``-mr`` or ``--MRepositDir``  - path to OSEHRA VistA-M git repository.
* ``-pr`` or  ``--patchRepositDir`` - path to the VistA Git source directory.

* ``-db`` or ``--filemanDbJson`` - fileman db call information in JSON format.
* ``-rj`` or ``--rtnJson``  -  path to the DataParser routine information in
  JSON format.
* ``-dj`` or ``--depJson`` - path to a file where the package dependency information
  will be stored

All other flags or arguments are optional, but do have an effect on the
output files.

* ``-is`` or ``--includeSource`` -  Flag to generate a web page with the source
  code for each routine
* ``-o`` or ``--outputDir`` - path to the directory to write the web pages into

  *Note: Ensure that the output directory exists prior to running, otherwise
  the script will fail*

* ``-gp`` or ``--gitPath``  - path to directory that contains git executable.

  *Note: not the the whole path of the git executable*

* ``-hd`` or ``--hasdot`` - Flag to denote that you want to generate the caller
  visualizations
* ``-dp`` or ``--dotpath`` -  path to the directory that contains the dot executable.

For debugging purpose, you can specify the output log file:

* ``-lf`` or ``--outputLogFileName`` - path to a file to log the output.

The follow figures show an example of the command looks like in Windows
Git Bash:

.. parsed-literal::

 $ python ./WebPageGenerator.py -xl ~/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log
     -mr ~/Work/OSEHRA/VistA-M/ -gp /bin/ -pr ~/Work/OSEHRA/VistA -is
     -o ~/CrossReference/ -hd -dp /usr/local/Graphviz2.30/bin/
     -fs  ~/Work/OSEHRA/VistA-build/Docs/Schema
     -db ~/Work/OSEHRA/filemanDBCall.json
     -rj ~/Work/OSEHRA/DataParserOut/Routine-Ref.json
     -dj ~/Work/OSEHRA/DataParserOut/PackageDep.json

and the example run of the analyzer:

.. parsed-literal::

 $ python ./WebPageGenerator.py -xl ~/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log
     -mr ~/Work/OSEHRA/VistA-M/ -gp /bin/ -pr ~/Work/OSEHRA/VistA -is
     -o ~/CrossReference/ -hd -dp /usr/local/Graphviz2.30/bin/
     -fs  ~/Work/OSEHRA/VistA-build/Docs/Schema
     -db ~/Work/OSEHRA/filemanDBCall.json
     -rj ~/Work/OSEHRA/DataParserOut/Routine-Ref.json
     -dj ~/Work/OSEHRA/DataParserOut/PackageDep.json
 2014-10-27 12:39:47,243 INFO Total # of Packages is 140
 2014-10-27 12:39:47,433 INFO Total Search Files are 2933
 2014-10-27 12:39:52,933 INFO Package: Uncategorized is new
 2014-10-27 12:39:53,211 INFO Total # of Packages is 141 and Total # of Globals is 2526, Total Skip File 0, total FileNo is 2526
 2014-10-27 12:39:53,727 INFO Total Search Files are 27485
 2014-10-27 12:39:55,744 INFO Total package is 141 and Total Routines are 27445
 2014-10-27 12:39:55,750 INFO Start paring log file /home/jasonli/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log\Accounts_Receivable.log]
 2014-10-27 12:39:58,757 INFO Start paring log file /home/jasonli/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log\Adverse_Reaction_Tracking.log]
 2014-10-27 12:39:59,536 INFO Start paring log file /home/jasonli/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log\Asists.log]
 2014-10-27 12:40:00,197 INFO Start paring log file /home/jasonli/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log\Authorization_Subscription.log]
 2014-10-27 12:40:00,358 INFO Start paring log file /home/jasonli/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log\Automated_Information_Collection_System.log]
 2014-10-27 12:40:03,842 INFO Start paring log file /home/jasonli/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log\Automated_Lab_Instruments.log]
 2014-10-27 12:40:06,230 INFO Start paring log file /home/jasonli/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log\Automated_Medical_Information_Exchange.log]
 2014-10-27 12:40:09,562 INFO Start paring log file /home/jasonli/Work/OSEHRA/VistA-build/Docs/CallerGraph/Log\Auto_Replenishment_Ward_Stock.log]

 <SNIP>
 2014-10-27 14:02:50,772 INFO Processing 23999 of total 27445
 2014-10-27 14:02:59,299 INFO Processing 24999 of total 27445
 2014-10-27 14:03:07,904 INFO Processing 25999 of total 27445
 2014-10-27 14:03:13,128 INFO Processing 26999 of total 27445
 2014-10-27 14:03:16,336 INFO End of generating individual routines......
 2014-10-27 14:03:16,463 INFO End of generating web pages....

Depending on the processing power of the machine, it could take from 25 minutes
to 2 hours to generate the whole web pages with dependency graph.

Source Code Highlighting
------------------------

To enable the color highlighting of the M routine source page, one additional
folder is necessary.  Copy the ``code_pretty_scripts`` directory from the
``Utilities/Dox/Web`` folder into the output web page directory.  The
folder contains code taken from the `google_code_prettify`_ repository which
is released under the Apache 2.0 license.

Stylesheet
----------

Copy the ``DoxygenStyle.css`` file from the Web directory (``Utilities/Dox/Web``) within
the VistA source tree to the output directory.

Reviewing the results
----------------------

To review the output web page, open the index.html file from your favorite web browser.

.. figure::
   http://code.osehra.org/content/named/SHA1/a9935090-localDox.png
   :align: center
   :alt:  Local copy of Dox pages

Figure 3 - Visual Cross Reference Web page.




.. _`README.rst`: ./README.rst
.. _`google_code_prettify`: https://github.com/google/code-prettify
.. _`M Routine Analyzer`: https://github.com/jasonli2000/rgivistatools/tree/fileman_json
.. _`OSEHRA VistA-M Repository`: https://github.com/OSEHRA/VistA-M
.. _`line 220`: https://github.com/jasonli2000/rgivistatools/blob/fileman_json/MParseAnalyze/src/com/pwc/us/rgi/vista/repository/RepositoryInfo.java#L220
.. _`Prepare M Repository`: ./populateMRepo.rst
