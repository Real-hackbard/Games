unit Bmp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Math, StdCtrls;

type
  TBato = record          // characteristics of a boat
            player,
            lives,
            sens : byte;
            cl : integer;
            lg : integer;
          end;
  Tval = record          // Movement/Combat Assessment Module
           ba : byte;
           cl : integer;
           lg : integer;
           val : integer;
         end;

const
  kfn  = 'BNav.sav';
  kvie : array[1..20] of byte = (4,3,3,3,3,2,2,2,2,2,4,3,3,3,3,2,2,2,2,2);

var
  dim : integer = 70;          // dimensions of a square
  rangle : extended;           // angle of rotation
  ix,iy : integer;             // length of a step
  jr,
  phase : byte;                // player game phase
  ledon,ledof,                 // LEDs on the sound button
  bato  : TBitmap;             // image of a boat
  tablo : array[0..11,0..7] of byte;      // game board
  batos : array[1..20] of TBato;          // boat storage
  tbmod : array[1..2,0..4] of TBitmap;    // images of the boats [player, lives]
  tbfon : array[1..5] of TBitmap;         // sinking boat images
  tbfeu : array[0..3] of TBitmap;         // shooting pictures
  ron   : array[0..3] of TBitmap;         // pawns for the publisher
  nbnav : array[1..2] of byte;            // boat counter
  tbvie : array[1..20] of byte;           // table of lives for initialization
  noba  : byte;
  Fsave : file of TBato;
  dir   : string;
  debug : boolean = false;
  fn    : string;
  
  procedure Trace(n1,n2 : integer);
  procedure LoadImages;
  procedure ClearImage;
  procedure MixLives;
  procedure SaveGame;
  procedure RestoreGame;
  procedure Rotation(var ABitmap : TBitmap);
  function  RotImage(srcbit: TBitmap; Angle: Extended; FPoint: TPoint;
            Background: TColor): TBitmap;

implementation

procedure Trace(n1,n2 : integer);
begin
  showmessage(inttostr(n1)+' - '+inttostr(n2));
end;

procedure LoadImages;     // initializing images
var
  i,j : byte;
begin
  for j := 1 to 2 do
  begin
    for i := 0 to 4 do
    begin
      tbmod[j,i] := TBitmap.Create;
      tbmod[j,i].LoadFromFile(ExtractFilePath(Application.ExeName) +
                              'Images\bato'+IntToStr(i)+'.bmp');
      tbmod[j,i].Transparent := true;
      if j = 1 then
      begin
        tbmod[j,i].Canvas.Brush.Color := clYellow;
        tbmod[j,i].Canvas.FloodFill(8,35,clRed,fsSurface);
      end;
    end;
  end;
  for i := 1 to 5 do
  begin
    tbfon[i] := TBitmap.Create;
    tbfon[i].LoadFromFile(ExtractFilePath(Application.ExeName) +
                          'Images\Co0'+IntToStr(i)+'.bmp');
    tbfon[i].Transparent := true;
    tbfon[i].TransparentColor := clWhite;
  end;
  for i := 0 to 3 do
  begin
    tbfeu[i] := TBitmap.Create;
    tbfeu[i].LoadFromFile(ExtractFilePath(Application.ExeName) +
                          'Images\Feu'+IntToStr(i)+'.bmp');
    tbfeu[i].Transparent := true;
    tbfon[i].TransparentColor := clWhite;
  end;
  for i := 0 to 3 do
  begin
    ron[i] := TBitmap.Create;
    case i of
      0 : ron[i].LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\RB.bmp');
      1 : ron[i].LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\RJ.bmp');
      2 : ron[i].LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\RR.bmp');
      3 : ron[i].LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\RG.bmp');
    end;
  end;
  ledon := TBitmap.Create;
  ledon.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\LedOn.bmp');
  ledof := TBitmap.Create;
  ledof.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\LedOff.bmp');
end;

procedure ClearImage;
var
  i,j : byte;
begin
  for j := 1 to 2 do
    for i := 0 to 4 do tbmod[j,i].Free;
  for i := 1 to 5 do tbfon[i].Free;
  for i := 0 to 3 do tbfeu[i].Free;
  for i := 0 to 3 do ron[i].Free;
  ledon.Free;
  ledof.Free;
end;

procedure MixLives;
var
  i,n,v : byte;
begin
  for i := 1 to 20 do
    tbvie[i] := kvie[i];
  for i := 1  to 10 do
  begin
    n := Random(10)+1;
    v := tbvie[n];
    tbvie[n] := tbvie[i];
    tbvie[i] := v;
  end;
  for i := 11  to 20 do
  begin
    n := Random(10)+11;
    v := tbvie[n];
    tbvie[n] := tbvie[i];
    tbvie[i] := v;
  end;
end;

procedure SaveGame;
var
  i : byte;
begin
  AssignFile(Fsave,dir+kfn);
  Rewrite(Fsave);
  for i := 0 to 20 do
    Write(Fsave,batos[i]);
  Closefile(Fsave);
end;

procedure RestoreGame;
var
  i : byte;
begin
  AssignFile(Fsave,dir+kfn);
  Reset(Fsave);
  for i := 0 to 20 do
    Read(Fsave,batos[i]);
  Closefile(Fsave);
end;

// Vector from FromP to ToP
function Vector(FromP, Top: TPoint): TPoint;
begin
  Result.x := Top.x - FromP.x;
  Result.y := Top.y - FromP.y;
end;

// new x of vector
function XComp(Vecteur: TPoint; Angle: Extended): Integer;
begin
  Result := Round(Vecteur.x * cos(Angle) - (Vecteur.y) * sin(Angle));
end;

// new y of vector
function YComp(Vecteur: TPoint; Angle: Extended): Integer;
begin
  Result := Round((Vecteur.x) * (sin(Angle)) + (Vecteur.y) * cos(Angle));
end;

function RotImage(srcbit: TBitmap; Angle: Extended; FPoint: TPoint;
  Background: TColor): TBitmap;
{
 srcbit: TBitmap;               // Rotate bitmap
 Angle: extended;               // angle
 FPoint: TPoint;                // Rotation point
 Background: TColor): TBitmap;  // Background color
}
var
  highest, lowest, mostleft, mostright: TPoint; 
  topoverh, leftoverh: integer;
  x, y, newx, newy: integer;
begin
  Result := TBitmap.Create;
  while Angle >= (2 * pi) do
  begin 
    angle := Angle - (2 * pi);
  end; 
  if (angle <= (pi / 2)) then
  begin 
    highest := Point(0,0);                          //OL
    Lowest := Point(Srcbit.Width, Srcbit.Height);   //UR
    mostleft := Point(0,Srcbit.Height);             //UL
    mostright := Point(Srcbit.Width, 0);            //OR
  end
  else if (angle <= pi) then 
  begin
    highest := Point(0,Srcbit.Height); 
    Lowest := Point(Srcbit.Width, 0);
    mostleft := Point(Srcbit.Width, Srcbit.Height);
    mostright := Point(0,0);
  end  
  else if (Angle <= (pi * 3 / 2)) then
  begin
    highest := Point(Srcbit.Width, Srcbit.Height);
    Lowest := Point(0,0); 
    mostleft := Point(Srcbit.Width, 0);
    mostright := Point(0,Srcbit.Height); 
  end
  else 
  begin
    highest := Point(Srcbit.Width, 0); 
    Lowest := Point(0,Srcbit.Height);
    mostleft := Point(0,0); 
    mostright := Point(Srcbit.Width, Srcbit.Height);
  end;
  topoverh := yComp(Vector(FPoint, highest), Angle);
  leftoverh := xComp(Vector(FPoint, mostleft), Angle);
  Result.Height := Abs(yComp(Vector(FPoint, lowest), Angle)) + Abs(topOverh);
  Result.Width  := Abs(xComp(Vector(FPoint, mostright), Angle)) + Abs(leftoverh);
  Topoverh := TopOverh + FPoint.y;
  Leftoverh := LeftOverh + FPoint.x; 
  Result.Canvas.Brush.Color := Background;
  Result.Canvas.pen.Color   := background;
  Result.Canvas.Fillrect(Rect(0,0,Result.Width, Result.Height));
  for y := 0 to srcbit.Height - 1 do
  begin
    for x := 0 to srcbit.Width - 1 do 
    begin
      newX := xComp(Vector(FPoint, Point(x, y)), Angle);
      newY := yComp(Vector(FPoint, Point(x, y)), Angle);
      newX := FPoint.x + newx - leftoverh;
      newy := FPoint.y + newy - topoverh;
      Result.Canvas.Pixels[newx, newy] := srcbit.Canvas.Pixels[x, y];
      if ((angle < (pi / 2)) or
        ((angle > pi) and
        (angle < (pi * 3 / 2)))) then
      begin 
        Result.Canvas.Pixels[newx, newy + 1] := srcbit.Canvas.Pixels[x, y];
      end  
      else
      begin 
        Result.Canvas.Pixels[newx + 1,newy] := srcbit.Canvas.Pixels[x, y];
      end; 
    end;
  end; 
end;

// procedure allowing a 90° rotation
procedure Rotation(var ABitmap : TBitmap);
type
  TRGBArray = array[0..10000] of TRGBTriple;
  pTRGBArray = ^TRGBArray;
  TArrayLigneCible = array[0..10000] of pTRGBArray;
var
  BitmapSource, BitmapCible : TBitmap;
  x,y : integer;
  LineSource, TargetLine : pTRGBArray;
begin
  BitmapSource := TBitmap.Create;
  BitmapCible := TBitmap.Create;
  try
    BitmapSource.assign (ABitmap);
    BitmapSource.pixelformat := pf24bit;
    BitmapCible.pixelformat := pf24bit;
    BitmapCible.Height := BitmapSource.Width;
    BitmapCible.Width := BitmapSource.Height;
    for y:=0 to BitmapSource.Height - 1 do
    begin
      LineSource := BitmapSource.ScanLine[y];
      for x:=0 to BitmapSource.Width - 1 do
      begin
        TargetLine := BitmapCible.ScanLine[x];
        TargetLine[BitmapSource.Height - 1 - y] := LineSource[x];
      end;
    end;
    ABitmap.assign(BitmapCible);
  finally
    BitmapSource.free;
    BitmapCible.free;
  end;
end;

end.
