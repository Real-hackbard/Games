unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Label4: TLabel;
    SpinEdit4: TSpinEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

uses unit1; 

{$R *.DFM}

procedure TForm2.Button1Click(Sender: TObject);
begin
  with form1 do Begin
     breite := spinedit1.Value;
     row := spinedit2.Value;
     col := spinedit3.Value;
     verzoegerung := spinedit4.Value;
     zeichneAlles;
  End;
  close;
end;

end.
