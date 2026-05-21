inherited frmStandardCodes: TfrmStandardCodes
  Caption = 'frmStandardCodes'
  ClientHeight = 439
  ClientWidth = 625
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  ExplicitWidth = 641
  ExplicitHeight = 478
  TextHeight = 13
  object lblMag: TLabel [0]
    Left = 8
    Top = 322
    Width = 53
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Magnitude:'
  end
  object lblUCUM: TLabel [1]
    Left = 104
    Top = 323
    Width = 203
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Unified Code for Units of Measure  (UCUM)'
  end
  object lblUCUM2: TLabel [2]
    Left = 104
    Top = 342
    Width = 48
    Height = 13
    Caption = 'lblUCUM2'
    Visible = False
  end
  inherited pnlMainAncestor: TPanel
    Top = 200
    Width = 625
    Height = 212
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 200
    ExplicitWidth = 625
    ExplicitHeight = 212
    inherited pnlGrid: TPanel
      Width = 619
      Height = 118
      Align = alTop
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 619
      ExplicitHeight = 118
      inherited lstCaptionList: TCaptionListView
        Width = 609
        Height = 65
        Columns = <
          item
            Caption = 'System'
            Width = 80
          end
          item
            Caption = 'Code'
            Width = 100
          end
          item
            Caption = 'Description'
            Width = 340
          end
          item
            Caption = 'Add to PL'
            Width = 70
          end>
        Pieces = '1,2,3,4'
        ExplicitWidth = 609
        ExplicitHeight = 65
      end
      inherited pnlComments: TPanel
        Top = 71
        Width = 615
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 71
        ExplicitWidth = 615
        inherited lblComment: TLabel
          Width = 609
          Anchors = [akRight, akBottom]
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited edtComment: TCaptionEdit
          Width = 609
          Anchors = [akLeft, akRight, akBottom]
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 609
        end
      end
    end
    inherited pnlGridRight: TPanel
      Left = 547
      Top = 124
      Height = 88
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 547
      ExplicitTop = 124
      ExplicitHeight = 88
      inherited btnRemove: TButton
        Top = 30
        Height = 27
        Anchors = [akRight, akBottom]
        ExplicitTop = 30
        ExplicitHeight = 27
      end
      inherited btnSelectAll: TButton
        Height = 24
        Anchors = [akRight, akBottom]
        ExplicitHeight = 24
      end
    end
  end
  inherited pnlBottomAncestor: TPanel
    Top = 412
    Width = 625
    TabOrder = 4
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 412
    ExplicitWidth = 625
    inherited btnOK: TBitBtn
      Left = 466
      ExplicitLeft = 466
    end
    inherited btnCancel: TBitBtn
      Left = 547
      ExplicitLeft = 547
    end
  end
  inherited pnlMain: TPanel
    Width = 625
    Height = 200
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 625
    ExplicitHeight = 200
    inherited grdMain: TGridPanel
      Width = 625
      Height = 200
      ControlCollection = <
        item
          Column = 0
          Control = lblSection
          Row = 0
        end
        item
          Column = 1
          Control = lblList
          Row = 0
        end
        item
          Column = 0
          Control = lbSection
          Row = 1
        end
        item
          Column = 1
          Control = lbxSection
          Row = 1
          RowSpan = 2
        end
        item
          Column = 0
          Control = btnOther
          Row = 2
        end>
      RowCollection = <
        item
          SizeStyle = ssAuto
          Value = 50.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end
        item
        end
        item
          SizeStyle = ssAuto
        end>
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 625
      ExplicitHeight = 200
      inherited lblSection: TLabel
        Width = 309
        Visible = False
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited lblList: TLabel
        Left = 313
        Width = 308
        Visible = False
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 313
      end
      inherited lbSection: TORListBox
        Width = 309
        Height = 176
        Visible = False
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 309
        ExplicitHeight = 175
      end
      inherited lbxSection: TORListBox
        Left = 313
        Width = 308
        Height = 176
        TabStop = False
        Style = lbStandard
        Enabled = False
        ItemHeight = 13
        Visible = False
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Section Name'
        Pieces = '1,2,3'
        TabPosInPixels = False
        CheckBoxes = False
        ExplicitLeft = 313
        ExplicitWidth = 308
        ExplicitHeight = 175
      end
      inherited btnOther: TButton
        Top = 175
        Width = 309
        Caption = 'SNOMED Codes'
        Visible = False
        ExplicitTop = 174
        ExplicitWidth = 309
      end
    end
    object pnlRight: TPanel
      Left = 0
      Top = 0
      Width = 625
      Height = 200
      Align = alClient
      TabOrder = 1
      TabStop = True
      DesignSize = (
        625
        200)
      object lblCodes: TLabel
        Left = 7
        Top = 6
        Width = 79
        Height = 13
        Caption = 'Standard Codes:'
        Visible = False
      end
      object btnTaxonomy: TButton
        Left = 6
        Top = 166
        Width = 163
        Height = 28
        Anchors = [akLeft, akBottom]
        Caption = 'Reminder Taxonomies'
        TabOrder = 0
        OnClick = btnTaxonomyClick
      end
      object lbxCodes: TORListBox
        Left = 6
        Top = 22
        Width = 407
        Height = 138
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        MultiSelect = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Visible = False
        OnClick = clbListClick
        OnDblClick = lbxCodesDblClick
        OnExit = lbxSectionExit
        Caption = 'Standard Code'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '1,2,3'
        TabPosInPixels = True
        OnChange = lbxCodesChange
        FlatCheckBoxes = False
        CheckEntireLine = True
        OnClickCheck = lbxSectionClickCheck
      end
      object btnAdd: TButton
        Left = 336
        Top = 166
        Width = 75
        Height = 25
        Caption = 'Add'
        Enabled = False
        TabOrder = 2
        Visible = False
        OnClick = btnAddClick
      end
      object btnPL: TButton
        Left = 200
        Top = 166
        Width = 115
        Height = 28
        Caption = 'Problem List'
        TabOrder = 4
        OnClick = btnPLClick
      end
    end
    object lblTaxonomies: TORStaticText
      Left = 156
      Top = 198
      Width = 1
      Height = 1
      Alignment = taLeftJustify
      Anchors = []
      BevelOuter = bvNone
      Caption = 'Reminder Taxonomies'
      TabOrder = 2
      Visible = False
      Text = 'Reminder Taxonomies'#13#10
      Lines.Strings = (
        'Reminder Taxonomies')
    end
  end
  object edtMag: TCaptionEdit [6]
    Left = 8
    Top = 338
    Width = 90
    Height = 21
    Anchors = [akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnChange = edtMagChange
    OnEnter = edtMagEnter
    OnExit = edtMagExit
    OnKeyPress = edtMagKeyPress
    Caption = '0'
  end
  object ckbAdd2PL: TCheckBox [7]
    Left = 441
    Top = 334
    Width = 100
    Height = 32
    Anchors = [akRight, akBottom]
    Caption = 'Add to Problem List'
    TabOrder = 3
    WordWrap = True
    OnClick = ckbAdd2PLClick
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
        'Component = frmStandardCodes'
        'Status = stsDefault')
      (
        'Component = edtMag'
        'Status = stsDefault')
      (
        'Component = btnTaxonomy'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = lbxCodes'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = ckbAdd2PL'
        'Status = stsDefault')
      (
        'Component = lblTaxonomies'
        'Status = stsDefault')
      (
        'Component = btnPL'
        'Status = stsDefault'))
  end
end
