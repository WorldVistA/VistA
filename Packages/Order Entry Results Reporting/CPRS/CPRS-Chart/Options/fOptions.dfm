inherited frmOptions: TfrmOptions
  Left = 315
  Top = 110
  Height = 397
  HelpContext = 9999
  VertScrollBar.Range = 360
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Options'
  Font.Name = 'Tahoma'
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 443
  ExplicitHeight = 397
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 339
    Width = 437
    Height = 30
    HelpContext = 9999
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object btnOK: TButton
      Left = 187
      Top = 2
      Width = 75
      Height = 22
      HelpContext = 9007
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnApplyClick
    end
    object btnCancel: TButton
      Left = 267
      Top = 2
      Width = 75
      Height = 22
      HelpContext = 9008
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnApply: TButton
      Left = 347
      Top = 2
      Width = 75
      Height = 22
      HelpContext = 9009
      Caption = 'Apply'
      Enabled = False
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
  object pnlMain: TPanel [1]
    Left = 0
    Top = 0
    Width = 437
    Height = 339
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object pagOptions: TPageControl
      Left = 5
      Top = 5
      Width = 427
      Height = 329
      HelpContext = 9999
      ActivePage = tsCoverSheet
      Align = alClient
      TabOrder = 0
      OnEnter = pagOptionsEnter
      object tsCoverSheet: TTabSheet
        HelpContext = 9700
        Caption = 'General'
        DesignSize = (
          419
          301)
        object bvlCoverDays: TBevel
          Left = 125
          Top = 16
          Width = 275
          Height = 2
        end
        object bvlCoverReminders: TBevel
          Left = 112
          Top = 102
          Width = 288
          Height = 2
        end
        object imgCoverDays: TImage
          Left = 16
          Top = 27
          Width = 41
          Height = 41
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
        end
        object imgCoverReminders: TImage
          Left = 16
          Top = 115
          Width = 41
          Height = 41
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
        end
        object bvlOtherParameters: TBevel
          Left = 115
          Top = 185
          Width = 288
          Height = 2
        end
        object imgOtherParameters: TImage
          Left = 15
          Top = 197
          Width = 41
          Height = 41
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
        end
        object lblCoverReminderDesc: TMemo
          Left = 125
          Top = 115
          Width = 275
          Height = 67
          TabStop = False
          Anchors = [akLeft, akTop, akRight]
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Configure and arrange which clinical reminders are '
            'displayed on your cover sheet.')
          ReadOnly = True
          TabOrder = 3
        end
        object lblCoverReminders: TStaticText
          Left = 13
          Top = 95
          Width = 90
          Height = 17
          Caption = 'Clinical Reminders'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object lblCoverDaysDesc: TMemo
          Left = 125
          Top = 27
          Width = 275
          Height = 70
          TabStop = False
          Anchors = [akLeft, akTop, akRight]
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Change the default date ranges for displaying patient '
            'information on your cover sheet.')
          ReadOnly = True
          TabOrder = 5
        end
        object lblCoverDays: TStaticText
          Left = 13
          Top = 9
          Width = 102
          Height = 17
          Caption = 'Date Range defaults'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object lblOtherParameters: TStaticText
          Left = 12
          Top = 177
          Width = 86
          Height = 17
          Caption = 'Other Parameters'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object lblOtherParametersDesc: TMemo
          Left = 124
          Top = 195
          Width = 275
          Height = 78
          TabStop = False
          Anchors = [akLeft, akTop, akRight]
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Configure chart tab setting.'
            ''
            'Change display date range on Meds tab.'
            ''
            'Change Encounter Appointments date range.')
          TabOrder = 8
        end
        object btnCoverDays: TButton
          Left = 255
          Top = 67
          Width = 145
          Height = 22
          HelpContext = 9001
          Anchors = [akTop, akRight]
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
        object btnCoverReminders: TButton
          Left = 255
          Top = 150
          Width = 145
          Height = 22
          HelpContext = 9002
          Anchors = [akTop, akRight]
          Caption = '&Clinical Reminders...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnCoverRemindersClick
        end
        object btnOtherParameters: TButton
          Left = 254
          Top = 269
          Width = 145
          Height = 22
          HelpContext = 9003
          Anchors = [akTop, akRight]
          Caption = '&Other Parameters...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnOtherParametersClick
        end
      end
      object tsNotifications: TTabSheet
        HelpContext = 9030
        Caption = 'Notifications'
        object bvlNotifications: TBevel
          Left = 88
          Top = 16
          Width = 312
          Height = 2
        end
        object imgNotifications: TImage
          Left = 16
          Top = 28
          Width = 41
          Height = 41
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
        end
        object lblNotificationView: TLabel
          Left = 10
          Top = 118
          Width = 349
          Height = 13
          Caption = 
            'You can turn on or off these notifications except those that are' +
            ' mandatory.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblNotificationsOptions: TStaticText
          Left = 125
          Top = 27
          Width = 164
          Height = 17
          Caption = 'Change your notification options.'
          TabOrder = 4
        end
        object lblNotifications: TStaticText
          Left = 13
          Top = 9
          Width = 62
          Height = 17
          Caption = 'Notifications'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object lblNotificationsSurrogate: TStaticText
          Left = 9
          Top = 100
          Width = 53
          Height = 17
          Caption = 'Surrogate:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object lblNotificationsSurrogateText: TStaticText
          Left = 60
          Top = 100
          Width = 130
          Height = 17
          Caption = '<no surrogate designated>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object lvwNotifications: TCaptionListView
          Left = 0
          Top = 142
          Width = 419
          Height = 159
          HelpContext = 9035
          Align = alBottom
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
          TabOrder = 3
          ViewStyle = vsReport
          OnChange = lvwNotificationsChange
          OnColumnClick = lvwNotificationsColumnClick
          OnCompare = lvwNotificationsCompare
          OnDblClick = lvwNotificationsDblClick
          OnEnter = lvwNotificationsEnter
          OnMouseDown = lvwNotificationsMouseDown
          Caption = 
            'You can turn on or off these notifications except those that are' +
            ' mandatory.'
        end
        object btnNotificationsRemove: TButton
          Left = 191
          Top = 73
          Width = 160
          Height = 22
          HelpContext = 9031
          Caption = '&Remove Pending Notifications...'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnNotificationsRemoveClick
        end
        object chkNotificationsFlagged: TCheckBox
          Left = 88
          Top = 50
          Width = 241
          Height = 16
          HelpContext = 9032
          Caption = 'Send me a MailMan bulletin for flagged orders'
          TabOrder = 0
          OnClick = chkNotificationsFlaggedClick
        end
        object btnSurrogate: TButton
          Left = 8
          Top = 73
          Width = 120
          Height = 22
          HelpContext = 9033
          Caption = 'Surrogate Settings...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnSurrogateClick
        end
      end
      object tsOrderChecks: TTabSheet
        HelpContext = 9040
        Caption = 'Order Checks'
        ImageIndex = 3
        object lblOrderChecksDesc: TLabel
          Left = 125
          Top = 27
          Width = 275
          Height = 30
          AutoSize = False
          Caption = 'Enable or disable your order checks.'
          WordWrap = True
        end
        object bvlOrderChecks: TBevel
          Left = 88
          Top = 16
          Width = 312
          Height = 2
        end
        object imgOrderChecks: TImage
          Left = 16
          Top = 27
          Width = 41
          Height = 41
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
        end
        object lblOrderChecksView: TLabel
          Left = 13
          Top = 68
          Width = 349
          Height = 13
          Caption = 
            'You can turn on or off these notifications except those that are' +
            ' mandatory.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblOrderChecks: TStaticText
          Left = 13
          Top = 9
          Width = 69
          Height = 17
          Caption = 'Order Checks'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object lvwOrderChecks: TCaptionListView
          Left = 0
          Top = 93
          Width = 419
          Height = 208
          HelpContext = 9041
          Align = alBottom
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
          Caption = 
            'You can turn on or off these notifications except those that are' +
            ' mandatory.'
        end
      end
      object tsListsTeams: TTabSheet
        HelpContext = 9050
        Caption = 'Lists/Teams'
        ImageIndex = 4
        object bvlPatientSelection: TBevel
          Left = 144
          Top = 16
          Width = 256
          Height = 2
        end
        object imgPatientSelection: TImage
          Left = 16
          Top = 28
          Width = 41
          Height = 41
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
        end
        object bvlTeams: TBevel
          Left = 144
          Top = 155
          Width = 256
          Height = 2
        end
        object imgTeams: TImage
          Left = 16
          Top = 168
          Width = 41
          Height = 41
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
        end
        object lblPatientSelectionDesc: TMemo
          Left = 125
          Top = 27
          Width = 275
          Height = 78
          TabStop = False
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Change the defaults for selecting patients. If your List '
            'Source is Combination, the criteria is defined using '
            'Source Combinations.')
          ReadOnly = True
          TabOrder = 7
        end
        object lblTeamsDesc: TMemo
          Left = 125
          Top = 168
          Width = 275
          Height = 73
          TabStop = False
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Edit your personal lists of patients and diagnoses. View '
            'the teams you are on and the patients associated with '
            'those teams.')
          ReadOnly = True
          TabOrder = 8
        end
        object lblPatientSelection: TStaticText
          Left = 13
          Top = 9
          Width = 124
          Height = 17
          Caption = 'Patient Selection defaults'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object lblTeams: TStaticText
          Left = 13
          Top = 148
          Width = 125
          Height = 17
          Caption = 'Personal Lists and Teams'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object btnPatientSelection: TButton
          Left = 255
          Top = 84
          Width = 145
          Height = 22
          HelpContext = 9051
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
        object btnPersonalLists: TButton
          Left = 255
          Top = 210
          Width = 145
          Height = 22
          HelpContext = 9052
          Caption = 'Personal &Lists...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnPersonalListsClick
        end
        object btnTeams: TButton
          Left = 255
          Top = 266
          Width = 145
          Height = 22
          HelpContext = 9053
          Caption = '&Teams Information...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = btnTeamsClick
        end
        object btnCombinations: TButton
          Left = 255
          Top = 117
          Width = 145
          Height = 22
          HelpContext = 9054
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
        object btnDiagnoses: TButton
          Left = 256
          Top = 237
          Width = 145
          Height = 22
          Caption = 'Personal &Diagnoses List...'
          TabOrder = 3
          OnClick = btnDiagnosesClick
        end
      end
      object tsNotes: TTabSheet
        HelpContext = 9200
        Caption = 'Notes'
        ImageIndex = 4
        DesignSize = (
          419
          301)
        object bvlNotesNotes: TBevel
          Left = 88
          Top = 16
          Width = 312
          Height = 2
        end
        object bvlNotesTitles: TBevel
          Left = 112
          Top = 155
          Width = 288
          Height = 2
        end
        object imgNotesNotes: TImage
          Left = 16
          Top = 27
          Width = 41
          Height = 41
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
        end
        object imgNotes: TImage
          Left = 16
          Top = 163
          Width = 41
          Height = 41
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
        end
        object lblNotesNotesDesc: TMemo
          Left = 125
          Top = 27
          Width = 275
          Height = 30
          TabStop = False
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Configure defaults for editing and saving notes.')
          ReadOnly = True
          TabOrder = 4
        end
        object lblNotesTitlesDesc: TMemo
          Left = 125
          Top = 165
          Width = 275
          Height = 78
          TabStop = False
          Anchors = [akLeft, akTop, akRight]
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Configure document list preferences.')
          ReadOnly = True
          TabOrder = 5
        end
        object lblNotesNotes: TStaticText
          Left = 13
          Top = 9
          Width = 32
          Height = 17
          Caption = 'Notes'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object lblNotesTitles: TStaticText
          Left = 13
          Top = 145
          Width = 81
          Height = 17
          Caption = 'Document Titles'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object btnNotesNotes: TButton
          Left = 255
          Top = 67
          Width = 145
          Height = 22
          HelpContext = 9201
          Anchors = [akTop, akRight]
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
        object btnNotesTitles: TButton
          Left = 255
          Top = 205
          Width = 145
          Height = 22
          HelpContext = 9202
          Anchors = [akTop, akRight]
          Caption = '&Document Titles...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnNotesTitlesClick
        end
      end
      object tsCprsReports: TTabSheet
        Caption = 'Reports'
        ImageIndex = 5
        object bvlReports: TBevel
          Left = 80
          Top = 16
          Width = 321
          Height = 2
        end
        object imgReports: TImage
          Left = 20
          Top = 31
          Width = 41
          Height = 41
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
        end
        object bvlReport1: TBevel
          Left = 104
          Top = 108
          Width = 297
          Height = 2
        end
        object bvlReport2: TBevel
          Left = 104
          Top = 204
          Width = 297
          Height = 2
        end
        object imgReport1: TImage
          Left = 16
          Top = 123
          Width = 41
          Height = 41
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
        end
        object imgReport2: TImage
          Left = 16
          Top = 219
          Width = 41
          Height = 41
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
        end
        object memReports: TMemo
          Left = 128
          Top = 27
          Width = 273
          Height = 41
          TabStop = False
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Change the default date range and occurrence limits '
            'for '
            'all reports on the CPRS Reports tab (excluding health '
            'summary reports) .')
          ReadOnly = True
          TabOrder = 4
        end
        object memReport1: TMemo
          Left = 128
          Top = 121
          Width = 273
          Height = 49
          TabStop = False
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Change the individual date range and occurrence limits '
            'for each report on the CPRS Reports tab (excluding '
            'health summary reports) .')
          ReadOnly = True
          TabOrder = 5
        end
        object lblReports: TStaticText
          Left = 13
          Top = 9
          Width = 56
          Height = 17
          Caption = 'All Reports'
          TabOrder = 2
        end
        object lblReport1: TStaticText
          Left = 9
          Top = 101
          Width = 91
          Height = 17
          Caption = 'Individual Reports'
          TabOrder = 3
        end
        object btnReports: TButton
          Left = 200
          Top = 76
          Width = 193
          Height = 22
          Caption = 'Set All Reports...'
          TabOrder = 0
          OnClick = btnReportsClick
        end
        object btnReport1: TButton
          Left = 200
          Top = 167
          Width = 193
          Height = 22
          Caption = 'Set Individual Report...'
          TabOrder = 1
          OnClick = btnReport1Click
        end
        object lblReport2: TStaticText
          Left = 5
          Top = 197
          Width = 90
          Height = 17
          Caption = 'Remote Data Tool'
          TabOrder = 6
        end
        object memReport2: TMemo
          Left = 135
          Top = 212
          Width = 273
          Height = 48
          TabStop = False
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Users now have direct '#39'one-click'#39' access to VistaWeb '
            'and RDV from the CPRS Toolbar.  You no longer have '
            'to change your Remote Data Tool settings.')
          ReadOnly = True
          TabOrder = 7
        end
      end
      object tsGraphs: TTabSheet
        Caption = 'Graphs'
        ImageIndex = 6
        DesignSize = (
          419
          301)
        object bvlGraphSettings: TBevel
          Left = 104
          Top = 16
          Width = 297
          Height = 2
        end
        object imgGraphSettings: TImage
          Left = 16
          Top = 163
          Width = 41
          Height = 41
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
        end
        object bvlGraphViews: TBevel
          Left = 104
          Top = 155
          Width = 297
          Height = 2
        end
        object imgGraphViews: TImage
          Left = 16
          Top = 27
          Width = 41
          Height = 41
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
        end
        object lblGraphSettings: TStaticText
          Left = 13
          Top = 145
          Width = 81
          Height = 17
          Caption = 'Default Settings'
          TabOrder = 0
        end
        object btnGraphSettings: TButton
          Left = 200
          Top = 235
          Width = 193
          Height = 22
          Caption = 'Default Graph Settings...'
          TabOrder = 1
          OnClick = btnGraphSettingsClick
        end
        object lblGraphViews: TStaticText
          Left = 13
          Top = 9
          Width = 79
          Height = 17
          Caption = 'View Definitions'
          TabOrder = 2
        end
        object btnGraphViews: TButton
          Left = 200
          Top = 100
          Width = 193
          Height = 22
          Caption = 'View Definitions...'
          TabOrder = 3
          OnClick = btnGraphViewsClick
        end
        object memGraphSettings: TMemo
          Left = 125
          Top = 167
          Width = 275
          Height = 66
          TabStop = False
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Configure default settings for graphs. Changes can be '
            'made to the types of data displayed and the styles of '
            'presentation. These settings are saved as your default.')
          ReadOnly = True
          TabOrder = 4
        end
        object memGraphViews: TMemo
          Left = 125
          Top = 27
          Width = 275
          Height = 68
          TabStop = False
          Anchors = [akLeft, akTop, akRight]
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            'Define collections of data as views. Views are used for '
            'common selections of multiple items.')
          ReadOnly = True
          TabOrder = 5
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
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
        'Component = pnlMain'
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
        'Component = lblNotificationsOptions'
        'Status = stsDefault')
      (
        'Component = lblNotifications'
        'Status = stsDefault')
      (
        'Component = lblNotificationsSurrogate'
        'Status = stsDefault')
      (
        'Component = lblNotificationsSurrogateText'
        'Status = stsDefault')
      (
        'Component = lvwNotifications'
        'Status = stsDefault')
      (
        'Component = btnNotificationsRemove'
        'Status = stsDefault')
      (
        'Component = chkNotificationsFlagged'
        'Status = stsDefault')
      (
        'Component = btnSurrogate'
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
        'Status = stsDefault')
      (
        'Component = btnNotesTitles'
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
        'Status = stsDefault'))
  end
end
