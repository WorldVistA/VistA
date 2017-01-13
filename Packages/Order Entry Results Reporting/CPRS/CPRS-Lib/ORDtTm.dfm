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
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
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
    Left = -3
    Top = 6
    Width = 302
    Height = 221
    Shape = bsFrame
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 20
    Top = 181
    Width = 200
    Height = 13
    AutoSize = False
    Caption = 
      'Date calendar selector. Use the page up and down buttons to cycl' +
      'e through the months.'
    Visible = False
  end
  object lblDate: TPanel
    Left = 18
    Top = 18
    Width = 192
    Height = 22
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'October 20, 1998'
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    object bvlRButton: TBevel
      Left = 160
      Top = 0
      Width = 2
      Height = 18
      Align = alRight
      Style = bsRaised
    end
    object pnlPrevMonth: TPanel
      Left = 0
      Top = 0
      Width = 27
      Height = 18
      Align = alLeft
      BevelWidth = 2
      TabOrder = 0
      OnClick = imgPrevMonthClick
      OnMouseDown = imgPrevMonthMouseDown
      OnMouseUp = imgPrevMonthMouseUp
      object imgPrevMonth: TImage
        Left = 2
        Top = 2
        Width = 23
        Height = 14
        Align = alClient
        Center = True
        Picture.Data = {
          07544269746D6170EE000000424DEE0000000000000076000000280000000F00
          00000F0000000100040000000000780000000000000000000000100000001000
          0000000000000000800000800000008080008000000080008000808000008080
          8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00888888888888888088888888888888808888888888880880888888888800
          08808888888800CC088088888800CCCC0880888800CCCCCC08808800CCCCCCCC
          0880888800CCCCCC088088888800CCCC08808888888800CC0880888888888800
          0880888888888888088088888888888888808888888888888880}
        OnClick = imgPrevMonthClick
        OnMouseDown = imgPrevMonthMouseDown
        OnMouseUp = imgPrevMonthMouseUp
      end
    end
    object pnlNextMonth: TPanel
      Left = 162
      Top = 0
      Width = 26
      Height = 18
      Align = alRight
      BevelWidth = 2
      TabOrder = 1
      OnClick = imgNextMonthClick
      OnMouseDown = imgNextMonthMouseDown
      OnMouseUp = imgNextMonthMouseUp
      object imgNextMonth: TImage
        Left = 2
        Top = 2
        Width = 22
        Height = 14
        Align = alClient
        Center = True
        Picture.Data = {
          07544269746D6170EE000000424DEE0000000000000076000000280000000F00
          00000F0000000100040000000000780000000000000000000000100000001000
          0000000000000000800000800000008080008000000080008000808000008080
          8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00888888888888888088888888888888808808888888888880880008888888
          8880880CC00888888880880CCCC008888880880CCCCCC0088880880CCCCCCCC0
          0880880CCCCCC0088880880CCCC008888880880CC00888888880880008888888
          8880880888888888888088888888888888808888888888888880}
        OnClick = imgNextMonthClick
        OnMouseDown = imgNextMonthMouseDown
        OnMouseUp = imgNextMonthMouseUp
      end
    end
  end
  object txtTime: TEdit
    Left = 218
    Top = 18
    Width = 81
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnChange = txtTimeChange
  end
  object lstHour: TListBox
    Left = 218
    Top = 38
    Width = 45
    Height = 160
    ItemHeight = 13
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
    TabOrder = 3
    OnClick = lstHourClick
  end
  object lstMinute: TListBox
    Left = 266
    Top = 38
    Width = 33
    Height = 160
    ItemHeight = 13
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
    TabOrder = 4
    OnClick = lstMinuteClick
  end
  object cmdOK: TButton
    Left = 318
    Top = 8
    Width = 72
    Height = 21
    Caption = 'OK'
    TabOrder = 7
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton
    Left = 318
    Top = 37
    Width = 72
    Height = 21
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = cmdCancelClick
  end
  object calSelect: TORCalendar
    Left = 18
    Top = 38
    Width = 192
    Height = 160
    StartOfWeek = 0
    TabOrder = 0
    UseCurrentDate = False
    OnChange = calSelectChange
  end
  object cmdToday: TButton
    Left = 18
    Top = 200
    Width = 42
    Height = 17
    Caption = 'Today'
    TabOrder = 1
    OnClick = cmdTodayClick
  end
  object cmdNow: TButton
    Left = 218
    Top = 200
    Width = 31
    Height = 17
    Caption = 'Now'
    TabOrder = 5
    OnClick = cmdNowClick
  end
  object cmdMidnight: TButton
    Left = 249
    Top = 200
    Width = 50
    Height = 17
    Caption = 'Midnight'
    TabOrder = 6
    OnClick = cmdMidnightClick
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblDate'
        'Status = stsDefault')
      (
        'Component = pnlPrevMonth'
        'Status = stsDefault')
      (
        'Component = pnlNextMonth'
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
        'Status = stsDefault'))
  end
end
