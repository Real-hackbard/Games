unit goal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TForm4 = class(TForm)
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DrawGoalTiles();
    procedure UpdatePlacement();
  end;

var
  Form4: TForm4;

implementation

uses
  Unit1;

{$R *.DFM}

procedure TForm4.DrawGoalTiles();
var
  x, y, iTile : integer;
begin
  { adjust goalscreen size }
  Self.ClientWidth := ini_GridX * 32;
  Self.ClientHeight := ini_GridY * 32;

  { force resize of image, else it is not shown completely }
  Image1.Picture.Bitmap.Width := ini_GridX * 32;
  Image1.Picture.Bitmap.Height := ini_GridY * 32;
  
  { so goalimage resizes as well }
  Application.ProcessMessages();
  
  { draw goal tiles }
  for x := 0 to ini_GridX-1 do
    for y := 0 to ini_GridY-1 do
    begin
      iTile := GoalTiles[x, y].iDirection;
      Image1.Canvas.Draw(x*32, y*32, TileImages[iTile+4].Picture.Bitmap); { +4 for small tiles }
      { draw numbers if difficulty is hard }
      if (ini_Difficulty = 3) then
        DrawOutlinedText(Image1.Canvas, x*32, y*32, iTile, IntToStr(GoalTiles[x, y].iNumber));
    end;

end;

procedure TForm4.UpdatePlacement();
begin
  Self.Left := Form1.Left + Form1.Width + 8;
  Self.Top := Form1.Top;
end;


procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.miShowGoalClick(Sender);
end;

end.
