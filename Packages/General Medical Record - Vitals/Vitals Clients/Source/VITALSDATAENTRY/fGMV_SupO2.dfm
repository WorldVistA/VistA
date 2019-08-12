object frmGMV_SupO2: TfrmGMV_SupO2
  Left = 743
  Top = 373
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'frmGMV_SupO2'
  ClientHeight = 157
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 254
    Height = 157
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 1
    TabOrder = 0
    object pnlBottom: TPanel
      Left = 3
      Top = 115
      Width = 248
      Height = 39
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 4
      DesignSize = (
        248
        39)
      object btnOK: TButton
        Left = 119
        Top = 10
        Width = 59
        Height = 20
        Anchors = [akTop, akRight]
        Caption = 'O&K'
        ModalResult = 1
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 181
        Top = 10
        Width = 57
        Height = 20
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
    object Panel1: TPanel
      Left = 3
      Top = 25
      Width = 248
      Height = 61
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lblFlow: TLabel
        Left = 7
        Top = 17
        Width = 51
        Height = 13
        Caption = '&Flow Rate:'
        FocusControl = edtFlow
      end
      object lblO2Con: TLabel
        Left = 7
        Top = 41
        Width = 86
        Height = 13
        Caption = '&O2 Concentration:'
        FocusControl = edtO2Con
      end
      object lblPercent: TLabel
        Left = 95
        Top = 41
        Width = 14
        Height = 13
        Caption = '(%)'
        ParentShowHint = False
        ShowHint = False
      end
      object lblLitMin: TLabel
        Left = 80
        Top = 17
        Width = 29
        Height = 13
        Hint = 'liters/minute'
        Caption = '(l/min)'
        ParentShowHint = False
        ShowHint = True
      end
      object edtFlow: TEdit
        Left = 119
        Top = 13
        Width = 98
        Height = 21
        Hint = 'Enter values between 0.5 and 20'
        MaxLength = 4
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = edtFlowChange
        OnExit = edtFlowExit
        OnKeyPress = edtFlowKeyPress
        OnKeyUp = edtFlowKeyUp
      end
      object edtO2Con: TEdit
        Left = 119
        Top = 37
        Width = 98
        Height = 21
        Hint = 'Enter value between 21 and 100'
        MaxLength = 3
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnChange = edtO2ConChange
        OnExit = edtO2ConExit
        OnKeyPress = edtO2ConKeyPress
        OnKeyUp = edtO2ConKeyUp
      end
      object udFlow: TUpDown
        Left = 224
        Top = 13
        Width = 16
        Height = 21
        Max = 20
        TabOrder = 1
        OnChangingEx = udFlowChangingEx
      end
      object udO2: TUpDown
        Left = 224
        Top = 37
        Width = 16
        Height = 21
        Min = -80
        TabOrder = 3
        OnChangingEx = udO2ChangingEx
      end
    end
    object Panel2: TPanel
      Left = 3
      Top = 3
      Width = 248
      Height = 22
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvNone
      Caption = 'Supplemental Oxygen'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object pnlQual: TPanel
      Left = 3
      Top = 113
      Width = 248
      Height = 2
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
    end
    object Panel5: TPanel
      Left = 3
      Top = 86
      Width = 248
      Height = 27
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object lblMethodValue: TLabel
        Left = 8
        Top = 6
        Width = 36
        Height = 13
        Caption = '&Method'
        FocusControl = cbMethod
      end
      object cbMethod: TComboBox
        Left = 119
        Top = 1
        Width = 122
        Height = 21
        Hint = 'Select Method from the list'
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = cbMethodChange
      end
    end
  end
end
