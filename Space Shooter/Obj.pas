unit Obj;

interface

uses
  Windows, SysUtils, Classes, Graphics, Math, objDrawable,
  objMovable, LaserObj;

type
  // types of ships
  TVaiseauType = (vtRaptor , vtArbitre , vtEnforcer ,vtCuirasse);


  // inherits from Movable ...

  TVaisseau = class(TobjMovable)
  private
    fVaisseauType: TVaiseauType;  // type of vessel
    fLaserType   : TLaserType; // the type of laser used, if it fires
    fNbLaser     : integer ; // number of laser
    fShoot : boolean; // the boolean to indicate whether it shoots
    fAngleDeTir : integer;
    fPower : integer; // life in progress
    fPowerMax : integer; // max life

    fGaugeShoot : integer; // the gauge shoot in progress
    fGaugeShootMax : integer; // the gauge shoot max
    fTempsShoot : integer;
    fTempsShootMax : integer;
    procedure SetGaugeShoot(ARecupGauge : integer);
    procedure SetfNbLaser(ANbLaser : integer);
  protected
    procedure CheckOut;override; // forced to implement it

  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect ; AVaisseauType : TVaiseauType);
    destructor Destroy; override;

    property VaisseauType    : TVaiseauType read fVaisseauType write fVaisseauType;
    property Power           : integer      read fPower        write fPower;
    property PowerMax        : integer      read fPowerMax     write fPowerMax;
    property LaserType       : TLaserType   read fLaserType    write fLaserType;
    property Shoot           : boolean      read fShoot        write fShoot;
    property GaugeShoot      : integer      read fGaugeShoot   write fGaugeShoot;
    property GaugeShootMax   : integer      read fGaugeShootMax write SetGaugeShoot;
    property NombreLaser     : integer      read fNbLaser       write SetfNbLaser;
    property AngleDeTir      : integer      read fAngleDeTir;

    property TempsShoot      : integer      read fTempsShoot    write fTempsShoot;
    property TempsShootMax   : integer      read fTempsShootMax;


    procedure RecupShoot;
    procedure ElargirAngleTir;
  end;

implementation

constructor TVaisseau.Create(ACanvas : TCanvas; AMoveRect : TRect ; AVaisseauType : TVaiseauType);
begin
  inherited Create(ACanvas,AMoveRect);
  // to say that he doesn't shoot
  Shoot:=false;
  
  Direction:= -90;
  Speed:= 0;
  // type of vessel
  fVaisseauType := AVaisseauType;
  //
  fAngleDeTir:=0;
  // Each type has its own specific characteristics.
  case fVaisseauType of

    vtArbitre : begin
      Image.LoadFromFile(AppDir + 'MEDIA\Vaisseau\Arbitre.bmp');
      Width:= 37;
      Height:= 40;
      fPowerMax:=600;
      fGaugeShootMax := 500;
      fTempsShootMax:=3;
    end;

    vtRaptor : begin
      Image.LoadFromFile(AppDir + 'MEDIA\Vaisseau\Raptor.bmp');
      Width:= 48;
      Height:= 49;
      fPowerMax:=700;
      fGaugeShootMax := 600;
      fTempsShootMax:=5;
    end;

    vtEnforcer : begin
      Image.LoadFromFile(AppDir + 'MEDIA\Vaisseau\Enforcer.bmp');
      Width:= 55;
      Height:= 50;
      fPowerMax:=800;
      fGaugeShootMax := 800;
      fTempsShootMax:=8;
    end;

    vtCuirasse : begin
      Image.LoadFromFile(AppDir + 'MEDIA\Vaisseau\Cuirasse.bmp');
      Width:= 75;
      Height:= 71;
      fPowerMax:=1200;
      fGaugeShootMax := 1000;
      fTempsShootMax:=10;
    end;

  end;
  TempsShoot:=fTempsShootMax;
  // Simple laser type by default
  fLaserType := ltFeu;
  // life in progress is put to its maximum at the beginning
  fPower:=PowerMax;
  // same % gauge shoot
  fGaugeShoot:=fGaugeShootMax;
  // 1 laser by default
  fNbLaser := 1;
  // White is the color of transparency
  Image.Transparent:=True;
  Image.TransparentColor:=ClWhite;

end;

destructor TVaisseau.Destroy;
begin
  inherited destroy;
end;

procedure TVaisseau.SetfNbLaser(ANbLaser : integer);
begin
  if(ANbLaser > 3 ) then begin
    fNbLaser := 3;
    exit;
  end;
  fGaugeShootMax := fGaugeShootMax * ANbLaser;
  fNbLaser := ANbLaser;
end;

procedure TVaisseau.SetGaugeShoot(ARecupGauge : integer);
begin
  GaugeShoot:=GaugeShoot+ARecupGauge;
  if(GaugeShoot > GaugeShootMax ) then GaugeShoot:=GaugeShootMax;
end;

procedure TVaisseau.ElargirAngleTir;
begin
  fAngleDeTir := fAngleDeTir+ 1;
  if(fAngleDeTir>25) then fAngleDeTir:=25;
end;

procedure TVaisseau.CheckOut;
begin
  // It was useful to me when I was using the keyboard.
  // Each time progress is called, it goes through this function
  if (Coord.X ) >  MoveRect.Right then Coord := point(0,Coord.Y);
  if (Coord.X ) <  MoveRect.Left then  Coord := point(MoveRect.Right,Coord.Y);
end;

procedure TVaisseau.RecupShoot;
begin
  if(fTempsShoot<=fTempsShootMax) then
    fTempsShoot:=fTempsShoot + 1;

  if(fTempsShoot>= fTempsShootMax) then fTempsShoot := fTempsShootMax;

  if(shoot) then
    if(TempsShoot>=TempsShootMax)then TempsShoot:=0;
  // The gauge rises little by little...
  if(GaugeShoot<= GaugeShootMax) then GaugeShoot := GaugeShoot +1;
end;

end.
