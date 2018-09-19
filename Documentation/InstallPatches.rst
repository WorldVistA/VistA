Install FOIA Patches
====================

**--- These instructions are for Windows Caché environments only ---**


Update VistA
------------

Clone the latest version of master from the VistA_ and VistA-M_ repositories.

Create a local VistA branch, the name is not important.

Setup and Configure
~~~~~~~~~~~~~~~~~~~

`Set up the testing environment`_ using the TEST_VISTA_FRESH and
TEST_VISTA_SETUP options.

Run the `automated VistA import script`_ and, if necessary, configure_ VistA.

Save a copy of the configured Cache.dat so that a clean instance is available
without re-running the import script.

Download Patches
----------------

`Download FOIA patches`_ from the OSEHRA FOIA VistA site. Before doing any
processing, it is recommended to make a copy of the downloaded patches, so
they don't need to be downloaded again if something goes wrong.

Cleanup Line Endings
~~~~~~~~~~~~~~~~~~~~

Convert text files to LF-only newlines::

 find FOIA -regex '.*\.\(GBL\|GBLs\|KID\|KIDs\|KIDS\|kid\|kids\|TXT\|TXTs\|txt\|txts\)$' -print0 |
 xargs -0 fromdos

If you don't do this, when running the next script, you may see errors like::

  2017-12-20 07:28:25,391 WARNING Can not parse **INSTALL NAME**
  Traceback (most recent call last):
    File "Scripts/ConvertToExternalData.py", line 310, in <module>
      main()
    File "Scripts/ConvertToExternalData.py", line 296, in main
      converter.convertCurrentDir(result.inputDir)
    File "Scripts/ConvertToExternalData.py", line 230, in convertCurrentDir
      self.convertKIDSBuildFile(absFileName)
    File "Scripts/ConvertToExternalData.py", line 241, in convertKIDSBuildFile
      kidsParser.parseKIDSBuild(kidsFile)
    File "C:\Users\betsy.mcphail\development\VistA\Scripts\KIDSBuildParser.py", line 538, in parseKIDSBuild
      kidsBuild=self._curKidsBuild)
    File "C:\Users\betsy.mcphail\development\VistA\Scripts\KIDSBuildParser.py", line 236, in parseLines
      handler(lines, kidsBuild)
    File "C:\Users\betsy.mcphail\development\VistA\Scripts\KIDSBuildParser.py", line 266, in __handlePostInstallRoutine__
      if kidsBuild.postInstallRoutine:
  AttributeError: 'NoneType' object has no attribute 'postInstallRoutine'

Convert Large Files
~~~~~~~~~~~~~~~~~~~

Convert large files to content links referencing external data::

 python Scripts/ConvertToExternalData.py -i FOIA

Files 1 MiB or larger will be renamed to a ".ExternalData_SHA1_<SHA>" staging file.

**Note:** If the line endings are not properly converted, the
CovertToExternalData script may fail with errors like::

    2017-12-20 07:28:25,391 WARNING Can not parse **INSTALL NAME**
    Traceback (most recent call last):
      File "Scripts/ConvertToExternalData.py", line 310, in <module>
        main()
      File "Scripts/ConvertToExternalData.py", line 296, in main
        converter.convertCurrentDir(result.inputDir)
      File "Scripts/ConvertToExternalData.py", line 230, in convertCurrentDir
        self.convertKIDSBuildFile(absFileName)
      File "Scripts/ConvertToExternalData.py", line 241, in convertKIDSBuildFile
        kidsParser.parseKIDSBuild(kidsFile)
      File "C:\Users\betsy.mcphail\development\VistA\Scripts\KIDSBuildParser.py", line 538, in parseKIDSBuild
        kidsBuild=self._curKidsBuild)
      File "C:\Users\betsy.mcphail\development\VistA\Scripts\KIDSBuildParser.py", line 236, in parseLines
        handler(lines, kidsBuild)
      File "C:\Users\betsy.mcphail\development\VistA\Scripts\KIDSBuildParser.py", line 266, in __handlePostInstallRoutine__
        if kidsBuild.postInstallRoutine:
    AttributeError: 'NoneType' object has no attribute 'postInstallRoutine'

Rename ".ExternalData_SHA1_<SHA>" files to just the SHA, for example::

  mv .ExternalData_SHA1_4d8ef9763be16099e4a10ea67ba8812245c227d3 4d8ef9763be16099e4a10ea67ba8812245c227d3

and move the files to VistA ``.ExternalData/SHA1/`` directory. The
`patch installer script`_ will look here for files named *just* the SHA.
Alternatively, the script will also look in
``<VistADir>/Packages/<PackageName>/Patches/<PatchName>/.ExternalData_SHA1_<SHA>``.

Do *not* commit the external data files to the repository.

Populate Packages
~~~~~~~~~~~~~~~~~

Sort_ the new patches into the ``Packages/`` directory structure.

Add new files (excludes external data files) and commit changes so far to a
local branch.

Update Spreadsheet
~~~~~~~~~~~~~~~~~~

Follow the instructions in `Update Spreadsheet`_ to update the current year's
patch spreadsheet to the latest available version.

**Note:**: In January, the previous year's spreadsheet may also need to be
updated.

Move .csv file to the ``Packages/Uncategorized/`` directory and commit to local branch.

Patch Sequence
~~~~~~~~~~~~~~

Run the `patch installer script`_ from the VistA Scripts directory to verify
that all required patches are available. Choose the option to generate patch
sequence order with actually installing any of the patches::

  cd Scripts
  python PatchSequenceApply.py -p ../Packages -l C:\\Users\\betsy.mcphail\\development\\patch_output -S 1

If a required patch is not installed, download_ the missing patch and re-reun
the Cleanup_ steps described above. Copy the patch into the appropriate patch
directory and commit to the working VistA branch. Repeat until the patch
installer script completes with no errors.

For help with other potential errors, refer to `Potential Issues`_.

Commit any changes to the working VistA branch.

Apply Patches
~~~~~~~~~~~~~

Run the `patch installer script`_, this time with the option to install
patches::

  cd Scripts
  python PatchSequenceApply.py -p ../Packages -l C:\\Users\\betsy.mcphail\\development\\patch_output -S 1 -i -n all

Fix any errors and commit changes so far to the working VistA branch.

Create PR For VistA Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create a Gerritt PR for the VistA changes as desribed in the
`Contributor Git Instructions`_.

If the spreadsheet needed to be modified, note the lines that were changed or
removed in the commit message.

Update VistA-M
--------------

`Set up the testing environment`_ but this time, do *not* use the
TEST_VISTA_SETUP option.

Run the `automated VistA import script`_.

Save a copy of the configured Cache.dat so that a clean instance is available
without re-running the import script.

Install Patches
~~~~~~~~~~~~~~~

Run the `PatchIncInstallExtractCommit`_ script::

  python PatchIncrInstallExtractCommit.py PatchIncrInstallExtractCommit.sample.json

Example setup file::

  {
    "VistA_Connection":
    {
      "system": 1,
      "useSudo": false
    },
    "Patch_Apply":
    {
      "log_dir": "C:/Users/betsy.mcphail/development/patch_log",
      "input_patch_dir": "C:/Users/betsy.mcphail/development/VistA/Packages",
      "continuous": true
    },
    "M_Extract":
    {
      "temp_output_dir": "C:/Users/betsy.mcphail/development/patch_out",
      "log_dir": "C:/Users/betsy.mcphail/development/patch_log",
      "M_repo": "C:/Users/betsy.mcphail/development/VistA-M",
      "M_repo_branch": "master",
      "commit_msg_dir": "C:/Users/betsy.mcphail/development/patch_out"
    },
    "Backup":
    {
      "backup_dir": "C:/Users/betsy.mcphail/development/patch_out",
      "cache_dat_dir": "C:/InterSystems/Cache/mgr/VISTA",
      "auto_recover": true
    }
  }

Once the script completes (it will probably take several *days*), do a quick
scan of changes to VistA-M repository to make sure they look reasonable.

**Note:** There may be one or more uncommitted files with just a date change in
the VistA-M repo, this expected, the changes can be discarded.

Uncategorized files
~~~~~~~~~~~~~~~~~~~

Update Packages.csv to take into account the files that are in VistA-M
``Packages/Uncategorized/``.

Move the contents of the ``Packages/Uncategorized/Routines/`` and
``Packages/Uncategorized/Routines/Globals/`` subdirectories to the
``Packages/`` directory.

Run the PopulatePackages script *from the VistA-M Packages/ directory*::

  $ python ~/Work/OSEHRA/VistA/Scripts/PopulatePackages.py < ../Packages.csv

Make a commit with the updated Packages.csv and any moved files.

Update Packages.csv in the *VistA* directory to include any changes just made.
Revise the topic and push it back to Gerrit.

Create VistA-M Branch
~~~~~~~~~~~~~~~~~~~~~

Create a branch in the `OSEHRA VistA-M Sandbox`_ (e.g. OV_Nov_2017) and push
all of the VistA-M commits there.

**Note:** There will be several uncommitted files with just a date change in
the VistA-M repository. This is expected, these changes can be discarded.

Run Tests
~~~~~~~~~

`Set up the testing environment`_ using the TEST_VISTA_FRESH and
TEST_VISTA_SETUP options.

Run the `automated VistA import script`_.

Save a copy of the configured Cache.dat so that a clean instance is available
without re-running the import script.

`Run the tests`_.

**Note:** It is expected that some XINDEX tests will fail. It is worth a look
to see if there are any easy changes that can be made (e.g. change line number
in the exception list).

Test GUIs
~~~~~~~~~

Dowload and run the latest version of the `GUI installer`_. Right-click on each
GUI. Go to Properties / Update and change the ‘server’ (or equivalent) field to
'localhost'.

From the Cache terminal::

  ZN "VISTA"
  D STRT^XWBTCP(9430)
  D ^%SS

Vitals
++++++

#. Start Vitals Manager and login
#. Create a template
#. Add at least one vital
#. Set template as default
#. Save
#. Start Vitals Demo and login
#. Make sure the template that was just created is available (will select
   patient, etc)

BCMA
+++++
#. Start BCMA Parameters and login
#. Go to Division 6100
#. Select ‘BCMA Online’
#. Start BCMA (may need to start as admin the first time) and login

CPRS
++++
#. Start CPRS and login

If any of the GUIs need to be updated, new versions can be downloaded from:
https://foia-vista.osehra.org/Patches_By_Application



.. _VistA: https://github.com/OSEHRA/VistA
.. _VistA-M: https://github.com/OSEHRA/VistA-M
.. _`Set up the testing environment`: SetupTestingEnvironment.rst
.. _`automated VistA import script`: AutomatedVistAConfiguration.rst
.. _Configure: ConfigureCache.rst
.. _`Download FOIA patches`: ../Scripts/HowtoDownloadPatches.rst
.. _Sort: ../Scripts/HowtoPopulatePackages.rst
.. _`Patch installer script`: ../Scripts/PatchSequenceApply.rst
.. _Download: https://foia-vista.osehra.org/Patches_By_Application
.. _`PatchIncInstallExtractCommit`: ../Scripts/PatchIncInstallExtractCommit.rst
.. _`Potential Issues`: ../Scripts/PatchSequenceApply.rst#potential-issues
.. _`Contributor Git Instructions`: https://www.osehra.org/content/contributor-git-instructions
.. _`OSEHRA VistA-M Sandbox`: https://github.com/OSEHRA-Sandbox/VistA-M
.. _`Run the tests`: RunningandUploadingTests.rst
.. _`exception list`: AddingTests.rst#xindex-exceptions
.. _`GUI Installer`: http://code.osehra.org/files/clients/OSEHRA_VistA/Installer_For_All_Clients
.. _`Update Spreadsheet`: ../Scripts/HowtoUpdateSpreadsheets.rst
