inherited frmODMedFA: TfrmODMedFA
  Left = 333
  Top = 258
  Caption = 'Formulary Alternatives'
  ClientHeight = 178
  ClientWidth = 308
  FormStyle = fsStayOnTop
  OnCreate = FormCreate
  ExplicitWidth = 316
  ExplicitHeight = 205
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 8
    Width = 273
    Height = 13
    Caption = 'The selected drug is not in the formulary.  Alternatives are:'
  end
  object Label2: TStaticText [1]
    Left = 8
    Top = 127
    Width = 250
    Height = 17
    Caption = 'Do you wish to use the selected alternative instead?'
    TabOrder = 3
  end
  object lstFormAlt: TORListBox [2]
    Left = 8
    Top = 22
    Width = 292
    Height = 97
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = lstFormAltClick
    Caption = 'The selected drug is not in the formulary.  Alternatives are:'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
  end
  object cmdYes: TButton [3]
    Left = 74
    Top = 148
    Width = 72
    Height = 21
    Caption = 'Yes'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = cmdYesClick
  end
  object cmdNo: TButton [4]
    Left = 162
    Top = 148
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'No'
    TabOrder = 2
    OnClick = cmdNoClick
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
        'Component = cmdYes'
        'Status = stsDefault')
      (
        'Component = cmdNo'
        'Status = stsDefault')
      (
        'Component = frmODMedFA'
        'Status = stsDefault'))
  end
end
