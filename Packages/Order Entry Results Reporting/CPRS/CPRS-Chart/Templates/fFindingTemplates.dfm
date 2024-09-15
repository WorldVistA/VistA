inherited frmFindingTemplates: TfrmFindingTemplates
  Left = 0
  Top = 0
  Cursor = crAppStart
  BorderIcons = []
  Caption = 'Finding Template'
  ClientHeight = 127
  ClientWidth = 229
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object lblFind: TLabel
    Left = 0
    Top = 50
    Width = 229
    Height = 23
    Align = alTop
    Alignment = taCenter
    Caption = 'Finding Template'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 146
  end
  object Label2: TLabel
    Left = 0
    Top = 73
    Width = 229
    Height = 19
    Align = alTop
    Alignment = taCenter
    Caption = '(This may take some time)'
    ExplicitWidth = 190
  end
  object animSearch: TAnimate
    Left = 0
    Top = 0
    Width = 229
    Height = 50
    Align = alTop
    CommonAVI = aviFindFolder
    StopFrame = 29
  end
  object btnCancel: TButton
    Left = 80
    Top = 98
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Default = True
    TabOrder = 1
    OnClick = btnCancelClick
  end
end
