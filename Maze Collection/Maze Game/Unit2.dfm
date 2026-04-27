object Form2: TForm2
  Left = 778
  Top = 190
  BorderStyle = bsDialog
  Caption = 'Jump to Pos'
  ClientHeight = 157
  ClientWidth = 174
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 36
    Width = 40
    Height = 13
    Caption = 'Pos (X) :'
  end
  object Label2: TLabel
    Left = 48
    Top = 68
    Width = 40
    Height = 13
    Caption = 'Pos (Y) :'
  end
  object SpinEdit1: TSpinEdit
    Left = 96
    Top = 32
    Width = 57
    Height = 22
    TabStop = False
    MaxLength = 3
    MaxValue = 580
    MinValue = 15
    TabOrder = 0
    Value = 15
  end
  object SpinEdit2: TSpinEdit
    Left = 96
    Top = 64
    Width = 57
    Height = 22
    TabStop = False
    MaxLength = 3
    MaxValue = 810
    MinValue = 15
    TabOrder = 1
    Value = 15
  end
  object Button1: TButton
    Left = 88
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    TabStop = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Jump'
    TabOrder = 3
    TabStop = False
    OnClick = Button2Click
  end
end
