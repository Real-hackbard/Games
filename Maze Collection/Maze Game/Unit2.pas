unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, XPMan;

type
  TForm2 = class(TForm)
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FColorKey: TCOLOR;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

const   LWA_COLORKEY = 1;
        LWA_ALPHA     = 2;
        WS_EX_LAYERED = $80000;

implementation

uses Unit1;

{$R *.dfm}
function MakeWindowTransparent(Wnd: HWND; nAlpha: Integer = 10): Boolean;
type
  TSetLayeredWindowAttributes = function(hwnd: HWND; crKey: COLORREF; bAlpha: Byte;
    dwFlags: Longint): Longint;
  stdcall;
var
  hUser32: HMODULE;
  SetLayeredWindowAttributes: TSetLayeredWindowAttributes;
begin
  Result := False;
  hUser32 := GetModuleHandle('USER32.DLL');
  if hUser32 <> 0 then
  begin
    @SetLayeredWindowAttributes := GetProcAddress(hUser32,
    'SetLayeredWindowAttributes');
    if @SetLayeredWindowAttributes <> nil then
    begin
      SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) or
                                                    WS_EX_LAYERED);
      SetLayeredWindowAttributes(Wnd, 0, Trunc((255 / 100) * (100 - nAlpha)),
                                                    LWA_ALPHA);
      Result := True;
    end;
  end;
end;

function SetLayeredWindowAttributes( Wnd: hwnd; crKey: ColorRef;
  Alpha: Byte; dwFlags: DWORD): Boolean; stdcall; external 'user32.dll';

procedure TForm2.Button1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Form1.Shape1.Left := SpinEdit1.Value;
  Form1.Shape1.Top := SpinEdit2.Value;
  Form1.StatusBar1.Panels[6].Text := IntToStr(Form1.Shape1.Left)+'x'+
                                       IntToStr(Form1.Shape1.Top);
  Application.ProcessMessages;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle,
                        GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(Handle, ColorToRGB(FColorKey), 230, LWA_ALPHA);
  SetWindowPos(Handle, HWND_TOPMOST, Left,Top, Width,Height,
             SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  SpinEdit1.Value := Form1.Shape1.Left;
  SpinEdit2.Value := Form1.Shape1.Top;
end;

end.
