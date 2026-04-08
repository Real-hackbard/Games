object HelpFrm: THelpFrm
  Left = 277
  Top = 226
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Help ?'
  ClientHeight = 151
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 241
    Height = 103
    AutoSize = False
    WordWrap = True
  end
  object OkBtn: TButton
    Left = 100
    Top = 127
    Width = 51
    Height = 21
    Cursor = crHandPoint
    Caption = 'Ok'
    TabOrder = 0
    OnClick = OkBtnClick
  end
end
