object Form1: TForm1
  Left = 256
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Maze Calculator'
  ClientHeight = 498
  ClientWidth = 877
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 479
    Width = 877
    Height = 19
    Panels = <
      item
        Text = 'Size:'
        Width = 150
      end
      item
        Text = 'Node:'
        Width = 150
      end
      item
        Text = 'Start:'
        Width = 150
      end
      item
        Text = 'Ziel:'
        Width = 150
      end
      item
        Text = 'Path length:'
        Width = 150
      end
      item
        Text = 'Time [ms]:'
        Width = 150
      end
      item
        Bevel = pbNone
        Width = 1
      end>
  end
  object MainMenu1: TMainMenu
    Left = 688
    Top = 64
    object mnuStart: TMenuItem
      Caption = '&Start'
      Hint = 'Strg+S'
      ShortCut = 16467
      OnClick = mnuStartClick
    end
    object mnuStop: TMenuItem
      Caption = 'S&top'
      Hint = 'Strg+T'
      OnClick = mnuStopClick
    end
    object mnuNew: TMenuItem
      Caption = '&New'
      Hint = 'STRG+N'
      ShortCut = 16462
      OnClick = mnuNewClick
    end
    object mnuAbout: TMenuItem
      Caption = 'About'
      Enabled = False
      Hint = 'Strg+I'
      ShortCut = 16457
      OnClick = mnuAboutClick
    end
  end
end
