object frmRoomSelector: TfrmRoomSelector
  Left = 746
  Top = 336
  BorderStyle = bsDialog
  Caption = 'Ward Room Selector'
  ClientHeight = 273
  ClientWidth = 292
  Color = clBtnFace
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 232
    Width = 292
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      292
      41)
    object BitBtn1: TBitBtn
      Left = 126
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 206
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      NumGlyphs = 2
    end
    object ed: TEdit
      Left = 8
      Top = 11
      Width = 112
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      Color = clMenuBar
      Constraints.MinWidth = 100
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 2
      Visible = False
    end
  end
  object pnlCanvas: TPanel
    Left = 0
    Top = 0
    Width = 292
    Height = 232
    Align = alClient
    TabOrder = 1
    DesignSize = (
      292
      232)
    object gbRooms: TGroupBox
      Left = 8
      Top = 8
      Width = 275
      Height = 215
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = '  Ward  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
end
