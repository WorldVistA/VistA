inherited frmOMVerify: TfrmOMVerify
  Left = 328
  Top = 243
  BorderIcons = []
  Caption = 'New Order'
  ClientHeight = 181
  ClientWidth = 579
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 587
  ExplicitHeight = 208
  PixelsPerInch = 96
  TextHeight = 13
  object cmdAccept: TButton [0]
    Left = 165
    Top = 154
    Width = 72
    Height = 21
    Caption = 'Accept'
    Default = True
    TabOrder = 0
    OnClick = cmdAcceptClick
  end
  object cmdEdit: TButton [1]
    Left = 253
    Top = 154
    Width = 72
    Height = 21
    Caption = 'Edit'
    TabOrder = 1
    OnClick = cmdEditClick
  end
  object cmdCancel: TButton [2]
    Left = 341
    Top = 154
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object memText: TRichEdit [3]
    Left = 6
    Top = 6
    Width = 567
    Height = 132
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      
        '1234567890123456789012345678901234567890123456789012345678901234' +
        '5678901234567890'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 3
    WantTabs = True
    WordWrap = False
    OnKeyUp = memTextKeyUp
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdEdit'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = memText'
        'Status = stsDefault')
      (
        'Component = frmOMVerify'
        'Status = stsDefault'))
  end
end
