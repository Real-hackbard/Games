Program Lemmings;

{$R Jacco1.RES}

(******** Windows specific Informations ****************)
{$IFDEF WIN32}
{-$DEFINE VGA} // set 640x480x32 video mode...

uses
 windows, messages, mmsystem;

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
 clickx:integer;
 clicky:integer;
 action:integer;

function clicked:boolean;
 begin
  result:=click;
  if result then begin
   clickx:=clickxpos;
   clicky:=clickypos;
   click :=false;
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

Type
 Song=(ChangeOp, Die, Door, Explode, LetsGo, OhNo, Oing, Splat, Ting);
Const
 SongNames:array[Song] of PChar=(
  'ChangeOp', 'Die', 'Door', 'Explode', 'LetsGo', 'OhNo', 'Oing', 'Splat', 'Ting'
 );
var
 Songs:array[Song] of record res:integer; lck:pchar; end;

procedure initWav;
 var
  s:Song;
  r:integer;
 begin
  for s:=low(Song) to High(Song) do begin
   r:=FindResource(hInstance,SongNames[s],RT_RCDATA);
   Songs[s].res:=LoadResource(hInstance,r);
   Songs[s].lck:=LockResource(songs[s].res);
  end;
 end;

procedure DoneWav;
 var
  s:Song;
 begin
  for s:=low(Song) to High(Song) do begin
   FreeResource(songs[s].res);
  end;
 end;

procedure Play(s:Song; async:boolean);
 const
  flags:array[boolean] of integer=(SND_MEMORY,SND_MEMORY or SND_ASYNC);
 begin
  PlaySound(Songs[s].lck,hInstance,flags[async]);
 end;

procedure PlayMidi(FileName:string);
 var
  mciOpen:TMCI_OPEN_PARMS;
  mciPlay:TMCI_PLAY_PARMS;
 begin
  with mciOpen do begin
   dwCallBack:=0;
   lpstrDeviceType:=nil;
   lpstrElementName:=PChar(FileName);
   lpstrAlias:=nil;
  end;
  if mciSendCommand(0, mci_Open, mci_open_element, Longint(@mciOpen))=0 then begin
   mciPlay.dwCallBack:=win;
   mciPlay.dwFrom    :=0;
   mciSendCommand( mciOpen.wDeviceId, mci_Play, mci_notify or mci_from, Longint(@mciPlay));
  end;
 end;

procedure PlayLoop(dev:integer);
 var
  mciPlay:TMCI_PLAY_PARMS;
 begin
  mciPlay.dwCallBack:=win;
  mciPlay.dwFrom    :=0;
  mciSendCommand(dev, mci_Play, mci_notify or mci_from, Longint(@mciPlay));
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

   WM_TIMER   : inc(msecs,3);

   MM_MCINOTIFY : PlayLoop(lParam);

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
  wc.style :=  0; // CS_SAVEBITS;      { Class style. }
  wc.lpfnWndProc := @WinProc;          { Window procedure for this class. }
  wc.cbClsExtra := 0;                  { No per-class extra data. }
  wc.cbWndExtra := 0;                  { No per-window extra data. }
  wc.hInstance := hInstance;           { Application that owns the class. }
  wc.hIcon := LoadIcon(hInstance,'Form1');
  wc.hCursor := LoadCursor(hInstance, 'Hand');
  wc.hbrBackground := 0;
  wc.lpszMenuName := nil;
  wc.lpszClassName := ClassName;       { Name used in call to CreateWindow. }
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
   'Lemmings',
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

const
 none       =-1;
 walkright  =0;
 walkleft   =1;
 fallright  =2;
 fallleft   =3;
 stopper    =4;
 bridgeleft =5;
 bridgeright=6;
 bomber     =7;
 floatleft  =8;
 floatright =9;
 digger     =10;
 bashleft   =11;
 bashright  =12;
 digleft    =13;
 digright   =14;
 climbleft  =15;
 climbright =16;
 edgeleft   =17;
 edgeright  =18;
 countdown  =19;
 dropdead   =20;
 waitleft   =21;
 waitright  =22;
 goingin    =23;

Type
 TFlag =(fClimber,fFloater,fBasher);

 TFlags=set of TFlag;

 TLemming=class
  alive:boolean;
  x,y  :integer;
  anim :integer;
  frame:integer;
  fbomb:integer; // bomb timer * 8
  step :integer; // bridge counter
  flags:TFlags;
  constructor create;
  function bomb:boolean;
  procedure walk(dx:integer);
  procedure Climb(dx:integer);
  procedure Edge(dx:integer);
  procedure fall(count,dy,walk:integer);
  procedure Bridge(dx:integer);
  procedure Bash(dx:integer);
  procedure Dig(dx:integer);
  procedure Wait(dx:integer);
  procedure NextFrame;
  procedure draw;
  function click:boolean;
  function SetFlag(f:TFlag; count:integer):boolean;
 end;

var
 Lemms:array[0..79] of TLemming;
 counter:array[0..7] of integer;
 armageddon:boolean;

const
 FLAKES=400; { number of snowflakes in level 1 }

Type
 TSprites=packed array[0..353,0..255] of integer;

var
 OffScr:TPixels;
 LemSpr:^TSprites;
 b1:^TPixels;
 b2:^TPixels;
 command:integer;
 lactive:integer;
 startx :integer;
 starty :integer;
 snow   :boolean;
 confirm:boolean;
 rate,lmax,snupd,ex1,ey1,ex2,ey2:integer;
 snx,sny:array[0..FLAKES-1] of integer;

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

constructor TLemming.Create;
 begin
  alive:=false;
 end;

function TLemming.Bomb:boolean;
 begin
  result:=(fbomb=0);
  if result then begin
   play(OhNo,true);
   if not armageddon then dec(counter[2]);
   fbomb:=5*8;
  end;
 end;

procedure TLemming.walk(dx:integer);
 var
  i:integer;
 begin
 // borders
  if dx<0 then begin // walk left
   if x<-4 then begin anim:=walkright; Exclude(Flags,fBasher); exit end;
  end else begin // walk right
   if x>240-5 then begin anim:=walkleft; Exclude(Flags,fBasher); exit end;
  end;
 // move on
  inc(x,dx);
 // climb on 1,2 or 3 pixels
  for i:=0 to 3 do begin
   if val(OffScr[y+9,x+5])<=40 then break; // no more obstacle
   if i=3 then begin // too many pixels
    inc(y,2);    // restore y
    dec(x,2*dx); // walk to the other side
    if fBasher in Flags then begin // bash ?
     Exclude(Flags,fBasher);
     if dx<0 then anim:=bashleft else anim:=bashright;
     frame:=0;
    end else
    if fClimber in Flags then begin // climb ?
     if dx<0 then anim:=climbleft else anim:=climbright;
    end else begin // go away !
     if dx<0 then anim:=walkright else anim:=walkleft;
    end;
    exit;
   end;
   dec(y); // climb a single pixel or two
  end;
 // fall from 1,2 or 3 pixels
  for i:=0 to 2 do begin
   if val(OffScr[y+10,x+5])>=40 then break;
   if i=2 then begin // too many pixels
    if fFloater in Flags then begin
     if dx<0 then anim:=floatleft else anim:=floatright;
    end else begin
     if dx<0 then anim:=fallleft else anim:=fallright;
     step:=y;
    end;
    exit;
   end;
   inc(y); // fall from a single pixel or two
  end;
 end;

procedure TLemming.Climb(dx:integer);
 begin
  if (Frame>4) then dec(y);
  if (Frame<5) and (val(OffScr[y+4-Frame,x+5+2*dx])<40) then begin
   if dx<0 then anim:=edgeleft else anim:=edgeright;
   dec(y,Frame+4);
   frame:=0;
  end;
  if Pixels[y+2,x+5+dx]>40 then begin
   if dx<0 then anim:=fallleft else anim:=fallright;
  end;
 end;

procedure TLemming.Edge(dx:integer);
 begin
  if (Frame = 7) then begin
   if dx<0 then anim:=walkleft else anim:=walkright;
   inc(X,2*dx);
  end;
 end;

procedure TLemming.fall(count,dy,walk:integer);
 var
  i:integer;
 begin
// if fFloater in Flags then Anim:=floatleft;
  for i:=0 to count-1 do begin
   if val(OffScr[y+10+dy,x+5])>=40 then begin
    if (count>0)and(y-step<40) then begin
     anim:=walk;
     inc(y,dy);
    end else begin
     anim:=dropdead;
    end;
    exit;
   end;
   inc(y);
  end;
 end;

procedure TLemming.Bridge(dx:integer);
 begin
  if (Frame=9) and (step<4) then play(Ting,true); // last 4 steps
  if (Frame=15) then begin
   dec(step);
   if (step>0) then begin // new step at frame 15
    inc(x,6);
    OffScr[y+12,x+1*dx]:=$FFFFFF;
    OffScr[y+12,x+2*dx]:=$FFFFFF;
    OffScr[y+12,x+3*dx]:=$FFFFFF;
    inc(x,2*dx-6);
    dec(y);
    if ((dx<0) and (x<-4)) or ((dx>0)and(x>240-5)) or (val(OffScr[y+12,x+4*dx])>40) then begin
     if dx<0 then anim:=walkright else anim:=walkleft;
     inc(y,3);
    end;
   end else begin
    if dx<0 then anim:=waitleft else anim:=waitright;
    Frame:=0;
   end;
  end;
 end;

procedure TLemming.Bash(dx:integer);
 var
  i,j:integer;
  sx,sy:integer;
 begin
  if (Frame >  9) and (Frame < 14) then inc(x,dx);
  if (Frame > 25) and (Frame < 30) then inc(x,dx);
  for i:=1 to 10 do begin
   for j:=0 to 5 do begin
    if val(offScr[y+i,x+4+6*dx+j])>40 then begin // at least one pixel is a wall
    // dig
     for sy:=0 to 9 do
      for sx:=0 to 6 do
       if LemSpr[sy,170-7*dx+sx]>0 then // dig mask
        OffScr[y+1+sy,x+4+3*dx+sx]:=0;
     exit;
    end;
   end;
  end;
  if dx<0 then anim:=walkleft else anim:=walkright;
 end;

procedure TLemming.Dig(dx:integer);
 begin
  if Frame=16 then begin
   inc(y);
   inc(x,2*dx);
   // more to do :)
  end;
 end;

procedure TLemming.Wait(dx:integer);
 begin
  if (Frame = 11) then begin
   if dx<0 then Anim := walkleft else anim:=walkright;
   inc(Y,3);
   Frame:=0;
  end;
 end;

procedure TLemming.NextFrame;
 var
  buff:^TPixels;
  wrt :^TPixels;
  hitground:boolean;
  sx,sy:integer;
  src  :^TSprites;
  i    :integer;
  ready:boolean;
 begin
  case Anim of

    None,Stopper: exit; // no animation

    WalkLeft :walk(-1);
    WalkRight:walk(+1);

    ClimbLeft :Climb(-1);
    ClimbRight:Climb(+1);

    EdgeLeft  :Edge(-1);
    EdgeRight :Edge(+1);

    FallLeft  :fall(3,0,walkleft);
    FallRight :fall(3,0,walkright);

    FloatLeft :fall(1,6,walkleft);
    FloatRight:fall(1,6,walkright);

    BridgeLeft :Bridge(-1);
    BridgeRight:Bridge(+1);

    BashLeft  :Bash(-1);
    BashRight :Bash(+1);

    DigLeft : Dig(-1);
    DigRight: Dig(+1);

    WaitLeft : Wait(-1);
    WaitRight: Wait(+1);

    Digger: if Frame=15 then begin
     for i:=1 to 9 do begin
      OffScr[y+11,x+i]:=0;
      OffScr[y+12,x+i]:=0;
     end;
     for i:=2 to 8 do OffScr[y+13,x+i]:=0;
     if val(Pixels[y+14,x+5])<40 then anim:=walkleft else inc(y,2);
    end;

    Bomber: case Frame of
     15: begin
          play(Explode,true);
          for sy:=0 to 22 do
           for sx:=0 to 16 do
            if LemSpr[sy,sx+133]<>0 then OffScr[y+sy-4,x+sx-3]:=0;
         end;
     31: begin anim:=none; alive:=false; dec(lactive) end;
    end;

    DropDead: case Frame of
     2 : play(Splat,true);
     15: begin alive:=false; dec(lactive); end;
    end;

    Goingin: case frame of
     2 : play(Oing,true);
     7 : begin alive:=false; dec(lactive); end;
    end;

  end;

  if ((X>=ex1) and (X<=ex2) and (Y>=ey1) and (Y<=ey2)) then begin
   Anim := goingin;
   dec(Y,3);
   Frame:=0;
  end;
end;

{$INCLUDE ANIMS.PAS}

procedure Animate(a,x,y,frame:integer);
 var
  src:^TSprites;
  dst:^TPixels;
  v,h:integer;
  pixel:word;
 begin
  inc(frame,FrameIndex[a]);
  src := @LemSpr[Frames[frame,1],Frames[frame,0]];
  dst := @Pixels[y,x];
  for v:=0 to Anims[a,2]-1 do begin
   for h:=0 to Anims[a,1]-1 do begin
    pixel:=src[v,h];
    if pixel>0 then dst[v,h]:=pixel;
   end;
  end;
 end;

procedure TLemming.Draw;
 begin
  if not alive then exit;
  nextframe;
  if anim<>none then begin
   inc(frame);
   if frame>=Anims[anim,0] then begin
    if (anim=floatleft)or(anim=floatright) then frame:=4 else frame:=0;
   end;
   Animate(anim,x,y,frame);
  end;
  if fbomb>1 then begin
   dec(fbomb);
   if fbomb=1 then begin
    anim :=bomber;
    frame:=0;
   end else begin
    Animate(countdown,x+3,y-6,(fbomb div 8));
   end;
  end;
 end;

function TLemming.Click:boolean;
 var
  b:^TPixels;
  j:integer;
 begin
  if alive and (clickx>=x-5)and(clickx<=x+15)and(clicky>=y-5)and(clicky<=y+15) then begin
   result:=true;
   case action of
     0: if SetFlag(fClimber,0) then exit;
     1: if SetFlag(fFloater,1) then exit;
     2: if bomb then exit;
     3: if anim in [walkleft,walkright] then begin
         dec(counter[3]);
         anim:=stopper;
         b:=@OffScr[y+4,x+6];
         for j:= 0 to 7 do begin
          if val(b[j,0]) < 40 then b[j,0] := 41 + (41 shl 8) + (41 shl 16);
          if val(b[j,1]) < 40 then b[j,1] := 41 + (41 shl 8) + (41 shl 16);
         end;
         exit;
        end;
     4: if anim in [walkleft,waitleft,walkright,waitright] then begin
         dec(counter[4]);
         if anim in [walkleft,walkright] then dec(y,3);
         if anim in [walkleft,waitleft] then anim:=bridgeleft else anim:=bridgeright;
         frame:=0;
         step:=10;
         exit;
        end;
     5: if (anim in [walkleft,walkright])and SetFlag(fBasher,5) then exit;
     6: if (anim in [walkleft,walkright]) then begin
         dec(counter[6]);
         dec(y,3);
         if anim=walkleft then anim:=digleft else anim:=digright;
         frame:=0;
         exit;
        end;
     7: if anim in [walkleft,walkright] then begin
         dec(counter[7]);
         anim:=digger;
         frame:=0;
         dec(y,2);
         exit;
        end;
     end;
    end;
    result:=false;
   end;

function TLemming.SetFlag(f:TFlag; count:integer):boolean;
 begin
  result:=false;
  if f in flags then exit;
  dec(counter[count]);
  include(flags,f);
  result:=true;
 end;

const
 ip:integer=0;

procedure setpos(i,x,y:integer);
 begin
  writeln('  {',ip:3,'} (',x:3,',',y:3,'),');
  inc(ip);
 end;

{$IFDEF BUILDPATH}
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
  writeln(' Frames:array[0..340,0..1] of word=(');
  for i:=0 to 7 do setpos(i,i*16,0);
  for i:=0 to 7 do setpos( i, (7 - i) * 16, 10 );
  for i:=0 to 3 do setpos( i, i * 16, 20 );
  for i:=0 to 3 do setpos( i, i * 16, 30 );
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
  writeln(' FrameIndex:array[0..23] of word;');
  writeln('Procedure InitFrames;');
  writeln(' var');
  writeln('  i,j:integer;');
  writeln(' begin');
  writeln('  j:=0;');
  writeln('  for i:=0 to 23 do begin');
  writeln('   FrameIndex[i]:=j;');
  writeln('   inc(j,Paths[i,0]);');
  writeln('  end;');
  writeln(' end;');
  writeln;
  close(output);
 {$endif}
(*
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
  for i:=0 to {7}3 do fallright.setfpos( i, i * 16, 10 );
  fallleft:=LAnim.Create;
  fallleft.setframes( 4 );
  fallleft.setsize( 10, 10 );
  for i:=0 to {7}3 do fallleft.setfpos( i, i * 16, 10 );
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
*)
 end;
{$ENDIF}
var
 i,j:integer;
 delay:integer;
 lcount:integer;
 lout:integer;
 x,y:integer;
 v,h:integer;
 lx,ly:integer;
 b:^TPixels;

Type
 TClickInfo=record x1,y1,x2,y2:integer end;

function GetClick(var ClickInfo:array of TClickInfo):integer;
 var
  i:integer;
 begin
  DoEvents;
  if clicked then begin
   for i:=low(ClickInfo) to high(ClickInfo) do begin
    with ClickInfo[i] do if (clickx>=x1)and(clickx<=x2)and(clicky>=y1)and(clicky<=y2) then begin
     result:=i;
     exit;
    end;
   end;
   result:=high(ClickInfo)+1;
  end else
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
  LoadBMP('Title',@pixels);
  Paint;
  repeat c:=GetClick(TitleClicks) until c>=0;
  case c of
   0: LoadLevel('Level1', 188,17,  77,202, 81,236, 32,40, true);
   1: LoadLevel('Level2',  69,57, 190, 74,198, 90, 32,40, true);
   2: LoadLevel('Level3', 124,23,  31,212, 33,234, 64,40, true);
   3: LoadLevel('Level4',  34,23, 193,200,197,226, 22,80, true);
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
  printcount( counter[0],  15, 245 );
  printcount( counter[1],  49, 245 );
  printcount( counter[2],  84, 245 );
  printcount( counter[3], 119, 245 );
  printcount( counter[4], 153, 245 );
  printcount( counter[5], 185, 245 );
  printcount( counter[6], 219, 245 );
  printcount( counter[7], 219, 285 );
  printcount( lactive   , 138, 288 );
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

procedure playgame;
 begin
  Move(b1^,Pixels[240,0],240*80*4); // draw Buttons
  Update;
  play(Door,false);
  play(LetsGo,true);

  action :=0;
  command:=0;
  lactive:=0;

  confirm:=false;
  armageddon:=false;

  Move(Pixels,OffScr,SizeOf(Pixels)); // save offscreen
  for i:=0 to 7 do counter[i]:=20;
  for i:=0 to 79 do lemms[i]:=TLemming.Create;

  delay :=1;
  lcount:=rate;
  lout  :=0;

  msecs:=0;
  while true do begin
  // new Lemming...
   if (msecs>=10) then begin
    dec(msecs,10);
    move(OffScr,Pixels,SizeOf(Pixels)); // restore background
    for i:=0 to lout-1 do Lemms[i].draw; // add lemmings
    if snow then updatesnow; // add snow
    updatecounts; // add scores
    update; // draw screen
    if ((lout < lmax) and (not armageddon)) then begin // new lemming ?
     dec(lcount);
     if (lcount = 0) then begin
      lcount:=rate;
      lemms[lout].alive:=true;
      lemms[lout].x:=startx;
      lemms[lout].y:=starty;
      lemms[lout].anim:=walkleft;
      inc(lout);      // total # of lemings
      inc(lactive);   // # active lemmings
     end;
    end;
   end;

   if armageddon and (lactive=0) then break;
   if (lout = lmax-1) and (lactive=0) then break;

  // button click
   command:=GetClick(ButtonClicks);

  // pause
   if (command=8) then begin
    SetButton(8,b2^,Pixels);
    Update;
    repeat command:=GetClick(ButtonClicks) until command>=0;
    if command=8 then command:=-1;
    msecs:=0;
   end;

  // no more available ?
   if (command in [0..7])and(counter[command]=0) then command:=-1;

  // highlight button
   if (command>=0)and(command<10) then begin
    SetButton(action,b1^,OffScr); // un-highlight old action
    action:=command;
    SetButton(action,b2^,OffScr); // highlight new action
    play(ChangeOp,true);
   end;

  // armageddon
   if (command=9) and (not armageddon) then begin
    if not confirm then
     confirm:=true
    else begin
     for i:=0 to lout-1 do Lemms[i].bomb;
     armageddon:=true;
    end;
   end;

  // not a button, maybe a lemming ?
   if command=10 then begin
    i:=0;
   // try until a lemming can be clicked
    while (i<lout)and(not lemms[i].Click) do inc(i);
   end;

  end;
  for i:=0 to 79 do lemms[i].Free;
 end;

{ main; }
begin
 GraphMode;

 PlayMidi('lemmings.mid');
 InitWav;

 LemSpr:=LoadBMP('LemAnim', nil);
 b1:=LoadBMP('Buttons', nil);
 b2:=LoadBMP('BButtons',nil);

 InitFrames;

 for i:=0 to FLAKES-1 do begin
  snx[i] := random(240);
  sny[i] := i mod 240;
 end;

 while title do playgame;

 DoneWav;
 TextMode;
end.

