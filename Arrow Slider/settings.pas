unit settings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    grpSettings: TGroupBox;
    edtGridX: TEdit;
    edtGridY: TEdit;
    lblGridSize: TLabel;
    lblGridSize2: TLabel;
    cmbHorizontal: TComboBox;
    lblLineUp: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    imgTileOrder: TImage;
    lblTileOrder: TLabel;
    chkShowTime: TCheckBox;
    chkShowMoves: TCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure imgTileOrderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    procedure DisplayTileOrder();
  public
    { Public declarations }
    fGridX, fGridY, fDifficulty : integer;
    fHorizontal : boolean;
    fTileOrder : string;
    procedure DisplaySettings(pGridX, pGridY, pDifficulty : integer; pHorizontal : boolean; pTileOrder : string);
  end;

var
  Form2: TForm2;

implementation

uses
  Unit1;

{$R *.DFM}

procedure TForm2.DisplaySettings(pGridX, pGridY, pDifficulty : integer; pHorizontal : boolean; pTileOrder : string);
begin
  { save in form variables }
  fGridX := pGridX;
  fGridY := pGridY;
  fDifficulty := pDifficulty;
  fHorizontal := pHorizontal;
  fTileOrder := pTileOrder;

  { show variables on form }
  edtGridX.Text := IntToStr(fGridX);
  edtGridY.Text := IntToStr(fGridY);
  if (fHorizontal = true) then
    cmbHorizontal.ItemIndex := 0
  else
    cmbHorizontal.ItemIndex := 1;
    
  chkShowMoves.Checked := ini_ShowMoves;
  chkShowTime.Checked := ini_ShowTime;

  DisplayTileOrder();
end;

procedure TForm2.DisplayTileOrder();
var
  i, iTile : integer;
begin
  for i := 1 to 8 do
  begin
    case fTileOrder[i] of
    'U': iTile := 0 + 4; {+4 for small tiles}
    'D': iTile := 1 + 4;
    'L': iTile := 2 + 4;
    else {'R'}
      iTile := 3 + 4;
    end; {case}
    { draw example tile }
    imgTileOrder.Canvas.Draw((i-1)*32, 0, TileImages[iTile].Picture.Bitmap);
  end;

end;

procedure TForm2.btnOkClick(Sender: TObject);
begin
  { save changes in form variables }
  fGridX := StrToInt(edtGridX.Text);
  fGridY := StrToInt(edtGridY.Text);
  fHorizontal := (cmbHorizontal.ItemIndex = 0);

  ini_ShowMoves := chkShowMoves.Checked;
  ini_ShowTime := chkShowTime.Checked;
end;

procedure TForm2.imgTileOrderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { convert to grid position }
  X := (X div 32) + 1;
  if (X < 1) or (X > 8) then Exit;
  { cycle though possibilities }
  case fTileOrder[X] of
  'U': fTileOrder[X] := 'D';
  'D': fTileOrder[X] := 'L';
  'L': fTileOrder[X] := 'R';
  else {'R'}
    fTileOrder[X] := 'U';
  end; {case}
  DisplayTileOrder();
end;

end.
