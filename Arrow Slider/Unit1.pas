unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls;

const
  TILE_SIZE_X = 64;
  TILE_SIZE_Y = 64;
  GRIDTOP_X = 32;
  GRIDTOP_Y = 32;

  CODE_UP = 0;
  CODE_DOWN = 1;
  CODE_LEFT = 2;
  CODE_RIGHT = 3;

type
  TAnimateVars = record
    xGrid : integer;
    yGrid : integer;
    iDirection : integer;
    iFrame : integer;
  end;

type
  TArrowTile = record
    iDirection : integer;
    iNumber : integer;
  end;

type ptrCanvas = ^TCanvas;

type
  TForm1 = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    miGame: TMenuItem;
    miHelp: TMenuItem;
    miStartGame: TMenuItem;
    N1: TMenuItem;
    miExit: TMenuItem;
    miAbout: TMenuItem;
    imgUp: TImage;
    imgDown: TImage;
    imgLeft: TImage;
    imgRight: TImage;
    miDifficulty: TMenuItem;
    miEasy: TMenuItem;
    miNormal: TMenuItem;
    miHard: TMenuItem;
    Timer1: TTimer;
    imgUpSmall: TImage;
    imgDownSmall: TImage;
    imgLeftSmall: TImage;
    imgRightSmall: TImage;
    miSettings: TMenuItem;
    miShowGoal: TMenuItem;
    lblDisplay1: TLabel;
    lblDisplay2: TLabel;
    lblDisplay3: TLabel;
    lblDisplay4: TLabel;
    lblDisplay5: TLabel;
    lblDisplay6: TLabel;
    lblDisplay7: TLabel;
    lblDisplay8: TLabel;
    lblDisplay9: TLabel;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miHowToPlayClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miStartGameClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miWidth4Click(Sender: TObject);
    procedure miEasyClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miSettingsClick(Sender: TObject);
    procedure miShowGoalClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    GameTiles : array[0..7, 0..7] of TArrowTile;
    AnimateVars : TAnimateVars;
    DisplayLabels : array[0..8] of TLabel;
    MovesCounter : integer;
    dtGameStart : TDateTime;
    strTimePlayed: String;
    bPlaying : boolean;
    procedure UpdateDisplayLabels(bUpdateTimePlayed : boolean);
    function GameTimePlayed() : string;
    procedure GameScramble();
    function GameScrambleUsefullMove(xPos, yPos, iDirection : integer) : boolean;
    procedure GameInitialise();
    function GameCompleted() : boolean;
    procedure GameUpdateTiles(xPos, yPos, iDirection : integer);
    procedure GameUpdateLayOut();
    procedure GameDrawTiles(xPos, yPos, iDirection, iFrame : integer);
    procedure GameDrawTileNr(xPos, yPos : integer; ArrowTile : TArrowTile);
    function InputPlayerClick(xGrid, yGrid : integer) : boolean;
    procedure SetNewSettings(GridX, GridY, iDifficulty : integer; bHorizontal : boolean; sTileOrder : string);

    function YesNo(strInput : String) : Boolean; overload;
    function YesNo(bInput : Boolean) : String; overload;
    procedure SettingsRead();
    procedure SettingsWrite();
  public
    { Public declarations }
  end;

  { global function }
  procedure DrawOutlinedText(pCanvas : TCanvas; xPos, yPos, iColor : Integer; strText : String);

var
  Form1: TForm1;
  { global so goal and settigs can also use it }
  TileImages : array[0..7] of TImage;
  TileColors : array[0..3, 0..1] of TColor; {tile index, color nr 0=dark 1=bright }
  GoalTiles : array[0..7, 0..7] of TArrowTile;
  { settings, global so goal and settigs can also use it }
  ini_GridX : integer; {0..7}
  ini_GridY : integer; {0..7}
  ini_Difficulty : integer;
  ini_Horizontal : boolean;
  ini_ShowTime : boolean;
  ini_ShowMoves : boolean;
  ini_ShowGoal: boolean;
  ini_TileOrder : string[8];

implementation

uses
  IniFiles, HelpAbout, settings, goal;

{$R *.DFM}

{ -------------------------------------
  Initialise program
  ------------------------------------- }
procedure TForm1.FormCreate(Sender: TObject);
var
  x, y : integer;
begin
  { DoubleBuffered := true, to prevent animation flickering }
  Self.DoubleBuffered := true;

  { put in array for more easy access }
  TileImages[0] := imgUp;
  TileImages[1] := imgDown;
  TileImages[2] := imgLeft;
  TileImages[3] := imgRight;

  TileImages[4] := imgUpSmall;
  TileImages[5] := imgDownSmall;
  TileImages[6] := imgLeftSmall;
  TileImages[7] := imgRightSmall;

  { dark colors, AABBGGRR => alpha, blue, green, red }
  TileColors[0, 0] := $000000C0; {dark red}
  TileColors[1, 0] := $00C00000; {dark blue}
  TileColors[2, 0] := $0000C000; {dark green}
  TileColors[3, 0] := $0000C0C0; {dark yellow}

  { light colors }
  TileColors[0, 1] := $008080FF; {light red}
  TileColors[1, 1] := $00FF8080; {light blue}
  TileColors[2, 1] := $0080FF80; {light green}
  TileColors[3, 1] := $0080FFFF; {light yellow}

  { put labels in array for easy manipulate }
  DisplayLabels[0] := lblDisplay1;
  DisplayLabels[1] := lblDisplay2;
  DisplayLabels[2] := lblDisplay3;
  DisplayLabels[3] := lblDisplay4;
  DisplayLabels[4] := lblDisplay5;
  DisplayLabels[5] := lblDisplay6;
  DisplayLabels[6] := lblDisplay7;
  DisplayLabels[7] := lblDisplay8;
  DisplayLabels[8] := lblDisplay9;

  { set top and left position of all labels }
  for y := 0 to 2 do
    for x := 0 to 2 do
    begin
      DisplayLabels[y*3+x].Top := 3+y;
      DisplayLabels[y*3+x].Left := 3+x;
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  x : integer;
begin
  { read settings and initialise game }
  SettingsRead();
  { a trick to force the game to reset }
  x := ini_GridX;
  ini_GridX := -1;
  { apply settings }
  SetNewSettings(x, ini_GridY, ini_Difficulty, ini_Horizontal, ini_TileOrder);
  { show goal at start up }
  if (ini_ShowGoal = true) then miShowGoalClick(Sender);
end;

procedure TForm1.UpdateDisplayLabels(bUpdateTimePlayed : boolean);
var
  i : Integer;
  strDisplay : String;
begin

  { only update timeplayed when called from tmrTimePlayed
    else also called on mouseclick, causing timer to appear not synchronised }
  if (bUpdateTimePlayed = true) then
    strTimePlayed := GameTimePlayed();

  { build display text }
  strDisplay := '';
  if (ini_ShowTime = true) then
    strDisplay := 'Time: ' + strTimePlayed + #13;

  if (ini_ShowMoves = true) then
    strDisplay := strDisplay + 'Moves: ' + IntToStr(MovesCounter);

  { set text of all labels }
  for i := 0 to 8 do
    DisplayLabels[i].Caption := strDisplay;

end;

function TForm1.GameTimePlayed() : string;
{ update strTimePlayed, for example '01:23' }
var
  iMinutes, iSeconds : Integer;
begin
  { initialise result }
  Result := '';

  { calculate how many seconds played }
  iSeconds := Trunc((Now() - dtGameStart) * 24 * 60 * 60);

  { only display minutes and seconds, no-one will play longer than an hour (i think) }
  iMinutes := (iSeconds - (iSeconds mod 60)) div 60;
  iSeconds := iSeconds - (iMinutes * 60);

  { construct string text }
  Result := IntToStr(iMinutes) + ':';
  if (iMinutes < 10) then Result := '0' + Result;

  if (iSeconds < 10) then Result := Result + '0';
  Result := Result + IntToStr(iSeconds);

end;

{ -------------------------------------
  Game functions
  ------------------------------------- }
procedure TForm1.GameScramble();
{ scramble the puzzle tiles array GameTiles }
var
  i, iDirection, iInvDirection, iMax, iMoves, iEasyMove, x, y : integer;
begin

  { fill with goal tile layout }
  for y := 0 to ini_GridY-1 do
    for x := 0 to ini_GridX-1 do
      GameTiles[x, y] := GoalTiles[x, y];

  { nr of reverse moves according to difficulty }
  if (ini_GridX > ini_GridY) then iMax := ini_GridX else iMax := ini_GridY;
  iMoves := iMax * iMax * iMax;

  { scramble by reverse moving column and rows }
  Randomize();
  iEasyMove := 0;
  for i := 1 to iMoves do
  begin
    { select a random tile }
    x := Random(ini_GridX);
    y := Random(ini_GridY);
    iDirection := GameTiles[x, y].iDirection;

    { move in opposite direction of tile }
    case iDirection of
    CODE_UP: iInvDirection := CODE_DOWN; { do opposite, so move column down }
    CODE_DOWN: iInvDirection := CODE_UP; { do opposite, so move column up }
    CODE_LEFT: iInvDirection := CODE_RIGHT; { do opposite, so move row to right }
    CODE_RIGHT: iInvDirection := CODE_LEFT; { do opposite, so move row to left }
    end; {case}

    { when difficulty is easy }
    if (ini_Difficulty = 1) then
      if (GameScrambleUsefullMove(x, y, iDirection) = True) then
        iEasyMove := iEasyMove + 1;

    { update game tiles }
    GameUpdateTiles(x, y, iInvDirection);

    { if difficulty is easy and enough moved done , then stop scramble }
    if (ini_Difficulty = 1) and (iEasyMove >= iMax) then
      Break;

  end;

end;

function TForm1.GameScrambleUsefullMove(xPos, yPos, iDirection : integer) : boolean;
{ check if a move is a usefull scramble move.
  For example move up in a column with only move-up tiles is not usefull }
var
  x, y : integer;
begin
  { assume not a usefull move }
  Result := false;

  { up down, move a column }
  if (iDirection = CODE_UP)
  or (iDirection = CODE_DOWN) then
  begin
    for y := 0 to ini_GridY-1 do
      if (GameTiles[xPos, y].iDirection = CODE_LEFT)
      or (GameTiles[xPos, y].iDirection = CODE_RIGHT) then
        Result := True;
  end else
  { left right, move a row }
  if (iDirection = CODE_LEFT)
  or (iDirection = CODE_RIGHT) then
  begin
    for x := 0 to ini_GridX-1 do
      if (GameTiles[x, yPos].iDirection = CODE_UP)
      or (GameTiles[x, yPos].iDirection = CODE_DOWN) then
        Result := True;
  end;


end;

function TForm1.GameCompleted() : boolean;
var
  x, y : integer;
  bCorrect : boolean;
begin
  { initialise }
  Result := true;

  { draw goal tiles }
  for x := 0 to ini_GridX-1 do
    for y := 0 to ini_GridY-1 do
    begin
      if (ini_Difficulty = 3) then
        { difficulty=hard, tiles direction AND number must be equal }
        bCorrect := (    (GameTiles[x, y].iDirection = GoalTiles[x, y].iDirection)
                     and (GameTiles[x, y].iNumber = GoalTiles[x, y].iNumber)
                    )
      else
        { difficulty=easy/normal, only tile directions must be equal }
        bCorrect := (GameTiles[x, y].iDirection = GoalTiles[x, y].iDirection);
        
      { one or more tiles not correct -> not solved }
      if (bCorrect = false) then
      begin
        { not completed }
        Result := false;
        Exit;
      end;
    end;
end;

procedure TForm1.GameUpdateTiles(xPos, yPos, iDirection : integer);
var
  x, y : integer;
  tmpTile : TArrowTile;
begin

  case iDirection of
  CODE_UP:
    begin
      { save top tile, move column up, put savetile at bottom }
      tmpTile := GameTiles[xPos, 0];
      for y := 0 to ini_GridY-2 do
        GameTiles[xPos, y] := GameTiles[xPos, y+1];
      GameTiles[xPos, ini_GridY-1] := tmpTile;
    end;
  CODE_DOWN:
    begin
      { save bottom tile, move column down, put savetile at top }
      tmpTile := GameTiles[xPos, ini_GridY-1];
      for y := ini_GridY-2 downto 0 do
        GameTiles[xPos, y+1] := GameTiles[xPos, y];
      GameTiles[xPos, 0] := tmpTile;
    end;
  CODE_LEFT:
    begin
      { save left tile, move row to left, put savetile at right }
      tmpTile := GameTiles[0, yPos];
      for x := 0 to ini_GridX-2 do
        GameTiles[x, yPos] := GameTiles[x+1, yPos];
      GameTiles[ini_GridX-1, yPos] := tmpTile;
    end;
  CODE_RIGHT:
    begin
      { save right tile, move row to right, put savetile at left }
      tmpTile := GameTiles[ini_GridX-1, yPos];
      for x := ini_GridX-2 downto 0 do
        GameTiles[x+1, yPos] := GameTiles[x, yPos];
      GameTiles[0, yPos] := tmpTile;
    end;
  end; {case}
end;

procedure TForm1.GameUpdateLayOut();
var
  i, x, y, iMax : integer;
  tmpTileOrder : array[0..7] of byte;
begin
  { resize window }
  x := (ini_GridX * TILE_SIZE_X) + 64; {+64 for border}
  y := (ini_GridY * TILE_SIZE_Y) + 64; {+64 for border}
  Self.ClientWidth := x;
  Self.ClientHeight := y;

  { force resize of image, else it is not shown completely }
  Image1.Picture.Bitmap.Width := x;
  Image1.Picture.Bitmap.Height := y;

  { prepare array with tile order }
  for i := 1 to 8 do
    case ini_TileOrder[i] of
    'U': tmpTileOrder[i-1] := 0;
    'D': tmpTileOrder[i-1] := 1;
    'L': tmpTileOrder[i-1] := 2;
    else {'R'}
      tmpTileOrder[i-1] := 3;
    end; {case}

  { update tile layout }
  i := 0;
  for y := 0 to ini_GridY-1 do
    for x := 0 to ini_GridX-1 do
    begin
      i := i + 1;
      if (ini_Horizontal = true) then
        { group tile colors horizontally }
        GoalTiles[x, y].iDirection := tmpTileOrder[y]
      else
        { group tile colors vertically }
        GoalTiles[x, y].iDirection := tmpTileOrder[x];
      GoalTiles[x, y].iNumber := i;
    end;

  { update goal picture }
  Form4.DrawGoalTiles();

  { update borders colors }
  Image1.Canvas.Brush.Style := bsSolid;
  Image1.Canvas.Pen.Style := psSolid;

  { draw top or left border }
  Image1.Canvas.Brush.Color := TileColors[tmpTileOrder[0], 0];
  Image1.Canvas.Pen.Color := TileColors[tmpTileOrder[0], 0];
  if (ini_Horizontal = true) then
    Image1.Canvas.Rectangle(0, 0, Image1.Width, GRIDTOP_Y) //top
  else
    Image1.Canvas.Rectangle(0, 0, GRIDTOP_X, Image1.Height); //left

  if (ini_Horizontal = true) then
    iMax := ini_GridY-1
  else
    iMax := ini_GridX-1;
  { draw borders }
  for i := 0 to iMax do
  begin
    Image1.Canvas.Brush.Color := TileColors[tmpTileOrder[i], 0];
    Image1.Canvas.Pen.Color := TileColors[tmpTileOrder[i], 0];

    if (ini_Horizontal = true) then
    begin
      { horizontal bars }
      y := GRIDTOP_Y + (i * TILE_SIZE_Y);
      Image1.Canvas.Rectangle(0, y, Image1.Width, y+TILE_SIZE_Y)
    end else begin
      { vertical bars }
      x := GRIDTOP_X + (i * TILE_SIZE_X);
      Image1.Canvas.Rectangle(x, 0, x+TILE_SIZE_X, Image1.Height);
    end;
  end; {for}

  { draw bottom or right border }
  if (ini_Horizontal = true) then
  begin
    { horizontal bars }
    Canvas.Brush.Color := TileColors[tmpTileOrder[ini_GridY-1], 0];
    y := GRIDTOP_Y + (ini_GridY * TILE_SIZE_Y);
    Image1.Canvas.Rectangle(0, y, Image1.Width, y+TILE_SIZE_Y)
  end else begin
    { vertical bars }
    Canvas.Brush.Color := TileColors[tmpTileOrder[ini_GridX-1], 0];
    x := GRIDTOP_X + (ini_GridX * TILE_SIZE_X);
    Image1.Canvas.Rectangle(x, 0, x+TILE_SIZE_X, Image1.Height);
  end;
end;

procedure TForm1.GameInitialise();
var
  x : integer;
begin
  { scramble game }
  GameScramble();

  { draw tiles }
  for x := 0 to ini_GridX-1 do
    GameDrawTiles(x, 0, CODE_UP, 0);

  { initialise moves/time display if needed }
  dtGameStart := Now();
  MovesCounter := 0;
  bPlaying := true;
  Timer2.Enabled := true;

  UpdateDisplayLabels(true);
end;

procedure TForm1.GameDrawTiles(xPos, yPos, iDirection, iFrame : integer);
{ draw a row or column of tiles.
  If iFrame is not zero (0) then draw a animation frame
  where a tile is moving over the border of the playgrid
  iFrame is 3 downto 0, where 0 is the current state of GameTiles[]

  For example,

  3 +---+  2 +---+  1 +---+  0 +---+
    | B |    |_B_|    |---|    | A |
    |---|    | A |    | A |    |   |
    +---+    +---+    +---+    +---+
  }
var
  i, iUntil, x, y, iTile : integer;
  rDest, rSrc : TRect;
begin

  if (iDirection = CODE_UP) then
  begin
    { ---- animate up ---- }
    { draw part of bottom tile at top }
    x := GRIDTOP_X + (xPos * TILE_SIZE_X);
    y := GRIDTOP_Y + (iFrame * 16); {16 = TILE_SIZE_Y / 4}

    { draw bottom tile immediately, only when not animating }
    iUntil := ini_GridY-1;
    if (iFrame <> 0) then iUntil := ini_GridY-2;

    { draw column, except not bottom tile when animating }
    for i := 0 to iUntil do
    begin
      iTile := GameTiles[xPos, i].iDirection;
      Image1.Canvas.Draw(x, y, TileImages[iTile].Picture.Bitmap);
      GameDrawTileNr(x, y, GameTiles[xPos, i]);
      y := y + TILE_SIZE_Y;
    end;

    { draw bottom tile, which is on top/bottom border }
    if (iFrame <> 0) then
    begin
      { get bottom tile }
      iTile := GameTiles[xPos, ini_GridY-1].iDirection;

      { draw part of bottom tile at grid top }
      rDest := Rect(x, GRIDTOP_Y, x+TILE_SIZE_X, GRIDTOP_Y+(iFrame*16)); {16 = TILE_SIZE_Y / 4};
      rSrc := Rect(0, (4-iFrame)*16, TILE_SIZE_X, TILE_SIZE_Y);
      Image1.Canvas.CopyRect(rDest, TileImages[iTile].Canvas, rSrc);

      { draw part of bottom tile at grid bottom }
      rDest := Rect(x, y, x+TILE_SIZE_X, y+((4-iFrame)*16)); {16 = TILE_SIZE_Y / 4};
      rSrc := Rect(0, 0, TILE_SIZE_X, (4-iFrame)*16);
      Image1.Canvas.CopyRect(rDest, TileImages[iTile].Canvas, rSrc);
      GameDrawTileNr(x, y, GameTiles[xPos, ini_GridY-1]);
    end;

  end
  else if (iDirection = CODE_DOWN) then
  begin
    { ---- animate down ---- }
    { start with bottom tile of column }
    x := GRIDTOP_X + (xPos * TILE_SIZE_X);
    y := GRIDTOP_Y + ((ini_GridY-1)*TILE_SIZE_Y) - (iFrame*16); {16 = TILE_SIZE_Y / 4}

    { draw top tile immediately, only when not animating }
    iUntil := 0;
    if (iFrame <> 0) then iUntil := 1;

    { draw column, except not top tile when animating }
    for i := ini_GridY-1 downto iUntil do
    begin
      iTile := GameTiles[xPos, i].iDirection;
      Image1.Canvas.Draw(x, y, TileImages[iTile].Picture.Bitmap);
      GameDrawTileNr(x, y, GameTiles[xPos, i]);
      y := y - TILE_SIZE_Y;
    end;

    y := GRIDTOP_Y + (ini_GridY*TILE_SIZE_Y) - (iFrame*16); {16 = TILE_SIZE_Y / 4}
    { draw top tile, which is on top/bottom border }
    if (iFrame <> 0) then
    begin
      { get top tile }
      iTile := GameTiles[xPos, 0].iDirection;

      { draw part of top tile at grid top }
      rDest := Rect(x, GRIDTOP_Y, x+TILE_SIZE_X, GRIDTOP_Y+((4-iFrame)*16)); {16 = TILE_SIZE_Y / 4};
      rSrc := Rect(0, (iFrame*16), TILE_SIZE_X, TILE_SIZE_Y);
      Image1.Canvas.CopyRect(rDest, TileImages[iTile].Canvas, rSrc);

      { draw part of top tile at grid bottom }
      rDest := Rect(x, y, x+TILE_SIZE_X, y+(iFrame*16)); {16 = TILE_SIZE_Y / 4};
      rSrc := Rect(0, 0, TILE_SIZE_X, iFrame*16);
      Image1.Canvas.CopyRect(rDest, TileImages[iTile].Canvas, rSrc);
      GameDrawTileNr(x, y, GameTiles[xPos, 0]);
    end;

  end
  else if (iDirection = CODE_LEFT) then
  begin
    { ---- animate left ---- }
    { draw part of right-most tile on the left }
    x := GRIDTOP_X + (iFrame * 16); {16 = TILE_SIZE_X / 4}
    y := GRIDTOP_Y + (yPos * TILE_SIZE_Y);

    { draw right tile immediately, only when not animating }
    iUntil := ini_GridX-1;
    if (iFrame <> 0) then iUntil := ini_GridX-2;

    { draw row, except not right-most tile when animating }
    for i := 0 to iUntil do
    begin
      iTile := GameTiles[i, yPos].iDirection;
      Image1.Canvas.Draw(x, y, TileImages[iTile].Picture.Bitmap);
      GameDrawTileNr(x, y, GameTiles[i, yPos]);
      x := x + TILE_SIZE_X;
    end;

    { draw right-most tile, which is on left/right border }
    if (iFrame <> 0) then
    begin
      { get right-most tile }
      iTile := GameTiles[ini_GridX-1, yPos].iDirection;

      { draw part of right-most tile at grid left }
      rDest := Rect(GRIDTOP_X, y, GRIDTOP_X+(iFrame*16), y+TILE_SIZE_Y); {16 = TILE_SIZE_Y / 4};
      rSrc := Rect((4-iFrame)*16, 0, TILE_SIZE_X, TILE_SIZE_Y);
      Image1.Canvas.CopyRect(rDest, TileImages[iTile].Canvas, rSrc);

      { draw part of right-most tile at grid right }
      rDest := Rect(x, y, x+((4-iFrame)*16), y+TILE_SIZE_Y); {16 = TILE_SIZE_Y / 4};
      rSrc := Rect(0, 0, (4-iFrame)*16, TILE_SIZE_Y);
      Image1.Canvas.CopyRect(rDest, TileImages[iTile].Canvas, rSrc);
      GameDrawTileNr(x, y, GameTiles[ini_GridX-1, yPos]);
    end;

  end
  else if (iDirection = CODE_RIGHT) then
  begin
    { ---- animate right ---- }
    { start with right-most tile of row }
    x := GRIDTOP_X + ((ini_GridX-1)*TILE_SIZE_X) - (iFrame*16); {16 = TILE_SIZE_Y / 4}
    y := GRIDTOP_Y + (yPos * TILE_SIZE_Y);

    { draw left-most tile immediately, only when not animating }
    iUntil := 0;
    if (iFrame <> 0) then iUntil := 1;

    { draw row, except not left-most tile when animating }
    for i := ini_GridX-1 downto iUntil do
    begin
      iTile := GameTiles[i, yPos].iDirection;
      Image1.Canvas.Draw(x, y, TileImages[iTile].Picture.Bitmap);
      GameDrawTileNr(x, y, GameTiles[i, yPos]);
      x := x - TILE_SIZE_X;
    end;

    x := GRIDTOP_X + (ini_GridX*TILE_SIZE_X) - (iFrame*16); {16 = TILE_SIZE_Y / 4}
    { draw left-most tile, which is on left/right border }
    if (iFrame <> 0) then
    begin
      { get left-most tile }
      iTile := GameTiles[0, yPos].iDirection;

      { draw part of left-most tile at grid left }
      rDest := Rect(GRIDTOP_Y, y, GRIDTOP_X+((4-iFrame)*16), y+TILE_SIZE_Y); {16 = TILE_SIZE_Y / 4};
      rSrc := Rect((iFrame*16), 0, TILE_SIZE_X, TILE_SIZE_Y);
      Image1.Canvas.CopyRect(rDest, TileImages[iTile].Canvas, rSrc);

      { draw part of left-most tile at grid right }
      rDest := Rect(x, y, x+(iFrame*16), y+TILE_SIZE_Y); {16 = TILE_SIZE_Y / 4};
      rSrc := Rect(0, 0, iFrame*16, TILE_SIZE_Y);
      Image1.Canvas.CopyRect(rDest, TileImages[iTile].Canvas, rSrc);
      GameDrawTileNr(x, y, GameTiles[0, yPos]);
    end;
  end;
end;

procedure TForm1.GameDrawTileNr(xPos, yPos : integer; ArrowTile : TArrowTile);
begin
  { only with difficulty is 3=hard }
  if (ini_Difficulty <> 3) then Exit;
  
  { draw tile number }
  DrawOutlinedText(Image1.Canvas,
                   xPos+2,
                   yPos+1,
                   ArrowTile.iDirection, {direction is same as color}
                   IntToStr(ArrowTile.iNumber));

end;

{ -------------------------------------
  Game input functions
  ------------------------------------- }
function TForm1.InputPlayerClick(xGrid, yGrid : integer) : boolean;
var
  iDirection : integer;
begin
  { initialise }
  Result := false;

  { check if valid grid position }
  if (xGrid < 0)
  or (xGrid > ini_GridX-1)
  or (yGrid < 0)
  or (yGrid > ini_GridY-1) then Exit;

  { get tile }
  iDirection := GameTiles[xGrid, yGrid].iDirection;

  { update game tiles }
  GameUpdateTiles(xGrid, yGrid, iDirection);

  { initialise animating, save animation parameters }
  AnimateVars.xGrid := xGrid;
  AnimateVars.yGrid := yGrid;
  AnimateVars.iDirection := iDirection;
  AnimateVars.iFrame := 3;

  { update screen first animation frame }
  GameDrawTiles(AnimateVars.xGrid,
                AnimateVars.yGrid,
                AnimateVars.iDirection,
                AnimateVars.iFrame);
                
  { rest of animation done in timer-events }
  Timer1.Enabled := true;

  { correct move }
  MovesCounter := MovesCounter + 1;
  Result := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  strMessage : string;
begin
  { update next animation frame }
  AnimateVars.iFrame := AnimateVars.iFrame - 1;

  { update next animation frame }
  GameDrawTiles(AnimateVars.xGrid,
                AnimateVars.yGrid,
                AnimateVars.iDirection,
                AnimateVars.iFrame);

  { check if animation done }
  if (AnimateVars.iFrame <= 0) then
  begin
    Timer1.Enabled := false;
    { check if completed }
    if (GameCompleted() = true) then
    begin
      Timer2.Enabled := false;
      UpdateDisplayLabels(True);
      strMessage := 'Puzzle completed!' + #13 +
                    '' + #13 +
                    'Time: ' + strTimePlayed + #13 +
                    'Moves: ' + IntToStr(MovesCounter);
      ShowMessage(strMessage);
    end;
  end;  
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  { no input when not playing }
  if (Timer2.Enabled = false) then Exit;

  { no new input when still animating, wait for animation to finish }
  if (Timer1.Enabled = true) then Exit;

  { determine grid position }
  X := X - GRIDTOP_X;
  Y := Y - GRIDTOP_Y;

  { cursor is outside playing area (left or top), exit this function }
  if (X < 0) or (Y < 0) then Exit;

  { translate X and Y to grid coordinates }
  X := X div TILE_SIZE_X;
  Y := Y div TILE_SIZE_Y;

  { input player move }
  if (InputPlayerClick(X, Y) = true) then
    if (ini_ShowMoves = true) then
      { update moves display }
      UpdateDisplayLabels(false);
end;

{ -------------------------------------
  Settings read and write
  ------------------------------------- }
function TForm1.YesNo(strInput : String) : Boolean;
begin
  { 'yes'=true 'no'=false }
  Result := (LowerCase(Copy(strInput, 1, 1)) <> 'n');
end;

function TForm1.YesNo(bInput : Boolean) : String;
begin
  { true='Yes' false='No' }
  if (bInput = true) then
    Result := 'yes'
  else
    Result := 'no';
end;

procedure TForm1.SettingsRead();
var
  strFilename, strTemp : String;
  IniFile : TIniFile;
  i, FormX, FormY : Integer;
begin
  { set default settings }
  ini_GridX := 4;
  ini_GridY := 4;
  ini_Difficulty := 2;
  ini_Horizontal := true;
  ini_ShowTime := true;
  ini_ShowMoves := true;
  ini_ShowGoal := true;
  ini_TileOrder := 'UDLRUDLR';

  { determine ini filename }
  strFilename := ChangeFileExt(Application.ExeName, '.ini');
  if not FileExists(strFilename) then Exit;

  { open ini file }
  IniFile := TIniFile.Create(strFilename);

  { grid size }
  ini_GridX := IniFile.ReadInteger('grid', 'xsize', 4);
  ini_GridY := IniFile.ReadInteger('grid', 'ysize', 4);

  { settings difficulty }
  strTemp := UpperCase(IniFile.ReadString('settings', 'difficulty', 'NORMAL'));
  if (strTemp = 'EASY') then
    ini_Difficulty := 1
  else if (strTemp = 'HARD') then
    ini_Difficulty := 3
  else
    ini_Difficulty := 2;

  { settings horizontal }
  ini_Horizontal := YesNo(IniFile.ReadString('settings', 'horizontal', 'y'));
  ini_ShowTime := YesNo(IniFile.ReadString('settings', 'showtime', 'y'));
  ini_ShowMoves := YesNo(IniFile.ReadString('settings', 'showmoves', 'y'));
  ini_ShowGoal := YesNo(IniFile.ReadString('settings', 'showgoal', 'y'));

  { settings tileorder }
  ini_TileOrder := UpperCase(IniFile.ReadString('settings', 'tileorder', 'UDLRUDLR'));

  { form }
  FormX := IniFile.ReadInteger('form', 'xpos', 100);
  FormY := IniFile.ReadInteger('form', 'ypos', 100);

  { incase XPos or YPos outside screen }
  if (FormX < 0)
  or (FormX > Screen.Width) then FormX := 0;
  if (FormY < 0)
  or (FormY > Screen.Height) then FormY := 0;

  { set form position }
  Self.Left := FormX;
  Self.Top := FormY;

  { close ini file }
  IniFile.Free;
end;

procedure TForm1.SettingsWrite();
var
  IniFile : TIniFile;
  strTemp : string;
begin

  { open ini file }
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  { grid size }
  IniFile.WriteInteger('grid', 'xsize', ini_GridX);
  IniFile.WriteInteger('grid', 'ysize', ini_GridY);

  { settings difficulty }
  case ini_Difficulty of
  1: strTemp := 'easy';
  2: strTemp := 'normal';
  3: strTemp := 'hard';
  end; {case}
  IniFile.WriteString('settings', 'difficulty', strTemp);

  IniFile.WriteString('settings', 'horizontal', YesNo(ini_Horizontal));
  IniFile.WriteString('settings', 'showtime', YesNo(ini_ShowTime));
  IniFile.WriteString('settings', 'showmoves', YesNo(ini_ShowMoves));
  IniFile.WriteString('settings', 'showgoal', YesNo(miShowGoal.Checked));

  IniFile.WriteString('settings', 'tileorder', ini_TileOrder);

  { form }
  IniFile.WriteInteger('form', 'xpos', Self.Left);
  IniFile.WriteInteger('form', 'ypos', Self.Top);

  { close ini file }
  IniFile.Free;
end;

{ -------------------------------------
  Menu items
  ------------------------------------- }
procedure TForm1.miStartGameClick(Sender: TObject);
begin
  GameInitialise();
end;

procedure TForm1.miExitClick(Sender: TObject);
begin
  Self.Close();
end;

procedure TForm1.miHowToPlayClick(Sender: TObject);
begin
  ShowMessage('not implemented yet..');
end;

procedure TForm1.miAboutClick(Sender: TObject);
begin
  with TForm3.Create(Self) do
    try
      ShowModal()
    finally
      Free();
    end; {try}
end;

procedure TForm1.miWidth4Click(Sender: TObject);
var
  iTag : integer;
begin
  iTag := (Sender as TMenuItem).Tag;
  if (iTag < 10) then
  begin
    { width }
    ini_GridX := iTag;
  end else begin
    { height }
    ini_GridY := (iTag - 10);
  end;
end;

procedure TForm1.miEasyClick(Sender: TObject);
var
  iTag : integer;
begin
  iTag := (Sender as TMenuItem).Tag;

  SetNewSettings(ini_GridX, ini_GridY, iTag, ini_Horizontal, ini_TileOrder);
end;

procedure TForm1.SetNewSettings(GridX, GridY, iDifficulty : integer; bHorizontal : boolean; sTileOrder : string);
var
  bResetGame, bGoalPlace : boolean;
  i : integer;
begin
  { check values }
  if (GridX < 2) or (GridX > 8) then GridX := 4;
  if (GridY < 2) or (GridY > 8) then GridY := 4;
  if (iDifficulty < 1) or (iDifficulty > 3) then iDifficulty := 2; {2=normal}

  { check values }
  sTileOrder := UpperCase(sTileOrder);
  if (Length(sTileOrder) <> 8) then sTileOrder := 'UDLRUDLR';
  for i := 1 to 8 do
    if  (sTileOrder[i] <> 'U')
    and (sTileOrder[i] <> 'D')
    and (sTileOrder[i] <> 'L')
    and (sTileOrder[i] <> 'R') then
      sTileOrder[i] := 'U';

  { reset game only if needed }
  bResetGame :=    (ini_GridX <> GridX)
                or (ini_GridY <> GridY)
                or (ini_Difficulty <> iDifficulty)
                or (ini_Horizontal <> bHorizontal)
                or (ini_TileOrder <> sTileOrder);

  { update goal place only when different grid size }
  bGoalPlace :=    (ini_GridX <> GridX)
                or (ini_GridY <> GridY);

  { new settings }
  ini_GridX := GridX;
  ini_GridY := GridY;
  ini_Difficulty := iDifficulty;
  ini_Horizontal := bHorizontal;
  ini_TileOrder := sTileOrder;

  { check menu item }
  miEasy.Checked := (iDifficulty = 1);
  miNormal.Checked := (iDifficulty = 2);
  miHard.Checked := (iDifficulty = 3);

  { reset game if needed }
  if (bResetGame = true) then
  begin
    GameUpdateLayOut();
    if (bGoalPlace = true) then Form4.UpdatePlacement();
    { reset game }
    GameInitialise();
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SettingsWrite();
end;

procedure TForm1.miSettingsClick(Sender: TObject);
begin
  { settings screen }
  with TForm2.Create(Self) do
    try
      DisplaySettings(ini_GridX,
                      ini_GridY,
                      ini_Difficulty,
                      ini_Horizontal,
                      ini_TileOrder);
      if (ShowModal() = mrOk) then
        { apply settings }
        Self.SetNewSettings(fGridX,
                            fGridY,
                            fDifficulty,
                            fHorizontal,
                            fTileOrder);
    finally
      Free();
    end;
end;

procedure TForm1.miShowGoalClick(Sender: TObject);
begin
  { hide goal screen }
  miShowGoal.Checked := not miShowGoal.Checked;

  if (miShowGoal.Checked = true) then
  begin
    { place goal to the right of main screen }
    Form4.UpdatePlacement();
    { show goal screen }
    Form4.Show();
  end
  else
    { hide goal screen }
    Form4.Hide();

end;

{ -------------------------------------
  Global function so goal can use it too
  ------------------------------------- }
procedure DrawOutlinedText(pCanvas : TCanvas; xPos, yPos, iColor : Integer; strText : String);
{ draw white text with black outlining
  iColor = 0..3 use TileColors, so red blue green yellow
  iColor = -1 is white }
var
  x, y : Integer;
begin

  with pCanvas do
  begin
    Brush.Style := bsClear; {text with transparant(=clear) background}

    { text on edges, dark text color }
//    if (iColor = -1) then
      Font.Color := clWindowText;
//    else
//      Font.Color := TileColors[iColor, 0];

    { display the same text 9 times, to create "outlined-text effect" }
    for y := 0 to 2 do
      for x := 0 to 2 do
      begin
        { first only draw outlined black part, x=1&y=1 is middle part }
        if not ( (y = 1) and (x = 1) ) then
        begin
          { text on edges = black }
          TextOut(xPos+x, yPos+y, strText);
        end;
      end;

    { draw middle part, light text color }
    if (iColor = -1) then
      Font.Color := clWindow
    else
      Font.Color := TileColors[iColor, 1];

    TextOut(xPos+1, yPos+1, strText);
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  { update time played if needed }
  if (ini_ShowTime = true) then
    UpdateDisplayLabels(true);
end;

end.

