inherited frmODMessage: TfrmODMessage
  Left = 271
  Top = 515
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  ClientHeight = 39
  ClientWidth = 374
  FormStyle = fsStayOnTop
  Position = poOwnerFormCenter
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    374
    39)
  PixelsPerInch = 96
  TextHeight = 13
  object imgMessage: TImage [0]
    Left = 4
    Top = 4
    Width = 32
    Height = 32
  end
  object memMessage: TRichEdit [1]
    Left = 40
    Top = 4
    Width = 332
    Height = 32
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInfoText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODMessage'
        'Status = stsDefault'))
  end
end
