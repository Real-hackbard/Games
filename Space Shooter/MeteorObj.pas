unit MeteorObj;

interface

uses Windows, SysUtils, Classes, Graphics, objMovable, Math;

type
  // types of meteorite
  TMeteoriteType = (mtBig,mtMedium,mtTiny);

  TMeteorite = class(TobjMovable)
  private
    fMeteorType: TMeteoriteType;
    fPower     : integer;
  protected
    procedure CheckOut;override;
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect ; AMeteorType : TMeteoriteType);
    destructor Destroy; override;

    property MeteoriteType    : TMeteoriteType read fMeteorType write fMeteorType;
    property Power            : integer        read fPower      write fPower;
  end;

implementation

constructor TMeteorite.Create(ACanvas : TCanvas; AMoveRect : TRect ; AMeteorType : TMeteoriteType);
begin
  inherited Create(ACanvas,AMoveRect);
  // that doesn't arrive right away from the MoveRect
  Coord := point(Random(MoveRect.Right),MoveRect.Top-200);
  fMeteorType := AMeteorType;
  // we test the type of meteorite
  // Each type has its own specific characteristic.
  // We use a random element so it doesn't get too repetitive.

  case fMeteorType of

    mtBig : begin
      Width := 119;
      Height := 76;
      Image.LoadFromFile(AppDir + 'MEDIA\Meteorite\MeteoriteBig.bmp');
      Direction:=RandomRange(45,135);
      Speed:=RandomRange(1,4);
      fPower := 300;
    end;

    mtMedium : begin
      Width := 74;
      Height := 58;
      Image.LoadFromFile(AppDir + 'MEDIA\Meteorite\MeteoriteMedium.bmp');
      Direction:=RandomRange(75,110);
      Speed:=RandomRange(6,9);
      fPower := 150;
    end;

    mtTiny : begin
      Width := 41;
      Height := 44;
      Image.LoadFromFile(AppDir + 'MEDIA\Meteorite\MeteoriteTiny.bmp');
      Direction:=RandomRange(80,100);
      Speed:=RandomRange(9,12);
      fPower := 100;
    end;
  end;

  Image.Transparent:=True;
  Image.TransparentColor:=ClLime;
end;

destructor TMeteorite.Destroy;
begin
  inherited destroy;
end;

procedure TMeteorite.CheckOut;
begin
  if (Coord.X) >  MoveRect.Right then ToDeleted := True;
  if (Coord.X) <   MoveRect.Left then  ToDeleted := True;
  if (Coord.Y) > MoveRect.Bottom then ToDeleted:=true;
  if (Coord.Y) < MoveRect.Top - 200 then ToDeleted:=true;
end;

end.
 