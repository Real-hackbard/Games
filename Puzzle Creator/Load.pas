unit Load;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, JPEG, StdCtrls, Buttons, ExtCtrls, FileCtrl;

type
  TForm3 = class(TForm)
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    FileListBox1: TFileListBox;
    Image1: TImage;
    Label1: TLabel;
    procedure FileListBox1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DriveComboBox1Click(Sender: TObject);
  private
    { Declarations private }
  public
    { Declarations public }
     function DiskInDrive(Drive: Char): Boolean;
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

uses Unit1;

var
  firstaig : boolean;

function Tform3.DiskInDrive(Drive: Char): Boolean;
var
  ErrorMode: word;
begin
  if Drive in ['a'..'z'] then Dec(Drive, $20);
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    if DiskSize(Ord(Drive) - $40) = -1 then
      Result := False
    else
      Result := True;
  finally
    SetErrorMode(ErrorMode);
  end;
end;

procedure TForm3.FileListBox1Click(Sender: TObject);
const
  K = 136;
Var
  w0, h0 : single;
  w, h   : single;
  kk : single;
begin
  IF filelistbox1.items.count < 1 then exit;
  IF filelistbox1.filename = '' then exit;
  IF Diskindrive(Drivecombobox1.drive) = False Then
  Begin
    Showmessage('CD-ROM or floppy disk not ready');
    exit;
  end;
  Image1.visible := false;
  Image1.width  := K;
  Image1.height := K;
  try
    Image1.Picture.LoadFromFile(FileListbox1.Filename);
  except
    on EInvalidGraphic do
    begin
      Image1.Picture.Graphic := nil;
      exit;
    end;
  end;
  IF Image1.Picture.Graphic is TJPEGImage then
  begin
    with TJPEGImage(Image1.Picture.Graphic) do
    begin
      PixelFormat := TJPEGPixelFormat(0);
      Scale := TJPEGScale(jsfullsize);
    end;
    Image1.IncrementalDisplay := False;
  end;
  
  w0 := Image1.picture.graphic.width;
  h0 := Image1.picture.graphic.height;
  Form1.Bmp0.free;
  Form1.Bmp0 := Tbitmap.create;
  Form1.bmp0.width  := Image1.picture.graphic.width;
  Form1.bmp0.height := Image1.picture.graphic.height;
  Form1.bmp0.canvas.draw(0,0,Image1.picture.graphic);
  w := w0;
  h := h0;

  IF (w0 > K) OR (h0 > K) then
  begin
    KK := K;
    IF w0 > h0 then
    begin
      w := kk;
      h := (kk * h0) / w0;
    end
    else
    begin
      h := kk;
      w := (kk*w0) / h0;
    end;
  end;
  Image1.width  := trunc(w);
  Image1.height := trunc(h);

  Label1.caption := 'Size '+ inttostr(Image1.picture.graphic.width) +
                    ' x ' + Inttostr(Image1.picture.graphic.height);

  Image1.left := (Panel1.width  - Image1.width ) div 2;
  Image1.top  := (Panel1.height - Image1.height) div 2;
  Image1.visible := true;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  Filelistbox1.setfocus;
  if firstaig then
  begin
    firstaig := false;
    Filelistbox1click(sender);
  end;
end;

procedure TForm3.DirectoryListBox1Change(Sender: TObject);
begin
  If form1.firsttime then exit;
  IF Diskindrive(Drivecombobox1.drive) = False Then
  Begin
    Showmessage('CD-ROM or floppy disk not ready');
    exit;
  end;
  Filelistbox1.Itemindex := 0;
  Filelistbox1click(sender);
  Filelistbox1.setfocus;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  firstaig := true;
end;

procedure TForm3.DriveComboBox1Click(Sender: TObject);
begin
 IF Diskindrive(Drivecombobox1.drive) = False Then
    Showmessage('CD-ROM or floppy disk not ready');
end;

end.
