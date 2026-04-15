program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Game in 'Game.pas',
  Graphic in 'Graphic.pas' {Form2};

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
