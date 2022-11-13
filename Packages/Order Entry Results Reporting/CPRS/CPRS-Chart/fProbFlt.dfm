inherited frmPlVuFilt: TfrmPlVuFilt
  Left = 353
  Top = 217
  BorderStyle = bsDialog
  Caption = 'Problem List View Filters'
  ClientHeight = 343
  ClientWidth = 349
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 349
    Height = 343
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object SrcLabel: TLabel
      Left = 8
      Top = 55
      Width = 65
      Height = 13
      Caption = 'Source Clinic:'
      IsControl = True
    end
    object DstLabel: TLabel
      Left = 199
      Top = 55
      Width = 84
      Height = 13
      Caption = 'Selected Clinic(s):'
      IsControl = True
    end
    object lblProvider: TLabel
      Left = 200
      Top = 252
      Width = 84
      Height = 13
      Caption = 'Selected Provider'
    end
    object Bevel1: TBevel
      Left = 3
      Top = 4
      Width = 343
      Height = 293
    end
    object OROffsetLabel1: TOROffsetLabel
      Left = 198
      Top = 6
      Width = 32
      Height = 15
      Caption = 'Status'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object cmdAdd: TButton
      Left = 162
      Top = 105
      Width = 27
      Height = 22
      Caption = '>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = cmdAddClick
      IsControl = True
    end
    object cmdRemove: TButton
      Left = 162
      Top = 169
      Width = 27
      Height = 22
      Caption = '<'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = cmdRemoveClick
      IsControl = True
    end
    object cmdRemoveAll: TButton
      Left = 162
      Top = 201
      Width = 27
      Height = 22
      Caption = '<<'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = cmdRemoveAllClick
      IsControl = True
    end
    object cmdOK: TBitBtn
      Left = 90
      Top = 309
      Width = 77
      Height = 22
      Caption = 'OK'
      TabOrder = 9
      OnClick = cmdOKClick
      NumGlyphs = 2
      Spacing = -1
      IsControl = True
    end
    object cmdCancel: TBitBtn
      Left = 176
      Top = 309
      Width = 77
      Height = 22
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 10
      OnClick = cmdCancelClick
      Layout = blGlyphTop
      NumGlyphs = 2
      Spacing = -1
      IsControl = True
    end
    object lstDest: TORListBox
      Left = 200
      Top = 70
      Width = 140
      Height = 176
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = lstDestClick
      Caption = 'Selected Clinic or Clinics'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object rgVu: TRadioGroup
      Left = 7
      Top = 7
      Width = 167
      Height = 41
      Caption = 'Primary View'
      Columns = 2
      Items.Strings = (
        '&Outpatient'
        '&Inpatient')
      TabOrder = 0
      OnClick = rgVuClick
    end
    object cboProvider: TORComboBox
      Left = 200
      Top = 265
      Width = 140
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Selected Provider'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2,3'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 8
      OnNeedData = cboProviderNeedData
      CharsNeedMatch = 1
    end
    object cmdDefaultView: TBitBtn
      Left = 180
      Top = 370
      Width = 128
      Height = 22
      Caption = 'Return to Default View'
      TabOrder = 11
      Visible = False
      OnClick = cmdDefaultViewClick
      NumGlyphs = 2
    end
    object cboSource: TORComboBox
      Left = 9
      Top = 69
      Width = 140
      Height = 176
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Source Clinic'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 2
      OnChange = cboSourceChange
      OnDblClick = cmdAddClick
      OnEnter = cboSourceEnter
      OnExit = cboSourceExit
      OnNeedData = cboSourceNeedData
      CharsNeedMatch = 1
    end
    object cmdSave: TButton
      Left = 48
      Top = 371
      Width = 128
      Height = 21
      Caption = 'Save as Default'
      TabOrder = 12
      Visible = False
      OnClick = cmdSaveClick
    end
    object chkComments: TCheckBox
      Left = 9
      Top = 266
      Width = 138
      Height = 17
      Caption = 'Show comments on list'
      TabOrder = 7
    end
    object cboStatus: TORComboBox
      Left = 200
      Top = 26
      Width = 139
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Status'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      CharsNeedMatch = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = cmdAdd'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = cmdRemoveAll'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = lstDest'
        'Status = stsDefault')
      (
        'Component = rgVu'
        'Status = stsDefault')
      (
        'Component = cboProvider'
        'Status = stsDefault')
      (
        'Component = cmdDefaultView'
        'Status = stsDefault')
      (
        'Component = cboSource'
        'Status = stsDefault')
      (
        'Component = cmdSave'
        'Status = stsDefault')
      (
        'Component = chkComments'
        'Status = stsDefault')
      (
        'Component = cboStatus'
        'Status = stsDefault')
      (
        'Component = frmPlVuFilt'
        'Status = stsDefault'))
  end
end
