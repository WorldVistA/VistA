object frmGMV_PtSelect: TfrmGMV_PtSelect
  Left = 492
  Top = 237
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'frmGMV_PtSelect'
  ClientHeight = 106
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    388
    106)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 304
    Top = 74
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 224
    Top = 74
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object pnlPtInfo: TPanel
    Left = 0
    Top = 0
    Width = 388
    Height = 57
    HelpContext = 2
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
  end
  object btnAgree: TButton
    Left = 8
    Top = 74
    Width = 210
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = '&I understand the security issues'
    TabOrder = 3
    Visible = False
    OnClick = btnAgreeClick
  end
end
