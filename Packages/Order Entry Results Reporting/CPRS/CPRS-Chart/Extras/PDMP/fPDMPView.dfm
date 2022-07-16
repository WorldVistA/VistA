object pdmpView: TpdmpView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Prescription Drug Monitoring Program Results'
  ClientHeight = 409
  ClientWidth = 624
  Color = clCream
  Constraints.MinHeight = 320
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
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
    Width = 624
    Height = 35
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    ParentBackground = False
    ShowCaption = False
    TabOrder = 1
    object btnDone: TButton
      AlignWithMargins = True
      Left = 488
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
      Left = 344
      Top = 3
      Width = 138
      Height = 29
      Align = alRight
      Caption = '&Cancel Without Update'
      ModalResult = 2
      TabOrder = 0
    end
  end
  object pnlCanvas: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 374
    Align = alClient
    Caption = 'pnlCanvas'
    ShowCaption = False
    TabOrder = 0
    object splBrowser: TSplitter
      Left = 1
      Top = 251
      Width = 622
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitLeft = 4
      ExplicitTop = 235
    end
    object pnlBrowser: TPanel
      Left = 1
      Top = 1
      Width = 622
      Height = 250
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlBrowser'
      ShowCaption = False
      TabOrder = 0
      object wbPDMP: TWebBrowser
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 616
        Height = 244
        Align = alClient
        TabOrder = 0
        OnNavigateComplete2 = wbPDMPNavigateComplete2
        OnNavigateError = wbPDMPNavigateError
        ExplicitLeft = 43
        ExplicitTop = 35
        ExplicitWidth = 576
        ExplicitHeight = 166
        ControlData = {
          4C000000AA3F0000381900000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E12620A000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    inline frPDMPReview: TfrPDMPReviewOptions
      Left = 1
      Top = 254
      Width = 622
      Height = 119
      Align = alBottom
      TabOrder = 1
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 254
      ExplicitWidth = 622
      ExplicitHeight = 119
      inherited sbPDMP: TScrollBox
        Width = 616
        Height = 113
        ExplicitWidth = 616
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
  end
end
