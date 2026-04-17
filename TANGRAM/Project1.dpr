program Project1;

{Tangram project}  

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Pieces in 'Pieces.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
