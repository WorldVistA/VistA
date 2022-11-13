;Message file for CPRSChart.exe
;Created September 3, 2020 for VA by Favor TechConsulting
;
Messages

@msgVersionInfo
Message file for CPRSChart.exe, Created 9/3/2020, Updated 6/7/2021
@@

@msgLeaveTextBox 
Use control-tab or control-shift-tab to leave this edit box.
@@

@msgHelpInfo
CPRSChart Scripts Version 12 - Created 6/7/2021

The following keystrokes are available for use within CPRS:

General:
Screen Sensitive Help....%keyfor(HotKeyHelp)
Change to next CPRS Page...%keyfor(VA508SendCustomCommand(1))
Change to prior CPRS Page...%keyfor(VA508SendCustomCommand(2))
Shows Title of Current Window...%keyfor(VA508SendCustomCommand(3))
Maximize Window...%keyfor(WindowMaximize)

Select New Patient...%keyfor(SelectNewPatient)
Show Demographic Information...%keyfor(OpenDemographics)
Open an Encounter...%keyfor(OpenEncounterWindow)
	
Click the OK button...%keyfor(PressOKButton)
Press Quit Button...%keyfor(PressQuitButton)

Open Consult Toolbox...%keyfor(ShowConsultToolbox)

Coversheet Tab:
Open Cover Sheet List Item...%keyfor(OpenListItem)
Refresh Cover Sheet List...%keyfor(RefreshListView)
Open the Primary Care provider information panel...%keyfor(OpenPrimaryCareDialog)
	
Notes Tab:
Show Progress Note Text...%keyfor(ShowNoteText)
Move to the Header and Text of a progress note...%keyfor(MoveToCurrentNote)
Move to Progress Note Text...%keyfor(MoveToNotesText)
Move to Progress Note Subject...%keyfor(MoveToSubjectLine)
Return to Progress Note List...%keyfor(ReturnToNotesList)
Create a new note...%keyfor(MoveToNewNote)	

Orders Tab:
Move to Main List...%keyfor(MoveToOrdersList)
Accept Order...%keyfor(PressAcceptOrderButton)
Accept Order (alternative)...%keyfor(PressAcceptButton)

In lists:
Left Click Cell...%keyfor(ltLeftClickCell)
Right Click Cell...%keyfor(ltRightClickCell)
Sort column...%keyfor(ltLeftClickHeader)
Right Click Header...%keyfor(ltRightClickHeader)

In tree views:
Edit item...%keyfor(f2editTreeNode)

The following keystrokes are for troubleshooting purposes:

Show Current Application Configuration...%keyfor(ShowActiveConfiguration)
Speak information about control in focus...%keyfor(SpeakControlInfo)
Speak Window Class Name...%keyfor(SayWindowsClass)
Speak Real Window Class Name...%keyfor(SayRealWindowClass)

Press Escape to close this window
@@

EndMessages
