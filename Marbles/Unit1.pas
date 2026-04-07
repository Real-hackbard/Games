unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, ComCtrls, XPMan;

type

  tSlot=record {describes a marble position}
    {base position plus two intermediate positions clockwise used to animate moves}
    positions:array[1..3] of trect;
    currRect:TRect; {current marble position, used for erasing during moves}
    color:TColor; {color of the marble currently occupying this slot}
   end;

  TSlots=array[0..18] of TSlot;  {Set of slot records describing a track}

  TForm1 = class(TForm)
    Image1: TImage;
    ResetBtn: TButton;
    MoveBox: TGroupBox;
    Label1: TLabel;
    MoveCount: TSpinEdit;
    HCWBtn: TButton;
    HCCWBtn: TButton;
    VCWBtn: TButton;
    VCCWBtn: TButton;
    Memo1: TMemo;
    Label2: TLabel;
    MoveCountLbl: TLabel;
    StatusBar1: TStatusBar;
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure HCWBtnClick(Sender: TObject);
    procedure VCWBtnClick(Sender: TObject);
    procedure HCCWBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure VCCWBtnClick(Sender: TObject);
  public
    cx,cy,r,cr:integer;
    bgc:TColor; {background color for board}
    trkcolor:TColor; {Track color}
    vslots:TSlots;
    hslots:TSlots;
    nbrmoves:integer;
    procedure setup;
    procedure redraw;
    procedure draw(const Slots:TSlots; n:integer);
    procedure synchFrom(var Slots1, Slots2:TSlots);
    procedure move(var Slots:TSlots; clockwise:boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var sleeptime:integer=50; {speed of move, 50 milliseconds allows move to be observed}

{**************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
{initialization}
begin
  setup; {Set colors}
  redraw;{Set track and marble positions}
  doublebuffered:=true;
end;


{************* FormResize *************}
Procedure TForm1.FormResize(Sender: TObject);
{when form size changes}
begin
  redraw;
end;

{************ Redraw **************}
procedure TForm1.redraw;
{size may have changed so recalc size fields and redraw marbles}
var   locs:array[1..5, 1..3] of TRect;

        {*****************************}
        {local routines used by ReDraw}
        {*****************************}

        {**** getpoint ****}
        function getpoint(cx,cy:integer;angle,d:extended):TPoint;
        {polar to cartesian conversion}
        begin
          result.x:=round(cx+d*cos(angle));
          result.y:=round(cy+d*sin(angle));
        end;

        {**** drawloop ****}
        procedure drawloop(startangle:extended; x,y:integer);
        {define one track loop, track and 5 marbles}
        var
          i,dx,dy:integer;
          p:TPoint;
        begin
          with image1, canvas do
          begin
            pen.width:=1;
            for i:= 0 to 4 do
            begin
              if (i=0) or (i=4) then brush.color:=clyellow
              else brush.color:=clblue;
              p:=getpoint(x,y,startangle+i*pi/4,3*r);
              locs[i+1,1]:=rect(p.x-cr,p.y-cr,p.x+cr,p.y+cr);
              p:=getpoint(x,y,startangle+i*pi/4+pi/12,3*r);
              locs[i+1,2]:=rect(p.x-cr,p.y-cr,p.x+cr,p.y+cr);
              p:=getpoint(x,y,startangle+i*pi/4+pi/6,3*r);
              locs[i+1,3]:=rect(p.x-cr,p.y-cr,p.x+cr,p.y+cr);
            end;
            pen.width:=2;
            dx:=round(r*cos(startangle));
            dy:=round(r*sin(startangle));
            {draw inner arc}
            arc(x+2*r,y+2*r,x-2*r,y-2*r, x-2*dx,y-2*dy, x+2*dx,y+2*dy);
            {extend inner arc by 1 radius width toward center and fill  it}
            brush.color:=clblack;
            fillrect(rect(x-2*dx,y-2*dy,x+2*dx+dy,y+2*dy-dx));
            {fill the inner arc}
            floodfill(round(x-2*sin(startangle)),round(y+2*cos(startangle)),
                        bgc,fssurface); 

            {draw middle arc}
            arc(x+4*r,y+4*r,x-4*r,y-4*r, x-4*dx,y-4*dy, x+4*dx,y+4*dy);
            {extend ends of middle arc by 1 radius toward center}
            moveto(x-4*dx,y-4*dy); lineto(x-4*dx+dy,y-4*dy-dx);
            moveto(x+4*dx,y+4*dy); lineto(x+4*dx+dy,y+4*dy-dx);

            {draw outer arc}
            arc(x+5*r,y+5*r,x-5*r,y-5*r, x-5*dx,y-5*dy, x+5*dx,y+5*dy);
          end;
        end; {drawloop}

        procedure interpolate(var Slots:TSlots);
        {assign intermediate move postions to animate marbles in center of track
          (marble numbers 5,6,7,8,9 and 14,15,16,17,18) }
        var i:integer;
            r1,r2:Trect;
        begin
          for  i:=5 to 18 do
          if (i<10) or (i>13) then
          begin
            with slots[i] do
            begin
              r1:=positions[1];{r1 = one end of move}
              {r2 = other end of move}
              If i<18 then r2:=slots[i+1].positions[1]
              else r2:=slots[1].positions[1];
              with positions[2] do {move 1/3 of distance from r1 to r2}
              begin
                left:= positions[1].left + (r2.left-r1.left) div 3;
                top:= positions[1].top + (r2.top-r1.top) div 3;
                right:= positions[1].right + (r2.right-r1.right) div 3;
                bottom:= positions[1].bottom + (r2.bottom-r1.bottom) div 3;
              end;
              with positions[3] do {move 2/3 of distance from r1 to r2}
              begin
                left:= positions[1].left + 2*(r2.left-r1.left) div 3;
                top:= positions[1].top + 2*(r2.top-r1.top) div 3;
                right:= positions[1].right + 2*(r2.right-r1.right) div 3;
                bottom:= positions[1].bottom + 2*(r2.bottom-r1.bottom) div 3;
              end;
            end;
          end;
        end; {interpolate}

var i,j,n:integer;
begin  {redraw}

 {position left side controls at bottom of screen}
  resetbtn.top:=clientheight-statusbar1.height-resetbtn.height-10;
  movebox.top:=resetbtn.top-movebox.height-10;

  {now work on the track}
  with image1, canvas do
  begin
    bgc:=clBlack;
    trkcolor:=clBlack;

    brush.color:=bgc;
    height:=self.clientheight-statusbar1.height;
    width :=height;
    left:=self.clientwidth-width;
    top:=0;
    update;
    rectangle(0,0,width,height);

    cx:=width div 2;
    cy:=height div 2;

    r:= width div 22;  {basic track width}
    cr:=9*r div 10 - 1;  {marble radius}

    {fill in the black center square}
    brush.color:=clblack;
    fillrect(rect(cx-2*r,cy-2*r,cx+2*r,cy+2*r));

    {assign base poistions for inner square marbles}
    for n:=18 downto 15 do
    begin
      i:=0; j:=18-n;
      vslots[n].positions[1]:=
          rect(cx+(2*i-3)*r-cr,cy+(2*j-3)*r-cr,cx+(2*i-3)*r+cr,cy+(2*j-3)*r+cr);
    end;
    for n:=6 to 9 do
    begin
      i:=3; j:=n-6;
      vslots[n].positions[1]:=
          rect(cx+(2*i-3)*r-cr,cy+(2*j-3)*r-cr,cx+(2*i-3)*r+cr,cy+(2*j-3)*r+cr);
    end;
    for n:=15 to 18 do
    begin
      i:=n-15; j:=0;
      hslots[n].positions[1]:=
          rect(cx+(2*i-3)*r-cr,cy+(2*j-3)*r-cr,cx+(2*i-3)*r+cr,cy+(2*j-3)*r+cr);
    end;
    for n:=9 downto 6 do
    begin
      i:=9-n;  j:=3;
      hslots[n].positions[1]:=
          rect(cx+(2*i-3)*r-cr,cy+(2*j-3)*r-cr,cx+(2*i-3)*r+cr,cy+(2*j-3)*r+cr);
    end;

    {draw the four loops - marbles and track segments}
    drawloop(-pi,cx,cy-5*r);   {top loop}
    for i:=1 to 5 do for j:=1 to 3 do vslots[i].positions[j]:=locs[i,j];
    drawloop(0,cx,cy+5*r);     {bottom loop}
    for i:=10 to 14 do for j:=1 to 3 do vslots[i].positions[j]:=locs[i-9,j];
    drawloop(pi/2, cx-5*r,cy); {left loop}
    for i:=10 to 14 do for j:= 1 to 3 do hslots[i].positions[j]:=locs[i-9,j];
    drawloop(-pi/2,cx+5*r,cy); {right loop}
    for i:=1 to 5 do for j:= 1 to 3 do hslots[i].positions[j]:=locs[i,j];

    floodfill(cx,cy-9*r-2,bgc,fssurface); {fill outer arc}
    brush.color:=trkcolor;
    floodfill(cx-2*r-1,cy-2*r-1,bgc,fssurface); {fill track area}

    {assign intermediate marble positions}
    interpolate(HSlots);
    interpolate(VSlots);
  end;

  for i:=1 to 18 do
  begin
    hslots[i].currrect:=hslots[i].positions[1];
    vslots[i].currrect:=vslots[i].positions[1];
   end;


  {Show the track}
  draw(Vslots,1);
  draw(HSlots,1);
end; {redraw}

var
  {"Shift" array is used by procedure SynchForm to synchronize marble colors
   common to horizontal and vertical tracks after a move}
  shift:array[0..5] of integer = (18,6,9,15,18,6);

{*************** SynchForm *************}
procedure TForm1.SynchFrom(var slots1, slots2:TSlots);
{make the common slots in slots2 match color with slots1}
var
  i,d:integer;
begin
  if @slots1=@hslots then d:=-1 else d:=+1;
  for i:=1 to 4 do slots2[shift[i]].color:=slots1[shift[i+d]].color;
end;


{**************** Draw *****************}
procedure TForm1.draw(Const slots:TSlots; n:integer);
{draw marbles being moved, "n" indicates which intermediate position}
var i:integer;
begin
  with image1.canvas do
  begin
    pen.color:=trkcolor;
    brush.color:=trkcolor;
    for i:=1 to 18 do {erase all tokens from their old positions}
    with slots[i] do  with currrect do ellipse(left,top,right,bottom);

    for i:=1 to 18 do
    with slots[i] do
    begin
      brush.color:=color;
      pen.color:=clblack;
      with positions[n] do ellipse(left,top,right,bottom);
      currrect:=positions[n];
    end;
  end;
end;

{**************** Move ******************}
procedure Tform1.move(var Slots:TSlots; clockwise:boolean);
{Move Horiz or Vertical track one position clockwise or counterclockwise}
var
  i:integer;
  c:Tcolor;
begin
  if clockwise then
  begin
    for i:=2 to 3 do
    begin
     draw(slots, i);
     update;
     sleep(sleeptime);
    end;
    c:=slots[18].color;
    for i:=18 downto 2 do slots[i].color:=slots[i-1].color;
    slots[1].color:=c;
    draw(slots,1);
  end
  else
  begin {counterclockwise}
    c:=slots[1].color; {save last color}
    for i:=1 to 17 do slots[i].color:=slots[i+1].color; {shift all colors back}
    slots[18].color:=c; {put color 1 in slot 18}
    for i:=3 downto 1 do
    begin
      draw(slots,i);
      update;
      sleep(sleeptime);
    end;
  end
end;

{***************  Setup ************}
Procedure TForm1.Setup;
{Re-establish original marble arrangement}
var i:integer;
    c:Tcolor;
begin
  for i:= 1 to 18 do
  begin
    case i of
      1,5,10,14: c:=clyellow;
      2,3,4,11,12,13:c:=clblue;
      else c:=clred;
    end;
    vslots[i].color:=c;
    hslots[i].color:=c;
  end;
  nbrmoves:=0;
  movecountlbl.caption:='0';
end;

{********************* HCWBtnCLick ***********}
procedure TForm1.HCWBtnClick(Sender: TObject);
{Horizontal clockwise move}
var i:integer;
begin
  for i:=1 to movecount.value do  move(hSlots,true);
  synchfrom(hSlots,vslots);
  inc(nbrmoves);
  movecountlbl.caption:=inttostr(nbrmoves);
end;

{****************** VCWBtnCLick ***********}
procedure TForm1.VCWBtnClick(Sender: TObject);
{Vertical clockwise move}
var i:integer;
begin
  for i:=1 to movecount.value do move(vSlots,true);
  synchfrom(vSlots,hSlots);
  inc(nbrmoves);
  movecountlbl.caption:=inttostr(nbrmoves);
end;

{****************** HCCWBtnCLick ***********}
procedure TForm1.HCCWBtnClick(Sender: TObject);
{Horoizontal counterclockwise move}
var i:integer;
begin
  for i:=1 to movecount.value do move(Hslots,false);
  synchfrom(hslots,vslots);
  inc(nbrmoves);
  movecountlbl.caption:=inttostr(nbrmoves);
end;

{****************** VCCWBtnCLick ***********}
procedure TForm1.VCCWBtnClick(Sender: TObject);
{Vertical counterclockwise move}
var i:integer;
begin
  for i:=1 to movecount.value do move(Vslots,false);
  synchfrom(vslots,hslots);
  inc(nbrmoves);
  movecountlbl.caption:=inttostr(nbrmoves);
end;

{**************** ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{Reset the marbles to original position and score to 0}
begin
  setup;
  draw(vslots,1);
  draw(hslots,1);
end;

end.
