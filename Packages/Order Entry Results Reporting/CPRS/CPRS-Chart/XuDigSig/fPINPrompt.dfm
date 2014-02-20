object frmPINPrompt: TfrmPINPrompt
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'CPRS PIV card PIN entry'
  ClientHeight = 198
  ClientWidth = 249
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    249
    198)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 67
    Width = 249
    Height = 41
    Color = clRed
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 87
    Width = 249
    Height = 114
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 126
      Height = 13
      Caption = 'Please enter your PIV PIN:'
    end
    object btnOK: TButton
      Left = 21
      Top = 70
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 134
      Top = 70
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object edtPINValue: TEdit
      Left = 21
      Top = 27
      Width = 188
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 249
    Height = 81
    Color = clGray
    TabOrder = 1
  end
end
