inherited frmIconLegend: TfrmIconLegend
  Left = 294
  Top = 224
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Icon Legend'
  ClientHeight = 317
  ClientWidth = 366
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  ExplicitWidth = 372
  ExplicitHeight = 349
  PixelsPerInch = 96
  TextHeight = 13
  object pcMain: TPageControl [0]
    Left = 0
    Top = 0
    Width = 366
    Height = 293
    ActivePage = Templates
    Align = alClient
    TabOrder = 0
    object Templates: TTabSheet
      Caption = 'Templates'
      ImageIndex = 1
      object Label3: TLabel
        Left = 0
        Top = 251
        Width = 336
        Height = 13
        Alignment = taCenter
        Caption = 
          '* Indicates template has been excluded from its parent group boi' +
          'lerplate'
      end
      inline fraImgText12: TfraImgText
        Left = 0
        Top = 0
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ExplicitWidth = 358
        inherited img: TImage
          Left = 28
          Width = 30
          Picture.Data = {
            07544269746D617076010000424D760100000000000076000000280000001E00
            0000100000000100040000000000000100000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00000000000888888880000000008888000000000080888888800000000808
            880080BBBBB008088888880BBBBB0080880080B000B030808888880B000B0308
            080080BBBBB0330088880000000B0330080080BBBBB0330888880BBBBB000330
            880080000000330888880B000B080330880080BBBBB0330888880BBBBB080330
            880080B000B0330888880BBBBB000330880080BBBBB033088888000000070330
            880080BBBBB033088888880FFF77033088000000000003088888800000000030
            880007777777000888888077777770008800800B3B3B3008888888003B3B3B00
            8800888003B3B3008888888800B3B3B008008888700000008888888887000000
            0800}
          ExplicitLeft = 28
          ExplicitWidth = 30
        end
        inherited lblText: TLabel
          Left = 64
          Width = 164
          Caption = 'Shared or Personal Template Root'
          ExplicitLeft = 64
          ExplicitWidth = 164
        end
      end
      object Panel1: TPanel
        Left = 173
        Top = 60
        Width = 184
        Height = 189
        TabOrder = 1
        object Label2: TLabel
          Left = 1
          Top = 1
          Width = 182
          Height = 20
          Align = alTop
          Alignment = taCenter
          AutoSize = False
          Caption = 'Personal Template Icons'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        inline fraImgText8: TfraImgText
          Left = 1
          Top = 161
          Width = 182
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 161
          ExplicitWidth = 182
          inherited img: TImage
            Left = 14
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00DDDDDDDD0000000DD778D7703BBBBB30DDD7778088888880DD7788F08708
              8080DD78878080008880D7F8F87088808080D7F7888088888880D78F88F04CCC
              CC40DD7FF7880000000DDD77FF8788877DDD77777FFFFF77777D7F8877777778
              887D78F8887778F8887DD78FF7D7D78FF7DDDD777DD7DD777DDDDDDDDD777DDD
              DDDD}
            Transparent = True
            ExplicitLeft = 14
          end
          inherited lblText: TLabel
            Left = 46
            Width = 121
            Caption = 'Personal Reminder Dialog'
            ExplicitLeft = 46
            ExplicitWidth = 121
          end
        end
        inline fraImgText10: TfraImgText
          Left = 1
          Top = 21
          Width = 182
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 21
          ExplicitWidth = 182
          inherited img: TImage
            Left = 14
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00555555555555555555500000000005555550FFFFFFFF05555550F0000FFF
              05555550FFFFFFFF05555550F000000F05555550FFFFFFFF05555550F000000F
              05555550FFFFFFFF05555550F000FFFF05555550FFFFF00005555550F00FF0F0
              55555550FFFFF005555555500000005555555555555555555555555555555555
              5555}
            Transparent = True
            ExplicitLeft = 14
          end
          inherited lblText: TLabel
            Left = 46
            Width = 88
            Caption = 'Personal Template'
            ExplicitLeft = 46
            ExplicitWidth = 88
          end
        end
        inline fraImgText15: TfraImgText
          Left = 1
          Top = 81
          Width = 182
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 81
          ExplicitWidth = 182
          inherited img: TImage
            Width = 36
            Picture.Data = {
              07544269746D6170B6010000424DB60100000000000076000000280000002400
              0000100000000100040000000000400100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00D0000000000DDDDDDDDDD0000000000DDDDD00000BFBFBFBFB0DDDDDDDDD
              00B8B8B8B8B0000000000FBFBFBFBF000000DDDD0B0B8B8B8B8B0FF000000BFB
              FBFBFB0FFFF0DDDD0FB0B8B8B8B8B0F000000FBFBFBFBF0000F0DDDD0BF00000
              000000F000000BFBFBFBFB0FFFF0DDDD0FB0F0F0FFFFFFF000000FBFBFBFBF00
              00F0DDDD0BF0F0F0F00000F000000000000000FFFFF0DDDD0FB0F0F0FFFFFFF0
              0000D0F0F0F0F00000F0DDDDD0F0F0F0F00000F00000D700F0F0FFFFFFF0DDDD
              D700F0F0FFFFFFF00000DDD0F0F0F00F0000DDDDDDD0F0F0F00F00000000DDD0
              F0F0FFFF0F0DDDDDDDD0F0F0FFFF0F0D0000DDD0F0F0FFFF00DDDDDDDDD0F0F0
              FFFF00DD0000DDD0F0F000000DDDDDDDDDD0F0F000000DDD0000DDD0F000000D
              DDDDDDDDDDD0F000000DDDDD0000DDD000000DDDDDDDDDDDDDD000000DDDDDDD
              0000}
            Transparent = True
            ExplicitWidth = 36
          end
          inherited lblText: TLabel
            Left = 46
            Width = 120
            Caption = 'Personal Group Template'
            ExplicitLeft = 46
            ExplicitWidth = 120
          end
        end
        inline fraImgText16: TfraImgText
          Left = 1
          Top = 101
          Width = 182
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 101
          ExplicitWidth = 182
          inherited img: TImage
            Width = 36
            Picture.Data = {
              07544269746D6170B6010000424DB60100000000000076000000280000002400
              0000100000000100040000000000400100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00D0000000000DDDDDDDDDD0000000000DDDDD00000BFBFBFBFB0DDDDDDDDD
              00B8B8B8B8B0000000000FBFBFBFBF000000DDDD0B0B8B8B8B8B088000000BFB
              FBFBFB088880DDDD0FB0B8B8B8B8B08000000FBFBFBFBF000080DDDD0BF00000
              0000008000000BFBFBFBFB088880DDDD0FB080808888888000000FBFBFBFBF00
              0080DDDD0BF080808000008000000000000000888880DDDD0FB0808088888880
              0000D0F0808080000080DDDDD0F08080800000800000D700808088888880DDDD
              D7008080888888800000DDD0808080080000DDDDDDD08080800800000000DDD0
              80808888080DDDDDDDD080808888080D0000DDD08080888800DDDDDDDDD08080
              888800DD0000DDD0808000000DDDDDDDDDD0808000000DDD0000DDD08000000D
              DDDDDDDDDDD08000000DDDDD0000DDD000000DDDDDDDDDDDDDD000000DDDDDDD
              0000}
            Transparent = True
            ExplicitWidth = 36
          end
          inherited lblText: TLabel
            Left = 46
            Width = 129
            Caption = 'Personal Group Template *'
            ExplicitLeft = 46
            ExplicitWidth = 129
          end
        end
        inline fraImgText17: TfraImgText
          Left = 1
          Top = 61
          Width = 182
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 61
          ExplicitWidth = 182
          inherited img: TImage
            Left = 7
            Width = 30
            Picture.Data = {
              07544269746D617076010000424D760100000000000076000000280000001E00
              0000100000000100040000000000000100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDD
              DD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00D0000000000DDDDD0000000000DD
              DD000BFBFBFBFB0DDDD00B8B8B8B8B0DDD000FBFBFBFBF0DDDD0F0B8B8B8B8B0
              DD000BFBFBFBFB0DDDD0BF0B8B8B8B8B0D000FBFBFBFBF0DDDD0FBF000000000
              0D000BFBFBFBFB0DDDD0BFBFBFBFB0DDDD000FBFBFBFBF0DDDD0FBFBFBFBF0DD
              DD000000000000DDDDD0BFBFBF000DDDDD00D0FBFB0DDDDDDDDD0BFBF0DDDDDD
              DD00D700007DDDDDDDDD700007DDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDD
              DD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDD
              DD00}
            Transparent = True
            ExplicitLeft = 7
            ExplicitWidth = 30
          end
          inherited lblText: TLabel
            Left = 46
            Width = 121
            Caption = 'Personal Template Folder'
            ExplicitLeft = 46
            ExplicitWidth = 121
          end
        end
        inline fraImgText13: TfraImgText
          Left = 1
          Top = 121
          Width = 182
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 121
          ExplicitWidth = 182
          inherited img: TImage
            Width = 36
            Picture.Data = {
              07544269746D6170B6010000424DB60100000000000076000000280000002400
              0000100000000100040000000000400100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00D0000000000DDDDDDDDDD0000000000DDDDD00000BFBFBFBFB0DDDDDDDDD
              00B8B8B8B8B0DDDD00000FBFBFBFBF0DDDDDDDDD0B0B8B8B8B8B0DDD00000BFB
              FBFBFB00000DDDDD0FB0B8B8B8B8B00D00000FBFBFBFBF088870DDDD0BF00000
              0000007000000BFBFBFBFB088880DDDD0FB088888888888000000FBFBFBFBF08
              0080DDDD0BF087088080008000000000000000888880DDDD0FB0800088888880
              0000D0F0888888800880DDDDD0F08880800008800000D700888888888880DDDD
              D7008888888888800000DDD0870880080080DDDDDDD08708800800800000DDD0
              800088888880DDDDDDD08000888888800000DDD0888080800080DDDDDDD08880
              808000800000DDD0888888888880DDDDDDD08888888888800000DDD04CCCCCCC
              CC40DDDDDDD04CCCCCCCCC400000DDDD00000000000DDDDDDDDD00000000000D
              0000}
            Transparent = True
            ExplicitWidth = 36
          end
          inherited lblText: TLabel
            Left = 46
            Width = 120
            Caption = 'Personal Template Dialog'
            ExplicitLeft = 46
            ExplicitWidth = 120
          end
        end
        inline fraImgText14: TfraImgText
          Left = 1
          Top = 141
          Width = 182
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 141
          ExplicitWidth = 182
          inherited img: TImage
            Width = 36
            Picture.Data = {
              07544269746D6170B6010000424DB60100000000000076000000280000002400
              0000100000000100040000000000400100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00D0000000000DDDDDDDDDD0000000000DDDDD00000BFBFBFBFB0DDDDDDDDD
              00B8B8B8B8B0DDDD00000FBFBFBFBF0DDDDDDDDD0B0B8B8B8B8B0DDD00000BFB
              FBFBFB00000DDDDD0FB0B8B8B8B8B00D00000FBFBFBFBF077770DDDD0BF00000
              0000007000000BFBFBFBFB077770DDDD0FB077777777777000000FBFBFBFBF07
              0070DDDD0BF077077070007000000000000000777770DDDD0FB0700077777770
              0000D0F0777777700770DDDDD0F07770700007700000D700777777777770DDDD
              D7007777777777700000DDD0770770070070DDDDDDD07707700700700000DDD0
              700077777770DDDDDDD07000777777700000DDD0777070700070DDDDDDD07770
              707000700000DDD0777777777770DDDDDDD07777777777700000DDD044444444
              4440DDDDDDD04444444444400000DDDD00000000000DDDDDDDDD00000000000D
              0000}
            Transparent = True
            ExplicitWidth = 36
          end
          inherited lblText: TLabel
            Left = 46
            Width = 129
            Caption = 'Personal Template Dialog *'
            ExplicitLeft = 46
            ExplicitWidth = 129
          end
        end
        inline fraImgText23: TfraImgText
          Left = 1
          Top = 41
          Width = 182
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 41
          ExplicitWidth = 182
          inherited img: TImage
            Left = 14
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00555555555555555555500000000005555550888888880555555080000888
              0555555088888888055555508000000805555550888888880555555080000008
              0555555088888888055555508000888805555550888880000555555080088080
              5555555088888005555555500000005555555555555555555555555555555555
              5555}
            Transparent = True
            ExplicitLeft = 14
          end
          inherited lblText: TLabel
            Left = 46
            Width = 97
            Caption = 'Personal Template *'
            ExplicitLeft = 46
            ExplicitWidth = 97
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 60
        Width = 173
        Height = 189
        TabOrder = 2
        object Label1: TLabel
          Left = 1
          Top = 1
          Width = 171
          Height = 20
          Align = alTop
          Alignment = taCenter
          AutoSize = False
          Caption = 'Shared Template Icons'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        inline fraImgText22: TfraImgText
          Left = 1
          Top = 141
          Width = 171
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 141
          ExplicitWidth = 171
          inherited img: TImage
            Width = 36
            Picture.Data = {
              07544269746D6170B6010000424DB60100000000000076000000280000002400
              0000100000000100040000000000400100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00D0000000000DDDDDDDDDD0000000000DDDDD00000BFBFBFBFB0DDDDDDDDD
              00B8B8B8B8B0DDDD00000FBFBFBFBF0DDDDDDDDD0B0B8B8B8B8B0DDD00000BFB
              FBFBFB000000DDDD0FB0B8B8B8B8B00000000FBFBFBFBF077770DDDD0BF00000
              0000007000000BFBFBFBFB077770DDDD0FB077777777777000000FBFBFBFBF07
              0070DDDD0BF077077070007000000000000000777770DDDD0FB0700077777770
              0000D0F0777777700770DDDDD0F07770700007700000D700777777777770DDDD
              D7007777777777700000DDD0770770070070DDDDDDD07707700700700000DDD0
              700077777770DDDDDDD07000777777700000DDD0777070700070DDDDDDD07770
              707000700000DDD0777777777770DDDDDDD07777777777700000DDD044444444
              4440DDDDDDD04444444444400000DDD0000000000000DDDDDDD0000000000000
              0000}
            Transparent = True
            ExplicitWidth = 36
          end
          inherited lblText: TLabel
            Left = 46
            Width = 122
            Caption = 'Shared Template Dialog *'
            ExplicitLeft = 46
            ExplicitWidth = 122
          end
        end
        inline fraImgText20: TfraImgText
          Left = 1
          Top = 61
          Width = 171
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 61
          ExplicitWidth = 171
          inherited img: TImage
            Left = 7
            Width = 30
            Picture.Data = {
              07544269746D617076010000424D760100000000000076000000280000001E00
              0000100000000100040000000000000100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDD
              DD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD0000000000000DDDD00000000000DD
              DD000BFBFBFBFB0DDDD00B8B8B8B8B0DDD000FBFBFBFBF0DDDD0F0B8B8B8B8B0
              DD000BFBFBFBFB0DDDD0BF0B8B8B8B8B0D000FBFBFBFBF0DDDD0FBF000000000
              00000BFBFBFBFB0DDDD0BFBFBFBFB0DDDD000FBFBFBFBF0DDDD0FBFBFBFBF0DD
              DD0000000000000DDDD00FBFB00000DDDD00D0FBFB0DDDDDDDDD0BFBF0DDDDDD
              DD00D000000DDDDDDDDD000000DDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDD
              DD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDD
              DD00}
            Transparent = True
            ExplicitLeft = 7
            ExplicitWidth = 30
          end
          inherited lblText: TLabel
            Left = 46
            Width = 114
            Caption = 'Shared Template Folder'
            ExplicitLeft = 46
            ExplicitWidth = 114
          end
        end
        inline fraImgText19: TfraImgText
          Left = 1
          Top = 101
          Width = 171
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 101
          ExplicitWidth = 171
          inherited img: TImage
            Width = 36
            Picture.Data = {
              07544269746D6170B6010000424DB60100000000000076000000280000002400
              0000100000000100040000000000400100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00D0000000000DDDDDDDDDD0000000000DDDDD00000BFBFBFBFB0DDDDDDDDD
              00B8B8B8B8B0000000000FBFBFBFBF000000DDDD0B0B8B8B8B8B088000000BFB
              FBFBFB088880DDDD0FB0B8B8B8B8B08000000FBFBFBFBF000080DDDD0BF00000
              0000008000000BFBFBFBFB088880DDDD0FB080808888888000000FBFBFBFBF00
              0080DDDD0BF080808000008000000000000000888880DDDD0FB0808088888880
              0000D0F0808080000080DDDDD0F08080800000800000D700808088888880DDDD
              D7008080888888800000DDD0808080080080DDDDDDD08080800800800000DDD0
              808088888880DDDDDDD08080888888800000DDD0808088888880DDDDDDD08080
              888888800000DDD0808000000000DDDDDDD08080000000000000DDD080000000
              00DDDDDDDDD08000000000DD0000DDD000000000DDDDDDDDDDD000000000DDDD
              0000}
            Transparent = True
            ExplicitWidth = 36
          end
          inherited lblText: TLabel
            Left = 46
            Width = 122
            Caption = 'Shared Group Template *'
            ExplicitLeft = 46
            ExplicitWidth = 122
          end
        end
        inline fraImgText18: TfraImgText
          Left = 1
          Top = 81
          Width = 171
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 81
          ExplicitWidth = 171
          inherited img: TImage
            Width = 36
            Picture.Data = {
              07544269746D6170B6010000424DB60100000000000076000000280000002400
              0000100000000100040000000000400100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00D0000000000DDDDDDDDDD0000000000DDDDD00000BFBFBFBFB0DDDDDDDDD
              00B8B8B8B8B0000000000FBFBFBFBF000000DDDD0B0B8B8B8B8B0FF000000BFB
              FBFBFB0FFFF0DDDD0FB0B8B8B8B8B0F000000FBFBFBFBF0000F0DDDD0BF00000
              000000F000000BFBFBFBFB0FFFF0DDDD0FB0F0F0FFFFFFF000000FBFBFBFBF00
              00F0DDDD0BF0F0F0F00000F000000000000000FFFFF0DDDD0FB0F0F0FFFFFFF0
              0000D0F0F0F0F00000F0DDDDD0F0F0F0F00000F00000D700F0F0FFFFFFF0DDDD
              D700F0F0FFFFFFF00000DDD0F0F0F00F00F0DDDDDDD0F0F0F00F00F00000DDD0
              F0F0FFFFFFF0DDDDDDD0F0F0FFFFFFF00000DDD0F0F0FFFFFFF0DDDDDDD0F0F0
              FFFFFFF00000DDD0F0F000000000DDDDDDD0F0F0000000000000DDD0F0000000
              00DDDDDDDDD0F000000000DD0000DDD000000000DDDDDDDDDDD000000000DDDD
              0000}
            Transparent = True
            ExplicitWidth = 36
          end
          inherited lblText: TLabel
            Left = 46
            Width = 113
            Caption = 'Shared Group Template'
            ExplicitLeft = 46
            ExplicitWidth = 113
          end
        end
        inline fraImgText21: TfraImgText
          Left = 1
          Top = 121
          Width = 171
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 121
          ExplicitWidth = 171
          inherited img: TImage
            Width = 36
            Picture.Data = {
              07544269746D6170B6010000424DB60100000000000076000000280000002400
              0000100000000100040000000000400100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00D0000000000DDDDDDDDDD0000000000DDDDD00000BFBFBFBFB0DDDDDDDDD
              00B8B8B8B8B0DDDD00000FBFBFBFBF0DDDDDDDDD0B0B8B8B8B8B0DDD00000BFB
              FBFBFB000000DDDD0FB0B8B8B8B8B00000000FBFBFBFBF088880DDDD0BF00000
              0000008000000BFBFBFBFB088880DDDD0FB088888888888000000FBFBFBFBF08
              0080DDDD0BF087088080008000000000000000888880DDDD0FB0800088888880
              0000D0F0888888800880DDDDD0F08880800008800000D700888888888880DDDD
              D7008888888888800000DDD0870880080080DDDDDDD08708800800800000DDD0
              800088888880DDDDDDD08000888888800000DDD0888080800080DDDDDDD08880
              808000800000DDD0888888888880DDDDDDD08888888888800000DDD0CCCCCCCC
              CCC0DDDDDDD0CCCCCCCCCCC00000DDD0000000000000DDDDDDD0000000000000
              0000}
            Transparent = True
            ExplicitWidth = 36
          end
          inherited lblText: TLabel
            Left = 46
            Width = 113
            Caption = 'Shared Template Dialog'
            ExplicitLeft = 46
            ExplicitWidth = 113
          end
        end
        inline fraImgText11: TfraImgText
          Left = 1
          Top = 21
          Width = 171
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 21
          ExplicitWidth = 171
          inherited img: TImage
            Left = 14
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00555555555555555555500000000005555550FFFFFFFF05555550F0000FFF
              05555550FFFFFFFF05555550F000000F05555550FFFFFFFF05555550F000000F
              05555550FFFFFFFF05555550F000F00F05555550FFFFFFFF05555550F00F000F
              05555550FFFFFFFF055555500000000005555555555555555555555555555555
              5555}
            Transparent = True
            ExplicitLeft = 14
          end
          inherited lblText: TLabel
            Left = 46
            Width = 81
            Caption = 'Shared Template'
            ExplicitLeft = 46
            ExplicitWidth = 81
          end
        end
        inline fraImgText9: TfraImgText
          Left = 1
          Top = 161
          Width = 171
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 161
          ExplicitWidth = 171
          inherited img: TImage
            Left = 14
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00DDDDDDD000000000D778D770BBBBBBB0DDD7778088888880DD7788F08708
              8080DD78878080008880D7F8F87088808080D7F7888088888880D78F88F0CCCC
              CCC0DD7FF78000000000DD77FF8788877DDD77777FFFFF77777D7F8877777778
              887D78F8887778F8887DD78FF7D7D78FF7DDDD777DD7DD777DDDDDDDDD777DDD
              DDDD}
            Transparent = True
            ExplicitLeft = 14
          end
          inherited lblText: TLabel
            Left = 46
            Width = 114
            Caption = 'Shared Reminder Dialog'
            ExplicitLeft = 46
            ExplicitWidth = 114
          end
        end
        inline fraImgText24: TfraImgText
          Left = 1
          Top = 41
          Width = 171
          Height = 20
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 41
          ExplicitWidth = 171
          inherited img: TImage
            Left = 14
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00555555555555555555500000000005555550888888880555555080000888
              0555555088888888055555508000000805555550888888880555555080000008
              0555555088888888055555508000800805555550888888880555555080080008
              0555555088888888055555500000000005555555555555555555555555555555
              5555}
            Transparent = True
            ExplicitLeft = 14
          end
          inherited lblText: TLabel
            Left = 46
            Width = 90
            Caption = 'Shared Template *'
            ExplicitLeft = 46
            ExplicitWidth = 90
          end
        end
      end
      inline fraImgText56: TfraImgText
        Left = 0
        Top = 20
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        TabStop = True
        ExplicitTop = 20
        ExplicitWidth = 358
        inherited img: TImage
          Left = 35
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00555555555555555555555555555555555000000000000005578888888888
            8805578FFFFFFFFFF805578F81FF5855F805578F191FFCC8F805578F9B1FFECC
            F805578FF91FFCFFF805578FFFFFFFFFF8055788888888888805578444444000
            0805578444444F0F080557888888888888055777777777777705555555555555
            5555}
          Transparent = True
          ExplicitLeft = 35
        end
        inherited lblText: TLabel
          Left = 64
          Width = 293
          Caption = 'COM Object Template (external application linked into CPRS) '
          ExplicitLeft = 64
          ExplicitWidth = 293
        end
      end
      inline fraImgText57: TfraImgText
        Left = 0
        Top = 40
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        TabStop = True
        ExplicitTop = 40
        ExplicitWidth = 358
        inherited img: TImage
          Left = 35
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00555555555555555555555555555555555000009999000005578899999999
            880557899FFFFFF99805579999FF585599055799F99FFCC89905599F9F99FECC
            F995599FF9F99FFFF995599FFFFF99FFF99557998888F9989905579944444F99
            9905578994444FF9980557889999999988055777779999777705555555555555
            5555}
          Transparent = True
          ExplicitLeft = 35
        end
        inherited lblText: TLabel
          Left = 64
          Width = 240
          Caption = 'COM Object Template not installed on workstation'
          ExplicitLeft = 64
          ExplicitWidth = 240
        end
      end
    end
    object Reminders: TTabSheet
      Caption = 'Reminders'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      inline fraImgText1: TfraImgText
        Left = 0
        Top = 8
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ExplicitTop = 8
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 47
          Width = 30
          Picture.Data = {
            07544269746D617076010000424D760100000000000076000000280000001E00
            0000100000000100040000000000000100000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00888888888888888888888888888888008888888888888888888888888888
            8800888888888888888888888888888888008000000000088888000000000088
            88000BFBFBFBFB0888800B8B8B8B8B0888000FBFBFBFBF088880F0B8B8B8B8B0
            88000BFBFBFBFB088880BF0B8B8B8B8B08000FBFBFBFBF088880FBF000000000
            08000BFBFBFBFB088880BFBFBFBFB08888000FBFBFBFBF088880FBFBFBFBF088
            88000000000000888880BFBFBF000888880080FBFB08888888880BFBF0888888
            8800870000788888888870000788888888008888888888888888888888888888
            8800888888888888888888888888888888008888888888888888888888888888
            8800}
          ExplicitLeft = 47
          ExplicitWidth = 30
        end
        inherited lblText: TLabel
          Left = 118
          Width = 93
          Caption = 'Reminder Category'
          ExplicitLeft = 118
          ExplicitWidth = 93
        end
      end
      inline fraImgText2: TfraImgText
        Left = 0
        Top = 34
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
        ExplicitTop = 34
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 52
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF0080018000008100888810009090001888880098F0F8900888870980FFF089
            07888099FFFFFFF990888090F000FF009088B099FFF0FFF990B8070980F0F089
            0708BB0098F0F8900BB800000999990000080887000000087708088887707888
            8708B078800B008870B808700BBBBB007808880BB0B0B0BB088880BB08B0B80B
            B088}
          ExplicitLeft = 52
        end
        inherited lblText: TLabel
          Left = 118
          Width = 77
          Caption = 'Reminder is Due'
          ExplicitLeft = 118
          ExplicitWidth = 77
        end
      end
      inline fraImgText3: TfraImgText
        Left = 0
        Top = 60
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = True
        ExplicitTop = 60
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 52
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF008006800000860088886000E0E00068888800E8F0F8E00888870E80FFF08E
            078880EEFF0FFFFEE08880E0FFF0FF00E08880EEFFF0FFFEE088870E80F0F08E
            07888800E8F0F8E0088800000EEEEE0000080887000000087708088887707888
            8708807880707088708888700880880078888888880008888888888888888888
            8888}
          ExplicitLeft = 52
        end
        inherited lblText: TLabel
          Left = 118
          Width = 179
          Caption = 'Reminder is not due, but is Applicable'
          ExplicitLeft = 118
          ExplicitWidth = 179
        end
      end
      inline fraImgText4: TfraImgText
        Left = 0
        Top = 86
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        TabStop = True
        ExplicitTop = 86
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 52
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF0088888000008888888880077777008888880778FFF87708888077FFFCFFF7
            7088807FCFFFFFCF7088078FFFFFFFFF870807FFFFFFFFFFF70807F00009FFFC
            F70807FFFFFF0FFFF708078FFFFFF0FF8708807FCFFFFFFF70888077FFFCFFF7
            7088880778FCF877088888800777770088888888800000888888888888888888
            8888}
          ExplicitLeft = 52
        end
        inherited lblText: TLabel
          Left = 118
          Width = 126
          Caption = 'Reminder is Not Applicable'
          ExplicitLeft = 118
          ExplicitWidth = 126
        end
      end
      inline fraImgText5: TfraImgText
        Left = 0
        Top = 112
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        TabStop = True
        ExplicitTop = 112
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 52
          Width = 20
          Picture.Data = {
            07544269746D617036010000424D360100000000000076000000280000001400
            0000100000000100040000000000C00000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00FFFFFF000FFFFFFFFFFF0000FFFFF06660FFFFFFFFFF0000FFFFF06660FF
            FFFFFFFF0000FFFFFF000FFFFFFFFFFF0000FFFFF06660FFFFFFFFFF0000FFFF
            F06660FFFFFFFFFF0000FFFFF066660FFFFFFFFF0000FFFFFF066660FFFFFFFF
            0000FFFFFFF066660FFFFFFF0000FFF000FF06660FFFFFFF0000FF0666000666
            0FFFFFFF0000FF06666666660FFFFFFF0000FF06666666660FFFFFFF0000FFF0
            06666600FFFFFFFF0000FFFFF00000FFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            0000}
          Transparent = True
          ExplicitLeft = 52
          ExplicitWidth = 20
        end
        inherited lblText: TLabel
          Left = 118
          Width = 214
          Caption = 'Reminder status has not yet been evaluated'
          ExplicitLeft = 118
          ExplicitWidth = 214
        end
      end
      inline fraImgText6: TfraImgText
        Left = 0
        Top = 138
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        TabStop = True
        ExplicitTop = 138
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 20
          Width = 86
          Picture.Data = {
            07544269746D617036030000424D360300000000000076000000280000005600
            0000100000000100040000000000C00200000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00800180000000000008888880068000000000000888888888800000000000
            08888888888800000000000888008810009090BBBBBB088888886000E0E0BBBB
            BB0888888880077770BBBBBB0888888888806660BBBBBB088800880098F0F077
            77770888888800E8F0F0777777088888880778FFF07777770888888888806660
            777777088800870980FFF0888888088888870E80FFF08888880888888077FFFC
            F088888808888888888800008888880888008099FFFFF080800808888880EEFF
            0FF0808008088888807FCFFFF080800808888888888066608080080888008090
            F000F088888808888880E0FFF0F0888888088888078FFFFFF088888808888888
            88806660888888088800B099FFF0F044444408888880EEFFF0F0444444088888
            07FFFFFFF04444440888888888806660444444088800070980F0F00000000888
            88870E80F0F000000008888807F00009F0000000088888888888066000000008
            8800BB0098F0F8900BB88888888800E8F0F8E0088888888807FFFFFF0FFFF708
            8888888888888066660888888800000009999900000888888800000EEEEE0000
            08888888078FFFFFF0FF87088888888880008806660888888800088700000008
            77088888880887000000087708888888807FCFFFFFFF70888888888806660006
            660888888800088887707888870888888808888770788887088888888077FFFC
            FFF770888888888806666666660888888800B078800B008870B8888888807880
            7070887088888888880778FCF877088888888888066666666608888888000870
            0BBBBB0078088888888870088088007888888888888007777700888888888888
            80066666008888888800880BB0B0B0BB08888888888888880008888888888888
            8888800000888888888888888880000088888888880080BB08B0B80BB0888888
            8888888888888888888888888888888888888888888888888888888888888888
            8800}
          ExplicitLeft = 20
          ExplicitWidth = 86
        end
        inherited lblText: TLabel
          Left = 118
          Width = 214
          Caption = 'Reminder has an associated Reminder Dialog'
          ExplicitLeft = 118
          ExplicitWidth = 214
        end
      end
      inline fraImgText7: TfraImgText
        Left = 0
        Top = 164
        Width = 358
        Height = 40
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        TabStop = True
        ExplicitTop = 164
        ExplicitWidth = 358
        ExplicitHeight = 40
        inherited img: TImage
          Left = 20
          Top = 8
          Width = 86
          Picture.Data = {
            07544269746D617036030000424D360300000000000076000000280000005600
            0000100000000100040000000000C00200000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00800180000000000008888880068000000000000888888888800000000000
            08888888888800000000000888008810009090BBFFBB088888886000E0E0BBFF
            BB0888888880077770BBFFBB0888888888806660BBFFBB088800880098F0F07F
            90F70888888800E8F0F07F90F7088888880778FFF07F90F70888888888806660
            7F90F7088800870980FFF08F990F088888870E80FFF08F990F0888888077FFFC
            F08F990F08888888888800008F990F0888008099FFFFF0F9990F08888880EEFF
            0FF0F9990F088888807FCFFFF0F9990F0888888888806660F9990F0888008090
            F000FF799990F8888880E0FFF0FF799990F88888078FFFFFFF799990F8888888
            8880666F799990F88800B099FFF0F7990990F8888880EEFFF0F7990990F88888
            07FFFFFFF7990990F8888888888066F7990990F88800070980FF990FF7990F88
            88870E80FF990FF7990F888807F0000F990FF7990F88888888880F990FF7990F
            8800BB0098F0FFF00F990F88888800E8F0FFF00F990F888807FFFFFFFFFFFF99
            0F888888888880FFF60F990F880000000999990000F990F88800000EEEEE0000
            F990F888078FFFFFF0FF87F990F88888800088066608F990F800088700000008
            77F790F88808870000000877F790F888807FCFFFFFFF70F790F8888806660006
            6608F790F800088887707888870F790F88088887707888870F790F888077FFFC
            FFF7708F790F88880666666666088F790F00B078800B008870B8F79088807880
            7070887088F79088880778FCF8770888F790888806666666660888F790000870
            0BBBBB0078088FFF8888700880880078888FFF8888800777770088888FFF8888
            800666660088888FFF00880BB0B0B0BB08888888888888880008888888888888
            8888800000888888888888888880000088888888880080BB08B0B80BB0888888
            8888888888888888888888888888888888888888888888888888888888888888
            8800}
          ExplicitLeft = 20
          ExplicitTop = 8
          ExplicitWidth = 86
        end
        inherited lblText: TLabel
          Left = 118
          Width = 209
          Height = 26
          Caption = 'Reminder'#39's associated Reminder Dialog has been processed'
          WordWrap = True
          ExplicitLeft = 118
          ExplicitWidth = 209
          ExplicitHeight = 26
        end
      end
    end
    object Notes: TTabSheet
      Caption = 'Notes'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      inline fraImgText25: TfraImgText
        Left = 0
        Top = 40
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ExplicitTop = 40
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00555555555555555555500000000005555550FFFFFFFF05555550F0000FFF
            05555550FFFFFFFF05555550F000000F05555550FFFFFFFF05555550F000000F
            05555550FFFFFFFF05555550F000F00F05555550FFFFFFFF05555550F00F000F
            05555550FFFFFFFF055555500000000005555555555555555555555555555555
            5555}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 80
          Caption = 'Standalone Note'
          ExplicitLeft = 150
          ExplicitWidth = 80
        end
      end
      inline fraImgText26: TfraImgText
        Left = 0
        Top = 60
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
        ExplicitTop = 60
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00555555555555555555500000000005555550FFFFFFFF05555550FFFFFFFF
            05555550FFFFFFFF05555550FFFFFFFF05555550FFF0FFFF05555550FFF0FFFF
            05555550F00000FF05555550FFF0FFFF05555550FFF0FFFF05555550FFFFFFFF
            05555550FFFFFFFF055555500000000005555555555555555555555555555555
            5555}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 51
          Caption = 'Addendum'
          ExplicitLeft = 150
          ExplicitWidth = 51
        end
      end
      inline fraImgText27: TfraImgText
        Left = 0
        Top = 80
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = True
        ExplicitTop = 80
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D617042020000424D420200000000000042000000280000001000
            0000100000000100100003000000000200000000000000000000000000000000
            0000007C0000E00300001F0000001F7C1F7C1F7C1F7C1F7C1F7C000000000000
            00000000000000000000000000001F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000FF7F0000
            000000000000FF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7F0000
            00000000000000000000FF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7F0000
            00000000000000000000FF7F00000000FF7FFF7F0000FF7FFF7F0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7F0000FF7FFF7F0000FF7F0000
            00000000FF7F00000000FF7F00000000000000000000000000000000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7F0000FF7FFF7F0000FF7F0000
            0000FF7F000000000000FF7F00000000FF7FFF7F0000FF7FFF7F0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F000000000000
            00000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F0000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000000000000000000000000000000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 147
          Caption = 'Standalone note with addenda'
          ExplicitLeft = 150
          ExplicitWidth = 147
        end
      end
      inline fraImgText28: TfraImgText
        Left = 0
        Top = 100
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        TabStop = True
        ExplicitTop = 100
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Width = 30
          Picture.Data = {
            07544269746D617076010000424D760100000000000076000000280000001E00
            0000100000000100040000000000000100000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00888888888888888888888888888888008888888888888888888888888888
            8800888888888888888888888888888888008000000000088888000000000088
            88000BFBFBFBFB0888800B8B8B8B8B0888000FBFBFBFBF088880F0B8B8B8B8B0
            88000BFBFBFBFB088880BF0B8B8B8B8B08000FBFBFBFBF088880FBF000000000
            08000BFBFBFBFB088880BFBFBFBFB08888000FBFBFBFBF088880FBFBFBFBF088
            88000000000000888880BFBFBF000888880080FBFB08888888880BFBF0888888
            8800870000788888888870000788888888008888888888888888888888888888
            8800888888888888888888888888888888008888888888888888888888888888
            8800}
          ExplicitLeft = 74
          ExplicitWidth = 30
        end
        inherited lblText: TLabel
          Left = 150
          Width = 102
          Caption = 'Interdisciplinary Note'
          ExplicitLeft = 150
          ExplicitWidth = 102
        end
      end
      inline fraImgText29: TfraImgText
        Left = 0
        Top = 120
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        TabStop = True
        ExplicitTop = 120
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Width = 32
          Picture.Data = {
            07544269746D617076010000424D760100000000000076000000280000002000
            0000100000000100040000000000000100000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
            DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD0000000000DDDDDDDDDDDDDDD
            DDDDDD0BFBF0FBFB0DDDDD0000000000DDDDDD0FBFB0BFBF0DDDD00B8B8B0B8B
            0DDDDD0BF00000FB0DDDD0F0B8B00008B0DDDD0FBFB0BFBF0DDDD0BF0B8B808B
            8B0DDD0BFBF0FBFB0DDDD0FB00000000000DDD0FBFBFBFBF0DDDD0BFBFBFBFB0
            DDDDDD0000000000DDDDD0FBFBFBFBF0DDDDDDD0FBFB0DDDDDDDD0BFBFB8000D
            DDDDDDD700007DDDDDDDDD0B8BF0DDDDDDDDDDDDDDDDDDDDDDDDDD700007DDDD
            DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
            DDDD}
          Transparent = True
          ExplicitLeft = 74
          ExplicitWidth = 32
        end
        inherited lblText: TLabel
          Left = 150
          Width = 170
          Caption = 'Interdisciplinary Note with addenda'
          ExplicitLeft = 150
          ExplicitWidth = 170
        end
      end
      inline fraImgText30: TfraImgText
        Left = 0
        Top = 140
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        TabStop = True
        ExplicitTop = 140
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D617042020000424D420200000000000042000000280000001000
            0000100000000100100003000000000200000000000000000000000000000000
            0000007C0000E00300001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000000000000000000
            00000000000000001F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7F00001F7C1F7C1F7C1F7C1F7C1F7C0000FF7F0000000000000000
            FF7FFF7FFF7F00001F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7F00001F7C1F7C1F7C1F7C1F7C1F7C0000FF7F0000000000000000
            00000000FF7F00001F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7F00001F7C1F7C1F7C1F7C1F7C1F7C0000FF7F0000000000000000
            00000000FF7F00001F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7F00001F7C1F7C1F7C1F7C1F7C1F7C0000FF7F000000000000FF7F
            FF7FFF7FFF7F00001F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7FFF7FFF7FFF7F
            00000000000000001F7C1F7C1F7C1F7C1F7C1F7C0000FF7F00000000FF7FFF7F
            0000FF7F00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7FFF7FFF7FFF7F
            000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000000000000000000
            00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 105
          Caption = 'Interdisciplinary entry'
          ExplicitLeft = 150
          ExplicitWidth = 105
        end
      end
      inline fraImgText31: TfraImgText
        Left = 0
        Top = 160
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        TabStop = True
        ExplicitTop = 160
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            000010000000010018000000000000030000C40E0000C40E0000000000000000
            0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000
            000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
            0000000000000000000000000000000000000000000000FFFFFF000000000000
            000000000000FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
            0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000000000
            000000000000000000000000FFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
            0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000000000
            000000000000000000000000FFFFFF000000000000FFFFFFFFFFFF000000FFFF
            FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
            0000000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFF000000000000
            000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000
            00000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
            0000000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFF000000000000
            FFFFFFFFFFFF000000FFFFFF000000FF00FF000000FFFFFFFFFFFF000000FFFF
            FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FF00FFFF
            00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000
            000000000000000000FF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FF000000000000000000000000000000000000000000000000000000FF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FF}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 173
          Caption = 'Interdisciplinary entry with addenda'
          ExplicitLeft = 150
          ExplicitWidth = 173
        end
      end
      inline fraImgText32: TfraImgText
        Left = 0
        Top = 180
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        TabStop = True
        ExplicitTop = 180
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Top = 1
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7000000000FFFFFF7CCCCCCCC
            0FFFFFF7CCCCCCCC0FFFFFF7CCCCCC220FFFFFF7EFEF22220FFFFFF7FEFEFE22
            0FFFFFF7E88FEFEF0FFFFFF78FB8FEFE0FFFFFF78BF8EFEF0FFFFFF7F88EFEFE
            0FFFFFF7EFEFEFEF0FFFFFF7777777777FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          Transparent = True
          ExplicitLeft = 74
          ExplicitTop = 1
        end
        inherited lblText: TLabel
          Left = 150
          Top = 3
          Width = 133
          Caption = 'Note has attached image(s)'
          ExplicitLeft = 150
          ExplicitTop = 3
          ExplicitWidth = 133
        end
      end
      inline fraImgText33: TfraImgText
        Left = 0
        Top = 0
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        TabStop = True
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D617042020000424D420200000000000042000000280000001000
            0000100000000100100003000000000200000000000000000000000000000000
            0000007C0000E00300001F0000001F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C00000000000000000000
            1F7C000000001F7C000000001F7C1F7C0000000000000000E07FE07FE07F0000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C0000E07FE07F00000000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C000000001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C00000000000000000000
            1F7C000000001F7C000000001F7C1F7C0000000000000000E07FE07FE07F0000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C0000E07FE07F00000000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C000000001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000000000000001F7C000000001F7C
            0000000000001F7C1F7C1F7C1F7C0000E07FE07FE07F00001F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000E07FE07F000000001F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000001F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Top = 5
          Width = 88
          Caption = 'Top level grouping'
          ExplicitLeft = 150
          ExplicitTop = 5
          ExplicitWidth = 88
        end
      end
      inline fraImgText34: TfraImgText
        Left = 0
        Top = 20
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        TabStop = True
        ExplicitTop = 20
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Top = 1
          Width = 30
          Picture.Data = {
            07544269746D617076010000424D760100000000000076000000280000001E00
            0000100000000100040000000000000100000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00000000000888888880000000008888000000000080888888800000000808
            880080BBBBB008088888880BBBBB0080880080B000B030808888880B000B0308
            080080BBBBB0330088880000000B0330080080BBBBB0330888880BBBBB000330
            880080000000330888880B000B080330880080BBBBB0330888880BBBBB080330
            880080B000B0330888880BBBBB000330880080BBBBB033088888000000070330
            880080BBBBB033088888880FFF77033088000000000003088888800000000030
            880007777777000888888077777770008800800B3B3B3008888888003B3B3B00
            8800888003B3B3008888888800B3B3B008008888700000008888888887000000
            0800}
          ExplicitLeft = 74
          ExplicitTop = 1
          ExplicitWidth = 30
        end
        inherited lblText: TLabel
          Left = 150
          Width = 103
          Caption = 'Selected subgrouping'
          ExplicitLeft = 150
          ExplicitWidth = 103
        end
      end
      inline fraImgText53: TfraImgText
        Left = 0
        Top = 220
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
        TabStop = True
        ExplicitTop = 220
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Top = 1
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000FFFFFF997777777
            0FFFFFF9997777770FFFFFF0997777880FFFFFF0999F88880FFFFFF0F9999888
            0FFFFFF08889988F0FFFFFF08F8999F80FFFFFF088F8999F0FFFFFF0F888F999
            0FFFFFF08F8F8F890FFFFFF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          Transparent = True
          ExplicitLeft = 74
          ExplicitTop = 1
        end
        inherited lblText: TLabel
          Left = 150
          Top = 3
          Width = 154
          Caption = 'Note'#39's images cannot be viewed'
          ExplicitLeft = 150
          ExplicitTop = 3
          ExplicitWidth = 154
        end
      end
      inline fraImgText54: TfraImgText
        Left = 0
        Top = 200
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
        TabStop = True
        ExplicitTop = 200
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Top = 1
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7000000000FFFFFF7CCCCCCCC
            0FFFFFF7CCCCCCCCFFFFFFF7CFFFFFFF0FFFFFF7E000000000FFFFF7F0000000
            00FFFFF7EFFFFFFF0FFFFFF78FBEFEFEFFFFFFF78BF8EFEF0FFFFFF7F88EFEFE
            0FFFFFF7EFEFEFEF0FFFFFF7777777777FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          Transparent = True
          ExplicitLeft = 74
          ExplicitTop = 1
        end
        inherited lblText: TLabel
          Left = 150
          Top = 3
          Width = 156
          Caption = 'Note'#39's child has attached images'
          WordWrap = True
          ExplicitLeft = 150
          ExplicitTop = 3
          ExplicitWidth = 156
        end
      end
    end
    object Consults: TTabSheet
      Caption = 'Consults'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 178
        Height = 265
        Align = alLeft
        TabOrder = 0
        object Label4: TLabel
          Left = 1
          Top = 1
          Width = 101
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'Consults treeview'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        inline fraImgText35: TfraImgText
          Left = 1
          Top = 14
          Width = 176
          Height = 22
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 14
          ExplicitWidth = 176
          ExplicitHeight = 22
          inherited img: TImage
            Left = 5
            Picture.Data = {
              07544269746D617042020000424D420200000000000042000000280000001000
              0000100000000100100003000000000200000000000000000000000000000000
              0000007C0000E00300001F0000001F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C00000000000000000000
              1F7C000000001F7C000000001F7C1F7C0000000000000000E07FE07FE07F0000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C0000E07FE07F00000000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C000000001F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C00000000000000000000
              1F7C000000001F7C000000001F7C1F7C0000000000000000E07FE07FE07F0000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C0000E07FE07F00000000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C000000001F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000000000000001F7C000000001F7C
              0000000000001F7C1F7C1F7C1F7C0000E07FE07FE07F00001F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000E07FE07F000000001F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000001F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
            Transparent = True
            ExplicitLeft = 5
          end
          inherited lblText: TLabel
            Left = 50
            Top = 5
            Width = 88
            Caption = 'Top level grouping'
            ExplicitLeft = 50
            ExplicitTop = 5
            ExplicitWidth = 88
          end
        end
        inline fraImgText36: TfraImgText
          Left = 1
          Top = 36
          Width = 176
          Height = 22
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 36
          ExplicitWidth = 176
          ExplicitHeight = 22
          inherited img: TImage
            Left = 5
            Top = 1
            Width = 30
            Picture.Data = {
              07544269746D617076010000424D760100000000000076000000280000001E00
              0000100000000100040000000000000100000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00000000000888888880000000008888000000000080888888800000000808
              880080BBBBB008088888880BBBBB0080880080B000B030808888880B000B0308
              080080BBBBB0330088880000000B0330080080BBBBB0330888880BBBBB000330
              880080000000330888880B000B080330880080BBBBB0330888880BBBBB080330
              880080B000B0330888880BBBBB000330880080BBBBB033088888000000070330
              880080BBBBB033088888880FFF77033088000000000003088888800000000030
              880007777777000888888077777770008800800B3B3B3008888888003B3B3B00
              8800888003B3B3008888888800B3B3B008008888700000008888888887000000
              0800}
            ExplicitLeft = 5
            ExplicitTop = 1
            ExplicitWidth = 30
          end
          inherited lblText: TLabel
            Left = 50
            Width = 103
            Caption = 'Selected subgrouping'
            ExplicitLeft = 50
            ExplicitWidth = 103
          end
        end
        inline fraImgText43: TfraImgText
          Left = 1
          Top = 102
          Width = 176
          Height = 36
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 102
          ExplicitWidth = 176
          ExplicitHeight = 36
          inherited img: TImage
            Left = 5
            Picture.Data = {
              07544269746D617036030000424D360300000000000036000000280000001000
              000010000000010018000000000000030000120B0000120B0000000000000000
              0000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
              000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFF
              FFFFFFFFFF000000FFFFFF000000FFFFFFFFFF006A240A6A240A6A240A6A240A
              6A240A6A240AFFFFFF000000FFFFFFFFFFFFFFFFFF000000FFFFFF000000FFFF
              FFFFFFFF6A240A6A240A6A240A6A240A6A240A6A240AFFFFFF000000FFFFFFFF
              FFFFFFFFFF000000FFFFFF000000FFFFFFFFFF00FFFF00FFFF006A240A6A240A
              FFFF00FFFF00FFFFFF000000FFFFFFFFFFFFFFFFFF000000FFFFFF000000FFFF
              FFFFFFFF7F7F7F7F7F7F6A240A6A240AFFFFFFFFFFFFFFFFFF000000FFFFFFFF
              FFFFFFFFFF000000FFFFFF000000FFFFFFFFFF00FFFF00FFFF006A240A6A240A
              FFFF00FFFF00FFFFFF000000FFFFFFFFFFFFFFFFFF000000FFFFFF000000FFFF
              FFFFFFFF7F7F7FFFFFFF6A240A6A240A7F7F7FFFFFFFFFFFFF000000FFFFFFFF
              FFFFFFFFFF000000FFFFFF000000FFFFFFFFFF006A240A6A240A6A240A6A240A
              6A240A6A240AFFFFFF000000FFFFFFFFFFFFFFFFFF000000FFFFFF000000FFFF
              FFFFFFFF6A240A6A240A6A240A6A240A6A240A6A240AFFFFFF000000FFFFFFFF
              FFFFFFFFFF000000FFFFFF000000FFFFFFFFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFFFF000000FFFFFFFFFFFFFFFFFF000000FFFFFF000000FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFF
              FFFFFFFFFF000000FFFFFF000000000000FFFFFF000000FFFFFF000000FFFFFF
              000000FFFFFF000000000000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF0000
              007F7F7F0000007F7F7F0000007F7F7F0000007F7F7F000000FFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF000000FFFFFF0000007F7F7F0000007F7F7F0000007F7F7F
              0000007F7F7F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
              FF000000FFFFFF000000FFFFFF000000FFFFFF000000FFFFFFFFFFFFFFFFFFFF
              FFFF}
            Transparent = True
            ExplicitLeft = 5
          end
          inherited lblText: TLabel
            Left = 50
            Top = 5
            Width = 76
            Height = 26
            Caption = 'Interfacility Consult request'
            WordWrap = True
            ExplicitLeft = 50
            ExplicitTop = 5
            ExplicitWidth = 76
            ExplicitHeight = 26
          end
        end
        inline fraImgText44: TfraImgText
          Left = 1
          Top = 138
          Width = 176
          Height = 35
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 138
          ExplicitWidth = 176
          ExplicitHeight = 35
          inherited img: TImage
            Left = 5
            Picture.Data = {
              07544269746D617036030000424D360300000000000036000000280000001000
              000010000000010018000000000000030000120B0000120B0000000000000000
              0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
              6A240A6A240A6A240A6A240A6A240A6A240AFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFF000000FFFFFFFFFFFF6A240A6A240A6A240A6A240A6A240A6A
              240AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
              FFFFFFFFFFFF6A240A6A240AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF0000000000FF800000FFFFFFFFFFFFFFFFFF6A240A6A240AFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808000800080808080FFFFFF
              FFFFFFFFFFFF6A240A6A240AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF000000FFC0C0C0FFFFFFFFFFFFFFFFFF6A240A6A240AFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0000080808080FFFFFF
              6A240A6A240A6A240A6A240A6A240A6A240AFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF808080FFFFFFC0C0C0FFFFFFFFFFFF6A240A6A240A6A240A6A240A6A240A6A
              240AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000800000808000FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF000000FFFFFFC0C0C0FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF808080808000808000C0C0C0C0C0C0C0C0C0800000
              808000C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080008080008080008080
              00808000808000C0C0C0808000808000808000808000808000808000FFFFFFFF
              FFFF808080808000808000808000808000808000800000C0C0C0808000808000
              808000808000808000808000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
              00808000FFFFFF808000FFFFFF808000808000FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF}
            Transparent = True
            ExplicitLeft = 5
          end
          inherited lblText: TLabel
            Left = 50
            Top = 5
            Width = 58
            Height = 39
            Caption = 'Interfacility Procedure request'
            WordWrap = True
            ExplicitLeft = 50
            ExplicitTop = 5
            ExplicitWidth = 58
            ExplicitHeight = 39
          end
        end
        inline fraImgText60: TfraImgText
          Left = 1
          Top = 58
          Width = 176
          Height = 22
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 58
          ExplicitWidth = 176
          ExplicitHeight = 22
          inherited img: TImage
            Left = 5
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF0055550000000005555500FFFFFFFFF05550F0FEEEEEEEF05550F0FFFFFFFF
              F05550F0FEEEEEEEF05550F0FF777FFFF05550F0FEEEEEEEF05550F0FF7F777F
              F05550F0FEEEEEEEF05550F0FF77F7FFF05550F0FEEEEEEEF05550F0FFFFFFFF
              F05550F00F0F0F0F005550550707070705555505070707070555555050505050
              5555}
            Transparent = True
            ExplicitLeft = 5
          end
          inherited lblText: TLabel
            Left = 50
            Top = 5
            Width = 76
            Caption = 'Consult request'
            ExplicitLeft = 50
            ExplicitTop = 5
            ExplicitWidth = 76
          end
        end
        inline fraImgText61: TfraImgText
          Left = 1
          Top = 80
          Width = 176
          Height = 22
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 80
          ExplicitWidth = 176
          ExplicitHeight = 22
          inherited img: TImage
            Left = 5
            Picture.Data = {
              07544269746D617036050000424D360500000000000036040000280000001000
              0000100000000100080000000000000100000000000000000000000100000000
              000000000000000080000080000000808000800000008000800080800000C0C0
              C000C0DCC000F0CAA6000020400000206000002080000020A0000020C0000020
              E00000400000004020000040400000406000004080000040A0000040C0000040
              E00000600000006020000060400000606000006080000060A0000060C0000060
              E00000800000008020000080400000806000008080000080A0000080C0000080
              E00000A0000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0
              E00000C0000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0
              E00000E0000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0
              E00040000000400020004000400040006000400080004000A0004000C0004000
              E00040200000402020004020400040206000402080004020A0004020C0004020
              E00040400000404020004040400040406000404080004040A0004040C0004040
              E00040600000406020004060400040606000406080004060A0004060C0004060
              E00040800000408020004080400040806000408080004080A0004080C0004080
              E00040A0000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0
              E00040C0000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0
              E00040E0000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0
              E00080000000800020008000400080006000800080008000A0008000C0008000
              E00080200000802020008020400080206000802080008020A0008020C0008020
              E00080400000804020008040400080406000804080008040A0008040C0008040
              E00080600000806020008060400080606000806080008060A0008060C0008060
              E00080800000808020008080400080806000808080008080A0008080C0008080
              E00080A0000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0
              E00080C0000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0
              E00080E0000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0
              E000C0000000C0002000C0004000C0006000C0008000C000A000C000C000C000
              E000C0200000C0202000C0204000C0206000C0208000C020A000C020C000C020
              E000C0400000C0402000C0404000C0406000C0408000C040A000C040C000C040
              E000C0600000C0602000C0604000C0606000C0608000C060A000C060C000C060
              E000C0800000C0802000C0804000C0806000C0808000C080A000C080C000C080
              E000C0A00000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0
              E000C0C00000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0
              A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF00F904FFFFFFFF
              FFFFFFFFFFFFFFFFFF0605A4FFFFFFFFFFFFFFFFFFFFFFFFFFFEF907FFFFFFFF
              FFFFFFFFFFFFFFFFFF0701A4FFFFFFFFFFFFFFFFFFFFFFFFA4FF07FFFFFFFFFF
              FFFFFFFFFFFFFFFFFF000406FFFFFFFFFFFFFFFFFFFFFFFF00FF07FF00FFFFFF
              FFFFFFFFFFFFA40606070707040607FFFFFFFFFF060606060606070606060606
              06FFFFA406060606060407060606060606A4FFFFFFFFFF0606FF06FF0606FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF}
            Transparent = True
            ExplicitLeft = 5
          end
          inherited lblText: TLabel
            Left = 50
            Top = 5
            Width = 89
            Caption = 'Procedure request'
            ExplicitLeft = 50
            ExplicitTop = 5
            ExplicitWidth = 89
          end
        end
      end
      object Panel4: TPanel
        Left = 178
        Top = 0
        Width = 180
        Height = 265
        Align = alClient
        TabOrder = 1
        object Label5: TLabel
          Left = 1
          Top = 1
          Width = 116
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'Documents treeview'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        inline fraImgText41: TfraImgText
          Left = 1
          Top = 14
          Width = 178
          Height = 33
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 14
          ExplicitWidth = 178
          ExplicitHeight = 33
          inherited img: TImage
            Left = 5
            Picture.Data = {
              07544269746D617042020000424D420200000000000042000000280000001000
              0000100000000100100003000000000200000000000000000000000000000000
              0000007C0000E00300001F0000001F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C00000000000000000000
              1F7C000000001F7C000000001F7C1F7C0000000000000000E07FE07FE07F0000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C0000E07FE07F00000000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C000000001F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C00000000000000000000
              1F7C000000001F7C000000001F7C1F7C0000000000000000E07FE07FE07F0000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C0000E07FE07F00000000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C000000001F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000000000000001F7C000000001F7C
              0000000000001F7C1F7C1F7C1F7C0000E07FE07FE07F00001F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000E07FE07F000000001F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000001F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
            Transparent = True
            ExplicitLeft = 5
          end
          inherited lblText: TLabel
            Left = 51
            Top = -1
            Width = 100
            Height = 26
            Caption = 'Top level - all related documents'
            WordWrap = True
            ExplicitLeft = 51
            ExplicitTop = -1
            ExplicitWidth = 100
            ExplicitHeight = 26
          end
        end
        inline fraImgText37: TfraImgText
          Left = 1
          Top = 47
          Width = 178
          Height = 22
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 47
          ExplicitWidth = 178
          ExplicitHeight = 22
          inherited img: TImage
            Left = 5
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00555555555555555555500000000005555550FFFFFFFF05555550F0000FFF
              05555550FFFFFFFF05555550F000000F05555550FFFFFFFF05555550F000000F
              05555550FFFFFFFF05555550F000F00F05555550FFFFFFFF05555550F00F000F
              05555550FFFFFFFF055555500000000005555555555555555555555555555555
              5555}
            Transparent = True
            ExplicitLeft = 5
          end
          inherited lblText: TLabel
            Left = 51
            Width = 48
            Caption = 'Document'
            ExplicitLeft = 51
            ExplicitWidth = 48
          end
        end
        inline fraImgText38: TfraImgText
          Left = 1
          Top = 69
          Width = 178
          Height = 22
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 69
          ExplicitWidth = 178
          ExplicitHeight = 22
          inherited img: TImage
            Left = 5
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00555555555555555555500000000005555550FFFFFFFF05555550FFFFFFFF
              05555550FFFFFFFF05555550FFFFFFFF05555550FFF0FFFF05555550FFF0FFFF
              05555550F00000FF05555550FFF0FFFF05555550FFF0FFFF05555550FFFFFFFF
              05555550FFFFFFFF055555500000000005555555555555555555555555555555
              5555}
            Transparent = True
            ExplicitLeft = 5
          end
          inherited lblText: TLabel
            Left = 51
            Width = 51
            Caption = 'Addendum'
            ExplicitLeft = 51
            ExplicitWidth = 51
          end
        end
        inline fraImgText39: TfraImgText
          Left = 1
          Top = 91
          Width = 178
          Height = 22
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 91
          ExplicitWidth = 178
          ExplicitHeight = 22
          inherited img: TImage
            Left = 5
            Picture.Data = {
              07544269746D617042020000424D420200000000000042000000280000001000
              0000100000000100100003000000000200000000000000000000000000000000
              0000007C0000E00300001F0000001F7C1F7C1F7C1F7C1F7C1F7C000000000000
              00000000000000000000000000001F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7F
              FF7FFF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000FF7F0000
              000000000000FF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7FFF7F
              FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7F0000
              00000000000000000000FF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7FFF7F
              FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7F0000
              00000000000000000000FF7F00000000FF7FFF7F0000FF7FFF7F0000FF7FFF7F
              FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7F0000FF7FFF7F0000FF7F0000
              00000000FF7F00000000FF7F00000000000000000000000000000000FF7FFF7F
              FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7F0000FF7FFF7F0000FF7F0000
              0000FF7F000000000000FF7F00000000FF7FFF7F0000FF7FFF7F0000FF7FFF7F
              FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F000000000000
              00000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F0000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000000000000000000000000000000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
            Transparent = True
            ExplicitLeft = 5
          end
          inherited lblText: TLabel
            Left = 51
            Width = 116
            Caption = 'Document with addenda'
            ExplicitLeft = 51
            ExplicitWidth = 116
          end
        end
        inline fraImgText40: TfraImgText
          Left = 1
          Top = 151
          Width = 178
          Height = 35
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 151
          ExplicitWidth = 178
          ExplicitHeight = 35
          inherited img: TImage
            Left = 5
            Top = 1
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7000000000FFFFFF7CCCCCCCC
              0FFFFFF7CCCCCCCCFFFFFFF7CFFFFFFF0FFFFFF7E000000000FFFFF7F0000000
              00FFFFF7EFFFFFFF0FFFFFF78FBEFEFEFFFFFFF78BF8EFEF0FFFFFF7F88EFEFE
              0FFFFFF7EFEFEFEF0FFFFFF7777777777FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF}
            Transparent = True
            ExplicitLeft = 5
            ExplicitTop = 1
          end
          inherited lblText: TLabel
            Left = 51
            Top = 3
            Width = 102
            Height = 26
            Caption = 'Document'#39's child has attached images'
            WordWrap = True
            ExplicitLeft = 51
            ExplicitTop = 3
            ExplicitWidth = 102
            ExplicitHeight = 26
          end
        end
        inline fraImgText52: TfraImgText
          Left = 1
          Top = 113
          Width = 178
          Height = 38
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 113
          ExplicitWidth = 178
          ExplicitHeight = 38
          inherited img: TImage
            Left = 5
            Top = 1
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7000000000FFFFFF7CCCCCCCC
              0FFFFFF7CCCCCCCC0FFFFFF7CCCCCC220FFFFFF7EFEF22220FFFFFF7FEFEFE22
              0FFFFFF7E88FEFEF0FFFFFF78FB8FEFE0FFFFFF78BF8EFEF0FFFFFF7F88EFEFE
              0FFFFFF7EFEFEFEF0FFFFFF7777777777FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF}
            Transparent = True
            ExplicitLeft = 5
            ExplicitTop = 1
          end
          inherited lblText: TLabel
            Left = 51
            Top = 3
            Width = 114
            Height = 26
            Caption = 'Document has attached image(s)'
            WordWrap = True
            ExplicitLeft = 51
            ExplicitTop = 3
            ExplicitWidth = 114
            ExplicitHeight = 26
          end
        end
        inline fraImgText55: TfraImgText
          Left = 1
          Top = 186
          Width = 178
          Height = 34
          Align = alTop
          AutoScroll = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 186
          ExplicitWidth = 178
          ExplicitHeight = 34
          inherited img: TImage
            Left = 5
            Top = 1
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000FFFFFF997777777
              0FFFFFF9997777770FFFFFF0997777880FFFFFF0999F88880FFFFFF0F9999888
              0FFFFFF08889988F0FFFFFF08F8999F80FFFFFF088F8999F0FFFFFF0F888F999
              0FFFFFF08F8F8F890FFFFFF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF}
            Transparent = True
            ExplicitLeft = 5
            ExplicitTop = 1
          end
          inherited lblText: TLabel
            Left = 51
            Top = 1
            Width = 94
            Height = 26
            Caption = 'Document'#39's images cannot be viewed'
            WordWrap = True
            ExplicitLeft = 51
            ExplicitTop = 1
            ExplicitWidth = 94
            ExplicitHeight = 26
          end
        end
      end
    end
    object Surgery: TTabSheet
      Caption = 'Surgery'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      inline fraImgText42: TfraImgText
        Left = 0
        Top = 0
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D617042020000424D420200000000000042000000280000001000
            0000100000000100100003000000000200000000000000000000000000000000
            0000007C0000E00300001F0000001F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C00000000000000000000
            1F7C000000001F7C000000001F7C1F7C0000000000000000E07FE07FE07F0000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C0000E07FE07F00000000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C000000001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C00000000000000000000
            1F7C000000001F7C000000001F7C1F7C0000000000000000E07FE07FE07F0000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C0000E07FE07F00000000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C000000001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000000000000001F7C000000001F7C
            0000000000001F7C1F7C1F7C1F7C0000E07FE07FE07F00001F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000E07FE07F000000001F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000001F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Top = 5
          Width = 88
          Caption = 'Top level grouping'
          ExplicitLeft = 150
          ExplicitTop = 5
          ExplicitWidth = 88
        end
      end
      inline fraImgText45: TfraImgText
        Left = 0
        Top = 22
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
        ExplicitTop = 22
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 74
          Top = 1
          Width = 30
          Picture.Data = {
            07544269746D617076010000424D760100000000000076000000280000001E00
            0000100000000100040000000000000100000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00000000000888888880000000008888000000000080888888800000000808
            880080BBBBB008088888880BBBBB0080880080B000B030808888880B000B0308
            080080BBBBB0330088880000000B0330080080BBBBB0330888880BBBBB000330
            880080000000330888880B000B080330880080BBBBB0330888880BBBBB080330
            880080B000B0330888880BBBBB000330880080BBBBB033088888000000070330
            880080BBBBB033088888880FFF77033088000000000003088888800000000030
            880007777777000888888077777770008800800B3B3B3008888888003B3B3B00
            8800888003B3B3008888888800B3B3B008008888700000008888888887000000
            0800}
          ExplicitLeft = 74
          ExplicitTop = 1
          ExplicitWidth = 30
        end
        inherited lblText: TLabel
          Left = 150
          Width = 103
          Caption = 'Selected subgrouping'
          ExplicitLeft = 150
          ExplicitWidth = 103
        end
      end
      inline fraImgText46: TfraImgText
        Left = 0
        Top = 162
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = True
        ExplicitTop = 162
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00555555555555555555500000000005555550FFFFFFFF05555550F0000FFF
            05555550FFFFFFFF05555550F000000F05555550FFFFFFFF05555550F000000F
            05555550FFFFFFFF05555550F000F00F05555550FFFFFFFF05555550F00F000F
            05555550FFFFFFFF055555500000000005555555555555555555555555555555
            5555}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 33
          Caption = 'Report'
          ExplicitLeft = 150
          ExplicitWidth = 33
        end
      end
      inline fraImgText47: TfraImgText
        Left = 0
        Top = 181
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        TabStop = True
        ExplicitTop = 181
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00555555555555555555500000000005555550FFFFFFFF05555550FFFFFFFF
            05555550FFFFFFFF05555550FFFFFFFF05555550FFF0FFFF05555550FFF0FFFF
            05555550F00000FF05555550FFF0FFFF05555550FFF0FFFF05555550FFFFFFFF
            05555550FFFFFFFF055555500000000005555555555555555555555555555555
            5555}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 51
          Caption = 'Addendum'
          ExplicitLeft = 150
          ExplicitWidth = 51
        end
      end
      inline fraImgText48: TfraImgText
        Left = 0
        Top = 201
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        TabStop = True
        ExplicitTop = 201
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D617042020000424D420200000000000042000000280000001000
            0000100000000100100003000000000200000000000000000000000000000000
            0000007C0000E00300001F0000001F7C1F7C1F7C1F7C1F7C1F7C000000000000
            00000000000000000000000000001F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000FF7F0000
            000000000000FF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7F0000
            00000000000000000000FF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000FF7F0000
            00000000000000000000FF7F00000000FF7FFF7F0000FF7FFF7F0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7F0000FF7FFF7F0000FF7F0000
            00000000FF7F00000000FF7F00000000000000000000000000000000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7F0000FF7FFF7F0000FF7F0000
            0000FF7F000000000000FF7F00000000FF7FFF7F0000FF7FFF7F0000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7FFF7F000000000000
            00000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F0000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000000000000000000000000000000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 101
          Caption = 'Report with addenda'
          ExplicitLeft = 150
          ExplicitWidth = 101
        end
      end
      inline fraImgText49: TfraImgText
        Left = 0
        Top = 237
        Width = 358
        Height = 26
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        TabStop = True
        ExplicitTop = 237
        ExplicitWidth = 358
        ExplicitHeight = 26
        inherited img: TImage
          Left = 74
          Top = 1
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7000000000FFFFFF7CCCCCCCC
            0FFFFFF7CCCCCCCC0FFFFFF7CCCCCC220FFFFFF7EFEF22220FFFFFF7FEFEFE22
            0FFFFFF7E88FEFEF0FFFFFF78FB8FEFE0FFFFFF78BF8EFEF0FFFFFF7F88EFEFE
            0FFFFFF7EFEFEFEF0FFFFFF7777777777FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          Transparent = True
          ExplicitLeft = 74
          ExplicitTop = 1
        end
        inherited lblText: TLabel
          Left = 150
          Top = 3
          Width = 143
          Caption = 'Report has attached image(s)'
          ExplicitLeft = 150
          ExplicitTop = 3
          ExplicitWidth = 143
        end
      end
      inline fraImgText50: TfraImgText
        Left = 0
        Top = 77
        Width = 358
        Height = 20
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        TabStop = True
        ExplicitTop = 77
        ExplicitWidth = 358
        inherited img: TImage
          Left = 74
          Width = 32
          Picture.Data = {
            07544269746D617076010000424D760100000000000076000000280000002000
            0000100000000100040000000000000100000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00500000000000055550000000000555550BFBFBFBFBFB055500B8B8B8B8B0
            00000FBFB0000FBF00000B0B8B8B8B8B0FF00BFB0BFBF0FB0FF00FB0B8B8B8B8
            B0F00FB0BFBFBF0F00F00BF00000000000F00BF0FBFBFB0B0FF00FB0F0FFFFFF
            FFF00FBF0FBFB0BF00F00BF0F0FFF000FFF00BFBF0000BFB0FF00FB0F0FF0FFF
            0FF00FBFBFBFBFBF00F050F0F0F0FFFFF0F00000000000000FF05700F0F0FFFF
            F0F05550F0F0F00F00005550F0F0FFFFF0F05550F0F0FFFF0F055550F0FF0FFF
            0FF05550F0F0FFFF00555550F0FFF000FFF05550F0F0000005555550F0FFFFFF
            FFF05550F000000555555550F000000000005550000005555555555000000555
            5555}
          Transparent = True
          ExplicitLeft = 74
          ExplicitWidth = 32
        end
        inherited lblText: TLabel
          Left = 150
          Width = 147
          Caption = 'OR case with attached reports'
          ExplicitLeft = 150
          ExplicitWidth = 147
        end
      end
      inline fraImgText51: TfraImgText
        Left = 0
        Top = 57
        Width = 358
        Height = 21
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        TabStop = True
        ExplicitTop = 57
        ExplicitWidth = 358
        ExplicitHeight = 21
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF0055555555555555555500000000000005550BFBFBFBFBFB05550FBFB000BF
            BF05550BFB0BFB0BFB05550FB0BFBFB0BF05550BF0FBFBF0FB05550FB0BFBFB0
            BF05550BFB0BFB0BFB05550FBFB000BFBF0555000000000000055550FBFB0555
            5555555000000555555555555555555555555555555555555555555555555555
            5555}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 162
          Caption = 'OR case with no attached reports'
          ExplicitLeft = 150
          ExplicitWidth = 162
        end
      end
      inline fraImgText58: TfraImgText
        Left = 0
        Top = 107
        Width = 358
        Height = 21
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        TabStop = True
        ExplicitTop = 107
        ExplicitWidth = 358
        ExplicitHeight = 21
        inherited img: TImage
          Left = 74
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF0055555555555555555500000000000005550BFBFBFBFBFB05550FB0BFBF00
            BF05550BF0FBF0F0FB05550FB0BF0FB0BF05550BF0F0FBF0FB05550FB00FBFB0
            BF05550BF0FBFBF0FB05550FBFBFBFBFBF0555000000000000055550FBFB0555
            5555555000000555555555555555555555555555555555555555555555555555
            5555}
          Transparent = True
          ExplicitLeft = 74
        end
        inherited lblText: TLabel
          Left = 150
          Width = 186
          Caption = 'Non-OR case without attached reports'
          ExplicitLeft = 150
          ExplicitWidth = 186
        end
      end
      inline fraImgText59: TfraImgText
        Left = 0
        Top = 126
        Width = 358
        Height = 21
        Align = alTop
        AutoScroll = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        TabStop = True
        ExplicitTop = 126
        ExplicitWidth = 358
        ExplicitHeight = 21
        inherited img: TImage
          Left = 74
          Width = 32
          Picture.Data = {
            07544269746D617076010000424D760100000000000076000000280000002000
            0000100000000100040000000000000100000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00500000000000055550000000000555550BFBFBFBFBFB055500B8B8B8B8B0
            00000FBF0FBFB0BF00000B0B8B8B8B8B0FF00BFB0BFB00FB0FF00FB0B8B8B8B8
            B0F00FBF0FB0B0BF00F00BF00000000000F00BFB0B0BF0FB0FF00FB0F0FFFFFF
            FFF00FBF00BFB0BF00F00BF0F0F0FFFFF0F00BFB0BFBF0FB0FF00FB0F0F0FFFF
            00F00FBFBFBFBFBF00F050F0F0F0FFF0F0F00000000000000FF05700F0F0FF0F
            F0F05550F0F0F00F00005550F0F0F0FFF0F05550F0F0FFFF0F055550F0F00FFF
            F0F05550F0F0FFFF00555550F0F0FFFFF0F05550F0F0000005555550F0FFFFFF
            FFF05550F000000555555550F000000000005550000005555555555000000555
            5555}
          Transparent = True
          ExplicitLeft = 74
          ExplicitWidth = 32
        end
        inherited lblText: TLabel
          Left = 150
          Width = 170
          Caption = 'Non-OR case with attached reports'
          ExplicitLeft = 150
          ExplicitWidth = 170
        end
      end
    end
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 293
    Width = 366
    Height = 24
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      366
      24)
    object btnOK: TButton
      Left = 291
      Top = 2
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pcMain'
        'Status = stsDefault')
      (
        'Component = Templates'
        'Status = stsDefault')
      (
        'Component = fraImgText12'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = fraImgText8'
        'Status = stsDefault')
      (
        'Component = fraImgText10'
        'Status = stsDefault')
      (
        'Component = fraImgText15'
        'Status = stsDefault')
      (
        'Component = fraImgText16'
        'Status = stsDefault')
      (
        'Component = fraImgText17'
        'Status = stsDefault')
      (
        'Component = fraImgText13'
        'Status = stsDefault')
      (
        'Component = fraImgText14'
        'Status = stsDefault')
      (
        'Component = fraImgText23'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = fraImgText22'
        'Status = stsDefault')
      (
        'Component = fraImgText20'
        'Status = stsDefault')
      (
        'Component = fraImgText19'
        'Status = stsDefault')
      (
        'Component = fraImgText18'
        'Status = stsDefault')
      (
        'Component = fraImgText21'
        'Status = stsDefault')
      (
        'Component = fraImgText11'
        'Status = stsDefault')
      (
        'Component = fraImgText9'
        'Status = stsDefault')
      (
        'Component = fraImgText24'
        'Status = stsDefault')
      (
        'Component = fraImgText56'
        'Status = stsDefault')
      (
        'Component = fraImgText57'
        'Status = stsDefault')
      (
        'Component = Reminders'
        'Status = stsDefault')
      (
        'Component = fraImgText1'
        'Status = stsDefault')
      (
        'Component = fraImgText2'
        'Status = stsDefault')
      (
        'Component = fraImgText3'
        'Status = stsDefault')
      (
        'Component = fraImgText4'
        'Status = stsDefault')
      (
        'Component = fraImgText5'
        'Status = stsDefault')
      (
        'Component = fraImgText6'
        'Status = stsDefault')
      (
        'Component = fraImgText7'
        'Status = stsDefault')
      (
        'Component = Notes'
        'Status = stsDefault')
      (
        'Component = fraImgText25'
        'Status = stsDefault')
      (
        'Component = fraImgText26'
        'Status = stsDefault')
      (
        'Component = fraImgText27'
        'Status = stsDefault')
      (
        'Component = fraImgText28'
        'Status = stsDefault')
      (
        'Component = fraImgText29'
        'Status = stsDefault')
      (
        'Component = fraImgText30'
        'Status = stsDefault')
      (
        'Component = fraImgText31'
        'Status = stsDefault')
      (
        'Component = fraImgText32'
        'Status = stsDefault')
      (
        'Component = fraImgText33'
        'Status = stsDefault')
      (
        'Component = fraImgText34'
        'Status = stsDefault')
      (
        'Component = fraImgText53'
        'Status = stsDefault')
      (
        'Component = fraImgText54'
        'Status = stsDefault')
      (
        'Component = Consults'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = fraImgText35'
        'Status = stsDefault')
      (
        'Component = fraImgText36'
        'Status = stsDefault')
      (
        'Component = fraImgText43'
        'Status = stsDefault')
      (
        'Component = fraImgText44'
        'Status = stsDefault')
      (
        'Component = fraImgText60'
        'Status = stsDefault')
      (
        'Component = fraImgText61'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = fraImgText41'
        'Status = stsDefault')
      (
        'Component = fraImgText37'
        'Status = stsDefault')
      (
        'Component = fraImgText38'
        'Status = stsDefault')
      (
        'Component = fraImgText39'
        'Status = stsDefault')
      (
        'Component = fraImgText40'
        'Status = stsDefault')
      (
        'Component = fraImgText52'
        'Status = stsDefault')
      (
        'Component = fraImgText55'
        'Status = stsDefault')
      (
        'Component = Surgery'
        'Status = stsDefault')
      (
        'Component = fraImgText42'
        'Status = stsDefault')
      (
        'Component = fraImgText45'
        'Status = stsDefault')
      (
        'Component = fraImgText46'
        'Status = stsDefault')
      (
        'Component = fraImgText47'
        'Status = stsDefault')
      (
        'Component = fraImgText48'
        'Status = stsDefault')
      (
        'Component = fraImgText49'
        'Status = stsDefault')
      (
        'Component = fraImgText50'
        'Status = stsDefault')
      (
        'Component = fraImgText51'
        'Status = stsDefault')
      (
        'Component = fraImgText58'
        'Status = stsDefault')
      (
        'Component = fraImgText59'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = frmIconLegend'
        'Status = stsDefault'))
  end
end
