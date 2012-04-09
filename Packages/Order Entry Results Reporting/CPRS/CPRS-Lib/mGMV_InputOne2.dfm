object fraGMV_InputOne2: TfraGMV_InputOne2
  Left = 0
  Top = 0
  Width = 854
  Height = 25
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 854
    Height = 25
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlValues: TPanel
      Left = 205
      Top = 0
      Width = 187
      Height = 25
      Align = alLeft
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object lblUnit: TLabel
        Left = 119
        Top = 8
        Width = 29
        Height = 13
        Caption = 'lblUnit'
      end
      object bvMetric: TBevel
        Left = 162
        Top = 4
        Width = 21
        Height = 21
        Shape = bsFrame
        Visible = False
      end
      object cbxInput: TComboBox
        Left = 1
        Top = 1
        Width = 112
        Height = 21
        Hint = 'Enter the appropriate vitals measurement'
        Style = csDropDownList
        DropDownCount = 12
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = cbxInputChange
        OnClick = cbxInputClick
        OnExit = cbxInputExit
        OnKeyDown = cbxInputKeyDown
      end
      object ckbMetric: TCheckBox
        Left = 166
        Top = 6
        Width = 15
        Height = 17
        Hint = 
          'Check to switch display values between English and Metric equiva' +
          'lents'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = ckbMetricClick
        OnEnter = ckbMetricEnter
        OnExit = ckbMetricExit
      end
      object cbxUnits: TComboBox
        Left = 116
        Top = 1
        Width = 69
        Height = 21
        Hint = 'Press to select metric'
        Style = csDropDownList
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Visible = False
        OnChange = acMetricChangedExecute
      end
    end
    object pnlRefusedUnavailable: TPanel
      Left = 0
      Top = 0
      Width = 75
      Height = 25
      Align = alLeft
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object lblNum: TLabel
        Left = 0
        Top = 0
        Width = 24
        Height = 25
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = '#. '
        Layout = tlCenter
      end
      object bvU: TBevel
        Left = 28
        Top = 3
        Width = 21
        Height = 21
        Shape = bsFrame
        Visible = False
      end
      object bvR: TBevel
        Left = 53
        Top = 3
        Width = 21
        Height = 21
        Shape = bsFrame
        Visible = False
      end
      object cbxRefused: TCheckBox
        Left = 54
        Top = 5
        Width = 16
        Height = 17
        Hint = 'Mark as Refused'
        Alignment = taLeftJustify
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = cbxRefusedClick
        OnEnter = cbxRefusedEnter
        OnExit = cbxRefusedExit
        OnMouseUp = cbxRefusedMouseUp
      end
      object cbxUnavailable: TCheckBox
        Left = 32
        Top = 5
        Width = 13
        Height = 17
        Hint = 'Mark as Unavailable'
        Alignment = taLeftJustify
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = cbxUnavailableClick
        OnEnter = cbxUnavailableEnter
        OnExit = cbxUnavailableExit
        OnMouseUp = cbxUnavailableMouseUp
      end
    end
    object pnlQualifiers: TPanel
      Left = 392
      Top = 0
      Width = 462
      Height = 25
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      object lblQualifiers: TLabel
        Left = 28
        Top = 5
        Width = 53
        Height = 13
        Hint = 'Current qualifiers to be filed with this vital measurement'
        Caption = 'lblQualifiers'
        ParentShowHint = False
        ShowHint = True
      end
      object bvQual: TBevel
        Left = 2
        Top = 3
        Width = 23
        Height = 21
        Shape = bsFrame
        Visible = False
      end
      object bbtnQualifiers: TBitBtn
        Left = 5
        Top = 5
        Width = 17
        Height = 16
        Hint = 'Press to display the qualifier selection screen'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = bbtnQualifiersClick
        OnEnter = bbtnQualifiersEnter
        OnExit = bbtnQualifiersExit
        Glyph.Data = {
          7E040000424D7E0400000000000036040000280000000B000000060000000100
          08000000000048000000C40E0000C40E00000001000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A6000020400000206000002080000020A0000020C0000020E000004000000040
          20000040400000406000004080000040A0000040C0000040E000006000000060
          20000060400000606000006080000060A0000060C0000060E000008000000080
          20000080400000806000008080000080A0000080C0000080E00000A0000000A0
          200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
          200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
          200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
          20004000400040006000400080004000A0004000C0004000E000402000004020
          20004020400040206000402080004020A0004020C0004020E000404000004040
          20004040400040406000404080004040A0004040C0004040E000406000004060
          20004060400040606000406080004060A0004060C0004060E000408000004080
          20004080400040806000408080004080A0004080C0004080E00040A0000040A0
          200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
          200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
          200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
          20008000400080006000800080008000A0008000C0008000E000802000008020
          20008020400080206000802080008020A0008020C0008020E000804000008040
          20008040400080406000804080008040A0008040C0008040E000806000008060
          20008060400080606000806080008060A0008060C0008060E000808000008080
          20008080400080806000808080008080A0008080C0008080E00080A0000080A0
          200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
          200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
          200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
          2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
          2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
          2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
          2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
          2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
          2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
          2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FAFAFAFAFA00
          FAFAFAFAFA00FAFAFAFA000000FAFAFAFA00FAFAFA0000000000FAFAFA00FAFA
          00000000000000FAFA00FA000000000000000000FA0000000000000000000000
          0000}
      end
    end
    object pnlName: TPanel
      Left = 75
      Top = 0
      Width = 130
      Height = 25
      Align = alLeft
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      object lblVital: TLabel
        Left = 0
        Top = 0
        Width = 113
        Height = 25
        Hint = 'Display name of the vitals measurement'
        Align = alLeft
        AutoSize = False
        Caption = 'lblVital'
        ParentShowHint = False
        ShowHint = True
        Layout = tlCenter
      end
    end
  end
end
