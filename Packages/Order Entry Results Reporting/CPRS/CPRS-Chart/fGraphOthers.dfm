inherited frmGraphOthers: TfrmGraphOthers
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Select Other Views and Lab Groups'
  ClientHeight = 384
  ClientWidth = 335
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 335
    Height = 241
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      335
      241)
    object lblOthers: TLabel
      Left = 12
      Top = 29
      Width = 101
      Height = 13
      Caption = 'Select or enter name:'
    end
    object lblViews: TLabel
      Left = 179
      Top = 29
      Width = 110
      Height = 13
      Caption = 'Views and Lab Groups:'
    end
    object lblInfo: TLabel
      Left = 12
      Top = 10
      Width = 313
      Height = 13
      Caption = 
        'You can copy other user'#39's views and lab groups for your own use.' +
        ' '
    end
    object lblDefinitions: TLabel
      Left = 12
      Top = 224
      Width = 52
      Height = 13
      Caption = 'Definitions:'
    end
    object cboOthers: TORComboBox
      Left = 12
      Top = 48
      Width = 144
      Height = 170
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Select or enter name'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      OnClick = cboOthersClick
      OnNeedData = cboOthersNeedData
      CharsNeedMatch = 1
    end
    object lstViews: TORListBox
      Left = 179
      Top = 48
      Width = 144
      Height = 137
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = lstViewsClick
      Caption = 'Currently selected recipients'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object btnCopy: TButton
      Left = 179
      Top = 193
      Width = 144
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Copy'
      TabOrder = 3
    end
    object pnlTempData: TPanel
      Left = -90
      Top = 96
      Width = 425
      Height = 49
      TabOrder = 4
      Visible = False
      object lblSave: TLabel
        Left = 184
        Top = 16
        Width = 3
        Height = 13
        Visible = False
      end
      object lblClose: TLabel
        Left = 192
        Top = 0
        Width = 3
        Height = 13
        Visible = False
      end
      object lstActualItems: TORListBox
        Left = 8
        Top = 5
        Width = 97
        Height = 41
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        ItemTipColor = clWindow
        LongList = False
      end
      object lstDrugClass: TListBox
        Left = 112
        Top = 5
        Width = 97
        Height = 41
        ItemHeight = 13
        TabOrder = 1
      end
      object lstScratch: TListBox
        Left = 216
        Top = 5
        Width = 97
        Height = 41
        ItemHeight = 13
        TabOrder = 2
      end
      object lstTests: TListBox
        Left = 320
        Top = 5
        Width = 97
        Height = 41
        ItemHeight = 13
        TabOrder = 3
      end
    end
  end
  object memReport: TRichEdit [1]
    Left = 0
    Top = 241
    Width = 335
    Height = 102
    Align = alClient
    BevelInner = bvNone
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WantReturns = False
    WordWrap = False
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 343
    Width = 335
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnClose: TButton
      Left = 250
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = cboOthers'
        'Status = stsDefault')
      (
        'Component = lstViews'
        'Status = stsDefault')
      (
        'Component = btnCopy'
        'Status = stsDefault')
      (
        'Component = pnlTempData'
        'Status = stsDefault')
      (
        'Component = lstActualItems'
        'Status = stsDefault')
      (
        'Component = lstDrugClass'
        'Status = stsDefault')
      (
        'Component = lstScratch'
        'Status = stsDefault')
      (
        'Component = lstTests'
        'Status = stsDefault')
      (
        'Component = memReport'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = frmGraphOthers'
        'Status = stsDefault'))
  end
end
