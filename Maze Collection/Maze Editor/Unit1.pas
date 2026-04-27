unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, Menus, Math, XPMan;

const
  SPACING           = 50;
  COUNTW            = 15;
  COUNTH            = 15;
  OFFSET            = 10;

type
  TOpenList = record
    Square: TPoint;
    G: Integer;           // Travel costs
    H: Integer;           // estimated distance from to destination
    F: Integer;           // Total cost
    Predecessor: TPoint;  // Predecessor;
  end;
  TOpenListArray = array of TOpenList;

  TWall = packed array[1..COUNTW, 1..COUNTH] of boolean;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    F1: TMenuItem;
    A1: TMenuItem;
    S1: TMenuItem;
    N1: TMenuItem;
    C1: TMenuItem;
    A2: TMenuItem;
    A3: TMenuItem;
    V1: TMenuItem;
    L1: TMenuItem;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure A3Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
  private
    { Private declarations }
    procedure StartSearch;
    procedure NewMaze;
  public
    { Public declarations }
  end;


var
  Form1             : TForm1;
  Bitmap            : Graphics.TBitmap;
  wall              : TWall;
  OpenList          : TOpenListArray; //array of TOpenList;
  ClosedList        : TOpenListArray; //array of TOpenList;

  Start             : TPoint = (x: 1; y: 1);
  Dest              : TPoint = (x: COUNTW; y: COUNTH);

resourcestring
  MYHINT              = 'Start: s'#13#10 +
                        'New: n'#13#10 +
                        'Set start: Shift+left mouse button'#13#10 +
                        'Set target: Ctrl+left mouse button' + #13#10 +
                        'Place wall: left mouse button';

implementation

uses globals;

{$R *.dfm}

// graphical helper routines ///////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  DrawGrid
//  Comment: Draw the grid
procedure DrawGrid(ASpacing, ACountW, ACountH: Cardinal);
var
  i                 : Cardinal;
begin
  with Bitmap do
  begin
    Width := ASpacing * ACountW;
    Height := ASpacing * ACountH;

    //Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 1;

    if Form1.L1.Checked = true then
    begin
      Canvas.Pen.Color := clBlack;
    end else begin
      Canvas.Pen.Color := clWhite;
    end;

    Rectangle(Canvas.Handle, 0, 0, (Spacing * COUNTW), (Spacing * COUNTH));

    for i := 1 to ACountW do
    begin
      Canvas.MoveTo(i * ASpacing, 0);
      Canvas.LineTo(i * ASpacing, Height);
    end;

    for i := 1 to ACountH do
    begin
      Canvas.MoveTo(0, i * ASpacing);
      Canvas.LineTo(Width, i * ASpacing);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//  FieldRect
//  Comment: Determines the surrounding rectangle of a field.
function FieldRect(x, y: integer; onscreen: boolean = false): TRect;
begin
  with result do
  begin
    right := x * spacing;
    bottom := y * spacing;
    left := right - spacing + 1;
    top := bottom - spacing + 1;
  end;
  if onscreen then
    OffsetRect(result, offset, offset);
end;

////////////////////////////////////////////////////////////////////////////////
//  DebuggText
//  Comment: For debugging purposes only. Outputs the F-value of a field
//  in the corresponding field.
procedure DebuggTextOut(AIdxLeft, AIdxTop, AWidth: Integer;
          AColor: TColor; F, G, H: Integer);
var
  rect              : TRect;
begin
  with Bitmap do
  begin
    Canvas.Brush.Color := AColor;
    Canvas.Brush.Style := bsClear;
    rect := FieldRect(AIdxLeft, AIdxTop);
    rect.Left := rect.Left + 1;
    rect.Right := rect.Right - 2;
    DrawText(Canvas.Handle, PChar(IntToStr(F)), length(IntToStr(F)),
              rect, DT_SINGLELINE or DT_LEFT);
    DrawText(Canvas.Handle, PChar(IntToStr(G)), length(IntToStr(G)),
              rect, DT_SINGLELINE or DT_LEFT or DT_BOTTOM);
    DrawText(Canvas.Handle, PChar(IntToStr(H)), length(IntToStr(H)),
              rect, DT_SINGLELINE or DT_RIGHT or DT_BOTTOM);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//  DrawSquare
//  Comment: Draws a filled rectangle in the specified field.
procedure DrawSquare(AIdxLeft, AIdxTop, AWidth: Integer; AColor: TColor);
begin
  with Bitmap do
  begin
    Canvas.Brush.Color := AColor;
    Canvas.FillRect(FieldRect(AIdxLeft, AIdxTop));
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//  DrawRect
//  Comment: Draws a bordered rectangle around the specified field.
procedure DrawRect(AIdxleft, AIdxTop, AWidth: Integer; AColor: TColor);
begin
  with Bitmap do
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := AColor;
    Canvas.Rectangle(FieldRect(AIdxLeft, AIdxTop));
  end;
end;

procedure GenerateMaze(AMinLen, AMaxLen, AGranularity, AWallCount: integer);
const
  poschange         : array[0..3] of TSize =
    ((cx: - 1; cy: 0), (cx: 1; cy: 0), (cx: 0; cy: - 1), (cx: 0; cy: 1));
var
  i, j, row, col, len, dir: integer;
begin
  for i := 1 to COUNTW do
    for j := 1 to COUNTH do
      Wall[i, j] := False;
  for i := 0 to AWallCount - 1 do
  begin
    col := AGranularity * Random((COUNTW + 1) div AGranularity);
    row := AGranularity * Random((COUNTH + 1) div AGranularity);
    len := AGranularity * Random(AMaxLen - AMinLen + 1) + AMinLen + 1;
    dir := Random(4);
    with poschange[dir] do
      for j := 1 to len do
      begin
        if (row < 1) or (row > COUNTH) or (col < 1) or (col > COUNTW) then
          break;
        if Wall[col, row] <> False then
          break;
        Wall[col, row] := True;
        inc(row, cy);
        inc(col, cx);
      end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//  DrawPlayField
//  Comment: Draw the playing field with start, finish and obstacles.
procedure DrawPlayField;
const
  clWall            : array[boolean] of TColor = (clWhite, clGray);
var
  i, j              : integer;
begin
  for i := 1 to COUNTW do
    for j := 1 to COUNTH do
      DrawSquare(i, j, SPACING, clWall[wall[i, j]]);
  with start do
    DrawSquare(x, y, SPACING, clGreen);
  with dest do
    DrawSquare(x, y, SPACING, clRed);
end;

///////////////////////////////////////////////////////////////////////////////
// A* Auxiliary routines ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//  ListAdd
//  Comment: Adds a field to a list
procedure ListAdd(var Dest: TOpenListArray; const AList: TOpenList);
var
  i                 : integer;
begin
  i := Length(Dest);
  SetLength(Dest, i + 1);
  Dest[i] := AList;
end;

////////////////////////////////////////////////////////////////////////////////
//  MoveToClosedList
//  Comment: Moves a field from the open list to the closed list
procedure MoveToClosedList(i: integer; var AList: TOpenList);
var
  j                 : integer;
begin
  AList := OpenList[i];
  j := Length(OpenList) - 1;
  OpenList[i] := OpenList[j];
  SetLength(OpenList, j);
  ListAdd(ClosedList, AList);
end;

////////////////////////////////////////////////////////////////////////////////
//  ClosestField
//  Comment: Determine the field from a list of the lowest costs
function ClosestField: integer;
var
  i, min            : integer;
begin
  result := 0;
  min := openlist[0].f;
  for i := Length(openlist) - 1 downto 1 do
  begin
    with openlist[i] do
    begin
      if f < min then
      begin
        min := f;
        result := i;
      end;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//  Exists
//  Comment: Checks if a field exists in a list
function Exists(const list: TOpenListArray; const p: TPoint; var i: integer): boolean;
var
  j                 : integer;
begin
  result := true;
  for j := Length(list) - 1 downto 0 do
    if Int64(list[j].square) = int64(p) then
    begin
      i := j;
      exit;
    end;
  result := false;
end;

////////////////////////////////////////////////////////////////////////////////
//  FindPath
//  Comment: A* Algorithmus
//  Summary of the A* method
//
//  1) Add the starting square to the open list.
//  2) Repeat the following:
//  a) In the open list, find the square with the lowest F-value. We will refer to this square as the
//  current square.
//  b) Move it to the closed list.
//  c) For each of the 8 squares adjacent to the current square:
//  If it is not traversable or is already in the closed list, ignore it; otherwise,
//  do the following:
//  If it is not in the open list, add it to the open list. Enter the current square as the
//  predecessor square of this square. Additionally, enter the values ??for the F, G, and H costs of this square.
//  If it is already in the open list, check if the path from the current square to it—measured by the
//  G-value—is better than the path from its entered predecessor square (a lower G-value means
//  a better path). If so, change its predecessor square to the current square and recalculate
//  its G and F values. If you have sorted your open list by the F-value, you may need to
//  re-sort this list to reflect this change.
//  d) End the process if:
//  you have moved the target square to the closed list; in this case, you have determined the path
//  no target square could be found and the open list is empty; in this case, there is no path.
//  3) Secure the path. The path is revealed by moving backwards from the target square, square by square,
//  reaching the starting square.

function FindPath(Handle: THandle): boolean;
var
  i, xx, yy         : Integer;
  NewField, ActField: TOpenList;

  // Add field to open list
  procedure AddNewField;
  begin
    with newfield, square do
    begin
      predecessor := actfield.square;
      g := actfield.g;
      if (x = predecessor.x) or (y = predecessor.y) then
        inc(g, 10)
      else
        inc(g, 14);
      h := 10 * (abs(x - dest.x) + abs(y - dest.y));
      f := h + g;
    end;
    ListAdd(OpenList, NewField);
    DrawSquare(NewField.Square.X, NewField.Square.Y, SPACING, clYellow);
    DebuggTextOut(NewField.Square.X, NewField.Square.Y,
                    SPACING, clBlack, NewField.F, NewField.G, NewField.H);
  end;

  // Calculate field values ??(H, G and F) and assign predecessor fields.
  procedure AdjustFieldData(i: integer);
  var
    gg              : integer;
  begin
    with openlist[i], actfield.square do
    begin
      gg := actfield.G;
      if (x = square.x) or (y = square.y) then
        inc(gg, 10)
      else
        inc(gg, 14);
      if gg < g then
      begin
        g := gg;
        f := g + h;
        predecessor := actfield.square;
      end;
    end;
  end;

begin
  SetLength(OpenList, 0);
  SetLength(ClosedList, 0);
  FillChar(NewField, SizeOf(NewField), 0);
  NewField.Square := Start;
  // Insert starting field into open list (1)
  ListAdd(OpenList, NewField);
  repeat // (2)
    if Abort then
      break;
    // Identify the field with the lowest path costs
    i := ClosestField; // (2a)
    // Copy the same field to the closed list
    MoveToClosedList(i, ActField); // (2b)
    with NewField, ActField.square do
      // walk around the field once (2c)
      for xx := Max(X - 1, 1) to Min(X + 1, COUNTW) do
      begin
        for yy := Max(Y - 1, 1) to Min(Y + 1, COUNTH) do
        begin
          //
          if ((xx <> X) or (yy <> Y)) and not wall[xx, yy] then
          begin
            Square := Point(xx, yy);
            // If it does not exist in the closed list, ignore it.
            if not Exists(ClosedList, Square, i) then
              // but in the closed, field evaluation
              if Exists(OpenList, Square, i) then
                AdjustFieldData(i)
              // otherwise add
              else
                AddNewField
          end;
        end;
      end;
  until (int64(ActField.Square) = int64(Dest)) or (length(OpenList) = 0); // (2d)
  result := (length(OpenList) > 0) and not Abort;
end;

procedure ProcessMessages(hWnd: DWORD);
var
  Msg               : TMsg;
begin
  while PeekMessage(Msg, hWnd, 0, 0, PM_REMOVE) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  n, gran, MinLength: Integer;
begin
  Application.HintPause := 0;
  Application.HintHidePause := 50000;
  Randomize;
  Caption := APPNAME;
  Height := COUNTH * SPACING + 75;
  Width := COUNTW * SPACING + 30;
  Hint := MYHINT;
  Bitmap := TBitmap.Create;
  DrawGrid(SPACING, COUNTW, COUNTH);

  n := Min(COUNTW, COUNTH) shr 1;
  gran := 1;
  while n > 1 do
  begin
    n := n shr 1;
    gran := gran shl 1;
  end;
  repeat
    if gran = 2 then
      MinLength := 1
    else
      MinLength := 2;
    GenerateMaze(MinLength, MinLength * 2, gran, (COUNTW * COUNTH) div gran);
    gran := gran shr 1;
  until gran < 2;
  DrawPlayField;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  BitBlt(Canvas.Handle, 0 + OFFSET, 0 + OFFSET,
          Width, Height, Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  shiftctrl         = [ssShift, ssCtrl];
var
  r                 : TRect;
  p                 : TPoint;
begin
  if shiftctrl * shift = shiftctrl then
    exit; // Shift and Ctrl pressed
  r.TopLeft := FieldRect(1, 1, true).TopLeft;
  r.BottomRight := FieldRect(COUNTW, COUNTH, true).BottomRight;
  if not PtInRect(r, Point(x, y)) then
    exit;
  x := (x - offset) div spacing + 1;
  y := (y - offset) div spacing + 1;
  p := Point(x, y);
  if ssShift in Shift then
  begin
    start := p;
    if wall[x, y] then
      wall[x, y] := false;
  end
  else if ssCtrl in shift then
  begin
    dest := p;
    if wall[x, y] then
      wall[x, y] := false;
  end
  else
  begin
    if (int64(p) = Int64(start)) or (Int64(p) = Int64(dest)) then
      exit;
    wall[x, y] := not wall[x, y];
  end;
  DrawPlayField;
  InvalidateRect(Handle, nil, False);
end;

procedure TForm1.StartSearch;
var
  i, j              : integer;
  ActField          : TOpenList;
  Path              : TOpenListArray;
resourcestring
  rsAbort           = 'Cancellation by user';
  rsNoPath          = 'No path found';
begin
  if not FindPath(Handle) then
  begin
    if Abort then
    begin
      MessageBox(Handle, PChar(rsAbort), PChar(APPNAME), MB_ICONWARNING);
      exit;
    end
    else
      MessageBox(Handle, PChar(rsNoPath), PChar(APPNAME), MB_ICONINFORMATION);
  end
  else
  begin
    SetLength(Path, length(ClosedList));
    j := 0;
    actfield := closedlist[Length(closedlist) - 1]; // Target field
    repeat
      with actfield, square do
        if not Exists(closedlist, predecessor, i) then
        begin
          ShowMessage('Error - field ' + IntToStr(x) + ', ' + IntToStr(y) + #13 +
            'Predecessor not found in closedlist.');
          exit;
        end
        else
        begin
          actfield := closedlist[i];
          Path[j] := ActField;
          Inc(j);
        end;
    until Int64(actfield.Predecessor) = Int64(start);
    for j := Length(ClosedList) - 1 downto 0 do
    begin
      DrawSquare(Path[j].Square.X, Path[j].Square.Y, SPACING, clAqua);
      DebuggTextOut(Path[j].Square.X, Path[j].Square.Y,
                      SPACING, clBlack, Path[j].F,
                      Path[j].G, Path[j].H);
      InvalidateRect(Handle, nil, False);
    end;
  end;
  DrawSquare(Dest.X, Dest.Y, SPACING, clRed);
  InvalidateRect(Handle, nil, False);
end;

procedure TForm1.NewMaze;
var
  n, gran, MinLength: Integer;
begin
  DrawGrid(SPACING, COUNTW, COUNTH);

  n := Min(COUNTW, COUNTH) shr 1;
  gran := 1;
  while n > 1 do
  begin
    n := n shr 1;
    gran := gran shl 1;
  end;
  repeat
    if gran = 2 then
      MinLength := 1
    else
      MinLength := 2;
    GenerateMaze(MinLength, MinLength * 2, gran, (COUNTW * COUNTH) div gran);
    gran := gran shr 1;
  until gran < 2;
  DrawPlayField;
  InvalidateRect(Handle, nil, False);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    's', 'S': StartSearch;
    'n', 'N': NewMaze;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Bitmap);
end;

procedure TForm1.S1Click(Sender: TObject);
begin
  StartSearch;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  NewMaze;
end;

procedure TForm1.C1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.A3Click(Sender: TObject);
var
  Version           : string;
  Description       : string;
  s                 : string;
begin
  Beep;
  s := Format(INFO_TEXT, [Version, Description]);
  MyMessageBox(Handle, APPNAME, s, 1);
end;

procedure TForm1.L1Click(Sender: TObject);
begin
  NewMaze;
end;

end.

