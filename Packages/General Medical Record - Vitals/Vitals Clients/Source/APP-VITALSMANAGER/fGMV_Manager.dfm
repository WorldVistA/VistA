object frmGMV_Manager: TfrmGMV_Manager
  Left = 477
  Top = 219
  HelpContext = 1
  Caption = 'Vitals Management'
  ClientHeight = 472
  ClientWidth = 751
  Color = clBtnFace
  Constraints.MinWidth = 640
  ParentFont = True
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 185
    Top = 30
    Width = 4
    Height = 423
  end
  object tbar: TToolBar
    Left = 0
    Top = 0
    Width = 751
    Height = 30
    BorderWidth = 1
    Caption = 'tbar'
    EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
    Images = ImageList1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 32
      Height = 22
      Caption = ' Print: '
      Transparent = False
      Layout = tlCenter
    end
    object tbtnPrint: TToolButton
      Left = 32
      Top = 0
      Action = actPrint
    end
    object ToolButton3: TToolButton
      Left = 55
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 10
      Style = tbsSeparator
    end
    object Label5: TLabel
      Left = 63
      Top = 0
      Width = 100
      Height = 22
      Caption = ' System Parameters:'
      Transparent = False
      Layout = tlCenter
    end
    object tbtnSaveParameters: TToolButton
      Left = 163
      Top = 0
      Action = actSaveParameters
    end
    object ToolButton2: TToolButton
      Left = 186
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 10
      Style = tbsSeparator
    end
    object Label4: TLabel
      Left = 194
      Top = 0
      Width = 89
      Height = 22
      Caption = ' Abnormal Values: '
      Transparent = False
      Layout = tlCenter
    end
    object tbtnSaveAbnormal: TToolButton
      Left = 283
      Top = 0
      Action = actAbnormalSave
    end
    object ToolButton5: TToolButton
      Left = 306
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 10
      Style = tbsSeparator
    end
    object Label1: TLabel
      Left = 314
      Top = 0
      Width = 59
      Height = 22
      Caption = ' Templates: '
      Transparent = False
      Layout = tlCenter
    end
    object tbtnNew: TToolButton
      Left = 373
      Top = 0
      Action = actFileNewTemplate
    end
    object tbtnSave: TToolButton
      Left = 396
      Top = 0
      Action = actFileSaveTemplate
    end
    object tbtnDelete: TToolButton
      Left = 419
      Top = 0
      Action = actFileDeleteTemplate
    end
    object tbtnMakeDefault: TToolButton
      Left = 442
      Top = 0
      Action = actFileMakeDefault
    end
    object ToolButton4: TToolButton
      Left = 465
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object Label2: TLabel
      Left = 473
      Top = 0
      Width = 55
      Height = 22
      Caption = ' Qualifiers: '
      Transparent = False
      Layout = tlCenter
    end
    object tbtnNewQualifier: TToolButton
      Left = 528
      Top = 0
      Action = actQualifierNew
    end
    object tbtnEditQualifier: TToolButton
      Left = 551
      Top = 0
      Action = actQualifierEdit
    end
    object ToolButton1: TToolButton
      Left = 574
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 9
      Style = tbsSeparator
    end
    object tbtnHelp: TToolButton
      Left = 582
      Top = 0
      Action = actHelpIndex
    end
  end
  object sb: TStatusBar
    Left = 0
    Top = 453
    Width = 751
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Bevel = pbNone
        Width = 50
      end>
    OnResize = sbResize
  end
  object pgctrl: TPageControl
    Left = 189
    Top = 30
    Width = 562
    Height = 423
    ActivePage = tbshtBlank
    Align = alClient
    Constraints.MinHeight = 330
    Constraints.MinWidth = 350
    Style = tsFlatButtons
    TabOrder = 2
    TabStop = False
    Visible = False
    object tbshtBlank: TTabSheet
      Caption = 'tbshtBlank'
    end
    object tbshtTemplate: TTabSheet
      BorderWidth = 4
      Caption = 'tbshtTemplate'
      ImageIndex = 1
      inline fraGMV_EditTemplate1: TfraGMV_EditTemplate
        Left = 0
        Top = 0
        Width = 546
        Height = 384
        Align = alClient
        Enabled = False
        TabOrder = 0
        ExplicitWidth = 546
        ExplicitHeight = 384
        inherited Splitter1: TSplitter
          Top = 233
          Width = 546
          Visible = False
          ExplicitTop = 233
          ExplicitWidth = 530
        end
        inherited pnlQualifiers: TPanel
          Top = 237
          Width = 546
          Height = 147
          BevelInner = bvRaised
          ExplicitTop = 237
          ExplicitWidth = 546
          ExplicitHeight = 147
          inherited Panel7: TPanel
            Left = 1
            Top = 1
            Height = 145
            ExplicitLeft = 1
            ExplicitTop = 1
            ExplicitHeight = 145
          end
          inherited pnlDefaults: TPanel
            Left = 10
            Top = 1
            Width = 535
            Height = 145
            ExplicitLeft = 10
            ExplicitTop = 1
            ExplicitWidth = 535
            ExplicitHeight = 145
            inherited Panel8: TPanel
              Top = 140
              Width = 535
              ExplicitTop = 140
              ExplicitWidth = 535
            end
            inherited pnlDefaultQualifiers: TPanel
              Width = 535
              Height = 73
              ExplicitWidth = 535
              ExplicitHeight = 73
              inherited gb: TGroupBox
                Width = 535
                Height = 73
                ExplicitWidth = 535
                ExplicitHeight = 73
              end
            end
            inherited Panel2: TPanel
              Width = 535
              ExplicitWidth = 535
              inherited rgMetric: TRadioGroup
                Width = 535
                ExplicitWidth = 535
              end
            end
            inherited Panel4: TPanel
              Width = 535
              ExplicitWidth = 535
            end
          end
        end
        inherited pnlVitals: TPanel
          Width = 546
          Height = 233
          BevelInner = bvRaised
          BevelOuter = bvNone
          ExplicitWidth = 546
          ExplicitHeight = 233
          inherited pnlListView: TPanel
            Width = 544
            Height = 131
            ExplicitWidth = 544
            ExplicitHeight = 131
            inherited Panel1: TPanel
              Width = 544
              Height = 131
              ExplicitWidth = 544
              ExplicitHeight = 131
              inherited Panel3: TPanel
                Width = 544
                ExplicitWidth = 544
                inherited Panel5: TPanel
                  Left = 262
                  ExplicitLeft = 262
                end
              end
              inherited lvVitals: TListView
                Width = 544
                Height = 108
                ExplicitWidth = 544
                ExplicitHeight = 108
              end
            end
          end
          inherited pnlHeader: TPanel
            Width = 544
            ExplicitWidth = 544
          end
          inherited pnlNameDescription: TPanel
            Width = 544
            ExplicitWidth = 544
            inherited edtTemplateDescription: TEdit
              Width = 538
              ExplicitWidth = 538
            end
            inherited edtTemplateName: TEdit
              Width = 538
              ExplicitWidth = 538
            end
          end
        end
        inherited ActionList1: TActionList
          Top = 20
        end
        inherited ImageList1: TImageList
          Left = 56
          Top = 176
          Bitmap = {
            494C010104000900280010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
            0000000000003600000028000000400000002000000001002000000000000020
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            FF000000FF000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            FF000000FF000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            000000000000000000000000000000000000000000000000FF000000FF000000
            FF000000FF000000FF000000FF00000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000FF000000FF000000
            FF000000FF000000FF000000FF00000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000FF000000FF000000FF0000000000000000000000
            000000000000000000000000000000000000000000000000FF000000FF000000
            FF000000FF000000FF000000FF00000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000FF000000FF000000
            FF000000FF000000FF000000FF00000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000FF000000FF000000FF0000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            FF000000FF000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            FF000000FF000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000FF0000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000FF0000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000FF000000FF00000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000FF00
            0000FF0000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000FF000000FF000000FF0000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            00000000000000000000000000000000000000000000FF000000FF000000FF00
            0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
            00000000FF000000FF00000000000000000000000000FF000000FF000000FF00
            0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
            00000000FF000000FF0000000000000000000000000000000000000000000000
            000000000000000000000000FF000000FF000000FF0000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            00000000000000000000000000000000000000000000FF000000FF000000FF00
            0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
            00000000FF000000FF00000000000000000000000000FF000000FF000000FF00
            0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
            00000000FF000000FF0000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000FF000000FF00000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000FF00
            0000FF0000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000FF0000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000FF0000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000424D3E000000000000003E000000
            2800000040000000200000000100010000000000000100000000000000000000
            000000000000000000000000FFFFFF0000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FC7FFEFFFFFFFFFFFC7FFEFFE7F8FFF8
            FC7FFC7FE7F8FFF8FC7FFC7F81FF81FFFC7FF83F81FC81FCFC7FF83FE7FCFFFC
            E00FF01FE7FFFFFFE00FF01FFFFCFFFCF01FE00FFEFCF7FCF01FE00FFE7FE7FF
            F83FFC7F80138013F83FFC7F80138013FC7FFC7FFE7FE7FFFC7FFC7FFEF8F7F8
            FEFFFC7FFFF8FFF8FEFFFC7FFFFFFFFF00000000000000000000000000000000
            000000000000}
        end
      end
    end
    object tbshtVitals: TTabSheet
      BorderWidth = 4
      Caption = 'tbshtVitals'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlCategories: TPanel
        Left = 0
        Top = 0
        Width = 546
        Height = 121
        Align = alTop
        Caption = 'pnlCategories'
        TabOrder = 0
        object Panel3: TPanel
          Left = 1
          Top = 1
          Width = 544
          Height = 20
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Categories'
          Color = clActiveCaption
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clCaptionText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object Panel2: TPanel
          Left = 1
          Top = 21
          Width = 544
          Height = 99
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel2'
          TabOrder = 1
          DesignSize = (
            544
            99)
          object lvCategories: TListView
            Left = 8
            Top = 8
            Width = 528
            Height = 83
            Anchors = [akLeft, akTop, akRight, akBottom]
            Columns = <
              item
                Caption = 'Category'
                Width = -1
                WidthType = (
                  -1)
              end
              item
                Caption = 'IEN'
                Width = 0
              end
              item
                AutoSize = True
                Caption = 'Qualifiers'
              end>
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnChange = lvCategoriesChange
            OnClick = lvCategoriesClick
            OnResize = lvCategoriesResize
          end
        end
      end
      object pnlQualifiers: TPanel
        Left = 0
        Top = 124
        Width = 546
        Height = 260
        Align = alClient
        Caption = 'pnlQualifiers'
        TabOrder = 2
        object Panel6: TPanel
          Left = 1
          Top = 1
          Width = 544
          Height = 20
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Qualifiers'
          Color = clActiveCaption
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clCaptionText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object Panel5: TPanel
          Left = 1
          Top = 21
          Width = 544
          Height = 238
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel5'
          TabOrder = 1
          DesignSize = (
            544
            238)
          object clbxQualifiers: TCheckListBox
            Left = 8
            Top = 8
            Width = 528
            Height = 221
            OnClickCheck = clbxQualifiersClickCheck
            Anchors = [akLeft, akTop, akRight, akBottom]
            Columns = 4
            ItemHeight = 13
            Sorted = True
            Style = lbOwnerDrawFixed
            TabOrder = 0
            OnClick = clbxQualifiersClick
            OnExit = clbxQualifiersExit
          end
        end
      end
      object Panel8: TPanel
        Left = 0
        Top = 121
        Width = 546
        Height = 3
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
      end
    end
    object tbshtVitalsHiLo: TTabSheet
      BorderWidth = 4
      Caption = 'tbshtVitalsHiLo'
      ImageIndex = 3
      OnResize = tbshtVitalsHiLoResize
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      inline fraLowValue: TfraVitalHiLo
        Left = 0
        Top = 0
        Width = 181
        Height = 384
        Align = alLeft
        TabOrder = 0
        ExplicitHeight = 384
        inherited Panel1: TPanel
          Height = 384
          BevelInner = bvNone
          BevelOuter = bvRaised
          Caption = ''
          ExplicitHeight = 384
          inherited pnlValue: TPanel
            Top = 334
            TabOrder = 2
            ExplicitTop = 334
          end
          inherited pnlSlider: TPanel
            Top = 37
            Height = 297
            ExplicitTop = 37
            ExplicitHeight = 297
            inherited tkbar: TTrackBar
              Left = 48
              Width = 36
              Height = 297
              TabOrder = 1
              ExplicitLeft = 48
              ExplicitWidth = 36
              ExplicitHeight = 297
            end
            inherited pnlMinMax: TPanel
              Left = 84
              Width = 95
              Height = 297
              TabOrder = 2
              ExplicitLeft = 84
              ExplicitWidth = 95
              ExplicitHeight = 297
              inherited lblMin: TLabel
                Top = 279
                ExplicitTop = 279
              end
            end
            inherited pnlSpacer: TPanel
              Width = 48
              Height = 297
              TabOrder = 0
              ExplicitWidth = 48
              ExplicitHeight = 297
            end
          end
          inherited pnlHeader: TPanel
            Height = 36
            Color = clActiveCaption
            TabOrder = 0
            ExplicitHeight = 36
            inherited lblName: TLabel
              Align = alLeft
              Font.Color = clCaptionText
              Font.Height = -12
            end
            inherited lblHiLo: TLabel
              Left = 135
              Top = 4
              Align = alRight
              Font.Color = clCaptionText
              Font.Height = -12
              ExplicitLeft = 135
              ExplicitTop = 4
            end
            inherited lblRange: TLabel
              Top = 19
              Align = alBottom
              Font.Color = clCaptionText
              Font.Height = -12
              ExplicitTop = 19
            end
          end
        end
      end
      inline fraHighValue: TfraVitalHiLo
        Left = 365
        Top = 0
        Width = 181
        Height = 384
        Align = alRight
        TabOrder = 1
        ExplicitLeft = 365
        ExplicitHeight = 384
        inherited Panel1: TPanel
          Height = 384
          Caption = ''
          ExplicitHeight = 384
          inherited pnlValue: TPanel
            Top = 334
            TabOrder = 2
            ExplicitTop = 334
          end
          inherited pnlSlider: TPanel
            Top = 37
            Height = 297
            ExplicitTop = 37
            ExplicitHeight = 297
            inherited tkbar: TTrackBar
              Height = 297
              TabOrder = 1
              ExplicitHeight = 297
            end
            inherited pnlMinMax: TPanel
              Height = 297
              TabOrder = 2
              ExplicitHeight = 297
              inherited lblMin: TLabel
                Top = 279
                ExplicitTop = 279
              end
            end
            inherited pnlSpacer: TPanel
              Height = 297
              TabOrder = 0
              ExplicitHeight = 297
            end
          end
          inherited pnlHeader: TPanel
            Height = 36
            Color = clActiveCaption
            TabOrder = 0
            ExplicitHeight = 36
            inherited lblName: TLabel
              Align = alLeft
              Font.Color = clCaptionText
              Font.Height = -12
            end
            inherited lblHiLo: TLabel
              Left = 135
              Top = 4
              Align = alRight
              Font.Color = clCaptionText
              Font.Height = -12
              ExplicitLeft = 135
              ExplicitTop = 4
            end
            inherited lblRange: TLabel
              Top = 19
              Align = alBottom
              Font.Color = clCaptionText
              Font.Height = -12
              ExplicitTop = 19
            end
          end
        end
      end
    end
    object tbshtSystemParameters: TTabSheet
      BorderWidth = 4
      Caption = 'tbshtSystemParameters'
      ImageIndex = 4
      inline fraSystemParameters: TfraSystemParameters
        Left = 0
        Top = 0
        Width = 546
        Height = 384
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 546
        ExplicitHeight = 384
        inherited Panel1: TPanel
          Width = 546
          Height = 384
          ExplicitWidth = 546
          ExplicitHeight = 384
          inherited pnlBottom: TPanel
            Width = 544
            Height = 289
            BevelInner = bvNone
            ExplicitWidth = 544
            ExplicitHeight = 289
            inherited Label1: TLabel
              Left = 0
              Top = 0
              Width = 544
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 528
            end
            inherited Label3: TLabel
              Left = 0
              Top = 251
              Width = 544
              ExplicitLeft = 0
              ExplicitTop = 251
              ExplicitWidth = 528
            end
            inherited clbxVersions: TCheckListBox
              Left = 0
              Top = 20
              Width = 544
              Height = 231
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Ctl3D = False
              ParentCtl3D = False
              ExplicitLeft = 0
              ExplicitTop = 20
              ExplicitWidth = 544
              ExplicitHeight = 231
            end
          end
          inherited pnlMain: TPanel
            Width = 544
            BevelInner = bvNone
            ExplicitWidth = 544
            DesignSize = (
              544
              73)
            inherited edtWebLink: TEdit
              Width = 545
              ExplicitWidth = 545
            end
            inherited cbxAllowUserTemplates: TCheckBox
              Width = 145
              ExplicitWidth = 145
            end
          end
          inherited pnlHeader: TPanel
            Width = 544
            BevelInner = bvNone
            Font.Height = -12
            ExplicitLeft = 1
            ExplicitTop = 1
            ExplicitWidth = 544
          end
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 30
    Width = 185
    Height = 423
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel1'
    Constraints.MaxWidth = 300
    Constraints.MinWidth = 150
    TabOrder = 1
    DesignSize = (
      185
      423)
    object tv: TTreeView
      Left = 8
      Top = 10
      Width = 177
      Height = 389
      HelpContext = 1
      Anchors = [akLeft, akTop, akRight, akBottom]
      Constraints.MaxWidth = 300
      Constraints.MinWidth = 150
      HideSelection = False
      Images = ImageList1
      Indent = 19
      ReadOnly = True
      SortType = stText
      TabOrder = 0
      OnChange = tvChange
      OnCollapsed = tvCollapsed
      OnEdited = tvEdited
      OnExpanded = tvExpanded
    end
  end
  object actions: TActionList
    Images = ImageList1
    Left = 32
    Top = 304
    object actFileNewTemplate: TAction
      Category = 'Template'
      Caption = '&NewTemplate ...'
      Hint = 'Create a New Vitals Input Template'
      ImageIndex = 2
      OnExecute = actFileNewTemplateExecute
    end
    object actFileSaveTemplate: TAction
      Category = 'Template'
      Caption = '&Save Template'
      Enabled = False
      Hint = 'Save Template'
      ImageIndex = 4
      OnExecute = actFileSaveTemplateExecute
    end
    object actFileDeleteTemplate: TAction
      Category = 'Template'
      Caption = '&Delete Template ...'
      Enabled = False
      Hint = 'Delete Template'
      ImageIndex = 5
      OnExecute = actFileDeleteTemplateExecute
    end
    object actFileExit: TAction
      Category = 'File'
      Caption = 'E&xit'
      OnExecute = actFileExitExecute
    end
    object actFileMakeDefault: TAction
      Category = 'Template'
      Caption = 'Set &Default Template'
      Enabled = False
      Hint = 'Set Template as Default'
      ImageIndex = 3
      OnExecute = actFileMakeDefaultExecute
    end
    object actQualifierNew: TAction
      Category = 'Qual'
      Caption = '&New Qualifier'
      Hint = 'Create new vitals qualifier'
      ImageIndex = 2
      OnExecute = actQualifierNewExecute
    end
    object actQualifierEdit: TAction
      Category = 'Qual'
      Caption = '&Edit Qualifier'
      Enabled = False
      Hint = 'Edit qualifer name and abbreviation'
      ImageIndex = 8
      OnExecute = actQualifierEditExecute
    end
    object actHelpIndex: TAction
      Caption = '&Index'
      Hint = 'Display Help File Index'
      ImageIndex = 9
      OnExecute = actHelpIndexExecute
    end
    object actHelpContents: TAction
      Caption = '&Contents'
      OnExecute = actHelpContentsExecute
    end
    object actPrint: TAction
      Category = 'File'
      Caption = '&Print Qualifiers Table'
      Hint = 'Print Qualifiers Table'
      ImageIndex = 10
      OnExecute = actPrintExecute
    end
    object actAbnormalSave: TAction
      Caption = 'Save &Abnormal Values'
      Enabled = False
      Hint = 'Save Abnormal Values'
      ImageIndex = 4
      OnExecute = actAbnormalSaveExecute
    end
    object actSaveParameters: TAction
      Category = 'File'
      Caption = '&Save System Parameters'
      Enabled = False
      ImageIndex = 4
      OnExecute = actSaveParametersExecute
    end
    object actWebLink: TAction
      Caption = 'Vitals &Website ...'
      OnExecute = actWebLinkExecute
    end
    object acQuailfiers: TAction
      Caption = 'Qualifiers'
      OnExecute = acQuailfiersExecute
    end
    object acLog: TAction
      Caption = 'Show Log'
      OnExecute = acLogExecute
    end
  end
  object MainMenu1: TMainMenu
    Images = ImageList1
    OwnerDraw = True
    Left = 32
    Top = 336
    object mnFile: TMenuItem
      Caption = '&File'
      object mnFilePrint: TMenuItem
        Action = actPrint
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnFileExit: TMenuItem
        Action = actFileExit
      end
    end
    object msSystemParameters: TMenuItem
      Caption = 'System Parameters'
      object mnSystemParametersSave: TMenuItem
        Action = actSaveParameters
      end
    end
    object mnAbnormal: TMenuItem
      Caption = 'A&bnormal Values'
      object mnAbnormalSave: TMenuItem
        Action = actAbnormalSave
      end
    end
    object mnTemplates: TMenuItem
      Caption = '&Templates'
      object mnTemplateNew: TMenuItem
        Action = actFileNewTemplate
      end
      object mnTemplateSave: TMenuItem
        Action = actFileSaveTemplate
      end
      object mnTemplateDelete: TMenuItem
        Action = actFileDeleteTemplate
      end
      object mnTemplateSetAsDefault: TMenuItem
        Action = actFileMakeDefault
      end
    end
    object Qualifiers1: TMenuItem
      Action = acQuailfiers
    end
    object mnQual: TMenuItem
      Caption = '&Qualifiers'
      Visible = False
      object mnQualNew: TMenuItem
        Action = actQualifierNew
      end
      object mnQualEdit: TMenuItem
        Action = actQualifierEdit
      end
    end
    object mnHelp: TMenuItem
      Caption = '&Help'
      object mnHelpIndex: TMenuItem
        Action = actHelpIndex
      end
      object mnHelpContents: TMenuItem
        Action = actHelpContents
      end
      object VitalsWebsite1: TMenuItem
        Action = actWebLink
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnHelpAbout: TMenuItem
        Caption = '&About'
        OnClick = mnHelpAboutClick
      end
      object ShowLog1: TMenuItem
        Action = acLog
      end
    end
  end
  object ImageList1: TImageList
    Left = 64
    Top = 336
    Bitmap = {
      494C01010B000E00240010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000000000000000000000000000FFFFFF000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00C6C6C600FFFFFF00000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C60000FFFF0000FFFF0000FFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600C6C6C600FFFF
      FF000000000000000000FF000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600848484008484840084848400C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00C6C6C600C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000FF0000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000848484008484
      8400848484000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000C6C6C600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000084848400FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000FFFF0000000000000000008484
      84000000000000000000FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00008484000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF000000000000FFFF00FFFFFF000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000FFFF000084840000000000000000000000000000FFFF0000FFFF000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF00008484000000000000000000000000000000000000FFFF000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000848400000000000000000000FFFF0000FFFF000084
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      840000848400000000000000000000000000000000000000000000000000C6C6
      C600C6C6C6000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424200000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      840000848400000000000000000000000000000000000000000000000000C6C6
      C600C6C6C6000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084844200F7CE
      A500F7CEA500C6C6C600C6C68400F7CEA500F7CEA500F7CEA500F7CEA500F7CE
      A500F7CEA5000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000084
      840000848400000000000000000000000000000000000000000000000000C6C6
      C600C6C6C6000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000042424200FFFF
      FF00FFFFFF00C6A5E70084C68400FFFFFF00FFFFFF00C6DEC600FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000042420000F7CE
      A500F7CEA500C6C6C600C6DEC600F7CEA50084C68400C6DEC600C6C68400F7CE
      A500F7CEA5000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084844200F7CE
      A500F7CEA500C6C6C600F7CEA50084C64200F7CEA500F7CEA50084C68400F7CE
      A500F7CEA5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000084840000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000042424200FFFF
      FF00FFFFFF00C6A5E700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000042420000F7CE
      A500F7CEA500C6C6C600F7CEA500F7CEA500F7CEA500F7CEA500F7CEA50084C6
      4200F7CEA5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084844200F7CE
      A500F7CEA500C6C6C600F7CEA500F7CEA500F7CEA500F7CEA500F7CEA500F7CE
      A50084C642000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000084
      840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000042424200FFFF
      FF00FFFFFF00C6A5E700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6DEC6000042000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000084
      840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000042420000F7CE
      A500F7CEA500C6C6C600F7CEA500F7CEA500F7CEA500F7CEA500F7CEA500F7CE
      A500F7CEA5000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000084
      840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084844200F7CE
      A500F7CEA500C6C6C600F7CEA500F7CEA500F7CEA500F7CEA500F7CEA500F7CE
      A500F7CEA5000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C60000000000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000042424200FFFF
      FF00FFFFFF00C6A5E700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424242000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000000000000000000000000000000000000000000000000084848400FFFF
      FF0000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF0084848400000000000000000084848400FFFFFF0000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60000000000848484000000000084848400FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C6008484840000000000848484000000000084848400FFFFFF0000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF000000000000FFFF0000000000000000000000000000FF
      FF000000000000000000000000000000000084848400FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF000000000084848400848484000000000084848400FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      840000000000C6C6C600848484000000000084848400FFFFFF0000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840000FFFF00848484000000000084848400FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF0000000000FFFFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF00000000000000000000FFFF000000000000FFFF000000
      0000000000000000000000000000000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00C6C6C600848484000000000084848400FFFFFF0000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00848484000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF000000000000FFFF000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C600FFFFFF0084848400848484008484
      84008484840084848400848484000000000084848400C6C6C60000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C6008484840084848400848484008484
      840084848400848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484840000000000000000000000
      0000000000000000000000000000000000000000000084848400C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C600848484000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FF3FFFFFFFFF0000FC1FFE7FC0070000
      F00FFC3F80030000E007FC3F00010000E003FE7F00010000E001FC3F00010000
      0000FC3F000000000000FC3F000000000000FC1F800000000000F20FC0000000
      0005E107E0010000F067E187E0070000F0FFE007F0070000E7FFF00FF0030000
      CFFFF81FF8030000DFFFFFFFFFFF0000FFFFFFFFFFFFFFFFE000FFFFFFFFFF7F
      C000DFFBC003FE3FC0008FFFC003FC1FC00087F7C003F80FC000C7EFC003F007
      C000E3CFC003FFFFC000F19FC003FFFFC000F83FC003FFFFC000FC7FC003F007
      C000F83FC003F80FC000F19FC003FC1FC000C3CFC003FE3FC00087E7C003FF7F
      C0008FFBC003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      E0008001C007C007C0000001C007C007C0000001C007C00780000001C007C007
      80000001C007C00700000001C007C00700000001C007C00700000001C007C007
      80000001C007C00780000001C007C00780010003C00FC00FC07F80FFC01FC01F
      E0FFC1FFC03FC03FFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object CCRContextor: TCCRContextor
    ApplicationName = 'VitalsManager#'
    NotificationFilter = 'User'
    OnCommitted = CCRContextorCommitted
    Left = 24
    Top = 56
  end
  object ApplicationEvents: TApplicationEvents
    OnHelp = ApplicationEventsHelp
    Left = 24
    Top = 88
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 104
    Top = 64
  end
end
