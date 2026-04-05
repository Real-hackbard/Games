unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, pngimage, Menus, StdCtrls, ExtCtrls, ExtDlgs, XPMan;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Image2: TImage;
    Panel3: TPanel;
    Image3: TImage;
    Panel4: TPanel;
    Image4: TImage;
    Panel5: TPanel;
    Image5: TImage;
    Panel6: TPanel;
    Image6: TImage;
    Panel7: TPanel;
    Image7: TImage;
    Panel8: TPanel;
    Image8: TImage;
    Panel9: TPanel;
    Image9: TImage;
    Panel10: TPanel;
    Image10: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    OpenSet1: TMenuItem;
    SaveSet1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    NewSet1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    SaveDialog1: TSaveDialog;
    Edit1: TEdit;
    Label11: TLabel;
    OpenDialog1: TOpenDialog;
    procedure Image2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NewSet1Click(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SaveSet1Click(Sender: TObject);
    procedure OpenSet1Click(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses PCSApi;

var
  PCSImages : TPCSImages;
  Images    : array[0..9] of TImage;
  ImgCheck  : array[0..9] of boolean;

function OkForSave : boolean;
var
  i : integer;
begin
  result := true;
  for i := 0 to 9 do
      result := result and ImgCheck[i];
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to 9 do begin
      PCSImages[i] := TPngObject.Create;
      ImgCheck[i] := false;
  end;
  Images[0] := Image1;
  Images[1] := Image2;
  Images[2] := Image3;
  Images[3] := Image4;
  Images[4] := Image5;
  Images[5] := Image6;
  Images[6] := Image7;
  Images[7] := Image8;
  Images[8] := Image9;
  Images[9] := Image10;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to 9 do
      PCSImages[i].Free;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  If OpenPictureDialog1.Execute then
     with (Sender as TImage) do
          if LoadImage(OpenPictureDialog1.FileName,PCSImages,tag) then
          begin
             Picture.LoadFromFile(OpenPictureDialog1.FileName);
             ImgCheck[tag] := true;
          end;
end;

procedure TForm1.NewSet1Click(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to 9 do begin
      PCSImages[i].Free;
      PCSImages[i] := TPNGObject.Create;
      ImgCheck[i]  := false;
      Images[i].Picture.Graphic := nil;
  end;
end;

procedure TForm1.File1Click(Sender: TObject);
begin
  SaveSet1.Enabled := OkForSave;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  form1.Close;
end;

procedure TForm1.SaveSet1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
     if SaveCardsSet(SaveDialog1.FileName,PCSImages,Edit1.text) then
        MessageDlg('Backup successful.',mtInformation,[mbOk],0)
     else
        MessageDlg('Backup failed.',mtWarning,[mbOk],0);
end;

procedure TForm1.OpenSet1Click(Sender: TObject);
var
  i : integer;
  n : string;
begin
  if OpenDialog1.Execute then
     if PCSApi.LoadCardsSet(OpenDialog1.FileName,PCSImages,n) then begin
        Edit1.Text := n;
        for i := 0 to 9 do begin
            Images[i].Picture.Graphic := PCSImages[i];
            ImgCheck[i] := true;
        end;
     end else
        MessageDlg('PCS file error, unknown format or corrupted file.',mtWarning,[mbOk],0);
end;

end.
 