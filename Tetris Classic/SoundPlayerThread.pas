unit SoundPlayerThread;

interface

uses
  Classes, MMSystem, Windows;

type
  TSoundPlayerThread = class(TThread)
  private
    { Private declarations }
    FAudioFileName: string;
  protected
    procedure Execute; override;
  public
    procedure SetFileName(const FileName: string);
  end;

implementation

procedure TSoundPlayerThread.Execute;
begin
  PlaySound(PChar(FAudioFileName), 0, SND_SYNC or SND_NOSTOP);
end;

procedure TSoundPlayerThread.SetFileName(const FileName: string);
begin
  FAudioFileName := FileName;
end;

end.