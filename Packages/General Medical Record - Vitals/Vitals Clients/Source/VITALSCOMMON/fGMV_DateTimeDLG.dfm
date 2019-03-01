object fGMV_DateTime: TfGMV_DateTime
  Left = 697
  Top = 290
  BorderStyle = bsDialog
  Caption = 'Date/Time Selector'
  ClientHeight = 262
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    77000770007700077000770007700000F7000F7000F7000F7000F7000F700000
    0000000000000000000000000000000000000000000000000000000000007708
    F8F8F8F8F8F8F8F8F8F8F8F8F8F8F70000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000770899F8F8F8F899F8F448F8F8F8F448F700
    99000000009900044F0000000440000000900000090090400400000040000000
    0009000090000400004000040000000000009009000040900004004000007708
    44F8F998F844F8F998F844F8F8F8F70044000990004400099000440000000000
    0040000004000000090000000000000000040000400000000090000000000000
    00004004000000000009000000007708F8F8F448F8F8F8F8F8F899F8F8F8F700
    0000044000000000000099000000000000000000000000000000009000000000
    0000000000000000000000090000000000000000000000000000000090007708
    F8F8F8F8F8F8F8F8F8F8F8F8F998F70000000000000000000000000009900000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000007708F8F8F8F8F8F8F8F8F8F8F8F8F8F8F700
    0000000000000000000000000000FFFFFFFFF39CE739F39CE739FFFFFFFFFFFF
    FFFF200000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2000000033FCE3F9FDFB
    5BF7FEF7BDEFFF6F5EDF20000000339CE73FFDFBFBFFFEF7FDFFFF6FFEFF2000
    00003F9FFF3FFFFFFFDFFFFFFFEFFFFFFFF7200000003FFFFFF9FFFFFFFFFFFF
    FFFFFFFFFFFF200000003FFFFFFF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000007707707707707000F
    70F70F70F70F7700000000000000F70998F8F998F8F800099000099000047700
    090090090440F708F899F8F8944800000099000049007700000000440090F704
    48F8F844F8F900044000040000097700040040000000F708F844F8F8F8F80000
    0044000000007700000000000000F708F8F8F8F8F8F8E4920000E49200003FFF
    000020000000E79E00003B69000020000000FCF300003FCD000020000000E7BE
    00003B7F000020000000FCFF00003FFF000020000000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 338
    Top = 0
    Width = 85
    Height = 262
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object SpeedButton2: TSpeedButton
      Left = 8
      Top = 40
      Width = 65
      Height = 25
      Caption = '&Cancel'
      OnClick = SpeedButton2Click
    end
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 8
      Width = 65
      Height = 25
      Caption = '&Ok'
      OnClick = SpeedButton1Click
    end
    object Label2: TLabel
      Left = 8
      Top = 226
      Width = 73
      Height = 31
      Alignment = taCenter
      AutoSize = False
      Caption = '        '
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Visible = False
      WordWrap = True
    end
  end
  object grpBoxDT: TGroupBox
    Left = 0
    Top = 0
    Width = 338
    Height = 262
    Align = alClient
    Caption = '  Date/Time '
    TabOrder = 1
    object Panel2: TPanel
      Left = 2
      Top = 15
      Width = 334
      Height = 245
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object pnlDate: TPanel
        Left = 0
        Top = 0
        Width = 214
        Height = 245
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object Panel5: TPanel
          Left = 0
          Top = 208
          Width = 214
          Height = 37
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          object bbtnToday: TBitBtn
            Left = 73
            Top = 4
            Width = 63
            Height = 25
            Caption = '&Today'
            TabOrder = 1
            OnClick = bbtnTodayClick
          end
          object bbtnYesterday: TBitBtn
            Left = 8
            Top = 4
            Width = 65
            Height = 25
            Caption = '<&<<'
            TabOrder = 0
            OnClick = bbtnYesterdayClick
          end
          object bbtnTomorrow: TBitBtn
            Left = 136
            Top = 4
            Width = 65
            Height = 25
            Caption = '>&>>'
            TabOrder = 2
            OnClick = bbtnTomorrowClick
          end
        end
        object mncCalendar: TMonthCalendar
          Left = 0
          Top = 37
          Width = 209
          Height = 162
          CalColors.MonthBackColor = clInfoBk
          Date = 37481.409778842590000000
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TabStop = True
          OnClick = mncCalendarClick
        end
        object pnlDateTimeText: TPanel
          Left = 0
          Top = 0
          Width = 214
          Height = 33
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = '  Date/Time Selected'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
      object Panel6: TPanel
        Left = 213
        Top = 0
        Width = 121
        Height = 245
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 10
          Width = 23
          Height = 13
          Caption = 'T&ime'
          FocusControl = edtTime
        end
        object lbxHours: TListBox
          Left = 9
          Top = 42
          Width = 57
          Height = 160
          Style = lbOwnerDrawVariable
          Color = clInfoBk
          ItemHeight = 13
          Items.Strings = (
            '00'
            '01'
            '02'
            '03'
            '04'
            '05'
            '06'
            '07'
            '08'
            '09'
            '10'
            '11'
            '12'
            '13'
            '14'
            '15'
            '16'
            '17'
            '18'
            '19'
            '20'
            '21'
            '22'
            '23')
          TabOrder = 0
          OnClick = lbxHoursClick
          OnEnter = lbxHoursEnter
        end
        object lbxMinutes: TListBox
          Left = 72
          Top = 40
          Width = 41
          Height = 161
          Style = lbOwnerDrawVariable
          Color = clInfoBk
          ItemHeight = 13
          Items.Strings = (
            ':00 --'
            ':05 '
            ':10 --'
            ':15'
            ':20 --'
            ':25'
            ':30 --'
            ':35'
            ':40 --'
            ':45'
            ':50 --'
            ':55')
          TabOrder = 1
          OnClick = lbxMinutesClick
        end
        object Panel4: TPanel
          Left = 0
          Top = 208
          Width = 121
          Height = 37
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          object bbtnMidnight: TBitBtn
            Left = 49
            Top = 4
            Width = 64
            Height = 25
            Caption = '&Midnight'
            TabOrder = 0
            OnClick = bbtnMidnightClick
          end
          object bbtnNow: TBitBtn
            Left = 7
            Top = 4
            Width = 42
            Height = 25
            Caption = '&Now'
            TabOrder = 1
            OnClick = bbtnNowClick
          end
        end
        object edtTime: TEdit
          Left = 48
          Top = 8
          Width = 65
          Height = 21
          TabOrder = 3
          Text = 'Time'
        end
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 362
    Top = 88
  end
end
