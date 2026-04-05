unit PathScan;

interface

uses windows, sysutils, classes, filectrl, forms;

type
  TPathScanner = class(TObject)
  private
    fFirstDir   : string;
    fExtFilter  : string;
    fUseFilter  : boolean;
    fScanSubs   : boolean;
    fTotalDirs  : int64;
    fTotalFiles : int64;
    fTotalSize  : int64;
  protected
    procedure Scanner(Strings : TStrings; const CurDir : string);
    function AttrToStr(const Attr : integer) : string;
  public
    property Directory : string   read fFirstDir  write fFirstDir;
    property Filter    : string   read fExtFilter write fExtFilter;
    property UseFilter : boolean  read fUseFilter write fUseFilter;
    property ScanSubs  : boolean  read fScanSubs  write fScanSubs;
    property TotalDirs : int64    read fTotalDirs;
    property TotalFiles: int64    read fTotalFiles;
    property TotalSize : int64    read fTotalSize;
    procedure SelectDir;
    procedure Scan(Strings : TStrings);
    constructor Create;
    destructor Destroy; override;
  end;


implementation



constructor TPathScanner.Create;
begin
  inherited create;
  fTotalDirs := 0;
  fTotalFiles:= 0;
  fTotalSize := 0;
  fExtFilter := '';
  fFirstDir  := '';
  fUseFilter := false;
  fScanSubs  := false;
end;

destructor TPathScanner.Destroy;
begin
  inherited Destroy;
end;

procedure TPathScanner.Scan(Strings : TStrings);
begin
  fTotalDirs := 0;
  fTotalFiles:= 0;
  fTotalSize := 0;
  Strings.BeginUpdate;
  Scanner(Strings,fFirstDir);
  Strings.EndUpdate;
end;

function TPathScanner.AttrToStr(const Attr : integer) : string;
begin
  result := '......';
  if (attr and faVolumeId) <> 0 then  result[1] := 'V'
  else
  if (attr and faDirectory) <> 0 then result[1] := 'D'
  else
     result[1]  := 'F';

  if (attr and faArchive)  <> 0 then result[2] := 'A';
  if (attr and faHidden)   <> 0 then result[3] := 'H';
  if (attr and faReadOnly) <> 0 then result[4] := 'R';
  if (attr and faSysFile)  <> 0 then result[5] := 'S';
  if (attr and faSymLink)  <> 0 then result[6] := 'L';
end;

procedure TPathScanner.SelectDir;
var DResult : string;
begin
  If SelectDirectory('Select a folder :','',DResult) Then
     fFirstDir := IncludeTrailingBackSlash(DResult);
end;


procedure TPathScanner.Scanner(Strings : TStrings; const CurDir : string);
var SRC : TSearchrec;
    SDN : string;
    LC  : integer;  { LC counter for process message | IDS index of the added element }
begin
  if DirectoryExists(CurDir) then begin
     { counter initialization at 0 }
     LC  := 0;
     SDN := copy(CurDir,length(fFirstDir)+1,length(CurDir));
     try
       { we search for the first file or directory }
       if findfirst(CurDir+'*.*',faAnyFile,SRC) = 0 then begin
          { loop entry }
          repeat
            { we increment the counter }
            inc(LC);

            { if the name is different from . or .. (root directory) }
            if (SRC.Name <> '.') and (SRC.Name <> '..') then begin

               { if the attribute indicates that it is a directory }
               if fScanSubs and ((SRC.Attr and faDirectory) <> 0) then begin
                  { We recurse ScanProject on the new directory }
                  inc(fTotalDirs);
                  Scanner(Strings,CurDir+SRC.Name+'\');
               end else

               { if the attribute tells us that it is a file }
               if not ((SRC.Attr and faVolumeID) <> 0) then begin
                  { We add the element and retrieve the index from IDS. }
                  if (not fUseFilter) or (fUseFilter and (ExtractFileExt(SRC.Name) = fExtFilter)) then begin
                     inc(fTotalFiles);
                     inc(fTotalSize,SRC.Size);
                     Strings.Add(SDN+SRC.Name{+'>'+AttrToStr(SRC.Attr)+'>'+IntToStr(SRC.Size)});
                  end;
               end;
            end;
            { Every ten passes, application.processmessage is called to refresh the display. }
            if (LC mod 10) = 0 then begin
               application.ProcessMessages;
            end;

          { The loop ends when FindNext finds nothing more. }
          until findnext(SRC) <> 0;
       end;
     finally
       { and finally we close SRC }
       FindClose(SRC);
     end;
  end;
end;

end.
