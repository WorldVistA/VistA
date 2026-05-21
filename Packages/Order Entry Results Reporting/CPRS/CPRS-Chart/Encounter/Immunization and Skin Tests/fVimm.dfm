inherited vimmMainForm: TvimmMainForm
  Left = 0
  Top = 0
  Caption = 'vimmMainForm'
  ClientHeight = 561
  ClientWidth = 1011
  Color = clWhite
  Constraints.MinHeight = 600
  Constraints.MinWidth = 1024
  Font.Name = 'Tahoma'
  StyleElements = [seFont, seClient, seBorder]
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 1027
  ExplicitHeight = 600
  TextHeight = 13
  object ScrollBox: TScrollBox [0]
    Left = 0
    Top = 0
    Width = 1011
    Height = 561
    Align = alClient
    ParentBackground = True
    TabOrder = 0
    OnResize = ScrollBoxResize
    object pnlForm: TPanel
      Left = 0
      Top = 0
      Width = 1007
      Height = 553
      Align = alTop
      Caption = 'pnlForm'
      TabOrder = 0
      object Panel1: TPanel
        Left = 1
        Top = 511
        Width = 1005
        Height = 41
        Align = alBottom
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          1005
          41)
        object btnCancel: TButton
          Left = 644
          Top = 6
          Width = 74
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Cancel'
          TabOrder = 0
          TabStop = False
          OnClick = btnCancelClick
        end
        object btnSave: TButton
          Left = 900
          Top = 6
          Width = 93
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Finish'
          TabOrder = 3
          TabStop = False
          OnClick = btnSaveClick
        end
        object btnAdd: TButton
          Left = 812
          Top = 6
          Width = 84
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Save'
          TabOrder = 2
          OnClick = btnAddClick
        end
        object btnCancelRecord: TButton
          Left = 724
          Top = 6
          Width = 82
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Clear'
          TabOrder = 1
          OnClick = btnCancelRecordClick
        end
      end
      object GridPanel: TGridPanel
        Left = 1
        Top = 1
        Width = 1005
        Height = 510
        Align = alClient
        BevelInner = bvRaised
        BevelKind = bkSoft
        BorderWidth = 1
        BorderStyle = bsSingle
        Color = clWindow
        ColumnCollection = <
          item
            Value = 100.000000000000000000
          end>
        ControlCollection = <>
        ParentBackground = False
        RowCollection = <
          item
            Value = 27.822630729101980000
          end
          item
            Value = 24.603154887591600000
          end
          item
            Value = 23.122593466650110000
          end
          item
            Value = 24.451620916656310000
          end>
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = ScrollBox'
        'Status = stsDefault')
      (
        'Component = pnlForm'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnSave'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = btnCancelRecord'
        'Status = stsDefault')
      (
        'Component = GridPanel'
        'Status = stsDefault')
      (
        'Component = vimmMainForm'
        'Status = stsDefault'))
  end
end
