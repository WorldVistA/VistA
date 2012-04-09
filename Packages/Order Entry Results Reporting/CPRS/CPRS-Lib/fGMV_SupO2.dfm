object frmGMV_SupO2: TfrmGMV_SupO2
  Left = 815
  Top = 181
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'frmGMV_SupO2'
  ClientHeight = 193
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 313
    Height = 193
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 1
    TabOrder = 0
    object pnlBottom: TPanel
      Left = 3
      Top = 142
      Width = 307
      Height = 48
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 0
      DesignSize = (
        307
        48)
      object btnOK: TButton
        Left = 146
        Top = 12
        Width = 73
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'O&K'
        ModalResult = 1
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 223
        Top = 12
        Width = 70
        Height = 25
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
    object Panel1: TPanel
      Left = 3
      Top = 30
      Width = 307
      Height = 74
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lblFlow: TLabel
        Left = 9
        Top = 21
        Width = 63
        Height = 16
        Caption = '&Flow Rate:'
        FocusControl = edtFlow
      end
      object lblO2Con: TLabel
        Left = 9
        Top = 50
        Width = 105
        Height = 16
        Caption = '&O2 Concentration:'
        FocusControl = edtO2Con
      end
      object lblPercent: TLabel
        Left = 117
        Top = 50
        Width = 20
        Height = 16
        Caption = '(%)'
        ParentShowHint = False
        ShowHint = False
      end
      object lblLitMin: TLabel
        Left = 98
        Top = 21
        Width = 38
        Height = 16
        Hint = 'liters/minute'
        Caption = '(l/min)'
        ParentShowHint = False
        ShowHint = True
      end
      object edtFlow: TEdit
        Left = 146
        Top = 16
        Width = 121
        Height = 24
        Hint = 'Enter values between 0.5 and 20'
        MaxLength = 4
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnKeyUp = edtFlowKeyUp
      end
      object edtO2Con: TEdit
        Left = 146
        Top = 46
        Width = 121
        Height = 24
        Hint = 'Enter value between 21 and 100'
        MaxLength = 3
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnKeyUp = edtO2ConKeyUp
      end
      object udFlow: TUpDown
        Left = 271
        Top = 16
        Width = 19
        Height = 26
        Min = -32768
        Max = 32767
        TabOrder = 2
        OnChangingEx = udFlowChangingEx
      end
      object udO2: TUpDown
        Left = 271
        Top = 46
        Width = 19
        Height = 25
        Min = -32768
        Max = 32767
        TabOrder = 3
        OnChangingEx = udO2ChangingEx
      end
    end
    object Panel2: TPanel
      Left = 3
      Top = 3
      Width = 307
      Height = 27
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvNone
      Caption = 'Supplemental Oxygen'
      TabOrder = 2
    end
    object pnlQual: TPanel
      Left = 3
      Top = 138
      Width = 307
      Height = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
    end
    object Panel5: TPanel
      Left = 3
      Top = 104
      Width = 307
      Height = 34
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
      object lblMethodValue: TLabel
        Left = 10
        Top = 7
        Width = 45
        Height = 16
        Caption = '&Method'
        FocusControl = cbMethod
      end
      object cbMethod: TComboBox
        Left = 146
        Top = 1
        Width = 147
        Height = 24
        Hint = 'Select Method from the list'
        Style = csDropDownList
        ItemHeight = 16
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = cbMethodChange
      end
    end
  end
end
