inherited frmTemplateReport: TfrmTemplateReport
  Left = 0
  Top = 0
  Caption = '-)'
  ClientHeight = 545
  ClientWidth = 789
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object pnlButtons: TPanel
    Left = 0
    Top = 504
    Width = 789
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 795
    DesignSize = (
      789
      41)
    object btnCopy: TButton
      Left = 8
      Top = 6
      Width = 185
      Height = 25
      Caption = 'Copy Report to Clipboard'
      TabOrder = 0
      OnClick = btnCopyClick
    end
    object btnCancel: TButton
      Left = 706
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
      ExplicitLeft = 712
    end
  end
  object reReport: TRichEdit
    Left = 0
    Top = 0
    Width = 789
    Height = 448
    Align = alClient
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    Zoom = 100
    ExplicitWidth = 795
  end
  object pnlStatusBar: TPanel
    Left = 0
    Top = 448
    Width = 789
    Height = 56
    Align = alBottom
    TabOrder = 2
    ExplicitWidth = 795
    object lblCurrent: TLabel
      Left = 8
      Top = 6
      Width = 56
      Height = 16
      Caption = 'lblCurrent'
    end
    object lblCount: TLabel
      Left = 8
      Top = 28
      Width = 46
      Height = 16
      Caption = 'lblCount'
    end
  end
end
