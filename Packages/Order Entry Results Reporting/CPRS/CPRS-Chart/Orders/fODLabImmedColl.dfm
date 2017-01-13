inherited frmODLabImmedColl: TfrmODLabImmedColl
  Left = 146
  Top = 150
  Caption = 'Immediate Collection Times'
  ClientHeight = 259
  ClientWidth = 516
  OldCreateOrder = True
  OnShow = FormShow
  ExplicitWidth = 532
  ExplicitHeight = 297
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 516
    Height = 259
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblImmedColl: TOROffsetLabel
      Left = 26
      Top = 202
      Width = 149
      Height = 15
      Caption = 'Enter or select a collection time'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object memImmedCollect: TCaptionMemo
      Left = 0
      Top = 0
      Width = 516
      Height = 193
      Align = alTop
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'Collection times')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      Caption = 'Collection times'
    end
    object calImmedCollect: TORDateBox
      Left = 26
      Top = 216
      Width = 219
      Height = 21
      TabOrder = 1
      OnKeyUp = calImmedCollectKeyUp
      DateOnly = False
      RequireTime = False
      Caption = 'Enter or select a collection time'
    end
    object cmdOK: TORAlignButton
      Left = 309
      Top = 213
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TORAlignButton
      Left = 405
      Top = 213
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = memImmedCollect'
        'Status = stsDefault')
      (
        'Component = calImmedCollect'
        'Text = Collection time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmODLabImmedColl'
        'Status = stsDefault'))
  end
end
