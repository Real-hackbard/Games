unit Unit1;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls, Dialogs,
  Menus, StdCtrls, Grids, Buttons, Messages, XPMan, Spin, ComCtrls;

type
  TIdRect=record
    Id:string;
    Left,top,right,bottom:integer;
    W,H,Area:integer;
  end;
  
  TForm1 = class(TForm)
    Panel3: TPanel;
    Panel2: TPanel;
    lichtaus: TPanel;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    Button1: TButton;
    Paintbox1: TPaintBox;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label3: TLabel;
    Label4: TLabel;
    Shape1: TShape;
    ColorDialog1: TColorDialog;
    procedure Button1Click(Sender: TObject);
    procedure Paintbox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Paintbox1Paint(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private-Deklarationen}
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  neuesspiel: boolean;
  lfeld:array[0..21,0..21] of boolean;
  zuege:integer;

implementation


{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j:integer;
begin
  neuesspiel:=true;
  zuege:=0;
  randomize;
  for i:=1 to 20 do
    for j:=1 to 20 do
       lfeld[i,j]:=(random<0.5);
  PaintBox1Paint(sender);
end;


procedure TForm1.Paintbox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nr,b,h,xx,br,i,j,xoffset:integer;
begin
  b:=paintbox1.width;
  h:=paintbox1.height;
  nr:=strtoint(edit1.text);

  if nr>20 then
  begin
    nr:=20;
    edit1.text:='20'
  end;

  xx:=b;
  if h<b then xx:=h;
  br:=(xx-60) div nr;
  xoffset:=(b-nr*br) div 2;

  if (x>=xoffset) and (y>=30) and neuesspiel then
  begin
    inc(zuege);
    x:=x-xoffset;
    y:=y-30;
    i:=x div br +1;
    j:=y div br +1;

    if (i in [1..nr]) and (j in [1..nr]) then
    begin
      lfeld[i,j]:=not lfeld[i,j];
      if i>1 then lfeld[i-1,j]:=not lfeld[i-1,j];
      if i<nr then lfeld[i+1,j]:=not lfeld[i+1,j];
      if j>1 then lfeld[i,j-1]:=not lfeld[i,j-1];
      if j<nr then lfeld[i,j+1]:=not lfeld[i,j+1];
      PaintBox1Paint(sender);
    end;
  end;
end;

procedure TForm1.Paintbox1Paint(Sender: TObject);
var
  xoffset,nr,b,h,x,i,j,br,anz:integer;
  bitmap:tbitmap;
begin
  nr:=strtoint(edit1.text);

  if nr>20 then
  begin
    nr:=20;
    edit1.text:='20'
  end;

  b:=paintbox1.width;
  h:=paintbox1.height;
  x:=b;
  if h<b then x:=h;
  br:=(x-60) div nr;
  xoffset:=(b-nr*br) div 2;
  bitmap:=tbitmap.create;
  bitmap.width:=paintbox1.width;
  bitmap.height:=paintbox1.height;
  anz:=0;

  for i:=1 to nr do
    for j:=1 to nr do
    begin
      if lfeld[i,j] then
      begin
        inc(anz);
        bitmap.canvas.Brush.color:= Shape1.Brush.Color;
      end else
      begin
        bitmap.canvas.Brush.color:=clwhite;
      end;

      bitmap.canvas.rectangle(xoffset+(i-1)*br,30+(j-1)*br,
                              xoffset+i*br+1,30+j*br+1);
  end;

  paintbox1.canvas.draw(0,0,bitmap);
  bitmap.free;
  label1.caption:='Moves '+inttostr(zuege);

  if anz=0 then
  begin
    if zuege>0 then
    begin
      Beep();
      showmessage('Congratulations! Task with '+inttostr(zuege)+' Trains done');
    end;
  end;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if NOT (Key in [#08, '0'..'9']) then 
    Key := #0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Shape1.Brush.Color := clYellow;
end;

procedure TForm1.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.Execute then
    Shape1.Brush.Color := ColorDialog1.Color;
  PaintBox1.OnPaint(sender);
end;

end.
