object Form1: TForm1
  Left = 224
  Top = 138
  Hint = 'Test'
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Maze Editor'
  ClientHeight = 652
  ClientWidth = 939
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 112
    Top = 32
    object F1: TMenuItem
      Caption = 'File'
      object C1: TMenuItem
        Caption = 'Close'
        OnClick = C1Click
      end
    end
    object A1: TMenuItem
      Caption = 'Action'
      object S1: TMenuItem
        Caption = 'Start'
        OnClick = S1Click
      end
      object N1: TMenuItem
        Caption = 'New Maze'
        OnClick = N1Click
      end
    end
    object V1: TMenuItem
      Caption = 'View'
      object L1: TMenuItem
        AutoCheck = True
        Caption = 'Lines'
        OnClick = L1Click
      end
    end
    object A2: TMenuItem
      Caption = 'Help'
      object A3: TMenuItem
        Caption = 'About'
        OnClick = A3Click
      end
    end
  end
end
