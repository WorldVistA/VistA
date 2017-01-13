inherited frmProbCmt: TfrmProbCmt
  Left = 205
  Top = 220
  Caption = 'Annotate a problem'
  ClientHeight = 101
  ClientWidth = 403
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 419
  ExplicitHeight = 139
  PixelsPerInch = 96
  TextHeight = 13
  object lblComment: TOROffsetLabel [0]
    Left = 9
    Top = 10
    Width = 215
    Height = 15
    Caption = 'Enter a new comment (up to 200 characters):'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object edComment: TCaptionEdit [1]
    Left = 11
    Top = 30
    Width = 386
    Height = 21
    MaxLength = 200
    TabOrder = 0
    Caption = 'Enter a new comment (up to 200 characters)'
  end
  object bbOK: TBitBtn [2]
    Left = 115
    Top = 60
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = bbOKClick
  end
  object bbCancel: TBitBtn [3]
    Left = 200
    Top = 60
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    NumGlyphs = 2
    TabOrder = 2
    OnClick = bbCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = edComment'
        'Status = stsDefault')
      (
        'Component = bbOK'
        'Status = stsDefault')
      (
        'Component = bbCancel'
        'Status = stsDefault')
      (
        'Component = frmProbCmt'
        'Status = stsDefault'))
  end
end
