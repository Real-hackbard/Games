program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  HelpAbout in 'HelpAbout.pas' {Form3},
  settings in 'settings.pas' {Form2},
  goal in 'goal.pas' {Form4};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
