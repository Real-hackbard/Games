object Form2: TForm2
  Left = 451
  Top = 249
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 200
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object grpSettings: TGroupBox
    Left = 8
    Top = 8
    Width = 273
    Height = 153
    Caption = ' Settings '
    TabOrder = 0
    object lblGridSize: TLabel
      Left = 8
      Top = 24
      Width = 40
      Height = 13
      Caption = 'Grid size'
    end
    object lblGridSize2: TLabel
      Left = 160
      Top = 24
      Width = 5
      Height = 13
      Caption = 'x'
    end
    object lblLineUp: TLabel
      Left = 8
      Top = 48
      Width = 72
      Height = 13
      Caption = 'Line up colours'
    end
    object imgTileOrder: TImage
      Left = 8
      Top = 112
      Width = 256
      Height = 32
      OnMouseDown = imgTileOrderMouseDown
    end
    object lblTileOrder: TLabel
      Left = 8
      Top = 96
      Width = 47
      Height = 13
      Caption = 'Tile order:'
    end
    object edtGridX: TEdit
      Left = 120
      Top = 24
      Width = 32
      Height = 21
      TabOrder = 0
    end
    object edtGridY: TEdit
      Left = 176
      Top = 24
      Width = 32
      Height = 21
      TabOrder = 1
    end
    object cmbHorizontal: TComboBox
      Left = 120
      Top = 48
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'Horizontal'
        'Vertical')
    end
    object chkShowTime: TCheckBox
      Left = 8
      Top = 72
      Width = 105
      Height = 17
      Caption = 'Show time played'
      TabOrder = 3
    end
    object chkShowMoves: TCheckBox
      Left = 120
      Top = 72
      Width = 121
      Height = 17
      Caption = 'Show nr. of moves'
      TabOrder = 4
    end
  end
  object btnOk: TButton
    Left = 120
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 200
    Top = 168
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
