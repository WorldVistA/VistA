inherited frmCoverSheetDetailDisplay: TfrmCoverSheetDetailDisplay
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmCoverSheetDetailDisplay'
  ClientHeight = 455
  ClientWidth = 525
  Color = clWindow
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlOptions: TPanel
    Left = 0
    Top = 405
    Width = 525
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    Color = cl3DLight
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      525
      50)
    object lblFontSizer: TLabel
      Left = 24
      Top = 16
      Width = 55
      Height = 13
      Caption = 'lblFontSizer'
      Visible = False
    end
    object btnClose: TButton
      Left = 437
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Close'
      ModalResult = 1
      TabOrder = 0
    end
    object btnPrint: TButton
      Left = 358
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Print'
      TabOrder = 1
    end
  end
  object memDetails: TMemo
    Left = 0
    Top = 0
    Width = 525
    Height = 405
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Ctl3D = True
    DoubleBuffered = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = []
    Lines.Strings = (
      'memDetails')
    ParentCtl3D = False
    ParentDoubleBuffered = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
end
