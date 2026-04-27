UNIT MazeLibrary;

INTERFACE

  USES
    Graphics;

  TYPE
    TPathStyle = (psLine, psBlock);
    TPathColor = (pcRainbow, pcSolid);

  FUNCTION DrawMaze(CONST Canvas:  TCanvas;
                    CONST xPixelCount, yPixelCount:  INTEGER;
                    CONST xCellCount,  yCellCount :  INTEGER;
                    CONST xOffset,     yOffset    :  INTEGER;
                    CONST MazeSeed:  Integer;
                    CONST ShowPath:  BOOLEAN;
                    CONST PathStyle:  TPathStyle = psBlock;
                    CONST PathColor:  TPathColor = pcRainbow;
                    CONST SolidColor: TColor = clWhite):  INTEGER;  

IMPLEMENTATION

  USES
    Windows,
    Classes,
    Dialogs,
    SpectraLibrary,
    Math;

  FUNCTION DrawMaze(CONST Canvas:  TCanvas;
                    CONST xPixelCount, yPixelCount:  INTEGER;
                    CONST xCellCount,  yCellCount :  INTEGER;
                    CONST xOffset,     yOffset    :  INTEGER;
                    CONST MazeSeed:  Integer;
                    CONST ShowPath:  BOOLEAN;
                    CONST PathStyle:  TPathStyle;
                    CONST PathColor:  TPathColor;
                    CONST SolidColor:  TColor):  INTEGER;
    const
      EAST  = 1;
      SOUTH = 2;
    var
      Cells     :  array of array of 0..3;   
      Count     :  Integer;
      MazeHeight:  Integer;
      MazeWidth :  Integer;
      NX        :  Integer;
      NY        :  Integer;
      PathLength:  Integer;
      PathPos   :  Integer;
      PosX      :  Integer;
      PosY      :  Integer;
      StackCount:  Integer;
      xCellSize :  Integer;
      yCellSize :  Integer;

    function IsValidCell(const X: Integer; const Y: Integer): Boolean;
    begin
      Result := ((X >= 0) and (X < xCellCount) and
                 (Y >= 0) and (Y < yCellCount))
    end;

    function Connected(const X2: Integer; const Y2: Integer): Boolean;
    begin
      if   IsValidCell(X2, Y2)
      then begin
        Result := (Cells[X2, Y2] <> 0);
        if   (not Result) and IsValidCell(X2, Y2 - 1)
        then Result := ((Cells[X2, Y2 - 1] and SOUTH) > 0);
        if   (not Result) and IsValidCell(X2 - 1, Y2)
        then Result := ((Cells[X2 - 1, Y2] and EAST) > 0)
      end
      else Result := TRUE;
    end;

    procedure Connect(const X2: Integer; const Y2: Integer);
    begin
      if   PosX = X2
      then Cells[PosX, Min(PosY, Y2)] := Cells[PosX, Min(PosY, Y2)] or SOUTH
      else
        if  PosY = Y2
        then Cells[Min(PosX, X2), PosY] := Cells[Min(PosX, X2), PosY] or EAST
        else ShowMessage('Attempting to connect cells that are not ' +
                         'orthogonally adjacent.');
    end;
  begin
    xCellSize  :=  xPixelCount DIV xCellCount;
    yCellSize  :=  yPixelCount DIV yCellCount;
    MazeWidth  := xCellCount * xCellSize + 1;
    MazeHeight := yCellCount * yCellSize + 1;
    SetLength(Cells, xCellCount+1, yCellCount+1);  
    for PosX := 0 to xCellCount-1 do
      for PosY := 0 to yCellCount-1 do
        Cells[PosX, PosY] := 0;
    StackCount := 0;
    PathLength := 0;
    RandSeed := MazeSeed;    
    PosX := 0;
    PosY := 0;
    NX := 0;
    NY := 0;
    PathPos := -1;
    repeat
      Count := 0;
      if   not Connected(PosX + 1, PosY)
      then begin
        Inc(Count);
        NX := PosX + 1;
        NY := PosY
      end;
      if   not Connected(PosX - 1, PosY)
      then begin
        Inc(Count);
        if   Random(Count) = 0
        then begin
          NX := PosX - 1;
          NY := PosY
        end;
      end;
      if   not Connected(PosX, PosY + 1)
      then begin
        Inc(Count);
        if   Random(Count) = 0
        then begin
          NX := PosX;
          NY := PosY + 1
        end
      end;
      if   not Connected(PosX, PosY - 1)
      then begin
        Inc(Count);
        if (Random(Count) = 0)
        then begin
          NX := PosX;
          NY := PosY - 1
        end
      end;
      if   Count > 0
      then begin
        Connect(NX, NY);
        Inc(StackCount);
        asm
          Push PosX;
          Push PosY;
        end;
        PosX := NX;
        PosY := NY;
      end
      else begin
        if  StackCount > 0
        then begin
          if  (PosX = xCellCount-1) and (PosY = yCellCount-1)
          then begin
            PathLength := StackCount;
            PathPos    := PathLength;
          end;
          IF   StackCount <= PathPos
          THEN BEGIN
            IF   ShowPath
            THEN BEGIN
              WITH Canvas DO
              BEGIN
                CASE PathStyle OF
                  psLine:
                    BEGIN
                      IF   StackCount = PathLength
                      THEN BEGIN
                        Pen.Width := Max(1, MulDiv( Min(xCellSize,yCellSize), 2, 10));
                        MoveTo(xOffset + PosX * xCellSize + xCellSize DIV 2,
                               yOffset + PosY * yCellSize + yCellSize DIV 2);
                      END
                      ELSE BEGIN
                        IF   PathColor = pcRainbow
                        THEN Pen.Color := WavelengthToColor(WavelengthMinimum +
                             PathPos / PathLength * (WavelengthMaximum - WavelengthMinimum))
                        ELSE Pen.Color := SolidColor;
                        LineTo(xOffset + PosX * xCellSize + xCellSize DIV 2,
                               yOffset + PosY * yCellSize + yCellSize DIV 2);
                      END
                    END;
                  psBlock:
                    BEGIN
                      IF   PathColor = pcRainbow
                      THEN Brush.Color := WavelengthToColor(WavelengthMinimum +
                             PathPos / PathLength * (WavelengthMaximum - WavelengthMinimum))
                      ELSE Brush.Color := SolidColor;
                      FillRect(Rect(xOffset +  PosX     * xCellSize,
                                    yOffset +  PosY     * yCellSize,
                                    xOffset + (PosX + 1)* xCellSize,
                                    yOffset + (PosY + 1)* yCellSize))
                    END
                END
              END
            END;
            Dec(PathPos);
          end;
          asm
            Pop PosY;
            Pop PosX;
          end;
          Dec(StackCount);
        end
      end
    until (StackCount = 0);  
    WITH Canvas DO
    BEGIN
      Pen.Width := 1;
      Pen.Color := clBlack;
      IF  ShowPath
      THEN BEGIN
        CASE PathStyle OF
          psLine:
            BEGIN
              Pen.Width := Max(1, MulDiv( Min(xCellSize,yCellSize), 2, 10));
              IF   PathColor = pcRainbow
              THEN Pen.Color := WavelengthToColor(WavelengthMinimum +
                                PathPos / PathLength * (WavelengthMaximum - WavelengthMinimum))
              ELSE Pen.Color := SolidColor;
              LineTo(xOffset + xCellSize DIV 2,
                     yOffset + yCellSize DIV 2)
            END;
          psBlock:
            BEGIN
              IF   PathColor = pcRainbow
              THEN Brush.Color := WavelengthToColor(WavelengthMinimum)
              ELSE Brush.Color := SolidColor;
              FillRect(Rect(xOffset+0, yOffset+0, xOffset+xCellSize, yOffset+yCellSize))
            END
        END
      END
      ELSE BEGIN
        Brush.Color := clRed;
        Ellipse( xOffset + MulDiv(xCellSize, 2,10),
                 yOffset + MulDiv(yCellSize, 2,10),
                 xOffset + MulDiv(xCellSize, 8,10),
                 yOffset + MulDiv(yCellSize, 8,10) );
        Ellipse( xOffset + MulDiv(xCellSize, 2,10) + (xCellCount - 1) * xCellSize,
                 yOffset + MulDiv(yCellSize, 2,10) + (yCellCount - 1) * yCellSize,
                 xOffset + MulDiv(xCellSize, 8,10) + (xCellCount - 1) * xCellSize,
                 yOffset + MulDiv(yCellSize, 8,10) + (yCellCount - 1) * yCellSize)
      END;
      Pen.Width := 1;
      Pen.Color := clBlack;
      Brush.Color := clBlack;
      FrameRect(Rect(xOffset+0,
                     yOffset+0,
                     xOffset + MazeWidth,
                     yOffset + MazeHeight));
      for PosX := 0 to xCellCount-1 do
      begin
        for PosY := 0 to yCellCount-1 do
        begin
          if  (Cells[PosX, PosY] and EAST) = 0
          then begin
            MoveTo(xOffset + (PosX + 1) * xCellSize, yOffset +  PosY      * yCellSize);
            LineTo(xOffset + (PosX + 1) * xCellSize, yOffset + (PosY + 1) * yCellSize+1)
          end;
          if   (Cells[PosX, PosY] and SOUTH) = 0
          then begin
            MoveTo(xOffset +  PosX      * xCellSize  , yOffset + (PosY + 1) * yCellSize);
            LineTo(xOffset + (PosX + 1) * xCellSize+1, yOffset + (PosY + 1) * yCellSize)
          end
        end
      end
    end;
    RESULT := 1 + PathLength   
  end ;
END.

