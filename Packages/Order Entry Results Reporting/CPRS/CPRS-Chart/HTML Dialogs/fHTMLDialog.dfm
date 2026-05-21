inherited frmHTMLDialog: TfrmHTMLDialog
  AlignWithMargins = True
  Left = 0
  Top = 0
  Caption = 'frmHTMLDialog'
  ClientHeight = 473
  ClientWidth = 586
  FormStyle = fsStayOnTop
  Position = poDesigned
  StyleElements = [seFont, seClient, seBorder]
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 602
  ExplicitHeight = 512
  TextHeight = 13
  object pnlButtons: TPanel [0]
    Left = 0
    Top = 440
    Width = 586
    Height = 33
    Align = alBottom
    Caption = 'pnlButtons'
    ShowCaption = False
    TabOrder = 1
    object btnSave: TButton
      AlignWithMargins = True
      Left = 426
      Top = 4
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Save'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 507
      Top = 4
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnRefresh: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Align = alLeft
      Caption = 'Refresh'
      TabOrder = 2
      Visible = False
      OnClick = btnRefreshClick
    end
  end
  object brEdge: TEdgeBrowser [1]
    Left = 0
    Top = 0
    Width = 586
    Height = 440
    Margins.Left = 0
    Margins.Top = 200
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    TabOrder = 0
    TabStop = True
    AllowSingleSignOnUsingOSPrimaryAccount = False
    TargetCompatibleBrowserVersion = '117.0.2045.28'
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
    OnCreateWebViewCompleted = brEdgeCreateWebViewCompleted
    OnExecuteScript = brEdgeExecuteScript
    OnNavigationCompleted = brEdgeNavigationCompleted
    OnWebMessageReceived = brEdgeWebMessageReceived
    OnWebResourceRequested = brEdgeWebResourceRequested
    ExplicitTop = 203
    ExplicitHeight = 237
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 32
    Top = 8
    Data = (
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = btnSave'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = brEdge'
        'Status = stsDefault')
      (
        'Component = frmHTMLDialog'
        'Status = stsDefault')
      (
        'Component = btnRefresh'
        'Status = stsDefault'))
  end
  object tmrCancel: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmrCancelTimer
    Left = 32
    Top = 72
  end
end
