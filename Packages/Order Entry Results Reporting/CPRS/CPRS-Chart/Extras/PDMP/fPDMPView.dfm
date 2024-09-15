object pdmpView: TpdmpView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Prescription Drug Monitoring Program Results'
  ClientHeight = 409
  ClientWidth = 1024
  Color = clCream
  Constraints.MinHeight = 320
  Constraints.MinWidth = 1040
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 374
    Width = 1024
    Height = 35
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    ParentBackground = False
    ShowCaption = False
    TabOrder = 1
    object btnDone: TButton
      AlignWithMargins = True
      Left = 888
      Top = 3
      Width = 133
      Height = 29
      Align = alRight
      Caption = 'Done and Update Note'
      ModalResult = 1
      TabOrder = 1
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 744
      Top = 3
      Width = 138
      Height = 29
      Align = alRight
      Caption = '&Cancel Without Update'
      ModalResult = 2
      TabOrder = 0
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 680
      Top = 3
      Width = 58
      Height = 29
      Hint = 'Close'
      Align = alRight
      Caption = 'C&lose'
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object btnBrowser: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 150
      Height = 29
      Hint = 'What is My Web Browser?'
      Align = alLeft
      Caption = 'What is my Browser?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnBrowserClick
    end
  end
  object pnlCanvas: TPanel
    Left = 0
    Top = 0
    Width = 1024
    Height = 374
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    object splBrowser: TSplitter
      Left = 1
      Top = 251
      Width = 1022
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitLeft = 4
      ExplicitTop = 235
      ExplicitWidth = 622
    end
    object pnlBrowser: TPanel
      Left = 1
      Top = 1
      Width = 1022
      Height = 250
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Please WAIT - report  ggeneration is in progress'
      TabOrder = 0
      object wbPDMP: TWebBrowser
        Left = 0
        Top = 0
        Width = 1022
        Height = 250
        Align = alClient
        TabOrder = 0
        SelectedEngine = EdgeIfAvailable
        OnNavigateError = wbPDMPNavigateError
        ExplicitLeft = -1
        ControlData = {
          4C000000A0690000D71900000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    inline frPDMPReview: TfrPDMPReviewOptions
      Left = 1
      Top = 254
      Width = 1022
      Height = 119
      Align = alBottom
      TabOrder = 1
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 254
      ExplicitWidth = 1022
      ExplicitHeight = 119
      inherited sbPDMP: TScrollBox
        Width = 1016
        Height = 113
        ExplicitWidth = 1016
        ExplicitHeight = 113
      end
    end
  end
  object alResults: TActionList
    Left = 16
    Top = 16
    object acSelectAll: TAction
      Caption = 'Check &All'
    end
    object acBrowser: TAction
      Caption = 'Browser'
    end
    object WindowClose1: TWindowClose
      Category = 'Window'
      Caption = 'C&lose'
      Enabled = False
      Hint = 'Close'
    end
    object acVerifySave: TAction
      Caption = 'Done && Update Note'
      OnExecute = acVerifySaveExecute
    end
  end
end
