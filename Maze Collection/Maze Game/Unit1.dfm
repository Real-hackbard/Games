object Form1: TForm1
  Left = 275
  Top = 245
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Maze Game'
  ClientHeight = 619
  ClientWidth = 842
  Color = clBtnFace
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
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 842
    Height = 600
    Align = alClient
  end
  object Shape1: TShape
    Left = 15
    Top = 15
    Width = 7
    Height = 7
    Brush.Color = clRed
    Pen.Color = clRed
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 600
    Width = 842
    Height = 19
    Panels = <
      item
        Text = 'Begin..'
        Width = 120
      end
      item
        Text = 'Pixels Moves :'
        Width = 80
      end
      item
        Text = '0'
        Width = 120
      end
      item
        Text = 'Best :'
        Width = 40
      end
      item
        Text = '2000 Pixel'
        Width = 120
      end
      item
        Text = 'Pos X/Y :'
        Width = 50
      end
      item
        Text = '15x15'
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 112
    Top = 64
    object F1: TMenuItem
      Caption = 'File'
      object S1: TMenuItem
        Caption = 'Save'
        OnClick = S1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Q1: TMenuItem
        Caption = 'Quit'
        ShortCut = 81
        OnClick = Q1Click
      end
    end
    object M1: TMenuItem
      Caption = 'Maze'
      object N2: TMenuItem
        Caption = 'New'
        ShortCut = 112
        OnClick = N2Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object S3: TMenuItem
        Caption = 'Jump to Start'
        ShortCut = 83
        OnClick = S3Click
      end
      object J1: TMenuItem
        Caption = 'Jump to Goal'
        ShortCut = 71
        OnClick = J1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object J2: TMenuItem
        Caption = 'Jum to Pos'
        ShortCut = 116
        OnClick = J2Click
      end
    end
    object V1: TMenuItem
      Caption = 'Options'
      object B1: TMenuItem
        AutoCheck = True
        Caption = 'Bold'
        ShortCut = 66
        OnClick = B1Click
      end
      object M2: TMenuItem
        Caption = 'Maze Color'
        OnClick = M2Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object S2: TMenuItem
        AutoCheck = True
        Caption = 'Sound'
        Checked = True
        ShortCut = 123
      end
    end
    object H1: TMenuItem
      Caption = 'Help'
      object A1: TMenuItem
        Caption = 'About'
        OnClick = A1Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Bitmap (*.bmp)|*.bmp'
    Left = 152
    Top = 64
  end
  object ColorDialog1: TColorDialog
    Left = 192
    Top = 64
  end
end
