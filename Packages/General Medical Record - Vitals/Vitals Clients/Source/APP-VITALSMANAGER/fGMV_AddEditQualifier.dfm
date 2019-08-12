object frmGMV_AddEditQualifier: TfrmGMV_AddEditQualifier
  Left = 451
  Top = 249
  HelpContext = 3
  BorderStyle = bsDialog
  Caption = 'Edit Qualifier'
  ClientHeight = 136
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 126
    Height = 13
    Caption = 'Qualifier Name (2-50 char):'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 110
    Height = 13
    Caption = 'Abbreviation (1-3 char):'
  end
  object edtName: TEdit
    Left = 8
    Top = 24
    Width = 241
    Height = 21
    Hint = 'Names: 2-50 characters'
    MaxLength = 50
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = 'edtName'
    OnChange = edtNameChange
    OnEnter = edtNameEnter
    OnExit = edtNameExit
    OnKeyPress = edtNameKeyPress
  end
  object edtAbbv: TEdit
    Left = 8
    Top = 64
    Width = 73
    Height = 21
    Hint = 'Abbriviations: 1-3 characters'
    MaxLength = 3
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = 'edtAbbv'
    OnChange = edtAbbvChange
    OnEnter = edtAbbvEnter
    OnExit = edtAbbvExit
  end
  object Panel1: TPanel
    Left = 0
    Top = 95
    Width = 256
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 2
    object btnCancel: TButton
      Left = 176
      Top = 8
      Width = 73
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 98
      Top = 8
      Width = 73
      Height = 25
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnApply: TButton
      Left = 8
      Top = 8
      Width = 73
      Height = 25
      Caption = 'Apply'
      TabOrder = 2
      Visible = False
      OnClick = btnOKClick
    end
  end
end
