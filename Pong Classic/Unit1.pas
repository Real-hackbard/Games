unit Unit1;

// All the stuff that the editor put in by itself
// Only edit declarations and nothing else till "safe to edit"

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, Menus, ComCtrls, XPMan, MMSystem;

  // Objects
  type
  TForm1 = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    shape3: TShape;
    Timer1: TTimer;
    Timer2: TTimer;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    StatusBar1: TStatusBar;
    S2: TMenuItem;
    S3: TMenuItem;
    N1: TMenuItem;
    F1: TMenuItem;
    P1: TMenuItem;
    T1: TMenuItem;
    N2: TMenuItem;
    T2: TMenuItem;
    N3: TMenuItem;
    P2: TMenuItem;
    S4: TMenuItem;
    N4: TMenuItem;
    L1: TMenuItem;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    N5: TMenuItem;
    F2: TMenuItem;
    Q1: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    B1: TMenuItem;
    S5: TMenuItem;
    N8: TMenuItem;
    B2: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    C1: TMenuItem;
    B3: TMenuItem;
    ColorDialog1: TColorDialog;
    P3: TMenuItem;
    M1: TMenuItem;
    R1: TMenuItem;
    difficulty1: TMenuItem;
    E1: TMenuItem;
    N9: TMenuItem;
    H1: TMenuItem;
    N10: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    Winningnumber1: TMenuItem;
  // Procedures (events)
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure T2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure S4Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N5Click(Sender: TObject);
    procedure F2Click(Sender: TObject);
    procedure Q1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure S5Click(Sender: TObject);
    procedure B2Click(Sender: TObject);
    procedure B3Click(Sender: TObject);
    procedure P3Click(Sender: TObject);
    procedure M1Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure Winningnumber1Click(Sender: TObject);

  private
  // Create variables xspeed, yspeed and score
  xspeed, yspeed : integer;
  scoreHuman : integer;
  ScoreComputer : integer;
  winner : integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PaddleWidth : integer;
  PaddleHeight : integer;
  ms: TMemoryStream;

implementation

{$R *.DFM}
// Play Sound from Memory
procedure PlayWaveStream(Stream: TMemoryStream);
begin
  if Stream = nil then
    sndPlaySound(nil, SND_ASYNC) //stop sound
  else
    sndPlaySound(Stream.Memory, (SND_ASYNC or SND_MEMORY));
end;

// If the sounds should be played directly from the file.
procedure PlaySoundFromMemory(Filename: string);
var
  f: file;
  p: pointer;
  fsize: integer;
begin
  AssignFile(f, Filename);
  Reset(f,1);
  fsize := FileSize(f);
  GetMem(p, fsize);
  BlockRead(f, p^, fsize);
  CloseFile(f);
  sndPlaySound(p,SND_MEMORY or SND_SYNC);
  FreeMem(p, fsize);
end;

{  Ball = shape3
   Player paddle = shape1
   Computer paddle = shape2
   Safe to edit
   Step event one, event for timer one   }
procedure TForm1.Timer1Timer(Sender: TObject);
var
  wav_stream: TMemoryStream;
begin
  {If someone has won show a message and move the ball back to the middle
  reset the yspeed and slow down the xspeed and assigning a score}
  if (Shape3.Left < 0) then
  begin
    ScoreHuman := ScoreHuman + 1;
    shape3.Left := 320 ;

    // Difficulty easy
    if E1.Checked = true then
    begin
      xspeed := 1;
      yspeed := 2;
    end;

    // Difficulty normal
    if N9.Checked = true then
    begin
      xspeed := 2;
      yspeed := 4;
    end;

    // Difficulty hard
    if N9.Checked = true then
    begin
      xspeed := 3;
      yspeed := 5;
    end;

    StatusBar1.Panels[3].Text := IntToStr(ScoreHuman);
    Label2.Caption := IntToStr(ScoreHuman);
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) +
                                'Media\out.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
    exit;
  end;

  if (Shape3.Left > Form1.Width) then
  begin
    ScoreComputer := ScoreComputer + 1;
    shape3.Left := 320;

    // Difficulty easy
    if E1.Checked = true then
    begin
      xspeed := -1;
      yspeed := 2;
    end;

    // Difficulty normal
    if E1.Checked = true then
    begin
      xspeed := -2;
      yspeed := 4;
    end;

    // Difficulty hard
    if E1.Checked = true then
    begin
      xspeed := -3;
      yspeed := 5;
    end;

    StatusBar1.Panels[1].Text := IntToStr(ScoreComputer);
    Label1.Caption := IntToStr(ScoreComputer);
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) +
                                'Media\out.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
    exit;
  end;
    
     // If xspeed and yspeed have not been given a value assign one to them
     if yspeed = 0 then yspeed := 2;
     if xspeed = 0 then xspeed := 5;

     // Move the ball
     shape3.Top := shape3.Top + yspeed;
     shape3.Left := shape3.Left + xspeed;

     { Check for the ball hitting the floor or roof,
       then adapt the course according to the results}
     if F2.Caption <> 'Fullscreen' then
     begin
       if (shape3.Top > Form1.Height-30) or (shape3.Top <= 0) then
       yspeed := -yspeed;
     end else begin
       if (shape3.Top > 560) or (shape3.Top <= 0) then
       yspeed := -yspeed;
     end;

     // Adapt for collisions with your paddle
     if T1.Checked = true then
     begin
       if (shape3.Left < shape1.Left + PaddleWidth)
       and (shape3.Top > shape1.Top) and (shape3.Top < shape1.Top + PaddleHeight)
       then
       begin
        xspeed := 5;
        ms.LoadFromFile(ExtractFilePath(Application.ExeName) +
                                'Media\ping.wav');
        ms.Position := 0;
        PlayWaveStream(ms);
        end;
     end;

     if N2.Checked = true then
     begin
       if (shape3.Left < shape1.Left + PaddleWidth)
       and (shape3.Top > shape1.Top) and (shape3.Top < shape1.Top + PaddleHeight)
       then
       begin
         xspeed := 5;
         ms.LoadFromFile(ExtractFilePath(Application.ExeName) +
                                'Media\ping.wav');
         ms.Position := 0;
         PlayWaveStream(ms);
      end;
     end;

     if T2.Checked = true then
     begin
       if (shape3.Left < shape1.Left + shape1.Width)
       and (shape3.Top > shape1.Top) and (shape3.Top < shape1.Top + PaddleHeight)
       then
       begin
        xspeed := 5;
        ms.LoadFromFile(ExtractFilePath(Application.ExeName) +
                                'Media\ping.wav');
        ms.Position := 0;
        PlayWaveStream(ms);
       end;
     end;


     // Adapt for collisions with the computer's paddle
     if N8.Checked = true then
     begin
       if (Shape3.Left > Shape2.Left - 10)
       and (Shape3.Top > Shape2.Top)
       and (Shape3.Top < Shape2.Top + PaddleHeight) then
       begin
        xspeed := -5;
        ms.LoadFromFile(ExtractFilePath(Application.ExeName) +
                                'Media\pong.wav');
        ms.Position := 0;
        PlayWaveStream(ms);
       end;
     end;

     if N8.Checked = true then
     begin
       if (Shape3.Left > Shape2.Left - 20)
       and (Shape3.Top > Shape2.Top)
       and (Shape3.Top < Shape2.Top + PaddleHeight) then
       begin
        xspeed := -5;
        ms.LoadFromFile(ExtractFilePath(Application.ExeName) +
                                'Media\pong.wav');
        ms.Position := 0;
        PlayWaveStream(ms);
       end;
     end;

     if B2.Checked = true then
     begin
       if (Shape3.Left > Shape2.Left - 59)
       and (Shape3.Top > Shape2.Top)
       and (Shape3.Top < Shape2.Top + PaddleHeight) then
       begin
        xspeed := -5;
        ms.LoadFromFile(ExtractFilePath(Application.ExeName) +
                                'Media\pong.wav');
        ms.Position := 0;
        PlayWaveStream(ms);
       end;
     end;


     // Move the computer paddle to hit the ball
     if (Shape2.Top + 28 > Shape3.Top)

     // Prevent the paddle going off the top of the window
     and (Shape2.Top > 0)
     then Shape2.Top := Shape2.Top - 4;
     if (Shape2.Top + 28 < Shape3.Top)


     // Prevent the paddle going off the bottom off the window
     and (Shape2.Top < Form1.Height) then
      Shape2.Top := Shape2.Top + 4;

     // Check to see if someone has won if someone has set the score to zero
     if scoreComputer = winner then
     begin
       // Human wins
       Beep;
       Timer1.Enabled := false;
       Timer2.Enabled := false;
       ShowMessage('Player has won : ' + IntToStr(ScoreHuman) +
                   ' : ' + IntToStr(ScoreComputer));
       scoreHuman := 0;
       ScoreComputer := 0;
       StatusBar1.Panels[1].Text := '0';
       S1.Enabled := false;
     end;

     if ScoreHuman = winner then
     begin
       // Computer wins
       Beep;
       Timer1.Enabled := false;
       Timer2.Enabled := false;
       ShowMessage('Computer has won : ' + IntToStr(ScoreHuman) +
                   ' : ' + IntToStr(ScoreComputer));
       scoreHuman := 0;
       ScoreComputer := 0;
       StatusBar1.Panels[3].Text := '0';
       S1.Enabled := false;
     end;
end;

// Key press event
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // If Up is pressed move your paddle up
  if (key = 38)
  // Prevent it going above the window
  and (Shape1.Top > 0) then
  begin
    if S3.Checked then shape1.Top := shape1.Top - 10;
    if N1.Checked then shape1.Top := shape1.Top - 20;
    if F1.Checked then shape1.Top := shape1.Top - 40;
  end;

  // If down is pressed move your paddle down
  if (key = 40)
  // Prevent it going off the bottom of the window
  and (shape1.Top < Form1.Height-Shape1.Height) then
  begin
    if S3.Checked then shape1.Top := shape1.Top + 10;
    if N1.Checked then shape1.Top := shape1.Top + 20;
    if F1.Checked then shape1.Top := shape1.Top + 40;
  end;

  if Key = VK_ESCAPE then
    begin
      Application.Terminate;
    end;
end;

// Step event two, event for timer2
procedure TForm1.Timer2Timer(Sender: TObject);
begin
  // Increase the xspeed by 1
  if xspeed < 0 then
    xspeed := xspeed - 1
  else
    xspeed := xspeed + 1;
  // Change the yspeed by 1 in a random direction
  yspeed := yspeed -1;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  // Reserve Memory wav Address
  ms := TMemoryStream.Create;

  winner := 10;
  Shape1.Width := 20;
  Shape2.Width := 20;
  Shape1.Height := 100;
  Shape2.Height := 100;
  PaddleWidth := 20;
  PaddleHeight := 100;
  scoreHuman := 0;
  ScoreComputer := 0;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TForm1.S1Click(Sender: TObject);
begin
  if Timer1.Enabled = true then
  begin
    Timer1.Enabled := false;
    Timer2.Enabled := false;
    S1.Caption := 'Start';
  end else begin
    Timer1.Enabled := true;
    Timer2.Enabled := true;
    S1.Caption := 'Stop';
  end;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  Shape1.Width := 20;
  Shape2.Width := 20;
end;

procedure TForm1.T1Click(Sender: TObject);
begin
  Shape1.Width := 10;
  Shape2.Width := 10;
  PaddleWidth := 10;
end;

procedure TForm1.T2Click(Sender: TObject);
begin
  Shape1.Width := 40;
  Shape2.Width := 40;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
  Shape1.Height := 100;
  Shape2.Height := 100;
  PaddleHeight := 100;
end;

procedure TForm1.S4Click(Sender: TObject);
begin
  Shape1.Height := 50;
  Shape2.Height := 50;
  PaddleHeight := 50;
end;

procedure TForm1.L1Click(Sender: TObject);
begin
  Shape1.Height := 150;
  Shape2.Height := 150;
  PaddleHeight := 150;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ms.Free;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  scoreHuman := 0;
  ScoreComputer := 0;
  StatusBar1.Panels[1].Text := '0';
  StatusBar1.Panels[3].Text := '0';
  Timer1.Enabled := true;
  Timer2.Enabled := true;
  Label1.Caption := '0';
  Label2.Caption := '0';
  S1.Enabled := true;
  S1.Caption := 'Stop';
end;

procedure TForm1.F2Click(Sender: TObject);
var
   r : TRect;
   i : integer;
begin
  if Borderstyle = bsSingle then
  begin
   Borderstyle := bsNone;
   SystemParametersInfo
      (SPI_GETWORKAREA, 0, @r,0);
   SetBounds
     (r.Left, r.Top, r.Right-r.Left, r.Bottom-r.Top);
   F2.Caption := 'Window';
   StatusBar1.Visible := false;
   Label1.Left := (Form1.Width div 2) - 150;
   Label2.Left := (Form1.Width div 2) + 95;

   Label3.Left := (Form1.Width div 2) - 40;
   Label4.Left := (Form1.Width div 2) + 25;

   for i := 4 to 28 do
     begin
        TShape(findcomponent('Shape' +
          inttostr(i))).Left := (Form1.Width div 2) -5;
     end;
  end else begin
    Borderstyle := bsSingle;
    Form1.Height := 640;
    Form1.Width := 800;
    F2.Caption := 'Fullscreen';
    Shape1.Top := 500;
    Shape2.Top := 500;
    Shape3.Top := 500;
    Label1.Left := 280;
    Label2.Left := 450;
    Label3.Left := 365;
    Label4.Left := 416;
    StatusBar1.Visible := true;
    Form1.WindowState := wsNormal;
    for i := 4 to 28 do
     begin
        TShape(findcomponent('Shape' +
          inttostr(i))).Left := (Form1.Width div 2) -5;
     end;
  end;
   Application.ProcessMessages;
end;

procedure TForm1.Q1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.N8Click(Sender: TObject);
begin
  Shape3.Width := 25;
  Shape3.Height := 25;
end;

procedure TForm1.S5Click(Sender: TObject);
begin
  Shape3.Width := 10;
  Shape3.Height := 10;
end;

procedure TForm1.B2Click(Sender: TObject);
begin
  Shape3.Width := 50;
  Shape3.Height := 50;
end;

procedure TForm1.B3Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Form1.Color := ColorDialog1.Color;
end;

procedure TForm1.P3Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    Shape1.Brush.Color := ColorDialog1.Color;
    Shape2.Brush.Color := ColorDialog1.Color;
  end;
end;

procedure TForm1.M1Click(Sender: TObject);
var
  i : integer;
begin
  if M1.Checked = true then
  begin
    for i := 4 to 28 do
       begin
          TShape(findcomponent('Shape' +
            inttostr(i))).Visible := true;
       end;
  end else begin
    for i := 4 to 28 do
       begin
          TShape(findcomponent('Shape' +
            inttostr(i))).Visible := false;
       end;
  end;
end;

procedure TForm1.R1Click(Sender: TObject);
begin
  if R1.Checked = true then
  begin
    Label1.Visible := true;
    Label2.Visible := true;
    Label3.Visible := true;
    Label4.Visible := true;
  end else begin
    Label1.Visible := false;
    Label2.Visible := false;
    Label3.Visible := false;
    Label4.Visible := false;
  end;
end;

procedure TForm1.Winningnumber1Click(Sender: TObject);
var
  Input: string;
  Val: Integer;
begin
  Input := InputBox('Input', 'Enter the winnings amount:', '10');

  if TryStrToInt(Input, Val) then
  begin
    winner := val;
    Label3.Caption := IntToStr(val);
    Label4.Caption := IntToStr(val);
  end else begin
    ShowMessage('Not a valid number!');
  end;
end;

end.
