unit uCmnFunc;

interface

uses
  uStruct;

function GetPollingIntervalInMinutes(PollingInterval: TPollingInterval): Integer;

implementation

function GetPollingIntervalInMinutes(PollingInterval: TPollingInterval): Integer;
begin
  case PollingInterval of
    pi10m:
      Result:=10;
    pi1h:
      Result:=60;
    pi5h:
      Result:=5 * 60;
    pi10h:
      Result:=10 * 60;
    pi1d:
      Result:=24 * 60;
    pi1w:
      Result:=7 * 24 * 60;
  else
    Result:=0;
  end;
end;

end.
