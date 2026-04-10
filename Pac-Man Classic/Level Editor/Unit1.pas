unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FileCtrl, XPman;

const
  SIZE = 32;

type
  TForm1 = class(TForm)
    Image1: TImage;
    imgPlan: TImage;
    Panel1: TPanel;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    imgFond: TImage;
    imgPts: TImage;
    imgGum: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    FileListBox1: TFileListBox;
    OpenDialog2: TOpenDialog;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label2: TLabel;
    imgBrush: TImage;
    procedure FormShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure imgFondMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgPtsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgGumMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Declarations privates }
    procedure Draw(x,y: integer);
  public
    { Declarations public }
  end;

var
  Form1: TForm1;
  sPath: string;
  lDown: boolean;
  imgPlanColor: TColor;

implementation

{$R *.DFM}
procedure TForm1.Draw(x,y: integer);
begin
  X := x div 32; Y := y div 32;
  Image1.Canvas.CopyRect(Rect(X*32,Y*32,(X*32)+32,(Y*32)+32),
    imgBrush.Canvas, Rect(0,0,32,32));
  imgPlan.Canvas.Pixels[x, y] := imgPlanColor;

  if CheckBox1.State = cbChecked then begin
    y := 14-y;
    Image1.Canvas.CopyRect(Rect(X*32,Y*32,(X*32)+32,(Y*32)+32),
      imgBrush.Canvas, Rect(0,0,32,32));
    imgPlan.Canvas.Pixels[x, y] := imgPlanColor;
  end;

  if CheckBox2.State = cbChecked then begin
    x := 14-x;
    Image1.Canvas.CopyRect(Rect(X*32,Y*32,(X*32)+32,(Y*32)+32),
      imgBrush.Canvas, Rect(0,0,32,32));
    imgPlan.Canvas.Pixels[x, y] := imgPlanColor;
  end;

  if (CheckBox1.State = cbChecked) and (CheckBox2.State = cbChecked) then
  begin
    y := 14-y;
    Image1.Canvas.CopyRect(Rect(X*32,Y*32,(X*32)+32,(Y*32)+32),
      imgBrush.Canvas, Rect(0,0,32,32));
    imgPlan.Canvas.Pixels[x, y] := imgPlanColor;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  x,y: byte;
begin
  sPath := ExtractFilePath(ParamStr(0));
  imgPts.Picture.LoadFromFile(sPath+'Points.bmp');
  imgFond.Picture.LoadFromFile(sPath+'Mur1.bmp');
  imgGum.Picture.LoadFromFile(sPath+'PacGum.bmp');

  for x := 0 to 14 do for y := 0 to 14 do
    Image1.Canvas.CopyRect(Rect(x*32,y*32,(x*32)+32,(y*32)+32),
    imgFond.Canvas, Rect(0,0,32,32));
  imgPlan.Canvas.Brush.Color := clWhite;
  imgPlan.Canvas.FillRect(Rect(0,0,15,15));

  imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
  imgPlanColor := clBlack;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  x,y: byte;
begin
  if OpenDialog1.Execute then begin
    imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
    imgPlanColor := clBlack;
    imgFond.Picture.LoadFromFile(OpenDialog1.FileName);
    for x := 0 to 14 do for y := 0 to 14 do
      if imgPlan.Canvas.Pixels[x,y] = clWhite then
        Image1.Canvas.CopyRect(Rect(x*32,y*32,(x*32)+32,(y*32)+32),
        imgFond.Canvas, Rect(0,0,32,32));
  end;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  lDown := true;
  Draw(x,y);
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  lDown := false;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if lDown then Draw(x,y);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  x,y: byte;
  s: string;
  nOld, nNew: integer;
  F: TextFile;
begin
  {$I-}
  ChDir(sPath);
  {$I+}
  FileListBox1.Directory := sPath;
  FileListBox1.Update;
  s := IntToStr(FileListBox1.Items.Count+1);
  if InputQuery('Table number', 'Please indicate your table number :', s) then
  begin
    Form1.Caption := 'Tableau - n° '+s;
    nNew := StrToInt(s);
    if FileExists('Tab'+s+'.txt') and
                 (MessageDlg('This table already exists; does it need to be replaced? ?',
                 mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
    begin
      {Rename the txt and bmp files above}
      for nOld := FileListBox1.Items.Count downto nNew do begin
        RenameFile('Tab'+IntToStr(nOld)+'.txt', 'Tab'+IntToStr(nOld+1)+'.txt');
        RenameFile('Mur'+IntToStr(nOld)+'.bmp', 'Mur'+IntToStr(nOld+1)+'.bmp');
      end;
    end;
    {Write text file}
    AssignFile(F, 'Tab'+IntToStr(nNew)+'.txt');
    Rewrite(F);
    for y := 0 to 14 do begin
      s := '';
      for x := 0 to 14 do begin
        if imgPlan.Canvas.Pixels[x,y] = clWhite then s := s+'#'
        else if imgPlan.Canvas.Pixels[x,y] = clBlack then s := s+' '
        else if imgPlan.Canvas.Pixels[x,y] = clBlue then s := s+'!';
      end;
      Writeln(F, s);
    end;
    CloseFile(F);
    {Writes bmp file}
    {Keep only the 32x32 pixels}
    imgBrush.Picture := nil;
    for x := 0 to 31 do for y := 0 to 31 do
      imgBrush.Canvas.Pixels[x,y] := imgFond.Canvas.Pixels[x,y];
    imgBrush.Picture.SaveToFile('Mur'+IntToStr(nNew)+'.bmp');
    imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
    imgPlanColor := clBlack;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  x, y: integer;
  aTab: TStringList;
  SRect: TRect;
  s: string;
begin
  if OpenDialog2.Execute then begin
    {n°}
    s := Copy(ExtractFileName(OpenDialog2.FileName),4,3);
    s := Copy(s,1,Pos('.',s)-1);
    Form1.Caption := 'Table - n° '+s;
    {Image of the walls}
    imgFond.Picture.LoadFromFile(ExtractFilePath(OpenDialog2.FileName)+
        'Mur'+s+'.bmp');
    {Convert the text file into a bitmap image}
    aTab := TStringList.Create;
    aTab.LoadFromFile(OpenDialog2.FileName);
    SRect := Rect(0,0,SIZE,SIZE);
    for y := 0 to 14 do begin
      for x := 0 to 14 do begin
        case aTab[y][x+1] of
        ' ':
          begin
          Image1.Canvas.CopyRect(
             Rect(x*SIZE,y*SIZE,(x*SIZE)+SIZE,(y*SIZE)+SIZE),
              imgPts.Canvas,SRect);
          imgPlan.Canvas.Pixels[x,y] := clBlack;
          end;
        '!':
          begin
          Image1.Canvas.CopyRect(
             Rect(x*SIZE,y*SIZE,(x*SIZE)+SIZE,(y*SIZE)+SIZE),
              imgGum.Canvas,SRect);
          imgPlan.Canvas.Pixels[x,y] := clBlue;
          end;
        else
          begin
          Image1.Canvas.CopyRect(Rect(x*SIZE,y*SIZE,(x*SIZE)+SIZE,(y*SIZE)+SIZE),imgFond.Canvas,SRect);
          imgPlan.Canvas.Pixels[x,y] := clWhite;
          end;
        end;
      end;
    end;
    aTab.free;
    imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
    imgPlanColor := clBlack;
  end;
end;

procedure TForm1.imgFondMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgBrush.Picture.Assign(imgFond.Picture.Bitmap);
  imgPlanColor := clWhite;
end;

procedure TForm1.imgPtsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
  imgPlanColor := clBlack;
end;

procedure TForm1.imgGumMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgBrush.Picture.Assign(imgGum.Picture.Bitmap);
  imgPlanColor := clBlue;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if MessageDlg('Are you sure you want a new painting? ?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FormShow(Self);
end;

end.
