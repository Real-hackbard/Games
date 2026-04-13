program ega_tga;

const
 EGA=$10; MXX=640; MXY=350;
 LIN:word=(MXX div 8);

 MODE =$05;
  W0=$0000;
  W1=$0100;
  W2=$0200;
  W3=$0300;
  R0=$0000; { Read Map Select }
  R1=$0800; { Color Compare   }

 SELECT=$04;
  RM0=$0000;
  RM1=$0100;
  RM2=$0200;
  RM3=$0300;

var
 ColorIndex:array[0..16] of byte;

Procedure GraphMode; assembler;
 asm
  MOV AX,EGA        { EGA 640x350x16 }
  INT 10h

  MOV DX,$3CE       { Write Mode 0 & Read Mode 0 }
  MOV AX,MODE+R0+W0
  OUT DX,AX

  MOV AX,$0003      { Function MOVE }
  OUT DX,AX

  MOV AX,SEG @DATA
  MOV ES,AX
  MOV DX,offset ColorIndex
  MOV AX,$1009
  INT 10h

 end;

Procedure TextMode; assembler;
 asm
  MOV AX,03h
  INT 10h
 end;

Procedure Palette(var p); assembler;
 asm
  les bx,p
  mov dx,$3C8
  mov al,0
  out dx,al
  inc dx
  mov cx,256
  @next:
   mov al,es:[bx+2]; shr al,2
   out dx,al
   mov al,es:[bx+1]; shr al,2
   out dx,al
   mov al,es:[bx+0]; shr al,2
   out dx,al
   add bx,3
  loop @next
 end;

Procedure SetColor(c:Word);assembler;
 asm
  MOV DX,$3CE

  MOV AH,BYTE(c)
  AND AX,$0F00
  OUT DX,AX      { Set Write mode 0 color }

  MOV AX,$0F01
  OUT DX,AX      { Use Register 0 color   }
 end;

Procedure SetPixel(x,y:word); assembler;
 asm
  MOV CX,X     { X }
  CMP CX,MXX
  JAE @Done

  MOV AX,Y     { Y }
  CMP AX,MXY
  JAE @Done
  MUL LIN

  MOV DI,CX
  SHR DI,3     { VideoOfs(X,Y)=LIN*Y+X/8 }
  ADD DI,AX

  MOV DX,$3CE    { Select pixel }
  MOV AX,$8008   { Bit mask }
  AND CL,$07     { x mod 8 }
  SHR AH,CL
  OUT DX,AX

  MOV AX,$0F01
  OUT DX,AX      { Use Register 0 color   }

  MOV ES,SegA000 { VideoSeg=$A000 }
  OR ES:[DI],AL

 @Done:
 end;

var
 f:file;
 p:packed array[0..255,0..2] of byte;
 w,h,e:word;
 b:pchar;
 x,y:integer;
 m:array[0..255] of integer;
 c:integer;

procedure setpalette(i:integer; var rgb); assembler;
 asm
  mov ax,i
  mov dx,$3C8
  out dx,al
  inc dx
  les bx,rgb
  mov al,es:[bx+2]; out dx,al
  mov al,es:[bx+1]; out dx,al
  mov al,es:[bx+0]; out dx,al
 end;

procedure plot(x,y,z:integer);
 begin
  if m[z]<0 then begin
   if c>17 then begin
    textmode;
    writeln('too many colors');
    halt;
   end;
   m[z]:=c;
   setpalette(ColorIndex[c],p[z]);
   inc(c);
  end;
  setcolor(m[z]);
 {setcolor(z);}
  setpixel(x,y);
 end;

begin
 if paramcount=0 then begin
  writeln('egatga [filename.tga]');
  exit;
 end;
 assign(f,paramstr(1));
 reset(f,1);
 seek(f,12);
 blockread(f,w,2);
 blockread(f,h,2);
 seek(f,18);
 blockread(f,p,sizeof(p));
 getmem(b,w);
 GraphMode;
 for x:=0 to 15 do setpalette(colorindex[x],p[x]);
 c:=1;
 fillchar(m,sizeof(m),255);
 for y:=h downto 1 do begin
  blockread(f,b^,w);
  for x:=0 to w-1 do begin
   plot(x,y,ord(b[x]));
  end;
 end;
 close(f);
 for y:=0 to 15 do begin
  setcolor(y);
  for x:=0 to 640 do begin
   setpixel(x,y);
  end;
 end;
 readln;
 textmode;
end.