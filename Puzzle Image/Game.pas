unit Game;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, math, Menus, MMSystem, SoundPlayerThread;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Button2: TButton;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Image2: TImage;
    lblAvert: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;

    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1Click(Sender: TObject);
    function MoveBlock(x,y:integer):boolean;
    procedure Init;
    procedure placeBlanc(x,y:integer);
    procedure InitMatrice(x,y:integer);
    procedure Button1Click(Sender: TObject);
    procedure DrawGrid;
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Procedure Selection(x,y:integer);
    function Comparer:boolean;
  private
    { Declarations privates }
  public
    { Declarations public }
    position:record
                   x,y:integer;
                   end;
    matrix:array[0..32] of array[0..32] of boolean;
    start:boolean;
    filename:string;
    click:boolean;
    endgame:boolean;
    SizeGrid:integer;
  end;

var
  Form2: TForm2;
  ms: TMemoryStream;

implementation

uses Unit1;

{$R *.DFM}
procedure PlayWaveStream(Stream: TMemoryStream);
begin
  if Stream = nil then
    sndPlaySound(nil, SND_ASYNC) //stop sound
  else
    sndPlaySound(Stream.Memory, (SND_ASYNC or SND_MEMORY));
end;

function TForm2.MoveBlock(x,y:integer):boolean;
var
   Size:record
           x,y:real;
          end;
   i,j:integer;
   REctCopySource:trect;
   REctCopyDest:trect;
   destx,desty:integer;
   moveable:boolean;
begin
  moveable:=false;

  if x>0 then if matrix[x-1][y]=false then
     begin
       destx:=x-1;
       desty:=y;
       moveable:=true;
     end;

  if x<SizeGrid then if matrix[x+1][y]=false then
     begin
       destx:=x+1;
       desty:=y;
       moveable:=true;
     end;

  if y>0 then if matrix[x][y-1]=false then
     begin
       destx:=x;
       desty:=y-1;
       moveable:=true;
     end;

  if y<SizeGrid then if matrix[x][y+1]=false then
     begin
       destx:=x;
       desty:=y+1;
       moveable:=true;
     end;

  if moveable=false then
     begin
       result:=false;
       exit;
     end;

  Size.x:=(image1.picture.width/SizeGrid);
  Size.y:=(image1.picture.height/SizeGrid);

  rectcopySource.Left:=floor(x*Size.x);
  rectcopySource.Top:=floor(y*Size.y);
  rectcopySource.Right:=floor((x+1)*(Size.x));
  rectcopySource.bottom:=floor((y+1)*(Size.y));
  rectcopyDest.Left:=floor(destx*Size.x);
  rectcopyDest.Top:=floor(desty*Size.y);
  rectcopyDest.Right:=floor((destx+1)*(Size.x));
  rectcopyDest.bottom:=floor((desty+1)*(Size.y));
  image1.Canvas.CopyRect(rectcopydest,image1.canvas,rectcopysource);
  
  matrix[destx][desty]:=true;
  result:=true;
end;

procedure TForm2.placeBlanc(x,y:integer);
var
   posx,posy:integer;
   top,right,left,bottom:integer;
begin
  matrix[x][y]:=false;

  x:=floor(x*image1.picture.width/SizeGrid);
  y:=floor(y*image1.picture.height/SizeGrid);

  top:=y;
  bottom:=top+floor(image1.picture.height/SizeGrid);
  left:=x;

  right:=left+floor(image1.picture.width/SizeGrid);
  image1.Canvas.Brush.color:=clpurple;
  image1.canvas.Brush.Style:=bsSolid;
  image1.Canvas.Rectangle(left,top,right,bottom);
  image1.Canvas.Brush.color:=clred;
  image1.canvas.Brush.Style:=bsDiagCross;
  image1.Canvas.Rectangle(left,top,right,bottom);
end;

procedure TForm2.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  position.x:=X;
  position.y:=Y;
end;

procedure TForm2.Image1Click(Sender: TObject);
var
   x,y:integer;
begin
  if Form1.CheckBox1.Checked = true then
  begin
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Wav\move.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end;

  click:=true;
  x:=floor(SizeGrid*position.x/image1.Width);
  y:=floor(SizeGrid*position.y/image1.height);

  if start=true then
  begin
     start:=false;
     image1.Picture.LoadFromFile(filename);
     Image2.Picture.LoadFromFile(filename);
     Selection(x,y);
     Image2.picture:=image1.picture;
     Button1.enabled:=true;
     lblAvert.caption:='<--- Click here !!';
     exit;
  end;

  if endgame=true then exit;
  if matrix[x][y]=false then exit;

  if moveblock(x,y)=true then
  begin
    placeBlanc(x,y);
    //Form1.edit1.text:=inttostr(Strtoint(Form1.Edit1.text)+1);
  end;

  if comparer=true then
  begin
    EDit1.text:='Ok';

    if Form1.CheckBox1.Checked = true then
  begin
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Wav\won.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end;


  end
  else
    Edit1.text:='Pas OK';
end;

procedure TForm2.DrawGrid;
var
   Size:record
                x,y:real;
                end;
   i,temp:integer;
begin
  Size.x:=(image1.picture.width/SizeGrid);
  Size.y:=(image1.picture.height/SizeGrid);

  for i:=1 to SizeGrid-1 do
  begin
    temp:=floor(Size.x*i);
    image1.canvas.moveto(temp,0);
    image1.canvas.lineto(temp,image1.height);
  end;

  for i:=1 to SizeGrid-1 do
  begin
    temp:=floor(Size.y*i);
    image1.canvas.moveto(0,temp);
    image1.canvas.lineto(image1.width,temp);
  end;
end;

procedure TForm2.Init;
var
   Size:record
    x,y:integer;
    end;
   i:integer;
begin
  Form1.edit1.text:='0';
end;

Procedure TForm2.Selection(x,y:integer);
begin
  InitMatrice(x,y);
  Placeblanc(x,y);
end;

procedure TForm2.InitMatrice(x,y:integer);
var
   i,j:integer;
begin
  for i:=0 to SizeGrid do
      for j:=0 to SizeGrid do
          matrix[i][j]:=true;
  matrix[x,y]:=false;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
   i,x,y,max:integer;
begin
  init;
  endgame:=false;
  lblavert.visible:=false;
  max:=1000*SizeGrid;

  if SizeGrid=32 then max:=50000;
  for i:=1 to max do
  begin
    x:=random(SizeGrid);
    y:=random(SizeGrid);
    if matrix[x][y]=false then
      next;

    if moveblock(x,y)=true then
      placeBlanc(x,y);
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Img\Chinese.bmp');
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  init;
  DrawGrid;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.close;
  ms.Free;
  Application.Terminate;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  DrawGrid;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  endgame:=true;
  ms := TMemoryStream.Create;
  filename:= ExtractFilePath(Application.ExeName) + 'Img\Chinese.bmp';
  start:=true;
  click:=false;
  SizeGrid:=4;
  lblAvert.visible:=true;
  lblavert.caption:='Click on the starting square.';
end;

function TForm2.comparer:boolean;
var
  i,j:integer;
  hauteur,largeur:integer;
  Color1,Color2:tcolor;
  match:longint;
begin
  Match:=-1;
  Largeur:=Image2.Picture.Bitmap.Width;
  Hauteur:=Image2.Picture.Bitmap.height;
  click:=false;
  for i:=1 to largeur do
      begin
      for j:=1 to hauteur do
          begin
            if j/50-floor(j/50)<>0 then
             next;
            application.processmessages;
            if click=true then
            begin
               click:=false;
               exit;
            end;

            Color1:=Image2.picture.bitmap.canvas.Pixels[i,j];
            Color2:=image1.Picture.Bitmap.canvas.pixels[i,j];

            if Color1=Color2 then
            begin
               inc(match);
            end;
          end;
      end;
  if floor((match/(i*j))*100)<98 then
     result:=false
  else
    begin
      result:=true;
      endgame:=true;
    end;
end;

end.
