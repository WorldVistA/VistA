inherited frmWVEIEReasonsDlg: TfrmWVEIEReasonsDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Women'#39's Health - Entered In Error Reason'
  ClientHeight = 110
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    443
    110)
  PixelsPerInch = 96
  TextHeight = 16
  object pnlOther: TPanel
    Left = 10
    Top = 20
    Width = 433
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      433
      25)
    object chkbxOther: TCheckBox
      Left = 0
      Top = 2
      Width = 58
      Height = 17
      Caption = 'Other'
      TabOrder = 0
      OnClick = chkbxOtherClick
    end
    object stxtReason: TStaticText
      Left = 64
      Top = 2
      Width = 158
      Height = 20
      Alignment = taRightJustify
      Caption = 'Enter Reason (3-50 chars)'
      Enabled = False
      TabOrder = 1
    end
    object edtOtherReason: TEdit
      Left = 228
      Top = 0
      Width = 195
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      MaxLength = 50
      TabOrder = 2
      OnChange = edtOtherReasonChange
    end
  end
  object btnCancel: TButton
    Left = 358
    Top = 77
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    DoubleBuffered = True
    ModalResult = 2
    ParentDoubleBuffered = False
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 276
    Top = 77
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    DoubleBuffered = True
    Enabled = False
    ModalResult = 1
    ParentDoubleBuffered = False
    TabOrder = 2
  end
end
