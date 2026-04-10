{- VER 1.0  ----------------------------------------------------------}
{** 0.58 Added PacGum1.wav, PacGum2.wav and Points.wav to a RES}
{        to speed up the playback time of these sounds}
{        Adding the corresponding variables and LoadWav and FreeWav}
{** 0.59 Changes for sndPlaySound}
{        None of the sounds are played if 1 is in progress (SND_NOSTOP)}
{        except for PacGums, end of Pacman and beginning of the painting}
{        Added an immortality bonus}
{** 0.6x Changes to Speed ??Calculation}
{        Adding a life}
{        Deleting a score}

{Notes}
{-----}
{imgMem is used to draw tables and, most importantly, to erase behind them}
{ghosts so they don't blink.}
{imPlan is used for testing and a copy is used to search for PacMan}
{imgWork is used to display sprites. Faster than a TImage like}
{that of the Tab (imgMem)}

unit Unit1;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Buttons, ExtCtrls, MMSystem, IniFiles, ComCtrls;

const
  SIZE = 32;
  OFFSET = 2;
  WMBOUCLE = WM_USER+1000;
  SD = 0; SG = 1; SH = 2; SB = 3; sNONE = 5;
  clMUR = clWhite; clPOINTS = clBlack;
  clGUM = clBlue; clMANGE = clRed; clBONUS = clGreen;
  NBTEST = 18;

type
  TSprite = record
    Zone: TRect;
    Sens: integer;
    WantSens: integer;
    Trace: byte;
    aWantSens: array[1..NBTEST] of byte;
    More: byte;
    Pic: byte;
  end;

  TForm1 = class(TForm)
    imgMem: TImage;
    imgWork: TPaintBox;
    LabelPause: TPanel;
    Panel3: TPanel;
    LabelScore: TLabel;
    imgVie1: TImage;
    imgVie2: TImage;
    imgVie3: TImage;    
    Label7: TLabel;
    imgPoints: TImage;
    imgPacGum: TImage;
    imgGosths: TImage;
    imgPac: TImage;
    imgMur: TImage;
    CheckBox1: TCheckBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    TimerAnimP: TTimer;
    TimerAnimG: TTimer;
    Timer3: TTimer;
    Timer4: TTimer;
    TimerStart: TTimer;
    TimerBonus: TTimer;
    imgBonus: TImage;
    TrackBar1: TTrackBar;
    ForKey: TListBox;
    Bevel3: TBevel;
    MemoSpeed: TMemo;
    procedure FormDestroy(Sender: TObject);
    procedure imgWorkPaint(Sender: TObject);
    procedure TimerAnimPTimer(Sender: TObject);
    procedure TimerAnimGTimer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerStartTimer(Sender: TObject);
    procedure TimerBonusTimer(Sender: TObject);
    procedure Label7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBar1Change(Sender: TObject);
    procedure ForKeyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TrackBar1Enter(Sender: TObject);
  private
    { Private declarations }
    function Distance(a,b:TPoint): integer;
    procedure Loop(var msg: TMessage); Message WMBOUCLE;
    function CanChange(nSprite:byte): integer;
    function CanContinue(nSprite:byte): boolean;
    procedure MakeTab;
    procedure Pause(Color: TColor; Text: string);
    procedure SeekPt(pt:TPoint;ar:TPoint;nSprite:byte);
    procedure PlaceSprite;
    procedure StartGame;
    procedure LoadWav;
    procedure FreeWav;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  aSprites: array[0..3] of TSprite;
  SpriteNum, GosthNum, nBonus: byte;
  imgPlan: TBitmap;
  iTab: byte;
  iTabPoints: integer;
  SpriteStart: TPoint;
  lImmortel, lGarouGarou: boolean;
  hPacGum1, hPacGum2, hPoints: THandle;
  pPacGum1, pPacGum2, pPoints: PChar;


implementation

uses scores;

{$R *.DFM}
{$R PM.RES}
procedure TForm1.LoadWav;
begin
  hPacGum1 := FindResource(hInstance, pchar('PacGum1'), 'WAV');
  if hPacGum1 <> 0 then begin
    hPacGum1 := LoadResource(hInstance, hPacGum1);
    pPacGum1 := LockResource(hPacGum1);
  end;
  hPacGum2 := FindResource(hInstance, pchar('PacGum2'), 'WAV');
  if hPacGum2 <> 0 then begin
    hPacGum2 := LoadResource(hInstance, hPacGum2);
    pPacGum2 := LockResource(hPacGum2);
  end;
  hPoints := FindResource(hInstance, pchar('Points'), 'WAV');
  if hPoints <> 0 then begin
    hPoints := LoadResource(hInstance, hPoints);
    pPoints := LockResource(hPoints);
  end;
end;

procedure TForm1.FreeWav;
begin
  UnLockResource(hPacGum1); FreeResource(hPacGum1);
  UnLockResource(hPacGum2); FreeResource(hPacGum2);
  UnLockResource(hPoints); FreeResource(hPoints);
end;

function TForm1.Distance(a,b:TPoint): integer;
begin
  result := sqr(a.x-b.x) + sqr(a.y-b.y);
end;

procedure TForm1.SeekPt(pt:TPoint;ar:TPoint;nSprite:byte);
var
  pl,pc: integer;
  count,i,poss: byte;
  Possible: Array[1..8] of TPoint;
  mdist: integer;
  Liste: TStringList;
  NewPt: TPoint;
  Virtuel: TBitmap;
  nbPos: byte;
begin
  Virtuel := TBitmap.Create;
  Virtuel.Assign(imgPlan);
  Liste := TStringList.Create;
  pt.x := pt.x div 32; pt.y := pt.y div 32;
  ar.x := ar.x div 32; ar.y := ar.y div 32;
  {Find and count the possible starting points around the current point
   among the 8 possible candidates}
  nbPos := 1;
  while (nbPos < aSprites[nSprite].Trace) do begin
    count:=0;
    FOR pl:= -1 TO 1 do
      FOR pc:= -1 TO 1 do
      begin
        {not the point itself !}
        {and ((pl <> 0) or (pc <> 0))}
        {no diagonal}
        if (abs(pl+pc) = 1)
        {Not ripe and not already taken}
        and (Virtuel.Canvas.Pixels[Pt.x+pc,Pt.y+pl]<>clMur)
        {not too high nor too low}
        and (Pt.y + pl> 0) and (Pt.y + pl <= 14)
        {neither too far to the left nor too far to the right}
        and (Pt.x + pc > 0) and (Pt.x + pc <= 14)
        then begin
        {there is a neighbor who is a possible point}
          inc(count);
          Possible[count] := Point(Pt.x+pc,Pt.y+pl);
        end;
      end;

      {only one candidate}
      if count=1 then
      begin
        Liste.Add(IntToStr(pt.x));
        Liste.Add(IntToStr(pt.y));
        NewPt:=Possible[1];
      end else
      {several candidates}
      if count>1 then
      begin
        {Let's choose the one closest to the arrival point.}
        mdist:=Distance(Possible[1],ar);
        poss:=1;
        for i:=2 to count do
          if Distance(Possible[i],ar)<mdist then begin
            mdist:=Distance(Possible[i],ar);
            poss:=i;
          end;
        Liste.Add(IntToStr(pt.x));
        Liste.Add(IntToStr(pt.y));
        NewPt:=Possible[poss];
      end else
      {desperate situation}
      if (count=0) and (Liste.Count=0) then break else
      {dead end}
      if (count=0) and (Liste.Count>=2) then
      begin
        {steps back}
        NewPt:=Point(StrToInt(Liste.Strings[Liste.Count-2]),
                    StrToInt(Liste.Strings[Liste.Count-1]));
        Liste.Delete(Liste.Count-2);
        Liste.Delete(Liste.Count-1);
      end;
    if NewPt.x-Pt.x = -1 then aSprites[nSprite].aWantSens[nbPos] := SG
    else if NewPt.x-Pt.x = 1 then aSprites[nSprite].aWantSens[nbPos] := SD
    else if NewPt.y-Pt.y = -1 then aSprites[nSprite].aWantSens[nbPos] := SH
    else aSprites[nSprite].aWantSens[nbPos] := SB;
    inc(nbPos);
    if (NewPt.x=ar.x) and (NewPt.y=ar.y) then break;
    Pt := NewPt;
    Virtuel.Canvas.Pixels[Pt.x,Pt.y]:=clMur;
  end;
  aSprites[nSprite].aWantSens[nbPos] := SNONE;
  aSprites[nSprite].More := 1;
  Liste.free;
  Virtuel.free;
end;

procedure TForm1.Pause(Color: TColor; Text: string);
begin
  LabelPause.Color := Color;
  LabelPause.Caption := Text;
  LabelPause.visible := not LabelPause.visible;
  while LabelPause.visible do Application.ProcessMessages;
end;

procedure TForm1.MakeTab;
var
  x, y: integer;
  aTab: TStringList;
  SRect: TRect;
begin
  if not FileExists(ExtractFilePath(Application.ExeName) +
                    'Data\Wall\Mur' + IntToStr(iTab)+'.bmp') then
  begin
    TimerBonus.Enabled := false;
    Form2.LabelScore.Caption := LabelScore.Caption;
    Form2.NoteBook1.PageIndex := 0;
    Form2.ShowModal;
    lImmortel := true;
    Pause(clGreen,'It''s over !');
    Exit;
  end;
  {A timer because Pause() would prevent starting}
  TimerStart.Enabled := true;
  {Image of the walls}
  imgMur.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
                              'Data\Wall\Mur'+IntToStr(iTab)+'.bmp');
  {Convert the text file into a bitmap image}
  aTab := TStringList.Create;
  aTab.LoadFromFile(ExtractFilePath(Application.ExeName) +
                    'Data\Tab\Tab'+IntToStr(iTab)+'.txt');
  SRect := Rect(0,0,SIZE,SIZE);
  iTabPoints := 0;
  for y := 0 to 14 do
    for x := 0 to 14 do begin
      case aTab[y][x+1] of
      ' ':
        begin
        imgMem.Canvas.CopyRect(
           Rect(x*SIZE,y*SIZE,(x*SIZE)+SIZE,(y*SIZE)+SIZE),imgPoints.Canvas,SRect);
        inc(iTabPoints);
        imgPlan.Canvas.Pixels[x,y] := clPoints;
        end;
      '!':
        begin
        imgMem.Canvas.CopyRect(
           Rect(x*SIZE,y*SIZE,(x*SIZE)+SIZE,(y*SIZE)+SIZE),imgPacGum.Canvas,SRect);
        inc(iTabPoints);
        imgPlan.Canvas.Pixels[x,y] := clGum;
        end;
      else
        begin
        imgMem.Canvas.CopyRect(Rect(x*SIZE,y*SIZE,(x*SIZE)+SIZE,(y*SIZE)+SIZE),
        imgMur.Canvas,SRect);
        imgPlan.Canvas.Pixels[x,y] := clMur;
        end;
      end;
    end;

  {Sprite Positions}
  for y := 1 to 13 do
  begin
    for x := 0 to 14 do
    begin
      if aTab[y][x+1] = ' ' then break;
    end;
    if aTab[y][x+1] = ' ' then break;
  end;
  SpriteStart.x := x;
  SpriteStart.y := y;
  aTab.free;
  PlaceSprite;
  {Point under Pac-Man eaten}
  imgMem.Canvas.FillRect(aSprites[0].Zone);
  imgPlan.Canvas.Pixels[SpriteStart.x,SpriteStart.y] := clMange;
  Dec(iTabPoints);
end;

procedure TForm1.StartGame;
begin
  Randomize;
  try
    iTab := StrToInt(ParamStr(1));
  except
    iTab := 1;
  end;
  imgVie1.visible := true;
  imgVie2.visible := true;
  imgVie3.visible := true;
  LabelScore.Caption := '0';
  MakeTab;
  PostMessage(Form1.Handle, WMBOUCLE, 0, 0);
end;

procedure TForm1.PlaceSprite;
var nSprite: byte;
begin
  {PacMan}
  aSprites[0].Zone := Rect(SpriteStart.x*SIZE,SpriteStart.y*SIZE,
                           (SpriteStart.x*SIZE)+SIZE,(SpriteStart.y*SIZE)+SIZE);
  SpriteNum := 0;
  {Ghosts}
  for nSprite := 1 to 3 do begin
    aSprites[nSprite].Zone := Rect(7*SIZE,7*SIZE,(7*SIZE)+SIZE,(7*SIZE)+SIZE);
    {Variable calculation}
    aSprites[nSprite].Trace := NBTEST-(nSprite*3);
    {Offset for different directions}
    aSprites[nSprite].More := nSprite*2;
    aSprites[nSprite].Pic := nSprite-1;
  end;
  {Fantime wipeout}
  GosthNum := 0;
  Timer3.Enabled := false;
  Timer4.Enabled := false;
  {Reset bonuses}
  TimerBonus.Enabled := false;
  TimerBonus.Tag := 0;
  lGarouGarou := false;
  lImmortel := false;
  TimerBonus.Enabled := true;
  {Paindouille}
  imgWorkPaint(Self);
end;

function TForm1.CanChange(nSprite:byte): integer;
var
  x, y: integer;
begin
  Result := aSprites[nSprite].Sens;
  {If Sprite in maze and on an integer point of the plane}
  if (RectVisible(imgWork.Canvas.Handle,aSprites[nSprite].Zone)
    and ((aSprites[nSprite].Zone.Left+aSprites[nSprite].Zone.Top) mod 32 = 0)) then
  begin
    x := aSprites[nSprite].Zone.Left div 32; y := aSprites[nSprite].Zone.Top div 32;
    case aSprites[nSprite].WantSens of
      SD: begin
            x := (aSprites[nSprite].Zone.Left+SIZE) div 32;
            y := aSprites[nSprite].Zone.Top div 32;
          end;
      SG: begin
            x := (aSprites[nSprite].Zone.Left-1) div 32;
            y := aSprites[nSprite].Zone.Top div 32;
          end;
      SH: begin
            x := aSprites[nSprite].Zone.Left div 32;
            y := (aSprites[nSprite].Zone.Top-1) div 32;
          end;
      SB: begin
            x := aSprites[nSprite].Zone.Left div 32;
            y := (aSprites[nSprite].Zone.Top+SIZE) div 32;
          end;
    end;
    if imgPlan.Canvas.Pixels[x,y] <> clMUR then Result := aSprites[nSprite].WantSens;
    {For ghosts, we ask for the next direction.}
    if (nSprite > 0) then
    begin
      Inc(aSprites[nSprite].More);
      if aSprites[nSprite].aWantSens[aSprites[nSprite].More] = SNONE
        then SeekPt(aSprites[nSprite].Zone.TopLeft,aSprites[0].Zone.TopLeft,nSprite);
      aSprites[nSprite].WantSens := aSprites[nSprite].aWantSens[aSprites[nSprite].More];
    end;
  end;
end;

function TForm1.CanContinue(nSprite:byte): boolean;
var
  x, y: integer;
begin
  result := true;
  {If Sprite on an integer point of the plane}
  if (aSprites[nSprite].Zone.Left+aSprites[nSprite].Zone.Top) mod 32 = 0 then
  begin
    x := aSprites[nSprite].Zone.Left div 32; y := aSprites[nSprite].Zone.Top div 32;
    case aSprites[nSprite].Sens of
      SD: begin
            x := (aSprites[nSprite].Zone.Left+SIZE) div 32;
            y := aSprites[nSprite].Zone.Top div 32;
          end;
      SG: begin
            x := (aSprites[nSprite].Zone.Left-1) div 32;
            y := aSprites[nSprite].Zone.Top div 32;
          end;
      SH: begin
            x := aSprites[nSprite].Zone.Left div 32;
            y := (aSprites[nSprite].Zone.Top-1) div 32;
          end;
      SB: begin
            x := aSprites[nSprite].Zone.Left div 32;
            y := (aSprites[nSprite].Zone.Top+SIZE) div 32;
          end;
    end;
    result := ((imgPlan.Canvas.Pixels[x,y] <> clMUR) and (aSprites[nSprite].Pic <> 4))
           or ((nSprite = 0) and (lGarouGarou));
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  FileIni: TIniFile;
begin
  imgPlan.Free;
  FreeWav;

  FileIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Data\Win.ini');
  FileIni.WriteInteger('PacMan', 'Speed', TrackBar1.Position);
  FileIni.Free;
end;

Procedure TForm1.Loop(var msg: TMessage);
var
  nVar, nSprite: integer;
  OldRec: TRect;
  Start: longint;
begin
  for nSprite := 0 to 3 do begin
    aSprites[nSprite].Sens := CanChange(nSprite);
    if CanContinue(nSprite) then
    begin
      case aSprites[nSprite].sens of
        SD:
        begin
          OldRec := Rect(aSprites[nSprite].Zone.Left,aSprites[nSprite].Zone.Top,
                         aSprites[nSprite].Zone.Left+OFFSET,aSprites[nSprite].Zone.Bottom);
          Inc(aSprites[nSprite].Zone.Left,OFFSET);
          if (aSprites[nSprite].Zone.Left > imgWork.Width) then
              aSprites[nSprite].Zone.Left := -SIZE+OFFSET;
        end;
        SG:
        begin
          OldRec := Rect(aSprites[nSprite].Zone.Right-OFFSET,aSprites[nSprite].Zone.Top,
                         aSprites[nSprite].Zone.Right,aSprites[nSprite].Zone.Bottom);
          Dec(aSprites[nSprite].Zone.Left,OFFSET);
          if (aSprites[nSprite].Zone.Left+SIZE < 0) then
              aSprites[nSprite].Zone.Left := imgWork.Width-OFFSET;
        end;
        SH:
        begin
          OldRec := Rect(aSprites[nSprite].Zone.Left,aSprites[nSprite].Zone.Bottom-OFFSET,
                         aSprites[nSprite].Zone.Right,aSprites[nSprite].Zone.Bottom);
          Dec(aSprites[nSprite].Zone.Top,OFFSET);
          if (aSprites[nSprite].Zone.Top+SIZE < 0) then
              aSprites[nSprite].Zone.Top := imgWork.Height-OFFSET;
        end;
        SB:
        begin
          OldRec := Rect(aSprites[nSprite].Zone.Left,aSprites[nSprite].Zone.Top,
                         aSprites[nSprite].Zone.Right,aSprites[nSprite].Zone.Top+OFFSET);
          Inc(aSprites[nSprite].Zone.Top,OFFSET);
          if (aSprites[nSprite].Zone.Top > imgWork.Height) then
          aSprites[nSprite].Zone.Top := -SIZE+OFFSET;
        end;
      end;
      aSprites[nSprite].Zone.Right := aSprites[nSprite].Zone.Left+SIZE;
      aSprites[nSprite].Zone.Bottom := aSprites[nSprite].Zone.Top+SIZE;
      if nSprite > 0 then
      imgWork.Canvas.CopyRect(OldRec, imgMem.Canvas, OldRec)
        else imgWork.Canvas.FillRect(OldRec);
    end;

    {Display}
    if nSprite = 0 then
    begin
      {Sprites}
      imgWork.Canvas.CopyRect(aSprites[0].Zone, imgPac.Canvas,
      Rect(SIZE*SpriteNum,SIZE*aSprites[0].Sens,(SIZE*SpriteNum)+
            SIZE,(SIZE*aSprites[0].Sens)+SIZE));
      {If Sprite on an integer point of the plane}
      if (aSprites[nSprite].Zone.Left+aSprites[nSprite].Zone.Top) mod 32 = 0 then
      begin
        {If points to eat}
        if (imgPlan.Canvas.Pixels[aSprites[0].Zone.Left div 32,
              aSprites[0].Zone.Top div 32] = clPOINTS)
        then begin
          if CheckBox1.Checked then
            sndPlaySound(pPoints, SND_ASYNC or SND_MEMORY or SND_NOSTOP);
          Dec(iTabPoints);
          labelScore.caption := IntToStr(StrToInt(labelScore.caption)+10);
          {If you eat everything}
          if iTabPoints = 0 then MakeTab;
        end else
        {If you eat gums}
        if (imgPlan.Canvas.Pixels[aSprites[0].Zone.Left div 32,
            aSprites[0].Zone.Top div 32] = clGUM)
        then begin
          if CheckBox1.Checked then sndPlaySound(pPacGum1, SND_ASYNC or SND_MEMORY);
          Dec(iTabPoints);
          labelScore.caption := IntToStr(StrToInt(labelScore.caption)+100);
          for nVar := 1 to 3 do aSprites[nVar].Pic := 3;
          Timer3.Enabled := false;
          Timer4.Enabled := false;
          Timer3.Enabled := true;
          Timer4.Enabled := true;
          {If you eat everything}
          if iTabPoints = 0 then MakeTab;
        end else
        {If Bonus to eat}
        if (imgPlan.Canvas.Pixels[aSprites[0].Zone.Left div 32,
            aSprites[0].Zone.Top div 32] = clBONUS)
        then begin
          TimerBonus.Tag := 0;
          labelScore.caption := IntToStr(StrToInt(labelScore.caption)+10);
          case nBonus of
            {Keys}
            0:begin
              Timer3.Enabled := false;
              Timer4.Enabled := false;
              Timer3.Enabled := true;
              Timer4.Enabled := true;
              for nVar := 1 to 3 do aSprites[nVar].Pic := 4;
              labelScore.caption := IntToStr(StrToInt(labelScore.caption)+1500);
              if CheckBox1.Checked then
              sndPlaySound(PChar(ExtractFilePath(Application.ExeName) +
                  'Data\Sound\DeadG.wav'),SND_ASYNC or SND_NOSTOP);
            end;
            {Hammer}
            1:begin
              lGarouGarou := true;
              if CheckBox1.Checked then
                sndPlaySound(PChar(ExtractFilePath(Application.ExeName) +
                    'Data\Sound\Bonus.wav'),SND_ASYNC or SND_NOSTOP);
            end;
            {Star}
            2:begin
              labelScore.caption := IntToStr(StrToInt(labelScore.caption)+2000);
              if CheckBox1.Checked then
                sndPlaySound(PChar(ExtractFilePath(Application.ExeName) +
                    'Data\Sound\Bonus.wav'),SND_ASYNC or SND_NOSTOP);
            end;
            {Life}
            3:begin
              if not imgVie3.visible then imgVie3.visible := true
                else if not imgVie2.visible then imgVie2.visible := true
                  else imgVie1.visible := true;
              if CheckBox1.Checked then
                sndPlaySound(PChar(ExtractFilePath(Application.ExeName) +
                    'Data\Sound\Bonus.wav'),SND_ASYNC or SND_NOSTOP);
            end;
            {Immortal}
            4:begin
              lImmortel := true;
              if CheckBox1.Checked then
                sndPlaySound(PChar(ExtractFilePath(Application.ExeName) +
                    'Data\Sound\Bonus.wav'),SND_ASYNC or SND_NOSTOP);
            end;
          end;
          {If you eat everything}
          if iTabPoints = 0 then MakeTab;
        end;
        imgPlan.Canvas.Pixels[aSprites[0].Zone.Left div 32,aSprites[0].Zone.Top div 32] := clMANGE;
        imgMem.Canvas.FillRect(aSprites[0].Zone);
      end;
    end else begin
      {Ghosts}
      imgWork.Canvas.CopyRect(aSprites[nSprite].Zone, imgGosths.Canvas,
      Rect(SIZE*GosthNum,SIZE*aSprites[nSprite].Pic,
                        (SIZE*GosthNum)+SIZE,
                        (SIZE*aSprites[nSprite].Pic)+SIZE));
      {If PacMan/ghost Distance < SIZE}
      if SQR(aSprites[nSprite].Zone.Left-aSprites[0].Zone.Left)+
              SQR(aSprites[nSprite].Zone.Top-aSprites[0].Zone.Top) < SQR(SIZE)
      then begin
        {Ghost to eat}
        if (aSprites[nSprite].Pic = 3)
        then begin
          {He is dead}
          aSprites[nSprite].Pic := 4;
          labelScore.caption := IntToStr(StrToInt(labelScore.caption)+500);
          if CheckBox1.Checked then
            sndPlaySound(PChar(ExtractFilePath(Application.ExeName) +
                'Data\Sound\DeadG.wav'),SND_ASYNC or SND_NOSTOP);
        end
        {PacMan to eat !}
        else if (aSprites[nSprite].Pic < 3) and (not lImmortel)
        then begin
          if CheckBox1.Checked then
            sndPlaySound(PChar(ExtractFilePath(Application.ExeName) +
                'Data\Sound\DeadP.wav'),SND_SYNC);
          {End}
          if imgVie1.visible then imgVie1.visible := false
            else if imgVie2.visible then imgVie2.visible := false
              else if imgVie3.visible then imgVie3.visible := false
                else begin
                  Form2.LabelScore.Caption := LabelScore.Caption;
                  Form2.NoteBook1.PageIndex := 0;
                  Form2.ShowModal;
                  Pause(clMaroon,'Game Over');
                  StartGame;
                  Exit;
                end;
          Pause(clGreen,'- Ready ? -');
          PlaceSprite;
          {Ghosts ready to eat, otherwise too hard !}
          Timer3.Enabled := false;
          Timer4.Enabled := false;
          Timer3.Enabled := true;
          Timer4.Enabled := true;
          for nVar := 1 to 3 do aSprites[nVar].Pic := 3;
        end;
      end;
    end;
  end;
  {Speed ??and loop}
  Start := GetTickCount;
  repeat
    Application.ProcessMessages;
  until (GetTickCount-Start) >= (TrackBar1.Max-TrackBar1.Position);
  PostMessage(Form1.Handle, WMBOUCLE, 0, 0);
end;

procedure TForm1.imgWorkPaint(Sender: TObject);
begin
  imgWork.Canvas.CopyRect(Rect(0,0,15*SIZE,15*SIZE),
        imgMem.Canvas, Rect(0,0,15*SIZE,15*SIZE));
end;

procedure TForm1.TimerAnimPTimer(Sender: TObject);
begin
  {Animation}
  Inc(SpriteNum);
  if SpriteNum = 3 then SpriteNum := 0;
end;

procedure TForm1.TimerAnimGTimer(Sender: TObject);
begin
  {Animation}
  Inc(GosthNum);
  if GosthNum = 3 then GosthNum := 0;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var nSprite: byte;
begin
  {Time to eat}
  Timer3.Enabled := false;
  Timer4.Enabled := false;
   for nSprite := 1 to 3 do aSprites[nSprite].Pic := nSprite-1;
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
  {Time to eat finished}
  if CheckBox1.Checked then sndPlaySound(pPacGum2, SND_ASYNC or SND_MEMORY);
end;

procedure TForm1.FormCreate(Sender: TObject);
var FileIni: TIniFile;
begin
  imgMem.Canvas.Brush.Color := clBlack;
  {Matrix plan}
  imgPlan := TBitMap.Create;
  imgPlan.Width := 15;
  imgPlan.Height := 15;
  {Images}
  imgPac.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    'Data\Images\PacMan.bmp');
  imgPoints.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    'Data\Images\Points.bmp');
  imgPacGum.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    'Data\Images\PacGum.bmp');
  imgGosths.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    'Data\Images\Gosths.bmp');
  imgVie1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    'Data\Images\Vie.bmp');
  imgVie2.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    'Data\Images\Vie.bmp');
  imgVie3.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    'Data\Images\Vie.bmp');
  imgBonus.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    'Data\Images\Bonus.bmp');
  {Test vitesse}
  FileIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Data\Win.ini');
  TrackBar1.Position := FileIni.ReadInteger('PacMan', 'Speed', 15);
  TrackBar1Change(TrackBar1);
  FileIni.Free;
  {Important sounds}
  LoadWav;
  {Departure}
  StartGame;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  LabelPause.visible := false;
end;

procedure TForm1.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := false;
  if CheckBox1.Checked then
  sndPlaySound(PChar(ExtractFilePath(Application.ExeName) +
    'Data\Sound\Tab.wav'),SND_ASYNC);
  Pause(clNavy,'Level '+IntToSTr(iTab));
  {Future Table}
  inc(iTab);
end;

procedure TForm1.TimerBonusTimer(Sender: TObject);
var
  x: byte;
begin
  nBonus := Random(5);
  for x := 7 downto 0 do
    if imgPlan.Canvas.Pixels[x,7] <> clMur then break;
  if TimerBonus.Tag = 0 then
  begin
    TimerBonus.Tag := 1;
    {The loop will be true but will cancel when it returns here}
    lGarouGarou := false;
    lImmortel := false;
    {So that the ghosts don't erase it}
    imgMem.Canvas.CopyRect(Rect(x*SIZE,7*SIZE,x*SIZE+SIZE,7*SIZE+SIZE),
                            imgBonus.Canvas,
                            Rect(nBonus*SIZE,0,(nBonus*SIZE)+SIZE,SIZE)
                            );
    {To see it}
    imgWork.Canvas.CopyRect(Rect(x*SIZE,7*SIZE,x*SIZE+SIZE,7*SIZE+SIZE),
                            imgBonus.Canvas,
                            Rect(nBonus*SIZE,0,(nBonus*SIZE)+SIZE,SIZE)
                             );
    if (imgPlan.Canvas.Pixels[x,7] = clPoints) or
       (imgPlan.Canvas.Pixels[x,7] = clGum) then Dec(iTabPoints);
    imgPlan.Canvas.Pixels[x,7] := clBonus;
  end else
  begin
    {We erase it}
    TimerBonus.Tag := 0;
    imgMem.Canvas.FillRect(Rect(x*SIZE,7*SIZE,x*SIZE+SIZE,7*SIZE+SIZE));
    imgWork.Canvas.FillRect(Rect(x*SIZE,7*SIZE,x*SIZE+SIZE,7*SIZE+SIZE));
    imgPlan.Canvas.Pixels[x,7] := clMange;
  end;
  if CheckBox1.Checked then sndPlaySound(PChar(ExtractFilePath(Application.ExeName) + 'Data\Sound\Bonus.wav'),SND_ASYNC or SND_NOSTOP);
end;

procedure TForm1.Label7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    Form2.LabelPosition.Caption := 'Ascending order';
    Form2.NoteBook1.PageIndex := 1;
    Form2.ShowModal;
  end else begin
    lImmortel := true;
    sndPlaySound(PChar(ExtractFilePath(Application.ExeName) +
      'Data\Sound\Bonus.wav'),SND_ASYNC or SND_NOSTOP);
  end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  TrackBar1.SelEnd := TrackBar1.Position;
  MemoSpeed.Lines[0] := 'Speed : '+IntToStr(TrackBar1.Position);
end;

procedure TForm1.ForKeyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var nSprite: byte;
begin
  case Key of
    VK_RIGHT  : aSprites[0].WantSens := SD;
    VK_LEFT   : aSprites[0].WantSens := SG;
    VK_UP     : aSprites[0].WantSens := SH;
    VK_DOWN   : aSprites[0].WantSens := SB;
    VK_RETURN : Pause(clMaroon,'- Pause -');
    VK_ESCAPE : begin LabelPause.visible := false; Form1.Close; end;
  end;
  Key := 0;
  nSprite := Random(3)+1;
  SeekPt(aSprites[nSprite].Zone.TopLeft,aSprites[0].Zone.TopLeft,nSprite);
end;

procedure TForm1.TrackBar1Enter(Sender: TObject);
begin
  ForKey.SetFocus;
end;

end.
