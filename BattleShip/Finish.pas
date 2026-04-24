unit Finish;     // Endgame routines

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TForm4 = class(TForm)
    OKBtn: TButton;
    Ccoule: TImage;
    Image1: TImage;
    Panel1: TPanel;

    procedure Poster(won : byte);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  won : byte;

implementation

{$R *.DFM}

procedure TForm4.Poster(won : byte);
begin
  case won of
    0,
    1 : begin
          //Form4.Color := clYellow;
          if won = 0 then
            Form4.Panel1.Caption := 'Pirates Abandoned !'
          else Form4.Panel1.Caption := 'Sunken Pirates';
          Form4.Image1.Visible := true;
        end;
    2 : begin
         Form4.Color := clAqua;
         Form4.Panel1.Caption := 'Poor corsairs';
         Form4.Image1.Visible := false;
       end;
  end;
end;

procedure TForm4.FormActivate(Sender: TObject);
begin
  Poster(won);
end;

end.
