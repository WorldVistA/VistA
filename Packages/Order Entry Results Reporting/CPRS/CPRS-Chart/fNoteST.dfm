inherited frmNotesSearchText: TfrmNotesSearchText
  Left = 473
  Top = 272
  BorderIcons = []
  Caption = 'List Signed Notes by Author'
  ClientHeight = 123
  ClientWidth = 331
  Position = poScreenCenter
  OnShow = FormShow
  ExplicitWidth = 339
  ExplicitHeight = 150
  DesignSize = (
    331
    123)
  PixelsPerInch = 96
  TextHeight = 13
  object lblSearchInfo: TLabel [0]
    Left = 8
    Top = 56
    Width = 221
    Height = 52
    Anchors = [akLeft, akTop, akBottom]
    Caption = 
      'Your current view of notes will be searched for the specified st' +
      'ring.  If you want to search a larger range of notes, you need t' +
      'o pull up that view prior to searching.'
    WordWrap = True
  end
  object lblAuthor: TLabel [1]
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Search string:'
  end
  object edtSearchText: TEdit [2]
    Left = 8
    Top = 24
    Width = 224
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object cmdOK: TButton [3]
    Left = 251
    Top = 24
    Width = 72
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [4]
    Left = 251
    Top = 49
    Width = 72
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = edtSearchText'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmNotesSearchText'
        'Status = stsDefault'))
  end
end
