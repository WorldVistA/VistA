inherited frmCombatVet: TfrmCombatVet
  Left = 22
  Top = 101
  BorderStyle = bsDialog
  Caption = 'Combat Veteran Details'
  ClientHeight = 248
  ClientWidth = 294
  Position = poMainFormCenter
  OnShow = FormShow
  ExplicitWidth = 300
  ExplicitHeight = 273
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 294
    Height = 209
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    BevelWidth = 2
    BorderWidth = 1
    TabOrder = 0
    DesignSize = (
      294
      209)
    object lblServiceBranch: TLabel
      Left = 36
      Top = 18
      Width = 76
      Height = 13
      Anchors = []
      Caption = 'Service Branch:'
      ExplicitLeft = 35
    end
    object lblStatus: TLabel
      Left = 79
      Top = 55
      Width = 33
      Height = 13
      Anchors = []
      Caption = 'Status:'
      ExplicitLeft = 78
      ExplicitTop = 54
    end
    object lblSepDate: TLabel
      Left = 32
      Top = 91
      Width = 80
      Height = 13
      Anchors = []
      Caption = 'Separation Date:'
    end
    object lblExpireDate: TLabel
      Left = 37
      Top = 129
      Width = 75
      Height = 13
      Anchors = []
      Caption = 'Expiration Date:'
      ExplicitLeft = 36
      ExplicitTop = 126
    end
    object edtServiceBranch: TEdit
      Left = 120
      Top = 18
      Width = 166
      Height = 21
      Anchors = []
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object edtStatus: TEdit
      Left = 120
      Top = 55
      Width = 166
      Height = 21
      Anchors = []
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtSeparationDate: TEdit
      Left = 120
      Top = 91
      Width = 166
      Height = 21
      Anchors = []
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object edtExpireDate: TEdit
      Left = 120
      Top = 129
      Width = 166
      Height = 21
      Anchors = []
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
    object edtOEF_OIF: TEdit
      Left = 120
      Top = 166
      Width = 166
      Height = 21
      Anchors = []
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
  end
  object BitBtn1: TBitBtn [1]
    Left = 104
    Top = 215
    Width = 75
    Height = 25
    Anchors = []
    Cancel = True
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmCombatVet'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = BitBtn1'
        'Status = stsDefault')
      (
        'Component = edtServiceBranch'
        'Label = lblServiceBranch'
        'Status = stsOK')
      (
        'Component = edtStatus'
        'Label = lblStatus'
        'Status = stsOK')
      (
        'Component = edtSeparationDate'
        'Label = lblSepDate'
        'Status = stsOK')
      (
        'Component = edtExpireDate'
        'Label = lblExpireDate'
        'Status = stsOK')
      (
        'Component = edtOEF_OIF'
        'Status = stsDefault'))
  end
end
