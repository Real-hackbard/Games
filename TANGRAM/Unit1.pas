unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, pieces, Menus, shellapi, XPMan;

type
  TForm1 = class(TForm)
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    LoadPiecebtn: TButton;
    RestartBtn: TButton;
    NextBtn: TButton;
    SolveBtn: TButton;
    PrevBtn: TButton;
    ExitBtn: TButton;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RestartBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure LoadPiecebtnClick(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PrevBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Tangram:TTangram;
    figfile:string;
    procedure setcaption;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{***************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  Tangram:=TTangram.createTangram(self,rect(0,0,panel1.left,
      clientheight),false);
  Doublebuffered:=true; {eliminate flicker}
  Open1Click(self);     {get a figures file}
end;

{**************** FormClose **************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 tangram.free;
end;

{**************** RestartBtnClck **********}
procedure TForm1.RestartBtnClick(Sender: TObject);
begin
  tangram.restart;
end;

procedure TForm1.NextBtnClick(Sender: TObject);
begin
  with tangram do showfigure(curfig+1);
  setcaption;
end;
                  
procedure TForm1.PrevBtnClick(Sender: TObject);
begin
  with tangram do showfigure(curfig-1);
  setcaption;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  if opendialog1.execute then
  begin
    OpenDialog1.initialdir := ExtractFileName(Application.Exename);
      with tangram do
      begin
        loadfigset(opendialog1.filename);
        figfile:=opendialog1.filename;
        showfigure(1);
        setcaption;
      end;
  end;
end;

procedure TForm1.LoadPiecebtnClick(Sender: TObject);
begin
  Open1click(sender);
end;

procedure TForm1.SolveBtnClick(Sender: TObject);
begin
   tangram.showsolution;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 // b:TBitmap;
  f:string;
begin
   with tangram do
   if (dragnbr>0) and ((key=ord('F')) or (key=ord('f')))
   then
   begin
     piece[dragnbr].flip;
     invalidate;
   end
   else if ((key=ord('S')) or (key=ord('s'))) then
   begin
     {save figure as a bitmap}
     b:=tbitmap.create;
     b.width:=tangram.width;
     b.height:=tangram.height;
     tangram.painttobitmap(b);
     f:=extractfilename(figfile);
     delete(f,pos('.',f),4);

     f:=extractfilepath(application.exename)+trim(f)+'_Fig'+
                                      inttostr(curfig)+'.bmp';
     b.savetofile(f);
     b.free;
   end;
end;

procedure TFOrm1.setcaption;
begin
  Caption:='TANGRAM - '+Uppercase(extractfilename(figfile))+
           ',  Figure '+inttostr(tangram.curfig)
           + ' of '+ inttostr(tangram.nbrfigures);
end;

procedure TForm1.ExitBtnClick(Sender: TObject);
begin
  close;
end;

end.

