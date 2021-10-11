unit uPreferences;

interface

uses
  uStruct;

const
  sApplicationIniSection='Preferences';

var
  sIniFilePath: String;

  DelphiState: TDelphiState;
  PollingInterval: TPollingInterval;
  LastPolledTime: TDateTime;
  IsDelphiDyingURI, IsDelphiDeadURI: String;
  DisastrousSituationLinksURI: String; 

procedure SaveDelphiState;  
procedure SavePollingIntervalOption;
procedure SaveLastPolledTime;
procedure SaveRunAtStartupOption(bRun: Boolean);
function CheckRunAtStartupOption: Boolean;

implementation

uses
  SysUtils, Forms, IniFiles, Registry, Windows;

procedure SaveDelphiState;
var
  ifMain: TIniFile;
begin
  try
    ifMain:=TIniFile.Create(sIniFilePath);

    ifMain.WriteInteger(sApplicationIniSection, 'DelphiState', Ord(DelphiState));

    ifMain.Free;
  except
  end;
end;

procedure SavePollingIntervalOption;
var
  ifMain: TIniFile;
begin
  try
    ifMain:=TIniFile.Create(sIniFilePath);

    ifMain.WriteInteger(sApplicationIniSection, 'PollingInterval', Ord(PollingInterval));

    ifMain.Free;
  except
  end;
end;

procedure SaveLastPolledTime;
var
  ifMain: TIniFile;
begin
  try
    ifMain:=TIniFile.Create(sIniFilePath);

    ifMain.WriteFloat(sApplicationIniSection, 'LastPolledTime', LastPolledTime);

    ifMain.Free;
  except
  end;
end;

procedure SaveRunAtStartupOption(bRun: Boolean);
var
  rgMain: TRegistry;
begin
  try
    rgMain:=TRegistry.Create;
    try
      rgMain.RootKey:=HKEY_CURRENT_USER;
      if bRun then
        begin
          if rgMain.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', true) then
            begin
              rgMain.WriteString('Is Delphi Dying Monitor', Application.ExeName);
              rgMain.CloseKey;
            end;
        end
      else
        begin
          if rgMain.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false) then
            begin
              rgMain.DeleteValue('Is Delphi Dying Monitor');
              rgMain.CloseKey;
            end;
        end;
    finally
      rgMain.Free;
    end;
  except
  end;
end;

function CheckRunAtStartupOption: Boolean;
var
  rgMain: TRegistry;
begin
  Result:=false;
  try
    rgMain:=TRegistry.Create;
    try
      rgMain.RootKey:=HKEY_CURRENT_USER;
      if rgMain.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', true) then
        begin
          if SameText(rgMain.ReadString('Is Delphi Dying Monitor'), Application.ExeName) then
            Result:=true;
        end;
    finally
      rgMain.Free;
    end;
  except
  end;
end;

procedure LoadPreferences;
var
  ifMain: TIniFile;
  iTemp: Integer;
begin
  if FileExists(sIniFilePath) then
    begin
      ifMain:=TIniFile.Create(sIniFilePath);
      ifMain.UpdateFile;

      iTemp:=ifMain.ReadInteger(sApplicationIniSection, 'DelphiState', Ord(dsLiving));
      if (iTemp < Ord(Low(TDelphiState))) or (iTemp > Ord(High(TDelphiState))) then
        iTemp:=Ord(dsLiving);
      DelphiState:=TDelphiState(iTemp);

      iTemp:=ifMain.ReadInteger(sApplicationIniSection, 'PollingInterval', Ord(pi10h));
      if (iTemp < Ord(Low(TPollingInterval))) or (iTemp > Ord(High(TPollingInterval))) then
        iTemp:=Ord(pi10h);
      PollingInterval:=TPollingInterval(iTemp);

      LastPolledTime:=ifMain.ReadFloat(sApplicationIniSection, 'LastPolledTime', 0);

      IsDelphiDyingURI:=ifMain.ReadString(sApplicationIniSection, 'IsDelphiDyingURI', 'http://isdelphidying.com/API/?json');
      IsDelphiDeadURI:=ifMain.ReadString(sApplicationIniSection, 'IsDelphiDeadURI', 'http://isdelphidead.com/API/?json');
      DisastrousSituationLinksURI:=ifMain.ReadString(sApplicationIniSection, 'DisastrousSituationLinksURI', 'http://www.isdelphidying.narod.ru/links.txt');

      ifMain.Free;
    end
  else
    begin
      DelphiState:=dsLiving;

      PollingInterval:=pi10h;

      LastPolledTime:=0;

      IsDelphiDyingURI:='http://isdelphidying.com/API/?json';
      IsDelphiDeadURI:='http://isdelphidead.com/API/?json';
      DisastrousSituationLinksURI:='http://www.isdelphidying.narod.ru/links.txt';
    end;
end;

initialization
  DecimalSeparator:='.';

  sIniFilePath:=ChangeFileExt(Application.ExeName, '.ini');

  LoadPreferences;
end.
