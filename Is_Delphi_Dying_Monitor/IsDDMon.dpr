program IsDDMon;

uses
  Forms,
  Windows,
  uMain in 'uMain.pas' {fmMain},
  uOptions in 'uOptions.pas' {fmOptions},
  uAbout in 'uAbout.pas' {fmAbout},
  uMessage in 'uMessage.pas' {fmMessage},
  uLkJSON in 'uLkJSON.pas',
  uPreferences in 'uPreferences.pas',
  uStruct in 'uStruct.pas',
  uCmnFunc in 'uCmnFunc.pas';

const
  MutexName = 'Is Delphi Dying Monitor Copyright © 2009 Valerian Kadyshev';

function AlreadyRuns: Boolean;
var
  HM: THandle;
begin
  HM:=OpenMutex(MUTEX_ALL_ACCESS, false, MutexName);

  Result:=HM <> 0;

  if HM = 0 then
    begin
      CreateMutex(nil, false, MutexName);
      Result:=false;
    end;
end;

{$R *.res}

begin
  if AlreadyRuns then
    Exit;

  Application.Title:='Is Delphi Dying Monitor v1.0';
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
