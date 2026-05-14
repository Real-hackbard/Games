unit Player;
 {
  This program may be used or modified for any non-commercial purpose
  so long as this original notice remains in place.
  All other rights are reserved

  This dialog is called to get the secret word from the human hangman when
  the computer is allowed to help score convict responses}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, dialogs;

type
  TForm4 = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    HangmanPanel: TPanel;
    WordEdt: TEdit;
    HideBox: TCheckBox;
    procedure HideBoxClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    public
      maxwordsize:integer;
  end;

var
  Form4: TForm4;

implementation

Uses UDict, Unit1;

{$R *.DFM}

{**************** HideBoxClick ***************}
procedure TForm4.HideBoxClick(Sender: TObject);
{Show or hide the human hangman's word as it's typed}
begin
   if Hidebox.checked then wordedt.passwordchar:='*'
   else wordedt.passwordchar:=#0;
end;

procedure TForm4.FormActivate(Sender: TObject);
begin
   wordedt.text:='';
   wordedt.setfocus;
   maxwordsize:=form1.maxwordlen;
   caption:='Hangman - Enter a secret word up to '+ inttostr(maxwordsize) +' characters';
end;

procedure TForm4.OKBtnClick(Sender: TObject);
var
  A,F,C:boolean;  {abbreviation, foreign, capitalized}
begin
  modalresult:=MrNone;
  if length(wordedt.text)>maxwordsize
  then showmessage('Word may not exceed '+inttostr(maxwordsize) +' at current level'
                   +#13+'Try again')
  else
  if (pubdic.lookup(wordedt.text, A,F,C))
     and (not A) and (not F) and (not C) then modalresult:=MrOK
  else showmessage('Sorry, that word is not recognized here, try again');
  if modalresult=MrNone then wordedt.text:=''; {clear word if we're not leaving}
end;

end.
