object Form1: TForm1
  Left = 276
  Top = 142
  HelpContext = 798
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Wythoff'
  ClientHeight = 679
  ClientWidth = 901
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 721
    Top = 0
    Width = 180
    Height = 679
    Align = alRight
    BevelOuter = bvNone
    Color = 15790320
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 70
      Width = 68
      Height = 14
      Caption = 'Play Area :'
    end
    object Label2: TLabel
      Left = 16
      Top = 152
      Width = 130
      Height = 16
      Caption = 'Rules of the game'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 400
      Width = 68
      Height = 16
      Caption = 'Turn order'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
      Left = 24
      Top = 24
      Width = 129
      Height = 25
      Caption = 'New Game'
      Default = True
      TabOrder = 4
      TabStop = False
      OnClick = NewGame
    end
    object Me1: TMemo
      Left = 8
      Top = 176
      Width = 161
      Height = 201
      TabStop = False
      BorderStyle = bsNone
      Color = 15790320
      Lines.Strings = (
        'You and the computer '
        'take '
        'turns moving the game '
        'piece any distance '
        'horizontally, vertically, '
        'or diagonally.'
        ''
        'You make a move by '
        'clicking on an empty '
        'space.'
        ''
        'The player who reaches '
        'the bottom left space '
        'wins.')
      ReadOnly = True
      TabOrder = 0
    end
    object Check1: TCheckBox
      Left = 12
      Top = 104
      Width = 125
      Height = 17
      TabStop = False
      Caption = 'Computer starts'
      TabOrder = 1
    end
    object Check2: TCheckBox
      Left = 12
      Top = 124
      Width = 125
      Height = 17
      TabStop = False
      Caption = 'Show directions'
      TabOrder = 2
      OnClick = PaintBox1Paint
    end
    object ListBox1: TListBox
      Left = 16
      Top = 424
      Width = 145
      Height = 185
      TabStop = False
      ItemHeight = 14
      TabOrder = 3
      TabWidth = 40
    end
    object Spin1: TSpinEdit
      Left = 96
      Top = 64
      Width = 60
      Height = 23
      TabStop = False
      MaxValue = 26
      MinValue = 8
      TabOrder = 5
      Value = 25
      OnChange = NewGame
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 721
    Height = 679
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 721
      Height = 679
      Align = alClient
      OnMouseDown = PaintBox1MouseDown
      OnMouseMove = PaintBox1MouseMove
      OnPaint = PaintBox1Paint
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 48
    Top = 32
  end
end
