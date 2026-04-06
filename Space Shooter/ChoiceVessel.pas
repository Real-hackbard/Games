unit ChoiceVessel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, XPMan;

type
  TForm2 = class(TForm)
    ImageRaptor: TImage;
    ImageArbitre: TImage;
    ImageEnforcer: TImage;
    Bevel3: TBevel;
    Bevel2: TBevel;
    Bevel1: TBevel;
    ChoixRapt: TButton;
    ChoixArb: TButton;
    ChoixEnf: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    ImageCuirasse: TImage;
    Bevel4: TBevel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    ChoixCuir: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label15: TLabel;
    procedure ChoixRaptClick(Sender: TObject);
    procedure ChoixArbClick(Sender: TObject);
    procedure ChoixEnfClick(Sender: TObject);
    procedure ChoixCuirClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.ChoixRaptClick(Sender: TObject);
begin
  ModalResult := 1;
end;

procedure TForm2.ChoixArbClick(Sender: TObject);
begin
    ModalResult := 2;
end;

procedure TForm2.ChoixEnfClick(Sender: TObject);
begin
    ModalResult := 3;
end;

procedure TForm2.ChoixCuirClick(Sender: TObject);
begin
  ModalResult := 4;
end;

end.
