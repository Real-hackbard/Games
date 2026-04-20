unit about;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TAboutbox = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Image1: TImage;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Aboutbox: TAboutbox;

implementation

{$R *.DFM}

procedure TAboutbox.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
