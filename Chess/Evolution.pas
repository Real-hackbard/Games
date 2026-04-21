unit Evolution;

interface


function assess(const cote: boolean): smallint;

implementation

uses
  SysUtils, Variables, Math;


function assess(const cote: boolean): smallint;
var
  Column, line, ici:integer;
  retour: smallint;
begin
  inc(Nb_Eval);
  with Positive do
  begin
    retour := 0;
    if complexity < 25 then for Column := 0 to 7 do
      begin
        nb_white_pawn[Column] := 0; nb_black_pawn[Column] := 0;
        ici := Column;
        for line := 1 to 6 do
        begin
          inc(ici, 8);
          case cases[ici] of
              Pawn: inc(nb_white_pawn[Column]);
              PawnBlack: inc(nb_black_pawn[Column]);
          end;
        end;
        if nb_white_pawn[Column] = 2 then dec(retour, 20);
        if nb_black_pawn[Column] = 2 then inc(retour, 20);
      end else
    begin
      if Black_rook then
      begin
        case Position_King[Black] of
          1, 2: if Cases[9] = PawnBlack then
            if Cases[10] = PawnBlack then
              if ((Cases[8] = PawnBlack) or (Cases[16] = PawnBlack)) then
                dec(retour, 20);
          5, 6: if Cases[14] = PawnBlack then
                  if ((Cases[15] = PawnBlack) or (Cases[23] = PawnBlack)) then
                    dec(retour, 20);
        end;
        dec(retour, 40);
      end else
      begin
        if not (black_grand_rook or black_little_rook) then inc(retour, 30);
      end;
      if White_rook then
      begin
        case Position_King[white] of
          57, 58: if ((Cases[48] = Pawn) or (Cases[40] = Pawn)) then
                    if Cases[49] = Pawn then
                        if Cases[50] = Pawn then
                          inc(retour, 20);
          61, 62: if Cases[54] = Pawn then
                    if ((Cases[55] = Pawn) or (Cases[47] = Pawn)) then
                      inc(retour, 20);
        end;
        inc(retour, 40);
      end else
      begin
        if not (white_grand_rook or white_little_rook) then dec(retour, 30);
      end;
      for Column := 0 to 7 do
      begin
        nb_white_pawn[Column] := 0; nb_black_pawn[Column] := 0;
        ici := Column;
        for line := 1 to 6 do
        begin
          inc(ici, 8);
          case cases[ici] of
              Pawn: begin inc(nb_white_pawn[Column]);end;
              PawnBlack: begin inc(nb_black_pawn[Column]); end;
          end ;

        end;
        case nb_white_pawn[Column] of
          0: if Column<>0 then if (Column=1) or (nb_white_pawn[Column - 2] = 0) then
                begin
                  if nb_white_pawn[Column - 1] <> 0 then dec(retour, 10); {isolated}
                  if nb_black_pawn[Column - 1] <> 0 then dec(retour, 10); {pass}
                end;

          2: dec(retour, 20); {double}
        end;
        case nb_black_pawn[Column] of
          0: if Column <> 0 then if (Column=1) or (nb_black_pawn[Column - 2] = 0) then
              begin
                if nb_black_pawn[Column - 1] <> 0 then inc(retour, 10); {isolated}
                if nb_white_pawn[Column - 1] <> 0 then inc(retour, 10); {pass}
              end;
          2: inc(retour, 20); {double}
        end;
      end;
      if nb_white_pawn[6] = 0 then
      begin
        if nb_white_pawn[7] <> 0 then dec(retour, 10); {isolated}
        if nb_black_pawn[7] <> 0 then dec(retour, 10); {pass}
      end;
      if nb_black_pawn[6] = 0 then
      begin
        if nb_black_pawn[7] <> 0 then inc(retour, 10); {isolated}
        if nb_white_pawn[7] <> 0 then inc(retour, 10); {pass}
      end;
    end;
    inc(retour, total);
  end;
  if cote then result := -retour else result := retour;
end;

end.

