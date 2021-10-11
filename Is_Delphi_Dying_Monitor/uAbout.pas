unit uAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmAbout = class(TForm)
    imgIcon: TImage;
    imgFlag: TImage;
    laMadeInRussia: TLabel;
    laProgramName: TLabel;
    laCopyright: TLabel;
    laWebSiteAddress: TLabel;
    btOk: TButton;
    procedure laWebSiteAddressClick(Sender: TObject);
    procedure laWebSiteAddressMouseEnter(Sender: TObject);
    procedure laWebSiteAddressMouseLeave(Sender: TObject);
  private
  public
  end;

var
  fmAbout: TfmAbout;

implementation

uses
  ShellAPI;

{$R *.dfm}

procedure TfmAbout.laWebSiteAddressClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, PChar('open'), PChar((Sender as TLabel).Caption), nil, nil, SW_NORMAL);
end;

procedure TfmAbout.laWebSiteAddressMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color:=clRed;
end;

procedure TfmAbout.laWebSiteAddressMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color:=clBlue;
end;

end.
