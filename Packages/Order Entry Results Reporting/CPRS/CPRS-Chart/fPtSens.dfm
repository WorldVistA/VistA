inherited frmPtSens: TfrmPtSens
  Left = 216
  Top = 373
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Restricted Patient Record'
  ClientHeight = 181
  ClientWidth = 596
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object imgWarning: TImage [0]
    Left = 16
    Top = 16
    Width = 32
    Height = 32
  end
  object lblContinue: TStaticText [1]
    Left = 64
    Top = 150
    Width = 267
    Height = 17
    Caption = 'Do you want to continue processing this patient record?'
    TabOrder = 3
  end
  object memWarning: TMemo [2]
    Left = 64
    Top = 16
    Width = 517
    Height = 113
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '                           *** WARNING ***'
      '                       *** RESTRICTED RECORD ***'
      
        '* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ' +
        '* * * * * '
      
        '* This record is protected by the Privacy Act of 1974. If you el' +
        'ect     *'
      
        '* to proceed, you will be required to prove you have a need to k' +
        'now.    *'
      
        '* Accessing this patient is tracked, and your station Security O' +
        'fficer  *'
      
        '* will contact you for your justification.                      ' +
        '        *'
      
        '* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ' +
        '* * * * * '
      '')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object cmdYes: TButton [3]
    Left = 408
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Yes'
    TabOrder = 1
    OnClick = cmdYesClick
  end
  object cmdNo: TButton [4]
    Left = 500
    Top = 144
    Width = 75
    Height = 25
    Caption = 'No'
    Default = True
    TabOrder = 2
    OnClick = cmdNoClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblContinue'
        'Status = stsDefault')
      (
        'Component = memWarning'
        'Status = stsDefault')
      (
        'Component = cmdYes'
        'Status = stsDefault')
      (
        'Component = cmdNo'
        'Status = stsDefault')
      (
        'Component = frmPtSens'
        'Status = stsDefault'))
  end
end
