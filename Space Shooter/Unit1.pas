unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Gauges, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    PanelInfo: TPanel;
    Label1: TLabel;
    PowerGauge: TGauge;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    mFichier: TMenuItem;
    miNewP: TMenuItem;
    miQuitter: TMenuItem;
    LabScore: TLabel;
    Label3: TLabel;
    GaugeShoot: TGauge;
    miPause: TMenuItem;
    Label4: TLabel;
    GaugeEtatLaser: TGauge;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure miNewPClick(Sender: TObject);
    procedure miQuitterClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miPauseClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
      AppDir : String;
      procedure MakeFullScreen;
      procedure CreateObj;
      procedure DestroyObj;
      procedure GameOver;
      procedure NewGame ;
      procedure AfficherInfoJoueur;
  end;

const
  FULLSCREEN = true;
var
  Form1: TForm1;
  
implementation

{$R *.dfm}

uses Obj, PlateauObj, ChoiceVessel, BombeGuideeObj;

var
  Plateau : TPlateau;

procedure TForm1.GameOver;
begin
  ShowMessage('Lost ! ');
end;

procedure TForm1.NewGame;
begin
  if(Assigned(Plateau) ) then  DestroyObj;
  CreateObj;
  Plateau.Start;
  PanelInfo.Visible := True;
  miPause.Enabled := True;
end;

procedure TForm1.AfficherInfoJoueur;
var
  i,n:integer;
begin
  if not Assigned (Plateau.Vaisseau) then Exit;
  PowerGauge.Progress := Plateau.Vaisseau.Power;
  GaugeShoot.MaxValue := Plateau.Vaisseau.GaugeShootMax;
  GaugeShoot.Progress := Plateau.Vaisseau.GaugeShoot;
  LAbScore.Caption := Format('%d',[Plateau.Score]);
  GaugeEtatLaser.MaxValue := Plateau.Vaisseau.TempsShootMax;
  GaugeEtatLaser.Progress := Plateau.Vaisseau.TempsShoot;

  n:=0;
  for i:=0 to Plateau.VecteurEnnemi.Count-1 do begin
    if(Assigned(TBombeG(Plateau.VecteurEnnemi.Items[i]))) then n:=n+1;
  end;

  Caption := Format('%d',[n]);
end;


procedure TForm1.MakeFullScreen;
begin
  Left := 0;
  Top:=0;
  Width := Screen.Monitors[0].Width;
  Height := Screen.Monitors[0].Height;
end;
{
  This is where we place all the objects we create.
}

procedure TForm1.CreateObj;
var
  t : TVaiseauType;
begin
  Form2.ShowModal;

  case Form2.ModalResult of
    1 : t:=(vtRaptor);
    2 : t:=(vtArbitre);
    3 : t:=(vtEnforcer);
    4 : t:=(vtCuirasse);
  end;

  Plateau := TPlateau.Create(self,self);
  Plateau.ApplicationDirectory := AppDir;
  Plateau.Load(t);
  GaugeShoot.MaxValue := Plateau.Vaisseau.GaugeShootMax;
  PowerGauge.MaxValue := Plateau.Vaisseau.PowerMax;
end;
{
  Here, all previously created objects are released.
}

procedure TForm1.DestroyObj;
begin
  Plateau.Free;
end;
{
  Create Form
}
procedure TForm1.FormCreate(Sender: TObject);
var
  i, x, y : integer;
  p : word;
begin
  for p := 10 to 200 do
  begin
      Canvas.Pixels[p, 10] := clRed;
  end;

  PanelInfo.Visible := False;
  Randomize;
  // Essential if you don't want to end up blind!
  DoubleBuffered := True;
  // app folder
  AppDir := ExtractFileDir(Application.ExeName);
  // fullscreen
  if(FULLSCREEN) then MakeFullScreen;
  // ctrl + n, new part
  miNewP.ShortCut:=ShortCut(Word('N'), [ssCtrl]);
  // ctrl + p = pause
  miPause.ShortCut:=ShortCut(Word('P'), [ssCtrl]);
  // ctrl + q = quit
  miQuitter.ShortCut:=ShortCut(Word('Q'), [ssCtrl]);
end;


procedure TForm1.miNewPClick(Sender: TObject);
begin
  NewGame;
end;

procedure TForm1.miQuitterClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Do you really want to leave? ?', mtConfirmation, [mbYes, mbNo], 0)= mrYes then begin

    if Assigned(Plateau) then Plateau.Stop;
    CanClose := True;
  end
  else
    CanClose := False;
end;

procedure TForm1.miPauseClick(Sender: TObject);
begin
  if (Plateau.Pause) then Plateau.Start else Plateau.Stop;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  i : integer;
  k, p : word;
begin
  for i := 0 to 2000 do
  begin
    p := Random(2000);
    k := Random(2000);
      Canvas.Pixels[p, k] := clWhite;
  end;
end;

end.
