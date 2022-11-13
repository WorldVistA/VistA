inherited frmOptions: TfrmOptions
  Left = 315
  Top = 110
  Width = 670
  Height = 599
  HelpContext = 9999
  VertScrollBar.Range = 360
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Options'
  Constraints.MinHeight = 520
  Constraints.MinWidth = 670
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  ExplicitWidth = 670
  ExplicitHeight = 599
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 538
    Width = 664
    Height = 32
    HelpContext = 9999
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    ExplicitTop = 459
    object btnOK: TButton
      AlignWithMargins = True
      Left = 409
      Top = 3
      Width = 76
      Height = 26
      HelpContext = 9007
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnApplyClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 491
      Top = 3
      Width = 76
      Height = 26
      HelpContext = 9008
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnApply: TButton
      AlignWithMargins = True
      Left = 586
      Top = 3
      Width = 75
      Height = 26
      HelpContext = 9009
      Margins.Left = 16
      Align = alRight
      Caption = 'Apply'
      Enabled = False
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
  object pagOptions: TPageControl [1]
    Left = 0
    Top = 0
    Width = 664
    Height = 538
    HelpContext = 9999
    ActivePage = tsCopyPaste
    Align = alClient
    OwnerDraw = True
    TabOrder = 0
    OnChange = pagOptionsChange
    OnChanging = pagOptionsChanging
    OnDrawTab = pagOptionsDrawTab
    OnEnter = pagOptionsEnter
    ExplicitHeight = 459
    object tsCoverSheet: TTabSheet
      HelpContext = 9700
      Caption = 'General'
      ExplicitHeight = 431
      object Panel56: TPanel
        Left = 0
        Top = 0
        Width = 656
        Height = 81
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel57: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 650
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object bvlCoverDays: TBevel
            AlignWithMargins = True
            Left = 111
            Top = 12
            Width = 536
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblCoverDays: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 102
            Height = 20
            Align = alLeft
            Caption = 'Date Range defaults'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel58: TPanel
          Left = 0
          Top = 32
          Width = 96
          Height = 49
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgCoverDays: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000777777777777777777777777700000007FFF8FFF8FFF8FFF88888
              888800000007FFF8FFF8FFF8FFF88888888800000007FFF8FFF8FFF8FFF88888
              88880000000788888888888888888888888800000007FFF8FFF8FFF8FFF8FFF8
              FFF800000007FFF8FFF8FFF8FFF8FFF8FFF800000007FFF8FFF8FFF8FFF8FFF8
              FFF80000000788888888888888888888888800000007FFF8FFF8FFF8FFF8FFF8
              FFF800000007FFF8FFF8FFF8FFF8FFF8FFF800000007FFF8FFF8FFF8FFF8FFF8
              FFF80000000788888888888888881118888800000007FFF8FFF8FFF8FFF18F81
              FFF800000007FFF8FFF8FFF8FFF1FFF1FFF800000007FFF8FFF8FFF8FFF18F81
              FFF80000000788888888888888881118888800000007888888888888FFF8FFF8
              FFF800000007888888888888FFF8FFF8FFF800000007888888888888FFF8FFF8
              FFF8000000077777777777777777777777770000000744444444444477777777
              7777000000074444444444447777777777770000000777777777777777777777
              7777000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFE0000007E0000007E0000007E0000007E0000007E0000007E0000007
              E0000007E0000007E0000007E0000007E0000007E0000007E0000007E0000007
              E0000007E0000007E0000007E0000007E0000007E0000007E0000007E0000007
              E0000007E0000007FFFFFFFFFFFFFFFFFFFFFFFF280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              000080000080000000808000800000008000800080800000C0C0C00080808000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
              0000000000000000000000008FF7FF7FF7FF7FF08FF7FF7FF7FF7FF087777777
              777777708FF7FF7FF7FF7FF08FF7FF7FF7FF7FF087777777711117708FF7FF7F
              F1FF1FF08FF7FF7FF1FF1FF087777777711117708FF7FF7FF7FF7FF08FF7FF7F
              F7FF7FF0844444448888888084444444888888808888888888888880FFFF0000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000000000000000000000000000000000000000}
            ExplicitLeft = 16
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel59: TPanel
          Left = 96
          Top = 32
          Width = 560
          Height = 49
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel60: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 49
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnCoverDays: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              HelpContext = 9001
              Align = alTop
              Caption = '&Date Range Defaults...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnCoverDaysClick
            end
          end
          object lblCoverDaysDesc: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 369
            Height = 43
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Change the default date ranges for displaying patient '
              'information on your cover sheet.')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object Panel61: TPanel
        Left = 0
        Top = 81
        Width = 656
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Panel62: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object bvlCoverReminders: TBevel
            AlignWithMargins = True
            Left = 99
            Top = 12
            Width = 554
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblCoverReminders: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 90
            Height = 20
            Align = alLeft
            Caption = 'Clinical Reminders'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel63: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 63
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgCoverReminders: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000008FFF0000000000000000000000000008BFBFFF000000000
              0000000000000008BFBFFBFFB0000000000000000000000BFBFBFFFFFFF00000
              000000000000008FBFBFBFBFBFFFB00000000000000000FBFBF38BFBFFFFFFB0
              00000000000008BFBFB88888BFBFBFFFB000000000000BFBFB83878B8BFFFFFF
              FFB0000000008FBFBFBF38383FB8BFFBFFFFB0000000FBFB83FBFB83FB838BFF
              FFBFFF700008BFBF7838BFBFB87F87BFBFFFFF70000BFBFB8B878B8BFB8B8F83
              8FFBF700008FBFBFB8B87838BFB8383F88FF700000FBFB8BFBF3838788FBFBF3
              8BFB700008BFB878B8BFBFB83878BFF8FFF700000BFBF38B878BFBFBF37788FB
              FBF700008FBFBFB8B8387FBFBFB838BFFF7000008BFBFBFBFB838B8BFBFBF3FB
              FB70000077BFBFBFB887BF383FBFBFBFB70000000077FBFBFBFBF3FB878B8BFB
              F7000000000077BFBFBFBF38B778BFBF7000000000000077FBFBFBFBFB83FBFB
              700000000000000077BFBFBFBFBFBFB700000000000000000077FBFBFBFBFBF7
              0000000000000000000077BFBFBFBF70000000000000000000000077FBFBFB70
              00000000000000000000000077BFB70000000000000000000000000000777000
              0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFF87FFFF
              FF01FFFFFE007FFFFC001FFFFC0007FFF80001FFF800007FF000001FF0000007
              E0000001E0000001C0000001C000000380000007800000070000000F0000000F
              0000001F0000001F0000003FC000003FF000007FFC00007FFF0000FFFFC000FF
              FFF001FFFFFC01FFFFFF03FFFFFFC7FFFFFFFFFF280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              000080000080000000808000800000008000800080800000C0C0C00080808000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
              00000000000000000000000000000FB00000000000000BFBF00000000000BFBF
              BFB000000000FB88FBFBF000000FBFBF88BFBFB0000BF88BFB88FB8000BFBFB8
              8FBFB80000FB88FBF88BF800088FBF88BFBF800000088BFB88FB80000000088F
              BFB80000000000088BF8000000000000088000000000000000000000FFFF0000
              F9FF0000F07F0000F01F0000E0070000E0010000C0000000C001000080030000
              8003000080070000E0070000F80F0000FE0F0000FF9F0000FFFF0000}
            ExplicitLeft = 16
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel64: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 63
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel65: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 63
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnCoverReminders: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              HelpContext = 9002
              Align = alTop
              Caption = '&Clinical Reminders...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnCoverRemindersClick
            end
          end
          object lblCoverReminderDesc: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 369
            Height = 57
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Configure and arrange which clinical reminders are '
              'displayed on your cover sheet.')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object Panel66: TPanel
        Left = 0
        Top = 170
        Width = 656
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Panel67: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object bvlOtherParameters: TBevel
            AlignWithMargins = True
            Left = 95
            Top = 12
            Width = 558
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblOtherParameters: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 86
            Height = 20
            Align = alLeft
            Caption = 'Other Parameters'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel68: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 63
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgOtherParameters: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
              000000000000000000FBFFFBFFFBFFFBFFFBFFF00000000000FFFFFFFFFFFFFF
              FFFFFFF00000000000FFFBFFFBFFFBFFFBFFFBF00000000000FFFFFFFFFFFFFF
              FFFFFFF00000000000FB77777777777777777FF00000000000FFFFFFFFFFFFFF
              FFFFFFF00000000000FFFBFFFBFFFBFFFBFFFBF00000000000FFFFFFFFFFFFFF
              FFFFFFF000000000008877777777777777777FF0000000000000000000000008
              FFFFFFF00BFBFBFBFBFBFBFBFBFBFB08FBFFFBF000BFBFBFBFBFBFBFBFBFBFB0
              8FFFFFF000FBFBFBFBFBFBFBFBFBFBF077777FF0000FBFBFBFBFBFBFBFBFBFBF
              08FFFFF0000BFBFBFBFBFBFBFBFBFBFB08FFFBF00000BFBFBFBFBFBFBFBFBFBF
              B08FFFF00000FBFBFBFBFBFBFBFBFBFBF0777FF000000FBFBFBFBFBFBFBFBFBF
              BF08FFF000000BFBFBFBFBFBFBFBFBFBFB08FBF0000000BFBFBF000000000FBF
              BFB08FF0000000FBFBFB0FFFFFFF0BFBFBF07FF00000000FBFBFB0F0F00FF0BF
              BFBF08F00000000BFBFBF0FF0000F0FBFBFB08F000000000BFBFBF0FFFFFFF0F
              BFBFB08000000000FBFBFB000000000BFBFBF080000000000FBFBFBFBFBFBFBF
              BFBFBF00000000000BFBFBFBFBFBFBFBFBFBFB000000000000BF7FBF7FBF7FBF
              7FBF7FB000000000000070007000700070007000000000000000707070707070
              7070707000000000000007000700070007000700FF800000FF800000FF800000
              FF800000FF800000FF800000FF800000FF800000FF800000FF80000000000000
              000000008000000080000000C0000000C0000000E0000000E0000000F0000000
              F0000000F8000000F8000000FC000000FC000000FE000000FE000000FF000000
              FF000000FF800000FF800000FFF55555FFFBBBBB280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              00008000008000000080800080000000800080008080000080808000C0C0C000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
              0000000000000FBFBFBFBFB000000B77777777F000000FBFBFBFBFB000000B77
              777777F0000000000000BFB00BFBFBFBFBF0F7F000BFBFBFBFBF0FB000FBFBFB
              FBFB0BF0000FB00000BFB0B0000BFB0FFF0BF0F00000BF00000FBF000000FBFB
              FBFBFB00000007BF7FB7BF7000000700700700700000007007007007F0000000
              F0000000F0000000F0000000F000000000000000000000008000000080000000
              C0000000C0000000E0000000E0000000F0000000F0000000FDB60000}
            ExplicitLeft = 15
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel69: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 63
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel70: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 63
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnOtherParameters: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              HelpContext = 9003
              Align = alTop
              Caption = '&Other Parameters...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnOtherParametersClick
            end
          end
          object lblOtherParametersDesc: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 369
            Height = 57
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Configure chart tab setting.'
              'Change display date range on Meds tab.'
              'Change Encounter Appointments date range.')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
    end
    object tsNotifications: TTabSheet
      HelpContext = 9030
      BorderWidth = 2
      Caption = 'Notifications'
      object pnlNotificationsList: TPanel
        Left = 0
        Top = 95
        Width = 652
        Height = 332
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitTop = 120
        ExplicitHeight = 307
        object lvwNotifications: TCaptionListView
          Left = 0
          Top = 54
          Width = 652
          Height = 278
          HelpContext = 9035
          Align = alClient
          Checkboxes = True
          Columns = <
            item
              Caption = 'Notification'
              Width = 190
            end
            item
              Caption = 'On/Off'
            end
            item
              Caption = 'Comment'
              Width = 145
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvwNotificationsChange
          OnColumnClick = lvwNotificationsColumnClick
          OnCompare = lvwNotificationsCompare
          OnDblClick = lvwNotificationsDblClick
          OnEnter = lvwNotificationsEnter
          OnMouseDown = lvwNotificationsMouseDown
          AutoSize = False
          Caption = 
            'You can turn on or off these notifications except those that are' +
            ' mandatory.'
          HideTinyColumns = False
          ExplicitHeight = 253
        end
        object Panel2: TPanel
          Left = 0
          Top = 29
          Width = 652
          Height = 25
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object lblNotificationView: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 349
            Height = 19
            Align = alLeft
            Caption = 
              'You can turn on or off these notifications except those that are' +
              ' mandatory.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ExplicitHeight = 13
          end
        end
        object pnlNotificationTools: TPanel
          Left = 0
          Top = 0
          Width = 652
          Height = 29
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
          object Button1: TButton
            AlignWithMargins = True
            Left = 216
            Top = 3
            Width = 213
            Height = 23
            HelpContext = 9031
            Align = alRight
            Caption = '&Remove Pending Notifications...'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = btnNotificationsRemoveClick
          end
          object Button2: TButton
            AlignWithMargins = True
            Left = 435
            Top = 3
            Width = 214
            Height = 23
            HelpContext = 9033
            Align = alRight
            Caption = 'Processed Alerts Settings...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = btnProcessedAlertsSettingsClick
          end
        end
      end
      object pnlNotifications: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 646
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Panel82: TPanel
          Left = 0
          Top = 0
          Width = 646
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object bvlNotifications: TBevel
            AlignWithMargins = True
            Left = 71
            Top = 12
            Width = 572
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 96
            ExplicitTop = 16
            ExplicitWidth = 312
            ExplicitHeight = 2
          end
          object lblNotifications: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 62
            Height = 20
            Align = alLeft
            Caption = 'Notifications'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel83: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 63
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgNotifications: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000003888738337700000000000000000038FBFFFB788B8837
              7000000000000788FBFFFBFFF7FF8B8883700000000007FBFFFBFFFBFF7BFFFB
              888700000000007FFBFFFBFFFB7FFBFFFBF3700000000007FFFBFFFBFFF7FFFB
              FF77770000000007FBFFFBFFFBF7FB7777FFF800000000007FFBFFFBFFF777FB
              FFFBF800000000007BFFFBFFFBFFFBFFFBFFF8000000000007FBFFFBFFFBFFFB
              FFFBF8000000000007FFFBFFFBFFFBFFFBFFF8000000000000000FFBFFFBFFFB
              FFFBF80000000000011110FFFBFFFBFFFBFFF80000111000011110FBFFFBFFFB
              FFFBF800011111000001110FFBFFFBFFFBFFF800091111011110110FFFFFFFFB
              FFFBF800091111011110110000000FFFFBFFF8000991110111101107777777FB
              FFFBF800099111099991110FFBFFFBFFFBFFF80000999077091110FBFFFBFFFB
              FFFBF80000000000099910FFFBFFFBFFFBFFF8000000000000000FFBFFFBFFFB
              FFFBF8000000000007FFFBFFFBFFFBFFFBFFF8000000000007FBFFFBFFFBFFFB
              FFFBF8000000000007FFFBFFFBFFFBFFFBFFF8000000000007FBFFFBFFFBFFFB
              FFFBF80000000000077777777777777777777700000000000000000000000000
              0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFE003FF
              FF00007FFC00001FF800000FF8000007FC000003FE000001FE000001FF000001
              FF000001FF800001FF800001FF800001C7000001830000010000000100000001
              00000001000000010000000180000001C7000001FF800001FF800001FF800001
              FF800001FF800001FF800001FFFFFFFFFFFFFFFF280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              000080000080000000808000800000008000800080800000C0C0C00080808000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
              00000000000000000000000000087B77088800000008FFFBF0B7880000008BFF
              FB0FB78000008FFBFF0F0080000008FFFB80FB700000000BFFFBFF7000000660
              FBFFFB7006600060FFFBFF700E60E06000FFFB700EE00EE0FFFBFF700000000F
              FBFFFB70000008FBFFFBFF7000000888888888800000000000000000FFFF0000
              F00F0000E0030000E0010000F0000000F0000000F8000000F800000090000000
              00000000000000000000000098000000F8000000F8000000FFFF0000}
            ExplicitLeft = 13
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel84: TPanel
          Left = 96
          Top = 26
          Width = 550
          Height = 63
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel85: TPanel
            Left = 330
            Top = 0
            Width = 220
            Height = 63
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnNotificationsRemove: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 214
              Height = 26
              HelpContext = 9031
              Align = alTop
              Caption = '&Remove Pending Notifications...'
              Enabled = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnNotificationsRemoveClick
            end
            object btnProcessedAlertsSettings: TButton
              AlignWithMargins = True
              Left = 3
              Top = 35
              Width = 214
              Height = 26
              HelpContext = 9033
              Align = alTop
              Caption = 'Processed Alerts Settings...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = btnProcessedAlertsSettingsClick
            end
          end
          object lblNotificationsOptions: TStaticText
            Left = 3
            Top = 3
            Width = 158
            Height = 17
            Caption = 'Change your notification options.'
            TabOrder = 1
          end
          object chkNotificationsFlagged: TCheckBox
            Left = 3
            Top = 29
            Width = 292
            Height = 16
            HelpContext = 9032
            Caption = 'Send me a MailMan bulletin for flagged orders'
            TabOrder = 2
            OnClick = chkNotificationsFlaggedClick
          end
        end
      end
    end
    object tsOrderChecks: TTabSheet
      HelpContext = 9040
      Caption = 'Order Checks'
      ImageIndex = 3
      ExplicitHeight = 431
      object lblOrderChecksView: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 92
        Width = 650
        Height = 13
        Align = alTop
        Caption = 
          'You can turn on or off these notifications except those that are' +
          ' mandatory.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 349
      end
      object lvwOrderChecks: TCaptionListView
        AlignWithMargins = True
        Left = 3
        Top = 111
        Width = 650
        Height = 396
        HelpContext = 9041
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = 'Order Check'
            Width = 190
          end
          item
            Caption = 'On/Off'
          end
          item
            Caption = 'Comment'
            Width = 145
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvwNotificationsChange
        OnColumnClick = lvwNotificationsColumnClick
        OnCompare = lvwNotificationsCompare
        OnDblClick = lvwNotificationsDblClick
        OnEnter = lvwNotificationsEnter
        OnMouseDown = lvwNotificationsMouseDown
        AutoSize = False
        Caption = 
          'You can turn on or off these notifications except those that are' +
          ' mandatory.'
        HideTinyColumns = False
        ExplicitHeight = 317
      end
      object Panel42: TPanel
        Left = 0
        Top = 0
        Width = 656
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Panel52: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 650
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object bvlOrderChecks: TBevel
            AlignWithMargins = True
            Left = 78
            Top = 12
            Width = 569
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblOrderChecks: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 69
            Height = 20
            Align = alLeft
            Caption = 'Order Checks'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel53: TPanel
          Left = 0
          Top = 32
          Width = 96
          Height = 57
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgOrderChecks: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000777777777777777777777700000000007FFFFFFFFFFFFFFFFFF
              FF700000000007FFFFFFFFFFFFFFFFFFFF700000000007FFFFFFFFFFFFFFFFFF
              FF700000000007FFFFFF888FFFFFFFFFFF700000000007FFFFF81188FFFFFFFF
              FF700000000007FFFF8111188FFFFFFFFF700000000007FFF81111118FFFFFFF
              FF700000000007FF8111111178FFFFFFFF700000000007FF1111F711188FFFFF
              FF700000000007FF111FFF811188FFFFFF700000000007FFF1FFFFF81178FFFF
              FF700000000007FFFFFFFFFF81178FFFFF700000000007FFFFFFFFFFFF1188FF
              FF700000000007FFFFFFFFFFFFF1188FFF700000000007FFFFFFFFFFFFFF1188
              FF700000000007FFFFFFFFFFFFFFF118FF700000000007FFFFFFFFFFFFFFFF11
              FF700000000007FFFFFFFFFFFFFFFFF18F700000000007FFFFFFFFFFFFFFFFFF
              1F700000000007FFFFFFFFFFFFFFFFFFFF700000000007FFFFF000000000008F
              FF700000000007FFFFF777777777808FFF700000000000777777F77777778077
              77000000000000000007F88888878000000000000000000000007FFFFFF70000
              0000000000000000000007777777000000000000000000000000000000000000
              0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFC00001F
              F800000FF800000FF800000FF800000FF800000FF800000FF800000FF800000F
              F800000FF800000FF800000FF800000FF800000FF800000FF800000FF800000F
              F800000FF800000FF800000FF800000FF800000FF800000FF800000FFC00003F
              FFE003FFFFF007FFFFF80FFFFFFFFFFFFFFFFFFF280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              000080000080000000808000800000008000800080800000C0C0C00080808000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
              000000000000000000000000000FFFFFFFFFF000000FFF77FFFFF000000FF717
              7FFFF000000F711177FFF000000F11F117FFF000000FFFFF187FF000000FFFFF
              F177F000000FFFFFFF17F000000FFFFFFFF1F000000FFFFFFFFFF000000FF000
              000FF000000000F77700000000000000000000000000000000000000FFFF0000
              E0070000C0030000C0030000C0030000C0030000C0030000C0030000C0030000
              C0030000C0030000C0030000C0030000E0070000FC3F0000FFFF0000}
            ExplicitLeft = 52
            ExplicitWidth = 57
          end
        end
        object Panel54: TPanel
          Left = 96
          Top = 32
          Width = 560
          Height = 57
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object lblOrderChecksDesc: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 554
            Height = 30
            Align = alTop
            AutoSize = False
            Caption = 'Enable or disable your order checks.'
            WordWrap = True
            ExplicitLeft = 125
            ExplicitTop = 24
            ExplicitWidth = 275
          end
          object Panel55: TPanel
            Left = 375
            Top = 36
            Width = 185
            Height = 21
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
          end
        end
      end
    end
    object tsListsTeams: TTabSheet
      HelpContext = 9050
      Caption = 'Lists/Teams'
      ImageIndex = 4
      ExplicitHeight = 431
      object Panel71: TPanel
        Left = 0
        Top = 0
        Width = 656
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel72: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object bvlPatientSelection: TBevel
            AlignWithMargins = True
            Left = 133
            Top = 12
            Width = 520
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblPatientSelection: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 124
            Height = 20
            Align = alLeft
            Caption = 'Patient Selection defaults'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel73: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 63
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgPatientSelection: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00066660006606666000000000
              000000000666066600606600000000000000000000600660FF60000000000000
              000000000000660FFF0000000000000000000000000000FF8800000000000000
              0000000000000FFF700005550555500000000000000007FFFFFF070050500000
              00000000000077FFFFFF78885000000000000000000780FFFF70088800000000
              000000000078880FFFFF088700000000000000000088870FFFFFF08000000000
              00000000008880FFFFFF08888000000000000000008F80FFFFF7888880000000
              0000000000FF8807FFF08888800000000000000000FFFFFFFFF0888888000000
              00000000007FFFFFFFF888888880000000000000000FFFFFFFF0088888000000
              00000000000007FFF00778888700000000000000000000000888778880777777
              777777700000000FF8888788808888888888887000000007FF88887778088888
              8888887000000000FFF8888888088848888888700000000077FFFFF700888444
              8888887000000000007700000788444448888870000000000000000007888484
              4488887000000000000000000788888844488870000000000000000007888888
              8444887000000000000000000788888888444870000000000000000007888888
              8884887000000000000000000788888888888870000000000000000007888888
              88888870000000000000000007777777777777700001FFFF0001FFFF8003FFFF
              C00FFFFFE01FFFFFF00007FFF00007FFE0001FFFC0003FFF80007FFF80007FFF
              80003FFF80003FFF80003FFF80001FFFC0000FFFC0001FFFE0003FFFFC000001
              FC000001FE000001FE000001FF000001FFC18001FFFF8001FFFF8001FFFF8001
              FFFF8001FFFF8001FFFF8001FFFF8001FFFF8001280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              000080000080000000808000800000008000800080800000C0C0C00080808000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000660060
              000000000000FF0000000000000FF005050000000000FFF070000000077FFFF0
              700000000770FFFF070000000770FF007700000007770FF07770000000777770
              7000000000000008770888880000088888047778000000000044477800000000
              0847447800000000087774480000000008777748000000000888888880FF0000
              C1FF0000C01F0000803F0000003F0000001F0000001F0000000F0000801F0000
              C0000000F0000000F8000000FF800000FF800000FF800000FF800000}
            ExplicitLeft = 16
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel74: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 63
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel75: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 63
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnPatientSelection: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              HelpContext = 9051
              Align = alTop
              Caption = 'Patient &Selection Defaults...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnPatientSelectionClick
            end
            object btnCombinations: TButton
              AlignWithMargins = True
              Left = 3
              Top = 35
              Width = 179
              Height = 26
              HelpContext = 9054
              Align = alTop
              Caption = 'Source &Combinations...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = btnCombinationsClick
            end
          end
          object lblPatientSelectionDesc: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 369
            Height = 57
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Change the defaults for selecting patients. If your List '
              'Source is Combination, the criteria is defined using '
              'Source Combinations.')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object Panel76: TPanel
        Left = 0
        Top = 89
        Width = 656
        Height = 135
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Panel77: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object bvlTeams: TBevel
            AlignWithMargins = True
            Left = 134
            Top = 12
            Width = 519
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblTeams: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 125
            Height = 20
            Align = alLeft
            Caption = 'Personal Lists and Teams'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel78: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 109
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgTeams: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00066660006606666000000000
              000000000666066600606600000000000000000000600660FF60000000000000
              000000000000660FFF0000000000000000000000000000FF8800000000000000
              0000000000000FFF700005550555500000000000000007FFFFFF070050500000
              00000000000077FFFFFF78885000000000000000000780FFFF70088800000000
              000000000078880FFFFF088700000000000000000088870FFFFFF08000000000
              00000000008880FFFFFF08888000000000000000008F80FFFFF7888880000000
              0000000000FF8807FFF08888800000000000000000FFFFFFFFF0888888000000
              00000000007FFFFFFFF888888880000000000000000FFFFFFFF0088888000000
              00000000000007FFF00778888700000000000000000000000888778880000000
              000000000000000FF8888788800000000000000000000007FF88887778000000
              0000000000000000FFF8888888000000000000000000000077FFFFF700000000
              0000000000000000007700000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000000000000000000000000001FFFF0001FFFF8003FFFF
              C00FFFFFE01FFFFFF00007FFF00007FFE0001FFFC0003FFF80007FFF80007FFF
              80003FFF80003FFF80003FFF80001FFFC0000FFFC0001FFFE0003FFFFC003FFF
              FC003FFFFE001FFFFE001FFFFF003FFFFFC1FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              000080000080000000808000800000008000800080800000C0C0C00080808000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000660060
              000000000000FF0000000000000FF005050000000000FFF070000000077FFFF0
              700000000770FFFF070000000770FF007700000007770FF07770000000777770
              7008888800000008770557780000088888077778000000000075577800000000
              0877557800000000085775580000000008755578000000000888888880FF0000
              C1FF0000C01F0000803F0000003F0000001F0000001F0000000F000080000000
              C0000000F0000000F8000000FF800000FF800000FF800000FF800000}
            ExplicitLeft = 16
            ExplicitTop = 68
            ExplicitWidth = 41
          end
        end
        object Panel79: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 109
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel80: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 109
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnPersonalLists: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              HelpContext = 9052
              Align = alTop
              Caption = 'Personal &Lists...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnPersonalListsClick
            end
            object btnDiagnoses: TButton
              AlignWithMargins = True
              Left = 3
              Top = 35
              Width = 179
              Height = 26
              Align = alTop
              Caption = 'Personal &Diagnoses List...'
              TabOrder = 1
              OnClick = btnDiagnosesClick
            end
            object btnTeams: TButton
              AlignWithMargins = True
              Left = 3
              Top = 67
              Width = 179
              Height = 26
              HelpContext = 9053
              Align = alTop
              Caption = '&Teams Information...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = btnTeamsClick
            end
          end
          object lblTeamsDesc: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 369
            Height = 103
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Edit your personal lists of patients and diagnoses. View '
              'the teams you are on and the patients associated with '
              'those teams.')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
    end
    object tsNotes: TTabSheet
      HelpContext = 9200
      Caption = 'Notes'
      ImageIndex = 4
      ExplicitHeight = 431
      object pnlTIU: TPanel
        Left = 0
        Top = 170
        Width = 656
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Panel38: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Bevel9: TBevel
            AlignWithMargins = True
            Left = 165
            Top = 12
            Width = 488
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblNotesTitles: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 156
            Height = 20
            Align = alLeft
            Caption = 'Required Fields of TIU Templates'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel39: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 63
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgRequiredFields: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              07544269746D617036080000424D360800000000000036040000280000002000
              0000200000000100080000000000000400000000000000000000000100000000
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
              FF0007F7A4A4A4A4A4070707A4A4A4A407070707070707070707070707070707
              0707000000000000A4A4A400000000A4A4A40707070707070707070707070707
              070700FFFFFFFFFF000000FFFFFFFF0000A4A4A4070707070707070707070707
              070700FFFFFFFFFFFFFFFFFFFFFFFFFF000000A4A4A407070707070707070707
              070700FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000A4A4070707070707070707
              070700FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000A4A40707070707070707
              070700FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000A40707070707070707
              070700FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00A4A407070707070707
              070700FFFFFFFFFFFFA4A4A4A4A4A4A4A4A4A4A4A4A40000A4A4A4A4A4A4A407
              070700FFFFFFFFFFFFFBFBFBFBFBFBFBFBFBFBFBFBFBFF00000000000000A4A4
              070700FFFFFFFFFFFFFBFBFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFF0000A4
              A40700FFFFFFFFFFFFFBFBFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFFFF0000
              A40700FFFFFFFFFFFFFBFBFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFFFFFF00
              A40700FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
              A4A400FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
              00A400FFFFFFFFFFFFA4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4
              00A400FFFFFFFFFFFFFBFBFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFFFFFFFF
              00A400FFFFFFFFFFFFFBFBFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFFFFFFFF
              00A400FFFFFFFFFFFFFBFBFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFFFFFFFF
              00A400FFFFFFFFFFFFFBFBFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFFFFFFFF
              00A400FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              00A400FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              00A400FFFFFFFFFFFFA4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4
              00A400FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              00A400FFFFFFFFFFFFFFFF00FFFFFF000000FF00FFFFFF00FF00FFFFFF0000FF
              00A400FFFFFFFFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FF0000FFFF00FFFF
              00A400FFFFFFFFFFFFFFFF00FFFFFF0000FFFF00FF00FF00FF00FF00FF00FFFF
              00A400FFFFFFFFFFFFFFFF00FFFFFF00FFFFFF0000FF0000FF00FF00FF00FFFF
              00A400FFFFFFFFFFFF0000000000FF000000FF00FFFFFF00FF0000FFFF00FFFF
              00A400FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              00A400FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              00F7000000000000000000000000000000000000000000000000000000000000
              0007}
            Transparent = True
            ExplicitLeft = 16
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel40: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 63
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel41: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 63
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnRequiredFields: TButton
              Left = 0
              Top = 0
              Width = 185
              Height = 26
              HelpContext = 9202
              Align = alTop
              Caption = '&Required Fields...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnRequiredFieldsClick
            end
          end
          object lblNotesTitlesDesc: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 369
            Height = 60
            Margins.Top = 0
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Configure appearance of the Required fields without '
              'values in TIU Templates')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object pnlNoteTop: TPanel
        Left = 0
        Top = 0
        Width = 656
        Height = 81
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel43: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Bevel10: TBevel
            AlignWithMargins = True
            Left = 41
            Top = 12
            Width = 612
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblNotesNotes: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 32
            Height = 20
            Align = alLeft
            Caption = 'Notes'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel44: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 55
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgNotesNotes: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00077777700077770000000000
              00000000000000777000077700000000000000000FFFFF000FFFF00777000000
              000000000FFFFFFFFFFFFF0007770000000000000FFFFFFFFFFFFFFFF0077000
              000000000FFFFFFFFFFFFFFFFF007700000000000FFFFFFFFFFFFFFFFFF00700
              000000000FFFFFFFFFFFFFFFFFFF0770000000000FFFFFF77777777777770077
              777770000FFFFFFFFFFFFFFFFFFFF000000077000FFFFFFFFFFFFFFFFFFFFFFF
              FFF007700FFFFFFFFFFFFFFFFFFFFFFFFFFF00700FFFFFFFFFFFFFFFFFFFFFFF
              FFFFF0700FFFFFFFFFFFFFFFFFFFFFFFFFFFF0770FFFFFFFFFFFFFFFFFFFFFFF
              FFFFF0070FFFFFF77777777777777777777777070FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFF77777777777777777
              777777070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFF0FFF0FF00FFFF0FFF
              000FFF070FFFFFF0FF00F0FF0FFF0FFF0FFFFF070FFFFFF0F0F0F0FF0FFF0FFF
              00FFFF070FFFFFF00FF0F0FF0FFF0FFF0FFFFF070FFFFFF0FFF0FF00FF00000F
              000FFF070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF070000000000000000000000000000000081C3FFFF0000FFFF00003FFF
              00000FFF000007FF000003FF000003FF000001FF000000070000000300000001
              0000000100000001000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000001280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              00008000008000000080800080000000800080008080000080808000C0C0C000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0077777777
              0000000000000000770000000FFFFFFF007000000FFFFFFFFF0770000FF77777
              777007770FFFFFFFFFFFF0070FFFFFFFFFFFFF070FF77777777777070FFFFFFF
              FFFFFF070FFFFFFFFFFFFF070FF77777777777070FF9F9999F9F99070FF9999F
              9F9F9F070FF9F9F9F99999070FFFFFFFFFFFFF07000000000000000700FF0000
              003F0000001F0000000700000000000000000000000000000000000000000000
              00000000000000000000000000000000000000000000000000000000}
            ExplicitLeft = 16
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel45: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 55
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel46: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 55
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnNotesNotes: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              HelpContext = 9201
              Align = alTop
              Caption = '&Notes...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnNotesNotesClick
            end
          end
          object lblNotesNotesDesc: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 369
            Height = 52
            Margins.Top = 0
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Configure defaults for editing and saving '
              'notes.')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object Panel47: TPanel
        Left = 0
        Top = 81
        Width = 656
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Panel48: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Bevel1: TBevel
            AlignWithMargins = True
            Left = 90
            Top = 12
            Width = 563
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object StaticText5: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 81
            Height = 20
            Align = alLeft
            Caption = 'Document Titles'
            TabOrder = 0
          end
        end
        object Panel49: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 63
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgNotes: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00077777700077770000000000
              00000000000000777000077700000000000000000FFFFF000FFFF00777000000
              000000000FFFFFFFFFFFFF0007770000000000000FFFFFFFFFFFFFFFF0077000
              000000000FFFFFFFFFFFFFFFFF007700000000000FFFFFFFFFFFFFFFFFF00700
              000000000FFFFFFFFFFFFFFFFFFF0770000000000FFFFFF77777777777770077
              777770000FFFFFFFFFFFFFFFFFFFF000000077000FFFFFFFFFFFFFFFFFFFFFFF
              FFF007700FFFFFFFFFFFFFFFFFFFFFFFFFFF00700FFFFFFFFFFFFFFFFFFFFFFF
              FFFFF0700FFFFFFFFFFFFFFFFFFFFFFFFFFFF0770FFFFFFFFFFFFFFFFFFFFFFF
              FFFFF0070FFFFFF77777777777777777777777070FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFF77777777777777777
              777777070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFFFF0FFF0FFF0FFF000
              F000FF070FFFFFFFF0FFF0FFF0FFF0FFF0FFFF070FFFFFFFF0FFF0FFF0FFF0FF
              F00FFF070FFFFFFFF0FFF0FFF0FFF0FFF0FFFF070FFFFFF00000F0F00000F0FF
              F000FF070FFFFFFFFFFFFFFFFFFFFFFFFFFFFF070FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF070000000000000000000000000000000081C3FFFF0000FFFF00003FFF
              00000FFF000007FF000003FF000003FF000001FF000000070000000300000001
              0000000100000001000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000001280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              00008000008000000080800080000000800080008080000080808000C0C0C000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0077777777
              0000000000000000770000000FFFFFFF007000000FFFFFFFFF0770000FF77777
              777007770FFFFFFFFFFFF0070FFFFFFFFFFFFF070FF77777777777070FFFFFFF
              FFFFFF070FFFFFFFFFFFFF070FF77777777777070FF9F9999F9F99070FF9999F
              9F9F9F070FF9F9F9F99999070FFFFFFFFFFFFF07000000000000000700FF0000
              003F0000001F0000000700000000000000000000000000000000000000000000
              00000000000000000000000000000000000000000000000000000000}
            ExplicitLeft = 13
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel50: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 63
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Memo3: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 369
            Height = 60
            Margins.Top = 0
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Configure document list preferences.')
            ReadOnly = True
            TabOrder = 0
          end
          object Panel51: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 63
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 1
            object btnNotesTitles: TButton
              AlignWithMargins = True
              Left = 3
              Top = 0
              Width = 179
              Height = 26
              HelpContext = 9202
              Margins.Top = 0
              Align = alTop
              Caption = '&Document Titles...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnNotesTitlesClick
            end
          end
        end
      end
    end
    object tsCprsReports: TTabSheet
      Caption = 'Reports'
      ImageIndex = 5
      ExplicitHeight = 431
      object Panel22: TPanel
        Left = 0
        Top = 170
        Width = 656
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Panel23: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Bevel6: TBevel
            AlignWithMargins = True
            Left = 100
            Top = 12
            Width = 553
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblReport2: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 91
            Height = 20
            Align = alLeft
            Caption = 'Remote Data Tool'
            TabOrder = 0
          end
        end
        object Panel24: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 63
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgReport2: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Center = True
            Picture.Data = {
              055449636F6E0000010001002020000000000000A80800001600000028000000
              2000000040000000010008000000000080040000000000000000000000010000
              0000000000000000000080000080000000808000800000008000800080800000
              C0C0C000C0DCC000F0CAA600CCFFFF0099FFFF0066FFFF0033FFFF00FFCCFF00
              CCCCFF0099CCFF0066CCFF0033CCFF0000CCFF00FF99FF00CC99FF009999FF00
              6699FF003399FF000099FF00FF66FF00CC66FF009966FF006666FF003366FF00
              0066FF00FF33FF00CC33FF009933FF006633FF003333FF000033FF00CC00FF00
              9900FF006600FF003300FF00FFFFCC00CCFFCC0099FFCC0066FFCC0066FFCC00
              33FFCC0000FFCC00FFCCCC00CCCCCC0099CCCC0066CCCC0033CCCC0000CCCC00
              FF99CC00CC99CC009999CC006699CC003399CC000099CC00FF66CC00CC66CC00
              9966CC006666CC003366CC000066CC00FF33CC00CC33CC009933CC006633CC00
              3333CC000033CC00FF00CC00CC00CC009900CC006600CC003300CC000000CC00
              FFFF9900CCFF990099FF990066FF990033FF990000FF9900FFCC9900CCCC9900
              99CC990066CC990033CC990000CC9900FF999900CC9999009999990066999900
              3399990000999900FF669900CC66990099669900666699003366990000669900
              FF339900CC33990099339900663399003333990000339900FF009900CC009900
              99009900660099003300990000009900FFFF6600CCFF660099FF660066FF6600
              33FF660000FF6600FFCC6600CCCC660099CC660066CC660033CC660000CC6600
              FF996600CC99660099996600669966003399660000996600FF666600CC666600
              99666600666666003366660000666600FF336600CC3366009933660066336600
              3333660000336600FF006600CC00660099006600660066003300660000006600
              FFFF3300CCFF330099FF330066FF330033FF330000FF3300FFCC3300CCCC3300
              99CC330066CC330033CC330000CC3300FF993300CC9933009999330066993300
              3399330000993300FF663300CC66330099663300666633003366330000663300
              FF333300CC33330099333300663333003333330000333300FF003300CC003300
              99003300660033003300330000003300CCFF000099FF000066FF000033FF0000
              FFCC0000CCCC000099CC000066CC000033CC000000CC0000FF990000CC990000
              99990000669900003399000000990000FF660000CC6600009966000066660000
              0066000033660000FF330000CC33000099330000663300003333000000330000
              CC0000009900000066000000330000000000DD000000BB000000AA0000008800
              0000770000005500000044000000220000DD000000BB000000AA000000880000
              00770000005500000044000000220000DDDDDD00555555007777770077777700
              44444400222222001111110077000000550000004400000022000000F0FBFF00
              A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
              FFFFFF000000000000EF000000EFEFEFEFEFEFEF000000000000000000000000
              0000000000000000EFEF0000EFEFEFEFEFEFEFEFEF00000000000000000000ED
              ED00000000000000EFEFEF0000000000EFEFEFEFEFEF00000000000000EDEDEB
              ED00000000000000EFEFEF00ACACAC4FACEF00EFEFEFEF00000000EDEDEBEBEB
              ED0000000000FB0000000000EFEFEFECEC4FAC00EFEFEF0000EDEDEBEBFFEBEB
              ED00000000FBFB0AEB0707F7F75D5DEDED4F4F00EF0000EFEDEBEBEBEBF7FFEB
              ED00000000F1FB00F0EFEFEFECECECECEC4F4FAC00EFEFEFEBEBEBEBEDF7FFEB
              ED0000000000F0F04FFF4FFFA6A6A6A6FF4FACACACEFEFEFEBEBEBEBEDF7FFEB
              ED000000000000F04F4FFFA6A64FFF4F4F4FA6ACAC00EFEFEBEBEBEBEDF7FFEB
              ED000000000000004FA6E4A6A6FF4FFF4F4FA6ACAC00EFEFEFEBEBEBEDF7FFF7
              ED000000000000004FACE4A6A6A64F4FFF4FA64F4F00EFEFEFEFEBEBEDEDF700
              ED000000000000EF4FACE4A6ACA6ACACA6A6ACACAC0000EFEFEFEFEB5D000000
              ED0000000000000000ACE4A6ECECEFEFEFEF00000000FB00EFEFEB00F05DEB00
              ED00000000000000EF002AE4EDED5D5DF7F70707EB0AFBFB00EBEBFFEBEBEB00
              ED0000000000000000004FACECECECECECEFEFEFF000FB00EBEBEBFFEBFFFFEB
              ED00000000000000000000004FACACAC4F00EFEBEB0000EBEBEBEBFFFFF7FFEB
              ED000000000000000000000000000000EF5DEBEBEB00EBEBEBEBEBEBEDF7FFEB
              ED000000000000000000000000FFEBEBEBEBEBEBEBEBEBEBEBEBEBEBEDF7FFEB
              ED000000000000000000000000FFEBEBEBEBEBEBEBEBEBEBEBEBEBEBEDF7FFEB
              ED000000000000000000000000FFEBEBEBEBEBEBEBEBEBEBEBEBEBEBEDF7FFEB
              ED000000000000000000000000FFEBEBEBEBEBEBEBEBEBEBEBEBEBEBEDECEBEB
              ED000000000000000000000000FFEBEBEBEBEBEBEBEBEBEBEBEBEBEBECF7FFFF
              ED000000000000000000000000FFEBEBEBEBEBEBEBEBEBEBEBEBEBFFFFFF0700
              00000000000000000000000000FFEBEBEBEBEBEBEBEBEBEBEBFFFFFF07000000
              00000000000000000000000000FFEBEBEBEBEBEBEBEBEBFFFFFF070000000000
              00000000000000000000000000FFEBEBEBEBEBEBEBFFFFFF0700000000000000
              00000000000000000000000000FFEBEBEBEBEBFFFFFF07000000000000000000
              00000000000000000000000000FFEBEBEBFFFFFF070000000000000000000000
              00000000000000000000000000FFEBFFFFFF0700000000000000000000000000
              00000000000000000000000000FFFFFF07000000000000000000000000000000
              00000000000000000000000000EB070000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000FB80FFE7F3007F83E1003E03C0001803800000030000000380000003
              C0000003E0000003E0000003E0000003E0000003F0000003F0000003F8000003
              FC000003FF000003FF000003FF000003FF000003FF000003FF000003FF000007
              FF00001FFF00007FFF0001FFFF0007FFFF001FFFFF007FFFFF01FFFFFF07FFFF
              FF9FFFFF}
            ExplicitLeft = 16
            ExplicitTop = 20
            ExplicitWidth = 41
          end
        end
        object Panel25: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 63
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel26: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 63
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
          end
          object memReport2: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 369
            Height = 60
            Margins.Top = 0
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Users now have direct '#39'one-click'#39' access to VistaWeb '
              'and RDV from the CPRS Toolbar.  You no longer have '
              'to change your Remote Data Tool settings.')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object Panel27: TPanel
        Left = 0
        Top = 81
        Width = 656
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Panel28: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Bevel7: TBevel
            AlignWithMargins = True
            Left = 98
            Top = 12
            Width = 555
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblReport1: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 89
            Height = 20
            Align = alLeft
            Caption = 'Individual Reports'
            TabOrder = 0
          end
        end
        object Panel29: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 63
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgReport1: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Center = True
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
              0000000000006666666666666666660000000000606007777777777777777700
              000000006660700FFFFFFFFFFFFFF7000000000066608F7FFFFFFFFFFFFFF700
              00000000666077FFFFFFFFFFFFFFF70000000000666077FFF444F44F444FF700
              000000006660700FFFFFFFFFFFFFF7000000000066608F7FF444F44F444FF700
              00000000666077FFFFFFFFFFFFFFF70000000000666077FFF444F44F444FF700
              000000006660700FFFFFFFFFFFFFF7000000000066608F7FF444F44F444FF700
              00000000666077FFFFFFFFFFFFFFF70000000000666077FFF444F44F444FF700
              000000006660700FFFFFFFFFFFFFF7000000000066608F7FF444000000000000
              00000000666077FFFFFF7FF8FF8FF8FF8FF00000666077FFF4447FF8FF8FF8FF
              8FF000006660700FFFFF7888888888888880000066608F7FFFFF7FF8FF8FF8FF
              8FF00000666077FFFFFF7FF8FF8FF8FF8FF0000066607FFFFFFF788888888111
              188000006660777777777FF8FF8FF1FF1FF000006660000000007FF8FF8FF1FF
              1FF00000660000000000788888888111188000006600000000007FF8FF8FF8FF
              8FF000006600000000007FF8FF8FF8FF8FF00000660000000000744444447777
              7770000060000000000074444444777777700000000000000000777777777777
              7770000000000000000000007777000000000000F00001FFE00001FF400001FF
              000001FF000001FF000001FF000001FF000001FF000001FF000001FF000001FF
              000001FF000001FF000001FF000001FF000001FF0000000F0000000F0000000F
              0000000F0000000F0000000F0000000F0000000F1FF0000F3FF0000F3FF0000F
              3FF0000F3FF0000F7FF0000FFFF0000FFFFF0FFF280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              000080000080000000808000800000008000800080800000C0C0C00080808000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
              00000000000000000000000000000007777777008000008F74444F008F000707
              FFFFFF008FFF778F74444F008FFF7707FFFFFF008FFF778F74444F008FFF7707
              FF0000008FFF778F787777008FFF770F8F7F77708FFF78088FF0007008FF7800
              8F707F70008880008FF0F7F00000000008FFFF000000000000888800FFFF0000
              FE0100007C010000380100000001000000010000000100000001000000010000
              00010000000000000200000083000000C7000000FF810000FFC30000}
            ExplicitLeft = 16
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel30: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 63
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel31: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 63
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnReport1: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              Align = alTop
              Caption = 'Set Individual Report...'
              TabOrder = 0
              OnClick = btnReport1Click
            end
          end
          object memReport1: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 369
            Height = 60
            Margins.Top = 0
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Change the individual date range and occurrence limits '
              'for each report on the CPRS Reports tab (excluding '
              'health summary reports) .')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object Panel32: TPanel
        Left = 0
        Top = 0
        Width = 656
        Height = 81
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel33: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Bevel8: TBevel
            AlignWithMargins = True
            Left = 64
            Top = 12
            Width = 589
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblReports: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 55
            Height = 20
            Align = alLeft
            Caption = 'All Reports'
            TabOrder = 0
          end
        end
        object Panel34: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 55
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgReports: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Center = True
            Picture.Data = {
              055449636F6E0000010001002020100000000000E80200001600000028000000
              2000000040000000010004000000000080020000000000000000000000000000
              0000000000000000000080000080000000808000800000008000800080800000
              80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
              FFFFFF0000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000070000000000000007000
              00000000000008FFFFFFFFFFFFFF07000000000000007888888888888888F070
              0000000000000FFFFFFFFFFFFFFF77070000000000007888888888888888F770
              7000000000000FFFFFFFFFFFFFFF77770700000000007888888888888888F777
              7070000000000FFFFFFFFFFFFFFF887777070000000078888888888888888888
              77707000080007FFFFFF888888888888887077000787707FFFF800FF00008888
              8880777008887807FFF0F80FF808F888888077770FFF78807FF08F80FFF08FFF
              888000000777777707FF08F0FF0008FFF880000008887887807FF008FFFF08FF
              FF8000000FFF7FF78807FFFFFFFFFFFFFF800000077777777770000000000000
              00000000088878878878878878870807777000000FFF7FF7FF7F87F87F870807
              7777000007777777777777777777080777777000088878878878878878870807
              777777000FFF7FF7FF7FF7FF7FF7080777777000044444444444444444440800
              00000000044444444444FF4FF4F4040000000000044444444444444444440400
              0000000000000000000000000000040000000000044444444444444444444000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000FFFFFFFFFFFFFFFFFFFFFFFFF7FFF7FFF80003FFF00001FFF80000FF
              F000007FF800003FF000001FF800000FF0000007B80000038000000180000000
              8000000F8000000F8000000F8000000F8000000F8000021F8000020F80000207
              8000020380000207800003FF800003FF800003FF800003FF800007FFFFFFFFFF
              FFFFFFFF}
            ExplicitTop = 35
            ExplicitWidth = 41
          end
        end
        object Panel35: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 55
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object Panel36: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 55
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 0
            object btnReports: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              Align = alTop
              Caption = 'Set All Reports...'
              TabOrder = 0
              OnClick = btnReportsClick
            end
          end
          object memReports: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 369
            Height = 52
            Margins.Top = 0
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Change the default date range and occurrence limits '
              'for all reports on the CPRS Reports tab '
              '(excluding health summary reports) .')
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
    end
    object tsGraphs: TTabSheet
      Caption = 'Graphs'
      ImageIndex = 6
      ExplicitHeight = 431
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 656
        Height = 81
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel8: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Bevel3: TBevel
            AlignWithMargins = True
            Left = 88
            Top = 12
            Width = 565
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblGraphViews: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 79
            Height = 20
            Align = alLeft
            Caption = 'View Definitions'
            TabOrder = 0
          end
        end
        object Panel9: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 55
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgGraphViews: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Center = True
            Picture.Data = {
              055449636F6E0000010001002020100000000000E80200001600000028000000
              2000000040000000010004000000000080020000000000000000000000000000
              0000000000000000000080000080000000808000800000008000800080800000
              80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
              FFFFFF0000000000000070707707070707070700000000000000788888888888
              888888700707070707077878788787887878880007FFFFFFFFFF788787887878
              8787887007F0000000007888888888888888880007F08888888878FFFF8FFFF8
              FFFF887007F08FFFFFFF7878787878787878780007F08F999999788888888888
              8888887007F08FFFFFFF787F0F8FFFF8FFFF880007F08BBBBBBB78FFFF8FFFF8
              FFFF887007F08F222222787F7F8FFFF8FFFF880007F08FFFFFFF78FFFF8FFFF8
              FFFF887007F08FFFFFFF787F0F8FFFF8FFFF880007FFFFFFFFFF78FFFF8FFFF8
              FFFF887007FFFFFFFFFF787F7F8FFFF8FFFF880007FFFFFFFFFF78FFFF8FFFF8
              FFFF887007F000000000787F0F8FFFF87F0F880007F08888888878FFFF8FFFF8
              FFFF887007F08FFFFFFF787F7F87F0F87F0F880007F08F9FFFFF78FFFF8FFFF8
              FFFF887007F08F9FFFFF7888888888888888880007F08FF9FFFF787878878788
              7878887007F08FF9FFFF7777777777777777770007F08FFF9FFFFFFFF9FFFF9F
              FFF0000007F08FFF9FFFFFFF9FFFFFF9FFF0000007F08FFFF9FFFF99FFFFFFFF
              9FF7000007F08FFFF9FF99FFFFFFFFFFF9F0000007F08FFFFF99FFFFFFFFFFFF
              FFF7000007F08FFFFFFFFFFFFFFFFFFFFFF0000007FFFFFFFFFFFFFFFFFFFFFF
              FFF7000007777777777777777777777777700000000000000000000000000000
              00000000FFF00001FFF000018000000180000001800000018000000180000001
              8000000180000001800000018000000180000001800000018000000180000001
              8000000180000001800000018000000180000001800000018000000180000001
              8000000F8000000F8000000F8000000F8000000F8000000F8000000F8000000F
              FFFFFFFF}
            ExplicitLeft = 16
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel10: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 55
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object memGraphViews: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 369
            Height = 52
            Margins.Top = 0
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Define collections of data as views. Views are used for '
              'common selections of multiple items.')
            ReadOnly = True
            TabOrder = 0
          end
          object Panel15: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 55
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel15'
            ShowCaption = False
            TabOrder = 1
            object btnGraphViews: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              Align = alTop
              Caption = 'View Definitions...'
              Constraints.MaxHeight = 26
              TabOrder = 0
              OnClick = btnGraphViewsClick
            end
          end
        end
      end
      object Panel11: TPanel
        Left = 0
        Top = 81
        Width = 656
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Panel12: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Bevel4: TBevel
            AlignWithMargins = True
            Left = 88
            Top = 12
            Width = 565
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object lblGraphSettings: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 79
            Height = 20
            Align = alLeft
            Caption = 'Default Settings'
            TabOrder = 0
          end
        end
        object Panel13: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 63
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgGraphSettings: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Center = True
            Picture.Data = {
              055449636F6E0000010001002020100000000000E80200001600000028000000
              2000000040000000010004000000000080020000000000000000000000000000
              0000000000000000000080000080000000808000800000008000800080800000
              80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
              FFFFFF0000000000000000000000000000000000007070707070707070707070
              7070700007FFFFFFFFFFFFFFFFFFFFFFFFFF000007F000000000000000000000
              0000700007F7888788878887888788878888000007FFFFFF9FFFFF9FFFF9FFFF
              FFFF700007FFFFFFFFFFFFFFFFFFFFFFFFFF000007FFFF999999F99970707070
              7070707007FFFFFFFFFFFFFF788888888887878007FFFBBBBBBBBBBB78878787
              88FFFF7707FFFFCCCCCCFCCC78F000088887878007FFFFFFFFFFFFFF77FFFFF7
              88FFFF7707FFFFFFFFFFFFFF78F000088888888007FFFFFFFFFFFFFF77FFFFF7
              8887878707FFFFFFFFFFFFFF78F0000888FFFF7007FFFFFFFFFFFFFF77FFFFF7
              8888888707F000000000000078F000088887878007F788878887888777FFFFF7
              88F0FF7707F7FFFFFFFFFFFF788888888888888007F7FF9FFFFFFFFF77878787
              8787878707F7FF9FFFFFFFFF777777777777777007F7FFF9FFFFFFFFF9F9FFFF
              FFF9700007F7FFF9FFFFFFFF9FF99FFFFF9F000007F7FFFF9FFFFFFF9FFFF9FF
              F99F700007F7FFFF9FFFFFF9FFFFF99F9FFF000007F7FFFFF9FFFF9FFFFFFFF9
              9FFF700007F7FFFFF9FF99FFFFFFFFF9FFFF000007F7FFFFFF999FFFFFFFFFFF
              FFFF700007F7FFFFFFF9FFFFFFFFFFFFFFFF000007FFFFFFFFFFFFFFFFFFFFFF
              FFFF700007777777777777777777777777770000000000000000000000000000
              00000000FFFFFFFF800000078000000780000007800000078000000780000007
              8000000080000000800000008000000080000000800000008000000080000000
              8000000080000000800000008000000080000000800000008000000780000007
              8000000780000007800000078000000780000007800000078000000780000007
              FFFFFFFF}
            ExplicitLeft = 16
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel14: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 63
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 2
          object memGraphSettings: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 369
            Height = 60
            Margins.Top = 0
            TabStop = False
            Align = alClient
            BorderStyle = bsNone
            Color = clBtnFace
            Lines.Strings = (
              'Configure default settings for graphs. Changes can be '
              'made to the types of data displayed and the styles of '
              'presentation. These settings are saved as your default.')
            ReadOnly = True
            TabOrder = 0
          end
          object Panel16: TPanel
            Left = 375
            Top = 0
            Width = 185
            Height = 63
            Align = alRight
            BevelOuter = bvNone
            Caption = 'Panel16'
            ShowCaption = False
            TabOrder = 1
            object btnGraphSettings: TButton
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 179
              Height = 26
              Align = alTop
              Caption = 'Default Graph Settings...'
              Constraints.MaxHeight = 26
              TabOrder = 0
              OnClick = btnGraphSettingsClick
            end
          end
        end
      end
    end
    object tsSurrogates: TTabSheet
      Caption = 'Surrogates'
      ImageIndex = 7
      ExplicitHeight = 431
      object pnlSurrogatesTop: TPanel
        Left = 0
        Top = 0
        Width = 656
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Bevel2: TBevel
            AlignWithMargins = True
            Left = 129
            Top = 12
            Width = 524
            Height = 11
            Margins.Top = 12
            Align = alClient
            Shape = bsTopLine
            ExplicitLeft = 161
            ExplicitTop = 8
            ExplicitWidth = 275
            ExplicitHeight = 2
          end
          object StaticText2: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 120
            Height = 20
            Align = alLeft
            Caption = 'Surrogates Management'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 26
          Width = 96
          Height = 39
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          object imgSurrogates: TImage
            AlignWithMargins = True
            Left = 20
            Top = 3
            Width = 73
            Height = 41
            Margins.Left = 20
            Align = alTop
            Picture.Data = {
              055449636F6E0000010002002020100000000000E80200002600000010101000
              00000000280100000E0300002800000020000000400000000100040000000000
              8002000000000000000000000000000000000000000000000000800000800000
              0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
              00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000003888738337700000000000000000038FBFFFB788B8837
              7000000000000788FBFFFBFFF7FF8B8883700000000007FBFFFBFFFBFF7BFFFB
              888700000000007FFBFFFBFFFB7FFBFFFBF3700000000007FFFBFFFBFFF7FFFB
              FF77770000000007FBFFFBFFFBF7FB7777FFF800000000007FFBFFFBFFF777FB
              FFFBF800000000007BFFFBFFFBFFFBFFFBFFF8000000000007FBFFFBFFFBFFFB
              FFFBF8000000000007FFFBFFFBFFFBFFFBFFF8000000000000000FFBFFFBFFFB
              FFFBF80000000000011110FFFBFFFBFFFBFFF80000111000011110FBFFFBFFFB
              FFFBF800011111000001110FFBFFFBFFFBFFF800091111011110110FFFFFFFFB
              FFFBF800091111011110110000000FFFFBFFF8000991110111101107777777FB
              FFFBF800099111099991110FFBFFFBFFFBFFF80000999077091110FBFFFBFFFB
              FFFBF80000000000099910FFFBFFFBFFFBFFF8000000000000000FFBFFFBFFFB
              FFFBF8000000000007FFFBFFFBFFFBFFFBFFF8000000000007FBFFFBFFFBFFFB
              FFFBF8000000000007FFFBFFFBFFFBFFFBFFF8000000000007FBFFFBFFFBFFFB
              FFFBF80000000000077777777777777777777700000000000000000000000000
              0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFE003FF
              FF00007FFC00001FF800000FF8000007FC000003FE000001FE000001FF000001
              FF000001FF800001FF800001FF800001C7000001830000010000000100000001
              00000001000000010000000180000001C7000001FF800001FF800001FF800001
              FF800001FF800001FF800001FFFFFFFFFFFFFFFF280000001000000020000000
              0100040000000000C00000000000000000000000000000000000000000000000
              000080000080000000808000800000008000800080800000C0C0C00080808000
              0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
              00000000000000000000000000087B77088800000008FFFBF0B7880000008BFF
              FB0FB78000008FFBFF0F0080000008FFFB80FB700000000BFFFBFF7000000660
              FBFFFB7006600060FFFBFF700E60E06000FFFB700EE00EE0FFFBFF700000000F
              FBFFFB70000008FBFFFBFF7000000888888888800000000000000000FFFF0000
              F00F0000E0030000E0010000F0000000F0000000F8000000F800000090000000
              00000000000000000000000098000000F8000000F8000000FFFF0000}
            ExplicitLeft = 24
            ExplicitTop = 22
            ExplicitWidth = 41
          end
        end
        object Panel17: TPanel
          Left = 96
          Top = 26
          Width = 560
          Height = 39
          Align = alClient
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 2
          object txtSurrogatesManagement: TStaticText
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 554
            Height = 17
            Margins.Top = 0
            Align = alTop
            Caption = 'Change the surrogates settings of the VistA account.'
            TabOrder = 0
          end
        end
      end
      object pnlSurrogates: TPanel
        Left = 0
        Top = 65
        Width = 656
        Height = 445
        Align = alClient
        BevelOuter = bvNone
        Caption = '"Canvas" for TfrmOptionsSurrogate'
        Color = clSilver
        ParentBackground = False
        TabOrder = 1
        ExplicitHeight = 366
      end
    end
    object tsCopyPaste: TTabSheet
      Caption = 'Copy/Paste'
      ImageIndex = 7
      ExplicitHeight = 431
      object bvlCopyPasteTitle: TBevel
        AlignWithMargins = True
        Left = 100
        Top = 26
        Width = 532
        Height = 2
        Margins.Left = 100
        Margins.Right = 24
        Align = alTop
        Shape = bsTopLine
        ExplicitLeft = 3
        ExplicitTop = 35
        ExplicitWidth = 650
      end
      object ImgCopyPaste: TImage
        Left = 16
        Top = 32
        Width = 41
        Height = 41
        Margins.Left = 20
        Picture.Data = {
          07544269746D6170361B0000424D361B00000000000036000000280000003000
          0000300000000100180000000000001B00000000000000000000000000000000
          0000FF00FFD9D9D9DCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCD9D9D9
          D8D8D8D9D9D9DCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCD9D9D9D8D8
          D8D9D9D9DCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCD9D9D9D8D8D8D9
          D9D9DCDCDCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD6D6D60101010202020000000000
          0000000000000000000000000000000002020203030302020200000000000000
          0000000000000000000000000000020202030303020202000000000000000000
          000000000000000000000000020202030303020202FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFD6D6D6010101141414424242434343434343434343434343434343434343
          4343434242424242424242424343434343434343434343434343434343434343
          4342424242424242424243434343434343434343434343434343434343434310
          1111040404DDDDDDFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737050505D6D6D6FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFD6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37
          3737000000C8C9C9D9D9D9DADCDCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFDADCDCDCDCDCFF00FFFF00FFFF00FFD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF3737370000001515150606060708080606
          06000000000000000000000000000000000000000000050505040404020202BE
          BEBED6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37
          37370000003E3E3E323232323434333333323434323232323232323232323232
          323232323232323232141414030303BCBCBCD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F020202BB
          BBBBD6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37
          3737000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5F5F5F000000BCBCBCD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F000000BE
          BEBED6D6D6010101474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF38
          3838000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5F5F5F000000BEBEBED6D6D6010101474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF383838060606FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F000000BE
          BEBED6D6D6010101464646FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF38
          3838070808D5D5D5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5F5F5F000000BEBEBED6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737060606D1D2D2FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F000000BE
          BEBED6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37
          3737000000D5D5D5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5D5D5D000000BEBEBED6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5E5E020202BE
          BEBED6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37
          3737000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5D5D5D030303BCBCBCD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F020202BB
          BBBBD6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37
          3737000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5F5F5F000000BCBCBCD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F000000BE
          BEBED6D6D6010101474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF38
          3838000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5F5F5F000000BEBEBED6D6D6010101474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF383838060606FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F000000BE
          BEBED6D6D6010101464646FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF38
          3838070808D5D5D5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5F5F5F000000BEBEBED6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737060606D1D2D2FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F000000BE
          BEBED6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37
          3737000000D5D5D5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5D5D5D000000BEBEBED6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5C5E5E020202BE
          BEBED6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37
          3737000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5D5D5D030303BCBCBCD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F020202BB
          BBBBD6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37
          3737000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5F5F5F000000BCBCBCD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF373737000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F000000BE
          BEBED6D6D6010101474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8283
          8360606065656565656565656565656565656565656565656560606060606019
          1919000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5F5F5F000000BEBEBED6D6D6010101474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF3F3F3F070808060606000000000000000000
          0000000000000000000000000606060708085D5F5FFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F000000BE
          BEBED6D6D6010101464646FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF3F3F
          3F0606065D5D5D8081818686868787878787878787874A4A4A0000000000005C
          5E5EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF5F5F5F000000BEBEBED6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF3F3F3F000000AAABABFF00FFFF00FFFF00FF
          FF00FFC3C3C30C0C0C000000555555FF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5F5F5F000000BE
          BEBED6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF3F3F
          3F000000B5B5B5FF00FFFF00FFFF00FFC1C1C10C0C0C000000545454FF00FFFF
          00FFFF00FFFF00FFA0A0A06F6F6F767676767676767676767676767676767676
          7676766F6F6F7070702D2D2D000000BEBEBED6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF3F3F3F000000B7B7B7FF00FFFF00FFB3B4B4
          101111000000545454FF00FFFF00FFFF00FFFF00FFFF00FF6363630708080606
          060000000000000000000000000000000000000000000505050404043D3D3DFF
          00FFD6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF3F3F
          3F000000B7B7B7FF00FFC0C0C0101111070808525252FF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FF6767670606064A4A4A808181868686878787878787878787
          5F5F5F000000000000383838FF00FFFF00FFD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF3F3F3F000000B7B7B7C1C1C10B0B0B000000
          525252E3E4E4FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6767670000008687
          87FF00FFFF00FFFF00FFFF00FFFF00FF1F1F1F0000002F2F2FFF00FFFF00FFFF
          00FFD6D6D6000000474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF3F3F
          3F0000006F6F6F0707070000005F5F5FFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FF6767670000008E8E8EFF00FFFF00FFFF00FFDEDEDE202020
          000000303030FF00FFFF00FFFF00FFFF00FFD6D6D6000000474747FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF3F3F3F000000000000000000545454FF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6767670000008F8F
          8FFF00FFFF00FFCDCDCD232323000000303030FF00FFFF00FFFF00FFFF00FFFF
          00FFD6D6D6010101474747FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF3E3F
          3F060606000000545454FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FF6767670000008F8F8FFF00FFDFDFDF232323070808313333
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD6D6D60101011C1C1C6565656565
          6565656565656565656565656565656560606060606060606065656565656565
          65656565656565656565656565651C1C1C0708085A5C5CFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6767670000008F8F
          8FFF00FF202020000000313333D8D8D8FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFD6D6D6010101030303030404000000000000000000000000000000000000
          0000000606060708080606060000000000000000000000000000000000000000
          00515151E3E4E4FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FF676767000000727272212121000000313131FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFBABABAB5B5B5B1B2B2AFB0
          B0B9B9B9BABABABABABABABABABABABABABABAB9B9B9AFB0B0AEAEAEAFB0B031
          3131424242BABABABABABABABABABCBCBCFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6363630000000000
          000000003C3C3CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF0304041F1F1FFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FF636363030404000000323232FF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF03
          03030D0D0D656565656565656565656565656565656565656565636363626464
          636363656565656565656565656565656565656565656565282A2A0303033D3D
          3DFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF0101010101010101010000000000000000
          0000000000000000000000000001010101010101010100000000000000000000
          0000000000000000000000373737FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFBA
          BABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABA
          BABABABABABABABABABABABABABABABABABABABABABABABABABABAFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF}
        Proportional = True
        Transparent = True
      end
      object lblCopyPaste: TStaticText
        AlignWithMargins = True
        Left = 6
        Top = 3
        Width = 647
        Height = 17
        Margins.Left = 6
        Align = alTop
        Caption = 'Copy / Paste'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 3
        ExplicitWidth = 650
      end
      object cbkCopyPaste: TCheckBox
        AlignWithMargins = True
        Left = 100
        Top = 33
        Width = 553
        Height = 17
        Margins.Left = 100
        Margins.Top = 2
        Margins.Bottom = 6
        Align = alTop
        Caption = 'Copy/Paste viewing is currently disabled. '
        TabOrder = 1
        OnClick = cbkCopyPasteClick
        ExplicitLeft = 3
        ExplicitTop = 48
        ExplicitWidth = 637
      end
      object pnlCPOptions: TPanel
        Left = 0
        Top = 56
        Width = 656
        Height = 454
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        Visible = False
        ExplicitTop = 0
        ExplicitHeight = 429
        object GroupBox1: TGroupBox
          AlignWithMargins = True
          Left = 100
          Top = 3
          Width = 532
          Height = 122
          Margins.Left = 100
          Margins.Right = 24
          Margins.Bottom = 1
          Align = alTop
          Caption = 'How text is identifed on the note'
          TabOrder = 0
          ExplicitLeft = 16
          ExplicitWidth = 624
          object pnlCPMain: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 522
            Height = 99
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 614
            object Panel1: TPanel
              Left = 0
              Top = 0
              Width = 522
              Height = 99
              Align = alClient
              BevelOuter = bvNone
              Caption = 'Panel1'
              ShowCaption = False
              TabOrder = 0
              ExplicitWidth = 614
              object lblCP: TStaticText
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 516
                Height = 17
                Align = alTop
                Caption = 'Configure visual element(s) for copy / paste'
                TabOrder = 0
                TabStop = True
                ExplicitWidth = 608
              end
              object CopyPasteOptions: TCheckListBox
                AlignWithMargins = True
                Left = 3
                Top = 26
                Width = 161
                Height = 70
                OnClickCheck = CPOptionsClickCheck
                Align = alLeft
                AutoComplete = False
                BevelInner = bvNone
                BevelOuter = bvNone
                BorderStyle = bsNone
                Color = clBtnFace
                Columns = 2
                Items.Strings = (
                  'Bold'
                  'Italics'
                  'Underline'
                  'Highlight')
                Style = lbOwnerDrawFixed
                TabOrder = 1
                OnDrawItem = CPOptionsDrawItem
              end
              object lbCPhighLight: TStaticText
                AlignWithMargins = True
                Left = 170
                Top = 30
                Width = 72
                Height = 17
                Caption = 'Highlight Color'
                TabOrder = 2
                TabStop = True
                Visible = False
              end
              object cpHLColor: TColorBox
                AlignWithMargins = True
                Left = 248
                Top = 26
                Width = 82
                Height = 22
                Style = [cbStandardColors, cbPrettyNames]
                Color = clBtnFace
                TabOrder = 3
                Visible = False
                OnChange = cpHLColorChange
              end
            end
          end
        end
        object GroupBox2: TGroupBox
          AlignWithMargins = True
          Left = 100
          Top = 127
          Width = 532
          Height = 250
          Margins.Left = 100
          Margins.Top = 1
          Margins.Right = 24
          Align = alTop
          Caption = 'Display differences between paste in details section'
          TabOrder = 1
          object pblCPLCS: TPanel
            Left = 2
            Top = 15
            Width = 528
            Height = 233
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 620
            ExplicitHeight = 277
            object CPLCSToggle: TCheckBox
              AlignWithMargins = True
              Left = 8
              Top = 0
              Width = 520
              Height = 50
              Margins.Left = 8
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alTop
              Caption = 
                'Difference Identifier Toggle: In the Pasted Data section, this a' +
                'llows user to view differences between what the author pasted in' +
                'to the note and what was edited.'
              TabOrder = 0
              WordWrap = True
              OnClick = CPLCSToggleClick
              ExplicitWidth = 612
            end
            object pnlCPLCsSub: TPanel
              AlignWithMargins = True
              Left = 3
              Top = 50
              Width = 525
              Height = 183
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              Visible = False
              ExplicitWidth = 617
              ExplicitHeight = 227
              object CPLcsMemo: TMemo
                AlignWithMargins = True
                Left = 8
                Top = 105
                Width = 514
                Height = 48
                Margins.Left = 8
                Align = alBottom
                BorderStyle = bsNone
                Color = clBtnFace
                Lines.Strings = (
                  
                    'Please note that the Difference Identifier process is memory int' +
                    'ensive. '
                  
                    'The default number of characters is set at 5000. Changing this t' +
                    'o a higher number '
                  
                    'may increase the time for the system to display all the differen' +
                    'ces.')
                ReadOnly = True
                TabOrder = 0
                ExplicitTop = 149
                ExplicitWidth = 606
              end
              object CPLCSCOLOR: TColorBox
                AlignWithMargins = True
                Left = 248
                Top = 3
                Width = 82
                Height = 22
                Style = [cbStandardColors, cbPrettyNames]
                Color = clBtnFace
                TabOrder = 1
                Visible = False
                OnChange = CPLCSCOLORChange
              end
              object CPLCSIDENT: TCheckListBox
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 161
                Height = 73
                OnClickCheck = CPLCSIDENTClickCheck
                Align = alLeft
                AutoComplete = False
                BorderStyle = bsNone
                Color = clBtnFace
                Columns = 2
                Items.Strings = (
                  'Bold'
                  'Italics'
                  'Underline'
                  'Text Color')
                Style = lbOwnerDrawFixed
                TabOrder = 2
                OnDrawItem = CPOptionsDrawItem
                ExplicitHeight = 117
              end
              object CPLCSLimit: TEdit
                AlignWithMargins = True
                Left = 3
                Top = 159
                Width = 519
                Height = 21
                Align = alBottom
                TabOrder = 3
                Text = '5000'
                OnKeyPress = CPLCSLimitKeyPress
                ExplicitTop = 203
                ExplicitWidth = 611
              end
              object CPLcsLimitText: TStaticText
                AlignWithMargins = True
                Left = 3
                Top = 82
                Width = 519
                Height = 17
                Align = alBottom
                Caption = 'Character Limit:'
                TabOrder = 4
                TabStop = True
                ExplicitTop = 126
                ExplicitWidth = 611
              end
              object lblTextColor: TStaticText
                AlignWithMargins = True
                Left = 190
                Top = 7
                Width = 52
                Height = 17
                Margins.Top = 2
                Caption = 'Text Color'
                TabOrder = 5
                Visible = False
                ExplicitHeight = 118
              end
            end
          end
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 24
    Top = 544
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnApply'
        'Status = stsDefault')
      (
        'Component = pagOptions'
        'Status = stsDefault')
      (
        'Component = tsCoverSheet'
        'Status = stsDefault')
      (
        'Component = lblCoverReminderDesc'
        'Status = stsDefault')
      (
        'Component = lblCoverReminders'
        'Status = stsDefault')
      (
        'Component = lblCoverDaysDesc'
        'Status = stsDefault')
      (
        'Component = lblCoverDays'
        'Status = stsDefault')
      (
        'Component = lblOtherParameters'
        'Status = stsDefault')
      (
        'Component = lblOtherParametersDesc'
        'Status = stsDefault')
      (
        'Component = btnCoverDays'
        'Status = stsDefault')
      (
        'Component = btnCoverReminders'
        'Status = stsDefault')
      (
        'Component = btnOtherParameters'
        'Status = stsDefault')
      (
        'Component = tsNotifications'
        'Status = stsDefault')
      (
        'Component = lvwNotifications'
        'Status = stsDefault')
      (
        'Component = tsOrderChecks'
        'Status = stsDefault')
      (
        'Component = lblOrderChecks'
        'Status = stsDefault')
      (
        'Component = lvwOrderChecks'
        'Status = stsDefault')
      (
        'Component = tsListsTeams'
        'Status = stsDefault')
      (
        'Component = lblPatientSelectionDesc'
        'Status = stsDefault')
      (
        'Component = lblTeamsDesc'
        'Status = stsDefault')
      (
        'Component = lblPatientSelection'
        'Status = stsDefault')
      (
        'Component = lblTeams'
        'Status = stsDefault')
      (
        'Component = btnPatientSelection'
        'Status = stsDefault')
      (
        'Component = btnPersonalLists'
        'Status = stsDefault')
      (
        'Component = btnTeams'
        'Status = stsDefault')
      (
        'Component = btnCombinations'
        'Status = stsDefault')
      (
        'Component = btnDiagnoses'
        'Status = stsDefault')
      (
        'Component = tsNotes'
        'Status = stsDefault')
      (
        'Component = lblNotesNotesDesc'
        'Status = stsDefault')
      (
        'Component = lblNotesTitlesDesc'
        'Status = stsDefault')
      (
        'Component = lblNotesNotes'
        'Status = stsDefault')
      (
        'Component = lblNotesTitles'
        'Status = stsDefault')
      (
        'Component = btnNotesNotes'
        'Text = Configure defaults for editing and saving notes.'
        'Status = stsOK')
      (
        'Component = btnRequiredFields'
        'Status = stsDefault')
      (
        'Component = tsCprsReports'
        'Status = stsDefault')
      (
        'Component = memReports'
        'Status = stsDefault')
      (
        'Component = memReport1'
        'Status = stsDefault')
      (
        'Component = lblReports'
        'Status = stsDefault')
      (
        'Component = lblReport1'
        'Status = stsDefault')
      (
        'Component = btnReports'
        'Status = stsDefault')
      (
        'Component = btnReport1'
        'Status = stsDefault')
      (
        'Component = lblReport2'
        'Status = stsDefault')
      (
        'Component = memReport2'
        'Status = stsDefault')
      (
        'Component = tsGraphs'
        'Status = stsDefault')
      (
        'Component = lblGraphSettings'
        'Status = stsDefault')
      (
        'Component = btnGraphSettings'
        'Status = stsDefault')
      (
        'Component = lblGraphViews'
        'Status = stsDefault')
      (
        'Component = btnGraphViews'
        'Status = stsDefault')
      (
        'Component = memGraphSettings'
        'Status = stsDefault')
      (
        'Component = memGraphViews'
        'Status = stsDefault')
      (
        'Component = frmOptions'
        'Status = stsDefault')
      (
        'Component = tsSurrogates'
        'Status = stsDefault')
      (
        'Component = pnlSurrogatesTop'
        'Status = stsDefault')
      (
        'Component = StaticText2'
        'Status = stsDefault')
      (
        'Component = txtSurrogatesManagement'
        
          'Text = Surrogate Management. Change the settings of the VistA ac' +
          'count.'
        'Status = stsOK')
      (
        'Component = pnlNotificationsList'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = lblNotifications'
        'Status = stsDefault')
      (
        'Component = lblNotificationsOptions'
        'Status = stsDefault')
      (
        'Component = chkNotificationsFlagged'
        'Status = stsDefault')
      (
        'Component = btnProcessedAlertsSettings'
        'Status = stsDefault')
      (
        'Component = pnlSurrogates'
        'Status = stsDefault')
      (
        'Component = pnlNotificationTools'
        'Status = stsDefault')
      (
        'Component = Button1'
        'Status = stsDefault')
      (
        'Component = Button2'
        'Status = stsDefault')
      (
        'Component = btnNotificationsRemove'
        'Status = stsDefault')
      (
        'Component = tsCopyPaste'
        'Status = stsDefault')
      (
        'Component = GroupBox1'
        'Status = stsDefault')
      (
        'Component = pnlCPMain'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = lblCP'
        'Status = stsDefault')
      (
        'Component = CopyPasteOptions'
        'Status = stsDefault')
      (
        'Component = lbCPhighLight'
        'Status = stsDefault')
      (
        'Component = cpHLColor'
        'Status = stsDefault')
      (
        'Component = GroupBox2'
        'Status = stsDefault')
      (
        'Component = pblCPLCS'
        'Status = stsDefault')
      (
        'Component = CPLCSToggle'
        'Status = stsDefault')
      (
        'Component = pnlCPLCsSub'
        'Status = stsDefault')
      (
        'Component = CPLcsMemo'
        'Status = stsDefault')
      (
        'Component = CPLCSCOLOR'
        'Status = stsDefault')
      (
        'Component = CPLCSIDENT'
        'Status = stsDefault')
      (
        'Component = CPLCSLimit'
        'Status = stsDefault')
      (
        'Component = CPLcsLimitText'
        'Status = stsDefault')
      (
        'Component = lblTextColor'
        'Status = stsDefault')
      (
        'Component = pnlCPOptions'
        'Status = stsDefault')
      (
        'Component = lblCopyPaste'
        'Status = stsDefault')
      (
        'Component = cbkCopyPaste'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = Panel7'
        'Status = stsDefault')
      (
        'Component = Panel8'
        'Status = stsDefault')
      (
        'Component = Panel9'
        'Status = stsDefault')
      (
        'Component = Panel10'
        'Status = stsDefault')
      (
        'Component = Panel11'
        'Status = stsDefault')
      (
        'Component = Panel12'
        'Status = stsDefault')
      (
        'Component = Panel13'
        'Status = stsDefault')
      (
        'Component = Panel14'
        'Status = stsDefault')
      (
        'Component = Panel15'
        'Status = stsDefault')
      (
        'Component = Panel16'
        'Status = stsDefault')
      (
        'Component = Panel22'
        'Status = stsDefault')
      (
        'Component = Panel23'
        'Status = stsDefault')
      (
        'Component = Panel24'
        'Status = stsDefault')
      (
        'Component = Panel25'
        'Status = stsDefault')
      (
        'Component = Panel26'
        'Status = stsDefault')
      (
        'Component = Panel27'
        'Status = stsDefault')
      (
        'Component = Panel28'
        'Status = stsDefault')
      (
        'Component = Panel29'
        'Status = stsDefault')
      (
        'Component = Panel30'
        'Status = stsDefault')
      (
        'Component = Panel31'
        'Status = stsDefault')
      (
        'Component = Panel32'
        'Status = stsDefault')
      (
        'Component = Panel33'
        'Status = stsDefault')
      (
        'Component = Panel34'
        'Status = stsDefault')
      (
        'Component = Panel35'
        'Status = stsDefault')
      (
        'Component = Panel36'
        'Status = stsDefault')
      (
        'Component = pnlTIU'
        'Status = stsDefault')
      (
        'Component = Panel38'
        'Status = stsDefault')
      (
        'Component = Panel39'
        'Status = stsDefault')
      (
        'Component = Panel40'
        'Status = stsDefault')
      (
        'Component = Panel41'
        'Status = stsDefault')
      (
        'Component = pnlNoteTop'
        'Status = stsDefault')
      (
        'Component = Panel43'
        'Status = stsDefault')
      (
        'Component = Panel44'
        'Status = stsDefault')
      (
        'Component = Panel45'
        'Status = stsDefault')
      (
        'Component = Panel46'
        'Status = stsDefault')
      (
        'Component = Panel47'
        'Status = stsDefault')
      (
        'Component = Panel48'
        'Status = stsDefault')
      (
        'Component = StaticText5'
        'Status = stsDefault')
      (
        'Component = Panel49'
        'Status = stsDefault')
      (
        'Component = Panel50'
        'Status = stsDefault')
      (
        'Component = Memo3'
        'Status = stsDefault')
      (
        'Component = Panel51'
        'Status = stsDefault')
      (
        'Component = Panel42'
        'Status = stsDefault')
      (
        'Component = Panel52'
        'Status = stsDefault')
      (
        'Component = Panel53'
        'Status = stsDefault')
      (
        'Component = Panel54'
        'Status = stsDefault')
      (
        'Component = Panel55'
        'Status = stsDefault')
      (
        'Component = Panel56'
        'Status = stsDefault')
      (
        'Component = Panel57'
        'Status = stsDefault')
      (
        'Component = Panel58'
        'Status = stsDefault')
      (
        'Component = Panel59'
        'Status = stsDefault')
      (
        'Component = Panel60'
        'Status = stsDefault')
      (
        'Component = Panel61'
        'Status = stsDefault')
      (
        'Component = Panel62'
        'Status = stsDefault')
      (
        'Component = Panel63'
        'Status = stsDefault')
      (
        'Component = Panel64'
        'Status = stsDefault')
      (
        'Component = Panel65'
        'Status = stsDefault')
      (
        'Component = Panel66'
        'Status = stsDefault')
      (
        'Component = Panel67'
        'Status = stsDefault')
      (
        'Component = Panel68'
        'Status = stsDefault')
      (
        'Component = Panel69'
        'Status = stsDefault')
      (
        'Component = Panel70'
        'Status = stsDefault')
      (
        'Component = Panel71'
        'Status = stsDefault')
      (
        'Component = Panel72'
        'Status = stsDefault')
      (
        'Component = Panel73'
        'Status = stsDefault')
      (
        'Component = Panel74'
        'Status = stsDefault')
      (
        'Component = Panel75'
        'Status = stsDefault')
      (
        'Component = Panel76'
        'Status = stsDefault')
      (
        'Component = Panel77'
        'Status = stsDefault')
      (
        'Component = Panel78'
        'Status = stsDefault')
      (
        'Component = Panel79'
        'Status = stsDefault')
      (
        'Component = Panel80'
        'Status = stsDefault')
      (
        'Component = pnlNotifications'
        'Status = stsDefault')
      (
        'Component = Panel82'
        'Status = stsDefault')
      (
        'Component = Panel83'
        'Status = stsDefault')
      (
        'Component = Panel84'
        'Status = stsDefault')
      (
        'Component = Panel85'
        'Status = stsDefault')
      (
        'Component = Panel17'
        'Status = stsDefault')
      (
        'Component = btnNotesTitles'
        'Status = stsDefault'))
  end
end
