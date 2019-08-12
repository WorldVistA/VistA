2009-02-18 zzzzzzandria
	Package: VitalsGUI
	Version: 5.0.23.6
	Internat version: TBD
	Comments:
		This version will address 508 complience Issue Matrix


2009-01-20 zzzzzzandria
	Package: Vitals GUI
	Version: 5.0.23.5
	Internal version: 01/20/09 16:30
	Comments:
		Updated version of patch 23. CASMED support.
		"/casmed=PORTn" parameter added. Set "n" to the port number to search for CASMED
		If no parameter speciied the application will search ports COM1..COM8
		 

2008-10-16 zzzzzzandria
	Package: Vitals GUI
	Version: 5.0.23.4
	Comments:
		Updated version of patch 23 includes CASMED VSM support.
		The directory structure of the source code was updated. 
		Not used source files were removed.

	Issues fixed:

	Issue: 
		The DLL uses time of workstation as the time the data was enetered.
	Fix:
		Time is taken from the server.


2008-07-29 zzzzzzandria
	Package: Vitals GUI
	Version: 5.0.23.3
	Comments:
		Patch 23 includes all updates of P22 plus changes needed for CP Flowsheets support.
		Vitals GUI adds a line to the data grid identifying the source of data (GMV or CliO)
		Most of the changes of P23 are controlled by preconditional PATCH_5_0_23.
		In case you need to roll back to P22 it is recommended to use the source code of P23 
            with the preconditional PATCH_5_0_22

2007-07-18 zzzzzzandria

	Application: VitalsManager
	Application version: 5.0.7.1
	Issue:
		If the VitalsManager application version is not compatible with the server,
		The runtime Error 216 is fired on exit of the app. 
	Fix:
		Project code updated to provide proper initialization of ccrContextor.



This Project contains source code of Vitals GUI v. 5.0.18.

NOTE:

1. The originally code was compiled with the version 6 of Delphi.
(Version 6.0 (Build 6.240) Update Pack 2)

To compile with the Delphi 6.0 (Build 6.163) use *.dcu files 
from XML subdirectory of the project

2. Vitals GUI uses the next external packages:
	- RPC Broker
	- OrCtrl (CPRS components)
	- CCR-Contextor (CCR Project)
	- OrpheusLite (Requeired by CCR)

Install the OrCtrl, OrpheusLite and CCR-Components before compilation.

3. Subdirectories

CCR-COMPONENTS 

Vitals uses TCCRContextor to support CCOW standard.
The component was originally developed for Clinical Case Registry (CCR) package. 
The Vitals package uses early version of CCR-Components. The source code of this version could is in the CCR-COMPONENTS subdirectory of "Vitals GUI 2007" project.
Most recent version of the component could be found in CCR v. 1.5 directory of VSS DB

OrCtrl

CPRS GUI components. Ignore this directory if the OrCtrl is installed on you PC.

OrpheusLite

GUI Components required to compile CCR-COMPONENTS package.
Install this package before compiling the CCR-COMPONENTS.

Vitals-5-0-18

Source code of:

	- Vitals User
	- Vitlas Manager
	- GMV_VitalsViewEnter (Vitals Lite DLL)


XML

DCU files required for Vitals compilation not included in Delphi 6.0 Build 6.163 (CD) 

------------
zzzzzzandria
 2007-05-17
------------