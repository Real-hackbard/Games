object Form1: TForm1
  Left = 343
  Top = 252
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Checkers'
  ClientHeight = 532
  ClientWidth = 819
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Turnlbl: TLabel
    Left = 416
    Top = 16
    Width = 97
    Height = 18
    Caption = 'Red moves'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object MustJumpLbl: TLabel
    Left = 640
    Top = 16
    Width = 91
    Height = 18
    Caption = 'Must jump'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 24
    Top = 456
    Width = 172
    Height = 18
    Caption = 'Pieces captured by:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ScoreLbl1: TLabel
    Left = 24
    Top = 488
    Width = 57
    Height = 18
    Caption = 'Red: 0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ScoreLbl2: TLabel
    Left = 200
    Top = 488
    Width = 68
    Height = 18
    Caption = 'Black: 0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object UndoLbl: TLabel
    Left = 648
    Top = 480
    Width = 145
    Height = 37
    AutoSize = False
    Caption = 'Click here or press U key to undo last move'
    WordWrap = True
    OnClick = UndoLblClick
  end
  object Button1: TButton
    Left = 520
    Top = 480
    Width = 107
    Height = 25
    Caption = 'Reset  game'
    TabOrder = 0
    TabStop = False
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 329
    Height = 417
    Caption = 'Panel1'
    Color = clWindow
    TabOrder = 1
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 313
      Height = 385
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      Lines.Strings = (
        'This program started life as an exercise in '
        'techniques'
        'for creating and managing a checkerboard in '
        'Delphi..  Along'
        'the way it turned into a basic version of "American '
        'rule" or'
        '"Straight" Checkers.'
        ''
        'In this implementation, a move is made by '
        'dragging a'
        'checker to a valid location. A text label above the'
        'board will indicate whose turn and whether a jump'
        'exists.  Multiple jumps are made as a series of '
        'single'
        'jumps.'
        ''
        'Rules:'
        ''
        '1. Pieces move diagonally; up for black, down for '
        'red'
        'pieces.'
        ''
        '2. Players alternate turns, Black moves first.'
        ''
        '3. Pieces are taken by "jumping", moving '
        'diagonally'
        'over an adjacent piece of the opposite color to an'
        'adjacent empty square. If the jumping piece has '
        'another jump'
        'available, the turn continues and that jump must '
        'be taken.'
        ''
        '4. If more than one jump is available at the start '
        'of a turn,'
        'any one may be taken.'
        ''
        '5. If a checker reaches the opposite side of the '
        'board'
        'it become a "king" and may move or jump '
        'diagonally in'
        'any direction.'
        ''
        '6. The game is over when one side captures all of '
        'the'
        'pieces, or his opponent is trapped with no move'
        'available.'
        ''
        ' ')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
