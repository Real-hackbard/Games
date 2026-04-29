unit InputName;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TInputNameForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Declarations privates }
  public
    { Declarations public }
  end;

var
  InputNameForm: TInputNameForm;

implementation

{$R *.DFM}

uses Unit1;

procedure TInputNameForm.FormShow(Sender: TObject);
const
  Levl: array[1..3] of string = (' beginner.',' intermediate.',' expert.');
  Br = #13#10;
begin
  Left := Application.MainForm.Left + 4;
  Top := Application.MainForm.Top + 90;
  Label1.Caption :=
  'You did the best' + Br +
  'time' + Br +
  'of the level' + Levl[GameLevel] + Br +
  'Enter your name.';
  Edit1.SetFocus;
  Edit1.SelectAll;
end;

procedure TInputNameForm.Button1Click(Sender: TObject);
begin
  case GameLevel of
    1: BestBeginnerName := Edit1.Text;
    2: BestIntermediateName := Edit1.Text;
    3: BestExpertName := Edit1.Text;
  end;
  Close;
end;

procedure TInputNameForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if Key = VK_RETURN then
  //  btnOk.Click;
end;

procedure TInputNameForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Button1.Click;
  end;
end;

end.
