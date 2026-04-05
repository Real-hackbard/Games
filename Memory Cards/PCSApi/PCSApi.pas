{
  PCS File Structure :

  PCS sign           [8 bytes]
  PNG images         [n bytes * 10]
  PCS sign           [8 bytes]
  PCS cards set name [32 bytes]
  PCS header         [1+4+4 bytes * 10]
}

unit PCSApi;

interface

uses Windows, SysUtils, Classes, Graphics, Jpeg, PngImage, Dialogs;

type
  { container for map images }
  TPCSImages = array[0..9] of TPNGObject;

procedure CreatePCSImages(var PCSImages : TPCSImages);
procedure FreePCSImages(var PCSImages : TPCSImages);

{ loads an image into a TPCSImages }
function LoadImage(const FileName : string; var PCSImages : TPCSImages; const index : integer) : boolean;

{ saving a PCS file }
function SaveCardsSet(const FileName : string; var PCSImages : TPCSImages; const SetName : string) : boolean;

{ loading a PCS file }
function LoadCardsSet(const FileName : string; var PCSImages : TPCSImages; var SetName : string) : boolean;
function GetCardsSetName(const FileName : string; var SetName : string) : boolean;

implementation


procedure CreatePCSImages(var PCSImages : TPCSImages);
var i : integer;
begin
  for i := 0 to 9 do
      PCSImages[i] := TPNGObject.Create;
end;

procedure FreePCSImages(var PCSImages : TPCSImages);
var i : integer;
begin
  for i := 0 to 9 do
      PCSImages[i].Free;
end;


type
  { Image file information for the PCS }
  TPCSInfos = record
     Code   : byte;      { index in the TPCSImages }
     Size   : cardinal;  { stream size }
     Offset : cardinal;  { stream offset in PCS files }
  end;

  { PCS file header }
  TPCSHeader = array[0..9] of TPCSInfos;

const
  { PCS signature }
  PCSSign : int64 = $0000000000534350;


{ utilities ------- }

{ BMP to PNG conversion }
procedure BmpToPng(BMP : TBitmap; PNG : TPngObject);
begin
  PNG.AssignHandle(BMP.Handle,false,$000000);
end;

{ JPG to PNG conversion }
procedure JpgToPng(JPG : TJpegImage; PNG : TPngObject);
var BMP : TBitmap;
begin
  BMP := TBitmap.Create;
  try
     BMP.Width  := JPG.Width;
     BMP.Height := JPG.Height;
     BMP.Canvas.Draw(0,0,JPG);
     PNG.AssignHandle(BMP.Handle,false,$000000);
  finally
     BMP.Free;
  end;
end;

function LoadImage(const FileName : string; var PCSImages : TPCSImages; const index : integer) : boolean;
var Ext : string;
    BMP : Tbitmap;
    JPG : TJpegImage;
    PNG : TPngObject;
begin
  result := false;

  Ext    := LowerCase(ExtractFileExt(FileName));

  if Ext = '.bmp' then begin
     BMP := TBitmap.Create;
     BMP.LoadFromFile(FileName);
     try
        if (BMP.Width <> 100) or (BMP.Height <> 160) then begin
           MessageDLG('image must have the following dimensions : 100x160.',
                  mtWarning,[mbOk],0);
        end else begin
           BmpToPng(BMP, PCSImages[index]);
           result := true;
        end;
      finally
        BMP.Free;
      end;
  end else

  if (Ext = '.jpg') or (Ext = '.jpeg') then begin
     JPG := TJpegImage.Create;
     JPG.LoadFromFile(FileName);
     try
        if (JPG.Width <> 100) or (JPG.Height <> 160) then begin
           MessageDLG('image must have the following dimensions : 100x160.',
                mtWarning,[mbOk],0);
        end else begin
           JpgToPng(JPG, PCSImages[index]);
           result := true;
        end;
     finally
        JPG.Free;
     end;
  end else

  if Ext = '.png' then begin
     PNG := TPngObject.Create;
     PNG.LoadFromFile(FileName);
     try
        if (PNG.Width <> 100) or (PNG.Height <> 160) then begin
           MessageDLG('image must have the following dimensions : 100x160.',
                  mtWarning,[mbOk],0);
        end else begin
           PCSImages[index].Assign(PNG);
           result := true;
        end;
     finally
        PNG.Free;
     end;
  end else
     MessageDLG('Image extension not supported. Only .bmp, .jpg, .jpeg et .png',mtWarning,[mbOk],0);
end;

{ ------- }

function SaveCardsSet(const FileName : string; var PCSImages : TPCSImages; const SetName : string) : boolean;
var TFS : TFileStream;
    TMS : TMemoryStream;
    i   : integer;
    Head: TPCSHeader;
    Name: string[32];
begin
  result := false;

  TFS := TFileStream.Create(FileName,fmCreate);
  try
     { writing the signature }
     TFS.WriteBuffer(PCSSign,SizeOf(int64));

     { writing images }
     for i := 0 to 9 do begin
         TMS := TMemoryStream.Create;
         try
            PCSImages[i].SaveToStream(TMS);
            { retrieving information for the file header }
            Head[i].Code   := i;
            Head[i].Size   := TMS.Size;
            Head[i].Offset := TFS.Position;
            TMS.Position   := 0;
            TFS.CopyFrom(TMS,TMS.Size);
         finally
            TMS.Free;
         end;
     end;

     { writing the signature }
     TFS.WriteBuffer(PCSSign,SizeOf(int64));

     { writing the name of the set }
     Name := SetName;
     TFS.WriteBuffer(Name,32);

     { writing the news }
     for i := 0 to 9 do
         TFS.WriteBuffer(Head[i],SizeOf(TPCSInfos));

     result := true;
  finally
     TFS.Free;
  end;
end;

function LoadCardsSet(const FileName : string; var PCSImages : TPCSImages; var SetName : string) : boolean;
var TFS : TFileStream;
    TMS : TMemoryStream;
    Head: TPCSHeader;
    i   : integer;
    sign: int64;
    Name: string[32];
begin
  result := false;
  if not FileExists(FileName) then exit;
  
  TFS := TFileStream.Create(FileName,fmOpenRead);
  try
     { reading the signature }
     TFS.ReadBuffer(sign,SizeOf(int64));

     if Sign <> PCSSign then begin
        TFS.Free;
        exit;
     end;

     { Move to the end of the file to read the header }
     TFS.Position := TFS.Size - (10*SizeOf(TPCSInfos)) - 32 - 8;

     { reading the signature }
     TFS.ReadBuffer(Sign,SizeOf(Int64));

     if Sign <> PCSSign then begin
        TFS.Free;
        exit;
     end;

     { reading the name of the set }
     TFS.ReadBuffer(Name,32);
     SetName := Name;

     { reading the news }
     for i := 0 to 9 do
         TFS.ReadBuffer(Head[i], SizeOf(TPCSInfos));

     { playback images }
     for i := 0 to 9 do begin
         TMS := TMemoryStream.Create;
         try
            TFS.Position := Head[i].Offset;
            TMS.CopyFrom(TFS,Head[i].Size);
            TMS.Position := 0;
            PCSImages[Head[i].Code].LoadFromStream(TMS);
         finally
            TMS.Free;
         end;
     end;

     result := true;
  finally
     TFS.Free;
  end;
end;

function GetCardsSetName(const FileName : string; var SetName : string) : boolean;
var TFS : TFileStream;
    sign: int64;
    Name: string[32];
begin
  result := false;
  if not FileExists(FileName) then exit;

  TFS := TFileStream.Create(FileName,fmOpenRead);
  try
     { reading the signature }
     TFS.ReadBuffer(sign,SizeOf(int64));

     if Sign <> PCSSign then begin
        TFS.Free;
        exit;
     end;

     { Move to the end of the file to read the header }
     TFS.Position := TFS.Size - (10*SizeOf(TPCSInfos)) - 32 - 8;

     { reading the signature }
     TFS.ReadBuffer(Sign,SizeOf(Int64));

     if Sign <> PCSSign then begin
        TFS.Free;
        exit;
     end;

     { reading the name of the set }
     TFS.ReadBuffer(Name,32);
     SetName := Name;

     result := true;
  finally
     TFS.Free;
  end;
end;
end.
