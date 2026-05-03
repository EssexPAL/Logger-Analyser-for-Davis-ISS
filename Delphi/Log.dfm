object LogForm: TLogForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Log'
  ClientHeight = 561
  ClientWidth = 494
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Monospac821 BT'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Log: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 488
    Height = 404
    Align = alClient
    ItemHeight = 14
    TabOrder = 0
    OnClick = LogClick
  end
  object InfoPanel: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 413
    Width = 488
    Height = 145
    Align = alBottom
    Color = clSilver
    ParentBackground = False
    TabOrder = 1
    object Info: TPaintBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 480
      Height = 137
      Align = alClient
      OnClick = InfoClick
      OnPaint = InfoPaint
      ExplicitLeft = 0
      ExplicitTop = 0
    end
  end
end
