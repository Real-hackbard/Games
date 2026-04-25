object Form1: TForm1
  Left = 547
  Top = 242
  BorderStyle = bsDialog
  Caption = 'Lights 2.0'
  ClientHeight = 407
  ClientWidth = 284
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 344
    Width = 284
    Height = 63
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      284
      63)
    object Bevel2: TBevel
      Left = 8
      Top = 5
      Width = 100
      Height = 25
      Style = bsRaised
    end
    object Shape1: TShape
      Left = 228
      Top = 26
      Width = 34
      Height = 33
      Anchors = [akTop, akRight]
      Brush.Color = clLime
    end
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 5
      Width = 100
      Height = 25
      Caption = 'New game'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object Label1: TLabel
      Left = 120
      Top = 24
      Width = 49
      Height = 16
      Alignment = taCenter
      Anchors = [akTop]
      AutoSize = False
      Caption = '99/99'
    end
    object Label2: TLabel
      Left = 121
      Top = 8
      Width = 43
      Height = 16
      Anchors = [akTop]
      AutoSize = False
      Caption = 'New:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Trebuchet MS'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 220
      Top = 8
      Width = 51
      Height = 13
      Alignment = taCenter
      Anchors = [akTop, akRight]
      Caption = 'Resultat:'
    end
    object StaticText1: TStaticText
      Left = 8
      Top = 38
      Width = 100
      Height = 20
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = '0 sec.'
      TabOrder = 0
    end
    object UpDown: TUpDown
      Left = 120
      Top = 40
      Width = 49
      Height = 17
      Anchors = [akTop]
      ArrowKeys = False
      Min = 1
      Max = 99
      Orientation = udHorizontal
      Position = 1
      TabOrder = 1
      Thousands = False
      OnClick = UpDownClick
    end
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 999
    OnTimer = Timer2Timer
    Left = 56
    Top = 280
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 24
    Top = 280
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.lgh'
    Filter = 'Fichiers Lights 1.3 (*.lgh)|*.lgh'
    Title = 'Ouvrir un fichier de jeu'
    Left = 88
    Top = 280
  end
end
