object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 438
  ClientWidth = 725
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 719
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Button1: TButton
      AlignWithMargins = True
      Left = 21
      Top = 7
      Width = 75
      Height = 27
      Margins.Left = 20
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Caption = 'Open'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 47
    Width = 361
    Height = 391
    Align = alLeft
    Caption = 'Panel2'
    TabOrder = 1
    object FileIn: TMemo
      AlignWithMargins = True
      Left = 7
      Top = 7
      Width = 347
      Height = 377
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Monospac821 BT'
      Font.Style = []
      Lines.Strings = (
        '#9605'
        '0003A 000 00 001 01DE 307 0000 000 00 27C9 B9')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 361
    Top = 47
    Width = 364
    Height = 391
    Align = alClient
    Caption = 'Panel3'
    TabOrder = 2
    object FileOut: TMemo
      AlignWithMargins = True
      Left = 7
      Top = 7
      Width = 350
      Height = 377
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Monospac821 BT'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object OD: TOpenDialog
    DefaultExt = 'raw'
    FileName = '*.raw'
    Left = 219
    Top = 3
  end
end
