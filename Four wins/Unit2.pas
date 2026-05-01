unit Unit2;

interface

uses
  windows, SysUtils, Graphics, Types, ExtCtrls, Dialogs;

const
  CIRCLEDIAMETRE = 50;
  CIRCLEFRAMECOLOR = clBlack;
  CIRCLECOLOR = clWhite;
  PLAYERONECOLOR = clRed;
  PLAYERTWOCOLOR = clYellow;
  COLUMNS = 10;
  ROWS = 6;

type
  TFourInARow = class(TObject)
  private
    OffScreenBmp: TBitmap;
    FPaintbox: TPaintbox;
    Field: array[0..COLUMNS - 1, 0..ROWS - 1] of Cardinal;
    procedure DrawCircle(Canvas: TCanvas; Center: TPoint; Diametre: Integer);
    procedure DrawSeparator(Canvas: TCanvas; x: Cardinal);
    function GetColumn(x: Cardinal): Cardinal;
  public
    constructor Create(PaintBox: TPaintBox);
    destructor Destroy; override;
    function SetStone(Player: Cardinal; x: Cardinal): Boolean;
    procedure DrawField;
    function Gewonnen(Spieler: Cardinal): Boolean;
  end;

implementation

{-------------------------------------------------------------------------------
  Description:
  draws the circles of the playing field
-------------------------------------------------------------------------------}

procedure TFourInARow.DrawCircle(Canvas: TCanvas; Center: TPoint; Diametre:
  Integer);
begin
  Canvas.Ellipse(Center.X - CIRCLEDIAMETRE div 2, Center.Y - CIRCLEDIAMETRE div
    2, Center.X + CIRCLEDIAMETRE div 2, Center.Y + CIRCLEDIAMETRE div 2);
end;

{-------------------------------------------------------------------------------
  Description:
  Draw the vertical dividing lines
-------------------------------------------------------------------------------}

procedure TFourInARow.DrawSeparator(Canvas: TCanvas; x: Cardinal);
begin
  Canvas.Pen.Color := clGray;
  Canvas.MoveTo(x, 0);
  Canvas.LineTo(x, OffScreenBmp.Height - CIRCLEDIAMETRE);
end;

{-------------------------------------------------------------------------------
  Description:
  Constructor. Creating the offscreen bitmap
-------------------------------------------------------------------------------}

constructor TFourInARow.Create(Paintbox: TPaintBox);
var
  c, r: Integer;
  rec: TRect;
begin
  inherited Create;
  FPaintbox := PaintBox;
  OffScreenBmp := TBitmap.Create;
  OffScreenBmp.Width := FPaintbox.Width;
  OffScreenBmp.Height := FPaintBox.Height;
  rec.Left := 0;
  rec.Top := 0;
  rec.Right := OffScreenBmp.Width;
  rec.Bottom := OffScreenBmp.Height;
  OffScreenBmp.Canvas.Brush.Color := clBtnFace;
  OffScreenBmp.Canvas.FillRect(rec);
  for c := 0 to COLUMNS - 1 do
    for r := 0 to ROWS - 1 do
      Field[c, r] := 0;
  DrawField;
end;

{-------------------------------------------------------------------------------
  Description:
  Destructor. Destroying the offscreen bitmap.
-------------------------------------------------------------------------------}

destructor TFourInARow.Destroy;
begin
  FreeAndNil(OffScreenBmp);
  inherited;
end;

{-------------------------------------------------------------------------------
  Description:
  Determines the column using mouse coordinates
-------------------------------------------------------------------------------}

function TFourInARow.GetColumn(x: Cardinal): Cardinal;
begin
  result := x div (OffScreenBmp.Width div COLUMNS);
end;

{-------------------------------------------------------------------------------
  Description:
  Adds a stone to the game field array.
-------------------------------------------------------------------------------}

function TFourInARow.SetStone(Player: Cardinal; x: Cardinal): Boolean;
var
  c, r: Integer;
begin
  result := False;
  c := GetColumn(x);
  for r := ROWS - 1 downto 0 do
  begin
    if Field[c, r] = 0 then
    begin
      Field[c, r] := Player;
      result := True;
      break;
    end;
  end;
  DrawField;
end;

{-------------------------------------------------------------------------------
  Description:
  Draw the playing field with the stones.
-------------------------------------------------------------------------------}

procedure TFourInARow.DrawField;
var
  pt: TPoint;
  x: Cardinal;
  c, r: Integer;
begin
  x := 0;
  for c := 0 to COLUMNS - 1 do
  begin
    OffScreenBmp.Canvas.Pen.Color := CIRCLEFRAMECOLOR;
    for r := 0 to ROWS - 1 do
    begin
      pt.X := OffScreenBmp.Width div COLUMNS * c + (OffScreenBmp.Width div
        COLUMNS div 2);
      pt.Y := OffScreenBmp.Height div ROWS * r + (CIRCLEDIAMETRE div 2);
      case Field[c, r] of
        0: OffScreenBmp.Canvas.Brush.Color := CIRCLECOLOR;
        1: OffScreenBmp.Canvas.Brush.Color := PLAYERONECOLOR;
        2: OffScreenBmp.Canvas.Brush.Color := PLAYERTWOCOLOR;
      end;
      DrawCircle(OffScreenBmp.Canvas, pt, CIRCLEDIAMETRE);
    end;
    if c < (COLUMNS - 1) then
      x := OffScreenBmp.Width div COLUMNS * (c + 1);
    DrawSeparator(OffScreenBmp.Canvas, x);
  end;
  BitBlt(FPaintbox.Canvas.Handle, 0, 0, FPaintBox.Width, FPaintbox.Height,
    OffScreenBmp.Canvas.Handle, 0, 0, SRCCOPY);
end;

{-------------------------------------------------------------------------------
  Description: Profit check
  Author: w3seek
-------------------------------------------------------------------------------}

function TFourInARow.Gewonnen(Spieler: Cardinal): Boolean;
const
  N_GEWINNT = 4;

  function GewinntReihe(Spalte, Zeile, Delta, Max: Integer): Boolean;
  var
    Anfang, Pos, Ende: PCardinal;
    c, i: Integer;
  begin
    Result := false;
    // We obtain the address of the point from which we view the playing field;
    // this is the left or upper edge of the playing field.
    Pos := @Field[Spalte, Zeile];
    // We obtain the addresses of the points above and below which we are
    // not allowed to go.
    Anfang := @Field[0, 0];
    Ende := @Field[COLUMNS - 1][ROWS - 1];
    c := 0;
    i := 0;

    // Repeat this loop until the current position is set outside the
    // playing field.
    while (Cardinal(Pos) <= Cardinal(Ende)) and (Cardinal(Pos) >=
      Cardinal(Anfang)) do
    begin
      // Is the player we're looking for currently in that position?
      if Pos^ = Spieler then
      begin
        // We are counting how many points have been scored
        // consecutively without interruption.
        Inc(c);
        if c = N_GEWINNT then
        begin
          // Okay, we have exactly N_WINS points in a row, the player has won!
          Result := true;
          Exit;
        end;
      end
      else
      begin
        // Okay, the point is not set or does not belong to the player we
        // are looking for; we are resetting the counter.
        c := 0;
      end;
      // We jump to the next point being tested. Depending on the direction
      // and distance we go, Delta indicates the value.
      Inc(Pos, Delta);
      // For rows and columns, we need a maximum value to avoid moving
      // to the next row/column!
      if Max > 0 then
      begin
        Inc(i);
        // Break the loop when we have exceeded the maximum.
        if i >= Max then
        begin
          Exit;
        end;
      end;
    end;
  end;

var
  i: Integer;
begin
  Result := false;

  // We walk from the upper left to the upper right play area.
  for i := 0 to COLUMNS - 1 do
  begin
       // Are there 4 consecutive points from the player in this column?
       // the distance to the nearest point (which lies directly below
       // the starting point) This is the number of points in a row.
       // We only check N_ROWS points in the column!
    if GewinntReihe(i, 0, 1, ROWS) or
       // N_COLUMNS + 1 is the distance to the next point below and to
       // the right of this point, i.e., 1 larger.
       // Since the playing field has columns, we do not set a maximum
       // number of points to be checked, so Max=0
    GewinntReihe(i, 0, ROWS + 1, 0) or
       // N_COLUMNS - 1 is the distance to the next point below and to
       // the left of this point, i.e., exactly 1 less.
       // Since the playing field has columns, we do not set a maximum
       // number of points to be checked, so Max=0
    GewinntReihe(i, 0, ROWS - 1, 0) then
    begin
      Result := true;
      Exit;
    end;
  end;

  // We run from the upper left play area to the lower left play area.
  for i := 0 to ROWS - 1 do
  begin
       // Are there 4 consecutive points from the player in this line?
       // The distance to the next point in the row is 1; we check a
       // maximum of N_columns points in the row.
    if GewinntReihe(0, i, ROWS, COLUMNS) or
       // -(N_COLUMNS - 1) is the distance to the nearest point that lies
       // diagonally to the top right; the distance is
       // So, negative and 1 less than the number of columns on the playing
       // field; we do not set a maximum number of points to check, so Max=0
    GewinntReihe(0, i, -(ROWS - 1), 0) or
       // N_COLUMNS + 1 is the distance to the nearest point in the bottom
       // right (diagonal), so the distance is positive.
       // and 1 greater than the number of columns on the playing field,
       // we do not set a maximum number of points to be checked, so Max=0
    GewinntReihe(0, i, ROWS + 1, 0) then
    begin
      Result := true;
      Exit;
    end;
  end;
end;

end.

