inherited frmBroker: TfrmBroker
  Left = 338
  Top = 235
  BorderIcons = [biSystemMenu]
  Caption = 'Broker Calls'
  ClientHeight = 414
  ClientWidth = 707
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  ExplicitWidth = 723
  ExplicitHeight = 452
  PixelsPerInch = 96
  TextHeight = 13
  object SplDebug: TSplitter [0]
    Left = 179
    Top = 0
    Width = 5
    Height = 414
    Visible = False
    ExplicitLeft = 196
    ExplicitTop = -8
  end
  object PnlDebug: TPanel [1]
    Left = 0
    Top = 0
    Width = 179
    Height = 414
    Align = alLeft
    TabOrder = 0
    Visible = False
    object PnlSearch: TPanel
      Left = 1
      Top = 1
      Width = 177
      Height = 51
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblSearch: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 3
        Width = 169
        Height = 13
        Margins.Left = 5
        Align = alTop
        Caption = 'Search Criteria'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 69
      end
      object pnlSubSearch: TPanel
        Left = 0
        Top = 16
        Width = 177
        Height = 35
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object SearchTerm: TEdit
          AlignWithMargins = True
          Left = 10
          Top = 3
          Width = 89
          Height = 29
          Margins.Left = 10
          Margins.Right = 10
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = SearchTermChange
          OnKeyDown = SearchTermKeyDown
          ExplicitHeight = 21
        end
        object btnSearch: TButton
          AlignWithMargins = True
          Left = 112
          Top = 3
          Width = 55
          Height = 29
          Margins.Right = 10
          Align = alRight
          Caption = 'Search'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnSearchClick
        end
      end
    end
    object PnlDebugResults: TPanel
      Left = 1
      Top = 52
      Width = 177
      Height = 361
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblDebug: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 3
        Width = 169
        Height = 13
        Margins.Left = 5
        Align = alTop
        Caption = 'Search Results'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 72
      end
      object ResultList: TListView
        AlignWithMargins = True
        Left = 10
        Top = 19
        Width = 157
        Height = 332
        Margins.Left = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        Columns = <
          item
            Caption = 'Index'
          end
          item
            Caption = 'RPC Name'
            Width = 200
          end>
        ColumnClick = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
        OnSelectItem = ResultListSelectItem
      end
    end
  end
  object pnlMain: TPanel [2]
    Left = 184
    Top = 0
    Width = 523
    Height = 414
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object memData: TRichEdit
      Left = 0
      Top = 68
      Width = 523
      Height = 346
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HideScrollBars = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WantReturns = False
    end
    object pnlTop: TORAutoPanel
      Left = 0
      Top = 0
      Width = 523
      Height = 68
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 523
        Height = 68
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        object lblMaxCalls: TLabel
          Left = 8
          Top = 8
          Width = 91
          Height = 13
          Caption = 'Max Calls Retained'
        end
        object btnFlag: TBitBtn
          Left = 283
          Top = 10
          Width = 55
          Height = 37
          Hint = 'Mark any additional RPCs as flaged'
          Caption = 'Flag'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7E7E7EFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF7E7E7EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7E7E7EFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF7E7E7EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF474747A9A9A9A3A3A376
            76763939390E0E0E010101181818FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF000000000000000000000000000000000000000000000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
            0000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF000000000000000000000000000000000000000000000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
            0000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF3939391616161010102828285A5A5A8888889696967E7E7EFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          Layout = blGlyphTop
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Spacing = 0
          TabOrder = 0
          OnClick = btnFlagClick
        end
        object btnRLT: TBitBtn
          Left = 222
          Top = 10
          Width = 55
          Height = 37
          Hint = 'Displays the time it takes an RPC to run at this moment'
          Caption = 'Real Time'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFD2D2D26F6F6F2929290707070707072A2A2A707070D4D4D4FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6A6A6A02020200000000000000
            00000000000000000000000202026D6D6DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            4646460000000000000000000000000000000000000000000000000000000000
            00474747FFFFFFFFFFFFFFFFFF6F6F6F00000000000000000000000000000000
            0000000000000000000000000000000000000000737373FFFFFFD4D4D4020202
            0000000000000000000000000000000000000000001414145E5E5E0000000000
            00000000030303D6D6D66E6E6E00000000000000000000000000000000000000
            0000272727DCDCDCFFFFFF040404000000000000000000717171292929000000
            0000000000000000000000000000003F3F3FFFFFFFFFFFFF3333330000000000
            000000000000002B2B2B0B0B0B0000000000000000000000000000002E2E2EFF
            FFFFFFFFFF5252520000000000000000000000000000000D0D0D0D0D0D000000
            000000000000000000000000595959FFFFFFACACAC0000000000000000000000
            000000000000000E0E0E2929290000000000000000000000000000004B4B4BFF
            FFFF7979790000000000000000000000000000000000002C2C2C6C6C6C000000
            0000000000000000000000003C3C3CFFFFFF6A6A6A0000000000000000000000
            000000000000006F6F6FD2D2D20101010000000000000000000000002D2D2DFF
            FFFF5B5B5B000000000000000000000000000000020202D4D4D4FFFFFF666666
            0000000000000000000000001C1C1CFFFFFF4A4A4A0000000000000000000000
            00000000696969FFFFFFFFFFFFFFFFFF44444400000000000000000000000042
            4242060606000000000000000000000000464646FFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF6A6A6A0202020000000000000000000000000000000000000202026D6D
            6DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD2D2D26F6F6F2A2A2A13
            13131313132B2B2B707070D4D4D4FFFFFFFFFFFFFFFFFFFFFFFF}
          Layout = blGlyphTop
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Spacing = 0
          TabOrder = 1
          OnClick = btnRLTClick
        end
        object cmdNext: TBitBtn
          Left = 466
          Top = 10
          Width = 55
          Height = 37
          Hint = 'Moves to the next rpc in the list'
          Caption = 'Next'
          Glyph.Data = {
            36010000424D360100000000000076000000280000001E0000000C0000000100
            040000000000C000000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777778877
            777777777778877777007777777F00877777777777F7787777007777777F0008
            7777777777F77787770078888887000087778888887777787700F00000000000
            087F7777777777778700F00000000000008F7777777777777800F00000000000
            007F7777777777777700F00000000000077F7777777777777700FFFFFFFF0000
            777FFFFFFFF7777777007777777F00077777777777F7777777007777777F0077
            7777777777F7777777007777777FF7777777777777FF77777700}
          Layout = blGlyphTop
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = cmdNextClick
        end
        object cmdPrev: TBitBtn
          Left = 405
          Top = 10
          Width = 55
          Height = 37
          Hint = 'Moves to the previous rpc in the list'
          Caption = 'Prev'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Glyph.Data = {
            36010000424D360100000000000076000000280000001E0000000C0000000100
            040000000000C000000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777887777
            7777777778877777770077777008777777777777778777777700777700087777
            7777777777877777770077700008888888877777778888888800770000000000
            0087777777777777780070000000000000877777777777777800F00000000000
            008F7777777777777800FF0000000000008F77777777777778007FF00007FFFF
            FF77FF77777FFFFFF70077FF0008777777777FF7778777777700777FF0087777
            777777FF7787777777007777FFF777777777777FFF7777777700}
          Layout = blGlyphTop
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = cmdPrevClick
        end
        object cmdSearch: TBitBtn
          Left = 344
          Top = 10
          Width = 55
          Height = 37
          Hint = 'Search through the entire rpc list'
          Caption = 'Search'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Glyph.Data = {
            E6010000424DE60100000000000036000000280000000C0000000C0000000100
            180000000000B001000000000000000000000000000000000000FFFFFF9F9F9F
            0F0F0FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F
            9F0000000000000F0F0FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF0F0F0F0000000000000000000F0F0FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFCFCFCF0F0F0F0000000000000000000F0F0F0F0F0F0000000F0F
            0F5F5F5FFFFFFFFFFFFFFFFFFFCFCFCF0F0F0F0000000000000000000F0F0F3F
            3F3F0F0F0F0000000F0F0FFFFFFFFFFFFFFFFFFFCFCFCF0F0F0F0000005F5F5F
            FFFFFFFFFFFFFFFFFF5F5F5F0000005F5F5FFFFFFFFFFFFFFFFFFF0F0F0F0F0F
            0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1F1F000000FFFFFFFFFFFFFFFFFF00
            00003F3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F3F3F000000FFFFFFFFFFFF
            FFFFFF0F0F0F0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F2F2F000000FFFF
            FFFFFFFFFFFFFF5F5F5F0000005F5F5FFFFFFFFFFFFFFFFFFF7F7F7F0000003F
            3F3FFFFFFFFFFFFFFFFFFFFFFFFF0F0F0F0000001F1F1F3F3F3F1F1F1F000000
            0F0F0FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F5F0000000000000000
            003F3F3FCFCFCFFFFFFF}
          Layout = blGlyphTop
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = cmdSearchClick
        end
        object lblCallID: TStaticText
          Left = 110
          Top = 24
          Width = 90
          Height = 17
          Alignment = taCenter
          Caption = 'Last Broker Call -0'
          TabOrder = 5
        end
        object txtMaxCalls: TCaptionEdit
          Left = 8
          Top = 24
          Width = 81
          Height = 21
          TabOrder = 6
          Text = '10'
          Caption = 'Max Calls Retained'
        end
        object udMax: TUpDown
          Left = 89
          Top = 24
          Width = 15
          Height = 21
          Associate = txtMaxCalls
          Min = 1
          Position = 10
          TabOrder = 7
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lblCallID'
        'Status = stsDefault')
      (
        'Component = txtMaxCalls'
        'Status = stsDefault')
      (
        'Component = cmdPrev'
        'Status = stsDefault')
      (
        'Component = cmdNext'
        'Status = stsDefault')
      (
        'Component = udMax'
        'Status = stsDefault')
      (
        'Component = memData'
        'Status = stsDefault')
      (
        'Component = frmBroker'
        'Status = stsDefault')
      (
        'Component = btnFlag'
        'Status = stsDefault')
      (
        'Component = btnRLT'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = PnlDebug'
        'Status = stsDefault')
      (
        'Component = PnlSearch'
        'Status = stsDefault')
      (
        'Component = pnlSubSearch'
        'Status = stsDefault')
      (
        'Component = SearchTerm'
        'Status = stsDefault')
      (
        'Component = btnSearch'
        'Status = stsDefault')
      (
        'Component = PnlDebugResults'
        'Status = stsDefault')
      (
        'Component = ResultList'
        'Status = stsDefault')
      (
        'Component = ScrollBox1'
        'Status = stsDefault'))
  end
end
