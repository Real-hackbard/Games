unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Menus,
  ExtCtrls, StdCtrls, MMSystem, Math, SoundPlayerThread, Dialogs;

type
 TBoard=array[-4..19,0..9] of integer;
 TOrientation=(toleft,toright,todown,torotate);
 TPiece=
  record
   matrix:array[0..3,0..3] of smallint;
   width:integer;
   height:integer;
  end;
 PPiece=^TPiece;
 TPieceKey=record
  key1,key2,key3:integer;
 end;
type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    S1: TShape;
    L1: TLabel;
    S2: TShape;
    L2: TLabel;
    PaintBox2: TPaintBox;
    L5: TLabel;
    L9: TLabel;
    S4: TShape;
    S5: TShape;
    L8: TLabel;
    L6: TLabel;
    L7: TLabel;
    S6: TShape;
    L4: TLabel;
    L3: TLabel;
    MainMenu1: TMainMenu;
    M1: TMenuItem;
    M2: TMenuItem;
    O1: TMenuItem;
    M3: TMenuItem;
    S3: TMenuItem;
    N1: TMenuItem;
    S7: TMenuItem;
    ColorDialog1: TColorDialog;
    B1: TMenuItem;
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PaintBox2Paint(Sender: TObject);
    procedure M2C(Sender: TObject);
    procedure M1C(Sender: TObject);
    procedure M3Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
  private
   fboard: TBoard;
   fposcol,fposrow,foffx,foffy:integer;
   fscore:integer;
   flines:integer;
   flevel:integer;
   ftime:longword;
   fpieceplaced,fterminate:boolean;
   fcurpiece,fnextpiece:TPieceKey;
  protected
   function GetCellRect(arow,acol:integer):TRect;
   function GetPreviewCellRect(arow,acol:integer):TRect;
   function CanPutPiece(apiece:PPiece;arow,acol:integer):boolean;
   function ClearLines:integer;
   procedure InvalidatePiece(arow,acol:integer);
   procedure InvalidatePreviewGrid;
   procedure PutPiece(apiece:PPiece;arow,acol:integer;ainv:boolean=true);
   procedure ClearPiece(apiece:PPiece;arow,acol:integer;ainv:boolean=true);
   procedure MovePiece(aOrientation:TOrientation);
   procedure Initialize;
   procedure GameLoop;
   procedure WndProc(var msg:TMessage);override;
  public
  end;

const
 CELL_SIZE         :integer=21;
 PREVIEW_CELL_SIZE :integer=17;
 ROW_CNT           :integer=20;
 COL_CNT           :integer=10;
 CLR_CNT           :integer=10;
 PIECE_SIZE        :integer= 4;
 LINE_SCORE        :integer=10;
 BONUS_SCORE       :integer=20;
 WM_STARTGAME :longword =WM_USER+1;
 COLORS   :array[1..10] of TColor =
 (clred,clyellow,clTeal,clblue,clPurple,cllime,clFuchsia,clAqua,clMaroon,clSilver);
 PIECES   :array[0..6,0..3] of TPiece=
 (
  (
   (matrix :((1,0,0,0),(1,0,0,0),(1,0,0,0),(1,0,0,0));width:1;height:4),
   (matrix :((1,1,1,1),(0,0,0,0),(0,0,0,0),(0,0,0,0));width:4;height:1),
   (matrix :((1,0,0,0),(1,0,0,0),(1,0,0,0),(1,0,0,0));width:1;height:4),
   (matrix :((0,0,0,0),(1,1,1,1),(0,0,0,0),(0,0,0,0));width:4;height:1)
  ),
  (
   (matrix :((1,0,0,0),(1,0,0,0),(1,1,0,0),(0,0,0,0));width:2;height:3),
   (matrix :((0,0,1,0),(1,1,1,0),(0,0,0,0),(0,0,0,0));width:3;height:2),
   (matrix :((1,1,0,0),(0,1,0,0),(0,1,0,0),(0,0,0,0));width:2;height:3),
   (matrix :((1,1,1,0),(1,0,0,0),(0,0,0,0),(0,0,0,0));width:3;height:2)
  ),
  (
   (matrix :((0,1,0,0),(0,1,0,0),(1,1,0,0),(0,0,0,0));width:2;height:3),
   (matrix :((1,1,1,0),(0,0,1,0),(0,0,0,0),(0,0,0,0));width:3;height:2),
   (matrix :((1,1,0,0),(1,0,0,0),(1,0,0,0),(0,0,0,0));width:2;height:3),
   (matrix :((1,0,0,0),(1,1,1,0),(0,0,0,0),(0,0,0,0));width:3;height:2)
  ),
  (
   (matrix :((1,0,0,0),(1,1,0,0),(0,1,0,0),(0,0,0,0));width:2;height:3),
   (matrix :((0,1,1,0),(1,1,0,0),(0,0,0,0),(0,0,0,0));width:3;height:2),
   (matrix :((1,0,0,0),(1,1,0,0),(0,1,0,0),(0,0,0,0));width:2;height:3),
   (matrix :((0,1,1,0),(1,1,0,0),(0,0,0,0),(0,0,0,0));width:3;height:2)
  ),
  (
   (matrix :((0,1,0,0),(1,1,0,0),(1,0,0,0),(0,0,0,0));width:2;height:3),
   (matrix :((1,1,0,0),(0,1,1,0),(0,0,0,0),(0,0,0,0));width:3;height:2),
   (matrix :((0,1,0,0),(1,1,0,0),(1,0,0,0),(0,0,0,0));width:2;height:3),
   (matrix :((1,1,0,0),(0,1,1,0),(0,0,0,0),(0,0,0,0));width:3;height:2)
  ),
  (
   (matrix :((0,1,0,0),(1,1,1,0),(0,0,0,0),(0,0,0,0));width:3;height:2),
   (matrix :((0,1,0,0),(1,1,0,0),(0,1,0,0),(0,0,0,0));width:2;height:3),
   (matrix :((1,1,1,0),(0,1,0,0),(0,0,0,0),(0,0,0,0));width:3;height:2),
   (matrix :((1,0,0,0),(1,1,0,0),(1,0,0,0),(0,0,0,0));width:2;height:3)
  ),
  (
   (matrix :((1,1,0,0),(1,1,0,0),(0,0,0,0),(0,0,0,0)); width:2;height:3),
   (matrix :((1,1,0,0),(1,1,0,0),(0,0,0,0),(0,0,0,0)); width:2;height:3),
   (matrix :((1,1,0,0),(1,1,0,0),(0,0,0,0),(0,0,0,0)); width:2;height:3),
   (matrix :((1,1,0,0),(1,1,0,0),(0,0,0,0),(0,0,0,0)); width:2;height:3)
  ) );

var
 Form1: TForm1;
 sofortabbruch : boolean;
 ms: TMemoryStream;
 rt : TMemoryStream;

implementation

{$R *.DFM}
procedure PlayWaveStream(Stream: TMemoryStream);
begin
  if Stream = nil then
    sndPlaySound(nil, SND_ASYNC) //stop sound
  else
    sndPlaySound(Stream.Memory, (SND_ASYNC or SND_MEMORY));
end;

procedure TForm1.Initialize;
begin
  foffx:=PaintBox1.left;
  foffy:=PaintBox1.top;
  fposrow:=-4;
  fposcol:=5;
  fscore:=0;
  flines:=0;
  flevel:=0;
  ftime:=400;
  fterminate:=false;
  fpieceplaced:=false;
  L4.visible:=false;
end;

procedure TForm1.WndProc(var msg:TMessage);
begin
  case Msg.Msg of
     WM_CLOSE: begin
                 if not sofortabbruch then sofortabbruch:=true;
                 close;
               end
   Else
     inherited;
   if msg.msg=WM_STARTGAME then GameLoop;
  end;
end;

procedure TForm1.MovePiece(aOrientation:TOrientation);
var
 acurpiece:PPiece;
begin
  acurpiece:= @PIECES[fcurpiece.key1,fcurpiece.key2];
  ClearPiece(acurpiece,fposrow,fposcol);
  case aOrientation of
      toleft:
        if CanPutPiece(acurpiece,fposrow,fposcol-1) then fposcol:=fposcol-1;
      toright:
        if CanPutPiece(acurpiece,fposrow,fposcol+1) then fposcol:=fposcol+1;
      todown:
        if CanPutPiece(acurpiece,fposrow+1,fposcol) then fposrow:=fposrow+1
          else fpieceplaced:=true;
      torotate:
        if CanPutPiece(@PIECES[fcurpiece.key1,(fcurpiece.key2+1) mod 4],
            fposrow,fposcol) then
            begin
              fcurpiece.key2:=(fcurpiece.key2+1) mod 4;
              acurpiece:= @PIECES[fcurpiece.key1,fcurpiece.key2];
            end;
  end;
  putpiece(acurpiece,fposrow,fposcol);
end;

function TForm1.GetCellRect(arow,acol:integer):TRect;
begin
  SetRect(result,-1,-1,-1,-1);
  if (arow<0) or (arow>ROW_CNT) or (acol<0) or (acol>COL_CNT) then exit;
  result.left:=(PaintBox1.width div COL_CNT)*acol+1;
  result.top:=(PaintBox1.Height div ROW_CNT)*arow+1;
  result.right:=result.left+CELL_SIZE;
  result.bottom:=result.top+CELL_SIZE;
end;

function TForm1.GetPreviewCellRect(arow,acol:integer):TRect;
begin
  SetRect(result,-1,-1,-1,-1);
  if (arow<0) or (arow>PIECE_SIZE) or (acol<0) or (acol>PIECE_SIZE) then exit;
  result.left:=(PaintBox2.width div PIECE_SIZE)*acol+1;
  result.top:=(PaintBox2.Height div PIECE_SIZE)*arow+1;
  result.right:=result.left+PREVIEW_CELL_SIZE;
  result.bottom:=result.top+PREVIEW_CELL_SIZE;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
 tmprect:TRect;
 i,j,hdc:integer;
begin
  PaintBox1.Canvas.Pen.Color:= clBlack;
  PaintBox1.Canvas.Brush.Color := ColorDialog1.Color;
  PaintBox1.Canvas.Rectangle(0,0,PaintBox1.width,PaintBox1.Height);

  hdc:=PaintBox1.canvas.handle;
  for i:=0 to 19 do
    for j:=0 to 9 do
    begin
      if fboard[i,j]>0 then
      begin
        if S7.Checked = true then
        begin
          PaintBox1.canvas.Brush.Color:= COLORS[fboard[i,j]];
        end;
        tmprect:=GetCellRect(i,j);
        PaintBox1.Canvas.Rectangle(tmprect);
        DrawEdge(hdc,tmprect,EDGE_BUMP,BF_RECT or BF_SOFT);
      end
    end;
end;

procedure TForm1.InvalidatePreviewGrid;
var
 tmprect:TRect;
begin
  tmprect.left:=PaintBox2.left;
  tmprect.top:=PaintBox2.top;
  tmprect.right:=tmprect.left+PaintBox2.width;
  tmprect.bottom:=tmprect.top+PaintBox2.height;
  InvalidateRect(handle,@tmprect,false);
end;

procedure TForm1.InvalidatePiece(arow,acol:integer);
var
 i,j:integer;
 tmprect:TRect;
begin
  SetRectEmpty(tmprect);
  for i:=-1 to 3 do
    for j:=-1 to 4 do
      UnionRect(tmprect,tmprect,getcellrect(arow+i,acol+j));
  offsetrect(tmprect,foffx,foffy);
  invalidaterect(handle,@tmprect,false);
end;

function TForm1.ClearLines:integer;
var
 i,j,k,l:integer;
 tmprect:TRect;
begin
  result:=0;
  l:=ROW_CNT-1;
  for i:=ROW_CNT-1 downto 0 do
  begin
    k:=0;
    for j:=COL_CNT-1 downto 0 do
      if(fboard[i,j]>0) then k:=k+1;
    if k=COL_CNT then
      result:=result+1
    else begin
      for k:=0 to COL_CNT-1 do
        fboard[l,k]:=fboard[i,k];
      l:=l-1;
    end;
  end;

  tmprect.left:=foffx;
  tmprect.top:=foffy;
  tmprect.right:=tmprect.left+PaintBox1.Width;
  tmprect.bottom:=tmprect.top+PaintBox1.height;

  if result>0 then
    InvalidateRect(handle,@tmprect,false);
end;

function TForm1.CanPutPiece(apiece:PPiece;arow,acol:integer):boolean;
var
 i,j,k:integer;
 broke:boolean;
begin
  result:=false;
  k:=0;
  if (arow<-4) or (acol<0) then exit;
  for i:=0 to 3 do begin
    broke:=false;
    for j:=0 to 3 do begin
      if ((arow+i<ROW_CNT) and
         (acol+j<COL_CNT) and
         (fboard[arow+i,acol+j]=0)) or (apiece.matrix[i,j]=0) then k:=k+1
      else begin
        broke:=false;
        break;
      end;
    end;
    if broke then break;
  end;
  if k=16 then result:=true;
end;

procedure TForm1.PutPiece(apiece:PPiece;arow,acol:integer;ainv:boolean=true);
var
 i,j:integer;
begin
  for i:=0 to 3 do
    for j:=0 to 3 do
      if (arow+i<ROW_CNT) and (acol+j<COL_CNT) and (apiece.matrix[i,j]=1) then
        fboard[arow+i,acol+j]:=apiece.matrix[i,j]*fcurpiece.key3;
  if ainv then InvalidatePiece(arow,acol);
end;

procedure TForm1.ClearPiece(apiece:PPiece;arow,acol:integer;ainv:boolean=true);
var
 i,j:integer;
begin
  for i:=0 to 3 do
    for j:=0 to 3 do
      if (arow+i<ROW_CNT) and (acol+j<COL_CNT) and (apiece.matrix[i,j]=1) then
  fboard[arow+i,acol+j]:=0;
end;

procedure TForm1.FormCreate(Sender: TObject);
const
  FileName = 'Sound\tetrismusic.wav';
begin
  Initialize;
  doublebuffered:=true;
  sofortabbruch := true;
  postMessage(handle,WM_STARTGAME,0,0);
  MCISendString(PChar('play ' + FileName), nil, 0, 0);
end;

procedure TForm1.GameLoop;
var
 atime:longword;
 alinecnt:integer;
begin
  sofortabbruch:=false;
  Randomize;
  fcurpiece.key1:=Random(7);
  fcurpiece.key2:=Random(4);
  fcurpiece.key3:=Random(CLR_CNT)+1;
  fnextpiece.key1:=Random(7);
  fnextpiece.key2:=Random(4);
  fnextpiece.key3:=Random(CLR_CNT)+1;
  atime:=GettickCount;

  while not fterminate do begin
    Application.ProcessMessages;

    if sofortabbruch then exit;

    if (Gettickcount-atime)>ftime then begin
      MovePiece(todown);
      atime:=GetTickCount;
    end;
    if fpieceplaced then begin
      if fposrow<0 then begin
        L4.visible:=true;
        fterminate:=true;

        // game over sound
        if S3.Checked = true then
        begin
        with TSoundPlayerThread.Create(true) do
          begin
            SetFileName(ExtractFilePath(Application.ExeName) + 'Sound\gameover.wav');
            FreeOnTerminate := true;
            Resume;
          end;
        end;
        ShowMessage('Game Over, you lose the Game!');
        break;
      end;
      alinecnt:=ClearLines;

      // drop peace bottom sound
      if S3.Checked = true then
        begin
          with TSoundPlayerThread.Create(true) do
          begin
            SetFileName(ExtractFilePath(Application.ExeName) + 'Sound\drop.wav');
            FreeOnTerminate := true;
            Resume;
          end;
        end;

      if alinecnt>0 then
      begin
        fscore:=fscore+alinecnt*LINE_SCORE;
        fscore:=fscore+(alinecnt-1)*BONUS_SCORE;
        flines:=flines+alinecnt;
        if fscore>=(flevel+1)*500 then
        begin
          flevel:=flevel+1;
          ftime:=max(ftime-25,25);
        end;
        L9.caption:=inttostr(fscore);
        L8.caption:=inttostr(flines);
        L7.Caption:=inttostr(flevel);

        // clear lines sound
        with TSoundPlayerThread.Create(true) do
        begin
          SetFileName(ExtractFilePath(Application.ExeName) + 'Sound\clear.wav');
          FreeOnTerminate := true;
          Resume;
        end;
      end;
      fposrow:=-4;
      fposcol:=5;
      fpieceplaced:=false;
      fcurpiece:=fnextpiece;
      fnextpiece.key1:=Random(7);
      fnextpiece.key2:=Random(4);
      fnextpiece.key3:=Random(CLR_CNT)+1;
      InvalidatePreviewGrid;
    end;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fterminate:=true;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if fterminate then exit;

  if key=VK_DOWN then
  begin
    MovePiece(todown);
  end;

    if key=VK_LEFT then
    begin
      MovePiece(toLeft);
    end;

    if key=VK_RIGHT then
    begin
      MovePiece(toright);
    end;

    if key=VK_SPACE then
    begin
      MovePiece(torotate);

      if S3.Checked = true then
      begin
        with TSoundPlayerThread.Create(true) do
        begin
          SetFileName(ExtractFilePath(Application.ExeName) + 'Sound\rotate.wav');
          FreeOnTerminate := true;
          Resume;
        end;
      end;
    end;

end;

procedure TForm1.PaintBox2Paint(Sender: TObject);
var
 tmprect:TRect;
 i,j,hdc:integer;
 apiece:PPiece;
begin
  PaintBox2.Canvas.Pen.Color:=clred;
  PaintBox2.Canvas.Brush.Color := clSilver;
  PaintBox2.Canvas.Rectangle(0,0,PaintBox2.width,PaintBox2.Height);
  hdc:=PaintBox2.canvas.handle;
  apiece:=@PIECES[fnextpiece.key1,fnextpiece.key2];
  PaintBox2.canvas.Brush.Color:=COLORS[fnextpiece.key3];
  for i:=0 to PIECE_SIZE-1 do
    for j:=0 to PIECE_SIZE-1 do
    begin
      if apiece.matrix[i,j]>0 then
      begin
        tmprect:=GetPreviewCellRect(i,j);
        PaintBox2.Canvas.Rectangle(tmprect);
        DrawEdge(hdc,tmprect,EDGE_BUMP,BF_RECT or BF_SOFT);
      end
    end;
end;

procedure TForm1.M2C(Sender: TObject);
var
  i,j:integer;
begin
  if not sofortabbruch then sofortabbruch:=true;
  foffx:=PaintBox1.left;
  foffy:=PaintBox1.top;
  fposrow:=-4;
  fposcol:=5;
  fscore:=0;
  flines:=0;
  flevel:=0;
  ftime:= 400;
  fterminate:=false;
  fpieceplaced:=false;
  L4.visible:=false;
  L9.caption:=inttostr(fscore);
  L8.caption:=inttostr(flines);
  L7.Caption:=inttostr(flevel);
  for i:=-4 to 19 do
    for j:=0 to 9 do fboard[i,j]:=0;

  PaintBox1.canvas.brush.color:=clBlack;
  PaintBox1paint(sender);
  postMessage(handle,WM_STARTGAME,0,0);
end;

procedure TForm1.M1C(Sender: TObject);
begin
  if not sofortabbruch then sofortabbruch:=true;
  close;
end;

procedure TForm1.M3Click(Sender: TObject);
const
  FileName = 'Sound\tetrismusic.wav';
begin
  if M3.Checked = true then
  begin
    MCISendString(PChar('Play ' + FileName), nil, 0, 0);
  end else begin
    MCISendString(PChar('Stop ' + FileName), nil, 0, 0);
  end;
end;

procedure TForm1.B1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then PaintBox1.OnPaint(sender);

end;

end.
