object Form1: TForm1
  Left = 275
  Top = 141
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Pong Classic'
  ClientHeight = 601
  ClientWidth = 784
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    784
    601)
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 32
    Top = 168
    Width = 40
    Height = 100
    Shape = stRoundRect
  end
  object Shape2: TShape
    Left = 720
    Top = 192
    Width = 40
    Height = 100
    Anchors = [akRight]
    Shape = stRoundRect
  end
  object shape3: TShape
    Left = 96
    Top = 176
    Width = 25
    Height = 25
    Shape = stCircle
  end
  object Shape4: TShape
    Left = 395
    Top = 8
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape5: TShape
    Left = 395
    Top = 48
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape6: TShape
    Left = 395
    Top = 88
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape7: TShape
    Left = 395
    Top = 128
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape8: TShape
    Left = 395
    Top = 168
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape9: TShape
    Left = 395
    Top = 208
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape10: TShape
    Left = 395
    Top = 248
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape11: TShape
    Left = 395
    Top = 288
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape12: TShape
    Left = 395
    Top = 328
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape13: TShape
    Left = 395
    Top = 368
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape14: TShape
    Left = 395
    Top = 408
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape15: TShape
    Left = 395
    Top = 448
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape16: TShape
    Left = 395
    Top = 488
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape17: TShape
    Left = 395
    Top = 528
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape18: TShape
    Left = 395
    Top = 568
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape19: TShape
    Left = 395
    Top = 608
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape20: TShape
    Left = 395
    Top = 648
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape21: TShape
    Left = 395
    Top = 688
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape22: TShape
    Left = 395
    Top = 728
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape23: TShape
    Left = 395
    Top = 768
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape24: TShape
    Left = 395
    Top = 808
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape25: TShape
    Left = 395
    Top = 848
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape26: TShape
    Left = 395
    Top = 888
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape27: TShape
    Left = 395
    Top = 928
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Shape28: TShape
    Left = 395
    Top = 968
    Width = 10
    Height = 33
    Brush.Color = clSilver
  end
  object Label1: TLabel
    Left = 280
    Top = 40
    Width = 50
    Height = 64
    Caption = '0'
    Font.Charset = OEM_CHARSET
    Font.Color = clWhite
    Font.Height = -64
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 472
    Top = 48
    Width = 50
    Height = 64
    Caption = '0'
    Font.Charset = OEM_CHARSET
    Font.Color = clWhite
    Font.Height = -64
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 368
    Top = 16
    Width = 12
    Height = 8
    Caption = '10'
    Font.Charset = OEM_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 416
    Top = 16
    Width = 12
    Height = 8
    Caption = '10'
    Font.Charset = OEM_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 582
    Width = 784
    Height = 19
    Panels = <
      item
        Text = 'You :'
        Width = 50
      end
      item
        Text = '0'
        Width = 50
      end
      item
        Text = 'Computer :'
        Width = 70
      end
      item
        Text = '0'
        Width = 50
      end
      item
        Text = 'Move the paddle with the up/down cursors'
        Width = 250
      end
      item
        Text = '10 point is winner'
        Width = 50
      end>
  end
  object Timer1: TTimer
    Interval = 5
    OnTimer = Timer1Timer
    Left = 240
    Top = 168
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 280
    Top = 168
  end
  object PopupMenu1: TPopupMenu
    Left = 320
    Top = 168
    object S1: TMenuItem
      Caption = 'Stop'
      ShortCut = 116
      OnClick = S1Click
    end
    object N5: TMenuItem
      Caption = 'New Game'
      ShortCut = 78
      OnClick = N5Click
    end
    object F2: TMenuItem
      Caption = 'Fullscreen'
      ShortCut = 112
      OnClick = F2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object S2: TMenuItem
      Caption = 'Paddle Speed'
      object S3: TMenuItem
        AutoCheck = True
        Caption = 'Slow'
        RadioItem = True
      end
      object N1: TMenuItem
        AutoCheck = True
        Caption = 'Normal'
        Checked = True
        RadioItem = True
      end
      object F1: TMenuItem
        AutoCheck = True
        Caption = 'Fast'
        RadioItem = True
      end
    end
    object P1: TMenuItem
      Caption = 'Paddle Width'
      object T1: TMenuItem
        AutoCheck = True
        Caption = 'Thin'
        RadioItem = True
        OnClick = T1Click
      end
      object N2: TMenuItem
        AutoCheck = True
        Caption = 'Normal'
        Checked = True
        RadioItem = True
        OnClick = N2Click
      end
      object T2: TMenuItem
        AutoCheck = True
        Caption = 'Tick'
        RadioItem = True
        OnClick = T2Click
      end
    end
    object P2: TMenuItem
      Caption = 'Paddle Height'
      object S4: TMenuItem
        AutoCheck = True
        Caption = 'Small'
        RadioItem = True
        OnClick = S4Click
      end
      object N4: TMenuItem
        AutoCheck = True
        Caption = 'Normal'
        Checked = True
        RadioItem = True
        OnClick = N4Click
      end
      object L1: TMenuItem
        AutoCheck = True
        Caption = 'Long'
        RadioItem = True
        OnClick = L1Click
      end
    end
    object B1: TMenuItem
      Caption = 'Ball Size'
      object S5: TMenuItem
        AutoCheck = True
        Caption = 'Small'
        RadioItem = True
        OnClick = S5Click
      end
      object N8: TMenuItem
        AutoCheck = True
        Caption = 'Normal'
        Checked = True
        RadioItem = True
        OnClick = N8Click
      end
      object B2: TMenuItem
        AutoCheck = True
        Caption = 'Big'
        RadioItem = True
        OnClick = B2Click
      end
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object C1: TMenuItem
      Caption = 'Colors'
      object B3: TMenuItem
        Caption = 'Background'
        OnClick = B3Click
      end
      object P3: TMenuItem
        Caption = 'Paddles'
        OnClick = P3Click
      end
    end
    object M1: TMenuItem
      AutoCheck = True
      Caption = 'Middle Line'
      Checked = True
      ShortCut = 77
      OnClick = M1Click
    end
    object R1: TMenuItem
      AutoCheck = True
      Caption = 'Result'
      Checked = True
      ShortCut = 82
      OnClick = R1Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object difficulty1: TMenuItem
      Caption = 'Difficulty'
      object E1: TMenuItem
        AutoCheck = True
        Caption = 'Easy'
        Checked = True
        RadioItem = True
      end
      object N9: TMenuItem
        AutoCheck = True
        Caption = 'Normal'
        RadioItem = True
      end
      object H1: TMenuItem
        AutoCheck = True
        Caption = 'Hard'
        RadioItem = True
      end
    end
    object Winningnumber1: TMenuItem
      Caption = 'Winning number'
      OnClick = Winningnumber1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object Q1: TMenuItem
      Caption = 'Qiut'
      ShortCut = 27
      OnClick = Q1Click
    end
  end
  object ColorDialog1: TColorDialog
    Left = 240
    Top = 208
  end
end
