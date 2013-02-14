inherited frmGraphData: TfrmGraphData
  Left = 0
  Top = 0
  Caption = 'GraphData - displayed only for testing'
  ClientHeight = 582
  ClientWidth = 782
  Font.Name = 'Tahoma'
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = btnRefreshClick
  ExplicitWidth = 790
  ExplicitHeight = 609
  PixelsPerInch = 96
  TextHeight = 13
  object pnlData: TPanel [0]
    Left = 0
    Top = 0
    Width = 782
    Height = 504
    Align = alClient
    TabOrder = 0
  end
  object pnlInfo: TPanel [1]
    Left = 0
    Top = 504
    Width = 782
    Height = 78
    Align = alBottom
    TabOrder = 1
    object lblInfo: TLabel
      Left = 14
      Top = 5
      Width = 162
      Height = 13
      Caption = 'Resize form before clicking button'
    end
    object lblInfoPersonal: TLabel
      Left = 184
      Top = 19
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Personal'
    end
    object lblInfoPublic: TLabel
      Left = 198
      Top = 33
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = 'Public'
    end
    object lblPublic: TLabel
      Left = 232
      Top = 33
      Width = 3
      Height = 13
    end
    object lblPersonal: TLabel
      Left = 231
      Top = 19
      Width = 3
      Height = 13
    end
    object lblCurrent: TLabel
      Left = 232
      Top = 5
      Width = 3
      Height = 13
    end
    object lblInfoCurrent: TLabel
      Left = 188
      Top = 5
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = 'Current'
    end
    object btnData: TButton
      Left = 14
      Top = 22
      Width = 75
      Height = 25
      Caption = 'TStringLists'
      TabOrder = 0
      OnClick = btnDataClick
    end
    object btnRefresh: TButton
      Left = 102
      Top = 22
      Width = 75
      Height = 25
      Caption = 'Refresh'
      Enabled = False
      TabOrder = 1
      OnClick = btnRefreshClick
    end
    object btnTesting: TButton
      Left = 14
      Top = 50
      Width = 75
      Height = 25
      Caption = 'Testing'
      TabOrder = 2
      OnClick = btnTestingClick
    end
    object memTesting: TMemo
      Left = 120
      Top = 48
      Width = 649
      Height = 27
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
