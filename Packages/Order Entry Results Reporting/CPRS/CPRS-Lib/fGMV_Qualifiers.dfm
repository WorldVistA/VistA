object frmGMV_Qualifiers: TfrmGMV_Qualifiers
  Left = 460
  Top = 247
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 246
  ClientWidth = 247
  Color = clBtnFace
  Constraints.MinWidth = 127
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 247
    Height = 246
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 1
    TabOrder = 0
    object pnlBottom: TPanel
      Left = 3
      Top = 178
      Width = 241
      Height = 65
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = pnlBottomResize
      DesignSize = (
        241
        65)
      object btnOK: TButton
        Left = 85
        Top = 34
        Width = 74
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 161
        Top = 34
        Width = 74
        Height = 25
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
      object edtQuals: TEdit
        Left = 9
        Top = 0
        Width = 224
        Height = 24
        TabOrder = 2
        Text = 'edtQuals'
      end
    end
  end
end
