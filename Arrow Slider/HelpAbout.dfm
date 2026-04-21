object Form3: TForm3
  Left = 761
  Top = 215
  BorderStyle = bsDialog
  Caption = 'Info'
  ClientHeight = 236
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object imgIcon: TImage
    Left = 10
    Top = 12
    Width = 32
    Height = 32
  end
  object lblAbout1: TLabel
    Left = 53
    Top = 20
    Width = 82
    Height = 13
    Caption = 'Arrow Slider v1.0'
  end
  object btnOk: TButton
    Left = 113
    Top = 208
    Width = 75
    Height = 23
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
