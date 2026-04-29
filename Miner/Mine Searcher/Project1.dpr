program Project1;



uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Personal in 'Personal.pas' {Form2},
  ScoreList in 'ScoreList.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
