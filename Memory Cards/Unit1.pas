unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, XPMan;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Partie1: TMenuItem;
    New1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    PaintBox1: TPaintBox;
    Options1: TMenuItem;
    Ensembles1: TMenuItem;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure New1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure CardsSetsClick(Sender: TObject);
    procedure Options1Click(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses PCSApi, PathScan, Math;

type
  TCardInfo = record
      Code     : byte;
      PosRect  : TRect;
      Selected : boolean;
      Enabled  : boolean;
  end;

var
  SetsDir      : string;
  PCSImages    : TPCSImages;
  CardsGrid    : array[0..2,0..5] of TCardInfo;
  CsX,CsY      : integer;
  SelCount     : byte;
  Select       : array[0..1] of TPoint;
  WaitForReset : boolean;
  Luckys       : integer;
  YouWin       : boolean;
  YouLoose     : boolean;
  GreatChoice  : boolean;
  BadChoice    : boolean;
  IsInGame     : boolean;

  SetsList     : TStringList;
  PathScanner  : TPathScanner;

procedure DistributeCards;
var
  iY,iX,rX,rY : integer;
begin
  for iY := 0 to 2 do
      for iX := 0 to 5 do
          CardsGrid[iY,iX].Code := 0;

  for iX := 1 to 9 do
      for iY := 0 to 1 do begin
          rX := RandomRange(0,6);
          rY := RandomRange(0,3);
          while CardsGrid[rY,rX].Code <> 0 do begin
             rX := RandomRange(0,6);
             rY := RandomRange(0,3);
          end;
          CardsGrid[rY,rX].Code := iX;
      end;
end;

procedure InitCardsPos(const OffsetX,OffsetY : integer);
var
  X,Y : integer;
begin
  for Y := 0 to 2 do
      for X := 0 to 5 do
          with CardsGrid[Y,X].PosRect do begin
            Left   := OffsetX+(X*110);
            top    := OffsetY+(Y*170);
            right  := OffsetX+((X+1)*110)-10;
            bottom := OffsetY+((Y+1)*170)-10;
          end;
end;

procedure ResetSelection;
var
  X,Y : integer;
begin
  for Y := 0 to 2 do
      for X := 0 to 5 do
          CardsGrid[Y,X].Selected := false;
end;

procedure ResetCards;
var
  X,Y : integer;
begin
  for Y := 0 to 2 do
      for X := 0 to 5 do
          with CardsGrid[Y,X] do begin
               Selected := false;
               Enabled  := false;
          end;
end;

function IsGameWin : boolean;
var
  X,Y : integer;
begin
  result := true;
  for Y := 0 to 2 do
      for X := 0 to 5 do
          result := result and CardsGrid[Y,X].Enabled;
end;
{ ------ }

function CursorOnCard(const X,Y : integer; const ARect : TRect) : boolean;
begin
  result := ((X >= (ARect.Left+4)) and (X <= (ARect.Right-4))) and
            ((Y >= (ARect.Top+4))  and (Y <= (ARect.Bottom-4)));
end;

procedure CursorToCard(const X,Y : integer; var cX,cY : integer);
var
  iX,iY : integer;
begin
  cX := -1;
  cY := -1;
  for iY := 0 to 2 do
      for iX := 0 to 5 do
          if CursorOnCard(X,Y,CardsGrid[iY,iX].PosRect) then begin
             cX := iX;
             cY := iY;
             exit;
          end;
end;

{ ------ }

procedure AbortLoading;
begin
  MessageDLG('Unable to load the game.',mtWarning,[mbOk],0);
  form1.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  SN : String;
  i  : integer;
  g  : TMenuItem;
begin
  Randomize;
  Form1.DoubleBuffered := true;

  CreatePCSImages(PCSImages);
  SetsList := TStringList.Create;

  { search for card sets }
  SetsDir := ExtractFilePath(Application.ExeName)+'CardsSets\';

  PathScanner := TPathScanner.Create;
  with PathScanner do begin
       Directory := SetsDir;
       Filter    := '.pcs';
       UseFilter := true;
       Scan(SetsList);
       Free;
  end;

  if SetsList.Count = 0 then begin
     AbortLoading;
     exit;
  end;

  for i := 0 to SetsList.Count-1 do begin
      GetCardsSetName(SetsDir+SetsList.Strings[i],SN);
      g            := TMenuItem.Create(Ensembles1);
      g.Tag        := i;
      g.AutoCheck  := true;
      g.RadioItem  := true;
      g.GroupIndex := 66;
      g.Caption    := SN;
      g.Checked    := pos('(defaut)',SN) <> 0;
      g.OnClick    := CardsSetsClick;
      Ensembles1.Add(g);
  end;

  if LoadCardsSet(SetsDir+'Default.pcs',PCSImages,SN) then begin
     IsInGame        := false;
     InitCardsPos(10,(PaintBox1.Height div 2)-((3*170) div 2)+5);
     DistributeCards;
  end else begin
     AbortLoading;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreePCSImages(PCSImages);
  SetsList.Free;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  X,Y : integer;
begin
  with PaintBox1.Canvas do begin
       Brush.Color := $c0c0c0c0;
       FillRect(PaintBox1.ClientRect);

       if not IsInGame then begin
          For Y := 0 to 2 do
              For X := 0 to 5 do
                  with CardsGrid[Y,X] do
                       Draw(PosRect.Left,PosRect.Top,PCSImages[Code]);
          exit;
       end;

       For Y := 0 to 2 do
           For X := 0 to 5 do
               with CardsGrid[Y,X] do begin
                    if Selected or Enabled then
                       Draw(PosRect.Left,PosRect.Top,PCSImages[Code])
                    else
                       Draw(PosRect.Left,PosRect.Top,PCSImages[0]);
               end;

       font.Name  := 'arial';
       font.Size  := 14;
       font.Color := clWhite;
       TextOut(PaintBox1.Width-120,10,format('Odds : %d',[Luckys]));
       
       {
       if GreatChoice then
       else
       if BadChoice then

       if YouWin then
       else
       if YouLoose then
       }
  end;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
  iX,iY : integer;
begin
  if not IsInGame then exit;

  for iY := 0 to 2 do
      for iX := 0 to 5 do
          if CursorOnCard(X,Y,CardsGrid[iY,iX].PosRect) and (SelCount < 2) and
             (not CardsGrid[iY,iX].Enabled) and (not CardsGrid[iY,iX].Selected) and
             (not WaitForReset) and (not YouLoose) and (not YouWin) then begin
             PaintBox1.Cursor := crHandPoint;
             exit;
          end else
             PaintBox1.Cursor := crDefault;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if WaitForReset or YouLoose or YouWin or (not IsInGame) then exit;

  if (ssLeft in Shift) then
     CursorToCard(X,Y,CsX,CsY)
  else begin
     CsX := -1;
     CsY := -1;
     SelCount := 0;
  end;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if WaitForReset or YouLoose or YouWin or (not IsInGame) then exit;

  if (CsX <> -1) and (CsY <> -1) and (SelCount < 2) then begin
     CardsGrid[CsY,CsX].Selected := true;
     Select[SelCount] := point(CsX,CsY);
     inc(SelCount);
  end;

  if SelCount = 2 then begin
     if CardsGrid[Select[0].Y,Select[0].X].Code = CardsGrid[Select[1].Y,Select[1].X].Code then begin
        CardsGrid[Select[0].Y,Select[0].X].Enabled  := true;
        CardsGrid[Select[1].Y,Select[1].X].Enabled  := true;
        inc(Luckys);
        GreatChoice := true;
     end else begin
        Dec(Luckys);
        BadChoice   := true;
     end;

     YouLoose  := Luckys = 0;
     YouWin    := IsGameWin;
     if YouLoose or YouWin then
        IsInGame := false;
     Select[0] := point(-1,-1);
     Select[1] := point(-1,-1);
     SelCount  := 0;
     CsX       := -1;
     CsY       := -1;
     WaitForReset := true;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TForm1.FormHide(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

var TickCount : cardinal = 0;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  PaintBox1.Refresh;

  if WaitForReset then
     inc(TickCount);

  if TickCount = (1000 div 45) then begin
     ResetSelection;
     TickCount := 0;
     WaitForReset := false;
     GreatChoice  := false;
     BadChoice    := false;
  end;
end;


procedure TForm1.New1Click(Sender: TObject);
begin
     ResetCards;
     DistributeCards;
     YouWin       := false;
     YouLoose     := false;
     CsX          := -1;
     CsY          := -1;
     SelCount     := 0;
     Select[0]    := point(-1,-1);
     Select[1]    := point(-1,-1);
     WaitForReset := false;
     Luckys       := 7;
     IsInGame     := true;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.CardsSetsClick(Sender: TObject);
var
  SN : string;
begin
  with (Sender as TMenuItem) do begin
       if LoadCardsSet(SetsDir+SetsList.Strings[tag],PCSImages,SN) then
          PaintBox1.Refresh;
  end;
end;

procedure TForm1.Options1Click(Sender: TObject);
begin
  (Sender as TMenuItem).Enabled := IsInGame <> true;
end;

end.
