{*******************************************************}
{       VA FileMan Delphi Components                    }
{                                                       }
{       San Francisco CIOFO                             }
{          (originally developed at Albany IRMFO)       }
{                                                       }
{       Revision Date: 05/24/99                         }
{                                                       }
{       Distribution Date: 02/28/98                     }
{                                                       }
{       Version: 1.0                                    }
{       Patch **1**                                     }
{                                                       }
{*******************************************************}

unit Fmcntrls;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Fmcmpnts, mfunstr, DiTypLib;

type

  TCntrlOption = (coValOnExit);
  TCntrlOptions = set of TCntrlOption;
  TFMMemoStyle = (msWrapped, msByLines);

  { TFMEdit }

  TFMEdit = class(TEdit)
  private
  protected
    FFMFile, FFMField, FFMCtrlInternal, FFMCtrlExternal,
      FFMDBInternal, FFMDBExternal, FIENS: String;
    FFMTag        : String;
    FFMGets       : TFMGets;
    FFMFiler      : TFMFiler;
    FFMValidator  : TFMValidator;
    FFMModified, FFMRequired: Boolean;
    FFMDisplayName: TFMStr50;
    FFMHelp       : TFMHelp;
    FFMHelpObj    : TFMHelpObj;
    FFMCtrlOptions    : TCntrlOptions;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetIENS(IENS: string); virtual;
    procedure SetFMFiler(ZFiler: TFMFiler); virtual;
    procedure WMSetText(var Message: TMessage); message WM_SETTEXT;
    procedure SetFMGets(ZGets: TFMGets); virtual;
    procedure DoEnter; override;
    procedure Change; override;
    procedure DoExit; override;
  public
    property FMCtrlInternal: string read FFMCtrlInternal write FFMCtrlInternal;
    property FMCtrlExternal: string read FFMCtrlExternal write FFMCtrlExternal;
    property FMDBInternal: string read FFMDBInternal write FFMDBInternal;
    property FMDBExternal: string read FFMDBExternal write FFMDBExternal;
    property FMTag: string read FFMTag write FFMTag;
    property IENS: string read FIENS write SetIENS;
    property FMModified: Boolean read FFMModified write FFMModified;
    property FMHelpObj: TFMHelpObj read FFMHelpObj write FFMHelpObj;
    function Validate: Boolean; virtual;
    constructor Create(AOwner: TComponent); override;
    function FieldCheck: Boolean; virtual; //d0
    function GetHelp: TFMHelpObj; virtual;
    procedure GetandDisplayHelp; virtual;
    procedure AutoValidate; virtual;     //d0
  published
    property FMFile       : string read FFMFile write FFMFile;
    property FMField      : string read FFMField write FFMField;
    property FMGets       : TFMGets read FFMGets write SetFMGets;
    property FMFiler      : TFMFiler read FFMFiler write SetFMFiler;
    property FMValidator  : TFMValidator read FFMValidator write FFMValidator;
    property FMHelp       : TFMHelp read FFMHelp write FFMHelp;
    property FMRequired   : Boolean read FFMRequired write FFMRequired default False;
    property FMDisplayName: TFMStr50 read FFMDisplayName write FFMDisplayName;
    property FMCtrlOptions    : TCntrlOptions read FFMCtrlOptions write FFMCtrlOptions;
  end;

  { TFMMemo }

  TFMMemo = class(TMemo)
  private
  protected
    FFMFile, FFMField, FIENS: String;
    FFMGets       : TFMGets;
    FFMFiler      : TFMFiler;
    FFMModified, FFMRequired: Boolean;
    FFMDisplayName: TFMStr50;
    FFMHelp       : TFMHelp;
    FFMCtrlOptions: TCntrlOptions;
    FFMHelpObj    : TFMHelpObj;
    FFMMemoStyle  : TFMMemoStyle;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetIENS(IENS: string); virtual;
    procedure SetFMGets(ZGets: TFMGets); virtual;
    procedure SetFMFiler(ZFiler: TFMFiler); virtual;
    procedure DoEnter; override;
    procedure Change; override;
    procedure DoExit; override;
  public
    property IENS: string read FIENS write SetIENS;
    property FMModified: Boolean read FFMModified write FFMModified;
    property FMHelpObj: TFMHelpObj read FFMHelpObj write FFMHelpObj;
    constructor Create(AOwner: TComponent); override;    //d0
    function FieldCheck: Boolean; virtual;  // d0
    function GetHelp: TFMHelpObj; virtual;
    procedure GetAndDisplayHelp; virtual;
    procedure AutoValidate;     //d0
  published
    property FMFile: string read FFMFile write FFMFile;
    property FMField: string read FFMField write FFMField;
    property FMGets: TFMGets read FFMGets write SetFMGets;
    property FMFiler: TFMFiler read FFMFiler write SetFMFiler;
    property FMRequired: Boolean read FFMRequired write FFMRequired default False;
    property FMDisplayName: TFMStr50 read FFMDisplayName write FFMDisplayName;
    property FMHelp: TFMHelp read FFMHelp write FFMHelp;
    property FMCtrlOptions: TCntrlOptions read FFMCtrlOptions write FFMCtrlOptions;
    property FMMemoStyle: TFMMemoStyle read FFMMemoStyle write FFMMemoStyle;
  end;

  { TFMListBox }

  TFMListBox = class(TListBox)  //class(TListBox)
  private
  protected
    FFMFile, FFMField, FFMCtrlInternal, FFMCtrlExternal,
      FFMDBInternal, FFMDBExternal, FIENS: String;
    FFMTag        : Integer;
    FFMGets       : TFMGets;
    FFMFiler      : TFMFiler;
    FFMValidator  : TFMValidator;
    FFMLister     : TFMLister;
    FFMModified, FFMRequired, FSorted: Boolean;
    FFMDisplayName: TFMStr50;
    FFMHelp       : TFMHelp;
    FFMHelpObj    : TFMHelpObj;
    FFMCtrlOptions: TCntrlOptions;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetIENS(IENS: string); virtual;
    procedure SetFMGets(ZGets: TFMGets); virtual;
    procedure SetFMFiler(ZFiler: TFMFiler); virtual;
    procedure SetSorted(ZSorted: Boolean); virtual;
    procedure DoEnter; override;
    procedure Click; override;
    procedure DoExit; override;
  public
    property FMCtrlInternal: string read FFMCtrlInternal write FFMCtrlInternal;
    property FMCtrlExternal: string read FFMCtrlExternal write FFMCtrlExternal;
    property FMDBInternal: string read FFMDBInternal write FFMDBInternal;
    property FMDBExternal: string read FFMDBExternal write FFMDBExternal;
    property FMTag: Integer read FFMTag write FFMTag;
    property IENS: string read FIENS write SetIENS;
    property FMModified: Boolean read FFMModified write FFMModified;
    property FMHelpObj: TFMHelpObj read FFMHelpObj write FFMHelpObj;
    function Validate: Boolean; virtual;
    procedure GetList; virtual;
    procedure GetMore; virtual;
    constructor Create(AOwner: TComponent); override;     //d0
    function FieldCheck: Boolean; virtual;  //d0
    function GetHelp: TFMHelpObj; virtual;
    procedure GetAndDisplayHelp; virtual;
    procedure AutoValidate; virtual;     //d0
    function GetSelectedRecord: TFMRecordObj; virtual;
    procedure SortResults; virtual;   //d0
  published
    property FMFile: string read FFMFile write FFMFile;
    property FMField: string read FFMField write FFMField;
    property FMGets: TFMGets read FFMGets write SetFMGets;
    property FMFiler: TFMFiler read FFMFiler write SetFMFiler;
    property FMLister: TFMLister read FFMLister write FFMLister;
    property FMValidator: TFMValidator read FFMValidator write FFMValidator;
    property FMHelp: TFMHelp read FFMHelp write FFMHelp;
    property FMRequired: Boolean read FFMRequired write FFMRequired default False;
    property FMDisplayName: TFMStr50 read FFMDisplayName write FFMDisplayName;
    property FMCtrlOptions: TCntrlOptions read FFMCtrlOptions write FFMCtrlOptions;
    property Sorted: Boolean read FSorted write SetSorted;
 end;

  { TFMComboBox }

  TFMComboBox = class(TComboBox)
  private
  protected
    FFMFile, FFMField, FFMCtrlInternal, FFMCtrlExternal,
      FFMDBInternal, FFMDBExternal, FIENS: String;
    FFMTag        : Integer;
    FFMGets       : TFMGets;
    FFMFiler      : TFMFiler;
    FFMValidator  : TFMValidator;
    FFMLister     : TFMLister;
    FFMModified, FFMRequired, FSorted: Boolean;
    FFMDisplayName: TFMStr50;
    FFMHelp       : TFMHelp;
    FFMHelpObj    : TFMHelpObj;
    FFMCtrlOptions: TCntrlOptions;
    FStyle        : TComboBoxStyle;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetIENS(IENS: string); virtual;
    procedure SetFMGets(ZGets: TFMGets); virtual;
    procedure SetFMFiler(ZFiler: TFMFiler); virtual;
    procedure SetSorted(ZSorted: Boolean); virtual;
    procedure DoEnter; override;
    procedure Change; override;
    procedure DoExit; override;
  public
    property FMCtrlInternal: string read FFMCtrlInternal write FFMCtrlInternal;
    property FMCtrlExternal: string read FFMCtrlExternal write FFMCtrlExternal;
    property FMDBInternal: string read FFMDBInternal write FFMDBInternal;
    property FMDBExternal: string read FFMDBExternal write FFMDBExternal;
    property FMTag: Integer read FFMTag write FFMTag;
    property IENS: string read FIENS write SetIENS;
    property FMModified: Boolean read FFMModified write FFMModified;
    property FMHelpObj: TFMHelpObj read FFMHelpObj write FFMHelpObj;
    function Validate: Boolean; virtual;
    procedure GetList; virtual;
    procedure GetMore; virtual;
    constructor Create(AOwner: TComponent); override;    //d0
    function FieldCheck: Boolean; virtual;  //d0
    function GetHelp: TFMHelpObj; virtual;
    procedure GetAndDisplayHelp; virtual;
    procedure AutoValidate; virtual;     //d0
    function GetSelectedRecord: TFMRecordObj; virtual;
    procedure SortResults; virtual;   //d0
  published
    property FMFile: string read FFMFile write FFMFile;
    property FMField: string read FFMField write FFMField;
    property FMGets: TFMGets read FFMGets write SetFMGets;
    property FMFiler: TFMFiler read FFMFiler write SetFMFiler;
    property FMLister: TFMLister read FFMLister write FFMLister;
    property FMValidator: TFMValidator read FFMValidator write FFMValidator;
    property FMHelp: TFMHelp read FFMHelp write FFMHelp;
    property FMRequired: Boolean read FFMRequired write FFMRequired default False;
    property FMDisplayName: TFMStr50 read FFMDisplayName write FFMDisplayName;
    property FMCtrlOptions: TCntrlOptions read FFMCtrlOptions write FFMCtrlOptions;
    property Style: TComboBoxStyle read FStyle default csDropDown;
    property Sorted: Boolean read FSorted write SetSorted;
  end;

  { TFMComboBoxLookUp }

  ComboBoxState = (ListDown, ListUp);

  TFMComboBoxLookUp = class(TFMComboBox)
  private
  protected
    FFMTag, FFMText, FFMFinderNumber, FFMFinderIndex: String;
    //FItemClicked: Boolean;
    procedure ShowDropDown(cboState: ComboBoxState); virtual;
    procedure Loaded; override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  protected
    procedure DoEnter;  override;
    procedure DoExit;   override;
    procedure DropDown; override;
    procedure Click;    override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    function  AutoLookUp: Boolean; virtual; //d0
    procedure ReSet; virtual;               //d0
    property FMTag: String read FFMTag write FFMTag;
    constructor Create(AOwner: TComponent); override;
    function GetX: String; virtual;     //d0
  published
    property FMFinderIndex: String read FFMFinderIndex write FFMFinderIndex;
    property FMFinderNumber: String read FFMFinderNumber write FFMFinderNumber;
  end;

  { TFMRadioButton }

  TFMRadioButton = class(TRadioButton)
  private
  protected
    FFMFile, FFMField, FFMCtrlInternal, FFMCtrlExternal,
      FFMDBExternal, FFMDBInternal, FIENS: String;
    FFMTag           : Boolean;
    FFMGets          : TFMGets;
    FFMFiler         : TFMFiler;
    FFMValidator     : TFMValidator;
    FFMModified, FFMRequired: Boolean;
    FFMDisplayName   : TFMStr50;
    FFMHelp          : TFMHelp;
    FFMHelpObj       : TFMHelpObj;
    FFMCtrlOptions   : TCntrlOptions;
    FFMValueChecked  : String;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetIENS(IENS: string); virtual;
    procedure SetFMGets(ZGets: TFMGets); virtual;
    procedure SetFMFiler(ZFiler: TFMFiler); virtual;
  protected
    procedure DoEnter; override;
    procedure Click; override;
    procedure DoExit; override;
  public
    property FMCtrlInternal: string read FFMCtrlInternal write FFMCtrlInternal;
    property FMCtrlExternal: string read FFMCtrlExternal write FFMCtrlExternal;
    property FMDBInternal: string read FFMDBInternal write FFMDBInternal;
    property FMDBExternal: string read FFMDBExternal write FFMDBExternal;
    property FMTag: Boolean read FFMTag write FFMTag;
    property IENS: string read FIENS write SetIENS;
    property FMModified: Boolean read FFMModified write FFMModified;
    property FMHelpObj: TFMHelpObj read FFMHelpObj write FFMHelpObj;
    function Validate: Boolean; virtual;
    constructor Create(AOwner: TComponent); override;    //d0
    function FieldCheck: Boolean; virtual;  //d0
    function GetHelp: TFMHelpObj; virtual;
    procedure GetAndDisplayHelp; virtual;
    procedure AutoValidate; virtual;     //d0
  published
    property FMFile: string read FFMFile write FFMFile;
    property FMField: string read FFMField write FFMField;
    property FMGets: TFMGets read FFMGets write SetFMGets; //**
    property FMFiler: TFMFiler read FFMFiler write SetFMFiler;  //**
    property FMValidator: TFMValidator read FFMValidator write FFMValidator;
    property FMHelp: TFMHelp read FFMHelp write FFMHelp;
    property FMRequired: Boolean read FFMRequired write FFMRequired default False;
    property FMDisplayName: TFMStr50 read FFMDisplayName write FFMDisplayName;
    property FMCtrlOptions: TCntrlOptions read FFMCtrlOptions write FFMCtrlOptions;
    property FMValueChecked: string read FFMValueChecked write FFMValueChecked;
  end;

  { TFMRadioGroup }

  TFMRadioGroup = class(TRadioGroup)
  private
  protected
    FFMFile, FFMField, FFMCtrlInternal, FFMCtrlExternal,
      FFMDBExternal, FFMDBInternal, FIENS: String;
    FFMTag        : Integer;
    FFMGets       : TFMGets;
    FFMFiler      : TFMFiler;
    FFMValidator  : TFMValidator;
    FFMModified, FFMRequired: Boolean;
    FFMDisplayName: TFMStr50;
    FFMHelp       : TFMHelp;
    FFMHelpObj    : TFMHelpObj;
    FFMCtrlOptions: TCntrlOptions;
    FFMInternalCodes: TStrings;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetIENS(IENS: string); virtual;
    procedure SetCode(FFMInternalCodes: Tstrings); virtual;
    procedure SetFMGets(ZGets: TFMGets); virtual;
    procedure SetFMFiler(ZFiler: TFMFiler); virtual;
  protected
    procedure DoEnter; override;
    procedure Click; override;
    procedure DoExit; override;
  public
    property FMCtrlInternal: string read FFMCtrlInternal write FFMCtrlInternal;
    property FMCtrlExternal: string read FFMCtrlExternal write FFMCtrlExternal;
    property FMDBInternal: string read FFMDBInternal write FFMDBInternal;
    property FMDBExternal: string read FFMDBExternal write FFMDBExternal;
    property FMTag: Integer read FFMTag write FFMTag;
    property IENS: string read FIENS write SetIENS;
    property FMModified: Boolean read FFMModified write FFMModified;
    property FMHelpObj: TFMHelpObj read FFMHelpObj write FFMHelpObj;
    constructor Create(AOwner: TComponent); override;    //d0
    destructor Destroy; override;           //d0
    function Validate: Boolean; virtual;
    function FieldCheck: Boolean; virtual;  //d0
    function GetHelp: TFMHelpObj; virtual;
    procedure GetAndDisplayHelp; virtual;
    procedure AutoValidate; virtual;                 //d0
  published
    property FMFile: string read FFMFile write FFMFile;
    property FMField: string read FFMField write FFMField;
    property FMGets: TFMGets read FFMGets write SetFMGets;
    property FMFiler: TFMFiler read FFMFiler write SetFMFiler;
    property FMValidator: TFMValidator read FFMValidator write FFMValidator;
    property FMHelp: TFMHelp read FFMHelp write FFMHelp;
    property FMRequired: Boolean read FFMRequired write FFMRequired default False;
    property FMDisplayName: TFMStr50 read FFMDisplayName write FFMDisplayName;
    property FMCtrlOptions: TCntrlOptions read FFMCtrlOptions write FFMCtrlOptions;
    property FMInternalCodes: TStrings read FFMInternalCodes write SetCode;
  end;

  { TFMCheckBox }

  TFMCheckBox = class(TCheckBox)
  private
  protected
    FFMFile, FFMField, FFMCtrlInternal, FFMCtrlExternal,
      FFMDBInternal, FFMDBExternal, FIENS: String;
    FFMTag           : Boolean;
    FFMGets          : TFMGets;
    FFMFiler         : TFMFiler;
    FFMValidator     : TFMValidator;
    FFMModified, FFMRequired: Boolean;
    FFMDisplayName   : TFMStr50;
    FFMHelp          : TFMHelp;
    FFMHelpObj       : TFMHelpObj;
    FFMCtrlOptions   : TCntrlOptions;
    FFMValueChecked  : String;
    FFMValueUnchecked: String;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetIENS(IENS: string); virtual;
    procedure SetFMGets(ZGets: TFMGets); virtual;
    procedure SetFMFiler(ZFiler: TFMFiler); virtual;
protected
    procedure DoEnter; override;
    procedure Click; override;
    procedure DoExit; override;
  public
    property FMCtrlInternal: string read FFMCtrlInternal write FFMCtrlInternal;
    property FMCtrlExternal: string read FFMCtrlExternal write FFMCtrlExternal;
    property FMDBInternal: string read FFMDBInternal write FFMDBInternal;
    property FMDBExternal: string read FFMDBExternal write FFMDBExternal;
    property FMTag: Boolean read FFMTag write FFMTag;
    property IENS: string read FIENS write SetIENS;
    property FMModified: Boolean read FFMModified write FFMModified;
    property FMHelpObj: TFMHelpObj read FFMHelpObj write FFMHelpObj;
    function Validate: Boolean; virtual;
    constructor Create(AOwner: TComponent); override;    //d0
    function FieldCheck: Boolean; virtual; //d0
    function GetHelp: TFMHelpObj; virtual;
    procedure GetAndDisplayHelp; virtual;
    procedure AutoValidate; virtual;     //d0
  published
    property FMFile       : string read FFMFile write FFMFile;
    property FMField      : string read FFMField write FFMField;
    property FMGets       : TFMGets read FFMGets write SetFMGets;
    property FMFiler      : TFMFiler read FFMFiler write SetFMFiler;
    property FMValidator  : TFMValidator read FFMValidator write FFMValidator;
    property FMHelp       : TFMHelp read FFMHelp write FFMHelp;
    property FMRequired   : Boolean read FFMRequired write FFMRequired default False;
    property FMDisplayName: TFMStr50 read FFMDisplayName write FFMDisplayName;
    property FMCtrlOptions    : TCntrlOptions read FFMCtrlOptions write FFMCtrlOptions;
    property FMValueChecked: string read FFMValueChecked write FFMValueChecked;
    property FMValueUnchecked: string read FFMValueUnchecked write FFMValueUnchecked;
  end;

  { TFMLabel }

  TFMLabel = class(TLabel)
  private
  protected
    FFMFile, FFMField, FFMCtrlInternal, FFMCtrlExternal,
      FFMDBInternal, FFMDBExternal, FIENS: String;
    FFMGets       : TFMGets;
    FFMFiler      : TFMFiler;
    FFMValidator  : TFMValidator;
    FFMRequired   : Boolean;
    FFMDisplayName: TFMStr50;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetIENS(IENS: string); virtual;
    procedure SetFMGets(ZGets: TFMGets); virtual;
    procedure SetFMFiler(ZFiler: TFMFiler); virtual;
  public
    property FMCtrlInternal: string read FFMCtrlInternal write FFMCtrlInternal;
    property FMCtrlExternal: string read FFMCtrlExternal write FFMCtrlExternal;
    property FMDBInternal: string read FFMDBInternal write FFMDBInternal;
    property FMDBExternal: string read FFMDBExternal write FFMDBExternal;
    property IENS: string read FIENS write SetIENS;
    function Validate: Boolean; virtual;
    constructor Create(AOwner: TComponent); override;    //d0
    function FieldCheck: Boolean; virtual;  //d0
  published
    property FMFile: string read FFMFile write FFMFile;
    property FMField: string read FFMField write FFMField;
    property FMGets: TFMGets read FFMGets write SetFMGets;
    property FMFiler: TFMFiler read FFMFiler write SetFMFiler;
    property FMValidator: TFMValidator read FFMValidator write FFMValidator;
    property FMRequired: Boolean read FFMRequired write FFMRequired default False;
    property FMDisplayName: TFMStr50 read FFMDisplayName write FFMDisplayName;
 end;

procedure Register;

implementation

uses
  System.UITypes;

Const
  COMBO_MORE = ' <<< More >>> ';


{************ TFMEdit ************}

constructor TFMEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFMRequired := False;
end;

procedure TFMEdit.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMEdit.SetFMGets(ZGets: TFMGets);
begin
  if (ZGets = nil) and Assigned(FFMGets) then FFMGets.RemoveCtrl(Self, FFMField);
  FFMGets := ZGets;
  if (csDesigning in ComponentState) then exit;
  if FFMGets <> nil then begin
    FFMGets.AddCtrl(Self, FFMField);
    FFMFile := FFMGets.FileNumber;
    end;
end;

procedure TFMEdit.SetFMFiler(ZFiler: TFMFiler);
begin
  if (ZFiler = nil) and Assigned(FFMFiler) then FFMFiler.RemoveCtrl(Self);
  FFMFiler := ZFiler;
  if (csDesigning in ComponentState) then exit;
  if FFMFiler <> nil then FFMFiler.AddCtrl(Self);
end;

procedure TFMEdit.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMValidator) then
    FFMValidator := nil;
  if (Operation = opRemove) and (AComponent = FFMGets) then
    FFMGets := nil;
  if (Operation = opRemove) and (AComponent = FFMFiler) then
    FFMFiler := nil;
  if (Operation = opRemove) and (AComponent = FFMHelp) then
    FFMHelp := nil;
end;

function TFMEdit.Validate: Boolean;
begin
  Result := False;
  if FFMValidator <> nil then begin
    FFMValidator.SetUp(FFMFile, FIENS, FFMField, Text);
    if FFMValidator.Validate then begin
      Result := True;
      FFMCtrlInternal := FFMValidator.Results[0];
      FFMCtrlExternal := FFMValidator.Results[1];
      end;
    end;
end;

procedure TFMEdit.DoEnter;
begin
  inherited DoEnter;
  FFMTag      := Text;
  FFMModified := False;
  if (FFMHelpObj <> nil) and (Assigned (FFMHelp)) then FFMHelp.DisplyHlp(FFMHelpObj);
end;

procedure TFMEdit.Change;
begin
  FFMModified := (FFMTag <> Text);
  inherited Change;
end;

function TFMEdit.FieldCheck: Boolean;
begin
  Result := True;
  if FFMRequired and (FFMCtrlInternal = '') then Result := False;
end;

function TFMEdit.Gethelp: TFMHelpObj;
begin
  Result := nil;
  if (FFMHelpObj = nil) and (FFMHelp <> nil) then begin
    FFMHelp.FileNumber := FFMFile;
    FFMHelp.FieldNumber := FFMField;
    Result := FFMHelp.GetHelp;
    end
  else if FFMHelpObj <> nil then Result := FFMHelpObj;
end;

procedure TFMEdit.GetAndDisplayHelp;
begin
  if (FFMHelpObj = nil) then FFMHelpObj := GetHelp;
  if Assigned (FFMHelpObj) then FFMHelpObj.DisplayHelp;
end;

procedure TFMEdit.DoExit;
begin
  if FFMHelp <> nil then
    FFMHelp.DisplayPanel.Caption := '';
  AutoValidate;
  inherited DoExit;
end;

procedure TFMEdit.WMSetText(var Message: TMessage);
begin
  inherited;
  AutoValidate;
end;

procedure TFMEdit.AutoValidate;
var
  ok: boolean;
  z : string;
begin
  if (coValOnExit in FFMCtrlOptions) and (FFMModified) and (FFMValidator <> nil)
     and (FFMFiler <> nil) then begin
    ok := True;
    if ((Text = '') or (Text = '@')) and FFMRequired and (FMTag <> '') then begin
      z := FMDisplayName;
      if z <> '' then z := ' for ' + z;
      MessageDlg('A value' + z + ' is required', mtWarning, [mbCANCEL], 0);
      ok := False;
      end;
    //assumes a TFMFiler is attached to the control
    if OK and Validate then begin
      Text := FFMCtrlExternal;
      FFMFiler.AddChgdControl(self);
      //can't change FFMModified to FALSE since app might check it
      end
    else ok := False;
    if not OK then begin
      if FFMValidator.ErrorList.Count > 0 then FFMValidator.DisplayErrors;
      Text := FFMTag;
      FFMModified := False;
      Setfocus;
      end;
    end
  else
      Exit;
end;

{************ TFMMemo ************}

constructor TFMMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFMRequired := False;
end;

procedure TFMMemo.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMMemo.SetFMGets(ZGets: TFMGets);
begin
  if (ZGets = nil) and Assigned(FFMGets) then FFMGets.RemoveCtrl(Self, FFMField);
  FFMGets := ZGets;
  if (csDesigning in ComponentState) then exit;
  if FFMGets <> nil then begin
    FFMGets.AddCtrl(Self, FFMField);
    FFMFile := FFMGets.FileNumber;
    end;
end;

procedure TFMMemo.SetFMFiler(ZFiler: TFMFiler);
begin
  if (ZFiler = nil) and Assigned(FFMFiler) then FFMFiler.RemoveCtrl(Self);
  FFMFiler := ZFiler;
  if (csDesigning in ComponentState) then exit;
  if FFMFiler <> nil then FFMFiler.AddCtrl(Self);
end;

procedure TFMMemo.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMGets) then
    FFMGets := nil;
  if (Operation = opRemove) and (AComponent = FFMFiler) then
    FFMFiler := nil;
  if (Operation = opRemove) and (AComponent = FFMHelp) then
    FFMHelp := nil;
end;

procedure TFMMemo.DoEnter;
begin
  inherited DoEnter;
  FFMModified := False;
  if (FFMHelpObj <> nil) and (Assigned (FFMHelp)) then FFMHelp.DisplyHlp(FFMHelpObj);
  end;

procedure TFMMemo.Change;
begin
  FFMModified := True;
  inherited Change;
end;

function TFMMemo.FieldCheck: Boolean;
begin
  Result := True;
  if FMRequired and (Text = '') then Result := False;
end;

function TFMMemo.Gethelp: TFMHelpObj;
begin
  Result := nil;
  if (FFMHelpObj = nil) and (FFMHelp <> nil) then begin
    FFMHelp.FileNumber := FFMFile;
    FFMHelp.FieldNumber := FFMField;
    Result := FFMHelp.GetHelp;
    end
  else if FFMHelpObj <> nil then Result := FFMHelpObj;
end;

procedure TFMMemo.GetAndDisplayHelp;
begin
  if (FFMHelpObj = nil) then FFMHelpObj := GetHelp;
  if Assigned (FFMHelpObj) then FFMHelpObj.DisplayHelp;
end;

procedure TFMMemo.DoExit;
begin
  if FFMHelp <> nil then
    FFMHelp.DisplayPanel.Caption := '';
  AutoValidate;
  inherited DoExit;
end;

procedure TFMMemo.AutoValidate;
var
  i : integer;
  x, space, prev : string;
  fldobj : TFMFieldObj;
begin
  if Assigned(FFMGets) and (FFMGets.GetField(FFMField) <> nil) then begin
    if (FFMGets.GetField(FFMField).FMWPTextLines.Count > 0) and (Lines.Count = 0) and FFMRequired then begin
      MessageDlg('Text is Required', mtWarning, [mbCancel], 0);
      FMModified := False;
      Lines.Clear;
      fldobj := FFMGets.GetField(FFMField);
      if FMMemoStyle = msByLines then Lines := fldobj.FMWPTextLines
      else begin
        text := '';
        space := ' ';
        for i := 0 to fldobj.FMWPTextLines.Count - 1 do begin
          x := fldobj.FMWPTextLines[i];
          if (x <> '') and (x <> ' ')  then begin
            if (pos(' ', x) = 1) or (text = '') then space := '';
            text := text + space + x;
            prev := x;
            end
          else begin
            if prev <> x then text := text + #13#10#13#10
            else text := text + #13#10;
            prev := x;
            end
          end;
        end;
      exit;
      end;
    end;
  if (coValOnExit in FFMCtrlOptions) and (FFMModified) and (FFMFiler <> nil)
    then FFMFiler.AddChgdControl(Self);
end;

{************ TFMListBox ************}

constructor TFMListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFMRequired := False;
  MultiSelect := False;
end;

procedure TFMListBox.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMListBox.SetFMGets(ZGets: TFMGets);
begin
  if (ZGets = nil) and Assigned(FFMGets) then FFMGets.RemoveCtrl(Self, FFMField);
  FFMGets := ZGets;
  if (csDesigning in ComponentState) then exit;
  if FFMGets <> nil then begin
    FFMGets.AddCtrl(Self, FFMField);
    FFMFile := FFMGets.FileNumber;
    end;
end;

procedure TFMListBox.SetFMFiler(ZFiler: TFMFiler);
begin
  if (ZFiler = nil) and Assigned(FFMFiler) then FFMFiler.RemoveCtrl(Self);
  FFMFiler := ZFiler;
  if (csDesigning in ComponentState) then exit;
  if FFMFiler <> nil then FFMFiler.AddCtrl(Self);
end;

procedure TFMListBox.SetSorted(ZSorted: Boolean);
begin
  FSorted := ZSorted;
  if (FSorted = True) then TListBox(self).Sorted := true;
  if (csDesigning in ComponentState) then exit;
  SortResults;
end;

procedure TFMListBox.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMValidator) then
    FFMValidator := nil;
  if (Operation = opRemove) and (AComponent = FFMGets) then
    FFMGets := nil;
  if (Operation = opRemove) and (AComponent = FFMFiler) then
    FFMFiler := nil;
  if (Operation = opRemove) and (AComponent = FFMLister) then
    FFMLister := nil;
  if (Operation = opRemove) and (AComponent = FFMHelp) then
    FFMHelp := nil;
end;

function TFMListBox.Validate: Boolean;
begin
  Result := False;
  if FFMValidator <> nil then begin
    FFMValidator.SetUp(FFMFile, FIENS, FFMField, FFMCtrlExternal);
    if FFMValidator.Validate then begin
      Result := True;
      FFMCtrlInternal := FFMValidator.Results[0];
      FFMCtrlExternal := FFMValidator.Results[1];
      end;
    end;
end;

procedure TFMListBox.DoEnter;
begin
  inherited DoEnter;
  FFMTag := ItemIndex;
  FFMModified := False;
  if (FFMHelpObj <> nil) and (Assigned (FFMHelp)) then FFMHelp.DisplyHlp(FFMHelpObj);
end;

procedure TFMListBox.Click;
begin
  FFMModified := (FFMTag <> ItemIndex);
  inherited Click;
end;

procedure TFMListBox.GetList;
begin
  if FFMLister <> nil then FFMLister.GetList(Items);
end;

procedure TFMListBox.GetMore;
begin
  if FFMLister <> nil then FFMLister.GetMore(Items);
end;

function TFMListBox.FieldCheck: Boolean;
begin
  Result := True;
  if FFMRequired and (FFMCtrlInternal = '') then Result := False;
end;

function TFMListBox.Gethelp: TFMHelpObj;
begin
  Result := nil;
  if (FFMHelpObj = nil) and (FFMHelp <> nil) then begin
    FFMHelp.FileNumber := FFMFile;
    FFMHelp.FieldNumber := FFMField;
    Result := FFMHelp.GetHelp;
    end
  else if FFMHelpObj <> nil then Result := FFMHelpObj;
end;

procedure TFMListBox.GetandDisplayHelp;
begin
  if (FFMHelpObj = nil) then FFMHelpObj := GetHelp;
  if Assigned (FFMHelpObj) then FFMHelpObj.DisplayHelp;
end;

procedure TFMListBox.DoExit;
begin
  if (FFMHelp <> nil) and (FFMHelp.DisplayPanel <> nil) then
    FFMHelp.DisplayPanel.Caption := '';
  AutoValidate;
  inherited DoExit;
end;

procedure TFMListBox.AutoValidate;
var
  obj : TFMRecordObj;
begin
  if (coValOnExit in FFMCtrlOptions) and (FFMModified) and (FFMFiler <> nil)
    then begin
    if ItemIndex=-1 then begin
      FFMCtrlInternal :='';
      FFMCtrlExternal := '';
      end
    else begin
      obj := GetSelectedRecord;
      if obj <> nil then begin
        FFMCtrlInternal := obj.IEN;
        FFMCtrlExternal := obj.GetField('.01').FMDBExternal; //if undefined, pass lfexternal prior to getlist
        end;
      end;
    FFMFiler.AddChgdControl(Self);
    end
  else
      Exit;
end;

function TFMListbox.GetSelectedRecord: TFMRecordObj;
var
  z : TObject;
begin
  Result := nil;
  if ItemIndex <> -1 then begin
    z := Items.Objects[ItemIndex];
    if (z <> nil) and (z is TFMRecordObj) then Result := TFMRecordObj(z);
    end;
end;

procedure TFMListBox.SortResults;
var
  i : integer;
  z : TObject;
  r : TFMRecordObj;
begin
  if (FSorted = True) and (FFMLister <> nil) then begin
    FFMLister.Results.Clear;
    for i := 0 to Items.Count - 1 do begin
      z := Items.Objects[i];
      if (z <> nil) and (z is TFMRecordObj) then begin
        r := TFMRecordObj(z);
        FFMLister.Results.AddObject(r.IEN, r);
        end;
      end;
    end;
end;


{************ TFMComboBox ************}

constructor TFMComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFMRequired := False;
end;

procedure TFMComboBox.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMComboBox.SetFMGets(ZGets: TFMGets);
begin
  if (ZGets = nil) and Assigned(FFMGets) then FFMGets.RemoveCtrl(Self, FFMField);
  FFMGets := ZGets;
  if (csDesigning in ComponentState) then exit;
  if FFMGets <> nil then begin
    FFMGets.AddCtrl(Self, FFMField);
    FFMFile := FFMGets.FileNumber;
    end;
end;

procedure TFMComboBox.SetFMFiler(ZFiler: TFMFiler);
begin
  if (ZFiler = nil) and Assigned(FFMFiler) then FFMFiler.RemoveCtrl(Self);
  FFMFiler := ZFiler;
  if (csDesigning in ComponentState) then exit;
  if FFMFiler <> nil then FFMFiler.AddCtrl(Self);
end;

procedure TFMComboBox.DoEnter;
begin
  inherited DoEnter;
  FFMTag := ItemIndex;
  FFMModified := False;
  if (FFMHelpObj <> nil) and (Assigned (FFMHelp)) then FFMHelp.DisplyHlp(FFMHelpObj);
end;

procedure TFMComboBox.Change;
begin
  if Self.ClassType <> TFMComboBoxLookUp then begin
     FFMModified := (FFMTag <> ItemIndex);
     if (not FFMModified) and (Text = '') then FFMModified := True;
     if (not FFMModified) and (Text = '@') then begin
       FFMModified := True;
       Text := '';
       end;
     if (not FFMModified) and (Text <> FMCtrlExternal) then FFMModified := True;
     end;
  inherited Change;
end;

procedure TFMComboBox.GetList;
begin
  if FFMLister <> nil then FFMLister.GetList(Items);
end;

procedure TFMComboBox.GetMore;
begin
  if FFMLister <> nil then FFMLister.GetMore(Items);
end;

procedure TFMComboBox.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMValidator) then
    FFMValidator := nil;
  if (Operation = opRemove) and (AComponent = FFMGets) then
    FFMGets := nil;
  if (Operation = opRemove) and (AComponent = FFMFiler) then
    FFMFiler := nil;
  if (Operation = opRemove) and (AComponent = FFMLister) then
    FFMLister := nil;
  if (Operation = opRemove) and (AComponent = FFMHelp) then
    FFMHelp := nil;
end;

function TFMComboBox.Validate: Boolean;
begin
  Result := False;
  if FFMValidator <> nil then begin
    FFMValidator.SetUp(FFMFile, FIENS, FFMField, FFMCtrlExternal);
    if FFMValidator.Validate then begin
      Result := True;
      FFMCtrlInternal := FFMValidator.Results[0];
      FFMCtrlExternal := FFMValidator.Results[1];
      end;
    end;
end;

function TFMComboBox.FieldCheck: Boolean;
begin
  Result := True;
  if FFMRequired and (FFMCtrlInternal = '') then Result := False;
end;

function TFMComboBox.Gethelp: TFMHelpObj;
begin
  Result := nil;
  if (FFMHelpObj = nil) and (FFMHelp <> nil) then begin
    FFMHelp.FileNumber := FFMFile;
    FFMHelp.FieldNumber := FFMField;
    Result := FFMHelp.GetHelp;
    end
  else if FFMHelpObj <> nil then Result := FFMHelpObj;
end;

procedure TFMComboBox.GetandDisplayHelp;
begin
  if (FFMHelpObj = nil) then FFMHelpObj := GetHelp;
  if Assigned (FFMHelpObj) then FFMHelpObj.DisplayHelp;
end;

procedure TFMComboBox.DoExit;
begin
  if (FFMHelp <> nil) and (FFMHelp.DisplayPanel <> nil) then
    FFMHelp.DisplayPanel.Caption := '';
  AutoValidate;
  inherited DoExit;
end;

procedure TFMComboBox.AutoValidate;
var
  z : TFMRecordObj;
  x : string;
begin
if (coValOnExit in FFMCtrlOptions) and (FFMFiler <> nil) and (FFMModified)
    then begin
  x := FFMDisplayName;
  if x <> '' then x := ' for ' + x;
  if (ItemIndex=-1) and (Text='') then begin
    if (FFMCtrlInternal <> '') and (not FFMRequired) then begin
      FFMCtrlInternal := '';
      FFMFiler.AddChgdControl(Self);
      end
    else  begin
      FFMModified := False;
      MessageDlg('A selection' + x + ' is required', mtWarning, [mbCANCEL], 0);
      Text := FMCtrlExternal;
      SetFocus;
      exit;
      end;
    end
  else begin
    if (ItemIndex = -1) and (Text <> '') then ItemIndex := Items.Indexof(Text);
    if (ItemIndex = -1) then begin  {what's in edit box can't be found in listbox, return old value}
      MessageDlg('Selection' + x + ' is invalid', mtWarning, [mbCancel], 0);
      Text := FFMCtrlExternal;
      FFMModified := False;
      SetFocus;
      Exit;
      end;
    z := GetSelectedRecord;
    if z <> nil then begin
      FFMCtrlInternal := z.IEN;
      FFMCtrlExternal := z.GetField('.01').FMDBExternal;
      FFMFiler.AddChgdControl(Self);
      end;
    end;
  end
  else Exit;
end;

function TFMComboBox.GetSelectedRecord: TFMRecordObj;
var
  z : TObject;
begin
  Result := nil;
  if ItemIndex <> -1 then begin
    z := Items.Objects[ItemIndex];
    if (z <> nil) and (z is TFMRecordObj) then Result := TFMRecordObj(z);
    end;
end;

procedure TFMComboBox.SetSorted(ZSorted: Boolean);
begin
  FSorted := ZSorted;
  if (FSorted = True) then TComboBox(self).Sorted := true;
  if (csDesigning in ComponentState) then exit;
  SortResults;
end;

procedure TFMComboBox.SortResults;
var
  i : integer;
  z : TObject;
  r : TFMRecordObj;
begin
  if (FSorted = True) and (FFMLister <> nil) then begin
    FFMLister.Results.Clear;
    for i := 0 to Items.Count - 1 do begin
      z := Items.Objects[i];
      if (z <> nil) and (z is TFMRecordObj) then begin
        r := TFMRecordObj(z);
        FFMLister.Results.AddObject(r.IEN, r);
        end;
      end;
    end;
end;

{************ TFMComboBoxLookUp ************}

constructor TFMComboBoxLookUp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFMFinderNumber := '*';
end;

procedure TFMComboBoxLookUp.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMValidator) then
    FFMValidator := nil;
  if (Operation = opRemove) and (AComponent = FFMGets) then
    FFMGets := nil;
  if (Operation = opRemove) and (AComponent = FFMFiler) then
    FFMFiler := nil;
  if (Operation = opRemove) and (AComponent = FFMLister) then
    FFMLister := nil;
  if (Operation = opRemove) and (AComponent = FFMHelp) then
    FFMHelp := nil;
end;

function TFMComboBoxLookUp.AutoLookUp: Boolean;
begin
  if (FFMLister <> nil) and (Style = csDropDown)
    then Result := True
  else Result := False;
end;

procedure TFMComboBoxLookUp.Click;
var
  index, z, y: integer;
  PartSave, x: string;
begin
  //fitemclicked:= true;
  index := ItemIndex;
  if (AutoLookUp) and (index <> -1) and (Items[index] = COMBO_MORE) then begin
    Items.Delete(index);
    if FFMLister.PartList.Count > 0 then PartSave := FFMLister.PartList[0];
    FFMLister.PartList.Clear;
    if FFMText <> '' then FFMLister.PartList.Add(FFMText);
    Getmore;
    ItemIndex := index;
    if partsave <> '' then FFMLister.PartList.Add(PartSave);
    if FFMLister.More then begin
      Items.add(COMBO_MORE);
      z := Items.IndexOf(COMBO_MORE);
      y := Items.Count - 1;
      if (y > z) then Items.Move(z, y);
      end;
    ShowDropDown(ListDown);
    end
  else  begin
    if (ItemIndex = -1) then ItemIndex := Items.IndexOf(Text);
    SelStart := Length(Text);
    if ItemIndex <> -1 then x := GetX
    else x := '';
    FFMModified := (FFMTag <> x);
    inherited Click;
    end;
end;

procedure TFMComboBoxLookUp.DoEnter;
begin
  inherited DoEnter;
  FFMModified := False;
  FFMTag      := FMCtrlInternal;
  if (FFMHelpObj <> nil) and (Assigned (FFMHelp)) then FFMHelp.DisplyHlp(FFMHelpObj);
end;

procedure TFMComboBoxLookUp.DoExit;
var
  x: string;
begin
  {clear up '?' before leaving gadget}
  if Pos('?',Text) = 1 then
    if FFMCtrlInternal <> '' then
      Reset
    else
      Text := '';
  if (AutoLookUp) then
    if (Items.IndexOf(Text) = -1) and (Text <> '') then begin
      Items.Clear;
      ShowDropDown(ListDown);
      {-- one match}
      if Items.Count = 1 then begin
        ShowDropDown(ListUp);
        SelStart    := Length(Text);
        x := GetX;
        FFMModified := (FFMTag <> x);
        inherited DoExit;
        end
      {-- no matches}
      else begin
        if Items.Count = 0 then MessageBeep(MB_ICONQUESTION)
        else SetFocus;
        inherited DoExit;
        end;
      end
  else begin
    if (ItemIndex = -1) then ItemIndex := Items.IndexOf(Text);
    SelStart    := Length(Text);
    if (ItemIndex = -1) then x := ''
    //else if (ItemIndex <> - 1) and (not FItemClicked) then x := FFMTag
    else x := GetX;
    FFMModified := (FFMTag <> x);
    //FItemClicked := False;
    inherited DoExit;
    end
  else inherited DoExit;
end;

procedure TFMComboBoxLookUp.DropDown;
var
  partsave, x : string;
  TempFinder : TFMFinder;
  z, y: integer;
begin
  inherited DropDown;
  x := FFMDisplayName;
  if x <> '' then x := ' for ' + x;
  if Text = '' then Text := '?';
  if (AutoLookUp) and (Pos('?', Text) <> 0) and (FFMLister <> nil) then begin
    if FFMLister.PartList.Count > 0 then partsave := FFMLister.PartList[0];
    FFMLister.PartList.Clear;
    Text := '';
    FFMLister.PartList.Add(Text);
    GetList;
    FFMLister.PartList.Clear;
    if partsave <> '' then FFMLister.PartList.Add(PartSave);
    if FFMLister.More then begin
      Items.add(COMBO_MORE);
      z := Items.IndexOf(COMBO_MORE);
      y := Items.Count - 1;
      if (y > z) then Items.Move(z, y);
      end;
    end
  else begin
    if (AutoLookUp) and (Text <> '') and (Items.IndexOf(Text) = -1) then begin
      Items.Clear;
      TempFinder := TFMFinder.Create(application);
      TempFinder.DisplayFields.Assign(FFMLister.DisplayFields);
      TempFinder.FieldNumbers.Assign(FFMLister.FieldNumbers);
      TempFinder.FileNumber := FFMLister.FileNumber;
      if FFMFinderIndex <> '' then TempFinder.FMIndex := FFMFinderIndex
      else TempFinder.FMIndex := FFMLister.FMIndex;
      TempFinder.Identifier := FFMLister.Identifier;
      TempFinder.IENS := FFMLister.IENS;
      if FFMFinderNumber <> '' then TempFinder.Number := FFMFinderNumber
      else TempFinder.Number := '*';
      TempFinder.RPCBroker := FFMLister.RPCBroker;
      TempFinder.Screen := FFMLister.Screen;
      TempFinder.Value := Text;
      if loReturnWriteIDs in FFMLister.ListerOptions then
        TempFinder.FinderOptions := [foReturnWriteIDs];
      TempFinder.GetFinderList(Items);
      if TempFinder.ErrorList.Count <> 0 then begin
        TempFinder.DisplayErrors;
        Exit;
      end;
      if TempFinder.More then begin
        Items.Clear;
        MessageDlg('Too many matches found.  Please be more specific.', mtWarning, [mbOK], 0);
        Reset;
        exit;
        end;
      if TempFinder.Results.Count > 0 then begin
        FFMLister.Results.Assign(TempFinder.Results);
        ItemIndex := 0;
        end;
      TempFinder.Free;
      end;
    end;
    if Items.Count = 0 then begin
      //MessageDlg('No matches found' + x, mtWarning, [mbOK], 0);
      Reset;
      end;
    if items.count =1 then itemindex := 0;
end;

procedure TFMComboBoxLookUp.KeyUp(var Key: Word; Shift: TShiftState);
var
  wParam: Word;
  lParam: LongInt;
begin
  inherited KeyUp(Key, Shift);
  wParam := 0;
  lParam := 0;
  if (AutoLookUp) then
    if (Text <> '') and (Items.IndexOf(Text) = -1) and (Key = VK_RETURN) then begin
      ShowDropDown(ListDown);
      if Items.Count = 1 then ShowDropDown(ListUp)
      else if Items.Count = 0 then begin
        SelStart := 0;
        SelLength := Length(Text);
        end;
      end
    else if (Key <> VK_UP)
        and  (Key <> VK_DOWN)
        and  (Key <> VK_PRIOR)
        and  (Key <> VK_NEXT)
        and  (Key <> VK_END)
        and  (Key <> VK_HOME)
        and  (Key <> VK_RETURN)
        and  (Key <> VK_SPACE)
        and  (Key <> VK_MENU)
        and  (Key <> VK_TAB)
        and  (sendMessage(Handle, CB_GETDROPPEDSTATE, wParam, lParam) <> 0) then
           begin
              ShowDropDown(ListUp);
              SelStart := Length(Text);
           end;
end;

procedure TFMComboBoxLookUp.Loaded;
begin
  inherited Loaded;
end;

procedure TFMComboBoxLookUp.ReSet;
var
  partsave, screensave : string;
begin
  if (FFMCtrlInternal <> '') and (AutoLookUp) then begin
    screensave := FFMLister.Screen;
    if FFMLister.PartList.Count <> 0 then partsave := FFMLister.PartList[0];
    FFMLister.Screen := 'I Y=' + FFMCtrlInternal;
    FFMLister.PartList.Clear;
    GetList;
    if partsave <> '' then FFMLister.PartList.Add(partsave);
    FFMLister.Screen := screensave;
    if Items.Count = 1 then ItemIndex := 0;
    end;
end;

procedure TFMComboBoxLookUp.ShowDropDown(cboState: ComboBoxState);
var
  wParam: word;
  lParam: LongInt;
begin
  lParam :=0;
  wParam := 0;
  case cboState of
    ListUp:   wParam := 0;
    ListDown: wParam := 1;
  end;
  sendMessage(Handle,CB_SHOWDROPDOWN, wParam, lParam);
end;

function TFMComboBoxLookup.GetX: String;
var
  y : TFMRecordObj;
begin
  y := GetSelectedRecord;
  if y <> nil then Result := y.IEN;
end;

{************ TFMRadioButton ************}

constructor TFMRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFMRequired := False;
end;

procedure TFMRadioButton.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMRadioButton.SetFMGets(ZGets: TFMGets);
begin
  if (ZGets = nil) and Assigned(FFMGets) then FFMGets.RemoveCtrl(Self, FFMField);
  FFMGets := ZGets;
  if (csDesigning in ComponentState) then exit;
  if FFMGets <> nil then begin
    FFMGets.AddCtrl(Self, FFMField);
    FFMFile := FFMGets.FileNumber;
    end;
end;

procedure TFMRadioButton.SetFMFiler(ZFiler: TFMFiler);
begin
  if (ZFiler = nil) and Assigned(FFMFiler) then FFMFiler.RemoveCtrl(Self);
  FFMFiler := ZFiler;
  if (csDesigning in ComponentState) then exit;
  if FFMFiler <> nil then FFMFiler.AddCtrl(Self);
end;

procedure TFMRadioButton.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMValidator) then
    FFMValidator := nil;
  if (Operation = opRemove) and (AComponent = FFMGets) then
    FFMGets := nil;
  if (Operation = opRemove) and (AComponent = FFMFiler) then
    FFMFiler := nil;
  if (Operation = opRemove) and (AComponent = FFMHelp) then
    FFMHelp := nil;
end;

function TFMRadioButton.Validate: Boolean;
begin
  Result := False;
  if not Checked then begin
    FFMCtrlInternal := '';
    FFMCtrlExternal := '';
    Result := True;
    Exit;
    end;
  if (FFMValidator <> nil) and Checked then begin
    FFMValidator.SetUp(FFMFile, FIENS, FFMField, FFMValueChecked);
    if FFMValidator.Validate then begin
      Result := True;
      FFMCtrlInternal := FFMValidator.Results[0];
      FFMCtrlExternal := FFMValidator.Results[1];
      end;
    end;
end;

procedure TFMRadioButton.DoEnter;
begin
  inherited DoEnter;
  FFMTag := Checked;
  FFMModified := False;
  if (FFMHelpObj <> nil) and (Assigned (FFMHelp)) then FFMHelp.DisplyHlp(FFMHelpObj);
end;

procedure TFMRadioButton.Click;
begin
  FFMModified := (FFMTag <> Checked);
  inherited Click;
end;

function TFMRadioButton.FieldCheck: Boolean;
begin
  Result := True;
  if FFMRequired and (FFMCtrlInternal = '') then Result := False;
end;

function TFMRadioButton.Gethelp: TFMHelpObj;
begin
  Result := nil;
  if (FFMHelpObj = nil) and (FFMHelp <> nil) then begin
    FFMHelp.FileNumber := FFMFile;
    FFMHelp.FieldNumber := FFMField;
    Result := FFMHelp.GetHelp;
    end
  else if FFMHelpObj <> nil then Result := FFMHelpObj;
end;

procedure TFMRadioButton.GetandDisplayHelp;
begin
  if (FFMHelpObj = nil) then FFMHelpObj := GetHelp;
  if Assigned (FFMHelpObj) then FFMHelpObj.DisplayHelp;
end;

procedure TFMRadioButton.DoExit;
begin
  if (FFMHelp <> nil) and (FFMHelp.DisplayPanel <> nil) then
    FFMHelp.DisplayPanel.Caption := '';
  AutoValidate;
  inherited DoExit;
end;

procedure TFMRadioButton.AutoValidate;
begin
  if (coValOnExit in FFMCtrlOptions) and (FFMModified) and (FFMFiler <> nil)
    then begin
    if Checked then begin
      FFMCtrlInternal := FFMValueChecked;
      FFMCtrlExternal := Caption;
      end
    else begin
      FFMCtrlInternal := '';
      FFMCtrlExternal := '';
      end;
    FFMFiler.AddChgdControl(Self)
    end
  else Exit;
end;

{************ TFMRadioGroup ************}

constructor TFMRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFMRequired := False;
  FFMInternalCodes := TStringList.Create
end;

destructor TFMRadioGroup.Destroy;
begin
  FFMInternalCodes.Free;
  inherited Destroy;
end;

procedure TFMRadioGroup.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMValidator) then
    FFMValidator := nil;
  if (Operation = opRemove) and (AComponent = FFMGets) then
    FFMGets := nil;
  if (Operation = opRemove) and (AComponent = FFMFiler) then
    FFMFiler := nil;
  if (Operation = opRemove) and (AComponent = FFMHelp) then
    FFMHelp := nil;
end;

procedure TFMRadioGroup.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMRadioGroup.SetFMGets(ZGets: TFMGets);
begin
  if (ZGets = nil) and Assigned(FFMGets) then FFMGets.RemoveCtrl(Self, FFMField);
  FFMGets := ZGets;
  if (csDesigning in ComponentState) then exit;
  if FFMGets <> nil then begin
    FFMGets.AddCtrl(Self, FFMField);
    FFMFile := FFMGets.FileNumber;
    end;
end;

procedure TFMRadioGroup.SetFMFiler(ZFiler: TFMFiler);
begin
  if (ZFiler = nil) and Assigned(FFMFiler) then FFMFiler.RemoveCtrl(Self);
  FFMFiler := ZFiler;
  if (csDesigning in ComponentState) then exit;
  if FFMFiler <> nil then FFMFiler.AddCtrl(Self);
end;

procedure TFMRadioGroup.SetCode(FFMInternalCodes: TStrings);
begin
  FMInternalCodes.Assign(FFMInternalCodes);
end;

procedure TFMRadioGroup.DoEnter;
begin
  inherited DoEnter;
  FFMTag := ItemIndex;
  FFMModified := False;
  if (FFMHelpObj <> nil) and (Assigned (FFMHelp)) then FFMHelp.DisplyHlp(FFMHelpObj);
end;

procedure TFMRadioGroup.DoExit;
begin
  if (FFMHelp <> nil) and (FFMHelp.DisplayPanel <> nil) then
    FFMHelp.DisplayPanel.Caption := '';
  AutoValidate;
  inherited DoExit;
end;

procedure TFMRadioGroup.Click;
begin
  FFMModified := (FFMTag <> ItemIndex);
  inherited Click;
end;

function TFMRadioGroup.Gethelp: TFMHelpObj;
begin
  Result := nil;
  if (FFMHelpObj = nil) and (FFMHelp <> nil) then begin
    FFMHelp.FileNumber := FFMFile;
    FFMHelp.FieldNumber := FFMField;
    Result := FFMHelp.GetHelp;
    end
  else if FFMHelpObj <> nil then Result := FFMHelpObj;
end;

procedure TFMRadioGroup.GetandDisplayHelp;
begin
  if (FFMHelpObj = nil) then FFMHelpObj := GetHelp;
  if Assigned (FFMHelpObj) then FFMHelpObj.DisplayHelp;
end;

function TFMRadioGroup.Validate: Boolean;
begin
  Result := False;
  if (FFMValidator <> nil) and (ItemIndex <> -1) then begin
    FFMValidator.SetUp(FFMFile, FIENS, FFMField, FFMInternalCodes[ItemIndex]);
    if FFMValidator.Validate then begin
      Result := True;
      FFMCtrlInternal := FFMValidator.Results[0];
      FFMCtrlExternal := FFMValidator.Results[1];
      end;
    end;
end;

function TFMRadioGroup.FieldCheck: Boolean;
begin
  Result := True;
  if FFMRequired and (FFMCtrlInternal = '') then Result := False;
end;

procedure TFMRadioGroup.AutoValidate;
begin
  if (coValOnExit in FFMCtrlOptions) and (FFMModified) and (FFMFiler <> nil)
    then begin
  if ItemIndex = -1 then begin
    FFMCtrlInternal := '';
    FFMCtrlExternal := '';
    end
  else begin
    FFMCtrlInternal := FFMInternalCodes[ItemIndex];
    FFMCtrlExternal := Items[ItemIndex];
    end;
  FFMFiler.AddChgdControl(Self);
  end
  else exit;
end;

{************ TFMCheckBox ************}

constructor TFMCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFMRequired := False;
end;

procedure TFMCheckBox.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMCheckBox.SetFMGets(ZGets: TFMGets);
begin
  if (ZGets = nil) and Assigned(FFMGets) then FFMGets.RemoveCtrl(Self, FFMField);
  FFMGets := ZGets;
  if (csDesigning in ComponentState) then exit;
  if FFMGets <> nil then begin
    FFMGets.AddCtrl(Self, FFMField);
    FFMFile := FFMGets.FileNumber;
    end;
end;

procedure TFMCheckBox.SetFMFiler(ZFiler: TFMFiler);
begin
  if (ZFiler = nil) and Assigned(FFMFiler) then FFMFiler.RemoveCtrl(Self);
  FFMFiler := ZFiler;
  if (csDesigning in ComponentState) then exit;
  if FFMFiler <> nil then FFMFiler.AddCtrl(Self);
end;

procedure TFMCheckBox.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMValidator) then
    FFMValidator := nil;
  if (Operation = opRemove) and (AComponent = FFMGets) then
    FFMGets := nil;
  if (Operation = opRemove) and (AComponent = FFMFiler) then
    FFMFiler := nil;
  if (Operation = opRemove) and (AComponent = FFMHelp) then
    FFMHelp := nil;
end;

function TFMCheckBox.Validate: Boolean;
var
  value : string;
begin
  Result := False;
  if (State = cbGrayed) then begin
    FFMCtrlInternal := '';
    FFMCtrlExternal := '';
    Result := True;
    Exit;
    end;
  if (FFMValidator <> nil) then begin
    if (State = cbChecked) then value := FFMValueChecked
    else value := FFMValueUnChecked;
    FFMValidator.SetUp(FFMFile, FIENS, FFMField, Value);
    if FFMValidator.Validate then begin
      Result := True;
      FFMCtrlInternal := FFMValidator.Results[0];
      FFMCtrlExternal := FFMValidator.Results[1];
      end;
    end;
end;

procedure TFMCheckBox.DoEnter;
begin
  inherited DoEnter;
  FFMTag := Checked;
  FFMModified := False;
  if (FFMHelpObj <> nil) and (Assigned (FFMHelp)) then FFMHelp.DisplyHlp(FFMHelpObj);
end;


procedure TFMCheckBox.Click;
begin
  FFMModified := (FFMTag <> Checked);
  inherited Click;
end;

function TFMCheckBox.FieldCheck: Boolean;
begin
  Result := True;
  if FFMRequired and (FFMCtrlInternal = '') then Result := False;
end;

function TFMCheckBox.Gethelp: TFMHelpObj;
begin
  Result := nil;
  if (FFMHelpObj = nil) and (FFMHelp <> nil) then begin
    FFMHelp.FileNumber := FFMFile;
    FFMHelp.FieldNumber := FFMField;
    Result := FFMHelp.GetHelp;
    end
  else if FFMHelpObj <> nil then Result := FFMHelpObj;
end;

procedure TFMCheckBox.GetandDisplayHelp;
begin
  if (FFMHelpObj = nil) then FFMHelpObj := GetHelp;
  if Assigned (FFMHelpObj) then FFMHelpObj.DisplayHelp;
end;

procedure TFMCheckBox.DoExit;
begin
  if (FFMHelp <> nil) and (FFMHelp.DisplayPanel <> nil) then
    FFMHelp.DisplayPanel.Caption := '';
  AutoValidate;
  inherited DoExit;
end;

procedure TFMCheckBox.AutoValidate;
begin
  if (coValOnExit in FFMCtrlOptions) and (FFMModified) and (FFMFiler <> nil)
    then begin
    if State = cbChecked then begin
      FFMCtrlInternal := FFMValueChecked;
      FFMCtrlExternal := Caption;
      end
    else FFMCtrlInternal := FFMValueUnchecked;
    FFMFiler.AddChgdControl(Self);
    end
  else Exit;
end;

{************ TFMLabel ************}

constructor TFMLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFMRequired := False;
end;

procedure TFMLabel.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMLabel.SetFMGets(ZGets: TFMGets);
begin
  if (ZGets = nil) and Assigned(FFMGets) then FFMGets.RemoveCtrl(Self, FFMField);
  FFMGets := ZGets;
  if (csDesigning in ComponentState) then exit;
  if FFMGets <> nil then begin
    FFMGets.AddCtrl(Self, FFMField);
    FFMFile := FFMGets.FileNumber;
    end;
end;

procedure TFMLabel.SetFMFiler(ZFiler: TFMFiler);
begin
  if (ZFiler = nil) and Assigned(FFMFiler) then FFMFiler.RemoveCtrl(Self);
  FFMFiler := ZFiler;
  if (csDesigning in ComponentState) then exit;
  if FFMFiler <> nil then FFMFiler.AddCtrl(Self);
end;

procedure TFMLabel.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMValidator) then
    FFMValidator := nil;
  if (Operation = opRemove) and (AComponent = FFMGets) then
    FFMGets := nil;
  if (Operation = opRemove) and (AComponent = FFMFiler) then
    FFMFiler := nil;
end;

function TFMLabel.Validate: Boolean;
begin
  Result := False;
  if FFMValidator <> nil then begin
    FFMValidator.SetUp(FFMFile, FIENS, FFMField, Caption);
    if FFMValidator.Validate then begin
      Result := True;
      FFMCtrlInternal := FFMValidator.Results[0];
      FFMCtrlExternal := FFMValidator.Results[1];
      end;
    end;
end;

function TFMLabel.FieldCheck: Boolean;
begin
   Result := True;
   if FFMRequired and (FFMCtrlInternal = '') then Result := False;
end;

{no ValOnExit on this control since there should be no DoExit event on a label}

procedure Register;
begin
  RegisterComponents('FileMan', [TFMEdit, TFMMemo, TFMListbox]);
  RegisterComponents('FileMan', [TFMComboBox, TFMComboBoxLookUp]);
  RegisterComponents('FileMan', [TFMRadioButton, TFMRadioGroup, TFMCheckBox, TFMLabel]);

end;

end.
