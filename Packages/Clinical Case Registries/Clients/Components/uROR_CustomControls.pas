unit uROR_CustomControls;
{$I Components.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, ActnList;

type

  TCBHAlign = (cbaLeft, cbaCenter, cbaRight);
  TCBVAlign = (cbaTop,  cbaMiddle, cbaBottom);

  TCCRCBDef = class(TCollectionItem)
  private
    fCaption: String;
    fCode:    String;
    fControl: TCheckBox;

  protected
    function  GetDisplayName: String; override;
    procedure setCaption(const aValue: String);
    procedure setCode(const aValue: String);

  public
    constructor Create(aCollection: TCollection); override;
    destructor  Destroy; override;

    property Control: TCheckBox         read  fControl
                                        write fControl;

  published
    property Caption: String            read  fCaption
                                        write setCaption;
    property Code: String               read  fCode
                                        write setCode;

  end;

  TCCRCBGroup = class;

  TCCRCBDefs = class(TOwnedCollection)
  private
    function getCBDef(anIndex: Integer): TCCRCBDef;

  protected
    procedure UpdateOwner; virtual;

  public
    constructor Create(anOwner: TCCRCBGroup);

    function  Add: TCCRCBDef;
    procedure Update(Item: TCollectionItem); override;

    property CBDefs[Index: Integer]: TCCRCBDef
                                        read getCBDef; default;

  end;

  TCCRCBGroup = class(TCustomPanel)
    procedure CheckBoxClick(Sender: TObject);

  private
    fCBHAlign:   TCBHAlign;
    fCBHMargin:  Integer;
    fCBStep:     Integer;
    fCBVAlign:   TCBVAlign;
    fCBVMargin:  Integer;
    fCheckBoxes: TCCRCBDefs;
    fCode:       String;
    fOnChange:   TNotifyEvent;
    fUpdating:   Boolean;

  protected
    function  GetEnabled: Boolean; override;
    procedure SetEnabled(aValue: Boolean); override;

    procedure setCBHAlign(aValue: TCBHAlign); virtual;
    procedure setCBHMargin(aValue: Integer); virtual;
    procedure setCBStep(aValue: Integer); virtual;
    procedure setCBVAlign(aValue: TCBVAlign); virtual;
    procedure setCBVMargin(aValue: Integer); virtual;
    procedure setCode(aValue: String); virtual;
    procedure UpdateCheckBoxes; virtual;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure Loaded; override;

  published
    property Align;
    //property Alignment;
    property Anchors;
    property AutoSize;
    property BevelInner   default bvNone;
    property BevelOuter   default bvNone;
    property BevelWidth;
    //property BiDiMode;
    property BorderWidth;
    property BorderStyle  default bsNone;
    //property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    //property UseDockManager default True;
    //property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property FullRepaint;
    property Font;
    //property Locked;
    //property ParentBiDiMode;
    {$IFDEF VERSION7}
    property ParentBackground;
    {$ENDIF}
    property ParentColor;
    property ParentCtl3D;
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
    //property OnDockDrop;
    //property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    //property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;

    property CBHAlign: TCBHAlign        read    fCBHAlign
                                        write   setCBHAlign
                                        default cbaRight;

    property CBHMargin: Integer         read    fCBHMargin
                                        write   setCBHMargin
                                        default 5;

    property CBStep: Integer            read    fCBStep
                                        write   setCBStep
                                        default 45;

    property CBVAlign: TCBVAlign        read    fCBVAlign
                                        write   setCBVAlign
                                        default cbaMiddle;

    property CBVMargin: Integer         read    fCBVMargin
                                        write   setCBVMargin
                                        default 10;

    property CheckBoxes: TCCRCBDefs     read    fCheckBoxes
                                        write   fCheckBoxes;

    property Code: String               read    fCode
                                        write   setCode;

    property Enabled: Boolean           read    GetEnabled
                                        write   SetEnabled;

    property OnChange: TNotifyEvent     read    fOnChange
                                        write   fOnChange;

  end;

  TCCRToolBar = class(TToolBar)
  private
    fSpacer: Tpanel;

  protected
    procedure Resize; override;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

  end;

implementation

uses
  uROR_Resources, uROR_Utilities;

/////////////////////////////////// TCCRCBDef \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRCBDef.Create(aCollection: TCollection);
begin
  inherited;
  fCaption := '';
  fCode    := '';
  fControl := nil;
end;

destructor TCCRCBDef.Destroy;
begin
  FreeAndNil(fControl);
  inherited;
end;

function TCCRCBDef.GetDisplayName: String;
begin
  if fCaption <> '' then
    Result := Caption
  else
    Result := inherited GetDisplayName;
end;

procedure TCCRCBDef.setCaption(const aValue: String);
begin
  if aValue <> fCaption then
    begin
      fCaption := aValue;
      Changed(False);
    end;
end;

procedure TCCRCBDef.setCode(const aValue: String);
begin
  if aValue <> fCode then
    begin
      fCode := aValue;
      Changed(False);
    end;
end;

/////////////////////////////////// TCCRCBDefs \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRCBDefs.Create(anOwner: TCCRCBGroup);
begin
  inherited Create(anOwner, TCCRCBDef);
end;

function TCCRCBDefs.Add: TCCRCBDef;
begin
  Result := TCCRCBDef(inherited Add);
end;

function TCCRCBDefs.getCBDef(anIndex: Integer): TCCRCBDef;
begin
  Result := TCCRCBDef(Items[anIndex]);
end;

procedure TCCRCBDefs.Update(Item: TCollectionItem);
begin
  inherited;
  UpdateOwner;
end;

procedure TCCRCBDefs.UpdateOwner;
begin
  if Owner <> nil then TCCRCBGroup(Owner).UpdateCheckBoxes;
end;

////////////////////////////////// TCCRCBGroup \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRCBGroup.Create(anOwner: TComponent);
begin
  inherited;
  fCheckBoxes := TCCRCBDefs.Create(self);

  BevelInner     := bvNone;
  BevelOuter     := bvNone;
  BorderStyle    := bsNone;
  Caption        := '';
  DockSite       := False;
  Height         := 33;
  ParentBiDiMode := True;

  fCBHAlign      := cbaRight;
  fCBHMargin     := 5;
  fCBStep        := 45;
  fCBVAlign      := cbaMiddle;
  fCBVMargin     := 10;

  fCode          := '';
  fUpdating      := False;
end;

destructor TCCRCBGroup.Destroy;
begin
  FreeAndNil(fCheckBoxes);
  inherited;
end;

procedure TCCRCBGroup.AlignControls(AControl: TControl; var Rect: TRect);
var
  cbx, i, n, rh, rw: Integer;
begin
  if CheckBoxes.Count > 0 then
    begin
      n := CheckBoxes.Count - 1;
      rh := Rect.Bottom - Rect.Top + 1;
      rw := Rect.Right - Rect.Left + 1;
      cbx := (rw - CBStep * CheckBoxes.Count) div 2 + 2;
      for i:=0 to n do
        if Assigned(CheckBoxes[i].Control) then
          with CheckBoxes[i].Control do
            begin
              Width := CBStep;
              case CBHAlign of
                cbaLeft:
                  Left := i * CBStep + CBHMargin;
                cbaCenter:
                  Left :=  i * CBStep + cbx;
                cbaRight:
                  Left := rw - (n - i + 1) * CBStep - CBHMargin;
              end;
              case CBVAlign of
                cbaTop:
                  Top := CBVMargin;
                cbaMiddle:
                  Top := (rh - Height) div 2;
                cbaBottom:
                  Top := rh - Height - CBVMargin;
              end;
            end;
    end;
  inherited;
end;

procedure TCCRCBGroup.CheckBoxClick(Sender: TObject);
var
  cbt: Integer;
begin
  if not fUpdating and (Sender is TCheckBox) then
    try
      fUpdating := True;
      cbt := TCheckBox(Sender).Tag;
      if (cbt >= 0) and (cbt < CheckBoxes.Count) then
        if TCheckBox(Sender).Checked then
          Code := CheckBoxes[cbt].Code
        else
          Code := '';
    finally
      fUpdating := False;
    end;
end;

function TCCRCBGroup.GetEnabled: Boolean;
begin
  Result := inherited GetEnabled;
end;

procedure TCCRCBGroup.Loaded;
begin
  inherited;
  UpdateCheckBoxes;
end;

procedure TCCRCBGroup.setCBHAlign(aValue: TCBHAlign);
begin
  fCBHAlign := aValue;
  Realign;
end;

procedure TCCRCBGroup.setCBHMargin(aValue: Integer);
begin
  fCBHMargin := aValue;
  Realign;
end;

procedure TCCRCBGroup.setCBStep(aValue: Integer);
begin
  fCBStep := aValue;
  Realign;
end;

procedure TCCRCBGroup.setCBVAlign(aValue: TCBVAlign);
begin
  fCBVAlign := aValue;
  Realign;
end;

procedure TCCRCBGroup.setCBVMargin(aValue: Integer);
begin
  fCBVMargin := aValue;
  Realign;
end;

procedure TCCRCBGroup.setCode(aValue: String);
var
  i, n: Integer;
begin
  fCode := aValue;
  n := CheckBoxes.Count - 1;
  for i:=0 to n do
    if Assigned(CheckBoxes[i].Control) and (CheckBoxes[i].Code <> '') then
      CheckBoxes[i].Control.Checked := (CheckBoxes[i].Code = aValue);
  if Assigned(OnChange) then OnChange(self);
end;

procedure TCCRCBGroup.SetEnabled(aValue: Boolean);
var
  i, n: Integer;
begin
  inherited SetEnabled(aValue);
  n := CheckBoxes.Count - 1;
  for i:=0 to n do
    if Assigned(CheckBoxes[i].Control) then
      CheckBoxes[i].Control.Enabled := aValue;
end;

procedure TCCRCBGroup.UpdateCheckBoxes;
var
  i, n: Integer;
begin
  n := CheckBoxes.Count - 1;
  try
    DisableAlign;
    for i:=0 to n do
      with CheckBoxes[i] do
        begin
          Control.Free;
          Control := TCheckBox.Create(self);
          Control.Caption := CheckBoxes[i].Caption;
          Control.Enabled := self.Enabled;
          Control.Name := Format('cb%d', [ID]);
          Control.TabStop := True;
          Control.Tag := i;
          Control.OnClick := CheckBoxClick;

          Control.Parent := self;
          Control.TabOrder := i;
        end;
  finally
    EnableAlign;
  end;
end;

////////////////////////////////// TCCRToolBar \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRToolBar.Create(anOwner: TComponent);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    begin
      fSpacer := TPanel.Create(Self);
      with fSpacer do
        begin
          Align       := alLeft;
          BevelInner  := bvNone;
          BevelOuter  := bvNone;
          Name        := 'pnlSpacer';
          Caption     := '';
          ParentColor := True;

          SetSubComponent(True);
          Parent := Self;
        end;
    end;
end;

destructor TCCRToolBar.Destroy;
begin
  FreeAndNil(fSpacer);
  inherited;
end;

procedure TCCRToolBar.Resize;
var
  i, n, wd: Integer;
begin
  if Assigned(fSpacer) then
    begin
      wd := ClientWidth;
      n := ControlCount - 1;
      for i:=0  to n do
        if (Controls[i] <> fSpacer) and Controls[i].Visible then
          Dec(wd, Controls[i].Width);
      fSpacer.Width := wd;
    end;
  inherited;
end;

end.
