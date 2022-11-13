object va508CollectionEditor: Tva508CollectionEditor
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = '508 Accessibility Manager'
  ClientHeight = 447
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object splMain: TSplitter
    Left = 257
    Top = 0
    Height = 428
    ExplicitLeft = 320
    ExplicitTop = 72
    ExplicitHeight = 100
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 257
    Height = 428
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lbCtrllList: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 251
      Height = 13
      Margins.Top = 10
      Align = alTop
      Caption = 'Control List'
      ExplicitWidth = 54
    end
    object lstCtrls: TListView
      Left = 0
      Top = 26
      Width = 257
      Height = 402
      Hint = 'List of all 508 compatible controls on the form'
      Align = alClient
      Columns = <>
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      ViewStyle = vsList
      OnSelectItem = lstCtrlsSelectItem
    end
  end
  object pnlRight: TPanel
    Left = 260
    Top = 0
    Width = 385
    Height = 428
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblAccLbl: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 69
      Width = 379
      Height = 13
      Align = alTop
      Caption = 'Access Label:'
      ExplicitWidth = 65
    end
    object lblAccProp: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 115
      Width = 379
      Height = 13
      Align = alTop
      Caption = 'Access Property:'
      ExplicitWidth = 82
    end
    object lnlAccTxt: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 161
      Width = 379
      Height = 13
      Align = alTop
      Caption = 'Access Text:'
      ExplicitWidth = 62
    end
    object lblHeader: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 20
      Width = 379
      Height = 13
      Margins.Top = 20
      Align = alTop
      Caption = 'Settings for TEdt'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 94
    end
    object chkDefault: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 46
      Width = 379
      Height = 17
      Hint = 
        'The screen reader will announce the default property when readin' +
        'g'
      Margins.Top = 10
      Align = alTop
      Caption = 'Use Default '
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = chkDefaultClick
    end
    object cmbAccessLbl: TComboBox
      AlignWithMargins = True
      Left = 3
      Top = 88
      Width = 379
      Height = 21
      Hint = 'The screen reader will announce this label when reading'
      Align = alTop
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnChange = cmbAccessLblChange
    end
    object cmbAccessProp: TComboBox
      AlignWithMargins = True
      Left = 3
      Top = 134
      Width = 379
      Height = 21
      Hint = 'The screen reader will announce this property when reading'
      Align = alTop
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnChange = cmbAccessPropChange
    end
    object memAccessTxt: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 180
      Width = 379
      Height = 75
      Hint = 'The screen reader will announce this text when reading'
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnChange = memAccessTxtChange
    end
    object pnlLstView: TPanel
      Left = 0
      Top = 258
      Width = 385
      Height = 170
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      Visible = False
      object lblAccColumns: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 379
        Height = 13
        Align = alTop
        Caption = 'Access Columns:'
        ExplicitWidth = 80
      end
      object lstAccessCol: TCheckListBox
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 379
        Height = 145
        Hint = 'The screen reader will announce these columns when reading'
        OnClickCheck = lstAccessColClickCheck
        Align = alClient
        Columns = 4
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 428
    Width = 645
    Height = 19
    AutoHint = True
    Panels = <>
    ParentShowHint = False
    ShowHint = True
    SimplePanel = True
  end
  object MainMenu1: TMainMenu
    Left = 176
    Top = 8
    object Main1: TMenuItem
      Caption = 'Main'
      object RefreshAll1: TMenuItem
        Caption = 'Refresh All'
        OnClick = RefreshAll1Click
      end
    end
  end
end
