inherited frmOrdersPickEvent: TfrmOrdersPickEvent
  Left = 305
  Top = 257
  BorderIcons = []
  Caption = 'Delayed Orders Exist for this Patient'
  ClientHeight = 212
  ClientWidth = 389
  Constraints.MinHeight = 200
  Constraints.MinWidth = 200
  Position = poScreenCenter
  ExplicitWidth = 405
  ExplicitHeight = 250
  PixelsPerInch = 96
  TextHeight = 13
  object lblMain: TLabel [0]
    Left = 8
    Top = 8
    Width = 322
    Height = 13
    Caption = 'Please choose which order set to continue working with:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 179
    Width = 389
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 153
    ExplicitWidth = 622
    DesignSize = (
      389
      33)
    object cmdOK: TButton
      Left = 281
      Top = 6
      Width = 80
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 6
      TabOrder = 0
      ExplicitLeft = 260
    end
  end
  object lstOrders: TORListBox [2]
    Left = 0
    Top = 32
    Width = 389
    Height = 147
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Caption = ''
    ItemTipColor = clWindow
    LongList = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 184
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = frmOrdersPickEvent'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'Status = stsDefault'))
  end
end
