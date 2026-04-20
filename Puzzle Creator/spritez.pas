UNIT Spritez;
{ ** optimisations ** }
{$R-} { range checking off }
{$Q-} { stack checking off }
{$I-} { i/o checking off   }

INTERFACE

USES
  Windows, Messages, sysutils, Classes, Graphics;

CONST
  TwoPi      = pi*2;
  pirad      = pi / 180;
  radpi      = 180 /pi;

TYPE TToon = CLASS(TObject)
 private
  Dmaskcolor : Tcolor;
  Drect      : Trect;
  DWidth     : integer;
  DHeight    : integer;
  Nbimages   : Integer;
  Images     : Tlist  ;
  Masks      : Tlist  ;
  Origpt     : Tpoint ;

  Constructor Create;
  Procedure  Free;
  Procedure  LoadToon(Wbmp: Tbitmap;
                  Nb,
                  row, Col,
                  W, H,
                  separator: integer;
                  Maskcolor : tcolor);
end;

TYPE TSprite = CLASS(TObject)
  Private
  Number    : integer;
  Next      : Tsprite;
  Prior     : Tsprite;
  priority  : integer;
  LoopCtr : integer;
  Loopmax : integer;
  DelayCtr  : integer;
  Sprtag    : integer;
  SprState  : Byte;
  filler    : byte;

  Toon   : TToon;
  CurImage  : Integer;
  Animloop  : Integer;
  Animctr   : Integer;
  Animsens  : Integer;
  Animstyle : Integer;

  x         : Integer;
  y         : Integer;
  dcx       : Integer;
  dcy       : Integer;
  xx        : Single;
  yy        : Single;
  vx        : Single;
  vy        : Single;
  oldvx     : Single;
  oldvy     : Single;
  ax        : Single;
  ay        : Single;
  kvx       : Single;
  kvy       : Single;

  rcbounds  : Trect;
  rclimit   : Trect;
  rcImg     : Trect;
  rcMano    : Trect;
  rcModif   : Trect;

  rebond    : Trect;
  reBrect   : Trect;
  amLEFT    : single;
  amHigh    : single;
  amRIGHT   : single;
  amDown    : single;

  CONSTRUCTOR Create;
  Procedure   Calculpos; VIRTUAL;
  Procedure   Adjustlimits;
end;

TYPE TPool = CLASS(TObject)
 private
  Premier  : Tsprite;
  Last     : Tsprite;
  Painting : Tlist;
  Palbum   : Pointer;
  Style    : integer;
  Albumdraw : boolean;

  CONSTRUCTOR Create( MaxS: integer);
  Procedure Free;
  Procedure ChainSprite(S: Tsprite);
  Procedure Chainlast(S: Tsprite);
  Procedure UnleashSprite(S: Tsprite);
  Procedure Erasures;
  Procedure Travel;
  Procedure PrepareCache;
  Procedure Display;
  Function  SprCreate(N: integer; SprType : integer): boolean;
  Function  GetSprite(N : integer): Tsprite;
 Public
  Maxspr     : integer;
  Collisspr  : integer;
  Collisrect : Trect;
  PoolState  : integer;

  Function  CreateSprite(N : integer; Toonname : string): boolean;
  Function  SprExists(N : integer): boolean;
  Function  SprCount : integer;
  Procedure SprDestroy(N : integer);
  Procedure SprErase(n : integer);


  Procedure Animate;
  Procedure AnimateMono(N : integer);

  Procedure SetLoopCtr(N, m : integer);
  Function  GetLoopCtr(N : integer): integer;
  Procedure SetDelayCtr(N, m : integer);
  Function  GetDelayCtr(N : integer): integer;
  Procedure Setpriority(N, p : integer);
  Procedure Setprioritylast(N, p : integer);
  Function  Getpriority(N : integer): integer;
  Procedure SetActive(N: integer; b: boolean);
  Procedure SetVisible(N: integer; b: boolean);
  Function  IsActive(N: integer): boolean;
  Function  IsVisible(N: integer): boolean;
  Procedure Settag(N , atag: integer);
  Function  Gettag(N : integer): integer;

  Procedure SetToon(N: integer; Wname: STRING);
  Function  GetToonName(N: integer): String;
  Function  GetToonW(N: integer): integer;
  Function  GetToonH(N: integer): integer;
  Procedure SetAnim(N, Wcount: integer);
  Procedure SetAnimStyle(N, Wstyle: integer);
  Function  GetCurimage(N: integer): integer;
  Procedure SetTrace(N: integer; b: boolean);

  Procedure SetLimits(N: integer; wrect: Trect);
  Procedure SetPos(N, wx, wy: integer);
  Function  Getposx(N: integer): integer;
  Function  Getposy(N: integer): integer;
  Function  Getdcx(N: integer): integer;
  Function  Getdcy(N: integer): integer;
  Procedure SetV(N: integer; Wvx, Wvy: single);
  Procedure SetKV(n: integer; kvx, kvy: single);
  Procedure Stop(n : integer);
  Function  Getvx(N: integer): single;
  Function  Getvy(N: integer): single;
  Function  SameXdirection(N: integer): boolean;
  Function  SameYdirection(N: integer): boolean;
  Procedure Setaccel(n: integer; Wax, Way : single);
  Function  Getax(N: integer): single;
  Function  Getay(N: integer): single;
  Function  Getaxvnull(N, x1: integer): single;
  Function  Getayvnull(N, y1: integer): single;
  Procedure Gotoxy(N, wx, wy, Loops: integer);
  Function  PtinSprite(pt: tpoint; marge: integer): integer;
  Function  Getoffsetx(N : integer): integer;
  Function  Getoffsety(N : integer): integer;
  Procedure Setoffset(N , wx, wy : integer);
end;

TYPE TAlbum = CLASS(TObject)
  private
  Cancan  : Tcanvas;
  BmpFont : Tbitmap;
  BmpMano : Tbitmap;
  Fondwidth  : integer;
  Fondheight : integer;
  Toons   : Tstringlist;
  Pools   : Tlist;
  Flagdecor : boolean;
  Function GetToon(wname : STRING): TToon;
  Function  GetAlbumToonName(AToon : TToon) : string;
public
  CONSTRUCTOR Create(Wcanvas : Tcanvas; Bitmap : Tbitmap);
  Procedure Free;
  Procedure FreePoolsToons;
  Function  CreatePool(Maxsprites: integer): Tpool;
  Procedure FreePool(Wpool : Tpool);

  Function  GetAreaBmp: Tbitmap;
  Procedure SetAreaBmp(Wbmp: Tbitmap);
  Function  GetArearect: Trect;
  Function  GetAreawidth  : integer;
  Function  GetAreaHeight : integer;
  Procedure DrawArea(wrect : Trect);

  Procedure FreeToon(Wname : STRING);
  Procedure CreateToon(wname : STRING; Wbmp: Tbitmap; Nb, Row, Col, W, H,
                        separator: integer; Maskcolor: Tcolor);
  Function GetMaskBitmap(Wname : string;
                      N: integer): Tbitmap;
  Function GetImgBitmap(Wname : string;
                      N: integer): Tbitmap;
  Function Gettoonwidth(Wname : string): integer;
  Function GettoonHeight(Wname : string): integer;
  Procedure SettoonCenter(Wname : string; acx, acy : integer);
end;
  Function rndi(a, b: integer): integer;
  Function rnd(a, b: single): single;
  Function zsin(a: integer): single;
  Function zcos(a: integer): single;
  Function Distance(x1, y1, x2, y2 : integer): integer;

IMPLEMENTATION

Const
  Maxrand = 1023;
  active  = 0;
  Visible = 1;
  trace   = 2;
  modif   = 3;
  userdraw = 4;
  autoleader = 5;
Var
  Trand  : array[0..Maxrand] OF single;
  Irand  : integer;
  sinb   : array[0..360] OF single;
  cosb   : array[0..360] OF single;

Procedure initrandom;
Var
  i : integer;
  a : single;
Begin
  randomize;
  For i := 0 to Maxrand do Trand[i] := random;
  For i := 0 to 360 do
  Begin
    a := i * pirad;
    sinb[i] := sin(a);
    cosb[i] := cos(a);
  end;
  Irand := 0;
end;

procedure SetBit(Position : Integer; Valeur: Byte; var ChangeByte : Byte);
var
  Bt : Byte;
begin
  bt := $01;
  bt := bt shl Position;
  if Valeur = 1 then
    ChangeByte := ChangeByte or bt
  else
  begin
    bt := bt xor $FF;
    ChangeByte := ChangeByte and bt;
  end;
end;

function Getbit(Position : Integer; TestByte : Byte) : Boolean;
var
  bt : Byte;
begin
  bt := $01;
  bt := bt shl Position;
  GetBit := (bt and TestByte) > 0;
end;

Function zsin(a : integer): single;
Begin
  while a > 360 do dec(a, 360);
  while a < 0   do inc(a, 360);
  result := sinb[a];
end;

Function zcos(a : integer): single;
Begin
  while a > 360 do dec(a, 360);
  while a < 0   do inc(a, 360);
  result := cosb[a];
end;

Function rnd(a, b: single): single;
var
  mano : single;
Begin
  If b < a  then begin mano := a; a := b; b:= mano; end;
  result := a + (b-a)* Trand[irand];
  inc(irand);
  IF irand > Maxrand Then irand := 0;
END;

Function rndi(a, b: integer): integer;
var
  mano : integer;
Begin
  If b < a  then begin mano := a; a := b; b:= mano; end;
  result := a + trunc((b-a+1)* Trand[irand]);
  inc(irand);
  IF irand > Maxrand Then irand := 0;
END;

Function Distance(x1, y1, x2, y2 : integer): integer;
var
  i : Integer;
  a, r0, r1 : Integer;
begin
  r0 := x2-x1;
  r1 := y2-y1;
  a := r0*r0 + r1*r1;
  r1 := (1+a) DIV 2;
  FOR i := 1 TO 12 DO
  begin
    r0 := r1;
    IF r0 > 0 then r1 := (r0+(a div r0)) div 2;
  end;
  Result:= r1;
end;

CONSTRUCTOR TToon.Create;
Begin
  INHERITED Create;
  Dmaskcolor := clblack;
  Drect := rect(0,0,0,0);
  DWidth  := 0;
  DHeight := 0;
  Nbimages := 0;
  Images   := NIL;
  Masks  := NIL;
end;

Procedure TToon.Free;
Var
  i : Integer;
Begin
  FOR i := 0 TO Images.count - 1 DO
    IF Images.Items[i]  <> NIL Then TBitmap(Images.Items[i]).free;
  FOR i := 0 TO Masks.count - 1 DO
    IF Masks.Items[i] <> NIL Then Tbitmap(Masks.Items[i]).free;
  INHERITED Free;
end;


Procedure Domasque(Bmpimage,Bmpmask: Tbitmap; zw, zh: integer; Mcolo:Tcolor);
var
  svcolo : Tcolor;
Begin
  Bmpmask.monochrome := true;
  svcolo := Bmpimage.canvas.brush.color;
  bmpimage.canvas.brush.color := Mcolo;
  Bmpmask.canvas.Draw(0,0, Bmpimage);
  IF Mcolo <> Clblack then
  begin
    With bmpimage.canvas do
    begin
      brush.color := Mcolo;
      CopyMode := cmsrcinvert;
      CopyRect(rect(0,0,zw,zh), Bmpmask.canvas, rect(0,0,zw,zh));
      CopyMode := cmsrccopy;
    end;
  end;
  Bmpimage.canvas.brush.color := svcolo;
end;

Procedure TToon.LoadToon
   (wbmp: Tbitmap; Nb, Row, Col, W, H, separator:integer; Maskcolor: Tcolor);
Var
  bmpi   : Tbitmap;
  bmpm   : Tbitmap;
  ctr    : Integer;
  ix     : Integer;
  iy     : Integer;
  colonne : integer;
  origRect : TRect;
Begin
  Dmaskcolor := Maskcolor;
  DWidth  := W;
  DHeight := H;
  IF Nb > Row * col Then Nb := Row *col;
  Nbimages  := Nb ;
  Images := Tlist.create;
  Images.capacity := Nb;
  Masks := Tlist.create;
  Masks.capacity := Nb;
  IF separator < 0 then separator := 0;
  ix := separator;
  iy := separator;
  colonne := 1;
  FOR Ctr := 1 TO Nbimages DO
  Begin
    Bmpi := TBitmap.Create;
    Bmpm := TBitmap.Create;
    Try

      Bmpi.Width  := DWidth;
      Bmpi.Height := DHeight;
      Bmpi.palette := wbmp.palette;
      Bmpi.canvas.brush.color := Dmaskcolor;
      Bmpi.canvas.Fillrect(rect(0,0, Dwidth, Dheight));
      OrigRect := Bounds(ix, iy, W, H);
      Bmpi.Canvas.Copyrect(rect(0,0,w,h), WBmp.Canvas, origRect);

      Bmpm.Width  := DWidth;
      Bmpm.Height := DHeight;
      Domasque(Bmpi, Bmpm , Dwidth, DHeight, DMaskcolor);
      Ix := Ix + W + separator;
      Inc (colonne);
      IF colonne > Col Then
      Begin
        Iy := Iy + H + separator;
        Colonne := 1;
        Ix := separator;
      end;
      Finally
      IF bmpi <> NIL Then Images.add(Bmpi);
      IF bmpm <> NIL Then Masks.add(Bmpm);
    end;
  end;
end;

CONSTRUCTOR Talbum.Create(Wcanvas : Tcanvas; Bitmap : Tbitmap);
Begin
  INHERITED create;
  Cancan := Wcanvas;
  Toons   := Tstringlist.create;
  Toons.capacity := 1024;
  Pools   := Tlist.create;
  BmpFont := NIL;
  BmpMano := NIL;
  SetAreaBmp(Bitmap);
  Flagdecor  := false;
end;

Procedure Talbum.Free;
Var
  i : integer;
Begin
  IF Pools <> NIL Then
  Begin
    FOR i := 0 TO pools.count - 1 DO Tpool(Pools.items[i]).free;
    Pools.free;
  end;
  IF Toons <> NIL Then
  Begin
    FOR i := 0 TO Toons.count - 1 DO
    begin
      TToon(Toons.objects[i]).free;
      Toons.objects[i] := NIL;
    end;
    Toons.free;
  end;
  IF BmpFont <> NIL Then BmpFont.Free;
  IF BmpMano <> NIL Then BmpMano.Free;
  INHERITED free;
  self := NIL;
end;

Procedure TAlbum.FreePoolsToons;
Var
  i : integer;
Begin
  IF Pools <> NIL Then
  begin
    FOR i := 0 TO pools.count - 1 DO
    begin
      Tpool(Pools.items[i]).free;
      pools.items[i] := NIL;
    end;
    pools.clear;
  end;
  IF Toons <> NIL Then
  begin
    FOR i := 0 TO Toons.count - 1 DO
    begin
      TToon(Toons.objects[i]).free;
      Toons.objects[i] := NIL;
    end;
    Toons.clear;
  end;
end;

Function Talbum.CreatePool(maxsprites : integer): Tpool;
Var
  pp : Tpool;
Begin
  pp := Tpool.create(maxsprites);
  IF pp = Nil then result := Nil
  else
  begin
    pp.Palbum := self;
    Pools.add(pp);
    result := pp;
    pp.style := 0;
    pp.albumdraw := false;
  end;
end;

Procedure TAlbum.FreePool(wpool : Tpool);
Begin
  IF Pools.indexof(Wpool) <> -1 Then
  begin
    Wpool.free;
    Pools.Remove(Wpool);
  end;
  wpool := Nil;
end;

Procedure TAlbum.SetAreabmp(Wbmp: Tbitmap);
Begin
  IF BmpFont <> NIL Then BmpFont.Free;
  IF BmpMano <> NIL Then BmpMano.Free;
  BmpFont := TBitmap.Create;
  Bmpfont.width  := Wbmp.width;
  Bmpfont.height := Wbmp.height;
  Bmpfont.canvas.draw(0,0,Wbmp);
  Bmpfont.palette := wbmp.palette;
  Wbmp.releasepalette;
  BmpMano := TBitmap.Create;
  Bmpmano.width  := Wbmp.width;
  Bmpmano.height := Wbmp.height;
  Bmpmano.canvas.draw(0,0,wbmp);
  Bmpmano.palette := wbmp.palette;
  Wbmp.releasepalette;
  Fondwidth  := wbmp.Width;
  Fondheight := wbmp.height;
end;

Function Talbum.GetAreabmp : Tbitmap;
begin
  result := Bmpfont;
end;

Function  Talbum.GetArearect: Trect;
begin
  result.left := 0;
  result.top  := 0;
  result.right := Fondwidth;
  result.bottom := Fondheight;
end;

Function  Talbum.GetAreawidth : integer;
Begin
  result := Fondwidth;
end;

Function  Talbum.GetAreaHeight : integer;
Begin
  result := Fondheight;
end;

Procedure Talbum.DrawArea(wrect : Trect);
Var
  oldpal : Hpalette;
Begin
  Bmpmano.Canvas.copymode := cmSrcCopy;
  Bmpmano.canvas.draw(0,0, Bmpfont);
  Oldpal := selectpalette(cancan.handle, bmpfont.palette, false);
  realizepalette(cancan.handle);
  cancan.stretchdraw(wrect, Bmpmano);
  selectpalette(cancan.handle, oldpal, false);
end;

Procedure TAlbum.CreateToon(wname : STRING; Wbmp: Tbitmap;
                            Nb, Row, Col, W, H, separator : integer;
                            Maskcolor : Tcolor);
Var
  d : TToon;
Begin
  d := TToon.create;
  d.loadToon(Wbmp, nb, Row, col, w, h, separator, maskcolor);
  Toons.addobject(uppercase(wname), d);
end;

Function Talbum.GetMaskbitmap(Wname: string; N: integer): Tbitmap;
Var
  i : integer;
  d : TToon;
Begin
  Result := NIL;
  i := Toons.Indexof(uppercase(Wname));
  IF i >= 0 Then
  begin
    d := TToon(Toons.objects[i]);
    IF N > d.Masks.count - 1 then exit;
    Result := Tbitmap(d.Masks[n]);
  end;
end;

Function Talbum.GetImgbitmap(Wname: string; N: integer): Tbitmap;
Var
  i : integer;
  d : TToon;
Begin
  Result := NIL;
  i := Toons.Indexof(uppercase(Wname));
  IF i >= 0 Then
  begin
    d := TToon(Toons.objects[i]);
    IF N > d.images.count - 1 then exit;
    Result := Tbitmap(d.images[n]);
  end;
end;

Function Talbum.Gettoonwidth(Wname : string): integer;
Var
  i : integer;
  d : TToon;
Begin
  Result := 8;
  i := Toons.Indexof(uppercase(Wname));
  IF i >= 0 Then
  begin
    d := TToon(Toons.objects[i]);
    Result := d.dwidth;
  end;
end;

Function Talbum.Gettoonheight(Wname : string): integer;
Var
  i : integer;
  d : TToon;
Begin
  Result := 8;
  i := Toons.Indexof(uppercase(Wname));
  IF i >= 0 Then
  begin
    d := TToon(Toons.objects[i]);
    Result := d.dheight;
  end;
end;

Procedure Talbum.FreeToon(Wname: STRING);
Var
  i : integer;
Begin
  i := Toons.Indexof(uppercase(Wname));
  IF i >= 0 Then
  begin
    TToon(Toons.objects[i]).free;
    Toons.delete(i);
  end;
end;

Function Talbum.GetToon(wname : STRING): TToon;
Var
  i : integer;
Begin
  i := Toons.indexof(uppercase(wname));
  IF i < 0 Then result := NIL else result := TToon(Toons.objects[i]);
end;

Function Talbum.GetAlbumToonName(AToon : TToon): string;
var
  i : integer;
begin
  result := '';
  For i := 0 to Toons.count-1 do
  begin
    IF Toons.objects[i] = aToon Then
    begin
      result := Toons[i];
      break;
    end;
  end;
end;

Procedure Talbum.SettoonCenter(Wname : string; acx, acy : integer);
var
  d : Ttoon;
begin
  d := getToon(wname);
  if d = nil then exit;
  d.origpt.x := acx;
  d.origpt.y := acy;
end;

CONSTRUCTOR Tsprite.Create;
Begin
  INHERITED create;
  next   := NIL;
  priority  := 0;
  SprState      := $00;
  Setbit(active,1,sprState);
  Setbit(modif,1,sprState);
  Toon    := NIL;
  Loopctr := 0;
  Loopmax := 0;
  Delayctr  := 0;
  CurImage  := 0;
  Animloop  := 10;
  Animctr   := 1;
  Animsens  := 1;
  Animstyle := 0;
  vx        := 0;
  vy        := 0;
  ax        := 0;
  ay        := 0;
  kvx       := 1;
  kvy       := 1;
  rcbounds  := Rect(0, 0, 0, 0);
  rclimit  := Rect(0, 0, 0, 0);
  rcimg     := Rect(0, 0, 0, 0);
  rcMano    := Rect(0, 0, 0, 0);
  rcmodif   := Rect(0, 0, 0, 0);
  rebond    := Rect(0, 0, 0, 0);
  rebrect   := rect(0, 0, 0, 0);
  amLEFT    := 1;
  amHigh    := 1;
  amRIGHT  := 1;
  amDown     := 1;
  sprtag    := 0;
  filler    := 0;
end;

Procedure Tsprite.Adjustlimits;
Begin
  If Toon = Nil then exit;
  Rclimit := rcbounds;
  IF rebond.left  <> 1 then rclimit.left  := rcbounds.left  - Toon.Dwidth;
  IF rebond.Top   <> 1 then rclimit.top   := rcbounds.top   - Toon.Dheight;
  IF rebond.right  = 1 then rclimit.right := rcbounds.right - Toon.Dwidth;
  IF rebond.bottom = 1 then rclimit.bottom:= rcbounds.bottom- Toon.Dheight;
end;

Procedure TSprite.Calculpos;
Begin
  oldvx := vx;
  oldvy := vy;
  vx := vx*kvx + ax;
  vy := vy*kvy + ay;
  xx := xx + vx;
  yy := yy + vy;
  x := trunc(xx);
  y := trunc(yy);
  rebrect := rect(0,0,0,0);
  IF x < rclimit.left Then
  Begin
    rebrect.left := 1;
    Case rebond.left OF
    0 : begin xx := rclimit.right; x := trunc(xx); end;
    1 : Begin
         xx := rclimit.left; x := trunc(xx);
         IF abs(vx) < 0.0001 then vx := 0 else vx := -vx * amLEFT;
         end;
    2 : Begin vx := 0; vy := 0; ax := 0; ay := 0; kvx := 1; kvy := 1 end;
    end;
  END
  else
  IF y < rclimit.top  Then
  Begin
    rebrect.top := 1;
    case rebond.top OF
    0 : begin yy := rclimit.bottom; y := trunc(y); end;
    1 : Begin
          yy := rclimit.top; y := trunc(yy);
          IF abs(vy) < 0.0001 then vy := 0 else vy := -vy * amHigh;
        end;
    2 : Begin vx := 0; vy := 0; ax := 0; ay := 0; kvx := 1; kvy := 1 end;
    end;
  end
  else
  IF x > rclimit.right Then
  Begin
    rebrect.right := 1;
    case rebond.right OF
    0 : Begin xx := rclimit.left; x := trunc(xx); end;
    1 : Begin
          xx := rclimit.right; x:= trunc(xx);
          IF abs(vx) < 0.0001 then vx := 0 else vx := -vx * amRIGHT;
        end;
    2 : Begin vx := 0; vy := 0; ax := 0; ay := 0; kvx := 1; kvy := 1; end;
    end;
  end
  else
  IF y > rclimit.bottom Then
  Begin
    rebrect.bottom := 1;
    Case rebond.bottom OF
    0 : Begin yy := rclimit.top; y := trunc(yy); end;
    1 : Begin
          yy := rclimit.bottom; y := trunc(yy);
          IF abs(vy) < 0.0001 then vy := 0 else vy := -vy * amDown;
        end;
    2 : Begin vx := 0; vy := 0; ax := 0; ay := 0; kvx := 1; kvy := 1 end;
    end;
  end;
end;

CONSTRUCTOR TPool.Create(MaxS: integer);
Var
  i : integer;
Begin
  INHERITED Create;
  Premier   := NIL;
  Last      := NIl;
  PoolState := 0;
  Palbum   := Nil;
  Maxspr   := Maxs;
  Painting  := Tlist.create;
  Painting.capacity := maxs+1;
  FOR i := 0 TO Maxspr DO Painting.add(NIL);
  style := 0;
end;

Procedure TPool.Free;
Var
  i: Integer;
  s : tsprite;
  d : tToon;
Begin
  FOR i := 0 TO Maxspr DO
  Begin
    s := GetSprite(i);
    IF s <> NIL Then
    Begin
      d := s.Toon;
      IF d <> NIL Then
      Begin
        s.rcmodif := Bounds(s.x, s.y, d.DWidth, d.DHeight);
        With Talbum(Palbum) do
        Begin
          BmpMano.Canvas.CopyMode := cmSrcCopy;
          BmpMano.Canvas.CopyRect (s.rcmodif, BmpFont.Canvas, s.rcmodif);
          Talbum(Palbum).cancan.copymode := cmSrccopy;
          Talbum(Palbum).cancan.CopyRect
             (s.rcmodif, BmpMano.Canvas, s.rcmodif);
        end;
      end;
    end;
    IF Painting[i] <> NIL Then Tsprite(Painting.items[i]).free;
  END;
  Painting.free;
  INHERITED Free;
  self := nil;
end;

Function Tpool.SprCount: integer;
var
  i, j : integer;
Begin
  j := 0;
  For i := 0 to maxspr DO IF Painting.items[i] <> Nil then inc(j);
  result := j;
end;

Function Tpool.GetSprite(N : integer): Tsprite;
Begin
  result := Nil;
  IF (N < 0) OR (N > Maxspr) then exit;
  IF Painting.items[N] <> Nil then
  result := Tsprite(Painting.items[N]);
end;

Procedure Tpool.Chainlast(S: Tsprite);
var
  Prec : Tsprite;
begin
  if s = nil then exit;
  if Last = NIL THEN
  BEGIN
    s.next  := NIL;
    s.prior := NIL;
    Premier := s;
    Last := s;
  END
  ELSE
  BEGIN
    prec := Last;
    s.next  := NIL;
    s.prior := prec;
    prec.next := s;
    Last  := s;
  end;
end;

Procedure Tpool.ChainSprite(S: Tsprite);
var
  Cur, Prec : Tsprite;
  ok : boolean;
BEGIN
  IF s = NIL then exit;
  IF premier = NIL THEN
  BEGIN
    s.next  := NIL;
    s.prior := NIL;
    Premier := s;
    Last := s;
  END
  ELSE
  BEGIN
    Cur  := premier;
    prec := cur.prior;
    IF s.priority <= cur.priority Then
    begin
      s.next    := cur;
      s.prior   := Nil;
      cur.prior := s;
      premier   := s;
    end
    else
    begin
      ok := false;
      repeat
        prec := cur;
        cur  := cur.next;
        IF cur <> Nil then
          IF s.priority <= cur.priority then oK := true;
      Until (cur = Nil) OR OK;
      IF cur = NIL then
      begin
        s.next    := NIL;
        s.prior   := prec;
        prec.next := s;
        Last  := s;
      end
      else
      begin
        s.next  := cur;
        s.prior := prec;
        prec.next := s;
        cur.prior := s;
      end;
    end;
  END;
END;

Procedure Tpool.Unleashsprite(s : Tsprite);
Begin
  IF s = NIL Then exit;
  IF (s.prior = Nil) And  (s.next = Nil) then
  begin
    premier := nil;
    Last := nil;
    exit;
  end;
  IF s.prior = Nil then
  begin
    premier := s.next;
    premier.prior := Nil;
  end
  else
  begin
    IF s.next = Nil then
    begin
      Last := s.prior;
      s.prior.next := Nil
    end
    else
    begin
      s.prior.next := s.next;
      s.next.prior := s.prior;
    end
  end;
  s.prior := Nil;
  s.next  := Nil;
End;

Function Tpool.CreateSprite(N : integer; Toonname : string): boolean;
Var
  d : TToon;
Begin
  d := Talbum(Palbum).getToon(ToonName);
  IF d = NIL Then begin result := false; exit; end;
  result := sprcreate(N, 0);
  IF result then setToon(N, toonname);
end;

Function TPool.SprCreate(N: integer; SprType : integer): boolean;
Var
  s : Tsprite;
Begin
  s := NIL;
  IF (N < 0) OR (N > Maxspr) Then Begin result := false; exit; end;
  s := Tsprite.create;
  IF s = NIL Then Begin result := false; exit; end;
  IF Painting.items[N] <> NIL Then sprDestroy(N);
  Painting.items[N] := s;
  Chainsprite(s);
  result := true ;
  S.Rcbounds:= rect(0,0,Talbum(Palbum).fondwidth, Talbum(Palbum).fondheight);
  S.Rclimit := s.rcbounds;
  S.Number := N;
end;

Procedure TPool.sprErase(n : integer);
Var
  s : Tsprite;
  d : TToon;
Begin
  s := GetSprite(n);
  IF s <> NIL Then
  Begin
    d := s.Toon;
    setbit(visible,0,s.sprState);
    IF d <> NIL Then
    Begin
      s.rcmodif := Bounds(s.x, s.y, d.DWidth, d.DHeight);
      With Talbum(Palbum) do
      Begin
        BmpMano.Canvas.CopyMode := cmSrcCopy;
        BmpMano.Canvas.CopyRect (s.rcmodif, BmpFont.Canvas, s.rcmodif);
        Talbum(Palbum).cancan.copymode := cmSrccopy;
        Talbum(Palbum).cancan.CopyRect(s.rcmodif, BmpMano.Canvas, s.rcmodif);
      end;
    end;
  end;
end;

Procedure TPool.sprDestroy(N : integer);
Var
  s : Tsprite;
Begin
  s:= GetSprite(N);
  IF s = NIL Then exit;
  IF getbit(trace, s.sprState) = false Then sprErase(N);
  Unleashsprite(s);
  s.free;
  Painting.items[N] := NIL;
end;

Function TPool.SprExists(N : integer): boolean;
Begin
  IF GetSprite(N) = Nil then result := false else result := true;
end;

Procedure TPool.SetTrace(N: integer; b: boolean);
Var
  s : Tsprite;
Begin
  s:= GetSprite(N); IF s = NIL Then exit;
  IF b then setbit(trace, 1, s.sprState) else setbit(trace, 0, s.sprState);
end;

Procedure TPool.SetToon(N: integer; WName: STRING);
Var
  d : TToon;
  s : tsprite;
Begin
  s := GetSprite(n);
  If s <> NIL Then
  Begin
    d := Talbum(Palbum).getToon(WName);
    IF d = NIL Then
    begin
      s.Toon := Nil;
      Setbit(visible,0,S.sprState);
      exit;
    end;
    Setbit(visible,1,s.sprState);
    s.Toon := d;
    s.curimage := 0;
    s.dcx := d.Dwidth  DIV 2;
    s.dcy := d.Dheight DIV 2;
    s.Adjustlimits;
    setbit(modif,1,s.sprState);
  end;
end;

Function TPool.GetToonName(N : integer) : STRING;
Var
  s : Tsprite;
begin
  result := '';
  S := getsprite(N);
  IF S <> NIL then
   IF s.Toon <> Nil then
     result := Talbum(Palbum).getAlbumToonName(s.Toon);
end;

Function  Tpool.GetToonW(N: integer): integer;
Var
  s : tsprite;
Begin
  result := 0;
  s := GetSprite(n);
  If s <> NIL Then
    IF s.Toon <> Nil then result := s.Toon.Dwidth;
end;

Function  Tpool.GetToonH(N: integer): integer;
Var
  s : tsprite;
Begin
  result := 0;
  s := GetSprite(n);
  If s <> NIL Then
    IF s.Toon <> Nil then result := s.Toon.DHeight;
end;

Procedure Tpool.SetLoopctr(N, m : integer);
Var
  s : tsprite;
Begin
  s := GetSprite(n);
  If s <> NIL Then
  Begin
    s.Loopmax := abs(m);
    s.Loopctr := s.Loopmax;
  end;
end;

Function Tpool.GetLoopCtr(N : integer): integer;
Var
  s : tsprite;
Begin
  s := GetSprite(n);
  If s <> NIL Then result := s.Loopctr else result := 0;
end;

Procedure Tpool.SetDelayctr(N, m : integer);
Var
  s : tsprite;
Begin
  s := GetSprite(n);
  If s <> NIL Then s.Delayctr := abs(m);
end;

Function Tpool.GetDelayCtr(N : integer): integer;
Var
  s : tsprite;
Begin
  s := GetSprite(n);
  If s <> NIL Then result := s.Delayctr else result := 0;
end;

Function  Tpool.PtinSprite(pt: tpoint; marge: integer): integer;
var
  s : tsprite;
begin
  result := -1;
  If Last = Nil then exit else s := Last;
  Repeat
    if (pt.x > s.x+marge) And (pt.y > s.y+marge) And
    (pt.x+marge < S.x+s.toon.dwidth) and (pt.y+marge < s.y+s.toon.dheight) then
    begin
      result := s.Number;
      exit;
    end;
    s := s.prior;
  until s= nil;
end;

Procedure Tpool.Erasures;
Var
  s : Tsprite;
  d : TToon;
Begin
  If premier = Nil then exit else s := premier;
  Repeat
    IF getbit(active, s.sprstate) then
    begin
      d := s.Toon;
      IF d <> NIL Then
      Begin
        s.rcmodif := Bounds(s.x, s.y, s.rcimg.right, s.rcimg.bottom);
        IF getbit(trace, s.sprState) = false Then
        Begin
          With Talbum(Palbum) do
          Begin
            BmpMano.Canvas.CopyMode := cmSrcCopy;
            BmpMano.Canvas.CopyRect(s.rcmodif, BmpFont.Canvas, s.rcmodif);
          end;
        end;
      end;
    end;
    s := s.next;
  Until s = nil;
end;

Procedure Tpool.Travel;
Var
  s : Tsprite;
  d : TToon;
Begin
  If premier = Nil then exit else s := premier;
  Repeat
    d := s.Toon;
    IF (d <> Nil) AND getbit(modif, s.sprState) Then
    Begin
      s.rcimg.right  := s.Toon.dwidth;
      s.rcimg.bottom := s.Toon.dheight;
      setbit(modif, 0, s.sprState);
    end;
    IF getbit(active, s.sprState) Then
    Begin
      s.calculpos;
      IF S.Loopmax <> 0 Then
      Begin
         dec(s.Loopctr);
         IF s.Loopctr < 0 Then s.Loopctr := s.Loopmax;
      end;
    end;
    IF s.Delayctr > 0 then dec(s.Delayctr);
    s := s.next;
  Until s = nil;
end;

Procedure Tpool.PrepareCache;
Var
  s    : Tsprite;
  d    : TToon;
Begin
  If premier = Nil then exit else s := premier;
  Repeat
    IF getbit(active, s.sprstate) then
    begin
     d := s.Toon;
      IF getbit(visible, s.sprState) AND (d <> NIL) Then
      Begin
        s.rcmano := Bounds(s.x, s.y, d.DWidth, d.DHeight);
        WITH Talbum(Palbum).BmpMano.canvas DO
        Begin
          CopyMode := cmSrcAnd;
          CopyRect
            (s.rcmano, Tbitmap(d.Masks.items[s.curimage]).Canvas, s.rcImg);
          CopyMode := cmSrcpaint;
          copyrect
            (s.rcmano, Tbitmap(d.images.items[s.curimage]).Canvas, s.rcImg);
        end;
      end;
    end;
    s := s.next;
  until s = NIL;
end;

Procedure Tpool.Display;
Var
  s : Tsprite;
  d : TToon;
Begin
  Talbum(Palbum).cancan.copymode := cmSrccopy;
  If premier = Nil then exit else s := premier;
  Repeat
    IF getbit(active, s.sprState) Then
    begin
      d := s.Toon;
      IF getbit(visible, s.sprState) and (d <> NIL) Then
      Begin
         UnionRect(s.rcmodif, s.rcmodif, s.rcmano);
        With Talbum(Palbum) do
        begin
          cancan.CopyRect(s.rcmodif, BmpMano.Canvas, s.rcmodif);
        end;
      end;
    end;
    s := s.next;
  Until s = Nil;
end;

Procedure TPool.Animate;
Begin
  IF not albumdraw then
  begin
    Erasures;
    Travel;
    Preparecache;
    Display;
  end;
end;

Procedure TPool.AnimateMono(N : integer);
Var
  sn, s : Tsprite;
  d, dn : TToon;
  collisrect : trect;
Begin
  s := GetSprite(n);
  If s <> NIL Then
  begin
    d := s.Toon;
    IF d <> NIL Then
    Begin
      if getbit(modif, s.sprState) then
      s.rcmodif := Bounds(s.x, s.y, s.rcimg.right, s.rcimg.bottom)
      else
      s.rcmodif := Bounds(s.x, s.y, d.DWidth, d.DHeight);

      With Talbum(Palbum) do
      Begin
        BmpMano.Canvas.CopyMode := cmSrcCopy;
        BmpMano.Canvas.CopyRect(s.rcmodif, BmpFont.Canvas, s.rcmodif);
      end;

      sn := premier;
      Repeat
        if (sn <> s) and getbit(visible, sn.sprState) then
        begin
          dn := sn.Toon;
          sn.rcmodif := Bounds(sn.x, sn.y, dn.DWidth, dn.DHeight);
  {$Ifdef WIN32}
          IF intersectRect(collisrect, sn.rcmodif, s.rcmodif) Then
  {$else}
          IF intersectRect(collisrect, sn.rcmodif, s.rcmodif) <> 0 Then
  {$endif}
          begin
           sn.rcmano := Bounds(sn.x, sn.y, dn.DWidth, dn.DHeight);
           WITH Talbum(Palbum).BmpMano.canvas DO
           Begin
            CopyMode := cmSrcAnd;
            CopyRect (sn.rcmano,
                     Tbitmap(dn.Masks.items[sn.curimage]).Canvas, sn.rcImg);
            CopyMode := cmSrcpaint;
            copyrect (sn.rcmano,
                      Tbitmap(dn.images.items[sn.curimage]).Canvas, sn.rcImg);
           end;
          end;
        end;
        sn := sn.next;
      until sn = NIL;
      IF getbit(modif, s.sprState) AND (d <> NIL) Then
      Begin
        s.rcimg.right  := s.Toon.dwidth;
        s.rcimg.bottom := s.Toon.dheight;
        setbit(modif, 0, s.sprState);
      end;
      s.calculpos;
      IF S.Loopmax <> 0 Then
      Begin
         dec(s.Loopctr);
         IF s.Loopctr < 0 Then s.Loopctr := s.Loopmax;
      end;
      IF s.Delayctr > 0 then dec(s.Delayctr);


      s.rcmano := Bounds(s.x, s.y, d.DWidth, d.DHeight);
      WITH Talbum(Palbum).BmpMano.canvas DO
      Begin
        CopyMode := cmSrcAnd;
        CopyRect
          (s.rcmano, Tbitmap(d.Masks.items[s.curimage]).Canvas, s.rcImg);
        CopyMode := cmSrcpaint;
        copyrect
          (s.rcmano, Tbitmap(d.images.items[s.curimage]).Canvas, s.rcImg);
      end;
      Talbum(Palbum).cancan.copymode := cmSrccopy;
      UnionRect(s.rcmodif, s.rcmodif, s.rcmano);
      With Talbum(Palbum) do
      begin
        cancan.CopyRect(s.rcmodif, BmpMano.Canvas, s.rcmodif);
      end;
    end;
  end;
end;

Procedure TPool.SetLimits(N: integer; wrect : Trect);
Var
  s : Tsprite;
Begin
  s := GetSprite(n);
  If s <> NIL Then
  begin
    s.rcbounds := wrect;
    S.Adjustlimits;
  end;
end;

Procedure TPool.SetActive(N: integer; b: boolean);
Var
  s : Tsprite;
Begin
  s := GetSprite(n);
  If s <> NIL Then
    IF b then setbit(active, 1, s.sprState) else setbit(active, 0, s.sprState);
end;

Function TPool.IsActive(N: integer): boolean;
Var
  s : Tsprite;
Begin
  result := false;
  s := GetSprite(n);
  If s <> NIL Then result := Getbit(active, s.sprState);
end;

Procedure TPool.SetVisible(N: integer; b: boolean);
Var
  s : Tsprite;
Begin
  s:= GetSprite(n);
  IF s <> NIL Then
   IF b then setbit(visible,1, s.sprState) else setbit(visible,0, s.sprState);
end;

Function TPool.IsVisible(N: integer) : boolean;
Var
  s : Tsprite;
Begin
  Result := false;
  s := GetSprite(n);
  If s <> NIL Then result := Getbit(active, s.sprState);
end;

Procedure Tpool.Settag(N , atag: integer);
Var
  s : Tsprite;
Begin
  s := GetSprite(n);
  If s <> NIL Then s.sprtag := atag;
end;

Function  Tpool.Gettag(N : integer): integer;
Var
  s : Tsprite;
Begin
  result := 0;
  s := GetSprite(n);
  If s <> NIL Then result := s.sprtag;
end;


Procedure TPool.SetAnim(N: integer; Wcount: Integer);
Var
  s : Tsprite;
Begin
  s:= GetSprite(n);
  IF s <> NIL Then s.animloop := Wcount;
end;


Procedure Tpool.SetAnimstyle(N, Wstyle: integer);
Var
  s : Tsprite;
  d : ttoon;
  bmp1 : Tbitmap;

  procedure rot90;
  type
    TManoRGB  = packed record
                   rgb    : TRGBTriple;
                   dummy  : byte;
                 end;
    TRGBArray = ARRAY[0..0] OF TRGBTriple;
    pRGBArray = ^TRGBArray;
  var
    aStream : TMemorystream;
    header  : TBITMAPINFO;
    dc      : hDC;
    P       : ^TManoRGB;
    RowOut:  pRGBArray;
     x,y,h,w: Integer;
  BEGIN
    IF Bmp1.empty then exit;
    bmp1.pixelformat := pf24bit;
    aStream := TMemoryStream.Create;
    aStream.SetSize(Bmp1.Height*Bmp1.Width * 4);
    with header.bmiHeader do begin
      biSize := SizeOf(TBITMAPINFOHEADER);
      biWidth := Bmp1.Width;
      biHeight := Bmp1.Height;
      biPlanes := 1;
      biBitCount := 32;
      biCompression := 0;
      biSizeimage := aStream.Size;
      biXPelsPerMeter :=1;
      biYPelsPerMeter :=1;
      biClrUsed :=0;
      biClrImportant :=0;
    end;
    dc := GetDC(0);
    P  := aStream.Memory;

    GetDIBits(dc,Bmp1.Handle,0,Bmp1.Height,P,header,dib_RGB_Colors);
    ReleaseDC(0,dc);
    w := bmp1.height;
    h := bmp1.width;
    bmp1.Width  := w;
    bmp1.height := h;
    for y := 0 to (h-1) do
    begin
      rowOut := Bmp1.ScanLine[y];
      P  := aStream.Memory;
      inc(p,y);
      for x := 0 to (w-1) do
      begin
        rowout[x] := p^.rgb;
        inc(p,h);
      end;
    end;
    aStream.Free;
  end;

begin
  s:= GetSprite(n);
  IF s <> NIL Then
  Begin
    IF Wstyle > 3 then wstyle := 3;
    if wstyle < 0  then wstyle := 0;
    d := s.toon;
    IF d <> NIL Then
    begin
      bmp1 := Tbitmap(d.images.items[0]);
      repeat
        inc(s.animstyle);
        if s.animstyle > 3 then s.animstyle := 0;
        rot90;
      until s.animstyle = wstyle;
      d.dwidth  := bmp1.width;
      d.dheight := bmp1.height;
      Tbitmap(d.Masks.items[0]).width  := d.dwidth;
      Tbitmap(d.Masks.items[0]).height := d.dheight;
      Domasque(Bmp1, TBitmap(d.Masks.items[0]), d.dwidth, d.dheight, clblack);
      setbit(modif,1,s.sprState);
    end;
  end;
end;

Function  TPool.getcurimage(N: integer): integer;
Var
  s : Tsprite;
Begin
  s:= GetSprite(n);
  IF s <> NIL Then result := s.animstyle else result := 0;
end;

Procedure Tpool.Setpriority(N , p : integer);
Var
  s : Tsprite;
Begin
  s:= GetSprite(n);
  IF s <> NIL Then
  Begin
    s.priority := p;
    Unleashsprite(s);
    chainsprite(s);
  end;
end;

Procedure Tpool.SetpriorityLast(N , p : integer);
Var
  s : Tsprite;
Begin
  s:= GetSprite(n);
  IF s <> NIL Then
  Begin
    s.priority := p;
    Unleashsprite(s);
    chainLast(s);
  end;
end;


Function  Tpool.Getpriority(N : integer): integer;
Var
  s : Tsprite;
Begin
  s:= GetSprite(n);
  IF s <> NIL Then result := s.priority else result := 0;
end;


Procedure TPool.SetPos(N, wx, wy: integer);
Var
  s : Tsprite;
Begin
  s:= GetSprite(n);
  IF s <> NIL Then
  Begin
    s.xx := trunc(wx);
    s.yy := trunc(wy);
  end;
end;

Function  TPool.getposx(N: integer): integer;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL Then result := trunc(s.xx) else result := 0;
end;

Function  TPool.getposy(N: integer): integer;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL Then result := trunc(s.yy) else result := 0;
end;

Function   TPool.Getdcx(N: integer): integer;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL Then result :=  s.dcx else result := 0;
end;

Function   TPool.Getdcy(N: integer): integer;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL Then result := s.dcy else result := 0;
end;

Procedure TPool.SetV(N: integer; Wvx, Wvy: single);
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL Then
  Begin
    s.vx := wvx;
    s.vy := wvy;
  end;
end;

Function  TPool.getvx(N: integer): single;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL Then result := s.vx else result := 0;
end;

Function  TPool.getvy(N: integer): single;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL Then result := s.vy else result := 0;
end;


Function  TPool.SameXdirection(N: integer): boolean;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  result := true;
  IF s <> NIL Then IF s.vx * s.oldvx < 0 Then result := false;
end;

Function  TPool.SameYdirection(N: integer): boolean;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  result := true;
  IF s <> NIL Then IF s.vy * s.oldvy < 0 Then result := false;
end;

Procedure TPool.SetAccel(N: integer; Wax, Way : single);
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL  Then
  Begin
    s.ax := wax;
    s.ay := way;
  end;
end;

Procedure Tpool.SetkV(n: integer; kvx, kvy : single);
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL  Then
  Begin
    s.kvx := abs(kvx);
    s.kvy := abs(kvy);
  end;
end;

Procedure Tpool.Stop(n : integer);
Var
 s : Tsprite;
begin
  s := getsprite(n);
  IF s <> NIL  Then
  Begin
    s.vx := 0;
    s.vy := 0;
    s.ax := 0;
    s.ay := 0;
    s.kvx := 1;
    s.kvy := 1;
    s.animloop := 0;
  end;
end;

Function TPool.getax(N: integer): single;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL  Then result := s.ax else result := 0;
end;

Function  TPool.getay(N: integer): single;
Var
  s : Tsprite;
Begin
  s := getsprite(n);
  IF s <> NIL Then result := s.ay else result := 0;
end;

Function  Tpool.Getaxvnull(N, x1 : integer): single;
Var
  s : Tsprite;
  b , d: single;
Begin
  s := getsprite(n);
  result := 0;
  IF s = NIL Then exit;
  IF abs(s.vx) < 0.00001 then exit;
  d := x1 - s.xx;
  d := d + s.vx;
  if abs(d) < 2 then exit;
  if (abs(s.vx)*3) > abs(d) then exit;
  result :=  - (s.vx*s.vx) / (2*d);
  b := (2*d) / s.vx;
  s.Loopmax := round(b);
  s.Loopctr := s.Loopmax;
end;

Function  Tpool.Getayvnull(N, y1 : integer): single;
Var
  s : Tsprite;
  b , d : single;
Begin
  s := getsprite(n);
  result := 0;
  IF s = NIL Then exit;
  IF abs(s.vy) < 0.00001 then exit;
  d := y1 - s.yy;
  d := d+s.vy;
  if abs(d) < 2 then exit;
  if (abs(s.vy)*3) > abs(d) then exit;
  result :=  - (s.vy*s.vy) / (2*d);
  b := (2*d) / s.vy;
  s.Loopmax := round(b);
  s.Loopctr := s.Loopmax;
end;

Procedure TPool.Gotoxy(N, wx, wy, Loops : integer);
Var
  s : Tsprite;
  wdx, wdy, wb : single;
Begin
  s := getsprite(n);
  IF (s = NIL) OR (loops < 1) Then exit;
  s.kvx := 1; s.kvy := 1;
  wb := loops;
  s.ax := -s.vx *2 / wb;
  s.ay := -s.vy *2 / wb;
  wdx := wx;
  wdy := wy;
  wdx := wdx - s.xx;
  wdy := wdy - s.yy;
  s.vx := s.vx+wdx / wb;
  s.vy := s.vy+wdy / wb;
end;


Function Tpool.Getoffsetx(N : integer): integer;
var
  s : Tsprite;
begin
  result:= 0;
  s := GetSprite(N);
  If s <> NIL Then result := s.Toon.origpt.x;
end;

Function Tpool.Getoffsety(N : integer): integer;
var
  s : Tsprite;
begin
  result:= 0;
  s := GetSprite(N);
  If s <> NIL Then result := s.Toon.origpt.y;
end;

Procedure Tpool.Setoffset(N , wx, wy : integer);
var
  s : Tsprite;
begin
  s := GetSprite(N);
  If s <> NIL Then
  begin
    s.Toon.origpt.x := wx;
    s.Toon.origpt.y := wy;
  end;
end;

Begin
  initrandom;
end.
