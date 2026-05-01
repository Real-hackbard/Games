unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    StatusBar1 : TStatusBar;
    MainMenu1: TMainMenu;
    Choisir1: TMenuItem;
    Quitter1: TMenuItem;
    ListBox1: TListBox;
    procedure FormActivate(Sender : TObject);
    procedure FormMouseDown(Sender : TObject;Button : TMouseButton;
              Shift : TShiftState;X,Y : Integer);
    procedure MenuClick(Sender : TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Declarations privates }
  public
    { Declarations public }
  end;
const
     side = 32;
     maxlevel = 20;
     but : array[1..maxlevel] of Integer =
                    (6,31,27,13,11,24,30,18,41,13,18,5,14,15,14,28,17,38,26,27);
type
    Pview = ^Tview;
    Tview = record
                 pt : TPoint;
                 c,d,a,v : Byte; { c : In progress
                                   d : Beginning
                                   a : Previous
                                   v : Empty (ground or target)
                                value
                                    0 = red exterior
                                    1 = black wall
                                    2 = white floor
                                    3 = yellow crate
                                    4 = blue target
                                    5 = crate on gray target
                                    6 .. 9 = clark green
                                    10..13 = Clark type lift  }
           end;
var
   Form1 : TForm1;
   Abi : array[1..9] of TBitmap;    // Elements of the decor
   sens,                            // 0 on the left, 1 on the right, 2 at the top, 3 at the bottom
   nivo : Byte;
   VLeft,head,                      // Margins
   long,high,                       // Decor dimensions
   sco : Integer;                   // Score
   target,place : TPoint;           // Elevator movement
   LView : TList;

implementation

{$R *.DFM}
{$R DECOR.RES}
{$R floor.RES}

procedure Watch(bmp : TBitmap;x,y : Integer);
begin
     Form1.Canvas.Draw(x,y,bmp);
end;

procedure Decode(var bmx,bmp : TBitmap);
// Trace the scenery by reading the bitmap
var
   i,j : Byte;
   c : TColor;
begin
     for i := 0 to side do
     for j := 0 to side do
     begin
          c := bmx.Canvas.Pixels[i,j];
          with bmp.Canvas do
          if c = RGB(255,0,0) then Pixels[i,j] := Abi[2].Canvas.Pixels[i,j]
                              else Pixels[i,j] := c;
     end;
end;

procedure Vignette;
var
   i : Byte;

   procedure TourneH(B1,B2 : TBitMap);
   begin
        StretchBlt(B2.Canvas.Handle,0,0,B2.Width,B2.Height,
        B1.Canvas.Handle,B1.Width,0,- B1.Width,B1.Height,srcCopy);
   end;

   procedure TourneV(B1,B2 : TBitMap);
   begin
        StretchBlt(B2.Canvas.Handle,0,0,B2.Width,B2.Height,
        B1.Canvas.Handle,0,B1.Height,B1.Width,- B1.Height,srcCopy);
   end;

   procedure TourneX(B1,B2 : TBitMap);
   var
      i,j : Integer;
      c : TColor;
   begin
        for i := 0 to B1.Width do for j := 0 to B1.Height do
        begin
             c := B1.Canvas.Pixels[i,j];
             B2.Canvas.Pixels[B1.Height - 1 - j,i] := c;
        end;
   end;

begin
     for i := 1 to 9 do
     begin
          Abi[i] := TBitmap.Create;
          with Abi[i] do
          begin
               Width := side;
               Height := side;
               case i of
                    1 : LoadFromResourceName(HInstance,'MUR');
                    2 : LoadFromResourceName(HInstance,'SOL');
                    3 : LoadFromResourceName(HInstance,'CAISSE');
                    4 : begin
                             LoadFromResourceName(HInstance,'CIBLE');
                             Decode(Abi[i],Abi[i]);
                        end;
                    5 : LoadFromResourceName(HInstance,'PLACE');
                    6 : begin
                             LoadFromResourceName(HInstance,'CLARK');
                             Decode(Abi[i],Abi[i]);
                        end;
                    7 : TourneH(Abi[6],Abi[i]);
                    8 : TourneX(Abi[6],Abi[i]);
                    9 : TourneV(Abi[6],Abi[i]);
               end;
          end;
     end;
end;

procedure Construction;
var
   i,j,k,x,y : Integer;
   st : string;
   View : Pview;
   Color : TColor;
   des1 : TBitmap;
begin
     Form1.Refresh;
     LView.Clear;
     st := IntToStr(nivo);
     Form1.StatusBar1.Panels[0].Text := 'Best score : ' +
                               IntToStr(but[nivo]);
     Form1.StatusBar1.Panels[1].Text := '';
     if Length(st) < 2 then st := '0' + st;
     st := 'NIV' + st;
     des1 := TBitmap.Create;
     with des1 do
     begin
          LoadFromResourceName(HInstance,st);
          long := Width;
          high := Height;
     end;
     with Form1 do
     begin
          i := side * high;
          j := side * long;
          VLeft := (ClientWidth - j) div 2;
          head := (ClientHeight - i) div 2;

          Caption :=  'The mover is at the level ' + IntToStr(nivo);
     end;
     for j := 0 to high - 1 do for i := 0 to long - 1 do
     begin
          x := i * side + VLeft;
          y := j * side + head;
          Color := des1.Canvas.Pixels[i,j];                   // Pixel color
          if Color = RGB(255,0,0) then k := 0                 // red = outside
          else
          if Color = RGB(0,0,0) then k := 1                   // black = wall
          else
          if Color = RGB(255,255,255) then k := 2             // white = ground
          else
          if Color = RGB(255,255,0) then k := 3               // yellow = crate
          else
          if Color = RGB(0,0,255) then k := 4                 // blue = target
          else
          if Color = RGB(128,128,128) then k := 5             // gray = target occupied
          else
          if Color = RGB(0,255,0) then k := 6;                // green = clark
          if (k > 0) and (k < 7) then Watch(Abi[k],x,y);
          if k = 6 then
          begin
               place.x := x;
               place.y := y;
               k := 2;
          end;
          if k > 1 then
          begin
               New(View);
               with View^ do
               begin
                    pt.x := x;
                    pt.y := y;
                    c := k;
                    d := k;
                    a := k;
                    if (k = 2) or (k = 3) or (k = 6) then v := 2;
                    if (k = 4) or (k = 5) then v := 4;
               end;
               LView.Add(View);
          end;
     end;
     des1.Free;
     target := place;
end;

procedure TForm1.FormActivate(Sender: TObject);
var
   i : Byte;
begin
     nivo := 1;
     sco := 0;
     with Form1 do
     begin
          Caption := 'Put away all the crates.';
          Color := clInfoBk;
          Color := RGB(5,0,57);
          Width := 560;
          Height := 630;
          Left := (Screen.Width - Width) div 2;
          Top := (Screen.Height - Height) div 2;
          Refresh;
     end;
     for i := 1 to maxlevel do ListBox1.Items.Add('Level ' + IntToStr(i));
     ListBox1.Height := ListBox1.ItemHeight * (maxlevel + 1);
     ListBox1.Top := 2;
     ListBox1.Visible := False;
     Vignette;
     Construction;
end;

procedure EndLevel;
var
   st : string;
begin
     st := 'You have completed the level ' + IntToStr(nivo) + #13#10;
     if but[nivo] = sco then st := st + 'You equal the best score (' +
                             IntToStr(sco) + ')' + #13#10 +
                             'Thats good work !!'
     else
     if but[nivo] < sco then st := st + 'Your score (' +
                             IntToStr(sco) + ') can be improved.' + #13#10 +
                             'Peut mieux faire !!'
     else
     if but[nivo] > sco then st := st + 'Your score (' +
                             IntToStr(sco) + ') is lower.' + #13#10 +
                             'You are the best !!';
     ShowMessagePos(st,Form1.Left - 100,Form1.Top - 50);
     Form1.Refresh;
     Inc(nivo);
     sco := 0;
     if nivo <= maxlevel then Construction
                       else
     begin
          Form1.Caption :=  'The mover is going to rest';
          ShowMessage('The tidying up is finished.' +
                            #13#10 + 'See you soon, I hope..');
     end;
end;

function Xy(p : TPoint) : Pview;
var
   ok : Boolean;
   i : Integer;
   Xvue : Pview;
begin
     i := 0;
     ok := True;
     while (i < LView.Count) and ok do
     begin
          Xvue := LView.Items[i];
          if (Xvue^.pt.x = p.x) and (Xvue^.pt.y = p.y) then ok := False
                                                       else Inc(i);
     end;
     if ok then Result := nil
           else Result := Xvue;
end;

procedure Move;
{value
       0 = outside
       1 = wall
       2 = ground
       3 = box
       4 = target
       5 = crate on target
       6 .. 9 = clark
       10..13 = survey }
var
   mur,ok : Boolean;
   i,px,cx : Integer;
   avt,k : TPoint;
   Avue,Bvue,Cvue : Pview;
begin
     mur := True;
     for i := 0 to LView.Count - 1 do
     begin
          Avue := LView.Items[i];
          Avue^.a := Avue^.c;
     end;
     px := place.x + place.y;
     cx := target.x + target.y;
     k.x := 0;
     k.y := 0;
     case sens of
          0 : k.x := - side;      // to the left
          1 : k.x := side;        // to the right
          2 : k.y := - side;      // up
          3 : k.y := side;        // down
     end;
     while (px <> cx) and mur do
     begin
          Avue := Xy(place);
          avt := place;
          Bvue := nil;
          Cvue := nil;
          ok := False;
          if Avue <> nil then
          begin
               avt.x := avt.x + k.x;
               avt.y := avt.y + k.y;
               Bvue := Xy(avt);
               if Bvue <> nil then
               begin
                    if (BVue^.c = 2) or (BVue^.c = 4) then ok := True  { ground or target }
                    else
                    if (BVue^.c = 3) or (BVue^.c = 5) then             { box }
                    begin
                         avt.x := avt.x + k.x;
                         avt.y := avt.y + k.y;
                         Cvue := Xy(avt);
                         if Cvue <> nil then
                         begin
                              if CVue^.c = 2 then  { ground }
                              begin
                                   CVue^.c := 3;   { box }
                                   ok := True;
                              end
                              else
                              if CVue^.c = 4 then  { target }
                              begin
                                   CVue^.c := 5;   { crate on target }
                                   ok := True;
                              end
                              else mur := False;
                         end
                         else mur := False;
                    end
                    else mur := False;
               end
               else mur := False;
          end
          else mur := False;
          if ok then
          begin
               AVue^.c := AVue^.v;
               Watch(Abi[AVue^.c],AVue^.pt.x,AVue^.pt.y);
               if CVue <> nil then
               begin
                    BVue^.c := 6 + sens;
                    Watch(Abi[BVue^.c],BVue^.pt.x,BVue^.pt.y);
                    Watch(Abi[CVue^.c],CVue^.pt.x,CVue^.pt.y);
                    Inc(sco);
                    Form1.StatusBar1.Panels[1].Text := ' Your score : ' + IntToStr(sco);
               end
               else
               begin
                    BVue^.c := 6 + sens;
                    Watch(Abi[BVue^.c],BVue^.pt.x,BVue^.pt.y);
               end;
               place := BVue^.pt;
               px := place.x + place.y;
          end;
     end;
     i := 0;
     mur := True;
     while (i < LView.Count) and mur do
     begin
          Avue := LView.Items[i];
          if Avue^.c = 3 then mur := False     { box }
                         else Inc(i);
     end;
     if mur then EndLevel;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     x := ((x - VLeft) div side) * side + VLeft;
     y := ((y - head) div side) * side + head;
     sens := 4;
     if y = place.y then
     begin
          if x < place.x then sens := 0       // to the left
          else
          if x > place.x then sens := 1;      // to the right
     end
     else
     if x = place.x then
     begin
          if y < place.y then sens := 2       // up
          else
          if y > place.y then sens := 3;      // down
     end;
     if sens < 4 then
     begin
          target.x := x;
          target.y := y;
          Move;
     end;
end;

procedure TForm1.MenuClick(Sender: TObject);
var
   id : Byte;
begin
     id := (Sender as TMenuItem).Tag;
     case id of
        1 : begin
                 ListBox1.Visible := True;
                 ListBox1.ItemIndex := nivo - 1;
                 ListBox1.SetFocus;
            end;

        3 : begin
                 for id := 1 to 9 do Abi[id].Free;
                 Application.Terminate
            end;
     end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
     nivo := ListBox1.ItemIndex + 1;
     ListBox1.Visible := False;
     sco := 0;
     Construction;
end;

initialization
// Creating the list
  LView := TList.Create;

finalization
// List destruction
  LView.Free;

end.
