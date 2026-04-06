unit ThreadMouvement;

interface

uses Windows, Classes, SysUtils,PlateauObj, ObjMovable, Obj, MeteorObj,
     LaserObj, ExplosionObj, BonusObj, BombeGuideeObj, EnnemiObj, Math, Unit1;

type
  TThreadMouvement = class(TThread)

  private
    fPlateau : TPlateau;
    fAttenteBonus : integer;
    procedure CentralControl;
    procedure CheckShoot;
    procedure CheckExplosion;
    procedure CreerEnnemi;
    procedure ProgressEnnemi;
    procedure ProgressVaisseau;
    procedure ProgressLaser;
    procedure CheckBonus;
    procedure CreerBonus;

  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended:boolean;APlateau : TPlateau);
    destructor  Destroy; override;
end;

const
  MAX_ENNEMI = 25;
  TEMPS_MAX_BONUS = 25 * 5;
  SCORE_BOMBE_GT = 2000;
  SCORE_BOMBE_GB = 5000;
  SCORE_VAISSEAU_ENFORCER = 10000;
implementation

constructor TThreadMouvement.Create(CreateSuspended:boolean;APlateau : TPlateau);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate:=false;
  Priority:=tpNormal;
  fPlateau := APlateau;
  fAttenteBonus := 0;
end;

destructor TThreadMouvement.Destroy;
begin
  inherited;
end;

procedure TThreadMouvement.CreerEnnemi;
var
  i : integer;
  b1,b2,v1 : integer;
begin
  // constant enemy...
  if(fPlateau.VecteurEnnemi.Count-1 < MAX_ENNEMI) then fPlateau.CreerMeteorite(mtBig);

  // Every time the score modulo SCORE_BOMBE_GT = 0, small guided bombs are launched...

  if( (fPlateau.Score>0) and (fPlateau.Score mod SCORE_BOMBE_GT = 0) ) then begin
    b1:=0;
    for i:=0 to fPlateau.VecteurEnnemi.Count-1 do begin
      if( (TBombeG(fPlateau.VecteurEnnemi.Items[i]).ClassName='TBombeG')
          and(TBombeG(fPlateau.VecteurEnnemi.Items[i]).BombeGType = bgTiny)   ) then  b1:=b1+1;
    end;
    if(b1<fPlateau.Score div SCORE_BOMBE_GT ) then fPlateau.CreerBombeG(bgTiny);
  end;

  // same but with large guided bombs

  if( (fPlateau.Score>0) and (fPlateau.Score mod SCORE_BOMBE_GB = 0) ) then begin
    b2:=0;
    for i:=0 to fPlateau.VecteurEnnemi.Count-1 do begin
      if( (TBombeG(fPlateau.VecteurEnnemi.Items[i]).ClassName='TBombeG')
          and(TBombeG(fPlateau.VecteurEnnemi.Items[i]).BombeGType = bgBig)   ) then b2:=b2+1;
    end;
    if(b2<fPlateau.Score div SCORE_BOMBE_GB ) then fPlateau.CreerBombeG(bgBig);
  end;


  (* TARGET POSITION UPDATE; THE SHIP IS ON THE GUIDED BOMB *)
  for i:=0 to fPlateau.VecteurEnnemi.Count-1 do begin
    if (fPlateau.VecteurEnnemi.Items[i].ClassName = 'TBombeG')then
      TBombeG(fPlateau.VecteurEnnemi.Items[i]).Cible := fPlateau.Vaisseau.Coord;
  end;

  // vaisseau ennemi
  if( (fPlateau.Score>0) and (fPlateau.Score mod SCORE_VAISSEAU_ENFORCER = 0) ) then begin
    v1:=0;
    for i:=0 to fPlateau.VecteurEnnemi.Count-1 do begin
      if( (TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).ClassName='TVaisseauEnnemi')
          and(TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).VaisseauType = veEnforcer)   ) then  v1:=v1+1;
    end;
    if(v1<fPlateau.Score div SCORE_VAISSEAU_ENFORCER ) then begin
      fPlateau.CreerVaisseauEnnemi(veEnforcer);
    end;
  end;
end;

procedure TThreadMouvement.ProgressEnnemi;
var
  i,j,m : integer;
  nbMeteor : integer;
begin
  (* We go through the entire list of enemies:
     Meteorite,
     G-Bomb
  *)
  for i:=0 to fPlateau.VecteurEnnemi.Count-1 do
  begin
    // We check if they are colliding (% to 1 laser), then scan the entire laser list.
    // to test % for each laser sent

    for j:=0 to fPlateau.VecteurLaser.Count-1 do begin
      {
        Enemy Collision % Laser
      }

      if(TObjMovable(fPlateau.VecteurEnnemi.Items[i]).
      Collide(TLaser(fPlateau.VecteurLaser.Items[j]))) then begin
        (*
        suppression  laser , ToDeleted := true ;
        Ennemi := Power - LaserDegat;
        et explosion ( on teste le type de laser et on associe un type d'explosion
        et augmentation du score (specifique a chaque ennemi
        *)

        // We put a stop to the laser that hit an enemy
        TLaser(fPlateau.VecteurLaser.Items[j]).ToDeleted:=True;

        // Each type of laser has its own explosion

        case TLaser(fPlateau.VecteurLaser.Items[j]).LaserType of
          ltFeu   : fPlateau.CreerExplosion(etRouge,TLaser(fPlateau.VecteurLaser.Items[j]).Coord);
          ltEnergy : fPlateau.CreerExplosion(etBleu,TLaser(fPlateau.VecteurLaser.Items[j]).Coord);
          ltTripleB : fPlateau.CreerExplosion(etBleu,TLaser(fPlateau.VecteurLaser.Items[j]).Coord);
        end;

        // score and power

          // laser and meteorite
          if(fPlateau.VecteurEnnemi.Items[i].ClassName='TMeteorite')then  begin
            fPlateau.Score := fPlateau.Score + 50;
            TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Power:=
            TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Power
            - TLaser(fPlateau.VecteurLaser.Items[j]).Degat;
          end;
          // laser and bomb
          if(fPlateau.VecteurEnnemi.Items[i].ClassName='TBombeG')then begin
            fPlateau.Score := fPlateau.Score + 150;
            TBombeG(fPlateau.VecteurEnnemi.Items[i]).Power:=
            TBombeG(fPlateau.VecteurEnnemi.Items[i]).Power
            - TLaser(fPlateau.VecteurLaser.Items[j]).Degat;
          end;
          // Laser and Enemy Ship
          if(fPlateau.VecteurEnnemi.Items[i].ClassName='TVaisseauEnnemi')then begin
            fPlateau.Score := fPlateau.Score + 300;
            TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Power:=
            TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Power
            - TLaser(fPlateau.VecteurLaser.Items[j]).Degat;
          end;

      // end Test
      end;

    // Laser collision check complete
    end;

    {
      Enemy Collision % Ship
    }

    // % meteorites
    if(fPlateau.VecteurEnnemi.Items[i].ClassName = 'TMeteorite') then begin
      if(TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Collide(fPlateau.Vaisseau)) then begin
          // we destroy the object
          TMeteorite(fPlateau.VecteurEnnemi.Items[i]).ToDeleted := True;
          // The ship loses as much power as the power of the object that is
          // collided with the ship
          fPlateau.Vaisseau.Power :=
          fPlateau.Vaisseau.Power - TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Power;
          fPlateau.CreerExplosion(etRouge ,TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Coord);
      end;
    end;

    // % bombs
    if(fPlateau.VecteurEnnemi.Items[i].ClassName = 'TBombeG') then begin
      if(TBombeG(fPlateau.VecteurEnnemi.Items[i]).Collide(fPlateau.Vaisseau)) then begin
          // we destroy the object
          TBombeG(fPlateau.VecteurEnnemi.Items[i]).ToDeleted := True;
          // The ship loses as much power as the power of the object that is
          // collided with the ship
          fPlateau.Vaisseau.Power :=
          fPlateau.Vaisseau.Power - TBombeG(fPlateau.VecteurEnnemi.Items[i]).Power;
          fPlateau.CreerExplosion(etRouge ,TBombeG(fPlateau.VecteurEnnemi.Items[i]).Coord);
      end;
    end;

    //¨% enemy ship
     if(fPlateau.VecteurEnnemi.Items[i].ClassName = 'TVaisseauEnnemi') then begin
      if(TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Collide(fPlateau.Vaisseau)) then begin
          // we destroy the object
          TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).ToDeleted := True;
          // The ship loses as much power as the power of the object that is
          // collided with the ship
          fPlateau.Vaisseau.Power :=
          fPlateau.Vaisseau.Power - TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Power;
          fPlateau.CreerExplosion(etRouge ,TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Coord);
      end;
    end;

    // compared to the Enemy Ship Laser
    if(fPlateau.VecteurEnnemi.Items[i].ClassName = 'TVaisseauEnnemi') then begin
      if( (TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Laser.Collide(fPlateau.Vaisseau))
      and (TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Laser.ToDeleted = false)) then begin
          // we destroy the object
          TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Laser.ToDeleted := True;
          // The ship loses as much power as the power of the object that is
          // collided with the ship
          fPlateau.Vaisseau.Power :=
          fPlateau.Vaisseau.Power - TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Laser.Degat;
          fPlateau.CreerExplosion(etRouge ,(fPlateau.Vaisseau.Coord));
      end;
    end;

    {
      Enemy health check
      % varies by class; death differs
    }

    // Meteorite
    if(fPlateau.VecteurEnnemi.Items[i].ClassName = 'TMeteorite') then begin
      if(TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Power<0)
      and(TMeteorite(fPlateau.VecteurEnnemi.Items[i]).ToDeleted = false) then begin
        TMeteorite(fPlateau.VecteurEnnemi.Items[i]).ToDeleted := true;
        // When you kill a large animal, a random number (between 1 and 10) is generated.
        // small meteorites appear
        // Depending on this random number, either a Power bonus is placed
        // or ammunition...
        // Or maybe nothing at all!
        if TMeteorite(fPlateau.VecteurEnnemi.Items[i]).MeteoriteType= mtBig then begin
          nbMeteor := RandomRange(1,10);
          for m := 1 to nbMeteor  do
            fPlateau.CreerMeteorite(mtTiny,TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Coord,(360 div nbMeteor)*m);
          case ( nbMeteor ) of
            1..4 : fPlateau.CreerBonus(btIncPower,TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Coord);
            5..8 : fPlateau.CreerBonus(btIncGauge,TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Coord);
          end;
        end;
      end;
      // We move them forward; here are the Meteorites
      TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Progress;
    end;

    // Bomb
    if(fPlateau.VecteurEnnemi.Items[i].ClassName = 'TBombeG') then begin

      if(TBombeG(fPlateau.VecteurEnnemi.Items[i]).Power<0)
      and(TBombeG(fPlateau.VecteurEnnemi.Items[i]).ToDeleted = false) then begin
        TBombeG(fPlateau.VecteurEnnemi.Items[i]).ToDeleted := true;
      end;

      // we move them forward
      TBombeG(fPlateau.VecteurEnnemi.Items[i]).Progress;
    end;

    // Enemy ship
    if(fPlateau.VecteurEnnemi.Items[i].ClassName = 'TVaisseauEnnemi') then begin

      if(TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Power<0)
      and(TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).ToDeleted = false) then begin
        TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).ToDeleted := true;
      end;
      // We advance the enemy ships.
      TVaisseauEnnemi(fPlateau.VecteurEnnemi.Items[i]).Progress;
    end;

    // We check if they are in the deleted category... if so, nil -> pack -> delete
    // We use TObjMovable because it inherits from ToDeleted

    if(TObjMovable(fPlateau.VecteurEnnemi.Items[i]).ToDeleted) then begin
       fPlateau.CreerExplosion(etReal,TObjMovable(fPlateau.VecteurEnnemi.Items[i]).Coord);
       fPlateau.VecteurEnnemi.Items[i]:=nil;
    end;

  end;
end;

procedure TThreadMouvement.CheckShoot;
var
  c : TPoint;
  Direction : single;
begin

  // if the Gauge bar is not empty and the ship fires
  // and that the ShootingTime = MaximumShootingTime
  if ((fPlateau.Vaisseau.GaugeShoot>0) and (fPlateau.Vaisseau.Shoot))
      and (fPlateau.Vaisseau.TempsShoot>=fPlateau.Vaisseau.TempsShootMax-1) then begin
    // we serve an intermediate variable
    // to retrieve the ship's coordinates, because the laser doesn't
    // will not exactly put the ship's Cood

    c := fPlateau.Vaisseau.Coord;
    c.X := c.X + (fPlateau.Vaisseau.Width div 2);
    c.Y := c.Y -10;

    Direction := RandomRange(-90+fPlateau.Vaisseau.AngleDeTir,-90-fPlateau.Vaisseau.AngleDeTir);
    // the basic laser
    if(fPlateau.Vaisseau.NombreLaser = 1) then
    fPlateau.CreerLaser(fPlateau.Vaisseau.LaserType,c,Direction);

    if(fPlateau.Vaisseau.NombreLaser = 2) then
    begin
       c.X := fPlateau.Vaisseau.Coord.X + fPlateau.Vaisseau.Width div 2;
       fPlateau.CreerLaser(fPlateau.Vaisseau.LaserType,c,Direction);

       c.X := fPlateau.Vaisseau.Coord.X + fPlateau.Vaisseau.Width div 4;
       fPlateau.CreerLaser(fPlateau.Vaisseau.LaserType,c,Direction);
    end;

    if(fPlateau.Vaisseau.NombreLaser = 3) then begin
      fPlateau.CreerLaser(fPlateau.Vaisseau.LaserType,c,Direction+5);
      fPlateau.CreerLaser(fPlateau.Vaisseau.LaserType,c,-90);
      fPlateau.CreerLaser(fPlateau.Vaisseau.LaserType,c,Direction-5);
    end;
  end;

  fPlateau.Vaisseau.RecupShoot;
end;

procedure TThreadMouvement.ProgressVaisseau;
var
  i : integer;
begin
  // check if we're getting a bonus
  for i:= 0 to fPlateau.VecteurBonus.Count-1 do begin
    if(fPlateau.Vaisseau.Collide(TBonus(fPlateau.VecteurBonus.Items[i]))) then begin
      // we associate the collision of the bonus
      // to his reward...
      case TBonus(fPlateau.VecteurBonus.Items[i]).BonusType of
        btIncPower : fPlateau.Vaisseau.Power := fPlateau.Vaisseau.Power + (fPlateau.Vaisseau.PowerMax div 8);
        btIncGauge : fPlateau.Vaisseau.GaugeShoot := fPlateau.Vaisseau.GaugeShoot + (fPlateau.Vaisseau.GaugeShootMax div 2);
        btIncLaser : fPlateau.Vaisseau.NombreLaser := fPlateau.Vaisseau.NombreLaser + 1;
        btLaserEnergy : fPlateau.Vaisseau.LaserType := ltEnergy;
        btLaserTripleB : fPlateau.Vaisseau.LaserType := ltTripleB;
        btIncAngle : fPlateau.Vaisseau.ElargirAngleTir;
      end;
      TBonus(fPlateau.VecteurBonus.Items[i]).ToDeleted := True;
    end;
  end;

  // if life < 0 toDeleted = true
  if(fPlateau.Vaisseau.Power<=0) then
    fPlateau.Vaisseau.ToDeleted:=true;

  if(fPlateau.Vaisseau.ToDeleted) then begin
    fPlateau.Vaisseau.Free;
    fPlateau.Vaisseau:=nil;
    fPlateau.Status := pGameOver;
  end;

end;

procedure TThreadMouvement.ProgressLaser;
var
  i : integer;
begin
  // We go through the list, and we move all the lasers forward.
  for i:=0 to fPlateau.VecteurLaser.Count-1 do begin
    TLaser(fPlateau.VecteurLaser.items[i]).Progress;
    // If some are marked for deletion, we set them to nil; nil -> pack -> delete
    if(TLaser(fPlateau.VecteurLaser.items[i]).ToDeleted)then
    fPlateau.VecteurLaser.Items[i]:=nil;
   end;
end;

procedure TThreadMouvement.CheckExplosion;
var
  i:integer;
begin
  // we go through the list of explosions
  for i:=0 to fPlateau.VecteurExplosion.Count-1 do begin
    // If the duration of appearance is negative, then it is set to delete
    // Note: the duration of appearance is decremented with each call to Draw for an explosion.
    if(TExplosion(fPlateau.VecteurExplosion.Items[i]).DureeApparition<0) then
      TExplosion(fPlateau.VecteurExplosion.Items[i]).ToDeleted:=True;
    // If it is set to be deleted, nil -> pack -> free
    if(TExplosion(fPlateau.VecteurExplosion.Items[i])).ToDeleted then
      fPlateau.VecteurExplosion.Items[i]:=nil;
  end;
end;

procedure TThreadMouvement.CheckBonus;
var
  i:integer;
begin
  for i:=0 to fPlateau.VecteurBonus.Count-1 do begin
    if(TBonus(fPlateau.VecteurBonus.Items[i]).DureeApparition < 0) then
      TBonus(fPlateau.VecteurBonus.Items[i]).ToDeleted := True;

    if(TBonus(fPlateau.VecteurBonus.Items[i]).ToDeleted) then
      fPlateau.VecteurBonus.Items[i]:=nil;
  end;
end;

procedure TThreadMouvement.CreerBonus;
var
  i : integer;
begin
  fAttenteBonus := fAttenteBonus + 1;
  if(fAttenteBonus > TEMPS_MAX_BONUS ) then begin
    fAttenteBonus:=0;

    i := Random(101);

    case i of
      1..40 : fPlateau.CreerBonus(btIncAngle,Point(Random(fPlateau.ClientRect.Right),Random(fPlateau.ClientRect.Bottom)));
      41..80 : fPlateau.CreerBonus(btLaserEnergy,Point(Random(fPlateau.ClientRect.Right),Random(fPlateau.ClientRect.Bottom)));
      81..85 : fPlateau.CreerBonus(btIncLaser,Point(Random(fPlateau.ClientRect.Right),Random(fPlateau.ClientRect.Bottom)));
      86..100 : fPlateau.CreerBonus(btLaserTripleB,Point(Random(fPlateau.ClientRect.Right),Random(fPlateau.ClientRect.Bottom)));
    end;
  end;
end;

procedure TThreadMouvement.CentralControl;
begin
   if( fPlateau.Status = pRun) then begin
    CheckBonus;
    CreerBonus;

    CreerEnnemi;
    CheckExplosion;
    ProgressEnnemi;
    CheckShoot;
    ProgressVaisseau;
    ProgressLaser;
    Form1.AfficherInfoJoueur;

    // Pack deletes all objects in nil, magic :)
    // Thanks again TObjectList ;)

    fPlateau.VecteurEnnemi.Pack;
    fPlateau.VecteurLaser.Pack;
    fPlateau.VecteurExplosion.Pack;
    fPlateau.VecteurBonus.Pack;

  end;
  // triggers onPaint de Plateau ...
  fPlateau.Refresh;
end;

procedure TThreadMouvement.Execute;
begin
  repeat
    Sleep(25); // in milliseconds
    Synchronize(CentralControl);
  until Terminated
end;


end.
