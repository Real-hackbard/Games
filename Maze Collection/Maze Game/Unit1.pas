unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, SoundPlayerThread, MMSystem;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Shape1: TShape;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    F1: TMenuItem;
    Q1: TMenuItem;
    SaveDialog1: TSaveDialog;
    S1: TMenuItem;
    N1: TMenuItem;
    M1: TMenuItem;
    N2: TMenuItem;
    J1: TMenuItem;
    V1: TMenuItem;
    B1: TMenuItem;
    S2: TMenuItem;
    N3: TMenuItem;
    M2: TMenuItem;
    ColorDialog1: TColorDialog;
    S3: TMenuItem;
    N4: TMenuItem;
    J2: TMenuItem;
    N5: TMenuItem;
    H1: TMenuItem;
    A1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure Init;
    procedure Draw;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Q1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure J1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure M2Click(Sender: TObject);
    procedure S3Click(Sender: TObject);
    procedure J2Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


const
  szw = 70;
  szh = 50;
  cellsz = 12;
type
  point=record
    x,y: integer;
  end;

var
  maze: array [0..szw-1] of array [0..szh-1] of integer;
  todo: array [0..szw*szh-1] of point;
  todonum: integer;

const
  dx: array [0..3] of integer=(0, 0, -1, 1);
  dy: array [0..3] of integer=(-1, 1, 0, 0);

var
  Form1: TForm1;
  Kol: Integer;
  ms: TMemoryStream;
  Color : TColor;
  best : integer;

implementation

uses Unit2;

{$R *.dfm}
procedure PlayWaveStream(Stream: TMemoryStream);
begin
  if Stream = nil then
    sndPlaySound(nil, SND_ASYNC) //stop sound
  else
    sndPlaySound(Stream.Memory, (SND_ASYNC or SND_MEMORY));
end;

procedure TForm1.Draw;
var
  x,y: integer;
begin
  if B1.Checked = true then Image1.Canvas.Pen.Width := 2;

  Image1.Canvas.Pen.Color := Color;

  for x:=1 to szw-2 do
    for y:=1 to szh-2 do
    begin
     if ((maze[x][y] and 1) <> 0) then
     begin
         Image1.Canvas.MoveTo(x * cellsz, y * cellsz);
         Image1.Canvas.LineTo(x * cellsz + cellsz + 1, y * cellsz);
     end;

     if ((maze[x][y] and 2) <> 0) then
     begin
         Image1.Canvas.MoveTo(x * cellsz, y * cellsz + cellsz);
         Image1.Canvas.LineTo(x * cellsz + cellsz + 1, y * cellsz + cellsz);
     end;

     if ((maze[x][y] and 4) <> 0) then
     begin
         Image1.Canvas.MoveTo(x * cellsz, y * cellsz);
         Image1.Canvas.LineTo(x * cellsz, y * cellsz + cellsz + 1);
     end;

     if ((maze[x][y] and 8) <> 0) then
     begin
         Image1.Canvas.MoveTo(x * cellsz + cellsz, y * cellsz);
         Image1.Canvas.LineTo(x * cellsz + cellsz, y * cellsz + cellsz + 1);
     end;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  init;
  draw;
  Image1.Canvas.Pixels[821,484]:= ClBlue;
  Image1.Canvas.Pixels[822,584]:= ClBlue;
  Image1.Canvas.Pixels[821,585]:= ClBlue;
  Image1.Canvas.Pixels[822,585]:= ClBlue;
end;

procedure TForm1.Init;
var
  x,y,n,d: integer;
begin
  for x:=0 to szw-1 do
    for y:=0 to szh-1 do
      if (x=0) or (x=szw-1) or (y=0) or (y=szh-1) then
        maze[x][y]:=32
      else
        maze[x][y]:=63;

  Randomize;
  x := Random(szw-2)+1;
  y := Random(szh-2)+1;

  maze[x][y]:= maze[x][y] and not 48;

  for d:=0 to 3 do
    if (maze[x + dx[d]][y + dy[d]] and 16) <> 0 then
    begin
      todo[todonum].x:=x + dx[d];
      todo[todonum].y:=y + dy[d];
      Inc(todonum);
      maze[x + dx[d]][y + dy[d]] := maze[x + dx[d]][y + dy[d]] and not 16;
    end;

   while todonum > 0 do
   begin
       n:= Random(todonum);
       x:= todo[n].x;
       y:= todo[n].y;

       Dec(todonum);
       todo[n]:= todo[todonum];

       repeat
           d:=Random (4);
       until not ((maze[x + dx[d]][y + dy[d]] and 32) <> 0);

       maze[x][y] := maze[x][y] and not ((1 shl d) or 32);
       maze[x + dx[d]][y + dy[d]] := maze[x + dx[d]][y + dy[d]] and not
                                        (1 shl (d xor 1));

       for d:=0 to 3 do
           if (maze[x + dx[d]][y + dy[d]] and 16) <> 0 then
           begin
             todo[todonum].x := x + dx[d];
             todo[todonum].y := y + dy[d];
             Inc(todonum);
             maze[x + dx[d]][y + dy[d]] := maze[x + dx[d]][y + dy[d]] and not 16;
           end;
   end;

   maze[1][1] := maze[1][1] and not 1;
   maze[szw-2][szh-2] := maze[szw-2][szh-2] and not 2;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  kol:=kol+1;
  StatusBar1.Panels[2].Text := IntToStr(kol);

  // goal achieved
  if (Image1.Canvas.Pixels[Shape1.Left,Shape1.Top+7]) and
     (Image1.Canvas.Pixels[Shape1.Left+1,Shape1.Top+7]) and
     (Image1.Canvas.Pixels[Shape1.Left+2,Shape1.Top+7]) and
     (Image1.Canvas.Pixels[Shape1.Left+3,Shape1.Top+7]) and
     (Image1.Canvas.Pixels[Shape1.Left+4,Shape1.Top+7]) and
     (Image1.Canvas.Pixels[Shape1.Left+5,Shape1.Top+7]) and
     (Image1.Canvas.Pixels[Shape1.Left+6,Shape1.Top+7]) and

     (Image1.Canvas.Pixels[Shape1.Left+7,Shape1.Top]) and
     (Image1.Canvas.Pixels[Shape1.Left+7,Shape1.Top+1]) and
     (Image1.Canvas.Pixels[Shape1.Left+7,Shape1.Top+2]) and
     (Image1.Canvas.Pixels[Shape1.Left+7,Shape1.Top+3]) and
     (Image1.Canvas.Pixels[Shape1.Left+7,Shape1.Top+4]) and
     (Image1.Canvas.Pixels[Shape1.Left+7,Shape1.Top+5]) and
     (Image1.Canvas.Pixels[Shape1.Left+7,Shape1.Top+6]) and
     (Image1.Canvas.Pixels[Shape1.Left+7,Shape1.Top+7]) = clBlue then
  begin
    if S2.Checked = true then
    begin
      ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\win.wav'));
      ms.Position := 0;
      PlayWaveStream(ms);
    end;
    StatusBar1.Panels[0].Text := 'WINNER!';

    if kol > best then
    begin
      ShowMessage('Congratulations, youve broken the record. goal in : ' + #13 +
                IntToStr(kol) + ' Pixels.');
      StatusBar1.Panels[4].Text := IntToStr(kol) + ' Pixels';
      Exit;
    end;

    ShowMessage('Congratulations, youve made it to the goal in : ' + #13 +
                IntToStr(kol) + ' Pixels.');
    Exit;
  end;

  case key of
        // move to the left
    37: if (Image1.Canvas.Pixels[Shape1.Left-1, Shape1.Top]) and
           (Image1.Canvas.Pixels[Shape1.Left-1, Shape1.Top+1]) and
           (Image1.Canvas.Pixels[Shape1.Left-1, Shape1.Top+2]) and
           (Image1.Canvas.Pixels[Shape1.Left-1, Shape1.Top+3]) and
           (Image1.Canvas.Pixels[Shape1.Left-1, Shape1.Top+4]) and
           (Image1.Canvas.Pixels[Shape1.Left-1, Shape1.Top+5]) and
           (Image1.Canvas.Pixels[Shape1.Left-1, Shape1.Top+6]) <> Color then
        begin
          Shape1.Left:=Shape1.Left-1;
          StatusBar1.Panels[0].Text := 'Move to Left';
          if S2.Checked = true then
          begin
            ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\tic.wav'));
            ms.Position := 0;
            PlayWaveStream(ms);
          end;

          StatusBar1.Panels[6].Text := IntToStr(Shape1.Left)+'x'+
                                       IntToStr(Shape1.Top);
        end else begin
          StatusBar1.Panels[0].Text := 'Blocked';
          if S2.Checked = true then
          begin
            ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\Block.wav'));
            ms.Position := 0;
            PlayWaveStream(ms);
          end;
        end;

        // move to the right
    39: if (Image1.Canvas.Pixels[Shape1.Left+7, Shape1.Top]) and
           (Image1.Canvas.Pixels[Shape1.Left+7, Shape1.Top+1]) and
           (Image1.Canvas.Pixels[Shape1.Left+7, Shape1.Top+2]) and
           (Image1.Canvas.Pixels[Shape1.Left+7, Shape1.Top+3]) and
           (Image1.Canvas.Pixels[Shape1.Left+7, Shape1.Top+4]) and
           (Image1.Canvas.Pixels[Shape1.Left+7, Shape1.Top+5]) and
           (Image1.Canvas.Pixels[Shape1.Left+7, Shape1.Top+6]) <> Color then
        begin
          Shape1.Left := Shape1.Left+1;
          StatusBar1.Panels[0].Text := 'Move to Right';
          if S2.Checked = true then
          begin
            ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\tic.wav'));
            ms.Position := 0;
            PlayWaveStream(ms);
          end;
          StatusBar1.Panels[6].Text := IntToStr(Shape1.Left)+'x'+
                                       IntToStr(Shape1.Top);
        end else begin
          StatusBar1.Panels[0].Text := 'Blocked';
          if S2.Checked = true then
          begin
            ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\Block.wav'));
            ms.Position := 0;
            PlayWaveStream(ms);
          end;
        end;

        // move down
    40: if (Image1.Canvas.Pixels[Shape1.Left, Shape1.Top+7]) and
           (Image1.Canvas.Pixels[Shape1.Left+1, Shape1.Top+7]) and
           (Image1.Canvas.Pixels[Shape1.Left+2, Shape1.Top+7]) and
           (Image1.Canvas.Pixels[Shape1.Left+3, Shape1.Top+7]) and
           (Image1.Canvas.Pixels[Shape1.Left+4, Shape1.Top+7]) and
           (Image1.Canvas.Pixels[Shape1.Left+5, Shape1.Top+7]) and
           (Image1.Canvas.Pixels[Shape1.Left+6, Shape1.Top+7]) <> Color then
        begin
          Shape1.Top:=Shape1.Top+1;
          StatusBar1.Panels[0].Text := 'Move to Down';
          if S2.Checked = true then
          begin
            ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\tac.wav'));
            ms.Position := 0;
            PlayWaveStream(ms);
          end;
          StatusBar1.Panels[6].Text := IntToStr(Shape1.Left)+'x'+
                                       IntToStr(Shape1.Top);
        end else begin
          StatusBar1.Panels[0].Text := 'Blocked';
          if S2.Checked = true then
          begin
            ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\Block.wav'));
            ms.Position := 0;
            PlayWaveStream(ms);
          end;
        end;

        // move up
    38: if (Image1.Canvas.Pixels[Shape1.Left, Shape1.Top-1]) and
           (Image1.Canvas.Pixels[Shape1.Left+1, Shape1.Top-1]) and
           (Image1.Canvas.Pixels[Shape1.Left+2, Shape1.Top-1]) and
           (Image1.Canvas.Pixels[Shape1.Left+3, Shape1.Top-1]) and
           (Image1.Canvas.Pixels[Shape1.Left+4, Shape1.Top-1]) and
           (Image1.Canvas.Pixels[Shape1.Left+5, Shape1.Top-1]) and
           (Image1.Canvas.Pixels[Shape1.Left+6, Shape1.Top-1]) <> Color then
        begin
          Shape1.Top:=Shape1.Top-1;
          StatusBar1.Panels[0].Text := 'Move to Up';
          if S2.Checked = true then
          begin
            ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\tac.wav'));
            ms.Position := 0;
            PlayWaveStream(ms);
          end;
          StatusBar1.Panels[6].Text := IntToStr(Shape1.Left)+'x'+
                                       IntToStr(Shape1.Top);
        end else begin
          StatusBar1.Panels[0].Text := 'Blocked';
          if S2.Checked = true then
          begin
            ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\Block.wav'));
            ms.Position := 0;
            PlayWaveStream(ms);
          end;
        end;
  end;

end;

procedure TForm1.Q1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.S1Click(Sender: TObject);
begin
 if SaveDialog1.Execute then
  Image1.Picture.Bitmap.SaveToFile(SaveDialog1.FileName + '.bmp');
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  kol := 0;
  Image1.Picture.Graphic := nil;
  init;
  draw;
  Image1.Canvas.Pixels[821,484]:= ClBlue;
  Image1.Canvas.Pixels[822,584]:= ClBlue;
  Image1.Canvas.Pixels[821,585]:= ClBlue;
  Image1.Canvas.Pixels[822,585]:= ClBlue;
  Shape1.Top := 15;
  Shape1.Left := 15;
  StatusBar1.Panels[0].Text := 'Begin..';
  StatusBar1.Panels[2].Text := '0';
  StatusBar1.Panels[6].Text := IntToStr(Shape1.Left)+'x'+
                                       IntToStr(Shape1.Top);
  ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\win.wav'));
  ms.Position := 0;
  PlayWaveStream(ms);
end;

procedure TForm1.J1Click(Sender: TObject);
begin
  Shape1.Left := 810;
  Shape1.Top := 580;
  StatusBar1.Panels[6].Text := IntToStr(Shape1.Left)+'x'+
                                       IntToStr(Shape1.Top);
  Application.ProcessMessages;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ms.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ms := TMemoryStream.Create;
  Color := clBlack;
  best := 2000;

  ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                            'Sounds\win.wav'));
  ms.Position := 0;
  PlayWaveStream(ms);
end;

procedure TForm1.B1Click(Sender: TObject);
begin
  N2.OnClick(sender);
end;

procedure TForm1.M2Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    Color := ColorDialog1.Color;
    N2.OnClick(sender);
  end;
end;

procedure TForm1.S3Click(Sender: TObject);
begin
  Shape1.Left := 15;
  Shape1.Top := 15;
  kol := 0;
  StatusBar1.Panels[6].Text := IntToStr(Shape1.Left)+'x'+
                                       IntToStr(Shape1.Top);
  Application.ProcessMessages;
end;

procedure TForm1.J2Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.A1Click(Sender: TObject);
begin
  Beep;
  MessageDlg('Maze Game' + #13 +
             'Version 1.0' + #13 +
             '2026 - Your Name'+ #13 +
             'github.com',
             mtInformation, [mbOK], 0);
end;

end.
