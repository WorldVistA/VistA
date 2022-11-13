inherited fraReminders: TfraReminders
  inherited pnlHeader: TPanel
    inherited lblHeader: TLabel
      Width = 772
      Height = 21
      Caption = 'Immunization Statuses'
      ExplicitWidth = 132
    end
  end
  inherited pnlWorkspace: TPanel
    object pnlItems: TPanel
      Left = 1
      Top = 1
      Width = 807
      Height = 148
      Align = alClient
      TabOrder = 0
      object Splitter1: TSplitter
        Left = 481
        Top = 1
        Width = 2
        Height = 146
      end
      object remList: TListView
        Left = 1
        Top = 1
        Width = 480
        Height = 146
        Align = alLeft
        Columns = <
          item
            Caption = 'id'
            Width = 0
          end
          item
            AutoSize = True
            Caption = 'Reminder Name'
          end
          item
            AutoSize = True
            Caption = 'Status'
          end
          item
            AutoSize = True
            Caption = 'Date Done'
          end
          item
            AutoSize = True
            Caption = 'Date Due'
          end>
        ReadOnly = True
        RowSelect = True
        PopupMenu = mnuAction
        TabOrder = 0
        ViewStyle = vsReport
      end
      object pnlDetails: TPanel
        Left = 483
        Top = 1
        Width = 323
        Height = 146
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object Splitter2: TSplitter
          Left = 0
          Top = 97
          Width = 323
          Height = 3
          Cursor = crVSplit
          Align = alBottom
          ExplicitWidth = 49
        end
        object lstHistory: TListView
          Left = 0
          Top = 0
          Width = 323
          Height = 97
          Align = alClient
          Columns = <>
          TabOrder = 0
          ViewStyle = vsReport
        end
        object remDetails: TRichEdit
          Left = 0
          Top = 100
          Width = 323
          Height = 46
          Align = alBottom
          Color = clCream
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Lines.Strings = (
            '')
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 1
          Zoom = 100
        end
      end
    end
  end
  object mnuAction: TPopupMenu
    Left = 400
    Top = 8
    object AddImmunization1: TMenuItem
      Caption = 'Add Immunization'
      OnClick = AddImmunization1Click
    end
    object ViewInformation1: TMenuItem
      Caption = 'View Information'
      OnClick = ViewInformation1Click
    end
    object acClinMaint: TMenuItem
      Caption = 'Clinical Maintenance'
      OnClick = acClinMaintClick
    end
  end
end
