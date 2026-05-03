object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Settings'
  ClientHeight = 550
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel20: TPanel
    AlignWithMargins = True
    Left = 194
    Top = 3
    Width = 156
    Height = 500
    Margins.Bottom = 0
    Align = alLeft
    TabOrder = 0
    object gbGraph: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 145
      Height = 309
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alTop
      Caption = ' Graph Colours '
      TabOrder = 0
      object buGC1: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 25
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Top = 10
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Graph BG'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        StyleElements = []
        OnClick = buGC1Click
      end
      object buGC2a: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 53
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Graph Max Line'
        TabOrder = 1
        StyleElements = []
        OnClick = buGC1Click
      end
      object buGC3: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 109
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Graph Text'
        TabOrder = 2
        StyleElements = []
        OnClick = buGC1Click
      end
      object buGC4: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 165
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Max/Min Lines'
        TabOrder = 3
        StyleElements = []
        OnClick = buGC1Click
      end
      object buGC5: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 137
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Graticule'
        TabOrder = 4
        StyleElements = []
        OnClick = buGC1Click
      end
      object buGC6: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 193
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Wind Alt Vector'
        TabOrder = 5
        StyleElements = []
        OnClick = buGC1Click
      end
      object buGC7: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 221
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Bar Colour'
        TabOrder = 6
        StyleElements = []
        OnClick = buGC1Click
      end
      object buGC8: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 249
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Text Colour'
        TabOrder = 7
        StyleElements = []
        OnClick = buGC1Click
      end
      object buGC2b: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 81
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Graph Min Line'
        TabOrder = 8
        StyleElements = []
        OnClick = buGC1Click
      end
      object buGC9: TPanel
        AlignWithMargins = True
        Left = 17
        Top = 277
        Width = 111
        Height = 22
        Margins.Left = 15
        Margins.Right = 15
        Align = alTop
        BevelEdges = []
        BevelInner = bvLowered
        Caption = 'Rose Colour'
        TabOrder = 9
        StyleElements = []
        OnClick = buGC9Click
      end
    end
    object gbAltitude: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 316
      Width = 145
      Height = 181
      Margins.Right = 6
      Align = alTop
      Caption = ' Station Altitude '
      TabOrder = 1
      object Label1: TLabel
        AlignWithMargins = True
        Left = 22
        Top = 18
        Width = 101
        Height = 13
        Margins.Left = 20
        Margins.Right = 20
        Align = alTop
        Caption = 'Altitude'
        ExplicitWidth = 37
      end
      object cbAltUnit: TComboBox
        AlignWithMargins = True
        Left = 22
        Top = 67
        Width = 101
        Height = 21
        Margins.Left = 20
        Margins.Top = 6
        Margins.Right = 20
        Margins.Bottom = 10
        Align = alTop
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 0
        Text = 'Metres'
        Items.Strings = (
          'Feet'
          'Metres')
      end
      object ebAltitude: TEdit
        AlignWithMargins = True
        Left = 22
        Top = 37
        Width = 101
        Height = 21
        Margins.Left = 20
        Margins.Right = 20
        Align = alTop
        TabOrder = 1
        Text = '0'
        OnKeyPress = ebAltitudeKeyPress
      end
    end
  end
  object Panel10: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 185
    Height = 500
    Margins.Bottom = 0
    Align = alLeft
    TabOrder = 1
    object rgWind: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 174
      Height = 97
      Margins.Right = 6
      Align = alTop
      Caption = 'Wind Speed'
      Items.Strings = (
        'Metres / Second'
        'Km / Hour'
        'Miles / Hour')
      TabOrder = 0
    end
    object rgPressure: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 266
      Width = 174
      Height = 100
      Margins.Right = 6
      Align = alTop
      Caption = 'Atmospheric Pressure'
      Items.Strings = (
        'millibars (mb) (hPa)'
        'millimeter of mercury (mmHg)'
        'inches of mercury (inHg)')
      TabOrder = 3
    end
    object rgPrecipitation: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 188
      Width = 174
      Height = 72
      Margins.Right = 6
      Align = alTop
      Caption = 'Precipitation'
      Items.Strings = (
        'Millimeters'
        'Inches')
      TabOrder = 2
    end
    object rgAir: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 107
      Width = 174
      Height = 75
      Margins.Right = 6
      Align = alTop
      Caption = 'Temperature'
      Items.Strings = (
        'Degrees Cekcius'
        'Degrees Fahrenheit')
      TabOrder = 1
    end
    object rgSpoonSize: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 372
      Width = 174
      Height = 60
      Margins.Right = 6
      Align = alTop
      Caption = ' Precipitation Spoon '
      Items.Strings = (
        '0.01 Inches'
        '2mm')
      TabOrder = 4
    end
    object GroupBox2: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 438
      Width = 174
      Height = 105
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      Caption = ' Barometric Pressure Correction  '
      TabOrder = 5
      object ebBPCorrection: TEdit
        AlignWithMargins = True
        Left = 52
        Top = 24
        Width = 70
        Height = 21
        Margins.Left = 50
        Margins.Top = 9
        Margins.Right = 50
        Align = alTop
        Alignment = taRightJustify
        TabOrder = 0
        Text = '0.0'
      end
    end
  end
  object Panel30: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 506
    Width = 554
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 2
    object buSave: TButton
      Tag = 1
      AlignWithMargins = True
      Left = 22
      Top = 8
      Width = 100
      Height = 25
      Margins.Left = 20
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alLeft
      Caption = 'Save'
      ModalResult = 6
      TabOrder = 0
      OnClick = buCloseClick
    end
    object buClose: TButton
      Tag = 2
      AlignWithMargins = True
      Left = 134
      Top = 8
      Width = 100
      Height = 25
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 50
      Margins.Bottom = 6
      Align = alLeft
      Caption = 'Close'
      ModalResult = 7
      TabOrder = 1
      OnClick = buCloseClick
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 356
    Top = 3
    Width = 201
    Height = 500
    Margins.Bottom = 0
    Align = alClient
    TabOrder = 3
    object Label3: TLabel
      AlignWithMargins = True
      Left = 11
      Top = 247
      Width = 186
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 'DB Directory'
      ExplicitLeft = 15
    end
    object Label4: TLabel
      AlignWithMargins = True
      Left = 11
      Top = 200
      Width = 48
      Height = 13
      Margins.Left = 10
      Margins.Top = 6
      Align = alTop
      Caption = 'Root Path'
    end
    object Label6: TLabel
      AlignWithMargins = True
      Left = 11
      Top = 290
      Width = 186
      Height = 13
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 'Table Name'
      ExplicitTop = 344
      ExplicitWidth = 100
    end
    object Label7: TLabel
      AlignWithMargins = True
      Left = 11
      Top = 333
      Width = 82
      Height = 13
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Selected Host IP '
    end
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 7
      Width = 193
      Height = 184
      Margins.Top = 6
      Align = alTop
      Caption = ' Default Printer '
      TabOrder = 0
      object Label2: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 21
        Width = 83
        Height = 13
        Margins.Left = 6
        Margins.Top = 6
        Align = alTop
        Caption = 'Available Printers'
      end
      object lbPrinterList: TListBox
        AlignWithMargins = True
        Left = 8
        Top = 40
        Width = 177
        Height = 120
        Margins.Left = 6
        Margins.Right = 6
        Margins.Bottom = 0
        Align = alTop
        ItemHeight = 13
        TabOrder = 0
      end
      object cbInvert: TCheckBox
        AlignWithMargins = True
        Left = 27
        Top = 163
        Width = 139
        Height = 17
        Margins.Left = 25
        Margins.Right = 25
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'Invert Printed Image'
        TabOrder = 1
      end
    end
    object ebDBdir: TEdit
      AlignWithMargins = True
      Left = 11
      Top = 263
      Width = 179
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      Color = clSilver
      ReadOnly = True
      TabOrder = 1
      Text = 'DB'
      StyleElements = []
    end
    object ebTableName: TEdit
      AlignWithMargins = True
      Left = 11
      Top = 306
      Width = 179
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      TabOrder = 2
      Text = 'WsData'
    end
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 216
      Width = 193
      Height = 25
      Margins.Top = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      ParentBackground = False
      TabOrder = 3
      object sbChooseDir: TSpeedButton
        AlignWithMargins = True
        Left = 168
        Top = 2
        Width = 23
        Height = 23
        Caption = '...'
        OnClick = sbChooseDirClick
      end
      object ebRootDir: TEdit
        AlignWithMargins = True
        Left = 7
        Top = 3
        Width = 156
        Height = 21
        Margins.Left = 7
        Margins.Right = 30
        Margins.Bottom = 0
        Align = alTop
        TabOrder = 0
        Text = 'ebRootDir'
        OnChange = ebRootDirChange
      end
    end
    object Panel3: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 346
      Width = 193
      Height = 25
      Margins.Top = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      ParentBackground = False
      TabOrder = 4
      object sbChoseIP: TSpeedButton
        AlignWithMargins = True
        Left = 168
        Top = 2
        Width = 23
        Height = 23
        Caption = '...'
        OnClick = sbChoseIPClick
      end
      object LocalIP: TEdit
        AlignWithMargins = True
        Left = 7
        Top = 3
        Width = 156
        Height = 21
        Margins.Left = 7
        Margins.Right = 30
        Margins.Bottom = 0
        Align = alTop
        ReadOnly = True
        TabOrder = 0
        Text = '0.0.0.0'
        OnChange = ebRootDirChange
      end
    end
    object GroupBox4: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 383
      Width = 190
      Height = 113
      Margins.Top = 9
      Margins.Right = 6
      Align = alClient
      Caption = ' Auto Import '
      TabOrder = 5
      object cbAtStart: TCheckBox
        AlignWithMargins = True
        Left = 32
        Top = 21
        Width = 126
        Height = 17
        Margins.Left = 30
        Margins.Top = 6
        Margins.Right = 30
        Margins.Bottom = 0
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'At Startup'
        TabOrder = 0
      end
      object cbHourly: TCheckBox
        AlignWithMargins = True
        Left = 32
        Top = 44
        Width = 126
        Height = 17
        Margins.Left = 30
        Margins.Top = 6
        Margins.Right = 30
        Margins.Bottom = 0
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'Every Hour'
        TabOrder = 1
      end
      object cbSaveRaw: TCheckBox
        AlignWithMargins = True
        Left = 32
        Top = 67
        Width = 126
        Height = 17
        Margins.Left = 30
        Margins.Top = 6
        Margins.Right = 30
        Margins.Bottom = 0
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'Save Raw File'
        TabOrder = 2
      end
    end
  end
  object CD: TColorDialog
    Left = 128
    Top = 192
  end
end
