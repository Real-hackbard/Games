unit EnnemiObj;

interface

uses
  Windows, SysUtils, Classes, Graphics, Math, objDrawable,
  objMovable, LaserObj, Obj;

type
  TVaisseauEnnemiType = (veEnforcer);

  TVaisseauEnnemi = class (TObjMovable)
  private
    fPower     : integer;
    fLaserType : TLaserType;
    fVaisseauType : TVaisseauEnnemiType;
    fLaser        : TLaser;
    fCible        : TVaisseau;
    fPas          : integer;
  protected
    procedure CheckOut;override; // forced to implement it
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect ; AVaisseauType : TVaisseauEnnemiType);
    destructor Destroy; override;

    property VaisseauType : TVaisseauEnnemiType   read fVaisseauType;

    property Power        : integer               read fPower   write fPower;
    property Laser        : TLaser                read fLaser;
    procedure Progress ;
    procedure Draw;
end;

implementation

constructor TVaisseauEnnemi.Create(ACanvas : TCanvas; AMoveRect : TRect ; AVaisseauType : TVaisseauEnnemiType);
begin
  inherited Create(ACanvas,AMoveRect);
  fCible := nil;
  fVaisseauType := AVaisseauType;
  Direction := 90;
  Coord := Point(Random(MoveRect.Right),10);
  case fVaisseauType of
    veEnforcer : begin
      fPower := 800;
      Speed:=5;
      Image.LoadFromFile(AppDir + 'MEDIA\Vaisseau\Enforcer.bmp');
      Width :=55;
      Height := 50;
      fLaserType := ltTripleB;
      fPas := 100;
    end;
  end;
  fLaser:= TLaser.Create(Canvas,MoveRect,Coord,90,fLaserType);
  Image.TransparentColor:=ClWhite;
  Image.Transparent:=True;
end;

destructor TVaisseauEnnemi.Destroy;
begin
  fLaser.Free;
  inherited Destroy;
end;

procedure TVaisseauEnnemi.CheckOut;
var
  c : Tpoint;
begin
  c := Coord;
  c.X := c.X + Width div 2;
  c.Y := c.Y + Height;
  if(Coord.Y > MoveRect.Bottom) then ToDeleted := True;
  if((Coord.Y mod fPas = 0) and (fLaser.ToDeleted)  ) then
    fLaser:= TLaser.Create(Canvas,MoveRect,c,90,fLaserType);
end;

procedure TVaisseauEnnemi.Progress;
begin
  if not( fLaser.ToDeleted) then fLaser.Progress;
  inherited Progress;
end;

procedure TVaisseauEnnemi.Draw;
begin
  if not( fLaser.ToDeleted)then fLaser.Draw;
  inherited Draw;
end;

end.
