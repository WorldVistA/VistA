inherited frmPtSelMsg: TfrmPtSelMsg
  Left = 375
  Top = 421
  Caption = 'Patient Lookup Messages'
  ClientHeight = 147
  ClientWidth = 367
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 375
  ExplicitHeight = 174
  DesignSize = (
    367
    147)
  PixelsPerInch = 96
  TextHeight = 13
  object cmdClose: TButton [0]
    Left = 158
    Top = 114
    Width = 60
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 0
    OnClick = cmdCloseClick
  end
  object memMessages: TRichEdit [1]
    Left = 0
    Top = 0
    Width = 367
    Height = 107
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clCream
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    WantReturns = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdClose'
        'Status = stsDefault')
      (
        'Component = memMessages'
        'Status = stsDefault')
      (
        'Component = frmPtSelMsg'
        'Status = stsDefault'))
  end
  object timClose: TTimer
    OnTimer = timCloseTimer
    Left = 6
    Top = 126
  end
end
