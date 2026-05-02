unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, Unit2, StdCtrls, Spin, XPMan, SoundPlayerThread,
  MMSystem;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Table: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
  private
    { Private-Deklarationen}
    procedure Win;
  public
    { Public-Deklarationen}
  end;

type
  TSet = set of 1..52;

var
  Form1: TForm1;
  mark: set of 0..52;
  Bmp: TBitmap;
  h: THandle;
  bank: integer = 100; 
  stavka: integer;
  cards: array [1..5] of integer; 
  hold: array [1..5] of boolean; 
  open: boolean = false; 
  again: boolean = false; 
  tref,bubn,piki,cher: TSet; 
  CardNum: array [2..14] of TSet; 
  Pair: boolean = false;
  TwoPair: boolean = false;
  Three: boolean = false;
  FullHouse: boolean = false;
  Four: boolean = false;
  Flush: boolean = false;
  Street: boolean = false;
  ms: TMemoryStream;

implementation

{$R *.DFM}
procedure PlayWaveStream(Stream: TMemoryStream);
begin
  if Stream = nil then
    sndPlaySound(nil, SND_ASYNC) //stop sound
  else
    sndPlaySound(Stream.Memory, (SND_ASYNC or SND_MEMORY));
end;

procedure TForm1.Win;
begin
  ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\win.wav');
  ms.Position := 0;
  PlayWaveStream(ms);
end;

procedure DrawFrame(Image: TImage; Color: TColor; Width: Integer);
begin
  Image.Canvas.Pen.Color := Color;
  Image.Canvas.Pen.Width := Width;
  Image.Canvas.Brush.Style := bsClear; // Füllung ausschalten -> Transparent
  Image.Canvas.Rectangle(0, 0, Image.Width, Image.Height);
end;

Procedure SetClose(count: integer);
var
  i : integer;
begin
  Bmp.Handle := LoadBitmap(h,'#59');
  if count=0 then
  for i:=1 to 5 do
    with Form1 do
    begin
      (FindComponent('Image' + IntToStr(i)) as TImage).Canvas.Draw(0, 0, Bmp);
      hold[i]:=false; 
    end
  else
    with Form1 do
    begin
      (FindComponent('Image' + IntToStr(count)) as TImage).Canvas.Draw(0, 0, Bmp);
      hold[count]:=false; 
    end;
  Form1.Refresh;

  // Computer
  {
  for Computer:=6 to 10 do
  with Form1 do
    begin
  (FindComponent('Image' + IntToStr(Computer)) as TImage).Canvas.Draw(0, 0, Bmp);
  end;
  }
end;

Procedure ClearImages(count: integer);
var
  i: integer;
begin
  with Form1 do
  if count<>0 then
    PatBlt((FindComponent('Image' + IntToStr(count)) as TImage).Canvas.Handle,0,0,71,116,WHITENESS)
  else
  for i:=1 to 5 do
    PatBlt((FindComponent('Image' + IntToStr(i)) as TImage).Canvas.Handle,0,0,71,116,WHITENESS);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
  path: array[0..255] of char;

begin
  Panel1.DoubleBuffered := true;
  Bmp := TBitmap.Create;
  ms := TMemoryStream.Create;

  GetWindowsDirectory(path,sizeOf(path));
  h := LoadLibrary(PChar(ExtractFilePath(Application.Exename) + 'cards.dll'));
  SetClose(0);

  Randomize;

  for i:=2 to 13 do 
    CardNum[i]:=[i,i+13,i+26,i+39];

  CardNum[14]:=[1,14,27,40];

  tref:=[1..13];
  bubn:=[14..26];
  piki:=[40..52];
  cher:=[27..39];

  ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-fan-1.wav');
  ms.Position := 0;
  PlayWaveStream(ms);
end;

function getNumber(i: integer): integer; 
var
  c: integer;
  label label1;
begin
  label1:
  c:=Random(53);
  if c=0 then
    c:=1;

  if (c in mark) then
    goto label1 else Include(mark,c);

  cards[i]:=c;
  Result:=c;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  i, c, l : integer;
begin
  for l := 4 to 9 - 1 do
    begin
        TLabel(findcomponent('Label' + inttostr(l))).Caption := 'Card';
        TLabel(findcomponent('Label' + inttostr(l))).Font.Color := clBlack;
     end;

  if again then
  begin
    // clear cards pixel graphic
    for c := 1 to 6 - 1 do
    begin
        TImage(findcomponent('Image' + inttostr(c))).Picture.Graphic := nil;
     end;

    SetClose(0);
    SpinEdit1.Enabled:=true;
    Label1.Caption:='give card..';
    again:=false;
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-fan-1.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
    Exit;
  end;

  if not open then 
  begin
    Label1.Caption:='give card..';
    SpinEdit1.Enabled:=false;
    stavka:=SpinEdit1.Value;
    Label3.Caption:='Bank: '+IntToStr(bank-stavka)+'$';
    ClearImages(0);
    SetClose(0);
    mark:=[];

    for i:=1 to 5 do
    begin
      Bmp.Handle := LoadBitmap(h,PChar('#'+IntToStr(getNumber(i))));
      (FindComponent('Image' + IntToStr(i)) as TImage).Canvas.Draw(0, 0, Bmp);
      (FindComponent('Image' + IntToStr(i)) as TImage).Refresh;

      ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-1.wav');
      ms.Position := 0;
      PlayWaveStream(ms);

      Sleep(200);
      open:=true; 
    end;
  end
  else  
  begin
    mark:=[];
    for i:=1 to 5 do
    if not hold[i] then  
    begin
      ClearImages(i);
      SetClose(i);
    end
    else
    begin
      Include(mark,cards[i]); 
      ClearImages(i);

      Bmp.Handle := LoadBitmap(h,PChar('#'+IntToStr(cards[i])));
      (FindComponent('Image' + IntToStr(i)) as TImage).Canvas.Draw(0, 0, Bmp);
      (FindComponent('Image' + IntToStr(i)) as TImage).Refresh;
    end;

    Form1.Refresh;
    for i:=1 to 5 do
    begin
      if not hold[i] then
      begin
        ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-1.wav');
        ms.Position := 0;
        PlayWaveStream(ms);

        Sleep(200);
        Bmp.Handle := LoadBitmap(h,PChar('#'+IntToStr(getNumber(i))));
        (FindComponent('Image' + IntToStr(i)) as TImage).Canvas.Draw(0, 0, Bmp);
        (FindComponent('Image' + IntToStr(i)) as TImage).Refresh;
      end;
    end;

    open:=false; 
    again:= true;
    Pair:= false;
    TwoPair:= false;
    Three:= false;
    FullHouse:= false;
    Four:= false;
    Flush:= false;
    Street:= false;  
    IsPair_TwoPair_Three_Full_Four(Pair,TwoPair,Three,FullHouse,Four);
    IsFlush(Flush);
    IsStreet(Street);

    if Street and Flush then
    begin
      Label1.Caption:='Street, you Win!';
      Win;
    end else begin
      Label1.Caption:='You have lost';
      ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\lost.wav');
      ms.Position := 0;
      PlayWaveStream(ms);
    end;

    if Four then
    begin
      Label1.Caption:='Street, you Win!';
      Win;
    end else begin
      Label1.Caption:='You have lost';
      ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\lost.wav');
      ms.Position := 0;
      PlayWaveStream(ms);
    end;

    if FullHouse then
    begin
      Label1.Caption:='Street, you Win!';
      Win;
    end else begin
      Label1.Caption:='You have lost';
      ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\lost.wav');
      ms.Position := 0;
      PlayWaveStream(ms);
    end;

    if Flush then
    begin
      Label1.Caption:='Street, you Win!';
      Win;
    end else begin
      Label1.Caption:='You have lost';
      ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\lost.wav');
      ms.Position := 0;
      PlayWaveStream(ms);
    end;

    if Street then
    begin
      Label1.Caption:='Street, you Win!';
      Win;
    end else begin
      Label1.Caption:='You have lost';
      ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\lost.wav');
      ms.Position := 0;
      PlayWaveStream(ms);
    end;

    if Three then
    begin
      Label1.Caption:='Three of kind, you Win!';
      Win;
    end else begin
      Label1.Caption:='You have lost';
      ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\lost.wav');
      ms.Position := 0;
      PlayWaveStream(ms);
    end;

    if TwoPair then
    begin
      Label1.Caption:='Two Pair, you Win!';
      Win;
    end else begin
      Label1.Caption:='You have lost';
      ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\lost.wav');
      ms.Position := 0;
      PlayWaveStream(ms);
    end;


    if Pair then
    begin
      Label1.Caption:='Pair, you Win!';
      Win;
    end else begin
      Label1.Caption:='You have lost';
      ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\lost.wav');
      ms.Position := 0;
      PlayWaveStream(ms);
    end;

    if Street and Flush then bank:=bank+49*stavka else
    if Four then bank:=bank+29*stavka else             
    if FullHouse then bank:=bank+19*stavka else
    if Flush then bank:=bank+14*stavka else
    if Street then bank:=bank+9*stavka else
    if Three then bank:=bank+5*stavka else
    if TwoPair then bank:=bank+3*stavka else

    if Pair then
    begin
      bank:=bank+stavka;
    end else begin
      bank:=bank-stavka;
    end;

    if bank<=0 then
    begin
      MessageBox(handle,'Youre Bankrupt!','',mb_OK+mb_IconAsterisk+mb_TaskModal);
      SpinEdit1.Value:=1;
      stavka:=1;
      bank:=100;
    end;

    if bank-stavka<0 then 
    begin
      SpinEdit1.Value:=bank;
      stavka:=bank;
    end;
    
    Label3.Caption:='Bank: '+IntToStr(bank-stavka)+'$';
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Bmp.Free;
  ms.Free;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  if not open then exit;

  PatBlt(Image1.Canvas.Handle,0,0,Image1.Width,Image1.Height,WHITENESS);
  Bmp.Handle := LoadBitmap(h,PChar('#'+IntToStr(cards[1])));

  if not hold[1] then
  begin
    Image1.Picture.Graphic := nil;
    Image1.Canvas.Draw(0, 0, Bmp);
    DrawFrame(Image1, clNavy, 5);
    Label4.Caption := 'Hold';
    Label4.Font.Color := clWhite;

    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-3.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end else begin
    Image1.Picture.Graphic := nil;
    Image1.Canvas.Draw(0, 0, Bmp);
    Label4.Caption := 'Drop';
    Label4.Font.Color := clBlack;

    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-4.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end;
  Image1.Refresh;
  hold[1]:= not hold[1]; 
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  if not open then exit;

  PatBlt(Image2.Canvas.Handle,0,0, Image2.Width, Image2.Height,WHITENESS);
  Bmp.Handle := LoadBitmap(h,PChar('#'+IntToStr(cards[2])));

  if not hold[2] then
  begin
    Image2.Picture.Graphic := nil;
    Image2.Canvas.Draw(0, 0, Bmp);
    DrawFrame(Image2, clNavy, 5);
    Label5.Caption := 'Hold';
    Label5.Font.Color := clWhite;

    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-3.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end else begin
    Image2.Picture.Graphic := nil;
    Image2.Canvas.Draw(0, 0, Bmp);
    Label5.Caption := 'Drop';
    Label5.Font.Color := clBlack;
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-4.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end;
  Image2.Refresh;
  hold[2]:= not hold[2];
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
  if not open then exit;
  PatBlt(Image3.Canvas.Handle,0,0,Image3.Width,Image3.Height,WHITENESS);
  Bmp.Handle := LoadBitmap(h,PChar('#'+IntToStr(cards[3])));

  if not hold[3] then
  begin
    Image3.Picture.Graphic := nil;
    Image3.Canvas.Draw(0, 0, Bmp);
    DrawFrame(Image3, clNavy, 5);
    Label6.Caption := 'Hold';
    Label6.Font.Color := clWhite;

    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-3.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end else begin
    Image3.Picture.Graphic := nil;
    Image3.Canvas.Draw(0, 0, Bmp);
    Label6.Caption := 'Drop';
    Label6.Font.Color := clBlack;
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-4.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end;
  Image3.Refresh;
  hold[3]:= not hold[3];
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
  if not open then exit;
  PatBlt(Image4.Canvas.Handle,0,0,Image4.Width,Image4.Height,WHITENESS);
  Bmp.Handle := LoadBitmap(h,PChar('#'+IntToStr(cards[4])));

  if not hold[4] then
  begin
    Image4.Picture.Graphic := nil;
    Image4.Canvas.Draw(0, 0, Bmp);
    DrawFrame(Image4, clNavy, 5);
    Label7.Caption := 'Hold';
    Label7.Font.Color := clWhite;

    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-3.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end else begin
    Image4.Picture.Graphic := nil;
    Image4.Canvas.Draw(0, 0, Bmp);
    Label7.Caption := 'Drop';
    Label7.Font.Color := clBlack;
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-4.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end;
  Image4.Refresh;
  hold[4]:= not hold[4];
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
  if not open then exit;
  PatBlt(Image5.Canvas.Handle,0,0,Image5.Width,Image5.Height,WHITENESS);
  Bmp.Handle := LoadBitmap(h,PChar('#'+IntToStr(cards[5])));

  if not hold[5] then
  begin
    Image5.Picture.Graphic := nil;
    Image5.Canvas.Draw(0, 0, Bmp);
    DrawFrame(Image5, clNavy, 5);
    Label8.Caption := 'Hold';
    Label8.Font.Color := clWhite;

    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-3.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end else begin
    Image5.Picture.Graphic := nil;
    Image5.Canvas.Draw(0, 0, Bmp);
    Label8.Caption := 'Drop';
    Label8.Font.Color := clBlack;
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\card-place-4.wav');
    ms.Position := 0;
    PlayWaveStream(ms);
  end;
  Image5.Refresh;
  hold[5]:= not hold[5];
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  stavka:=SpinEdit1.Value;
  if bank-stavka<0 then
  begin
    stavka:=bank;
    SpinEdit1.Value:=stavka;
  end;
  ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Sounds\bet.wav');
  ms.Position := 0;
  PlayWaveStream(ms);
  Label3.Caption:='Bank: '+IntToStr(bank-stavka)+'$';
end;
end.

