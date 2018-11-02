object frmGMV_Qualifiers: TfrmGMV_Qualifiers
  Left = 674
  Top = 291
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 204
  ClientWidth = 313
  Color = clBtnFace
  Constraints.MinWidth = 127
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 313
    Height = 204
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 1
    Caption = 'Panel2'
    TabOrder = 0
    object Panel1: TPanel
      Left = 3
      Top = 172
      Width = 307
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        307
        29)
      object btnOK: TButton
        Left = 150
        Top = 5
        Width = 75
        Height = 20
        Caption = '&OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 224
        Top = 5
        Width = 73
        Height = 20
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
    object pnlMain: TPanel
      Left = 3
      Top = 25
      Width = 307
      Height = 147
      Align = alClient
      BorderWidth = 1
      TabOrder = 1
      object pnlBottom: TPanel
        Left = 2
        Top = 120
        Width = 303
        Height = 25
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        OnResize = pnlBottomResize
        DesignSize = (
          303
          25)
        object Label1: TLabel
          Left = 8
          Top = 3
          Width = 42
          Height = 13
          Caption = 'Selected'
          FocusControl = edtQuals
        end
        object edtQuals: TEdit
          Left = 80
          Top = 0
          Width = 218
          Height = 19
          Anchors = [akLeft, akTop, akRight]
          Color = clBtnFace
          Ctl3D = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 0
          Text = 'edtQuals'
        end
      end
      object sb: TScrollBox
        Left = 2
        Top = 2
        Width = 303
        Height = 110
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
      end
      object Panel4: TPanel
        Left = 2
        Top = 112
        Width = 303
        Height = 8
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Bevel1: TBevel
          Left = 0
          Top = 0
          Width = 303
          Height = 8
          Align = alClient
          Shape = bsTopLine
          Style = bsRaised
        end
      end
    end
    object pnlTitle: TPanel
      Left = 3
      Top = 3
      Width = 307
      Height = 22
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvNone
      Caption = 'Qualifiers'
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
  end
end
