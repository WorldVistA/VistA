inherited frmSkinTests: TfrmSkinTests
  Left = 213
  Top = 163
  Caption = 'Encounter Skin Test form'
  ClientWidth = 657
  ExplicitWidth = 673
  PixelsPerInch = 96
  TextHeight = 13
  inherited lblSection: TLabel
    Width = 84
    Caption = 'Skin Test Section'
    ExplicitWidth = 84
  end
  inherited btnOK: TBitBtn
    Left = 497
    TabOrder = 5
    ExplicitLeft = 497
  end
  inherited btnCancel: TBitBtn
    Left = 577
    TabOrder = 6
    ExplicitLeft = 577
  end
  inherited pnlGrid: TPanel
    TabOrder = 1
    inherited lstCaptionList: TCaptionListView
      Columns = <
        item
          Caption = 'Results'
          Width = 80
        end
        item
          Caption = 'Reading'
          Tag = 1
          Width = 120
        end
        item
          Caption = 'Selected Skin Tests'
          Width = 150
        end>
      OnSelectItem = lstCaptionListSelectItem
      Caption = 'Selected Skin Tests'
      Pieces = '1,2,3'
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 3
  end
  object btnSkinEdit: TButton [8]
    Left = 484
    Top = 272
    Width = 131
    Height = 25
    Caption = 'Add/Edit/Delete Record'
    TabOrder = 8
    OnClick = btnSkinEditClick
  end
  inherited btnSelectAll: TButton
    TabOrder = 2
    TabStop = True
  end
  inherited pnlMain: TPanel
    Width = 645
    TabOrder = 0
    ExplicitWidth = 645
    inherited lbxSection: TORListBox
      Tag = 50
      Width = 438
      ExplicitWidth = 438
    end
    inherited pnlLeft: TPanel
      inherited lbSection: TORListBox
        Tag = 50
        TabOrder = 0
        Caption = 'Skin Test Section'
      end
      inherited btnOther: TButton
        Tag = 21
        Caption = 'Other Skin Test...'
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = edtComment'
        'Label = lblComment'
        'Status = stsOK')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnSelectAll'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = lbxSection'
        'Label = lblList'
        'Status = stsOK')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = lbSection'
        'Label = lblSection'
        'Status = stsOK')
      (
        'Component = btnOther'
        'Status = stsDefault')
      (
        'Component = pnlGrid'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmSkinTests'
        'Status = stsDefault')
      (
        'Component = btnSkinEdit'
        'Status = stsDefault'))
  end
end
