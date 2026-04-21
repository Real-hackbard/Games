unit SearchForHits;

interface

procedure Poster;

procedure Research(const color: boolean);

implementation

uses
  windows, SysUtils, Variables, Move, dialogs, Functions, Evolution,
  forms, Unit1, math, Graphics, Board;

procedure Tri_Whatever(var li: List_Move; const n: integer);
var
  s, sj, sl, sr, j, S1: LongInt;
  Code: smallint;
  Resa_Chiffre: Element;
  St: array[0..100, 0..1] of LongInt;
begin
  with li do
  begin
    S := 1;
    st[S, 0] := 1;
    st[S, 1] := n;
    repeat
      sl := st[S, 0];
      sr := st[S, 1];
      S := pred(S);
      repeat
        j := sl;
        sj := sr;
        S1 := (sl + sr) div 2;
        Code := -position[S1, 4];
        repeat
          while (-position[J, 4] < Code) do
            j := j + 1;
          while (Code < -position[Sj, 4]) do
            SJ := Sj - 1;
          if j <= sj then
          begin
            Resa_Chiffre := position[Sj];
            position[Sj] := position[j];
            position[j] := Resa_Chiffre;
            j := Succ(J);
            sj := Pred(sj);
          end;
        until j > sj;
        if j < sr then
        begin
          S := Succ(S);
          St[S, 0] := j;
          St[S, 1] := sr;
        end;
        sr := sj;
      until sl >= sr;
    until S < 1;
  end;
end;

function sheettrue(const beta: integer): integer;
var
  j, evaluatedfirst,firstevaluationfor, evaluated, Best,
  i, arrival, deprime: integer;
  progress: Chessboard;
  Squize, yena: boolean;
  cbpb:integer;
begin
  yena := false;
  progress := Positive;
  Best := -infini;
  with Possible_Moves do with Positive do
    begin
      cbpb:=Cases_beaten_by_whites;
      evaluatedfirst := assess(true)-cbpb;
      for j := 63 downto 0 do if cases[j] < 0 then
        begin
          Nb_Pos := 0;
          black_strokes(j);
          if Nb_Pos <> 0 then
          begin
            yena := true;
            for i := 1 to Nb_pos do
            begin
              arrival := position[i, 2];
              squize := false;
              if (complexity >= 25) then
              begin
                firstevaluationfor:=evaluatedfirst - bonus[cases[j],j];
                if (cases[arrival] = Empty) then
                begin
                  Squize := true;deprime:=cbpb;
                  case cases[j] of
                    PawnBlack: if j >= 48 then Squize := false;
                    BlackKing, RookBlack:Squize:=Black_rook;
                  end ;
                end else deprime:=23+cbpb;
                if Squize then evaluated := firstevaluationfor  +
                                      bonus[cases[j],arrival]-deprime else
                begin
                  playtrue(position[i, 1], position[i, 2], position[i, 3]);
                  evaluated := assess(true) -deprime;
                  Positive := progress;
                end;
              end else
              begin
                 firstevaluationfor:=evaluatedfirst - bonus_end[cases[j],j];
                if (cases[arrival] = Empty) then
                  case cases[j] of
                    PawnBlack: if j < 48 then Squize := true;
                    BlackRider, MadBlack, QueenBlack, BlackKing: Squize := true;
                  end;
                if Squize then evaluated := firstevaluationfor +
                                            bonus_end[cases[j],arrival] else
                begin
                  playtrue(position[i, 1], position[i, 2], position[i, 3]);
                  evaluated := assess(true);
                  Positive := progress;
                end;
              end;
              if evaluated > Best then
              begin
                Best := evaluated;
                if Best >= beta then
                begin
                  sheettrue := Best;
                  exit;
                end;
              end;
            end;
          end;
        end;
      if not yena then
      begin
        if UnderFire(Position_King[Black], -1, false) then
          sheettrue := -infini + (profope - 1) else sheettrue := 0;
        exit;
      end;
      sheettrue := Best;
      exit;
    end;
end;

function leaffalse(const beta: integer): integer;
var
  j, evalupremier, evalupremierpourj, evaluated, Best,
  i, arrival, deprime: integer;
  encours: Chessboard;
  Squize, yena: boolean;
  cbpn:integer;
begin
  yena := false;
  encours := Positive;
  Best := -infini;
  with Possible_Moves do with Positive do
    begin
      cbpn:=Squares_beaten_by_black;
      evalupremier := assess(false)-cbpn;
      for j := 0 to 63 do if cases[j] > 0 then
        begin
          evalupremierpourj:=evalupremier - bonus[cases[j],j];
          Nb_Pos := 0;
          white_shots(j);
          if Nb_Pos <> 0 then
          begin
            yena := true;
            for i := 1 to Nb_pos do
            begin
              arrival := position[i, 2];
              squize := false;
              if (complexity >= 25) then
              begin
                if (cases[arrival] = Empty) then
                begin
                 Squize := true;
                 deprime:=cbpn;
                 case cases[j] of
                   Pawn: if j < 16 then Squize := false;
                   King, Rook:Squize:=White_rook;
                 end;
                end else deprime:=23+cbpn;
                if Squize then evaluated := evalupremierpourj  +
                            bonus[cases[j],arrival]-deprime else
                begin
                  playfalse(position[i, 1], position[i, 2], position[i, 3]);
                  evaluated := assess(false) - deprime;
                  Positive := encours;
                end;
              end else
              begin
                evalupremierpourj:=evalupremier - bonus_end[cases[j],j];
                if (cases[arrival] = Empty) then
                  case cases[j] of
                    King, Queen, Mad, Rider: Squize := true;
                    Pawn: if j >= 16 then Squize := true;
                  end;
                if Squize then evaluated := evalupremier +
                        bonus_end[cases[j],arrival] else
                begin
                  playfalse(position[i, 1], position[i, 2], position[i, 3]);
                  evaluated := assess(false);
                  Positive := encours;
                end;
              end;
              if evaluated > Best then
              begin
                Best := evaluated;
                if Best >= beta then
                begin
                  leaffalse := Best;
                  exit;
                end;
              end;
            end;
          end;
        end;
      if not yena then
      begin
        if UnderFire(Position_King[white], 1, false) then leaffalse := -infini + (profope - 1) else leaffalse := 0;
        exit;
      end;
      leaffalse := Best;
      exit;
    end;
end;

procedure Poster;
begin
  Form1.Label1.caption := strint(Nb_Eval) +
    ' Ratings in : '+temps(GetTickCount - h);
end;

function AlphaBetalegere(const depth: integer; alpha: integer; const beta: integer; const color: boolean): integer;
var
  evaluated, Best, i: integer;
  liste_coup: List_Move;
  progress: Chessboard;
begin
  if depth = 1 then if color then
  begin
    alphabetalegere := sheettrue(beta); exit;
  end else begin
    alphabetalegere := leaffalse(beta); exit;
  end;
  progress := Positive;
  Best := -infini;
  generate_hit_list(color);
  liste_coup := Possible_Moves;
  with liste_coup do
  begin
    if Nb_pos = 0 then if color then
      begin
        if UnderFire(Positive.Position_King[Black], -1, false) then
          AlphaBetalegere := -infini else AlphaBetalegere := 0;
        exit;
      end else
      begin
        if UnderFire(Positive.Position_King[white], 1, false) then
          AlphaBetalegere := -infini else AlphaBetalegere := 0;
        exit;
      end;
    for i := 1 to Nb_pos do
    begin
      play(position[i, 1], position[i, 2], position[i, 3]);
      if depth = 2 then
      begin
        if color then evaluated := -leaffalse(-alpha)
          else evaluated := -sheettrue(-alpha);
      end else evaluated := -AlphaBetalegere(depth - 1,
                              -beta, -alpha, not color);
      if evaluated > Best then
      begin
        Best := evaluated;
        if Best >= beta then
        begin
          AlphaBetalegere := Best;
          exit;
        end;
        alpha := max(alpha, Best);
      end;
      Positive := progress;
    end;
  end;
  AlphaBetalegere := Best;
end;

function AlphaBeta(const depth: integer; alpha: integer; const beta: integer; const color: boolean): integer;
var
  evaluated, Best, i, j: integer;
  liste_coup: List_Move;
  tmp: Element;
  progress: Chessboard;
begin
  if depth = 1 then if color then begin alphabeta := sheettrue(beta);
    exit;
  end else
  begin
    alphabeta := leaffalse(beta); exit; end;
    progress := Positive;
    Best := -infini;
    generate_hit_list(color);
    liste_coup := Possible_Moves;
  with liste_coup do
  begin
    if Nb_pos = 0 then if color then
      begin
        if UnderFire(Positive.Position_King[Black], -1, false) then
          AlphaBeta := -infini + (profope - depth) else AlphaBeta := 0;
        exit;
      end else
      begin
        if UnderFire(Positive.Position_King[white], 1, false) then
          AlphaBeta := -infini + (profope - depth) else AlphaBeta := 0;
        exit;
      end;
      for i := 1 to Nb_pos do if Stack_1[depth] = position[i, 1] then
        if Stack_2[depth] = position[i, 2] then
        begin
          tmp := position[i];
          for j := i downto 2 do position[j] := position[j - 1];
          position[1] := tmp;
          Break;
        end;
    for i := 1 to Nb_pos do
    begin
      Application.processmessages;
      play(position[i, 1], position[i, 2], position[i, 3]);
      evaluated := -AlphaBeta(depth - 1, -beta, -alpha, not color);
      if evaluated > Best then
      begin
        Best := evaluated;
        if Best >= beta then
        begin
          AlphaBeta := Best;
          Stack_1[depth] := position[i, 1];
          Stack_2[depth] := position[i, 2];
          exit;
        end;
        alpha := max(alpha, Best);
      end;
      Positive := progress;
    end;
  end;
  AlphaBeta := Best;
end;

function negascout(const depth: integer; alpha: integer; const beta: integer; const color: boolean): integer;
var
  i, j, a, b, t: integer;
  liste_coup: List_Move;
  tmp: Element;
  progress: Chessboard;
begin
  if depth = 3 then
    begin
      Negascout := alphabeta(depth, alpha, beta, color);
        exit; end;
  if stop then
  begin
  Negascout :=0;
  exit;
  end;
  progress := Positive;
  generate_hit_list(color);
  liste_coup := Possible_Moves;
  a := alpha; b := beta;
  with liste_coup do
  begin
    if Nb_pos = 0 then if color then
    begin
      if UnderFire(Positive.Position_King[Black], -1, false) then
        Negascout := -infini + (profope - depth) else Negascout := 0;
      exit;
    end else
    begin
      if UnderFire(Positive.Position_King[white], 1, false) then
        Negascout := -infini + (profope - depth) else Negascout := 0;
      exit;
    end;
    if (depth = profope-1) AND (profope<12) then
    for i := 1 to Nb_pos do
    begin
      play(position[i, 1], position[i, 2], position[i, 3]);
      position[i, 4] := -AlphaBeta(3, -beta, -alpha, not color);
      Positive := progress;
    end else 
    for i := 1 to Nb_pos do
    begin
      play(position[i, 1], position[i, 2], position[i, 3]);
      case depth of
              2..6:position[i, 4] := assess(color);
             7..15:position[i, 4] := -AlphaBetalegere(2, -beta, -alpha, not color);
      end;
      Positive := progress;
    end;
    Tri_Whatever(liste_coup, Nb_pos);
    for i := 1 to Nb_pos do if Stack_1[depth] = position[i, 1] then
      if Stack_2[depth] = position[i, 2] then
    begin
      tmp := position[i];
      for j := i downto 2 do position[j] := position[j - 1];
      position[1] := tmp;
      Break;
    end;
    for i := 1 to Nb_pos do
    begin
      Application.processmessages;
      play(position[i, 1], position[i, 2], position[i, 3]);
      t := -Negascout(depth - 1, -b, -a, not color);
      if (t > a) and (t < beta) and (i > 1) then
        a := -Negascout(depth - 1, -beta, -t, not color);
      a := max(a, t);
      if a >= beta then
      begin
        Negascout := a;
        Stack_1[depth] := position[i, 1];
        Stack_2[depth] := position[i, 2];
        exit;
      end;
      Positive := progress;
      b := a + 1;
    end;
  end;
  Negascout := a;
end;

procedure Research(const color: boolean);
var
  The_Best, i, j, alpha: integer;
  liste_coup: List_Move;
  encours: Chessboard;
  annule: boolean;
  a, b, t: integer;
begin
  annule := true; alpha := -infini; stop := false; a := alpha; b := infini;
  enabler(false, false, false, false);
  Positive.Total := 0;
  FillChar(Stack_1, Sizeof(Stack_1), 0); FillChar(Stack_2, Sizeof(Stack_2), 0);
  encours := Positive;
  The_Best := -infini - 60;
  generate_hit_list(color);
  liste_coup := Possible_Moves;
  if liste_coup.Nb_pos = 0 then
  begin
    if (color and UnderFire(Positive.Position_King[Black], -1, false)) or
      (not color and UnderFire(Positive.Position_King[white], 1, false)) then
    begin
      showmessage('Matt !');
      part_in_progress := false;
    end else
    begin
      showmessage('Zero');
      encours := Positive;
      part_in_progress := false;
    end;
    exit;
  end;
  h := GetTickCount;
  form1.Timer1.Enabled:=true;
  with liste_coup do
  begin
    for i := 1 to Nb_pos do
    begin
      play(position[i, 1], position[i, 2], position[i, 3]);
      position[i, 4] := -negascout(3, -infini, -alpha, not color);
      Positive := encours;
    end;
    Tri_Whatever(liste_coup, Nb_pos);
    alpha := -infini;
    for i := 1 to Nb_pos do
    begin
      play(position[i, 1], position[i, 2], position[i, 3]);
      position[i, 4] := -negascout(5, -infini, -alpha, not color);
      Positive := encours;
    end;
    Tri_Whatever(liste_coup, Nb_pos);
    Draw(Positive_draw);
    if Nb_pos=1 then
    begin
      best_departure := position[1, 1];
      best_arrival := position[1, 2];
      best_erase := position[1, 3];
    end else
    for i := 1 to Nb_pos do
    begin
      Poster;
      if form1.Effacerlesflches1.checked then Draw(Positive_draw);
      If i>1 then  Arrow(best_departure, best_arrival,clgray);
      Arrow(position[i, 1], position[i, 2],clBlue);
      if stop then exit;
      play(position[i, 1], position[i, 2], position[i, 3]);
      t := -Negascout(profope - 1, -b, -a, not color);
      if (t > a) and (i > 1) then
        a := -Negascout(profope - 1, -infini, -t, not color);
      a := max(a, t);
      Nb_Repetition := 0;

      for j := 1 to Stack_Size_Rep do
        if compareMem(@encours, @StackRep[j], 64) then
          Inc(Nb_Repetition);
      if annule then if Nb_repetition > 2 then
        begin
          showmessage('The computer could cancel by playing : ' +
            cartesien(position[i, 1]) + cartesien(position[i, 2]));
          if nb_pos > 1 then a := -infini;
          nb_repetition := 0; annule := false;
        end;
      if a > The_Best then
      begin
        The_Best := a;
        best_departure := position[i, 1];
        best_arrival := position[i, 2];
        best_erase := position[i, 3];
        if (The_Best > infini - 20) then begin Positive := encours;
        break;
        end;
      end;
      Positive := encours;
      b := a + 1;
    end;
  end;
  form1.Timer1.Enabled:=false;
  Poster;
end;

end.

