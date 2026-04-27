
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, Menus, Math, XPMan, ExtDlgs, ExtCtrls,
  StdCtrls, Spin;

type
  TForm1 = class(TForm)
    ColorDialogFloodFill: TColorDialog;
    PanelControls: TPanel;
    LabelCellsColumns: TLabel;
    LabelCellsRows: TLabel;
    LabelCells: TLabel;
    LabelRandSeed: TLabel;
    LabelPixelsColumlns: TLabel;
    LabelPixelsRows: TLabel;
    ShapeColor: TShape;
    ButtonNewMaze: TButton;
    EditRandSeed: TEdit;
    CheckBoxShowPath: TCheckBox;
    SpinEditXCells: TSpinEdit;
    SpinEditYCells: TSpinEdit;
    SpinEditXPixels: TSpinEdit;
    SpinEditYPixels: TSpinEdit;
    ButtonPrint: TButton;
    ButtonSave: TButton;
    RadioGroupPathStyle: TRadioGroup;
    RadioGroupPathColor: TRadioGroup;
    ScrollBoxMaze: TScrollBox;
    ImageMaze: TImage;
    SavePictureDialogMaze: TSavePictureDialog;
    LabelLength: TLabel;
    procedure ButtonNewMazeClick(Sender: TObject);
    procedure CheckBoxShowPathClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NumberKeyPress(Sender: TObject; var Key: Char);
    procedure ValueChange(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure ButtonPrintClick(Sender: TObject);
    procedure ShapeColorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMazeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  private
    InitialFormWidth :  INTEGER;
    InitialFormHeight:  INTEGER;
    PROCEDURE WMGetMinMaxInfo (VAR Msg:  TWMGetMinMaxInfo);
      MESSAGE wm_GetMinMaxInfo;
  public
    PROCEDURE UpdateMaze;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  MazeLibrary, ScreenPrintMaze;

PROCEDURE TForm1.WMGetMinMaxInfo(VAR Msg:  TWMGetMinMaxInfo);
BEGIN
    WITH Msg.MinMaxInfo^ DO
    BEGIN
      ptMinTrackSize.x := InitialFormWidth;
      ptMinTrackSize.y := InitialFormHeight
    END
END ;

PROCEDURE TForm1.UpdateMaze;
  CONST
    Margin = 0; 
  VAR
    Bitmap    :  TBitmap;
    PathColor :  TPathColor;
    PathLength:  INTEGER;
    PathStyle :  TPathStyle;
    Seed      :  INTEGER;
    xWidth    :  INTEGER;
    xCells    :  INTEGER;
    yCells    :  INTEGER;
    yHeight   :  INTEGER;
BEGIN
  Screen.Cursor := crHourGlass;
  TRY
    Bitmap := TBitmap.Create;
    TRY
      TRY
        xWidth := SpinEditXPixels.Value + 1  + 2*Margin
      EXCEPT
        ON EConvertError DO  xWidth := 201   + 2*Margin
      END;
      TRY
        yHeight := SpinEditYPixels.Value + 1 + 2*Margin
      EXCEPT
        ON EConvertError DO  yHeight := 201  + 2*Margin
      END;
      Bitmap.Width  := xWidth;
      Bitmap.Height := yHeight;
      TRY
        xCells := SpinEditXCells.Value
      EXCEPT
        ON EConvertError DO  xCells := 20  
      END;
      TRY
        yCells := SpinEditYCells.Value
      EXCEPT
        ON EConvertError DO  yCells := 15  
      END;
      TRY
        Seed := StrToInt(EditRandSeed.Text);
      EXCEPT
        ON EConvertError DO Seed := 19937  
      END;
      IF   RadioGroupPathStyle.ItemIndex = 0
      THEN PathStyle := psLine
      ELSE PathStyle := psBlock;
      IF   RadioGroupPathColor.ItemIndex = 0
      THEN PathColor := pcRainbow
      ELSE PathColor := pcSolid;
      PathLength := DrawMaze(Bitmap.Canvas,
                             Bitmap.Width, Bitmap.Height,
                             xCells,       yCells,
                             Margin, Margin,
                             Seed,
                             CheckBoxShowPath.Checked,
                             PathStyle,
                             PathColor,
                             ShapeColor.Brush.Color);
      ImageMaze.Picture.Graphic := Bitmap;
      LabelLength.Caption := 'Length = ' + IntToStr(PathLength)
    FINALLY
      Bitmap.Free
    END;
  FINALLY
    Screen.Cursor := crDefault
  END
END ;

procedure TForm1.ButtonNewMazeClick(Sender: TObject);
VAR
    Seed:  INTEGER;
begin
  Randomize;
  Seed := RandSeed;
  EditRandSeed.Text := IntToStr(Seed);
  UpdateMaze
end;

procedure TForm1.CheckBoxShowPathClick(Sender: TObject);
begin
  UpdateMaze
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InitialFormWidth  := Width;
  InitialFormHeight := Height;
  ButtonNewMazeClick(Sender)
end;

procedure TForm1.NumberKeyPress(Sender: TObject;
  var Key: Char);
  CONST
    Backspace = #$08;
begin
  IF   NOT (Key IN [Backspace, '0'..'9'])
  THEN Key := #$00
end;

procedure TForm1.ValueChange(Sender: TObject);
begin
  UpdateMaze
end;

procedure TForm1.ButtonUpdateClick(Sender: TObject);
begin
  IF   EditRandSeed.Text = ''
  THEN EditRandSeed.Text := '0';
  UpdateMaze
end;

procedure TForm1.ButtonPrintClick(Sender: TObject);
begin
  FormPrintMaze.ShowModal;
  IF   FormPrintMaze.ModalResult = mrOK
  THEN ShowMessage('Maze printed.')
end;

procedure TForm1.ShapeColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IF   ColorDialogFloodFill.Execute
  THEN BEGIN
    ShapeColor.Brush.Color := ColorDialogFloodFill.Color;
    UpdateMaze
  END
end;

procedure TForm1.ImageMazeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  VAR
    Color:  TColor;
begin
  Color := ImageMaze.Canvas.Pixels[X,Y];
  ImageMaze.Canvas.Brush.Color := ShapeColor.Brush.Color;
  ImageMaze.Canvas.FloodFill(X,Y, Color, fsSurface)
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  SpinEditXPixels.Value := 50 * ((ScrollBoxMaze.Width -1) DIV 50);
  SpinEditYPixels.Value := 50 * ((ScrollBoxMaze.Height-1) DIV 50)
end;

procedure TForm1.ButtonSaveClick(Sender: TObject);
begin
  IF   SavePictureDialogMaze.Execute
  THEN BEGIN
    ImageMaze.Picture.Bitmap.SaveToFile(SavePictureDialogMaze.Filename);
    ShowMessage('File Saved.')
  END
end;
end.

