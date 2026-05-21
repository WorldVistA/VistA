inherited frmSkinTests: TfrmSkinTests
  Left = 213
  Top = 163
  Caption = 'Encounter Skin Test form'
  ClientWidth = 657
  Constraints.MinHeight = 150
  Constraints.MinWidth = 580
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  ExplicitWidth = 673
  TextHeight = 13
  inherited pnlMainAncestor: TPanel
    Width = 657
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 657
    inherited pnlGrid: TPanel
      AlignWithMargins = False
      Left = 0
      Top = 0
      Width = 579
      Height = 168
      BevelKind = bkNone
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 579
      ExplicitHeight = 168
      inherited lstCaptionList: TCaptionListView
        Width = 573
        Height = 119
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
            AutoSize = True
            Caption = 'Selected Skin Tests'
          end>
        Caption = 'Selected Skin Tests'
        Pieces = '1,2,3'
        ExplicitWidth = 573
        ExplicitHeight = 119
      end
      inherited pnlComments: TPanel
        Top = 125
        Width = 579
        Visible = False
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 125
        ExplicitWidth = 579
        inherited lblComment: TLabel
          Width = 573
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited edtComment: TCaptionEdit
          Width = 573
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 573
        end
      end
    end
    inherited pnlGridRight: TPanel
      Left = 579
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 579
      inherited btnRemove: TButton
        Top = 68
        TabOrder = 2
        Visible = False
        ExplicitTop = 68
      end
      inherited btnSelectAll: TButton
        Top = 44
        Margins.Top = 0
        TabOrder = 1
        TabStop = True
        Visible = False
        ExplicitTop = 44
      end
      object btnSkinEdit: TButton
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 75
        Height = 38
        Margins.Left = 0
        Align = alTop
        Caption = 'Add / Edit / Delete Record'
        TabOrder = 0
        WordWrap = True
        OnClick = btnSkinEditClick
      end
    end
  end
  inherited pnlBottomAncestor: TPanel
    Width = 657
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 657
    inherited btnOK: TBitBtn
      Left = 498
      ExplicitLeft = 498
    end
    inherited btnCancel: TBitBtn
      Left = 579
      ExplicitLeft = 579
    end
  end
  inherited pnlMain: TPanel
    Width = 657
    Visible = False
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 657
    inherited grdMain: TGridPanel
      Width = 657
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 657
      inherited lblSection: TLabel
        Width = 325
        Caption = 'Skin Test Section'
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 84
      end
      inherited lblList: TLabel
        Left = 329
        Width = 324
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 329
      end
      inherited lbSection: TORListBox
        Width = 325
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Skin Test Section'
        ExplicitWidth = 325
      end
      inherited lbxSection: TORListBox
        Left = 329
        Width = 324
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Section Name'
        ExplicitLeft = 329
        ExplicitWidth = 324
      end
      inherited btnOther: TButton
        Width = 325
        Caption = 'Other Skin Test...'
        ExplicitWidth = 325
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
