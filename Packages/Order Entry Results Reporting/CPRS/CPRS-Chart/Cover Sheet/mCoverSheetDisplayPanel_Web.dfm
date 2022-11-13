inherited fraCoverSheetDisplayPanel_Web: TfraCoverSheetDisplayPanel_Web
  Width = 584
  Height = 444
  ExplicitWidth = 584
  ExplicitHeight = 444
  inherited pnlMain: TPanel
    Width = 584
    Height = 444
    ExplicitWidth = 584
    ExplicitHeight = 444
    inherited img: TImage
      Height = 413
      ExplicitHeight = 407
    end
    inherited pnlHeader: TPanel
      Width = 578
      ExplicitWidth = 578
      inherited lblTitle: TLabel
        Width = 522
      end
      inherited sbtnRefresh: TSpeedButton
        Left = 556
        ExplicitLeft = 549
      end
    end
    inherited pnlWorkspace: TPanel
      Width = 552
      Height = 413
      ExplicitWidth = 552
      ExplicitHeight = 413
      object brwsr: TWebBrowser
        AlignWithMargins = True
        Left = 3
        Top = 30
        Width = 546
        Height = 380
        Margins.Top = 0
        Align = alClient
        TabOrder = 0
        SelectedEngine = EdgeIfAvailable
        OnNavigateComplete2 = brwsrNavigateComplete2
        ExplicitWidth = 437
        ExplicitHeight = 304
        ControlData = {
          4C0000006E380000462700000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E12620A000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object pnlNavigator: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 546
        Height = 27
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Caption = 'pnlNavigator'
        Color = clInactiveCaption
        ParentBackground = False
        TabOrder = 1
        Visible = False
        object sbtnBack: TSpeedButton
          AlignWithMargins = True
          Left = 1
          Top = 3
          Width = 23
          Height = 21
          Margins.Left = 1
          Margins.Right = 0
          Align = alLeft
          Caption = '<'
          ExplicitLeft = 22
          ExplicitTop = 11
          ExplicitHeight = 22
        end
        object sbtnForward: TSpeedButton
          AlignWithMargins = True
          Left = 24
          Top = 3
          Width = 23
          Height = 21
          Margins.Left = 0
          Margins.Right = 0
          Align = alLeft
          Caption = '>'
          ExplicitLeft = 162
          ExplicitTop = 11
          ExplicitHeight = 22
        end
        object sbtnGO: TSpeedButton
          AlignWithMargins = True
          Left = 465
          Top = 3
          Width = 40
          Height = 21
          Margins.Left = 0
          Margins.Right = 0
          Align = alRight
          Caption = '> Go'
          OnClick = sbtnGOClick
          ExplicitLeft = 441
          ExplicitHeight = 23
        end
        object sbtnHome: TSpeedButton
          AlignWithMargins = True
          Left = 505
          Top = 3
          Width = 40
          Height = 21
          Margins.Left = 0
          Margins.Right = 1
          Align = alRight
          Caption = 'Home'
          OnClick = sbtnGOClick
          ExplicitLeft = 487
          ExplicitHeight = 23
        end
        object edtURL: TEdit
          AlignWithMargins = True
          Left = 49
          Top = 3
          Width = 414
          Height = 21
          Margins.Left = 2
          Margins.Right = 2
          Align = alClient
          TabOrder = 0
          OnKeyDown = edtURLKeyDown
        end
      end
    end
    inherited pnlVertHeader: TPanel
      Height = 413
      ExplicitHeight = 413
      inherited img: TImage
        Height = 413
        ExplicitHeight = 407
      end
    end
  end
end
