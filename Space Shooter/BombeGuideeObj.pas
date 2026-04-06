unit BombeGuideeObj;

interface

uses Windows, SysUtils, Classes, Graphics, objMovable,Math;

type

  TBombeGType = (bgTiny,bgBig);

  TBombeG = class(TObjMovable)
  private
    fBombeGType: TBombeGType;
    fPower     : integer;
    fNbCycle   : integer;
    fMaxNbCycle: integer;
    fCible     : TPoint;
    fTime      : integer;
    fTimeMax   : integer;
    fADest     : boolean;
    CibleOK    : boolean;
    fMinVitesse: integer;
    procedure SetCible(C : TPoint);
  protected
    procedure CheckOut;override;
    procedure Move;override;
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect ; ABombeGType : TBombeGType);
    destructor Destroy; override;

    property BombeGType       : TBombeGType    read fBombeGType write fBombeGType;
    property Power            : integer        read fPower      write fPower;
    property Cible            : TPoint         read fCible      write SetCible;
  end;

implementation


constructor TBombeG.Create(ACanvas : TCanvas; AMoveRect : TRect ; ABombeGType : TBombeGType);
var
  i : integer;
begin
  inherited Create(ACanvas,AMoveRect);
  fBombeGType := ABombeGType;

  i := Random(20);
  // appear on the left, right...
  if (i<10) then
    Coord := Point(MoveRect.Left,Random(MoveRect.Bottom))
  else
    Coord := Point(MoveRect.Right,Random(MoveRect.Bottom));

  CibleOK := True;
  fADest := false;
  fCible := Cible;

  fTime:=0;

  case fBombeGType of
    bgTiny : begin
      Width := 17;
      Height := 15;
      Image.LoadFromFile(AppDir+'MEDIA\BombeG\bombeGuideT.bmp');
      Power := 100;
      fTimeMax := 25;
      fMaxNbCycle:=3;
      fMinVitesse:=5;
    end;

    bgBig : begin
      Width := 28;
      Height := 28;
      Image.LoadFromFile(AppDir+'MEDIA\BombeG\bombeGuideB.bmp');
      fTimeMax := 12;
      Power := 200;
      fMinVitesse:=10;
      fMaxNbCycle:=1;
    end;

  end;
  Image.TransparentColor:=rgb(255,0,0);
  Image.Transparent:=True;
  fNbCycle:=0;
end;

destructor TBombeG.Destroy;
begin
  inherited destroy;
end;

procedure TBombeG.SetCible(C : TPoint);
begin
  if(CibleOK) then fCible := C;
end;

procedure TBombeG.Move;
var
  x,y,vx,vy:integer;
begin
  x := Coord.X;
  y := Coord.Y;

  Vx := (Abs(Coord.X - fCible.X) div 100) * (Abs(Coord.X - fCible.X) div 100);
  Vy := (Abs(Coord.Y - fCible.Y) div 100) * (Abs(Coord.Y - fCible.Y) div 100);

  if(Vx< 5 ) then Vx := fMinVitesse;
  if(Vy< 5 ) then Vy := fMinVitesse;

  if (Abs(Coord.X - fCible.X)<5) then Vx := 1;
  if (Abs(Coord.Y - fCible.Y)<5) then Vy := 1;

  if(Coord.X < fCible.X) then x:=x+Vx;
  if(Coord.Y < fCible.Y) then y:=y+Vy;

  if(Coord.X > fCible.X) then x:=x-Vx;
  if(Coord.Y > fCible.Y) then y:=y-Vy;
  
  Coord :=point(x,y);
end;

procedure TBombeG.CheckOut;
var
  posY : integer;
begin
  posY := Coord.Y;

  if (Coord.X) >  MoveRect.Right then begin
    posY := PosY + 100;
    Coord := Point(0,PosY);
  end;

  if (Coord.X) <  MoveRect.Left  then begin
    posY := PosY - 100;
    Coord := Point(MoveRect.Right,PosY);
  end;

  if (Coord.Y) > MoveRect.Bottom then ToDeleted:=true;
  if (Coord.Y) < MoveRect.Top - 200 then ToDeleted:=true;

  if(fNbCycle > fMaxNbCycle ) then ToDeleted:=True;

  fTime:=fTime+1;
  CibleOK := False;

  if( (fADest) and (fTime>fTimeMax)) then begin
    fADest := false;
    CibleOK := True;
    fNbCycle := fNbCycle + 1;
  end;

  if( ((Coord.X = fCible.X) and (Coord.Y = fCible.Y)) and fADest=false  ) then begin
    fADest:=True;
    fTime:=0;
  end;

end;

end.

