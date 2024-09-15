object pdmpUserForm: TpdmpUserForm
  Left = 0
  Top = 0
  ActiveControl = cboProviderDEA
  Caption = 'Select Authorized User'
  ClientHeight = 327
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 288
    Width = 393
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 234
      Top = 3
      Width = 75
      Height = 33
      Align = alRight
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnAccept: TButton
      AlignWithMargins = True
      Left = 315
      Top = 3
      Width = 75
      Height = 33
      Align = alRight
      Caption = '&Accept'
      Default = True
      ModalResult = 1
      TabOrder = 2
    end
    object btnDebug: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 126
      Height = 33
      Align = alLeft
      Caption = '&Debug: No Selection'
      TabOrder = 0
      TabStop = False
      Visible = False
      OnClick = btnDebugClick
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 288
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object lblUser: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 387
      Height = 13
      Align = alTop
      Caption = '&Select User:'
      FocusControl = cboProviderDEA
      ExplicitWidth = 58
    end
    object cboProviderDEA: TORComboBox
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 387
      Height = 263
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = ''
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      TabStop = True
      Text = ''
      OnDblClick = cboProviderDEADblClick
      OnNeedData = cboProviderDEANeedData
      CharsNeedMatch = 1
    end
  end
end
