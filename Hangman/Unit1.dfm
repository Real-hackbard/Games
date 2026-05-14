object Form1: TForm1
  Left = 333
  Top = 179
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Hangman'
  ClientHeight = 415
  ClientWidth = 517
  Color = clWindow
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object DeadLbl: TLabel
    Left = 358
    Top = 416
    Width = 5
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object GallowsImage: TImage
    Left = 248
    Top = 8
    Width = 257
    Height = 393
  end
  object Label1: TLabel
    Left = 24
    Top = 264
    Width = 33
    Height = 16
    Caption = 'Level'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object MaxLenLbl: TLabel
    Left = 136
    Top = 280
    Width = 84
    Height = 16
    Caption = 'Max word size'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object MaxMovesLbl: TLabel
    Left = 136
    Top = 312
    Width = 69
    Height = 16
    Caption = 'Max moves'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 248
    Top = 8
    Width = 257
    Height = 393
    Shape = bsFrame
  end
  object PlayerPanel: TPanel
    Left = 8
    Top = 8
    Width = 225
    Height = 233
    Color = clAqua
    TabOrder = 0
    Visible = False
    object Label4: TLabel
      Left = 8
      Top = 96
      Width = 134
      Height = 16
      Caption = 'Correct guesses so far'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object WordLbl: TLabel
      Left = 5
      Top = 120
      Width = 99
      Height = 16
      Caption = '_ _ _ _ _ _ _ _'
      Color = clAqua
      ParentColor = False
    end
    object Label3: TLabel
      Left = 8
      Top = 157
      Width = 106
      Height = 16
      Caption = 'All guesses so far'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 69
      Width = 74
      Height = 16
      Caption = 'Enter a letter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 8
      Top = 8
      Width = 65
      Height = 20
      Caption = 'Convict:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Guesseslbl: TLabel
      Left = 9
      Top = 176
      Width = 208
      Height = 41
      AutoSize = False
      Caption = 'xxx'
      Color = clWhite
      ParentColor = False
      WordWrap = True
    end
    object MovesLeftLbl: TLabel
      Left = 8
      Top = 40
      Width = 181
      Height = 16
      Caption = 'You have __ letter guesses left'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 112
      Top = 65
      Width = 25
      Height = 24
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 8
    Width = 225
    Height = 241
    Color = clWindow
    TabOrder = 2
    object Memo1: TMemo
      Left = 8
      Top = 8
      Width = 209
      Height = 225
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      Lines.Strings = (
        'You are sentenced to die in the '
        'gallows unless you can guess the '
        'secret word in  the maximum '
        'number of guesses or less!'
        ''
        'Drag the "Level" trackbar pointer '
        'to  change difficulty level. '
        ''
        'Click the "New Game" button to '
        'begin play. '
        ''
        'At the highest level, you are very '
        'likely to die!')
      ParentFont = False
      TabOrder = 0
    end
  end
  object NewGameBtn: TBitBtn
    Left = 120
    Top = 376
    Width = 105
    Height = 25
    Caption = 'New Game'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TabStop = False
    OnClick = NewGameBtnClick
  end
  object Levelbar: TTrackBar
    Left = 16
    Top = 280
    Width = 105
    Height = 29
    Min = 3
    Position = 5
    TabOrder = 3
    TabStop = False
    OnChange = LevelbarChange
  end
end
