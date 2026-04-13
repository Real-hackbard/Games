unit Inflate;

interface

implementation

procedure zInflate(src,dst:pointer);

 var
  Bits    :integer;
  BitsLeft:integer;

  procedure NextByte;
   begin
    Bits:=byte(src^);
    inc(integer(src));
    BitsLeft:=8;
   end;

  function GetBits(count:byte):word; { return "count" bits }
   Var
    Left:integer;
   begin
   { check BitsLeft }
    if BitsLeft=0 then NextByte;
   { more bits left then needed ? }
    if count<=BitsLeft then begin
     Result:=Bits and ((1 shl Count)-1);
     Dec(BitsLeft,Count);
     Bits:=Bits shr Count;
    end else begin { else, take all and add 8 more }
     Result:=Bits;
     Left:=BitsLeft; { save BitsLeft cause LZNext set it to 8 }
     Dec(Count,BitsLeft);
     BitsLeft:=0; NextByte; { so BitsLeft=8 }
     Result:=Result or GetBits(Count) shl Left;
    end;
   end;

  procedure iStored;
   var
    i,len:integer;
   begin
   // !! boundary !
    BitsLeft:=0;
    len:=GetBits(16);
    if (not len)<>GetBits(16) then halt;
    move(src^,dst^,len);
    inc(integer(src),len);
   end;


  procedure iFixed;
   begin
    halt;
   end;

  procedure iDynamic;
   begin
   
   end;

 begin
  BitsLeft:=0;
  while GetBits(1)=0 do begin
   case GetBits(2) of
    0: iStored;
    1: iFixed;
    2: iDynamic;
   end;
  end;
 end;

// ZIP
Type
 PK34= packed record
  PKxx   :longinter; // 'PK'#1#2
  version:word;
  flags  :word;
  method :word;
  time   :integer;
  crc32  :integer;
  zsize  :integer;
  xsize  :integer;
  namelen:word;
  xlength:word;
 // filename[namelen] of char;
 // extra[xlength] of byte;
 end;

function UnZIP_PK34(src:pointer):pointer;
 begin
  with PK34(src^) do begin
   GetMem(Result,RealSize);
   inc(integer(src,SizeOf(PK34)+NameLen+xLength);
   zInflate(src,Result);
  end;
 end;

end.
