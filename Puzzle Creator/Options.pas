unit Options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TForm2 = class(TForm)
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
  private
    { Declarations private }
  public
    { Declarations public }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

uses Unit1;

procedure TForm2.RadioGroup1Click(Sender: TObject);
begin
  form1.dimensions;
  form1.Shapes;
  form1.drawingtest(true);
end;

procedure TForm2.RadioGroup2Click(Sender: TObject);
begin
  form1.drawingtest(true);
end;

end.
