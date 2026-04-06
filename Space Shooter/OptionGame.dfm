object OptionForm: TOptionForm
  Left = 297
  Top = 168
  Width = 334
  Height = 250
  Caption = 'OptionForm'
  Color = clWindowText
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
    Left = 16
    Top = 4
    Width = 129
    Height = 25
    Caption = 'Volume Musique : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -20
    Font.Name = 'Zombie Guts Yanked'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 24
    Top = 76
    Width = 98
    Height = 25
    Caption = 'Volume SFX : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -20
    Font.Name = 'Zombie Guts Yanked'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object TrackMusiqueVolume: TTrackBar
    Left = 104
    Top = 48
    Width = 150
    Height = 25
    Max = 255
    Frequency = 15
    TabOrder = 0
    ThumbLength = 10
  end
  object TrackSFXVolume: TTrackBar
    Left = 104
    Top = 112
    Width = 150
    Height = 25
    Max = 255
    Frequency = 15
    TabOrder = 1
    ThumbLength = 10
  end
  object OkOptionVolume: TButton
    Left = 240
    Top = 168
    Width = 75
    Height = 25
    Caption = 'O K'
    TabOrder = 2
  end
end
