unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls, Spin, Buttons, ImgList, Menus, MMSystem,
  IniFiles;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    ImageList1: TImageList;
    pnlSheat: TPanel;
    Label4: TLabel;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    miGame: TMenuItem;
    miQuestionMark: TMenuItem;
    miNew: TMenuItem;
    N2: TMenuItem;
    miBeginner: TMenuItem;
    miIntermediate: TMenuItem;
    miExpert: TMenuItem;
    miCustom: TMenuItem;
    N3: TMenuItem;
    miMarks: TMenuItem;
    miSound: TMenuItem;
    N4: TMenuItem;
    miScore: TMenuItem;
    N5: TMenuItem;
    miClose: TMenuItem;
    pnlInfo: TPanel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    Panel2: TPanel;
    DrawGrid1: TDrawGrid;
    miAbout: TMenuItem;
    miCheat: TMenuItem;
    N6: TMenuItem;
    Label5: TLabel;
    Label6: TLabel;
    procedure btnNewGameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure miCheatClick(Sender: TObject);
    procedure miBeginnerClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miSoundClick(Sender: TObject);
    procedure miNewClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miScoreClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Declarations privates }
    procedure DefineGame;
    procedure ReadData;
    procedure WriteData;
    procedure UpdateBestScores(Time: Word);
  public
    { Declarations public }
  end;

var
  Form1: TForm1;

  PathAppli: string;    // application path
  BestBeginnerTime, BestIntermediateTime, BestExpertTime: Word;   // time
  BestBeginnerName, BestIntermediateName, BestExpertName: string; // id
  GameLevel: Byte;      // level of play

implementation

uses
  Matrix, DGUtils, About, Scores, InputName, Customer;

{$R *.DFM} {$R WindowsXP.res}

const
  { cell marking }
  TAG_NULL  = 0;  // unmarked box
  TAG_FLAG  = 1;  // box marked with a flag
  TAG_QMARK = 2;  // box marked with a '?'

  { Game Level }
  BEGINNER     = 1;
  INTERMEDIATE = 2;
  EXPERT       = 3;
  CUSTOM       = 4;
  
var
  MatrixMine      : TMatrixBool;  // mine location table
  MatrixNumb      : TMatrixByte;  // proximity indication table
  MatrixShow      : TMatrixBool;  // table of discovered cells
  MatrixFlag      : TMatrixByte;  // cell status table

  MinesTotal      : Integer;      // total number of mines
  MinesRemaining  : Integer;      // Mines still to be found (player estimate)
  MinesFound      : Integer;      // mines actually found

  ElapsedTime     : Integer;      // elapsed time
  TimerCanGo      : Boolean;      // The timer will be activated on the first click.

  ExplodingZone   : TPoint;       // minefield where the player clicked

  HORZ_CELLS      : Integer;      // number of columns
  VERT_CELLS      : Integer;      // number of rows
  CellsCount      : Integer;      // number of cells

  Tic, Tac,
  Boom, Win       : string;       // location of sounds

{ Start a new game }
procedure TForm1.btnNewGameClick(Sender: TObject);
begin
  { initialization of variables }
  MinesTotal     := SpinEdit1.Value;
  MinesRemaining := MinesTotal;
  MinesFound     := 0;
  ElapsedTime    := 0;
  ExplodingZone  := Point(Length(MatrixMine), Length(MatrixMine[0]));

  { Initializing the tables, setting up the mines, and providing local information. }
  InitializeMatrixBool(MatrixMine);               // value = False
  GetRandomCells(MatrixMine, MinesTotal);         // random placement of mines
  InitializeMatrixBool(MatrixShow);               // value = False
  InitializeMatrixByte(MatrixFlag);               // value = 0
  SearchForNeighboring(MatrixNumb, MatrixMine);   // mine proximity indicators

  { grid update }
  DrawGrid1.Invalidate;

  { information display }
  CellsCount := HORZ_CELLS * VERT_CELLS;
  Label2.Caption := Format('%.3d', [MinesTotal]);
  Label3.Caption  := Format('%.3d', [ElapsedTime]);
  Label4.Caption := Format('%.3d/%.3d', [MinesFound, MinesTotal]);
  Label7.Caption  := Format('%.3d/%.3d', [CountMatrixBool(MatrixShow, False), CellsCount]);

  { button drawing = smiling smiley }
  SpeedButton1.Glyph := nil;
  ImageList1.GetBitmap(0, SpeedButton1.Glyph);

  DrawGrid1.Enabled := True;
  
  { The timer will be able to start on the first left click }
  Timer1.Enabled := False;
  TimerCanGo := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  { application path }
  PathAppli := ExtractFilePath(Application.ExeName);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  { elimination of any potential flickering effect }
  DrawGrid1.DoubleBuffered := True;
  { reading data from the ini file }
  ReadData;
  { concealment of evidence of "cheating" }
  pnlSheat.Width := 0;
  { definition of the level of play and sizing }
  DefineGame;
  { No cell selection because it's unsightly }
  NoSelectionInDrawGrid(DrawGrid1);
  { game launch }
  btnNewGameClick(nil);
  { path of sound files }
  Tic  := PathAppli + 'Sounds\Tic.wav';
  Tac  := PathAppli + 'Sounds\Tac.wav';
  Boom := PathAppli + 'Sounds\Boom.wav';
  Win  := PathAppli + 'Sounds\Win.wav';
  { click menu cheat }
  miCheatClick(nil);
end;

{ It is during this event that the cells of the StringGrid are drawn }
procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Indication: Integer;
begin
  { number indicating the number of mines around the cell }
  Indication := MatrixNumb[ACol, ARow];
  if (not MatrixMine[ACol, ARow] or CheckBox3.Checked) and
     (Indication <> 0) and CheckBox1.Checked then
    DrawGrid1.Canvas.TextOut(Rect.Left + 4, Rect.Top + 1, IntToStr(Indication));
  { displaying the image corresponding to the current state of the cell }
  if not MatrixShow[ACol, ARow] and not CheckBox4.Checked then
    with DrawGrid1.Canvas do
    case MatrixFlag[ACol, ARow] of
      0: Draw(Rect.Left, Rect.Top, Image3.Picture.Graphic);  // hidden
      1: Draw(Rect.Left, Rect.Top, Image4.Picture.Graphic);   // flag
      2: Draw(Rect.Left, Rect.Top, Image5.Picture.Graphic);  // '?'
    end
  else
  if MatrixMine[ACol, ARow] and CheckBox2.Checked then
    DrawGrid1.Canvas.Draw(Rect.Left, Rect.Top, Image1.Picture.Graphic);  // mine
  { if the player clicked on a mine }
  if (ACol = ExplodingZone.x) and (ARow = ExplodingZone.y) then
    DrawGrid1.Canvas.Draw(Rect.Left, Rect.Top, Image2.Picture.Graphic); // mine red
end;

var
  Losing: Boolean;  // lost game

procedure TForm1.DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  { button drawing = smiling smiley }
  SpeedButton1.Glyph := nil;
  ImageList1.GetBitmap(0, SpeedButton1.Glyph);
  { prevents cell selection because it is unsightly }
  NoSelectionInDrawGrid(DrawGrid1);
  { This is ultimately the best place to put the following code blocks. }
  { If hidden squares = actual number of mines and squares marked with a flag }
  if (CountMatrixBool(MatrixShow, False) = MinesTotal) and
     (CountMatrixByte(MatrixFlag, 1) = MinesTotal) then
  { The game is won. }
  begin
    { button drawing = cool smiley }
    SpeedButton1.Glyph := nil;
    ImageList1.GetBitmap(3, SpeedButton1.Glyph);
    { we freeze the game }
    Timer1.Enabled := False;
    DrawGrid1.Enabled := False;
    { The sound will play if the option is checked. }
    if miSound.Checked then
      sndPlaySound(PChar(Win), SND_ASYNC);
    DrawGrid1.Invalidate;           // <-
    UpdateBestScores(StrToInt(Label3.Caption));   // <-
  end;
  { the game is lost }
  if Losing then
  begin
    { button drawing = kaput smiley }
    SpeedButton1.Glyph := nil;
    ImageList1.GetBitmap(2, SpeedButton1.Glyph);
    { we freeze the game }
    Timer1.Enabled := False;
    DrawGrid1.Enabled := False;
    { The sound will play if the option is checked. }
    if miSound.Checked then
      sndPlaySound(PChar(Boom), SND_ASYNC);
  end;
end;

procedure TForm1.DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  WrongFlags: Integer;  // Incorrect flags; delete if matching boxes are found.
begin Losing := False;
  { the square becomes a discovery square }
  MatrixShow[ACol, ARow] := True;
  { if we've stumbled upon a mine... }
  if MatrixMine[ACol, ARow] then
  begin
    { the explosion zone is determined }
    ExplodingZone := Point(ACol, ARow);
    { The game is declared lost. }
    Losing := True;
  end
  { otherwise it's bad... }
  else
  begin
    { possible clearing of empty cells around the clicked cell }
    SearchForShowing(MatrixShow, MatrixNumb, ACol, ARow);
    { Here we need to update the count of squares mistakenly marked with a
    flag and which have been cleared. ! }
    WrongFlags := CompareMatrixByteBool(MatrixFlag, 1, 0, MatrixShow, True);
    { update of the player's estimated remaining mine count }
    Inc(MinesRemaining, WrongFlags);
    Label2.Caption := Format('%.3d', [MinesRemaining]);
    { grid refresh }
    DrawGrid1.Invalidate;
  end;
  Label7.Caption  := Format('%.3d/%.3d',
                      [CountMatrixBool(MatrixShow, False), CellsCount]);
end;

procedure TForm1.DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
  Wdth: Integer;
begin
  if ssRight in Shift then        // if right click...
  begin
    { A quick calculation to locate the clicked cell }
    ACol := X div (DrawGrid1.DefaultColWidth + 1);
    ARow := Y div (DrawGrid1.DefaultRowHeight + 1);
    if MatrixShow[ACol, ARow] then Exit;  // If box discovered, exit ->
    { cell state change (3 states) }
    case MatrixFlag[ACol, ARow] of
      TAG_NULL :    // state found: unmarked box
      begin
        MatrixFlag[ACol, ARow] := TAG_FLAG;   // Result: marked square (flag)
        Dec(MinesRemaining);                  // Estimated number of mines to be found: - 1
        if MatrixMine[ACol, ARow] then        // if mine is in the box...
          Inc(MinesFound);                    // Mines found: +1
        { predicting a negative display if the player has placed too many flags }
        if MinesRemaining < 0 then Wdth := 2 else Wdth := 3;
        Label2.Caption := Format('%.*d', [Wdth, MinesRemaining]);
        Label4.Caption := Format('%.3d/%.3d', [MinesFound, MinesTotal]);
      end;
      TAG_FLAG :    // Status found: marked square (flag)
      begin
        if miMarks.Checked then               // depending on the menu option...
          MatrixFlag[ACol, ARow] := TAG_QMARK // Result: marked box (?)
        else
          MatrixFlag[ACol, ARow] := TAG_NULL; // Result: unmarked box
        Inc(MinesRemaining);                  // Estimated number of mines to be found: +1
        if MatrixMine[ACol, ARow] then        // if mine is in the box...
          Dec(MinesFound);                    // Mines found: - 1
        if MinesRemaining < 0 then Wdth := 2 else Wdth := 3;
        Label2.Caption := Format('%.*d', [Wdth, MinesRemaining]);
        Label4.Caption := Format('%.3d/%.3d', [MinesFound, MinesTotal]);
      end;
      TAG_QMARK :   // state found: marked box (?)
      begin
        MatrixFlag[ACol, ARow] := TAG_NULL;   // Result: unmarked box
      end;
    end;
    DrawGrid1.Invalidate;
  end
  else if ssLeft in Shift then    // if left click...
  begin
    SpeedButton1.Glyph := nil;
    ImageList1.GetBitmap(1, SpeedButton1.Glyph);   // Oooh... smiley
    if TimerCanGo then
    begin
      Timer1.Enabled := True;
      TimerCanGo := False;
    end;
  end;
end;

{ Elapsed time management, display and sound }
var
  IsTic: Boolean = True;
{ I'm replacing the typed constant with a delocalized variable
  (so I can assign it a value), to ensure compatibility with a
  compilation option that seems to be enabled by default
  under Delphi in particular. }
procedure TForm1.Timer1Timer(Sender: TObject);
//const
//   IsTic: Boolean = True;
begin
  Inc(ElapsedTime);
  Label3.Caption := Format('%.3d', [ElapsedTime]);
  if miSound.Checked then
  begin
    if IsTic then
      sndPlaySound(PChar(Tic), SND_ASYNC)
    else
      sndPlaySound(PChar(Tac), SND_ASYNC);
  end;
  IsTic := not IsTic;
end;

{ TDrawGrid Refresh }
procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  DrawGrid1.Invalidate;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  DrawGrid1.Invalidate;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  DrawGrid1.Invalidate;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  DrawGrid1.Invalidate;
end;

{ ************ SECTION CONCERNING USER CHOICE MANAGEMENT ************ }

{ Show/hide the panel of "cheat" indicators }
procedure TForm1.miCheatClick(Sender: TObject);
const
  PANEL_CHEAT_WIDTH = 169;
begin
  miCheat.Checked := not miCheat.Checked;
  if miCheat.Checked then
  begin
    ClientWidth := Panel1.Width + PANEL_CHEAT_WIDTH;
    pnlSheat.Width := PANEL_CHEAT_WIDTH;
  end
  else
  begin
    pnlSheat.Width := 0;
    ClientWidth := Panel1.Width;
  end;
end;

{ Defining the game's parameters and dimensions based on the chosen level }
procedure TForm1.DefineGame;
begin
  case GameLevel of
    BEGINNER :
    begin
      HORZ_CELLS := 9;
      VERT_CELLS := 9;
      SpinEdit1.Value := 10;
    end;
    INTERMEDIATE :
    begin
      HORZ_CELLS := 16;
      VERT_CELLS := 16;
      SpinEdit1.Value := 40;
    end;
    EXPERT :
    begin
      HORZ_CELLS := 30;
      VERT_CELLS := 16;
      SpinEdit1.Value := 99;
    end;
    CUSTOM :
    begin
      HORZ_CELLS := CustomWidth;
      VERT_CELLS := CustomHeight;
      SpinEdit1.Value := CustomMines;
    end;
  end;
  { WARNING! Don't forget to size the tables ! }
  SetLengthMatrixBool(MatrixMine, HORZ_CELLS, VERT_CELLS);
  SetLengthMatrixNumb(MatrixNumb, HORZ_CELLS, VERT_CELLS);
  SetLengthMatrixBool(MatrixShow, HORZ_CELLS, VERT_CELLS);
  SetLengthMatrixNumb(MatrixFlag, HORZ_CELLS, VERT_CELLS);

  with DrawGrid1 do
  begin
    Width    := HORZ_CELLS * (DefaultColWidth + 1) + 2;
    Height   := VERT_CELLS * (DefaultRowHeight + 1) + 2;
    ColCount := HORZ_CELLS;
    RowCount := VERT_CELLS;
  end;

  { positioning of elements around the DrawGrid }
  Panel1.Width := Panel2.Width + 12;
  Panel1.Height := Panel2.Height + 56;
  pnlSheat.Height := Panel1.Height;
  pnlInfo.Width := Panel2.Width;
  SpeedButton1.Left := (pnlInfo.Width - SpeedButton1.Width) div 2;
  ClientWidth := Panel1.Width + pnlSheat.Width;
  ClientHeight := Panel1.Height;
end;

procedure TForm1.miBeginnerClick(Sender: TObject);
var
  i: Integer;
begin
  { I could have used the RadioItem property, but I wanted to keep the
    checkmark as a 'V' and not a '.' for aesthetic reasons. }
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TMenuItem then
      if (Components[i] as TMenuItem).Tag > 0 then
        (Components[i] as TMenuItem).Checked := False;
  (Sender as TMenuItem).Checked := True;
  GameLevel := (Sender as TMenuItem).Tag;
  { custom game settings (optional) }
  if miCustom.Checked then
    CustomerForm.ShowModal;
  { definition of the level of play and sizing }
  DefineGame;
  { definition of the level of play and sizingdefinition of the
    level of play and sizing }
  btnNewGameClick(nil);
end;

procedure TForm1.miAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TForm1.miSoundClick(Sender: TObject);
begin
  with Sender as TMenuItem do
    Checked := not Checked;
end;

procedure TForm1.miNewClick(Sender: TObject);
begin
  btnNewGameClick(nil);
end;

procedure TForm1.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.miScoreClick(Sender: TObject);
begin
  ScoreForm.ShowModal;
end;

{ Reading data from the ini file }
procedure TForm1.ReadData;
var
  i: Integer;
begin
  with TIniFile.Create(PathAppli + 'Data.ini') do
  try
    { plug position }
    Left := ReadInteger('USER', 'left', 300);
    Top := ReadInteger('USER', 'top', 100);
    { game level and corresponding menu selection }
    GameLevel := ReadInteger('USER', 'level', 1);
    for i := 0 to ComponentCount - 1 do
      if Components[i] is TMenuItem then
        if (Components[i] as TMenuItem).Tag > 0 then
        begin
          if (Components[i] as TMenuItem).Tag = GameLevel then
            (Components[i] as TMenuItem).Checked := True
          else
            (Components[i] as TMenuItem).Checked := False;
        end;
    { reading game settings according to player preferences (custom) }
    CustomWidth  := ReadInteger('USER', 'customwidth', 9);
    CustomHeight := ReadInteger('USER', 'customheight', 9);
    CustomMines  := ReadInteger('USER', 'custommine', 10);
    { checking the various optional menus }
    miMarks.Checked       := ReadBool('USER', 'marks', False);
    miSound.Checked       := ReadBool('USER', 'sound', True);
    miCheat.Checked       := ReadBool('USER', 'cheat', False);
    { update according to previous parameter }
    miCheat.Click;
    { reading high scores }
    BestBeginnerTime      := ReadInteger('SCORE', 'time1', 999);
    BestIntermediateTime  := ReadInteger('SCORE', 'time2', 999);
    BestExpertTime        := ReadInteger('SCORE', 'time3', 999);
    BestBeginnerName      := ReadString('SCORE', 'name1', 'Anonym');
    BestIntermediateName  := ReadString('SCORE', 'name2', 'Anonym');
    BestExpertName        := ReadString('SCORE', 'name3', 'Anonym');
  finally
    Free;
  end;
end;

{ Writing data to the ini file }
procedure TForm1.WriteData;
begin
  with TIniFile.Create(PathAppli + 'Data.ini') do
  try
    WriteInteger('USER', 'left', Left);
    WriteInteger('USER', 'top', Top);
    WriteInteger('USER', 'level', GameLevel);
    WriteBool('USER', 'marks', miMarks.Checked);
    WriteBool('USER', 'sound', miSound.Checked);
    WriteBool('USER', 'cheat', miCheat.Checked);
    WriteInteger('USER', 'customwidth', CustomWidth);
    WriteInteger('USER', 'customheight', CustomHeight);
    WriteInteger('USER', 'custommine', CustomMines);
  finally
    Free;
  end;
end;

{ Comparison of the time achieved with the best score established }
procedure TForm1.UpdateBestScores(Time: Word);
var
  BestScoreChange: Boolean;
begin
  BestScoreChange := False;
  { comparison of scores based on level }
  case GameLevel of
    BEGINNER :
      if Time < BestBeginnerTime then
      begin
        BestBeginnerTime := Time;
        BestScoreChange := True;
      end;
    INTERMEDIATE :
      if Time < BestIntermediateTime then
      begin
        BestIntermediateTime := Time;
        BestScoreChange := True;
      end;
    EXPERT :
      if Time < BestExpertTime then
      begin
        BestExpertTime := Time;
        BestScoreChange := True;
      end;
    CUSTOM: Exit;
  end;
  { a better time has been established }
  if BestScoreChange then
  begin
    { name input window call }
    InputNameForm.ShowModal;
    { display and recording of new best times }
    ScoreForm.ShowModal;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteData;
end;

end.
