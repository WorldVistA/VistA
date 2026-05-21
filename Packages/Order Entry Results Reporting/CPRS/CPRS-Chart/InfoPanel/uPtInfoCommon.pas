unit uPtInfoCommon;

interface

uses
  System.Classes,
  System.JSON.Converters,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  Vcl.WinXCtrls,
  ORSymbolLabel,
  uPtInfoData;

type
  TPtInfoDataTypes = class
  public const
    EditorLayoutTypeOffset = 100;
    ImageMarginSizeTop: Array [8 .. 14] of Integer = (1, 0, 1, 0, 1, 0, 2);
    ImageMarginSizeBottom: Array [8 .. 14] of Integer = (1, 0, 1, 0, 2, 0, 3);
    LabelMarginSize = 3;
    MainDefaultColorValue = clBtnFace;
    RowHeightOffset: Array [Boolean] of Integer = (4, 6);
    SymbolFontOffset = 2;
  public type
    TActionType = (actNone, actShowDetail, actShowURL, actShowMessage,
      actShowEditor, actShowHTMLEditor);
    TDataType = (dataNone, dataDivision, dataEncounterProvider, dataPort,
      dataServer, dataStationNumber, dataUserInformation, dataVisitInformation);
    TFieldType = (fldNone, fldID, fldName, fldLocID, fldLocName,
      fldVisitDateTime, fldVisitType, fldVisitString);
    TOpenState = (osUnpinned, osFloating, osPinned, osClosed, osRestored);
    TPopOutType = (popShowEmbedded, popShowModal, popShowNonModal);
    TRequiredType = (reqNo, reqOptional, reqRequired);
  end;

  TPtInfoSplitViewBase = class(TSplitView)
  private
    FFloatMonitoring: Boolean;
    FImageCollapse: TImage;
    FImageExpand: TImage;
    FInternalCount: Integer;
    FSymbolLabel: TORSymbolLabel;
    FWarningMessage: string;
    FResetToCollapse: boolean;
    function GetFloatMonitoring: Boolean;
  protected
    function GetFormGrid: TGridPanel; virtual; abstract;
    function GetOpenState: TPtInfoDataTypes.TOpenState; virtual; abstract;
    function GetPanelGrid: TGridPanel; virtual; abstract;
    function GetPinnedWidth: Integer; virtual; abstract;
    function GetWarningDisplayed: Boolean; virtual; abstract;
    procedure SetOpenState(const Value: TPtInfoDataTypes.TOpenState);
      virtual; abstract;
    procedure SetPinnedWidth(const Value: Integer); virtual; abstract;
  public
    procedure AdjustPanels; virtual; abstract;
    procedure BeginInternalCall;
    function CanPin: Boolean; virtual; abstract;
    procedure EndInternalCall;
    function HasActiveEmbeddedForm: Boolean; virtual; abstract;
    procedure InitPatient; virtual; abstract;
    procedure InitPanels(PageID: Integer); virtual; abstract;
    function IsInternalCall: Boolean;
    procedure FontChanged; virtual; abstract;
    procedure Reload; virtual; abstract;
    procedure ResetOpenState; virtual; abstract;
    property FormGrid: TGridPanel read GetFormGrid;
    property FloatMonitoring: Boolean read GetFloatMonitoring
      write FFloatMonitoring;
    property ImageCollapse: TImage read FImageCollapse write FImageCollapse;
    property ImageExpand: TImage read FImageExpand write FImageExpand;
    property OpenState: TPtInfoDataTypes.TOpenState read GetOpenState
      write SetOpenState;
    property PanelGrid: TGridPanel read GetPanelGrid;
    property PinnedWidth: Integer read GetPinnedWidth write SetPinnedWidth;
    property SymbolLabel: TORSymbolLabel read FSymbolLabel write FSymbolLabel;
    property WarningDisplayed: Boolean read GetWarningDisplayed;
    property WarningMessage: string read FWarningMessage write FWarningMessage;
    property ResetToCollapse: boolean read FResetToCollapse write FResetToCollapse;
  end;

implementation

uses
  System.TypInfo,
  System.Rtti,
  Vcl.Forms,
  uInit,
  fFrame;

{ TPtInfoSplitViewBase }

procedure TPtInfoSplitViewBase.BeginInternalCall;
begin
  inc(FInternalCount);
end;

procedure TPtInfoSplitViewBase.EndInternalCall;
begin
  if FInternalCount > 0 then
    dec(FInternalCount);
end;

function TPtInfoSplitViewBase.GetFloatMonitoring: Boolean;
begin
  Result := FFloatMonitoring and frmFrame.Activated and (not uInit.TimingOut)
    and (not IsInternalCall);
end;

function TPtInfoSplitViewBase.IsInternalCall: Boolean;
begin
  Result := (FInternalCount > 0);
end;

end.
