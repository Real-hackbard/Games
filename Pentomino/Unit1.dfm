object Form1: TForm1
  Left = 234
  Top = 205
  HelpContext = 500
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Pentomino'
  ClientHeight = 708
  ClientWidth = 982
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object P1: TPanel
    Left = 0
    Top = 0
    Width = 982
    Height = 27
    Align = alTop
    Caption = 'Pentomino'
    Color = 15790320
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Verdana'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 0
    object TB1: TToolBar
      Left = 1
      Top = 1
      Width = 23
      Height = 25
      Align = alLeft
      AutoSize = True
      ButtonHeight = 23
      Color = 15790320
      EdgeBorders = []
      ParentColor = False
      TabOrder = 0
    end
  end
  object P8: TPanel
    Left = 1
    Top = 27
    Width = 981
    Height = 681
    Align = alClient
    BevelOuter = bvNone
    Caption = 'P8'
    TabOrder = 1
    object P5: TPanel
      Left = 0
      Top = 0
      Width = 981
      Height = 575
      Align = alClient
      Color = clWhite
      TabOrder = 0
      object PaintBox1: TPaintBox
        Left = 1
        Top = 1
        Width = 979
        Height = 573
        Align = alClient
        OnMouseDown = PaintBox1MouseDown
        OnMouseMove = PaintBox1MouseMove
        OnMouseUp = PaintBox1MouseUp
        OnPaint = PaintBox1Paint
      end
    end
    object P4: TPanel
      Left = 0
      Top = 575
      Width = 981
      Height = 106
      Align = alBottom
      BevelOuter = bvNone
      Color = 15790320
      TabOrder = 1
      object L1: TLabel
        Left = 258
        Top = 16
        Width = 12
        Height = 14
        Alignment = taRightJustify
        Caption = '...'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object L2: TLabel
        Left = 464
        Top = 16
        Width = 475
        Height = 56
        Caption = 
          'The area shown in gray must be completely covered with the pento' +
          'minoes.'#13#10'The pieces are moved using the left mouse button.'#13#10'A si' +
          'mple right-click rotates the pentomino.'#13#10'A right-click while hol' +
          'ding down the Ctrl key mirrors the block.'
      end
      object L3: TLabel
        Left = 180
        Top = 50
        Width = 4
        Height = 14
      end
      object LB1: TListBox
        Left = 280
        Top = 16
        Width = 161
        Height = 74
        Color = 15790320
        IntegralHeight = True
        ItemHeight = 14
        TabOrder = 0
        TabWidth = 200
        OnClick = D1Click
      end
      object Button1: TButton
        Left = 16
        Top = 16
        Width = 129
        Height = 25
        Caption = 'Reset'
        TabOrder = 1
        OnClick = D1Click
      end
      object d3: TButton
        Left = 16
        Top = 48
        Width = 129
        Height = 25
        Caption = 'Show solution'
        TabOrder = 2
        OnClick = D3Click
      end
    end
  end
  object P2: TPanel
    Left = 0
    Top = 27
    Width = 1
    Height = 681
    Align = alLeft
    BevelOuter = bvNone
    Color = 15790320
    TabOrder = 2
    object P6: TPanel
      Left = 0
      Top = 0
      Width = 1
      Height = 498
      Align = alTop
      Color = clWhite
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 48
    Top = 72
    object M2: TMenuItem
      Caption = 'Datei'
      Visible = False
      object M3: TMenuItem
        Caption = 'Programm beenden'
        ShortCut = 27
        Visible = False
        OnClick = S7Click
      end
      object M1: TMenuItem
        Caption = 'M'
        ShortCut = 13
        Visible = False
        OnClick = D1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 97
    Top = 67
  end
end
