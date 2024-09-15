inherited frmAlertNoteSelector: TfrmAlertNoteSelector
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Alert Processing Note Selector'
  ClientHeight = 459
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object rbtnNewNote: TRadioButton
    Left = 16
    Top = 144
    Width = 265
    Height = 17
    Caption = 'Create New Note Using Default Note Title'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = rbtnNewNoteClick
  end
  object rbtnSelectAddendum: TRadioButton
    Left = 16
    Top = 167
    Width = 265
    Height = 17
    Caption = 'Add Adendum to Note From Initial SMART Visit Date'
    TabOrder = 3
    TabStop = True
    OnClick = rbtnSelectAddendumClick
  end
  object rbtnSelectOwn: TRadioButton
    Left = 8
    Top = 424
    Width = 265
    Height = 17
    Caption = 'Select Different Note For Addendum'
    TabOrder = 5
    TabStop = True
    OnClick = rbtnSelectOwnClick
  end
  object btnOK: TButton
    Left = 304
    Top = 420
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 6
  end
  object lbATRNotes_ORIG: TORListBox
    Left = 32
    Top = 206
    Width = 337
    Height = 138
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Caption = ''
    ItemTipColor = clWindow
    LongList = True
    Pieces = '2'
  end
  object lbATRs: TORListBox
    Left = 16
    Top = 24
    Width = 427
    Height = 114
    Color = clCream
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Caption = ''
    ItemTipColor = clWindow
    LongList = True
  end
  object lbATRNotes: TListBox
    Left = 16
    Top = 190
    Width = 427
    Height = 211
    ItemHeight = 13
    TabOrder = 4
    OnClick = lbATRNotesClick
  end
  object buCancel: TButton
    Left = 385
    Top = 420
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 7
    OnClick = buCancelClick
  end
  object StaticText1: TStaticText
    Left = 16
    Top = 8
    Width = 98
    Height = 17
    Caption = 'SMART Alert Values'
    TabOrder = 0
    TabStop = True
  end
end
