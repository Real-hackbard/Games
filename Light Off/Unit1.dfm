object Form1: TForm1
  Left = 251
  Top = 167
  HelpContext = 108
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Light Off'
  ClientHeight = 547
  ClientWidth = 798
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = Button1Click
  PixelsPerInch = 96
  TextHeight = 14
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 798
    Height = 547
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 798
      Height = 547
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      object lichtaus: TPanel
        Left = 0
        Top = 0
        Width = 798
        Height = 547
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 0
        object Paintbox1: TPaintBox
          Left = 153
          Top = 0
          Width = 645
          Height = 547
          Align = alClient
          OnMouseDown = Paintbox1MouseDown
          OnPaint = Paintbox1Paint
        end
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 153
          Height = 547
          Align = alLeft
          BevelOuter = bvNone
          Color = 15790320
          TabOrder = 0
          object Label2: TLabel
            Left = 16
            Top = 24
            Width = 67
            Height = 14
            Caption = 'Field size :'
          end
          object Label1: TLabel
            Left = 16
            Top = 104
            Width = 61
            Height = 14
            Caption = 'Moves : 0'
          end
          object Label3: TLabel
            Left = 16
            Top = 192
            Width = 111
            Height = 70
            Caption = 
              'Try to convert all '#13#10'fields to white. '#13#10'A maximum of 5 '#13#10'possibl' +
              'e fields '#13#10'will be converted.'
          end
          object Label4: TLabel
            Left = 24
            Top = 304
            Width = 40
            Height = 14
            Caption = 'Light :'
          end
          object Shape1: TShape
            Left = 72
            Top = 303
            Width = 25
            Height = 17
            Cursor = crHandPoint
            OnMouseDown = Shape1MouseDown
          end
          object Button1: TButton
            Left = 16
            Top = 136
            Width = 129
            Height = 25
            Caption = 'New Game'
            TabOrder = 0
            TabStop = False
            OnClick = Button1Click
          end
          object Edit1: TEdit
            Left = 56
            Top = 48
            Width = 49
            Height = 22
            TabStop = False
            TabOrder = 1
            Text = '3'
            OnKeyPress = Edit1KeyPress
          end
          object UpDown1: TUpDown
            Left = 105
            Top = 48
            Width = 16
            Height = 22
            Associate = Edit1
            Min = 1
            Max = 20
            Position = 3
            TabOrder = 2
          end
        end
      end
    end
  end
  object ColorDialog1: TColorDialog
    Left = 184
    Top = 32
  end
end
