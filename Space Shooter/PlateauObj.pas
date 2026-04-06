unit PlateauObj;

interface

uses
     Windows, Classes, Controls, Graphics, ExtCtrls, Messages, Contnrs, Jpeg,
     ObjDrawable, ObjMovable, Obj, MeteorObj, LaserObj, ExplosionObj,
     BonusObj, BombeGuideeObj, Fmod, fmodtypes, Dialogs, EnnemiObj;

type
  TStatusPlateau = (pCreate,pLoading,pPause,pRun,pGameOver);
  TPlateau = class (TPaintBox)
  private
    // sky
    BackGround          : TObjectList;
    // the player
    MonVaisseau         : TVaisseau;
    // Vectors of the different things present in the game
    // Facilitates the insertion, deletion, drawing, and progression of each object
    // Moreover, much more advantageous than a simple array (no limit (except RAM ;) ))
    // And simpler than a dynamic array

    ListEnnemi          : TObjectList;
    ListLaser           : TObjectList;
    ListExplosion       : TobjectList;
    ListBonus           : TObjectList;

    ImagePause          : TObjDrawable;
    ImageGameOver       : TObjDrawable;
    ImageLoading        : TObjDrawable;

    // the application directory (used to load game images)
    fAppDir             : String;

    // the status of the plateau,
    fStatus              : TStatusPlateau;

    // boolean to determine if the set is paused or not
    fPause : boolean;
    // board score
    fScore : Integer;

    // general music
     Musique : PFMusicModule;
     fVolumeMusique : integer;
     fSFXVolume : integer;
    {
      Mouse event retrieval, inspired by Guillemouse
      I only use it in private procedures
    }

    // Guillemouze
    // Mouse enters, exits Plateau
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    // Me
    // when you move the mouse
    procedure WMMouseMove (var Message: TMessage); message WM_MOUSEMOVE;
    // press left button
    procedure WMMouseLeftDown(var Message: TMessage); message WM_LBUTTONDOWN;
    // release left button
    procedure WMMouseLeftUp(var Message: TMessage); message WM_LBUTTONUP;

    procedure SetVolumeMusique(vol:integer);
    procedure SetSFXVolume(vol : integer);
  public
    constructor Create(AOwner: TComponent;Parent : TWinControl);Reintroduce;
    destructor  Destroy;override;
    procedure   Paint; override;

    // We load the board, player creation
    procedure   Load(AVaisseauType : TVaiseauType);
    // we launch the Thread
    procedure   Start;
    // We stop the thread
    procedure   Stop;

    procedure   CreerMeteorite(MeteoriteType : TMeteoriteType);overload;
    procedure   CreerMeteorite(MeteoriteType : TMeteoriteType;ACoord : Tpoint;ADirection : single);overload;

    procedure   CreerBombeG(BombeType : TBombeGType);

    procedure   CreerVaisseauEnnemi(VaisseauType : TVaisseauEnnemiType);
    procedure   CreerExplosion(ExplosionType : TExplosionType; Coord : TPoint);
    procedure   CreerLaser(LaserType : TLaserType ;Coord : TPoint;Direction : single);
    procedure   CreerBonus(BonusType : TBonusType ;Coord : TPoint);

    property ApplicationDirectory   : String          read fAppDir         write fAppDir;
    property Status                 : TStatusPlateau  read fStatus         write fStatus;
    property Vaisseau               : TVaisseau       read MonVaisseau     write MonVaisseau;
    property VecteurEnnemi          : TObjectList     read ListEnnemi      write ListEnnemi;
    property VecteurLaser           : TObjectList     read ListLaser       write ListLaser;
    property VecteurExplosion       : TObjectList     read ListExplosion   write ListExplosion;
    property VecteurBonus           : TObjectList     read ListBonus       write ListBonus;
    property Pause                  : boolean         read fPause          write fPause;
    property Score                  : integer         read fScore          write fScore;
    property VolumeMusique          : integer         read fVolumeMusique  write SetVolumeMusique;
    property VolumeSFX              : integer         read fSFXVolume      write SetSFXVolume;

end;

const
  NAME_BACKGROUND = '\MEDIA\BACKGROUND\Stars.jpg';
  DIMENSION_BACKGROUND = 125;

  NAME_MUSIQUE = '\MEDIA\MUSIC\spaceflight_hymn.mid';
implementation
// It must be declared here, otherwise there is a circular reference
uses ThreadMouvement;
var
  ThreadM     : TThreadMouvement;


constructor TPlateau.Create(AOwner: TComponent ; Parent : TWinControl);
begin
  inherited Create(AOwner);
  fStatus :=pCreate;

  self.Parent:=Parent;
  self.Align:=alClient;
  // true, manages the release of objects from the list by itself
  ListEnnemi:=TObjectList.Create(True);
  ListLaser := TObjectList.Create(True);
  ListExplosion := TObjectList.Create(True);
  ListBonus := TObjectList.Create(True);
  BackGround := TObjectList.Create(True);
  // When the board is created, the Thread is not launched
  fPause := True;
  ThreadM := TThreadMouvement.Create(fPause,self);
  // When we start, the score is 0
  fScore := 0;
  // initializes the sound, FMOD
  FSOUND_Init(44100, 32, 0);
end;

destructor TPlateau.Destroy;
begin
  ThreadM.Free;
  // TObjectList takes care of everything
  MonVaisseau.Free;
  ListEnnemi.Free;
  BackGround.Free;
  ListLaser.Free;
  ListExplosion.Free;
  ListBonus.Free;
  ImagePause.Free;
  ImageGameOver.Free;
  ImageLoading.Free;

  FMUSIC_FreeSong(Musique);
  FSOUND_Close();
  inherited destroy;

end;

procedure TPlateau.SetVolumeMusique(vol:integer);
begin
  if(vol<0) or (vol>255) then exit;
  FMUSIC_SetMasterVolume(Musique,vol)
end;

procedure TPlateau.SetSFXVolume(vol : integer);
begin
  if(vol<0) or (vol>255) then exit;
  FSOUND_SetSFXMasterVolume(vol)
end;


procedure TPlateau.Load(AVaisseauType : TVaiseauType) ;
var
  jpg : TJpegImage;
  sBackGround : TObjDrawable;
  x,y : integer;
begin
  if  fAppDir='' then exit;

  ImageLoading := TObjDrawable.Create(Canvas,ClientRect);
  ImageLoading.Image.LoadFromFile(fAppDir+'\MEDIA\GAME\loading.bmp');
  ImageLoading.Coord := Point ( ClientWidth div 2 - ImageLoading.Image.Width div 2 , ClientHeight div 2 - ImageLoading.Image.Height div 2);
  fStatus := pLoading;
  Refresh;

  jpg := TJpegImage.Create;
  jpg.LoadFromFile(fAppDir+NAME_BACKGROUND);

  // TObjectList takes care of everything
  for x:=0 to (ClientWidth div DIMENSION_BACKGROUND) do begin
    for y:=0 to (ClientHeight div DIMENSION_BACKGROUND) do begin
      sBackGround := TObjDrawable.Create(Canvas,ClientRect);
      with(sBackGround) do begin
        Image.Assign(jpg);
        Coord := Point(DIMENSION_BACKGROUND*x,DIMENSION_BACKGROUND*y);
        Width := DIMENSION_BACKGROUND;
        Height := DIMENSION_BACKGROUND;
      end;
      BackGround.Add(sBackGround)  ;
    end;
  end;

  jpg.Free;

  MonVaisseau := TVaisseau.Create(Canvas,ClientRect,AVaisseauType);
  Musique := FMUSIC_LoadSong(PChar(fAppDir +NAME_MUSIQUE));


  Canvas.CopyMode:=cmSrcCopy;

  ImagePause := TObjDrawable.Create(Canvas,ClientRect);
  ImagePause.Image.LoadFromFile(fAppDir + '\MEDIA\GAME\Pause.bmp');
  ImagePause.Image.TransparentColor:=ClWhite;
  ImagePause.Coord := Point ( ClientWidth div 2 - ImagePause.Image.Width div 2 , ClientHeight div 2 - ImagePause.Image.Height div 2);


  ImageGameOver := TObjDrawable.Create(Canvas,ClientRect);
  ImageGameOver.Image.LoadFromFile(fAppDir + '\MEDIA\GAME\GameOver.bmp');
  ImageGameOver.Coord := Point ( ClientWidth div 2 - ImageGameOver.Image.Width div 2 , ClientHeight div 2 - ImageGameOver.Image.Height div 2);


  SetVolumeMusique(255);
  SetSFXVolume(100);
end;

procedure  TPlateau.CreerMeteorite(MeteoriteType : TMeteoriteType);
begin
  ListEnnemi.Add(TMeteorite.Create(Canvas , ClientRect , MeteoriteType));
end;

procedure TPlateau.CreerMeteorite(MeteoriteType : TMeteoriteType;ACoord : Tpoint ; ADirection : single);
var
  m : TMeteorite;
begin
    m := TMeteorite.Create(Canvas , ClientRect , MeteoriteType);
    m.Coord := ACoord;
    m.Direction := ADirection;
    ListEnnemi.Add(m);
end;

procedure TPlateau.CreerBombeG(BombeType : TBombeGType);
begin
   ListEnnemi.Add(TBombeG.Create(Canvas,ClientRect,BombeType));
end;

procedure TPlateau.CreerVaisseauEnnemi(VaisseauType : TVaisseauEnnemiType);
begin
  ListEnnemi.Add(TVaisseauEnnemi.Create(Canvas,ClientRect,veEnforcer));
end;


procedure TPlateau.CreerExplosion(ExplosionType : TExplosionType; Coord : TPoint);
begin
  ListExplosion.Add(TExplosion.Create(Canvas,ClientRect,ExplosionType,Coord))
end;

procedure TPlateau.CreerLaser(LaserType : TLaserType ;Coord : TPoint;Direction : single);
var
  l : TLaser;
begin
  l :=TLaser.Create(Canvas , ClientRect , Coord ,Direction, LaserType);
  MonVaisseau.GaugeShoot := MonVaisseau.GaugeShoot - l.UGauge;
  ListLaser.Add(l);
end;

procedure TPlateau.CreerBonus(BonusType : TBonusType ;Coord : TPoint);
begin
  ListBonus.Add(TBonus.Create(Canvas,ClientRect,BonusType,Coord));
end;


procedure TPlateau.Start;
begin
  if not (Assigned(ThreadM)) then exit;
  fStatus :=pRun;
  fPause := False;
  ThreadM.Resume;
  FMUSIC_PlaySong(Musique);
end;

procedure TPlateau.Stop;
begin
  if not (Assigned(ThreadM)) then exit;
  fStatus := pPause;
  fPause := True;
   // we keep the position of the sound
  FMUSIC_StopSong(Musique);
end;

{
  Here's a small example that might be useful: if you move outside the window, it means you're no longer playing,
  so it stops the thread, and there's no problem :) ; I'm just using it to hide the cursor
  when playing and make it reappear...
}
procedure TPlateau.CMMouseEnter(var Message: TMessage);
begin
  ShowCursor(False);
  //ThreadM.Resume;
end;

procedure TPlateau.CMMouseLeave(var Message: TMessage);
begin
  ShowCursor(True);
  //ThreadM.Suspend;
end;

procedure TPlateau.WMMouseMove(var Message: TMessage);
begin
  if assigned(MonVaisseau) then
    MonVaisseau.Coord:=Point(Message.LParamLo,Message.LParamHi);
end;

procedure TPlateau.WMMouseLeftDown(var Message: TMessage);
begin
  if assigned(MonVaisseau) then begin
    MonVaisseau.Shoot := True;
  end;

end;

procedure TPlateau.WMMouseLeftUp(var Message: TMessage);
begin
  if assigned(MonVaisseau) then MonVaisseau.Shoot := False;
end;

procedure TPlateau.Paint;
var
  i :integer;
begin

    inherited Paint;

    for i:=0 to BackGround.Count-1 do
        TObjDrawable(BackGround.items[i]).Draw;

    if assigned(MonVaisseau) then MonVaisseau.Draw;

    for i:=0 to ListEnnemi.Count-1 do begin
      TObjDrawable(ListEnnemi.items[i]).Draw;
      if ListEnnemi.items[i].ClassName='TVaisseauEnnemi' then
        TVaisseauEnnemi(ListEnnemi.items[i]).Draw;
    end;

    for i:=0 to ListLaser.Count-1 do
      TLaser(ListLaser.items[i]).Draw;

    for i:=0 to ListExplosion.Count-1 do
      TExplosion(ListExplosion.items[i]).Draw;

    for i:=0 to ListBonus.Count-1 do
      TBonus(ListBonus.items[i]).Draw;


    case fStatus of
      pPause : ImagePause.Draw;
      pGameOver : ImageGameOver.Draw;
      pLoading : ImageLoading.Draw;
    end;

end;

end.
