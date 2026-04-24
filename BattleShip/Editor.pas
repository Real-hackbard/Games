unit Editor;    // Table editor

interface                               

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Bmp, Menus;

type
  TForm3 = class(TForm)
    Image2: TImage;
    Panel1: TPanel;
    LabelEdit2: TLabeledEdit;
    LabelEdit3: TLabeledEdit;
    LabelEdit4: TLabeledEdit;
    Label1: TLabel;
    Button2: TButton;
    Button4: TButton;
    Button3: TButton;
    Button1: TButton;
    SB4: TSpeedButton;
    SB3: TSpeedButton;
    SB2: TSpeedButton;
    SB1: TSpeedButton;
    Bevel1: TBevel;
    LabelEdit1: TLabeledEdit;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Image3: TImage;
    Image1: TImage;
    aPanel2: TPanel;
    Bevel2: TBevel;
    Image4: TImage;
    Pion: TImage;
    procedure SB1Click(Sender: TObject);
    procedure PosterPano;
    procedure PosterValues(nb : byte);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MovePawn(nb : byte;x1,y1,x2,y2 : integer);
    procedure Button4Click(Sender: TObject);
    procedure GameProgress;
    procedure Image4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Declarations privates }
    procedure PosterBoat(nb : byte);
  public
    { Declarations public }
  end;

var
  Form3: TForm3;
  tba : array[0..11,0..7] of byte;
  eba : array[1..20] of TBato;
  Fba : file of TBato;

implementation

{$R *.dfm}

var
  sns : byte = 0;
  bac : TBato;
  nba : byte;
  tali : array[1..10] of byte;
  tbli : array[1..10] of byte;
  dx,dy,fx,fy,
  cl1,lg1,cl2,lg2 : integer;
  bta : byte = 0;
  btb : byte = 0;
  pha : byte = 0;

procedure TForm3.SB1Click(Sender: TObject);  // change direction
begin
  sns := (Sender as TSpeedButton).Tag;
  nba := StrToInt(LabelEdit1.Text);
  eba[nba].sens := sns;
  PosterBoat(nba);
end;

procedure TForm3.PosterPano;
var
  i : byte;
  cl,lg : integer;
begin
  for lg := 0 to 7 do
    for cl := 0 to 11 do
    begin
      i := tba[cl,lg];
      if i > 0 then
        Image2.Canvas.Draw(cl*30,lg*30,ron[eba[i].player])
      else Image2.Canvas.Draw(cl*30,lg*30,ron[0]);
    end;
end;

procedure TForm3.PosterValues(nb : byte);
begin
  bac := eba[nb];
  LabelEdit1.Text := IntToStr(nb);
  LabelEdit2.Text := IntToStr(bac.player);
  LabelEdit3.Text := IntToStr(bac.cl);
  LabelEdit4.Text := IntToStr(bac.lg);
  sns := bac.sens;
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  i,x,y : byte;
  cl,lg : integer;
  ok  : boolean;
begin
  for y := 0 to 7 do
    for x := 0 to 11 do tba[x,y] := 0;
  PosterPano;
  MixLives;
  for i := 1 to 10 do
  begin
    tali[i] := i;
    Image1.Canvas.Draw(i*30,0,ron[0]);
    tbli[i] := i+10;
    Image3.Canvas.Draw(i*30,0,ron[0]);
  end;
  for i := 1 to 10 do
  begin
    ok := false;
    repeat
      cl := Random(6);
      lg := Random(7);
      if tba[cl,lg] = 0 then ok := true;
    until ok;
    tba[cl,lg] := i;
    eba[i].sens := Random(4)+1;
    tba[11-cl,7-lg] := i+10;
    eba[i+10].sens := Random(4)+1;
    eba[i].player := 1;
    Image2.Canvas.Draw(cl*30,lg*30,ron[1]);
    eba[i+10].player := 2;
    Image2.Canvas.Draw((11-cl)*30,(7-lg)*30,ron[2]);
    eba[i].lives := tbvie[i];
    eba[i].cl := cl;
    eba[i].lg := lg;
    eba[i+10].lives := tbvie[i+10];
    eba[i+10].cl := 11-cl;
    eba[i+10].lg := 7-lg;
    jr := Random(2)+1;
  end;
end;

procedure TForm3.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if pha = 0 then
  begin
    cl1 := X div 30;
    lg1 := Y div 30;
    nba := tba[cl1,lg1];
    if nba = 0 then
    begin
      if bta = 0 then exit;
      if tba[cl1,lg1] = 0 then           // Adding a boat
      begin
        tba[cl1,lg1] := bta;
        eba[bta].cl := cl1;
        eba[bta].lg := lg1;
        eba[bta].lives := tbvie[bta];
        if bta < 11 then
        begin
          tali[bta] := 0;
          Image1.Canvas.Draw(bta*30,0,ron[0]);
          Image2.Canvas.Draw(cl1*30,lg1*30,ron[1]);
          eba[bta].sens := 1;
        end
        else
          begin                     
            tbli[bta-10] := 0;
            Image3.Canvas.Draw((bta-10)*30,0,ron[0]);
            Image2.Canvas.Draw(cl1*30,lg1*30,ron[2]);
            eba[bta].sens := 3;
          end;
        PosterValues(bta);
        PosterBoat(bta);
        bta := 0;
      end;
      exit;
    end;
    if Button = mbRight then     // removal of a boat
    begin
      Image2.Canvas.Draw(cl1*30,lg1*30,ron[0]);
      eba[nba].cl := 0;
      eba[nba].lg := 0;
      if nba < 11 then
      begin
        tali[nba] := nba;
        Image1.Canvas.Draw(nba*30,0,ron[1]);
      end
      else
        begin
          tbli[nba-10] := 0;
          Image3.Canvas.Draw((nba-10)*30,0,ron[2]);
        end;
      Exit;
    end;
    dx := cl1 * 30;
    dy := lg1 * 30;
    Image2.Canvas.Draw(dx,dy,ron[3]);
    Image2.Repaint;
    pha := 1;
  end
  else
    begin                 // boat movement
      pha := 0;
      cl2 := X div 30;
      lg2 := Y div 30;
      if tba[cl2,lg2] > 0 then   // destination occupied
      begin
        if nba in[1..10] then Image2.Canvas.Draw(cl1*30,lg1*30,ron[1])
        else Image2.Canvas.Draw(cl1*30,lg1*30,ron[2]);
        if tba[cl2,lg2] <> nba then
        begin
          nba := tba[cl2,lg2];
          cl1 := cl2;
          lg1 := lg2;
          Image2.Canvas.Draw(cl1*30,lg1*30,ron[3]);
          dx := cl1 * 30;
          dy := lg1 * 30;
          pha := 1;
          exit;
        end;
        if nba in[1..10] then Image2.Canvas.Draw(cl1*30,lg1*30,ron[1])
        else Image2.Canvas.Draw(cl1*30,lg1*30,ron[2]);
        Image2.Repaint;
        PosterValues(nba);
        PosterBoat(nba);
        exit;
      end;
      fx := cl2 * 30;
      fy := lg2 * 30;
      Pion.Picture.Bitmap := ron[3];
      Pion.Left := dx+5;
      Pion.Top := dy+40;
      Image2.Canvas.Draw(dx,dy,ron[0]);
      Pion.Visible := true;
      eba[nba].cl := cl2;
      eba[nba].lg := lg2;
      MovePawn(nba,dx,dy,fx,fy);
      if nba in[1..10] then Image2.Canvas.Draw(fx,fy,ron[1])
      else Image2.Canvas.Draw(fx,fy,ron[2]);
      Pion.Visible := false;
      Pion.Top := 5;
      tba[cl1,lg1] := 0;
      tba[cl2,lg2] := nba;
      PosterValues(nba);
      PosterBoat(nba);
    end;
end;

procedure TForm3.MovePawn(nb : byte;x1,y1,x2,y2 : integer);
var
  xo,yo,
  xd,yd,
  ix,iy,np : integer;
begin             // sliding movement
  xo := x1;       // initial position of the boat
  yo := y1;
  xd := x2;       // final position
  yd := y2;
  np := 30;       // Number of steps = number of squares * half the length of a square
  ix := (xd-xo) div np;    // length of a step
  iy := (yd-yo) div np;
  repeat
    xo := xo+ix;
    yo := yo+iy;
    Pion.Left := xo+5;      // we move the boat
    Pion.Top := yo+40;
    Pion.Repaint;
    Image2.Repaint;
    dec(np);
    Sleep(10);
  until np = 0;
end;

procedure TForm3.Button3Click(Sender: TObject);
var
  i : byte;
  fn : string;
begin
  if SaveDialog1.Execute then
  begin
    fn := SaveDialog1.FileName;
    if ExtractFileExt(fn) = '' then fn := fn+'.BN5';
    AssignFile(Fba,fn);
    Rewrite(Fba);
    for i := 1 to 20 do Write(Fba,eba[i]);
    CloseFile(Fba);
  end;
end;

procedure TForm3.Button4Click(Sender: TObject);
var
  i,x,y : byte;
begin
  if OpenDialog1.Execute then
  begin
    MixLives;
    for y := 0 to 7 do
      for x := 0 to 11 do tba[x,y] := 0;
    AssignFile(Fba, OpenDialog1.FileName);
    Reset(Fba);
    for i := 1 to 20 do
    begin
      Read(Fba,eba[i]);
      with eba[i] do
      begin
        if lives > 0 then
        begin
          tba[cl,lg] := i;
          eba[i].lives := tbvie[i];
          if i < 11 then
          begin
            tali[i] := 0;
            Image1.Canvas.Draw(i*30,0,ron[0]);
            Image2.Canvas.Draw(cl*30,lg*30,ron[1]);
          end
          else begin
                 tbli[i-10] := 0;
                 Image3.Canvas.Draw((i-10)*30,0,ron[0]);
                 Image2.Canvas.Draw(cl*30,lg*30,ron[2]);
               end;
        end
        else begin
               tba[cl,lg] := 0;
               if i < 11 then
               begin
                 tali[i] := i;
                 Image1.Canvas.Draw(i*30,0,ron[1]);
                 Image2.Canvas.Draw(cl*30,lg*30,ron[0]);
               end
               else begin
                      tbli[i-10] := i;
                      Image3.Canvas.Draw((i-10)*30,0,ron[2]);
                      Image2.Canvas.Draw(cl*30,lg*30,ron[0]);
                    end;
             end;
      end;
    end;
    CloseFile(Fba);
    PosterPano;
  end;
end;

procedure TForm3.GameProgress;   // is loaded into the editor
var
  i,x,y : byte;
begin
  for y := 0 to 7 do
    for x := 0 to 11 do tba[x,y] := 0;
  for i := 1 to 20 do
  begin
    eba[i] := batos[i];
    if eba[i].lives > 0 then
      tba[eba[i].cl,eba[i].lg] := i
    else if i in[1..10] then tali[i] := i
         else tbli[i-10] := i;
  end;
  PosterPano;
  for i := 1 to 10 do
  begin
    if tali[i] > 0 then
      Image1.Canvas.Draw(i*30,0,ron[1]);
    if tbli[i] > 0 then
      Image3.Canvas.Draw(i*30,0,ron[2]);
  end;
end;

procedure TForm3.PosterBoat(nb : byte);
var
  bo : TBato;
begin
  bo := eba[nb];
  bato.Assign(tbmod[bo.player,bo.lives]);
  case bo.sens of
    2 : begin
          Rotation(bato);
        end;
    3 : begin
          Rotation(bato);
          Rotation(bato);
        end;
    4 : begin
          Rotation(bato);
          Rotation(bato);
          Rotation(bato);
        end;
  end;
  bato.Transparent := true;
  Image4.Picture.Bitmap.Assign(bato);
end;

procedure TForm3.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bta := X div 30;
  Image1.Canvas.Draw(bta*30,0,ron[3]);
end;

procedure TForm3.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bta := X div 30;
  Image3.Canvas.Draw(bta*30,0,ron[3]);
  inc(bta,10);
end;

procedure TForm3.Image4Click(Sender: TObject);  // change number of lives
var
  nb : byte;
begin
  if not debug then exit;
  nb := StrToInt(LabelEdit1.Text);
  inc(eba[nb].lives);
  if eba[nb].lives > 4 then eba[nb].lives := 1;
  PosterBoat(nb);
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  if debug then GameProgress;
end;

end.
