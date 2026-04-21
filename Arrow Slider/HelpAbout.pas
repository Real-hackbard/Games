unit HelpAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm3 = class(TForm)
    imgIcon: TImage;
    lblAbout1: TLabel;
    btnOk: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  ShellAPI;

{$R *.DFM}

procedure TForm3.FormCreate(Sender: TObject);
begin
  imgIcon.Picture.Icon := Application.Icon;
end;

end.
