unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;
  
type
  THelpFrm = class(TForm)
    OkBtn: TButton;
    Label1: TLabel;
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    private
    { Private declarations }
    public
    { Public declarations }
  end;
  
var
  HelpFrm: THelpFrm;
  
implementation

uses Unit1;
  
{$R *.DFM}

procedure THelpFrm.OkBtnClick(Sender: TObject);
begin
  Close;
end;

procedure THelpFrm.FormCreate(Sender: TObject);
begin
  Label1.Caption:= 'To start playing, press Start or F1.'+
  Chr(10)+Chr(13);
  Label1.Caption:= Label1.Caption+'To stop the game, press Stop or F3.'+
  Chr(10)+Chr(13);
  Label1.Caption:= Label1.Caption+'To move, you need to use the mouse. ';
  Label1.Caption:= Label1.Caption+'To exit the game, press ESC or Quit.'+
  Chr(10)+Chr(13)+Chr(10)+Chr(13)+'Good luck!';
end;

end.
