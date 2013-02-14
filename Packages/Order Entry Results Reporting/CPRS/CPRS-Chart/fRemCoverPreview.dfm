inherited frmRemCoverPreview: TfrmRemCoverPreview
  Left = 214
  Top = 107
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Cover Sheet Reminders'
  ClientHeight = 383
  ClientWidth = 255
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 263
  ExplicitHeight = 410
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBtns: TPanel [0]
    Left = 0
    Top = 354
    Width = 255
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      255
      29)
    object btnOK: TButton
      Left = 179
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object lvMain: TListView [1]
    Left = 0
    Top = 0
    Width = 255
    Height = 354
    Align = alClient
    Columns = <
      item
        Caption = 'Reminder'
        Tag = 1
        Width = 200
      end
      item
        Caption = 'Seq'
        Tag = 2
        Width = 35
      end>
    ReadOnly = True
    SortType = stData
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = lvMainColumnClick
    OnCompare = lvMainCompare
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBtns'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = lvMain'
        'Status = stsDefault')
      (
        'Component = frmRemCoverPreview'
        'Status = stsDefault'))
  end
end
