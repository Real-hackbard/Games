unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ComCtrls, SoundPlayerThread, MMSystem, Buttons,
  ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    ListBox1: TListBox;
    Label2: TLabel;
    Edit1: TEdit;
    Button28: TButton;
    Button29: TButton;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    Bevel1: TBevel;
    procedure Button1Click(Sender: TObject);
    procedure anzeige(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure test(b:char;Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  ratewort,eingabewort:string;
  fehler : integer;
  ms: TMemoryStream;
  gefunden:boolean;

implementation

{$R *.dfm}
procedure PlayWaveStream(Stream: TMemoryStream);
begin
  if Stream = nil then
    sndPlaySound(nil, SND_ASYNC) //stop sound
  else
    sndPlaySound(Stream.Memory, (SND_ASYNC or SND_MEMORY));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i, n, anz:integer;
begin
  for n := 1 to 26 do
  begin
    TCheckbox(findcomponent('SpeedButton' + inttostr(n))).Font.Color := clNavy;
  end;

  anz:=listbox1.items.count;
  ratewort:=uppercase(listbox1.items[random(anz)]);
  eingabewort:=ratewort;

  for i:=1 to length(eingabewort) do
    eingabewort[i]:='•';

  fehler:=0;
  anzeige(sender);
end;

procedure TForm1.anzeige(Sender: TObject);
var
  i : integer;
begin
  label1.Caption:=eingabewort;
  label2.caption:='Error '+ IntToStr(fehler);

  if ratewort=eingabewort then
  begin
    Beep;

    if Fehler = 0 then
    begin
      ShowMessage('Bravo, you guessed the word with 0 errors!!');
      Exit;
    end;

    ShowMessage('Congratulations! You found the word with ' + IntToStr(fehler) + ' Errors');
  end;
end;

procedure TForm1.test(b:char;Sender: TObject);
var
  i:integer;
begin
  gefunden:=false;

  for i:=1 to length(ratewort) do
  begin
    if ratewort[i]=b then
    begin
      eingabewort[i]:=b;
      gefunden:=true;
      ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                      'Wav\won.wav'));
      ms.Position := 0;
      PlayWaveStream(ms);
    end;
  end;

  if not gefunden then
  begin
    inc(fehler);
    ms.LoadFromFile(PChar(ExtractFilePath(Application.ExeName) +
                      'Wav\error.wav'));
    ms.Position := 0;
    PlayWaveStream(ms);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  randomize;
  button1click(sender);
end;

procedure TForm1.Button28Click(Sender: TObject);
var b:char;
begin
  if length(edit1.Text)>0 then begin
    b:=upcase(edit1.text[1]);
    test(b,sender);
    anzeige(sender);
  end;
end;

procedure TForm1.Button29Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ListBox1.Items.LoadFromFile(OpenDialog1.FileName);
    StatusBar1.Panels[1].Text := IntToStr(ListBox1.Items.Count);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ms := TMemoryStream.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ms.Free;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if sender=Speedbutton1 then
  begin
    test('A',sender);
    if gefunden = true then SpeedButton1.Font.Color := clRed;
  end;

  if sender=Speedbutton2 then
  begin
    test('B',sender);
    if gefunden = true then SpeedButton2.Font.Color := clRed;
  end;

  if sender=Speedbutton3 then
  begin
    test('C',sender);
    if gefunden = true then SpeedButton3.Font.Color := clRed;
  end;

  if sender=Speedbutton4 then
  begin
    test('D',sender);
    if gefunden = true then SpeedButton4.Font.Color := clRed;
  end;

  if sender=Speedbutton5 then
  begin
    test('E',sender);
    if gefunden = true then SpeedButton5.Font.Color := clRed;
  end;

  if sender=Speedbutton6 then
  begin
    test('F',sender);
    if gefunden = true then SpeedButton6.Font.Color := clRed;
  end;

  if sender=Speedbutton7 then
  begin
    test('G',sender);
    if gefunden = true then SpeedButton7.Font.Color := clRed;
  end;

  if sender=Speedbutton8 then
  begin
    test('H',sender);
    if gefunden = true then SpeedButton8.Font.Color := clRed;
  end;

  if sender=Speedbutton9 then
  begin
    test('I',sender);
    if gefunden = true then SpeedButton9.Font.Color := clRed;
  end;

  if sender=Speedbutton10 then
  begin
    test('J',sender);
    if gefunden = true then SpeedButton10.Font.Color := clRed;
  end;

  if sender=Speedbutton11 then
  begin
    test('K',sender);
    if gefunden = true then SpeedButton11.Font.Color := clRed;
  end;

  if sender=Speedbutton12 then
  begin
    test('L',sender);
    if gefunden = true then SpeedButton12.Font.Color := clRed;
  end;

  if sender=Speedbutton13 then
  begin
    test('M',sender);
    if gefunden = true then SpeedButton13.Font.Color := clRed;
  end;

  if sender=Speedbutton14 then
  begin
    test('N',sender);
    if gefunden = true then SpeedButton14.Font.Color := clRed;
  end;

  if sender=Speedbutton15 then
  begin
    test('O',sender);
    if gefunden = true then SpeedButton15.Font.Color := clRed;
  end;

  if sender=Speedbutton16 then
  begin
    test('P',sender);
    if gefunden = true then SpeedButton16.Font.Color := clRed;
  end;

  if sender=Speedbutton17 then
  begin
    test('Q',sender);
    if gefunden = true then SpeedButton17.Font.Color := clRed;
  end;

  if sender=Speedbutton18 then
  begin
    test('R',sender);
    if gefunden = true then SpeedButton18.Font.Color := clRed;
  end;

  if sender=Speedbutton19 then
  begin
    test('S',sender);
    if gefunden = true then SpeedButton19.Font.Color := clRed;
  end;

  if sender=Speedbutton20 then
  begin
    test('T',sender);
    if gefunden = true then SpeedButton20.Font.Color := clRed;
  end;

  if sender=Speedbutton21 then
  begin
    test('U',sender);
    if gefunden = true then SpeedButton21.Font.Color := clRed;
  end;

  if sender=Speedbutton22 then
  begin
    test('V',sender);
    if gefunden = true then SpeedButton22.Font.Color := clRed;
  end;

  if sender=Speedbutton23 then
  begin
    test('W',sender);
    if gefunden = true then SpeedButton23.Font.Color := clRed;
  end;

  if sender=Speedbutton24 then
  begin
    test('X',sender);
    if gefunden = true then SpeedButton24.Font.Color := clRed;
  end;

  if sender=Speedbutton25 then
  begin
    test('Y',sender);
    if gefunden = true then SpeedButton25.Font.Color := clRed;
  end;

  if sender=Speedbutton26 then
  begin
    test('Z',sender);
    if gefunden = true then SpeedButton26.Font.Color := clRed;
  end;

  anzeige(sender);
end;

end.
