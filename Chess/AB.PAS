unit ab;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    OKButton: TButton;
    Label1: TLabel;
  private
    { declarations privates }
  public
    { declarations public }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

end.

