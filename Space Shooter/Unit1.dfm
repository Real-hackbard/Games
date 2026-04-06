object Form1: TForm1
  Left = 396
  Top = 142
  Width = 640
  Height = 480
  Caption = 'Space Shooter'
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 64
    Top = 176
    Width = 383
    Height = 80
    Caption = 'Space Shooter'
    Font.Charset = ANSI_CHARSET
    Font.Color = clSilver
    Font.Height = -64
    Font.Name = 'Impact'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 120
    Top = 251
    Width = 78
    Height = 13
    Caption = 'Start New Game'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object PanelInfo: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 65
    Align = alTop
    Color = clWindowText
    TabOrder = 0
    DesignSize = (
      624
      65)
    object Label1: TLabel
      Left = 80
      Top = 4
      Width = 57
      Height = 23
      Caption = 'Power'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -20
      Font.Name = 'Zombie Guts Yanked'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object PowerGauge: TGauge
      Left = 32
      Top = 32
      Width = 153
      Height = 20
      BackColor = clWindow
      Color = clBlack
      ForeColor = clLime
      ParentColor = False
      Progress = 0
    end
    object Label2: TLabel
      Left = 523
      Top = 4
      Width = 70
      Height = 23
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'SCORE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -20
      Font.Name = 'Zombie Guts Yanked'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object LabScore: TLabel
      Left = 523
      Top = 32
      Width = 70
      Height = 23
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'SCORE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -20
      Font.Name = 'Zombie Guts Yanked'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 242
      Top = 4
      Width = 116
      Height = 23
      Anchors = [akTop]
      Caption = 'Gauge Shoot'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -20
      Font.Name = 'Zombie Guts Yanked'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object GaugeShoot: TGauge
      Left = 221
      Top = 32
      Width = 153
      Height = 20
      Anchors = [akTop]
      BackColor = clWindow
      Color = clBlack
      ForeColor = clLime
      ParentColor = False
      Progress = 0
    end
    object Label4: TLabel
      Left = 400
      Top = 4
      Width = 112
      Height = 23
      Anchors = [akTop]
      Caption = 'Laser Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -20
      Font.Name = 'Zombie Guts Yanked'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object GaugeEtatLaser: TGauge
      Left = 400
      Top = 32
      Width = 113
      Height = 20
      Anchors = [akTop]
      BackColor = clWindow
      Color = clBlack
      ForeColor = clLime
      ParentColor = False
      Progress = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 48
    Top = 96
    object mFichier: TMenuItem
      Caption = 'Game'
      object miNewP: TMenuItem
        Caption = '&New Game'
        OnClick = miNewPClick
      end
      object miPause: TMenuItem
        Caption = 'Pause'
        Enabled = False
        OnClick = miPauseClick
      end
      object miQuitter: TMenuItem
        Caption = '&Quit'
        OnClick = miQuitterClick
      end
    end
  end
end
