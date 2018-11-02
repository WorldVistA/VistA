unit fGMV_AddEditQualifier;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 3/02/09 12:04p $
*       Developer:    doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Form to add/edit qualifiers
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER/fGMV_AddEditQualifier.pas $
*
* $History: fGMV_AddEditQualifier.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/11/07    Time: 3:12p
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/APP-VITALSMANAGER
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:40p
 * Created in $/Vitals/VITALS-5-0-18/APP-VitalsManager
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:30p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/APP-VitalsManager
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 4:56p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsManager-503
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:21p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSMANAGER-503
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/26/04    Time: 1:09p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsManager
 * 
 * *****************  Version 7  *****************
 * User: Zzzzzzandria Date: 11/04/02   Time: 9:15a
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Version 5.0.0.0
 *
 * *****************  Version 6  *****************
 * User: Zzzzzzandria Date: 8/23/02    Time: 5:04p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * 
 * *****************  Version 5  *****************
 * User: Zzzzzzandria Date: 7/18/02    Time: 5:56p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * 1. Qualifier name case are the same as in Database
 * 2. Qualifier List for the category selected is updated after editing
 * the qualifier description
 * 3. Categories are kept in ListView and supplied with a hint if not
 * enough window space
 * 4. Tree view could not be stretched more then 300 pixels or shrunken
 * less then 150
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 7/09/02    Time: 5:00p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 6/13/02    Time: 5:14p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 6/06/02    Time: 11:10a
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Roll-up to 5.0.0.27
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 4/04/02    Time: 3:39p
 * Created in $/Vitals GUI Version 5.0/Vitals Manager
 *
 *
*
================================================================================
}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  uGMV_Common, Buttons, ExtCtrls, uGMV_FileEntry;

type
  TfrmGMV_AddEditQualifier = class(TForm)
    edtName: TEdit;
    edtAbbv: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    btnApply: TButton;
    procedure edtNameChange(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
    procedure edtAbbvExit(Sender: TObject);
    procedure edtAbbvEnter(Sender: TObject);
    procedure edtAbbvChange(Sender: TObject);
    procedure edtNameEnter(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure edtNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
  private
    FDD: string;
    FIENS: string;
    FQualifierRec: TGMV_FileEntry;
    FChangeMade: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGMV_AddEditQualifier: TfrmGMV_AddEditQualifier;

function NewQualifier: TGMV_FileEntry;
procedure EditQualifier(Qualifier: TGMV_FileEntry);

implementation

uses uGMV_Const
 , uGMV_Engine, system.UITypes
 ;

{$R *.DFM}

function NewQualifier: TGMV_FileEntry;
var
  s,
  aNewQualifier: string;
begin
  Result := nil;
  if InputQuery('New Qualifier', 'Qualifier Name (2-50 char):', aNewQualifier) then
    if aNewQualifier <> '' then
      begin
        s := addNewQualifier(aNewQualifier);
        if piece(s, '^', 1) = '-1' then
          begin
            MessageDlg('Unable to create qualifier'+#13+piece(s, '^', 2), mtError, [mbok], 0);
          end
        else
          begin
            Result := TGMV_FileEntry.CreateFromRPC(s);
            GMVQuals.Entries.AddObject(Result.Caption, Result);
            EditQualifier({Broker, }Result);
          end;
      end;
end;

procedure EditQualifier({Broker: TRPCBroker; }Qualifier: TGMV_FileEntry);
begin
  with TfrmGMV_AddEditQualifier.Create(Application) do
    try
      FQualifierRec := Qualifier;
      FDD := Qualifier.DDNumber;
      FIENS := Qualifier.IENS;
      edtName.Text := Qualifier.FieldData('.01');
      edtAbbv.Text := Qualifier.FieldData('.02');
      ShowModal;
    finally
      free;
    end;
end;

procedure TfrmGMV_AddEditQualifier.edtNameEnter(Sender: TObject);
begin
  FChangeMade := False;
  btnApply.Enabled := False;//AAN 06/12/02
end;

procedure TfrmGMV_AddEditQualifier.edtNameKeyPress(Sender: TObject; var Key: Char);
begin
//AAN 07/18/2002  if Key in ['a'..'z'] then
//AAN 07/18/2002    Dec(Key, 32);
end;

procedure TfrmGMV_AddEditQualifier.edtNameChange(Sender: TObject);
begin
  FChangeMade := True;
  btnApply.Enabled := True;//AAN 06/12/02
end;

procedure TfrmGMV_AddEditQualifier.edtNameExit(Sender: TObject);
var
  s: String;
begin
  if FChangeMade then
    begin
      s := validateQualifierName(FDD,FIENS,'.01',edtName.text);
      if piece(s, '^', 1) = '-1' then
        begin
          MessageDlg(piece(s, '^', 2), mtError, [mbOK], 0);
          edtName.Text := FQualifierRec.FieldData('.01');
          edtName.SetFocus;
        end;
      FChangeMade := False;
      btnApply.Enabled := False;//AAN 06/12/02
    end;
end;

procedure TfrmGMV_AddEditQualifier.edtAbbvEnter(Sender: TObject);
begin
  FChangeMade := False;
  btnApply.Enabled := False;//AAN 06/12/02
end;

procedure TfrmGMV_AddEditQualifier.edtAbbvChange(Sender: TObject);
begin
  FChangeMade := True;
  btnApply.Enabled := True;//AAN 06/12/02
end;

procedure TfrmGMV_AddEditQualifier.edtAbbvExit(Sender: TObject);
var
  s: String;
begin
  if FChangeMade then
    begin
      s := validateQualifierName(FDD,FIENS,'.02',edtAbbv.text);
      if piece(s, '^', 1) = '-1' then
        begin
          MessageDlg(piece(s, '^', 2), mtError, [mbOK], 0);
          edtAbbv.Text := FQualifierRec.FieldData('.02');
          edtAbbv.SetFocus;
        end;
      FChangeMade := False;
      btnApply.Enabled := False;//AAN 06/12/02
    end;
end;

procedure TfrmGMV_AddEditQualifier.btnApplyClick(Sender: TObject);
var
  i: Integer;
begin
  i := GMVQuals.Entries.IndexOfObject(FQualifierRec);// AAN 08/22/2002

  setQualifierName(FDD,FIENS,'.01',edtName.text);
  setQualifierName(FDD,FIENS,'.02',edtAbbv.text);

  FQualifierRec.Caption := FQualifierRec.FieldData('.01');
  try
    GMVQuals.Entries[i] := FQualifierRec.Caption;
  except
  end;
  btnApply.Enabled := False;//AAN 06/12/02
end;

procedure TfrmGMV_AddEditQualifier.btnOKClick(Sender: TObject);
begin
  btnApplyClick(Sender);
end;

end.
