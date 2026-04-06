unit ExplosionObj;

interface

uses
  Windows, SysUtils,Classes,Graphics,ObjDrawable,ObjAnimated,Fmod,fmodtypes;

type
  TExplosionType = (etRouge,etBleu,etReal,etBonus);

  TExplosion = class (TObjectAnimated)
  private
    fDureeApparition : integer;
    fExplosionType   : TExplosionType;
    fSoundExplosion : PFSoundSample;

  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect;AExplosionType : TExplosionType ; ACoord : TPoint);
    destructor Destroy;override;

    property    DureeApparition : integer  read fDureeApparition  write fDureeApparition;
    procedure Draw;

end;

implementation

constructor TExplosion.Create(ACanvas : TCanvas; AMoveRect : TRect;AExplosionType : TExplosionType ; ACoord : TPoint);
begin
  inherited Create(ACanvas , AMoveRect);
  Coord := ACoord;
  fExplosionType := AExplosionType;

  Image.Transparent:=True;
  Image.TransparentColor := ClBlack;

  case fExplosionType of

    etBonus : begin
      CreateSprite(AppDir +'MEDIA\EXPLOSION\ExplosionType1.bmp',12,41,38,Image.TransparentColor);
      fSoundExplosion := FSOUND_Sample_Load(FSOUND_FREE,PChar(AppDir + 'MEDIA\EXPLOSION\IncLaser.wav'), 0, 0, 0);
      Width := 41;
      Height := 38;
    end;

    etRouge : begin
      CreateSprite(AppDir +'MEDIA\EXPLOSION\ExplosionType1.bmp',12,41,38,Image.TransparentColor);
      fSoundExplosion := FSOUND_Sample_Load(FSOUND_FREE,PChar(AppDir + 'MEDIA\EXPLOSION\explode.wav'), 0, 0, 0);
      Width := 41;
      Height := 38;
    end;

    etBleu : begin
       CreateSprite(AppDir +'MEDIA\EXPLOSION\ExplosionType2.bmp',12,40,38,Image.TransparentColor);
       fSoundExplosion := FSOUND_Sample_Load(FSOUND_FREE,PChar(AppDir + 'MEDIA\EXPLOSION\explode.wav'), 0, 0, 0);
       Width := 41;
       Height := 38;
    end;

    etReal : begin
       CreateSprite(AppDir +'MEDIA\EXPLOSION\explosionReal.bmp',16,64,64,Image.TransparentColor);
       fSoundExplosion := FSOUND_Sample_Load(FSOUND_FREE,PChar(AppDir + 'MEDIA\EXPLOSION\explode.wav'), 0, 0, 0);
       Width := 64;
       Height := 64;
    end;

  end;
  fDureeApparition := NombreTexture-1;
  FSOUND_PlaySound(FSOUND_FREE, fSoundExplosion);
end;

procedure TExplosion.Draw;
begin
  fDureeApparition:=fDureeApparition-1;
  inherited draw;
end;

destructor TExplosion.Destroy;
begin
  FSOUND_Sample_Free(fSoundExplosion);
  inherited Destroy;
end;




end.
 