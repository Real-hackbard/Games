object Form1: TForm1
  Left = 311
  Top = 100
  Width = 425
  Height = 509
  Caption = 'Chess'
  Color = clBtnFace
  TransparentColorValue = clNavy
  Constraints.MaxHeight = 900
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 25
    Width = 409
    Height = 425
    Align = alClient
    Constraints.MaxHeight = 1000
    Constraints.MaxWidth = 1000
    OnMouseDown = Image1MouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 25
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 136
      Top = 6
      Width = 21
      Height = 13
      Caption = '       '
    end
    object Label4: TLabel
      Left = 403
      Top = 6
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 552
      Top = 8
      Width = 3
      Height = 13
    end
    object def0: TBitBtn
      Left = 0
      Top = 0
      Width = 33
      Height = 25
      Caption = '<<'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = def0Click
    end
    object def: TBitBtn
      Left = 32
      Top = 0
      Width = 33
      Height = 25
      Caption = '<'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = defClick
    end
    object ref: TBitBtn
      Left = 64
      Top = 0
      Width = 33
      Height = 25
      Caption = '>'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = refClick
    end
    object reftt: TBitBtn
      Left = 96
      Top = 0
      Width = 33
      Height = 25
      Caption = '>>'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = refttClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 112
    Top = 72
    object File1: TMenuItem
      Caption = 'File'
      object N1: TMenuItem
        Caption = 'New game with the whites'
        OnClick = N1Click
      end
      object N2: TMenuItem
        Caption = 'New game with black'
        OnClick = N2Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object S1: TMenuItem
        Caption = 'Save as...'
        OnClick = S1Click
      end
      object O1: TMenuItem
        Caption = 'Open...'
        OnClick = O1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object L1: TMenuItem
        Caption = 'Read EPD'
        OnClick = L1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object C1: TMenuItem
        Caption = 'Close'
      end
    end
    object Stop1: TMenuItem
      Caption = 'Stop'
      Visible = False
      OnClick = Stop1Click
    end
    object L2: TMenuItem
      Caption = 'Levels'
      object Level1: TMenuItem
        Caption = '3.5 blows    (t = 1)'
        OnClick = Level1Click
      end
      object Level2: TMenuItem
        Caption = '4   blows     (x5)'
        Checked = True
        OnClick = Level2Click
      end
      object Level3: TMenuItem
        Caption = '4.5 blows    (x40)'
        OnClick = Level3Click
      end
      object Level4: TMenuItem
        Caption = '5    blows    (x150)'
        OnClick = Level4Click
      end
      object Level5: TMenuItem
        Caption = '5.5 blows   (long!)'
        OnClick = Level5Click
      end
      object Level6: TMenuItem
        Caption = '6   blows (very long!)'
        OnClick = Level6Click
      end
      object Level7: TMenuItem
        Caption = '6.5  strokes  (very, very long!)'
        OnClick = Level7Click
      end
    end
    object Chess1: TMenuItem
      Caption = 'Chessboard'
      object Grand1: TMenuItem
        Caption = 'Little'
        OnClick = Grand1Click
      end
      object moyen1: TMenuItem
        Caption = 'Normal'
        OnClick = moyen1Click
      end
      object rsgrand1: TMenuItem
        Caption = 'Big'
        OnClick = rsgrand1Click
      end
      object ourner1: TMenuItem
        Caption = 'Turn'
        OnClick = ourner1Click
      end
      object Effacerlesflches1: TMenuItem
        Caption = 'Clear the arrows'
        Checked = True
        OnClick = Effacerlesflches1Click
      end
      object Bleu1: TMenuItem
        Caption = 'Blue'
        OnClick = Bleu1Click
      end
      object Olive1: TMenuItem
        Caption = 'Olive'
        OnClick = Olive1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object A1: TMenuItem
        Caption = 'About'
        OnClick = A1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.txt'
    Filter = 'Txte|*.txt'
    Left = 32
    Top = 72
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = '*.zet'
    Filter = 'Fichier Mazette|*.zet'
    Left = 32
    Top = 104
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.zet'
    Filter = 'Fichier Mazette|*.zet'
    Left = 72
    Top = 72
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 152
    Top = 72
  end
end
