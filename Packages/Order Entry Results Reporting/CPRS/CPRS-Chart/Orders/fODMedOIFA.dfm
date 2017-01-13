inherited frmODMedOIFA: TfrmODMedOIFA
  Left = 0
  Top = 0
  Caption = 'Formulary Alternatives'
  ClientHeight = 219
  ClientWidth = 375
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 0
    Top = 0
    Width = 375
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Caption = 'The selected drug is not in the formulary.  Alternatives are:'
    ExplicitWidth = 340
  end
  object Label2: TStaticText [1]
    Left = 0
    Top = 166
    Width = 375
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    Caption = 'Do you wish to use the selected alternative instead?'
    TabOrder = 1
    ExplicitTop = 165
    ExplicitWidth = 310
  end
  object lstFormAlt: TORListBox [2]
    Left = 0
    Top = 16
    Width = 375
    Height = 150
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = lstFormAltClick
    Caption = 'The selected drug is not in the formulary.  Alternatives are:'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
    ExplicitHeight = 149
  end
  object btnPanel: TPanel [3]
    Left = 0
    Top = 186
    Width = 375
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object cmdYes: TButton
      Left = 91
      Top = 4
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Yes'
      Default = True
      Enabled = False
      TabOrder = 0
      OnClick = cmdYesClick
    end
    object cmdNo: TButton
      Left = 199
      Top = 4
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Cancel = True
      Caption = 'No'
      TabOrder = 1
      OnClick = cmdNoClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Label2'
        'Status = stsDefault')
      (
        'Component = lstFormAlt'
        'Status = stsDefault')
      (
        'Component = btnPanel'
        'Status = stsDefault')
      (
        'Component = cmdYes'
        'Status = stsDefault')
      (
        'Component = cmdNo'
        'Status = stsDefault')
      (
        'Component = frmODMedOIFA'
        'Status = stsDefault'))
  end
end
