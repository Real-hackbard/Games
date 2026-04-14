object Form1: TForm1
  Left = 592
  Top = 156
  HelpContext = 131
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tetris Classic'
  ClientHeight = 414
  ClientWidth = 460
  Color = 15790320
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = [fsBold]
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object S6: TShape
    Left = 292
    Top = 237
    Width = 94
    Height = 25
    Brush.Style = bsClear
    Pen.Color = clRed
  end
  object S2: TShape
    Left = 215
    Top = 3
    Width = 242
    Height = 409
    Brush.Style = bsClear
    Pen.Color = clGray
  end
  object S4: TShape
    Left = 292
    Top = 133
    Width = 94
    Height = 25
    Brush.Style = bsClear
    Pen.Color = clRed
  end
  object L9: TLabel
    Left = 296
    Top = 136
    Width = 87
    Height = 20
    AutoSize = False
    Caption = '0'
    Color = clWhite
    ParentColor = False
  end
  object S1: TShape
    Left = 2
    Top = 3
    Width = 211
    Height = 409
    Brush.Style = bsClear
    Pen.Color = clGray
  end
  object PaintBox1: TPaintBox
    Left = 6
    Top = 6
    Width = 203
    Height = 403
    Color = clBlack
    ParentColor = False
    OnPaint = PaintBox1Paint
  end
  object L1: TLabel
    Left = 300
    Top = 11
    Width = 73
    Height = 14
    Caption = 'Next Stone'
  end
  object L2: TLabel
    Left = 291
    Top = 114
    Width = 50
    Height = 14
    Caption = 'Points :'
  end
  object PaintBox2: TPaintBox
    Left = 304
    Top = 30
    Width = 67
    Height = 67
    Color = clAqua
    ParentColor = False
    OnPaint = PaintBox2Paint
  end
  object L5: TLabel
    Left = 291
    Top = 166
    Width = 44
    Height = 14
    Caption = 'Lines :'
  end
  object S5: TShape
    Left = 292
    Top = 184
    Width = 94
    Height = 25
    Brush.Style = bsClear
    Pen.Color = clRed
  end
  object L8: TLabel
    Left = 296
    Top = 187
    Width = 87
    Height = 20
    AutoSize = False
    Caption = '0'
    Color = clWhite
    ParentColor = False
  end
  object L6: TLabel
    Left = 291
    Top = 219
    Width = 83
    Height = 14
    Caption = 'Game level :'
  end
  object L7: TLabel
    Left = 296
    Top = 240
    Width = 87
    Height = 20
    AutoSize = False
    Caption = '0'
    Color = clWhite
    ParentColor = False
  end
  object L4: TLabel
    Left = 305
    Top = 283
    Width = 75
    Height = 14
    Caption = 'Game Over'
  end
  object L3: TLabel
    Left = 224
    Top = 328
    Width = 220
    Height = 70
    Caption = 
      'Controls:'#13#10'Left arrow keys,'#13#10'right arrow keys, down arrow keys'#13#10 +
      'Spacebar rotates the'#13#10'part'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 32
    object M1: TMenuItem
      Caption = 'Qiut'
      ShortCut = 27
      OnClick = M1C
    end
    object M2: TMenuItem
      Caption = 'New Game'
      OnClick = M2C
    end
    object O1: TMenuItem
      Caption = 'Options'
      object M3: TMenuItem
        AutoCheck = True
        Caption = 'Music'
        Checked = True
        OnClick = M3Click
      end
      object S3: TMenuItem
        AutoCheck = True
        Caption = 'Sounds'
        Checked = True
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object S7: TMenuItem
        AutoCheck = True
        Caption = 'Stone Colors'
        Checked = True
      end
      object B1: TMenuItem
        Caption = 'Background Color'
        OnClick = B1Click
      end
    end
  end
  object ColorDialog1: TColorDialog
    Left = 112
    Top = 32
  end
end
