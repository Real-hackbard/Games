unit Game;

interface

const Steinwert: array[1..2] of byte = (1,5);
      Spieler1 = 1;
      Spieler2 = 2;

      { Strategy parameters }
(*
      Parameter_a:longint = 1;     { Opposing one row }
      Parameter_b:longint = 5;     { own series }
      Parameter_c:longint = 30;    { Opposing double line }
      Parameter_d:longint = 150;   { own 2-row }
      Parameter_e:longint = 1800;   { Opposing 3-man line }
      Parameter_f:longint = 15000;  { own 3-series }
      Parameter_g:longint = 150000; { Opposing 4-man line }
      Parameter_h:longint = 1500000; { own 4-series }
*)
      Parameter_a:longint = 1;     { Opposing one row }
      Parameter_b:longint = 2;     { own series }
      Parameter_c:longint = 50;    { Opposing double line }
      Parameter_d:longint = 150;   { own 2-row }
      Parameter_e:longint = 500;   { Opposing 3-man line }
      Parameter_f:longint = 1000;  { own 3-series }
      Parameter_g:longint = 50000; { Opposing 4-man line }
      Parameter_h:longint = 100000; { own 4-series }

type
  TSteinwert = byte;
  TSpieler = Spieler1..Spieler2;
  TSpielertyp = (Keiner, Mensch, Computer);
  TReihensummenHaeufigkeit = array[0..20] of integer;
  TSiegreihe = array[0..3] of record x,y,z: 0..3; end;
  TZug= record
          x,y: integer;
        end;
  TSpielfeld = array[0..3,0..3,0..3] of TSteinwert;
  TPosition = record
                Feld: TSpielfeld;
                amZug: TSpieler;
              end;
  TSpiel = class
    Position: TPosition;
    Spielertyp: array[1..2] of TSpielertyp;
    MaxSuchtiefe: integer;
    Siegreihe: TSiegreihe;
    constructor create(sp1, sp2: TSpielertyp; MaxSuchtiefe: integer);
    function ReihensummenHaeufigkeit(Pos: TPosition): TReihensummenHaeufigkeit;
    function zulaessig(Pos: TPosition; Zug: TZug): boolean;
    function amEnde(Pos: TPosition): boolean;
    function ZKoordinateVonZug(Pos: TPosition; Zug: TZug): integer;
    procedure Ausfuehren(Pos: TPosition; Zug: TZug; var neuPos: TPosition);
    function Computerzug(var Wertung: longint): TZug;
  function HeuristischerWert(Pos: TPosition): longint;
  function negmax(tiefe: integer; Pos: TPosition; var BesterZug: TZug): longint;

  end;


implementation

constructor TSpiel.Create(sp1, sp2: TSpielertyp; MaxSuchtiefe: integer);
var x,y,z: integer;
begin
  inherited create;
  for x:= 0 to 3
  do for y:= 0 to 3
     do for z:= 0 to 3
        do Position.Feld[x,y,z]:= 0;
  Position.amZug:= Spieler1;
  Spielertyp[1]:= sp1;
  Spielertyp[2]:= sp2;
  Self.MaxSuchtiefe:= MaxSuchtiefe;
end;

function TSpiel.ReihensummenHaeufigkeit(Pos: TPosition): TReihensummenHaeufigkeit;
var summe: integer;
    x,y,z: integer;
    Haeufigkeiten: TReihensummenHaeufigkeit;
begin
  for x:= 0 to 20 do Haeufigkeiten[x]:= 0;
  { Search all bars upwards }
  for x:= 0 to 3
    do begin
         for y:= 0 to 3
           do begin
                summe:= 0;
                for z:= 0 to 3
                  do summe:= summe+pos.Feld[x,y,z];
                inc(Haeufigkeiten[summe]);
                if summe in [4,20]
                 then for z:= 0 to 3 do begin Siegreihe[z].x:= x; Siegreihe[z].y:= y; Siegreihe[z].z:= z; end;
              end;
       end;
  { Search all rows from left to right }
  for y:= 0 to 3
    do begin
         for z:= 0 to 3
           do begin
                summe:= 0;
                for x:= 0 to 3
                  do summe:= summe+pos.Feld[x,y,z];
                inc(Haeufigkeiten[summe]);
                if summe in [4,20]
                 then for x:= 0 to 3 do begin Siegreihe[x].x:= x; Siegreihe[x].y:= y; Siegreihe[x].z:= z; end;
              end;
       end;
  { Search all rows from back to front }
  for x:= 0 to 3
    do begin
         for z:= 0 to 3
           do begin
                summe:= 0;
                for y:= 0 to 3
                  do summe:= summe+pos.Feld[x,y,z];
                inc(Haeufigkeiten[summe]);
                if summe in [4,20]
                 then for y:= 0 to 3 do begin Siegreihe[y].x:= x; Siegreihe[y].y:= y; Siegreihe[y].z:= z; end;
              end;
       end;
  { Search all dialogues from bottom back to top front. }
  for x:= 0 to 3
    do begin
         summe:= 0;
         for y:= 0 to 3
           do summe:= summe+pos.Feld[x,y,y];
         inc(Haeufigkeiten[summe]);
         if summe in [4,20]
          then for y:= 0 to 3 do begin Siegreihe[y].x:= x; Siegreihe[y].y:= y; Siegreihe[y].z:= y; end;
       end;
  { Search all dialogues from top back to bottom front. }
  for x:= 0 to 3
    do begin
         summe:= 0;
         for y:= 0 to 3
           do summe:= summe+pos.Feld[x,y,3-y];
         inc(Haeufigkeiten[summe]);
         if summe in [4,20]
          then for y:= 0 to 3 do begin Siegreihe[y].x:= x; Siegreihe[y].y:= y; Siegreihe[y].z:= 3-y; end;
       end;
  { Search all dialogues from bottom left to top right. }
  for y:= 0 to 3
    do begin
         summe:= 0;
         for x:= 0 to 3
           do summe:= summe+pos.Feld[x,y,x];
         inc(Haeufigkeiten[summe]);
         if summe in [4,20]
          then for x:= 0 to 3 do begin Siegreihe[x].x:= x; Siegreihe[x].y:= y; Siegreihe[x].z:= x; end;
       end;
  { Search all dialogues from top left to bottom right. }
  for y:= 0 to 3
    do begin
         summe:= 0;
         for x:= 0 to 3
           do summe:= summe+pos.Feld[x,y,3-x];
         inc(Haeufigkeiten[summe]);
         if summe in [4,20]
          then for x:= 0 to 3 do begin Siegreihe[x].x:= x; Siegreihe[x].y:= y; Siegreihe[x].z:= 3-x; end;
       end;
  { Search all dialogues from back left to front right. }
  for z:= 0 to 3
    do begin
         summe:= 0;
         for x:= 0 to 3
           do summe:= summe+pos.Feld[x,x,z];
         inc(Haeufigkeiten[summe]);
         if summe in [4,20]
          then for x:= 0 to 3 do begin Siegreihe[x].x:= x; Siegreihe[x].y:= x; Siegreihe[x].z:= z; end;
       end;
  { Search all dialogues from front left to back right. }
  for z:= 0 to 3
    do begin
         summe:= 0;
         for x:= 0 to 3
           do summe:= summe+pos.Feld[x,3-x,z];
         inc(Haeufigkeiten[summe]);
         if summe in [4,20]
          then for x:= 0 to 3 do begin Siegreihe[x].x:= x; Siegreihe[x].y:= 3-x; Siegreihe[x].z:= z; end;
       end;
  { Search diagonals from front left bottom to back right top }
  summe:= 0;
  for x:= 0 to 3
    do summe:= summe+pos.Feld[x,x,x];
  inc(Haeufigkeiten[summe]);
  if summe in [4,20]
   then for x:= 0 to 3 do begin Siegreihe[x].x:= x; Siegreihe[x].y:= x; Siegreihe[x].z:= x; end;
  { Search diagonals from front left top to back right bottom }
  summe:= 0;
  for x:= 0 to 3
    do summe:= summe+pos.Feld[x,x,3-x];
  inc(Haeufigkeiten[summe]);
  if summe in [4,20]
   then for x:= 0 to 3 do begin Siegreihe[x].x:= x; Siegreihe[x].y:= x; Siegreihe[x].z:= 3-x; end;
  { Search diagonals from back left bottom to front right top }
  summe:= 0;
  for x:= 0 to 3
    do summe:= summe+pos.Feld[x,3-x,x];
  inc(Haeufigkeiten[summe]);
  if summe in [4,20]
   then for x:= 0 to 3 do begin Siegreihe[x].x:= x; Siegreihe[x].y:= 3-x; Siegreihe[x].z:= x; end;
  { Search diagonals from back left top to front right bottom }
  summe:= 0;
  for x:= 0 to 3
    do summe:= summe+pos.Feld[x,3-x,3-x];
  inc(Haeufigkeiten[summe]);
  if summe in [4,20]
   then for x:= 0 to 3 do begin Siegreihe[x].x:= x; Siegreihe[x].y:= 3-x; Siegreihe[x].z:= 3-x; end;

  Reihensummenhaeufigkeit:= Haeufigkeiten;
end;

function TSpiel.zulaessig(Pos: TPosition; Zug: TZug): boolean;
var z: integer;
begin
  z:= 0;
  while (Pos.Feld[Zug.x,Zug.y,z]<>0) and (z<3)
    do inc(z);
  if Pos.Feld[Zug.x,Zug.y,z]<>0
  then zulaessig:= false
  else zulaessig:= true;
end;

function TSpiel.ZKoordinateVonZug(Pos: TPosition; Zug: TZug): integer;
var z: integer;
begin
  z:= 0;
  while (Pos.Feld[Zug.x,Zug.y,z]<>0) and (z<3)
  do inc(z);
  ZKoordinateVonZug:= z;
end;

procedure TSpiel.Ausfuehren(Pos: TPosition; Zug: TZug; var neuPos: TPosition);
var x,y,z: integer;
begin
  for x:= 0 to 3 do for y:= 0 to 3 do for z:= 0 to 3 do neuPos.Feld[x,y,z]:= Pos.Feld[x,y,z];
  z:= ZKoordinatevonZug(neuPos,Zug);
  neuPos.Feld[Zug.x,Zug.y,z]:= Steinwert[Pos.amZug];
  if Pos.amZug=Spieler1
    then neuPos.amZug:= Spieler2
    else neuPos.amZug:= Spieler1;
end;

function TSpiel.amEnde(Pos: TPosition): boolean;
var ende: boolean;
    x,y,z: integer;
    h: TReihensummenHaeufigkeit;
begin
  h:= ReihensummenHaeufigkeit(Pos);
  ende:= (h[4]>0) or (h[20]>0);
  if not ende
  then begin
         ende:= true;
         for x:= 0 to 3 do for y:= 0 to 3 do for z:= 0 to 3 do if Pos.Feld[x,y,z]=0 then ende:= false;
       end;
   amEnde:= ende;
end;

  function TSpiel.HeuristischerWert(Pos: TPosition): longint;
  var h: TReihensummenHaeufigkeit;
      c: integer;
  begin
    h:= ReihensummenHaeufigkeit(Pos);
    c:= Steinwert[Pos.amZug];
    HeuristischerWert:=
                  -Parameter_a*h[1*(6-c)]             { opposing singles }
                  +Parameter_b*h[1*c]                 { own single rows }
                  -Parameter_c*h[2*(6-c)]             { opposing double lines }
                  +Parameter_d*h[2*c]                 { own rows of two }
                  -Parameter_e*h[3*(6-c)]             { opposing three-man lines }
                  +Parameter_f*h[3*c]                 { own rows of three }
                  -Parameter_g*h[4*(6-c)]             { opposing four-man lines }
                  +Parameter_h*h[4*c]                 { own rows of four }
  end;

  function TSpiel.negmax(tiefe: integer; Pos: TPosition; var BesterZug: TZug): longint;
  var Wert, NachfolgerWert: longint;
      Probezug, Zug: TZug;
      Nachfolger: TPosition;
      x,y: 0..3;
  begin
    if (tiefe >= MaxSuchtiefe) or (amEnde(Pos))
    then negmax:= HeuristischerWert(Pos)
    else begin
           Wert:= -1000000;
           for x:= 0 to 3
           do for y:= 0 to 3
              do begin
                   Probezug.x:= x;
                   Probezug.y:= y;
                   if zulaessig(Pos,Probezug)
                   then begin
                          Ausfuehren(Pos, Probezug, Nachfolger);
                          NachfolgerWert:= -negmax(tiefe+1, nachfolger, Zug);
                          if (NachfolgerWert>Wert) or
                             ((NachfolgerWert=Wert) and (random(2)=0))
                          then begin
                                 Wert:= NachfolgerWert;
                                 BesterZug:= Probezug;
                               end;

                        end;
                 end;
           negmax:= Wert;
         end;
  end;

function TSpiel.Computerzug(var Wertung: longint): TZug;
var BesterZug: TZug;
    BesterWert: longint;

begin

  Wertung:= negmax(0, Position, BesterZug);
  ComputerZug:= BesterZug;
end;

end.
