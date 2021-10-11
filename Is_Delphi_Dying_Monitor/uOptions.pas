unit uOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfmOptions = class(TForm)
    laPollingInterval: TLabel;
    cmbPollingInterval: TComboBox;
    cbRunAtWinStartup: TCheckBox;
    btOk: TButton;
    btCancel: TButton;
  private
  public
    procedure ApplyPreferences;
    procedure ChangePreferences;
  end;

var
  fmOptions: TfmOptions;

implementation

uses
  uPreferences, uStruct;

{$R *.dfm}

procedure TfmOptions.ApplyPreferences;
begin
  cmbPollingInterval.ItemIndex:=Ord(PollingInterval);

  cbRunAtWinStartup.Checked:=CheckRunAtStartupOption;
end;

procedure TfmOptions.ChangePreferences;
begin
  PollingInterval:=TPollingInterval(cmbPollingInterval.ItemIndex);

  SaveRunAtStartupOption(cbRunAtWinStartup.Checked);
end;

end.
