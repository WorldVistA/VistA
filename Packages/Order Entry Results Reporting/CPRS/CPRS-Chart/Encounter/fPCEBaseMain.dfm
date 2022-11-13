inherited frmPCEBaseMain: TfrmPCEBaseMain
  Left = 302
  Top = 166
  Caption = 'frmPCEBaseMain'
  PixelsPerInch = 96
  TextHeight = 16
  object lblSection: TLabel [0]
    Left = 6
    Top = 6
    Width = 59
    Height = 16
    Caption = 'lblSection'
  end
  object lblList: TLabel [1]
    Left = 213
    Top = 6
    Width = 85
    Height = 16
    Caption = 'Section Name'
  end
  object lblComment: TLabel [2]
    Left = 6
    Top = 328
    Width = 64
    Height = 16
    Caption = 'Comments'
  end
  object bvlMain: TBevel [3]
    Left = 0
    Top = 230
    Width = 619
    Height = 140
  end
  inherited btnOK: TBitBtn
    Left = 463
    TabOrder = 1
    ExplicitLeft = 463
  end
  inherited btnCancel: TBitBtn
    Left = 544
    ExplicitLeft = 544
  end
  inherited pnlGrid: TPanel
    Width = 475
    TabOrder = 0
    ExplicitWidth = 475
    inherited lstCaptionList: TCaptionListView
      Width = 475
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
      ExplicitWidth = 475
    end
  end
  object edtComment: TCaptionEdit [7]
    Left = 6
    Top = 343
    Width = 523
    Height = 24
    TabOrder = 5
    OnChange = edtCommentChange
    OnExit = edtCommentExit
    OnKeyPress = edtCommentKeyPress
    Caption = 'Comments'
  end
  object btnRemove: TButton [8]
    Left = 536
    Top = 343
    Width = 75
    Height = 21
    Caption = 'Remove'
    TabOrder = 4
    OnClick = btnRemoveClick
  end
  object btnSelectAll: TButton [9]
    Left = 406
    Top = 326
    Width = 75
    Height = 17
    Caption = 'Select All'
    TabOrder = 3
    TabStop = False
    OnClick = btnSelectAllClick
  end
  object pnlMain: TPanel [10]
    Left = 6
    Top = 20
    Width = 612
    Height = 204
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 6
    object splLeft: TSplitter
      Left = 204
      Top = 0
      Height = 204
      OnMoved = splLeftMoved
    end
    object lbxSection: TORListBox
      Left = 207
      Top = 0
      Width = 405
      Height = 204
      Style = lbOwnerDrawFixed
      Align = alClient
      ExtendedSelect = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = clbListClick
      OnExit = lbxSectionExit
      OnMouseDown = clbListMouseDown
      Caption = 'Section Name'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
      TabPosInPixels = True
      CheckBoxes = True
      CheckEntireLine = True
      OnClickCheck = lbxSectionClickCheck
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 204
      Height = 204
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        204
        204)
      object lbSection: TORListBox
        Left = 0
        Top = 0
        Width = 204
        Height = 174
        Align = alTop
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = lbSectionClick
        OnExit = lbSectionExit
        Caption = 'Section'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3'
        CheckEntireLine = True
      end
      object btnOther: TButton
        Left = 65
        Top = 178
        Width = 139
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Other'
        TabOrder = 0
        OnClick = btnOtherClick
        OnExit = btnOtherExit
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 24
    Top = 24
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
        'Component = frmPCEBaseMain'
        'Status = stsDefault'))
  end
end
