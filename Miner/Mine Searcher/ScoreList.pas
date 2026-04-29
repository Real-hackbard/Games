unit ScoreList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Declarations privates }
  public
    { Declarations public }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.FormShow(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create();
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  Reg.OpenKeyReadOnly('SoftWare\Miner\one\');
  Label4.Caption := IntToStr(Reg.ReadInteger('Time')) + ' seconds';
  Label7.Caption := Reg.ReadString('Name');
  Reg.CloseKey();

  Reg.OpenKeyReadOnly('SoftWare\Miner\two\');
  Label5.Caption := IntToStr(Reg.ReadInteger('Time')) + ' seconds';
  Label8.Caption := Reg.ReadString('Name');
  Reg.CloseKey();

  Reg.OpenKeyReadOnly('SoftWare\Miner\three\');
  Label6.Caption := IntToStr(Reg.ReadInteger('Time')) + ' seconds';
  Label9.Caption := Reg.ReadString('Name');
  Reg.CloseKey();

  Reg.Free();
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create();
  Reg.RootKey := HKEY_LOCAL_MACHINE;

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

  Reg.Free();

  Label4.Caption := '999 seconds';
  Label7.Caption := 'Anonym';

  Label5.Caption := '999 seconds';
  Label8.Caption := 'Anonym';

  Label6.Caption := '999 seconds';
  Label9.Caption := 'Anonym';
end;

end.
