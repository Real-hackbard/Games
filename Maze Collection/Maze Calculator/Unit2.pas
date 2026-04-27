unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  globals;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Caption := APPNAME;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Abort := True;
  Close;
end;

end.
 