program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Bmp in 'Bmp.pas',
  Editor in 'Editor.pas' {Form3},
  Finish in 'Finish.pas' {Form4},
  Help in 'Help.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
