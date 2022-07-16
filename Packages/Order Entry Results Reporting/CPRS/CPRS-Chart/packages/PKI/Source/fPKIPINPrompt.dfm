object frmPKIPINPrompt: TfrmPKIPINPrompt
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'PIV card PIN entry'
  ClientHeight = 153
  ClientWidth = 356
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 55
    Width = 356
    Height = 4
    Align = alBottom
    BevelOuter = bvNone
    Color = 4227327
    ParentBackground = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 59
    Width = 356
    Height = 94
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      356
      94)
    object lblInstructions: TLabel
      Left = 8
      Top = 8
      Width = 126
      Height = 13
      Caption = 'Please enter your PIV PIN.'
    end
    object lblPIN: TLabel
      Left = 8
      Top = 33
      Width = 18
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'PIN'
    end
    object btnOK: TButton
      Left = 220
      Top = 67
      Width = 61
      Height = 20
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 288
      Top = 67
      Width = 61
      Height = 20
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object edtPINValue: TEdit
      Left = 85
      Top = 30
      Width = 195
      Height = 24
      PasswordChar = '*'
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 356
    Height = 55
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    Color = clGray
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 28
      Width = 116
      Height = 16
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'PIV Card Access'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 11
      Width = 167
      Height = 15
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Department of Veterans Affairs'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
    end
  end
end
