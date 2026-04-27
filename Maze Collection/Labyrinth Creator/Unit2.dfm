object Form2: TForm2
  Left = 281
  Top = 167
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 207
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 27
    Width = 172
    Height = 13
    Caption = 'Width and height of the fields:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 85
    Top = 61
    Width = 96
    Height = 13
    Caption = 'Number of rows:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 66
    Top = 94
    Width = 116
    Height = 13
    Caption = 'Number of columns:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 143
    Top = 126
    Width = 38
    Height = 13
    Caption = 'Delay:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object SpinEdit1: TSpinEdit
    Left = 192
    Top = 24
    Width = 121
    Height = 22
    TabStop = False
    MaxValue = 100
    MinValue = 1
    TabOrder = 0
    Value = 16
  end
  object SpinEdit2: TSpinEdit
    Left = 192
    Top = 56
    Width = 121
    Height = 22
    TabStop = False
    MaxValue = 500
    MinValue = 1
    TabOrder = 1
    Value = 40
  end
  object SpinEdit3: TSpinEdit
    Left = 192
    Top = 88
    Width = 121
    Height = 22
    TabStop = False
    MaxValue = 500
    MinValue = 1
    TabOrder = 2
    Value = 60
  end
  object SpinEdit4: TSpinEdit
    Left = 192
    Top = 120
    Width = 121
    Height = 22
    TabStop = False
    MaxValue = 500
    MinValue = -1
    TabOrder = 3
    Value = 10
  end
  object Button1: TButton
    Left = 120
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 4
    TabStop = False
    OnClick = Button1Click
  end
end
