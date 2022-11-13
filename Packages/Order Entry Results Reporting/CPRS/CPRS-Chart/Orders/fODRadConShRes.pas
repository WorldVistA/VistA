unit fODRadConShRes;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ORCtrls, ORfn, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmODRadConShRes = class(TfrmBase508Form)
    cmdOK: TButton;
    cmdCancel: TButton;
    cboSource: TORComboBox;
    SrcLabel: TLabel;
    pnlBase: TORAutoPanel;
    txtResearch: TCaptionEdit;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    FSource: string  ;
    FChanged: Boolean;
  end;

procedure SelectSource(FontSize: Integer; SrcType: char; var Source: string) ;

implementation

{$R *.DFM}

uses rODRad, rCore, uCore;

const
  TX_CS_TEXT = 'Select Source, or press Cancel.';
  TX_CS_CAP = 'No Source';
  TX_R_TEXT = 'Enter Source (3-40 characters), or press Cancel.';
  TX_R_CAP = 'No Source';

procedure SelectSource(FontSize: Integer; SrcType: char; var Source: string) ;
{ displays Source entry/selection form and returns a record of the selection }
var
  frmODRadConShRes: TfrmODRadConShRes;
  W, H: Integer;
begin
  frmODRadConShRes := TfrmODRadConShRes.Create(Application);
  try
    with frmODRadConShRes do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      if CharInSet(SrcType, ['C','S']) then with cboSource do
         begin
           SubsetOfRadSources(cboSource.Items, SrcType);
           if Items.Count > 0 then
            begin
             txtResearch.Enabled := False;
             Enabled := True;
             SelectByID(Piece(Source,U,1));
             cboSource.Visible := True;
             txtResearch.Visible := False;
             //BringToFront;
             ShowModal;
            end
           {else if Items.Count = 1 then
             FSource := Items[0]}
           else
             FSource := '-1';
         end
      else if SrcType = 'R' then
        begin
          cboSource.Enabled := False;
          cboSource.Visible := False;
          srcLabel.Caption := 'Enter Source:';
          txtResearch.Visible := True;
          //txtResearch.BringToFront;
          txtResearch.Text := Source;
          ShowModal;
          FSource := txtResearch.Text;
        end;
      Source:= FSource ;
    end; {frmODRadConShRes}
  finally
    frmODRadConShRes.Release;
  end;
end;

procedure TfrmODRadConShRes.cmdCancelClick(Sender: TObject);
begin
  FChanged := False ;
  FSource := '';
  Close;
end;

procedure TfrmODRadConShRes.cmdOKClick(Sender: TObject);
begin
 if cboSource.Enabled then with cboSource do
  begin
   if ItemIEN = 0 then
    begin
     InfoBox(TX_CS_TEXT, TX_CS_CAP, MB_OK or MB_ICONWARNING);
     FChanged := False ;
     FSource := '';
     Exit;
    end;
   FChanged := True;
   FSource := Items[ItemIndex];
  end
 else
  begin
   if (Length(txtResearch.Text)<3) or (Length(txtResearch.Text)> 40) then
    begin
     InfoBox(TX_R_TEXT, TX_R_CAP, MB_OK or MB_ICONWARNING);
     FChanged := False ;
     FSource := '';
     Exit;
    end ;
   FChanged := True;
   FSource := txtResearch.Text;
  end;
 Close;
end;

end.
