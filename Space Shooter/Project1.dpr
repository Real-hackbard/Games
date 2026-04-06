program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Obj in 'Obj.pas',
  ObjDrawable in 'ObjDrawable.pas',
  ObjMovable in 'ObjMovable.pas',
  MeteorObj in 'MeteorObj.pas',
  LaserObj in 'LaserObj.pas',
  PlateauObj in 'PlateauObj.pas',
  ThreadMouvement in 'ThreadMouvement.pas',
  ExplosionObj in 'ExplosionObj.pas',
  ChoiceVessel in 'ChoiceVessel.pas' {Form2},
  BonusObj in 'BonusObj.pas',
  ObjAnimated in 'ObjAnimated.pas',
  BombeGuideeObj in 'BombeGuideeObj.pas',
  EnnemiObj in 'EnnemiObj.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
