program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  About in 'About.pas' {AboutForm},
  Scores in 'Scores.pas' {ScoreForm},
  InputName in 'InputName.pas' {InputNameForm},
  Customer in 'Customer.pas' {CustomerForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TScoreForm, ScoreForm);
  Application.CreateForm(TInputNameForm, InputNameForm);
  Application.CreateForm(TCustomerForm, CustomerForm);
  Application.Run;
end.
