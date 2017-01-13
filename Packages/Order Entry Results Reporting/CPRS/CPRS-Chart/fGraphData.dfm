inherited frmGraphData: TfrmGraphData
  Left = 0
  Top = 0
  Caption = 'GraphData - displayed only for testing'
  ClientHeight = 761
  ClientWidth = 1023
  Font.Name = 'Tahoma'
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = btnRefreshClick
  ExplicitWidth = 1031
  ExplicitHeight = 793
  PixelsPerInch = 120
  TextHeight = 17
  object pnlData: TPanel [0]
    Left = 0
    Top = 0
    Width = 1023
    Height = 659
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
  end
  object pnlInfo: TPanel [1]
    Left = 0
    Top = 659
    Width = 1023
    Height = 102
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    object lblInfo: TLabel
      Left = 18
      Top = 7
      Width = 206
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resize form before clicking button'
    end
    object lblInfoPersonal: TLabel
      Left = 243
      Top = 25
      Width = 51
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taRightJustify
      Caption = 'Personal'
    end
    object lblInfoPublic: TLabel
      Left = 259
      Top = 43
      Width = 35
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taRightJustify
      Caption = 'Public'
    end
    object lblPublic: TLabel
      Left = 303
      Top = 43
      Width = 4
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object lblPersonal: TLabel
      Left = 302
      Top = 25
      Width = 4
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object lblCurrent: TLabel
      Left = 303
      Top = 7
      Width = 4
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object lblInfoCurrent: TLabel
      Left = 247
      Top = 7
      Width = 47
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taRightJustify
      Caption = 'Current'
    end
    object btnData: TButton
      Left = 18
      Top = 29
      Width = 98
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'TStringLists'
      TabOrder = 0
      OnClick = btnDataClick
    end
    object btnRefresh: TButton
      Left = 133
      Top = 29
      Width = 98
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Refresh'
      Enabled = False
      TabOrder = 1
      OnClick = btnRefreshClick
    end
    object btnTesting: TButton
      Left = 18
      Top = 65
      Width = 98
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Testing'
      TabOrder = 2
      OnClick = btnTestingClick
    end
    object memTesting: TMemo
      Left = 157
      Top = 63
      Width = 849
      Height = 35
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
