unit Graphic;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Game, StdCtrls, ExtCtrls;

const
  Faktor: double = 100;
  Verschiebungx: double = 340;
  Verschiebungy: double = 250;

type
  TRaumkoordinate = record
                      x,y,z: double;
                    end;
  TBallkoordinaten = array[0..3,0..3,0..3] of TRaumkoordinate;
  TBodenkoordinaten = array[0..1,0..1] of TRaumkoordinate;
  TStabkoordinaten = array[0..3,0..3,0..1] of TRaumkoordinate;
  TDarstellung = record
                   Ball: TBallkoordinaten;
                   Boden: TBodenkoordinaten;
                   Stab: TStabkoordinaten;
                 end;

  TForm2 = class(TForm)
    B_xMinus: TButton;
    B_xPlus: TButton;
    B_yMinus: TButton;
    B_yPlus: TButton;
    b_zMinus: TButton;
    B_zPlus: TButton;
    procedure FormCreate(Sender: TObject);
    procedure B_xMinusClick(Sender: TObject);
    procedure B_xPlusClick(Sender: TObject);
    procedure B_yMinusClick(Sender: TObject);
    procedure B_yPlusClick(Sender: TObject);
    procedure b_zMinusClick(Sender: TObject);
    procedure B_zPlusClick(Sender: TObject);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Darstellung: TDarstellung;
    Position: TPosition;
    procedure Anzeigen;
    procedure GrunddarstellungHerstellen;
    procedure Drehung(dx,dy,dz: integer);
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

function Raumkoordinate(x,y,z: double): TRaumkoordinate;
begin
  result.x:= x;
  result.y:= y;
  result.z:= z;
end;

function Bildkoordinate(p: TRaumkoordinate): TPoint;
begin

  Result.x:= trunc(p.x*Faktor+Verschiebungx);
  Result.y:= trunc(p.y*Faktor+Verschiebungy);
end;

function Raumdrehung(p1: TRaumkoordinate; gradx, grady, gradz: integer): TRaumkoordinate;
var altx,alty,altz: double;
    a,b,c: double;
    p2: TRaumkoordinate;
begin
 altx:= p1.x; alty:= p1.y; altz:= p1.z;
 a:= pi/360*gradx; b:= pi/360*grady; c:= pi/360*gradz;
 p2.x:= altx*cos(c)*cos(b)-alty*(cos(c)*sin(b)*sin(a)+sin(c)*cos(a))-altz*(cos(c)*sin(b)*cos(a)-sin(c)*sin(a));
 p2.y:= altx*sin(c)*cos(b)-alty*(sin(c)*sin(b)*sin(a)-cos(c)*cos(a))-altz*(sin(c)*sin(b)*cos(a)+cos(c)*sin(a));
 p2.z:= altx*sin(b)+alty*cos(b)*sin(a)+altz*cos(b)*cos(a);
 Result:= p2;
end;

procedure TForm2.GrunddarstellungHerstellen;
var x,y,z: integer;
begin
  for x:= 0 to 3
  do begin
       for y:= 3 downto 0
       do begin
            for z:= 0 to 3
            do begin
                 Darstellung.Ball[x,y,z]:= Raumkoordinate(x-1.5,-y+1.5,z/2-1.5);
               end;
            Darstellung.Stab[x,y,0]:= Raumkoordinate(x-1.5,-y+1.5,-2);
            Darstellung.Stab[x,y,1]:= Raumkoordinate(x-1.5,-y+1.5,+0.5);
          end;
     end;
  for x:= 0 to 1
  do for y:= 0 to 1
     do Darstellung.Boden[x,y]:= Raumkoordinate((x-0.5)*4,(y-0.5)*4,-2);
  Drehung(0,0,45);
end;

procedure TForm2.Drehung(dx,dy,dz: integer);
var x,y,z: integer;
begin
  with Darstellung
  do begin
       for x:= 0 to 3
       do for y:= 0 to 3
          do begin
               for z:= 0 to 3
               do Ball[x,y,z]:= Raumdrehung(ball[x,y,z],dx,dy,dz);
               Stab[x,y,0]:= Raumdrehung(Stab[x,y,0],dx,dy,dz);
               Stab[x,y,1]:= Raumdrehung(Stab[x,y,1],dx,dy,dz);
             end;
       for x:= 0 to 1
       do for y:= 0 to 1
          do Boden[x,y]:= Raumdrehung(Boden[x,y],dx,dy,dz);
     end;
end;

procedure TForm2.Anzeigen;
var x,y,z: integer;
begin
  Canvas.Brush.Color:= clSilver;
  Canvas.FillRect(Canvas.ClipRect);
  Canvas.Brush.Color:= clGray;
  Canvas.Polygon([Bildkoordinate(Darstellung.Boden[0,0]),Bildkoordinate(Darstellung.Boden[0,1]),
                  Bildkoordinate(Darstellung.Boden[1,1]),Bildkoordinate(Darstellung.Boden[1,0])]);
  for y:= 3 downto 0
  do for x:= 0 to 3
     do begin
          Canvas.MoveTo(Bildkoordinate(Darstellung.Stab[x,y,0]).x,
                        Bildkoordinate(Darstellung.Stab[x,y,0]).y);
          Canvas.LineTo(Bildkoordinate(Darstellung.Stab[x,y,1]).x,
                        Bildkoordinate(Darstellung.Stab[x,y,1]).y);

          for z:= 0 to 3
          do begin
               if Position.Feld[x,y,z]>0
               then begin
                      case Position.Feld[x,y,z] of
                        1: Canvas.Brush.Color:= clBlue;
                        5: Canvas.Brush.Color:= clRed;
                        2: Canvas.Brush.Color:= 255+150*256+150*256*256;
                        4: Canvas.Brush.Color:= 255*256*256+150+150*256;
                      end;
                      Canvas.Ellipse(Bildkoordinate(Darstellung.Ball[x,y,z]).x-20,
                                     Bildkoordinate(Darstellung.Ball[x,y,z]).y-20,
                                     Bildkoordinate(Darstellung.Ball[x,y,z]).x+20,
                                     Bildkoordinate(Darstellung.Ball[x,y,z]).y+20);
                    end
             end;
        end;
end;


procedure TForm2.FormCreate(Sender: TObject);
begin
  GrunddarstellungHerstellen;
  Drehung(70,35,0);
end;

procedure TForm2.B_xMinusClick(Sender: TObject);
begin
  Drehung(-5,0,0);
  Anzeigen;
end;

procedure TForm2.B_xPlusClick(Sender: TObject);
begin
  Drehung(5,0,0);
  Anzeigen;
end;

procedure TForm2.B_yMinusClick(Sender: TObject);
begin
  Drehung(0,-5,0);
  Anzeigen;
end;

procedure TForm2.B_yPlusClick(Sender: TObject);
begin
  Drehung(0,+5,0);
  Anzeigen;
end;

procedure TForm2.b_zMinusClick(Sender: TObject);
begin
  Drehung(0,0,-5);
  Anzeigen;
end;

procedure TForm2.B_zPlusClick(Sender: TObject);
begin
  Drehung(0,0,+5);
  Anzeigen;
end;

procedure TForm2.Shape1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var dx, dy, dz: integer;
begin
  if ssLeft in Shift
  then begin
         dy:= trunc((x*2-Form2.Width)/Form2.Width*180);
         dx:= trunc(y/Form2.Height*180);
         GrunddarstellungHerstellen;
         Drehung(dx,dy,0);
         Anzeigen;
       end;
end;

end.



