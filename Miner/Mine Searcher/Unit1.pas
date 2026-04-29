unit Unit1;

interface             

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Math, ExtCtrls, ImgList, Menus, Buttons, StdCtrls, Registry,
  XPMan;

type
  Caze = Record
   Image: TImage;
   Info: 0..8;
   Checked, Brands, Mined: Boolean;
  end;

  TLevel = (one, two, three, Perso);

type
  TForm1 = class(TForm)
    Panel3: TPanel;
    ImageList1: TImageList;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    Game: TMenuItem;
    N1: TMenuItem;
    MI_Separator1: TMenuItem;
    B1: TMenuItem;
    N2: TMenuItem;
    E1: TMenuItem;
    P1: TMenuItem;
    MI_Separator2: TMenuItem;
    B2: TMenuItem;
    MI_Separator3: TMenuItem;
    Q1: TMenuItem;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    Edit2: TEdit;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure CheckCase(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LoadNewGame(Sender: TObject);
    procedure ShowElapsedTime(Sender: TObject);
    procedure Q1Click(Sender: TObject);
    procedure B2Click(Sender: TObject);
  private
    { Declarations privates }
    Procedure Descover(i, j: Integer);
    procedure NewGame();
    function isEndGame(): Boolean;
    procedure EndGame();
    procedure ShowHideFlag(i,j: integer);
    procedure TesterMine(i,j: integer);
    procedure GameOver();
    procedure ShowFinedMine();
    procedure EmptyMinefield();
    procedure MinerFieldOfMines();
    procedure CheckMenuItem();
    procedure CreateScoreListIfNoteExist();
    function UpdateScoreListe(): Boolean;
  public
    { Declarations public }
    NbrLgn,NbrCln,NbrMine: Integer;
    NLMax, NCMax: integer;
    Level : TLevel;
  end;

var
  Form1: TForm1;
  T: Array of Array of Caze;
  Time, FinedMine: Integer;

implementation

uses Personal, ScoreList;

{$R *.dfm}

function TForm1.UpdateScoreListe(): Boolean;
var
  Reg: TRegistry;
  Name: String;
begin
  Result := False;
  Reg := TRegistry.Create();
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  case (Level) of
    one    : Reg.OpenKey('\SoftWare\Miner\one\',True);
    two  : Reg.OpenKey('\SoftWare\Miner\two\',True);
    three : Reg.OpenKey('\SoftWare\Miner\three\',True);
  end;

  if (Level <> Perso) then begin
    if (Time < Reg.ReadInteger('Time')) then begin
      Name := InputBox('Best Minesweeper...','Please enter your name :','Anonym');
      Reg.WriteString('Name',Name);
      Reg.WriteInteger('Time',Time);
      Result := True;
    end;
    Reg.CloseKey();
  end;

  Reg.Free();
end;

procedure TForm1.CreateScoreListIfNoteExist();
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create();
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  if not Reg.KeyExists('\SoftWare\Miner') then begin
    Reg.OpenKey('\SoftWare\Miner\one\',True);
    Reg.WriteInteger('Time',999);
    Reg.WriteString('Name','Anonym');
    Reg.CloseKey();

    Reg.OpenKey('\SoftWare\Miner\two\',True);
    Reg.WriteInteger('Time',999);
    Reg.WriteString('Name','Anonym');
    Reg.CloseKey();

    Reg.OpenKey('\SoftWare\Miner\three\',True);
    Reg.WriteInteger('Time',999);
    Reg.WriteString('Name','Anonym');
    Reg.CloseKey();
  end;
  Reg.Free();
end;

procedure TForm1.EndGame();
begin
  Timer1.Enabled := False;
  Panel3.Enabled := False;

  if UpdateScoreListe() then Form3.ShowModal();
end;

procedure TForm1.CheckMenuItem();
begin
  B1.Checked := Level =one;
  N2.Checked := Level =two;
  E1.Checked := Level =three;
  P1.Checked := Level =Perso;
end;

procedure TForm1.MinerFieldOfMines();
var
  i,j,Cpt: Integer;
begin
  Randomize();
  Cpt := 0;
  while (Cpt < NbrMine) do
  begin
    i := Random(NbrLgn);
    j := Random(NbrCln);
    if (not T[i,j].Mined) then
    begin
      T[i,j].Mined := True;

      if (i-1 >= 0) then
      begin
        if (j-1 >= 0) then INC(T[i-1,j-1].Info);
        INC(T[i-1,j].Info);
        if (j+1 < NbrCln) then INC(T[i-1,j+1].Info);
      end;

      if (j-1 >= 0) then INC(T[i,j-1].Info);
      if (j+1 < NbrCln) then INC(T[i,j+1].Info);

      if (i+1 < NbrLgn) then
      begin
        if (j-1 >= 0) then INC(T[i+1,j-1].Info);
        INC(T[i+1,j].Info);
        if (j+1 < NbrCln) then INC(T[i+1,j+1].Info);
      end;

      Cpt := Cpt + 1;
    end;
  end;
end;

procedure TForm1.EmptyMinefield();
var
  i,j: Integer;
begin
  for i:=0 to NbrLgn - 1 do
    for j:=0 to NbrCln - 1 do
    begin
      ImageList1.GetIcon(9,T[i,j].Image.Picture.Icon);
      T[i,j].Info := 0;
      T[i,j].Mined := False;
      T[i,j].Image.Tag := i * NbrCln + j;
      T[i,j].Checked := False;
      T[i,j].Brands := False;
    end;
end;

procedure TForm1.GameOver();
var
  i,j: Integer;
begin
  Timer1.Enabled := False;
  Panel3.Enabled := False;
  for i := 0 to NbrLgn - 1 do
    for j := 0 to NbrCln - 1 do
    begin
      if (T[i,j].Brands)and(not T[i,j].Mined) then
        ImageList1.GetIcon(12,T[i,j].Image.Picture.Icon);
      if (not T[i,j].Brands)and(T[i,j].Mined) then
        ImageList1.GetIcon(11,T[i,j].Image.Picture.Icon);
    end;
end;

procedure TForm1.TesterMine(i,j: integer);
begin
  if (not T[i,j].Mined) then
  begin
    Descover(i,j);
    if isEndGame() then EndGame();
  end else
    GameOver();
end;

procedure TForm1.ShowHideFlag(i,j: integer);
begin
  if (not T[i,j].Brands) then
  begin
    T[i,j].Brands := True;
    ImageList1.GetIcon(10,T[i,j].Image.Picture.Icon);
    FinedMine := FinedMine + 1;
    if isEndGame() then EndGame();
  end else begin
    T[i,j].Brands := False;
    ImageList1.GetIcon(9,T[i,j].Image.Picture.Icon);
    FinedMine := FinedMine - 1;
  end;
  ShowFinedMine();
end;

function TForm1.isEndGame(): Boolean;
var
  i,j: Integer;
begin
  i := 0;
  Result := FinedMine = NbrMine;
  while (i < NbrLgn) and Result do
  begin
    j := 0;
    while (j < NbrCln) and Result do
    begin
      if T[i,j].Mined then Result := T[i,j].Brands
      else Result := T[i,j].Checked;
      j := j + 1;
    end;
    i := i + 1;
  end;
end;

procedure  TForm1.CheckCase(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i,j: integer;
begin
  i := (Sender as TControl).Tag div NbrCln;
  j := (Sender as TControl).Tag mod NbrCln;
  Timer1.Enabled := True;
  if (not T[i,j].Checked) then
  begin
    if (Button = mbRight) then ShowHideFlag(i,j);
    if (not T[i,j].Brands) and (Button = mbLeft) then TesterMine(i,j);
  end;
end;

procedure TForm1.NewGame();
begin
  CheckMenuItem();

  Panel3.Enabled := True;
  Panel3.Width := 16 * NbrCln + 4;
  Panel3.Height := 16 * NbrLgn + 4;
  Panel3.Left := 8;

  Form1.Width := Panel3.Width + 20;
  Form1.Height := Panel3.Top + Panel3.Height + 60;
  Form1.Position := poScreenCenter;

  Timer1.Enabled := False;
  BitBtn1.Left := (Panel1.Width - BitBtn1.Width) div 2;
  Edit2.Left := Panel1.Width - Edit2.Width - 12;
  Edit2.Text := '000';
  Time := 0;
  FinedMine := 0;
  ShowFinedMine();
  EmptyMinefield();
  MinerFieldOfMines();
end;

Procedure TForm1.Descover(i, j: Integer);
begin
  if (not T[i,j].Checked)and(not T[i,j].Brands) then
  begin
    ImageList1.GetIcon(T[i,j].Info,T[i,j].Image.Picture.Icon);
    T[i,j].Checked := True;
    if (T[i,j].Info = 0) then
    begin

      if (i-1 >= 0) then
      begin
        if (j-1 >= 0) then Descover(i-1,j-1);
        Descover(i-1,j);
        if (j+1 < NbrCln) then Descover(i-1,j+1);
      end;

      if (j-1 >= 0) then Descover(i,j-1);
      if (j+1 < NbrCln) then Descover(i,j+1);

      if (i+1 < NbrLgn) then
      begin
        if (j-1 >= 0) then Descover(i+1,j-1);
        Descover(i+1,j);
        if (j+1 < NbrCln) then Descover(i+1,j+1);
      end;

    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i,j: integer;
begin
  CreateScoreListIfNoteExist();
  
  Level := three;
  NLMax := 24; NCMax := 30;
  NbrCln := 30; NbrLgn := 16; NbrMine := 99;
  SetLength(T,NLMax,NCMax);
  for i:=0 to NLMax-1 do
    for j:=0 to NCMax-1 do
    begin
      T[i,j].Image := TImage.Create(self);
      T[i,j].Image.Parent := Panel3;
      T[i,j].Image.Left := j * 16;
      T[i,j].Image.Top := i * 16;
      T[i,j].Image.AutoSize := True;
      T[i,j].Image.OnMouseDown := CheckCase;
    end;
  NewGame();
end;

procedure TForm1.LoadNewGame(Sender: TObject);
begin
  case (Sender as TComponent).Tag of
    1: begin
        NbrLgn := 09;
        NbrCln := 09;
        NbrMine := 10;
        Level := one;
      end;
    2: begin
        NbrLgn := 16;
        NbrCln := 16;
        NbrMine := 40;
        Level := two;
      end;
    3: begin
        NbrLgn := 16;
        NbrCln := 30;
        NbrMine := 99;
        Level := three;
      end;
    4: Form2.ShowModal();
  end;
  if (Sender as TComponent).Tag  = 4 then
  begin
    if (Form2.ModalResult = mrOK) then NewGame();
  end else
    NewGame();
end;

procedure TForm1.ShowElapsedTime(Sender: TObject);
begin
  INC(Time);
  case (Time div 10) of
         0: Edit2.Text := '00' + IntToStr(Time);
      1..9: Edit2.Text :=  '0' + IntToStr(Time);
    10..90: Edit2.Text := IntToStr(Time);
  end;

  if (Time = 999) then
  begin
    MessageDlg('Time limit exceeded !',mtWarning,[mbOK],0);
    GameOver();
  end;
end;

procedure TForm1.ShowFinedMine();
var
  Ch: String;
begin
  case ((NbrMine - FinedMine) div 10) of
    -9..-1: ch := '-';
         0: If (NbrMine >= FinedMine) then Ch := '00' else Ch := '-0';
      1..9: Ch := '0';
    10..90: Ch := '';
  end;
  Edit1.Text := Ch + IntToStr(ABS(NbrMine  - FinedMine));
end;

procedure TForm1.Q1Click(Sender: TObject);
begin
  Application.Terminate();
end;

procedure TForm1.B2Click(Sender: TObject);
begin
  Form3.ShowModal();
end;

end.
