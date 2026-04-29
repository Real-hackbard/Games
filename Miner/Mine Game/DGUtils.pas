unit DGUtils;

interface

uses Windows, Graphics, Controls, Grids;

  { allows loading an image into a TDrawGrid from a TImageList }
  procedure DrawImageListInDrawGrid(const ImageList: TImageList; Index: Integer;
    const DrawGrid: TDrawGrid; Rect: TRect);
  { visually clears any selection in the TDrawGrid }
  procedure NoSelectionInDrawGrid(const DrawGrid: TDrawGrid);

implementation

{ I no longer use this method as it's far too slow; I'm leaving
  it for informational purposes only. }
procedure DrawImageListInDrawGrid(const ImageList: TImageList; Index: Integer;
  const DrawGrid: TDrawGrid; Rect: TRect);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    ImageList.GetBitmap(Index, Bmp);
    DrawGrid.Canvas.Draw(Rect.Left, Rect.Top, Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure NoSelectionInDrawGrid(const DrawGrid: TDrawGrid);
var { based on a tip from Nono40 }
  Select: TGridRect;
begin
  with Select do
  begin
    Top    := 0;
    Bottom := 0;
    Left   := DrawGrid.ColCount + 1;
    Right  := Left;
  end;
  DrawGrid.Selection := Select;
end;

end.
