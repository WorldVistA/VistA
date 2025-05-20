inherited frmFrame: TfrmFrame
  Left = 219
  Top = 102
  Caption = ']='
  ClientHeight = 825
  ClientWidth = 976
  FormStyle = fsMDIForm
  Menu = mnuFrame
  Visible = True
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  OldCreateOrder = True
  ExplicitHeight = 884
  PixelsPerInch = 96
  TextHeight = 13
  object pnlNoPatientSelected: TPanel [0]
    Left = 0
    Top = 0
    Width = 976
    Height = 825
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = 'No patient is currently selected'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Visible = False
  end
  object pnlPatientSelected: TPanel [1]
    Left = 0
    Top = 0
    Width = 976
    Height = 825
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    object bvlPageTop: TBevel
      Left = 1
      Top = 103
      Width = 974
      Height = 2
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      ExplicitTop = 62
    end
    object pnlToolbar: TPanel
      Left = 1
      Top = 1
      Width = 974
      Height = 61
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object bvlToolTop: TBevel
        Left = 0
        Top = 0
        Width = 974
        Height = 1
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Style = bsRaised
      end
      object pnlCCOW: TPanel
        Left = 0
        Top = 1
        Width = 59
        Height = 60
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alLeft
        BevelWidth = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object imgCCOW: TImage
          Left = 2
          Top = 2
          Width = 55
          Height = 56
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Center = True
          Picture.Data = {
            07544269746D617052030000424D520300000000000052020000280000001000
            000010000000010008000000000000010000120B0000120B0000870000008700
            00003F3E3F003A393A007B351600BCB6B30082340900642700008D3F0D00985B
            3400B19A8C00B5A59B008B3700008A3700008936000088360000873500008635
            00008535000083340000813300007D3100007D3200007B3100007A3000007830
            0000772F0000762F0000742E00006F2C00006E2B00006C2B00006A2A00006829
            0000662800006528000061260000602600005C2400005B240000592300005823
            0000562200008B3801008C3902008C3903008C3A04008C3B05008D3B06008D3C
            07008E3E0A008F420F009045130090481900935025009B6440009F6D4C00A275
            5800A6806700AA897300AD917F00B8AEA700053A0D00063B0E000C3F14000E41
            16000A3C17002351360000007F0000007B000101800001017F00040480000707
            820007078100080882000A0A82000D0D7200101085000E0E7200131386001313
            7500171787001919880021218A0025258C0023237B002B2B8E002C2C8E002F2F
            8F002C2C79003535840039398500FFFFFF00DFDFDF00BFBFBF00BEBEBE00BCBC
            BC00BBBBBB00B9B9B900B8B8B800B7B7B700B4B4B400B2B2B200B1B1B100ACAC
            AC00A9A9A900A7A7A700A6A6A600A4A4A400A2A2A2009F9F9F00989898009797
            970094949400929292008F8F8F008C8C8C008B8B8B0089898900858585008484
            840083838300818181007F7F7F007E7E7E007D7D7D007B7B7B007A7A7A007979
            79007777770076767600747474000A0A0A000707070001010100000000005D04
            868686865D868686865D5D5D5D5D5D865B5B5B5B865B5B5B5B865D5D5D5D865B
            8686868686868686865B865D5D5D865B865D865D5D5D865D865B865D5D5D865B
            8686868686868686865B865D5D5D0A865B5B5B5B865B5B5B5B865D5D5D5D0A0A
            868686865D868686865D5D5D5D5D0A0A0A0A0A0A5D5D5D5D5D0C0C5D5D5D0A0A
            0A0A0A0A5D5D5D5D5D0C0C5D5D5D0A0A0A0A0A0A5D5D5D5D5D5D5D5D5D5D5D29
            0A0A0A5D5D5D5D5D5D0C0C5D5D5D5D5D0A0A5D5D5D5D5D5D5D0C0C0C5D5D5D0A
            0A0A2F5D5D5D5D5D5D5D0C0C0C5D5D0A0A0A305D5D5D5D5D5D5D5D0C0C5D5D02
            0A0A025D5D5D5D5D0C0C0C0C0C5D5D5D5D5D5D5D5D5D5D5D0C0C0C0C5D5D}
          ExplicitWidth = 56
          ExplicitHeight = 57
        end
      end
      object pnlPatient: TKeyClickPanel
        Left = 59
        Top = 1
        Width = 283
        Height = 60
        Hint = 'Click for more patient information.'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alLeft
        BevelWidth = 2
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInfoBk
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
        OnClick = pnlPatientClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlPatientMouseDown
        OnMouseUp = pnlPatientMouseUp
        object lblPtName: TStaticText
          Left = 9
          Top = 6
          Width = 188
          Height = 28
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'No Patient Selected'
          Font.Charset = ANSI_CHARSET
          Font.Color = clInfoText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlPatientClick
          OnMouseDown = pnlPatientMouseDown
          OnMouseUp = pnlPatientMouseUp
        end
        object lblPtInfo: TStaticText
          Left = 9
          Top = 28
          Width = 106
          Height = 28
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = '000-00-0000'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlPatientClick
          OnMouseDown = pnlPatientMouseDown
          OnMouseUp = pnlPatientMouseUp
        end
      end
      object pnlVisit: TKeyClickPanel
        Left = 342
        Top = 1
        Width = 181
        Height = 60
        Hint = 'Click to change provider/location.'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alLeft
        BevelWidth = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = True
        OnClick = pnlVisitClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlVisitMouseDown
        OnMouseUp = pnlVisitMouseUp
        object lblPtLocation: TStaticText
          Left = 9
          Top = 6
          Width = 4
          Height = 4
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlVisitClick
          OnMouseDown = pnlVisitMouseDown
          OnMouseUp = pnlVisitMouseUp
        end
        object lblPtProvider: TStaticText
          Left = 9
          Top = 28
          Width = 4
          Height = 4
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlVisitClick
          OnMouseDown = pnlVisitMouseDown
          OnMouseUp = pnlVisitMouseUp
        end
      end
      object pnlPrimaryCare: TKeyClickPanel
        Left = 523
        Top = 1
        Width = 177
        Height = 60
        Hint = 'Primary Care Team / Primary Care Provider'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelWidth = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        TabStop = True
        OnClick = pnlPrimaryCareClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlPrimaryCareMouseDown
        OnMouseUp = pnlPrimaryCareMouseUp
        object lblPtCare: TStaticText
          Left = 9
          Top = 6
          Width = 4
          Height = 4
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlPrimaryCareClick
          OnMouseDown = pnlPrimaryCareMouseDown
          OnMouseUp = pnlPrimaryCareMouseUp
        end
        object lblPtAttending: TStaticText
          Left = 9
          Top = 28
          Width = 4
          Height = 4
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlPrimaryCareClick
          OnMouseDown = pnlPrimaryCareMouseDown
          OnMouseUp = pnlPrimaryCareMouseUp
        end
        object lblPtMHTC: TStaticText
          Left = 9
          Top = 52
          Width = 4
          Height = 4
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = pnlPrimaryCareClick
          OnMouseDown = pnlPrimaryCareMouseDown
          OnMouseUp = pnlPrimaryCareMouseUp
        end
      end
      object pnlReminders: TKeyClickPanel
        Left = 814
        Top = 1
        Width = 52
        Height = 60
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        BevelWidth = 2
        Caption = 'Reminders'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        TabStop = True
        OnClick = pnlRemindersClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlRemindersMouseDown
        OnMouseUp = pnlRemindersMouseUp
        object imgReminder: TImage
          Left = 2
          Top = 2
          Width = 48
          Height = 56
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Center = True
          OnMouseDown = pnlRemindersMouseDown
          OnMouseUp = pnlRemindersMouseUp
          ExplicitHeight = 57
        end
        object anmtRemSearch: TAnimate
          Left = 2
          Top = 2
          Width = 48
          Height = 56
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Visible = False
        end
      end
      object pnlPostings: TKeyClickPanel
        Left = 866
        Top = 1
        Width = 108
        Height = 60
        Hint = 'Click to display patient postings.'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        BevelWidth = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        TabStop = True
        OnClick = pnlPostingsClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlPostingsMouseDown
        OnMouseUp = pnlPostingsMouseUp
        object lblPtPostings: TStaticText
          Left = 7
          Top = 6
          Width = 87
          Height = 20
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Alignment = taCenter
          AutoSize = False
          Caption = 'No Postings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlPostingsClick
          OnMouseDown = pnlPostingsMouseDown
          OnMouseUp = pnlPostingsMouseUp
        end
        object lblPtCWAD: TStaticText
          Left = 9
          Top = 28
          Width = 87
          Height = 20
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Alignment = taCenter
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          Transparent = False
          OnClick = pnlPostingsClick
          OnMouseDown = pnlPostingsMouseDown
          OnMouseUp = pnlPostingsMouseUp
        end
      end
      object pnlOTHD: TKeyClickPanel
        Left = 456
        Top = 1
        Width = 109
        Height = 60
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        BevelWidth = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        TabStop = True
        Visible = False
        OnClick = pnlOTHDClick
        OnEnter = pnlOTHDEnter
        OnExit = pnlOTHDExit
        OnMouseDown = pnlOTHDMouseDown
        OnMouseUp = pnlOTHDMouseUp
        object lblOTHDTitle: TStaticText
          Left = 7
          Top = 2
          Width = 40
          Height = 24
          Hint = 'Other than Honorable'
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Alignment = taCenter
          Caption = 'OTH'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoBk
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = pnlOTHDClick
          OnMouseDown = pnlOTHDMouseDown
          OnMouseUp = pnlOTHDMouseUp
        end
        object lblOTHDDtl: TStaticText
          Left = 4
          Top = 27
          Width = 43
          Height = 17
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Alignment = taCenter
          Caption = '##D,P#'
          TabOrder = 1
          OnClick = pnlOTHDClick
          OnMouseDown = pnlOTHDMouseDown
          OnMouseUp = pnlOTHDMouseUp
        end
      end
      object paVAA: TKeyClickPanel
        Left = 366
        Top = 1
        Width = 90
        Height = 60
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 5
        Visible = False
        OnResize = paVAAResize
        object laVAA2: TButton
          Left = 0
          Top = 24
          Width = 90
          Height = 36
          Hint = 'Click to display patient insurance data'
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Caption = 'Pt Insur'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = laVAA2Click
        end
        object laMHV: TButton
          Left = 0
          Top = 0
          Width = 90
          Height = 24
          Hint = 'Click to display MHV data'
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          Caption = 'MHV'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = laMHVClick
        end
      end
      object pnlCVnFlag: TPanel
        Left = 565
        Top = 1
        Width = 138
        Height = 60
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        TabOrder = 6
        object btnCombatVet: TButton
          Left = 1
          Top = 32
          Width = 136
          Height = 27
          Hint = 'Click to display combat veteran eligibility details.'
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alBottom
          Caption = 'CV JAN 30, 2008'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnCombatVetClick
        end
        object pnlFlag: TKeyClickPanel
          Left = 1
          Top = 16
          Width = 136
          Height = 16
          Hint = 'Click to display patient record flags.'
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          BevelWidth = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          OnClick = pnlFlagClick
          OnEnter = pnlFlagEnter
          OnExit = pnlFlagExit
          OnMouseDown = pnlFlagMouseDown
          OnMouseUp = pnlFlagMouseUp
          object lblFlag: TLabel
            Left = 2
            Top = 2
            Width = 132
            Height = 12
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Alignment = taCenter
            Caption = 'Flag'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnFace
            Font.Height = -9
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            WordWrap = True
            OnClick = pnlFlagClick
            OnMouseDown = pnlFlagMouseDown
            OnMouseUp = pnlFlagMouseUp
            ExplicitWidth = 25
            ExplicitHeight = 13
          end
        end
        object txtCmdFlags: TVA508StaticText
          Name = 'txtCmdFlags'
          Left = 1
          Top = 1
          Width = 136
          Height = 15
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          Alignment = taCenter
          Caption = 'Flags Button Disabled'
          TabOrder = 2
          Visible = False
          ShowAccelChar = True
          WordWrap = False
          LabelAlignment = taCenter
          LabelLayout = tlTop
        end
      end
      object pnlRemoteData: TKeyClickPanel
        Left = 703
        Top = 1
        Width = 111
        Height = 60
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        BevelWidth = 2
        Caption = 'Remote Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        TabStop = True
        OnClick = pnlCIRNClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlCIRNMouseDown
        OnMouseUp = pnlCIRNMouseUp
        object pnlVistaWeb: TKeyClickPanel
          Left = 2
          Top = 2
          Width = 107
          Height = 29
          Hint = 'Click for any external patient data'
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          BevelWidth = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          OnClick = pnlVistaWebClick
          OnEnter = pnlPrimaryCareEnter
          OnExit = pnlPrimaryCareExit
          OnMouseDown = pnlVistaWebMouseDown
          OnMouseUp = pnlVistaWebMouseUp
          object lblVistaWeb: TLabel
            Left = 2
            Top = 2
            Width = 103
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Alignment = taCenter
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clInfoText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            OnClick = pnlVistaWebClick
            OnMouseDown = pnlVistaWebMouseDown
            OnMouseUp = pnlVistaWebMouseUp
            ExplicitWidth = 3
            ExplicitHeight = 16
          end
        end
        object pnlCIRN: TKeyClickPanel
          Left = 2
          Top = 31
          Width = 107
          Height = 27
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          BevelWidth = 2
          Caption = 'Remote Data'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TabStop = True
          OnClick = pnlCIRNClick
          OnEnter = pnlPrimaryCareEnter
          OnExit = pnlPrimaryCareExit
          OnMouseDown = pnlCIRNMouseDown
          OnMouseUp = pnlCIRNMouseUp
          object lblCIRN: TLabel
            Left = 2
            Top = 2
            Width = 103
            Height = 23
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Alignment = taCenter
            Caption = 'Remote Data'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnFace
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            OnClick = pnlCIRNClick
            ExplicitWidth = 80
            ExplicitHeight = 16
          end
        end
      end
    end
    object stsArea: TStatusBar
      Left = 1
      Top = 803
      Width = 974
      Height = 21
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Panels = <
        item
          Width = 200
        end
        item
          Width = 224
        end
        item
          Style = psOwnerDraw
          Width = 50
        end
        item
          Width = 94
        end
        item
          Width = 38
        end
        item
          Width = 33
        end>
      PopupMenu = popAlerts
      SizeGrip = False
    end
    object tabPage: TTabControl
      Left = 1
      Top = 776
      Width = 974
      Height = 27
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      TabPosition = tpBottom
      OnChange = tabPageChange
      OnMouseDown = tabPageMouseDown
      OnMouseUp = tabPageMouseUp
    end
    object pnlPage: TPanel
      Left = 1
      Top = 105
      Width = 974
      Height = 671
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object lstCIRNLocations: TORListBox
        Left = 642
        Top = 0
        Width = 317
        Height = 118
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabStop = False
        Style = lbOwnerDrawFixed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        ParentShowHint = False
        PopupMenu = popCIRN
        ShowHint = False
        TabOrder = 1
        Visible = False
        OnClick = lstCIRNLocationsClick
        OnExit = lstCIRNLocationsExit
        Caption = 'Remote Data'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3,4'
        TabPositions = '16'
        RightClickSelect = True
        CheckBoxes = True
        CheckEntireLine = True
      end
    end
    object pnlOtherInfo: TKeyClickPanel
      Left = 1
      Top = 62
      Width = 974
      Height = 41
      Align = alTop
      Color = clYellow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      OnClick = pnlOtherInfoClick
      OnMouseDown = pnlOtherInfoMouseDown
      OnMouseUp = pnlOtherInfoMouseUp
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 48
    Data = (
      (
        'Component = pnlNoPatientSelected'
        'Status = stsDefault')
      (
        'Component = pnlPatientSelected'
        'Status = stsDefault')
      (
        'Component = pnlToolbar'
        'Status = stsDefault')
      (
        'Component = pnlCCOW'
        'Status = stsDefault')
      (
        'Component = pnlPatient'
        'Status = stsDefault')
      (
        'Component = lblPtName'
        'Status = stsDefault')
      (
        'Component = lblPtInfo'
        'Status = stsDefault')
      (
        'Component = pnlVisit'
        'Status = stsDefault')
      (
        'Component = lblPtLocation'
        'Status = stsDefault')
      (
        'Component = lblPtProvider'
        'Status = stsDefault')
      (
        'Component = pnlPrimaryCare'
        'Status = stsDefault')
      (
        'Component = lblPtCare'
        'Status = stsDefault')
      (
        'Component = lblPtAttending'
        'Status = stsDefault')
      (
        'Component = pnlReminders'
        'Status = stsDefault')
      (
        'Component = anmtRemSearch'
        'Status = stsDefault')
      (
        'Component = pnlPostings'
        'Status = stsDefault')
      (
        'Component = lblPtPostings'
        'Status = stsDefault')
      (
        'Component = lblPtCWAD'
        'Status = stsDefault')
      (
        'Component = paVAA'
        'Status = stsDefault')
      (
        'Component = laVAA2'
        'Status = stsDefault')
      (
        'Component = laMHV'
        'Status = stsDefault')
      (
        'Component = stsArea'
        'Status = stsDefault')
      (
        'Component = tabPage'
        'Status = stsDefault')
      (
        'Component = pnlPage'
        'Status = stsDefault')
      (
        'Component = lstCIRNLocations'
        'Status = stsDefault')
      (
        'Component = frmFrame'
        'Status = stsDefault')
      (
        'Component = pnlCVnFlag'
        'Status = stsDefault')
      (
        'Component = btnCombatVet'
        'Status = stsDefault')
      (
        'Component = pnlFlag'
        'Status = stsDefault')
      (
        'Component = pnlRemoteData'
        'Status = stsDefault')
      (
        'Component = pnlVistaWeb'
        'Status = stsDefault')
      (
        'Component = pnlCIRN'
        'Status = stsDefault')
      (
        'Component = lblPtMHTC'
        'Status = stsDefault')
      (
        'Component = txtCmdFlags'
        'Status = stsDefault')
      (
        'Component = lblOTHDDtl'
        'Status = stsDefault'))
  end
  object mnuFrame: TMainMenu
    Left = 180
    Top = 128
    object mnuFile: TMenuItem
      Caption = '&File'
      GroupIndex = 1
      object mnuFileOpen: TMenuItem
        Caption = 'Select &New Patient...'
        OnClick = mnuFileOpenClick
      end
      object mnuFileRefresh: TMenuItem
        Caption = 'Refresh Patient &Information'
        OnClick = mnuFileRefreshClick
      end
      object mnuFileResumeContext: TMenuItem
        Caption = 'Rejoin patient link'
        object mnuFileResumeContextSet: TMenuItem
          Caption = 'Set new context'
          OnClick = mnuFileResumeContextSetClick
        end
        object Useexistingcontext1: TMenuItem
          Caption = 'Use existing context'
          OnClick = mnuFileResumeContextGetClick
        end
      end
      object mnuFileBreakContext: TMenuItem
        Caption = 'Break patient link'
        OnClick = mnuFileBreakContextClick
      end
      object mnuFileEncounter: TMenuItem
        Caption = '&Update Provider / Location...'
        OnClick = mnuFileEncounterClick
      end
      object mnuFileReview: TMenuItem
        Caption = '&Review/Sign Changes...'
        OnClick = mnuFileReviewClick
      end
      object Z7: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuFileNext: TMenuItem
        Caption = 'Next Noti&fication'
        OnClick = mnuFileNextClick
      end
      object mnuFileNotifRemove: TMenuItem
        Caption = 'Remo&ve Current Notification'
        OnClick = mnuFileNotifRemoveClick
      end
      object mnuFileViewNotifications: TMenuItem
        Caption = 'View Patient'#39's Notifications...'
        OnClick = mnuFileViewNotificationsClick
      end
      object Z1: TMenuItem
        Caption = '-'
      end
      object mnuFilePrintSetup: TMenuItem
        Caption = 'Print &Setup...'
        Enabled = False
        OnClick = mnuFilePrintSetupClick
      end
      object mnuFilePrintSelectedItems: TMenuItem
        Caption = 'Print Selected Items'
        Enabled = False
        OnClick = mnuFilePrintSelectedItemsClick
      end
      object mnuFilePrint: TMenuItem
        Caption = '&Print...'
        Enabled = False
        OnClick = mnuFilePrintClick
      end
      object mnuFileExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mnuFileExitClick
      end
    end
    object mnuEdit: TMenuItem
      Caption = '&Edit'
      GroupIndex = 2
      OnClick = mnuEditClick
      object mnuEditUndo: TMenuItem
        Caption = '&Undo'
        ShortCut = 16474
        OnClick = mnuEditUndoClick
      end
      object mnuEditRedo: TMenuItem
        Caption = 'Re&do'
        ShortCut = 16473
        OnClick = mnuEditRedoClick
      end
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuEditCut: TMenuItem
        Caption = 'Cu&t'
        ShortCut = 16472
        OnClick = mnuEditCutClick
      end
      object mnuEditCopy: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = mnuEditCopyClick
      end
      object mnuEditPaste: TMenuItem
        Caption = '&Paste'
        ShortCut = 16470
        OnClick = mnuEditPasteClick
      end
      object Z4: TMenuItem
        Caption = '-'
      end
      object mnuEditPref: TMenuItem
        Caption = 'P&references'
        object Prefs1: TMenuItem
          Caption = '&Fonts'
          object mnu8pt: TMenuItem
            Tag = 8
            Caption = '8 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu10pt1: TMenuItem
            Tag = 10
            Caption = '10 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu12pt1: TMenuItem
            Tag = 12
            Caption = '12 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu14pt1: TMenuItem
            Tag = 14
            Caption = '14 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
        end
      end
    end
    object mnuView: TMenuItem
      Caption = '&View'
      GroupIndex = 3
      object mnuViewChart: TMenuItem
        Caption = 'Chart &Tab'
        object mnuChartCover: TMenuItem
          Tag = 1
          Caption = 'Cover &Sheet'
          ShortCut = 16467
          OnClick = mnuChartTabClick
        end
        object mnuChartProbs: TMenuItem
          Tag = 2
          Caption = '&Problem List'
          ShortCut = 16464
          OnClick = mnuChartTabClick
        end
        object mnuChartMeds: TMenuItem
          Tag = 3
          Caption = '&Medications'
          ShortCut = 16461
          OnClick = mnuChartTabClick
        end
        object mnuChartOrders: TMenuItem
          Tag = 4
          Caption = '&Orders'
          ShortCut = 16463
          OnClick = mnuChartTabClick
        end
        object mnuChartNotes: TMenuItem
          Tag = 6
          Caption = 'Progress &Notes'
          ShortCut = 16462
          OnClick = mnuChartTabClick
        end
        object mnuChartCslts: TMenuItem
          Tag = 7
          Caption = 'Consul&ts'
          ShortCut = 16468
          OnClick = mnuChartTabClick
        end
        object mnuChartSurgery: TMenuItem
          Tag = 11
          Caption = 'S&urgery'
          ShortCut = 16469
          OnClick = mnuChartTabClick
        end
        object mnuChartDCSumm: TMenuItem
          Tag = 8
          Caption = '&Discharge Summaries'
          ShortCut = 16452
          OnClick = mnuChartTabClick
        end
        object mnuChartLabs: TMenuItem
          Tag = 9
          Caption = '&Laboratory'
          ShortCut = 16460
          OnClick = mnuChartTabClick
        end
        object mnuChartReports: TMenuItem
          Tag = 10
          Caption = '&Reports'
          ShortCut = 16466
          OnClick = mnuChartTabClick
        end
      end
      object mnuViewInformation: TMenuItem
        Caption = 'Information'
        OnClick = mnuViewInformationClick
        object mnuViewDemo: TMenuItem
          Tag = 1
          Caption = 'De&mographics...'
          OnClick = ViewInfo
        end
        object mnuViewVisits: TMenuItem
          Tag = 2
          Caption = 'Visits/Pr&ovider...'
          OnClick = ViewInfo
        end
        object mnuViewPrimaryCare: TMenuItem
          Tag = 3
          Caption = 'Primary &Care...'
          OnClick = ViewInfo
        end
        object mnuViewMyHealtheVet: TMenuItem
          Tag = 4
          Caption = 'MyHealthe&Vet...'
          OnClick = ViewInfo
        end
        object mnuInsurance: TMenuItem
          Tag = 5
          Caption = '&Insurance...'
          OnClick = ViewInfo
        end
        object mnuViewFlags: TMenuItem
          Tag = 6
          Caption = '&Flags...'
          OnClick = ViewInfo
        end
        object mnuViewRemoteData: TMenuItem
          Tag = 7
          Caption = 'Remote &Data...'
          OnClick = ViewInfo
        end
        object mnuViewReminders: TMenuItem
          Tag = 8
          Caption = '&Reminders...'
          OnClick = ViewInfo
        end
        object mnuViewPostings: TMenuItem
          Tag = 9
          Caption = '&Postings...'
          OnClick = ViewInfo
        end
      end
    end
    object mnuTools: TMenuItem
      Caption = '&Tools'
      GroupIndex = 8
      object Z8: TMenuItem
        Caption = '-'
      end
      object mnuToolsGraphing: TMenuItem
        Caption = '&Graphing...'
        ShortCut = 16455
        OnClick = mnuToolsGraphingClick
      end
      object LabInfo1: TMenuItem
        Caption = '&Lab Test Information...'
        OnClick = LabInfo1Click
      end
      object mnuToolsOptions: TMenuItem
        Caption = '&Options...'
        OnClick = mnuToolsOptionsClick
      end
      object DigitalSigningSetup1: TMenuItem
        Caption = 'Digital Signing Setup...'
        OnClick = DigitalSigningSetup1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object PDMP1: TMenuItem
        Caption = 'PDMP'
        object RequestPDMPData1: TMenuItem
          Action = acPDMPRequest
        end
        object CancelPDMPRequest1: TMenuItem
          Action = acPDMPCancel
        end
        object ReviewPDMPData1: TMenuItem
          Action = acPDMPReview
        end
      end
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      GroupIndex = 9
      object mnuHelpContents: TMenuItem
        Caption = '&Contents'
        Hint = 'help\cprs.chm'
        OnClick = ToolClick
      end
      object mnuHelpTutor: TMenuItem
        Caption = '&Brief Tutorial'
        Enabled = False
        Visible = False
      end
      object mnuDebugReport: TMenuItem
        Caption = 'Debug Report'
        OnClick = mnuDebugReportClick
      end
      object ResetParams1: TMenuItem
        Action = acResetParams
        Visible = False
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuWAPermissions: TMenuItem
        Caption = 'Write Access Permissions'
        OnClick = mnuWAPermissionsClick
      end
      object Z5: TMenuItem
        Caption = '-'
      end
      object mnuHelpBroker: TMenuItem
        Caption = 'Last Broker Call'
        OnClick = mnuHelpBrokerClick
      end
      object mnuHelpLists: TMenuItem
        Caption = 'Show ListBox Data'
        OnClick = mnuHelpListsClick
      end
      object mnuHelpSymbols: TMenuItem
        Caption = 'Symbol Table'
        OnClick = mnuHelpSymbolsClick
      end
      object mnuFocusChanges: TMenuItem
        AutoCheck = True
        Caption = 'Show Focus Changes'
        OnClick = mnuFocusChangesClick
      end
      object mnuShowActivityLog: TMenuItem
        Caption = 'Show &Activity Log'
        OnClick = mnuShowActivityLogClick
      end
      object Z6: TMenuItem
        Caption = '-'
      end
      object mnuHelpAbout: TMenuItem
        Caption = '&About CPRS'
        OnClick = mnuHelpAboutClick
      end
    end
  end
  object popCIRN: TPopupMenu
    Left = 539
    Top = 148
    object popCIRNSelectAll: TMenuItem
      Caption = 'Select All'
      OnClick = popCIRNSelectAllClick
    end
    object popCIRNSelectNone: TMenuItem
      Caption = 'Select None'
      OnClick = popCIRNSelectNoneClick
    end
    object popCIRNClose: TMenuItem
      Caption = 'Close List'
      OnClick = popCIRNCloseClick
    end
  end
  object OROpenDlg: TOpenDialog
    Filter = 'Exe file (*.exe)|*.exe'
    Left = 260
    Top = 257
  end
  object popAlerts: TPopupMenu
    AutoPopup = False
    Left = 320
    Top = 200
    object mnuAlertContinue: TMenuItem
      Caption = 'Continue'
      ShortCut = 16451
      OnClick = mnuFileNextClick
    end
    object mnuAlertForward: TMenuItem
      Caption = 'Forward'
      ShortCut = 16454
      OnClick = mnuAlertForwardClick
    end
    object mnuAlertRenew: TMenuItem
      Caption = 'Renew'
      ShortCut = 16466
      OnClick = mnuAlertRenewClick
    end
  end
  object AppEvents: TApplicationEvents
    OnActivate = AppEventsActivate
    OnIdle = AppEventsIdle
    OnMessage = AppEventsMessage
    OnShortCut = AppEventsShortCut
    Left = 336
    Top = 256
  end
  object compAccessTabPage: TVA508ComponentAccessibility
    Component = tabPage
    OnCaptionQuery = compAccessTabPageCaptionQuery
    Left = 56
    Top = 48
  end
  object CPAppMon: TCopyApplicationMonitor
    BreakUpLimit = 80
    HighlightColor = clYellow
    LoadBuffer = LoadBuffer
    LoadProperties = LoadProperties
    MatchHighlight = True
    MatchStyle = []
    MonitoringApplication = 'CPRS'
    MonitoringPackage = 'OR'
    PolledBuffer = True
    BufferEnabled = False
    HashBuffer = True
    SaveBuffer = SaveBuffer
    SaveCutOff = 2.000000000000000000
    CompareCutOff = 15
    StartPollBuff = StartPollBuff
    StopPollBuff = StopPollBuff
    LCSToggle = False
    LCSCharLimit = 5000
    LCSUseColor = False
    LCSTextColor = clBlue
    LCSTextStyle = []
    UserDuz = 0
    Enabled = True
    Left = 16
    Top = 96
  end
  object alPdmp: TActionList
    Left = 528
    Top = 224
    object acPDMPRequest: TAction
      Caption = 'Request PDMP Data'
      OnExecute = acPDMPRequestExecute
    end
    object acPDMPReview: TAction
      Caption = 'Review PDMP Data'
      Enabled = False
      OnExecute = acPDMPReviewExecute
    end
    object acPDMPCancel: TAction
      Caption = 'Cancel PDMP Request'
      Enabled = False
      OnExecute = acPDMPCancelExecute
    end
    object acPDMPOptions: TAction
      Caption = 'PDMP Options'
    end
    object acResetParams: TAction
      Caption = 'Reset Params'
      OnExecute = acResetParamsExecute
    end
  end
end
