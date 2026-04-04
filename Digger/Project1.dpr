program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}
{$R digger}

begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
