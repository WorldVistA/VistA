object OvcfrmClockDlg: TOvcfrmClockDlg
  Left = 422
  Top = 239
  Caption = 'Clock Dialog'
  ClientHeight = 172
  ClientWidth = 162
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object TPanel
    Left = 0
    Top = 141
    Width = 162
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 152
    ExplicitWidth = 170
    object btnHelp: TButton
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Help'
      TabOrder = 0
    end
    object TPanel
      Left = 92
      Top = 0
      Width = 78
      Height = 31
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnCancel: TButton
        Left = 0
        Top = 4
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Ok'
        Default = True
        ModalResult = 2
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 162
    Height = 141
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 170
    ExplicitHeight = 152
    object OvcClock1: TOvcClock
      Left = 1
      Top = 1
      Width = 168
      Height = 150
      Active = True
      Align = alClient
      Controller = OvcController1
      DigitalOptions.MilitaryTime = True
      DigitalOptions.OnColor = clYellow
      DigitalOptions.OffColor = 1068618
      DigitalOptions.BgColor = clBlack
      DigitalOptions.Size = 2
      DigitalOptions.ShowSeconds = True
      HandOptions.HourHandColor = clBlack
      HandOptions.HourHandLength = 70
      HandOptions.HourHandWidth = 5
      HandOptions.MinuteHandColor = clBlue
      HandOptions.MinuteHandLength = 80
      HandOptions.MinuteHandWidth = 3
      HandOptions.SecondHandColor = clRed
      HandOptions.SecondHandLength = 90
      HandOptions.SecondHandWidth = 1
      HandOptions.ShowSecondHand = True
      HandOptions.SolidHands = False
    end
  end
  object OvcController1: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ())
    Epoch = 1900
  end
end
