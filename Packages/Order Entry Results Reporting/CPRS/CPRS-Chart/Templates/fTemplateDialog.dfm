inherited frmTemplateDialog: TfrmTemplateDialog
  Left = 268
  Top = 155
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Text Dialog'
  ClientHeight = 603
  ClientWidth = 910
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnMouseWheel = FormMouseWheel
  OnPaint = FormPaint
  OnResize = FormResize
  ExplicitTop = -110
  ExplicitWidth = 926
  ExplicitHeight = 642
  PixelsPerInch = 96
  TextHeight = 13
  object splFields: TSplitter [0]
    Left = 639
    Top = 0
    Height = 566
    Align = alRight
    Color = clSilver
    ParentColor = False
    Visible = False
    ExplicitLeft = 0
    ExplicitTop = 533
    ExplicitHeight = 636
  end
  object pnlDebug: TPanel [1]
    Left = 642
    Top = 0
    Width = 268
    Height = 566
    Align = alRight
    BevelOuter = bvLowered
    TabOrder = 0
    Visible = False
    object splDebug: TSplitter
      Left = 1
      Top = 240
      Width = 266
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitLeft = 3
      ExplicitTop = 112
    end
    object pnlTables: TPanel
      Left = 1
      Top = 1
      Width = 266
      Height = 239
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlTables'
      ShowCaption = False
      TabOrder = 0
      object dbgControls: TDBGrid
        Left = 0
        Top = 34
        Width = 266
        Height = 205
        Align = alClient
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object cbCdsFieldsRequired: TCheckBox
        Left = 0
        Top = 0
        Width = 266
        Height = 17
        Align = alTop
        Caption = 'Required and Focusable'
        Color = clYellow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = cbCdsFieldsRequiredClick
      end
      object cbText: TCheckBox
        Left = 0
        Top = 17
        Width = 266
        Height = 17
        Align = alTop
        Caption = 'Show Text'
        TabOrder = 2
        OnClick = cbTextClick
      end
    end
    object pnlText: TPanel
      Left = 1
      Top = 243
      Width = 266
      Height = 322
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'pnlText'
      ShowCaption = False
      TabOrder = 1
      Visible = False
      object edTarget: TEdit
        Left = 0
        Top = 0
        Width = 266
        Height = 21
        Align = alTop
        TabOrder = 0
        OnKeyDown = edTargetKeyDown
      end
      object reText: TRichEdit
        Left = 0
        Top = 21
        Width = 266
        Height = 301
        Align = alClient
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 30
        ParentFont = False
        PopupMenu = PopupMenu2
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        WantReturns = False
        WordWrap = False
        Zoom = 100
      end
    end
  end
  object pnlBottomGrid: TPanel [2]
    Left = 0
    Top = 566
    Width = 910
    Height = 37
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    object pnlBottomLeft: TPanel
      Left = 1
      Top = 5
      Width = 8
      Height = 27
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
    end
    object pnlBottomRight: TPanel
      Left = 901
      Top = 5
      Width = 8
      Height = 27
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
    end
    object grdpnlBottom: TGridPanel
      Left = 9
      Top = 5
      Width = 892
      Height = 27
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 75.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 75.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 75.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
        end
        item
          SizeStyle = ssAbsolute
          Value = 75.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 75.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = btnAllGrid
          Row = 0
        end
        item
          Column = 1
          Control = btnNoneGrid
          Row = 0
        end
        item
          Column = 3
          Control = btnPreviewGrid
          Row = 0
        end
        item
          Column = 5
          Control = btnOKGrid
          Row = 0
        end
        item
          Column = 6
          Control = btnCancelGrid
          Row = 0
        end
        item
          Column = 2
          Control = Panel1
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 2
      object btnAllGrid: TButton
        Left = 0
        Top = 0
        Width = 75
        Height = 27
        Align = alClient
        Caption = 'All'
        TabOrder = 0
        OnClick = btnAllClick
      end
      object btnNoneGrid: TButton
        Left = 75
        Top = 0
        Width = 75
        Height = 27
        Align = alClient
        Caption = 'None'
        TabOrder = 1
        OnClick = btnNoneClick
      end
      object btnPreviewGrid: TButton
        Left = 667
        Top = 0
        Width = 75
        Height = 27
        Align = alClient
        Caption = 'Preview'
        TabOrder = 2
        OnClick = btnPreviewClick
      end
      object btnOKGrid: TButton
        Left = 742
        Top = 0
        Width = 75
        Height = 27
        Align = alClient
        Caption = 'OK'
        ModalResult = 1
        TabOrder = 3
        OnClick = btnOKClick
      end
      object btnCancelGrid: TButton
        Left = 817
        Top = 0
        Width = 75
        Height = 27
        Align = alClient
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 4
      end
      object Panel1: TPanel
        Left = 150
        Top = 0
        Width = 517
        Height = 27
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 5
        object StaticText1: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 134
          Height = 21
          Align = alLeft
          Alignment = taCenter
          Caption = '* Indicates a Required Field'
          TabOrder = 0
        end
        object btnDebug: TButton
          Left = 442
          Top = 0
          Width = 75
          Height = 27
          Align = alRight
          Caption = 'Debug'
          TabOrder = 1
          Visible = False
          OnClick = btnDebugClick
        end
        object btnFields: TButton
          Left = 367
          Top = 0
          Width = 75
          Height = 27
          Align = alRight
          Caption = 'Fields'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Visible = False
          OnClick = btnFieldsClick
        end
      end
    end
    object pnlBtnTop: TPanel
      Left = 1
      Top = 1
      Width = 908
      Height = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object pnlBtnBottom: TPanel
      Left = 1
      Top = 32
      Width = 908
      Height = 4
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
    end
  end
  object sbMain: TScrollBox [3]
    Left = 0
    Top = 0
    Width = 639
    Height = 566
    VertScrollBar.Tracking = True
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 2
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 8
    Data = (
      (
        'Component = sbMain'
        'Status = stsDefault')
      (
        'Component = frmTemplateDialog'
        'Status = stsDefault')
      (
        'Component = grdpnlBottom'
        'Status = stsDefault')
      (
        'Component = btnAllGrid'
        'Status = stsDefault')
      (
        'Component = btnNoneGrid'
        'Status = stsDefault')
      (
        'Component = btnPreviewGrid'
        'Status = stsDefault')
      (
        'Component = btnOKGrid'
        'Status = stsDefault')
      (
        'Component = btnCancelGrid'
        'Status = stsDefault')
      (
        'Component = pnlDebug'
        'Status = stsDefault')
      (
        'Component = reText'
        'Status = stsDefault')
      (
        'Component = pnlBottomGrid'
        'Status = stsDefault')
      (
        'Component = pnlBottomLeft'
        'Status = stsDefault')
      (
        'Component = pnlBottomRight'
        'Status = stsDefault')
      (
        'Component = pnlBtnTop'
        'Status = stsDefault')
      (
        'Component = pnlBtnBottom'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = StaticText1'
        'Status = stsDefault')
      (
        'Component = btnDebug'
        'Status = stsDefault')
      (
        'Component = btnFields'
        'Status = stsDefault')
      (
        'Component = cbCdsFieldsRequired'
        'Status = stsDefault')
      (
        'Component = dbgControls'
        'Status = stsDefault')
      (
        'Component = pnlTables'
        'Status = stsDefault')
      (
        'Component = pnlText'
        'Status = stsDefault')
      (
        'Component = edTarget'
        'Status = stsDefault')
      (
        'Component = cbText'
        'Status = stsDefault'))
  end
  object PopupMenu1: TPopupMenu
    Left = 96
    Top = 8
    object S1: TMenuItem
      Caption = 'Highlight Required Fields without Value'
      Checked = True
      OnClick = S1Click
    end
    object S4: TMenuItem
      Caption = 'Set Highlighting Preferences'
      OnClick = S4Click
    end
    object N1: TMenuItem
      Caption = '-'
      Visible = False
    end
    object T1: TMenuItem
      Caption = 'Template Debug Info'
      Visible = False
      OnClick = T1Click
    end
  end
  object CPTemp: TCopyEditMonitor
    CopyMonitor = frmFrame.CPAppMon
    RelatedPackage = 'Template'
    TrackOnlyEdits = <>
    Left = 16
    Top = 64
  end
  object PopupMenu2: TPopupMenu
    Left = 688
    Top = 288
    object Highlight1: TMenuItem
      Caption = 'Highlight'
      OnClick = Highlight1Click
    end
  end
end
