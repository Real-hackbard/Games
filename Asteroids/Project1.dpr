program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Title := '';
  Application.CreateForm(TForm1, Form1);
  //Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
