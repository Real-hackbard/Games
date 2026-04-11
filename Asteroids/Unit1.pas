unit Unit1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, IniFiles, MPlayer;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    SndPlayer: TMediaPlayer;
    Panel1: TPanel;
    btnPause: TButton;
    Panel3: TPanel;
    clsButton: TButton;
    btnReplay: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure clsButtonClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnReplayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure BeginGame;
    procedure PlaySound(nSound: Integer);
    procedure UpdateCaption;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

type

TVertex = object
  x: Real;
  y: Real;
end;

TGraphObject = class
  nVerts   : Integer;
  Color    : TColor;
  nW       : Integer;
  nH       : Integer;
  xo       : Real;
  yo       : Real;
  Angle    : Real;
  xVeloc   : Real;
  yVeloc   : Real;
  cs       : Real;
  sn       : Real;
  Canvas   : TCanvas;
  rcBound  : TRect;
  Vertices : Array[0..14] of TVertex;

  constructor Create(Canv: TCanvas; Width, Height: Integer); dynamic;
  procedure   Free; dynamic;
  function    Collide(tgO: TGraphObject): Boolean;
  procedure   Draw(Erase: Boolean);
  procedure   MoveIt;
  procedure   Rotate;
  procedure   SetColor(Clr: TColor);
  procedure   SetPos(xPos, yPos: Real);
  procedure   SetRotate(NewAngle: Real);
  procedure   SetScale(Scale: Real);
  procedure   SetVertices(Verts: Array of TVertex);
  procedure   SetVelocity(xV, yV: Real);
  procedure   Translate;
end;

TDirectional = class(TGraphObject)
  nSpeed    : Integer;
  nMaxSpeed : Integer;
  nFacing   : Integer;
  csFace    : Real;
  snFace    : Real;

  constructor Create(Canv: TCanvas; Width, Height, MaxSpeed: Integer); dynamic;
  procedure   DecSpeed;
  procedure   IncSpeed;
  procedure   MoveIt; dynamic;
  procedure   Reset; dynamic;
  procedure   SetFacing(F: Integer);
  procedure   SetSpeed(S: Integer);
  procedure   UpdateVelocity;
  procedure   UpdateFacing(F: Integer);
end;

TAsteroid = class(TGraphObject)
  bDestroyed : Boolean;

  constructor Create(Canv: TCanvas; Width: Integer; Height: Integer);override;
  procedure   Destroy;
  procedure   MoveIt;
  procedure   Reset;
end;

TMissle = class(TDirectional)
  nAlive : Integer;

  constructor Create(Canv: TCanvas; Width, Height, MaxSpeed: Integer);override;
  procedure   MoveIt;
  procedure   DestoryAsters;
  procedure   SetAlive(nA: Integer);
end;

TShip = class(TDirectional)
  bRotate: Boolean;
  Missle : Array [0..3] of TMissle;

  constructor Create(Canv: TCanvas; Width, Height, MaxSpeed: Integer);override;
  procedure   Free; override;
  procedure   BlowUp;
  procedure   MoveIt;
  procedure   RotateLeft;
  procedure   RotateRight;
  procedure   Shoot;
  procedure   Reset;
end;

const
  NumMissles = 3;
  NumColors  = 13;
  MaxAsters  = 24;
  Margins    = 40;
  SndFire    = 1;
  SndHit     = 2;
  SndExplode = 3;
  SndWin     = 4;

var
  Asteroids  : Array[0..MaxAsters-1] of TAsteroid;
  Colors     : Array[0..NumColors-1] of TColor;
  Ship       : TShip;
  TimesDrawn : LongInt;
  StartTicks : LongInt;
  nScore     : Integer;
  FaceMod    : Real;
  NumDegrees : Integer;
  North      : Integer;
  NumAsters  : Integer;

function Vertex(xA, yA: Real): TVertex;
begin
  Result.x := xA;
  Result.y := yA;
end;

constructor TGraphObject.Create(Canv: TCanvas; Width, Height: Integer);
begin
  inherited Create;

  Canvas  := Canv;
  nW      := Width;
  nH      := Height;
  xo      := 0;
  yo      := 0;
  Color   := clBlack;
  cs      := 0;
  sn      := 0;
  Angle   := 0;
  nVerts  := 0;
  xVeloc  := 0;
  yVeloc  := 0;
end;

procedure TGraphObject.Free;
begin
  Draw(TRUE);
  inherited Free;
end;

function TGraphObject.Collide(tgO: TGraphObject): Boolean;
var
  rcBox  : TRect;
  rcCurOb: TRect;
  rcInObj: TRect;
begin

  Result  := False;
  rcCurOb := Rect(rcBound.Top    + TRUNC(xo),
                  rcBound.Left   + Trunc(yo),
                  rcBound.Bottom + TRUNC(xo),
                  rcBound.Right  + Trunc(yo));

  rcInObj := Rect(tgo.rcBound.Top    + TRUNC(tgo.xo),
                  tgo.rcBound.Left   + Trunc(tgo.yo),
                  tgo.rcBound.Bottom + TRUNC(tgo.xo),
                  tgo.rcBound.Right  + Trunc(tgo.yo));

  if IntersectRect(rcBox, rcCurOb, rcInObj) then
    Result := TRUE;
end;

procedure TGraphObject.Draw(Erase: Boolean);
var
  nV: Integer;
begin
  with Canvas do
  begin
    if Erase = True then
      Pen.Color := Form1.Color
    else
      Pen.Color := Color;

    MoveTo(Trunc(xo + Vertices[0].x) ,Trunc(yo + Vertices[0].y));
    for nV := 1 to nVerts do
      LineTo(Trunc(xo + Vertices[nV].x), Trunc(yo + Vertices[nV].y));

    LineTo(Trunc(xo + Vertices[0].x), Trunc(yo + Vertices[0].y));
  end;
end;

procedure TGraphObject.MoveIt;
begin
  Draw(TRUE);
  Rotate;
  Translate;
  Draw(FALSE);
end;

procedure TGraphObject.Rotate;
var
  nCntr: Integer;
  xNew : Real;
  yNew : Real;
begin

  for nCntr := 0 to nVerts do
  begin
    xNew := Vertices[nCntr].x * cs - Vertices[nCntr].y * sn;
    yNew := Vertices[nCntr].y * cs + Vertices[nCntr].x * sn;

    Vertices[nCntr].x := xNew;
    Vertices[nCntr].y := yNew;
  end;
end;

procedure TGraphObject.SetColor(Clr: TColor);
begin
  Color := Clr;
end;

procedure TGraphObject.SetPos(xPos, yPos: Real);
begin
  xo := xPos;
  yo := yPos;
end;

procedure TGraphObject.SetRotate(NewAngle: Real);
begin
  Angle := NewAngle;
  cs    := cos(Angle);
  sn    := sin(Angle);
end;

procedure TGraphObject.SetScale(Scale: Real);
var
  nCntr: Integer;
begin
  rcBound := Rect(999, 999, -999, -999);

  for nCntr := 0 to nVerts do
  begin
    Vertices[nCntr].x := Vertices[nCntr].x * Scale;
    Vertices[nCntr].y := Vertices[nCntr].y * Scale;

    if (Vertices[nCntr].x < rcBound.Top) then
      rcBound.Top := Trunc(Vertices[nCntr].x);

    if (Vertices[nCntr].x > rcBound.Bottom) then
      rcBound.Bottom := Trunc(Vertices[nCntr].x);

    if (Vertices[nCntr].y < rcBound.Left) then
      rcBound.Left := Trunc(Vertices[nCntr].y);

    if (Vertices[nCntr].y > rcBound.Right) then
      rcBound.Right := Trunc(Vertices[nCntr].y);
  end;
end;

procedure TGraphObject.SetVertices(Verts: Array of TVertex);
var
  nCntr : Integer;
begin
  if (nVerts > 14) then
    nVerts := 14
  else
    nVerts := High(Verts);

  for nCntr := 0 to nVerts do
    Vertices[nCntr] := Verts[nCntr];
end;

procedure TGraphObject.SetVelocity(xV, yV: Real);
begin
  xVeloc := xV;
  yVeloc := yV;
end;

procedure TGraphObject.Translate;
begin
  xo := xo + xVeloc;
  yo := yo + yVeloc;

  if (xo > nW) then
    xo := Margins
  else if (xo < Margins) then
    xo := nW;

  if (yo > nH) then
    yo := Margins
  else if (yo < Margins) then
    yo := nH;
end;

constructor TDirectional.Create(Canv:TCanvas; Width, Height, MaxSpeed:Integer);
begin
  inherited Create(Canv, Width, Height);
  nMaxSpeed := MaxSpeed;
  Reset;
end;

procedure TDirectional.DecSpeed;
begin
  if (nSpeed > 0) then
  begin
    Dec(nSpeed);
    UpdateVelocity;
  end;
end;

procedure TDirectional.IncSpeed;
begin
  if (nSpeed < nMaxSpeed) then
  begin
    Inc(nSpeed);
    UpdateVelocity;
  end;
end;

procedure TDirectional.MoveIt;
begin
  Draw(TRUE);
  Translate;
  Draw(FALSE);
end;

procedure TDirectional.Reset;
begin
  nSpeed := 0;
  SetFacing(North);
  end;

procedure TDirectional.SetFacing(F: Integer);
begin
  nFacing := 0;
  UpdateFacing(F);
end;

procedure TDirectional.SetSpeed(S: Integer);
begin
  if (nSpeed < 0) then
    nSpeed := 0
  else if (nSpeed < nMaxSpeed) then
    nSpeed := S
  else
    nSpeed := S;
  UpdateVelocity;
end;

procedure TDirectional.UpdateFacing(F: Integer);
var
  FM: Real;
begin
  Inc(nFacing, F);
  if (nFacing > NumDegrees) then
    nFacing := 0;
  if (nFacing < 0) then
    nFacing := NumDegrees;

  FM     := FaceMod * nFacing;
  csFace := cos(FM);
  snFace := sin(FM);
  UpdateVelocity;
end;

procedure TDirectional.UpdateVelocity;
begin
  SetVelocity(csFace * nSpeed, snFace * nSpeed);
end;

constructor TAsteroid.Create(Canv: TCanvas; Width: Integer; Height: Integer);
begin
  inherited Create(Canv, Width, Height);
  Reset;
end;

procedure TAsteroid.Destroy;
begin
  bDestroyed := TRUE;
  Form1.PlaySound(sndHit);
  Inc(nScore, 100);
  Form1.UpdateCaption;
  Draw(TRUE);
end;

procedure TAsteroid.MoveIt;
begin
  if bDestroyed = False then
    inherited MoveIt;
end;

procedure TAsteroid.Reset;
begin
  SetVertices([Vertex(4.0  + Random(2),  3.5 + Random(2)),
               Vertex(8.5  + Random(2), -3.0 + Random(2)),
               Vertex(6    + Random(2), -5   + Random(2)),
               Vertex(2    + Random(2), -3   + Random(2)),
               Vertex(-4   + Random(2), -6   + Random(2)),
               Vertex(-3.5 + Random(2),  5.5 + Random(2))]);

  SetPos(Margins + Random(nW), Margins + Random(nH));
  SetColor(Colors[Random(NumColors)]);
  SetVelocity(-10 + Random(20), -10 + Random(20));
  SetRotate((-50 + Random(100)) / 100);
  SetScale(Random(4) + 2);
  bDestroyed := False;
  Draw(False);
end;

constructor TMissle.Create(Canv:TCanvas; Width, Height, MaxSpeed: Integer);
begin
  inherited Create(Canv, Width, Height, MaxSpeed);
  SetVertices([Vertex(1.5,   0.5),  Vertex(0.5,   1.5),
               Vertex(-0.5,  1.5),  Vertex(-1.5,  0.5),
               Vertex(-1.5, -0.5),  Vertex(-0.5, -1.5),
               Vertex(0.5,  -1.5),  Vertex(1.5,  -0.5)]);
  SetColor(clWhite);
  SetScale(1);
  SetSpeed(0);
  nAlive := 0;
end;

procedure TMissle.DestoryAsters;
var
  nCntr : Integer;
begin
  for nCntr := 0 to NumAsters do
  begin
    if ((Asteroids[nCntr].bDestroyed = False) and
        (Collide(Asteroids[nCntr]) = TRUE)) then
    begin
      Asteroids[nCntr].Destroy;
      nAlive := 0;
      Form1.UpdateCaption;
      break;
    end;
  end;
end;

procedure TMissle.MoveIt;
begin
  if (nAlive > 0) then
  begin
    Dec(nAlive);
    inherited MoveIt;
    DestoryAsters;
    if (nAlive = 0) then
    Draw(TRUE);
  end;
end;

procedure TMissle.SetAlive(nA: Integer);
begin
  nAlive := nA;
end;

constructor TShip.Create(Canv:TCanvas; Width, Height, MaxSpeed: Integer);
var
  nCntr : Integer;
begin
  inherited Create(Canv, Width, Height, MaxSpeed);
  for nCntr := 0 to NumMissles do
    Missle[nCntr] := TMissle.Create(Canv, Width, Height, 30);
  Reset;
end;

procedure TShip.Free;
var
  nCntr : Integer;
begin
  for nCntr := 0 to NumMissles do
    Missle[nCntr].Free;
  inherited Free;
end;

procedure TShip.BlowUp;
var
  nCntr: Integer;
  nxo  : Integer;
  nyo  : Integer;
  nxr  : Integer;
  nyr  : Integer;
begin
  Form1.Timer1.Enabled := False;
  Form1.Panel1.Caption := 'You have been Hit';
  Form1.PlaySound(sndExplode);

  nxr := rcBound.Bottom - rcBound.Top  + Trunc(Margins / 2);
  nyr := rcBound.Right  - rcBound.Left + Trunc(Margins / 2);
  nxo := Trunc(xo - nxr / 2);
  nyo := Trunc(yo - nyr / 2);

  for nCntr := 0 To 2500 do
    Canvas.Pixels[nxo + Random(nxr),nyo + Random(nyr)] :=
        Colors[Random(NumColors)];
end;

procedure TShip.MoveIt;
var
  nCntr : Integer;
begin
  Draw(TRUE);
  if bRotate = TRUE then
  begin
    Rotate;
    bRotate := FALSE;
  end;
  Translate;
  Draw(FALSE);
  for nCntr := 0 to NumMissles do
    Missle[nCntr].MoveIt;
end;

procedure TShip.RotateRight;
begin
  SetRotate(FaceMod);
  UpdateFacing(1);
  bRotate := TRUE;
end;

procedure TShip.Reset;
var
  nCntr: Integer;
begin
  inherited Reset;
  SetVertices([Vertex(3,-19),   Vertex(12, -1),
               Vertex(17, 2),   Vertex(17, 9),
               Vertex(8, 14),   Vertex(5, 8),
               Vertex(-5, 8),   Vertex(-8, 14),
               Vertex(-17, 9),  Vertex(-17, 2),
               Vertex(-12, -1), Vertex(-3, -19),
               Vertex(-3, -8),  Vertex(3, -8)]);
  SetPos(nW DIV 2, nH DIV 2);
  SetColor(clYellow);
  SetScale(1);
  for nCntr := 0 to NumMissles do
    Missle[nCntr].SetAlive(0);
  Draw(False);
end;

procedure TShip.RotateLeft;
begin
  SetRotate(-FaceMod);
  UpdateFacing(-1);
  bRotate := TRUE;
end;

procedure TShip.Shoot;
var
  nCntr: Integer;
begin
  for nCntr := 0 to NumMissles do
  begin
    if (Missle[nCntr].nAlive = 0) then
    begin
      Form1.PlaySound(sndFire);
      Missle[nCntr].SetPos(xo, yo);
      Missle[nCntr].SetFacing(nFacing);
      Missle[nCntr].SetSpeed(Missle[nCntr].nMaxSpeed);
      Missle[nCntr].SetAlive(Random(10) + 10);
    end;
  end;
end;

procedure TForm1.BeginGame;
var
  nCntr: Integer;
begin
  Canvas.Pen.Color := clBlack;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
  nScore         := 0;
  for nCntr  := 0 to NumAsters do
    Asteroids[nCntr].Reset;
  Ship.Reset;
  UpdateCaption;
  Panel1.Caption := 'Use Arrow Keys to move and Space bar to Fire';
  Timer1.Enabled := TRUE;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 nCntr      : Integer;
 NumDraws   : LongInt;
 NumLast    : LongInt;
 iniFile    : TIniFile;
 strSec     : String;
 strDrawSec : String;
 nTurnDeg   : Integer;
 w          : WORD;
 IniPath    : String;

begin
  DoubleBuffered := true;
  nTurnDeg   := 20;
  FaceMod    := nTurnDeg * PI / 180;
  NumDegrees := Trunc(360 / nTurnDeg) - 1;
  North      := Trunc((NumDegrees + 1) * 0.75);

  Randomize;
  Colors[0]  := clAqua;
  Colors[1]  := clBlue;
  Colors[2]  := clFuchsia;
  Colors[3]  := clGreen;
  Colors[4]  := clLime;
  Colors[5]  := clGray;
  Colors[6]  := clOlive;
  Colors[7]  := clPurple;
  Colors[8]  := clRed;
  Colors[9]  := clSilver;
  Colors[10] := clTeal;
  Colors[11] := clWhite;
  Colors[12] := clYellow;
  TimesDrawn := 0;
  Left       := 0;
  Top        := 0;
  Color      := ClBlack;
  Width      := GetSystemMetrics(SM_CXSCREEN);
  Height     := GetSystemMetrics(SM_CYSCREEN);
  IniPath    := ExtractFilePath(Application.ExeName) + 'asteroid.ini';
  iniFile    := TiniFile.Create(IniPath);
  NumAsters  := iniFile.ReadInteger('Settings', 'Asteroids', 10);
  NumDraws   := iniFile.ReadInteger('Timing', 'Draws',     0);
  strSec     := iniFile.ReadString('Timing',  'Seconds',  '0.00');
  strDrawSec := iniFile.ReadString('Timing',  'Draws_Sec','0.00' );
  iniFile.Free;
  Dec(NumAsters);

  if (NumAsters > MaxAsters) then
    NumAsters := MaxAsters;

  for nCntr  := 0 to NumAsters do
    Asteroids[nCntr] := TAsteroid.Create(Canvas,
                        ClientWidth - Margins * 2, ClientHeight - Margins * 2);

  Ship := TShip.Create(Canvas,ClientWidth - Margins * 2,
                       ClientHeight - Margins * 2, 20);

  SndPlayer.FileName := 'AsterSnd.wav';
  SndPlayer.Open;
  StartTicks := GetTickCount;
  BeginGame;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
 nCntr : Integer;
 nAlive: Integer;
begin
  for nCntr := 0 to NumAsters do
  begin
    Asteroids[nCntr].MoveIt;
    TimesDrawn := TimesDrawn + 1;
  end;
  Ship.MoveIt;
  TimesDrawn := TimesDrawn + 1;

  nAlive := 0;
  for nCntr := 0 to NumAsters do
  begin
    if (Asteroids[nCntr].bDestroyed = False) then
    begin
      Inc(nAlive);
      if (Ship.Collide(Asteroids[nCntr]) = TRUE) then
        Ship.BlowUp;
    end;
  end;

  if (nAlive = 0) then
  begin
    Timer1.Enabled := False;
    Form1.Panel1.Caption := 'You Have Won';
    Form1.PlaySound(sndWin);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  iniFile  : TIniFile;
  iniPath  : String;
  Seconds  : Real;
  DrawsSec : Real;
  strVal   : String;
  nCntr    : Integer;
begin
  Seconds  := (GetTickCount - StartTicks) / 1000;
  DrawsSec := TimesDrawn / Seconds;

  SndPlayer.Close;
  Ship.Free;
  for nCntr := 0 to NumAsters do
    Asteroids[nCntr].Free;

  IniPath := ExtractFilePath(Application.ExeName) + 'asteroid.ini';
  iniFile := TiniFile.Create(IniPath);
  iniFile.WriteInteger('Settings', 'Asteroids', NumAsters + 1);
  iniFile.WriteInteger('Timing', 'Draws',     TimesDrawn);
  FmtStr(strVal, '%4.4f', [Seconds]);
  iniFile.WriteString('Timing', 'Seconds',   strVal);
  FmtStr(strVal, '%4.4f', [DrawsSec]);
  iniFile.WriteString('Timing', 'Draws_Sec',   strVal);
  iniFile.Free;
  Action := caFree;
end;

procedure TForm1.clsButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btnPauseClick(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_UP:
      begin
      Ship.IncSpeed;
      Key := 0;
      end;

    VK_DOWN:
      begin
      Ship.DecSpeed;
      Key := 0;
      end;

    VK_LEFT:
      begin
      Ship.RotateLeft;
      Key := 0;
      end;

    VK_RIGHT:
      begin
      Ship.RotateRight;
      Key := 0;
      end;

    VK_SPACE:
      begin
      Ship.Shoot;
      Key := 0;
      end;
  end;
end;

procedure TForm1.btnReplayClick(Sender: TObject);
begin
  BeginGame;
end;

procedure TForm1.PlaySound(nSound: Integer);
begin
  case nSound of
    SndFire:
    begin
      SndPlayer.StartPos := 0;
      SndPlayer.EndPos   := 510;
    end;

    SndHit:
    begin
      SndPlayer.StartPos := 511;
      SndPlayer.EndPos   := 1130;
    end;

    SndExplode:
    begin
      SndPlayer.StartPos := 1140;
      SndPlayer.EndPos   := 2580;
    end;

    SndWin:
    begin
      SndPlayer.StartPos := 2581;
      SndPlayer.EndPos   := 4650;
    end;
  end;

  SndPlayer.Play;
end;

procedure TForm1.UpdateCaption;
var
  nCntr : Integer;
  nAlive: Integer;
begin

  nAlive := 0;
  for nCntr := 0 to NumAsters do
  begin
    if (Asteroids[nCntr].bDestroyed = False) then
      Inc(nAlive);
  end;

  Panel1.Caption := Format('Asteroids: %d    Number Left: %d',
                            [NumAsters + 1, nAlive]);
  Panel3.Caption := 'Score: ' + IntToStr(nScore);
end;
end.
