unit uROR_ParamsPanel;
{$I Components.inc}

interface

uses
  Forms, SysUtils, Classes, Controls, ExtCtrls, StdCtrls, Types, uROR_Utilities;

type
  TCustomReportParameters = class;

  TCCRPanelClearParamsEvent = procedure (const aReportCode: String;
    aList: TCustomReportParameters) of object;
  TCCRPanelGetEvent = procedure (const aReportCode: String;
    aList: TCustomReportParameters; aMsgLst: TStrings; var aField: TWinControl) of object;
  TCCRPanelSetEvent = procedure (const aReportCode: String;
    aList: TCustomReportParameters) of object;
  TCCRPanelSetupEvent = procedure (const aReportCode: String) of object;

  TCCRParamsPanel = class(TCustomPanel)
  private
    fBevel:         TBevel;
    fCaption:       String;
    fLabel:         TLabel;
    fOnClearParams: TCCRPanelClearParamsEvent;
    fOnGetValues:   TCCRPanelGetEvent;
    fOnSetup:       TCCRPanelSetupEvent;
    fOnSetValues:   TCCRPanelSetEvent;

  protected
    procedure AdjustClientRect(var aRect: TRect); override;
    procedure AlignControls(aControl: TControl; var aRect: TRect); override;
    procedure CreateHandle; override;
    procedure DoClearParams(const aReportCode: String;
      aList: TCustomReportParameters); virtual;
    procedure Paint; override;
    procedure Resize; override;
    procedure setCaption(const aValue: String); virtual;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetName(const Value: TComponentName); override;
    procedure updateHeader(const aCaption: String); virtual;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    function  GetFieldValues(const aReportCode: String;
      aList: TCustomReportParameters; aMsgLst: TStrings): TWinControl;
    procedure SetFieldValues(const aReportCode: String; aList: TCustomReportParameters);
    procedure Setup(const aReportCode: String); virtual;

  published
    property Align;
    property Alignment default taLeftJustify;
    property Anchors;
    //property AutoSize;
    //property BevelInner;
    //property BevelOuter;
    //property BevelWidth;
    property BiDiMode;
    //property BorderWidth;
    //property BorderStyle;
    property Color;
    property Constraints;
    //property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    property ParentBiDiMode;
    {$IFDEF VERSION7}
    property ParentBackground;
    {$ENDIF}
    property ParentColor;
    //property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;

    property Caption: String                        read   fCaption
                                                    write  setCaption;

    property OnClearParams: TCCRPanelClearParamsEvent read fOnClearParams
                                                    write  fOnClearParams;

    property OnGetValues: TCCRPanelGetEvent         read   fOnGetValues
                                                    write  fOnGetValues;

    property OnSetup: TCCRPanelSetupEvent           read   fOnSetup
                                                    write  fOnSetup;

    property OnSetValues: TCCRPanelSetEvent         read   fOnSetValues
                                                    write  fOnSetValues;

  end;

  TCustomReportParameters = class(TPersistent)
  end;

implementation

uses
  Graphics, uROR_Resources;

type

  TParamsLabel = class(TLabel)
  protected
    procedure SetName(const Value: TComponentName); override;
  end;

//////////////////////////////// TCCRParamsPanel \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRParamsPanel.Create(anOwner: TComponent);
begin
  inherited;

  Alignment  := taLeftJustify;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  Ctl3D      := False;

  fBevel     := nil;
  fCaption   := '';
  fLabel     := nil;
end;

destructor TCCRParamsPanel.Destroy;
begin
  inherited;
end;

procedure TCCRParamsPanel.AdjustClientRect(var aRect: TRect);
begin
  inherited;
  if Assigned(fLabel) then
    aRect.Top := fLabel.Height;
end;

procedure TCCRParamsPanel.AlignControls(aControl: TControl; var aRect: TRect);
begin
  if Assigned(fLabel) then
    aRect.Top := fLabel.Height;
  inherited;
end;

procedure TCCRParamsPanel.CreateHandle;
begin
  inherited;
  Resize;
end;

procedure TCCRParamsPanel.DoClearParams(const aReportCode: String;
  aList: TCustomReportParameters);
begin
  if Assigned(OnClearParams) then
    OnClearParams(aReportCode, aList);
end;

function TCCRParamsPanel.GetFieldValues(const aReportCode: String;
  aList: TCustomReportParameters; aMsgLst: TStrings): TWinControl;
begin
  Result := nil;
  if not Enabled then
    DoCLearParams(aReportCode, aList)
  else if Assigned(OnGetValues) then
    OnGetValues(aReportCode, aList, aMsgLst, Result);
end;

procedure TCCRParamsPanel.Paint;
var
  saveStyle: TPenStyle;
begin
  inherited;
  if not Assigned(fLabel) and (csDesigning in ComponentState) then
    with Canvas do
      begin
        MoveTo(0, 0);
        saveStyle := Pen.Style;
        Pen.Style := psDash;
        LineTo(Self.ClientWidth, 0);
        Pen.Style := saveStyle;
      end;
end;

procedure TCCRParamsPanel.Resize;
const
  DX = 16;
begin
  inherited;
  if Assigned(fBevel) then
    fBevel.Width := ClientWidth;

  if Assigned(fLabel) then
    case Alignment of
      taRightJustify:
        fLabel.Left := ClientWidth - fLabel.Width - DX;
      taCenter:
        fLabel.Left := (ClientWidth - fLabel.Width) div 2;
      else
        fLabel.Left := DX;
    end;
end;

procedure TCCRParamsPanel.setCaption(const aValue: String);
begin
  if aValue <> fCaption then
    begin
      fCaption := aValue;
      if aValue <> '' then
        updateHeader('  ' + aValue + '  ')
      else
        updateHeader('');
    end
end;

procedure TCCRParamsPanel.SetEnabled(Value: Boolean);
begin
  inherited;
  if Assigned(fLabel) then
    fLabel.Enabled := Value;
end;

procedure TCCRParamsPanel.SetName(const Value: TComponentName);
begin
  inherited;
  inherited Caption := '';
end;

procedure TCCRParamsPanel.SetFieldValues(const aReportCode: String;
  aList: TCustomReportParameters);
begin
  if Assigned(OnSetValues) then
    OnSetValues(aReportCode, aList);
end;

procedure TCCRParamsPanel.Setup(const aReportCode: String);
begin
  if Assigned(OnSetup) then
    OnSetup(aReportCode);
end;

procedure TCCRParamsPanel.updateHeader(const aCaption: String);
begin
  if aCaption <> '' then
    begin
      if not Assigned(fLabel) then
        begin
          fLabel := TParamsLabel.Create(Self);
          with fLabel do
            begin
              SetSubComponent(True);
              Parent := Self;

              AutoSize := True;
              Name     := 'HeaderLabel';
              Top      := 0;
              Left     := 10;

              Font.Style := Font.Style + [fsBold];
            end;
        end;

      fLabel.Caption := aCaption;

      if not Assigned(fBevel) then
        begin
          fBevel := TBevel.Create(Self);
          with fBevel do
            begin
              SetSubComponent(True);
              Parent := Self;

              Height   := 3;
              Left     := 0;
              Name     := 'HeaderBevel';
              Shape    := bsTopLine;
              Top      := (fLabel.Height - Height) div 2;
              try
                Width  := Self.ClientWidth;
                SendToBack;
              except
              end;
            end;
        end;
    end
  else
    begin
      FreeAndNil(fBevel);
      FreeAndNil(fLabel);
    end;
end;

///////////////////////////////// TParamsLabel \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TParamsLabel.SetName(const Value: TComponentName);
begin
  inherited;
  Caption := '';
end;

end.
