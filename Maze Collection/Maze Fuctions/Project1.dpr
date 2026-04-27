program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  SpectraLibrary in 'SpectraLibrary.pas',
  ScreenPrintMaze in 'ScreenPrintMaze.pas' {FormPrintMaze},
  MazeLibrary in 'MazeLibrary.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormPrintMaze, FormPrintMaze);
  Application.Run;
end.
