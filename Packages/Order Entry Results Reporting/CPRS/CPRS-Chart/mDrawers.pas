unit mDrawers;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORCtrls, ComCtrls, Buttons, ExtCtrls, Menus, ActnList,
  uTemplates, ORClasses, System.Actions, U_CPTPasteDetails;

type
  // Indicates what a drawer is doing at the moment
  TDrawerState = (dsEnabled, dsDisabled, dsHidden, dsOpen);

  // Drawer listing
  TDrawer = (odNone, odTemplates, odEncounter, odReminders, odOrders);
  TDrawers = set of TDrawer;

(*  {TTabOrder - class used to handle tabbing on an irrregular form,
               may need to be moved to it's own unit someday.}
  TTabOrder = class(TWinControl) // only reason it's a win control is so FindNextControl will work.
  private
    fData: array of TWinControl;
    function GetData(AnIdx: integer): TWinControl;
    procedure SetData(AnIdx: integer; const Value: TWinControl);
  public
    Count: integer;                                                        // holds the number of controls in the list
    Above: TWinControl;
    Below: TWinControl;
    constructor CreateTabOrder(AboveCtrl, BelowCtrl: TWinControl);         // creates and assigns the boundaries for the control list
    property Data[AnIdx: integer]: TWinControl read GetData write SetData; // holds the controls in the list
    procedure Add(AControl: TWinControl);                                  // add a control to the bottom of the list
    procedure Clear;                                                       // clear out the list; does not affect the controls referenced in the list
    function Next(AControl: TWinControl): TWinControl;                     // finds the next control in the tab order
    function Previous(AControl: TWinControl): TWinControl;                 // finds the previous control in the tab order
    function IndexOf(AControl: TWinControl): integer;                      // locates the position of a control in the list
    procedure Swap(IndexA, IndexB: integer);
    procedure PromoteAboveOther(ControlA, ControlB: TWinControl);
  end;*)
  TDrawerEvent = procedure(ADrawer: TDrawer; ADrawerState: TDrawerState) of object;
  TTemplateEditEvent = procedure of object;

  TDrawerConfiguration = record
    TemplateState: TDrawerState;  // state of the template drawer
    EncounterState: TDrawerState; // state of the encounter drawer
    ReminderState: TDrawerState;  // state of the reminder drawer
    OrderState: TDrawerState;     // state of the order drawer
    ActiveDrawer: TDrawer;        // currently active drawer, if any
    ButtonMargin: integer;
    BaseHeight: integer;
    LastOpenSize: integer;
  end;

  TfraDrawers = class(TFrame)
    pnlTemplate: TPanel;
    pnlEncounter: TPanel;
    pnlReminder: TPanel;
    pnlOrder: TPanel;
    pnlTemplates: TPanel;
    btnTemplate: TBitBtn;
    btnEncounter: TBitBtn;
    pnlEncounters: TPanel;
    btnReminder: TBitBtn;
    pnlReminders: TPanel;
    btnOrder: TBitBtn;
    pnlOrders: TPanel;
    popTemplates: TPopupMenu;
    mnuCopyTemplate: TMenuItem;
    mnuInsertTemplate: TMenuItem;
    mnuPreviewTemplate: TMenuItem;
    N1: TMenuItem;
    mnuGotoDefault: TMenuItem;
    mnuDefault: TMenuItem;
    N3: TMenuItem;
    mnuViewNotes: TMenuItem;
    N4: TMenuItem;
    mnuFindTemplates: TMenuItem;
    mnuCollapseTree: TMenuItem;
    N2: TMenuItem;
    mnuEditTemplates: TMenuItem;
    mnuNewTemplate: TMenuItem;
    N5: TMenuItem;
    mnuViewTemplateIconLegend: TMenuItem;
    tvTemplates: TORTreeView;
    lbEncounter: TORListBox;
    tvReminders: TORTreeView;
    lbOrders: TORListBox;
    al: TActionList;
    acTemplates: TAction;
    acEncounter: TAction;
    acReminders: TAction;
    acOrders: TAction;
    pnlTemplateSearch: TPanel;
    edtSearch: TCaptionEdit;
    btnFind: TORAlignButton;
    cbWholeWords: TCheckBox;
    cbMatchCase: TCheckBox;
    acFind: TAction;
    acCopyTemplateText: TAction;
    acInsertTemplate: TAction;
    acPreviewTemplate: TAction;
    acGotoDefault: TAction;
    acMarkDefault: TAction;
    acViewTemplateNotes: TAction;
    acCollapseTree: TAction;
    acFindTemplate: TAction;
    acEditTemplates: TAction;
    acNewTemplate: TAction;
    acIconLegend: TAction;
    procedure tvRemindersMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acTemplatesExecute(Sender: TObject);
    procedure acEncounterExecute(Sender: TObject);
    procedure acOrdersExecute(Sender: TObject);
    procedure acRemindersExecute(Sender: TObject);
    procedure acFindExecute(Sender: TObject);
    procedure popTemplatesPopup(Sender: TObject);
    procedure acInsertTemplateExecute(Sender: TObject);
    procedure acPreviewTemplateExecute(Sender: TObject);
    procedure acCopyTemplateTextExecute(Sender: TObject);
    procedure acGotoDefaultExecute(Sender: TObject);
    procedure acMarkDefaultExecute(Sender: TObject);
    procedure acViewTemplateNotesExecute(Sender: TObject);
    procedure acFindTemplateExecute(Sender: TObject);
    procedure acFindTemplateUpdate(Sender: TObject);
    procedure acCollapseTreeExecute(Sender: TObject);
    procedure acEditTemplatesExecute(Sender: TObject);
    procedure acNewTemplateExecute(Sender: TObject);
    procedure acIconLegendExecute(Sender: TObject);
    procedure acTemplatesUpdate(Sender: TObject);
    procedure acFindUpdate(Sender: TObject);
    procedure acRemindersUpdate(Sender: TObject);
    procedure acEncounterUpdate(Sender: TObject);
    procedure acOrdersUpdate(Sender: TObject);
    procedure tvTemplatesGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure tvTemplatesGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvTemplatesExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvTemplatesClick(Sender: TObject);
    procedure tvTemplatesDblClick(Sender: TObject);
    procedure tvTemplatesCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure tvTemplatesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvTemplatesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSearchEnter(Sender: TObject);
    procedure edtSearchExit(Sender: TObject);
    procedure tvTemplatesDragging(Sender: TObject; Node: TTreeNode;
      var CanDrag: Boolean);
    procedure tvRemindersNodeCaptioning(Sender: TObject; var Caption: string);
    procedure tvRemindersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvRemindersCurListChanged(Sender: TObject; Node: TTreeNode);
    procedure edtSearchChange(Sender: TObject);
    procedure cbFindOptionClick(Sender: TObject);
  private
    FOldMouseUp: TMouseEvent;
    FOnDrawerStateChange: TDrawerEvent;
    FEmptyNodeCount: integer;
    FInternalExpand :boolean;
    FInternalHiddenExpand :boolean;
    FLastFoundNode: TTreeNode;
    FOpenToNode: string;
    FDefTempPiece: integer;
    FAsk :boolean;
    FAskExp :boolean;
    FAskNode :TTreeNode;
    FDragNode :TTreeNode;
    FClickOccurred: boolean;
    fActiveDrawer: TDrawer;
    UpdatingVisual: boolean;
    fEncounterState: TDrawerState;
    fReminderState: TDrawerState;
    fTemplateState: TDrawerState;
    fOrderState: TDrawerState;
    fButtonMargin: integer;
    fBaseHeight: integer;
    FLastOpenSize: integer;
    FRichEditControl: ORExtensions.TRichEdit;
    FOldDragDrop: TDragDropEvent;
    FOldDragOver: TDragOverEvent;
    FNewNoteButton: TButton;
    FFindNext: boolean;
    FHasPersonalTemplates: boolean;
    FOnDrawerButtonClick: TNotifyEvent;
    FOnUpdateVisualsEvent: TNotifyEvent;
    fTemplateEditEvent: TTemplateEditEvent;
    FCopyMonitor: TCopyPasteDetails;
    FTemplateAccess: boolean;
    procedure SetEncounterState(const Value: TDrawerState);
    procedure SetOrderState(const Value: TDrawerState);
    procedure SetReminderState(const Value: TDrawerState);
    procedure SetTemplateState(const Value: TDrawerState);
    procedure SetActiveDrawer(const Value: TDrawer);
    procedure SetBaseHeight(const Value: integer);
    function GetTotalButtonHeight: integer;
    function GetDrawerIsOpen: boolean;
    function GetDrawerButtonsVisible: boolean;
  protected
    procedure CheckAsk;
    procedure PositionToReminder(Sender: TObject);
    procedure RemindersChanged(Sender: TObject);
    procedure InsertText;
    function InsertOK(Ask: boolean): boolean;
    procedure SetRichEditControl(const Value: ORExtensions.TRichEdit);
    procedure NewRECDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure NewRECDragOver(Sender, Source: TObject; X, Y: Integer;
                             State: TDragState; var Accept: Boolean);
    procedure MoveCaret(X, Y: integer);
    procedure ReloadTemplates;
    procedure SetFindNext(const Value: boolean);
    procedure AddTemplateNode(const tmpl: TTemplate; const Owner: TTreeNode = nil);
    procedure OpenToNode(Path: string = '');
  public
    RemNotifyList: TORNotifyList;
    FTotalButtonHeight: integer; // height of all the non-hidden buttons
    constructor Create(AOwner: TComponent); Override;
    destructor Destroy; Override;
    property TemplateState: TDrawerState read fTemplateState write SetTemplateState;    // state of the template drawer
    property EncounterState: TDrawerState read fEncounterState write SetEncounterState; // state of the encounter drawer
    property ReminderState: TDrawerState read fReminderState write SetReminderState;    // state of the reminder drawer
    property OrderState: TDrawerState read fOrderState write SetOrderState;             // state of the order drawer
    property ActiveDrawer: TDrawer read fActiveDrawer write SetActiveDrawer;            // currently active drawer, if any
    property OnDrawerButtonClick: TNotifyEvent read FOnDrawerButtonClick write FOnDrawerButtonClick;
    property OnUpdateVisualsEvent: TNotifyEvent read FOnUpdateVisualsEvent write FOnUpdateVisualsEvent;
    property TotalButtonHeight: integer read GetTotalButtonHeight;

    property OnDrawerStateChange: TDrawerEvent read FOnDrawerStateChange write fOnDrawerStateChange;
    property OnTemplateEditEvent: TTemplateEditEvent read fTemplateEditEvent write fTemplateEditEvent;

    property ButtonMargin: integer read fButtonMargin write fButtonMargin;
    property BaseHeight: integer read fBaseHeight write SetBaseHeight;
    property LastOpenSize: integer read FLastOpenSize write FLastOpenSize;
    property RichEditControl: ORExtensions.TRichEdit read FRichEditControl write SetRichEditControl;
    property NewNoteButton: TButton read FNewNoteButton write FNewNoteButton;
    property FindNext: boolean read FFindNext write SetFindNext;
    property HasPersonalTemplates: boolean read FHasPersonalTemplates;
    property DrawerIsOpen: boolean read GetDrawerIsOpen;
    property DrawerButtonsVisible: Boolean read GetDrawerButtonsVisible;


    procedure ResetTemplates;
    procedure UpdateVisual;
    procedure Init;
    procedure DisplayDrawers(Show: Boolean; OpenDrawer: TDrawer = odNone; AEnable: TDrawers = []; ADisplay: TDrawers = []);
    function CanEditTemplates: boolean;
    function CanEditShared: boolean;
    procedure NotifyWhenRemTreeChanges(Proc: TNotifyEvent);
    procedure RemoveNotifyWhenRemTreeChanges(Proc: TNotifyEvent);
    procedure ExternalReloadTemplates;
    procedure UpdatePersonalTemplates;
    function ButtonByDrawer(Value: TDrawer): TBitBtn;
    procedure SaveDrawerConfiguration(var Configuration: TDrawerConfiguration);
    procedure LoadDrawerConfiguration(Configuration: TDrawerConfiguration);
     Property CopyMonitor: TCopyPasteDetails read fCopyMonitor write fCopyMonitor;
    property TemplateAccess: boolean read FTemplateAccess write FTemplateAccess;
  end;

var
  FocusMonitorOn: boolean;

implementation

{$R *.dfm}

uses
  VAUtils, rTemplates, dShared, fTemplateDialog, RichEdit, fFindingTemplates,
  Clipbrd, VA508AccessibilityRouter, ORFn, fRptBox, fTemplateEditor, fIconLegend,
  fTemplateView, fReminderDialog, uReminders, uVA508CPRSCompatibility, System.Types,
  uConst, uMisc;

const
  FindNextText = 'Find Next';

{ TfraDrawers }

constructor TfraDrawers.Create(AOwner: TComponent);
begin
  inherited;
  dmodShared.AddDrawerTree(Self);
  FHasPersonalTemplates := FALSE;
end;

destructor TfraDrawers.Destroy;
begin
  dmodShared.RemoveDrawerTree(Self);
  KillObj(@RemNotifyList);
 inherited;
end;

{------------------------------------}
{  MoveCaret - Copied from fDrawers  }
{------------------------------------}
procedure TfraDrawers.MoveCaret(X, Y: integer);
var
  pt: TPoint;

begin
  FRichEditControl.SetFocus;
  pt := Point(x, y);
  FRichEditControl.SelStart := FRichEditControl.Perform(EM_CHARFROMPOS,0,LParam(@pt));
end;

{-----------------------------------------}
{  NewRECDragDrop - Copied from fDrawers  }
{-----------------------------------------}
procedure TfraDrawers.NewRECDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if(Source = tvTemplates) then
  begin
    MoveCaret(X, Y);
    InsertText;
  end
  else
  if(assigned(FOldDragDrop)) then
    FOldDragDrop(Sender, Source, X, Y);
end;

{-----------------------------------------}
{  NewRECDragOver - Copied from fDrawers  }
{-----------------------------------------}
procedure TfraDrawers.NewRECDragOver(Sender, Source: TObject; X,              
  Y: Integer; State: TDragState; var Accept: Boolean);

begin
  Accept := FALSE;
  if(Source = tvTemplates) then
  begin
    if(AssignedAndHasData(FDragNode)) and
      (TTemplate(FDragNode.Data).RealType in [ttDoc, ttGroup]) then
    begin
      Accept := TRUE;
      MoveCaret(X, Y);
    end;
  end
  else
  if(assigned(FOldDragOver)) then
    FOldDragOver(Sender, Source, X, Y, State, Accept);
end;

{-------------------------------------------------------------------------------------}
{  acCollapseTreeExecute - Converted to an action from fDrawers.mnuCollapseTreeClick  }
{-------------------------------------------------------------------------------------}
procedure TfraDrawers.acCollapseTreeExecute(Sender: TObject);                 
begin
  tvTemplates.Selected := nil;
  tvTemplates.FullCollapse;
end;

{-----------------------------------------------------------------------------------------}
{  acCopyTemplateTextExecute - Converted to an action from fDrawers.mnuCopyTemplateClick  }
{-----------------------------------------------------------------------------------------}
procedure TfraDrawers.acCopyTemplateTextExecute(Sender: TObject);
var
  txt: string;
  Template: TTemplate;

begin
  txt := '';
  if((AssignedAndHasData(tvTemplates.Selected)) and
     (TTemplate(tvTemplates.Selected.Data).RealType in [ttDoc, ttGroup])) and
     (dmodShared.TemplateOK(tvTemplates.Selected.Data)) then
  begin
    Template := TTemplate(tvTemplates.Selected.Data);
    txt := Template.Text;
    CheckBoilerplate4Fields(txt, 'Template: ' + Template.PrintName, false, FCopyMonitor);
    if txt <> '' then
    begin
      Clipboard.SetTextBuf(PChar(txt));
      GetScreenReader.Speak('Text copied to clip board');
    end;
  end;
  if txt <> '' then
    StatusText('Templated Text copied to clipboard.');
end;

{---------------------------------------------------------------------------------------}
{  acEditTemplatesExecute - Converted to an action from fDrawers.mnuEditTemplatesClick  }
{                           Also altered to interface with fTemplatesEditor             }
{---------------------------------------------------------------------------------------}
procedure TfraDrawers.acEditTemplatesExecute(Sender: TObject);
begin
  EditTemplates(TForm(Owner));
end;

{-------------------------------------------------------}
{  acEncounterExecute - Activates the encounter drawer  }
{-------------------------------------------------------}
procedure TfraDrawers.acEncounterExecute(Sender: TObject);
begin
  if (ActiveDrawer <> odEncounter) then
    ActiveDrawer := odEncounter
  else
    ActiveDrawer := odNone;
end;

{------------------------------------------------------------}
{  acEncounterUpdate - Updates the encounter control states  }
{------------------------------------------------------------}
procedure TfraDrawers.acEncounterUpdate(Sender: TObject);
begin
  acEncounter.Enabled := (EncounterState in [dsOpen, dsEnabled]);
  acEncounter.Visible := not (EncounterState = dsHidden);
  
  pnlEncounter.Visible := (EncounterState = dsOpen);
  pnlEncounter.Enabled := (EncounterState in [dsOpen, dsEnabled]);
end;

{---------------------------------------------------------------------}
{  acFindExecute - Converted to an action from fDrawers.btnFindClick  }
{---------------------------------------------------------------------}
procedure TfraDrawers.acFindExecute(Sender: TObject);
var
  Found, TmpNode: TTreeNode;
  IsNext: boolean;

begin
  if(edtSearch.text <> '') then
  begin
    IsNext := ((FFindNext) and assigned (FLastFoundNode));
    if IsNext then
      TmpNode := FLastFoundNode
    else
      TmpNode := tvTemplates.Items.GetFirstNode;
    FInternalExpand := TRUE;
    FInternalHiddenExpand := TRUE;
    try
      Found := FindTemplate(edtSearch.Text, tvTemplates, Application.MainForm, TmpNode,
                            IsNext, not cbMatchCase.Checked, cbWholeWords.Checked);
    finally
      FInternalExpand := FALSE;
      FInternalHiddenExpand := FALSE;
    end;

    if assigned(Found) then
    begin
      FLastFoundNode := Found;
      FindNext := True;
      FInternalExpand := TRUE;
      try
        tvTemplates.Selected := Found;
      finally
        FInternalExpand := FALSE;
      end;
    end;
  end;
  edtSearch.SetFocus;
end;

{--------------------------------------------------------------------------------------}
{  acFindTemplateExecute - Converted to an action from fDrawers.mnuFindTemplatesClick  }
{--------------------------------------------------------------------------------------}
procedure TfraDrawers.acFindTemplateExecute(Sender: TObject);
begin
  acFindTemplate.Checked := not acFindTemplate.Checked;
  acFindTemplateUpdate(nil); // just making sure state is checked
  if acFindTemplate.Checked and (ActiveDrawer = odTemplates) and edtSearch.CanFocus then
    edtSearch.SetFocus;
end;

{--------------------------------------------------------------------------------------}
{  acFindTemplateUpdate - Sets Find Template status based on menu item checked or not  }
{--------------------------------------------------------------------------------------}
procedure TfraDrawers.acFindTemplateUpdate(Sender: TObject);
begin
  pnlTemplateSearch.Visible := acFindTemplate.Checked;
end;

{--------------------------------------------------------}
{  acFindUpdate - Sets Find status based on search text  }
{--------------------------------------------------------}
procedure TfraDrawers.acFindUpdate(Sender: TObject);
begin
  acFind.Enabled := (edtSearch.Text <> '');
end;

{-----------------------------------------------------------------------------------}
{  acGotoDefaultExecute - Converted to an action from fDrawers.mnuGotoDefaultClick  }
{-----------------------------------------------------------------------------------}
procedure TfraDrawers.acGotoDefaultExecute(Sender: TObject);
begin
  OpenToNode(Piece(GetUserTemplateDefaults, '/', FDefTempPiece));
end;

{---------------------------------------------------------------------------------------------}
{  acIconLegendExecute - Converted to an action from fDrawers.mnuViewTemplateIconLegendClick  }
{---------------------------------------------------------------------------------------------}
procedure TfraDrawers.acIconLegendExecute(Sender: TObject);
begin
  ShowIconLegend(ilTemplates);
end;

{-----------------------------------------------------------------------------------------}
{  acInsertTemplateExecute - Converted to an action from fDrawers.mnuInsertTemplateClick  }
{-----------------------------------------------------------------------------------------}
procedure TfraDrawers.acInsertTemplateExecute(Sender: TObject);
begin
  if((AssignedAndHasData(tvTemplates.Selected)) and
     (TTemplate(tvTemplates.Selected.Data).RealType in [ttDoc, ttGroup])) then
    InsertText;
end;

{-------------------------------------------------------------------------------}
{  acMarkDefaultExecute - Converted to an action from fDrawers.mnuDefaultClick  }
{-------------------------------------------------------------------------------}
procedure TfraDrawers.acMarkDefaultExecute(Sender: TObject);          
var
  NodeID: string;
  UserTempDefNode: string;
begin
  NodeID := tvTemplates.GetNodeID(TORTreeNode(tvTemplates.Selected), 1, ';');
  UserTempDefNode := Piece(GetUserTemplateDefaults, '/', FDefTempPiece);
  if NodeID <> UserTempDefNode then
    SetUserTemplateDefaults(tvTemplates.GetNodeID(TORTreeNode(tvTemplates.Selected), 1, ';'),
                          FDefTempPiece)
  else SetUserTemplateDefaults('', FDefTempPiece);
end;

{-----------------------------------------------------------------------------------}
{  acNewTemplateExecute - Converted to an action from fDrawers.mnuNewTemplateClick  }
{-----------------------------------------------------------------------------------}
procedure TfraDrawers.acNewTemplateExecute(Sender: TObject);          
begin
  EditTemplates(TForm(Owner), TRUE);
end;

{-------------------------------------------------}
{  acOrdersExecute - Activates the orders drawer  }
{-------------------------------------------------}
procedure TfraDrawers.acOrdersExecute(Sender: TObject);
begin
  if (ActiveDrawer <> odOrders) then
    ActiveDrawer := odOrders
  else
    ActiveDrawer := odNone;
end;  

{------------------------------------------------------}
{  acOrdersUpdate - Updates the orders control states  }
{------------------------------------------------------}
procedure TfraDrawers.acOrdersUpdate(Sender: TObject);
begin
  acOrders.Enabled := (OrderState in [dsOpen, dsEnabled]);
  acOrders.Visible := not (OrderState = dsHidden);
  
  pnlOrders.Visible := (OrderState = dsOpen);
  pnlOrders.Enabled := (OrderState in [dsOpen, dsEnabled]);
end;

{-------------------------------------------------------------------------------------------}
{  acPreviewTemplateExecute - Converted to an action from fDrawers.mnuPreviewTemplateClick  }
{-------------------------------------------------------------------------------------------}
procedure TfraDrawers.acPreviewTemplateExecute(Sender: TObject);            
var
  tmpl: TTemplate;
  txt: String;
begin
  if(AssignedAndHasData(tvTemplates.Selected)) then
  begin
    if(dmodShared.TemplateOK(tvTemplates.Selected.Data,'template preview')) then
    begin
      tmpl := TTemplate(tvTemplates.Selected.Data);
      tmpl.TemplatePreviewMode := TRUE; // Prevents "Are you sure?" dialog when canceling
      txt := tmpl.Text;
      if(not tmpl.DialogAborted) then
        ShowTemplateData(nil, tmpl.PrintName, txt);
    end;
  end;
end;

{-------------------------------------------------------}
{  acRemindersExecute - Activates the reminders drawer  }
{-------------------------------------------------------}
procedure TfraDrawers.acRemindersExecute(Sender: TObject);
begin
  if(ActiveDrawer <> odReminders) then begin
    if(InitialRemindersLoaded) then begin
      ActiveDrawer := odReminders;
    end else begin
      StartupReminders;
      if(GetReminderStatus = rsNone) then begin
        ReminderState := dsDisabled;
        ActiveDrawer := odNone;
      end else begin
        ActiveDrawer := odReminders;
      end;
    end;
  end else begin
    ActiveDrawer := odNone;
  end;
  if (ActiveDrawer = odReminders) then
    BuildReminderTree(tvReminders);
end;

{------------------------------------------------------------}
{  acRemindersUpdate - Updates the reminders control states  }
{------------------------------------------------------------}
procedure TfraDrawers.acRemindersUpdate(Sender: TObject);
begin
  acReminders.Enabled := (ReminderState in [dsOpen, dsEnabled]);
  acReminders.Visible := not (ReminderState = dsHidden);

  pnlReminders.Enabled := (ReminderState in [dsOpen, dsEnabled]);
  pnlReminders.Visible := (ReminderState = dsOpen);
end;

{---------------------------------------------------------------------------------------}
{  acTemplatesExecute - Activates the templates drawer, some code copied from fDrawers  }
{---------------------------------------------------------------------------------------}
procedure TfraDrawers.acTemplatesExecute(Sender: TObject);
begin
  if(ActiveDrawer <> odTemplates) then begin
    ReloadTemplates;
    btnFind.Enabled := (edtSearch.Text <> '');
    pnlTemplateSearch.Visible := mnuFindTemplates.Checked;
    ActiveDrawer := odTemplates;
    if ScreenReaderActive then
      pnlTemplates.SetFocus;
  end else begin
    ActiveDrawer := odNone;
  end;
end;

{------------------------------------------------------------}
{  acTemplatesUpdate - Updates the templates control states  }
{------------------------------------------------------------}
procedure TfraDrawers.acTemplatesUpdate(Sender: TObject);
begin
  acTemplates.Enabled := (TemplateState in [dsOpen, dsEnabled]);
  acTemplates.Visible := (not (TemplateState = dsHidden));

  pnlTemplates.Enabled := (TemplateState in [dsOpen, dsEnabled]);
  pnlTemplates.Visible := (TemplateState = dsOpen);

  pnlTemplateSearch.Visible := pnlTemplates.Visible and acFindTemplate.Checked;
end;

{---------------------------------------------------------------------------------------}
{  acViewTemplateNotesExecute - Converted to an action from fDrawers.mnuViewNotesClick  }
{---------------------------------------------------------------------------------------}
procedure TfraDrawers.acViewTemplateNotesExecute(Sender: TObject);          
var
  tmpl: TTemplate;
  tmpSL: TStringList;

begin
  if(AssignedAndHasData(tvTemplates.Selected)) then
  begin
    tmpl := TTemplate(tvTemplates.Selected.Data);
    if(tmpl.Description = '') then
      ShowMsg('No notes found for ' + tmpl.PrintName)
    else
    begin
      tmpSL := TStringList.Create;
      try
        tmpSL.Text := tmpl.Description;
        ReportBox(tmpSL, tmpl.PrintName + ' Notes:', TRUE);
      finally
        tmpSL.Free;
      end;
    end;
  end;
end;

{----------------------------------------}
{  CanEditShared - Copied from fDrawers  }
{----------------------------------------}
function TfraDrawers.CanEditShared: boolean;
begin
  Result := FTemplateAccess and (UserTemplateAccessLevel = taEditor);
end;

{-------------------------------------------}
{  CanEditTemplates - Copied from fDrawers  }
{-------------------------------------------}
function TfraDrawers.CanEditTemplates: boolean;
begin
  Result := FTemplateAccess and (UserTemplateAccessLevel in [taAll, taEditor]);
end;

{--------------------------------------------}
{  cbFindOptionClick - Copied from fDrawers  }
{--------------------------------------------}
procedure TfraDrawers.cbFindOptionClick(Sender: TObject);
begin
  FindNext := False;
  if(pnlTemplateSearch.Visible) then edtSearch.SetFocus;
end;

{-----------------------------------------}
{  DisplayDrawers - Copied from fDrawers  }
{-----------------------------------------}
procedure TfraDrawers.DisplayDrawers(Show: Boolean; OpenDrawer: TDrawer; AEnable, ADisplay: TDrawers);
begin
  if not show then ADisplay := [];

  if odTemplates in ADisplay then begin
    if odTemplates in AEnable then begin
      if odTemplates = OpenDrawer then
        TemplateState := dsOpen
      else
        TemplateState := dsEnabled;
    end else begin
      TemplateState := dsDisabled;
    end;
  end else begin
    TemplateState := dsHidden;
  end;

  if odEncounter in ADisplay then begin
    if odEncounter in AEnable then begin
      if odEncounter = OpenDrawer then
        EncounterState := dsOpen
      else
        EncounterState := dsEnabled;
    end else begin
      EncounterState := dsDisabled;
    end;
  end else begin
    EncounterState := dsHidden;
  end;

  if odReminders in ADisplay then begin
    if odReminders in AEnable then begin
      if odReminders = OpenDrawer then
        ReminderState := dsOpen
      else
        ReminderState := dsEnabled;
    end else begin
      ReminderState := dsDisabled;
    end;
  end else begin
    ReminderState := dsHidden;
  end;

  if odOrders in ADisplay then begin
    if odOrders in AEnable then begin
      if odOrders = OpenDrawer then
        OrderState := dsOpen
      else
        OrderState := dsEnabled;
    end else begin
      OrderState := dsDisabled;
    end;
  end else begin
    OrderState := dsHidden;
  end;
  UpdateVisual;
end;

{------------------------------------------}
{  edtSearchChange - Copied from fDrawers  }
{------------------------------------------}
procedure TfraDrawers.edtSearchChange(Sender: TObject);
begin
  FindNext := False;
end;

{-----------------------------------------}
{  edtSearchEnter - Copied from fDrawers  }
{-----------------------------------------}
procedure TfraDrawers.edtSearchEnter(Sender: TObject);
begin
  btnFind.Default := True;
end;

{----------------------------------------}
{  edtSearchExit - Copied from fDrawers  }
{----------------------------------------}
procedure TfraDrawers.edtSearchExit(Sender: TObject);
begin
  btnFind.Default := False;
end;

{---------------------------------------------------------}
{  Init - Called from the parent to initialize the frame  }
{---------------------------------------------------------}
procedure TfraDrawers.Init;
begin
  fActiveDrawer := odNone; // indicates all toggled off.
  fBaseHeight := Height;
  UpdatingVisual := False;
  fEncounterState := dsEnabled;
  fReminderState := dsEnabled;
  fTemplateState := dsEnabled;
  fOrderState := dsEnabled;
  fButtonMargin := 2;
  fTemplateEditEvent := nil;

  UpdateVisual;
end;         

{-----------------------------------}
{  InsertOK - Copied from fDrawers  }
{-----------------------------------}
function TfraDrawers.InsertOK(Ask: boolean): boolean;

  function REOK: boolean;
  begin
    Result := assigned(FRichEditControl) and
              FRichEditControl.Visible and
              FRichEditControl.Parent.Visible;
  end;

begin
  Result := REOK;
  if (not ask) and (not Result) and (assigned(FNewNoteButton)) then
    Result := TRUE
  else
  if ask and (not Result) and assigned(FNewNoteButton) and
     FNewNoteButton.Visible and FNewNoteButton.Enabled then
  begin
    FNewNoteButton.Click;
    Result := REOK;
  end;
end;

{-------------------------------------}
{  InsertText - Copied from fDrawers  }
{-------------------------------------}

procedure TfraDrawers.InsertText;
var
  BeforeLine, AfterTop: integer;
  txt, DocInfo: string;
  Template: TTemplate;

begin
  DocInfo := '';
  if AssignedAndHasData(tvTemplates.Selected) and InsertOK(TRUE) and
    (dmodShared.TemplateOK(tvTemplates.Selected.Data)) then
  begin
    Template := TTemplate(tvTemplates.Selected.Data);
    Template.TemplatePreviewMode := FALSE;
    Template.ExtCPMon := FCopyMonitor;
    if Template.IsReminderDialog then begin
      FocusMonitorOn := False;
      Template.ExecuteReminderDialog(TForm(Owner));
      FocusMonitorOn := True;
    end else begin
      if Template.IsCOMObject then
        txt := Template.COMObjectText('', DocInfo)
      else
        txt := Template.Text;
      if(txt <> '') then
      begin
        CheckBoilerplate4Fields(txt, 'Template: ' + Template.PrintName);
        if (txt <> '') and (FRichEditControl.CanFocus) then begin
          BeforeLine := SendMessage(FRichEditControl.Handle, EM_EXLINEFROMCHAR, 0, FRichEditControl.SelStart);
          //Limit the editable recatnge
          SendMessage(Application.MainForm.Handle, UM_NOTELIMIT, 1, 1);
          FRichEditControl.SelText := txt;
          FRichEditControl.SetFocus;
          SendMessage(FRichEditControl.Handle, EM_SCROLLCARET, 0, 0);
          AfterTop := SendMessage(FRichEditControl.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
          SendMessage(FRichEditControl.Handle, EM_LINESCROLL, 0, -1 * (AfterTop - BeforeLine));
          SpeakTextInserted;

          //show copy/paste entries
          CopyMonitor.ManuallyShowNewHighlights;
        end;
      end;
    end;
  end;
end;

procedure TfraDrawers.LoadDrawerConfiguration(Configuration: TDrawerConfiguration);
begin
  fTemplateState  := Configuration.TemplateState;
  fEncounterState := Configuration.EncounterState;
  fReminderState  := Configuration.ReminderState;
  fOrderState     := Configuration.OrderState;
  fActiveDrawer   := Configuration.ActiveDrawer;
  fButtonMargin   := Configuration.ButtonMargin;
  fBaseHeight     := Configuration.BaseHeight;
  fLastOpenSize   := Configuration.LastOpenSize;
end;

procedure TfraDrawers.SaveDrawerConfiguration(var Configuration: TDrawerConfiguration);
begin
  Configuration.TemplateState  := fTemplateState;
  Configuration.EncounterState := fEncounterState;
  Configuration.ReminderState  := fReminderState;
  Configuration.OrderState     := fOrderState;
  Configuration.ActiveDrawer   := fActiveDrawer;
  Configuration.ButtonMargin   := fButtonMargin;
  Configuration.BaseHeight     := fBaseHeight;
  Configuration.LastOpenSize   := fLastOpenSize;
end;

{-----------------------------------------------------}
{  SetActiveDrawer - Write accessor for ActiveDrawer  }
{-----------------------------------------------------}
procedure TfraDrawers.SetActiveDrawer(const Value: TDrawer);
begin
  case fActiveDrawer of // enabled the passed drawer
    odTemplates:   TemplateState := dsEnabled;
    odEncounter:  EncounterState := dsEnabled;
    odReminders:   ReminderState := dsEnabled;
    odOrders:      OrderState := dsEnabled;
  end;
  if fActiveDrawer <> Value then begin // opens or closes the drawer
    case Value of
      odTemplates:   if TemplateState = dsEnabled then begin
                      TemplateState := dsOpen;
                      fActiveDrawer := Value;
                    end else
                      fActiveDrawer := odNone;
      odEncounter:  if EncounterState = dsEnabled then begin 
                      EncounterState := dsOpen;
                      fActiveDrawer := Value;
                    end else
                      fActiveDrawer := odNone;
      odReminders:   if ReminderState = dsEnabled then begin 
                      ReminderState := dsOpen;
                      fActiveDrawer := Value;
                    end else 
                      fActiveDrawer := odNone;
      odOrders:      if OrderState = dsEnabled then begin 
                      OrderState := dsOpen;
                      fActiveDrawer := Value;
                    end else 
                      fActiveDrawer := odNone;
      odNone:       fActiveDrawer := odNone;
    end;
  end;
  if assigned(FOnDrawerButtonClick) then
    FOnDrawerButtonClick(ButtonByDrawer(Value));
  UpdateVisual;
end;

{--------------------------------------------------------------}
{  SetBaseHeight - Write accessor for the BaseHeight property  }
{--------------------------------------------------------------}
procedure TfraDrawers.SetBaseHeight(const Value: integer);
begin
  if not UpdatingVisual then begin
    fBaseHeight := Value;
    UpdateVisual;
  end;
end;

{----------------------------------------------------------------------}
{  SetEncounterState - Write accessor for the EncounterState property  }
{----------------------------------------------------------------------}
procedure TfraDrawers.SetEncounterState(const Value: TDrawerState);
begin
  fEncounterState := Value;
  UpdateVisual;
  if assigned(fOnDrawerStateChange) then fOnDrawerStateChange(odEncounter, fEncounterState);
end;

{----------------------------------------------------------}
{  SetFindNext - Write accessor for the FindNext property  }
{----------------------------------------------------------}
procedure TfraDrawers.SetFindNext(const Value: boolean);
begin
  if(FFindNext <> Value) then
  begin
    FFindNext := Value;
    if(FFindNext) then btnFind.Caption := FindNextText
    else btnFind.Caption := 'Find';
  end;
end;

{--------------------------------------------------------------}
{  SetOrderState - Write accessor for the OrderState property  }
{--------------------------------------------------------------}
procedure TfraDrawers.SetOrderState(const Value: TDrawerState);
begin
  fOrderState := Value;
  UpdateVisual;
  if assigned(fOnDrawerStateChange) then fOnDrawerStateChange(odOrders, fOrderState);
end;

{-------------------------------------------}
{  RemindersChanged - Copied from fDrawers  }
{-------------------------------------------}
procedure TfraDrawers.RemindersChanged(Sender: TObject);
begin
  if FTemplateAccess and (ActiveDrawer = odReminders) then begin
    BuildReminderTree(tvReminders);
    FOldMouseUp := tvReminders.OnMouseUp;
  end else begin
    FOldMouseUp := nil;
    tvReminders.PopupMenu := nil;
  end;
  tvReminders.OnMouseUp := tvRemindersMouseUp;
end;

{---------------------------------------------}
{  PositionToReminder - Copied from fDrawers  }
{---------------------------------------------}
procedure TfraDrawers.PositionToReminder(Sender: TObject);
var
  Rem: TReminder;

begin
  if(assigned(Sender)) then
  begin
    if(Sender is TReminder) then
    begin
      Rem := TReminder(Sender);
      if(Rem.CurrentNodeID <> '') then
        tvReminders.Selected := tvReminders.FindPieceNode(Rem.CurrentNodeID, 1, IncludeParentID)
      else
      begin
        tvReminders.Selected := tvReminders.FindPieceNode(RemCode + (Sender as TReminder).IEN, 1);
        if(assigned(tvReminders.Selected)) then
          TORTreeNode(tvReminders.Selected).EnsureVisible;
      end;
      Rem.CurrentNodeID := '';
    end;
  end
  else
    tvReminders.Selected := nil;
end;

{-------------------------------------------------------------}
{  SetReminderState - Write accessor for ReminderState        }
{                     Code borowed from fDrawers.ShowDrawers  }
{-------------------------------------------------------------}
procedure TfraDrawers.SetReminderState(const Value: TDrawerState);
begin
  if (Value <> fReminderState) then begin
    fReminderState := Value;
    if Value <> dsHidden  then begin
      NotifyWhenRemindersChange(RemindersChanged);
      NotifyWhenProcessingReminderChanges(PositionToReminder);
    end else begin
      RemoveNotifyRemindersChange(RemindersChanged);
      RemoveNotifyWhenProcessingReminderChanges(PositionToReminder);
    end;
    UpdateVisual;
    if assigned(fOnDrawerStateChange) then fOnDrawerStateChange(odReminders, fReminderState);
  end;
end;             

{---------------------------------------------}
{  SetRichEditControl - Copied from fDrawers  }
{---------------------------------------------}
procedure TfraDrawers.SetRichEditControl(const Value: ORExtensions.TRichEdit);
begin
  if(FRichEditControl <> Value) then
  begin
    if(assigned(FRichEditControl)) then
    begin
      FRichEditControl.OnDragDrop := FOldDragDrop;
      FRichEditControl.OnDragOver := FOldDragOver;
    end;
    FRichEditControl := Value;
    if(assigned(FRichEditControl)) then
    begin
      FOldDragDrop := FRichEditControl.OnDragDrop;
      FOldDragOver := FRichEditControl.OnDragOver;
      FRichEditControl.OnDragDrop := NewRECDragDrop;
      FRichEditControl.OnDragOver := NewRECDragOver;
    end;
  end;
end;

{-------------------------------------------------------------}
{  SetTemplateState - Write accessor for TemplateState        }
{-------------------------------------------------------------}
procedure TfraDrawers.SetTemplateState(const Value: TDrawerState);
begin
  fTemplateState := Value;
  UpdateVisual;
  if assigned(fOnDrawerStateChange) then fOnDrawerStateChange(odTemplates, fTemplateState);
end;

{----------------------------------------------------}
{  tvRemindersCurListChanged - Copied from fDrawers  }
{----------------------------------------------------}
procedure TfraDrawers.tvRemindersCurListChanged(Sender: TObject; Node: TTreeNode);
begin
  if(assigned(RemNotifyList)) then
    RemNotifyList.Notify(Node);
end;

{---------------------------------------------------}
{  NotifyWhenRemTreeChanges - Copied from fDrawers  }
{---------------------------------------------------}
procedure TfraDrawers.NotifyWhenRemTreeChanges(Proc: TNotifyEvent);
begin
  if(not assigned(RemNotifyList)) then
    RemNotifyList := TORNotifyList.Create;
  RemNotifyList.Add(Proc);
end;

{---------------------------------------------------------}
{  RemoveNotifyWhenRemTreeChanges - Copied from fDrawers  }
{---------------------------------------------------------}
procedure TfraDrawers.RemoveNotifyWhenRemTreeChanges(Proc: TNotifyEvent);
begin
  if(assigned(RemNotifyList)) then
    RemNotifyList.Remove(Proc);
end;

{---------------------------------------------}
{  tvRemindersKeyDown - Copied from fDrawers  }
{---------------------------------------------}
procedure TfraDrawers.tvRemindersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_RETURN, VK_SPACE:
    begin
      FocusMonitorOn := False;
      ViewReminderDialog(ReminderNode(tvReminders.Selected));
      FocusMonitorOn := True;
      Key := 0;
    end;
  end;
end;

{---------------------------------------------}
{  tvRemindersMouseUp - Copied from fDrawers  }
{---------------------------------------------}
procedure TfraDrawers.tvRemindersMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (assigned(tvReminders.Selected)) and
     (htOnItem in tvReminders.GetHitTestInfoAt(X, Y)) then begin
      FocusMonitorOn := False;
      ViewReminderDialog(ReminderNode(tvReminders.Selected));
      FocusMonitorOn := True;
    end;
end;

{----------------------------------------------------}
{  tvRemindersNodeCaptioning - Copied from fDrawers  }
{----------------------------------------------------}
procedure TfraDrawers.tvRemindersNodeCaptioning(Sender: TObject; var Caption: string);
var
  StringData: string;
begin
  StringData := (Sender as TORTreeNode).StringData;
  if (Length(StringData) > 0) and (StringData[1] = 'R') then begin //Only tag reminder statuses
    case StrToIntDef(Piece(StringData,'^',6 {Due}),-1) of
      0: Caption := Caption + ' -- Applicable';
      1: Caption := Caption + ' -- DUE';
      2: Caption := Caption + ' -- Not Applicable';
      else Caption := Caption + ' -- Not Evaluated';
    end;
  end;
end;

{-----------------------------------}
{  CheckAsk - Copied from fDrawers  }
{-----------------------------------}
procedure TfraDrawers.CheckAsk;
begin
  if(FAsk) then
  begin
    FAsk := FALSE;
    FInternalExpand := TRUE;
    try
      if(FAskExp) then
        FAskNode.Expand(FALSE)
      else
        FAskNode.Collapse(FALSE);
    finally
      FInternalExpand := FALSE;
    end;
  end;
end;

{-------------------------------------------}
{  tvTemplatesClick - Copied from fDrawers  }
{-------------------------------------------}
procedure TfraDrawers.tvTemplatesClick(Sender: TObject);
begin
  FClickOccurred := TRUE;
  CheckAsk;
end;

{------------------------------------------------}
{  tvTemplatesCollapsing - Copied from fDrawers  }
{------------------------------------------------}
procedure TfraDrawers.tvTemplatesCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  if(assigned(Node)) then
  begin
    if(Dragging) then EndDrag(FALSE);
    if(not FInternalExpand) then
    begin
      if assigned(Node.Data) and (TTemplate(Node.Data).RealType = ttGroup) then
      begin
        FAsk := TRUE;
        FAskExp := FALSE;
        AllowCollapse := FALSE;
        FAskNode := Node;
      end;
    end;
    if(AllowCollapse) then
      FClickOccurred := FALSE;
  end;
end;

{----------------------------------------------}
{  tvTemplatesDblClick - Copied from fDrawers  }
{----------------------------------------------}
procedure TfraDrawers.tvTemplatesDblClick(Sender: TObject);
begin
  if(not FClickOccurred) then CheckAsk
  else
  begin
    FAsk := FALSE;
    if((AssignedAndHasData(tvTemplates.Selected)) and
       (TTemplate(tvTemplates.Selected.Data).RealType in [ttDoc, ttGroup])) then
      InsertText;
  end;
end;

{----------------------------------------------}
{  tvTemplatesDragging - Copied from fDrawers  }
{----------------------------------------------}
procedure TfraDrawers.tvTemplatesDragging(Sender: TObject; Node: TTreeNode;
  var CanDrag: Boolean);
begin
  if AssignedAndHasData(Node) and
    (TTemplate(Node.Data).RealType in [ttDoc, ttGroup]) then
  begin
    FDragNode := Node;
    CanDrag := TRUE;
  end
  else
  begin
    FDragNode := nil;
    CanDrag := FALSE;
  end;
end;

{-----------------------------------------------}
{  tvTemplatesExpanding - Copied from fDrawers  }
{-----------------------------------------------}
procedure TfraDrawers.tvTemplatesExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  if(assigned(Node)) then
  begin
    if(Dragging) then EndDrag(FALSE);
    if(not FInternalExpand) then
    begin
      if assigned(Node.Data) and (TTemplate(Node.Data).RealType = ttGroup) then
      begin
        FAsk := TRUE;
        FAskExp := TRUE;
        AllowExpansion := FALSE;
        FAskNode := Node;
      end;
    end;
    if(AllowExpansion) then
    begin
      FClickOccurred := FALSE;
      AllowExpansion := dmodShared.ExpandNode(tvTemplates, Node, FEmptyNodeCount);
      if(FInternalHiddenExpand) then AllowExpansion := FALSE;
    end;
  end;
end;

{---------------------------------------------------}
{  tvTemplatesGetImageIndex - Copied from fDrawers  }
{---------------------------------------------------}
procedure TfraDrawers.tvTemplatesGetImageIndex(Sender: TObject; Node: TTreeNode);
begin
  Node.ImageIndex := dmodShared.ImgIdx(Node);
end;

{------------------------------------------------------}
{  tvTemplatesGetSelectedIndex - Copied from fDrawers  }
{------------------------------------------------------}
procedure TfraDrawers.tvTemplatesGetSelectedIndex(Sender: TObject; Node: TTreeNode);
begin
  Node.SelectedIndex := dmodShared.ImgIdx(Node);
end;

{---------------------------------------------}
{  tvTemplatesKeyDown - Copied from fDrawers  }
{---------------------------------------------}
procedure TfraDrawers.tvTemplatesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CheckAsk;
  case Key of
  VK_SPACE, VK_RETURN:
    begin
      InsertText;
      Key := 0;
    end;
  end;
end;

{-------------------------------------------}
{  tvTemplatesKeyUp - Copied from fDrawers  }
{-------------------------------------------}
procedure TfraDrawers.tvTemplatesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CheckAsk;
end;

{--------------------------------------------------}
{  UpdatePersonalTemplates - Copied from fDrawers  }
{--------------------------------------------------}
procedure TfraDrawers.UpdatePersonalTemplates;
var
  NeedPersonal: boolean;
  Node: TTreeNode;

  function FindNode: TTreeNode;
  begin
    Result := tvTemplates.Items.GetFirstNode;
    while AssignedAndHasData(Result) do
    begin
      if(Result.Data = MyTemplate) then exit;
      Result := Result.getNextSibling;
    end;
  end;

begin
  NeedPersonal := (UserTemplateAccessLevel <> taNone);
  if(NeedPersonal <> FHasPersonalTemplates) then
  begin
    if(NeedPersonal) then
    begin
      if(assigned(MyTemplate)) and (MyTemplate.Children in [tcActive, tcBoth]) then
      begin
        AddTemplateNode(MyTemplate);
        FHasPersonalTemplates := TRUE;
        if(assigned(MyTemplate)) then
        begin
          Node := FindNode;
          if(assigned(Node)) then
            Node.MoveTo(nil, naAddFirst);
        end;
      end;
    end
    else
    begin
      if(assigned(MyTemplate)) then
      begin
        Node := FindNode;
        if(assigned(Node)) then Node.Delete;
      end;
      FHasPersonalTemplates := FALSE;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{  UpdateVisual - Updates the appearance of the drawers based on their states  }
{------------------------------------------------------------------------------}
procedure TfraDrawers.UpdateVisual;
var
  DrawerSpace: integer;       // space allowed for the open drawer
begin
  if not UpdatingVisual then begin // skip if already updating
    UpdatingVisual := True;
    try
      acTemplatesUpdate(nil);
      acRemindersUpdate(nil);
      acOrdersUpdate(nil);
      acEncounterUpdate(nil);

(*      // calculate total button height
      TotalButtonHeight := 0;

      if TemplateState <> dsHidden then
        inc(TotalButtonHeight, btnTemplate.Height+ButtonMargin);
      if EncounterState <> dsHidden then
        inc(TotalButtonHeight, btnEncounter.Height+ButtonMargin);
      if ReminderState <> dsHidden then
        inc(TotalButtonHeight, btnReminder.Height+ButtonMargin);
      if OrderState <> dsHidden then
        inc(TotalButtonHeight, btnOrder.Height+ButtonMargin); *)

      // calculate Drawer Space
      DrawerSpace := BaseHeight - TotalButtonHeight;

      // Set component height based on if a drawer is open
      if DrawerIsOpen then begin
        Height := BaseHeight;
      end else begin
        Height := TotalButtonHeight;
      end;

      // set order controls
      btnOrder.Width := pnlOrder.Width;
      case OrderState of
        dsEnabled:  begin
                      pnlOrder.Height := btnOrder.Height + ButtonMargin;
                      btnOrder.Enabled := True;
                      pnlOrders.Height := 1;
                    end;
        dsDisabled: begin;
                      pnlOrder.Height := btnOrder.Height + ButtonMargin;
                      btnOrder.Enabled := False;
                      pnlOrders.Height := 1;
                    end;
        dsHidden:   begin
                      pnlOrder.Height := 1;
                      btnOrder.Enabled := False;
                      pnlOrders.Height := 1;
                    end;
        dsOpen:     begin
                      pnlOrder.Height := btnOrder.Height + ButtonMargin + DrawerSpace;
                      btnOrder.Enabled := True;
                      pnlOrders.Height := DrawerSpace;
                    end;
      end;

      // set reminder controls
      btnReminder.Width := pnlReminder.Width;
      case ReminderState of
        dsEnabled:  begin
                      pnlReminder.Height := btnReminder.Height + ButtonMargin;
                      btnReminder.Enabled := True;
                      pnlReminders.Height := 1;
                    end;
        dsDisabled: begin;
                      pnlReminder.Height := btnReminder.Height + ButtonMargin;
                      btnReminder.Enabled := False;
                      pnlReminders.Height := 1;
                    end;
        dsHidden:   begin
                      pnlReminder.Height := 1;
                      btnReminder.Enabled := False;
                      pnlReminders.Height := 1;
                    end;
        dsOpen:     begin
                      pnlReminder.Height := btnReminder.Height + ButtonMargin + DrawerSpace;
                      btnReminder.Enabled := True;
                      pnlReminders.Height := DrawerSpace;
                    end;
      end;

      // set encounter controls
      btnEncounter.Width := pnlEncounter.Width;
      case EncounterState of
        dsEnabled:  begin
                      pnlEncounter.Height := btnEncounter.Height + ButtonMargin;
                      btnEncounter.Enabled := True;
                      pnlEncounters.Height := 1;
                    end;
        dsDisabled: begin;
                      pnlEncounter.Height := btnEncounter.Height + ButtonMargin;
                      btnEncounter.Enabled := False;
                      pnlEncounters.Height := 1;
                    end;
        dsHidden:   begin
                      pnlEncounter.Height := 1;
                      btnEncounter.Enabled := False;
                      pnlEncounters.Height := 1;
                    end;
        dsOpen:     begin
                      pnlEncounter.Height := btnEncounter.Height + ButtonMargin + DrawerSpace;
                      btnEncounter.Enabled := True;
                      pnlEncounters.Height := DrawerSpace;
                    end;
      end;

      // set template controls
      btnTemplate.Width := pnlTemplate.Width;
      case TemplateState of
        dsEnabled:  begin
                      pnlTemplate.Height := btnTemplate.Height + ButtonMargin;
                      btnTemplate.Enabled := True;
                      pnlTemplates.Height := 1;
                    end;
        dsDisabled: begin;
                      pnlTemplate.Height := btnTemplate.Height + ButtonMargin;
                      btnTemplate.Enabled := False;
                      pnlTemplates.Height := 1;
                    end;
        dsHidden:   begin
                      pnlTemplate.Height := 1;
                      btnTemplate.Enabled := False;
                      pnlTemplates.Height := 1;
                    end;
        dsOpen:     begin
                      pnlTemplate.Height := btnTemplate.Height + ButtonMargin + DrawerSpace;
                      btnTemplate.Enabled := True;
                      pnlTemplates.Height := DrawerSpace;
                    end;
      end;

      if assigned(FOnUpdateVisualsEvent) then
       FOnUpdateVisualsEvent(self);

    finally
      UpdatingVisual := False;
    end;
  end;
end;

{-----------------------------------------}
{  ResetTemplates - Copied from fDrawers  }
{-----------------------------------------}
procedure TfraDrawers.ResetTemplates;
begin
  FOpenToNode := Piece(GetUserTemplateDefaults, '/', FDefTempPiece);
end;

{------------------------------------------}
{  ReloadTemplates - Copied from fDrawers  }
{------------------------------------------}
procedure TfraDrawers.ReloadTemplates;
begin
  FindNext := False;
  LoadTemplateData;
  if(UserTemplateAccessLevel <> taNone) and (assigned(MyTemplate)) and
    (MyTemplate.Children in [tcActive, tcBoth]) then
  begin
    AddTemplateNode(MyTemplate);
    FHasPersonalTemplates := TRUE;
  end;
  AddTemplateNode(RootTemplate);
  OpenToNode;
end;

{--------------------------------------------------}
{  ExternalReloadTemplates - Copied from fDrawers  }
{--------------------------------------------------}
procedure TfraDrawers.ExternalReloadTemplates;
begin
  if(FOpenToNode = '') and (assigned(tvTemplates.Selected)) then
    FOpenToNode := tvTemplates.GetNodeID(TORTreeNode(tvTemplates.Selected),1,';');
  tvTemplates.Items.Clear;
  FHasPersonalTemplates := FALSE;
  FEmptyNodeCount := 0;
  ReloadTemplates;
end;


function TfraDrawers.GetDrawerIsOpen: boolean;
begin
  case fActiveDrawer of
    odTemplates: Result := (TemplateState = dsOpen);
    odEncounter: Result := (EncounterState = dsOpen);
    odReminders: Result := (ReminderState = dsOpen);
    odOrders: Result := (OrderState = dsOpen);
  else
    Result := False;
  end;
end;

function TfraDrawers.GetDrawerButtonsVisible: boolean;
begin
  Result := false;

  if  (TemplateState <> dshidden) or  (EncounterState <> dshidden) or  (ReminderState <> dshidden) or
  (OrderState <> dshidden) then
   Result := True;

end;

function TfraDrawers.GetTotalButtonHeight: integer;
begin
  FTotalButtonHeight := 0;

  if TemplateState <> dsHidden then
    inc(FTotalButtonHeight, btnTemplate.Height+ButtonMargin);
  if EncounterState <> dsHidden then
    inc(FTotalButtonHeight, btnEncounter.Height+ButtonMargin);
  if ReminderState <> dsHidden then
    inc(FTotalButtonHeight, btnReminder.Height+ButtonMargin);
  if OrderState <> dsHidden then
    inc(FTotalButtonHeight, btnOrder.Height+ButtonMargin);
  Result := FTotalButtonHeight;
end;

{------------------------------------------}
{  AddTemplateNode - Copied from fDrawers  }
{------------------------------------------}
procedure TfraDrawers.AddTemplateNode(const tmpl: TTemplate; const Owner: TTreeNode = nil);
begin
  dmodShared.AddTemplateNode(tvTemplates, FEmptyNodeCount, tmpl, FALSE, Owner);
end;

function TfraDrawers.ButtonByDrawer(Value: TDrawer): TBitBtn;
begin
  case Value of
    odTemplates: Result := btnTemplate;
    odEncounter: Result := btnEncounter;
    odReminders: Result := btnReminder;
    odOrders: Result := btnOrder;
  else
    Result := nil;
  end;
end;

{-------------------------------------}
{  OpenToNode - Copied from fDrawers  }
{-------------------------------------}
procedure TfraDrawers.OpenToNode(Path: string = '');
var
  OldInternalHE, OldInternalEX: boolean;

begin
  if(Path <> '') then
    FOpenToNode := PATH;
  if(FOpenToNode <> '') then
  begin
    OldInternalHE := FInternalHiddenExpand;
    OldInternalEX := FInternalExpand;
    try
      FInternalExpand := TRUE;
      FInternalHiddenExpand := FALSE;
      dmodShared.SelectNode(tvTemplates, FOpenToNode, FEmptyNodeCount);
    finally
      FInternalHiddenExpand := OldInternalHE;
      FInternalExpand := OldInternalEX;
    end;
    FOpenToNode := '';
  end;
end;

{--------------------------------------------}
{  popTemplatesPopup - Copied from fDrawers  }
{--------------------------------------------}
procedure TfraDrawers.popTemplatesPopup(Sender: TObject);
var
  Node: TTreeNode;
  ok, ok2, NodeFound: boolean;
  Def: string;

begin
  ok := FALSE;
  ok2 := FALSE;
  if(ActiveDrawer = odTemplates) then
  begin
    Node := tvTemplates.Selected;
    tvTemplates.Selected := Node; // This line prevents selected from changing after menu closes
    NodeFound := (AssignedAndHasData(Node));
    if(NodeFound) then
    begin
      with TTemplate(Node.Data) do
      begin
        ok := (RealType in [ttDoc, ttGroup]);
        ok2 := ok and (not IsReminderDialog) and (not IsCOMObject);
      end;
    end;
    Def := Piece(GetUserTemplateDefaults, '/', FDefTempPiece);
    mnuGotoDefault.Enabled := (Def <> '');
    mnuViewNotes.Enabled := NodeFound and (TTemplate(Node.Data).Description <> '');
    mnuDefault.Enabled := NodeFound;
    mnuDefault.Checked := NodeFound and (tvTemplates.GetNodeID(TORTreeNode(Node), 1, ';') = Def);
  end
  else
  begin
    mnuDefault.Enabled := FALSE;
    mnuGotoDefault.Enabled := FALSE;
    mnuViewNotes.Enabled := FALSE;
  end;
  mnuPreviewTemplate.Enabled := ok2;
  mnuCopyTemplate.Enabled := ok2;
  mnuInsertTemplate.Enabled := ok and InsertOK(FALSE);
  mnuFindTemplates.Enabled := (ActiveDrawer = odTemplates);
  mnuCollapseTree.Enabled := ((ActiveDrawer = odTemplates) and
                              (dmodShared.NeedsCollapsing(tvTemplates)));
  mnuEditTemplates.Enabled := (UserTemplateAccessLevel in [taAll, taEditor]);
  mnuNewTemplate.Enabled := (UserTemplateAccessLevel in [taAll, taEditor]);
end;

(*{ TTabOrder }

{-------------------------------------------------}
{  Add - Add a control to the bottom of the list  }
{        AControl: windows control to be added    }
{-------------------------------------------------}
procedure TTabOrder.Add(AControl: TWinControl);
begin
  if assigned(AControl) then begin
    SetLength(fData, Count + 1);
    fData[Count] := AControl;
    Count := Length(fData);
  end;       
end;

{---------------------------------------------------------------}
{  Clear - Clear out the list                                   }
{          Does not affect the controls referenced in the list  }
{---------------------------------------------------------------}
procedure TTabOrder.Clear;                                    
begin
  SetLength(fData, 0);
  Count := 0;
end;                         

{--------------------------------------------------------------------------------------------}
{  Create - Creates and assigns the boundaries for the control list                          }
{           Above: Control who receives focus on a shift-tab from the beginning of the list  }
{           Below: Control who receives focus on a tab from the end of the list              }
{--------------------------------------------------------------------------------------------}
constructor TTabOrder.CreateTabOrder(AboveCtrl, BelowCtrl: TWinControl);                                    
begin
  inherited Create(nil);
  Above := AboveCtrl;
  Below := BelowCtrl;
  Count := 0;
end;

{-------------------------------------------------------------}
{  GetData - Read accessor for the Data property              }
{            AnIdx: Index of the desired control in the list  }
{-------------------------------------------------------------}
function TTabOrder.GetData(AnIdx: integer): TWinControl;      
begin
  if (AnIdx >= 0) and (AnIdx < Count) then begin
    Result := fData[AnIdx];
  end else begin
    Result := nil;
  end;
end;

{-----------------------------------------------------------}
{  IndexOf - Locates the position of a control in the list  }
{            AControl: Name of the control to find          }
{-----------------------------------------------------------}
function TTabOrder.IndexOf(AControl: TWinControl): integer;
begin
  Result := 0;
  while (Result < Count) and (AControl <> fData[Result]) do inc(Result);
  if Result >= Count then Result := -1;
end;

{------------------------------------------------------}
{  Next - Finds the next control in the tab order      }
{         AControl: Beginning point for the search     }
{------------------------------------------------------}
function TTabOrder.Next(AControl: TWinControl): TWinControl;
var
  idx: integer;    // loop controller
  c: TWinControl;  // currently evaluating this control
begin
  Result := nil;
  idx := IndexOf(AControl); // find starting position
  if (idx <> -1) then begin
    repeat
      if (idx + 1) >= Count then begin // going forward, use Below if the index goes out of range
        if (Below.CanFocus and Below.TabStop) then
          Result := Below
        else 
          Result := FindNextControl(Below, True, True, False);
      end else begin
        c := fData[idx + 1];
        if (assigned(c) and c.CanFocus and c.TabStop) then begin // valid control found, assign to result
          Result := fData[idx + 1];                  
        end else begin
          inc(idx); // continue looping
        end;
      end;
    until (assigned(Result));
  end;
end;

{----------------------------------------------------------}
{  Previous - Finds the previous control in the tab order  }
{             AControl: Beginning point for the search     }
{----------------------------------------------------------}
function TTabOrder.Previous(AControl: TWinControl): TWinControl;
var
  idx: integer;    // loop controller
  c: TWinControl;  // currently evaluating this control
begin
  Result := nil;
  idx := IndexOf(AControl); // find starting position
  if (idx <> -1) then begin
    repeat
      if (idx = 0) then begin // going backwards, use Above if the index reaches 0
        if (Above.CanFocus and Above.TabStop) then
          Result := Above
        else
          Result := FindNextControl(Above, False, True, False);
      end else begin
        c := fData[idx - 1];
        if (assigned(c) and c.CanFocus and c.TabStop) then begin // valid control found, assign to result
          Result := fData[idx - 1];
        end else begin
          dec(idx); // continue looping  
        end;
      end;
    until (assigned(Result));
  end;
end;

procedure TTabOrder.PromoteAboveOther(ControlA, ControlB: TWinControl);
var
  PositionA, PositionB: integer;
begin
  PositionA := IndexOf(ControlA);
  PositionB := IndexOf(ControlB);
  if PositionA > PositionB then
    Swap(PositionA, PositionB);
end;

{-------------------------------------------------------------}
{  SetData - Write accessor for the Data property             }
{            AnIdx: Index of the desired control in the list  }
{            Value: Control to update in Data                 }
{-------------------------------------------------------------}
procedure TTabOrder.SetData(AnIdx: integer; const Value: TWinControl);
begin
  if AnIdx >= 0 then begin
    if AnIdx >= Count then begin
      SetLength(fData, AnIdx + 1);
      Count := Length(fData);
    end;
    fData[AnIdx] := Value;
  end;
end;

procedure TTabOrder.Swap(IndexA, IndexB: integer);
var
  AControl: TWinControl;
begin
  if fData[IndexA] = Above then
    Above := fData[IndexB];
  if fData[IndexB] = Below then
    Below := fData[IndexA];
  AControl := fData[IndexA];
  fData[IndexA] := fData[IndexB];
  fData[IndexB] := AControl;
end;*)

initialization
  FocusMonitorOn := True;

end.

