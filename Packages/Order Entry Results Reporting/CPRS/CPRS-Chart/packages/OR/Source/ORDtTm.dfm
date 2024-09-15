object ORfrmDtTm: TORfrmDtTm
  Left = 586
  Top = 483
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Select Date/Time'
  ClientHeight = 235
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    398
    235)
  PixelsPerInch = 96
  TextHeight = 13
  object TxtDateSelected: TLabel
    Left = 110
    Top = 181
    Width = 80
    Height = 13
    Caption = 'TxtDateSelected'
    Visible = False
  end
  object bvlFrame: TBevel
    Left = 8
    Top = 6
    Width = 211
    Height = 221
    Shape = bsFrame
    Style = bsRaised
  end
  object lblCalendar: TLabel
    Left = 66
    Top = 204
    Width = 200
    Height = 13
    AutoSize = False
    Caption = 
      'Date calendar selector. Use the page up and down buttons to cycl' +
      'e through the months.'
    Visible = False
  end
  object pnlDate: TPanel
    Left = 18
    Top = 18
    Width = 192
    Height = 22
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'October 20, 1998'
    Color = clWindow
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object bbtnPrevMonth: TBitBtn
      Left = 0
      Top = 0
      Width = 25
      Height = 20
      Align = alLeft
      Glyph.Data = {
        EE000000424DEE0000000000000076000000280000000F0000000F0000000100
        0400000000007800000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        88808888888888888880888888888888088088888888880008808888888800CC
        088088888800CCCC0880888800CCCCCC08808800CCCCCCCC0880888800CCCCCC
        088088888800CCCC08808888888800CC08808888888888000880888888888888
        088088888888888888808888888888888880}
      TabOrder = 0
      OnClick = bbtnPrevMonthClick
    end
    object bbtnNextMonth: TBitBtn
      Left = 165
      Top = 0
      Width = 25
      Height = 20
      Align = alRight
      Glyph.Data = {
        EE000000424DEE0000000000000076000000280000000F0000000F0000000100
        0400000000007800000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8880888888888888888088088888888888808800088888888880880CC0088888
        8880880CCCC008888880880CCCCCC0088880880CCCCCCCC00880880CCCCCC008
        8880880CCCC008888880880CC008888888808800088888888880880888888888
        888088888888888888808888888888888880}
      TabOrder = 1
      OnClick = bbtnNextMonthClick
    end
  end
  object txtTime: TEdit
    Left = 218
    Top = 18
    Width = 81
    Height = 21
    TabOrder = 3
    OnChange = txtTimeChange
  end
  object lstHour: TORDtTmListBox
    Left = 218
    Top = 38
    Width = 45
    Height = 160
    Style = lbOwnerDrawVariable
    Items.Strings = (
      '  0'
      '  1'
      '  2'
      '  3'
      '  4'
      '  5'
      '  6'
      '  7'
      '  8'
      '  9'
      '10'
      '11'
      '12 --'
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
    TabOrder = 4
    OnClick = lstHourClick
    OnEnter = lstHourEnter
  end
  object lstMinute: TORDtTmListBox
    Left = 266
    Top = 38
    Width = 33
    Height = 160
    Style = lbOwnerDrawVariable
    Items.Strings = (
      ':00 --'
      ':05'
      ':10'
      ':15 --'
      ':20'
      ':25'
      ':30 --'
      ':35'
      ':40'
      ':45 --'
      ':50'
      ':55')
    TabOrder = 5
    OnClick = lstMinuteClick
    OnEnter = lstMinuteEnter
  end
  object cmdOK: TButton
    Left = 318
    Top = 8
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 8
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton
    Left = 318
    Top = 37
    Width = 72
    Height = 21
    Caption = 'Cancel'
    TabOrder = 9
    OnClick = cmdCancelClick
  end
  object calSelect: TORCalendar
    Left = 18
    Top = 38
    Width = 192
    Height = 160
    Color = clScrollBar
    StartOfWeek = 0
    TabOrder = 1
    UseCurrentDate = False
    OnChange = calSelectChange
  end
  object cmdToday: TButton
    Left = 18
    Top = 200
    Width = 42
    Height = 23
    Caption = 'Today'
    TabOrder = 2
    OnClick = cmdTodayClick
  end
  object cmdNow: TButton
    Left = 225
    Top = 200
    Width = 31
    Height = 23
    Caption = 'Now'
    TabOrder = 6
    OnClick = cmdNowClick
  end
  object cmdMidnight: TButton
    Left = 262
    Top = 200
    Width = 50
    Height = 23
    Caption = 'Midnight'
    TabOrder = 7
    OnClick = cmdMidnightClick
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 344
    Top = 152
    Data = (
      (
        'Component = pnlDate'
        'Status = stsDefault')
      (
        'Component = txtTime'
        'Text = Time selected'
        'Status = stsOK')
      (
        'Component = lstHour'
        'Text = Hours'
        'Status = stsOK')
      (
        'Component = lstMinute'
        'Text = Minutes'
        'Status = stsOK')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = calSelect'
        'Label = TxtDateSelected'
        'Status = stsOK')
      (
        'Component = cmdNow'
        'Status = stsDefault')
      (
        'Component = cmdToday'
        'Status = stsDefault')
      (
        'Component = cmdMidnight'
        'Status = stsDefault')
      (
        'Component = ORfrmDtTm'
        'Status = stsDefault')
      (
        'Component = bbtnPrevMonth'
        'Text = Previous month'
        'Status = stsOK')
      (
        'Component = bbtnNextMonth'
        'Text = Next month'
        'Status = stsOK'))
  end
end
