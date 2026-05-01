unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, XPMan;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    btnNewGame: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnAbout: TButton;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnNewGameClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  private
    { Private declarations }
    FPlayer: Cardinal;
    procedure NewGame;
  public
    { Public declarations }
  end;

const
  APPNAME = 'Four wins';
  VER = '1.0';
  INFO_TEXT = APPNAME + ' ' + VER + #13#10 +
    'Copyright © 2026 Your Name' + #13#10#13#10 +
    'https://github.com/';

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Unit2;

var
  FourInARow: TFourInARow;

procedure TForm1.NewGame;
begin
  FreeAndNIl(FourInARow);
  FourInARow := TFourInARow.Create(Paintbox1);
  FPlayer := 1;
  Label2.Caption:= 'Player '+IntToStr(FPlayer);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.Title := APPNAME;
  Caption := APPNAME;
  NewGame;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  FourInARow.DrawField;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FourInARow);
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TempPlayer: Integer;
begin
  tempPlayer := FPlayer;
  if not FourInARow.SetStone(FPlayer, x) then
    ShowMessage('invalid move')
  else
  begin
    case FPlayer of
      1: FPlayer := 2;
      2: FPlayer := 1;
    end;
  end;
  if FourInARow.Gewonnen(TempPlayer) then
    ShowMessage('Player '+IntToStr(TempPlayer)+' win.');
  Label2.Caption:= 'Player '+IntToStr(FPlayer);
end;

procedure TForm1.btnNewGameClick(Sender: TObject);
begin
  NewGame;
end;

procedure TForm1.btnAboutClick(Sender: TObject);
begin
  MessageBox(Handle, INFO_TEXT, APPNAME, MB_ICONINFORMATION);
end;

end.

