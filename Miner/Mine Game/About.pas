unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TAboutForm = class(TForm)
    btnOk: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnOkClick(Sender: TObject);
  private
    { Declarations privates }
  public
    { Declarations publiqc }
  end;

var
  AboutForm: TAboutForm;

implementation

uses ShellApi;

{$R *.DFM}

procedure TAboutForm.btnOkClick(Sender: TObject);
begin
  Close;
end;

end.
