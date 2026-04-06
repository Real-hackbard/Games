// class to learn how to draw any bitmap on a canvas
unit ObjAnimated;

interface

uses Windows, SysUtils, Classes, Graphics, Math,Contnrs, Jpeg, ObjDrawable;

type

  TObjectAnimated = class(TObjDrawable)
  private
    // current image
    fTextureEnCours : integer;
    // List of images that make up the cartoon
    fTextureList : TObjectList;
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect);
    destructor Destroy; override;
    // nbX,nbY, number of images in X
    // Width, Height; the length and width dimensions of each sprite
    procedure CreateSprite(FileName : String ; ANbX,AWidth , AHeight : integer ; ATransparentColor : TColor);

    procedure Draw;      // Procedure to call to draw on the canvas
    function  NombreTexture : integer;

  end;

implementation

constructor TObjectAnimated.Create(ACanvas : TCanvas; AMoveRect : TRect);
begin
  inherited Create(ACanvas , AMoveRect );
  fTextureEnCours := 0;
  fTextureList := TObjectList.Create(True);
end;

destructor TObjectAnimated.Destroy;
begin
  fTextureList.Free;
  inherited destroy;
end;

procedure TObjectAnimated.CreateSprite(FileName : String ; ANbX,AWidth , AHeight : integer ; ATransparentColor : TColor);
var
  BitmapTmp : TBitmap;
  bitmapSprite : TBitmap;
  x:integer;
  Dest,Source : TRect;
begin
  BitmapTmp := TBitmap.Create;
  BitmapTmp.LoadFromFile(FileName);
  for x:= 0 to ANbX-1 do begin
    bitmapSprite := TBitmap.Create;
    bitmapSprite.Width := AWidth;
    bitmapSprite.Height := AHeight;
    // calculating the position within the image, the large one, the one containing the sprites
    Dest:=Rect(0,0,bitmapSprite.Width,bitmapSprite.Height);
    Source:=Rect(x*AWidth,0,(x*AWidth)+AWidth,AHeight);
    // We cut it out and paste it into the sprite image

    bitmapSprite.Canvas.CopyRect(Dest , BitmapTmp.Canvas , Source);
    bitmapSprite.TransparentColor:=ATransparentColor;
    bitmapSprite.Transparent:=True;

    // We add to the list of textures...
    fTextureList.Add(bitmapSprite);
  end;
  // we release the bitmap that contained the large image
  BitmapTmp.Free;
end;

function TObjectAnimated.NombreTexture : integer;
begin
  result := fTextureList.Count-1;
end;
procedure TObjectAnimated.Draw;
begin
  fTextureEnCours := fTextureEnCours + 1;
  if(fTextureEnCours > fTextureList.Count-1) then fTextureEnCours:=0;


  // If the list is not empty, we pass the current image to our Image
  // Otherwise, the default image will be drawn...
  if not (fTextureList.Count = 0) then
    Image.Assign(TBitmap(fTextureList.Items[fTextureEnCours]));

  inherited Draw;
end;

end.
