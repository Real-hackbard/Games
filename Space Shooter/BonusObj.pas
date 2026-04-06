unit BonusObj;

interface

uses
  Windows, SysUtils, Classes, Graphics, ObjDrawable, Fmod, fmodtypes;

type
  TBonusType = (btIncLaser,btIncGauge,btIncPower,btLaserEnergy,btIncAngle, btLaserTripleB);

  TBonus = class (TObjDrawable)
  private
    fDureeApparition : integer;
    fBonusType   : TBonusType;
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect; ABonusType : TBonusType ; ACoord : TPoint);

    property DureeApparition : integer    read fDureeApparition write fDureeApparition;
    property BonusType       : TBonusType read fBonusType       write fBonusType;
    procedure Draw;
end;

implementation

constructor TBonus.Create(ACanvas : TCanvas; AMoveRect : TRect; ABonusType : TBonusType ; ACoord : TPoint);
begin
  inherited Create(ACanvas , AMoveRect);
  Coord := ACoord;
  fBonusType := ABonusType;
  fDureeApparition:=25 * 5;
  case fBonusType of

    btIncLaser : Image.LoadFromFile(AppDir + 'MEDIA\Bonus\IncLaser.bmp');
    btIncGauge : Image.LoadFromFile(AppDir + 'MEDIA\Bonus\IncGauge.bmp');
    btIncPower : Image.LoadFromFile(AppDir + 'MEDIA\Bonus\IncPower.bmp');
    btLaserEnergy : Image.LoadFromFile(AppDir + 'MEDIA\Bonus\LaserEnergy.bmp');
    btIncAngle : Image.LoadFromFile(AppDir + 'MEDIA\Bonus\IncAngle.bmp');
    btLaserTripleB : Image.LoadFromFile(AppDir + 'MEDIA\Bonus\LaserTripleB.bmp')
  end;

  // basic size
  Width := 15;
  Height := 14;

  Image.Transparent:=True;
  Image.TransparentColor := ClBlack;
end;

procedure TBonus.Draw;
begin
  fDureeApparition:=fDureeApparition-1;
  inherited draw;
end;




end.

