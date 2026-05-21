inherited frmImmunizations: TfrmImmunizations
  Left = 373
  Top = 169
  Caption = 'Encouner Immunization'
  ClientHeight = 367
  ClientWidth = 702
  Constraints.MinHeight = 194
  Constraints.MinWidth = 714
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  ExplicitWidth = 718
  ExplicitHeight = 406
  TextHeight = 13
  inherited pnlMainAncestor: TPanel
    Width = 702
    Height = 136
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 702
    ExplicitHeight = 136
    inherited pnlGrid: TPanel
      AlignWithMargins = False
      Left = 0
      Top = 0
      Width = 624
      Height = 136
      BevelKind = bkNone
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 624
      ExplicitHeight = 136
      inherited lstCaptionList: TCaptionListView
        Width = 618
        Height = 87
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
            AutoSize = True
            Caption = 'Selected Immunizations'
          end>
        Caption = 'Selected Immunizations'
        Pieces = '1,2,3,4'
        ExplicitWidth = 618
        ExplicitHeight = 87
      end
      inherited pnlComments: TPanel
        Top = 93
        Width = 624
        Visible = False
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 93
        ExplicitWidth = 624
        inherited lblComment: TLabel
          Width = 618
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited edtComment: TCaptionEdit
          Width = 618
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 618
        end
      end
    end
    inherited pnlGridRight: TPanel
      Left = 624
      Height = 136
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 624
      ExplicitHeight = 136
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
        ExplicitTop = 44
      end
      object btnAdd: TButton
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
        OnClick = btnAddClick
      end
    end
  end
  inherited pnlBottomAncestor: TPanel
    Top = 340
    Width = 702
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 340
    ExplicitWidth = 702
    inherited btnOK: TBitBtn
      Left = 543
      ExplicitLeft = 543
    end
    inherited btnCancel: TBitBtn
      Left = 624
      ExplicitLeft = 624
    end
  end
  inherited pnlMain: TPanel
    Width = 702
    Visible = False
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 702
    inherited grdMain: TGridPanel
      Width = 702
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 702
      inherited lblSection: TLabel
        Width = 347
        Caption = 'Immunization Section'
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 100
      end
      inherited lblList: TLabel
        Left = 351
        Width = 347
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 351
      end
      inherited lbSection: TORListBox
        Width = 347
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Immunization Section'
        ExplicitWidth = 347
      end
      inherited lbxSection: TORListBox
        Left = 351
        Width = 347
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Section Name'
        ExplicitLeft = 351
        ExplicitWidth = 347
      end
      inherited btnOther: TButton
        Width = 347
        ExplicitWidth = 347
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
        'Component = frmImmunizations'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault'))
  end
end
