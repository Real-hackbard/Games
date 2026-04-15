unit Unit1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Game, Graphic, Menus, XPMan, StdCtrls;

const
  vonlinks = 60;
  vonoben = 200;
type
  TForm1 = class(TForm)
    Shape1: TShape;
    MainMenu1: TMainMenu;
    Start1: TMenuItem;
    Close1: TMenuItem;
    Game1: TMenuItem;
    P1: TMenuItem;
    MI_sp_sp: TMenuItem;
    MI_sp_co: TMenuItem;
    MI_co_sp: TMenuItem;
    MI_co_co: TMenuItem;
    S1: TMenuItem;
    MI_staerke1: TMenuItem;
    mi_staerke2: TMenuItem;
    MI_staerke3: TMenuItem;
    MI_staerke4: TMenuItem;
    Timer1: TTimer;
    Info1: TMenuItem;
    D1: TMenuItem;
    V1: TMenuItem;
    N1: TMenuItem;
    A1: TMenuItem;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Start1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MI_sp_spClick(Sender: TObject);
    procedure MI_staerke1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Spiel: TSpiel;
    aktStab: TZug;
    Spielerzug: TZug;
    ProgrammBeendet: boolean;
    MaxSuchtiefe: integer;
    procedure SetzeStein(amZug: TSpieler; Zug: TZug);
    procedure Entferne_Kugeln;
    procedure Spielablauf;
    procedure Siegerehrung;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
procedure TForm1.SetzeStein(amZug: TSpieler; Zug: TZug);
var
  s: TShape;
  z: integer;
  i: integer;
begin
   { Place ball }
   z:= Spiel.ZKoordinateVonZug(Spiel.Position,Zug);
   s:= TShape.Create(Form1);
   s.Parent:= Form1;
   s.Height:= 25-Zug.y*2;
   s.Width:= 25-Zug.y*2;

   if amZug = Spieler1
     then
      s.Brush.Color:= clBlue
     else
      s.Brush.Color:= clRed;

   s.Pen.Color:= clBlack;
   s.Shape:= stCircle;
   s.Left:= vonLinks + Zug.x*80+Zug.y*40-(s.Width-Shape1.Width)
                                          div 2-Zug.x*Zug.y*4;;
   s.Top:= vonOben-Zug.y*60+105-(z+1)*(25-Zug.y*3);
   s.Name:= 'Ball_'+IntToStr(Zug.x)+IntToStr(Zug.y)+IntToStr(z);
   s.OnMouseMove:= Shape1MouseMove;
   s.OnMouseDown:= Shape1MouseDown;
   { Set rod }
   s:= TShape.Create(Form1);
   s.Parent:= Form1;
   s.Height:= 10-Zug.y;
   s.Width:= 9;
   s.Brush.Color:= clOlive;
   s.Pen.Color:= clOlive;
   s.Shape:= stRoundRect;
   s.Left:= vonLinks+ Zug.x*80+Zug.y*40-Zug.x*Zug.y*4;
   s.Top:= vonOben-Zug.y*60+105-(z+1)*(25-Zug.y*3)-Zug.y div 2;
   s.Name:= 'Stab_'+IntToStr(Zug.x)+IntToStr(Zug.y)+IntToStr(z);
   s.OnMouseMove:= Shape1MouseMove;
   s.OnMouseDown:= Shape1MouseDown;

   { Execute move }
   Spiel.Ausfuehren(Spiel.Position,Zug,Spiel.Position);
   for i:= 0 to ComponentCount-1
   do if (Components[i] is TShape) and
         (copy((Components[i] as TShape).name,1,4)='Stab') and
         (StrToInt((Components[i] as TShape).name[6])=Zug.x) and
         (StrToInt((Components[i] as TShape).name[7])=Zug.y)
      then begin
             (Components[i] as TShape).Brush.Color:= clYellow;
             (Components[i] as TShape).Pen.Color:= clYellow
           end
      else if (Components[i] is TShape) and (copy((Components[i] as TShape).name,1,4) = 'Stab')
           then begin
                  (Components[i] as TShape).Brush.Color:= clOlive;
                  (Components[i] as TShape).Pen.Color:= clOlive;
                end;
end;

procedure TForm1.Entferne_Kugeln;
var
  i: integer;
begin
  for i:= ComponentCount-1 downto 0
  do begin
       if (Components[i] is TShape) and
          ( length((Components[i] as TShape).Name)=8)
          then begin
                 Components[i].free;
               end;
     end;
end;

procedure TForm1.Siegerehrung;
begin
  Timer1.enabled:= true;
end;

procedure TForm1.Spielablauf;
var
  Zug: TZug;
  j: integer;
  h: longint;
begin
  Spiel.Free;
  Entferne_Kugeln;
  Spiel:= TSpiel.Create(Keiner,Keiner,MaxSuchtiefe);
  if MI_sp_sp.checked or MI_sp_co.checked
    then Spiel.Spielertyp[1]:= Mensch
    else Spiel.Spielertyp[1]:= Computer;
  if MI_sp_sp.checked or MI_co_sp.checked
    then Spiel.Spielertyp[2]:= Mensch
    else Spiel.Spielertyp[2]:= Computer;
  while (not Spiel.amEnde(Spiel.Position)) and
        (not ProgrammBeendet)
  do begin
       application.ProcessMessages;
       if Spiel.Spielertyp[Spiel.Position.amZug]=Mensch
       then begin
              Spielerzug.x:= -1;
              Spielerzug.y:= -1;
              while (Spielerzug.x=-1) and (not ProgrammBeendet)
              do application.ProcessMessages;
              Zug:= Spielerzug;
            end
       else begin
              Zug:= Spiel.Computerzug(h);
            end;
       if not ProgrammBeendet
       then SetzeStein(Spiel.Position.amZug,Zug);
     { messagedlgpos(inttostr(h),mtcustom,[mbyes],0,0,0); }
       RePaint;
    end;
    if (Spiel.Reihensummenhaeufigkeit(Spiel.Position)[4]>0) or
       (Spiel.Reihensummenhaeufigkeit(Spiel.Position)[20]>0)
    then Siegerehrung;
    for j:= 0 to 3
    do if Spiel.Position.amZug = Spieler1
       then Spiel.Position.Feld[Spiel.Siegreihe[j].x,Spiel.Siegreihe[j].y,Spiel.Siegreihe[j].z]:= 2
       else Spiel.Position.Feld[Spiel.Siegreihe[j].x,Spiel.Siegreihe[j].y,Spiel.Siegreihe[j].z]:= 4;

    Spiel.Spielertyp[1]:= Keiner;
    Spiel.Spielertyp[2]:= Keiner;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  x,y: integer;
  s: TShape;
begin
  randomize;
  for x:= 0 to 3
  do for y:= 0 to 3 do
     begin
       s:= TShape.Create(Form1);
       s.Parent:= Form1;
       s.Height:= 105-y*12;
       s.Width:= 9;
       s.Brush.color:= clOlive;
       s.Pen.color:= clOlive;
       s.Shape:= stRoundRect;
       s.Left:= vonLinks+x*80+y*40-x*y*4;
       s.Top:= vonOben-y*60+y*12;
       s.Name:= 'Stab_'+IntToStr(x)+IntToStr(y);
       s.OnMouseMove:= Shape1MouseMove;
       s.OnMouseDown:= Shape1MouseDown;
     end;
  AktStab.x:= -1;
  AktStab.y:= -1;
  MaxSuchtiefe:= 2;
  Spiel:= TSpiel.Create(Keiner,Keiner,MaxSuchtiefe);
  ProgrammBeendet:= false;
end;

procedure TForm1.Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i: integer;
begin
  if Spiel.Spielertyp[Spiel.Position.amZug]=Mensch
  then begin
         AktStab.x:= StrToInt((Sender as TShape).Name[6]);
         AktStab.y:= StrToInt((Sender as TShape).Name[7]);
         for i:= 0 to ComponentCount-1
         do if (Components[i] is TShape) and
               (copy((Components[i] as TShape).name,1,4)='Stab') and
               ((StrToInt((Components[i] as TShape).name[6])<>AktStab.x) or
               (StrToInt((Components[i] as TShape).name[7])<>AktStab.y))
               then begin
                      if (Components[i] as TShape).Brush.Color<>clYellow
                      then begin
                             (Components[i] as TShape).Brush.Color:= clOlive;
                             (Components[i] as TShape).Pen.Color:= clOlive;
                           end;
                    end;
         for i:= 0 to ComponentCount-1
         do if (Components[i] is TShape) and
               (copy((Components[i] as TShape).name,1,4)='Stab') and
               (StrToInt((Components[i] as TShape).name[6])=AktStab.x) and
               (StrToInt((Components[i] as TShape).name[7])=AktStab.y)
               then begin
                      (Components[i] as TShape).Brush.Color:= clLime;
                      (Components[i] as TShape).Pen.Color:= clLime;
                    end;
       end;
end;

procedure TForm1.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
begin
  if (Spiel.Spielertyp[Spiel.Position.amZug]=Mensch) and
     (Spiel.zulaessig(Spiel.Position,AktStab))
  then begin
         Spielerzug:= AktStab;
         for i:= 0 to ComponentCount-1
         do if (Components[i] is TShape) and
               (copy((Components[i] as TShape).name,1,4)='Stab')
               then begin
                      (Components[i] as TShape).Brush.Color:= clOlive;
                      (Components[i] as TShape).Pen.Color:= clOlive;
                    end;
         AktStab.x:= -1;
         AktStab.y:= -1;
       end;
end;

procedure TForm1.Start1Click(Sender: TObject);
begin
  Timer1.enabled:= false;
  Spielablauf;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  ProgrammBeendet:= true;
  Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ProgrammBeendet:= true;
end;

procedure TForm1.MI_sp_spClick(Sender: TObject);
begin
  mi_sp_sp.checked:= false;
  mi_sp_co.checked:= false;
  mi_co_sp.checked:= false;
  mi_co_co.checked:= false;
  (sender as TMenuItem).Checked:= true;
end;

procedure TForm1.MI_staerke1Click(Sender: TObject);
begin
  MI_staerke1.Checked := false;
  MI_staerke2.checked := false;
  MI_staerke3.checked := false;
  MI_staerke4.checked := false;
  (Sender as TMenuItem).checked:= true;
  MaxSuchtiefe:= StrToInt((Sender as TMenuItem).name[11])+1
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i, j: integer;
begin
  for j:= 0 to 3
  do for i:= 0 to ComponentCount-1
     do begin
          if (Components[i] is TShape) and
             ((Components[i] as TShape).Name = 'Ball_'+IntToStr(Spiel.Siegreihe[j].x)+
                                                       IntToStr(Spiel.Siegreihe[j].y)+
                                                       IntToStr(Spiel.Siegreihe[j].z))
          then begin
                 if (Components[i] as TShape).Brush.Color <> clWhite
                 then begin
                       (Components[i] as TShape).Brush.Color:= clWhite;
                      end
                 else begin
                        if Spiel.Position.amZug = Spieler1
                          then (Components[i] as TShape).Brush.Color:= clRed
                          else (Components[i] as TShape).Brush.Color:= clBlue;
                      end;
                 (Components[i] as TShape).Refresh;
               end;

        end;

end;

procedure TForm1.D1Click(Sender: TObject);
begin
  Form2.Show;
  Form2.Position:= Spiel.Position;
  Form2.Anzeigen;
end;

procedure TForm1.A1Click(Sender: TObject);
begin
  ShowMessage('Connect Four 3D'+#13+' Version 1.0');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Start1Click(self);
end;

end.
