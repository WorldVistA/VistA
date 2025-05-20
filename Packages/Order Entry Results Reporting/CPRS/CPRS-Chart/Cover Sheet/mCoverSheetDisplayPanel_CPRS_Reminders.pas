unit mCoverSheetDisplayPanel_CPRS_Reminders;
{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-08
  *
  *       Description:  Customized display panel for Clinical Reminders.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Menus,
  Vcl.ImgList,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  iCoverSheetIntf,
  mCoverSheetDisplayPanel_CPRS,
  oDelimitedString;

type
  TfraCoverSheetDisplayPanel_CPRS_Reminders = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    fSeparator: TMenuItem;
    fReminderOptions: TMenuItem;
  protected
    { Inherited methods }
    function getTitle: string; override;
    procedure setTitle(const aValue: string); override;

    { Inherited events - TfraGridPanel }
    procedure OnPopupMenu(Sender: TObject); override;
    procedure OnPopupMenuInit(Sender: TObject); override;
    procedure OnPopupMenuFree(Sender: TObject); override;

    { Inherited events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
    procedure OnGetDetail(aRec: TDelimitedString; aResult: TStrings); override;

    procedure OnStartBackgroundLoad(Sender: TObject); override;
    procedure OnCompleteBackgroundLoad(Sender: TObject); override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_Reminders: TfraCoverSheetDisplayPanel_CPRS_Reminders;

implementation

uses
  uCore,
  uReminders,
  rReminders,
  fIconLegend,
  ORFn,
  ORNet,
  UResponsiveGUI;

const
  CUSTOM_TITLE = 'Clinical Reminders'; // The original title has column headers in it.

{$R *.dfm}


constructor TfraCoverSheetDisplayPanel_CPRS_Reminders.Create(aOwner: TComponent);
begin
  inherited;

  AddColumn(0, 'Reminder');
  AddColumn(1, 'Due Date');
  CollapseColumns;
end;

destructor TfraCoverSheetDisplayPanel_CPRS_Reminders.Destroy;
begin
  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Reminders.OnGetDetail(aRec: TDelimitedString; aResult: TStrings);
var
  aList: TStringList;
begin
  aList := TStringList.Create;
  try
    DetailReminder(aRec.GetPieceAsInteger(1), aList);
    aResult.Text := aList.Text;
  finally
    FreeAndNil(aList);
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Reminders.OnAddItems(aList: TStrings);
var
  aRec: TDelimitedString;
  aStr, temp: string;
begin
  try
    lvData.Items.BeginUpdate;
    for aStr in aList do
    begin
      aRec := TDelimitedString.Create(aStr);
      try
        if lvData.Items.Count = 0 then
          if aRec.GetPieceIsNull(1) and (aList.Count = 1) then
          begin
            CollapseColumns;
            lvData.Items.Add.Caption := aRec.GetPiece(2);
            Continue;
          end
          else if aRec.GetPieceEquals(1, '0') then
          begin
            CollapseColumns;
            lvData.Items.Add.Caption := aRec.GetPiece(2);
            Break;
          end
          else
            ExpandColumns;

        temp := aRec.GetPiece(6);
        if (temp <> '1') and (temp <> '3') and (temp <> '4') then
          Continue;
        // if aRec.GetPieceIsNotNull(3) then
        with lvData.Items.Add do
        begin
          Caption := aRec.GetPiece(2);
          if (temp = '1') and aRec.GetPieceIsDouble(3) then
            SubItems.Add(FormatDateTime('MMM DD, YYYY',
              aRec.GetPieceAsTDateTime(3)))
          else if temp = '3' then
            SubItems.Add('Error')
          else if temp = '4' then
            SubItems.Add('CNBD')
          else
            SubItems.Add(aRec.GetPiece(3));
          Data := aRec;
          aRec := nil;
        end;
      finally
        if assigned(aRec) then
          FreeAndNil(aRec);
      end;
    end;
    RemindersEvaluated(TStringList(aList));
    if InteractiveRemindersActive then
      begin
        RemindersStarted := TRUE;
        LoadReminderData(CoverSheetRemindersInBackground);
      end;
  finally
    lvData.Items.EndUpdate;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Reminders.OnStartBackgroundLoad(Sender: TObject);
begin
  inherited;
  CoverSheetRemindersInBackground := TRUE;
  CoverSheet.OnRefreshReminders(Sender);
  TResponsiveGUI.ProcessMessages;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Reminders.OnCompleteBackgroundLoad(Sender: TObject);
begin
  inherited;
  CoverSheetRemindersInBackground := False;
  CoverSheet.OnRefreshReminders(Sender);
  TResponsiveGUI.ProcessMessages;
end;

function TfraCoverSheetDisplayPanel_CPRS_Reminders.getTitle: string;
begin
  Result := CUSTOM_TITLE;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Reminders.OnPopupMenu(Sender: TObject);
var
  aRec: TDelimitedString;
begin
  inherited;

  aRec := ListViewItemRec;

  if Assigned(aRec) then
    begin
      // Asterick is needed for the ReminderMenuBuilder method.
      ReminderMenuBuilder(fReminderOptions, '*' + aRec.GetDelimitedString, False, False, False);
      fReminderOptions.Enabled := TRUE;
    end
  else
    fReminderOptions.Enabled := False;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Reminders.OnPopupMenuFree(Sender: TObject);
begin
  FreeAndNil(fSeparator);
  FreeAndNil(fReminderOptions);
  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Reminders.OnPopupMenuInit(Sender: TObject);
begin
  inherited;
  fSeparator := NewLine;
  fReminderOptions := NewItem('Reminders Options ...', 0, False, False, nil, 0, 'pmnReminderOptions');
  pmn.Items.Add(fSeparator);
  pmn.Items.Add(fReminderOptions);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Reminders.setTitle(const aValue: string);
begin

  lblTitle.Caption := CUSTOM_TITLE;
  pnlVertHeader.Caption := CUSTOM_TITLE + ' minimized';
  pnlWorkspace.Caption := CUSTOM_TITLE;

end;

end.
