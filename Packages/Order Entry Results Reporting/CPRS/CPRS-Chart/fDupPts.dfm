inherited frmDupPts: TfrmDupPts
  Left = 160
  Top = 190
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  Caption = 'Similar Patients'
  ClientHeight = 247
  ClientWidth = 642
  Constraints.MinHeight = 240
  Constraints.MinWidth = 320
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 654
  ExplicitHeight = 274
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDupPts: TPanel [0]
    Left = 0
    Top = 0
    Width = 642
    Height = 203
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 687
    ExplicitHeight = 212
    object lblSelDupPts: TLabel
      Left = 1
      Top = 1
      Width = 155
      Height = 13
      Caption = 'Please select the correct patient:'
      Visible = False
    end
  end
  object pnlSelDupPt: TPanel [1]
    Left = 0
    Top = 0
    Width = 642
    Height = 203
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 687
    ExplicitHeight = 212
    object lboSelPt: TCaptionListView
      Left = 1
      Top = 39
      Width = 640
      Height = 163
      Margins.Left = 8
      Margins.Right = 8
      Align = alClient
      BevelOuter = bvNone
      Columns = <
        item
          Caption = 'Name'
          Width = 180
        end
        item
          Caption = 'DOB'
          Tag = 1
          Width = 76
        end
        item
          Caption = 'SSN'
          Tag = 2
          Width = 76
        end
        item
          Caption = 'Location'
          Width = 76
        end
        item
          Caption = 'Physician'
          Width = 76
        end
        item
          Caption = 'Last Visit'
          Width = 76
        end
        item
          Caption = 'Last Location'
          Width = 76
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
      OnCustomDrawItem = lboSelPtCustomDrawItem
      OnDblClick = lboSelPtDblClick
      AutoSize = False
      Caption = 'Please select the correct patient'
      Pieces = '2,3,4,5,6,7,8'
      ExplicitWidth = 685
    end
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 640
      Height = 38
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 685
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 203
    Width = 642
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 212
    ExplicitWidth = 687
    object Panel2: TPanel
      Left = 283
      Top = 0
      Width = 169
      Height = 44
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 0
      object btnOK: TButton
        Left = 3
        Top = 13
        Width = 75
        Height = 25
        Caption = '&OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 84
        Top = 13
        Width = 75
        Height = 25
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 32
    Top = 96
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
        'Status = stsDefault')
      (
        'Component = pnlHeader'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault'))
  end
end
