unit ScreenPrintMaze;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons;

type
  TFormPrintMaze = class(TForm)
    LabelXPixels: TLabel;
    LabelPixels: TLabel;
    LabelYPixels: TLabel;
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    LabelPixelsColumlns: TLabel;
    LabelPixelsRows: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;
var
  FormPrintMaze: TFormPrintMaze;

implementation

{$R *.DFM}

uses
  MazeLibrary,      
  Printers,         
  Unit1;

procedure TFormPrintMaze.FormActivate(Sender: TObject);
begin
  LabelXPixels.Caption := IntToStr( GetDeviceCaps(Printer.Handle, VERTRES) );
  LabelYPixels.Caption := IntToStr( GetDeviceCaps(Printer.Handle, HORZRES) )
end;

procedure TFormPrintMaze.BitBtnOKClick(Sender: TObject);
  CONST
    iMargin =  5;  
    jMargin =  5;  
  VAR
    iFromLeftMargin:  INTEGER;
    jFromPageMargin:  INTEGER;
    PathColor      :  TPathColor;
    PathStyle      :  TPathStyle;
    s              :  STRING;
    Seed           :  INTEGER;
    xCells         :  INTEGER;
    yCells         :  INTEGER;
begin
  Printer.Orientation := poLandscape;
  Printer.BeginDoc;
  iFromLeftMargin := MulDiv(Printer.PageWidth,  iMargin, 100);
  jFromPageMargin := MulDiv(Printer.PageHeight, jMargin, 100);
  TRY
    TRY
      xCells := Form1.SpinEditXCells.Value
    EXCEPT
      ON EConvertError DO  xCells := 20
    END;
    TRY
      yCells := Form1.SpinEditYCells.Value;
    EXCEPT
      ON EConvertError DO  yCells := 20
    END;
    TRY
      Seed := StrToInt(Form1.EditRandSeed.Text);
    EXCEPT
       ON EConvertError DO Seed := 0
    END;
    IF   Form1.RadioGroupPathStyle.ItemIndex = 0
    THEN PathStyle := psLine
    ELSE PathStyle := psBlock;
    IF   Form1.RadioGroupPathColor.ItemIndex = 0
    THEN PathColor := pcRainbow
    ELSE PathColor := pcSolid;
    DrawMaze(Printer.Canvas,
             Printer.PageWidth  - 2*iFromLeftMargin,
             Printer.PageHeight - 2*jFromPageMargin,
             xCells,            yCells,
             iFromLeftMargin, jFromPageMargin,
             Seed,
             Form1.CheckBoxShowPath.Checked,
             PathStyle,
             PathColor,
             Form1.ShapeColor.Brush.Color);
    Printer.Canvas.Brush.Color := clWhite;       
    Printer.Canvas.Font.Height := MulDiv(Printer.PageHeight, 25, 1000);
    Printer.Canvas.Font.Name := 'Arial';
    Printer.Canvas.Font.Color := clBlue;
    Printer.Canvas.Font.Style := [fsBold, fsItalic];
    s := 'efg''s Computer Lab';
    Printer.Canvas.TextOut(iFromLeftMargin,
                           Printer.PageHeight -
                           Printer.Canvas.TextHeight(s),
                           s);
    Printer.Canvas.Font.Style := [fsBold];       
    s := 'www.efg2.com/lab';
    Printer.Canvas.TextOut(Printer.PageWidth -
                           iFromLeftMargin   -
                           Printer.Canvas.TextWidth(s),
                           Printer.PageHeight -
                           Printer.Canvas.TextHeight(s),
                           s);
    Printer.Canvas.Font.Color := clBlack;        
    Printer.Canvas.Font.Height := MulDiv(Printer.PageHeight, 15, 1000);
    Printer.Canvas.Font.Style := [];
    s := 'Cells = ' + IntToStr(xCells) + ' by ' + IntToStr(yCells) +
         '     Seed = ' + IntToStr(Seed);
    Printer.Canvas.TextOut((Printer.PageWidth -
                            Printer.Canvas.TextWidth(s)) DIV 2,
                           Printer.PageHeight -
                           Printer.Canvas.TextHeight(s),
                           s);
  FINALLY
    Printer.EndDoc
  END
end;
end.

