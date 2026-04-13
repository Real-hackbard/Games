Unit EASYCE; { for PC :) }

interface

type
 TPalette:array[0..255,0..2] of byte;

procedure play(wav:string);
function loadtga(tga:string; w,h:integer; var pal:TPalette):pointer;
procedure GraphMode(var pal:TPalette);
var
 clickxpos:integer;
 clickypos:integer;
function clicked:boolean;
procedure snapshot;
procedure update;
procedure bar(x1,y1,x2,y2,c:integer);
procedure print(s:string; x,y,c:word);
function getbuffer:pointer;

implementation

procedure play(wav:string);
 begin
 end;

function loadtga(tga:string; w,h:integer; var pal:TPalette):pointer;
 var
  f   :file;
  p   :pointer;
 begin
  assign(f,tga);
  reset(f,1);
  seek(f,18);
  blockread(f,pal,sizeof(pal));
  getmem(p,w*h);
  blockread(f,p^,w*h);
  close(f);
  loadtga:=p;
 end;

procedure Graphmode(var pal:TPalette);  assembler;
 asm
  mov ax,13h; int 10h;
  push ds
  lds si,pal
  mov dx,$3c8; mov al,0; out dx,al
  mov cx,3*256; rep outsb
  pop  ds
 end;

function clicked:boolean;
 begin
 end;

procedure snapshot;
 begin
 end;

procedure update;
 begin
 end;

procedure bar(x1,y1,x2,y2,c:integer);
 begin
 end;

procedure print(s:string; x,y,c:word);
 begin
 end;

function getbuffer:pointer;
 begin
 end;

end.