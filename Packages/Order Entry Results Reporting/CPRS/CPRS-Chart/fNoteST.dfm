inherited frmNotesSearchText: TfrmNotesSearchText
  Left = 473
  Top = 272
  BorderIcons = []
  Caption = 'List Signed Notes by Author'
  ClientHeight = 154
  ClientWidth = 331
  Constraints.MinHeight = 154
  Constraints.MinWidth = 331
  Position = poScreenCenter
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 347
  ExplicitHeight = 193
  DesignSize = (
    331
    154)
  TextHeight = 13
  object lblAuthor: TLabel [0]
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Search string:'
  end
  object edtSearchText: TEdit [1]
    Left = 8
    Top = 24
    Width = 216
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object pnlButtonPanel: TPanel [2]
    Left = 238
    Top = 0
    Width = 93
    Height = 154
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      93
      154)
    object cmdCancel: TButton
      Left = 16
      Top = 49
      Width = 77
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = cmdCancelClick
    end
    object cmdOK: TButton
      Left = 16
      Top = 24
      Width = 77
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = cmdOKClick
    end
  end
  object pnlSearchInfoPanel: TPanel [3]
    Left = 8
    Top = 51
    Width = 217
    Height = 95
    BevelOuter = bvNone
    TabOrder = 2
    object lblSearchInfo: TLabel
      Left = 1
      Top = 1
      Width = 215
      Height = 93
      Align = alClient
      Caption = 
        'Your current view of notes will be searched for the specified st' +
        'ring.  If you want to search a larger range of notes, you need t' +
        'o pull up that view prior to searching.'
      WordWrap = True
      ExplicitWidth = 214
      ExplicitHeight = 52
    end
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
        'Status = stsDefault')
      (
        'Component = pnlButtonPanel'
        'Status = stsDefault')
      (
        'Component = pnlSearchInfoPanel'
        'Status = stsDefault'))
  end
end
