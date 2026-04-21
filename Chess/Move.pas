unit Move;

interface

uses
  Variables, Graphics, Math, Dialogs, Functions;

function UnderFire(const po, s: integer; const from_generer: boolean): boolean;
procedure black_strokes(const La_position: integer);
procedure white_shots(const La_position: integer);
function Cases_beaten_by_whites:integer;
function Squares_beaten_by_black:integer;
procedure play(const Le_depart, Larrivee, Lefface: integer);
procedure playtrue(const Le_depart, Larrivee, Lefface: integer);
procedure playfalse(const Le_depart, Larrivee, Lefface: integer);
procedure generate_hit_list(const color: boolean);

implementation

function UnderFire(const po, s: integer; const from_generer: boolean): boolean;
var
  li, co, ou, i: integer;
begin

{ 1:Mad dame
  2:Round Dame
  4:Rider
  8:Pawn
  16:King
  32:Crazy Lady-
  64:Lady Tower-}

  if not from_Generer then
    if s = -1 then
      Cases_beaten_by_whites else Squares_beaten_by_black;
  if boxes[po] = 0 then
  begin
    UnderFire := false;
    exit;
  end;
  li := po div 8; co := po mod 8;
  UnderFire := true;
  with Positive do if s = -1 then
    begin
      if boxes[po] and 32 = 32 then
      begin
        Ou := po;
        for i := 1 to min(7 - li, 7 - co) do
        begin
          inc(ou, 9);
          case Cases[ou] of
            Empty: ;
            Queen, Mad: exit;
          else break;
          end;
        end;
        Ou := po;
        for i := 1 to min(7 - li, co) do
        begin
          inc(ou, 7);
          case Cases[ou] of
            Empty: ;
            Queen, Mad: exit;
          else break;
          end;
        end;
      end;
       if boxes[po] and 64 = 64 then
      begin
        Ou := po;
        for i := 1 to 7 - li do
        begin
          inc(ou, 8);
          case Cases[ou] of
            Empty: ;
            Queen, Rook: exit;
          else break;
          end;
        end;
        Ou := po;
        for i := 1 to 7 - co do
        begin
          inc(ou, 1);
          case Cases[ou] of
            Empty: ;
            Queen, Rook: exit;
          else break;
          end;
        end;
      end;
      if boxes[po] and 1 = 1 then
      begin
        Ou := po;
        for i := 1 to min(li, 7 - co) do
        begin
          inc(ou, -7);
          case Cases[ou] of
            Empty: ;
            Queen, Mad: exit;
          else break;
          end;
        end;
        Ou := po;
        for i := 1 to min(li, co) do
        begin
          inc(ou, -9);
          case Cases[ou] of
            Empty: ;
            Queen, Mad: exit;
          else break;
          end;
        end;
      end;

      if boxes[po] and 2 = 2 then
      begin
        Ou := po;
        for i := 1 to li do
        begin
          inc(ou, -8);
          case Cases[ou] of
            Empty: ;
            Queen, Rook: exit;
          else break;
          end;
        end;
        Ou := po;
        for i := 1 to co do
        begin
          inc(ou, -1);
          case Cases[ou] of
            Empty: ;
            Queen, Rook: exit;
          else break;
          end;
        end;
      end;

      if boxes[po] and 4 = 4 then
        for i := Departure_Rider[po] to Arrival_Rider[po] do
          if Cases[po + Rider_Movement[i]] = Rider then exit;
      if boxes[po] and 8 = 8 then
      begin
        if co < 7 then if li < 7 then if (Cases[po + 9] = Pawn) then exit;
        if co > 0 then if li < 7 then if (Cases[po + 7] = Pawn) then exit;
      end;
      if boxes[po] and 16 = 16 then
        if (Abs(li - (Position_King[white] div 8)) < 2) and
                     (Abs(co - (Position_King[white] mod 8)) < 2) then
                     exit;
    end else
    begin
      if boxes[po] and 1 = 1 then
      begin
        Ou := po;
        for i := 1 to min(li, 7 - co) do
        begin
          inc(ou, -7);
          case Cases[ou] of
            Empty: ;
            MadBlack, QueenBlack: exit;
          else break;
          end;
        end;
        Ou := po;
        for i := 1 to min(li, co) do
        begin
          inc(ou, -9);
          case Cases[ou] of
            Empty: ;
            MadBlack, QueenBlack: exit;
          else break;
          end;
        end;
      end;
      if boxes[po] and 32 = 32 then
      begin
        Ou := po;
        for i := 1 to min(7 - li, 7 - co) do
        begin
          inc(ou, 9);
          case Cases[ou] of
            Empty: ;
            MadBlack, QueenBlack: exit;
          else break;
          end;
        end;
        Ou := po;
        for i := 1 to min(7 - li, co) do
        begin
          inc(ou, 7);
          case Cases[ou] of
            Empty: ;
            MadBlack, QueenBlack: exit;
          else break;
          end;
        end;
      end;
      if boxes[po] and 2 = 2 then
      begin
        Ou := po;
        for i := 1 to li do
        begin
          inc(ou, -8);
          case Cases[ou] of
            Empty: ;
            RookBlack, QueenBlack: exit;
          else break;
          end;
        end;
        Ou := po;
        for i := 1 to co do
        begin
          inc(ou, -1);
          case Cases[ou] of
            Empty: ;
            RookBlack, QueenBlack: exit;
          else break;
          end;
        end;
      end;
      if boxes[po] and 64 = 64 then
      begin
        Ou := po;
        for i := 1 to 7 - li do
        begin
          inc(ou, 8);
          case Cases[ou] of
            Empty: ;
            RookBlack, QueenBlack: exit;
          else break;
          end;
        end;
        Ou := po;
        for i := 1 to 7 - co do
        begin
          inc(ou, 1);
          case Cases[ou] of
            Empty: ;
            RookBlack, QueenBlack: exit;
          else break;
          end;
        end;
      end;
      if boxes[po] and 4 = 4 then
      for i := Departure_Rider[po] to Arrival_Rider[po] do
          if Cases[po + Rider_Movement[i]] = BlackRider then
          exit;

      if boxes[po] and 8 = 8 then
      begin
        if li > 0 then if co > 0 then if (Cases[po - 9] = PawnBlack) then exit;
        if li > 0 then if co < 7 then if (Cases[po - 7] = PawnBlack) then exit;
      end;
      if boxes[po] and 16 = 16 then
        if (Abs(li - (Position_King[Black] div 8)) < 2) and
                     (Abs(co - (Position_King[Black] mod 8)) < 2) then
                     exit;
    end;
  UnderFire := false;
end;

procedure black_strokes(const La_position: integer);
var i, li, co: integer;
  Sauv_posit: Chessboard;

  procedure pre_undeplus(const Posi, pre_efface: integer);
  begin
    play(La_position, posi, Pre_efface);
    if not UnderFire(Positive.Position_King[true], -1, true) then
      with Possible_Moves do
      begin
        inc(Nb_pos);
        position[Nb_pos, 1] := La_position;
        position[Nb_pos, 2] := Posi;
        position[Nb_pos, 3] := pre_efface;
      end;
    Positive := sauv_posit;
  end;

  procedure Fou_Tour_Dame_Noir(const increment, combien: integer);
  var i, dep: integer;
  begin
    dep := La_position;
    with Positive do for i := 1 to combien do
      begin
        inc(dep, increment);
        case sign(Cases[dep]) of
          0: pre_undeplus(dep, La_position);
          -1: exit;
          1: begin pre_undeplus(dep, La_position); exit; end;
        end;
      end;
  end;

begin
  sauv_posit := Positive;
  with Positive do
      begin
        li := La_position div 8; co := La_position mod 8;
        case Cases[La_position] of
           BlackKing: begin
              for i := Departure_King[La_position] to Arrival_King[La_position] do
                if sign(Cases[La_position + Kings_Displacement[i]]) <> -1 then
                  pre_undeplus(La_position + Kings_Displacement[i], La_position);

              if black_little_rook then if Cases[7] = RookBlack then
                if Cases[5] = 0 then if Cases[6] = 0 then
                      if not UnderFire(5, -1, true) then
                        if not UnderFire(La_position, -1, true) then
                          pre_undeplus(6, La_position);

              if black_grand_rook then
                if Cases[0] = RookBlack then
                  if Cases[1] = 0 then
                    if Cases[2] = 0 then
                      if Cases[3] = 0 then
                        if not UnderFire(3, -1, true) then
                          if not UnderFire(La_position, -1, true) then
                            pre_undeplus(2, La_position);
            end;
           QueenBlack: begin
              Fou_Tour_Dame_Noir(9, min(7 - li, 7 - co)); Fou_Tour_Dame_Noir(7, min(7 - li, co));
              Fou_Tour_Dame_Noir(+8, 7 - li); Fou_Tour_Dame_Noir(+1, 7 - co);
              Fou_Tour_Dame_Noir(-7, min(li, 7 - co)); Fou_Tour_Dame_Noir(-9, min(li, co));
              Fou_Tour_Dame_Noir(-8, li); Fou_Tour_Dame_Noir(-1, co);
            end;
          MadBlack: begin
              Fou_Tour_Dame_Noir(9, min(7 - li, 7 - co)); Fou_Tour_Dame_Noir(7, min(7 - li, co));
              Fou_Tour_Dame_Noir(-7, min(li, 7 - co)); Fou_Tour_Dame_Noir(-9, min(li, co));
            end;
          BlackRider: begin
              for i :=   Arrival_Rider[La_position] downto Departure_Rider[La_position] do
                if sign(Cases[La_position + Rider_Movement[i]]) <> -1 then
                  pre_undeplus(La_position + Rider_Movement[i], La_position);
            end;
          RookBlack: begin
              Fou_Tour_Dame_Noir(+8, 7 - li);
              Fou_Tour_Dame_Noir(+1, 7 - co);
              Fou_Tour_Dame_Noir(-8, li);
              Fou_Tour_Dame_Noir(-1, co);
            end;
          PawnBlack: if li < 7 then
            begin
              if Cases[La_position + 8] = 0 then
                pre_undeplus(La_position + 8, La_position); {Lower box}

              if li = 1 then
                if Cases[La_position + 8] = 0 then
                  if Cases[La_position + 16] = 0 then
                    pre_undeplus(La_position + 16, La_position); {2 boxes at the beginning}

              if co > 0 then
                if Cases[La_position + 7] > 0 then
                  pre_undeplus(La_position + 7, La_position); { Taken on the left }

              if co < 7 then
                if Cases[La_position + 9] > 0 then
                  pre_undeplus(La_position + 9, La_position); { right hand grip}
                  { prise en passant }

              if Last <> NotPawn then
                if Cases[Last] > 0 then
                  if La_Position >= 32 then
                    if La_position <= 39 then
                      if abs(la_position - Last) = 1 then
                        pre_undeplus(Last + 8, Last);
            end;
        end;
      end;
end;

procedure white_shots(const la_position: integer);
var
  i, li, co: integer;
  Sauv_posit: Chessboard;

  procedure pre_undeplus(const Posi, pre_efface: integer);
  begin
    play(La_position, posi, Pre_efface);
    if not UnderFire(Positive.Position_King[false], 1, true) then
      with Possible_Moves do
      begin
        inc(Nb_pos);
        position[Nb_pos, 1] := La_position;
        position[Nb_pos, 2] := Posi;
        position[Nb_pos, 3] := pre_efface;
      end;
    Positive := sauv_posit;
  end;

  procedure Fou_Tour_Dame_Blanc(const increment, combien: integer);
  var i, dep: integer;
  begin
    dep := La_position;
    with Positive do for i := 1 to combien do
      begin
        inc(dep, increment);
        case sign(Cases[dep]) of
          0: pre_undeplus(dep, La_position);
          -1: begin pre_undeplus(dep, La_position); exit; end;
          1: exit;
        end;
      end;
  end;

begin
  sauv_posit := Positive;
  with Positive do
      begin
        li := La_position div 8; co := La_position mod 8;
        case Cases[La_position] of
          Pawn: if li > 0 then
            begin
              if Cases[La_position - 8] = 0 then
                pre_undeplus(La_position - 8, La_position); {Upper box}
              if li = 6 then
                if Cases[La_position - 8] = 0 then
                  if Cases[La_position - 16] = 0 then
                    pre_undeplus(La_position - 16, La_position); {2 boxes at the beginning }
              if co > 0 then
                if Cases[La_position - 9] < 0 then
                  pre_undeplus(La_position - 9, La_position); { Taken on the left }
              if co < 7 then
                if Cases[La_position - 7] < 0 then
                  pre_undeplus(La_position - 7, La_position); { right hand grip }
              { taken in passing}
              if Last <> NotPawn then
                if Cases[Last] < 0 then
                  if La_Position >= 24 then
                    if La_position <= 31 then
                      if abs(la_position - Last) = 1 then
                        pre_undeplus(Last - 8, Last);
            end;
          Rook: begin
              Fou_Tour_Dame_Blanc(-8, li);Fou_Tour_Dame_Blanc(-1, co);
              Fou_Tour_Dame_Blanc(+8, 7 - li);
              Fou_Tour_Dame_Blanc(+1, 7 - co);
            end;
          Rider: begin
              for i := Departure_Rider[La_position] to Arrival_Rider[La_position] do
                if sign(Cases[La_position + Rider_Movement[i]]) <> 1 then
                  pre_undeplus(La_position + Rider_Movement[i], La_position);
            end;
          Mad: begin
              Fou_Tour_Dame_Blanc(-7, min(li, 7 - co));
              Fou_Tour_Dame_Blanc(-9, min(li, co));
              Fou_Tour_Dame_Blanc(9, min(7 - li, 7 - co));
              Fou_Tour_Dame_Blanc(7, min(7 - li, co));
            end;

          Queen: begin
              Fou_Tour_Dame_Blanc(-7, min(li, 7 - co));
              Fou_Tour_Dame_Blanc(-9, min(li, co));
              Fou_Tour_Dame_Blanc(-8, li);
              Fou_Tour_Dame_Blanc(-1, co);
              Fou_Tour_Dame_Blanc(9, min(7 - li, 7 - co));
              Fou_Tour_Dame_Blanc(7, min(7 - li, co));
              Fou_Tour_Dame_Blanc(+1, 7 - co);Fou_Tour_Dame_Blanc(+8, 7 - li);
            end;
          King: begin
              for i := Departure_King[La_position] to Arrival_King[La_position] do
                if sign(Cases[La_position + Kings_Displacement[i]]) <> 1 then
                  pre_undeplus(La_position + Kings_Displacement[i], La_position);

              if white_little_rook then
                if Cases[63] = Rook then
                  if Cases[61] = 0 then
                    if Cases[62] = 0 then
                      if not UnderFire(61, 1, true) then
                        if not UnderFire(La_position, 1, true) then
                          pre_undeplus(62, La_position);

              if white_grand_rook then
                if Cases[56] = Rook then
                  if Cases[57] = 0 then
                    if Cases[58] = 0 then
                      if Cases[59] = 0 then
                        if not UnderFire(59, 1, true) then
                          if not UnderFire(La_position, 1, true) then
                            pre_undeplus(58, La_position);
            end;
        end;
      end;
end;



function Cases_beaten_by_whites:integer;
var i, li, co, The_position,retour: integer;

  procedure hou(const a, b: byte);
  begin
    boxes[a] := boxes[a] or b;
    inc(retour);
  end;

  procedure FTDB(const increment, combien, pourou: integer);
  var i, dep: integer;
  begin
    dep := The_position;
    with Positive do for i := 1 to combien do
      begin
        inc(dep, increment);
        hou(dep, pourou);
        if sign(Cases[dep]) = 1 then exit;
      end;
  end;

begin
  retour:=0;
  for The_position := 63 downto 0 do
    boxes[The_position] := 0;
  with Positive do for The_position := 63 downto 0 do
    if cases[The_Position] > 0 then
      begin
        li := The_position div 8; co := The_position mod 8;
        case Cases[The_position] of
          Pawn: if li > 0 then
            begin
              if co > 0 then hou(The_position - 9, 8);
              if co < 7 then hou(The_position - 7, 8);
            end;
          Rook: begin
              FTDB(-8, li, 64);
              FTDB(+8, 7 - li, 2);
              FTDB(-1, co, 64);
              FTDB(+1, 7 - co, 2);
            end;
          Rider: for i := Departure_Rider[The_position] to Arrival_Rider[The_position] do
              hou(The_position + Rider_Movement[i], 4);
          Mad: begin
              FTDB(-7, min(li, 7 - co), 32); FTDB(-9, min(li, co), 32);
              FTDB(9, min(7 - li, 7 - co), 1); FTDB(7, min(7 - li, co), 1);
            end;
          Queen: begin
              FTDB(-7, min(li, 7 - co), 32);
              FTDB(-9, min(li, co), 32);
              FTDB(9, min(7 - li, 7 - co), 1);
              FTDB(7, min(7 - li, co), 1);
              FTDB(-8, li, 64); FTDB(+8, 7 - li, 2);
              FTDB(-1, co, 64); FTDB(+1, 7 - co, 2);
            end;
          King: for i := Departure_King[The_position] to Arrival_King[The_position] do
            hou(The_position + Kings_Displacement[i], 16);
        end;
      end;
   Cases_beaten_by_whites:=retour;
end;

function Squares_beaten_by_black:integer;
var
  i, li, co, The_position,retour: integer;

 { 1:Mad dame
  2:Round Dame
  4:Rider
  8:Pawn
  16:King
  32:Crazy Lady-
  64:Lady Tower-}

  procedure hou(const a, b: byte);
  begin
    boxes[a] := boxes[a] or b;
    inc(retour);
  end;

  procedure FTDN(const increment, combien, pourou: integer);
  var i, dep: integer;
  begin
    dep := The_position;
    with Positive do for i := 1 to combien do
      begin
        inc(dep, increment);
        hou(dep, pourou);
        if sign(Cases[dep]) = -1 then exit;
      end;
  end;

begin
  retour:=0;
  for The_position := 63 downto 0 do boxes[The_position] := 0;
  with Positive do for The_position := 63 downto 0 do
    if cases[The_Position] < 0 then
      begin
        li := The_position div 8; co := The_position mod 8;
        case Cases[The_position] of
          PawnBlack: if li < 7 then
            begin
              if co > 0 then hou(The_position + 7, 8);
              if co < 7 then hou(The_position + 9, 8);
            end;
          RookBlack: begin
              FTDN(-8, li, 64);
              FTDN(+8, 7 - li, 2);
              FTDN(-1, co, 64);
              FTDN(+1, 7 - co, 2);
            end;
          BlackRider: for i := Departure_Rider[The_position] to Arrival_Rider[The_position] do
              hou(The_position + Rider_Movement[i], 4);
          MadBlack: begin
              FTDN(-7, min(li, 7 - co), 32);
              FTDN(-9, min(li, co), 32);
              FTDN(9, min(7 - li, 7 - co), 1);
              FTDN(7, min(7 - li, co), 1);
            end;
          QueenBlack: begin
              FTDN(-7, min(li, 7 - co), 32);
              FTDN(-9, min(li, co), 32);
              FTDN(9, min(7 - li, 7 - co), 1);
              FTDN(7, min(7 - li, co), 1);
              FTDN(-8, li, 64); FTDN(+8, 7 - li, 2);
              FTDN(-1, co, 64); FTDN(+1, 7 - co, 2);
            end;
          BlackKing: for i := Departure_King[The_position]
            to Arrival_King[The_position] do
              hou(The_position + Kings_Displacement[i], 16);
        end;
      end;
      Squares_beaten_by_black:=retour;
end;

procedure play(const Le_depart, Larrivee, Lefface: integer);
begin
  with Positive do
  begin
    dec(total, values_Cases[Cases[Larrivee]]);
    if complexity>=25 then
    begin
      dec(total, bonus[Cases[Larrivee],Larrivee]);
      dec(total, bonus[Cases[Le_depart],Le_depart]);
      inc(total, bonus[Cases[Le_depart],Larrivee]);
    end else
    begin
      dec(total, bonus_end[Cases[Larrivee],Larrivee]);
      dec(total, bonus_end[Cases[Le_depart],Le_depart]);
      inc(total, bonus_end[Cases[Le_depart],Larrivee]);
    end;
    Cases[Larrivee] := Cases[Le_depart]; Cases[Le_depart] := 0; Cases[Lefface] := 0;
    Last := NotPawn;
    case Cases[Larrivee] of
      PawnBlack: if Larrivee >= 56 then begin Cases[Larrivee] := QueenBlack;
      recalculates;
      end else if Larrivee - Le_depart = 16 then Last := Larrivee;
      Pawn: if Larrivee <= 7 then begin Cases[Larrivee] := Queen;
      recalculates; end else if Le_depart - Larrivee = 16 then Last := Larrivee;
      RookBlack: case Le_depart of
          0: black_grand_rook := false;
          7: black_little_rook := false;
        end;
      Rook: case Le_depart of
          56: white_grand_rook := false;
          63: white_little_rook := false;
        end;
      BlackKing: begin
          Position_King[Black] := Larrivee;
          if Le_depart = 4 then
          begin
            black_grand_rook := false;
            black_little_rook := false;
            case Larrivee of
              2: begin
                  Cases[0] := Empty;
                  Cases[3] := RookBlack;
                  Black_rook := true;
                end;
              6: begin
                  Cases[7] := Empty;
                  Cases[5] := RookBlack;
                  Black_rook := true;
                end;
            end;
          end;
        end;
      King: begin
          Position_King[white] := Larrivee;
          if Le_depart = 60 then
          begin
            white_grand_rook := false;
            white_little_rook := false;
            case Larrivee of
              58: begin
                  Cases[56] := Empty;
                  Cases[59] := Rook;
                  White_rook := true;
                end;
              62: begin
                  Cases[63] := Empty;
                  Cases[61] := Rook;
                  White_rook := true;
                end;
            end;
          end;
        end;
    end;
  end;
end;

procedure playtrue(const Le_depart, Larrivee, Lefface: integer);
begin
  with Positive do
  begin
    dec(total, values_Cases[Cases[Larrivee]]);

    if complexity>=25 then
    begin
      dec(total, bonus[Cases[Larrivee],Larrivee]);
      dec(total, bonus[Cases[Le_depart],Le_depart]);
      inc(total, bonus[Cases[Le_depart],Larrivee]);
    end else
    begin
      dec(total, bonus_end[Cases[Larrivee],Larrivee]);
      dec(total, bonus_end[Cases[Le_depart],Le_depart]);
      inc(total, bonus_end[Cases[Le_depart],Larrivee]);
    end;

    Cases[Larrivee] := Cases[Le_depart]; Cases[Le_depart] := 0; Cases[Lefface] := 0;
    Last := NotPawn;
    case Cases[Larrivee] of
      BlackKing: begin
          Position_King[Black] := Larrivee;
          if Le_depart = 4 then
          begin
            black_grand_rook := false;
            black_little_rook := false;
            case Larrivee of
              2: begin
                  Cases[0] := Empty;
                  Cases[3] := RookBlack;
                  Black_rook := true;
                end;
              6: begin
                  Cases[7] := Empty;
                  Cases[5] := RookBlack;
                  Black_rook := true;
                end;
            end;
          end;
        end;
      RookBlack: case Le_depart of
          0: black_grand_rook := false;
          7: black_little_rook := false;
        end;

      PawnBlack: if Larrivee >= 56 then begin Cases[Larrivee] := QueenBlack;
      recalculates; end else if Larrivee - Le_depart = 16 then Last := Larrivee;
    end;
  end;
end;

procedure playfalse(const Le_depart, Larrivee, Lefface: integer);
begin
  with Positive do
  begin
    dec(total, values_Cases[Cases[Larrivee]]);
    if complexity>=25 then
    begin
      dec(total, bonus[Cases[Larrivee],Larrivee]);
      dec(total, bonus[Cases[Le_depart],Le_depart]);
      inc(total, bonus[Cases[Le_depart],Larrivee]);
    end else
    begin
      dec(total, bonus_end[Cases[Larrivee],Larrivee]);
      dec(total, bonus_end[Cases[Le_depart],Le_depart]);
      inc(total, bonus_end[Cases[Le_depart],Larrivee]);
    end;
    Cases[Larrivee] := Cases[Le_depart]; Cases[Le_depart] := 0; Cases[Lefface] := 0;
    Last := NotPawn;
    case Cases[Larrivee] of
      Pawn: if Larrivee <= 7 then begin Cases[Larrivee] := Queen;
      recalculates; end else if Le_depart - Larrivee = 16 then Last := Larrivee;
      Rook: case Le_depart of
          56: white_grand_rook := false;
          63: white_little_rook := false;
        end;
      King: begin
          Position_King[white] := Larrivee;
          if Le_depart = 60 then
          begin
            white_grand_rook := false;
            white_little_rook := false;
            case Larrivee of
              58: begin
                  Cases[56] := Empty;
                  Cases[59] := Rook;
                  White_rook := true;
                end;
              62: begin
                  Cases[63] := Empty;
                  Cases[61] := Rook;
                  White_rook := true;
                end;
            end;
          end;
        end;
    end;
  end;
end;

procedure generate_hit_list(const color: boolean);
var la_position:integer;
begin
  Possible_Moves.Nb_Pos := 0;
  case color of
    True: begin
        Cases_beaten_by_whites;
        for La_Position := 63 downto 0 do if Positive.cases[La_Position] < 0 then
          black_strokes(La_Position);
      end;
    false: begin
        Squares_beaten_by_black;
        for La_Position := 63 downto 0 do  if Positive.cases[La_Position] > 0 then
          white_shots(La_Position);
      end;
  end;
end;

end.

