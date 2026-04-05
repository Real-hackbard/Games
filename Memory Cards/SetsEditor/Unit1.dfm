object Form1: TForm1
  Left = 378
  Top = 187
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Memory Cards - SetsEditor'
  ClientHeight = 418
  ClientWidth = 574
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 36
    Width = 25
    Height = 13
    Caption = 'Back'
  end
  object Label2: TLabel
    Left = 120
    Top = 36
    Width = 31
    Height = 13
    Caption = 'Card 1'
  end
  object Label3: TLabel
    Left = 232
    Top = 36
    Width = 31
    Height = 13
    Caption = 'Card 2'
  end
  object Label4: TLabel
    Left = 344
    Top = 36
    Width = 31
    Height = 13
    Caption = 'Card 3'
  end
  object Label5: TLabel
    Left = 456
    Top = 36
    Width = 31
    Height = 13
    Caption = 'Card 4'
  end
  object Label6: TLabel
    Left = 8
    Top = 224
    Width = 31
    Height = 13
    Caption = 'Card 5'
  end
  object Label7: TLabel
    Left = 120
    Top = 224
    Width = 31
    Height = 13
    Caption = 'Card 6'
  end
  object Label8: TLabel
    Left = 232
    Top = 224
    Width = 31
    Height = 13
    Caption = 'Card 7'
  end
  object Label9: TLabel
    Left = 344
    Top = 224
    Width = 31
    Height = 13
    Caption = 'Card 8'
  end
  object Label10: TLabel
    Left = 456
    Top = 224
    Width = 31
    Height = 13
    Caption = 'Card 9'
  end
  object Label11: TLabel
    Left = 8
    Top = 8
    Width = 34
    Height = 13
    Caption = 'Name :'
  end
  object Panel1: TPanel
    Left = 8
    Top = 52
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 0
    object Image1: TImage
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Panel2: TPanel
    Left = 120
    Top = 52
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 1
    object Image2: TImage
      Tag = 1
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Panel3: TPanel
    Left = 232
    Top = 52
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 2
    object Image3: TImage
      Tag = 2
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Panel4: TPanel
    Left = 344
    Top = 52
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 3
    object Image4: TImage
      Tag = 3
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Panel5: TPanel
    Left = 456
    Top = 52
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 4
    object Image5: TImage
      Tag = 4
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Panel6: TPanel
    Left = 8
    Top = 240
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 5
    object Image6: TImage
      Tag = 5
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Panel7: TPanel
    Left = 120
    Top = 240
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 6
    object Image7: TImage
      Tag = 6
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Panel8: TPanel
    Left = 232
    Top = 240
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 7
    object Image8: TImage
      Tag = 7
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Panel9: TPanel
    Left = 344
    Top = 240
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 8
    object Image9: TImage
      Tag = 8
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Panel10: TPanel
    Left = 456
    Top = 240
    Width = 106
    Height = 166
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 9
    object Image10: TImage
      Tag = 9
      Left = 3
      Top = 3
      Width = 100
      Height = 160
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Image2Click
    end
  end
  object Edit1: TEdit
    Left = 48
    Top = 4
    Width = 189
    Height = 21
    TabStop = False
    MaxLength = 32
    TabOrder = 10
    Text = '(New)'
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 68
    object File1: TMenuItem
      Caption = 'File'
      OnClick = File1Click
      object NewSet1: TMenuItem
        Caption = 'New set of cards'
        OnClick = NewSet1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object OpenSet1: TMenuItem
        Caption = 'Open a deck of cards'
        OnClick = OpenSet1Click
      end
      object SaveSet1: TMenuItem
        Caption = 'Save the card set'
        OnClick = SaveSet1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Close'
        OnClick = Exit1Click
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 
      'Tous |*.png;*.jpg;*.jpeg;*.bmp|Portable Network Graphics (*.png)' +
      '|*.png|Fichier image JPEG (*.jpg)|*.jpg|Fichier image JPEG (*.jp' +
      'eg)|*.jpeg|Bitmaps (*.bmp)|*.bmp'
    OptionsEx = [ofExNoPlacesBar]
    Left = 80
    Top = 64
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.pcs'
    Filter = 'Fichier Paazu Cards Set|*.pcs'
    OptionsEx = [ofExNoPlacesBar]
    Left = 40
    Top = 108
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.pcs'
    Filter = 'Fichier Paazu Cards Set|*.pcs'
    OptionsEx = [ofExNoPlacesBar]
    Left = 80
    Top = 112
  end
end
