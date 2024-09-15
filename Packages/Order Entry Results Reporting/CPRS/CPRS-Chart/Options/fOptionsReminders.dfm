inherited frmOptionsReminders: TfrmOptionsReminders
  Left = 693
  Top = 17
  HelpContext = 9020
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Clinical Reminders on Cover Sheet'
  ClientHeight = 287
  ClientWidth = 474
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 480
  ExplicitHeight = 312
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 255
    Width = 474
    Height = 32
    HelpContext = 9020
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitTop = 303
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 474
      Height = 2
      Align = alTop
      ExplicitWidth = 407
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 315
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9996
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 396
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9997
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 474
    Height = 255
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 3
    ExplicitTop = 344
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 211
      Height = 255
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 0
      object lblNotDisplayed: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 205
        Height = 16
        Align = alTop
        Caption = 'Reminders not being displayed:'
        ExplicitLeft = 8
        ExplicitTop = 8
        ExplicitWidth = 190
      end
      object lstNotDisplayed: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 205
        Height = 227
        HelpContext = 9026
        Align = alClient
        MultiSelect = True
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 0
        OnClick = lstNotDisplayedChange
        OnDblClick = btnAddClick
        Caption = 'Reminders not being displayed:'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3'
        OnChange = lstNotDisplayedChange
        ExplicitLeft = 8
        ExplicitWidth = 203
        ExplicitHeight = 217
      end
    end
    object Panel3: TPanel
      Left = 211
      Top = 0
      Width = 50
      Height = 255
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 1
      ExplicitLeft = 208
      ExplicitTop = -6
      object btnAdd: TBitBtn
        AlignWithMargins = True
        Left = 3
        Top = 24
        Width = 44
        Height = 25
        Margins.Top = 24
        Align = alTop
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333FF3333333333333003333
          3333333333773FF3333333333309003333333333337F773FF333333333099900
          33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
          99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
          33333333337F3F77333333333309003333333333337F77333333333333003333
          3333333333773333333333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333333333333}
        NumGlyphs = 2
        TabOrder = 0
        OnClick = btnAddClick
        ExplicitLeft = -8
        ExplicitTop = 112
        ExplicitWidth = 75
      end
      object btnDelete: TBitBtn
        AlignWithMargins = True
        Left = 3
        Top = 55
        Width = 44
        Height = 25
        Align = alTop
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333333333333333333333333333333333333333333333
          3333333333333FF3333333333333003333333333333F77F33333333333009033
          333333333F7737F333333333009990333333333F773337FFFFFF330099999000
          00003F773333377777770099999999999990773FF33333FFFFF7330099999000
          000033773FF33777777733330099903333333333773FF7F33333333333009033
          33333333337737F3333333333333003333333333333377333333333333333333
          3333333333333333333333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333333333333}
        NumGlyphs = 2
        TabOrder = 1
        OnClick = btnDeleteClick
        ExplicitLeft = -8
        ExplicitTop = 112
        ExplicitWidth = 75
      end
      object btnUp: TBitBtn
        AlignWithMargins = True
        Left = 3
        Top = 107
        Width = 44
        Height = 25
        Margins.Top = 24
        Align = alTop
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
          3333333333777F33333333333309033333333333337F7F333333333333090333
          33333333337F7F33333333333309033333333333337F7F333333333333090333
          33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
          3333333777737777F333333099999990333333373F3333373333333309999903
          333333337F33337F33333333099999033333333373F333733333333330999033
          3333333337F337F3333333333099903333333333373F37333333333333090333
          33333333337F7F33333333333309033333333333337373333333333333303333
          333333333337F333333333333330333333333333333733333333}
        NumGlyphs = 2
        TabOrder = 2
        OnClick = btnUpClick
        ExplicitLeft = -8
        ExplicitTop = 112
        ExplicitWidth = 75
      end
      object btnDown: TBitBtn
        AlignWithMargins = True
        Left = 3
        Top = 138
        Width = 44
        Height = 25
        Align = alTop
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
          333333333337F33333333333333033333333333333373F333333333333090333
          33333333337F7F33333333333309033333333333337373F33333333330999033
          3333333337F337F33333333330999033333333333733373F3333333309999903
          333333337F33337F33333333099999033333333373333373F333333099999990
          33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
          33333333337F7F33333333333309033333333333337F7F333333333333090333
          33333333337F7F33333333333309033333333333337F7F333333333333090333
          33333333337F7F33333333333300033333333333337773333333}
        NumGlyphs = 2
        TabOrder = 3
        OnClick = btnDownClick
        ExplicitLeft = -8
        ExplicitTop = 112
        ExplicitWidth = 75
      end
    end
    object Panel4: TPanel
      Left = 261
      Top = 0
      Width = 213
      Height = 255
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 2
      ExplicitLeft = 8
      ExplicitWidth = 211
      object lblDisplayed: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 207
        Height = 16
        Align = alTop
        Caption = 'Reminders being displayed:'
        ExplicitLeft = 44
        ExplicitTop = 8
        ExplicitWidth = 169
      end
      object lstDisplayed: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 207
        Height = 170
        HelpContext = 9025
        Align = alClient
        MultiSelect = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lstDisplayedChange
        OnDblClick = btnDeleteClick
        Caption = 'Reminders being displayed:'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3'
        OnChange = lstDisplayedChange
        ExplicitLeft = 26
        ExplicitWidth = 187
        ExplicitHeight = 217
      end
      object radSort: TRadioGroup
        AlignWithMargins = True
        Left = 3
        Top = 201
        Width = 207
        Height = 51
        Align = alBottom
        Caption = 'Sort by '
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          '&Display Order'
          '&Alphabetical')
        ParentFont = False
        TabOrder = 1
        OnClick = radSortClick
        ExplicitLeft = -6
        ExplicitTop = 204
        ExplicitWidth = 219
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = lstDisplayed'
        'Status = stsDefault')
      (
        'Component = lstNotDisplayed'
        'Status = stsDefault')
      (
        'Component = radSort'
        'Status = stsDefault')
      (
        'Component = frmOptionsReminders'
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
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = btnDelete'
        'Status = stsDefault')
      (
        'Component = btnUp'
        'Status = stsDefault')
      (
        'Component = btnDown'
        'Status = stsDefault'))
  end
end
