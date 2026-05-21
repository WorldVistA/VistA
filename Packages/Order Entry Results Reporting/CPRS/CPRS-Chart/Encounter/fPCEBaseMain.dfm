inherited frmPCEBaseMain: TfrmPCEBaseMain
  Left = 302
  Top = 166
  Caption = 'frmPCEBaseMain'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 13
  inherited pnlMainAncestor: TPanel [0]
    Top = 204
    Height = 168
    TabOrder = 1
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 204
    ExplicitHeight = 168
    inherited pnlGrid: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 536
      Height = 162
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 3
      ExplicitTop = 3
      ExplicitWidth = 536
      ExplicitHeight = 162
      inherited lstCaptionList: TCaptionListView
        Width = 530
        Height = 130
        Columns = <
          item
            Width = 30
          end
          item
            Width = 120
          end>
        OnChange = lstCaptionListChange
        OnClick = lstCaptionListClick
        OnExit = lstCaptionListExit
        OnInsert = lstCaptionListInsert
        ExplicitWidth = 530
        ExplicitHeight = 130
      end
      object pnlComments: TPanel
        Left = 0
        Top = 136
        Width = 536
        Height = 26
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'pnlComments'
        ShowCaption = False
        TabOrder = 1
        object lblComment: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 55
          Height = 20
          Align = alLeft
          Caption = 'Comments: '
          ExplicitHeight = 13
        end
        object edtComment: TCaptionEdit
          AlignWithMargins = True
          Left = 64
          Top = 0
          Width = 469
          Height = 23
          Margins.Top = 0
          Align = alClient
          TabOrder = 0
          OnChange = edtCommentChange
          OnExit = edtCommentExit
          OnKeyPress = edtCommentKeyPress
          Caption = ''
          ExplicitHeight = 21
        end
      end
    end
    object pnlGridRight: TPanel
      Left = 542
      Top = 0
      Width = 78
      Height = 168
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      object btnRemove: TButton
        AlignWithMargins = True
        Left = 0
        Top = 27
        Width = 75
        Height = 21
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = 'Remove'
        TabOrder = 1
        OnClick = btnRemoveClick
      end
      object btnSelectAll: TButton
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 75
        Height = 21
        Margins.Left = 0
        Align = alTop
        Caption = 'Select All'
        TabOrder = 0
        TabStop = False
        OnClick = btnSelectAllClick
      end
    end
  end
  inherited pnlBottomAncestor: TPanel [1]
    TabOrder = 2
    StyleElements = [seFont, seClient, seBorder]
  end
  object pnlMain: TPanel [2]
    Left = 0
    Top = 0
    Width = 620
    Height = 204
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object grdMain: TGridPanel
      Left = 0
      Top = 0
      Width = 620
      Height = 204
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
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
          SizeStyle = ssAuto
        end>
      TabOrder = 0
      object lblSection: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 307
        Height = 13
        Margins.Right = 0
        Align = alTop
        Anchors = []
        Caption = 'lblSection'
        ExplicitWidth = 46
      end
      object lblList: TLabel
        AlignWithMargins = True
        Left = 313
        Top = 3
        Width = 304
        Height = 13
        Align = alTop
        Anchors = []
        Caption = 'Section Name'
        ExplicitWidth = 67
      end
      object lbSection: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 304
        Height = 158
        Margins.Top = 0
        Align = alClient
        Anchors = []
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lbSectionClick
        OnExit = lbSectionExit
        Caption = 'Section'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3'
        FlatCheckBoxes = False
        CheckEntireLine = True
      end
      object lbxSection: TORListBox
        AlignWithMargins = True
        Left = 313
        Top = 19
        Width = 304
        Height = 182
        Margins.Top = 0
        Style = lbOwnerDrawFixed
        Align = alClient
        Anchors = []
        ExtendedSelect = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnExit = lbxSectionExit
        Caption = 'Section'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        TabPosInPixels = True
        CheckBoxes = True
        FlatCheckBoxes = False
        CheckEntireLine = True
        OnClickCheck = lbxSectionClickCheck
      end
      object btnOther: TButton
        AlignWithMargins = True
        Left = 3
        Top = 180
        Width = 304
        Height = 21
        Margins.Top = 0
        Align = alBottom
        Anchors = []
        Caption = 'Other'
        TabOrder = 2
        OnClick = btnOtherClick
        OnExit = btnOtherExit
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 32
    Top = 40
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
        'Component = frmPCEBaseMain'
        'Status = stsDefault')
      (
        'Component = pnlGridRight'
        'Status = stsDefault')
      (
        'Component = pnlMainAncestor'
        'Status = stsDefault')
      (
        'Component = pnlBottomAncestor'
        'Status = stsDefault')
      (
        'Component = grdMain'
        'Status = stsDefault')
      (
        'Component = lstCaptionList'
        'Status = stsDefault')
      (
        'Component = pnlComments'
        'Status = stsDefault'))
  end
end
