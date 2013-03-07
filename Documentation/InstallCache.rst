Installing Caché
=================

.. role:: usertype
    :class: usertype

The following instructions were adapted from Nancy Anthracite\'s document entitled InstallingVistAWithSingleUserVersionCache5.2, which was created to guide a user through installing InterSystems Caché onto a Windows operating system. The instructions were using an older version of Caché; this uses the most recent trial version and shows the most recent Management Portal interface.

Trial versions of the Caché installer can be downloaded from http://download.intersystems.com/download/register.csp. This installation guide uses Caché 2011.1. If you already have a Caché installation and are looking to install VistA as an additional database, you do not have to re-install Caché. Please use your existing installation and pick up the instructions at the point where the folder is created within the mgr folder.

Download and Install Caché
--------------------------

Download the Caché installer from the above link and double click on the downloaded  .exe file. The first window that requires interaction is the Licensing Agreement shown in the figure below. Agree to the license in order to continue in the installation process.

.. figure:: http://code.osehra.org/content/named/SHA1/df177515-Cache2011License.png
   :align: center
   :alt:  Caché License Terms

The next window asks to set the directory in which Caché will be installed. Most users will be able to accept the default path. If more than one instance is found on the machine, the next instances will be denoted with a number appended to the end of the instance name.


.. figure:: http://code.osehra.org/content/named/SHA1/3c138d88-Cache2011InstallPath.png
   :align: center
   :alt:  Setting the installation path for Caché

Once the install directory is set, the installer will display a summary of the instance that will be installed in the process.
There is the option to enter a license if you have one, but this is not a required step for the current testing configuration.


.. figure:: http://code.osehra.org/content/named/SHA1/85434e9e-Cache2011InstallSummary.png
   :align: center
   :alt:  Summary of Caché installation options

After the installation has finished, the completion screen is shown.

.. figure:: http://code.osehra.org/content/named/SHA1/46c175c7-Cache2011InstallComplete.png
   :align: center
   :alt:  Final window of Caché Installation

The first sign of a correctly installed and running instance of Caché is the Caché Cube in the taskbar, like below.

.. figure:: http://code.osehra.org/content/named/SHA1/d3df0e66-Cache2011Cube.png
   :align: center
   :alt:  Screenshot of Caché Cube in taskbar.

Clicking on the Cube will open a menu that displays the options to interact with the Caché database.

.. figure:: http://code.osehra.org/content/named/SHA1/31e12788-Cache2011MenuDoc.png
   :align: center
   :alt:  The main menu that shows when the Caché Cube is clicked.

The next test to ensure that your Caché instance is working is to open the documentation. This will bring up the documentation home page in your default web browser.

.. figure:: http://code.osehra.org/content/named/SHA1/83e31c7b-Cache2011DocMainPage.png
   :align: center
   :alt:  Documentation font page in the web browser Google Chrome.


Configuring Caché
------------------

Once Caché is installed, it is time to create the proper folders and environment to run the VistA instance within Caché. The first step is to go to the mgr folder of Caché and create a new folder as shown below. This folder will hold the database file cache.dat that will contain the VistA routines and globals.


.. figure:: http://code.osehra.org/content/named/SHA1/0f2c2ab6-Cache2011MgrFldr.png
   :align: center
   :alt:  mgr folder prior to creation of VistA folder

As an example, the folder has been given the name \"VistA.\" While the choice of name has no bearing on the installation, the testing code requires that the Namespace chosen below in matches the folder name created in this step.

.. figure:: http://code.osehra.org/content/named/SHA1/18a90c5b-Cache2011MgrFldrVistA.png
   :align: center
   :alt:  mgr folder post-creation of VistA folder

At this point we are ready to stand up the VistA instance. Right click on the Caché cube and select Management Portal of Caché.

.. figure:: http://code.osehra.org/content/named/SHA1/1f2af02f-Cache2011MenuSysMgt.png
   :align: center
   :alt:  Management Portal link in Caché

This link will open a Management Portal web page.  Click on System Administration to show administrative options.

.. figure:: http://code.osehra.org/content/named/SHA1/747ca57e-Cache2011SysMgtMain.png
   :align: center
   :alt:  Main page of the Management Portal

System Administration shows those options that can be used to change the Caché system. Our goal is to use the Configuration function to create and initialize an empty database that can then be filled with the VistA routines and globals. Starting from :alt: , click on Configuration, System Configuration, and Local Databases to arrive at :alt: .

.. figure:: http://code.osehra.org/content/named/SHA1/f36ea51c-Cache2011SysAdminMenu.png
   :align: center
   :alt:  System Administration page of Management Portal

Create the database by clicking on the Local Databases tab and then selecting Go.

.. figure:: http://code.osehra.org/content/named/SHA1/f245cb17-Cache2011SysConfigMenu.png
   :align: center
   :alt:  System Configuration menu.

This resulting page contains the list of all of the local databases. All of the selections shown were created automatically during the installation of Caché. Create a new database by clicking on the \"Create New Database\" button. This will bring up a wizard.

.. figure:: http://code.osehra.org/content/named/SHA1/2cc2f9ea-Cache2011CreateDatabase.png
   :align: center
   :alt:  Local Databases page with pointer to Create New Database button.

Set the directory entry to the folder that you created and set the database name. We recommend using the same name as the folder, but this is not necessary. When satisfied, select \"Next\" to proceed.

.. figure:: http://code.osehra.org/content/named/SHA1/eacb4e1c-Cache2011DatabaseWizardName.png
   :align: center
   :alt:  First page of the Database Wizard.

It is not necessary to change any of the default settings to enable testing and we recommend simply hitting Finish to proceed.
However, if there are known required settings for the current site, these settings can be modified.

.. figure:: http://code.osehra.org/content/named/SHA1/a0ead746-Cache2011DatabaseWizardDetails.png
   :align: center
   :alt:  Details of the Database Wizard

Verify that the newly created database appears in the database listing.

.. figure:: http://code.osehra.org/content/named/SHA1/73ac678d-Cache2011ShowNewDatabase.png
   :align: center
   :alt:  Database listing with the inclusion of the recently created VistA database.

We now will configure the namespace for the newly created database. Navigate back to the System Configuration menu, click on the Namespaces option.

.. figure:: http://code.osehra.org/content/named/SHA1/24613b57-Cache2011ConfigureNameSpace.png
   :align: center
   :alt:  Choosing Namespaces from System Configuration Menu

Then, click on the \"Create New Namespace\" button to open a wizard.

.. figure:: http://code.osehra.org/content/named/SHA1/374ab649-Cache2011CreateNewNamespace.png
   :align: center
   :alt:  Namespace listing and button to create a new namespace.

In the wizard, enter the name of the namespace and then select the database created above. Be certain to name the Namespace the same as the folder created above. Click on \"Save\" to finish the Namespace creation and to return to the namespace listing.

.. figure:: http://code.osehra.org/content/named/SHA1/6ea5a988-Cache2011NamespaceForm.png
   :align: center
   :alt:  Choosing the name of the namespace and the database it maps to.

Verify that the new namespace is now in the list of current namespaces.

The next steps will be configuring the global and routine mappings, both of which are accessed from this page. We will focus on the global mapping first.

 .. figure:: http://code.osehra.org/content/named/SHA1/d5960250-Cache2011GlobalMappingSelect.png
    :align: center
    :alt:  Namespace listing with the new namespace in it. The boxes highlight the links for mapping globals and routines.

To create the new mapping, click on New Global Mapping.  This opens another configuration wizard.

.. figure:: http://code.osehra.org/content/named/SHA1/9fd55585-Cache2011NewGlobalMapping.png
   :align: center
   :alt:  Setting the Global Mapping.

For VistA, there is only one global mapping that needs to be made.
First set the Global Database location to the VistA database name, and for the Global Name enter \"%Z*\". This will map all globals that start with \"%Z\" to be specific to the VistA namespace. Click OK and the wizard will exit and display the new mapping in the window.
Be sure to click on Save Changes before navigating back to the Namespaces page.

.. figure:: http://code.osehra.org/content/named/SHA1/3330d488-Cache2011SetGlobalMapping.png
   :align: center
   :alt:  Adding the %Z* mapping to the globals.

Verify that the global mapping has been saved to the namespace.

.. figure:: http://code.osehra.org/content/named/SHA1/4c432905-Cache2011SaveGlobalMapping.png
   :align: center
   :alt:  Page displaying the newly mapped globals.

The final step before Caché is ready for the import is to map the routines. From within the Namespaces menu in the Management Portal, click on the Routine Mappings link.

.. figure:: http://code.osehra.org/content/named/SHA1/d12fc19d-Cache2011RoutineMappingSelect.png
   :align: center
   :alt:  Selecting the namespace mapping link.

This page will list the current routine mappings for the VistA namespace.
Much like the globals, there are no current mappings. Click on the New Routine Mapping button to bring up the routine mapping wizard.

.. figure:: http://code.osehra.org/content/named/SHA1/7df74cae-Cache2011NewRoutineMapping.png
   :align: center
   :alt:  Adding new Routine Mappings.

Again select the database location that corresponds to the VistA database, enter \"%DT*\" into the Routine name, and click Apply. This adds the first namespace mapping to the VistA database.

.. figure:: http://code.osehra.org/content/named/SHA1/614140b7-Cache2011SetRoutineMapping.png
   :align: center
   :alt:  Entering the first routine mapping.

There are six other mappings that need to be entered in the same manner -

+-------+
| %RCR  |
|       |
| %XU*  |
|       |
| %ZIS* |
|       |
| %ZO*  |
|       |
| %ZT*  |
|       |
| %ZV*  |
+-------+


After the final mapping is set, click OK to be sent back to the Routine Mapping page. You should now see the seven mappings listed on the page. Click on the Save Changes button.

.. figure:: http://code.osehra.org/content/named/SHA1/76ede01b-Cache2011SaveRoutineMapping.png
   :align: center
   :alt:  Final listing of Routine Mappings and the Save Changes button.

The final step of preparing the Caché installation for testing is to set the instance to allow TELNET service. This is done though the System Administration > Security > Services menu.

.. figure:: http://code.osehra.org/content/named/SHA1/494cd956-Cache2011ServicesMenu.png
   :align: center
   :alt:  Menu path to the Services option.

Click on Go to be brought to the menu which lists all services that are supported by Caché. Near the bottom of the list you will see the \"%Service_Telnet\" listing.

.. figure:: http://code.osehra.org/content/named/SHA1/8af9b9f4-Cache2011TelenetServiceoff.png
   :align: center
   :alt:  The list of Services available to Caché

Click on the link to bring up the \"Edit Service\" page (:alt: ).

.. figure:: http://code.osehra.org/content/named/SHA1/6f00d817-Cache2011TelnetServiceEdit.png
   :align: center
   :alt:  Edit Service page for %Service_Telnet.

To enable the Telnet session, simply check the box next to \"Service Enabled\" and then click \"Save\".

.. figure:: http://code.osehra.org/content/named/SHA1/b2fe0970-Cache2011EnableTelnetService.png
   :align: center
   :alt:  Enabling the Telenet service.

After saving, the Services menu will now show that the Telnet service is enabled.

.. figure:: http://code.osehra.org/content/named/SHA1/a354a916-Cache2011TelnetServiceEnabled.png
   :align: center
   :alt:  Services menu with Telnet enabled
