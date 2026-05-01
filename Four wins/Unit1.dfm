object Form1: TForm1
  Left = 274
  Top = 168
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Four wins'
  ClientHeight = 627
  ClientWidth = 793
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 8
    Top = 40
    Width = 777
    Height = 577
    OnMouseDown = PaintBox1MouseDown
    OnPaint = PaintBox1Paint
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 57
    Height = 13
    Caption = 'on Move :'
  end
  object Label2: TLabel
    Left = 72
    Top = 8
    Width = 12
    Height = 13
    Caption = '...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnNewGame: TButton
    Left = 624
    Top = 8
    Width = 75
    Height = 25
    Caption = '&New Game'
    TabOrder = 0
    TabStop = False
    OnClick = btnNewGameClick
  end
  object btnAbout: TButton
    Left = 704
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Info'
    TabOrder = 1
    TabStop = False
    OnClick = btnAboutClick
  end
end
