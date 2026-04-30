object Form1: TForm1
  Left = 384
  Top = 158
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Tic-Tac-Toe'
  ClientHeight = 589
  ClientWidth = 813
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object PaintBox1: TPaintBox
    Left = 224
    Top = 8
    Width = 569
    Height = 561
    OnMouseDown = PaintBox1MouseDown
    OnPaint = PaintBox1Paint
  end
  object Panel3: TPanel
    Left = 8
    Top = 8
    Width = 201
    Height = 556
    BevelOuter = bvNone
    Color = 15790320
    TabOrder = 0
    object Label1: TLabel
      Left = 64
      Top = 116
      Width = 5
      Height = 16
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 24
      Top = 164
      Width = 5
      Height = 16
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object PaintBox2: TPaintBox
      Left = 8
      Top = 192
      Width = 185
      Height = 169
      OnPaint = PaintBox2Paint
    end
    object Label3: TLabel
      Left = 16
      Top = 140
      Width = 53
      Height = 16
      Caption = 'Results'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 16
      Top = 92
      Width = 154
      Height = 14
      Caption = 'Intelligence                 %'
    end
    object Button1: TButton
      Left = 24
      Top = 24
      Width = 145
      Height = 25
      Caption = 'New Game'
      Default = True
      TabOrder = 1
      TabStop = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 384
      Width = 182
      Height = 25
      Caption = 'Computer vs Computer'
      TabOrder = 2
      TabStop = False
      OnClick = Button2Click
    end
    object CheckBox1: TCheckBox
      Left = 24
      Top = 60
      Width = 145
      Height = 17
      TabStop = False
      Caption = 'Computer starts'
      TabOrder = 0
    end
    object SpinEdit1: TSpinEdit
      Left = 96
      Top = 88
      Width = 57
      Height = 23
      TabStop = False
      MaxValue = 100
      MinValue = 0
      TabOrder = 3
      Value = 100
    end
    object ListBox1: TListBox
      Left = 32
      Top = 432
      Width = 121
      Height = 97
      ItemHeight = 14
      Items.Strings = (
        '000000000'#9'123456789'
        '100000000'#9'5'
        '010000000'#9'5'
        '001000000'#9'5'
        '000100000'#9'5'
        '000010000'#9'1379'
        '000001000'#9'5'
        '000000100'#9'5'
        '000000010'#9'5'
        '000000001'#9'5'
        '200000000'#9'5'
        '020000000'#9'5'
        '002000000'#9'5'
        '000200000'#9'5'
        '000020000'#9'1379'
        '000002000'#9'5'
        '000000200'#9'5'
        '000000020'#9'5'
        '000000002'#9'5')
      TabOrder = 4
      Visible = False
    end
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 144
    Top = 264
  end
end
