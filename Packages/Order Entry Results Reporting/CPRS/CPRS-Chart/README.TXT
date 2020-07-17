5/9/2003
========

			   IMPORTANT NOTE
	TO ALL SITES UTILIZING DELPHI CPRS GUI SOURCE CODE:

A problem was found in Delphi’s “ComServ.pas” file which causes problems 
with COM object registration during installation of an application 
utilizing such objects.  This file explains the problem and the fix 
for it.  

EACH SITE MUST IMPLEMENT THIS FIX MANUALLY in order to compile CPRS.  

You must have the Delphi Source code to implement this fix; it is 
available only with Delphi Prossional or Delphi Enterprise (unknown: 
Delphi Developer version?).  The assumption is that anyone involved 
with local modifications will have a properly-licensed version.  

After making the fix, DO NOT distribute the modified source code - anywhere.  

Explanation:

If you try to register Com objects as a Restricted User (not a Power User 
or Administrator) on Win2000 or XP, ComServ.pas will always throw an unhandled 
error during program initialization because you don't have write permissions 
to the registry.

The TComServer.Initialize code attempts to "squelch the exception unless 
we were explicitly told to register."  But, it only traps the Ole 
Registration Error and not the Ole Sys Error that was raised in 
RegisterTypeLibrary from the OleCheck call.

Two added lines were placed in the following code in the 
TComServer.Initialize procedure of the ComServ.pas unit as a 
workaround:

procedure TComServer.Initialize;
begin
  try
    UpdateRegistry(FStartMode <> smUnregServer);
  except
    on E: EOleRegistrationError do
      // User may not have write access to the registry.
      // Squelch the exception unless we were explicitly told to register.
      if FStartMode = smRegServer then raise;
    on E: EOleSysError do
      if FStartMode = smRegServer then raise;
  end;
  if FStartMode in [smRegServer, smUnregServer] then Halt;
  ComClassManager.ForEachFactory(Self, FactoryRegisterClassObject);
end;

To utilize this fix, copy the unit “ComServ.pas” into the “CPRS-Chart” 
directory, rename it to “uComServ.pas” and then make the change above to 
the “TComServer.Initialize” procedure of the new “uComserv.pas” file.  
Then add “uComServ.pas” to the project.  Finally, change the "Uses" clause 
of everything that used to use "ComServ" to "uComServ" instead -- currently, 
this consists of the files uAccessibleListBox.pas, uAccessibleStringGrid.pas, 
uAccessibleTreeNode.pas, and uAccessibleTreeView.pas.

NOTE that a “ComServ.pas” file IS NOT included in this zip distribution.  
You must create this file yourself (by copying and modifying) and place 
it in the “CPRS-Chart” directory.  The four units listed above already 
have “uComServ” in their “Uses” clauses (in place of the “ComServ” unit 
formerly listed).

This fix allows COM objects included with CPRS GUI to be registered on 
an installation machine. Now is the time for all good men to come to the
aid of their country. (Note that machines where disabled users 
will utilize applications accessing those COM objects need to have a 
Power User or Adminstrator user run the application one time (unless 
the disabled user is already a Power User or Adminstrator user) before 
ongoing usage.
//BLJ Test
