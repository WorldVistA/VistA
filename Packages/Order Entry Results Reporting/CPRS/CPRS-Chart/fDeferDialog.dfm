object frmDeferDialog: TfrmDeferDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Defer Item'
  ClientHeight = 331
  ClientWidth = 645
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object pnlBottom: TPanel
    Left = 0
    Top = 279
    Width = 645
    Height = 52
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      645
      52)
    object cmdCancel: TButton
      Left = 534
      Top = 11
      Width = 94
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object cmdDefer: TButton
      Left = 433
      Top = 11
      Width = 93
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Action = acDefer
      Anchors = [akRight, akBottom]
      TabOrder = 1
    end
  end
  object gbxDeferBy: TGroupBox
    AlignWithMargins = True
    Left = 411
    Top = 4
    Width = 230
    Height = 271
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alRight
    Caption = ' Defer Until '
    TabOrder = 1
    DesignSize = (
      230
      271)
    object Bevel2: TBevel
      Left = 13
      Top = 188
      Width = 203
      Height = 5
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Shape = bsTopLine
    end
    object lblDate: TLabel
      Left = 13
      Top = 201
      Width = 34
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Date:'
    end
    object lblTime: TLabel
      Left = 13
      Top = 235
      Width = 34
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Time:'
    end
    object lblCustom: TLabel
      Left = 13
      Top = 163
      Width = 48
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Custom'
      Transparent = False
    end
    object dtpDate: TDateTimePicker
      Left = 84
      Top = 198
      Width = 132
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Date = 41835.573142557870000000
      Time = 41835.573142557870000000
      TabOrder = 0
    end
    object dtpTime: TDateTimePicker
      Left = 84
      Top = 231
      Width = 132
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Date = 41835.573435787040000000
      Format = 'h:mm tt'
      Time = 41835.573435787040000000
      Kind = dtkTime
      TabOrder = 1
    end
    object cbxDeferBy: TComboBox
      Left = 13
      Top = 31
      Width = 203
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = csDropDownList
      TabOrder = 2
      OnChange = acNewDeferalClickedExecute
    end
    object stxtDeferUntilDate: TStaticText
      AlignWithMargins = True
      Left = 13
      Top = 75
      Width = 116
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'stxtDeferUntilDate'
      TabOrder = 3
    end
    object stxtDeferUntilTime: TStaticText
      AlignWithMargins = True
      Left = 13
      Top = 113
      Width = 116
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'stxtDeferUntilTime'
      TabOrder = 4
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 407
    Height = 279
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlLeft'
    ShowCaption = False
    TabOrder = 2
    object stxtDescription: TStaticText
      AlignWithMargins = True
      Left = 13
      Top = 13
      Width = 381
      Height = 253
      Margins.Left = 13
      Margins.Top = 13
      Margins.Right = 13
      Margins.Bottom = 13
      Align = alClient
      Caption = 'stxtDescription'
      TabOrder = 0
    end
  end
  object acList: TActionList
    Left = 40
    Top = 56
    object acNewDeferalClicked: TAction
      Caption = 'acNewDeferalClicked'
      OnExecute = acNewDeferalClickedExecute
    end
    object acDefer: TAction
      Caption = 'Defer'
      OnExecute = acDeferExecute
    end
  end
end
