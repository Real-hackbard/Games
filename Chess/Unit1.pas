unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, variables, Board, ExtCtrls, StdCtrls, ComCtrls, Menus, Buttons;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    L2: TMenuItem;
    Chess1: TMenuItem;
    Grand1: TMenuItem;
    rsgrand1: TMenuItem;
    Help1: TMenuItem;
    Label4: TLabel;
    Level1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Level2: TMenuItem;
    ourner1: TMenuItem;
    N2: TMenuItem;
    S1: TMenuItem;
    O1: TMenuItem;
    OpenDialog2: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Level3: TMenuItem;
    L1: TMenuItem;
    def0: TBitBtn;
    def: TBitBtn;
    ref: TBitBtn;
    reftt: TBitBtn;
    moyen1: TMenuItem;
    Effacerlesflches1: TMenuItem;
    Level4: TMenuItem;
    Stop1: TMenuItem;
    Bleu1: TMenuItem;
    Olive1: TMenuItem;
    Label5: TLabel;
    Level5: TMenuItem;
    Level6: TMenuItem;
    Level7: TMenuItem;
    Timer1: TTimer;
    C1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    A1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure Grand1Click(Sender: TObject);
    procedure rsgrand1Click(Sender: TObject);
    procedure Level1Click(Sender: TObject);
    procedure Level2Click(Sender: TObject);
    procedure ourner1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure Level3Click(Sender: TObject);
    procedure Level4Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure defClick(Sender: TObject);
    procedure refClick(Sender: TObject);
    procedure def0Click(Sender: TObject);
    procedure refttClick(Sender: TObject);
    procedure moyen1Click(Sender: TObject);
    procedure Effacerlesflches1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Bleu1Click(Sender: TObject);
    procedure Olive1Click(Sender: TObject);
    procedure Level5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Level6Click(Sender: TObject);
    procedure Level7Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure A1Click(Sender: TObject);

  private
    { Declarations privates }
  public
    { Declarations public }
  end;
var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Move, Functions, AB, Math, Promotion, SearchForHits, IniFiles, EPD;

procedure TForm1.FormCreate(Sender: TObject);
begin
  EPD_progress:=false;
  field:=tstrings.create;
  randomize;
  //Background_Color := 8421376;
  Background_Color := 111011;
  DoubleBuffered := true;
  left := 10;
  top := 10;
  initialisation(Positive);
  Chess_large := 100;
  Draw(Positive);
  Chess_large := 100;
  Draw(Positive);
  init_prof := 8;
  part_in_progress := False;
  Form1.Label1.caption := '';
  Nb_Tour := 0;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Draw(Positive_draw);
end;

function danslaliste(ca: integer; var ef: integer): boolean;
var
  i: integer;
begin
  for i := 1 to Possible_Moves.Nb_pos do
    if ca = Possible_Moves.position[i, 2] then
    begin
      danslaliste := true;
      ef := Possible_Moves.position[i, 3];
      exit;
    end;
  danslaliste := false;
end;

procedure inc_historique(la, labas, la_ef: integer);
begin
  Combien_hist := Index_hist;
  Inc(Combien_hist);
  Index_hist := Combien_hist;
  with hist_int[Combien_hist] do
  begin
    departure := la;
    arrival := labas;
    erase := la_ef;
    WhatInside := Positive.Cases[labas];
  end;
end;

procedure Ordinateur;
var
  i: integer;
  possibles: List_Move;
  b, find: boolean;
  s: string;
  mouv_str: T_str12;
begin
  form1.Stop1.visible := true;
  form1.File1.Visible := false;
  form1.Label5.Caption:='';
  historical := '';
  Positive_draw := Positive;
  enabler(false, false, false, false);

  for i := 1 to min(combien_hist, 16) do
    historical := historical + cartesien(hist_int[i].departure) +
                  cartesien(hist_int[i].arrival);
  Complexity := 0; {Start: Complexity=88    finale pawn : 3 and 4}
  for i := 0 to 63 do
    case abs(Positive.Cases[i]) of
      6: inc(complexity, 1);
      5: Inc(complexity, 5);
      3, 4: inc(complexity, 4);
      2: inc(complexity, 10);
    end;
  profope := init_prof;
  case complexity of
    0..7: profope := Init_Prof + 2;
    8..30: profope := Init_Prof + 1;
    31..100: Profope := Init_Prof;
  end;
  s := 'Analyse : ' + strint(profope div 2);

  if odd(profope) then s := s + '.5';

  s := s + ' blows';
  form1.label4.Caption := s;
  form1.File1.enabled := false;
  h := GetTickCount;
  Nb_Eval := 0;
  b := following(historical, best_departure, best_arrival);
  if b then
  begin
    best_erase := best_departure;
    Possible_Moves.Nb_pos := 0;
    if (Color_Computer and (Positive.Cases[best_departure] >= 0)) or
      (not Color_Computer and (Positive.Cases[best_departure] <= 0)) then
        b := false else
    begin
      if Color_Computer then black_strokes(best_departure)
        else
      white_shots(best_departure);
      find := false;

      for i := 1 to Possible_Moves.Nb_pos do
        if Possible_Moves.position[i, 2] = best_arrival then
          find := true;
      b := find;
    end;
  end;
  if not b then Research(Color_Computer);
  if part_in_progress then
  begin
    mouv_str := movement(best_departure, best_arrival);
    play(best_departure, best_arrival, best_erase);
    stack_Rep;
    inc_historique(best_departure, best_arrival, best_erase);
    Draw(Positive);
    Positive_draw := Positive;
    Mark_One_Box(best_arrival div 8, best_arrival mod 8, Clblue);
    Mark_One_Box(best_departure div 8, best_departure mod 8, Clblue);
    form1.Label4.Caption := mouv_str;
  end;
  if (Color_Computer and UnderFire(Positive.Position_King[false], 1, false)) or
    (not Color_Computer and UnderFire(Positive.Position_King[true], -1, false)) then
  begin
    form1.label1.caption := 'Failure';
    generate_hit_list(not Color_Computer);
    possibles := Possible_Moves;
    if possibles.Nb_pos = 0 then showmessage('Matt');
  end ;
  enabler(true, true, false, false);
  form1.File1.enabled := true;
  form1.Stop1.visible := false; form1.File1.Visible := true;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  labas, la_ef: integer;
  promo: boolean;
  li, co: integer;
begin
  if not part_in_progress then exit;
  if Color_Computer xor (not Odd(Index_Hist)) XOR
                        (EPD_black_first AND EPD_progress){ XOR EPD_swap } then
  begin
    Beep;
    Showmessage('Its not your turn to play !');
    exit;
  end;
  if button = mbLeft then
  begin
    if not Current_moves then
    begin
      there := x div Chess_large + 8 * (y div Chess_large);
      TurnsAway(li, co, there);
      if ((Positive.Cases[there] <= 0) and Color_Computer) or
         ((Positive.Cases[there] >= 0) and not Color_Computer) then
         exit;

      Possible_Moves.Nb_pos := 0;
      if Color_Computer then
      begin
        Squares_beaten_by_black;
        white_shots(there);
      end else
      begin
        Cases_beaten_by_whites;     
        black_strokes(there);
      end;

      possible_brand;
      if Possible_Moves.Nb_pos <> 0 then Current_moves := true;
    end else
    begin
      enabler(false, false, false, false);
      Current_moves := false;
      labas := x div Chess_large + 8 * (y div Chess_large);
      TurnsAway(li, co, labas);
      if danslaliste(labas, la_ef) then
      begin
        with Positive do with form2 do if Color_Computer then
            begin
              promo := ((labas <= 7) and (Cases[there] = Pawn));
              play(there, labas, la_ef);
              if promo then {promotion for white people}
              begin
                showmodal;
                if RadioButton1.Checked then Cases[labas] := Queen else
                  if RadioButton2.Checked then Cases[labas] := Rook else
                  if RadioButton3.Checked then Cases[labas] := Mad else
                  if RadioButton4.Checked then Cases[labas] := Rider;
                recalculates;
              end;
            end else
            begin
              promo := ((labas >= 56) and (Cases[there] = PawnBlack));
              play(there, labas, la_ef);
              if promo then {promotion for blacks}
              begin
                showmodal;
                if RadioButton1.Checked then Cases[labas] := QueenBlack else
                  if RadioButton2.Checked then Cases[labas] := RookBlack else
                  if RadioButton3.Checked then Cases[labas] := MadBlack else
                  if RadioButton4.Checked then Cases[labas] := BlackRider;
                recalculates;
              end;
            end;
        inc_historique(there, labas, la_ef);
        stack_Rep;
        Draw(Positive);
        Mark_One_Box(there div 8, there mod 8, Clred);
        Mark_One_Box(labas div 8, labas mod 8, Clred);
        Ordinateur;
      end else Draw(Positive);
    end;
  end;
  enabler(true, true, false, false);
end;

procedure retire_checked;
begin
  Form1.Level1.Checked := false;
  Form1.Level2.Checked := false;
  Form1.Level3.Checked := false;
  Form1.Level4.Checked := false;
  form1.Level5.Checked := false;
  form1.Level6.Checked := false;
  form1.Level7.Checked := false;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  EPD_progress:=false;
  Fillchar(StackRep,SizeOf(StackRep),0);
  Color_Computer := true;
  Combien_hist := 0;
  Index_hist := 0;
  Nb_Tour := 0;
  initialisation(Positive);
  Draw(Positive);
  part_in_progress := true;
end;

procedure TForm1.N2Click(Sender: TObject);
var
  rr, la, labas: integer;
begin
  EPD_progress:=false;
  Fillchar(StackRep,SizeOf(StackRep),0);
  Color_Computer := false;
  Combien_hist := 0;
  Index_hist := 0;
  Nb_Tour := 2;
  initialisation(Positive);
  rr := random(7) + 1;
  case rr of
    1, 2, 3: begin la := encrypt('e2'); labas := encrypt('e4'); end;
    4: begin la := encrypt('d2'); labas := encrypt('d4'); end;
    5: begin la := encrypt('f2'); labas := encrypt('f4'); end;
    6: begin la := encrypt('c2'); labas := encrypt('c4'); end;
    7: begin la := encrypt('b2'); labas := encrypt('b4'); end;
  end;
  play(la, labas, la);
  Draw(Positive);
  inc_historique(la, labas, la);
  part_in_progress := true;
end;

procedure TForm1.Level3Click(Sender: TObject);
begin
  Init_Prof := 9;
  retire_checked;
  Level3.Checked := true;
end;

procedure TForm1.Grand1Click(Sender: TObject);
begin
  Chess_large := 60;
  Draw(Positive_draw);
end;

procedure TForm1.rsgrand1Click(Sender: TObject);
begin
  Chess_large := 95;
  Draw(Positive_draw);
end;

procedure TForm1.Level1Click(Sender: TObject);
begin
  Init_Prof := 7;
  retire_checked;
  Level1.Checked := true;
end;

procedure restitue(jusque: integer);
var i: integer;
begin
  for i := 1 to jusque do
  begin
    stack_Rep;
    play(hist_int[i].departure, hist_int[i].arrival, hist_int[i].erase);
    Positive.Cases[hist_int[i].arrival] := hist_int[i].WhatInside
  end;
  Draw(Positive);
  Positive_draw := Positive;
end;

procedure TForm1.Level2Click(Sender: TObject);
begin
  Init_Prof := 8;
  retire_checked;
  Level2.Checked := true;
end;

procedure TForm1.ourner1Click(Sender: TObject);
begin
  Nb_Tour := (Nb_Tour + 1) mod 4;
  Draw(Positive_draw);
end;

procedure TForm1.S1Click(Sender: TObject);
var F: file;
begin
  if SaveDialog1.execute then
  begin
    filename := SaveDialog1.Filename;
    if FileExists(filename) then if
      MessageDlg('The file already exists, do you want to replace it? ?',
            mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
    assignfile(F, filename);
    ReWrite(f, 1);
    try
      BlockWrite(f, Color_Computer, SizeOf(Color_Computer));
      BlockWrite(f, Index_hist, SizeOf(Index_hist));
      BlockWrite(f, Combien_hist, SizeOf(Combien_hist));
      BlockWrite(f, hist_int[1], Combien_hist * SizeOf(hist_int[1]));
    finally
      Closefile(f);
    end;
  end;
end;

procedure TForm1.O1Click(Sender: TObject);
var f: file;
begin
  if openDialog2.execute then
  begin
    filename := OpenDialog2.Filename;
    Index_hist := 0;
    initialisation(Positive);
    part_in_progress := true;
    ASSIGNfile(F, filename);
    ReSet(f, 1);
    try
      BlockRead(f, Color_Computer, SizeOf(Color_Computer));
      BlockRead(f, Index_hist, SizeOf(Index_hist));
      BlockRead(f, Combien_hist, SizeOf(Combien_hist));
      BlockRead(f, hist_int[1], Combien_hist * SizeOf(hist_int[1]));
    finally
      Closefile(f);
    end;
    if Color_Computer then Nb_Tour := 0 else Nb_Tour := 2;
    restitue(Index_hist);
    Draw(Positive);
    Positive_draw := Positive;
    enabler(true, true, Index_hist < Combien_hist, Index_hist < Combien_hist);
  end;
end;


procedure TForm1.Level4Click(Sender: TObject);
begin
  Init_Prof := 10;
  retire_checked;
  Level4.Checked := true;
end;

procedure TForm1.L1Click(Sender: TObject);
begin
  Form3.showmodal;
  form3.edit1.SelectAll;
  initialisation(TheChessBoard);
  if length(form3.edit1.Text) > 0 then
    if EpdToChessboard(form3.edit1.text) then
    begin
     Fillchar(StackRep,SizeOf(StackRep),0);
     EPD_progress:=true;
     EPD_black_first:=false;
     EPD_swap:=false;
     Combien_hist := 0;
     Index_hist := 0;
     part_in_progress := true;
     Positive := TheChessBoard;
     if Color_Computer=true then
     begin
        Nb_Tour := 0;
        EPD_black_first:=true;
     end else Nb_Tour := 2;
     Draw(Positive);
      If not form3.RadioButton1.Checked then
      begin
        EPD_swap:=true;
        Color_Computer:=not Color_Computer;
      end else EPD_swap:=false;
     if not EPD_swap then Ordinateur;
  end;
end;

procedure TForm1.defClick(Sender: TObject);
begin
  if Index_hist < 1 then exit;
  Current_moves := false;

  if not EPD_progress then
    initialisation(Positive)
  else
    Positive:=TheChessBoard;

  dec(Index_hist, 1);
  enabler(Index_hist > 0, Index_hist > 0, true, true);
  restitue(Index_Hist);
  Positive_draw := Positive;
end;

procedure TForm1.refClick(Sender: TObject);
begin
  if Index_hist > Combien_hist - 1 then exit;
  Current_moves := false;
  if not EPD_progress then initialisation(Positive) else Positive:=TheChessBoard;
  inc(Index_hist, 1);
  enabler(true, true, Index_hist < Combien_hist, Index_hist < Combien_hist);
  restitue(Index_Hist);
  Positive_draw := Positive;
end;

procedure TForm1.def0Click(Sender: TObject);
begin
  if Index_hist < 1 then exit;
  Current_moves := false;
  if not EPD_progress then initialisation(Positive) else Positive:=TheChessBoard;
  Index_hist := 0;
  enabler(Index_hist > 0, Index_hist > 0, true, true);
  restitue(Index_Hist);
  Positive_draw := Positive;
end;

procedure TForm1.refttClick(Sender: TObject);
begin
  if Index_hist > Combien_hist - 1 then exit;
  Current_moves := false;
  if not EPD_progress then initialisation(Positive) else Positive:=TheChessBoard;
  Index_hist := Combien_hist;
  enabler(true, true, Index_hist < Combien_hist, Index_hist < Combien_hist);
  restitue(Index_Hist);
  Positive_draw := Positive;
end;

procedure TForm1.moyen1Click(Sender: TObject);
begin
  Chess_large := 80;
  Draw(Positive_draw);
end;

procedure TForm1.Effacerlesflches1Click(Sender: TObject);
begin
  Effacerlesflches1.Checked := not (Effacerlesflches1.checked);
end;

procedure TForm1.Stop1Click(Sender: TObject);
begin
  stop := true;
end;

procedure change_color(de,enca:Tcolor);
var
  li,co,debut:integer;
  ligne:boolean;
begin
  ligne :=false;form1.Image1.canvas.pen.Color:=enca;
   With form1.Image1 do
   for li:=0  to Height do
    for co:=0 to width do
      with canvas do
      begin
       if pixels[co,li]=de then
       begin
         if not ligne then
         begin
           ligne:=true;debut:=co;
         end;
       end else
       begin
         if ligne then
         begin
           ligne:=false;moveto(debut,li);lineTo(co-1,li);
         end;
       end;
   end;
end;

procedure TForm1.Bleu1Click(Sender: TObject);
begin
   Background_Color:=8421376;
   change_color(Clolive,8421376);
end;

procedure TForm1.Olive1Click(Sender: TObject);
begin
   Background_Color:=ClOlive;
   change_color(8421376,ClOlive);
end;

procedure TForm1.Level5Click(Sender: TObject);
begin
  Init_Prof := 11;
  retire_checked;
  Level5.Checked := true;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  field.free;
end;

procedure TForm1.Level6Click(Sender: TObject);
begin
  Init_Prof := 12;
  retire_checked;
  Level6.Checked := true;
end;

procedure TForm1.Level7Click(Sender: TObject);
begin
  Init_Prof := 13;
  retire_checked;
  Level7.Checked := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   Poster;
end;

procedure TForm1.A1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.

