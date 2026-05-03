object ImportForm: TImportForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Auto Data Import'
  ClientHeight = 306
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 258
    Width = 629
    Height = 45
    Align = alBottom
    BevelInner = bvLowered
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Button1: TButton
      AlignWithMargins = True
      Left = 252
      Top = 8
      Width = 125
      Height = 29
      Margins.Left = 250
      Margins.Top = 6
      Margins.Right = 250
      Margins.Bottom = 6
      Align = alClient
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object ImportLog: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 629
    Height = 249
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Monospac821 BT'
    Font.Style = []
    Lines.Strings = (
      'ImportLog')
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 276
    Top = 84
  end
end
