unit uMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfmMessage = class(TForm)
    laMessage: TLabel;
    splitMain: TSplitter;
    pnLinks: TPanel;
    laNote: TLabel;
    scrbLinks: TScrollBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    procedure LinkClick(Sender: TObject);
    procedure LinkMouseEnter(Sender: TObject);
    procedure LinkMouseLeave(Sender: TObject);  
  end;

var
  fmMessage: TfmMessage;

implementation

uses
  ShellAPI;

{$R *.dfm}

procedure TfmMessage.LinkClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, PChar('open'), PChar((Sender as TLabel).Caption), nil, nil, SW_NORMAL);
end;

procedure TfmMessage.LinkMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color:=clRed;
end;

procedure TfmMessage.LinkMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color:=clBlue;
end;

procedure TfmMessage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

end.
