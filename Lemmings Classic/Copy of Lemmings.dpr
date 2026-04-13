Program Lemmings;

{ Lemmings - Windows CE port by Jacco Bikker, a.k.a.
  "The Phantom"  -   Intended as a demonstration of
   EasyCE - Visit http://www.cewarez.com/coding
 --------------------------------------------------
 Pascal version by Paul TOTH <tothpaul@free.fr>
 http://tothpaul.free.fr

 because of lots of copy/past in Jacco's code, I've change the code a lot :)
}

{$R Jacco1.RES}

(******** Windows specific Informations ****************)
{$IFDEF WIN32}
{-$DEFINE VGA}
{$DEFINE PATH}
uses
 windows,messages,mmsystem;

Type
 TBMP256=packed record

  bfType:packed array[1..2] of char;
  bfSize:LongInt;
  brReserved:LongInt;
  bgOffBits:LongInt;

  biSize:LongInt;
  biWidth:LongInt;
  biHeight:LongInt;
  biPlanes:word;
  biBitCount:word;
  biCompression:longint;
  biSizeImage:longint;
  biXPelsPerMeter:longint;
  biYPelsPerMeter:longint;
  biClrUsed:Longint;
  biClrImportant:longint;

  colors:packed array[#0..#255] of integer;

  data:byte;
 end;

var
 Colors:packed array[0..255,0..3] of byte;
 click:boolean=false;
 clickxpos:integer;
 clickypos:integer;

function clicked(var x,y:integer):boolean;
 begin
  result:=click;
  if result then begin
   x:=clickxpos;
   y:=clickypos;
   click:=false;
  end;
 end;

function LoadBMP(Name:string; dst:pointer):pointer;
 var
  r,m:integer;
  b:^TBMP256;
  x,y:integer;
  i:^integer;
  p:pchar;
 begin
  r:=FindResource(hInstance,PChar(Name),RT_RCDATA);
  m:=LoadResource(hInstance,r);
  b:=LockResource(m);
  if dst<>nil then result:=dst else GetMem(result,b.biSizeImage*4);
  i:=result;
  p:=@b.data;
  for y:=1 to b.BiHeight do
   for x:=0 to b.biWidth-1 do begin
    i^:=b.colors[p[(b.biHeight-y)*b.BiWidth+x]];
    inc(i);
   end;
 end;

const
 ClassName='JaccoLemmingsCE';

Type
 TPalette256=packed record
  Version:word;
  Entries:word;
  Colors:packed array[0..255] of integer;
 end;

 TBitmapInfo=packed record
  Header:TBitmapInfoHeader;
  Colors:packed Array[0..255] of Word;
 end;

 TPixels=packed array[0..319,0..239] of integer;

var
 win:THandle;
 hdc:THandle;
 pal:THandle;
 Border,Caption:integer;
 Width,Height:integer;
 BitmapInfo  :TBitmapInfo;
 Pixels      :TPixels;
 msecs:integer;

procedure Play(Wav:string);
 var
  r,m:integer;
  p:pchar;
 begin
  r:=FindResource(hInstance,PChar(Wav),RT_RCDATA);
  m:=LoadResource(hInstance,r);
  p:=LockResource(m);
  PlaySound(p,hInstance,SND_MEMORY or SND_ASYNC);
  FreeResource(m); // can I do this ?!
 end;

procedure Paint;
 begin
  StretchDiBits(hdc, 0,0,Width,Height, 0,0,240,320, @Pixels,PBitmapInfo(@BitmapInfo)^, 0, SRCCOPY);
 end;

Function WinProc(hWnd: THandle; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
 begin
  Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  Case Msg of
   WM_SIZE    : begin
                 Width :=LOWORD(lParam);
                 Height:=HIWORD(lParam);
                 Paint;
                end;

   WM_LBUTTONDOWN : if (width<>0) and (height<>0) then begin
                     clickxpos:=(240*LOWORD(lParam)) div Width;
                     clickypos:=(320*HIWORD(lParam)) div Height;
                     click:=true;
                    end;

   WM_PAINT   : Paint;

   WM_TIMER   : inc(msecs,10);

   WM_DESTROY : PostQuitMessage(0);
  end;
 end;

procedure TextMode;
 begin
  KillTimer(win,1);
  ReleaseDC(win,hdc);
  DestroyWindow(win);
 {$IFDEF VGA}
  ChangeDisplaySettings(TDeviceMode(nil^),0);
 {$ENDIF} 
 end;

procedure DoEvents;
 var
  msg:TMsg;
 begin
  while PeekMessage(Msg,0,0,0,pm_remove) do begin
   TranslateMessage(msg);    { Translates virtual key codes. }
   DispatchMessage(msg);     { Dispatches message to window. }
   if msg.Message=WM_QUIT then begin
    TextMode;
    halt;
   end;
  end;
 end;

procedure GraphMode;
 var
  wc :TWndClass;
  i  :integer;
 {$IFDEF VGA}
  Device:TDeviceMode;
 {$ENDIF}
 begin
 { Register the window class for my window. }
  wc.style :=  0; // CS_SAVEBITS;            { Class style. }
  wc.lpfnWndProc := @WinProc;          { Window procedure for this class. }
  wc.cbClsExtra := 0;                  { No per-class extra data. }
  wc.cbWndExtra := 0;                  { No per-window extra data. }
  wc.hInstance := hInstance;           { Application that owns the class. }
  wc.hIcon := LoadIcon(hInstance,'Form1');  { Delphi icon }
  wc.hCursor := LoadCursor(0, IDC_ARROW); { defaut cursor }
  wc.hbrBackground := 0; // GetStockObject(BLACK_BRUSH); { black screen }
  wc.lpszMenuName := nil; // 'MainMenu';       { Name of menu resource in .RC file. }
  wc.lpszClassName := ClassName;      { Name used in call to CreateWindow. }
  if RegisterClass(wc)=0 then halt;

  With BitmapInfo do begin
   with header do begin
    biSize         :=SizeOf(TBitmapInfoHeader);
    biWidth        := 240;
    biHeight       :=-320;
    biplanes       :=1;
    bibitcount     :=32;
    bicompression  :=BI_RGB;
    biSizeImage    :=320*240;
    bixpelspermeter:=0;
    biypelspermeter:=0;
    biclrused      :=0;
    biclrimportant :=0;
   end;
  end;
 {$IFDEF VGA} // 640x480
  With Device do begin
   dmSize:=SizeOf(TDeviceMode);
   dmPelsWidth :=640;
   dmPelsHeight:=480;
   dmBitsPerPel:=32;
   dmFields:=DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL;
  end;
  ChangeDisplaySettings(Device,CDS_FULLSCREEN);
 {$ENDIF} 

  Border :=2*(GetSystemMetrics(SM_CXDLGFRAME)+GetSystemMetrics(SM_CXBORDER));
  Caption:=GetSystemMetrics(SM_CYCAPTION);
  win:= CreateWindow(
   ClassName,  { registered class name }
   'Lemmings by Paul TOTH',
   WS_OVERLAPPEDWINDOW or ws_visible,   { Window style. }
   (GetSystemMetrics(SM_CXFULLSCREEN)-320) div 2, // cw_usedefault,         { Default horizontal position. }
   (GetSystemMetrics(SM_CYFULLSCREEN)-200) div 2, // cw_usedefault,         { Default vertical position. }
   240+Border,
   320+Border+Caption,
   0,                     { Overlapped windows have no parent. }
   0,                     { Use the window class menu. }
   hInstance,             { This instance owns this window. }
   nil                    { Pointer not needed. }
  );
  if win=0 then halt;
  hdc:=GetDC(win);

  msecs:=0;
  SetTimer(win,1,10,nil);
 end;

Procedure Update;
 begin
  Paint;
  DoEvents;
 end;

procedure bar(x1,y1,x2,y2,c:integer);
 var
  x,y:integer;
 begin
  x:=x2-x1+1;
  for y:=y1 to y2 do
   for x:=x1 to x2 do pixels[y,x]:=c;
 end;

const
 m_Chr:array[0..53,0..6,0..7] of char=(
        ( { 0}'oooo:::','oo:oo::','oo::oo:','oo:::oo','ooooooo','oo:::oo','oo:::oo' ),
	( { 1}'oooo:::','oo:oo::',':oo::::','ooooo::','oo::oo:','oo:::oo','oooooo:' ),
	( { 2}'::ooooo',':oo::::','oo:::::','oo:::::','oo:::::','oo:::::',':oooooo' ),
	( { 3}'oooo:::','oo:oo::','oo::oo:','oo:::oo','oo:::oo','oo:::oo','oooooo:' ),
	( { 4}'ooooooo','oo:::::','oo:::::','ooooooo','oo:::::','oo:::::','ooooooo' ),
	( { 5}'ooooooo','oo:::::','oo:::::','ooooo::','oo:::::','oo:::::','oo:::::' ),
	( { 6}'::oooo:',':oo::::','oo:::::','oo:oooo','oo:::oo','oo:::oo',':oooooo' ),
	( { 7}'oo::::o','oo::::o','oo::::o','ooooooo','oo::::o','oo::::o','oo::::o' ),
	( { 8}'::oooo:',':::oo::',':::oo::',':::oo::',':::oo::',':::oo::','::oooo:' ),
	( { 9}'::ooooo',':::::oo',':::::oo',':::::oo','oo:::oo',':oo:oo:','::ooo::' ),
	( {10}'oo::oo:','oo:oo::','oooo:::','ooo::::','ooooo::','oo::oo:','oo:::oo' ),
	( {11}'oo:::::','oo:::::','oo:::::','oo:::::','oo:::::','oo:::::','ooooooo' ),
	( {12}'o:::::o','oo:::oo','ooo:ooo','ooooooo','oo:o:oo','oo:::oo','oo:::oo' ),
	( {13}'oo:::oo','ooo::oo','oooo:oo','oo:oooo','oo::ooo','oo:::oo','oo:::oo' ),
	( {14}'::ooo::',':oo:oo:','oo:::oo','oo:::oo','oo:::oo','oo:::oo',':ooooo:' ),
	( {15}'ooooo::','oo::oo:','oo:::oo','oo:::oo','oooooo:','oo:::::','oo:::::' ),
	( {16}'::ooo::',':oo:oo:','oo:::oo','oo:o:oo','oo:oooo','oo::oo:',':ooo:oo' ),
	( {17}'ooooo::','oo::oo:','oo:::oo','oooooo:','oo:oo::','oo::oo:','oo:::oo' ),
	( {18}'::ooooo',':oo::::','oo:::::','ooooooo',':::::oo','::::oo:','ooooo::' ),
	( {19}'ooooooo',':::oo::',':::oo::',':::oo::',':::oo::',':::oo::',':::oo::' ),
	( {20}'oo:::oo','oo:::oo','oo:::oo','oo:::oo','oo:::oo','oo::oo:',':oooo::' ),
	( {21}'oo:::oo','oo:::oo',':oo:oo:',':oo:oo:','::ooo::','::ooo::',':::o:::' ),
	( {22}'oo:::oo','oo:::oo','oo:::oo','oo:::oo','oo:o:oo',':ooooo:','::o:o::' ),
	( {23}'oo::::o',':oo::oo','::oooo:',':::oo::','::oooo:',':oo::oo','oo::::o' ),
	( {24}'oo::::o',':oo::oo','::oooo:',':::oo::',':::oo::',':::oo::',':::oo::' ),
	( {25}'ooooooo','::::oo:',':::oo::','::oo:::',':oo::::','oo:::::','ooooooo' ),
	( {26}':ooooo:','oo:::oo','oo:::oo',':::::::','oo:::oo','oo:::oo',':ooooo:' ),
	( {27}':::::::',':::::oo',':::::oo',':::::::',':::::oo',':::::oo',':::::::' ),
	( {28}':ooooo:',':::::oo',':::::oo',':ooooo:','oo:::::','oo:::::',':ooooo:' ),
	( {29}':ooooo:',':::::oo',':::::oo',':ooooo:',':::::oo',':::::oo',':ooooo:' ),
	( {30}':::::::','oo:::oo','oo:::oo',':ooooo:',':::::oo',':::::oo',':::::::' ),
	( {31}':ooooo:','oo:::::','oo:::::',':ooooo:',':::::oo',':::::oo',':ooooo:' ),
	( {32}':ooooo:','oo:::::','oo:::::',':ooooo:','oo:::oo','oo:::oo',':ooooo:' ),
	( {33}':ooooo:',':::::oo',':::::oo',':::::::',':::::oo',':::::oo',':::::::' ),
	( {34}':ooooo:','oo:::oo','oo:::oo',':ooooo:','oo:::oo','oo:::oo',':ooooo:' ),
	( {35}':ooooo:','oo:::oo','oo:::oo',':ooooo:',':::::oo',':::::oo',':ooooo:' ),
	( {36}':::::::',':::::::',':::o:::',':::::::',':::::::',':::o:::',':::::::' ),
	( {37}':::oo::',':::oo::',':::oo::',':::oo::',':::::::',':::oo::',':::oo::' ),
	( {38}':oooo::','::::oo:','::::oo:',':::oo::',':::::::','::oo:::','::oo:::' ),
	( {39}':::::::',':::::::',':::::::','::oooo:',':::::::',':::::::',':::::::' ),
	( {40}':::::::',':::::::',':::::::',':ooooo:',':::::::',':ooooo:',':::::::' ),
	( {41}':::::::',':::o:::',':::o:::',':::o:::',':::o:::',':::o:::',':::::::' ),
	( {42}'::ooo::','::o::::','::o::::','::o::::','::o::::','::o::::','::ooo::' ),
	( {43}'::ooo::','::::o::','::::o::','::::o::','::::o::','::::o::','::ooo::' ),
	( {44}':::::::',':::::::',':::::::',':::::::',':::::::',':::::::',':::::::' ),
	( {45}':::::::',':::::::',':::::::',':::::::',':::::::',':::oo::',':::oo::' ),
	( {46}':::::::',':::::::',':::::::',':::::::','::::o::','::::o::',':::o:::' ),
	( {47}':o:::::','::o::::',':::o:::','::::o::',':::o:::','::o::::',':o:::::' ),
	( {48}'::::o::',':::o:::','::o::::',':o:::::','::o::::',':::o:::','::::o::' ),
	( {49}'ooooooo','ooooooo','ooooooo','ooooooo','ooooooo','ooooooo','ooooooo' ),
	( {50}':::o:::',':::o:::','::o::::',':::::::',':::::::',':::::::',':::::::' ),
	( {51}'::ooo::',':o:::o:','o::oo:o','o:o:::o','o::oooo',':o:::::','::oooo:' ),
	( {52}'::::::o',':::::o:','::::o::',':::o:::','::o::::',':o:::::','o::::::' ),
	( {53}'o::::::',':o:::::','::o::::',':::o:::','::::o::',':::::o:','::::::o' )
 );
procedure print(s:string;x,y,c:integer);
 var
  i:integer;
  a:integer;
  h,v:integer;
 begin
  for i:=1 to length(s) do begin
                     //          1         2         3         4         5         6
                     //0....:....0....:....0....:....0....:....0....:....0'...'.:....0
   a:=pos(s[i],'abcdefghijklmnopqrstuvwxyz0123456789:!?-=+[] .,><#''@/S'#8#10#13)-1;
   case i of
    0..53: begin
      for h:=0 to 7 do
       for v:=0 to 6 do
        if m_Chr[a,v,h]='o' then Pixels[y+v,x+h]:=c;
      inc(x,8);
      if x>320 then begin
       x:=2;
       if y<300 then inc(y,9);
      end;
    end;
    54   : if x>8 then dec(x,8); // #8
    55,56: x:=0;               // #10 #13
   end;
  end;
 end;

{$ENDIF}
(*******************************************************)

{-$DEFINE TEST}

{$IFDEF TEST}
begin
 graphmode;
 LoadBMP('Title',@Pixels);
 while true do doevents;
end.
{$ELSE}

Type
 LAnim=class
  public
   Constructor Create{$IFDEF PATH}(i:integer){$ENDIF};
   Destructor Destroy;
  {$IFNDEF PATH}
   procedure setfpos(i,x,y:integer);
   procedure setsize(x,y:integer);
   procedure setframes(n:integer);
   function getframes:integer;
  {$ENDIF}
   procedure update(x,y,frame:integer);
  private
  {$IFDEF PATH}
   index:integer;
  {$ELSE}
   m_Frames:integer;
   m_Fx,m_Fy:array[0..31] of integer;
   m_Fszx,m_Fszy:integer;
  {$ENDIF}
  public
//   s_Frames:^TPixels;
  end;
{$IFNDEF PATH}
procedure LAnim.setfpos(i,x,y:integer); begin m_Fx[i]:=x; m_Fy[i]:=y; end;
procedure LAnim.setsize(x,y:integer); begin m_Fszx:=x; m_Fszy:=y; end;
procedure LAnim.setframes(n:integer); begin m_Frames:=n; end;
function LAnim.getframes:integer; begin getframes:=m_Frames; end;
{$ENDIF}
Type
 Lemming=class
  public
   Constructor Create;
   Destructor Destroy;
   procedure setpos(x,y:integer);
   procedure setanim(a:LAnim);
   function getanim:LAnim;
   procedure update;
   procedure draw;
   function getxpos:integer;
   function getypos:integer;
   function getframe:integer;
   procedure setframe(i:integer);
   procedure setcounter(i:integer);
   function getcounter:integer;
   procedure isfloater;
   procedure isclimber;
   procedure isbomb;
   function getbomb:boolean;
   function getfloat:boolean;
  private
   m_X,m_Y:integer;
   m_Counter, m_BCount, m_Height:integer;
   m_Frame:integer;
   m_Floater, m_Climber, m_Bomb:boolean;
   m_Anim:LAnim;
  end;

procedure Lemming.setpos(x,y:integer); begin m_X:=x; m_Y:=y; end;
procedure Lemming.setanim(a:LAnim); begin m_Anim:=a; end;
function Lemming.getanim:LAnim; begin getanim:=m_Anim; end;
function Lemming.getxpos:integer; begin getxpos:=m_X; end;
function Lemming.getypos:integer; begin getypos:=m_Y; end;
function Lemming.getframe:integer; begin getframe:=m_Frame; end;
procedure Lemming.setframe(i:integer); begin m_Frame:=i; end;
procedure Lemming.setcounter(i:integer); begin m_Counter:=i; end;
function Lemming.getcounter:integer; begin getcounter:=m_Counter; end;
procedure Lemming.isfloater; begin m_Floater:=true; end;
procedure Lemming.isclimber; begin m_Climber:=true; end;
procedure Lemming.isbomb; begin if not m_Bomb then begin m_Bomb:=true; m_BCount:=6*8; end; end;
function Lemming.getbomb:boolean; begin getbomb:=m_Bomb; end;
function Lemming.getfloat:boolean; begin getfloat:=m_Floater; end;

const
 FLAKES=400; { number of snowflakes in level 1 }

var
 walkleft,   walkright,   fallleft,  fallright, stopper:LAnim;
 bridgeleft, bridgeright, bomber,    digger,    axeman :LAnim;
 floatleft,  floatright,  bashleft,  bashright         :LAnim;
 digleft,    digright,    climbleft, climbright        :LAnim;
 edgeleft,   edgeright,   countdown, dropdead          :LAnim;
 waitleft,   waitright,   goingin                      :LAnim;
Type
 TAnimPixels=packed array[0..353,0..255] of integer;
const
 f :^TAnimPixels=nil;
var
 OffScr:TPixels;
const
 b1:^TPixels=nil;
 b2:^TPixels=nil;
 command:integer=0;
 lactive:integer=0;
 startx :integer=100;
 starty :integer=100;
 snow   :boolean=false;
var
 paused:boolean;
const
 confirm:boolean=false;
 armageddon:boolean=false;
var
 rate,lmax,snupd,ex1,ey1,ex2,ey2:integer;
const
 comcount:array[0..10] of integer=(20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20);
var
 snx,sny:array[0..FLAKES-1] of integer;
(*// Statics (hey, who cares:)
unsigned short* LAnim::s_Frames = 0; // Ptr to anim image data
LAnim* walkleft, *walkright, *fallleft, *fallright, *stopper;
LAnim* bridgeleft, *bridgeright, *bomber, *digger, *axeman;
LAnim* floatleft, *floatright, *bashleft, *bashright;
LAnim* digleft, *digright, *climbleft, *climbright;
LAnim* edgeleft, *edgeright, *countdown, *dropdead;
LAnim* waitleft, *waitright, *goingin; // Available anims
unsigned short* p = 0; // Framebuffer pointer
unsigned short* f = 0; // Anim image data
unsigned short* t = 0; // Temporary image buffer
unsigned short* b1 = 0, *b2 = 0; // Button image data
int command = 0; // Selected command
int lactive = 0; // Number of lemmings active
int startx = 100, starty = 100; // Default spawn pos of lemmings
bool snow, paused = false, confirm = false, armageddon = false;
int rate, lmax, snupd, ex1, ey1, ex2, ey2;
int comcount[11] = { 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20 };
int snx[FLAKES], sny[FLAKES];
*)

Constructor Lemming.Create;
 begin
  m_Anim:=nil;
  m_Frame:=0;
  m_Floater:=false;
  m_Climber:=false;
  m_Bomb:=false;
 end;

Destructor Lemming.Destroy;
 begin
 end;

function val(n:integer):integer;
 var
  v1,v2,v3:integer;
 begin
 (*
  v1:=(n and (31 shl 11)) shr 11;
  v2:=(n and (63 shl  5)) shr  6;
  v3:=(n and  31);
 *)
  v1:=(n shr (2*8+3)) and 31;
  v2:=(n shr (1*8+3)) and 31;
  v3:=(n shr (0*8+3)) and 31;
  val:=(v1+v2+v3)*3;

 end;

procedure Lemming.update;
 var
  buff:^TPixels;
  wrt :^TPixels;
  hitground:boolean;
  sx,sy:integer;
  src  :^TAnimPixels;
  i    :integer;
  ready:boolean;
 begin
  if m_Anim=nil then exit;
  buff:=@Pixels[m_Y,m_X+5];//@p^[m_X+5+m_Y*240];
  wrt :=@OffScr[m_Y,m_X+5];//@t^[m_X+5+m_Y*240];
  if (m_Anim = walkleft) then begin
   dec(m_X); buff:=@Pixels[m_Y,m_X+5];
   if val(buff[9,0])>40 then begin
    dec(m_Y);
    if val(buff[8,0])>40 then begin
     dec(m_Y);
     if val(buff[7,0])>40 then begin
      dec(m_Y);
      if val(buff[6,0])>40 then begin
       if m_Climber then begin
        inc(m_Y,3);
        inc(m_X,2);
        m_Anim:=climbleft;
       end else begin
        m_Anim:=walkright;
        inc(m_Y,3);
       end;
      end;
     end;
    end;
   end else
   if val(buff[10,0])<40 then begin
    inc(m_Y);
    if val(buff[11,0])<40 then begin
     inc(m_Y);
     if val(buff[12,0])<40 then begin
      inc(m_Y);
      if val(buff[12,0])<40 then begin
       if m_Floater then begin
        dec(m_Y,5);
        m_Anim:=floatleft;
        m_Frame:=0;
       end else begin
        m_Anim:=fallleft;
        m_Height:=m_Y;
       end;
      end;
     end;
    end;
   end;
  end else
  if (m_Anim=walkright) then begin
   inc(m_X);
   //inc(buff);
   buff:=@Pixels[m_Y,m_X+5];
   if val(buff[9,0]) > 40 then begin
    dec(m_Y);
    if val(buff[8,0]) > 40 then begin
     dec(m_Y);
     if val(buff[7,0]) > 40 then begin
      dec(m_Y);
      if val(buff[6,0]) > 40 then begin
       if m_Climber then begin
        inc(m_Y,3);
	dec(m_X,2);
	m_Anim:=climbright;
       end else begin
        m_Anim:=walkleft;
	inc(m_Y,3);
       end;
      end;
     end;
    end;
   end else
   if val(buff[10,0]) < 40 then begin
    inc(m_Y);
    if val(buff[11,0]) < 40 then begin
     inc(m_Y);
     if val(buff[12,0]) < 40 then begin
      inc(m_Y);
      if val(buff[13,0]) < 40 then begin
       if m_Floater then begin
        m_Anim := floatright;
	m_Frame:= 0;
	dec(m_Y,6);
       end else	begin
        m_Anim := fallright;
	m_Height:= m_Y;
       end;
      end;
     end;
    end;
   end;
  end else
  if m_Anim=floatleft then begin
   if val(buff[16,0])<40 then
    inc(m_Y)
   else begin
    m_Anim:=walkleft;
    inc(m_Y,6);
   end;
  end else
  if m_Anim=fallleft then begin
   hitground:=false;
   if m_Floater then m_Anim:=floatleft;
   if val(buff[10,0])<40 then begin
    inc(m_Y);
    if val(buff[11,0])<40 then begin
     inc(m_Y);
     if val(buff[11,0])<40 then inc(m_Y) else hitground:=true;
    end else begin
     hitground:=true;
    end;
   end else begin
    hitground:=true;
   end;
   if hitground then begin
    if ((m_Y - m_Height) < 40) then m_Anim := walkleft else m_Anim := dropdead;
   end;
  end else
  if (m_Anim = floatright ) then begin
   if val(buff[16,0]) < 40 then
    inc(m_Y)
   else begin
    m_Anim := walkright;
    inc(m_Y,6);
   end;
  end else
  if (m_Anim = fallright ) then begin
   hitground := false;
   if (m_Floater) then m_Anim := floatright;
   if val(buff[10,0]) < 40 then begin
    inc(m_Y);
    if val(buff[11,0]) < 40 then begin
     inc(m_Y);
     if val(buff[11,0]) < 40 then inc(m_Y) else hitground:=true;
    end	else begin
     hitground := true;
    end;
   end else begin
    hitground := true;
   end;
   if (hitground) then begin
    if ((m_Y - m_Height) < 40) then m_Anim:=walkright else m_Anim:=dropdead;
   end;
  end else
  if (m_Anim = stopper) then begin
   { Do nothing special }
  end else
  if (m_Anim = bridgeleft) then begin
   if (m_Frame = 9) and (m_Counter < 4) then play('Ting');
   if (m_Frame = 15) then begin
    dec(m_Counter);
    if (m_Counter > 0) then begin
     wrt[11,240-2]:=65535;
     wrt[11,240-1]:=65535;
     wrt[12,0    ]:=65535;
     dec(m_X,2);
     dec(m_Y,1);
     if val(buff[11,240-1]) > 40 then begin
      m_Anim := walkright;
      inc(m_Y,3);
     end;
    end else begin
     m_Anim := waitleft;
     m_Frame:= 0;
    end;
   end;
  end else
  if (m_Anim = bridgeright) then begin
   if (m_Frame = 15) then begin
    dec(m_Counter);
    if (m_Counter > 0) then begin
     wrt^[12,2]:=65535;
     wrt^[12,3]:=65535;
     wrt^[12,4]:=65535;
     inc(m_X,2);
     dec(m_Y,1);
     if val(buff[12,3]) > 40 then begin
      m_Anim := walkleft;
      inc(m_Y,3);
     end;
    end else begin
     m_Anim := waitright;
     m_Frame:= 0;
    end;
   end;
  end else
  if (m_Anim = bomber) then begin
   if (m_Frame = 1) then play('OhNo');
   if (m_Frame = 15) then begin
    play('Explode');
    for sy := 0 to 22 do begin
     src := @f[sy+1,133];
     for sx := 0 to 16 do
      if src[0,sx]<>0 then wrt[sy-5,sx+240-8]:=0;
    end;
   end;
   if (m_Frame = 31) then begin
    m_Anim:=nil;
    dec(lactive);
   end;
  end else
  if (m_Anim = digger) then begin
   if (m_Frame = 15) then begin
    for i:=0 to 8 do begin
     wrt[11,239 - 4 + i] := 0;
     wrt[12,236 + i] := 0;
    end;
    for i:=0 to 7 do wrt[12, 477 + i] := 0;
    inc(m_Y,2);
    if val(buff[14,0]) < 40 then begin
     m_Anim := walkleft;
     dec(m_Y,4);
    end;
   end;
  end else
  if (m_Anim = bashleft) then begin
   if ((m_Frame >  9) and (m_Frame < 14)) then dec(m_X);
   if ((m_Frame > 25) and (m_Frame < 30)) then dec(m_X);
   ready:=true;
   for sy:=0 to 9 do begin
    if buff[sy,240- 4] > 40 then begin
     ready := false;
     break;
    end;
   end;
   if (ready) then m_Anim := walkleft;
   for sy := 0 to 9 do begin
    src:=@f[sy,177];
    for sx:=0 to 9 do if src[0,sx]<>0 then wrt[sy-1,sx+240-4]:= 0;
   end;
  end else
  if (m_Anim = bashright) then begin
   if ((m_Frame > 9) and (m_Frame < 14)) then inc(m_X);
   if ((m_Frame > 25) and (m_Frame < 30)) then inc(m_X);
   ready := true;
   for sy:=0 to 9 do begin
    if val(buff[sy,8]) > 40 then begin
     ready := false;
     break;
    end;
   end;
   if (ready) then m_Anim := walkright;
   for sy:=0 to 9 do begin
    src:=@f[sy,163];
    for sx:=0 to 9 do if src[0,sx]<>0 then wrt[sy,2 + sx]:= 0;
   end;
  end else
  if (m_Anim = digleft) then begin
   if (m_Frame = 16) then begin
    inc(m_Y);
    dec(m_X,2);
   end;
  end else
  if (m_Anim = digright) then begin
   if (m_Frame = 16) then begin
    inc(m_Y);
    inc(m_X,2);
   end;
  end else
  if (m_Anim = climbleft) then begin
   if (m_Frame > 4) then dec(m_Y);
   if (m_Frame < 5) and (val(buff[(4 - m_Frame)-1,240 - 2]) < 40) then begin
    m_Anim := edgeleft;
    dec(m_Y,m_Frame + 4);
    m_Frame := 0;
   end;
   if val(buff[2-1,240 - 1]) > 40 then m_Anim := fallright;
  end else
  if (m_Anim = climbright) then begin
   if (m_Frame > 4) then dec(m_Y);
   if (m_Frame < 5) and (val(buff[(4 - m_Frame), 2]) < 40) then begin
    m_Anim := edgeright;
    dec(m_Y,m_Frame + 4);
    m_Frame := 0;
   end;
   if val(buff[2 , 1]) > 40 then m_Anim := fallleft;
  end else
  if (m_Anim = edgeleft) then begin
   if (m_Frame = 7) then begin
    m_Anim := walkleft;
    dec(m_X,2);
   end;
  end else
  if (m_Anim = edgeright) then begin
   if (m_Frame = 7) then begin
    m_Anim := walkright;
    inc(m_X,2);
   end;
  end else
  if (m_Anim = dropdead) then begin
   if (m_Frame =  2) then play('Splat');
   if (m_Frame = 15) then begin
    m_Anim := nil;
    dec(lactive);
   end;
  end else
  if (m_Anim = waitleft) then begin
   if (m_Frame = 11) then begin
    m_Anim := walkleft;
    inc(m_Y,3);
    m_Frame := 0;
   end;
  end else
  if (m_Anim = waitright) then begin
   if (m_Frame = 11) then begin
    m_Anim := walkright;
    inc(m_Y,3);
    m_Frame := 0;
   end;
  end else
  if (m_Anim = goingin) then begin
   if (m_Frame = 2) then play('Oing');
   if (m_Frame = 7) then begin
    m_Anim := nil;
    dec(lactive);
   end;
  end;
  if ((m_X>=ex1) and (m_X<=ex2) and (m_Y>=ey1) and (m_Y<=ey2)) then begin
   m_Anim := goingin;
   dec(m_Y,3);
   m_Frame := 0;
  end;
 end;

procedure Lemming.draw;
 var
  bc:integer;
 begin
  if (m_Anim<>nil) then begin
   inc(m_Frame);
   if (m_Frame>=m_Anim.getframes) then begin
    if (m_Anim=floatleft)or(m_Anim=floatright) then m_Frame:=4 else m_Frame:=0;
   end;
   m_Anim.update(m_X, m_Y, m_Frame);
  end;
  if (m_Bomb) then begin
   dec(m_BCount);
   bc:=m_BCount div 8;
   if (bc = 0) then begin
    m_Anim := bomber;
    m_Bomb := false;
    m_Frame:= 0;
   end else begin
    countdown.update( m_X + 3, m_Y - 6, bc - 1 );
   end;
  end;
 end;

Constructor LAnim.Create;
 begin
 {$IFDEF PATH}Index:=i;{$ENDIF}
  m_Frames := 0;
 end;

Destructor LAnim.Destroy;
 begin
 end;

procedure LAnim.update(x,y,frame:integer);
 var
  src:^TAnimPixels;
  dst:^TPixels;
  v,h:integer;
  pixel:word;
 begin
  src := @f[m_Fy[frame],m_Fx[frame]];
  dst := @Pixels[y,x];
  for v:=0 to m_Fszy-1 do begin
   for h:=0 to m_Fszx-1 do begin
    pixel:=src[v,h];
    if pixel>0 then dst[v,h]:=pixel;
   end;
  end;
 end;

const
 ip:integer=0;
procedure setpos(i,x,y:integer);
 begin
  writeln('  {',ip:3,'} (',x:3,',',y:3,'),');
  inc(ip);
 end;

{$IFDEF PATH}
{$INCLUDE PATH.PAS}
{$ELSE}
procedure initanims;
 var
  i:integer;
  f:textfile;
 begin
 {$define makepas}
 {$ifdef makepas}
  assignfile(output,'path.pas');
  rewrite(output);
  writeln('Type');
  writeln(' TPath=array[0..2] of byte;');
  writeln('Const');
  writeln(' FrameCount =0;');
  writeln(' FrameWidth =1;');
  writeln(' FrameHeight=2;');
  writeln(' Paths:array[0..23] of TPath=(');
  writeln('  ( 8, 10,10), {  0-walkright   }');
  writeln('  ( 8, 10,10), {  1-walkleft    }');
  writeln('  ( 4, 10,10), {  2-fallright   }');
  writeln('  ( 4, 10,10), {  3-fallleft    }');
  writeln('  (16, 12,10), {  4-stopper     }');
  writeln('  (16, 16,13), {  5-bridgeleft  }');
  writeln('  (16, 16,13), {  6-bridgeright }');
  writeln('  (32, 16,10), {  7-bomber      }');
  writeln('  (12, 16,16), {  8-floatleft   }');
  writeln('  (12, 16,16), {  9-floatright  }');
  writeln('  (16, 16,14), { 10-digger      }');
  writeln('  (32, 16,10), { 11-bashleft    }');
  writeln('  (32, 16,10), { 12-bashright   }');
  writeln('  (24, 16,13), { 13-digleft     }');
  writeln('  (24, 16,13), { 14-digright    }');
  writeln('  ( 8, 16,11), { 15-climbleft   }');
  writeln('  ( 8, 16,11), { 16-climbright  }');
  writeln('  ( 8, 16,16), { 17-edgeleft    }');
  writeln('  ( 8, 16,16), { 18-edgeright   }');
  writeln('  ( 5,  5, 5), { 19-countdown   }');
  writeln('  (16, 16,10), { 20-dropdead    }');
  writeln('  (12, 16,13), { 21-waitleft    }');
  writeln('  (12, 16,13), { 22-waitright   }');
  writeln('  ( 8, 16,13)  { 23-goingin     }');
  writeln(' );');
  writeln(' Frames:array[0..348,0..1] of word=(');
  for i:=0 to 7 do setpos(i,i*16,0);
  for i:=0 to 7 do setpos( i, (7 - i) * 16, 10 );
  for i:=0 to 7 do setpos( i, i * 16, 10 );
  for i:=0 to 7 do setpos( i, i * 16, 10 );
  for i:=0 to 15 do setpos( i, i * 16, 148 );
  for i:=0 to 15 do setpos( i, i * 16, 208 );
  for i:=0 to 15 do setpos( i, i * 16, 195 );
  for i:=0 to 15 do setpos( i, i * 16, 128 );
  for i:=0 to 15 do setpos( i + 16, i * 16, 138 );
  for i:=0 to 7 do setpos( i, i * 16, 112 );
  for i:=0 to 3 do setpos( i + 8, (7 - i) * 16, 112 );
  for i:=0 to 7 do setpos( i, i * 16, 96 );
  for i:=0 to 3 do setpos( i + 8, (7 - i) * 16, 96 );
  for i:=0 to 15 do setpos( i, i * 16, 247 );
  for i:=0 to 15 do setpos( i, i * 16, 281 );
  for i:=0 to 15 do setpos( i + 16, i * 16, 291 );
  for i:=0 to 15 do setpos( i, i * 16, 261 );
  for i:=0 to 15 do setpos( i + 16, i * 16, 271 );
  for i:=0 to 11 do setpos( i, i * 16, 327 );
  for i:=0 to 11 do setpos( i + 12, i * 16, 340 );
  for i:=0 to 11 do setpos( i, i * 16, 301 );
  for i:=0 to 11 do setpos( i + 12, i * 16, 314 );
  for i:=0 to 7 do setpos( i, i * 16, 53 );
  for i:=0 to 7 do setpos( i, i * 16, 41 );
  for i:=0 to 7 do setpos( i, i * 16, 80 );
  for i:=0 to 7 do setpos( i, i * 16, 64 );
  for i:=0 to 4 do setpos( i, i * 16 + 135, 116 );
  for i:=0 to 15 do setpos( i, i * 16, 138 );
  for i:=0 to  7 do setpos( i, i * 16, 234 );
  for i:=8 to 11 do setpos( i, 7 * 16, 234 );
  for i:=0 to  7 do setpos( i, i * 16, 221 );
  for i:=8 to 11 do setpos( i, 7 * 16, 221 );
  for i:=0 to 7-1 do setpos( i, i * 16, 182 );
  writeln('  {',ip:3,'} (',7*16:3,',',182,')');
  writeln(' );');
  writeln('Var');
  writeln(' FrameIndex:array[0..24] of word;');
  writeln('Procedure InitFrames;');
  writeln(' var');
  writeln('  i,j:integer;');
  writeln(' begin');
  writeln('  for i:=0 to 23 do begin');
  writeln('   FrameIndex[i]:=j;');
  writeln('   inc(j,Paths[i,0]);');
  writeln('  end;');
  writeln('  FrameIndex[24]:=j;');
  writeln(' end;');
  writeln;
  close(output);
 {$endif}

  walkright:=LAnim.create;
  walkright.setframes( 8 );
  walkright.setsize( 10, 10 );
  for i:=0 to 7 do walkright.setfpos( i, i * 16, 0 );
  walkleft:=LAnim.Create;
  walkleft.setframes( 8 );
  walkleft.setsize( 10, 10 );
  for i:=0 to 7 do walkleft.setfpos( i, (7 - i) * 16, 10 );
  fallright:=LAnim.Create;
  fallright.setframes( 4 );
  fallright.setsize( 10, 10 );
  for i:=0 to 7 do fallright.setfpos( i, i * 16, 10 );
  fallleft:=LAnim.Create;
  fallleft.setframes( 4 );
  fallleft.setsize( 10, 10 );
  for i:=0 to 7 do fallleft.setfpos( i, i * 16, 10 );
  stopper:=LAnim.Create;
  stopper.setframes( 16 );
  stopper.setsize( 12, 10 );
  for i:=0 to 15 do stopper.setfpos( i, i * 16, 148 );
  bridgeleft:=LAnim.Create;
  bridgeleft.setframes( 16 );
  bridgeleft.setsize( 16, 13 );
  for i:=0 to 15 do bridgeleft.setfpos( i, i * 16, 208 );
  bridgeright:=LAnim.Create;
  bridgeright.setframes( 16 );
  bridgeright.setsize( 16, 13 );
  for i:=0 to 15 do bridgeright.setfpos( i, i * 16, 195 );
  bomber:=LAnim.Create;
  bomber.setframes( 32 );
  bomber.setsize( 16, 10 );
  for i:=0 to 15 do bomber.setfpos( i, i * 16, 128 );
  for i:=0 to 15 do bomber.setfpos( i + 16, i * 16, 138 );
  floatleft:=LAnim.Create;
  floatleft.setframes( 12 );
  floatleft.setsize( 16, 16 );
  for i:=0 to 7 do floatleft.setfpos( i, i * 16, 112 );
  for i:=0 to 3 do floatleft.setfpos( i + 8, (7 - i) * 16, 112 );
  floatright:=LAnim.Create;
  floatright.setframes( 12 );
  floatright.setsize( 16, 16 );
  for i:=0 to 7 do floatright.setfpos( i, i * 16, 96 );
  for i:=0 to 3 do floatright.setfpos( i + 8, (7 - i) * 16, 96 );
  digger:=LAnim.Create;
  digger.setframes( 16 );
  digger.setsize( 16, 14 );
  for i:=0 to 15 do digger.setfpos( i, i * 16, 247 );
  bashleft:=LAnim.Create;
  bashleft.setframes( 32 );
  bashleft.setsize( 16, 10 );
  for i:=0 to 15 do bashleft.setfpos( i, i * 16, 281 );
  for i:=0 to 15 do bashleft.setfpos( i + 16, i * 16, 291 );
  bashright:=LAnim.Create;
  bashright.setframes( 32 );
  bashright.setsize( 16, 10 );
  for i:=0 to 15 do bashright.setfpos( i, i * 16, 261 );
  for i:=0 to 15 do bashright.setfpos( i + 16, i * 16, 271 );
  digleft:=LAnim.Create;
  digleft.setframes( 24 );
  digleft.setsize( 16, 13 );
  for i:=0 to 11 do digleft.setfpos( i, i * 16, 327 );
  for i:=0 to 11 do digleft.setfpos( i + 12, i * 16, 340 );
  digright:=LAnim.Create;
  digright.setframes( 24 );
  digright.setsize( 16, 13 );
  for i:=0 to 11 do digright.setfpos( i, i * 16, 301 );
  for i:=0 to 11 do digright.setfpos( i + 12, i * 16, 314 );
  climbleft:=LAnim.Create;
  climbleft.setframes( 8 );
  climbleft.setsize( 16, 11 );
  for i:=0 to 7 do climbleft.setfpos( i, i * 16, 53 );
  climbright:=LAnim.Create;
  climbright.setframes( 8 );
  climbright.setsize( 16, 11 );
  for i:=0 to 7 do climbright.setfpos( i, i * 16, 41 );
  edgeleft:=LAnim.Create;
  edgeleft.setframes( 8 );
  edgeleft.setsize( 16, 16 );
  for i:=0 to 7 do edgeleft.setfpos( i, i * 16, 80 );
  edgeright:=LAnim.Create;
  edgeright.setframes( 8 );
  edgeright.setsize( 16, 16 );
  for i:=0 to 7 do edgeright.setfpos( i, i * 16, 64 );
  countdown:=LAnim.Create;
  countdown.setframes( 5 );
  countdown.setsize( 5, 5 );
  for i:=0 to 4 do countdown.setfpos( i, i * 16 + 135, 116 );
  dropdead:=LAnim.Create;
  dropdead.setframes( 16 );
  dropdead.setsize( 16, 10 );
  for i:=0 to 15 do dropdead.setfpos( i, i * 16, 138 );
  waitleft:=LAnim.Create;
  waitleft.setframes( 12 );
  waitleft.setsize( 16, 13 );
  for i:=0 to  7 do waitleft.setfpos( i, i * 16, 234 );
  for i:=8 to 11 do waitleft.setfpos( i, 7 * 16, 234 );
  waitright:=LAnim.Create;
  waitright.setframes( 12 );
  waitright.setsize( 16, 13 );
  for i:=0 to  7 do waitright.setfpos( i, i * 16, 221 );
  for i:=8 to 11 do waitright.setfpos( i, 7 * 16, 221 );
  goingin:=LAnim.Create;
  goingin.setframes( 8 );
  goingin.setsize( 16, 13 );
  for i:=0 to 7 do goingin.setfpos( i, i * 16, 182 );
 end;
{$ENDIF}
var
 i,j:integer;
 lemm:array[0..79] of Lemming;
 delay:integer;
 lemmings_:integer;
 lcount:integer;
 lout:integer;
 x,y:integer;
 v,h:integer;
 lx,ly:integer;
 b:^TPixels;
 action:integer;

Type
 TClickInfo=record x1,y1,x2,y2:integer end;

function GetClick(var ClickInfo:array of TClickInfo):integer;
 var
  i:integer;
  x,y:integer;
 begin
  DoEvents;
  if clicked(x,y) then begin
   for i:=low(ClickInfo) to high(ClickInfo) do begin
    with ClickInfo[i] do if (x>=x1)and(x<=x2)and(y>=y1)and(y<=y2) then begin
     result:=i;
     exit;
    end;
   end;
   for i:=0 to Lemmings_-1 do begin
    with Lemm[i] do if (x>=m_X-1)and(x<=m_X+15)and(y>=m_Y-5)and(y<=m_Y+15) then begin
     result:=i+100;
     exit;
    end;
   end;
  end;
  result:=-1;
 end;

Const
 TitleClicks:array[0..4] of TClickInfo=(
  { 0-Level 1 } (x1: 98; y1: 38; x2: 217; y2: 63),
  { 1-Level 2 } (x1: 98; y1: 73; x2: 217; y2: 98),
  { 2-Level 3 } (x1: 98; y1:108; x2: 217; y2:133),
  { 3-Level 4 } (x1: 98; y1:143; x2: 217; y2:168),
  { 4-EXIT => } (x1:198; y1:273; x2: 231; y2:294)
 );

 ButtonClicks:array[0..9] of TClickInfo=(
  { 0 - Climber } (x1:  1; y1:240+ 1; x2: 32; y2:240+38),
  { 1 - floater } (x1: 34; y1:240+ 1; x2: 66; y2:240+38),
  { 2 - bomb    } (x1: 68; y1:240+ 1; x2:101; y2:240+38),
  { 3 - stopper } (x1:103; y1:240+ 1; x2:135; y2:240+38),
  { 4 - bridge  } (x1:137; y1:240+ 1; x2:170; y2:240+38),
  { 5 - bash    } (x1:171; y1:240+ 1; x2:204; y2:240+38),
  { 6 - axe     } (x1:206; y1:240+ 1; x2:239; y2:240+38),
  { 7 - dig     } (x1:206; y1:240+40; x2:239; y2:240+78),

  { 8 - Pause   } (x1:  1; y1:240+40; x2: 32; y2:240+78),
  { 9 - Armag.  } (x1: 34; y1:240+40; x2: 66; y2:240+78)
 );

procedure LoadLevel(Name:string; sx,sy, x1,y1,x2,y2, r,m:integer; s:boolean);
 begin
  LoadBMP(Name,@Pixels);
  ex1 := x1;
  ey1 := y1;
  ex2 := x2;
  ey2 := y2;
  startx := sx;
  starty := sy;
  rate := r;
  lmax := m;
  snow := s;
 end;

function title:boolean;
 var
  c:integer;
  x,y:integer;
 begin
  LoadBMP('Title',@pixels{, 240, 320});
  repeat c:=GetClick(TitleClicks) until c>=0;
  case c of
   0: LoadLevel('Level4', 188,17,  77,202, 81,236, 32,40, true);
   1: LoadLevel('Level1',  69,57, 190, 74,198, 90, 32,40, true);
   2: LoadLevel('Level5', 124,23,  31,212, 33,234, 64,40, true);
   3: LoadLevel('Level3',  34,23, 193,200,197,226, 22,80, true);
  end;
  Result:=(c<>4);
 end;

procedure printcount(n,x1,y1:integer);
 var
  tmp:string[2];
 begin
//  bar( x1, y1, x1 + 14, y1 + 7, 0);
  tmp:=chr(n div 10 + ord('0'))+chr(n mod 10 + ord('0'));
  print( tmp, x1, y1, $FFFFFF );
 end;

procedure updatecounts;
 begin
  printcount( comcount[0],  15, 245 );
  printcount( comcount[1],  49, 245 );
  printcount( comcount[2],  84, 245 );
  printcount( comcount[3], 119, 245 );
  printcount( comcount[4], 153, 245 );
  printcount( comcount[5], 185, 245 );
  printcount( comcount[6], 219, 245 );
  printcount( comcount[7], 219, 285 );
 end;

procedure updatesnow;
 var
  i  :integer;
  dir:integer;
 begin
  if (snupd = 1) then snupd := 0 else snupd := 1;
  for i := 0 to FLAKES-1 do begin
   if ((i and 1) = snupd) then begin
    dir := random(3);
    if (dir = 0) then begin
     inc(snx[i]);
     if (snx[i] > 239) then snx[i] := 0;
    end else
    if (dir = 1) then begin
     dec(snx[i]);
     if (snx[i] < 1) then snx[i] := 239;
    end;
    inc(sny[i], (i and 3) + 1);
    if (sny[i] > 239) then sny[i] := 0;
   end;
   Pixels[sny[i],snx[i]]:=65535;
  end;
 end;

procedure SetButton(b:integer; var src,dst:TPixels);
 var
  x,y:integer;
 begin
  with ButtonClicks[b] do
   for x:=x1 to x2 do
    for y:=y1 to y2 do
     dst[y,x]:=src[y-240,x];
 end;

{ main; }
begin
 GraphMode;

 f :=LoadBMP('LemAnim',nil);
 b1:=LoadBMP('Buttons',nil);
 b2:=LoadBMP('BButtons',nil);
{$IFDEF PATH}
 InitFrames;
{$ELSE}
 initanims;
{$ENDIF}
 for i:=0 to FLAKES-1 do begin
  snx[i] := random(240){ div RAND_MAX};
  sny[i] := i mod 240;
 end;

 while title do begin

  command := 0;
  lactive := 0;
  paused := false;
  confirm:= false;
  armageddon := false;

  action:=0;

  Move(b1^,Pixels[240,0],240*80*4); // Buttons
  Update;
  //resettimer;
  play('Door'); sleep(500);  play('LetsGo' );

  Move(Pixels,OffScr,SizeOf(Pixels)); // save offscreen
  updatecounts;

  for i:=0 to 79 do lemm[i]:=nil;

  delay     := 1;
  lemmings_ := 0;
  lcount    := rate;
  lout      := 0;
  for i:=0 to 10 do comcount[i] := 20;

  msecs:=0;
  while true do begin
  // new Lemming...
   if (not paused) then begin
    if (msecs>=10) then begin
     dec(msecs,10);
     move(OffScr,Pixels,SizeOf(Pixels));
     for i:=0 to lemmings_-1 do lemm[i].update;
     for i:=0 to lemmings_-1 do lemm[i].draw;
     if (snow) then updatesnow;
     updatecounts;
     update;
     if ((lemmings_ < lmax) and (not armageddon)) then begin
      dec(lcount);
      if (lcount = 0) then begin
       lcount:=rate;
       lemm[lemmings_]:=Lemming.Create;
       lemm[lemmings_].setpos( startx, starty );
       lemm[lemmings_].setanim( walkleft );
       inc(lemmings_);
       inc(lactive);
       inc(lout);
      end;
     end;
    end;
   end; // not paused

   if armageddon and (lactive=0) then break;
   if (lout = 40) and (lactive = 0) then break;

  // button click
   command:=GetClick(ButtonClicks);

   if (command in [0..7])and(comcount[command]=0) then command:=-1;

   if (command=8) and Paused then begin
    SetButton(8,b1^,OffScr); // UnClick
    command:=-1;
    paused:=false;
   end;

   if (command>=0)and(command<10) then begin
    SetButton(action ,b1^,OffScr);
    SetButton(command,b2^,OffScr);
    action:=command;
    play('ChangeOp');
   end;

   case command of
    8: begin
        Paused:=true;
        SetButton(8,b2^,Pixels);
        Update;
       end;
    9: if not armageddon then begin
        if confirm then begin
         for i := 0 to lemmings_-1 do if (lemm[i].getanim=nil) then lemm[i].isbomb;
         armageddon:=true;
        end else begin
         confirm:=true;
        end;
       end;
   end;
   if (command>=100) then begin
    i:=command-100;
    case action of
     0: begin
         dec(comcount[0]);
         lemm[i].isclimber;
        end;
     1: if not lemm[i].getfloat then begin
         dec(comcount[1]);
         lemm[i].isfloater;
        end;
     2: if not lemm[i].getbomb then begin
         dec(comcount[2]);
         lemm[i].isbomb;
        end;
     3: if (lemm[i].getanim=walkleft)or(lemm[i].getanim=walkright) then begin
         dec(comcount[3]);
         lemm[i].setanim(stopper);
         b := @OffScr[9+ly, 11 + lx];
         for j:= 0 to 7 do begin
          if val(b[j,0]) < 40 then b[j,0] := 41 + (41 shl 8) + (41 shl 16);
          if val(b[j,1]) < 40 then b[j,1] := 41 + (41 shl 8) + (41 shl 16);
         end;
        end;
     4: if (lemm[i].getanim=walkleft)or(lemm[i].getanim=waitleft) then begin
         dec(comcount[4]);
         if lemm[i].getanim=walkleft then
          lemm[i].setpos(lemm[i].getxpos,lemm[i].getypos-3)
         else
          lemm[i].setpos(lemm[i].getxpos,lemm[i].getypos);
         lemm[i].setanim(bridgeleft);
         lemm[i].setframe(0);
         lemm[i].setcounter(10);
        end else
        if (lemm[i].getanim=walkright)or(lemm[i].getanim=waitright) then begin
         dec(comcount[4]);
         if lemm[i].getanim=walkright then
          lemm[i].setpos(lemm[i].getxpos,lemm[i].getypos-3)
         else
          lemm[i].setpos(lemm[i].getxpos,lemm[i].getypos);
         lemm[i].setanim(bridgeright);
         lemm[i].setframe(0);
         lemm[i].setcounter(10);
        end;
     5: if (lemm[i].getanim=walkleft) then begin
         dec(comcount[5]);
         lemm[i].setanim(bashleft);
         lemm[i].setframe(0);
        end else
        if (lemm[i].getanim=walkright) then begin
         dec(comcount[5]);
         lemm[i].setanim(bashright);
         lemm[i].setframe(0);
        end;
     6: if (lemm[i].getanim=walkleft) then begin
         dec(comcount[6]);
         lemm[i].setpos( lemm[i].getxpos, lemm[i].getypos - 3);
         lemm[i].setanim(digleft);
         lemm[i].setframe(0);
        end else
        if (lemm[i].getanim=walkright) then begin
         dec(comcount[6]);
         lemm[i].setpos( lemm[i].getxpos, lemm[i].getypos - 3);
         lemm[i].setanim(digright);
         lemm[i].setframe(0);
        end;
     7: if (lemm[i].getanim=walkleft)or(lemm[i].getanim=walkright) then begin
         dec(comcount[7]);
         lemm[i].setanim(digger);
         lemm[i].setframe(0);
         lemm[i].setpos(lemm[i].getxpos,lemm[i].getypos-2);
        end;
     end;
     updatecounts;
    end;
   end;
  end;
  for i := 0 to lemmings_-1 do lemm[i].Destroy;
{$IFDEF VGA}
 ChangeDisplaySettings(TDeviceMode(nil^),0);
{$ENDIF}
 end.
(*
	delete t;
	delete f;
	delete walkright;
	delete walkleft;
	delete fallleft;
	delete fallright;
	delete bridgeleft;
	delete bridgeright;
	delete bomber;
	delete stopper;
	delete floatleft;
	delete floatright;
	delete digger;
	delete bashleft;
	delete bashright;
	delete digleft;
	delete digright;
	delete climbleft;
	delete climbright;
	delete edgeleft;
	delete edgeright;
	delete countdown;
	delete dropdead;
	delete waitleft;
	delete waitright;
	delete goingin;
*)
{$ENDIF}
