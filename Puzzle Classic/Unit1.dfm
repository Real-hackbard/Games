object Form1: TForm1
  Left = 242
  Top = 45
  HelpContext = 1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Puzzle Classic'
  ClientHeight = 637
  ClientWidth = 920
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PopupMenu = PopUpMenu1
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object f_puzzle: TPanel
    Left = 0
    Top = 0
    Width = 920
    Height = 637
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 192
      Height = 637
      Align = alLeft
      BevelOuter = bvNone
      Color = 15790320
      TabOrder = 0
      object RadioGroup1: TRadioGroup
        Left = 16
        Top = 152
        Width = 161
        Height = 81
        Caption = ' Parts '
        ItemIndex = 1
        Items.Strings = (
          '12 - easy'
          '48 - difficult'
          '192 - extreme')
        TabOrder = 0
        TabStop = True
      end
      object RadioGroup2: TRadioGroup
        Left = 16
        Top = 248
        Width = 161
        Height = 65
        Caption = ' Difficulty level '
        ItemIndex = 0
        Items.Strings = (
          'without rotation'
          'with rotation')
        TabOrder = 1
      end
      object Memo1: TMemo
        Left = 16
        Top = 368
        Width = 161
        Height = 209
        BorderStyle = bsNone
        Color = 15790320
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        Lines.Strings = (
          'A left mouse click and'
          'moving the mouse'
          'moves the'
          'selected part.'
          ''
          'A right mouse click'
          'rotates the part by'
          '90'#176'.'
          ''
          'Custom images are '
          'stretched or '
          'compressed '
          'to the format 640 x'
          '480.')
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object Listbox1: TListBox
        Left = 16
        Top = 54
        Width = 161
        Height = 84
        BorderStyle = bsNone
        Color = 15790320
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        IntegralHeight = True
        ItemHeight = 14
        Items.Strings = (
          'Abu Simbel'#9'38'
          'Adam-Ries-Museum'#9'93'
          'Azure-Window'#9'75'
          'Basilius-Kathedrale'#9'65'
          'Burg Kriebstein'#9'91'
          'Che Guevara'#9'95'
          'Chich'#233'n Itz'#225#9'50'
          'Delphi'#9'72'
          'Dresden-Zwinger'#9'105'
          'Galilei-Plastik'#9'83'
          'Gem'#228'lde'#9'104'
          'G'#246'ltzschtalbr'#252'cke'#9'52'
          'Hiroshima-Memorial'#9'70'
          'Karl Marx Monument'#9'41'
          'Kleine Meerjungfrau'#9'90'
          'Kreidefelsen'#9'78'
          'Meerschweinchen'#9'87'
          'Meteora'#9'74'
          'Portr'#228'tfoto'#9'10'
          'Saturn'#9'11'
          'Spaghettimonster'#9'7'
          'Spirale'#9'94'
          'Taj Mahal'#9'37'
          'Warnem'#252'nde'#9'107'
          'Wartburg'#9'33')
        ParentFont = False
        Sorted = True
        TabOrder = 3
        TabWidth = 160
        OnClick = ListBox1Click
      end
      object Button1: TButton
        Left = 16
        Top = 16
        Width = 161
        Height = 25
        Caption = 'Load Random'
        TabOrder = 4
        OnClick = Button1Click
      end
      object Button4: TButton
        Left = 16
        Top = 328
        Width = 161
        Height = 25
        Caption = 'Load your own image'
        TabOrder = 5
        OnClick = Button4Click
      end
      object Button2: TButton
        Left = 16
        Top = 584
        Width = 161
        Height = 25
        Caption = 'Show solution'
        TabOrder = 6
        OnClick = Button2Click
      end
    end
    object Panel4: TPanel
      Left = 196
      Top = 0
      Width = 724
      Height = 637
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      object PaintBox1: TPaintBox
        Left = 40
        Top = 48
        Width = 640
        Height = 480
        OnMouseDown = PaintBox1MouseDown
        OnMouseMove = PaintBox1MouseMove
        OnMouseUp = PaintBox1MouseUp
        OnPaint = puzzledarstellen
      end
      object Image5: TImage
        Left = 40
        Top = 48
        Width = 640
        Height = 480
        Visible = False
      end
      object Image1: TImage
        Left = 760
        Top = 344
        Width = 160
        Height = 160
        Visible = False
      end
      object Image2: TImage
        Left = 744
        Top = 256
        Width = 80
        Height = 80
        Visible = False
      end
      object Label1: TLabel
        Left = 72
        Top = 552
        Width = 96
        Height = 25
        Caption = 'Moves 0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -21
        Font.Name = 'Verdana'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 408
        Top = 552
        Width = 57
        Height = 25
        Caption = 'Time'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -21
        Font.Name = 'Verdana'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 72
        Top = 584
        Width = 70
        Height = 25
        Caption = 'xxxxx'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -21
        Font.Name = 'Verdana'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
      end
      object Image3: TImage
        Left = 32
        Top = 480
        Width = 105
        Height = 105
        AutoSize = True
        Visible = False
      end
      object Image4: TImage
        Left = 24
        Top = 416
        Width = 40
        Height = 40
        Visible = False
      end
    end
    object Panel17: TPanel
      Left = 192
      Top = 0
      Width = 4
      Height = 637
      Align = alLeft
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 2
    end
  end
  object PopUpMenu1: TPopupMenu
    Left = 384
    Top = 128
    object M57: TMenuItem
      Caption = 'enter'
      ShortCut = 13
      Visible = False
    end
    object M35: TMenuItem
      Caption = 'schlie'#223'en'
      ShortCut = 8219
      Visible = False
      OnClick = S1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 264
    Top = 120
    object M33: TMenuItem
      Caption = 'Ende'
      ShortCut = 27
      Visible = False
      OnClick = S1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 345
    Top = 124
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'JPEG Image File (*.jpg)|*.jpg'
    Left = 305
    Top = 122
  end
end
