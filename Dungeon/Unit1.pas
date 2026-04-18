Unit Unit1;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, MMSystem;

Type
  TypeSens = (Nord, East, South, West); // To understand the meaning of the characters
                                      // in the maze
  TForm1 = Class(TForm)
    Timer1: TTimer;
    Commande: TGroupBox;
    TrackBar1: TTrackBar;
    CheckBox1: TCheckBox;
    EditSombre: TEdit;
    Label1: TLabel;
    ScrollBar1: TScrollBar;
    PaintBox1: TPaintBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CheckBox2: TCheckBox;
    PaintBox2: TPaintBox;
    PlayerButtonRotateLeft: TBitBtn;
    LeftPlayerButton: TBitBtn;
    PlayerButtonUp: TBitBtn;
    PlayerButtonRotateRight: TBitBtn;
    PlayerBottomButton: TBitBtn;
    RightPlayerButton: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Timer2: TTimer;
    Timer3: TTimer;
    Procedure LoadBlock;
    Procedure LoadSriteMap;
    Procedure LoadEnemySprite;
    Procedure LoadArrowMouse;
    Procedure LoadCompass;
    Procedure LoadWinLoss;
    Procedure InitLevel;
    Procedure InitGame;
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Procedure ShowEnemySprite(XPos, YPos, Zoom : Integer; Sens : TypeSens);
    Procedure ShowMapHide;
    Procedure Timer1Timer(Sender: TObject);
    Procedure PlayerMovementUp;
    Procedure PlayerMovementDown;
    Procedure PlayerMovementLeft;
    Procedure PlayerMovementRight;
    Procedure PlayerMovementPivotLeft;
    Procedure PlayerMovementPivotRight;
    Procedure PlayerButtonUpClick(Sender: TObject);
    Procedure PlayerButtonRotateRightClick(Sender: TObject);
    Procedure PlayerButtonRotateLeftClick(Sender: TObject);
    Procedure PlayerBottomButtonClick(Sender: TObject);
    Procedure LeftPlayerButtonClick(Sender: TObject);
    Procedure RightPlayerButtonClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  Private
    { Declarations privates }
  Public
    { Declarations public }
  End;

Const ProgramName     = 'Dungeon';
      VersionProgramme = '1.0';

      CrMouseOff = 1;

      CoordBlock : Array [1..8] Of Record // Display coordinates of the blocks
                                        LEFT,
                                        CENTER,
                                        RIGHT,
                                        Ceiling,
                                        Sol       : Record
                                                          X1, Y1, X2, Y2 : Integer;
                                                    End;
                                  End = ((LEFT   : (X1 : 268; Y1 : 91;  X2 : 278; Y2 : 104);
                                          CENTER   : (X1 : 274; Y1 : 91;  X2 : 292; Y2 : 104);
                                          RIGHT   : (X1 : 288; Y1 : 91;  X2 : 298; Y2 : 104);
                                          Ceiling  : (X1 : 274; Y1 : 91;  X2 : 292; Y2 : 92);
                                          Sol      : (X1 : 274; Y1 : 101; X2 : 292; Y2 : 104)),

                                         (LEFT   : (X1 : 259; Y1 : 88;  X2 : 274; Y2 : 110);
                                          CENTER   : (X1 : 268; Y1 : 88;  X2 : 298; Y2 : 110);
                                          RIGHT   : (X1 : 292; Y1 : 88;  X2 : 307; Y2 : 110);
                                          Ceiling  : (X1 : 268; Y1 : 88;  X2 : 298; Y2 : 90);
                                          Sol      : (X1 : 268; Y1 : 105; X2 : 298; Y2 : 110)),

                                         (LEFT   : (X1 : 246; Y1 : 84;  X2 : 268; Y2 : 119);
                                          CENTER   : (X1 : 259; Y1 : 84;  X2 : 307; Y2 : 119);
                                          RIGHT   : (X1 : 298; Y1 : 84;  X2 : 320; Y2 : 119);
                                          Ceiling  : (X1 : 259; Y1 : 84;  X2 : 307; Y2 : 87);
                                          Sol      : (X1 : 259; Y1 : 111; X2 : 307; Y2 : 119)),

                                         (LEFT   : (X1 : 227; Y1 : 77;  X2 : 259; Y2 : 132);
                                          CENTER   : (X1 : 246; Y1 : 77;  X2 : 320; Y2 : 132);
                                          RIGHT   : (X1 : 307; Y1 : 77;  X2 : 339; Y2 : 132);
                                          Ceiling  : (X1 : 246; Y1 : 77;  X2 : 320; Y2 : 83);
                                          Sol      : (X1 : 246; Y1 : 120; X2 : 320; Y2 : 132)),

                                         (LEFT   : (X1 : 199; Y1 : 68;  X2 : 246; Y2 : 151);
                                          CENTER   : (X1 : 227; Y1 : 68;  X2 : 339; Y2 : 151);
                                          RIGHT   : (X1 : 320; Y1 : 68;  X2 : 367; Y2 : 151);
                                          Ceiling  : (X1 : 227; Y1 : 68;  X2 : 339; Y2 : 76);
                                          Sol      : (X1 : 227; Y1 : 133; X2 : 339; Y2 : 151)),

                                         (LEFT   : (X1 : 157; Y1 : 54;  X2 : 227; Y2 : 179);
                                          CENTER   : (X1 : 199; Y1 : 54;  X2 : 367; Y2 : 179);
                                          RIGHT   : (X1 : 339; Y1 : 54;  X2 : 409; Y2 : 179);
                                          Ceiling  : (X1 : 199; Y1 : 54;  X2 : 367; Y2 : 67);
                                          Sol      : (X1 : 199; Y1 : 152; X2 : 367; Y2 : 179)),

                                         (LEFT   : (X1 : 094; Y1 : 33;  X2 : 199; Y2 : 221);
                                          CENTER   : (X1 : 157; Y1 : 33;  X2 : 409; Y2 : 221);
                                          RIGHT   : (X1 : 367; Y1 : 33;  X2 : 472; Y2 : 221);
                                          Ceiling  : (X1 : 157; Y1 : 33;  X2 : 409; Y2 : 53);
                                          Sol      : (X1 : 157; Y1 : 180; X2 : 409; Y2 : 221)),

                                         (LEFT   : (X1 : 000; Y1 : 1;   X2 : 157; Y2 : 284);
                                          CENTER   : (X1 : 094; Y1 : 1;   X2 : 472; Y2 : 284);
                                          RIGHT   : (X1 : 409; Y1 : 1;   X2 : 566; Y2 : 284);
                                          Ceiling  : (X1 : 094; Y1 : 1;   X2 : 472; Y2 : 32);
                                          Sol      : (X1 : 094; Y1 : 222; X2 : 472; Y2 : 284)));

      // Y coordinates for displaying enemies, X is constant
      YPosEnemy : Array [1..8] Of Integer = (252, 200, 165, 141, 125, 114, 110, 102);

Type TypeBMPBlock   = Record // Labyrinth bitmap stock
                           FloorCeiling : TBitmap;
                           SolPlafondWidth, SolPlafondHeight : Integer;

                           Exit : TBitmap;
                           ExitWidth, ExitHeight : Integer;

                           Cube : Array [1..3] Of Record
                                                        Left, Center, Right    : TBitmap;
                                                        LeftWidth, LeftHeight : Integer;
                                                        CenterWidth, CenterHeight : Integer;
                                                        RightWidth, RightHeight : Integer;
                                                  End;
                     End;
     TypeBMPMapSprite  = Record // Store the sprites to display on the map
                                 Player : Array [TypeSens] Of TBitmap;
                                 Enemy : Array [TypeSens] Of TBitmap;
                           End;
     TypeBMPEnemySprite = Array [TypeSens] Of Record // Stock up on enemies
                                                     Pixel : TBitmap;
                                                     PixelWidth, PixelHeight : Integer;
                                               End;
     TypeBMPArrowMouse = Array [1..6] Of TBitmap;
     TypeBMPCompass      = Array [TypeSens] Of TBitmap;
     TypeLaby        = Record // All the blocks of the level
                             XSize, YSize   : Byte;     // Maze size
                             XDebut, YDebut     : Byte;     // Player's starting position
                             SensBeginning      : TypeSens; // Player's sense at the beginning
                             XExit, YExit       : Byte;     // Exit coordinates
                             Block              : Array [1..20, 1..20] Of Byte;
                       End;
     TypeGuideBlock   = Array [1..8] Of Record // Will contain the numbers of the blocks to display
                                             Left, Center, Right    : Byte;  // Block on the left, in the center and on the right
                                             SwExit                 : Boolean;
                                             SwCenter               : Boolean; // True if an enemy is located in that square. ne s'occupe pas des ennemis qui se trouvent à gauche ou à droite puisque qu'ils seront cachés par les blocs
                                             SensCenter             : TypeSens; // The enemy's sense
                                       End;
     TypeCharacter  = Record
                             XPos, YPos : Integer;
                             Sens       : TypeSens;
                       End;
     TypeRGB         = Record
                             Blue, Green, Red : Byte;
                       End;
     TypeTRGBArray   = Array [0..570] Of TypeRGB;
     TypePRGBArray   = ^TypeTRGBArray;
     TypeEnemy      = Array [1..7] Of TypeCharacter;

     TypeEnemyDirectionPossible = Record
                                    HowMuch : Byte;
                                    Sens    : Array [1..4] Of TypeSens;
                              End;

Const Shift : Array [TypeSens] Of Record
                                              X, Y, XLEFT, YLEFT, XRight, YRight : Integer;
                                        End = ((X :  0; Y : -1; XLEFT : -1; YLEFT :  0; XRight :  1; YRight :  0),
                                               (X :  1; Y :  0; XLEFT :  0; YLEFT : -1; XRight :  0; YRight :  1),
                                               (X :  0; Y :  1; XLEFT :  1; YLEFT :  0; XRight : -1; YRight :  0),
                                               (X : -1; Y :  0; XLEFT :  0; YLEFT :  1; XRight :  0; YRight : -1));

Var Form1             : TForm1;
    BMPForm1          : TBitmap;
    BMPBuffer         : TBitmap;
    BMPZoom           : TBitmap;
    BMPArrowMouse     : TypeBMPArrowMouse;
    BMPCompass        : TypeBMPCompass;
    BMPWon, BMPPerdu  : TBitmap;
    BMPBlock          : TypeBMPBlock;
    Laby              : TypeLaby;
    GuideBloc         : TypeGuideBlock;
    BMPMap            : TBitmap;
    BMPMapSprite      : TypeBMPMapSprite;
    BMPCacheMap       : TBitmap;
    BMPBufferMap      : TBitmap;
    MapZoom           : Byte;

    Player             : TypeCharacter;
    DeadPlayer         : Boolean;
    SwAnimDead         : Boolean;
    CptAnimDead        : Byte;
    CptAnimWon         : Byte;
    Enemy              : TypeEnemy;
    EnemyMax           : Byte;
    EnemySensPossible  : TypeEnemyDirectionPossible;
    EnemyPause         : Integer;
    BMPEnemySprite     : TypeBMPEnemySprite;

    WavePause, CodeWave : Integer;
    crCursor : Byte;

// Variables used in Timer. If they are declared in Timer, they will be
// Created and then deleted repeatedly, therefore a waste of time
// Except for Cpt, CptEnnemi, X, and Y, which apparently must be a simple local variable
    TCode                            : Byte;
    TXPos, TYPos, TXSize, TYSize     : Integer;
    TRGBColor                        : TColor;
    TRed, TGreen, TBlue              : Integer;
    TScanLine                        : TypePRGBArray;
    TSensInverse                     : TypeSens;
    TSwCenterBlock                   : Boolean;
    TCoordMouse                      : TPoint;

// Commands for the programmer during the testing phase
    SwDark         : Boolean; // To obscure the labyrinth
    DarkPercent    : Byte;
    MaxW, MaxH     : Integer;
    SwCacheMap     : Boolean; // Hide or show the player's path on the map
// End of orders

Implementation

{$R *.DFM}

(*----------------------------------------------------------------------------*)
(* Loading graphics                                                           *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.LoadBlock;
Var
  Cpt    : Byte;
  StrCpt : String;
Begin
// The background: floor and ceiling
     BMPBlock.FloorCeiling := TBitmap.Create;
     BMPBlock.FloorCeiling.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Block\SolPlafond.BMP');
     BMPBlock.FloorCeiling.PixelFormat := pf24Bit;
     BMPBlock.SolPlafondWidth := BMPBlock.FloorCeiling.Width;
     BMPBlock.SolPlafondHeight := BMPBlock.FloorCeiling.Height;

// The exit
     BMPBlock.Exit := TBitmap.Create;
     BMPBlock.Exit.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Block\Sortie.BMP');
     BMPBlock.Exit.PixelFormat := pf24Bit;
     BMPBlock.ExitWidth := BMPBlock.Exit.Width;
     BMPBlock.ExitHeight := BMPBlock.Exit.Height;

// The 7 styles of cubes (left - center - right)
     For Cpt := 1 To 3 Do
         Begin
              StrCpt := IntToStr(Cpt);

              BMPBlock.Cube[Cpt].Left := TBitmap.Create;
              BMPBlock.Cube[Cpt].Left.LoadFromFile(ExtractFilePath(Application.ExeName) +'Block\Cube' + StrCpt + 'Gauche.BMP');
              BMPBlock.Cube[Cpt].Left.PixelFormat := pf24Bit;
              BMPBlock.Cube[Cpt].LeftWidth := BMPBlock.Cube[Cpt].Left.Width;
              BMPBlock.Cube[Cpt].LeftHeight := BMPBlock.Cube[Cpt].Left.Height;

              BMPBlock.Cube[Cpt].Center := TBitmap.Create;
              BMPBlock.Cube[Cpt].Center.LoadFromFile(ExtractFilePath(Application.ExeName) +'Block\Cube' + StrCpt + 'Centre.BMP');
              BMPBlock.Cube[Cpt].Center.PixelFormat := pf24Bit;
              BMPBlock.Cube[Cpt].CenterWidth := BMPBlock.Cube[Cpt].Center.Width;
              BMPBlock.Cube[Cpt].CenterHeight := BMPBlock.Cube[Cpt].Center.Height;

              BMPBlock.Cube[Cpt].Right := TBitmap.Create;
              BMPBlock.Cube[Cpt].Right.LoadFromFile(ExtractFilePath(Application.ExeName) +'Block\Cube' + StrCpt + 'Droite.BMP');
              BMPBlock.Cube[Cpt].Right.PixelFormat := pf24Bit;
              BMPBlock.Cube[Cpt].RightWidth := BMPBlock.Cube[Cpt].Right.Width;
              BMPBlock.Cube[Cpt].RightHeight := BMPBlock.Cube[Cpt].Right.Height;
         End;
End;

Procedure TForm1.LoadSriteMap;
Var
  CptSens : TypeSens;
Begin
     For CptSens := Nord To West Do
         Begin
              BMPMapSprite.Player[CptSens] := TBitmap.Create;
              BMPMapSprite.Enemy[CptSens] := TBitmap.Create;
         End;

     BMPMapSprite.Player[Nord].LoadFromFile(ExtractFilePath(Application.ExeName) +'MapSprites\CarteJoueurNord.BMP');
     BMPMapSprite.Player[East].LoadFromFile(ExtractFilePath(Application.ExeName) +'MapSprites\CarteJoueurEst.BMP');
     BMPMapSprite.Player[South].LoadFromFile(ExtractFilePath(Application.ExeName) +'MapSprites\CarteJoueurSud.BMP');
     BMPMapSprite.Player[West].LoadFromFile(ExtractFilePath(Application.ExeName) +'MapSprites\CarteJoueurOuest.BMP');

     BMPMapSprite.Enemy[Nord].LoadFromFile(ExtractFilePath(Application.ExeName) +'MapSprites\CarteEnnemiNord.BMP');
     BMPMapSprite.Enemy[East].LoadFromFile(ExtractFilePath(Application.ExeName) +'MapSprites\CarteEnnemiEst.BMP');
     BMPMapSprite.Enemy[South].LoadFromFile(ExtractFilePath(Application.ExeName) +'MapSprites\CarteEnnemiSud.BMP');
     BMPMapSprite.Enemy[West].LoadFromFile(ExtractFilePath(Application.ExeName) +'MapSprites\CarteEnnemiOuest.BMP');

     For CptSens := Nord To West Do
         Begin
              BMPMapSprite.Player[CptSens].PixelFormat := pf24Bit;
              BMPMapSprite.Enemy[CptSens].PixelFormat := pf24Bit;
         End;
End;

Procedure TForm1.LoadEnemySprite;
Var
  CptSens : TypeSens;
Begin
     For CptSens := Nord To West Do
         BMPEnemySprite[CptSens].Pixel := TBitmap.Create;

     BMPEnemySprite[Nord].Pixel.LoadFromFile(ExtractFilePath(Application.ExeName) +'EnemySprites\EnnemiNord.BMP');
     BMPEnemySprite[East].Pixel.LoadFromFile(ExtractFilePath(Application.ExeName) +'EnemySprites\EnnemiEst.BMP');
     BMPEnemySprite[South].Pixel.LoadFromFile(ExtractFilePath(Application.ExeName) +'EnemySprites\EnnemiSud.BMP');
     BMPEnemySprite[West].Pixel.LoadFromFile(ExtractFilePath(Application.ExeName) +'EnemySprites\EnnemiOuest.BMP');

     For CptSens := Nord To West Do
         Begin
              BMPEnemySprite[CptSens].Pixel.PixelFormat := pf24Bit;
              BMPEnemySprite[CptSens].PixelWidth := BMPEnemySprite[CptSens].Pixel.Width;
              BMPEnemySprite[CptSens].PixelHeight := BMPEnemySprite[CptSens].Pixel.Height;
         End;
End;

Procedure TForm1.LoadArrowMouse;
Var
  Cpt : Byte;
Begin
     For Cpt := 1 To 6 Do
         BMPArrowMouse[Cpt] := TBitmap.Create;

     BMPArrowMouse[1].LoadFromFile(ExtractFilePath(Application.ExeName) +'Arrows\FlecheSourisPivoteGauche.BMP');
     BMPArrowMouse[2].LoadFromFile(ExtractFilePath(Application.ExeName) +'Arrows\FlecheSourisAvant.BMP');
     BMPArrowMouse[3].LoadFromFile(ExtractFilePath(Application.ExeName) +'Arrows\FlecheSourisPivoteDroite.BMP');
     BMPArrowMouse[4].LoadFromFile(ExtractFilePath(Application.ExeName) +'Arrows\FlecheSourisGauche.BMP');
     BMPArrowMouse[5].LoadFromFile(ExtractFilePath(Application.ExeName) +'Arrows\FlecheSourisArriere.BMP');
     BMPArrowMouse[6].LoadFromFile(ExtractFilePath(Application.ExeName) +'Arrows\FlecheSourisDroite.BMP');

     For Cpt := 1 To 6 Do
         Begin
              BMPArrowMouse[Cpt].PixelFormat := pf24Bit;
              BMPArrowMouse[Cpt].Transparent := True;
              BMPArrowMouse[Cpt].TransparentColor := BMPArrowMouse[Cpt].Canvas.Pixels[0, 0];
         End;
End;

Procedure TForm1.LoadCompass;
Var
  Cpt : TypeSens;
Begin
     For Cpt := Nord To West Do
         BMPCompass[Cpt] := TBitmap.Create;

     BMPCompass[Nord].LoadFromFile(ExtractFilePath(Application.ExeName) +'Compass\North.BMP');
     BMPCompass[East].LoadFromFile(ExtractFilePath(Application.ExeName) +'Compass\East.BMP');
     BMPCompass[South].LoadFromFile(ExtractFilePath(Application.ExeName) +'Compass\South.BMP');
     BMPCompass[West].LoadFromFile(ExtractFilePath(Application.ExeName) +'Compass\West.BMP');

     For Cpt := Nord To West Do
         Begin
              BMPCompass[Cpt].PixelFormat := pf24Bit;
              BMPCompass[Cpt].Transparent := True;
              BMPCompass[Cpt].TransparentColor := BMPCompass[Cpt].Canvas.Pixels[0, 0];
         End;
End;

Procedure TForm1.LoadWinLoss;
Begin
     BMPWon := TBitmap.Create;
     BMPWon.LoadFromFile(ExtractFilePath(Application.ExeName) +'Miscellaneous\Gagne.BMP');
     BMPWon.PixelFormat := pf24Bit;
     BMPWon.Transparent := True;
     BMPWon.TransparentColor := BMPWon.Canvas.Pixels[0, 0];

     BMPPerdu := TBitmap.Create;
     BMPPerdu.LoadFromFile(ExtractFilePath(Application.ExeName) +'Miscellaneous\Perdu.BMP');
     BMPPerdu.PixelFormat := pf24Bit;
     BMPPerdu.Transparent := True;
     BMPPerdu.TransparentColor := BMPPerdu.Canvas.Pixels[0, 0];
End;

(*----------------------------------------------------------------------------*)
(* CLOSE                                                                      *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  Cpt     : Byte;
  CptSens : TypeSens;
Begin
     Timer1.Enabled := False;

// Free the memory
     BMPBuffer.Free;

     With BMPBlock Do
          Begin
               FloorCeiling.Free;
               Exit.Free;
               For Cpt := 1 To 3 Do
                   With Cube[Cpt] Do
                        Begin
                             Left.Free;
                             Center.Free;
                             Right.Free;
                        End;
          End;

     BMPMap.Free;
     BMPCacheMap.Free;
     BMPBufferMap.Free;

     For CptSens := Nord To West Do
         Begin
              BMPMapSprite.Player[CptSens].Free;
              BMPMapSprite.Enemy[CptSens].Free;

              BMPEnemySprite[CptSens].Pixel.Free;
         End;

     For Cpt := 1 To 6 Do
         BMPArrowMouse[Cpt].Free;

     For CptSens := Nord To West Do
         BMPCompass[CptSens].Free;

     BMPWon.Free;
     BMPPerdu.Free;

     BMPForm1.Free;
End;

(*----------------------------------------------------------------------------*)
(* Initializations                                                            *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.InitLevel;
Const Buffer : Array [1..20] Of String = ('13212332212212323321',
                                          '30000000210000130131',
                                          '10123210230130020133',
                                          '20003120000133000121',
                                          '12201232102323020001',
                                          '10000002101200003201',
                                          '20313102200003202303',
                                          '10231203322101100002',
                                          '10032200002300003301',
                                          '33031232201201012103',
                                          '32000322202201000001',
                                          '23130000003201103212',
                                          '11230232100002100002',
                                          '32320322123032322011',
                                          '20000321000000022013',
                                          '10320000021213000021',
                                          '10311232012210010123',
                                          '30200000002310200312',
                                          '30220120300000001323',
                                          '13212313211223322123');
Var X, Y    : Byte;
    Color : TColor;
Begin
     With Laby Do
          Begin
               XSize := 20;
               YSize := 20;

               XDebut := 2;
               YDebut := 19;
               SensBeginning := Nord;

               XExit := 17;
               YExit := 2;

               BMPMap := TBitmap.Create;
               BMPMap.PixelFormat := pf24Bit;
               BMPMap.Width := XSize;
               BMPMap.Height := YSize;
               MapZoom := 5;

               BMPCacheMap := TBitmap.Create;      // To be placed on the map
               BMPCacheMap.PixelFormat := pf24Bit; // The black will hide part of the map
               BMPCacheMap.Width := XSize;       // The white will reveal the path already taken by the player
               BMPCacheMap.Height := YSize;

               BMPBufferMap := TBitmap.Create;     // To prevent the card from flashing
               BMPBufferMap.PixelFormat := pf24Bit;
               BMPBufferMap.Width := XSize * MapZoom;
               BMPBufferMap.Height := YSize * MapZoom;

               For Y := 1 To YSize Do
                   For X := 1 To XSize Do
                       Begin
                            Block[X, Y] := Ord(Buffer[Y, X]) - 48;

                            Case Block[X, Y] Of
                                 0    : Color := RGB(215, 171, 83);
                                 1..3 : Color := RGB(127, 83, 0);
                            Else Color := RGB(255, 0, 0);
                            End;

                            BMPMap.Canvas.Pixels[X-1, Y-1] := Color;
                            // Hide areas of the map that the player has not yet visited.
                            BMPCacheMap.Canvas.Pixels[X-1, Y-1] := RGB(0, 0, 0);
                       End;
          End;

     EnemyMax := 7;
     For X := 1 To EnemyMax Do
         Begin
              Enemy[X].XPos := X +1;
              Enemy[X].YPos := 2;
              Enemy[X].Sens := Nord;
         End;
     EnemyPause := 0;
End;

Procedure TForm1.InitGame;
Begin
     Player.XPos := Laby.XDebut;
     Player.YPos := Laby.YDebut;
     Player.Sens := Laby.SensBeginning;
End;

(*----------------------------------------------------------------------------*)
(* PROCEDURE FORM_CREATE                                                      *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.FormCreate(Sender: TObject);
Begin
     Timer1.Enabled := False;
     Timer3.Enabled := False;
     Timer2.Enabled := False;

     Randomize;

     //Form1.Caption := ProgramName + '  Ver ' + VersionProgramme;

// Create the hidden screen
     BMPBuffer := TBitmap.Create;
     BMPBuffer.PixelFormat := pf24Bit;
     BMPBuffer.Width := 567;
     BMPBuffer.Height := 286;

// Loading graphics
     LoadBlock;
     LoadSriteMap;
     LoadEnemySprite;
     LoadArrowMouse;
     LoadCompass;
     LoadWinLoss;

// Initializations
     InitLevel;
     InitGame;

     WavePause := Random(100) + 50; // The next sound in x time

     DeadPlayer := False;
     SwAnimDead := False;
     CptAnimDead := 0;
     CptAnimWon := 200;

// Hide the mouse when it is over PaintBox1
     PaintBox1.Cursor := crNone;

// Commands for the programmer during the testing phase
     SwDark := True;
     CheckBox1.Checked := SwDark;
     DarkPercent := 30;
     TrackBar1.Position := DarkPercent;
     EditSombre.Text := IntToStr(DarkPercent);

     ScrollBar1.Position := 100;
     Label1.Caption := 'Timer speed : ' + IntToStr(ScrollBar1.Position);
     Timer1.Interval := ScrollBar1.Position;

     MaxW := 0; MaxH := 0;
     Label3.Caption := 'Max width.: ' + IntToStr(MaxW);
     Label4.Caption := 'Max height.: ' + IntToStr(MaxH);

     SwCacheMap := True;
     CheckBox2.Checked := SwCacheMap;
// End of orders

     BMPForm1 := TBitmap.Create;
     BMPForm1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Miscellaneous\EcranDeFond.BMP');
     BMPForm1.PixelFormat := pf24Bit;

     Timer1.Enabled := True;
End; {TForm1.FormCreate}

(*----------------------------------------------------------------------------*)
(* To display enemies with transparency and zoom                              *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.ShowEnemySprite(XPos, YPos, Zoom : Integer;
                                      Sens             : TypeSens);
Var W, H : Integer;
    Z    : Real;
Begin
// Calculate the zoom for width and height
     Z := (Zoom / BMPEnemySprite[Sens].PixelHeight) * 0.82;
     W := Trunc(BMPEnemySprite[Sens].PixelWidth * Z);
     H := Trunc(BMPEnemySprite[Sens].PixelHeight * Z);

     XPos := XPos - (W Div 2); // Center the enemy
     YPos := YPos - H;

// Will be used to zoom in on enemies
     BMPZoom := TBitmap.Create;
     BMPZoom.PixelFormat := pf24Bit;
     BMPZoom.Width := W;
     BMPZoom.Height := H;

     BMPZoom.Canvas.CopyRect(Bounds(0, 0, W, H),
                             BMPEnemySprite[Sens].Pixel.Canvas,
                             Bounds(0, 0, BMPEnemySprite[Sens].PixelWidth,
                                          BMPEnemySprite[Sens].PixelHeight));

     BMPZoom.Transparent := True;
     BMPZoom.TransparentColor := BMPZoom.Canvas.Pixels[0, 0];
     BMPBuffer.canvas.Draw(XPos, YPos, BMPZoom);
     BMPZoom.Free;

// Commands for the programmer during the testing phase
     If W > MaxW Then MaxW := W;
     If H > MaxH Then MaxH := H;
     Label3.Caption := 'Max width.: ' + IntToStr(MaxW);
     Label4.Caption := 'Max height.: ' + IntToStr(MaxH);
// End of orders
End;

(*----------------------------------------------------------------------------*)
(* To display the small map with the black cover                              *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.ShowMapHide;
Begin
     BMPZoom := TBitmap.Create;  // Create the map cover to the size of the map
     BMPZoom.PixelFormat := pf24Bit;
     BMPZoom.Width := BMPCacheMap.Width * MapZoom;
     BMPZoom.Height := BMPCacheMap.Width * MapZoom;

     BMPZoom.Canvas.CopyRect(Bounds(0, 0, BMPZoom.Width, BMPZoom.Height),
                             BMPCacheMap.Canvas,
                             Bounds(0, 0, BMPCacheMap.Width, BMPCacheMap.Height));

     BMPZoom.Transparent := True;
     BMPZoom.TransparentColor := RGB(255, 255, 255);
     BMPBufferMap.Canvas.Draw(0, 0, BMPZoom);
     BMPZoom.Free;
End;

(*----------------------------------------------------------------------------*)
(* Timers                                                                     *)
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
(* Main part of the game                                                      *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.Timer1Timer(Sender: TObject);
Var
  Cpt, CptEnemy, X, Y : Integer;
  CptSens             : TypeSens;
Begin
//     GetCursorPos(TCoordSouris); // Mouse coordinates relative to the screen
//     TCoordSouris.X := TCoordSouris.X - Left - 24; // Positioning on the game window
//     TCoordSouris.Y := TCoordSouris.Y - Top - 49;

// We stop calling the Timer in case the routine takes too long to execute
     Timer1.Enabled := False;

// A little ambient sound
     Dec(WavePause);
     If WavePause = 0 Then
        Begin
             CodeWave := Random(4); // Lequel?
             Case CodeWave Of
                  0 : sndPlaySound('Wav\Fall1.WAV', snd_Async);
                  1 : sndPlaySound('Wav\Fall2.WAV', snd_Async);
                  2 : sndPlaySound('Wav\Drop1.WAV', snd_Async);
                  3 : sndPlaySound('Wav\Drop2.WAV', snd_Async);
             End;
             WavePause := Random(100) + 50; // The next sound in x time
        End;

// Change the direction of enemies
     Inc(EnemyPause);
     If EnemyPause = 10 Then
        Begin
             EnemyPause := 0;
             For CptEnemy := 1 To EnemyMax Do
                 Begin
                      Laby.Block[Enemy[CptEnemy].XPos, Enemy[CptEnemy].YPos] := 0;

                      EnemySensPossible.HowMuch := 0;
                      For CptSens := Nord To West Do // Test possible directions
                          Begin
(*0 1 2 3*)                    TSensInverse := TypeSens((Ord(Enemy[CptEnemy].Sens) + 2) Mod 4);
(*N E S O => CptSens*)
(*S O N E => TSensInverse*)    If CptSens <> TSensInverse  Then // But not going back, it creates an unpleasant ping-pong effect.
(*2 3 0 1*)                       If Laby.Block[Enemy[CptEnemy].XPos + Shift[CptSens].X,
                                               Enemy[CptEnemy].YPos + Shift[CptSens].Y] = 0 Then
                                     Begin // If possible ...
                                          Inc(EnemySensPossible.HowMuch); // ... One more sense ...
                                          EnemySensPossible.Sens[EnemySensPossible.HowMuch] := CptSens; // ... We're storing it for a raffle.
                                     End;
                          End;
                      If EnemySensPossible.HowMuch = 0 Then // Si = 0 => The enemy is blocked either by another enemy or in a dead end.
                         Begin // In this case, the enemy has the right to retreat.
                              Inc(EnemySensPossible.HowMuch); // ... One more sense ...
                              EnemySensPossible.Sens[EnemySensPossible.HowMuch] := TSensInverse; // ... that of the return
                         End;

                      Enemy[CptEnemy].Sens := EnemySensPossible.Sens[Random(EnemySensPossible.HowMuch) + 1];

                      // Calculate the enemy's new position
                      Enemy[CptEnemy].XPos := Enemy[CptEnemy].XPos + Shift[Enemy[CptEnemy].Sens].X;
                      Enemy[CptEnemy].YPos := Enemy[CptEnemy].YPos + Shift[Enemy[CptEnemy].Sens].Y;

                      // Define the enemy's direction in the labyrinth.
                      // This will be used to display the enemy in relation to the player's direction.
                      Case Enemy[CptEnemy].Sens Of
                           Nord  : Laby.Block[Enemy[CptEnemy].XPos, Enemy[CptEnemy].YPos] := 8;
                           East   : Laby.Block[Enemy[CptEnemy].XPos, Enemy[CptEnemy].YPos] := 9;
                           South   : Laby.Block[Enemy[CptEnemy].XPos, Enemy[CptEnemy].YPos] := 10;
                           West : Laby.Block[Enemy[CptEnemy].XPos, Enemy[CptEnemy].YPos] := 11;
                      End;
                 End;
         End;

// Calculate the blocks to display
      For Cpt := 1 To 8 Do // Initialize everything now because in the second loop, we might not go as far as Cpt=8
          Begin            // This initialization will prevent crashes in the "Display 3D blocks" section.
               GuideBloc[Cpt].Left := 0; // Nothing left
               GuideBloc[Cpt].Center := 0; // Nothing in the center
               GuideBloc[Cpt].Right := 0; // Nothing to the right
               GuideBloc[Cpt].SwExit := False; // No visible exit

               GuideBloc[Cpt].SwCenter := False; // No enemy on the square
               GuideBloc[Cpt].SensCenter := Nord; // Default enemy sense
          End;

      TXPos := Player.XPos; TYPos := Player.YPos; // Player's position in the maze
      TSwCenterBlock := False;
      Cpt := 0;
    Repeat
          Inc(Cpt);

{ +---> } If Not TSwCenterBlock Then // To avoid displaying the map behind a block
{ I }        Begin // Reveal the areas of the map where the player has been
{ I }             BMPCacheMap.Canvas.Pixels[TXPos-1, TYPos-1] := RGB(255, 255, 255);
{ I }             BMPCacheMap.Canvas.Pixels[TXPos+Shift[Player.Sens].XLEFT-1, TYPos+Shift[Player.Sens].YLEFT-1] := RGB(255, 255, 255);
{ I }             BMPCacheMap.Canvas.Pixels[TXPos+Shift[Player.Sens].XRight-1, TYPos+Shift[Player.Sens].YRight-1] := RGB(255, 255, 255);
{ I }        End;
{ I }
{ I }     If (TXPos = Laby.XExit) And (TYPos = Laby.YExit) Then GuideBloc[Cpt].SwExit := True;
{ I }     TCode := Laby.Block[TXPos, TYPos];
{ I }     Case TCode Of // Test in the center
{ I }          1..3  : Begin
{ I }                       GuideBloc[Cpt].Center := Laby.Block[TXPos, TYPos]; // A block ...
{ +-----------------------} TSwCenterBlock := True;
                       End;
               8..11 : Begin
                            GuideBloc[Cpt].SwCenter := True; // ... or an enemy
                            Case TCode Of // It's quite cumbersome, but it's to define the enemy's direction relative to the player's.
{ 8 : si l'ennemi va au Nord ...}8  : Case Player.Sens Of // But since these are CASE OF scenarios, not everything is executed.
                                           Nord  : GuideBloc[Cpt].SensCenter := Nord;
                                           East   : GuideBloc[Cpt].SensCenter := West;
                                           South   : GuideBloc[Cpt].SensCenter := South;
                                           West : GuideBloc[Cpt].SensCenter := East;
                                      End;
                                 9  : Case Player.Sens Of { 9 : if the enemy goes to the East ...}
                                           Nord  : GuideBloc[Cpt].SensCenter := East;
                                           East   : GuideBloc[Cpt].SensCenter := Nord;
                                           South   : GuideBloc[Cpt].SensCenter := West;
                                           West : GuideBloc[Cpt].SensCenter := South;
                                      End;
                                 10 : Case Player.Sens Of { 10 : if the enemy goes south ...}
                                           Nord  : GuideBloc[Cpt].SensCenter := South;
                                           East   : GuideBloc[Cpt].SensCenter := East;
                                           South   : GuideBloc[Cpt].SensCenter := Nord;
                                           West : GuideBloc[Cpt].SensCenter := West;
                                      End;
                                 11 : Case Player.Sens Of { 11 : if the enemy goes west...}
                                           Nord  : GuideBloc[Cpt].SensCenter := West;
                                           East   : GuideBloc[Cpt].SensCenter := South;
                                           South   : GuideBloc[Cpt].SensCenter := East;
                                           West : GuideBloc[Cpt].SensCenter := Nord;
                                      End;
                            End;
                       End;
          End;

          If Laby.Block[TXPos+Shift[Player.Sens].XLEFT, TYPos+Shift[Player.Sens].YLEFT] In [1..3] Then // Test left
              GuideBloc[Cpt].Left := Laby.Block[TXPos+Shift[Player.Sens].XLEFT, TYPos+Shift[Player.Sens].YLEFT];

          If Laby.Block[TXPos+Shift[Player.Sens].XRight, TYPos+Shift[Player.Sens].YRight] In [1..3] Then // Test right
             GuideBloc[Cpt].Right := Laby.Block[TXPos+Shift[Player.Sens].XRight, TYPos+Shift[Player.Sens].YRight];

          TXPos := TXPos + Shift[Player.Sens].X;
          TYPos := TYPos + Shift[Player.Sens].Y;
    Until (Cpt = 8) Or (TXPos < 1) Or (TXpos > Laby.XSize) Or (TYPos < 1) Or (TYPos > Laby.YSize); // If outside the maze

// Display the 3D blocks
     BMPBuffer.Canvas.CopyRect(Bounds(94, 0, BMPBlock.SolPlafondWidth, BMPBlock.SolPlafondHeight),
                               BMPBlock.FloorCeiling.Canvas,
                               Bounds(0, 0, BMPBlock.SolPlafondWidth, BMPBlock.SolPlafondHeight));
     For Cpt := 8 DownTo 1 Do
         Begin
              If GuideBloc[Cpt].SwExit Then
              BMPBuffer.Canvas.CopyRect(Rect(CoordBlock[9-Cpt].Sol.X1, CoordBlock[9-Cpt].Sol.Y1, CoordBlock[9-Cpt].Sol.X2, CoordBlock[9-Cpt].Sol.Y2),
                                        BMPBlock.Exit.Canvas,
                                        Bounds(0, 0, BMPBlock.ExitWidth, BMPBlock.ExitHeight));

              If GuideBloc[Cpt].Left <> 0 Then
              BMPBuffer.Canvas.CopyRect(Rect(CoordBlock[9-Cpt].LEFT.X1, CoordBlock[9-Cpt].LEFT.Y1, CoordBlock[9-Cpt].LEFT.X2, CoordBlock[9-Cpt].LEFT.Y2),
                                        BMPBlock.Cube[GuideBloc[Cpt].Left].Left.Canvas,
                                        Bounds(0, 0, BMPBlock.Cube[GuideBloc[Cpt].Left].LeftWidth, BMPBlock.Cube[GuideBloc[Cpt].Left].LeftHeight));

              If GuideBloc[Cpt].Right <> 0 Then
              BMPBuffer.Canvas.CopyRect(Rect(CoordBlock[9-Cpt].RIGHT.X1, CoordBlock[9-Cpt].RIGHT.Y1, CoordBlock[9-Cpt].RIGHT.X2, CoordBlock[9-Cpt].RIGHT.Y2),
                                        BMPBlock.Cube[GuideBloc[Cpt].Right].Right.Canvas,
                                        Bounds(0, 0, BMPBlock.Cube[GuideBloc[Cpt].Right].RightWidth, BMPBlock.Cube[GuideBloc[Cpt].Right].RightHeight));

              If GuideBloc[Cpt].Center <> 0 Then
              BMPBuffer.Canvas.CopyRect(Rect(CoordBlock[9-Cpt].CENTER.X1, CoordBlock[9-Cpt].CENTER.Y1, CoordBlock[9-Cpt].CENTER.X2, CoordBlock[9-Cpt].CENTER.Y2),
                                        BMPBlock.Cube[GuideBloc[Cpt].Center].Center.Canvas,
                                        Bounds(0, 0, BMPBlock.Cube[GuideBloc[Cpt].Center].CenterWidth, BMPBlock.Cube[GuideBloc[Cpt].Center].CenterHeight));

// Display enemies on the 3D screen
              If GuideBloc[Cpt].SwCenter Then
                 Begin
                      TXPos := 283;
                      TYPos := YPosEnemy[Cpt];
                      ShowEnemySprite(TXPos, TYPos, CoordBlock[9-Cpt].CENTER.Y2 - CoordBlock[9-Cpt].CENTER.Y1, GuideBloc[Cpt].SensCenter);
                 End;

// Darken the labyrinth
              If SwDark Then
                 Begin
                      For Y := CoordBlock[9-Cpt].CENTER.Y1 To CoordBlock[9-Cpt].CENTER.Y2 Do
                          Begin
                               TScanLine := BMPBuffer.ScanLine[Y];
                               For X := 0 To 566 Do
                                   Begin
                                        TRed := TScanLine[X].Red;
                                        TGreen  := TScanLine[X].Green;
                                        TBlue  := TScanLine[X].Blue;

                                        TRed := TRed - DarkPercent; If TRed < 0 Then TRed := 0;
                                        TGreen  := TGreen  - DarkPercent; If TGreen  < 0 Then TGreen  := 0;
                                        TBlue  := TBlue  - DarkPercent; If TBlue  < 0 Then TBlue  := 0;

                                        TScanLine[X].Red := TRed;
                                        TScanLine[X].Green  := TGreen;
                                        TScanLine[X].Blue  := TBlue;
                                   End;
                          End;
                 End;
         End;

// Display the compass
     BMPBuffer.Canvas.Draw(267, 14, BMPCompass[Player.Sens]);

// Display the buffer in PaintBox1
     PaintBox1.Canvas.CopyRect(Bounds(0, 0, 316, 237),
                               BmpBuffer.Canvas, Bounds(125, 16, 316, 237));

// Show mouse arrow
     If ((TCoordMouse.X >= 16) And (TCoordMouse.X <= 94)) And ((TCoordMouse.Y >= 16) And (TCoordMouse.Y <= 102)) Then
        PaintBox1.Canvas.Draw(TCoordMouse.X-16, TCoordMouse.Y-16, BMPArrowMouse[1])
     Else If ((TCoordMouse.X >= 95) And (TCoordMouse.X <= 189)) And ((TCoordMouse.Y >= 16) And (TCoordMouse.Y <= 102)) Then
             PaintBox1.Canvas.Draw(TCoordMouse.X-16, TCoordMouse.Y-16, BMPArrowMouse[2])
          Else If ((TCoordMouse.X >= 190) And (TCoordMouse.X <= 299)) And ((TCoordMouse.Y >= 16) And (TCoordMouse.Y <= 102)) Then
                  PaintBox1.Canvas.Draw(TCoordMouse.X-16, TCoordMouse.Y-16, BMPArrowMouse[3])
               Else If ((TCoordMouse.X >= 16) And (TCoordMouse.X <= 94)) And ((TCoordMouse.Y >= 103) And (TCoordMouse.Y <= 220)) Then
                       PaintBox1.Canvas.Draw(TCoordMouse.X-16, TCoordMouse.Y-16, BMPArrowMouse[4])
                    Else If ((TCoordMouse.X >= 95) And (TCoordMouse.X <= 189)) And ((TCoordMouse.Y >= 103) And (TCoordMouse.Y <= 220)) Then
                            PaintBox1.Canvas.Draw(TCoordMouse.X-16, TCoordMouse.Y-16, BMPArrowMouse[5])
                         Else If ((TCoordMouse.X >= 190) And (TCoordMouse.X <= 299)) And ((TCoordMouse.Y >= 103) And (TCoordMouse.Y <= 220)) Then
                                 PaintBox1.Canvas.Draw(TCoordMouse.X-16, TCoordMouse.Y-16, BMPArrowMouse[6]);

// Show map
     BMPMap.Canvas.Pixels[Laby.XExit-1, Laby.YExit-1] := RGB(255, 255, 0); // Mark the exit on the map with a yellow dot
     BMPBufferMap.Canvas.CopyRect(Bounds(0, 0, BMPMap.Width*MapZoom, BMPMap.Height*MapZoom),
                                    BMPMap.Canvas,
                                    Bounds(0, 0, BMPMap.Width, BMPMap.Height));

// Position the player on the map
     TXPos := (Player.XPos-1) * MapZoom; // Player's position on the map
     TYPos := (Player.YPos-1) * MapZoom;

     TXSize := Trunc((BMPMapSprite.Player[Player.Sens].Width / 14) * MapZoom); // Zoom in on the player to match the map size
     TYSize := Trunc((BMPMapSprite.Player[Player.Sens].Height / 14) * MapZoom); // Zoom in on the player to match the map size

     BMPBufferMap.Canvas.CopyRect(Bounds(TXPos, TYPos, TXSize, TYSize),
                                    BMPMapSprite.Player[Player.Sens].Canvas,
                                    Bounds(0, 0, BMPMapSprite.Player[Player.Sens].Width, BMPMapSprite.Player[Player.Sens].Height));

// Position the enemies on the map
     For CptEnemy := 1 To EnemyMax Do
         Begin
              TXPos := (Enemy[CptEnemy].XPos-1) * MapZoom; // Enemy position on the map
              TYPos := (Enemy[CptEnemy].YPos-1) * MapZoom;

// We retrieve the player's TXSize and TYSize
              BMPBufferMap.Canvas.CopyRect(Bounds(TXPos, TYPos, TXSize, TYSize),
                                             BMPMapSprite.Enemy[Enemy[CptEnemy].Sens].Canvas,
                                             Bounds(0, 0, BMPMapSprite.Enemy[Enemy[CptEnemy].Sens].Width, BMPMapSprite.Enemy[Enemy[CptEnemy].Sens].Height));
         End;

     If SwCacheMap Then ShowMapHide;

     PaintBox2.Canvas.Draw(0, 0, BMPBufferMap);

// Is the player dead?
     For Cpt := 1 To EnemyMax Do
         If (Enemy[Cpt].XPos = Player.XPos) And (Enemy[Cpt].YPos = Player.YPos) Then DeadPlayer := True;

// Order for testing phase
     Label2.Caption := 'Playful sense : ' + IntToStr(Ord(Player.Sens));
     Label5.Caption := 'MouseX = ' + IntToStr(TCoordMouse.X);
     Label6.Caption := 'MouseY = ' + IntToStr(TCoordMouse.Y);
     Label7.Caption := 'Next wave at 0 : ' + IntToStr(WavePause);
     If DeadPlayer Then Label8.Caption := 'Player is dead'
                     Else Label8.Caption := 'Player not dead';
// Order complete for testing phase

     If (Player.XPos = Laby.XExit) And (Player.YPos = Laby.YExit) Then
        Begin // If the player is on the exit
             Timer3.Enabled := True;
             BMPBuffer.Canvas.Draw(150, 90, BMPWon);
        End
     Else If Not DeadPlayer Then Timer1.Enabled := True // If the player is not dead, we start again.
          Else Begin // Otherwise ...
                    Timer2.Enabled := True;
                    BMPBuffer.Canvas.Draw(210, 35, BMPPerdu);
               End;
End;

(*----------------------------------------------------------------------------*)
(* Animation when the player has won                                          *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.Timer3Timer(Sender: TObject);
Var
  X, Y : Integer;
Begin
     For Y := 16 To 285 Do
         Begin
              TScanLine := BMPBuffer.ScanLine[Y];
              For X := 125 To 440 Do
                  Begin
                       TRed := (TScanLine[X-1].Red + TScanLine[X+0].Red + TScanLine[X+1].Red) Div 3;
                       TGreen  := (TScanLine[X-1].Green  + TScanLine[X+0].Green  + TScanLine[X+1].Green) Div 3;
                       TBlue  := (TScanLine[X-1].Blue  + TScanLine[X+0].Blue  + TScanLine[X+1].Blue) Div 3;

                       TScanLine[X].Red := (TRed);
                       TScanLine[X].Green  := (TGreen);
                       TScanLine[X].Blue  := (TBlue);
                  End;
         End;

     BMPBuffer.Canvas.Draw(150, 90, BMPWon);

     PaintBox1.Canvas.CopyRect(Bounds(0, 0, 316, 237),
                               BmpBuffer.Canvas, Bounds(125, 16, 316, 237));

     Dec(CptAnimWon);
     If CptAnimWon = 0 Then Close; // Calling TForm1.FormClose and then exiting the program
End;

(*----------------------------------------------------------------------------*)
(* Animation when the player has lost                                         *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.Timer2Timer(Sender: TObject);
Var
  X, Y : Integer;
Begin
     For Y := 16 To 285 Do
         Begin
              TScanLine := BMPBuffer.ScanLine[Y];
              For X := 125 To 440 Do
                  Begin
                       TRed := TScanLine[X].Red;
                       TGreen  := TScanLine[X].Green;
                       TBlue  := TScanLine[X].Blue;

                       If TRed < 255 Then Inc(TRed);
                       If TGreen > 0 Then Dec(TGreen);
                       If TBlue > 0 Then Dec(TBlue);

                       TScanLine[X].Red := TRed;
                       TScanLine[X].Green  := TGreen;
                       TScanLine[X].Blue  := TBlue;
                  End;
         End;

     PaintBox1.Canvas.CopyRect(Bounds(0, 0, 316, 237),
                               BmpBuffer.Canvas, Bounds(125, 16, 316, 237-CptAnimDead));

     Inc(CptAnimDead, 1);
     If CptAnimDead >= 236 Then
        Begin
             CptAnimDead := 236;
             SwAnimDead := True;
        End;

     If SwAnimDead Then Close; // Calling TForm1.FormClose and then exiting the program
End;

(*----------------------------------------------------------------------------*)
(* Player movement                                                            *)
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
(* Procedures for calculating displacements                                   *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.PlayerMovementUp;
Var
  XPos, YPos : Integer;
Begin
// Calculate the player's new position
     XPos := Player.XPos + Shift[Player.Sens].X;
     YPos := Player.YPos + Shift[Player.Sens].Y;

// Can the player go?
     Case Laby.Block[XPos, YPos] Of
              0 : Begin // Yes, we confirm the new coordinates
                       Player.XPos := XPos;
                       Player.YPos := YPos;
                  End;
          8..11 : DeadPlayer := True; // An enemy
     End;
End;

Procedure TForm1.PlayerMovementDown;
Var
  XPos, YPos : Integer;
Begin
// Calculate the player's new position
     XPos := Player.XPos - Shift[Player.Sens].X;
     YPos := Player.YPos - Shift[Player.Sens].Y;

// Can the player go?
     Case Laby.Block[XPos, YPos] Of
              0 : Begin // Yes, we confirm the new coordinates
                       Player.XPos := XPos;
                       Player.YPos := YPos;
                  End;
          8..11 : DeadPlayer := True; // An enemy
     End;
End;

Procedure TForm1.PlayerMovementLeft;
Var
  XPos, YPos : Integer;
Begin
// Calculate the player's new position
     XPos := Player.XPos + Shift[Player.Sens].Y;
     YPos := Player.YPos - Shift[Player.Sens].X;

// Can the player go?
     Case Laby.Block[XPos, YPos] Of
              0 : Begin // Yes, we confirm the new coordinates
                       Player.XPos := XPos;
                       Player.YPos := YPos;
                  End;
          8..11 : DeadPlayer := True; // An enemy
     End;
End;

Procedure TForm1.PlayerMovementRight;
Var
  XPos, YPos : Integer;
Begin
// Calculate the player's new position
     XPos := Player.XPos - Shift[Player.Sens].Y;
     YPos := Player.YPos + Shift[Player.Sens].X;

// Can the player go?
     Case Laby.Block[XPos, YPos] Of
              0 : Begin // Yes, we confirm the new coordinates
                       Player.XPos := XPos;
                       Player.YPos := YPos;
                  End;
          8..11 : DeadPlayer := True; // An enemy
     End;
End;

Procedure TForm1.PlayerMovementPivotLeft;
Begin
     If Player.Sens = Nord Then Player.Sens := West
                           Else Dec(Player.Sens, 1);
End;

Procedure TForm1.PlayerMovementPivotRight;
Begin
     If Player.Sens = West Then Player.Sens := Nord
                            Else Inc(Player.Sens, 1);
End;

(*----------------------------------------------------------------------------*)
(* Navigation via buttons                                                     *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.PlayerButtonUpClick(Sender: TObject);
Begin
     PlayerMovementUp;
End;

Procedure TForm1.PlayerBottomButtonClick(Sender: TObject);
Begin
     PlayerMovementDown;
End;

Procedure TForm1.LeftPlayerButtonClick(Sender: TObject);
Begin
     PlayerMovementLeft;
End;

Procedure TForm1.RightPlayerButtonClick(Sender: TObject);
Begin
     PlayerMovementRight;
End;

Procedure TForm1.PlayerButtonRotateRightClick(Sender: TObject);
Begin
     PlayerMovementPivotRight;
End;

Procedure TForm1.PlayerButtonRotateLeftClick(Sender: TObject);
Begin
     PlayerMovementPivotLeft;
End;

(*----------------------------------------------------------------------------*)
(* Mouse movement around the game area                                        *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Begin
     TCoordMouse := Point(X, Y);
End;

Procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
     If ((X >= 16) And (X <= 94)) And ((Y >= 16) And (Y <= 102)) Then PlayerMovementPivotLeft
     Else If ((X >= 95) And (X <= 189)) And ((Y >= 16) And (Y <= 102)) Then PlayerMovementUp
          Else If ((X >= 190) And (X <= 299)) And ((Y >= 16) And (Y <= 102)) Then PlayerMovementPivotRight
               Else If ((X >= 16) And (X <= 94)) And ((Y >= 103) And (Y <= 220)) Then PlayerMovementLeft
                    Else If ((X >= 95) And (X <= 189)) And ((Y >= 103) And (Y <= 220)) Then PlayerMovementDown
                         Else If ((X >= 190) And (X <= 299)) And ((Y >= 103) And (Y <= 220)) Then PlayerMovementRight;
End;

(*----------------------------------------------------------------------------*)
(* Keyboard movement                                                          *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
Begin
     Case Key Of
          VK_NUMPAD4 : PlayerMovementLeft;
          VK_NUMPAD5 : PlayerMovementDown;
          VK_NUMPAD6 : PlayerMovementRight;
          VK_NUMPAD7 : PlayerMovementPivotLeft;
          VK_NUMPAD8 : PlayerMovementUp;
          VK_NUMPAD9 : PlayerMovementPivotRight;
     End;
End;

(*----------------------------------------------------------------------------*)
(* Commands for the programmer                                                *)
(*----------------------------------------------------------------------------*)
Procedure TForm1.CheckBox1Click(Sender: TObject);
Begin
     SwDark := CheckBox1.Checked;
End;

Procedure TForm1.TrackBar1Change(Sender: TObject);
Begin
     DarkPercent := TrackBar1.Position;
     EditSombre.Text := IntToStr(DarkPercent);
End;

Procedure TForm1.ScrollBar1Change(Sender: TObject);
Begin
     Label1.Caption := 'Timer speed : ' + IntToStr(ScrollBar1.Position);
     Timer1.Interval := ScrollBar1.Position;
End;

Procedure TForm1.CheckBox2Click(Sender: TObject);
Begin
     SwCacheMap := CheckBox2.Checked;
End;
// End of orders

Procedure TForm1.FormPaint(Sender: TObject);
Begin
     Canvas.CopyRect(Bounds(0, 0, BMPForm1.Width, BMPForm1.Height),
                     BMPForm1.Canvas, Bounds(0, 0, BMPForm1.Width, BMPForm1.Height));
End;

End.

