inherited fraVimmSelect: TfraVimmSelect
  Width = 717
  Height = 96
  ExplicitWidth = 717
  ExplicitHeight = 96
  inherited pnlHeader: TPanel
    Width = 717
    ExplicitWidth = 717
  end
  inherited pnlWorkspace: TPanel
    Width = 717
    Height = 67
    ExplicitWidth = 717
    ExplicitHeight = 67
    object gridPanel: TGridPanel
      Left = 1
      Top = 1
      Width = 715
      Height = 65
      Align = alClient
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
          Control = rgpDocumentation
          Row = 0
        end
        item
          Column = 1
          Control = pnlImm
          Row = 0
        end>
      ParentColor = True
      RowCollection = <
        item
          Value = 100.000000000000000000
        end
        item
          SizeStyle = ssAuto
        end>
      TabOrder = 0
      object rgpDocumentation: TRadioGroup
        Left = 1
        Top = 1
        Width = 356
        Height = 63
        Align = alClient
        Caption = 'Select Documentation Type'
        Columns = 2
        Enabled = False
        Items.Strings = (
          '&Administered'
          '&Historical'
          '&Contraindication/Precaution'
          '&Refused')
        TabOrder = 0
        TabStop = True
        OnClick = rgpDocumentationClick
        OnEnter = rgpDocumentationEnter
      end
      object pnlImm: TPanel
        Left = 357
        Top = 1
        Width = 357
        Height = 63
        Align = alClient
        Padding.Right = 10
        ParentColor = True
        TabOrder = 1
        DesignSize = (
          357
          63)
        object lblImm: TLabel
          Left = 6
          Top = 6
          Width = 119
          Height = 13
          Caption = 'Select an Immunization *'
        end
        object cboImm: TORComboBox
          Left = 6
          Top = 25
          Width = 341
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Style = orcsDropDown
          AutoSelect = True
          Caption = ''
          Color = clWindow
          DropDownCount = 8
          Enabled = False
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = False
          LookupPiece = 2
          MaxLength = 0
          ParentShowHint = False
          Pieces = '2'
          ShowHint = False
          Sorted = True
          SynonymChars = '<>'
          TabOrder = 0
          TabStop = True
          Text = ''
          OnKeyDown = cboImmKeyDown
          OnMouseClick = cboImmMouseClick
          CharsNeedMatch = 1
          SetItemIndexOnChange = False
        end
      end
    end
  end
end
