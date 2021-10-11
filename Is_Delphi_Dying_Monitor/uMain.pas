unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ShellAPI, Menus, uStruct;

const
  TrayIconID = 1020;
  WM_TRAYICON = WM_USER;

type
  TfmMain = class(TForm)
    tmrMain: TTimer;
    IdHTTP1: TIdHTTP;
    pmMain: TPopupMenu;
    pmiPollServer: TMenuItem;
    pmiOptions: TMenuItem;
    pmiAbout: TMenuItem;
    pmiSeparator1: TMenuItem;
    pmiExit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pmiExitClick(Sender: TObject);
    procedure pmiAboutClick(Sender: TObject);
    procedure pmiOptionsClick(Sender: TObject);
    procedure tmrMainTimer(Sender: TObject);
    procedure pmiPollServerClick(Sender: TObject);
  protected
    WM_TASKBARCREATED: Cardinal;
    nidTrayIcon: TNotifyIconData;
    procedure WndProc(var Msg: TMessage); override;
    procedure AddTrayIcon(IconHandle: HICON);
    procedure DeleteTrayIcon;
  private
  public
    function PollServers: TDelphiState;
    procedure ShowMessage;
  end;

var
  fmMain: TfmMain;

  bAboutDialogCreated: Boolean = false;
  bOptionsDialogCreated: Boolean = false;

implementation

uses
  DateUtils, uLkJSON, uAbout, uOptions, uMessage, uPreferences, uCmnFunc;

{$R *.dfm}
{$R Manifest.res}

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Application.ShowMainForm:=false;

  WM_TASKBARCREATED:=RegisterWindowMessage('TaskbarCreated');

  AddTrayIcon(Application.Icon.Handle);
end;

procedure TfmMain.AddTrayIcon(IconHandle: HICON);
begin
  nidTrayIcon.cbSize:=SizeOf(TNotifyIconData);
  nidTrayIcon.Wnd:=Handle;
  nidTrayIcon.uID:=TrayIconID;

  nidTrayIcon.uCallbackMessage:=WM_TRAYICON;
  nidTrayIcon.hIcon:=IconHandle;
  nidTrayIcon.szTip:='Is Delphi Dying Monitor';

  nidTrayIcon.uFlags:=NIF_MESSAGE or NIF_ICON or NIF_TIP;
  Shell_NotifyIcon(NIM_ADD, @nidTrayIcon);
end;

procedure TfmMain.DeleteTrayIcon;
begin
  Shell_NotifyIcon(NIM_DELETE, @nidTrayIcon);
end;

procedure TfmMain.WndProc(var Msg: TMessage);

  procedure ShowPopupMenu;
  var
    P: TPoint;
  begin
    GetCursorPos(P);
    SetForegroundWindow(Handle);
    pmMain.Popup(P.X, P.Y);
  end;

begin
  inherited;

  case Msg.Msg of
    WM_TRAYICON:
      case Msg.LParam of
        WM_LBUTTONDBLCLK:
          pmiPollServer.Click;
        WM_RBUTTONDOWN:
          ShowPopupMenu;
      end;
  else
    if Msg.Msg = WM_TASKBARCREATED then
      begin
        DeleteTrayIcon;
        AddTrayIcon(Application.Icon.Handle);
      end;
  end;    
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  DeleteTrayIcon;
end;

procedure TfmMain.pmiExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.pmiAboutClick(Sender: TObject);
begin
  if bAboutDialogCreated then
    SetForegroundWindow(fmAbout.Handle)
  else
    begin
      fmAbout:=TfmAbout.Create(Self);
      try
        bAboutDialogCreated:=true;
        fmAbout.ShowModal;
      finally
        fmAbout.Free;
        bAboutDialogCreated:=false
      end;
    end;
end;

procedure TfmMain.pmiOptionsClick(Sender: TObject);
begin
  if bOptionsDialogCreated then
    SetForegroundWindow(fmOptions.Handle)
  else
    begin
      fmOptions:=TfmOptions.Create(Self);
      try
        bOptionsDialogCreated:=true;
        fmOptions.ApplyPreferences;
        if fmOptions.ShowModal = mrOk then
          begin
            fmOptions.ChangePreferences;
            SavePollingIntervalOption;
          end;
      finally
        fmOptions.Free;
        bOptionsDialogCreated:=false;
      end;
    end;                                
end;

function TfmMain.PollServers: TDelphiState;
var
  ResponseStr: String;
  JSONObj: TlkJSONobject;
  JSONStr: TlkJSONstring;
begin
  Result:=uPreferences.DelphiState;
  try
    // check is Delphi already dead
    ResponseStr:=IdHTTP1.Get(IsDelphiDeadURI);
    IdHTTP1.Disconnect;

    JSONObj:=TlkJSON.ParseText(ResponseStr) as TlkJSONobject;
    try
      JSONStr:=JSONObj.Field['Is Delphi Dead?'] as TlkJSONstring;
      if JSONStr.Value <> 'No.' then // there are no other strings specified in API, so check for "No."
        begin
          Result:=dsDead;
          Exit; // if it's dead, then we willn't check for dying condition 
        end;
    finally
      JSONObj.Free;
    end;

    // check is Delphi dying now
    ResponseStr:=IdHTTP1.Get(IsDelphiDyingURI);
    IdHTTP1.Disconnect;

    JSONObj:=TlkJSON.ParseText(ResponseStr) as TlkJSONobject;
    try
      JSONStr:=JSONObj.Field['Is Delphi Dying?'] as TlkJSONstring;
      if JSONStr.Value <> 'No.' then // there are no other strings specified in API, so check for "No."
        Result:=dsDying
      else
        Result:=dsLiving;
    finally
      JSONObj.Free;
    end;
  except
  end;
end;

procedure TfmMain.tmrMainTimer(Sender: TObject);
var
  dsTemp: TDelphiState;
begin
  if CompareDateTime(Now, IncMinute(LastPolledTime, GetPollingIntervalInMinutes(PollingInterval))) >= 0 then
    begin
      dsTemp:=PollServers;
      LastPolledTime:=Now;
      SaveLastPolledTime;
      if dsTemp <> DelphiState then
        begin
          DelphiState:=dsTemp;
          SaveDelphiState;
          ShowMessage;
        end;
    end;
end;

procedure TfmMain.ShowMessage;
var
  ResponseStr: String;

  procedure MakeLinks;
  var
    slLinks: TStringList;
    i: Integer;
    laNew: TLabel;
  begin
    slLinks:=TStringList.Create;
    try
      slLinks.Text:=ResponseStr;
      for i:=0 to slLinks.Count - 1 do
        begin
          laNew:=TLabel.Create(fmMessage);
          laNew.Parent:=fmMessage.scrbLinks;
          laNew.Cursor:=crHandPoint;
          laNew.Font.Color:=clBlue;
          laNew.Caption:=slLinks[i];
          laNew.Left:=10;
          laNew.Top:=8 + 15 * i;
          laNew.OnClick:=fmMessage.LinkClick;
          laNew.OnMouseEnter:=fmMessage.LinkMouseEnter;
          laNew.OnMouseLeave:=fmMessage.LinkMouseLeave;
        end;
    finally
      slLinks.Free;
    end;
  end;

begin
  fmMessage:=TfmMessage.Create(nil);
  case DelphiState of
    dsDying:
      begin
        fmMessage.Caption:='Oops! (' + DateTimeToStr(Now) + ')';
        fmMessage.laMessage.Caption:='Delphi is dying now!';

        try
          ResponseStr:=IdHTTP1.Get(DisastrousSituationLinksURI);
          IdHTTP1.Disconnect;

          if ResponseStr <> '' then
            begin
              MakeLinks;
              fmMessage.pnLinks.Visible:=true;
              fmMessage.splitMain.Visible:=true;
            end;
        except
        end;
      end;
    dsDead:
      begin
        fmMessage.Caption:='Forget About It (' + DateTimeToStr(Now) + ')';
        fmMessage.laMessage.Caption:='Delphi is dead :-(';
      end;
  else
    fmMessage.Caption:=fmMessage.Caption + ' (' + DateTimeToStr(Now) + ')';
    // nothing to do more, the form already has appropriate text
  end;
  fmMessage.Show;
end;

procedure TfmMain.pmiPollServerClick(Sender: TObject);
begin
  tmrMain.Enabled:=false; // restart the main timer
  tmrMain.Enabled:=true;

  DelphiState:=PollServers;
  SaveDelphiState;
  LastPolledTime:=Now;
  SaveLastPolledTime;
  ShowMessage;
end;

end.
