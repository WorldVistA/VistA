unit mVImmBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ImgList, Vcl.Buttons, System.ImageList, VA508AccessibilityRouter, VAUtils;

type
  TPanelHelper = class helper for TPanel
  strict private
    function GetOnKeyDown: TKeyEvent;
    procedure SetOnKeyDown(AKeyEvent: TKeyEvent);
  public
    property OnKeyDown: TKeyEvent read GetOnKeyDown write SetOnKeyDown;
  end;


  TfraParent = class(TFrame)
    pnlHeader: TPanel;
    pnlWorkspace: TPanel;
    lblHeader: TLabel;
    imgLst: TImageList;
    spBtnExpandCollapse: TSpeedButton;
    procedure spbtnExpandCollapseClick(Sender: TObject);
    procedure pnlHeaderEnter(Sender: TObject);
  private
    { Private declarations }
  protected
    fCollapsed: boolean;
  public
    { Public declarations }
    style: TSizeStyle;
    minValue: double;
    constructor Create(aOwner: TComponent); override;
    procedure PanelKeyDown(Sender: TObject; var Key: Word; Shift:TShiftState);
//    destructor Destroy; override;

  end;

implementation

const
  IMG_COLLAPSE = 0;
  IMG_EXPAND = 1;
{$R *.dfm}

{ TFrame1 }
procedure TfraParent.PanelKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_SPACE then
    spbtnExpandCollapseClick(spBtnExpandCollapse);
end;

procedure TfraParent.pnlHeaderEnter(Sender: TObject);
var
tmp: string;
begin
  if ScreenReaderActive then
    begin
      tmp := ' press the space bar to ';
      if fCollapsed then
        tmp := tmp + 'expand the section'
      else tmp := tmp + 'collapse the section';
      GetScreenReader.Speak(lblHeader.Caption + tmp);
    end;
end;

procedure TfraParent.spbtnExpandCollapseClick(Sender: TObject);
var
i: integer;
aGridPanel: TGridPanel;
aControl: TControl;

function AlignRows(aGridPanel: TGridPanel): boolean;
var
  i: integer;
  j,x: integer;
  diff: double;
  total: integer;
  aControl: TControl;
begin
  try
    j := 0;
    total := 0;
    x := 0;
    aGridPanel.RowCollection.BeginUpdate;
    for i := 0 to aGridPanel.RowCollection.Count - 1 do
      if aGridPanel.RowCollection[i].SizeStyle = ssPercent then
        begin
          aControl := aGridPanel.ControlCollection.Controls[0,i];
          if TfraParent(aControl).minValue = 0 then inc(j)
          else begin
            aGridPanel.RowCollection[i].value := TfraParent(aControl).minValue;
            total := total + Round(aGridPanel.RowCollection[i].value);
            inc(x);
          end;
        end;
    //determine if there is extra space to make it to 100%
    if (j = 0) and (total < 100) and (x > 0) then
      begin
        diff := ((100 - total) / x);
        for i := 0 to aGridPanel.RowCollection.Count - 1 do
        if aGridPanel.RowCollection[i].SizeStyle = ssPercent then
            begin
              aGridPanel.RowCollection[i].value := aGridPanel.RowCollection[i].value + Round(diff);
            end;
      end;
    //determine the amount of space that is left for frame that do not have a value property
    if j > 0 then
      begin
        for i := 0 to aGridPanel.RowCollection.Count - 1 do
        if aGridPanel.RowCollection[i].SizeStyle = ssPercent then
          aGridPanel.RowCollection[i].Value := ((100 - total) / j);
      end;

    aGridPanel.RowCollection.EndUpdate;
    Result := True;
  except
    aGridPanel.RowCollection.EndUpdate;
    Result := False;
  end;
end;

begin
  if self.Parent is TGridPanel then
    try
      aGridPanel := TGridPanel(Parent);
      fCollapsed := not fCollapsed;
      aGridPanel.RowCollection.BeginUpdate;
      i := aGridPanel.ControlCollection.IndexOf(self);
      with aGridPanel.RowCollection[i] do
        begin
          if fCollapsed then
            begin
              SizeStyle := ssAbsolute;
              Value := pnlWorkspace.Top;
              pnlWorkspace.Visible := false;
              spbtnExpandCollapse.Glyph := nil;
              imgLst.GetBitmap(IMG_EXPAND, spbtnExpandCollapse.Glyph);
            end
          else
            begin
              pnlWorkspace.Visible := true;
              aControl := aGridPanel.ControlCollection.Controls[0,i];
              SizeStyle := TFraparent(aControl).style;
              value := TFraParent(aControl).minValue;
              spbtnExpandCollapse.Glyph := nil;
              imgLst.GetBitmap(IMG_COLLAPSE, spbtnExpandCollapse.Glyph);
              aControl.Refresh;
            end;
        end;
      aGridPanel.RowCollection.EndUpdate;
      AlignRows(aGridPanel);
    except
      ShowMessage('Something went wrong');
    end;
end;

constructor TfraParent.Create(aOwner: TComponent);
begin
  inherited;
    fCollapsed := false;
    spbtnExpandCollapse.Glyph := nil;
    imgLst.GetBitmap(IMG_COLLAPSE, spbtnExpandCollapse.Glyph);
    style := ssPercent;
    minValue := 0;
    self.lblHeader.Font.Size := Application.MainForm.Font.Size;
    if ScreenReaderActive then
      begin
        pnlHeader.TabStop := true;
        pnlHeader.OnKeyDown := PanelKeyDown;
      end;

end;

//destructor TfraParent.Destroy;
//begin
//
//  inherited;
//
//end;


{ TPanelHelper }

function TPanelHelper.GetOnKeyDown: TKeyEvent;
begin
  Result := inherited OnKeyDown;
end;

procedure TPanelHelper.SetOnKeyDown(AKeyEvent: TKeyEvent);
begin
  inherited OnKeyDown := AKeyEvent;
end;

end.
