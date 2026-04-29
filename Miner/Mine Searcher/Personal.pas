unit Personal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    LabelEdit1: TLabeledEdit;
    LabelEdit2: TLabeledEdit;
    LabelEdit3: TLabeledEdit;
    BOK: TButton;
    BAnnuler: TButton;
    procedure FormShow(Sender: TObject);
    procedure BOKClick(Sender: TObject);
  private
    { Declarations privates }
  public
    { Declarations public }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin
  LabelEdit1.Text := IntToStr(Form1.NbrLgn);
  LabelEdit2.Text := IntToStr(Form1.NbrCln);
  LabelEdit3.Text := IntToStr(Form1.NbrMine);
end;

procedure TForm2.BOKClick(Sender: TObject);
var
  New_NbrLgn, New_NbrCln, New_NbrMine : Integer;
begin
  New_NbrLgn := StrToInt(LabelEdit1.Text);
  New_NbrCln := StrToInt(LabelEdit2.Text);
  New_NbrMine := StrToInt(LabelEdit3.Text);

  if (New_NbrLgn > Form1.NLMax) then New_NbrLgn := Form1.NLMax;
  if (New_NbrLgn < 9) then New_NbrLgn := 9;

  if (New_NbrCln > Form1.NCMax) then New_NbrCln := Form1.NCMax;
  if (New_NbrCln < 9) then New_NbrCln := 9;
  
  if (New_NbrMine > (New_NbrLgn * New_NbrCln div 2)) then
    New_NbrMine := New_NbrLgn * New_NbrCln div 2;
    
  if (New_NbrMine < 10) then New_NbrMine := 10;

  Form1.NbrLgn  := New_NbrLgn;
  Form1.NbrCln  := New_NbrCln;
  Form1.NbrMine := New_NbrMine;

  Form1.Level := Perso;
end;

end.
