inherited frmGraphData: TfrmGraphData
  Left = 0
  Top = 0
  Caption = 'GraphData - displayed only for testing'
  ClientHeight = 609
  ClientWidth = 818
  Font.Name = 'Tahoma'
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = btnRefreshClick
  ExplicitWidth = 834
  ExplicitHeight = 647
  PixelsPerInch = 96
  TextHeight = 13
  object pnlData: TPanel [0]
    Left = 0
    Top = 0
    Width = 818
    Height = 527
    Align = alClient
    TabOrder = 0
  end
  object pnlInfo: TPanel [1]
    Left = 0
    Top = 527
    Width = 818
    Height = 82
    Align = alBottom
    TabOrder = 1
    object lblInfo: TLabel
      Left = 14
      Top = 6
      Width = 162
      Height = 13
      Caption = 'Resize form before clicking button'
    end
    object lblInfoPersonal: TLabel
      Left = 194
      Top = 20
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Personal'
    end
    object lblInfoPublic: TLabel
      Left = 208
      Top = 34
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = 'Public'
    end
    object lblPublic: TLabel
      Left = 242
      Top = 34
      Width = 3
      Height = 13
    end
    object lblPersonal: TLabel
      Left = 242
      Top = 20
      Width = 3
      Height = 13
    end
    object lblCurrent: TLabel
      Left = 242
      Top = 6
      Width = 3
      Height = 13
    end
    object lblInfoCurrent: TLabel
      Left = 198
      Top = 6
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = 'Current'
    end
    object btnData: TButton
      Left = 14
      Top = 23
      Width = 79
      Height = 26
      Caption = 'TStringLists'
      TabOrder = 0
      OnClick = btnDataClick
    end
    object btnRefresh: TButton
      Left = 106
      Top = 23
      Width = 79
      Height = 26
      Caption = 'Refresh'
      Enabled = False
      TabOrder = 1
      OnClick = btnRefreshClick
    end
    object btnTesting: TButton
      Left = 14
      Top = 52
      Width = 79
      Height = 26
      Caption = 'Testing'
      TabOrder = 2
      OnClick = btnTestingClick
    end
    object memTesting: TMemo
      Left = 126
      Top = 50
      Width = 679
      Height = 28
      ScrollBars = ssVertical
      TabOrder = 3
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlData'
        'Status = stsDefault')
      (
        'Component = pnlInfo'
        'Status = stsDefault')
      (
        'Component = btnData'
        'Status = stsDefault')
      (
        'Component = btnRefresh'
        'Status = stsDefault')
      (
        'Component = frmGraphData'
        'Status = stsDefault')
      (
        'Component = btnTesting'
        'Status = stsDefault')
      (
        'Component = memTesting'
        'Status = stsDefault'))
  end
end
