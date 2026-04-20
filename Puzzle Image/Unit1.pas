unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, jpeg, XPMan, SoundPlayerThread;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Convert1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    N1: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    cbTaille: TComboBox;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Convert1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Jpg2bmp(JpgFilePath : string; BmpSavePath : string);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Declarations privates }
  public
    { Declarations public }
    convert:boolean;
  end;

var
  Form1: TForm1;

implementation

uses Game;

{$R *.DFM}
procedure TForm1.Button1Click(Sender: TObject);
begin
  Form2.SizeGrid:=(cbTaille.itemindex+1)*4;
  if cbtaille.itemindex=4 then Form2.SizeGrid:=32;
  Form2.show;
end;

procedure TForm1.jpg2bmp(JpgFilePath : string; BmpSavePath : string);
var
  bmp : TBitmap;
  Jpg : TJpegImage;
begin
  bmp := TBitmap.Create;
  jpg := TJpegImage.Create;
  try
    jpg.LoadFromFile (jpgfilepath);
    bmp.Assign(jpg);
    bmp.SaveToFile (BmpSavePath + '.bmp');

  finally
    jpg.Free;
    bmp.Free;
  end;
end;

procedure TForm1.Convert1Click(Sender: TObject);
begin
  if convert=true then
     deletefile('temp.bmp');

  Opendialog1.Filter:='*.jpg';

  if opendialog1.execute then
     begin
       convert:=true;
       jpg2bmp(opendialog1.filename,'.\temp');

       with Form2 do
       begin
         filename:='.\temp.bmp';
         image1.Picture.LoadFromFile(filename);
         Image2.Picture.LoadFromFile(filename);
         init;
         start:=true;
         DrawGrid;
       end;
     end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if convert=true then
     deletefile('temp.bmp');

  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName) + 'Img';

  if OpenDialog1.execute then
     begin
       convert:=false;
       with Form2 do
       begin
         filename:=opendialog1.filename;
         image1.Picture.LoadFromFile(filename);
         Image2.Picture.LoadFromFile(filename);
         init;
         start:=true;
         DrawGrid;
       end;
     end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Form2.close;
  Form1.close;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  button2Click(self);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  cbTaille.ItemIndex:=0;
  convert:=false;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if convert=true then
     deletefile('temp.bmp');
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if NOT (Key in [#08, '0'..'9']) then
    Key := #0;
end;

end.
