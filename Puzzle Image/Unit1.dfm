object Form1: TForm1
  Left = 374
  Top = 191
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Puzzle Picture'
  ClientHeight = 245
  ClientWidth = 223
  Color = clWindow
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 83
    Width = 53
    Height = 13
    Caption = 'Movement:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 56
    Top = 156
    Width = 23
    Height = 13
    Caption = 'Size:'
  end
  object Label3: TLabel
    Left = 16
    Top = 16
    Width = 180
    Height = 39
    Caption = 'Puzzle Picture'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Impact'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 129
    Top = 208
    Width = 79
    Height = 25
    Caption = 'Start Puzzle'
    TabOrder = 0
    TabStop = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 33
    Top = 207
    Width = 79
    Height = 25
    Caption = 'Picture'
    TabOrder = 1
    TabStop = False
    OnClick = Button2Click
  end
  object cbTaille: TComboBox
    Left = 89
    Top = 153
    Width = 79
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    TabStop = False
    Text = '4 X 4'
    Items.Strings = (
      '4 X 4'
      '8 X 8'
      '12 X 12'
      '16 X 16'
      '32 X 32')
  end
  object CheckBox1: TCheckBox
    Left = 91
    Top = 120
    Width = 53
    Height = 17
    TabStop = False
    Caption = 'Sound'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 90
    Top = 79
    Width = 46
    Height = 21
    TabStop = False
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    TabOrder = 4
    Text = '0'
    OnKeyPress = Edit1KeyPress
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 72
    object File1: TMenuItem
      Caption = '&File'
      object Open1: TMenuItem
        Caption = '&Open'
        OnClick = Open1Click
      end
      object Convert1: TMenuItem
        Caption = '&Convert JPG->BMP'
        OnClick = Convert1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = '&Exit'
        OnClick = Exit1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Bitmap (*.bmp)|*.bmp|Jpg (*.jpg)|*.jpg'
    Left = 40
    Top = 72
  end
end
