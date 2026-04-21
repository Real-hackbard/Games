program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  VARIABLES in 'Variables.pas',
  Evolution in 'Evolution.pas',
  Functions in 'Functions.pas',
  Move in 'Move.pas',
  Board in 'Board.pas',
  SearchForHits in 'SearchForHits.pas',
  AB in 'AB.PAS' {AboutBox},
  PROMOTION in 'Promotion.pas' {Form2},
  ChessLibrary in 'ChessLibrary.pas',
  EPD in 'EPD.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

