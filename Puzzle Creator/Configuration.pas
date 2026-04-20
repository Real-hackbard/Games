unit Configuration;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, Buttons, ExtCtrls;

type
  TForm4 = class(TForm)
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    Label2: TLabel;
    RadioGroup3: TRadioGroup;
    CheckBox3: TCheckBox;
    RadioGroup4: TRadioGroup;
    CheckBox4: TCheckBox;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form4: TForm4;

implementation

{$R *.DFM}

end.
