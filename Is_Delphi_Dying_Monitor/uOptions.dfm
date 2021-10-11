object fmOptions: TfmOptions
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 147
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object laPollingInterval: TLabel
    Left = 24
    Top = 32
    Width = 72
    Height = 13
    Caption = '&Polling Interval:'
    FocusControl = cmbPollingInterval
  end
  object cmbPollingInterval: TComboBox
    Left = 112
    Top = 28
    Width = 137
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      '10 minutes'
      '1 hour'
      '5 hours'
      '10 hours'
      '1 day'
      '1 week')
  end
  object cbRunAtWinStartup: TCheckBox
    Left = 24
    Top = 64
    Width = 225
    Height = 17
    Caption = '&Run at Windows Startup'
    TabOrder = 1
  end
  object btOk: TButton
    Left = 51
    Top = 100
    Width = 75
    Height = 22
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btCancel: TButton
    Left = 147
    Top = 100
    Width = 75
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
