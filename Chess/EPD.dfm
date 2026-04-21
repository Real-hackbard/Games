object Form3: TForm3
  Left = 381
  Top = 176
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'EPD'
  ClientHeight = 123
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 140
    Height = 13
    Caption = 'Enter or paste an EPD string :'
  end
  object Edit1: TEdit
    Left = 16
    Top = 24
    Width = 497
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 416
    Top = 72
    Width = 97
    Height = 33
    Caption = 'Back'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object Panel1: TPanel
    Left = 24
    Top = 64
    Width = 129
    Height = 49
    TabOrder = 2
    object RadioButton1: TRadioButton
      Left = 8
      Top = 8
      Width = 113
      Height = 17
      Caption = 'computer-related'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 24
      Width = 73
      Height = 17
      Caption = 'human trait'
      TabOrder = 1
    end
  end
end
