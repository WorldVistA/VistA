inherited frmOMVerify: TfrmOMVerify
  Left = 360
  Top = 243
  BorderIcons = []
  Caption = 'New Order'
  ClientHeight = 202
  ClientWidth = 560
  Position = poDesigned
  ExplicitWidth = 576
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 16
  object pnlButtons: TPanel [0]
    Left = 0
    Top = 170
    Width = 560
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 149
    ExplicitWidth = 579
    object cmdEdit: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 72
      Height = 26
      Align = alLeft
      Caption = 'Edit'
      TabOrder = 0
      OnClick = cmdEditClick
      ExplicitLeft = 253
      ExplicitTop = 20
      ExplicitHeight = 21
    end
    object cmdAccept: TButton
      AlignWithMargins = True
      Left = 407
      Top = 3
      Width = 72
      Height = 26
      Align = alRight
      Caption = 'Accept'
      Default = True
      TabOrder = 1
      OnClick = cmdAcceptClick
      ExplicitLeft = 165
      ExplicitTop = 20
      ExplicitHeight = 21
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 485
      Top = 3
      Width = 72
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = cmdCancelClick
      ExplicitLeft = 341
      ExplicitTop = 20
      ExplicitHeight = 21
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 560
    Height = 170
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 208
    ExplicitTop = 88
    ExplicitWidth = 185
    ExplicitHeight = 41
    object memText: TRichEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 552
      Height = 162
      TabStop = False
      Align = alClient
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
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WantTabs = True
      WordWrap = False
      Zoom = 100
      OnKeyDown = memTextKeyDown
    end
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
        'Text = Order information.'
        'Status = stsOK')
      (
        'Component = frmOMVerify'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = memText
    OnStateQuery = VA508ComponentAccessibility1StateQuery
    Left = 48
    Top = 32
  end
end
