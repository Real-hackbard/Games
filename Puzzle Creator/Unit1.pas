unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, ExtDlgs, Buttons, filectrl, Menus, spritez,
  MMSystem, XPMan, dxGDIPlusClasses;

  const Pmax = 128;
  type
    Tpiece = record
    pleft   : byte;
    ptop    : byte;
    pright  : byte;
    pbottom : byte;
    pinit   : Tpoint;
    prot    : integer;
    prot0   : integer;
    pflag   : integer;
  end;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    MainMenu1: TMainMenu;
    Quitter1: TMenuItem;
    C1: TMenuItem;
    S1: TMenuItem;
    A1: TMenuItem;
    I1: TMenuItem;
    About1: TMenuItem;
    Bevel1: TBevel;
    ProgressBar1: TProgressBar;
    PaintBox1: TPaintBox;
    Label5: TLabel;
    Quit1: TMenuItem;
    Load1: TMenuItem;
    Panel2: TPanel;
    PaintBox2: TPaintBox;
    O1: TMenuItem;
    Image1: TImage;
    N1: TMenuItem;
    N2: TMenuItem;
    C2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure C1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure Paintbox2Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure RecommencerClick(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
  private
  { Private-Deklarationen}
  startdir     : string;
  filename     : string;
  PaintboxFlag : integer;
  finished     : boolean;
  OK           : boolean;
  OKsprites    : boolean;
  Auto         : boolean;
  movauto      : boolean;
  moving       : boolean;
  redo         : boolean;

  cur    : integer;
  curlig : integer;
  curcol : integer;
  mx, my : integer;

  magnetism  : integer;
  RightClick : boolean;
  speed      : integer;
  Tstart     : Tdatetime;
  Tancien    : Tdatetime;
  ctrtriche  : integer;
  ctrdeplace : integer;

  Bmp1 : Tbitmap;
  BB : array[0..9] of tpoint;

  nx, ny : integer;
  k1,
  k2,
  k3,

  Centrex, Centrey : integer;
  origx, origy     : integer;
  Zrect : Trect;
  Pzcolor : Tcolor;
  PP : Array[0..Pmax, 0..Pmax] of Tpiece;

  ctrprior                : integer;
  oldpuzzle               : boolean;
  oldPbwidth, oldPbheight : integer;
  oldorigx, oldorigy      : integer;
  oldnbp                  : integer;
  oldk1                   : integer;
  oldnbx                  : integer;
  oldnby                  : integer;
  oldzrect                : Trect;
  Procedure Readinifile;
  Procedure Writeinifile;

  public
  { Public-Deklarationen}
    Bmp0 : Tbitmap;
    nbp : integer;
    firsttime : boolean;
    Album1 : Talbum;
    Pool   : Tpool;

    procedure menugris(Yes : boolean);
    procedure dimensions;
    procedure Shapes;
    procedure curtoligcol;
    procedure Drawingtest(display : boolean);
    procedure Bez(cancan : Tcanvas; ox, oy : integer; AA : array of tpoint);
    procedure MakePuzzle(nochange : boolean);
    procedure Fig(cancan : Tcanvas; alig, acol: integer);
    function  envelope(alig, acol : integer) : trect;
    Function  Testfinal : boolean;
    procedure Autodeplace;
    Procedure DisplayImg(reduced : boolean);
    Function  Temps : string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R Rich.res}

uses Options, Load, Configuration, about;

const
  INIFile = 'Puzzle.ini';
  brand  = '[PUZZLE]';

  curve1 : array[0..9] of Tpoint = (
  (x:00; y:00), (x:01; y:-2), (x:06; y:02), (x:06; y:00), (x:04; y:-6),
  (x:11; y:-4), (x:09; y:00), (x:09; y:01), (x:15; y:-1), (x:15; y:00));
  curve2 : array[0..9] of Tpoint = (
  (x:00; y:00), (x:00; y:02), (x:00; y:04), (x:00; y:06), (x:06; y:04),
  (x:05; y:11), (x:00; y:09), (x:00; y:12), (x:00; y:13), (x:00; y:15));
  curve3 : array[0..9] of Tpoint = (
  (x:00; y:00), (x:00; y:01), (x:06; y:-2), (x:06; y:00), (x:03; y:06),
  (x:10; y:05), (x:09; y:00), (x:09; y:-2), (x:15; y:00), (x:15; y:00));
  curve4 : array[0..9] of Tpoint = (
  (x:00; y:00), (x:00; y:02), (x:00; y:03), (x:00; y:06), (x:-6; y:04),
  (x:-5; y:11), (x:00; y:09), (x:00; y:10), (x:00; y:13), (x:00; y:15));

procedure TForm1.FormCreate(Sender: TObject);
var
  bmpfond : TBitmap;
begin
  firsttime := true;
  oldpuzzle := false;
  PaintboxFlag := 0;
  ok := false;
  oksprites := false;
  moving := false;
  auto := false;
  redo := false;
  finished := false;
  magnetism := 12;
  RightClick := true;
  speed := 1;
  startdir := getcurrentdir;
  menugris(true);
  bmpfond := Tbitmap.create;
  Try
    bmpfond.width  := paintbox1.width;
    bmpfond.height := paintbox1.height;
    bmpfond.canvas.brush.color := clbtnface;
    bmpfond.canvas.fillrect(rect(0,0,paintbox1.width, paintbox1.height));
    bmpfond.canvas.brush.color := clblack;
    Album1 := Talbum.create(paintbox1.canvas, Bmpfond);
    Paintboxflag := 1;
  finally
    bmpfond.free;
  end;

  Bmp0 := Tbitmap.create;
  Bmp0.width  := 8;
  Bmp0.height := 8;
  Bmp0.pixelformat := pf24bit;
  Bmp1 := Tbitmap.create;
  Bmp1.width  := 8;
  Bmp1.height := 8;
  Bmp1.pixelformat := pf24bit;
  pzcolor := clgray;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if auto then A1click(sender);
  writeinifile;
  action := cafree;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Album1.free;
  bmp0.free;
  Bmp1.free;
end;

Procedure Tform1.Readinifile;
var
  Text : textfile;
  g, g2       : string;
  i, ctr     : integer;
  c : char;
  num : array[1..6] of integer;

  Procedure Number6;
  var
    p, i : integer;
  begin
    for i := 1 to 6 do num[i] := 0;
    i := 0;
    Repeat
      p := pos(';', g);
      if p > 0 then
      begin
        inc(i);
        try
          num[i] := strtoint(copy(g, 1, p-1));
        except
        end;
        delete(g,1,p);
      end;
    until p = 0;
  end;

  Procedure decodepuzzle;
  var
    dlig, dcol : integer;
  begin
    if copy(g,1,7) = 'SCREEN;' then
    begin
      oldpuzzle := true;
      delete(g,1,7);
      Number6;
      oldPbwidth  := Num[1];
      oldPbheight := Num[2];
      oldorigx    := Num[3];
      oldorigy    := Num[4];
      oldnbp      := Num[5];
      oldk1       := Num[6];
    end
    else
    if copy(g,1,7) = 'PIECES;' then
    begin
      delete(g,1,7);
      Number6;
      oldnbx          := Num[1];
      if oldnbx < 1 then oldnbx := 1;
      if oldnbx > pmax then oldnbx := 1;
      oldnby          := Num[2];
      if oldnby < 1 then oldnby := 1;
      if oldnby > pmax then oldnby := 1;
      oldzrect.left   := Num[3];
      oldzrect.top    := Num[4];
      oldzrect.right  := Num[5];
      oldzrect.bottom := Num[6];
    end
    else
    if copy(g,1,6) = 'TEMPS;' then
    begin
      delete(g,1,6);
      Number6;
      Tancien := encodetime(word(Num[1]), word(Num[2]), word(Num[3]), 0);
    end
    else
    begin
      Number6;
      dlig := (Num[1]-1) div oldnbx;
      dcol := (Num[1]-1) mod oldnbx;
      PP[dlig, dcol].pleft   := Num[2] div 1000;
      PP[dlig, dcol].ptop    := (Num[2] mod 1000)  div 100;
      PP[dlig, dcol].pright  := (num[2] mod 100) div 10;
      PP[dlig, dcol].pbottom := num[2] mod 10;
      PP[dlig, dcol].pinit.x := Num[3];
      PP[dlig, dcol].pinit.y := Num[4];
      PP[dlig, dcol].pflag   := Num[5];
      PP[dlig, dcol].prot    := Num[6];
      PP[dlig, dcol].prot0   := Num[6];
    end;
  end;

begin
  c := startdir[1];
  If Form3.diskindrive(c) = false then exit;
  IF fileexists(startdir+'\'+INIFile) then
  begin
    Assignfile(Text, startdir+'\'+INIFile);
    Reset(Text);
    Ctr := 0;
    while NOT Eof(Text) do
    begin
      Readln(Text, g);
      inc(ctr);
      case ctr of
      1: if g <> brand then
         begin
           showmessage('Puzzle.ini : incorrect file');
           closefile(Text);
           exit;
         end;
      2: if g <> '' then
         begin
           g2 := extractfilepath(g);
           if directoryexists(g2) then form3.directorylistbox1.directory := g2;
           If fileexists(g) then form3.filelistbox1.filename := g;
           filename := extractfilename(g);
         end;
      3: begin
           while length(g) < 9 do g := g+'0';
           For i := 1 to 9 do
             if g[i] in ['0'..'9'] = false then g[i] := '1';
           with form4 do
           begin
             Radiogroup1.itemindex := strtoint(copy(g,1,1));
             Radiogroup2.itemindex := strtoint(copy(g,2,1));
             Radiogroup3.itemindex := strtoint(copy(g,3,1));
             Radiogroup4.itemindex := strtoint(copy(g,4,1));
             speed := Radiogroup3.itemindex;
             if copy(g,1,5) = '0' then
               checkbox1.checked := false else Checkbox1.checked := true;
             if copy(g,1,6) = '0' then
               checkbox2.checked := false else Checkbox2.checked := true;
             if copy(g,3,7) = '0' then
               checkbox1.checked := false else Checkbox3.checked := true;
           end;
           with form2 do
           begin
             Radiogroup1.itemindex := strtoint(copy(g,8,1));
             Radiogroup2.itemindex := strtoint(copy(g,9,1));
             if Form4.Radiogroup4.itemindex = 0 then
               checkbox1.checked := false else checkbox1.checked := true;
           end;
         end;
      else
      decodepuzzle;
      end;
    end;
    closefile(Text);
  end;
end;

Procedure TForm1.WriteIniFile;
var
  text : textfile;
  s : string;
  ctri, i, j : integer;
  h,m,sec,ms : word;
begin
  Assignfile(text, startdir+'\'+INIFile);
  rewrite(text);
  writeln(text, brand);
  writeln(text, form3.filelistbox1.filename);
  with form4 do
  begin
    s := inttostr(Radiogroup1.itemindex);
    s := s+inttostr(Radiogroup2.itemindex);
    s := s+inttostr(Radiogroup3.itemindex);
    s := s+inttostr(Radiogroup4.itemindex);

    if checkbox1.checked then s := s+'1' else  s := s+'0';
    if checkbox2.checked then s := s+'1' else  s := s+'0';
    if Checkbox3.checked then s := s+'1' else  s := s+'0';
  end;
  with Form2 do
  begin
    s := s + inttostr(Radiogroup1.itemindex);
    s := s + inttostr(radiogroup2.itemindex);
  end;
  writeln(text, s);
  if ok and (finished = false) then
  begin
    s := 'SCREEN;'+inttostr(Paintbox1.width)+';'+inttostr(Paintbox1.height)+';'
                  +inttostr(origx)+';'+inttostr(origy)+';'
                  +inttostr(Nbp)+';'+inttostr(k1)+';';
    writeln(text, s);
    s := 'PIECES;'+inttostr(nx)+';'+inttostr(ny)+';'
                  +inttostr(zrect.left)+';'+inttostr(zrect.top)+';'
                  +inttostr(zrect.right)+';'+inttostr(zrect.bottom)+';';
    writeln(text, s);
    decodetime(now-tstart, h,m,sec,ms);
    s := 'TEMPS;'+inttostr(h)+';'+inttostr(m)+';'+inttostr(sec)+';0;0;0';
    writeln(text,s);

    ctri := 0;
    for j := 0 to ny-1 do
      for  i := 0 to nx-1 do
      begin
        inc(ctri);
        s := inttostr(ctri)+';';
        with PP[j,i] do
        begin
          s := s+inttostr(pleft);
          s := s+inttostr(ptop);
          s := s+inttostr(pright);
          s := s+inttostr(pbottom)+';';
        end;
        s := s+inttostr(pool.getposx(ctri))+';';
        s := s+inttostr(pool.getposy(ctri))+';';
        s := s+inttostr(pool.gettag(ctri))+';';
        cur := ctri;
        curtoligcol;
        s := s+inttostr(PP[curlig, curcol].prot)+';';
        writeln(text,s);
      end;
    end;
  closefile(text);
end;

procedure TForm1.Menugris(Yes : boolean);
begin
  IF Yes then
  begin
    S1.enabled := false;
    A1.enabled := false;
  end
  else
  begin
    S1.enabled := true;
    A1.enabled := true;
  end;
end;

procedure TForm1.RecommencerClick(Sender: TObject);
var
  n, lig, col : integer;
begin
  IF paintboxflag = 1 then exit;
  ctrtriche  := 0;
  ctrdeplace := 0;
  finished := false;
  timer1.enabled := false;
  panel7.caption := '';
  label5.visible := false;
  panel2.visible := false;
  paintbox1.invalidate;
  n := 0;
  for lig := 0 to ny-1 do
  begin
    for col := 0 to nx-1 do
    begin
      inc(n);
      Pool.settoon(n, 'P'+inttostr(n));
      pool.setpos(n, pp[lig, col].pinit.x, pp[lig, col].pinit.y);
      pool.setpriority(n, -n);
        pool.setanimstyle(n, pp[lig, col].prot0);
        pool.settag(n, 0);
        pp[lig, col].prot := pp[lig, col].prot0;
    end;
  end;
  panel8.caption := inttostr(nbp)+' Parts';
  pool.animate;
  Tstart := now;
  menugris(false);
  if form4.checkbox3.checked then timer1.enabled := true;
end;

procedure Tform1.Dimensions;
var
  w, h : integer;
  w1, h1 : single;
  w2, h2 : single;
  k, kw, kh: single;
begin
  IF not ok then exit;
  if screen.width > 800 then
  k1 := form2.radiogroup1.itemindex+3
  else k1 := form2.radiogroup1.itemindex+2;
  k2 := k1*15;
  k3 := k1*4;
  w1 := bmp0.width;
  h1 := bmp0.height;
  w2 := paintbox1.width;

  if h1 >= w1 then
      h2 := paintbox1.height-24-K2-k3-k3
    else
      h2:= paintbox1.height-((k2+k3)*3);

  kw := 1;
  kh := 1;
  if w1 > w2 then kw := w2/w1;
  if h1 > h2 then kh := h2/h1;
  if kw < kh then k := kw else k := kh;
  w := round(w1*k);
  h := round(h1*k);
  nx := w div k2;
  ny := h div k2;
  if nx < 1 then nx := 1;
  if ny < 1 then ny := 1;
  Inc(nx,2);
  Inc(ny,2);
  nbp := nx*ny;
  ctrprior := nbp;

  with Zrect do
  begin
    left   := 0;
    top    := 0;
    right  := nx*k2 - k3*2;
    bottom := ny*k2 - k3*2;
  end;

  bmp1.free;
  bmp1 := tbitmap.create;
  bmp1.width  := Zrect.right - Zrect.left;
  bmp1.height := Zrect.bottom - Zrect.top;
  centrex := paintbox1.width  div 2;
  centrey := paintbox1.height div 2;
  origx   := centrex - bmp1.width  div 2;
  origy   := centrey - bmp1.height div 2;

  bmp1.canvas.stretchdraw(Zrect, bmp0);
  panel8.caption := inttostr(nbp)+' Parts';
  DisplayImg(false);
end;

procedure Tform1.DisplayImg(reduced : boolean);
begin
  if Not reduced then
  begin
    panel2.width  := bmp1.width+2;
    panel2.height := bmp1.height+2;
    panel2.left := origx-1;
    panel2.top  := origy+1;
    paintbox2.invalidate;
  end
  else
  begin
    panel2.width  := form3.image1.width+4;
    panel2.height := form3.image1.height+4;
    panel2.left := 2;
    panel2.top  := 2;
    paintbox2.invalidate;
  end;
end;

Procedure TForm1.Shapes;
var
  col, lig : integer;
  z : word;
begin
  for lig := 0 to Pmax do
   for col := 0 to Pmax do
    begin
      PP[lig, col].pleft    := 0;
      PP[lig, col].ptop     := 0;
      PP[lig, col].pright   := 0;
      PP[lig, col].pbottom  := 0;
      PP[lig, col].pinit.x  := 0;
      PP[lig, col].pinit.y  := 0;
      PP[lig, col].prot     := 0;
      PP[lig, col].prot0    := 0;
      PP[lig, col].pflag    := 0;
    end;
  for lig := 0 to ny-1 do
  begin
    for col := 0 to nx-1 do
    begin

      if lig = 0 then
      begin
        pp[lig, col].ptop := 0;
      end
      else
      begin
        if lig = ny then
        begin
           pp[lig-1, col].pbottom := 0
        end
        else
        begin
          z := random(2);
          if z = 0 then
          begin
            pp[lig, col].ptop := 1;
            pp[lig-1, col].pbottom := 1;
          end
          else
          begin
            pp[lig, col].ptop := 2;
            pp[lig-1, col].pbottom := 2;
          end;
        end;
      end;

      iF col = 0 then
      begin
        pp[lig, col].pleft := 0;
      end
      else
      begin
        if col= nx then
        begin
          pp[lig, col-1].pright := 0;
        end
        else
        begin
          z := random(2);
          if z = 0 then
          begin
            pp[lig, col].pleft := 1;
            pp[lig, col-1].pright := 1;
          end
          else
          begin
            pp[lig, col].pleft := 2;
            pp[lig, col-1].pright := 2;
          end;
        end;
      end;
    end;
  end;
end;


Procedure Tform1.Curtoligcol;
begin
  curlig := (cur-1) div nx;
  curcol := (cur-1) mod nx;
end;

procedure Line(cancan : tcanvas; x1, y1, x2, y2 : integer);
begin
  with cancan do
  begin
    moveto(x1, y1);
    lineto(x2, y2);
  end;
end;

procedure TForm1.Bez(cancan : Tcanvas; ox, oy : integer; AA : array of tpoint);
var
  n : integer;
  hh : Thandle;
begin
  for n := 0 to 9 do
  begin
    BB[n].x := AA[n].x*k1 +ox;
    BB[n].y := AA[n].y*k1 +oy;
  end;
  HH := cancan.handle;
  Windows.polybezier(HH, BB, 10);
end;

procedure Tform1.Drawingtest(display : boolean);
var
  col, lig : integer;
begin
  album1.drawarea(rect(0,0,paintbox1.width, paintbox1.height));
  with bmp1.canvas do
  begin
    stretchdraw(Zrect, bmp0);
    case form2.radiogroup2.itemindex of
    0 : Pzcolor := clgray;
    1 : Pzcolor := clsilver;
    end;
    pen.color := Pzcolor;
    moveto(0,0);
    lineto(bmp1.width-1,0);
    lineto(Bmp1.width-1, bmp1.height-1);
    lineto(0, bmp1.height-1);
    lineto(0,0);
  end;
  for lig := 0 to ny-1 do
  begin
    for col := 0 to nx-1 do
    begin
      case pp[lig, col].ptop of
      1 :  bez(Bmp1.canvas, col*k2 -k3, lig*k2-k3, curve1);
      2 :  bez(Bmp1.canvas, col*k2 -k3, lig*k2-k3, curve3);
      end;
      case pp[lig, col].pleft of
      1 :  bez(Bmp1.canvas, col*k2 -k3, lig*k2-k3, curve2);
      2 :  bez(Bmp1.canvas, col*k2 -k3, lig*k2-k3, curve4);
      end;
    end;
  end;
  if display then paintbox1.canvas.draw(origx, origy, bmp1);
end;

Procedure TForm1.MakePuzzle(nochange : boolean);
var
  savecursor : Tcursor;
  col, lig : integer;
  i, nbimg : integer;
  r1, r2 : trect;
  p : tpoint;
  bmp2 : Tbitmap;
  bmp3 : tbitmap;
  csx, csy : integer;
  nomtoon : string;
  bmpfond : tbitmap;
  rrr : integer;
  a, b : integer;
  bestmarge : integer;
begin
  savecursor := screen.cursor;
 try
  screen.cursor := crhourglass;
  bmpfond := album1.getareabmp;
  with bmpfond.canvas do
  begin
    pen.color := clred;
    brush.color := $00CBD1CF;
    rectangle(origx-2, origy-2, origx+bmp1.width+2, origy+bmp1.height+2);
  end;
  album1.drawarea(rect(0,0,paintbox1.width, paintbox1.height));

  bmp1.canvas.brush.color := $00353535;
  bmp0.canvas.brush.color := $00353535;
  bmp1.canvas.brushcopy(Zrect, bmp0, rect(0,0,bmp0.width, bmp0.height), clblack);
  bmp1.canvas.brush.color := clblack;
  bmp1.pixelformat := pf24bit;
  progressbar1.position := 0;
  progressbar1.max := nx*ny*2;
  nbimg := 1;
  csx := bmp1.width div 2;
  csy := bmp1.height div 2;
  for lig := 0 to ny-1 do
  begin
    for col := 0 to nx-1 do
    begin
      r1 := envelope(lig, col);
      bmp2 := Tbitmap.create;
      try
        bmp2.width  := r1.right - r1.left+1;
        bmp2.height := r1.bottom - r1.top+1;
        bmp2.pixelformat := pf24bit;
        r2.Left  := 0;
        r2.top   := 0;
        r2.right := bmp2.width;
        r2.bottom := bmp2.height;
        with bmp2.canvas do
        begin

          copymode := cmsrccopy;
          brush.color := clblack;
          fillrect(r2);
          pen.color := clwhite;
          fig(bmp2.canvas, lig, col);
          brush.color := clwhite;
          floodfill(Bmp2.width div 2+2, bmp2.height div 2+2, clwhite, fsborder);
          CopyMode := cmSrcAnd;
          copyrect  (r2, bmp1.canvas, r1);
          pen.color := pzcolor;
          fig(bmp2.canvas, lig, col);
        end;
        progressbar1.position := nbimg;
        With album1 do
        begin
          nomtoon := 'P'+inttostr(nbimg);
          createToon(nomtoon, bmp2,1,1,1, bmp2.width,bmp2.height, 0, clblack);
          settooncenter(nomtoon, r1.left - csx, r1.Top - csy);
        end;
        inc(nbimg);
      finally
        bmp2.free;
      end;
    end;
  end;

  Pool := Album1.createpool(nbp);

  r1 := rect(origx-k2-k3*2, origy-k2-k3*2, origx+bmp1.width, origy+bmp1.height);
  bestmarge := 0;
  if origy < k2+k3 then bestmarge := 1;
  if origx < k2+k3 then bestmarge := 2;
  if (origx < k2+k3) and (origy < k2+k3) then bestmarge := 3;
  nbimg := 0;
  for lig := 0 to ny-1 do
  begin
    for col := 0 to nx-1 do
    begin
      inc(nbimg);
      progressbar1.position := nx*ny+nbimg;
      nomtoon := 'P'+inttostr(nbimg);
      Pool.createsprite(nbimg, nomtoon);
      if redo then
      begin
        p.x := PP[lig, col].pinit.x;
        p.y := PP[lig, col].pinit.y;
        Pool.settag(nbimg,  PP[lig, col].pflag);
      end
      else
      begin
        p.x := rndi(0, paintbox1.width - k2-k3);
        p.y := rndi(0, paintbox1.height- k2-K3);
        i := rndi(0,9);
        if Ptinrect(r1, p) then
        begin
          if p.x < centrex-k2 then
          begin
            case bestmarge of
            0 : if i mod 2 = 0 then p.x := rndi(0, r1.left);
            1 : p.x := rndi(0, r1.left);
            3 : if i mod 2 = 0 then p.x := -k2;
            end;
          end
          else
          begin
            case bestmarge of
            0 : if i mod 2 = 0 then p.x := rndi(r1.right, paintbox1.width-k2-k3);
            1 : p.x := rndi(r1.right, paintbox1.width-k2-k3);
            3 : if i mod 2 = 0 then p.x := paintbox1.width-k2-k3;
            end;
          end;
          if p.y < centrey-k2 then
          begin
            case bestmarge of
            0 : if i mod 2 = 1 then p.y := rndi(0, r1.top-k3);
            2 : p.y := rndi(0, r1.top-k3);
            3 : if i mod 2 = 1 then p.y := -k2;
            end;
          end
          else
          begin
            case bestmarge of
            0 : if i mod 2 = 1 then p.y := rndi(r1.bottom, paintbox1.height-k2-k3);
            2 : p.y := rndi(r1.bottom, paintbox1.height-k2-k3);
            3 : if i mod 2 = 1 then p.y := paintbox1.height-k2;
            end;
          end;
        end;
        p.x := (p.x div 16)*16+8;
        p.y := (p.y div 16)*16+8;
      end;
      pool.setpos(nbimg, p.x, p.y);
      pool.setpriority(nbimg, -nbimg);
      pp[lig, col].pinit.x := p.x;
      pp[lig, col].pinit.y := p.y;

      if nochange then rrr := PP[lig, col].prot0
       else iF form4.radiogroup4.itemindex = 1 then
         rrr := rndi(0,3) else rrr := 0;
      pool.setanimstyle(nbimg, rrr);
      pp[lig, col].prot   := rrr;
      pp[lig, col].prot0   := rrr;
    end;
  end;
  pool.animate;
  oksprites := true;
  menugris(false);
  Tstart := now;
 finally
   screen.cursor := savecursor;
 end;
 progressbar1.position := 0;
end;

procedure TForm1.fig(cancan : Tcanvas; alig, acol: integer);
var
  xx, yy : integer;
begin
  xx := 0;
  yy := 0;
  case pp[alig,acol].ptop  of
  0 : yy := k3;
  1 : yy := -k3-2;
  2 : yy := -k1-1;
  end;
  case pp[alig,acol].pleft  of
  0 : xx := k3;
  1 : xx := -2;
  2 : xx := -k3-2;
  end;
  yy := -yy;
  xx := -xx;
  case pp[alig, acol].ptop  of
  0 : Line(cancan, xx, 0, xx+k2, 0);
  1 : bez(cancan, xx, yy, curve1);
  2 : bez(cancan, xx, yy, curve3);
  end;
  case pp[alig,acol].pbottom  of
  0 : Line(cancan, xx, yy+k2-k3, xx+k2, yy+k2-k3);
  1 : bez(cancan, xx, yy+k2, curve1);
  2 : bez(cancan, xx, yy+k2, curve3);
  end;
  case pp[alig,acol].pleft  of
  0 : Line(cancan, 0, yy, 0, yy+k2);
  1 : bez(cancan, xx, yy, curve2);
  2 : bez(cancan, xx, yy, curve4);
  end;
  case pp[alig,acol].pright  of
  0 : Line(cancan, xx+k2-k3, yy, xx+k2-k3, yy+k2);
  1 : bez(cancan, xx+k2, yy, curve2);
  2 : bez(cancan, xx+k2, yy, curve4);
  end;
end;

Function TForm1.Envelope(alig, acol : integer) : trect;
var
  dx1, dy1, dx2, dy2 : integer;
begin
  dx1 := 0; dx2 := 0; dy1 := 0;; dy2 := 0;
  case pp[alig,acol].ptop  of
  0 : dy1 := k3;
  1 : dy1 := -k3-2;
  2 : dy1 := -k1-1;
  end;
  case pp[alig,acol].pbottom  of
  0 : dy2 := k2-k3;
  1 : dy2 := k2+k1+2;
  2 : dy2 := k2+k3+2;
  end;
  case pp[alig,acol].pleft  of
  0 : dx1 := k3;
  1 : dx1 := -2;
  2 : dx1 := -k3-2;
  end;
  case pp[alig,acol].pright  of
  0 : dx2 := k2-k3;
  1 : dx2 := k2+k3+2;
  2 : dx2 := k2+2;
  end;
  result.left   := acol*k2 - k3+dx1;
  result.top    := alig*k2 - k3+dy1;
  result.Right  := acol*k2 - k3+dx2;
  result.Bottom := alig*k2 - k3+dy2;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  if paintboxflag = 0 then exit;
  album1.drawarea(rect(0,0,paintbox1.width, paintbox1.height));
  if paintboxflag = 1 then paintbox1.canvas.draw(origx, origy, bmp1);
  if oksprites then pool.animate;
end;

procedure TForm1.S1Click(Sender: TObject);
begin
  if S1.caption = '&Turn off' then
  begin
    panel2.visible := false;
    S1.caption := '&Show Original';
  end
  else
  begin
    IF form4.radiogroup1.itemindex = 0 then
      DisplayImg(false) else DisplayImg(true);
    Panel2.visible := true;
    S1.caption := '&Turn off';
  end;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : tpoint;
begin
  IF movauto then exit;
  IF auto then exit;
  p.x := x;
  p.y := y;
  cur := 0;
  with pool do
  begin
    cur := Ptinsprite(p, -4);
    if cur > 0 then
    begin
      inc(ctrprior);
      setpriorityLast(cur, ctrprior);
      if (button = Mbright) and (Form4.radiogroup4.itemindex = 1) then
      begin
        curtoligcol;
        inc(PP[curlig, curcol].prot);
        if PP[curlig, curcol].prot > 3 then PP[curlig, curcol].prot := 0;
        setanimstyle(cur, PP[curlig, curcol].prot);
        animatemono(cur);
      end
      else
      begin
        if (ssctrl in shift) or (ssshift in shift) then
        begin
          autodeplace;
          testfinal;
        end
        else
        begin
          PlaySound(PChar('AUF'), hInstance, snd_ASync or snd_Resource);
          moving := true;
          mx := x-getposx(cur);
          my := y-getposy(cur);
        end;
      end;
    end
    else cur := 0;
  end;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if movauto then exit;
  if not moving then exit;
  with pool do
  begin
    If x-mx+getdcx(cur) < 0 then x := -getdcx(cur)+mx;
    IF y-my+getdcy(cur) < 0 then y := -getdcx(cur)+my;
    If x-mx+getdcx(cur) > paintbox1.width then
       x := Paintbox1.width-getdcx(cur)+mx;
    If y-my+getdcy(cur) > paintbox1.height then
       y := Paintbox1.height-getdcy(cur)+my;
    setpos(cur, x-mx, y-my);
    animatemono(cur);
  end;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if movauto then exit;
  if not moving then exit;
  moving := false;
  curtoligcol;
  PlaySound(PChar('ABB'), hInstance, snd_ASync or snd_Resource);
  with pool do
  begin
    if (abs(getposx(cur) - centrex-getoffsetx(cur)) < magnetism) AND
       (abs(getposy(cur) - centrey-getoffsety(cur)) < magnetism) AND
       (PP[curlig, curcol].prot = 0)  then
    begin
      setpos(cur,centrex+getoffsetx(cur), centrey+getoffsety(cur));
      setpriority(cur,0);
      settag(cur, 1);
      animatemono(cur);
      PlaySound(PChar('GUT'), hInstance, snd_ASync or snd_Resource);
    end
    else
    begin
      setpriorityLast(cur, ctrprior);
      settag(cur, 0);
    end;
    cur := 0;
  end;
  inc(ctrdeplace);
  testfinal;
end;

Function  Tform1.temps : string;
var
  tt : Tdatetime;
  st : string;
  hh, mn, ss, ms : word;
begin
  tt := now -Tstart;
  decodetime(tt, hh, mn, ss, ms);
  ss := ss;
  st := '';
  if hh > 0 then st := ' '+inttostr(hh)+' h';
  if mn > 0 then st := st+' '+inttostr(mn)+' min';
  st := st+'  '+inttostr(ss)+' sec';
  result := st;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  panel7.caption := temps;
end;

Function Tform1.testfinal : boolean;
const
  lib  = 'Congratulations, your time:';
var
  i : integer;
  a : integer;
  s : string;
  efficiency : integer;
begin
  a := 0;
  Label5.visible := false;
  For i := 1 to pool.maxspr do
  begin
    if pool.gettag(i) = 1 then inc(a);
  end;
  panel8.caption := inttostr(a)+' / '+inttostr(nbp)+' Parts';
  If a = Pool.maxspr then
  begin
    result := true;
    DisplayImg(false);
    timer1.enabled := false;
    panel7.caption := '';
    S1.enabled := true;
    panel2.visible := true;
    s := lib+temps;
    efficiency := 0;
    menugris(true);
    if ctrtriche > 0 then
    begin
     if ctrtriche > nbp  div 9 then efficiency := 2 else efficiency := 1;
    end;
    case efficiency of
    1 :;
    2 :;
    end;
    if Not finished then
    begin
      PlaySound(PChar('FIN'), hInstance, snd_ASync or snd_Resource);
      Label5.caption := s;
      Label5.left := (paintbox1.width - label5.width) div 2;
      Label5.visible := true;
      finished := true;
    end;
  end
  else result := false;
end;

procedure TForm1.AutoDeplace;
var
  d : integer;
  n : integer;
  fini  : boolean;
begin
  if movauto then exit;
  inc(ctrdeplace);
  movauto := true;
  with pool do
  begin
    curtoligcol;
    if pp[curlig, curcol].prot > 0 then
    begin
      pp[curlig, curcol].prot := 0;
      setanimstyle(cur, 0);
    end;
    setpriority(cur, Maxspr+2);
    if speed < 3 then
    begin
      setv(cur, rnd(-0.3,0.3), rnd(-0.5,0.5));
      d := distance(getposx(cur), getposy(cur),
             centrex+getoffsetx(cur), centrey+getoffsety(cur)) + 4;
      case speed of
      0 : d := d div 4;
      1 : d := d div 12;
      2 : d := d div 24;
      end;
      if d < 8 then d := 8;
      gotoxy(cur, centrex+getoffsetx(cur), centrey+getoffsety(cur), d);
           setloopctr(cur, d);
      fini := false;
      repeat
        For n := 1 to 4 do
        begin
          if pool <> Nil then
          begin
            animatemono(cur);
            if getloopctr(cur) = 1 then fini := true;
          end;
          application.processmessages;
        end;
      until fini;
    end
    else sleep(40);
    stop(cur);
    setpos(cur, centrex + getoffsetx(cur), centrey+ getoffsety(cur));
    animatemono(cur);
    setpriority(cur, 0);
    settag(cur, 1);
  end;
  inc(ctrtriche);
  movauto := false;
end;

procedure TForm1.A1Click(Sender: TObject);
var
  ctr : integer;
  nbpbord : integer;
  ctrbord : integer;
  minpiece : integer;
  maxpiece : integer;

  function pmin(p1,p2 : integer): integer;
  begin
    if p1 < p2 then result := p1 else result := p2;
  end;
  function pmax(p1,p2 : integer): integer;
  begin
    if p1 > p2 then result := p1 else result := p2;
  end;

  function isbordure(p : integer) : boolean;
  begin
    result := false;
    if (p < nx) or (p > nbp-nx) or (p mod nx < 2) then result := true;
  end;

begin
  IF auto = false then
  begin
    auto := true;
    A1.caption := '&Stop';
  end
  else
  begin
    auto := false;
  end;

  if (nx < 3) or (ny < 3) then nbpbord := nbp else nbpbord := nbp-(nx-2)*(ny-2);
  ctrbord := 0;
  minpiece := 1;
  maxpiece := nbp;
  for ctr := 1 to nbp do
    if (pool.gettag(ctr) = 1) and isbordure(ctr) then inc(ctrbord);
  with pool do
  begin
    while testfinal = false do
    begin
      application.processmessages;
      if auto = false then break;

      cur := rndi(minpiece, maxpiece);
      ctr := 0;
      IF form4.checkbox4.checked = false then Ctrbord := Nbpbord + 20;
      IF ctrbord < nbpbord then
      begin
        while (gettag(cur) = 1) or (ctr > nbp) or (isbordure(cur) = false) do
        begin
          inc(ctr);
          inc(cur);
          if cur > maxspr then cur := 1;
        end;
        inc(ctrbord);
      end
      else
      begin
        while (gettag(cur) = 1) or (ctr > nbp) do
        begin
          inc(ctr);
          inc(cur);
          if cur > maxspr then cur := 1;
        end;
      end;
      minpiece := pmin(cur, minpiece);
      maxpiece := pmax(cur, maxpiece);
      If not movauto then
      begin
        autodeplace;
      end;
    end;
  end;
  auto := false;
  A1.caption := '&Automatic';
end;

procedure TForm1.C1Click(Sender: TObject);
var
  rrr : integer;
  i : integer;
  m1 : integer;
  m2 : integer;
  m3 : integer;
  m4 : integer;
  c1 : boolean;
  c2 : boolean;
  c3 : boolean;
begin
  with form4 do
  begin
    m1 := Radiogroup1.itemindex;
    m2 := Radiogroup2.itemindex;
    m3 := Radiogroup3.itemindex;
    m4 := Radiogroup4.itemindex;
    c1 := checkbox1.checked;
    c2 := checkbox2.checked;
    c3 := Checkbox3.checked;
    if form4.showmodal = mrcancel then
    begin
      Radiogroup1.itemindex := m1;
      Radiogroup2.itemindex := m2;
      Radiogroup3.itemindex := m3;
      Radiogroup4.itemindex := m4;
      checkbox1.checked := c1;
      checkbox2.checked := c2;
      checkbox3.checked := c3;
      exit;
    end;
    case Radiogroup2.itemindex of
    0 : Magnetism := 12;
    1 : Magnetism := 4;
    end;
    speed := radiogroup3.itemindex;
    Case radiogroup1.itemindex of
    0 : S1.enabled := true;
    1 : S1.enabled := true;
    2 : begin
        S1.enabled := false;
        Panel2.visible := false;
        end;
    end;
    RightClick := checkbox1.enabled;
    if checkbox3.checked then
      timer1.enabled := true else timer1.enabled := false;

    IF Form4.Radiogroup4.itemindex <> m4 then
    begin
      IF form4.radiogroup4.itemindex = 0 then
      begin
        progressbar1.position := 0;
        progressbar1.max := pool.maxspr;
        For i := 0 to Pool.maxspr do
        begin
          If pool.gettag(i) <> 1 then
          begin
            progressbar1.position := i;
            cur := i;
            curtoligcol;
            if pp[curlig, curcol].prot > 0 then
            begin
              pp[curlig, curcol].prot := 0;
              pool.setanimstyle(cur, 0);
            end;
          end;
        end;
        progressbar1.position := 0;
      end
      else
      begin
        progressbar1.position := 0;
        progressbar1.max := pool.maxspr;
        For i := 0 to Pool.maxspr do
        begin
          IF pool.gettag(i) <> 1 then
          begin
            progressbar1.position := i;
            cur := i;
            curtoligcol;
            rrr := rndi(0,3);
            pool.setanimstyle(cur, rrr);
            pp[curlig, curcol].prot    := rrr;
            pp[curlig, curcol].prot0   := rrr;
          end;
        end;
        progressbar1.position := 0;
      end;
      Pool.animate;
    end;
  end;
end;

procedure TForm1.Paintbox2Click(Sender: TObject);
begin
  if panel2.left < 8 then DisplayImg(false) else DisplayImg(true);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  aboutbox.showmodal;
end;

procedure TForm1.PaintBox2Paint(Sender: TObject);
begin
  if panel2.left < 8 then
    Paintbox2.canvas.stretchdraw(rect(0,0,paintbox2.width,
                                          paintbox2.height),bmp1)
  else
    Paintbox2.canvas.draw(0,0, bmp1);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  top:=0;
end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Load1Click(Sender: TObject);
var
  bmpfond : Tbitmap;
  choix : integer;
begin
  paintbox1.visible:=true;
  ctrtriche  := 0;
  ctrdeplace := 0;
  finished := false;
  timer1.enabled := false;
  panel7.caption := '';
  label5.visible := false;
  if firsttime then
  begin
    readinifile;
    if oldpuzzle AND (messagedlg
       ('The last, incomplete puzzle  '+filename+'  load again?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      form3.filelistbox1click(form1);
      ok := true;
      Dimensions;
      if (oldPbwidth  = paintbox1.width) AND
         (oldPbheight = paintbox1.height) AND
         (oldorigx    = origx) AND
         (oldorigy    = origy) AND
         (oldnbp      = nbp) AND
         (oldk1       = k1) AND
         (oldnbx      = nx) AND
         (oldnby      = ny) AND
         (oldzrect.left   = zrect.left) AND
         (oldzrect.top    = zrect.top) AND
         (oldzrect.right  = zrect.right) AND
         (oldzrect.bottom = zrect.bottom) Then
      begin
        redo := true;
        Makepuzzle(true);

        Tstart := Tstart - Tancien;
        redo := false;
        if form4.checkbox3.checked then timer1.enabled := true;
        Paintboxflag := 2;
        oldpuzzle := false;
        firsttime := false;
        exit;
      end
      else
      begin
        showmessage('An error occurred while loading the image.!');
        oldpuzzle := false;
      end;
    end;
    firsttime := false;
  end;

  form2.top  := 40;
  form2.left := 4;
  oksprites := false;
  album1.freepoolstoons;
  bmpfond := album1.getareabmp;
  with bmpfond.canvas do
  begin
    brush.color := clbtnface;
    fillrect(rect(0,0,paintbox1.width, paintbox1.height));
  end;
  repeat
    If form3.showmodal = MrOK then
    begin

      Image1.Visible := false;

      ok := true;
      PaintboxFlag := 1;
      dimensions;
      Shapes;
      drawingtest(true);
      paintbox1.canvas.draw(origx, origy, bmp1);

      if Form4.Radiogroup4.itemindex = 0 then
         Form2.checkbox1.checked := false else Form2.checkbox1.checked := true;
      choix := form2.showmodal;
      if form2.checkbox1.checked then
        Form4.Radiogroup4.itemindex := 1 else Form4.Radiogroup4.itemindex := 0;
    end
    else choix := mrcancel;
  until (choix = mrok) or (choix = mrcancel);
  IF choix = mrok then
  begin
    menugris(false);
    drawingtest(false);
    Makepuzzle(false);
    panel2.visible := false;
    if form4.checkbox3.checked then timer1.enabled := true;
    Paintboxflag := 2;
  end
  else
  begin
    paintboxflag := 1;
    paintbox1.invalidate;
    ok := false;
  end;
end;


procedure TForm1.C2Click(Sender: TObject);
var
  bmpfond : TBitmap;
begin
  firsttime := true;
  oldpuzzle := false;
  PaintboxFlag := 0;
  ok := false;
  oksprites := false;
  moving := false;
  auto := false;
  redo := false;
  finished := false;
  magnetism := 12;
  RightClick := true;
  speed := 1;
  startdir := getcurrentdir;
  menugris(true);
  bmpfond := Tbitmap.create;
  Try
    bmpfond.width  := paintbox1.width;
    bmpfond.height := paintbox1.height;
    bmpfond.canvas.brush.color := clbtnface;
    bmpfond.canvas.fillrect(rect(0,0,paintbox1.width, paintbox1.height));
    bmpfond.canvas.brush.color := clblack;
    Album1 := Talbum.create(paintbox1.canvas, Bmpfond);
    Paintboxflag := 1;
  finally
    bmpfond.free;
  end;

  Bmp0 := Tbitmap.create;
  Bmp0.width  := 8;
  Bmp0.height := 8;
  Bmp0.pixelformat := pf24bit;
  Bmp1 := Tbitmap.create;
  Bmp1.width  := 8;
  Bmp1.height := 8;
  Bmp1.pixelformat := pf24bit;
  pzcolor := clgray;
  Image1.Visible := true;
end;

end.
