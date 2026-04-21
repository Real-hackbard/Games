unit Board;

interface

uses variables;

procedure TurnsAway(var li, co, la: integer);
procedure Turned(var li, co: integer);
procedure Draw(const p: Chessboard);

implementation

uses
  Types, Unit1, Graphics, Functions;

type profil = array[1..16] of array[1..2] of single;

const lep: profil = ((0.2, 0.4), (0.2, 0.3), (0.05, 0.3),
    (0.05, 0.1), (0.1, 0.1), (0.1, -0.1), (-0.1, -0.1), (-0.1, 0.1),
    (-0.05, 0.1), (-0.05, 0.3), (-0.2, 0.3), (-0.2, 0.4), (0, 0),
    (0, 0), (0, 0), (0, 0));
  lat: profil = ((0.3, 0.4), (0.3, 0.3), (0.15, 0.3), (0.15, -0.2),
    (0.3, -0.2), (0.3, -0.4), (0.2, -0.4), (0.2, -0.3),
    (-0.2, -0.3), (-0.2, -0.4), (-0.3, -0.4), (-0.3, -0.2), (-0.15, -0.2),
    (-0.15, 0.3), (-0.3, 0.3), (-0.3, 0.4));
  lec: profil = ((0.3, 0.4), (0.3, 0.3), (0.2, 0.3), (0.2, 0), (0.1, -0.3),
    (0, -0.3), (-0.2, -0.1), (-0.2, 0),
    (0, -0.05), (0, 0.1), (-0.1, 0.3), (-0.3, 0.3), (-0.3, 0.4),
    (0, 0), (0, 0), (0, 0));
  lef: profil = ((0.3, 0.4), (0.3, 0.3), (0.05, 0.3), (0.05, 0),
    (0.15, -0.15), (0.05, -0.3), (-0.05, -0.3), (-0.15, -0.15),
    (-0.05, 0), (-0.05, 0.3), (-0.3, 0.3), (-0.3, 0.4), (0, 0),
    (0, 0), (0, 0), (0, 0));
  lar: profil = ((0.3, 0.4), (0.3, 0.3), (0.2, 0.3), (0.2, 0),
    (0.3, -0.3), (0.1, -0.1), (0, -0.3), (-0.1, -0.1),
    (-0.3, -0.3), (-0.2, 0), (-0.2, 0.3), (-0.3, 0.3), (-0.3, 0.4),
    (0, 0), (0, 0), (0, 0));
  ler: profil = ((0.3, 0.4), (0.3, 0.3), (0.2, 0.3), (0.2, 0),
    (0.3, -0.2), (0.2, -0.2), (0, 0), (-0.2, -0.2),
    (-0.3, -0.2), (-0.2, 0), (-0.2, 0.3), (-0.3, 0.3), (-0.3, 0.4),
    (0, 0), (0, 0), (0, 0));

procedure Turned(var li, co: integer);
var
  t, i: integer;
begin
  for i := 1 to Nb_Tour do
  begin
    t := li; li := co; co := 7 - t;
  end;
end;

procedure TurnsAway(var li, co, la: integer);
var
  t, i: integer;
begin
  li := La div 8; co := La mod 8;
  for i := 1 to Nb_Tour do
  begin
    t := co; co := li; li := 7 - t;
  end;
  la := li * 8 + co;
end;

procedure Draw(const p: Chessboard);
var
  li, co, choix, la, oux, ouy: integer;
  polygone: array[1..16] of tpoint;

  procedure ligne(x1, y1, X2, Y2: single);
  begin
    with form1.image1.canvas do
    begin
      MoveTo(round(X1), round(Y1)); LineTo(round(X2), round(Y2));
    end;
  end;

  procedure Trace_carre(x1,y1,x2,y2,x3,y3,x4,y4:integer;couleur:Tcolor);
  begin
   with form1.image1.canvas do
   begin
     brush.color := couleur;
     pen.color := couleur;
     polygone[1].x :=x1;
     polygone[1].y :=y1;
     polygone[2].x :=x2;
     polygone[2].y :=y2;
     polygone[3].x :=x3;
     polygone[3].y :=y3;
     polygone[4].x :=x4;
     polygone[4].y :=y4;
     polygon(Slice(polygone,4));
   end;
  end;
  procedure Trace_Profil(const lax, lay: integer; const qui: Profil; Combien: Integer);
  var
    i: integer;
  begin
    for i := 1 to combien do
    begin
      polygone[i].x := lax + round(qui[i, 1] * Chess_large);
      polygone[i].y := lay + round(qui[i, 2] * Chess_large);
    end;
    form1.image1.canvas.polygon(Slice(polygone, Combien));
  end;

begin
  Form1.Clientwidth:=8 * Chess_large;
  Form1.ClientHeight := 8 * Chess_large+form1.Panel1.Height;
  Form1.Image1.Width := 8 * Chess_large;
  Form1.Image1.Height := 8 * Chess_large;
  with form1.image1.canvas do
    for la := 0 to 63 do
    begin
      li := La div 8; co := La mod 8;
      Turned(li, co);
      if odd(Nb_Tour) xor odd(li + co) then brush.color := Background_Color else brush.color := Color_White;
      polygone[1].x := co * Chess_large;       polygone[1].y := li * Chess_large;
      polygone[2].x := co * Chess_large;       polygone[2].y := (li + 1) * Chess_large;
      polygone[3].x := (co + 1) * Chess_large; polygone[3].y := (li + 1) * Chess_large;
      polygone[4].x := (co + 1) * Chess_large; polygone[4].y := li * Chess_large;
      Brush.style := bssolid;
      polygon(Slice(polygone, 4));
      oux := round((co + 0.5) * Chess_large); ouy := round((li + 0.5) * Chess_large);
      if p.Cases[la] < 0 then
      begin
        brush.color := clblack;
        pen.color := clwhite;
      end else
      begin
        brush.color := clwhite;
        pen.color := clblack;
      end;
      choix := p.Cases[la];
      case choix of
        PawnBlack, Pawn: Trace_Profil(oux, ouy, lep, 12);
        RookBlack, Rook: Trace_Profil(oux, ouy, lat, 16);
        BlackRider, Rider: Trace_Profil(oux, ouy, lec, 13);
        MadBlack, Mad: begin
            Trace_Profil(oux, ouy, lef, 12);
            ligne(oux - 0.032 * Chess_large * 2, ouy - 0.032 * Chess_large * 3 - 0.15 * Chess_large, oux + 0.032 * Chess_large * 2, ouy + 0.032 * Chess_large * 3 - 0.15 * Chess_large);
          end;
        QueenBlack, Queen: Trace_Profil(oux, ouy, lar, 13);
        BlackKing, King: begin
            Trace_Profil(oux, ouy, ler, 13);
            if choix < 0 then form1.image1.Canvas.Pen.Color := clWhite
            else form1.image1.Canvas.Pen.Color := clBlack;
            Pen.Width := 5;
            ligne(oux, ouy - 0.1 * Chess_large, oux, ouy - 0.3 * Chess_large);
            ligne(oux - 0.1 * Chess_large, ouy - 0.2 * Chess_large, oux + 0.1 * Chess_large, ouy - 0.2 * Chess_large);
            if choix > 0 then form1.image1.Canvas.Pen.Color := clWhite
            else form1.image1.Canvas.Pen.Color := clBlack;
            Pen.Width := 3;
            ligne(oux, ouy - 0.1 * Chess_large, oux, ouy - 0.3 * Chess_large);
            ligne(oux - 0.1 * Chess_large, ouy - 0.2 * Chess_large, oux + 0.1 * Chess_large, ouy - 0.2 * Chess_large);
            Pen.Width := 1;
          end;
      end;
      Brush.style := bsclear;
      //pen.color:= clgreen;
      pen.color := clblack;
    end;
end;

end.

