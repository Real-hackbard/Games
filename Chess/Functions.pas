unit Functions;

interface

uses
  graphics, variables;

function movement(de, ar: integer): T_str12;
procedure enabler(def0b, defb, refb, refttb: boolean);
function cartesien(ca: integer): T_str2;
function encrypt(const s: T_str2): integer;
function following(const s: T_str100; var depart, arrivee: integer): boolean;
function strg5(a: Single): string;
procedure Mark_One_Box(li, co: integer; c: Tcolor);
procedure possible_brand;
function strint(a: integer): string;
procedure Initialisation(var posit: Chessboard);
procedure stack_Rep;
procedure Arrow(dela, alabas: Integer;couleur:TColor);
procedure ToWrite(la: Integer; s: string);
function EpdToChessboard(s: string): Boolean;
procedure recalculates;
function temps(z:cardinal):string;


implementation

uses
  Unit1, Board, Windows, math, forms, ChessLibrary, Dialogs, Types,
  Classes, SysUtils;


function movement(de, ar: integer): T_str12;
var
  Quoi, lien: T_str2;
begin
  with Positive do
  begin
    quoi := ''; lien := '';
    if abs(Cases[de]) = King then Quoi := 'R' else
      if abs(Cases[de]) = Queen then Quoi := 'D' else
      if abs(Cases[de]) = Rook then Quoi := 'T' else
      if abs(Cases[de]) = Mad then Quoi := 'F' else
      if abs(Cases[de]) = Rider then Quoi := 'C' else Quoi := '';
    if sign(Cases[de]) = -sign(Cases[ar]) then lien := 'x' else lien := '-';
    movement := quoi + cartesien(de) + lien + cartesien(ar);
  end;
end;

procedure enabler(def0b, defb, refb, refttb: boolean);
begin
  with form1 do
  begin
    def0.enabled := def0b;
    def.enabled := defb;
    ref.enabled := refb;
    reftt.enabled := refttb;
  end;
end;

function cartesien(ca: integer): T_str2;
const
  ab: string = 'abcdefgh';
  unde: string = '87654321';
var
  s: T_str2;
begin
  s := 'xx';
  s[1] := ab[(ca mod 8) + 1]; s[2] := unde[(ca div 8) + 1];
  cartesien := s;
end;

function encrypt(const s: T_str2): integer;
begin
  if (length(s) <> 2) or (pos(s[1], 'abcdefgh') = 0) or
    (pos(s[2], '12345678') = 0) then
  begin
    encrypt := -1; exit;
  end;
  encrypt := (pos(s[2], '87654321') - 1) * 8 + (pos(s[1], 'abcdefgh') - 1);
end;

procedure delay;
var
  hh: integer;
begin
  hh := GetTickCount; while GetTickCount - hh < 5 do ;
end;

function dedans(const s, laboite: string): boolean;

  function cestdedans(dou: integer): boolean;
  var i, j, Nbcou, Nbdanscou: integer;
    ilyest: boolean;
    cou, danscou: array[1..20] of T_Str4;
  begin
    cestdedans := False; i := dou; Nbcou := 0;
    while i < length(laboite) do
    begin
      Inc(NbCou); cou[NbCou] := copy(laboite, i, 4); inc(i, 8);
    end;
    i := dou; Nbdanscou := 0;
    while i < length(s) do
    begin
      Inc(NbdansCou); Danscou[NbdansCou] := copy(s, i, 4); inc(i, 8);
    end;
    for i := 1 to NbDansCou do
    begin
      Ilyest := false; for j := 1 to NbCou do if cou[j] = dansCou[i] then
        Ilyest := true;
      if not Ilyest then exit;
    end;
    cestdedans := true;
  end;

begin
  Dedans := False;
  if cestdedans(1) then if ((length(s) < 5) or (CestDedans(5))) then
    dedans := true;
end;


function following(const s:T_str100;var depart,arrivee:integer):boolean;
var
  i,ar,de:integer;
  depart_s,arrivee_s:T_str2;
begin
  combien_bib:=0;
  For i:=1 to endbib do
  begin
    If dedans(s,copy(bib[i],1,length(s)))  then
      if length(bib[i]) >= length(s)+4 then
    begin
      depart_s:=copy(bib[i],1+length(s),2);
      arrivee_s:= copy(bib[i],1+length(s)+2,2);
      de:=encrypt(depart_s);
      ar:=encrypt(arrivee_s);
      if (ar>=0) and (ar<=63) and (de>=0) and (de<=63) then
        if combien_bib<1500 then
      begin
        inc(combien_bib);
        res_dep_int[combien_bib]:=de;
        res_arr_int[combien_bib]:=ar;
      end;
    end;
  end;
  If combien_bib>0 then
  begin
    i:=random(combien_bib)+1;
    depart:= res_dep_int[i];
    arrivee:=res_arr_int[i];
    following:=true;
    exit;
  end;
  following:=false;
end;

function strg5(a: Single): string;
var
  s: string;
begin
  str(a: 7: 5, s);
  if a = 0 then s := '0';
  if pos('.', s) <> 0 then
    while s[length(s)] = '0' do
      delete(s, length(s), 1);
  if s[length(s)] = '.' then delete(s, length(s), 1);
  Strg5 := s;
end;

procedure Mark_One_Box(li, co: integer; c: Tcolor);
begin
  with form1.image1.canvas do
  begin
    Turned(li, co);
    pen.color := c;
    Pen.Width := 3;
    rectangle(co * Chess_large, li * Chess_large, (co + 1) * Chess_large,
          (li + 1) * Chess_large);
    pen.color := clblack;
    Pen.Width := 1;
  end;
end;

procedure possible_brand;
var
  i: Integer;
begin
  for i := 1 to Possible_Moves.Nb_pos do
  Mark_One_Box(Possible_Moves.position[i, 2] div 8,
  Possible_Moves.position[i, 2] mod 8, ClRed);
end;

function strint(a: integer): string;
var
  s1, s: string;
  i, Computer: integer;
begin
  str(a, s1); s := '';
  Computer := -(length(s1) mod 3);
  for i := 1 to length(s1) do
  begin
    if Computer = 0 then s := s + ' ';
    s := s + s1[i];
    inc(Computer);
    if Computer > 0 then Computer := Computer mod 3;
  end;
  strint := s;
end;

procedure Initialisation(var posit: Chessboard);
begin
  with Posit do
  begin
    white_little_rook := true;
    white_grand_rook := true;
    black_little_rook := true;
    black_grand_rook := true;
    White_rook := false;
    Black_rook := false;
    Last := NotPawn;
    Cases := Departure;
    Position_King[white] := 60;
    Position_King[Black] := 4;
    Total := 0;
  end;
  init_bib;
  Positive_draw := posit;
end;

procedure stack_Rep;
var
  i: integer;
begin
  for i := Stack_Size_Rep downto 2 do StackRep[i] := StackRep[i - 1];
  StackRep[1] := Positive;
end;

procedure Arrow(dela, alabas: Integer;couleur:TColor);
var
  Name, cX, cY: Single;
  Ax, Ay, Bx, By, li, co: Integer;
begin
  li := deLa div 8;
  co := deLa mod 8;
  Turned(li, co);
  Ax := round((co + 0.5) * Chess_large); Ay := round((li + 0.5) * Chess_large);
  li := alabas div 8;
  co := alabas mod 8;
  Turned(li, co);
  Bx := round((co + 0.5) * Chess_large); By := round((li + 0.5) * Chess_large);
  Name := SQRT((BX - AX) * (BX - AX) + (BY - AY) * (BY - AY));

  if (Name = 0) then Exit;

  cX := (BX - AX) / Name;
  cY := (BY - AY) / Name;
  with form1.image1.canvas do
  begin
    Pen.Width := 3; Pen.Color := couleur;
    MoveTo(AX, AY); LineTo(BX, BY);
    MoveTo(BX, BY); LineTo(Round(BX - cX * 30 + cY * 8),
          Round(BY - cY * 30 - cX * 8));
    MoveTo(BX, BY); LineTo(Round(BX - cX * 30 - cY * 8),
          Round(BY - cY * 30 + cX * 8));
    pen.color := clblack; Pen.Width := 1;
  end;
end;

procedure ToWrite(la: Integer; s: string);
var
  li, co: Integer;
begin
  li := La div 8; co := La mod 8;
  Turned(li, co);
  with form1.image1.canvas do
    textout(round((co + 0.75) * Chess_large),
    round((li + 0.75) * Chess_large), s);
end;

procedure extraireMots(s: string;into: TStrings);
var
  i, n: integer;
  currentWord: string;
const
  sep: TSysCharSet = [' '];
begin
  into.Clear;
  n := length(s);
  i := 1;
  while (i <= n) do
  begin
    currentWord := '';
    { We skip the separators.  }
    while (i <= n) and (s[i] in sep) do inc(i);
    { recovery of the current word  }
    while (i <= n) and not (s[i] in sep) do
    begin
      currentWord := currentWord + s[i];
      inc(i);
    end;
    if (currentWord <> '') then into.Add(currentWord);
  end;
end;

function EpdToChessboard(s: string): Boolean;
var
  lu: Char;
  Cursor, line, column,  position, lapiece,i: Integer;
  mot: string[128];
  lastr:T_str2;
  la:shortint;

  function degage_mot: string;
  begin
    while (length(s) > 0) and (s[1] = ' ') do delete(s, 1, 1);
    if pos(' ', s) > 0 then
    begin
      degage_mot:=Copy(s, 1, Pos(' ', s)-1);
      delete(s, 1, pos(' ', s));
    end else
    begin
      degage_mot:=s;
      s:='';
    end;
  end;

begin
  with TheChessBoard do
  begin
    EpdToChessboard := False;
    mot:=degage_mot;
    if mot='' then exit;
    Cursor:=1;
    while (Cursor <= Length(mot)) do
    begin
      case mot[Cursor] of
        '1': mot[Cursor] := '*';
        '2': begin mot[Cursor] := '*'; Insert('*', mot, Cursor); end;
        '3': begin mot[Cursor] := '*'; Insert('**', mot, Cursor); end;
        '4': begin mot[Cursor] := '*'; Insert('***', mot, Cursor); end;
        '5': begin mot[Cursor] := '*'; Insert('****', mot, Cursor); end;
        '6': begin mot[Cursor] := '*'; Insert('*****', mot, Cursor); end;
        '7': begin mot[Cursor] := '*'; Insert('******', mot, Cursor); end;
        '8': begin mot[Cursor] := '*'; Insert('*******', mot, Cursor); end;
      end;
      Inc(Cursor);
    end;
    Cursor := 1;
    line := 0;
    column := 0;
    while (Cursor <= Length(mot)) do
    begin
      lu := mot[Cursor];
      case lu of
        'p': lapiece := PawnBlack;
        'n': lapiece := BlackRider;
        'b': lapiece := MadBlack;
        'r': lapiece := RookBlack;
        'q': lapiece := QueenBlack;
        'k': lapiece := BlackKing;
        'P': lapiece := Pawn;
        'N': lapiece := Rider;
        'B': lapiece := Mad;
        'R': lapiece := Rook;
        'Q': lapiece := Queen;
        'K': lapiece := King;
        '*': lapiece := Empty;
      end;
      position := column + line * 8;
      cases[position] := lapiece;
      if lu <> '/' then Inc(column);
      if (column > 7) then
      begin
        column := 0;
        inc(line);
      end;
      Inc(Cursor);
    end;
    mot:=degage_mot;if mot='' then exit;
    if pos('w',mot)>0 then Color_Computer:=false; {white line}
    if pos('b',mot)>0 then Color_Computer:=true;  {black line}

    mot:=degage_mot;if mot='' then exit;
    white_little_rook := (Pos('K', mot) > 0);
    white_grand_rook := (Pos('Q', mot) > 0);
    black_little_rook := (Pos('k', mot) > 0);
    black_grand_rook := (Pos('q', mot) > 0);

    for i:=0 to 63 do
    begin
      if cases[i]=King then Position_King[white]:=i;
      if cases[i]=BlackKing then Position_King[Black]:=i;
    end;

    White_rook:=not( white_little_rook AND  white_grand_rook) AND
      (Position_King[white ] <>60);
    Black_rook:= not( black_little_rook  AND  black_grand_rook ) AND
      (Position_King[Black]<>4);
    mot:=degage_mot;if mot='' then exit;
    Last:=0;

    if (mot <> '-') then
    begin
      lastr:='aa';
      lastr[1]:=mot[1];
      lastr[2]:=mot[2];
      la:=encrypt(lastr);
      if la>=36 then
        dec(la,8)
      else
        inc(la,8);
      Last:=la;
    end;

    EpdToChessboard := True;
    Positive := TheChessBoard;
    Draw(Positive);
  end;
end;

procedure recalculates;
var
  retour: Smallint;
  I: integer;
begin
  retour := 0;
  with Positive do
  begin
    for i := 0 to 63 do
    begin
      inc(retour, values_Cases[cases[i]]);
      inc(retour, bonus[Cases[i],i]);
    end;
    total := retour;
  end;
end;

function temps(z:cardinal):string;
var
  s,m,h:cardinal;
begin
  S := (Z div 1000) mod 60;
  M := (Z div 60000) mod 60;
  H := (Z div 3600000);
  Z := (Z mod 1000 ) div 100;
  temps:=format('%.2dh%.2dmn%.2d.%.1d',[H,M,S,Z])+'s'; 
end;
end.

