unit UORForm;

interface

uses
  Vcl.Forms,
  System.Classes;

type
  TORForm = class(TForm)
  private
    FOldCreateOrder: Boolean;
    procedure ReadOldCreateOrder(Reader: TReader);
    procedure WriteOldCreateOrder(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
    procedure OldDoCreate; virtual;
    procedure DoCreate; override;
    procedure OldDoDestroy; virtual;
    procedure DoDestroy; override;
    procedure DoSetFontSize(FontSize: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OldCreateOrder: Boolean read FOldCreateOrder write FOldCreateOrder
      stored True;
  end;

implementation
uses
  ORFn;

constructor TORForm.Create(AOwner: TComponent);
begin
  OldCreateOrder := True;
  inherited Create(AOwner);
  if OldCreateOrder then OldDoCreate;
end;

destructor TORForm.Destroy;
begin
  if OldCreateOrder then OldDoDestroy;
  inherited Destroy;
end;

procedure TORForm.OldDoCreate;
// Timing is based on OldCreateOrder
begin
  inherited DoCreate;
  // After all OnCreate events have fired we resize the form to the currently
  // set MainFontSize. It is important to do this AFTER OnCreate events as in
  // OnCreate events we may Create components that are expected to always be
  // present (i.e. no If Assigned checks) on OnResize events, and form resizing
  // triggers OnResize events.
  DoSetFontSize(ORFn.MainFontSize);
end;

procedure TORForm.DoCreate;
// Timing is based on new Create order
begin
  if not OldCreateOrder then OldDoCreate;
end;

procedure TORForm.OldDoDestroy;
// Timing is based on OldCreateOrder
begin
  inherited DoDestroy;
end;

procedure TORForm.DoDestroy;
// Timing is based on new Create order
begin
  if not OldCreateOrder then OldDoDestroy;
end;

procedure TORForm.DoSetFontSize(FontSize: Integer);
// This may be overriden in child classes (FE: unit fODBase in CPRS)
begin
  ORFn.ResizeAnchoredFormToFont(Self);
end;

procedure TORForm.Loaded;
begin
  inherited;
  // After all properties are loaded, we set the Font.Size for the form to 8
  // points. This will guarantee that font sizing will work correctly on all
  // components on the form with ParentFont set to True. If the form itself
  // uses ParentFont we leave Font.Size alone.
  if not ParentFont then Font.Size := 8;
end;

procedure TORForm.ReadOldCreateOrder(Reader: TReader);
begin
  FOldCreateOrder := Reader.ReadBoolean;
end;

procedure TORForm.WriteOldCreateOrder;
begin
  Writer.WriteBoolean(FOldCreateOrder);
end;

procedure TORForm.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  // The below code overrides the reading and writing for OldCreateOrder as
  // defined in TCustomForm.DefineProperties in Delphi 11 and further. It
  // effectively restores this functionality to Delphi 10 behavior.
  Filer.DefineProperty('OldCreateOrder', ReadOldCreateOrder,
    WriteOldCreateOrder, False);
end;

end.
