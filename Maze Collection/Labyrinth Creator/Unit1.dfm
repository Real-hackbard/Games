object Form1: TForm1
  Left = 480
  Top = 166
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Labyrinth Creator'
  ClientHeight = 421
  ClientWidth = 680
  Color = clMenu
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 136
    Top = 0
    Width = 361
    Height = 354
    OnMouseDown = Image1MouseDown
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 80
    object Datei1: TMenuItem
      Caption = 'File'
      object SpeichereIrrgarten1: TMenuItem
        Caption = 'Save Maze'
        OnClick = SpeichereIrrgarten1Click
      end
      object LaseIrgarten1: TMenuItem
        Caption = 'Load Maze'
        OnClick = LaseIrgarten1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Beenden1: TMenuItem
        Caption = 'Close'
        OnClick = Beenden1Click
      end
    end
    object ErzeugeLabyrinth1: TMenuItem
      Caption = 'Create Maze'
      object ZufaelligesLabyrinth1: TMenuItem
        Caption = 'Random Maze'
        OnClick = ZuflligeVerteilung1Click
      end
      object Beispiel11: TMenuItem
        Caption = 'Example 1'
        OnClick = Beispiel11Click
      end
      object Beispiel21: TMenuItem
        Caption = 'Example 2'
        OnClick = Beispiel21Click
      end
      object Beispiel31: TMenuItem
        Caption = 'Example 3'
        OnClick = Beispiel31Click
      end
      object Beispiel41: TMenuItem
        Caption = 'Example 4'
        OnClick = Beispiel41Click
      end
      object Beispiel51: TMenuItem
        Caption = 'Example 5'
        OnClick = Beispiel51Click
      end
      object Beispiel61: TMenuItem
        Caption = 'Example 6'
        OnClick = Beispiel61Click
      end
      object Beispiel71: TMenuItem
        Caption = 'Example 7'
        OnClick = Beispiel71Click
      end
    end
    object Start1: TMenuItem
      Caption = 'Start'
      object Bisrechtsunten1: TMenuItem
        Caption = 'To the bottom right'
        OnClick = Bisrechtsunten1Click
      end
      object WelchesZielisterreichbar1: TMenuItem
        Caption = 'What goal is achievable?'
        OnClick = WelchesZielisterreichbar1Click
      end
    end
    object Tempo1: TMenuItem
      Caption = 'Options'
      object Verzoegerung100ms: TMenuItem
        Caption = 'Delay: 100 milliseconds'
        OnClick = Verzoegerung100msClick
      end
      object Verzoegerung10ms: TMenuItem
        Caption = 'Delay: 10 milliseconds'
        OnClick = Verzoegerung10msClick
      end
      object KeineVerzgerung1: TMenuItem
        Caption = 'No delay'
        OnClick = KeineVerzgerung1Click
      end
      object VielZuSchnell1: TMenuItem
        Caption = 'Immediately shows final state'
        OnClick = VielZuSchnell1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object WeitereEinstellungen1: TMenuItem
        Caption = 'More settings...'
        OnClick = WeitereEinstellungen1Click
      end
    end
    object Hilfe1: TMenuItem
      Caption = 'Help'
      object Hinweis: TMenuItem
        Caption = 'Notice'
        OnClick = HinweisClick
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Ini Files (*.ini)|*.ini'
    Left = 24
    Top = 48
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Ini Files (*.ini)|*.ini'
    Left = 24
    Top = 16
  end
end
