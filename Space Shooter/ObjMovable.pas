// class to learn how to draw any bitmap that can move on a canvas
// pure foxi
unit ObjMovable;

interface

uses Windows, SysUtils, Classes, Graphics, Math, ObjDrawable;

type

  TObjMovable = class(TObjDrawable)
  private

    fSpeed       : single;     // Speed ??of movement -8..-4 4..8
    fDirection   : single;     // Direction in degrees -80..-20  20..80

    _SpCosMul    : integer;    // rounded off fSpeed * Cos(fDirection)
    _SpSinMul    : integer;    // rounded off fSpeed * Sin(fDirection)

    procedure SetSingle(index : integer; val : single);

  protected
    procedure ComputeSPD;virtual;     // Speed ??direction calculation
    procedure Move;virtual;           // Calculating the displacement
    procedure CheckOut;virtual;abstract;       // Checking the movement limits

  public
    property Speed       : single  index 0 read fSpeed       write SetSingle;
    property Direction   : single  index 1 read fDirection   write SetSingle;
    procedure Progress;  // Procedure to call to arrange the trip
  end;

implementation

procedure TObjMovable.SetSingle(index : integer; val : single);
begin
  {
   fDirection is converted to radians
  Finally, ComputeSPD must be called to recalculate the parameters
  speed/direction
  }
  case index of
    0 : fSpeed     := val;
    1 : fDirection := DegToRad(val);
  end;
  ComputeSPD;
end;

procedure TObjMovable.ComputeSPD;
var ST,CT : extended;
begin
  {
   Nothing too complicated.
   ComputeSPD is strategically placed within methods, notably:

   -object creation
   -changing the Velocity/Direction values
   -reversing Velocity/Direction.

   Therefore, it is called as infrequently as possible, which improves performance
   because Round, Sin, Cos, and multiplication require many CPU cycles.
   For Sin and Cos, we prefer using SinCos, which is much faster.
  }
  SinCos(fDirection,ST,CT);
  _SpCosMul := round(fSpeed * CT);
  _SpSinMul := round(fSpeed * ST);
end;

procedure TObjMovable.Move;
var
x,y : integer;
begin
  {
   Calculating the ball's position.
   The displacement formula is reduced to its simplest form.
   Thanks to ComputeSPD, the calculation is reduced to two additions per pass.
  }
  x := Coord.X;
  y := Coord.Y;
  x := x + _SpCosMul;
  y := y + _SpSinMul;
  Coord:=point(x,y);
end;

procedure TObjMovable.Progress;
begin
  if not Enabled then exit;
  Move;
  CheckOut;
end;

end.
