unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Menus, ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Beenden1: TMenuItem;
    Start1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Hilfe1: TMenuItem;
    Hinweis: TMenuItem;
    ZufaelligesLabyrinth1: TMenuItem;
    Beispiel11: TMenuItem;
    Beispiel21: TMenuItem;
    ErzeugeLabyrinth1: TMenuItem;
    Beispiel31: TMenuItem;
    Beispiel41: TMenuItem;
    Beispiel51: TMenuItem;
    Beispiel61: TMenuItem;
    Bisrechtsunten1: TMenuItem;
    WelchesZielisterreichbar1: TMenuItem;
    Tempo1: TMenuItem;
    KeineVerzgerung1: TMenuItem;
    Verzoegerung10ms: TMenuItem;
    Verzoegerung100ms: TMenuItem;
    VielZuSchnell1: TMenuItem;
    Beispiel71: TMenuItem;
    SpeichereIrrgarten1: TMenuItem;
    LaseIrgarten1: TMenuItem;
    N1: TMenuItem;
    WeitereEinstellungen1: TMenuItem;
    N2: TMenuItem;
    procedure ZuflligeVerteilung1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Beispiel11Click(Sender: TObject);
    procedure Beispiel21Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure Beispiel31Click(Sender: TObject);
    procedure Beispiel41Click(Sender: TObject);
    procedure Beispiel51Click(Sender: TObject);
    procedure Beispiel61Click(Sender: TObject);
    procedure Bisrechtsunten1Click(Sender: TObject);
    procedure WelchesZielisterreichbar1Click(Sender: TObject);
    procedure KeineVerzgerung1Click(Sender: TObject);
    procedure Verzoegerung10msClick(Sender: TObject);
    procedure Verzoegerung100msClick(Sender: TObject);
    procedure VielZuSchnell1Click(Sender: TObject);
    procedure Beispiel71Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeichereIrrgarten1Click(Sender: TObject);
    procedure LaseIrgarten1Click(Sender: TObject);
    procedure HinweisClick(Sender: TObject);
    procedure WeitereEinstellungen1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

type
  TMeineFarben = (weiss, schwarz, gelb, rot);

const
  ModulFuerRandomfolge = 210018313;  // Primenummber

var
  Form1: TForm1;
  zaehl: integer;
  verzoegerung: integer = 10;
  breite: integer = 16;
  Row: integer = 40;    // From 0 to Row = Number of Rows + 1
  Col: integer = 60;    // From 0 to Col = number of Col+1
  grid: array[0..500,0..500] of TmeineFarben;

procedure zeichneAlles;

implementation

uses Unit2;

{$R *.DFM}
// Color from 0 to maximum color
procedure zeichne(reihe,spalte: integer; farbe: TMeineFarben);
begin
 grid[reihe,spalte] := farbe;
 with form1.image1.Canvas do
 begin
   pen.Width := 1;
   pen.Color := clGray;
   Case farbe of weiss:   brush.color := clwhite;
                 schwarz: brush.color := clblack;
                 gelb:    brush.color := clyellow;
                 rot:     brush.Color := clred;
   end;
     rectangle(breite*spalte,
               breite*reihe,
               breite*succ(spalte),
               breite*succ(reihe));
 end;
end;

procedure zeichneAlles;
const
  rand = 20;
var
  i,j: integer;
begin
  with Form1 do
  begin
    clientwidth := (col+1)*breite + 2*rand;
    clientHeight := (Row+1)*breite + 2*rand;
    //color := clblue;

    with Image1 do
    begin
      width := (Col+1)*breite;
      height := (Row+1)*breite;
      left := rand;
      top := rand;
    end;
  end;

  for i := 0 to Row do
    for j := 0 to Col do
      zeichne(i,j,grid[i,j]);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i,j: Integer;
begin
   for i := 0 to Row do
    for j := 0 to Col do
      grid[i,j] := weiss;

   zeichneAlles;
end;

procedure Anfangszustand(SetzteRandseed,prozent: integer);
var
  i, j: integer;
begin
  randseed := SetzteRandseed;
  form1.Caption := 'Initial value =' + inttostr(SetzteRandseed);
  zaehl := 0;

  for i := 0 to Row do
    for j := 0 to Col do
      if random(100) < prozent then
        grid[i,j] := schwarz
      else
        grid[i,j] := weiss;

  grid[0,0] := weiss;
  grid[row,col] := weiss;
  zeichneAlles;
end;

procedure TForm1.ZuflligeVerteilung1Click(Sender: TObject);
begin
  randomize;
  Anfangszustand(randseed,33);
end;

procedure StringToGrid(const s: string);
var
  pu: Tstringlist;
  i,j: integer;
begin
  form1.Caption := 'Labyrinth';
  pu := TStringlist.Create;
  try
    pu.Text := s;
  for i := 0 to row + 1 do
  begin
   if i >= pu.count - 1 then pu.Add('');
   while length(pu[i]) < Col + 1 do
    pu[i] := pu[i] + '0';
  end;

  for i := 0 to Row do
    for j := 0 to Col do
      if pu[i][j+1] = '1' then
        grid[i,j] := schwarz
      else
        grid[i,j] := weiss;
  finally
    pu.Free
  end;

  zeichneAlles;
end;

procedure TForm1.Beispiel11Click(Sender: TObject);
begin
  row := 40; 
  col := 60;
  stringToGrid(
   '0000010100110101101011100011100000000010101001110011101110111'#13#10+
'1100100000000100011000000000100000000000000110100000011101001'#13#10+
'0010111000010010000000000011100110000000010100110100100000000'#13#10+
'0000000110000011001001100001000110000101010001100000100010100'#13#10+
'0000000000000010001000100001000001010100001100110010000000010'#13#10+
'1010101011000000101000000110100010010110010110101001110001001'#13#10+
'0010010101101101101010111010000000000000011000001100011010000'#13#10+
'0110100000010010001000111101000000100001010100000010111011001'#13#10+
'1000001000100100001000010001001101100000000001010001001000101'#13#10+
'0001000000101000011110011000010000000000001111001100000011000'#13#10+
'0001011111110001101100001010100000100011000010011000100000001'#13#10+
'1000100110111010001010000110101111000100001100011100010110011'#13#10+
'0011000001000101001001011101011100011000010100000110100000010'#13#10+
'0000100000010100001101110111001011100010011001000001000100010'#13#10+
'1000001100000000011000100100000101100000100000000011101001100'#13#10+
'1000110010000001111001111000010100101111001100100010000000000'#13#10+
'1100001000001100000110001111100010001000000011001011001000010'#13#10+
'0011010001101100101100010001010001000110001000001110000010010'#13#10+
'1000010011011000111110000100000100110000001100101000000100000'#13#10+
'0000111000100101001001000001011101001100100000110000000001010'#13#10+
'0001100000000110010010101001100110010010101000110010001001111'#13#10+
'0100100110100001001000101001000101000110100010001110000000101'#13#10+
'0000111010110100010011100011101001010000110110110000100000011'#13#10+
'0001011010011011010100000001001001010000001001000100101110010'#13#10+
'0011100110011001001000111011010000000001000011000010001010110'#13#10+
'0001000000001000010001001000000000010000000011001100011000000'#13#10+
'1000011000000001010000011110101010110000001001100001001001000'#13#10+
'0100011010101010111000101100101110010000111001001010100100000'#13#10+
'0000010000100100011000010101010000010000000000000101100100000'#13#10+
'0011010011000011111000000000000001011100010010001000001110100'#13#10+
'1001100000000010000001100011010100001100100001111001000001000'#13#10+
'1001100000000010010100011110000110010100000110000010110100001'#13#10+
'0110100010011100110000010001011001010001100000110000110000111'#13#10+
'0100000001001000001000010100001010110110101111010000010100010'#13#10+
'0100100100100000100110000000010100010000001110100010011010101'#13#10+
'1101010011001000001001000100111001010001011011011111000000110'#13#10+
'0000001101001000000110011011100001001000010010001011011101010'#13#10+
'1100100001110001000010010000101001011001000100010100010001100'#13#10+
'0101001000000010000100000000100001110000010001100101000110000'#13#10+
'0000000000000101001000101000100100000000001001000111111110101'#13#10+
'1001000000001000001001000001100100010000100000010000000000000');
end;

procedure TForm1.Beispiel21Click(Sender: TObject);
begin
  Anfangszustand(164,33);
end;

function findepfad(reihe,spalte: integer; mitZiel: boolean): boolean;
var
  b: boolean;
  r: integer;
begin
  inc(zaehl);
  if verzoegerung >= 0 then
  begin
     sleep(verzoegerung);
     application.ProcessMessages;
  end;
  if (reihe=Row) and (spalte=Col) then
  begin
    result := true;
    zeichne(reihe,spalte,gelb);
    if Mitziel then exit; // complete
  end;
  if (reihe < 0) or (spalte <0) or (reihe > Row) or (Spalte > Col) then
  begin
    result := false;
    exit;
  end;
  Case grid[reihe,spalte] of schwarz,gelb,rot: result := false;
                                    // Wall or spot already reached
                    weiss: begin    // New position reached
                      zeichne(reihe,spalte,gelb);
                      b := false;
                      r := 1;
                      while (not b) and (r < 5) do
                      begin
                        case r of
                          1: b := findepfad(reihe, spalte + 1, mitZiel);
                          2: b := findepfad(reihe + 1, spalte, mitZiel);
                          3: b := findepfad(reihe, spalte - 1, mitZiel);
                          4: b := findepfad(reihe - 1, spalte, mitZiel);
                        end;
                        inc(r);
                        if b then break;  //b=true: From here there is a way to the destination.
                                          //break heißt: From here there is a way to the destination.

                      end;
                      if not b then zeichne(reihe,spalte,rot);
                      result := b;
                    end;
                    else result := false; // It doesn't happen. But it reassures the compiler.
  End;
end;

procedure TForm1.Beenden1Click(Sender: TObject);
begin
  close();
end;

procedure TForm1.Beispiel31Click(Sender: TObject);
begin
   Anfangszustand(347,33);
end;

procedure TForm1.Beispiel41Click(Sender: TObject);
begin
   Anfangszustand(2047,33);
end;

procedure TForm1.Beispiel51Click(Sender: TObject);
begin
   Anfangszustand(2152,33);
end;

procedure TForm1.Beispiel61Click(Sender: TObject);
begin
 Anfangszustand(2616,33);
end;

procedure TForm1.Bisrechtsunten1Click(Sender: TObject);
begin
 if findepfad(0,0,true) then
  showmessage('Goal achieved')
    else
  showmessage('Goal not achieved!');

  form1.Caption := 'Steps = ' + inttostr(zaehl);
end;

procedure TForm1.WelchesZielisterreichbar1Click(Sender: TObject);
begin
  if findepfad(0,0,false) then {};
  showmessage('Yellow: goal achieved.'#13+
     'White: Fields that cannot be reached');
end;

procedure TForm1.KeineVerzgerung1Click(Sender: TObject);
begin
  verzoegerung := 0;
end;

procedure TForm1.Verzoegerung10msClick(Sender: TObject);
begin
  verzoegerung := 10;
end;

procedure TForm1.Verzoegerung100msClick(Sender: TObject);
begin
   verzoegerung := 100;
end;

procedure TForm1.VielZuSchnell1Click(Sender: TObject);
begin
  verzoegerung := -1;
end;

procedure TForm1.Beispiel71Click(Sender: TObject);
begin
   Anfangszustand(58883990,33);
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  u,v: integer;
begin
  v := x div Breite;
  u := y div Breite;

  if grid[u,v] <> schwarz then
    grid[u,v] := schwarz
  else
    grid[u,v] := weiss;

  zeichneAlles;
end;


procedure TForm1.SpeichereIrrgarten1Click(Sender: TObject);
var
  pu: Tstringlist;
  i,j: integer;
  s: string;
begin
  pu := TStringlist.Create;
  try
    for i := 0 to Row do
    begin
      s := '';
      for j := 0 to Col do if grid[i,j] = schwarz
        then s := s + '1' else s := s + '0';
      pu.add(s);
    end;
    with savedialog1 do if execute then
      pu.SaveToFile(filename);
  finally
    pu.Free
  end;
end;

procedure TForm1.LaseIrgarten1Click(Sender: TObject);
var
  pu: Tstringlist;
begin
  pu := TStringlist.Create;
  try
    with opendialog1 do if execute then
      pu.LoadFromFile(filename)
    else
      exit;
  stringToGrid(pu.text);
  finally
    pu.Free
  end;

  zeichneAlles;
end;

procedure TForm1.HinweisClick(Sender: TObject);
const
  hinweis =
'{\rtf1\ansi\ansicpg1252\deff0\deflang1031{\fonttbl{\f0\froman\fprq2\fcharset0 Times New Roman;}'#13+
'{\f1\fnil\fcharset0 Times New Roman;}}'#13+
'{\colortbl ;\red255\green0\blue0;\red0\green0\blue0;}'#13+
'\viewkind4\uc1\pard\qc\cf1\f0\fs48 Notice\par'#13+
'\par'#13+
'\pard\cf2\fs24 1. Step: Draw a maze by clicking on the squares.\par'#13+
'               or use the "Create Maze" menu and modify it.\par'#13+
'               or load a previously drawn labyrinth using the "File" menu.\par\par'#13+
'2. Step: Save your maze so you can use it again later.  \par\par'#13+
'3. Step: Adjust the speed using the "Settings" menu.\par\par'#13+
'4. Step: Menu "Start"\par'#13+
'                Normal: "To the bottom right." Then the computer searches for a suitable path, if possible.\par'#13+
'                or "Which goal is achievable?". The computer then highlights all fields that are achievable.\par'#13+
'\par'#13+
'\par'#13+
'\pard\qc\cf1\fs48 Have fun with the maze!\cf0\f1\fs20\par'#13+
'}';

var
  ms: TMemoryStream;
  pu: Tstringlist;
begin
  form2.Show;
  ms := TMemoryStream.Create;
  pu := TStringlist.Create;
  try
    pu.Text := hinweis;
    pu.SaveToStream(ms);
    ms.Position := 0;
  finally
    pu.free;
    ms.free
  end;
end;

procedure TForm1.WeitereEinstellungen1Click(Sender: TObject);
begin
  form2.showmodal;
end;

end.
