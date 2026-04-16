unit Solution;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, gifimage;

type
  TForm2 = class(TForm)
    Image1: TImage;
    PM1: TPopupMenu;
    M2: TMenuItem;
    M11: TMenuItem;
    M1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure M2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;
  zusatzbildstring2:string;

implementation

{$R *.DFM}

procedure TForm2.FormCreate(Sender: TObject);
var
  x:integer;
procedure loesungladen(const kk:string);
var
  Stream		: TStream;
  GIF			: TGIFImage;
  Bitmap		: TBitmap;
begin
  Stream := TResourceStream.Create(hinstance,kk,'GIF');
  try
    GIF := TGIFImage.Create;
    try
      GIF.LoadFromStream(Stream);
      Image1.Picture.Assign(nil);
      Bitmap := TBitmap.Create;
      try
        Bitmap.Assign(GIF);
        Image1.Picture.Assign(Bitmap);
      finally
        Bitmap.Free;
      end;
    finally
      GIF.Free;
    end;
  finally
    Stream.Free;
  end;
end;
begin
    loesungladen(zusatzbildstring2);

    Form2.clientwidth:=Image1.Picture.bitmap.width;
    Form2.clientheight:=Image1.Picture.bitmap.height;

    if Form2.top+Form2.height+30>screen.height then
    begin
      x:=screen.height-Form2.height-30;
      if x<0 then x:=0;
      Form2.top:=x;
    end;
end;

procedure TForm2.M2Click(Sender: TObject);
begin
    close
end;

end.
