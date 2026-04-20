program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Options in 'Options.pas' {Form2},
  Load in 'Load.pas' {Form3},
  Configuration in 'Configuration.pas' {Form4},
  spritez in 'spritez.pas',
  about in 'about.pas' {Aboutbox};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TAboutbox, Aboutbox);
  Application.Run;
end.
