unit scores;

interface

uses
  Windows, Messages, SysUtils, Controls, Forms, StdCtrls, ExtCtrls, Classes;

type
  TForm2 = class(TForm)
    Notebook1: TNotebook;
    Label1: TLabel;
    Label2: TLabel;
    LabelScore: TLabel;
    Edit4: TEdit;
    ListBox1: TListBox;
    Button1: TButton;
    LabelPosition: TLabel;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Declarations privates }
  public
    { Declarations public }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.FormShow(Sender: TObject);
begin
  ListBox1.Clear;
  ListBox1.Items.LoadFromFile('Scores.txt');
  if Notebook1.PageIndex = 0 then Form2.Edit4.SetFocus;
end;

procedure TForm2.Edit4KeyPress(Sender: TObject; var Key: Char);
var nl: integer;
begin
  if (Key = #13) then begin
    Key := #0;
    for nl := 1 to 10-Length(LabelScore.Caption) do
      LabelScore.Caption := '.'+LabelScore.Caption;
    ListBox1.Items.Add(LabelScore.Caption+' - '+Edit4.Text);
    ListBox1.Items.SaveToFile('Scores.txt');
    ListBox1.Clear;
    ListBox1.Items.LoadFromFile('Scores.txt');
    nl := ListBox1.Items.IndexOf(LabelScore.Caption+' - '+Edit4.Text);
    ListBox1.ItemIndex := nl;
    nl := ListBox1.Items.Count-nl;
    if nl = 1 then LabelPosition.Caption := IntToStr(nl)+'1st rank !'
      else LabelPosition.Caption := IntToStr(nl)+'th rank';
    NoteBook1.PageIndex := 1;
  end;
end;

procedure TForm2.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then begin
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    ListBox1.Items.SaveToFile('Scores.txt');
  end;
end;

end.
