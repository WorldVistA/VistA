object frmWVEIEReasonsDlg: TfrmWVEIEReasonsDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Women'#39's Health - Entered In Error Reason'
  ClientHeight = 110
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    375
    110)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlOther: TPanel
    Left = 10
    Top = 20
    Width = 365
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    Caption = 'pnlOther'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      365
      25)
    object chkbxOther: TCheckBox
      Left = 0
      Top = 0
      Width = 97
      Height = 17
      Caption = 'Other'
      TabOrder = 0
      OnClick = chkbxOtherClick
    end
    object stxtReason: TStaticText
      Left = 64
      Top = 2
      Width = 131
      Height = 17
      Alignment = taRightJustify
      Caption = 'Enter Reason (3-50 chars)'
      Enabled = False
      TabOrder = 1
    end
    object edtOtherReason: TEdit
      Left = 213
      Top = 0
      Width = 142
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      MaxLength = 50
      TabOrder = 2
      OnChange = edtOtherReasonChange
    end
  end
  object btnCancel: TButton
    Left = 290
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
    Left = 208
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
