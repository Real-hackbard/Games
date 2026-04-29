unit Customer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TCustomerForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button2: TButton;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Declarations privates }
  public
    { Declarations public }
  end;

var
  CustomerForm: TCustomerForm;

  CustomHeight,             // grid height,
  CustomWidth,              // grid width,
  CustomMines: Integer;     // and number of mines chosen per user

implementation

uses Unit1;

{$R *.DFM}

procedure TCustomerForm.Button1Click(Sender: TObject);
begin
  CustomWidth  := Form1.DrawGrid1.ColCount;
  CustomHeight := Form1.DrawGrid1.RowCount;
  CustomMines  := Form1.SpinEdit1.Value;
  Close;
end;

procedure TCustomerForm.FormShow(Sender: TObject);
begin
  Left := Application.MainForm.Left + 4;
  Top := Application.MainForm.Top + 90;
  Edit1.Text := IntToStr(Form1.DrawGrid1.RowCount);
  Edit2.Text := IntToStr(Form1.DrawGrid1.ColCount);
  Edit3.Text := IntToStr(Form1.SpinEdit1.Value);
end;

{ Minimum/maximum dimensions: I'm a bit more generous than WinMine }
const
  COL_MINI = 9;
  COL_MAXI = 50;  // 30 for WinMine
  ROW_MINI = 9;
  ROW_MAXI = 36;  // 24 for WinMine

procedure TCustomerForm.Button2Click(Sender: TObject);
begin
  CustomWidth   := StrToIntDef(Edit2.Text, COL_MINI);
  if CustomWidth < COL_MINI then
    CustomWidth := COL_MINI
  else
  if CustomWidth > COL_MAXI then
    CustomWidth := COL_MAXI;
  Edit2.Text := IntToStr(CustomWidth);

  CustomHeight  := StrToIntDef(Edit1.Text, ROW_MINI);
  if CustomHeight < ROW_MINI then
    CustomHeight := ROW_MINI
  else
  if CustomHeight > ROW_MAXI then
    CustomHeight := ROW_MAXI;
  Edit1.Text := IntToStr(CustomHeight);

  { There's no limitation; it can be fun to test 0 or > n cells. }
  CustomMines   := StrToIntDef(Edit3.Text, 0);
  
  Close;
end;

{ basic input check and proceed to the next edit }
procedure TCustomerForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, #13, '0'..'9']) then Key := #0;
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

end.
