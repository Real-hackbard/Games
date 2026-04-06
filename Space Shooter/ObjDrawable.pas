// class to learn how to draw any bitmap on a canvas
unit ObjDrawable;

interface

uses Windows, SysUtils, Classes, Graphics, Math,Jpeg;

type


  TObjDrawable = class(TObject)
  private
    fAppDir       : String;
    fCanvas      : TCanvas;
    fMoveRect    : TRect;      // Display area
    fBitmap      : Tbitmap;    // Bitmap
    fStretch     : Boolean;
    fCoord       : TPoint;     // Coordinates at the top
    fWidth       : integer;    // SizeX
    fHeight      : integer;    // SizeY
    fEnabled     : boolean;    // True if Canvas is assigned, otherwise False
    // to know whether or not to delete the object
    fToDeleted    : boolean;

    procedure SetEnabled(val : boolean);
    function  GetEnabled : boolean;

    procedure SetBitmap(val : TBitmap);

    procedure SetAppDir(dir : String);
    function  GetAppDir:String;

    procedure SetStretch(s : boolean);
    function  GetStretch:boolean;

    procedure SetCoord ( p :Tpoint);
    function  GetCoord:TPoint;
    
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect);
    destructor Destroy; override;

    property Canvas      : TCanvas read fCanvas      write fCanvas;
    property MoveRect    : TRect   read fMoveRect    write fMoveRect;

    property AppDir      : String  read GetAppdir    write SetAppDir;

    property Coord       : TPoint  read GetCoord     write SetCoord;
    property Width       : integer read fWidth       write fWidth ;
    property Height      : integer read fHeight      write fHeight ;

    property Enabled     : boolean read GetEnabled   write SetEnabled default true;

    property Image       : TBitmap read fBitmap      write SetBitmap;

    property Stretch     : Boolean read GetStretch   write SetStretch default false;
    property ToDeleted   : boolean read fToDeleted   write fToDeleted default false;

    function Collide(Obj:TObjDrawable):Boolean;

    procedure Draw;      // Procedure to call to draw on the canvas

  end;

implementation

constructor TObjDrawable.Create(ACanvas : TCanvas; AMoveRect : TRect);
begin
  {
   Call to the ancestor constructor of TObject
  }
  inherited Create;
  {
   Assigning the canvas and display area rectangle
  }
  fCanvas      := ACanvas;
  fMoveRect    := AMoveRect;

  {
   Pre-calculation of the position
  }
  // by default in the top left corner
  fCoord       := point(0,0);
  // par defaut 0 0
  fWidth       := 0;
  fHeight      := 0;
  {
   Creating the bitmap
  }
  fBitmap      := TBitmap.Create;
  {
   Checking the assignment of fCanvas to avoid ACanvas = nil
  }
  fToDeleted := False;
  fEnabled     := Assigned(fCanvas);
end;

destructor TObjDrawable.Destroy;
begin
  {
   Bitmap release
  }
  fBitmap.Free;

  {
   Calling the TObject ancestor destroyer
  }
  inherited destroy;
end;


function TObjDrawable.Collide(Obj:TObjDrawable):Boolean;
var
  Dummy:TRect;
begin
  if(Obj = nil ) then begin
    result:=false;
    exit;
  end;
  Result:=IntersectRect(Dummy,Rect(fCoord.X,fCoord.Y,fCoord.X+fWidth,fCoord.Y+fHeight),rect(obj.Coord.X,obj.Coord.Y,obj.Coord.X+obj.Width,obj.Coord.Y+obj.Height));
end;

procedure TObjDrawable.SetEnabled(val : boolean);
begin
  {
   The assignment of fCanvas is checked when the developer
   attempts to modify the Enabled property.
  }
  fEnabled := assigned(fCanvas) and val;
end;

function TObjDrawable.GetEnabled : boolean;
begin
  {
   We return a result based on the assignment of fCanvas
  }
  fEnabled := assigned(fCanvas);
  result   := fEnabled;
end;

procedure TObjDrawable.SetAppDir(dir : String);
begin
  AppDir := dir;
end;

function TObjDrawable.GetAppDir:String;
begin
  result := fAppDir;
end;

procedure TObjDrawable.SetBitmap(val : TBitmap);
begin
  {
   Assignment to bitmap
  }
  fBitmap.Assign(val);
end;

procedure TObjDrawable.SetStretch(s : boolean);
begin
  fStretch := s;
end;

function TObjDrawable.GetStretch:boolean;
begin
  result := fStretch;
end;

procedure TObjDrawable.SetCoord (p :Tpoint);
begin
  fCoord := p;
end;

function TObjDrawable.GetCoord:TPoint;
begin
  result := fCoord;
end;

procedure TObjDrawable.Draw;
begin
  if not fEnabled then exit;
  // If the object is not in the movement area
  // We don't draw it (I don't know if this is really useful)

  if (Coord.X < MoveRect.Left) or (Coord.X > MoveRect.Right) then exit;
  if (Coord.Y < MoveRect.Top)  or (Coord.Y > MoveRect.Bottom) then exit;
  
  with fCanvas do
  begin
    if(fStretch) then
      StretchDraw(Rect(fCoord.X,fCoord.Y,fCoord.X+fWidth,fCoord.Y+fHeight),fBitmap)
    else
      Draw(fCoord.X,fCoord.Y,fBitmap);
  end;
end;

end.
