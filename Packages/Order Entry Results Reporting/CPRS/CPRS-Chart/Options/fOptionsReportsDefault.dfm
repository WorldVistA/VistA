inherited frmOptionsReportsDefault: TfrmOptionsReportsDefault
  Left = 773
  Top = 334
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Default Settings For Available CPRS Reports'
  ClientHeight = 205
  ClientWidth = 384
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel [0]
    Left = 8
    Top = 118
    Width = 23
    Height = 13
    Caption = 'Max:'
  end
  object Label3: TLabel [1]
    Left = 8
    Top = 48
    Width = 51
    Height = 13
    Caption = 'Start Date:'
  end
  object Label4: TLabel [2]
    Left = 8
    Top = 81
    Width = 51
    Height = 13
    Caption = 'Stop Date:'
  end
  object Bevel1: TBevel [3]
    Left = 8
    Top = 8
    Width = 337
    Height = 2
  end
  object Bevel2: TBevel [4]
    Left = 0
    Top = 173
    Width = 384
    Height = 2
    Align = alBottom
  end
  object lblDefaultText: TMemo [5]
    Left = 232
    Top = 40
    Width = 137
    Height = 121
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Click dots in boxes to set '
      'start and end dates. You can '
      'also input values directly.')
    ReadOnly = True
    TabOrder = 4
  end
  object edtDefaultMax: TCaptionEdit [6]
    Left = 96
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 2
    OnClick = edtDefaultMaxClick
    OnExit = edtDefaultMaxExit
    OnKeyPress = edtDefaultMaxKeyPress
    Caption = 'Max'
  end
  object Panel1: TPanel [7]
    Left = 0
    Top = 175
    Width = 384
    Height = 30
    Align = alBottom
    TabOrder = 3
    object btnOK: TButton
      Left = 264
      Top = 4
      Width = 50
      Height = 22
      Hint = 'Click to save the new setting.'
      Caption = 'OK'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnReset: TButton
      Left = 176
      Top = 4
      Width = 81
      Height = 22
      Hint = 'Click to keep original setting'
      Caption = 'Use Defaults'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnResetClick
    end
    object btnCancel: TButton
      Left = 320
      Top = 4
      Width = 57
      Height = 22
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
  end
  object odcDfStart: TORDateBox [8]
    Left = 96
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 0
    OnClick = odcDfStartClick
    OnExit = odcDfStartExit
    OnKeyPress = odcDfStartKeyPress
    DateOnly = True
    RequireTime = False
  end
  object odcDfStop: TORDateBox [9]
    Left = 96
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 1
    OnClick = odcDfStopClick
    OnExit = odcDfStopExit
    OnKeyPress = odcDfStopKeyPress
    DateOnly = True
    RequireTime = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblDefaultText'
        'Status = stsDefault')
      (
        'Component = edtDefaultMax'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnReset'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = odcDfStart'
        'Status = stsDefault')
      (
        'Component = odcDfStop'
        'Status = stsDefault')
      (
        'Component = frmOptionsReportsDefault'
        'Status = stsDefault'))
  end
end
