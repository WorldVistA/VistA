object frmJSONDescendantClassesWizardForm: TfrmJSONDescendantClassesWizardForm
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Right = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'frmJSONDescendantClassesWizardForm'
  ClientHeight = 251
  ClientWidth = 849
  Color = clWindow
  Constraints.MinHeight = 290
  Constraints.MinWidth = 835
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 17
  object lblDesc: TLabel
    AlignWithMargins = True
    Left = 12
    Top = 38
    Width = 831
    Height = 34
    Margins.Left = 12
    Margins.Right = 6
    Align = alTop
    AutoSize = False
    Caption = 'lblDesc'
    WordWrap = True
    ExplicitWidth = 712
  end
  object lblName: TLabel
    AlignWithMargins = True
    Left = 12
    Top = 5
    Width = 831
    Height = 25
    Margins.Left = 12
    Margins.Top = 5
    Margins.Right = 6
    Margins.Bottom = 5
    Align = alTop
    AutoSize = False
    Caption = 'lblName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitLeft = 8
    ExplicitWidth = 785
  end
  object bvlTop: TBevel
    AlignWithMargins = True
    Left = 3
    Top = 78
    Width = 843
    Height = 2
    Align = alTop
    Shape = bsTopLine
    ExplicitLeft = 0
    ExplicitTop = 75
    ExplicitWidth = 730
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 213
    Width = 849
    Height = 38
    Align = alBottom
    Caption = 'pnlButtons'
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 241
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 770
      Top = 6
      Width = 75
      Height = 26
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object btnFinish: TButton
      AlignWithMargins = True
      Left = 689
      Top = 6
      Width = 75
      Height = 26
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Finish'
      Enabled = False
      TabOrder = 1
      OnClick = btnFinishClick
    end
    object btnNext: TButton
      AlignWithMargins = True
      Left = 608
      Top = 6
      Width = 75
      Height = 26
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Next >>'
      TabOrder = 0
      OnClick = btnNextClick
    end
    object btnBack: TButton
      AlignWithMargins = True
      Left = 527
      Top = 6
      Width = 75
      Height = 26
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = '<< Back'
      Enabled = False
      TabOrder = 2
      OnClick = btnBackClick
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 83
    Width = 281
    Height = 130
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnlLeft'
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMediumblue
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsUnderline]
    ParentBackground = False
    ParentFont = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = True
    TabOrder = 1
    ExplicitHeight = 381
    object lblSection1: TLabel
      AlignWithMargins = True
      Left = 12
      Top = 34
      Width = 187
      Height = 17
      Hint = 
        'Select a Prefix and/or Suffix to add to the descendent class nam' +
        'es.  So if the parent class is TObject, the descendant class wil' +
        'l be TPrefixObjectSuffix.  Prefix or Suffix can be blank, but no' +
        't both.'
      Margins.Left = 12
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Descendant Classes Prefix/Suffix'
    end
    object lblSection0: TLabel
      AlignWithMargins = True
      Left = 12
      Top = 7
      Width = 243
      Height = 17
      Hint = 'Select the Unit created by the JSON Data Binding Wizard'
      Margins.Left = 12
      Margins.Top = 7
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Select Unit Created by JSON Data Binding'
    end
    object lblSection2: TLabel
      AlignWithMargins = True
      Left = 12
      Top = 61
      Width = 152
      Height = 17
      Hint = 'Select Options for Creating Descendant Classes'
      Margins.Left = 12
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Descendant Class Options'
    end
  end
  object sbMain: TScrollBox
    Left = 281
    Top = 83
    Width = 568
    Height = 130
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 2
    ExplicitHeight = 381
    object gpMain: TGridPanel
      Left = 0
      Top = 0
      Width = 568
      Height = 130
      Align = alClient
      BevelOuter = bvNone
      Caption = 'gpMain'
      Color = clWhite
      ColumnCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 200.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          ColumnSpan = 2
          Control = cboUnit
          Row = 0
        end
        item
          Column = 0
          Control = lblPrefix
          Row = 1
        end
        item
          Column = 1
          Control = edtPrefix
          Row = 1
        end
        item
          Column = 0
          Control = lblSuffix
          Row = 2
        end
        item
          Column = 1
          Control = edtSuffix
          Row = 2
        end
        item
          Column = 0
          ColumnSpan = 2
          Control = cbIncludeOwners
          Row = 3
        end
        item
          Column = 0
          Control = lblOwnerName
          Row = 4
        end
        item
          Column = 1
          Control = cboOwnerName
          Row = 4
        end
        item
          Column = 0
          ColumnSpan = 2
          Control = cbTopLevelOwner
          Row = 5
        end
        item
          Column = 0
          Control = lblTopOwnerClass
          Row = 6
        end
        item
          Column = 1
          Control = edtTopOwnerClass
          Row = 6
        end>
      ParentBackground = False
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 31.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 31.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 31.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 31.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 31.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 31.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 31.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      ShowCaption = False
      TabOrder = 0
      OnResize = gpMainResize
      ExplicitHeight = 381
      object cboUnit: TComboBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 562
        Height = 25
        Align = alClient
        DropDownCount = 12
        Sorted = True
        TabOrder = 0
      end
      object lblPrefix: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 34
        Width = 194
        Height = 25
        Align = alClient
        AutoSize = False
        Caption = 'Class Name Prefix:'
        Layout = tlCenter
        ExplicitLeft = 200
        ExplicitTop = 65
        ExplicitWidth = 48
      end
      object edtPrefix: TEdit
        AlignWithMargins = True
        Left = 203
        Top = 34
        Width = 362
        Height = 25
        Align = alClient
        AutoSize = False
        TabOrder = 1
      end
      object lblSuffix: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 65
        Width = 194
        Height = 25
        Align = alClient
        AutoSize = False
        Caption = 'Class Name Suffix:'
        Layout = tlCenter
        ExplicitLeft = 200
        ExplicitTop = 96
        ExplicitWidth = 48
      end
      object edtSuffix: TEdit
        AlignWithMargins = True
        Left = 203
        Top = 65
        Width = 362
        Height = 25
        Align = alClient
        AutoSize = False
        TabOrder = 2
      end
      object cbIncludeOwners: TCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 96
        Width = 562
        Height = 25
        Align = alClient
        Alignment = taLeftJustify
        Caption = 'Include Owner Properties:'
        TabOrder = 3
        OnClick = cbClick
        ExplicitTop = 127
      end
      object lblOwnerName: TLabel
        AlignWithMargins = True
        Left = 18
        Top = 127
        Width = 179
        Height = 25
        Margins.Left = 18
        Align = alClient
        AutoSize = False
        Caption = 'Owner Property Name *: '
        Layout = tlCenter
        ExplicitLeft = 3
        ExplicitTop = 158
        ExplicitWidth = 245
      end
      object cboOwnerName: TComboBox
        AlignWithMargins = True
        Left = 203
        Top = 127
        Width = 362
        Height = 25
        Align = alClient
        DropDownCount = 12
        TabOrder = 4
      end
      object cbTopLevelOwner: TCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 158
        Width = 562
        Height = 25
        Align = alClient
        Alignment = taLeftJustify
        Caption = 'Top Level Class has Owner:'
        TabOrder = 5
        Visible = False
        OnClick = cbClick
        ExplicitTop = 189
      end
      object lblTopOwnerClass: TLabel
        AlignWithMargins = True
        Left = 18
        Top = 189
        Width = 179
        Height = 25
        Margins.Left = 18
        Align = alClient
        AutoSize = False
        Caption = 'Top Level Class Owner Class *:'
        Layout = tlCenter
        ExplicitLeft = 3
        ExplicitTop = 220
        ExplicitWidth = 227
      end
      object edtTopOwnerClass: TEdit
        AlignWithMargins = True
        Left = 203
        Top = 189
        Width = 362
        Height = 25
        Align = alClient
        AutoSize = False
        TabOrder = 6
        ExplicitTop = 220
      end
    end
  end
end
