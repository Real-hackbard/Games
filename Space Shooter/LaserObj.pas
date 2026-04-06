unit LaserObj;

interface

uses Windows, SysUtils, Classes, Graphics, Math,objMovable,Fmod,fmodtypes;

type
  // laser types
  TLaserType = (ltFeu , ltEnergy , ltTripleB);

  TLaser = class(TobjMovable)
  private
    fLaserType: TLaserType;
    fSoundLaser : PFSoundSample;
    // the damage it inflicts
    fDegat : integer;
    // the amount of energy required to use it
    fUGauge : integer;
  protected
    procedure CheckOut;override;
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect ; ACoord : TPoint; ADirection : single ;ALaserType : TLaserType);
    destructor Destroy; override;

    property LaserType    : TLaserType read fLaserType write fLaserType;
    property Degat        : integer    read fDegat     write fDegat;
    property UGauge       : integer    read fUGauge    write fUGauge;
  end;

implementation

constructor TLaser.Create(ACanvas : TCanvas; AMoveRect : TRect ; ACoord : TPoint;ADirection : single ;ALaserType : TLaserType);
begin

  inherited Create(ACanvas,AMoveRect);

  Coord := ACoord;
  Direction:= ADirection;
  fLaserType := ALaserType;
  ToDeleted := false;
  // each type of laser...
  // Same as meteorite, spaceship, and explosion...
  case fLaserType of

    ltFeu : begin
      Width := 8;
      Height := 16;
      Image.LoadFromFile(AppDir + 'MEDIA\Laser\Feu.bmp');
      fSoundLaser := FSOUND_Sample_Load(FSOUND_FREE,PChar(AppDir + 'MEDIA\Laser\Feu.wav'), 0, 0, 0);
      Speed:=15;
      fDegat := 25;
      fUGauge :=10;
    end;
    ltEnergy : begin
      Width := 8;
      Height := 18;
      Image.LoadFromFile(AppDir + 'MEDIA\Laser\Energy.bmp');
      fSoundLaser := FSOUND_Sample_Load(FSOUND_FREE,PChar(AppDir + 'MEDIA\Laser\Energy.wav'), 0, 0, 0);
      Speed:=20;
      fDegat := 50;
      fUGauge := 10;
    end;
    ltTripleB : begin
      Width := 17;
      Height := 39;
      Image.LoadFromFile(AppDir + 'MEDIA\Laser\TripleB.bmp');
      fSoundLaser := FSOUND_Sample_Load(FSOUND_FREE,PChar(AppDir + 'MEDIA\Laser\TripleB.wav'), 0, 0, 0);
      Speed:=30;
      fDegat := 70;
      fUGauge := 15;
    end;

  end;
  FSOUND_PlaySound(FSOUND_FREE, fSoundLaser);
  Image.Transparent:=True;
  Image.TransparentColor:=ClBlack;

end;

destructor TLaser.Destroy;
begin
  FSOUND_Sample_Free(fSoundLaser);
  inherited destroy;
end;


procedure TLaser.CheckOut;
begin
  if (Coord.X ) >  MoveRect.Right then ToDeleted:=True;
  if (Coord.X ) <  MoveRect.Left then  ToDeleted:=True;
  if (Coord.Y) < MoveRect.Top then ToDeleted:=True;
  if (Coord.Y) > MoveRect.Bottom then ToDeleted:=True;
end;



end.

