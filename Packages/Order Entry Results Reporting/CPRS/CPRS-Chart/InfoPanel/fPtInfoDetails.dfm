inherited frmPtInfoDetails: TfrmPtInfoDetails
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'frmPtInfoDetails'
  ClientHeight = 257
  ClientWidth = 358
  ParentFont = True
  FormStyle = fsStayOnTop
  Position = poDefault
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 374
  ExplicitHeight = 296
  TextHeight = 15
  object memDetails: TRichEdit [0]
    Left = 0
    Top = 68
    Width = 358
    Height = 45
    Align = alTop
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PlainText = True
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    OnKeyDown = memDetailsKeyDown
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 223
    Width = 358
    Height = 34
    Align = alBottom
    TabOrder = 5
    TabStop = True
    object btnClose: TButton
      AlignWithMargins = True
      Left = 279
      Top = 4
      Width = 75
      Height = 26
      Align = alRight
      Caption = 'Close'
      ModalResult = 8
      TabOrder = 0
      OnClick = btnCloseClick
      OnKeyDown = btnCloseKeyDown
    end
    object btnPrint: TButton
      AlignWithMargins = True
      Left = 198
      Top = 4
      Width = 75
      Height = 26
      Align = alRight
      Caption = 'Print'
      TabOrder = 1
      OnClick = btnPrintClick
      OnKeyDown = btnCloseKeyDown
    end
  end
  object pnlHeader: TPanel [2]
    Left = 0
    Top = 0
    Width = 358
    Height = 31
    Align = alTop
    TabOrder = 1
    OnResize = pnlHeaderResize
    object sbClose: TSpeedButton
      Left = 328
      Top = 1
      Width = 29
      Height = 29
      Align = alRight
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
        000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
        00000000FFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
        000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFF
        FFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF000000000000000000FFFFFF000000000000000000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000
        0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF000000000000000000000000000000FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FF
        FFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF000000000000000000FFFFFFFFFFFFFFFFFF000000000000000000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000
        000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000
        00000000FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Layout = blGlyphRight
      Transparent = False
      OnClick = btnCloseClick
      ExplicitLeft = 472
    end
    object lblHeader: TVA508StaticText
      Left = 1
      Top = 1
      Width = 327
      Height = 29
      Align = alClient
      Alignment = taCenter
      Caption = ''
      TabOrder = 0
      ShowAccelChar = True
      WordWrap = False
      LabelAlignment = taCenter
      LabelLayout = tlCenter
    end
  end
  object wbEdgeBrowser: TEdgeBrowser [3]
    Left = 0
    Top = 31
    Width = 358
    Height = 37
    Align = alTop
    TabOrder = 2
    TabStop = True
    AllowSingleSignOnUsingOSPrimaryAccount = False
    TargetCompatibleBrowserVersion = '117.0.2045.28'
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
  end
  inline fraEditGrid: TfraEditGridBase [4]
    Left = 0
    Top = 152
    Width = 358
    Height = 71
    Align = alClient
    Color = clWindow
    ParentBackground = False
    ParentColor = False
    TabOrder = 3
    ExplicitTop = 152
    ExplicitWidth = 358
    ExplicitHeight = 71
    inherited ScrollBox1: TScrollBox
      Width = 358
      Height = 71
      ExplicitWidth = 358
      ExplicitHeight = 71
      inherited pnlForm: TPanel
        Width = 354
        Height = 67
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 354
        ExplicitHeight = 67
        inherited grdEditPanel: TGridPanel
          Width = 354
          Height = 36
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 354
          ExplicitHeight = 36
        end
        inherited pnlButtons: TPanel
          Top = 36
          Width = 354
          Height = 31
          StyleElements = [seFont, seClient, seBorder]
          OnResize = fraEditGridpnlButtonsResize
          ExplicitTop = 36
          ExplicitWidth = 354
          ExplicitHeight = 31
          inherited btnSave: TButton
            AlignWithMargins = True
            Left = 195
            Top = 3
            Align = alRight
            OnClick = fraEditGridBtnSaveClick
            ExplicitLeft = 195
            ExplicitTop = 6
          end
          inherited btnCancel: TButton
            AlignWithMargins = True
            Left = 276
            Top = 3
            Align = alRight
            OnClick = btnCloseClick
            ExplicitLeft = 276
            ExplicitTop = 3
          end
        end
      end
    end
  end
  object sbCustom: TScrollBox
    Left = 0
    Top = 113
    Width = 358
    Height = 39
    Align = alTop
    TabOrder = 4
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memDetails'
        'Status = stsDefault')
      (
        'Component = wbEdgeBrowser'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = frmPtInfoDetails'
        'Status = stsDefault')
      (
        'Component = pnlHeader'
        'Status = stsDefault')
      (
        'Component = fraEditGrid'
        'Status = stsDefault')
      (
        'Component = fraEditGrid.ScrollBox1'
        'Status = stsDefault')
      (
        'Component = fraEditGrid.pnlForm'
        'Status = stsDefault')
      (
        'Component = fraEditGrid.grdEditPanel'
        'Status = stsDefault')
      (
        'Component = fraEditGrid.pnlButtons'
        'Status = stsDefault')
      (
        'Component = fraEditGrid.btnSave'
        'Status = stsDefault')
      (
        'Component = fraEditGrid.btnCancel'
        'Status = stsDefault')
      (
        'Component = sbCustom'
        'Status = stsDefault')
      (
        'Component = lblHeader'
        'Status = stsDefault')
      (
        'Component = btnPrint'
        'Status = stsDefault'))
  end
end
