inherited frmImmunizations: TfrmImmunizations
  Left = 373
  Top = 169
  Caption = 'Encouner Immunization'
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  inherited lblSection: TLabel
    Width = 100
    Caption = 'Immunization Section'
    Visible = False
    ExplicitWidth = 100
  end
  inherited lblList: TLabel
    Visible = False
  end
  inherited lblComment: TLabel
    Visible = False
  end
  inherited bvlMain: TBevel
    Left = -3
    ExplicitLeft = -3
  end
  inherited btnOK: TBitBtn
    TabOrder = 5
  end
  inherited btnCancel: TBitBtn
    TabOrder = 6
  end
  inherited pnlGrid: TPanel
    TabOrder = 1
    inherited lstCaptionList: TCaptionListView
      Columns = <
        item
          Caption = 'Series'
          Width = 80
        end
        item
          Caption = 'Refused/Contra'
          Tag = 1
          Width = 120
        end
        item
          Caption = 'Selected Immunizations'
          Width = 150
        end>
      Caption = 'Selected Immunizations'
      Pieces = '1,2,3,4'
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 3
    Visible = False
  end
  object btnAdd: TButton [8]
    Left = 487
    Top = 256
    Width = 129
    Height = 25
    Caption = 'Add/Edit/Delete Record'
    TabOrder = 8
    OnClick = btnAddClick
  end
  inherited btnSelectAll: TButton
    TabOrder = 2
    TabStop = True
  end
  inherited pnlMain: TPanel
    TabOrder = 0
    inherited lbxSection: TORListBox
      Tag = 40
      Visible = False
    end
    inherited pnlLeft: TPanel
      inherited lbSection: TORListBox
        Tag = 40
        TabOrder = 0
        Visible = False
        Caption = 'Immunization Section'
      end
      inherited btnOther: TButton
        Tag = 20
        Caption = 'Other Immunization...'
        TabOrder = 1
        Visible = False
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = edtComment'
        'Label = lblComment'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = btnRemove'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnSelectAll'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = lbxSection'
        'Label = lblList'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = pnlLeft'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = lbSection'
        'Label = lblSection'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = btnOther'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlGrid'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = frmImmunizations'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault'))
  end
end
