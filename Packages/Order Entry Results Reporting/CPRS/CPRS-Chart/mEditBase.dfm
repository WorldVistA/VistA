object fraEditGridBase: TfraEditGridBase
  Left = 0
  Top = 0
  Width = 674
  Height = 337
  Color = clWindow
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 674
    Height = 337
    Align = alClient
    TabOrder = 0
    OnMouseWheel = ScrollBox1MouseWheel
    object pnlForm: TPanel
      Left = 0
      Top = 0
      Width = 670
      Height = 330
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object grdEditPanel: TGridPanel
        Left = 0
        Top = 0
        Width = 670
        Height = 281
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <>
        ParentColor = True
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        TabOrder = 0
      end
      object pnlButtons: TPanel
        Left = 0
        Top = 281
        Width = 670
        Height = 49
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          670
          49)
        object btnSave: TButton
          Left = 568
          Top = 16
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Save'
          TabOrder = 0
          TabStop = False
          OnClick = btnSaveClick
        end
        object btnCancel: TButton
          Left = 464
          Top = 16
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Cancel'
          TabOrder = 1
          TabStop = False
          OnClick = btnCancelClick
        end
      end
    end
  end
end
