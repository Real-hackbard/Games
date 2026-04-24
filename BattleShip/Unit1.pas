unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Math, StdCtrls, Buttons, IniFiles, Editor, Help, ComCtrls,
  finish, Bmp, MMSystem;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Pima: TImage;
    Bevel2: TBevel;
    Button4: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Image3: TImage;
    Bevel1: TBevel;
    Pn1: TPanel;
    Pn2: TPanel;
    Panel1: TPanel;
    Button3: TButton;
    BitBtn1: TBitBtn;
    Image4: TImage;
    TrackBar1: TTrackBar;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReadingTable;
    procedure WhoStarts;
    procedure Corner(bma : TBitmap);
    procedure RotaRight(bmp : TBitmap);
    procedure RotaLeft(bmp : TBitmap);
    procedure BoatPoster(nb : byte);
    procedure MoveBoat(nb : byte;x1,y1,x2,y2 : integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    function  Whatens(nb : byte) : byte;
    procedure Combat(nb : byte);
    procedure Cannon(sn,nm,ne : byte);
    procedure Sinking(nb : byte);
    procedure ComputerGame;
    function Assessment(bn,sn : byte) : Tval;
    function EvSens1(cl,lg : byte) : Tval;
    function EvSens2(cl,lg : byte) : Tval;
    function EvSens3(cl,lg : byte) : Tval;
    function EvSens4(cl,lg : byte) : Tval;
    procedure ApplyTable;
    procedure Image4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Declarations privates }
  public
    { Declarations public }
  end;

var
  Form1: TForm1;
  fond : TBitmap;
  dx,dy,fx,fy : integer;
  cl1, lg1, cl2, lg2 : integer;
  ja : byte;           // attacking player, opponent
  vs : array[0..4] of byte;
  BattleEnd : boolean = false;
  bson : boolean = true;
  quickly : integer;
  fpar : TIniFile;

implementation

{$R *.dfm}
procedure TForm1.FormCreate(Sender: TObject);
var
  i,x,y : integer;
begin
  Randomize;
  DoubleBuffered := true;
  fond := TBitmap.Create;
  fond.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\water.bmp');
  bato := TBitmap.Create;
  bato.Width := dim;
  bato.Height := dim;
  bato.Transparent := true;

  for y := 0 to 7 do
    for x := 0 to 11 do
      Image1.Canvas.Draw(x*dim,y*dim,fond);

  LoadImages;
  dir := ExtractFilePath(Application.ExeName);
  OpenDialog1.InitialDir := dir + 'Data\';
  fpar := TIniFile.Create(dir + 'BNav.ini');
  quickly := fpar.ReadInteger('Options','Speed',15);
  TrackBar1.Position := quickly;
  bson := fpar.ReadBool('Options','Sound',true);

  if bson then
    BitBtn1.Glyph.Assign(ledon)
  else BitBtn1.Glyph.Assign(ledof);
  if FileExists(dir+kfn) then
  begin
    RestoreGame;
    nbnav[1] := 0;
    nbnav[2] := 0;
    for i := 1 to 20 do
      if batos[i].lives > 0 then
      begin
        BoatPoster(i);
        inc(nbnav[batos[i].player]);
        tablo[batos[i].cl,batos[i].lg] := i;
      end;  
    Pn1.Caption := IntToStr(nbnav[1]);
    Pn2.Caption := IntToStr(nbnav[2]);
    jr := 1;
    Bevel1.Top := 40;
    BattleEnd := false;
    phase := 0;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not BattleEnd then SaveGame
  else if FileExists(dir+kfn) then DeleteFile(dir+kfn);
  fond.Free;
  bato.Free;
  ClearImage;
  fpar.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  lg,cl : integer;
begin
  BattleEnd := false;
  phase := 0;
  for lg := 0 to 7 do
    for cl := 0 to 11 do
    begin
      tablo[cl,lg] := 0;
      Image1.Canvas.Draw(cl*dim,lg*dim,fond);
    end;
  MixLives;
  Image4.Visible := true;
end;

procedure TForm1.Image4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  no : integer;
begin
  fn := '';
  Image4.Visible := false;
  if Y > 365 then
  begin
    if OpenDialog1.Execute then    // recorded
    begin
      fn := OpenDialog1.FileName;
      ReadingTable;
    end
    else Exit;
  end
  else
    if Y > 335 then
    begin
      Form3.Button1Click(self);   // random
    end
    else
      begin                       // predefined
        no := (Y div 84) * 2 + X div 124 + 1;
        fn := dir + 'Data\Predef\Tableau'+IntToStr(no)+'.BN5';
        ReadingTable;
      end;
  ApplyTable;
  WhoStarts;
end;

procedure TForm1.ReadingTable;
var
  i : byte;
begin
  AssignFile(Fba,fn);
  Reset(Fba);
  for i := 1 to 20 do
  begin
    Read(Fba,eba[i]);
    eba[i].lives := tbvie[i];
  end;
  CloseFile(Fba);
end;

procedure TForm1.WhoStarts;
begin
  jr := Random(2)+1;
  if jr = 1 then Bevel1.Top := 40
  else
  Bevel1.Top := 144;
  BattleEnd := false;
  if jr = 2 then ComputerGame;
end;

// Displays a boat based on the direction and number of lives
procedure TForm1.BoatPoster(nb : byte);
var
  bo : TBato;
begin
  bo := batos[nb];
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
  Image1.Canvas.Draw(dim*bo.cl,dim*bo.lg,bato);
  Image1.Repaint;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
  n : byte;
begin
  if (jr = 2) or BattleEnd then exit;  // click during computer game or end
  if phase = 1 then                    // Can we change boats? ?
  begin
    n := tablo[X div dim, Y div dim];
    if (n > 0) and (batos[n].player = 1) then  // yes
    begin
      Bevel2.Visible := false;
      Bevel2.Left := 920;
      phase := 0;
    end;
  end;
  if phase = 0 then
  begin
    cl1 := X div dim;
    lg1 := Y div dim;
    noba := tablo[cl1,lg1];
    if noba = 0 then exit;
    if batos[noba].player <> jr then exit;
    dx := cl1 * dim;
    dy := lg1 * dim;
    Bevel2.Left := dx+5;
    Bevel2.Top := dy+5;
    Bevel2.Visible := true;
    phase := 1;
  end
  else
    begin
      Bevel2.Visible := false;
      Bevel2.Left := 920;
      phase := 0;
      cl2 := X div dim;
      lg2 := Y div dim;
      if tablo[cl2,lg2] > 0 then exit;  // destination occupied
      if cl2 > cl1 then
      begin
        for i := cl1+1 to cl2 do
          if tablo[i,lg1] > 0 then exit;  // the way is not clear
      end
      else
        if cl2 < cl1 then
        begin
          for i := cl1-1 downto cl2 do
            if tablo[i,lg1] > 0 then exit;
        end
        else
          if lg2 > lg1 then
          begin
            for i := lg1+1 to lg2 do
              if tablo[cl1,i] > 0 then exit;
          end
          else
            if lg2 < lg1 then
            begin
            for i := lg1-1 downto lg2 do
              if tablo[cl1,i] > 0 then exit;
          end;

      fx := cl2 * dim;
      fy := lg2 * dim;
      if (fx <> dx) and (fy <> dy) then exit; // slanted movement

      BoatPoster(noba);
      Pima.Picture.Bitmap := bato;
      Pima.Left := dx+5;
      Pima.Top := dy+5;
      Image1.Canvas.Draw(dx,dy,fond);
      Pima.Visible := true;
      batos[noba].sens := Whatens(noba);     // position the boat
      batos[noba].cl := cl2;
      batos[noba].lg := lg2;
      MoveBoat(noba,dx,dy,fx,fy);
      BoatPoster(noba);
      Pima.Visible := false;
      Pima.Left := 855;
      tablo[cl1,lg1] := 0;
      tablo[cl2,lg2] := noba;
      Combat(noba);

      if jr = 2 then
      begin
        jr := 1;
        Bevel1.Top := 40;
      end
      else begin
             jr := 2;
             Bevel1.Top := 144;
           end;
    end;
  if jr = 2 then ComputerGame;
end;

function TForm1.Whatens(nb : byte) : byte;
var
  sn : byte;
begin
 sn := batos[nb].sens;
 case sn of
   1 : begin
         if cl1 < cl2 then sn := 1
         else if cl1 > cl2 then
              begin
                sn := 3;
                RotaLeft(bato);
                RotaLeft(bato);
              end
              else if lg1 < lg2 then
                   begin
                     sn := 2;
                     RotaRight(bato);
                   end
                   else if lg1 > lg2 then
                        begin
                          sn := 4;
                          RotaLeft(bato);
                        end;
       end;
   2 : begin
         if lg1 < lg2 then sn := 2
         else if lg1 > lg2 then
              begin
                sn := 4;
                RotaLeft(bato);
                RotaLeft(bato);
              end
              else if cl1 < cl2 then
                   begin
                     sn := 1;
                     RotaLeft(bato);
                   end
                   else if cl1 > cl2 then
                        begin
                          sn := 3;
                          RotaRight(bato);
                        end;
       end;
   3 : begin
         if cl1 > cl2 then sn := 3
         else if cl1 < cl2 then
              begin
                sn := 1;
                RotaLeft(bato);
                RotaLeft(bato);
              end
              else if lg1 < lg2 then
                   begin
                     sn := 2;
                     RotaLeft(bato);
                   end
                   else if lg1 > lg2 then
                        begin
                          sn := 4;
                          RotaRight(bato);
                        end;
       end;
   4 : begin
         if lg1 > lg2 then sn := 4
         else if lg1 < lg2 then
              begin
                sn := 2;
                RotaLeft(bato);
                RotaLeft(bato);
              end
              else if cl1 < cl2 then
                   begin
                     sn := 1;
                     RotaRight(bato);
                   end
                   else if cl1 > cl2 then
                        begin
                          sn := 3;
                          RotaLeft(bato);
                        end;
       end;
  end;
  batos[nb].sens := sn;
  result := sn;
end;

procedure TForm1.Corner(bma : TBitmap);
var
  ec : integer;
  bmp : TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.Width := dim;
  bmp.Height := dim;
  bmp := RotImage(bma, DegToRad(rangle),
         Point(dim div 2, dim div 2), clWhite);
  ec := (bmp.Width - dim) div 2;
  Pima.Left := ix - ec;
  Pima.Top := iy - ec;
  Pima.Width := bmp.Width;
  Pima.Height := bmp.Height;
  Pima.Picture.Bitmap := bmp;
  Pima.Repaint;
  bmp.Free;
end;

procedure TForm1.RotaRight(bmp : TBitmap);
begin
  ix := Pima.Left;
  iy := Pima.Top;
  rangle := 0;
  Pima.Transparent := true;
  while rangle < 90 do
  begin
    rangle := rangle+15;
    Corner(bmp);
  end;
  Rotation(bmp);
  Pima.Picture.Bitmap := bmp;
end;

procedure TForm1.RotaLeft(bmp : TBitmap);
var
  i : byte;
begin
  ix := Pima.Left;
  iy := Pima.Top;
  rangle := 360;
  Pima.Transparent := true;
  while rangle > 270 do
  begin
    rangle := rangle-15;
    Corner(bmp);
  end;
  for i := 1 to 3 do Rotation(bmp);
  Pima.Picture.Bitmap := bmp;
end;

procedure TForm1.MoveBoat(nb : byte;x1,y1,x2,y2 : integer);
var
  xo,yo,
  xd,yd,df,
  ix,iy,np : integer;
begin             // sliding movement
  xo := x1;       // initial position of the boat
  yo := y1;
  xd := x2;       // final position
  yd := y2;
  df := 0;
  case batos[nb].sens of
    1 : df := cl2 - cl1;
    2 : df := lg2 - lg1;
    3 : df := cl1 - cl2;
    4 : df := lg1 - lg2;
  end;
  np := df * 5;    // Number of steps = number of squares * half the length of a square
  ix := (xd-xo) div np;    // length of a step
  iy := (yd-yo) div np;
  repeat
    xo := xo+ix;
    yo := yo+iy;
    Pima.Left := xo+1;      // we move the boat
    Pima.Top := yo+1;
    Pima.Repaint;
    Image1.Repaint;
    dec(np);
    Sleep(quickly);
  until np = 0;
end;

procedure TForm1.Combat(nb : byte);
var
  i,cl,lg : integer;
  na : byte;
begin
  if jr = 1 then ja := 2
  else ja := 1;
  for i := 0 to 4 do vs[i] := 0;
  cl := batos[nb].cl;
  lg := batos[nb].lg;
  if lg > 0 then            // Boat within firing range?
  begin
    na := tablo[cl,lg-1];
    if na > 0 then
      if batos[na].player = ja then vs[4] := na;
  end;
  if lg < 7 then
  begin
    na := tablo[cl,lg+1];
    if na > 0 then
      if batos[na].player = ja then vs[2] := na;
  end;
  if cl > 0 then
  begin
    na := tablo[cl-1,lg];
    if na > 0 then
      if batos[na].player = ja then vs[3] := na;
  end;
  if cl < 11 then
  begin
    na := tablo[cl+1,lg];
    if na > 0 then
      if batos[na].player = ja then vs[1] := na;
  end;
  for i := 1 to 4 do
    if vs[i] > 0 then inc(vs[0]);
  if vs[0] = 0 then Exit;
  case batos[nb].sens of      // enemy ship in front and perpendicular
    1 : if vs[1] > 0 then
        begin
          na := vs[1];
          if batos[na].sens in[2,4] then Cannon(2,na,nb);
        end;
    2 : if vs[2] > 0 then
        begin
          na := vs[2];
          if batos[na].sens in[1,3] then Cannon(0,na,nb);
        end;
    3 : if vs[3] > 0 then
        begin
          na := vs[3];
          if batos[na].sens in[2,4] then Cannon(3,na,nb);
        end;
    4 : if vs[4] > 0 then
        begin
          na := vs[4];
          if batos[na].sens in[1,3] then Cannon(1,na,nb);
        end;
  end;
  case batos[nb].sens of       // enemy boats against flank
    1,3 : begin
            if vs[2] > 0 then
            begin
              Cannon(1,nb,vs[2]);
              if batos[vs[2]].sens in[2,4] then vs[2] := 0;
            end;
            if vs[4] > 0 then
            begin
              Cannon(0,nb,vs[4]);
              if batos[vs[4]].sens in[2,4] then vs[4] := 0;
            end;
          end;
    2,4 : begin
            if vs[1] > 0 then
            begin
              Cannon(3,nb,vs[1]);
              if batos[vs[1]].sens in[1,3] then vs[1] := 0;
            end;
            if vs[3] > 0 then
            begin
              Cannon(2,nb,vs[3]);
              if batos[vs[3]].sens in[1,3] then vs[3] := 0;
            end;
          end;
  end;
  for i := 1 to 4 do
    if vs[i] > 0 then inc(vs[0]);
  if vs[0] = 0 then Exit;
  case batos[nb].sens of                       // Fight back
    1,3 : begin
            if vs[2] > 0 then Cannon(0,vs[2],nb);
            if vs[4] > 0 then Cannon(1,vs[4],nb);
          end;
    2,4 : begin
            if vs[1] > 0 then Cannon(2,vs[1],nb);
            if vs[3] > 0 then Cannon(3,vs[3],nb);
          end;
  end;
end;

procedure TForm1.Cannon(sn,nm,ne : byte);
var
  bm, be : TBato;
  i, xm, ym : integer;
begin
  bm := batos[nm];
  be := batos[ne];
  xm := bm.cl*dim;
  ym := bm.lg*dim;
  if bm.lives = 0 then exit;
  Pima.Picture := nil;
  if bson then
    SndPlaySound(PChar(ExtractFilePath(Application.ExeName) + 'Data\Boom.wav'),
          snd_nodefault or snd_async);
  case sn of                   // selection of the direction of fire
    0 : begin
          Pima.Picture.Bitmap.Assign(tbfeu[0]);
          Pima.Left := xm+5;
          Pima.Top := ym+5;
          Pima.Visible := true;
          for i := 1 to 19 do
          begin
            Pima.Top := Pima.Top - 1;
            Image1.Repaint;
            Sleep(20-i);
          end;
        end;
    1 : begin
          Pima.Picture.Bitmap.Assign(tbfeu[1]);
          Pima.Left := xm+5;
          Pima.Top := ym+5;
          Pima.Visible := true;
          for i := 1 to 19 do
          begin
            Pima.Top := Pima.Top + 1;
            Image1.Repaint;
            Sleep(20-i);
          end;
        end;
    2 : begin
          Pima.Picture.Bitmap.Assign(tbfeu[2]);
          Pima.Left := xm+5;
          Pima.Top := ym+5;
          Pima.Visible := true;
          for i := 1 to 19 do
          begin
            Pima.Left := Pima.Left - 1;
            Image1.Repaint;
            Sleep(20-i);
          end;
        end;
    3 : begin
          Pima.Picture.Bitmap.Assign(tbfeu[3]);
          Pima.Left := xm+5;
          Pima.Top := ym+5;
          Pima.Visible := true;
          for i := 1 to 19 do
          begin
            Pima.Left := Pima.Left + 1;
            Image1.Repaint;
            Sleep(20-i);
          end;
        end;
  end;
  Pima.Visible := false;
  Pima.Left := 855;
  Sleep(200);
  Dec(be.lives);
  batos[ne] := be;
  BoatPoster(ne);
  if be.lives = 0 then
  begin
    Sinking(ne);
    Tablo[be.cl,be.lg] := 0;
  end;
  Sleep(200);
end;

procedure TForm1.Sinking(nb : byte);    // destroyed boat
var
  i, j, x, y : integer;
begin
  x := batos[nb].cl * dim;
  y := batos[nb].lg * dim;
  j := batos[nb].player;
  if bson then
    SndPlaySound(PChar(ExtractFilePath(Application.ExeName) + 'Data\Sinks.wav'),
        snd_nodefault or snd_async);
  for i := 1 to 5 do
  begin
    Image1.Canvas.Draw(x,y,tbfon[i]);
    Image1.Repaint;
    Sleep(200);
  end;
  if j = 1 then          // points tally and final test
  begin
    Dec(nbnav[1]);
    Pn1.Caption := IntToStr(nbnav[1]);
    if nbnav[1] = 0 then
    begin
      won := 2;
      Form4.ShowModal;
      BattleEnd := true;
    end;
  end
  else begin
         Dec(nbnav[2]);
         Pn2.Caption := IntToStr(nbnav[2]);
         if nbnav[2] = 0 then
         begin
           won := 1;
           Form4.ShowModal;
           BattleEnd := true;
         end;  
       end;
end;

//-------------------------- Computer game -------------------------------------
procedure TForm1.ComputerGame;
var
  i,sn,n : byte;
  cl,lg : integer;
  val,eval : Tval;
begin
  if BattleEnd then exit;
  eval.val := -50;
  for i := 20 downto 11 do
  begin
    if batos[i].lives > 0 then
    begin
      for sn := 1 to 4 do
      begin
        val := Assessment(i,sn);
        val.ba := i;
        if val.val > eval.val then eval := val
        else
          if val.val = eval.val then
          begin
            n := Random(2);
            if n = 0 then eval := val;
          end;
      end;
    end;
  end;
  if eval.val < -40 then         // No boat in sight or danger
  begin
    eval.val := -50;
    for i := 20 downto 11 do
    begin
      if batos[i].lives > 0 then
      begin
        cl := batos[i].cl;
        lg := batos[i].lg;
        val := EvSens1(cl,lg);
        val.ba := i;
        if val.val > eval.val then eval := val
        else
          if val.val = eval.val then
          begin
            n := Random(2);
            if n = 0 then eval := val;
          end;
        val := EvSens2(cl,lg);
        val.ba := i;
        if val.val > eval.val then eval := val
        else
          if val.val = eval.val then
          begin
            n := Random(2);
            if n = 0 then eval := val;
          end;
        val := EvSens3(cl,lg);
        val.ba := i;
        if val.val > eval.val then eval := val
        else
          if val.val = eval.val then
          begin
            n := Random(2);
            if n = 0 then eval := val;
          end;
        val := EvSens4(cl,lg);
        val.ba := i;
        if val.val > eval.val then eval := val
        else
          if val.val = eval.val then
          begin
            n := Random(2);
            if n = 0 then eval := val;
          end;
      end;
    end;
  end;
  noba := eval.ba;
  cl1 := batos[noba].cl;
  lg1 := batos[noba].lg;
  cl2 := eval.cl;
  lg2 := eval.lg;
  if (cl1 = cl2) and (lg1 = lg2) then
  begin
    won := 0;
    Form4.ShowModal;
    BattleEnd := true;
    exit;
  end;
  dx := cl1 * dim;
  dy := lg1 * dim;
  fx := cl2 * dim;
  fy := lg2 * dim;
  BoatPoster(noba);
  Pima.Picture.Bitmap := bato;
  Pima.Left := dx+5;
  Pima.Top := dy+5;
  Image1.Canvas.Draw(dx,dy,fond);
  Pima.Visible := true;
  batos[noba].sens := Whatens(noba);     // position the boat
  batos[noba].cl := cl2;
  batos[noba].lg := lg2;
  MoveBoat(noba,dx,dy,fx,fy);
  BoatPoster(noba);
  Pima.Visible := false;
  Pima.Left := 855;
  tablo[cl1,lg1] := 0;
  tablo[cl2,lg2] := noba;
  Combat(noba);
  if jr = 2 then
  begin
    jr := 1;
    Bevel1.Top := 40;
  end
  else begin
         jr := 2;
         Bevel1.Top := 144;
       end;
end;

// searching for ships that could be attacked from all four directions
function TForm1.Assessment(bn,sn : byte) : Tval;
var
  nc,cl,lg : integer;
  ba : byte;
  mb : TBato;
  va,eva : Tval;
begin
  eva.val := -50;
  mb := batos[bn];
  cl := mb.cl;
  lg := mb.lg;
  case sn of
    1 : begin
          nc := cl;
          while (nc < 11) and (tablo[nc+1,lg] = 0) do
          begin
            inc(nc);
            va.val := 0;
            if nc < 11 then
            begin
              ba := tablo[nc+1,lg];               // boat in front
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := nc;
                  va.lg := lg;
                  if batos[ba].sens in [2,4] then
                  begin
                    if mb.lives < 2 then va.val := -80
                    else va.val := -45;
                  end
                  else va.val := -20 - batos[ba].lives;
                end;
            end;
            if lg > 0 then                        // edge
            begin
              ba  := tablo[nc,lg-1];
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := nc;
                  va.lg := lg;
                  if batos[ba].sens in [2,4] then
                    va.val := va.val + 50 - batos[ba].lives
                  else
                    va.val := va.val + 10 - batos[ba].lives;
                  if batos[ba].lives = 1 then inc(va.val,30);
                end;
            end;
            if lg < 7 then                       // starboard
            begin
              ba  := tablo[nc,lg+1];
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := nc;
                  va.lg := lg;
                  if batos[ba].sens in [2,4] then
                    va.val := va.val + 50 - batos[ba].lives
                  else
                    va.val := va.val + 10 - batos[ba].lives;
                  if batos[ba].lives = 1 then inc(va.val,30);
                end;
            end;
            if va.val <> 0 then
              if va.val > eva.val then eva := va;
          end; // while
        end;   // 1
    2 : begin
          nc := lg;
          while (nc < 7) and (tablo[cl,nc+1] = 0) do
          begin
            inc(nc);
            va.val := 0;
            if nc < 7 then
            begin
              ba := tablo[cl,nc+1];               // boat in front
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := cl;
                  va.lg := nc;
                  if batos[ba].sens in [1,3] then
                  begin
                    if mb.lives < 2 then va.val := -80
                    else va.val := -45;
                  end
                  else va.val := -20 - batos[ba].lives;
                end;
            end;
            if cl > 0 then                        // starboard
            begin
              ba  := tablo[cl-1,nc];
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := cl;
                  va.lg := nc;
                  if batos[ba].sens in [1,3] then
                    va.val := va.val + 50 - batos[ba].lives
                  else
                    va.val := va.val + 10  - batos[ba].lives;
                  if batos[ba].lives = 1 then inc(va.val,30);
                end;
            end;
            if cl < 11 then                       // edge
            begin
              ba  := tablo[cl+1,nc];
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := cl;
                  va.lg := nc;
                  if batos[ba].sens in [1,3] then
                    va.val := va.val + 50 - batos[ba].lives
                  else
                    va.val := va.val + 10 - batos[ba].lives;
                  if batos[ba].lives = 1 then inc(va.val,30);
                end;
            end;
            if va.val <> 0 then
              if va.val > eva.val then eva := va;
          end; // while
        end;   // 2
    3 : begin
          nc := cl;
          while (nc > 0) and (tablo[nc-1,lg] = 0) do
          begin
            dec(nc);
            va.val := 0;
            if nc > 0 then
            begin
              ba := tablo[nc-1,lg];              // boat in front
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := nc;
                  va.lg := lg;
                  if batos[ba].sens in [2,4] then
                  begin
                    if mb.lives < 2 then va.val := -80
                    else va.val := -45;
                  end
                  else va.val := -20 - batos[ba].lives;
                end;
            end;
            if lg > 0 then                      // starboard
            begin
              ba  := tablo[nc,lg-1];
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := nc;
                  va.lg := lg;
                  if batos[ba].sens in [2,4] then
                    va.val := va.val + 50 - batos[ba].lives
                  else
                    va.val := va.val + 20 - batos[ba].lives;
                  if batos[ba].lives = 1 then inc(va.val,30);
                end;
            end;
            if lg < 7 then                      // edge
            begin
              ba  := tablo[nc,lg+1];
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := nc;
                  va.lg := lg;
                  if batos[ba].sens in [2,4] then
                    va.val := va.val + 50 - batos[ba].lives
                  else
                    va.val := va.val + 20 - batos[ba].lives;
                  if batos[ba].lives = 1 then inc(va.val,30);
                end;
            end;
            if va.val <> 0 then
              if va.val > eva.val then eva := va;
          end; // while
        end;   // 3
    4 : begin
          nc := lg;
          while (nc > 0) and (tablo[cl,nc-1] = 0) do
          begin
            dec(nc);
            va.val := 0;
            if nc > 0 then
            begin
              ba := tablo[cl,nc-1];               // boat in front
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := cl;
                  va.lg := nc;
                  if batos[ba].sens in [1,3] then
                  begin
                    if mb.lives < 2 then va.val := -80
                    else va.val := -45;
                  end
                  else va.val := -20 - batos[ba].lives;
                end;
            end;
            if cl > 0 then                        // edge
            begin
              ba  := tablo[cl-1,nc];
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := cl;
                  va.lg := nc;
                  if batos[ba].sens in [1,3] then
                    va.val := va.val + 50 - batos[ba].lives
                  else
                    va.val := va.val + 10 - batos[ba].lives;
                  if batos[ba].lives = 1 then inc(va.val,30);
                end;
            end;
            if cl < 11 then                       // starboard
            begin
              ba  := tablo[cl+1,nc];
              if ba > 0 then
                if batos[ba].player = 1 then
                begin
                  va.cl := cl;
                  va.lg := nc;
                  if batos[ba].sens in [1,3] then
                    va.val := va.val + 50 - batos[ba].lives
                  else
                    va.val := va.val + 10  - batos[ba].lives;
                  if batos[ba].lives = 1 then inc(va.val,30);
                end;
            end;
            if va.val <> 0 then
              if va.val > eva.val then eva := va;
          end; // while
        end;   // 4
  end;  // case
  Result := eva;
end;

// 4 recursive functions:
// If no fight is possible, look for the best way to move.
function TForm1.EvSens1(cl,lg : byte) : Tval;
var
  nc,nl : integer;
  va,eva : tval;
  be,ex : byte;
begin
  ex := 0;
  if cl < 11 then
  begin
    eva.val := 0;
    if tablo[cl+1,lg] = 0 then
    begin
      nc := cl+1;
      eva.cl := nc;
      eva.lg := lg;
      if lg > 0 then
      begin
        if tablo[nc,lg-1] = 0 then
        begin
          nl := lg-1;
          repeat
            be := tablo[nc,nl];
            if be in[0,11..20] then inc(eva.val,10)
            else dec(eva.val,10);
            dec(nl);
          until nl < 0;
        end;
      end;
      if lg < 7 then
      begin
        if tablo[nc,lg+1] = 0 then
        begin
          nl := lg+1;
          repeat
            be := tablo[nc,nl];
            if be in[0,11..20] then inc(eva.val,10)
            else dec(eva.val,10);
            inc(nl);
          until nl > 7;
        end;
      end;
      if nc+1 <= 11 then
      begin
        be := tablo[nc+1,lg];
        if be in[1..10] then
          if batos[be].sens in[2,4] then dec(eva.val,20)
          else inc(eva.val,10);
        if lg > 0 then
          for nl := lg-1 downto 0 do
            if tablo[nc+1,nl] in[1..10] then dec(eva.val,20);
        if lg < 7 then
          for nl := lg+1 to 7 do
            if tablo[nc+1,nl] in[1..10] then dec(eva.val,20);
      end;
      if lg > 0 then
        for nl := lg-1 downto 0 do
          if tablo[nc-1,nl] in[1..10] then dec(eva.val,20);
      if lg < 7 then
          for nl := lg+1 to 7 do
            if tablo[nc-1,nl] in[1..10] then dec(eva.val,20);
    end
    else
      begin
        be := tablo[cl+1,lg];
        eva.cl := cl;
        eva.lg := lg;
        ex := 1;
        if be < 11 then eva.val := 0
        else
          if batos[be].sens in[1,3] then eva.val := -20
          else eva.val := -40;
      end;
  end
  else
    begin
      eva.cl := cl;
      eva.lg := lg;
      eva.val := -50;
      ex := 1;
    end;
  if (cl+1 < 11) and (ex = 0) then
  begin
    va := EvSens1(cl+1,lg);              // exam next box
    if va.val > eva.val then eva := va;
  end;
  Result := eva;
end;

function TForm1.EvSens2(cl,lg : byte) : Tval;
var
  nc,nl : integer;
  va,eva : tval;
  be,ex : byte;
begin
  ex := 0;
  if lg < 7 then
  begin
    eva.val := 0;
    if tablo[cl,lg+1] = 0 then
    begin
      nl := lg+1;
      eva.cl := cl;
      eva.lg := nl;
      if cl > 0 then
      begin
        if tablo[cl-1,nl] = 0 then
        begin
          nc := cl-1;
          repeat
            be := tablo[nc,nl];
            if be in[0,11..20] then inc(eva.val,10)
            else dec(eva.val,10);
            dec(nc);
          until nc < 0;
        end;
      end;
      if cl < 11 then
      begin
        if tablo[cl+1,nl] = 0 then
        begin
          nc := cl+1;
          repeat
            be := tablo[nc,nl];
            if be in[0,11..20] then inc(eva.val,10)
            else dec(eva.val,10);
            inc(nc);
          until nc > 11;
        end;
       end;
      if nl+1 <= 7 then
      begin
        be := tablo[cl,nl+1];
        if be in[1..10] then
          if batos[be].sens in[1,3] then dec(eva.val,20)
          else inc(eva.val,10);
        if cl > 0 then
          for nc := cl-1 downto 0 do
            if tablo[nc,nl+1] in[1..10] then dec(eva.val,20);
        if cl < 11 then
          for nc := cl+1 to 11 do
            if tablo[nc,nl+1] in[1..10] then dec(eva.val,20);
      end;
      if cl > 0 then
        for nc := cl-1 downto 0 do
          if tablo[nc,nl-1] in[1..10] then dec(eva.val,20);
      if cl < 11 then
          for nc := cl+1 to 11 do
            if tablo[nc,nl-1] in[1..10] then dec(eva.val,20);
    end
    else
      begin
        be := tablo[cl,lg+1];
        eva.cl := cl;
        eva.lg := lg;
        ex := 1;
        if be < 11 then eva.val := 0
        else
          if batos[be].sens in[2,4] then eva.val := -20
          else eva.val := -40;
      end;
  end
  else
    begin
      eva.cl := cl;
      eva.lg := lg;
      eva.val := -50;
      ex := 1;
    end;
  if (lg+1 < 7) and (ex = 0) then
  begin
    va := EvSens2(cl,lg+1);
    if va.val > eva.val then eva := va;
  end;
  Result := eva;
end;

function TForm1.EvSens3(cl,lg : byte) : Tval;
var
  nc,nl : integer;
  va,eva : tval;
  be,ex : byte;
begin
  ex := 0;
  if cl > 0 then
  begin
    eva.val := 0;
    if tablo[cl-1,lg] = 0 then
    begin
      nc := cl-1;
      eva.cl := nc;
      eva.lg := lg;
      if lg > 0 then
      begin
        if tablo[nc,lg-1] = 0 then
        begin
          nl := lg-1;
          repeat
            be := tablo[nc,nl];
            if be in[0,11..20] then inc(eva.val,10)
            else dec(eva.val,10);
            dec(nl);
          until nl < 0;
        end;
      end;
      if lg < 7 then
      begin
        if tablo[nc,lg+1] = 0 then
        begin
          nl := lg+1;
          repeat
            be := tablo[nc,nl];
            if be in[0,11..20] then inc(eva.val,10)
            else dec(eva.val,10);
            inc(nl);
          until nl > 7;
        end;
      end;
      if nc-1 >= 0 then
      begin
        be := tablo[nc-1,lg];
        if be in[1..10] then
          if batos[be].sens in[2,4] then dec(eva.val,20)
          else inc(eva.val,10);
        if lg > 0 then
          for nl := lg-1 downto 0 do
            if tablo[nc-1,nl] in[1..10] then dec(eva.val,20);
        if lg < 7 then
          for nl := lg+1 to 7 do
            if tablo[nc-1,nl] in[1..10] then dec(eva.val,20);
      end;
      if lg > 0 then
        for nl := lg-1 downto 0 do
          if tablo[nc-1,nl] in[1..10] then dec(eva.val,20);
      if lg < 7 then
          for nl := lg+1 to 7 do
            if tablo[nc-1,nl] in[1..10] then dec(eva.val,20);
    end
    else
      begin
        be := tablo[cl-1,lg];
        eva.cl := cl;
        eva.lg := lg;
        ex := 1;
        if be < 11 then eva.val := 0
        else
          if batos[be].sens in[1,3] then eva.val := -20
          else eva.val := -40;
      end;
  end
  else
    begin
      eva.cl := cl;
      eva.lg := lg;
      eva.val := -50;
      ex := 1;
    end;
  if (cl-1 > 0) and (ex = 0) then
  begin
    va := EvSens3(cl-1,lg);
    if va.val > eva.val then eva := va;
  end;
  Result := eva;
end;

function TForm1.EvSens4(cl,lg : byte) : Tval;
var
  nc,nl : integer;
  va,eva : tval;
  be,ex : byte;
begin
  ex := 0;
  if lg > 0 then
  begin
    eva.val := 0;
    if tablo[cl,lg-1] = 0 then
    begin
      nl := lg-1;
      eva.cl := cl;
      eva.lg := nl;
      if cl > 0 then
      begin
        if tablo[cl-1,nl] = 0 then
        begin
          nc := cl-1;
          repeat
            be := tablo[nc,nl];
            if be in[0,11..20] then inc(eva.val,10)
            else dec(eva.val,10);
            dec(nc);
          until nc < 0;
        end;
      end;
      if cl < 11 then
      begin
        if tablo[cl+1,nl] = 0 then
        begin
          nc := cl+1;
          repeat
            be := tablo[nc,nl];
            if be in[0,11..20] then inc(eva.val,10)
            else dec(eva.val,10);
            inc(nc);
          until nc > 11;
        end;
      end;
      if nl-1 >= 0 then
      begin
        be := tablo[cl,nl-1];
        if be in[1..10] then
          if batos[be].sens in[1,3] then dec(eva.val,20)
          else inc(eva.val,10);
        if cl > 0 then
          for nc := cl-1 downto 0 do
            if tablo[nc,nl+1] in[1..10] then dec(eva.val,20);
        if cl < 11 then
          for nc := cl+1 to 11 do
            if tablo[nc,nl+1] in[1..10] then dec(eva.val,20);
      end;
      if cl > 0 then
        for nc := cl-1 downto 0 do
          if tablo[nc,nl-1] in[1..10] then dec(eva.val,20);
      if cl < 11 then
          for nc := cl+1 to 11 do
            if tablo[nc,nl-1] in[1..10] then dec(eva.val,20);
    end
    else
      begin
        be := tablo[cl,lg-1];
        eva.cl := cl;
        eva.lg := lg;
        ex := 1;
        if be < 11 then eva.val := 0
        else
          if batos[be].sens in[2,4] then eva.val := -20
          else eva.val := -40;
      end;
  end
  else
    begin
      eva.cl := cl;
      eva.lg := lg;
      eva.val := -50;
      ex := 1;
    end;
  if (lg-1 > 0) and (ex = 0) then
  begin
    va := EvSens4(cl,lg-1);
    if va.val > eva.val then eva := va;
  end;
  Result := eva;
end;

//------------------------ Editor ----------------------------------------------
procedure TForm1.Button2Click(Sender: TObject);
begin
  if Form3.ShowModal = mrOk then
  begin
    ApplyTable;
    WhoStarts;
  end;  
end;

procedure TForm1.ApplyTable;
var
  i : byte;
  cl,lg : integer;
  mb : TBato;
begin
  for i := 1 to 20 do batos[i] := eba[i];
  for lg := 0 to 7 do
    for cl := 0 to 11 do
    begin
      tablo[cl,lg] := 0;
      Image1.Canvas.Draw(cl*dim,lg*dim,fond);
    end;
  nbnav[1] := 0;
  nbnav[2] := 0;
  for i := 1 to 20 do
  begin
    mb := batos[i];
    if mb.lives > 0 then
    begin
      tablo[mb.cl,mb.lg] := i;
      inc(nbnav[mb.player]);
      BoatPoster(i);           
    end;
  end;
  Pn1.Caption := IntToStr(nbnav[1]);
  Pn2.Caption := IntToStr(nbnav[2]);
  Image1.Repaint;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  bson := not bson;
  if bson then
    BitBtn1.Glyph.Assign(ledon)
  else
    BitBtn1.Glyph.Assign(ledof);

  Button3.SetFocus;
  fpar.WriteBool('Options','Sound',bson);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  quickly := TrackBar1.Position;
  fpar.WriteInteger('Options','Speed',quickly);
end;

end.
