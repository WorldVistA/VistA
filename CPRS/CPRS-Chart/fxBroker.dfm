inherited frmBroker: TfrmBroker
  Left = 338
  Top = 235
  BorderIcons = [biSystemMenu]
  Caption = 'Broker Calls'
  ClientHeight = 273
  ClientWidth = 427
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  ExplicitWidth = 435
  ExplicitHeight = 300
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 427
    Height = 53
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblMaxCalls: TLabel
      Left = 8
      Top = 8
      Width = 91
      Height = 13
      Caption = 'Max Calls Retained'
    end
    object lblCallID: TStaticText
      Left = 125
      Top = 20
      Width = 90
      Height = 17
      Alignment = taCenter
      Caption = 'Last Broker Call -0'
      TabOrder = 4
    end
    object txtMaxCalls: TCaptionEdit
      Left = 8
      Top = 24
      Width = 81
      Height = 21
      TabOrder = 0
      Text = '10'
      Caption = 'Max Calls Retained'
    end
    object cmdPrev: TBitBtn
      Left = 319
      Top = 8
      Width = 50
      Height = 37
      Caption = 'Prev'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = cmdPrevClick
      Glyph.Data = {
        36010000424D360100000000000076000000280000001E0000000C0000000100
        040000000000C000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777887777
        7777777778877777770077777008777777777777778777777700777700087777
        7777777777877777770077700008888888877777778888888800770000000000
        0087777777777777780070000000000000877777777777777800F00000000000
        008F7777777777777800FF0000000000008F77777777777778007FF00007FFFF
        FF77FF77777FFFFFF70077FF0008777777777FF7778777777700777FF0087777
        777777FF7787777777007777FFF777777777777FFF7777777700}
      Layout = blGlyphTop
    end
    object cmdNext: TBitBtn
      Left = 369
      Top = 8
      Width = 50
      Height = 37
      Caption = 'Next'
      TabOrder = 2
      OnClick = cmdNextClick
      Glyph.Data = {
        36010000424D360100000000000076000000280000001E0000000C0000000100
        040000000000C000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777778877
        777777777778877777007777777F00877777777777F7787777007777777F0008
        7777777777F77787770078888887000087778888887777787700F00000000000
        087F7777777777778700F00000000000008F7777777777777800F00000000000
        007F7777777777777700F00000000000077F7777777777777700FFFFFFFF0000
        777FFFFFFFF7777777007777777F00077777777777F7777777007777777F0077
        7777777777F7777777007777777FF7777777777777FF77777700}
      Layout = blGlyphTop
    end
    object udMax: TUpDown
      Left = 89
      Top = 24
      Width = 15
      Height = 21
      Associate = txtMaxCalls
      Min = 1
      Position = 10
      TabOrder = 3
    end
    object btnRLT: TButton
      Left = 257
      Top = 18
      Width = 31
      Height = 21
      Caption = 'RLT'
      TabOrder = 6
      OnClick = btnRLTClick
    end
  end
  object memData: TRichEdit [1]
    Left = 0
    Top = 53
    Width = 427
    Height = 220
    Align = alClient
    HideScrollBars = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WantReturns = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lblCallID'
        'Status = stsDefault')
      (
        'Component = txtMaxCalls'
        'Status = stsDefault')
      (
        'Component = cmdPrev'
        'Status = stsDefault')
      (
        'Component = cmdNext'
        'Status = stsDefault')
      (
        'Component = udMax'
        'Status = stsDefault')
      (
        'Component = btnRLT'
        'Status = stsDefault')
      (
        'Component = memData'
        'Status = stsDefault')
      (
        'Component = frmBroker'
        'Status = stsDefault'))
  end
end
