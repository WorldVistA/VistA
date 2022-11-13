inherited frmGraphOthers: TfrmGraphOthers
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Select Other Views and Lab Groups'
  ClientHeight = 452
  ClientWidth = 474
  Position = poScreenCenter
  OnShow = FormShow
  ExplicitWidth = 480
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 16
  object pnlMain: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 474
    Height = 420
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 241
    object lblInfo: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 466
      Height = 16
      Align = alTop
      Caption = 
        'You can copy other user'#39's views and lab groups for your own use.' +
        ' '
      ExplicitLeft = 3
      ExplicitTop = 3
      ExplicitWidth = 389
    end
    object memReport: TRichEdit
      AlignWithMargins = True
      Left = 4
      Top = 323
      Width = 466
      Height = 93
      Align = alBottom
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
      Zoom = 100
      ExplicitLeft = 3
      ExplicitTop = 256
      ExplicitWidth = 468
    end
    object Panel1: TPanel
      Left = 1
      Top = 23
      Width = 472
      Height = 259
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 2
      ExplicitTop = 304
      ExplicitHeight = 217
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 209
        Height = 259
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        ExplicitHeight = 217
        object lblOthers: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 203
          Height = 16
          Align = alTop
          Caption = 'Select or enter name:'
          ExplicitLeft = 12
          ExplicitTop = 29
          ExplicitWidth = 126
        end
        object cboOthers: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 203
          Height = 231
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = 'Select or enter name'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 16
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
          Text = ''
          OnClick = cboOthersClick
          OnNeedData = cboOthersNeedData
          CharsNeedMatch = 1
          ExplicitLeft = 12
          ExplicitTop = 47
          ExplicitWidth = 144
          ExplicitHeight = 170
        end
      end
      object Panel3: TPanel
        Left = 209
        Top = 0
        Width = 38
        Height = 259
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 1
        ExplicitLeft = 155
        ExplicitHeight = 217
      end
      object Panel4: TPanel
        Left = 247
        Top = 0
        Width = 225
        Height = 259
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel4'
        ShowCaption = False
        TabOrder = 2
        ExplicitLeft = 144
        ExplicitTop = 88
        ExplicitWidth = 185
        ExplicitHeight = 41
        object lblViews: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 219
          Height = 16
          Align = alTop
          Caption = 'Views and Lab Groups:'
          ExplicitLeft = -100
          ExplicitTop = 29
          ExplicitWidth = 138
        end
        object lstViews: TORListBox
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 219
          Height = 231
          Align = alClient
          MultiSelect = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = lstViewsClick
          Caption = 'Currently selected recipients'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
          ExplicitLeft = -58
          ExplicitTop = 51
          ExplicitWidth = 283
          ExplicitHeight = 137
        end
      end
    end
    object Panel5: TPanel
      Left = 1
      Top = 282
      Width = 472
      Height = 38
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 3
      ExplicitTop = 23
      ExplicitWidth = 281
      object lblDefinitions: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 16
        Width = 214
        Height = 19
        Margins.Top = 16
        Align = alLeft
        Caption = 'Definitions:'
        ExplicitTop = 3
        ExplicitHeight = 32
      end
      object btnCopy: TButton
        AlignWithMargins = True
        Left = 395
        Top = 3
        Width = 74
        Height = 32
        Align = alRight
        Caption = 'Copy'
        TabOrder = 0
      end
    end
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 420
    Width = 474
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 352
    object btnClose: TButton
      AlignWithMargins = True
      Left = 396
      Top = 3
      Width = 75
      Height = 26
      Align = alRight
      Caption = 'Close'
      TabOrder = 0
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 120
    Top = 272
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
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault'))
  end
end
