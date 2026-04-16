program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Solution in 'Solution.pas' {Form2};

{$R *.RES}
{$R xpento.RES}
{$R xpento2.RES}

begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
