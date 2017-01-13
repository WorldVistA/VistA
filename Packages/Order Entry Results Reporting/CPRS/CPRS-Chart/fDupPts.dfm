inherited frmDupPts: TfrmDupPts
  Left = 160
  Top = 190
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Similar Patients'
  ClientHeight = 187
  ClientWidth = 463
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDupPts: TPanel [0]
    Left = 0
    Top = 0
    Width = 463
    Height = 187
    Align = alClient
    TabOrder = 0
    DesignSize = (
      463
      187)
    object lblSelDupPts: TLabel
      Left = 1
      Top = 1
      Width = 461
      Height = 13
      Align = alTop
      Caption = 'Please select the correct patient:'
      ExplicitWidth = 155
    end
    object pnlSelDupPt: TPanel
      Left = 2
      Top = 19
      Width = 461
      Height = 120
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      object lboSelPt: TCaptionListView
        Left = 1
        Top = 1
        Width = 459
        Height = 118
        Margins.Left = 8
        Margins.Right = 8
        Align = alClient
        Columns = <
          item
            Caption = 'Name'
            Width = 180
          end
          item
            Caption = 'DOB'
            Tag = 1
            Width = 100
          end
          item
            Caption = 'SSN'
            Tag = 2
            Width = 160
          end>
        HideSelection = False
        HoverTime = 0
        IconOptions.WrapText = False
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowWorkAreas = True
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = lboSelPtDblClick
        Caption = 'Please select the correct patient'
        Pieces = '2,3,4'
        ExplicitLeft = 0
        ExplicitTop = 47
        ExplicitWidth = 461
        ExplicitHeight = 73
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 137
      Width = 461
      Height = 49
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        461
        49)
      object btnOK: TButton
        Left = 288
        Top = 16
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&OK'
        Default = True
        TabOrder = 0
        OnClick = btnOKClick
        ExplicitLeft = 290
      end
      object btnCancel: TButton
        Left = 373
        Top = 16
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCancelClick
        ExplicitLeft = 375
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlDupPts'
        'Status = stsDefault')
      (
        'Component = pnlSelDupPt'
        'Status = stsDefault')
      (
        'Component = frmDupPts'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = lboSelPt'
        'Status = stsDefault'))
  end
end
