object fmMessage: TfmMessage
  Left = 192
  Top = 107
  Width = 535
  Height = 331
  Caption = 'Yeah!'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object laMessage: TLabel
    Left = 0
    Top = 0
    Width = 527
    Height = 161
    Align = alClient
    Alignment = taCenter
    AutoSize = False
    Caption = 'Delphi is living now!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object splitMain: TSplitter
    Left = 0
    Top = 161
    Width = 527
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ResizeStyle = rsUpdate
    Visible = False
  end
  object pnLinks: TPanel
    Left = 0
    Top = 164
    Width = 527
    Height = 140
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object laNote: TLabel
      Left = 0
      Top = 0
      Width = 527
      Height = 20
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'You can help! Just proceed to one of the following links:'
      Layout = tlCenter
    end
    object scrbLinks: TScrollBox
      Left = 0
      Top = 20
      Width = 527
      Height = 120
      Align = alClient
      TabOrder = 0
    end
  end
end
