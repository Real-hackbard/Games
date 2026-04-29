unit Scores;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TScoreForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblLevel1Time: TLabel;
    lblLevel2Time: TLabel;
    lblLevel3Time: TLabel;
    lblLevel1Name: TLabel;
    lblLevel2Name: TLabel;
    lblLevel3Name: TLabel;
    Button2: TButton;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Declarations privates }
    procedure DisplayScores;
    procedure WriteScore;
  public
    { Declarations public }
  end;

var
  ScoreForm: TScoreForm;

implementation

uses Unit1, InputName, IniFiles;

{$R *.DFM}

procedure TScoreForm.Button2Click(Sender: TObject);
begin
  Close;
end;

{ Display of the best times achieved and their corresponding identities }
procedure TScoreForm.DisplayScores;
begin
  lblLevel1Time.Caption := Format('%d seconds', [BestBeginnerTime]);
  lblLevel2Time.Caption := Format('%d seconds', [BestIntermediateTime]);
  lblLevel3Time.Caption := Format('%d seconds', [BestExpertTime]);
  lblLevel1Name.Caption := BestBeginnerName;
  lblLevel2Name.Caption := BestIntermediateName;
  lblLevel3Name.Caption := BestExpertName;
end;

{ Displaying and saving scores }
procedure TScoreForm.FormShow(Sender: TObject);
begin
  { positioning of the record in relation to the main record }
  Left := Application.MainForm.Left + 4;
  Top := Application.MainForm.Top + 90;
  { hard-coding in the ini file }
  WriteScore;
  { hard-coded writing in the display update file }
  DisplayScores;
end;

{ Initialize scores requested }
procedure TScoreForm.Button1Click(Sender: TObject);
begin
  BestBeginnerTime     := 999;
  BestIntermediateTime := 999;
  BestExpertTime       := 999;
  BestBeginnerName     := 'Anonym';
  BestIntermediateName := 'Anonym';
  BestExpertName       := 'Anonym';
  { Updated the input window in InputNameForm }
  InputNameForm.Edit1.Text := 'Anonym';
  { hard-coding in the ini file }
  WriteScore;
  { score display update }
  DisplayScores;
end;

{ Writing scores to the ini file }
procedure TScoreForm.WriteScore;
begin
  with TIniFile.Create(PathAppli + 'Data.ini') do
  try
    WriteInteger('SCORE', 'time1', BestBeginnerTime);
    WriteInteger('SCORE', 'time2', BestIntermediateTime);
    WriteInteger('SCORE', 'time3', BestExpertTime);
    WriteString('SCORE', 'name1', BestBeginnerName);
    WriteString('SCORE', 'name2', BestIntermediateName);
    WriteString('SCORE', 'name3', BestExpertName);
  finally
    Free;
  end;
end;

end.
