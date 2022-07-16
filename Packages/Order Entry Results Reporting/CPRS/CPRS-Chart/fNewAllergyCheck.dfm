object frmNewAllergyCheck: TfrmNewAllergyCheck
  Left = 545
  Top = 470
  BorderIcons = [biSystemMenu]
  Caption = 'Existing Medication Allergy'
  ClientHeight = 377
  ClientWidth = 591
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 267
    Top = 167
    Width = 50
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = ' Optional Recipients'
    WordWrap = True
  end
  object SendAlertBtn: TSpeedButton
    Left = 515
    Top = 349
    Width = 69
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '&OK'
    OnClick = SendAlertBtnClick
  end
  object AddBtn: TSpeedButton
    Left = 267
    Top = 203
    Width = 60
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '&Add'
    OnClick = AddBtnClick
  end
  object RemoveBtn: TSpeedButton
    Left = 267
    Top = 233
    Width = 60
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '&Remove'
    OnClick = RemoveBtnClick
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 591
    Height = 162
    Align = alTop
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 0
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 581
      Height = 13
      Align = alTop
      Caption = ' The following Active Order contains xxxxxxxxxx.'
      WordWrap = True
      ExplicitWidth = 227
    end
    object ActiveOrders: TLabel
      Left = 0
      Top = 19
      Width = 587
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alTop
      Color = clWindow
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      ExplicitWidth = 3
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 35
      Width = 581
      Height = 13
      Align = alTop
      Caption = 
        ' There are active order(s) which contain the drug allergy just a' +
        'dded. An alert will be sent to:'
      ExplicitWidth = 427
    end
    object Recipients: TORListBox
      AlignWithMargins = True
      Left = 3
      Top = 54
      Width = 581
      Height = 99
      TabStop = False
      Align = alTop
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = ''
      ItemTipColor = clWindow
      LongList = False
    end
  end
  object SelRecip: TORListBox
    Left = 332
    Top = 168
    Width = 254
    Height = 170
    TabStop = False
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Caption = ''
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2,3'
  end
  object Panel1: TPanel
    Left = 8
    Top = 168
    Width = 254
    Height = 170
    Caption = 'Panel1'
    TabOrder = 3
    object OptRecip: TORComboBox
      Left = 1
      Top = 1
      Width = 252
      Height = 168
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Encounter Provider'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      OnDblClick = OptRecipDblClick
      OnNeedData = OptRecipNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
  end
end
