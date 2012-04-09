inherited frmWardComments: TfrmWardComments
  Left = 334
  Top = 234
  Caption = 'Comments for Order'
  ClientHeight = 262
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 289
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 80
    Width = 52
    Height = 13
    Caption = 'Comments:'
  end
  object cmdOK: TButton [1]
    Left = 267
    Top = 233
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [2]
    Left = 347
    Top = 233
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object memOrder: TMemo [3]
    Left = 8
    Top = 8
    Width = 411
    Height = 56
    TabStop = False
    Color = clBtnFace
    Lines.Strings = (
      'memOrder')
    ReadOnly = True
    TabOrder = 3
    WantReturns = False
  end
  object memComments: TRichEdit [4]
    Left = 8
    Top = 94
    Width = 411
    Height = 123
    ScrollBars = ssVertical
    TabOrder = 0
    WantTabs = True
    OnKeyUp = memCommentsKeyUp
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = frmWardComments'
        'Status = stsDefault'))
  end
end
