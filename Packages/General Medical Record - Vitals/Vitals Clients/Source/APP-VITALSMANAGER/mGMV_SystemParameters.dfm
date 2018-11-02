object fraSystemParameters: TfraSystemParameters
  Left = 0
  Top = 0
  Width = 303
  Height = 320
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 303
    Height = 320
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object pnlBottom: TPanel
      Left = 1
      Top = 94
      Width = 301
      Height = 225
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'pnlBottom'
      TabOrder = 1
      object Label1: TLabel
        Left = 1
        Top = 1
        Width = 299
        Height = 20
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = '&Version Compatibility:'
        FocusControl = clbxVersions
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 1
        Top = 186
        Width = 299
        Height = 38
        Align = alBottom
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Place a check mark next to all versions that are compatible with' +
          ' the current server version.'
        Layout = tlCenter
        WordWrap = True
      end
      object clbxVersions: TCheckListBox
        Left = 1
        Top = 21
        Width = 299
        Height = 165
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object pnlMain: TPanel
      Left = 1
      Top = 21
      Width = 301
      Height = 73
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = pnlMainResize
      DesignSize = (
        301
        73)
      object Label2: TLabel
        Left = 4
        Top = 32
        Width = 121
        Height = 13
        Caption = 'Help Menu &Web Address:'
        FocusControl = edtWebLink
      end
      object edtWebLink: TEdit
        Left = 4
        Top = 48
        Width = 291
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        Text = 'edtWebLink'
      end
      object cbxAllowUserTemplates: TCheckBox
        Left = 4
        Top = 8
        Width = 157
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Allow &User Templates:'
        TabOrder = 0
      end
    end
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 301
      Height = 20
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'System Parameters'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      ExplicitLeft = 2
      ExplicitTop = 3
    end
  end
end
