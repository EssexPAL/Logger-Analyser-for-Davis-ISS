object IPEditForm: TIPEditForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'IP Address Edit'
  ClientHeight = 162
  ClientWidth = 183
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 163
    Height = 13
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Align = alTop
    Caption = 'Logger IP Addresses (IPv4)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 155
  end
  object mIPA: TMemo
    AlignWithMargins = True
    Left = 10
    Top = 32
    Width = 163
    Height = 89
    Margins.Left = 10
    Margins.Top = 6
    Margins.Right = 10
    Align = alTop
    Color = clBtnFace
    TabOrder = 0
    OnKeyPress = mIPAKeyPress
  end
  object buCancel: TButton
    Left = 10
    Top = 127
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = buCancelClick
  end
  object buSave: TButton
    Left = 98
    Top = 127
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = buSaveClick
  end
end
