object fmMain: TfmMain
  Left = 217
  Top = 117
  Width = 361
  Height = 206
  Caption = 'Is Delphi Dying Monitor v1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object tmrMain: TTimer
    Interval = 60000
    OnTimer = tmrMainTimer
    Left = 40
    Top = 48
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 40
    Top = 88
  end
  object pmMain: TPopupMenu
    Left = 88
    Top = 48
    object pmiPollServer: TMenuItem
      Caption = '&Poll Server'
      Default = True
      OnClick = pmiPollServerClick
    end
    object pmiOptions: TMenuItem
      Caption = '&Options'#8230
      OnClick = pmiOptionsClick
    end
    object pmiAbout: TMenuItem
      Caption = '&About'#8230
      OnClick = pmiAboutClick
    end
    object pmiSeparator1: TMenuItem
      Caption = '-'
    end
    object pmiExit: TMenuItem
      Caption = 'E&xit'
      OnClick = pmiExitClick
    end
  end
end
