object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Weather Station RF Data Logger'
  ClientHeight = 791
  ClientWidth = 1184
  Color = clWhite
  Constraints.MaxWidth = 1200
  Constraints.MinWidth = 1190
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainTitle: TPanel
    Tag = 11
    AlignWithMargins = True
    Left = 6
    Top = 3
    Width = 1169
    Height = 35
    Margins.Left = 6
    Margins.Right = 9
    Align = alTop
    BevelEdges = []
    BevelInner = bvLowered
    BevelOuter = bvSpace
    Caption = 'Weather Data Analyser'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object lDateNo: TLabel
      AlignWithMargins = True
      Left = 1089
      Top = 5
      Width = 28
      Height = 25
      Margins.Right = 50
      Align = alRight
      Caption = '----'
      ExplicitHeight = 21
    end
  end
  object DataPage: TPageControl
    Left = 0
    Top = 41
    Width = 1184
    Height = 750
    Margins.Right = 0
    ActivePage = tsAnalyse
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TabPosition = tpBottom
    OnChange = rgMeasurementOldClick
    OnChanging = DataPageChanging
    object tsStation: TTabSheet
      Caption = 'Weather Station'
      object Panel4: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 2
        Width = 1176
        Height = 523
        Margins.Left = 0
        Margins.Top = 2
        Margins.Right = 0
        Align = alTop
        BevelInner = bvLowered
        BevelWidth = 3
        TabOrder = 0
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 9
          Top = 9
          Width = 250
          Height = 505
          Margins.Right = 0
          Align = alLeft
          BevelInner = bvLowered
          TabOrder = 0
          object Panel2: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 5
            Width = 240
            Height = 23
            Align = alTop
            BevelInner = bvLowered
            Caption = 'File List'
            TabOrder = 0
          end
          object Panel11: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 468
            Width = 240
            Height = 32
            Align = alBottom
            BevelInner = bvLowered
            TabOrder = 1
            object buFiles2: TButton
              Tag = 2
              AlignWithMargins = True
              Left = 128
              Top = 5
              Width = 95
              Height = 22
              Margins.Right = 15
              Align = alRight
              Cancel = True
              Caption = 'Clear ALL'
              TabOrder = 0
              OnClick = buFiles1Click
            end
            object buFiles1: TButton
              Tag = 1
              AlignWithMargins = True
              Left = 17
              Top = 5
              Width = 95
              Height = 22
              Margins.Left = 15
              Align = alLeft
              Caption = 'Select ALL'
              TabOrder = 1
              OnClick = buFiles1Click
            end
          end
          object Panel19: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 34
            Width = 240
            Height = 428
            Align = alClient
            BevelOuter = bvNone
            Caption = 'Panel19'
            TabOrder = 2
            object clbFileList: TCheckListBox
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 228
              Height = 416
              Margins.Left = 6
              Margins.Top = 6
              Margins.Right = 6
              Margins.Bottom = 6
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Monospac821 BT'
              Font.Style = []
              HeaderBackgroundColor = clHighlight
              ItemHeight = 14
              ParentFont = False
              PopupMenu = pmWSmenu
              TabOrder = 0
            end
          end
        end
        object Panel6: TPanel
          AlignWithMargins = True
          Left = 465
          Top = 9
          Width = 702
          Height = 505
          Margins.Left = 0
          Align = alClient
          BevelInner = bvLowered
          Caption = 'Panel6'
          TabOrder = 1
          object Panel3: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 475
            Width = 692
            Height = 28
            Margins.Top = 0
            Margins.Bottom = 0
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 0
            object Bevel1: TBevel
              AlignWithMargins = True
              Left = 83
              Top = 5
              Width = 5
              Height = 18
              Margins.Left = 0
              Margins.Top = 5
              Margins.Bottom = 5
              Align = alLeft
              ExplicitTop = 0
              ExplicitHeight = 28
            end
            object buClearLog: TButton
              AlignWithMargins = True
              Left = 3
              Top = 1
              Width = 70
              Height = 25
              Margins.Top = 1
              Margins.Right = 10
              Margins.Bottom = 2
              Align = alLeft
              Caption = 'Clear Log'
              TabOrder = 0
              OnClick = buClearLogClick
            end
            object buLoggerStatus: TButton
              AlignWithMargins = True
              Left = 97
              Top = 1
              Width = 130
              Height = 25
              Margins.Left = 6
              Margins.Top = 1
              Margins.Bottom = 2
              Align = alLeft
              Caption = 'Logger Status'
              TabOrder = 1
              OnClick = DoButtons
            end
            object buGetSysLog: TButton
              AlignWithMargins = True
              Left = 233
              Top = 1
              Width = 130
              Height = 25
              Margins.Top = 1
              Margins.Bottom = 2
              Align = alLeft
              Caption = 'Logger System Log'
              TabOrder = 2
              OnClick = DoButtons
            end
          end
          object Log: TListBox
            AlignWithMargins = True
            Left = 8
            Top = 6
            Width = 689
            Height = 433
            Margins.Left = 6
            Margins.Top = 4
            Align = alClient
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Monospac821 BT'
            Font.Style = []
            ItemHeight = 14
            ParentFont = False
            TabOrder = 1
            StyleElements = []
            OnClick = LogClick
          end
          object pInfo: TPanel
            AlignWithMargins = True
            Left = 8
            Top = 442
            Width = 689
            Height = 30
            Hint = 'System Log expansion'
            Margins.Left = 6
            Margins.Top = 0
            Align = alBottom
            Alignment = taLeftJustify
            BevelInner = bvLowered
            Color = clYellow
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Monospac821 BT'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            StyleElements = []
          end
        end
        object Panel10: TPanel
          AlignWithMargins = True
          Left = 262
          Top = 9
          Width = 200
          Height = 505
          Align = alLeft
          BevelInner = bvLowered
          TabOrder = 2
          object Label2: TLabel
            AlignWithMargins = True
            Left = 12
            Top = 69
            Width = 183
            Height = 13
            Margins.Left = 10
            Margins.Top = 10
            Margins.Bottom = 1
            Align = alTop
            Alignment = taCenter
            Caption = 'Logger Manual Operations'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 148
          end
          object Label1: TLabel
            AlignWithMargins = True
            Left = 12
            Top = 10
            Width = 183
            Height = 16
            Margins.Left = 10
            Margins.Top = 8
            Align = alTop
            Alignment = taCenter
            Caption = 'Logger IP Address (IPv4)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 165
          end
          object Label4: TLabel
            AlignWithMargins = True
            Left = 12
            Top = 217
            Width = 183
            Height = 13
            Margins.Left = 10
            Margins.Top = 30
            Margins.Bottom = 1
            Align = alTop
            Alignment = taCenter
            Caption = 'Logger Automatic Operations'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 166
          end
          object buGetDir: TButton
            Tag = 1
            AlignWithMargins = True
            Left = 12
            Top = 90
            Width = 176
            Height = 28
            Margins.Left = 10
            Margins.Top = 7
            Margins.Right = 10
            Margins.Bottom = 2
            Align = alTop
            Caption = 'Get Directory from Logger'
            TabOrder = 0
            OnClick = DoButtons
          end
          object buEraseFile: TButton
            Tag = 2
            AlignWithMargins = True
            Left = 12
            Top = 157
            Width = 176
            Height = 28
            Margins.Left = 10
            Margins.Top = 5
            Margins.Right = 10
            Margins.Bottom = 2
            Align = alTop
            Caption = 'Erase Checked File/s'
            TabOrder = 1
            OnClick = DoButtons
          end
          object PB: TProgressBar
            AlignWithMargins = True
            Left = 12
            Top = 484
            Width = 176
            Height = 14
            Margins.Left = 10
            Margins.Top = 5
            Margins.Right = 10
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 2
          end
          object cbLoggerIP: TComboBox
            AlignWithMargins = True
            Left = 32
            Top = 32
            Width = 136
            Height = 24
            Margins.Left = 30
            Margins.Right = 30
            Align = alTop
            Style = csDropDownList
            TabOrder = 3
            OnChange = cbLoggerIPChange
          end
          object buAutoImport: TButton
            Tag = 3
            AlignWithMargins = True
            Left = 12
            Top = 236
            Width = 176
            Height = 28
            Margins.Left = 10
            Margins.Top = 5
            Margins.Right = 10
            Margins.Bottom = 2
            Align = alTop
            Caption = 'Auto Import New Data'
            TabOrder = 4
            OnClick = buAutoImportClick
          end
          object buLocalImportSelected: TButton
            Tag = 13
            AlignWithMargins = True
            Left = 12
            Top = 125
            Width = 176
            Height = 25
            Margins.Left = 10
            Margins.Top = 5
            Margins.Right = 10
            Margins.Bottom = 2
            Align = alTop
            Caption = 'Import Checked Files'
            TabOrder = 5
            OnClick = DoButtons
          end
        end
      end
      object Panel8: TPanel
        Left = 0
        Top = 528
        Width = 1176
        Height = 193
        Align = alClient
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
      end
    end
    object tsData: TTabSheet
      Caption = 'Raw Data'
      ImageIndex = 2
      PopupMenu = pmWSmenu
      object HeaderControl1: THeaderControl
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1170
        Height = 17
        Sections = <
          item
            ImageIndex = -1
            Width = 14
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = 'Date && Time'
            Width = 152
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = 'Wind'
            Width = 228
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = 'Temp'
            Width = 76
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = 'Humidity'
            Width = 77
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = 'Pressure'
            Width = 76
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = 'Rainfall'
            Width = 139
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = 'RSSI'
            Width = 75
          end>
      end
      object DataVST: TVirtualStringTree
        AlignWithMargins = True
        Left = 3
        Top = 24
        Width = 870
        Height = 694
        Margins.Top = 1
        Align = alLeft
        Colors.BorderColor = 15987699
        Colors.DisabledColor = clGray
        Colors.DropMarkColor = 15385233
        Colors.DropTargetColor = 15385233
        Colors.DropTargetBorderColor = 15987699
        Colors.FocusedSelectionColor = 15385233
        Colors.FocusedSelectionBorderColor = clWhite
        Colors.GridLineColor = 15987699
        Colors.HeaderHotColor = clBlack
        Colors.HotColor = clBlack
        Colors.SelectionRectangleBlendColor = 15385233
        Colors.SelectionRectangleBorderColor = 15385233
        Colors.SelectionTextColor = clBlack
        Colors.TreeLineColor = 9471874
        Colors.UnfocusedSelectionColor = 15385233
        Colors.UnfocusedSelectionBorderColor = 15385233
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -13
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Height = 20
        Header.Options = [hoColumnResize, hoShowSortGlyphs, hoVisible]
        ScrollBarOptions.ScrollBars = ssVertical
        TabOrder = 1
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnColumnClick = DataVSTColumnClick
        OnGetText = DataVSTGetText
        OnMouseEnter = DataVSTMouseEnter
        OnMouseLeave = DataVSTMouseLeave
        Columns = <
          item
            Alignment = taCenter
            Position = 0
            Width = 12
          end
          item
            Alignment = taCenter
            Position = 1
            Width = 76
            WideText = 'Date'
          end
          item
            Alignment = taCenter
            Position = 2
            Width = 76
            WideText = 'Time'
          end
          item
            Alignment = taCenter
            Position = 3
            Width = 76
            WideText = 'Direction'
          end
          item
            Alignment = taCenter
            Position = 4
            Width = 76
            WideText = 'Avr. Speed'
          end
          item
            Alignment = taCenter
            Position = 5
            Width = 76
            WideText = 'Pk. Speed'
          end
          item
            Alignment = taCenter
            Position = 6
            Width = 76
            WideText = 'Temp.'
          end
          item
            Alignment = taCenter
            Position = 7
            Width = 76
            WideText = 'Humidity'
          end
          item
            Alignment = taCenter
            Position = 8
            Width = 76
            WideText = 'Pressure'
          end
          item
            Alignment = taCenter
            Position = 9
            Width = 70
            WideText = 'Hour'
          end
          item
            Alignment = taCenter
            Position = 10
            Width = 70
            WideText = 'Min'
          end
          item
            Alignment = taCenter
            Position = 11
            Width = 75
            WideText = 'RSSI'
          end>
      end
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 876
        Top = 23
        Width = 297
        Height = 695
        Margins.Left = 0
        Margins.Top = 0
        Align = alClient
        BevelInner = bvLowered
        TabOrder = 2
        object Label5: TLabel
          AlignWithMargins = True
          Left = 22
          Top = 22
          Width = 50
          Height = 16
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 50
          Align = alTop
          Caption = 'Date'
          Constraints.MaxWidth = 50
          Constraints.MinWidth = 50
          ExplicitLeft = 42
        end
        object dtpDataDate: TDateTimePicker
          AlignWithMargins = True
          Left = 70
          Top = 20
          Width = 100
          Height = 21
          Margins.Left = 40
          Margins.Right = 40
          Date = 44945.939673032410000000
          Time = 44945.939673032410000000
          TabOrder = 0
        end
        object rgTimes: TRadioGroup
          AlignWithMargins = True
          Left = 12
          Top = 51
          Width = 273
          Height = 162
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Align = alTop
          Caption = 'Data Start Time'
          Columns = 2
          ItemIndex = 7
          Items.Strings = (
            'All (1440)'
            '00:00'
            '02:00'
            '04:00'
            '06:00'
            '08:00'
            '10:00'
            '12:00'
            '14:00'
            '16:00'
            '18:00'
            '20:00'
            '22:00')
          TabOrder = 1
          OnClick = dtpDataDateChange
        end
        object rgSortOrder: TRadioGroup
          AlignWithMargins = True
          Left = 12
          Top = 219
          Width = 273
          Height = 240
          Margins.Left = 10
          Margins.Right = 10
          Align = alTop
          Caption = ' Sort Order '
          ItemIndex = 0
          Items.Strings = (
            'NONE'
            'Time'
            'Wind - Direction'
            'Wind - Avr. Speed'
            'Wind - Peak Speed'
            'Temperature'
            'Humidity'
            'Barometric Pressure'
            'Rainfall - Hour'
            'Rainfall - Minute'
            'RSSI')
          TabOrder = 2
          OnClick = dtpDataDateChange
        end
        object buLoadData: TButton
          Left = 185
          Top = 18
          Width = 100
          Height = 25
          Caption = 'Load Data'
          TabOrder = 3
          OnClick = buLoadDataClick
        end
        object Info: TMemo
          AlignWithMargins = True
          Left = 11
          Top = 465
          Width = 275
          Height = 222
          Margins.Left = 9
          Margins.Right = 9
          Margins.Bottom = 6
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          Lines.Strings = (
            ''
            '  DATA HANDLING FEATURES'
            ''
            ' 1). Data can be loaded by date and viewed '
            ' either in two-hour intervals or as a full '
            ' 24 hour period (1440 rows).'
            ''
            ' 2). Data can be sorted by various parameters '
            ' in ascending order.'
            ''
            ' 3). Data rows are editable and can be saved. '
            ' To edit a row, hold down the Ctrl key and'
            ' click on the desired row.'
            ' ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
        end
      end
    end
    object tsAnalyse: TTabSheet
      Caption = 'Analyse'
      ImageIndex = 3
      Constraints.MaxHeight = 875
      Constraints.MaxWidth = 1286
      Constraints.MinHeight = 611
      Constraints.MinWidth = 992
      object Panel24: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 123
        Width = 1170
        Height = 595
        Align = alClient
        BevelInner = bvLowered
        Caption = 'Panel24'
        TabOrder = 0
        object Graph: TImage
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 900
          Height = 585
          Align = alLeft
          ParentShowHint = False
          PopupMenu = pmWSmenu
          ShowHint = True
          ExplicitHeight = 587
        end
        object GroupBox1: TGroupBox
          AlignWithMargins = True
          Left = 913
          Top = 5
          Width = 250
          Height = 578
          Margins.Left = 5
          Margins.Right = 5
          Margins.Bottom = 10
          Align = alClient
          Caption = ' Parameters '
          Color = clWhite
          ParentBackground = False
          ParentColor = False
          TabOrder = 0
          object Label6: TLabel
            Left = 12
            Top = 26
            Width = 69
            Height = 16
            Margins.Left = 20
            Caption = 'Start Date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object sbPrevMonth: TSpeedButton
            Tag = 1
            Left = 195
            Top = 22
            Width = 24
            Height = 24
            Glyph.Data = {
              52050000424D5205000000000000420000002800000012000000120000000100
              20000300000010050000130B0000130B000000000000000000000000FF0000FF
              0000FF00000000000049000000E2000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000E200000048000000E3000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000E2000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000CE000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000F600000080000000060000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000C2000000280000
              000000000000000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000F00000006F0000
              0002000000000000000000000000000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000B30000
              001C0000000000000000000000000000000000000000000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000B30000001C00000000000000000000000000000000000000000000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000F00000006F00000002000000000000
              000000000000000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00C2000000280000000000000000000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000F60000008000000006000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000CE0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000E3000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000E20000004A000000E3000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000E300000049}
            OnClick = sbPrevMonthClick
          end
          object sbNextMonth: TSpeedButton
            Tag = 2
            Left = 216
            Top = 22
            Width = 24
            Height = 24
            Glyph.Data = {
              52050000424D5205000000000000420000002800000012000000120000000100
              20000300000010050000130B0000130B000000000000000000000000FF0000FF
              0000FF00000000000049000000E2000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000E200000048000000E3000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000E2000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000190000007A000000F4000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF00000000000000000000001A000000A20000
              00FE000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF00000000000000000000
              0000000000000000003F000000D2000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              0000000000000000000000000000000000000000000400000078000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF0000000000000000000000000000000000000000000000040000
              0078000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000000000000000000000000000000000
              003F000000D2000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF00000000000000000000
              001B000000A2000000FE000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              001D0000007A000000F4000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000E3000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000E20000004A000000E3000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000E300000049}
            OnClick = sbPrevMonthClick
          end
          object lMonth: TLabel
            Left = 148
            Top = 26
            Width = 41
            Height = 16
            Margins.Left = 20
            Alignment = taRightJustify
            Caption = 'Month'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object gbSmooting: TGroupBox
            AlignWithMargins = True
            Left = 12
            Top = 382
            Width = 231
            Height = 179
            Margins.Left = 10
            Margins.Top = 300
            Margins.Right = 8
            Margins.Bottom = 0
            Caption = 'Data Smoothing (SMA) '
            TabOrder = 0
            object lSampleWindow: TLabel
              AlignWithMargins = True
              Left = 5
              Top = 28
              Width = 221
              Height = 16
              Margins.Top = 10
              Align = alTop
              Alignment = taCenter
              Caption = 'Sample Window Width'
              ExplicitWidth = 130
            end
            object Label3: TLabel
              AlignWithMargins = True
              Left = 12
              Top = 86
              Width = 207
              Height = 48
              Margins.Left = 10
              Margins.Right = 10
              Align = alTop
              Caption = 
                'To invoke data smoothing, hold the shift key down whilst pressin' +
                'g the activity button.'
              WordWrap = True
              ExplicitWidth = 205
            end
            object tbSampleWindow: TTrackBar
              AlignWithMargins = True
              Left = 12
              Top = 50
              Width = 207
              Height = 30
              Margins.Left = 10
              Margins.Right = 10
              Align = alTop
              LineSize = 2
              PageSize = 1
              Position = 4
              SelEnd = 21
              ShowSelRange = False
              TabOrder = 0
              OnChange = tbSampleWindowChange
            end
          end
          object caStartDate: TCalendar
            Left = 12
            Top = 52
            Width = 233
            Height = 155
            Color = clWhite
            StartOfWeek = 1
            TabOrder = 1
            UseCurrentDate = False
            OnChange = caStartDateChange
          end
          object rgPeriod: TRadioGroup
            Left = 12
            Top = 213
            Width = 98
            Height = 165
            Caption = ' Period '
            ItemIndex = 0
            Items.Strings = (
              '1 Day'
              '1 Week'
              '2 weeks'
              '1 Month'
              '3 Months'
              '6 Monhs'
              '12 Months'
              '24 Months')
            TabOrder = 2
          end
          object ShowMinMax: TGroupBox
            AlignWithMargins = True
            Left = 122
            Top = 326
            Width = 122
            Height = 50
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Caption = 'Show Min/Max'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            object cbShowMinMax: TCheckBox
              AlignWithMargins = True
              Left = 32
              Top = 18
              Width = 58
              Height = 20
              Margins.Left = 30
              Margins.Top = 0
              Margins.Right = 30
              Margins.Bottom = 0
              Align = alTop
              Alignment = taLeftJustify
              Caption = 'Show'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = rgMeasurementOldClick
            end
          end
          object buToday: TButton
            Tag = 1
            Left = 120
            Top = 221
            Width = 122
            Height = 30
            Caption = 'Today'
            TabOrder = 4
            OnClick = buTodayClick
          end
          object Button1: TButton
            Tag = 2
            Left = 120
            Top = 257
            Width = 122
            Height = 30
            Caption = 'Yesterday'
            TabOrder = 5
            OnClick = buTodayClick
          end
          object Button2: TButton
            Tag = 3
            Left = 122
            Top = 293
            Width = 122
            Height = 30
            Caption = 'Monday'
            TabOrder = 6
            OnClick = buTodayClick
          end
        end
        object RFAnalyse: TMemo
          AlignWithMargins = True
          Left = -1
          Top = 0
          Width = 903
          Height = 583
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Monospac821 BT'
          Font.Style = []
          Lines.Strings = (
            'RFAnalyse'
            ''
            'This will be in the'
            'correct position'
            'at run time.')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 1
          Visible = False
        end
      end
      object ToolBar: TToolBar
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1170
        Height = 75
        AutoSize = True
        BorderWidth = 1
        ButtonHeight = 71
        ButtonWidth = 99
        Color = clNavy
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Images = ImageList
        ParentColor = False
        ParentFont = False
        ShowCaptions = True
        TabOrder = 1
        StyleElements = []
        Wrapable = False
        object ToolButton3: TToolButton
          Left = 0
          Top = 0
          Width = 8
          Caption = 'ToolButton3'
          ImageIndex = 22
          Style = tbsSeparator
        end
        object TB1: TToolButton
          Tag = 1
          Left = 8
          Top = 0
          AutoSize = True
          Caption = ' Wind Rose '
          ImageIndex = 0
          OnClick = TB1Click
        end
        object TB2: TToolButton
          Tag = 2
          Left = 88
          Top = 0
          Hint = 'Hold shift down for data smoothing'
          AutoSize = True
          Caption = 'Wind Graph'
          ImageIndex = 1
          ParentShowHint = False
          ShowHint = True
          OnClick = TB1Click
        end
        object TB3: TToolButton
          Tag = 3
          Left = 166
          Top = 0
          AutoSize = True
          Caption = 'Wind Polar'
          ImageIndex = 2
          OnClick = TB1Click
        end
        object ToolButton5: TToolButton
          Left = 239
          Top = 0
          Width = 8
          Caption = 'ToolButton5'
          ImageIndex = 19
          Style = tbsSeparator
        end
        object TB4: TToolButton
          Tag = 4
          Left = 247
          Top = 0
          Hint = 'Hold shift down for data smoothing'
          AutoSize = True
          Caption = 'Wind Speed Avr'
          ImageIndex = 3
          ParentShowHint = False
          ShowHint = True
          OnClick = TB1Click
        end
        object TB5: TToolButton
          Tag = 5
          Left = 350
          Top = 0
          AutoSize = True
          Caption = 'Wind Speed Pk'
          ImageIndex = 4
          ParentShowHint = False
          ShowHint = False
          OnClick = TB1Click
        end
        object ToolButton7: TToolButton
          Left = 447
          Top = 0
          Width = 8
          Caption = 'ToolButton7'
          ImageIndex = 19
          Style = tbsSeparator
        end
        object TB6: TToolButton
          Tag = 6
          Left = 455
          Top = 0
          Hint = 'Hold shift down for data smoothing'
          AutoSize = True
          Caption = 'Temperature'
          ImageIndex = 5
          ParentShowHint = False
          ShowHint = True
          OnClick = TB1Click
        end
        object ToolButton8: TToolButton
          Left = 541
          Top = 0
          Width = 8
          Caption = 'ToolButton8'
          ImageIndex = 12
          Style = tbsSeparator
        end
        object TB7: TToolButton
          Tag = 7
          Left = 549
          Top = 0
          Hint = 'Hold shift down for data smoothing'
          AutoSize = True
          Caption = 'Humidity'
          ImageIndex = 6
          ParentShowHint = False
          ShowHint = True
          OnClick = TB1Click
        end
        object ToolButton10: TToolButton
          Left = 609
          Top = 0
          Width = 8
          Caption = 'ToolButton10'
          ImageIndex = 14
          Style = tbsSeparator
        end
        object TB8: TToolButton
          Tag = 8
          Left = 617
          Top = 0
          AutoSize = True
          Caption = 'Rainfall Text'
          ImageIndex = 7
          OnClick = TB1Click
        end
        object TB9: TToolButton
          Tag = 9
          Left = 699
          Top = 0
          AutoSize = True
          Caption = 'Rainfall Graph'
          ImageIndex = 8
          OnClick = TB1Click
        end
        object TB12: TToolButton
          Tag = 11
          Left = 790
          Top = 0
          AutoSize = True
          Caption = 'Rainfall Rate'
          ImageIndex = 9
          OnClick = TB1Click
        end
        object ToolButton13: TToolButton
          Left = 873
          Top = 0
          Width = 8
          Caption = 'ToolButton13'
          ImageIndex = 18
          Style = tbsSeparator
        end
        object TB10: TToolButton
          Tag = 10
          Left = 881
          Top = 0
          Hint = 'Hold shift down for data smoothing'
          AutoSize = True
          Caption = 'Barometer'
          ImageIndex = 10
          ParentShowHint = False
          ShowHint = True
          OnClick = TB1Click
        end
        object ToolButton1: TToolButton
          Left = 952
          Top = 0
          Width = 8
          Caption = 'ToolButton1'
          ImageIndex = 3
          Style = tbsSeparator
        end
        object TB11: TToolButton
          Left = 960
          Top = 0
          AutoSize = True
          Caption = 'Print'
          ImageIndex = 11
          OnClick = TB11Click
        end
        object ToolButton2: TToolButton
          Left = 1015
          Top = 0
          Width = 8
          Caption = 'ToolButton2'
          ImageIndex = 21
          Style = tbsSeparator
        end
        object TB13: TToolButton
          Tag = 12
          Left = 1023
          Top = 0
          AutoSize = True
          Caption = 'RSSI'
          ImageIndex = 12
          OnClick = TB13Click
        end
      end
      object LDP: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 84
        Width = 1170
        Height = 33
        Align = alTop
        BevelInner = bvLowered
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        StyleElements = [seClient, seBorder]
      end
    end
  end
  object SD: TSaveDialog
    DefaultExt = 'Log'
    FileName = '*.Log'
    Left = 564
    Top = 184
  end
  object DataSource: TDataSource
    AutoEdit = False
    Left = 544
    Top = 297
  end
  object MainMenu: TMainMenu
    Images = ImageList16
    Left = 516
    Top = 185
    object Settings1: TMenuItem
      Caption = 'Settings'
      ImageIndex = 3
      object EditSettings1: TMenuItem
        Caption = 'Edit Settings'
        OnClick = EditSettings1Click
      end
      object PrinterSetup1: TMenuItem
        Caption = 'Printer Setup'
        OnClick = PrinterSetup1Click
      end
    end
    object Database1: TMenuItem
      Caption = 'Database'
      ImageIndex = 1
      object EmptyDatabase: TMenuItem
        Caption = 'Empty Database'
        OnClick = EmptyDatabaseClick
      end
    end
    object WeatherStation1: TMenuItem
      Caption = 'Weather Station'
      ImageIndex = 2
      object IPAddress1: TMenuItem
        Caption = 'IP Addresses'
        OnClick = IPAddress1Click
      end
      object LoggerUnit1: TMenuItem
        Caption = 'Logger'
        object RestartLogger: TMenuItem
          Caption = 'Restart Logger'
          OnClick = RestartLoggerClick
        end
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ImportData1: TMenuItem
      Bitmap.Data = {
        42040000424D4204000000000000420000002800000010000000100000000100
        20000300000000040000C30E0000C30E000000000000000000000000FF0000FF
        0000FF0000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000700000073000000AA000000AB000000AB0000
        00AB000000AB000000AB000000AB000000AB000000AB000000AA000000730000
        0007000000000000000000000073000000F3000000AE000000AB000000AB0000
        00AB000000AB000000AB000000AB000000AB000000AB000000AE000000F30000
        00730000000000000000000000AA000000AE0000000100000000000000000000
        0000000000000000000000000000000000000000000000000001000000AE0000
        00AA0000000000000000000000AB000000AB0000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000AB0000
        00AB0000000000000000000000AA000000AA0000000000000000000000000000
        0002000000660000006600000002000000000000000000000000000000AA0000
        00AA000000000000000000000059000000590000000000000000000000020000
        0074000000FC000000FC00000074000000020000000000000000000000590000
        0059000000000000000000000000000000000000000000000002000000740000
        00F8000000ED000000ED000000F8000000740000000200000000000000000000
        000000000000000000000000000000000000000000000000003E000000F70000
        0073000000AC000000AC00000073000000F80000003E00000000000000000000
        000000000000000000000000000000000000000000000000000C0000003E0000
        0002000000AB000000AB000000020000003E0000000C00000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000AB000000AB00000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000AB000000AB00000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000AB000000AB00000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000AA000000AA00000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000590000005900000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000}
      Caption = 'Import Data'
      ImageIndex = 0
      OnClick = ImportData1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object About1: TMenuItem
      Caption = 'About'
      ImageIndex = 4
      OnClick = About1Click
    end
  end
  object pmWSmenu: TPopupMenu
    Left = 501
    Top = 248
    object TMenuItem
    end
    object mCheckDLSelected: TMenuItem
      Caption = 'Check Selected Files'
      OnClick = mCheckDLSelectedClick
    end
    object mClearDLDirectory: TMenuItem
      Caption = 'Clear Directory'
      OnClick = mClearDLDirectoryClick
    end
    object mViewSignalLevel: TMenuItem
      Tag = 1
      Caption = 'View RSSI'
      OnClick = mViewlFileClick
    end
    object mViewFile: TMenuItem
      Caption = 'View File'
      OnClick = mViewlFileClick
    end
    object mCheckImportSelected: TMenuItem
      Caption = 'Check Selected Files'
    end
    object mViewPlotBuffer: TMenuItem
      Caption = 'View Plot Buffer'
      OnClick = mViewPlotBufferClick
    end
    object mEditRowData: TMenuItem
      Caption = 'Edit Data'
    end
  end
  object ImageList: TImageList
    Height = 48
    Width = 48
    Left = 612
    Top = 184
    Bitmap = {
      494C01010D00D001540130003000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000C0000000C000000001002000000000000040
      0200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000001D00000034000000340000001D000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000C7000000FF000000FF000000C7000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000B1000000FF000000FF000000B1000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000083000000FF000000FF00000083000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000083000000FF000000FF00000083000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000084000000FF000000FF00000084000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000059000000FF000000FF00000059000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000055000000FF000000FF00000055000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000055000000FF000000FF00000055000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000049000000FF000000FF00000049000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000034000000FF000000FF00000034000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000034000000FF000000FF00000034000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000034000000FF000000FF00000034000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000E0000002E000000000000000000000000000000000000
      000000000000000000000000001C000000FF000000FF0000001C000000000000
      000000000000000000000000000000000000000000000000002E0000000E0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000E0000009E000000FF000000130000000000000000000000000000
      0000000000000000000000000018000000FF000000FF00000018000000000000
      00000000000000000000000000000000000000000013000000FF0000009E0000
      000E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000500000090000000FF00000055000000000000000000000000000000000000
      0000000000000000000000000018000000FF000000FF00000018000000000000
      0000000000000000000000000000000000000000000000000055000000FF0000
      0090000000050000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      004E000000FF0000006800000000000000050000006F00000066000000000000
      0000000000000000000000000010000000FF000000FF00000010000000000000
      00000000000000000000000000660000006F0000000500000000000000680000
      00FF0000004E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000130000
      00FF000000AF000000090000000000000066000000FF0000006F000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      000000000000000000000000006F000000FF0000006600000000000000090000
      00AF000000FF0000001300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000005D0000
      00FF0000003A0000000000000033000000FF0000009000000005000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      000000000000000000000000000500000090000000FF00000033000000000000
      003A000000FF0000005D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000009000000C60000
      00AF0000000500000005000000AF000000FF00000015000000000000001D0000
      009D000000280000000000000000000000FF000000FF00000000000000000000
      00280000009D0000001D0000000000000015000000FF000000AF000000050000
      0005000000AF000000C600000009000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000002A000000FF0000
      00550000000000000031000000FF0000005D0000000000000009000000A80000
      00FF0000002900000000000000000000008D0000008D00000000000000000000
      0029000000FF000000A800000009000000000000005D000000FF000000310000
      000000000055000000FF0000002A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000055000000FF0000
      0025000000000000006E000000FF00000020000000000000004E000000FF0000
      0055000000000000000000000000000000470000004700000000000000000000
      000000000055000000FF0000004E0000000000000020000000FF0000006E0000
      000000000025000000FF00000055000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000083000000FF0000
      000D00000000000000B2000000C70000000000000000000000AF000000C70000
      0009000000000000000000000000000000000000000000000000000000000000
      000000000009000000C7000000AF0000000000000000000000C7000000B20000
      00000000000D000000FF00000083000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000087000000FF0000
      000000000001000000FF000000830000000000000013000000FF000000720000
      0000000000000000000000000018000000C2000000C70000001D000000000000
      00000000000000000072000000FF000000130000000000000083000000FF0000
      000100000000000000FF00000087000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000E4000000FF0000
      000000000018000000FF000000830000000000000018000000FF000000550000
      0000000000000000000000000055000000FF000000FF00000055000000000000
      00000000000000000055000000FF000000180000000000000083000000FF0000
      001800000000000000FF000000E4000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000090000000FF0000
      000000000006000000FF000000830000000000000017000000FF0000006B0000
      0000000000000000000000000028000000FF000000FF00000028000000000000
      0000000000000000006B000000FF000000170000000000000083000000FF0000
      000600000000000000FF00000090000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000083000000FF0000
      000900000000000000C7000000AF0000000000000000000000C7000000BD0000
      00050000000000000000000000000000000E0000000E00000000000000000000
      000000000005000000BD000000C70000000000000000000000AF000000C70000
      000000000009000000FF00000083000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000005C000000FF0000
      00220000000000000070000000FF00000018000000000000005C000000FF0000
      0040000000000000000000000000000000000000000000000000000000000000
      000000000040000000FF0000005C0000000000000018000000FF000000700000
      000000000022000000FF0000005C000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000032000000FF0000
      0047000000000000003A000000FF0000004E000000000000000E000000C70000
      00E3000000180000000000000000000000000000000000000000000000000000
      0018000000E3000000C70000000E000000000000004E000000FF0000003A0000
      000000000047000000FF00000032000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000A000000FF0000
      009E0000000000000009000000C7000000C70000000E000000000000002D0000
      00C7000000220000000000000000000000000000000000000000000000000000
      0022000000C70000002D000000000000000E000000C7000000C7000000090000
      00000000009E000000FF0000000A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000006F0000
      00FF0000002E0000000000000041000000FF0000007800000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000078000000FF00000041000000000000
      002E000000FF0000006F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000001D0000
      00FF00000090000000050000000400000081000000FF0000004E000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000004E000000FF0000008100000004000000050000
      0090000000FF0000001D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0065000000FF0000004E000000000000000E000000900000004E000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000004E000000900000000E000000000000004E0000
      00FF000000650000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00090000009F000000FF00000034000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000034000000FF0000
      009F000000090000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000001D000000C7000000D4000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000D4000000C70000
      001D000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000001800000022000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000022000000180000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FEFEFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE0000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00FDFDFD00FDFD
      FD00FEFEFE0000000000FEFEFE00FDFDFD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00FEFEFE0000000000000000000000000000000000FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00FEFEFE0000000000000000000000000000000000FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FE00FFFFFE00FEFEFD00FDFDFC00FEFEFD00FFFFFE000000000000000000FEFE
      FF00FEFDFF00FDFCFE00FEFEFE00000000000000000000000000FEFEFE00FCFC
      FC00FDFDFD00FEFEFE00FEFEFE0000000000FFFEFF00FEFDFE00FDFDFE00FFFE
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FE00FFFFFE00FEFEFD00FDFDFC00FEFEFD00FFFFFE000000000000000000FEFE
      FF00FEFDFF00FDFCFE00FEFEFE00000000000000000000000000FEFEFE00FCFC
      FC00FDFDFD00FEFEFE00FEFEFE0000000000FFFEFF00FEFDFE00FDFDFE00FFFE
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00FDFDFD00FDFDFD00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FDFDFD00FDFDFD00FDFDFD00FDFD
      FD00FDFDFD00FDFDFD00FDFDFD00FDFDFD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFD00FEFEFE00000000000000
      0000FEFEFE00FEFEFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFC00ACADAB007A7B7900C8C8C70000000000FFFEFF00FFFEFF00F0F0
      F2009290940086858800E7E7E700000000000000000000000000DCDCDC008080
      80009D9D9D00F9F9F900FEFEFE0000000000FEFDFE00BFBEC00079787A00BFBE
      C100FEFDFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFC00ACADAB007A7B7900C8C8C70000000000FFFEFF00FFFEFF00F0F0
      F2009290940086858800E7E7E700000000000000000000000000DCDCDC008080
      80009D9D9D00F9F9F900FEFEFE0000000000FEFDFE00BFBEC00079787A00BFBE
      C100FEFDFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FDFDFD00FDFD
      FD00FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      0000FEFEFE00FDFDFD00FDFDFD00FDFDFD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D9D9D900262527002020220049484A00F4F4F40000000000FFFEFF009B9A
      9D001E1D2000201F22007C7B7C00FEFEFE0000000000FBFBFB00585858002121
      210020202000C0C0C000FEFEFE0000000000E4E3E5002D2C2E00212022003433
      3600EDECEE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D9D9D900262527002020220049484A00F4F4F40000000000FFFEFF009B9A
      9D001E1D2000201F22007C7B7C00FEFEFE0000000000FBFBFB00585858002121
      210020202000C0C0C000FEFEFE0000000000E4E3E5002D2C2E00212022003433
      3600EDECEE000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00FDFDFD00FEFE
      FE000000000000000000FEFEFE00FBFBFB00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00FDFDFD00FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D8D8D90029282A002120230044434500F6F6F600FFFFFE00FEFEFE009A9A
      9B001F1F2000202022007E7E7F00FEFDFE00FFFEFF00FDFDFD005D5D5D002222
      220022222200C3C3C300FEFEFE00FFFEFF00E1E1E30037363800212121003433
      3500F1F0F1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D8D8D90029282A002120230044434500F6F6F600FFFFFE00FEFEFE009A9A
      9B001F1F2000202022007E7E7F00FEFDFE00FFFEFF00FDFDFD005D5D5D002222
      220022222200C3C3C300FEFEFE00FFFEFF00E1E1E30037363800212121003433
      3500F1F0F1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FAFAFA00F0F0F000E8E8E8FFEBEBEBAAEBEBEBAAEBEBEBAAEBEB
      EBAAEBEBEBAAEBEBEBAAEBEBEBAAEBEBEBAAE8E8E8FFE8E8E8FFE8E8E8FFE8E8
      E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8
      E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6
      E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE7E7E7FFE5E5E5FFE6E6E6FFEEEE
      EE44F8F8F8000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7E7E700272727002323
      2300232323002323230023232300232323002323230023232300232323002323
      2300232323002323230023232300232323002323230023232300232323002323
      2300232323002323230023232300232323002323230023232300232323002323
      2300232323002323230057575700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FBFBFC006B6A6D0022212300A1A1A100FEFEFE00FFFFFD00FFFFFD00EBEB
      EB00434344002D2C2D00DFDEE100FEFDFF00FEFEFF0000000000B9B9B9002929
      290050505000F8F8F80000000000FFFEFF00FCFBFC0085858600212121009594
      9600FFFEFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FBFBFC006B6A6D0022212300A1A1A100FEFEFE00FFFFFD00FFFFFD00EBEB
      EB00434344002D2C2D00DFDEE100FEFDFF00FEFEFF0000000000B9B9B9002929
      290050505000F8F8F80000000000FFFEFF00FCFBFC0085858600212121009594
      9600FFFEFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FDFDFD000000
      0000FEFEFE00707070FF181818FF2A2A2AFF282828FF2C2C2CFF2A2A2AFF2D2D
      2DFF2D2D2DFF292929FF2C2C2CFF2C2C2CFF2F2F2FFF272727FF353535FF2929
      29FF2D2D2DFF2B2B2BFF2A2A2AFF2D2D2DFF2D2D2DFF2E2E2EFF2C2C2CFF2E2E
      2EFF2B2B2BFF2F2F2FFF272727FF303030FF313131FF2C2C2CFF2D2D2DFF2E2E
      2EFF2A2A2AFF333333FF2D2D2DFF2F2F2FFF373737FF282828FF343434FF5D5D
      5DFFFCFCFC0000000000FBFBFB00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D8D8D800010101006666
      6600909090009090900090909000909090009090900090909000909090009090
      9000909090009090900090909000909090009090900090909000909090009090
      9000909090009090900090909000909090009090900090909000909090009090
      900090909000303030004E4E4E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00FEFEFF00DFDEE00072717400F9F9F900FFFFFE00FFFFFD00FFFFFE000000
      0000A9A9A9009D9D9D00FEFDFF00FEFDFF00FFFEFF0000000000F6F6F6008181
      8100D2D2D200FEFEFE00FEFDFE00FEFDFF00FEFDFF00E2E2E3006B6B6B00EFEF
      EF00FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00FEFEFF00DFDEE00072717400F9F9F900FFFFFE00FFFFFD00FFFFFE000000
      0000A9A9A9009D9D9D00FEFDFF00FEFDFF00FFFEFF0000000000F6F6F6008181
      8100D2D2D200FEFEFE00FEFDFE00FEFDFF00FEFDFF00E2E2E3006B6B6B00EFEF
      EF00FEFEFE000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00000000000000
      0000E9E9E9EE171717FFB2B2B2FF9E9E9EFFA3A3A3FFA1A1A1FF9A9A9AFF9F9F
      9FFFA4A4A4FFA0A0A0FF9F9F9FFF9F9F9FFF9B9B9BFFA5A5A5FF9C9C9CFFA0A0
      A0FF9E9E9EFFA6A6A6FF9D9D9DFFA0A0A0FF9E9E9EFFA2A2A2FF999999FFA2A2
      A2FF9B9B9BFFA4A4A4FF9D9D9DFF989898FF999999FF9A9A9AFFA1A1A1FF9D9D
      9DFF9C9C9CFFA3A3A3FF999999FF999999FF929292FFA1A1A1FFA1A1A1FF3838
      38FFDDDDDDFF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00282828009C9C
      9C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FCFCFC001E1E1E008D8D8D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00EBEBEC00F4F3
      F400FEFEFE00FEFDFE00FEFEFE00FEFEFE00FCFCFB00E8E8E800F9F9F900FEFE
      FE00FAFAFA00FFFEFF00FEFEFF00F4F3F500EAE9EB00FDFDFD00FEFEFE00FAFA
      FA00FEFEFE00FDFDFD00EFEEEF00F1F1F300FEFDFF00FEFDFE00FEFEFE000000
      0000FBFAFC00E7E7E800F6F5F700FDFDFE00FEFEFF00FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00EBEBEC00F4F3
      F400FEFEFE00FEFDFE00FEFEFE00FEFEFE00FCFCFB00E8E8E800F9F9F900FEFE
      FE00FAFAFA00FFFEFF00FEFEFF00F4F3F500EAE9EB00FDFDFD00FEFEFE00FAFA
      FA00FEFEFE00FDFDFD00EFEEEF00F1F1F300FEFDFF00FEFDFE00FEFEFE000000
      0000FBFAFC00E7E7E800F6F5F700FDFDFE00FEFEFF00FEFEFE00000000000000
      000000000000000000000000000000000000FEFEFE00FCFCFC00FCFCFC000000
      00008E8E8EFF696969FF0F0F0FFF000000FF000000FF030303FF070707FF0404
      04FF000000FF000000FF080808FF000000FF020202FF040404FF000000FF0101
      01FF000000FF000000FF000000FF000000FF000000FF000000FF050505FF0000
      00FF000000FF000000FF030303FF020202FF030303FF030303FF000000FF0101
      01FF040404FF000000FF010101FF050505FF050505FF020202FF101010FF5858
      58FF7A7A7AFFF8F8F800FCFCFC00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005F5F5F006868
      6800000000000000000000000000C4C4C4003F3F3F003E3E3E003E3E3E003E3E
      3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E
      3E003E3E3E003E3E3E003E3E3E003E3E3E0047474700F4F4F400000000000000
      0000E8E8E80002020200CBCBCB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCFBFC008B8A8D00333235004746
      4800D9D9DA00FEFEFE00FEFEFE00EEEEEE0057575700303031006A6A6B00F6F6
      F6000000000000000000CFCED00041414300343335009D9D9D00FDFDFD00FEFE
      FE00FEFEFE0094949400333233003F3E4000C9C9CB00FEFEFE00FEFEFE00F6F6
      F7006B6A6C00302F32005A595D00E9E8EA00FEFEFE00FEFEFE00FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCFBFC008B8A8D00333235004746
      4800D9D9DA00FEFEFE00FEFEFE00EEEEEE0057575700303031006A6A6B00F6F6
      F6000000000000000000CFCED00041414300343335009D9D9D00FDFDFD00FEFE
      FE00FEFEFE0094949400333233003F3E4000C9C9CB00FEFEFE00FEFEFE00F6F6
      F7006B6A6C00302F32005A595D00E9E8EA00FEFEFE00FEFEFE00FEFEFE000000
      000000000000000000000000000000000000000000000000000000000000FDFD
      FD00282828FF7B7B7BFF000000FF666666FFBABABAFFC6C6C6FFCBCBCBFFD3D3
      D3FFD4D4D4FFCACACAFFCACACAFFCECECEFFD1D1D1FFC6C6C6FFCFCFCFFFD2D2
      D2FFCECECEFFC3C3C3FF7A7A7AFF818181FF7D7D7DFF8A8A8AFF7F7F7FFFAFAF
      AFFFD5D5D5FFD3D3D3FFCECECEFFD5D5D5FFD0D0D0FFD1D1D1FFD8D8D8FFCECE
      CEFFD4D4D4FFD9D9D9FFD0D0D0FFD2D2D2FFCCCCCCFF747474FF050505FF6F6F
      6FFF242424FFFCFCFC0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009D9D9D002D2D
      2D00F5F5F5000000000000000000CFCFCF007575750074747400747474007474
      7400747474007474740074747400747474007474740074747400747474007474
      7400747474007474740074747400747474007E7E7E00FEFEFE00000000000000
      0000AAAAAA000B0B0B00F0F0F000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E4E4E5002D2C2E00222123002322
      230086868600FEFEFE00FEFEFE00ADADAD00212121002120220023222400CCCC
      CC00FEFEFE00FDFDFD006D6C6E00212022002120220039393900F1F1F100FEFE
      FE00F2F2F2003A3A3A00212122002120220074737600FDFCFD00FEFEFE00C5C4
      C60022212300212022001F1D2100B1B0B200FEFEFE00FEFEFE00FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E4E4E5002D2C2E00222123002322
      230086868600FEFEFE00FEFEFE00ADADAD00212121002120220023222400CCCC
      CC00FEFEFE00FDFDFD006D6C6E00212022002120220039393900F1F1F100FEFE
      FE00F2F2F2003A3A3A00212122002120220074737600FDFCFD00FEFEFE00C5C4
      C60022212300212022001F1D2100B1B0B200FEFEFE00FEFEFE00FEFEFE000000
      00000000000000000000000000000000000000000000F9F9F90000000000E4E4
      E4FF232323FF4E4E4EFF181818FFD4D4D4FF8F8F8FFFE5E5E5FF00000000F7F7
      F7000000000000000000000000000000000000000000FCFCFC00000000000000
      0000ACACACFFA8A8A8FFDFDFDFFFA4A4A4FFA8A8A8FFA3A3A3FFCFCFCFFFBEBE
      BEFFA9A9A9FFF9F9F90000000000F6F6F600FDFDFD0000000000FEFEFE000000
      0000000000000000000000000000FEFEFE00949494FFC7C7C7FF303030FF2A2A
      2AFF505050FFAFAFAFFF00000000FDFDFD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D5D5D5000707
      0700CACACA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006E6E6E0036363600FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0EFF00042424300222122002020
      2100A7A7A800FEFDFF00FEFEFF00C6C5C60027262800202022002B2B2C00E3E3
      E30000000000FEFEFE008B8A8D00202022002020210050505000FAFAFA00FEFE
      FE00F7F7F700505050001F1F20002120230095949600FEFEFF0000000000D9D9
      DA002D2C2E00201F220026252800D1D1D100FEFEFD00FEFEFD00FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0EFF00042424300222122002020
      2100A7A7A800FEFDFF00FEFEFF00C6C5C60027262800202022002B2B2C00E3E3
      E30000000000FEFEFE008B8A8D00202022002020210050505000FAFAFA00FEFE
      FE00F7F7F700505050001F1F20002120230095949600FEFEFF0000000000D9D9
      DA002D2C2E00201F220026252800D1D1D100FEFEFD00FEFEFD00FEFEFE000000
      000000000000000000000000000000000000FEFEFE0000000000FDFDFD008F8F
      8FFF696969FF111111FF525252FFFDFDFD00FEFEFE0000000000000000000000
      000000000000FAFAFA00FBFBFB00FCFCFC000000000000000000F7F7F700AEAE
      AEFFB2B2B2FF848484FFB9B9B9FFCDCDCDFFBCBCBCFFBDBDBDFFCACACAFFB3B3
      B3FFCACACAFFADADADFFF3F3F300000000000000000000000000FCFCFC000000
      0000F9F9F900FCFCFC000000000000000000FEFEFE00FDFDFD007B7B7BFF0D0D
      0DFF6E6E6EFF707070FF00000000000000000000000000000000000000000000
      00000000000000000000E7E7E700A9A9A900A6A6A600A6A6A600A5A5A5001212
      12008B8B8B00000000000000000000000000D5D5D500A6A6A600A6A6A600A6A6
      A600A6A6A600A6A6A600A6A6A600A6A6A600A6A6A600A6A6A600A6A6A600A6A6
      A600A6A6A600A6A6A600A6A6A600ACACAC00EFEFEF0000000000000000000000
      00002A2A2A004C4C4C00A6A6A600A6A6A600A6A6A600BFBFBF00EDEDED000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFD00A4A4A400222222004544
      4600F2F2F300FEFDFF00FFFEFF00F6F5F700666567002120220079797A00FDFD
      FD000000000000000000DDDCDE0039383B0027262800B8B8B800FEFEFE00FEFE
      FE00FEFEFE00B3B3B3002322230038373900E9E8EA00FEFEFF0000000000FCFC
      FC007C7C7D002221230068686A00FDFDFD00FFFFFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFD00A4A4A400222222004544
      4600F2F2F300FEFDFF00FFFEFF00F6F5F700666567002120220079797A00FDFD
      FD000000000000000000DDDCDE0039383B0027262800B8B8B800FEFEFE00FEFE
      FE00FEFEFE00B3B3B3002322230038373900E9E8EA00FEFEFF0000000000FCFC
      FC007C7C7D002221230068686A00FDFDFD00FFFFFE0000000000000000000000
      00000000000000000000000000000000000000000000F8F8F800000000006767
      67FF7D7D7DFF000000FF747474FFDBDBDBFFF3F3F300F8F8F800000000000000
      0000FBFBFB00FEFEFE000000000000000000FCFCFC0000000000D8D8D8FFBFBF
      BFFF020202FF131313FF828282FFCFCFCFFFEAEAEACCE3E3E3FF9E9E9EFFBCBC
      BCFFB2B2B2FFC4C4C4FFCCCCCCFFF9F9F900000000000000000000000000FBFB
      FB00E1E1E1FFFBFBFB00FEFEFE0000000000FEFEFE00E5E5E5FF7F7F7FFF0000
      00FF787878FF454545FFF9F9F900FEFEFE000000000000000000000000000000
      0000000000007979790001010100121212002121210020202000202020001010
      1000505050000000000000000000000000005E5E5E000B0B0B000B0B0B000B0B
      0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B
      0B000B0B0B000B0B0B000B0B0B000B0B0B00C7C7C7000000000000000000F2F2
      F20002020200121212002020200020202000202020001111110021212100C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EEEEEE0061616100BDBD
      BD00FEFDFE00FFFEFF00FFFEFF00FEFDFF00D4D3D6004F4E5100E8E8E900FEFE
      FE00FEFEFE00FEFEFE00FDFCFF00A1A0A2006C6C6D00F9F9F900FEFEFE00FEFE
      FE00FEFEFE00F7F7F70076767600ABAAAC00FEFDFF00FFFEFF00FEFEFE00FEFE
      FE00E1E1E2004E4D5000DDDCDE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EEEEEE0061616100BDBD
      BD00FEFDFE00FFFEFF00FFFEFF00FEFDFF00D4D3D6004F4E5100E8E8E900FEFE
      FE00FEFEFE00FEFEFE00FDFCFF00A1A0A2006C6C6D00F9F9F900FEFEFE00FEFE
      FE00FEFEFE00F7F7F70076767600ABAAAC00FEFDFF00FFFEFF00FEFEFE00FEFE
      FE00E1E1E2004E4D5000DDDCDE00FEFEFE000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00000000003D3D
      3DFF757575FF060606FF9D9D9DFFA9A9A9FFD3D3D3FFFEFEFE00F0F0F000D5D5
      D5FFDCDCDCFFD9D9D9FFD6D6D6FFE6E6E6FF0000000000000000949494FFB4B4
      B4FFA0A0A0FF090909FF1C1C1CFFCECECEFF000000000000000000000000C1C1
      C1FFC6C6C6FFABABABFFBCBCBCFFEEEEEE4400000000FDFDFD00A2A2A2FFE1E1
      E1FFBBBBBBFF949494FFF7F7F70000000000E5E5E5FFA2A2A2FFB9B9B9FF0909
      09FF717171FF1C1C1CFFFEFEFE00000000000000000000000000000000000000
      0000C9C9C90001010100A8A8A80000000000000000000000000000000000A3A3
      A30027272700FEFEFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AFAF
      AF0010101000FAFAFA00000000000000000000000000EFEFEF00606060002B2B
      2B00FAFAFA000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00EEEEEE00FDFD
      FD0000000000FEFEFF00FEFEFF00FEFEFF00FDFCFE00F2F1F300FEFDFE00FEFE
      FE00FEFEFE00FEFEFE00FEFDFF00F7F6F800F5F5F600FEFEFE00FEFEFE00FEFE
      FE00FEFDFF00FEFDFE00EDECEE00FBFBFC00FEFEFF00FEFEFE00FEFDFF00FEFD
      FF00FEFDFF00F1F1F200FCFCFC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00EEEEEE00FDFD
      FD0000000000FEFEFF00FEFEFF00FEFEFF00FDFCFE00F2F1F300FEFDFE00FEFE
      FE00FEFEFE00FEFEFE00FEFDFF00F7F6F800F5F5F600FEFEFE00FEFEFE00FEFE
      FE00FEFDFF00FEFDFE00EDECEE00FBFBFC00FEFEFF00FEFEFE00FEFDFF00FEFD
      FF00FEFDFF00F1F1F200FCFCFC00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00FCFCFC002727
      27FF797979FF090909FFD8D8D8FFFDFDFD0000000000A9A9A9FF535353FF7575
      75FF757575FF747474FF737373FF4C4C4CFFF9F9F900E4E4E4FFCBCBCBFFA4A4
      A4FFA5A5A5FFC9C9C9FF141414FF212121FF989898FFD3D3D3FFFCFCFC000000
      0000A5A5A5FFB6B6B6FFD1D1D1FFC5C5C5FFFDFDFD00B2B2B2FFA6A6A6FF7B7B
      7BFF727272FF969696FF999999FFF4F4F40000000000FBFBFB00F5F5F5000F0F
      0FFF696969FF222222FFEEEEEE44000000000000000000000000000000000000
      0000747474004F4F4F000000000000000000000000000000000000000000DCDC
      DC0001010100D4D4D400FEFEFE000000000000000000FEFEFE00FCFCFC00FDFD
      FD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFD
      FD00FDFDFD00FDFDFD00FDFDFD00FEFEFE000000000000000000000000007171
      7100444444000000000000000000000000000000000000000000CFCFCF000101
      0100D2D2D2000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FDFDFE00FDFDFD00FEFE
      FE00FEFEFE00FDFDFD00FDFDFD00FDFDFE00FDFCFE00FDFCFE00FDFCFE00FDFD
      FD00FDFDFD00FDFDFE00FDFCFE00FDFCFE00FDFCFE00FDFDFD00FDFDFD00FDFD
      FE00FDFCFE00FDFCFE00FDFCFE00FDFDFD00FDFDFD00FDFDFE00FDFCFE00FDFC
      FE00FEFDFE00FEFEFE00FAFAFA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FDFDFE00FDFDFD00FEFE
      FE00FEFEFE00FDFDFD00FDFDFD00FDFDFE00FDFCFE00FDFCFE00FDFCFE00FDFD
      FD00FDFDFD00FDFDFE00FDFCFE00FDFCFE00FDFCFE00FDFDFD00FDFDFD00FDFD
      FE00FDFCFE00FDFCFE00FDFCFE00FDFDFD00FDFDFD00FDFDFE00FDFCFE00FDFC
      FE00FEFDFE00FEFEFE00FAFAFA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001414
      14FF7D7D7DFF030303FFD6D6D6FFD9D9D9FFFAFAFA00505050FFF2F2F200FCFC
      FC0000000000FAFAFA00767676FF626262FFFEFEFE00C9C9C9FFDBDBDBFFBBBB
      BBFFA6A6A6FFFDFDFD00D7D7D7FF040404FF010101FF222222FFF0F0F0000000
      0000BABABAFFCECECEFFB8B8B8FFB6B6B6FFF3F3F300C7C7C7FF626262FFFEFE
      FE0000000000898989FFCCCCCCFFDCDCDCFF00000000E1E1E1FFD7D7D7FF1818
      18FF575757FF272727FFECECEC88FCFCFC000000000000000000000000000000
      00006C6C6C005F5F5F0000000000000000000000000000000000000000000000
      0000212121009E9E9E00FEFEFE0000000000F8F8F80036363600131313001414
      1400141414001414140014141400141414001414140014141400141414001414
      14001414140014141400141414007E7E7E000000000000000000000000003333
      33007D7D7D000000000000000000000000000000000000000000EFEFEF000000
      0000CECECE000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFCFE00E3E2E500C0BFC200BDBC
      BE00BCBBBE00BBBABD00BBBABD00BBBABD00BBBABE00BBBABE00BBBABE00BBBA
      BD00BBBABD00BBBABD00BBBABE00BBBABE00BBBABE00BBBABD00BBBABD00BBBA
      BE00BBBABE00BBBABE00BBBABE00BBBABD00BBBABD00BBBABE00BBBABE00BBBA
      BE00BCBBBD00BEBEBF00D2D2D300F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFCFE00E3E2E500C0BFC200BDBC
      BE00BCBBBE00BBBABD00BBBABD00BBBABD00BBBABE00BBBABE00BBBABE00BBBA
      BD00BBBABD00BBBABD00BBBABE00BBBABE00BBBABE00BBBABD00BBBABD00BBBA
      BE00BBBABE00BBBABE00BBBABE00BBBABD00BBBABD00BBBABE00BBBABE00BBBA
      BE00BCBBBD00BEBEBF00D2D2D300F0F0F0000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F8F800000000001A1A
      1AFF717171FF080808FF9D9D9DFFB0B0B0FFF0F0F000AAAAAAFF6F6F6FFFFEFE
      FE00FCFCFC00525252FF949494FFFDFDFD0000000000C0C0C0FFD9D9D9FFB3B3
      B3FFAEAEAEFF00000000F5F5F5002F2F2FFF000000FF000000FFDEDEDEFF0000
      0000B2B2B2FFD7D7D7FFC6C6C6FFADADADFFFAFAFA00CFCFCFFF7B7B7BFFF8F8
      F80000000000707070FFBCBCBCFF00000000F4F4F400B1B1B1FFAAAAAAFF2222
      22FF555555FF2A2A2AFFE5E5E5FFFEFEFE000000000000000000000000000000
      00006C6C6C005F5F5F0000000000000000000000000000000000000000000000
      00005A5A5A0062626200FEFEFE000000000000000000BABABA00A2A2A200A2A2
      A200A2A2A200A2A2A200A2A2A200A2A2A200A2A2A200A2A2A200A2A2A200A2A2
      A200A2A2A200A2A2A200A2A2A200DBDBDB000000000000000000F3F3F3000F0F
      0F00B5B5B5000000000000000000000000000000000000000000EFEFEF000000
      0000CECECE000000000000000000000000000000000000000000000000000000
      0000FEFEFE00FFFEFF00FDFCFD00C3C2C40053525600211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F24002220250057565A00ABABAD00F2F1F200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00FFFEFF00FDFCFD00C3C2C40053525600211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F24002220250057565A00ABABAD00F2F1F200000000000000
      000000000000000000000000000000000000FBFBFB0000000000FDFDFD002020
      20FF808080FF070707FFD7D7D7FF0000000000000000FBFBFB00919191FF6060
      60FF838383FF747474FF0000000000000000FEFEFE00DCDCDCFFC7C7C7FFB4B4
      B4FFA9A9A9FF0000000000000000CACACAFF6C6C6CFF2F2F2FFF424242FFF0F0
      F000A6A6A6FFBBBBBBFFE7E7E7FFADADADFFFAFAFA00B8B8B8FFABABABFF6868
      68FF797979FFA0A0A0FF9C9C9CFFEAEAEACC00000000FEFEFE00FBFBFB000D0D
      0DFF676767FF222222FFEEEEEE44000000000000000000000000000000000000
      00006C6C6C005F5F5F0000000000000000000000000000000000000000000000
      00009E9E9E002B2B2B00FDFDFD00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00C5C5C5000404
      0400FBFBFB000000000000000000000000000000000000000000EFEFEF000000
      0000CECECE000000000000000000000000000000000000000000000000000000
      0000FEFEFE00FCFCFD0088878B00211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F240028262B00555457006F6D710074737600706E7200615F63003D3C
      400026242900211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F240062616500EDECED000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00FCFCFD0088878B00211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F240062616500EDECED000000
      000000000000000000000000000000000000FAFAFA0000000000FCFCFC002929
      29FF878787FF000000FFC1C1C1FFDFDFDFFFE1E1E1FF0000000000000000D3D3
      D3FFCECECEFFFDFDFD00FEFEFE0000000000FEFEFE00FBFBFB00B4B4B4FFA5A5
      A5FFCECECEFFB9B9B9FFFCFCFC0000000000FBFBFB00E5E5E5FF464646FF3D3D
      3DFFBBBBBBFF9B9B9BFFA9A9A9FFF8F8F80000000000FDFDFD009D9D9DFFDFDF
      DFFFBBBBBBFF959595FFFAFAFA0000000000EFEFEF22DBDBDBFFDDDDDDFF0909
      09FF727272FF151515FFF6F6F600000000000000000000000000000000000000
      00006B6B6B005F5F5F0000000000000000000000000000000000000000000000
      0000CFCFCF00020202002A2A2A002B2B2B002B2B2B002B2B2B002B2B2B002B2B
      2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B
      2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B00141414003636
      3600000000000000000000000000000000000000000000000000EFEFEF000101
      0100CECECE000000000000000000000000000000000000000000000000000000
      0000FEFEFE00ADADAF00211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24004442
      4700A3A2A400F6F5F6000000000000000000000000000000000000000000F9F9
      F900D8D8D9008F8E91003A383C00211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F24007F7D8100FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00ADADAF00211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F24007F7D8100FEFE
      FE000000000000000000000000000000000000000000FEFEFE00FCFCFC004F4F
      4FFF828282FF000000FF616161FFA2A2A2FFF0F0F000F8F8F800FEFEFE000000
      0000F5F5F50000000000000000000000000000000000FAFAFA00A7A7A7FFD5D5
      D5FFA3A3A3FFC5C5C5FFB5B5B5FFF3F3F30000000000FBFBFB00A8A8A8FF4242
      42FF363636FFBDBDBDFFCCCCCCFFFAFAFA0000000000FAFAFA00FCFCFC00FDFD
      FD00E4E4E4FF000000000000000000000000ECECEC88A6A6A6FF818181FF0808
      08FF878787FF202020FFF8F8F800000000000000000000000000000000000000
      0000707070005E5E5E0000000000000000000000000000000000000000000000
      0000000000009A9A9A0095959500929292009696960099999900909090008E8E
      8E0096969600959595009B9B9B00969696009F9F9F009D9D9D00979797008E8E
      8E008B8B8B00929292009696960093939300909090009797970092929200C1C1
      C100000000000000000000000000000000000000000000000000EFEFEF000808
      0800D4D4D400000000000000000000000000000000000000000000000000FFFE
      FF00F9F8F90037353A00211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F24005D5B5F00F8F8
      F800000000000000000000000000000000000000000000000000000000000000
      00000000000000000000908F9100211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400B9B9
      BA0000000000000000000000000000000000000000000000000000000000FFFE
      FF00F9F8F90037353A00211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      000000000000211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400000000000000000000000000211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400B9B9
      BA000000000000000000000000000000000000000000FEFEFE00FCFCFC008080
      80FF7E7E7EFF101010FF646464FFF7F7F700FCFCFC00FEFEFE00000000000000
      00000000000000000000FEFEFE00FEFEFE000000000000000000F5F5F5009D9D
      9DFFD2D2D2FF8D8D8DFFCACACAFFB7B7B7FFA6A6A6FFAAAAAAFFE1E1E1FF9292
      92FF474747FF686868FFF3F3F30000000000FCFCFC000000000000000000FEFE
      FE0000000000FBFBFB0000000000FCFCFC00FBFBFB00000000008F8F8FFF0000
      00FF969696FF505050FF00000000FCFCFC000000000000000000000000000000
      0000717171006060600000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF000606
      0600D1D1D1000000000000000000000000000000000000000000FFFEFF00FFFE
      FF00B8B7B900211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F240065646700FCFCFC000000
      0000000000000000000000000000E0E0E000BFBFC000C4C4C500EDEDEE000000
      00000000000000000000908F9100211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24006B69
      6C00000000000000000000000000000000000000000000000000FFFEFF00FFFE
      FF00B8B7B900211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      000000000000211F2400211F2400211F2400211F2400211F2400211F24000000
      0000000000000000000000000000211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24006B69
      6C0000000000000000000000000000000000FEFEFE000000000000000000A9A9
      A9FF595959FF3B3B3BFF252525FFF4F4F400B1B1B1FFE9E9E9EEFEFEFE00FAFA
      FA0000000000FEFEFE000000000000000000F9F9F9000000000000000000F2F2
      F200A2A2A2FFD2D2D2FFC7C7C7FFA0A0A0FFA6A6A6FFADADADFF9E9E9EFFBBBB
      BBFFD3D3D3FF6D6D6DFF898989FFFBFBFB0000000000FEFEFE00FEFEFE000000
      0000FAFAFA000000000000000000F8F8F800B7B7B7FFEAEAEACC424242FF1515
      15FF7D7D7DFF7D7D7DFF00000000000000000000000000000000000000000000
      0000717171005E5E5E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000F4F4F4000909
      0900CCCCCC000000000000000000000000000000000000000000FFFEFF00FFFE
      FF0086858900211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400DFDFE000000000000000
      000000000000DFDFDF004F4D5100211F2400211F2400211F2400565458000000
      00000000000000000000908F9100211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24005452
      5600000000000000000000000000000000000000000000000000FFFEFF00FFFE
      FF0086858900211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      000000000000211F2400211F2400211F2400211F2400211F2400211F24000000
      0000000000000000000000000000211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24005452
      5600000000000000000000000000000000000000000000000000FDFDFD00E5E5
      E5FF303030FF7F7F7FFF010101FF727272FFC6C6C6FF00000000000000000000
      000000000000FEFEFE00FEFEFE00FEFEFE0000000000FDFDFD0000000000FDFD
      FD00FEFEFE00CBCBCBFF979797FFADADADFFB8B8B8FFB0B0B0FFA2A2A2FFD2D2
      D2FFFCFCFC00FEFEFE00868686FF9C9C9CFF00000000FDFDFD0000000000FDFD
      FD000000000000000000FCFCFC0000000000CCCCCCFF9A9A9AFF080808FF6464
      64FF333333FFD0D0D0FF00000000FEFEFE000000000000000000000000000000
      00006C6C6C006767670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F2F2F2000E0E
      0E00D0D0D0000000000000000000000000000000000000000000FFFEFF00FFFE
      FF0072707400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F24006362650000000000000000000000
      0000EBEAEB0023212600211F2400211F2400211F2400211F2400555357000000
      00000000000000000000908F9100211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24003E3C
      4000000000000000000000000000000000000000000000000000FFFEFF00FFFE
      FF0072707400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      000000000000211F2400211F2400211F2400211F240000000000000000000000
      00000000000000000000211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24003E3C
      400000000000000000000000000000000000FEFEFE0000000000FDFDFD000000
      0000525252FF909090FF090909FF626262FFFDFDFD00FAFAFA0000000000F8F8
      F800000000000000000000000000FEFEFE0000000000FAFAFA00F8F8F8000000
      0000FDFDFD00FCFCFC0000000000F8F8F800F8F8F800FEFEFE00FBFBFB000000
      00000000000000000000000000009A9A9AFFA3A3A3FF00000000FCFCFC000000
      000000000000FAFAFA0000000000FEFEFE00FEFEFE00828282FF070707FFA2A2
      A2FF2B2B2BFF00000000FDFDFD00000000000000000000000000000000000000
      0000717171006464640000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF000A0A
      0A00D8D8D8000000000000000000000000000000000000000000FFFEFF00FFFE
      FF0096959800211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400A8A7A90000000000000000000000
      00007D7C7F00211F2400211F2400211F2400211F2400211F2400555357000000
      00000000000000000000908F9100211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24007573
      7600000000000000000000000000000000000000000000000000FFFEFF00FFFE
      FF0096959800211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24007573
      760000000000000000000000000000000000FBFBFB000000000000000000F8F8
      F800ADADADFF515151FF545454FF080808FFD8D8D8FF939393FFBFBFBFFF0000
      000000000000F8F8F800FCFCFC0000000000FBFBFB000000000000000000FBFB
      FB00FEFEFE0000000000F9F9F9000000000000000000FAFAFA00C8C8C8FF0000
      0000F2F2F2000000000000000000FBFBFB00ABABABFFBCBCBCFFFBFBFB000000
      0000F9F9F90000000000E5E5E5FF848484FFDCDCDCFF1D1D1DFF232323FF7070
      70FF7D7D7DFF00000000FBFBFB00FCFCFC000000000000000000000000000000
      00006D6D6D006060600000000000000000006565650030303000303030009191
      9100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF000101
      0100CECECE000000000000000000000000000000000000000000FFFEFF00FEFD
      FF00CCCBCD0022202500211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400D6D6D7000000000000000000FDFD
      FD004A494D00211F2400211F24007A797C00E3E3E400E3E3E400F1F1F1000000
      00000000000000000000908F9100211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24009E9D
      9F00000000000000000000000000000000000000000000000000FFFEFF00FEFD
      FF00CCCBCD0022202500211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24009E9D
      9F00000000000000000000000000000000000000000000000000FEFEFE000000
      0000F4F4F4002A2A2AFFA2A2A2FF0B0B0BFF313131FFE5E5E5FF000000000000
      0000FDFDFD00FDFDFD0000000000FDFDFD00FEFEFE0000000000FDFDFD00F8F8
      F80000000000C5C5C5FFB1B1B1FFB6B6B6FFB2B2B2FFBBBBBBFFA8A8A8FFE7E7
      E7FF9A9A9AFF00000000FDFDFD000000000000000000BCBCBCFFCECECEFFFAFA
      FA00FDFDFD0000000000FCFCFC00ECECEC88575757FF020202FFA1A1A1FF2929
      29FFE8E8E8FFF8F8F80000000000000000000000000000000000000000000000
      00006D6D6D00606060000000000000000000CACACA00ABABAB00ABABAB00E8E8
      E800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF000101
      0100CECECE00000000000000000000000000000000000000000000000000FFFE
      FF00F8F8F90065646700211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400E0E0E1000000000000000000FBFB
      FB003E3C4000211F2400211F2400888789000000000000000000000000000000
      00000000000000000000908F9100211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F240036343800E3E3
      E40000000000000000000000000000000000000000000000000000000000FFFE
      FF00F8F8F90065646700211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F240036343800E3E3
      E40000000000000000000000000000000000FEFEFE0000000000000000000000
      0000FCFCFC00A7A7A7FF4C4C4CFF616161FF040404FFA3A3A3FF00000000B7B7
      B7FFF9F9F90000000000F9F9F90000000000F9F9F90000000000000000000000
      0000A7A7A7FF7C7C7CFFACACACFFACACACFFAAAAAAFF868686FF323232FF6D6D
      6DFFBCBCBCFFA2A2A2FF00000000000000000000000000000000D4D4D4FFDFDF
      DFFFFBFBFB00C7C7C7FFF6F6F600E4E4E4FF080808FF323232FF747474FF7373
      73FF0000000000000000FBFBFB00F9F9F9000000000000000000000000000000
      00008F8F8F002A2A2A00EFEFEF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD000505
      0500E4E4E4000000000000000000000000000000000000000000000000000000
      000000000000E4E3E5003D3B3F00211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400D5D5D6000000000000000000FCFC
      FC00403E4300211F2400211F2400888789000000000000000000000000000000
      00000000000000000000908F9100211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400C1C1C2000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E4E3E5003D3B3F00211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      000000000000211F2400211F2400211F24000000000000000000000000000000
      000000000000211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400C1C1C2000000
      000000000000000000000000000000000000FDFDFD00FDFDFD00000000000000
      0000FBFBFB00FCFCFC003E3E3EFFA1A1A1FF272727FF1F1F1FFF989898FFA1A1
      A1FFFBFBFB000000000000000000FDFDFD000000000000000000FDFDFD00FBFB
      FB00818181FFD0D0D0FF00000000FAFAFA00949494FF161616FFE1E1E1FFFCFC
      FC00777777FFDBDBDBFFDFDFDFFFFEFEFE000000000000000000FEFEFE00E7E7
      E7FFEBEBEBAABBBBBBFF939393FF2B2B2BFF0B0B0BFFBCBCBCFF131313FFEAEA
      EACC00000000F9F9F900F8F8F800000000000000000000000000000000000000
      0000E8E8E8001717170040404000A3A3A300A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A400A4A4A400909090000C0C0C005F5F
      5F00000000000000000000000000000000000000000000000000000000000000
      000000000000FDFDFE00DCDCDD004241450028262B00211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400B5B4B60000000000000000000000
      0000605F6200211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F24002A282D00B8B7BA00FDFCFD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDFDFE00DCDCDD004241450028262B00211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      000000000000211F2400211F2400211F2400211F2400211F2400000000000000
      00000000000000000000211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F24002A282D00B8B7BA00FDFCFD000000
      000000000000000000000000000000000000FCFCFC0000000000FDFDFD000000
      00000000000000000000C2C2C2FF313131FF969696FF121212FF3A3A3AFFDFDF
      DFFF00000000E1E1E1FFEDEDED6600000000F8F8F80000000000FDFDFD000000
      0000DFDFDFFF585858FFDDDDDDFFE9E9E9EE464646FF747474FFF9F9F900FAFA
      FA00757575FFBBBBBBFF000000000000000000000000FBFBFB00FBFBFB00CFCF
      CFFFF8F8F800000000004B4B4BFF000000FF9F9F9FFF313131FFB6B6B6FF0000
      0000F7F7F70000000000FEFEFE00FCFCFC000000000000000000000000000000
      000000000000CACACA00454545001E1E1E0002020200090909001A1A1A001A1A
      1A0015151500010101001A1A1A001A1A1A001A1A1A001A1A1A001A1A1A001A1A
      1A001A1A1A001A1A1A001A1A1A001A1A1A001A1A1A001A1A1A001A1A1A001A1A
      1A001A1A1A001A1A1A001A1A1A001A1A1A001A1A1A001A1A1A001A1A1A000000
      00000B0B0B001A1A1A001A1A1A001313130001010100262626007A7A7A00FDFD
      FD00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFF00F9F9FA00B2B1B30069676B00514F53003735
      3A00211F2400211F2400211F2400211F24008281840000000000000000000000
      0000A2A1A40024222700211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      24002A282D004F4E52005E5D600091909200F5F5F500FDFDFE00FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFF00F9F9FA00B2B1B30069676B00514F53003735
      3A00211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      000000000000211F2400211F2400211F2400211F2400211F2400211F24000000
      00000000000000000000211F2400211F2400211F2400211F2400211F2400211F
      24002A282D004F4E52005E5D600091909200F5F5F500FDFDFE00FEFEFE000000
      00000000000000000000000000000000000000000000F8F8F800000000000000
      0000FBFBFB00FCFCFC00FDFDFD00939393FF595959FF878787FF0A0A0AFF4545
      45FFD3D3D3FF808080FF00000000FEFEFE00000000000000000000000000FDFD
      FD0000000000E2E2E2FF767676FF6C6C6CFFE5E5E5FF959595FF858585FF6A6A
      6AFFC8C8C8FFA0A0A0FF0000000000000000FCFCFC0000000000FDFDFD009999
      99FFC8C8C8FF525252FF000000FF7E7E7EFF636363FF5E5E5EFFFEFEFE000000
      0000FCFCFC000000000000000000FDFDFD000000000000000000000000000000
      0000000000000000000000000000FDFDFD001B1B1B0094949400FEFEFE00FEFE
      FE006D6D6D0043434300FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00E3E3E3000303
      0300C8C8C800FEFEFE00FEFEFE00343434006C6C6C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFF00FDFDFD00F9F8FA008F8D
      9100211F2400211F2400211F2400211F24003B3A3E00EAEAEA00000000000000
      0000F4F4F4006E6D7000211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      240055545800F8F7F900FCFBFC00FEFEFE00FEFEFE00FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFF00FDFDFD00F9F8FA008F8D
      9100211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      000000000000211F2400211F2400211F2400211F2400211F2400000000000000
      00000000000000000000211F2400211F2400211F2400211F2400211F2400211F
      240055545800F8F7F900FCFBFC00FEFEFE00FEFEFE00FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000696969FF636363FF808080FF0404
      04FF1E1E1EFFCDCDCDFF00000000EFEFEF22B8B8B8FF00000000FCFCFC000000
      000000000000FCFCFC000000000000000000F4F4F400979797FFBABABAFFE8E8
      E8FFA1A1A1FF00000000FEFEFE0000000000D0D0D0FFD0D0D0FFFEFEFE00EBEB
      EBAA343434FF010101FF7A7A7AFF797979FF373737FFFAFAFA00000000000000
      0000FAFAFA00FEFEFE0000000000FDFDFD000000000000000000000000000000
      0000000000000000000000000000000000006B6B6B0025252500D1D1D100FEFE
      FE006D6D6D004444440000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E4E4E4000202
      0200C9C9C900FEFEFE008B8B8B0002020200CCCCCC0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000908F
      9200211F2400211F2400211F2400211F2400211F240091909300000000000000
      000000000000F0EFF0008D8C8E0043414600211F2400211F2400211F24003C3B
      3F007574770097969800211F2400211F2400211F2400211F2400211F2400211F
      240055535700FDFDFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000908F
      9200211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      000000000000211F2400211F2400211F2400211F240000000000000000000000
      00000000000000000000211F2400211F2400211F2400211F2400211F2400211F
      240055535700FDFDFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F8F8F800626262FF6D6D6DFF8C8C
      8CFF121212FF101010FF8C8C8CFF787878FFF0F0F000FCFCFC00D6D6D6FFF2F2
      F200FDFDFD0000000000F9F9F900FCFCFC00FAFAFA00FDFDFD00C0C0C0FF0000
      0000F4F4F400F9F9F900CACACAFF00000000F7F7F700858585FFAAAAAAFF2727
      27FF000000FF878787FF777777FF313131FFEEEEEE44FCFCFC00F6F6F6000000
      0000FDFDFD000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ECECEC003F3F3F00070707002929
      29000F0F0F004444440000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E4E4E4000202
      02002A2A2A0019191900010101008E8E8E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BAB9
      BB00211F2400211F2400211F2400211F2400211F24002B292D00ABAAAC000000
      0000000000000000000000000000F6F6F600ECEBEC00E9E9E900F5F5F5000000
      000000000000BFBFC000211F2400211F2400211F2400211F2400211F2400211F
      24007A797C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BAB9
      BB00211F2400211F2400211F2400211F2400211F2400211F2400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000211F2400211F2400211F2400211F2400211F2400211F2400211F
      24007A797C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F1F1F100686868FF5858
      58FFA8A8A8FF3A3A3AFF101010FF373737FFAAAAAAFFFCFCFC006E6E6EFFF8F8
      F800FEFEFE00A8A8A8FF00000000FCFCFC00CBCBCBFFFEFEFE00000000009F9F
      9FFF00000000FDFDFD00868686FFFAFAFA00CDCDCDFF525252FF010101FF0F0F
      0FFFB1B1B1FF5F5F5FFF474747FFEFEFEF2200000000FCFCFC00000000000000
      0000FBFBFB0000000000FDFDFD00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F5F5F500B7B7B7008A8A
      8A00424242004444440000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E4E4E4000202
      0200616161008F8F8F00E4E4E400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EEED
      EF0037353A00211F2400211F2400211F2400211F2400211F24002D2B30009D9C
      9F00FBFBFB000000000000000000000000000000000000000000000000000000
      000000000000BFBFC000211F2400211F2400211F2400211F2400211F2400211F
      2400D2D1D3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EEED
      EF0037353A00211F2400211F2400211F2400211F2400211F2400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400D2D1D3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00FEFEFE008383
      83FF303030FF888888FF7B7B7BFF111111FF020202FF2F2F2FFF676767FFDFDF
      DFFFFEFEFE00797979FFFDFDFD00FCFCFC00868686FFFCFCFC00000000008B8B
      8BFFF5F5F500F2F2F2006D6D6DFF3C3C3CFF000000FF000000FF777777FFBABA
      BAFF2E2E2EFF707070FF00000000FDFDFD00F7F7F7000000000000000000F9F9
      F90000000000FCFCFC00FCFCFC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006C6C6C004444440000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E4E4E4000202
      0200C8C8C8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FF00A4A3A6002A282C00211F2400211F2400211F2400211F2400211F2400211F
      24004F4D5100B3B3B400E9E9E900F8F8F800FDFDFD000000000000000000FBFB
      FB00E7E6E70086858800211F2400211F2400211F2400211F2400211F24007B79
      7D00FDFDFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FF00A4A3A6002A282C00211F2400211F2400211F2400211F2400000000000000
      0000000000000000000000000000000000000000000000000000211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F24007B79
      7D00FDFDFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FAFAFA000000000000000000F6F6
      F600CBCBCBFF555555FF525252FFAEAEAEFF818181FF181818FF030303FF0404
      04FF222222FF4C4C4CFF767676FF919191FF606060FF8C8C8CFF7D7D7DFF4B4B
      4BFF282828FF000000FF0A0A0AFF101010FF757575FFD1D1D1FF636363FF2222
      22FFB3B3B3FFFEFEFE0000000000FCFCFC000000000000000000F8F8F8000000
      0000000000000000000000000000FDFDFD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006C6C6C004444440000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E4E4E4000202
      0200C8C8C8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD008A898B002C2A2F00211F2400211F2400211F2400211F2400211F
      2400211F2400211F240024222700414044004A484C004B494D00434145002D2B
      3000211F2400211F2400211F2400211F2400211F2400211F24005E5D6000F8F7
      F800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD008A898B002C2A2F00211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400211F2400211F2400211F2400211F2400211F2400211F24005E5D6000F8F7
      F800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00FBFBFB000000
      000000000000F5F5F500949494FF3F3F3FFF464646FF9C9C9CFFAAAAAAFF7878
      78FF393939FF1F1F1FFF0C0C0CFF000000FF000000FF090909FF000000FF0D0D
      0DFF3A3A3AFF6B6B6BFFA9A9A9FFB1B1B1FF606060FF141414FF929292FFF9F9
      F9000000000000000000F4F4F40000000000F8F8F800FAFAFA00000000000000
      0000F7F7F7000000000000000000FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006C6C6C004444440000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E4E4E4000303
      0300C8C8C8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FCFCFC00BDBCBE00525055002A282D00211F2400222025002B29
      2E00211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      24002220250023212600211F240022202500424045009B9A9D00FBFBFC000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FCFCFC00BDBCBE00525055002A282D00211F2400222025002B29
      2E00211F2400211F2400211F2400211F2400211F2400211F2400211F2400211F
      24002220250023212600211F240022202500424045009B9A9D00FBFBFC000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD0000000000FEFE
      FE00F9F9F900F9F9F90000000000F3F3F300B6B6B6FF5D5D5DFF2F2F2FFF4747
      47FF7F7F7FFFA4A4A4FFB1B1B1FFB8B8B8FFB5B5B5FFB2B2B2FFB8B8B8FFB2B2
      B2FF878787FF4D4D4DFF1F1F1FFF4C4C4CFFA1A1A1FF0000000000000000F9F9
      F9000000000000000000FDFDFD00FEFEFE0000000000FBFBFB00000000000000
      00000000000000000000F4F4F400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000777777003A3A3A00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DBDBDB000202
      0200D2D2D2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFF00F8F7F900DFDEE100D3D2D400D7D6D900D3D2
      D4002C2A2F00211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400A9A8AB00DBDADD00D2D1D300D9D9DB00FAF9FB00FDFCFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFF00F8F7F900DFDEE100D3D2D400D7D6D900D3D2
      D4002C2A2F00211F2400211F2400211F2400211F2400211F2400211F2400211F
      2400A9A8AB00DBDADD00D2D1D300D9D9DB00FAF9FB00FDFCFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00000000000000
      0000FDFDFD0000000000FEFEFE00FEFEFE000000000000000000ECECEC88C2C2
      C2FF888888FF5C5C5CFF404040FF2E2E2EFF2E2E2EFF292929FF3A3A3AFF5252
      52FF818181FFB9B9B9FFF1F1F1000000000000000000FAFAFA00000000000000
      000000000000F9F9F90000000000FCFCFC0000000000FEFEFE0000000000FDFD
      FD00FEFEFE000000000000000000FCFCFC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B5B5B500060606007C7C7C00B1B1B100B1B1B100B1B1B100B1B1B100B1B1
      B100B1B1B100B1B1B100B1B1B100B1B1B100B1B1B100B1B1B100B1B1B100B1B1
      B100B1B1B100B1B1B100B1B1B100B1B1B100B1B1B100A7A7A7003D3D3D001E1E
      1E00FDFDFD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFEFF00FFFEFF00FFFEFF00FDFD
      FE0079787B00211F2400211F2400211F2400211F2400211F2400211F2400302E
      3300F6F5F700FFFEFF00FFFEFF00FEFEFF00FFFEFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFEFF00FFFEFF00FFFEFF00FDFD
      FE0079787B00211F2400211F2400211F2400211F2400211F2400211F2400302E
      3300F6F5F700FFFEFF00FFFEFF00FEFEFF00FFFEFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00989898001C1C1C000C0C0C000B0B0B000B0B0B000B0B0B000B0B
      0B000B0B0B000A0A0A000B0B0B000B0B0B000B0B0B000A0A0A000B0B0B000B0B
      0B000B0B0B000A0A0A000B0B0B000B0B0B000B0B0B000B0B0B0042424200DEDE
      DE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFEFF00FFFE
      FF00EBEBED006A686C00211F2400211F2400211F2400211F2400413F4300D9D8
      DA00FEFEFF00FFFEFF00FFFEFF00FFFEFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFEFF00FFFE
      FF00EBEBED006A686C00211F2400211F2400211F2400211F2400413F4300D9D8
      DA00FEFEFF00FFFEFF00FFFEFF00FFFEFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700FAFAFA00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFE
      FF00FFFEFF00FAF9FB00B4B3B500818083007E7D8000A3A2A400EEEEEE00FEFE
      FE00FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFE
      FF00FFFEFF00FAF9FB00B4B3B500818083007E7D8000A3A2A400EEEEEE00FEFE
      FE00FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFEFF0000000000FEFEFE00FEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFEFF0000000000FEFEFE00FEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FCFCFC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFEFFFEFEFEFF00000000000000000000000000000000FEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F5F5F500DFDFDFFFD5D5D5FFD7D7D7FFE9E9E9EEFAFAFA00FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00F8F8F800DCDCDC00D0D0
      D000D3D3D300DBDBDB00F2F2F200000000000000000000000000000000000000
      00000000000000000000FEFEFE00FDFCFC00FEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FEFFFFFFFEFFFEFEFDFFFDFDFCFFFEFEFDFFFFFFFEFF0000000000000000FEFE
      FFFFFEFDFFFFFDFCFEFFFEFEFEFF000000000000000000000000FEFEFEFFFCFC
      FCFFFDFDFDFFFEFEFEFFFEFEFEFF00000000FFFEFFFFFEFDFEFFFDFDFEFFFFFE
      FFFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCDCDCFF9090
      90FF4A4A4AFF12121266313131FF6D6D6DFFB9B9B9FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EEEE
      EE44A8A8A8FF505050FF282828FF2E2E2EFF2B2B2BFF2F2F2FFF737373FFC8C8
      C8FFFBFBFB00FEFEFE00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00FEFEFE000000000000000000000000000000000000000000000000000000
      00000000000000000000BEBEBE008A8A8A004D4D4D0033333300333333003333
      330033333300333333003B3B3B00545454008D8D8D00D5D5D500FBFBFB000000
      000000000000FEFEFE00000000000000000000000000FEFEFE00FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFCFFACADABFF7A7B79FFC8C8C7FF00000000FFFEFFFFFFFEFFFFF0F0
      F2FF929094FF868588FFE7E7E7FF000000000000000000000000DCDCDCFF8080
      80FF9D9D9DFFF9F9F9FFFEFEFEFF00000000FEFDFEFFBFBEC0FF79787AFFBFBE
      C1FFFEFDFFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D9D9DFF0F0F0F000606
      06000606060006060600060606000606060006060600565656FFDDDDDDFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00D8D8D8FF5656
      56FF515151FFB0B0B0FFDCDCDBFFECECEBAAE9E9E7FFCECECDFF909090FF2F30
      30FF8D8D8DFFF1F2F100FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00FDFDFD000000000000000000000000000000000000000000000000000000
      0000A8A8A8004747470033333300333333003333330033333300333333003333
      33003333330033333300333333003333330033333300333333005B5B5B00B6B6
      B600FAFAFA0000000000000000000000000000000000FEFEFE00F9F9F900FBFB
      FB0000000000000000000000000000000000000000000000000000000000FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D9D9D9FF262527FF202022FF49484AFFF4F4F4FF00000000FFFEFFFF9B9A
      9DFF1E1D20FF201F22FF7C7B7CFFFEFEFEFF00000000FBFBFBFF585858FF2121
      21FF202020FFC0C0C0FFFEFEFEFF00000000E4E3E5FF2D2C2EFF212022FF3433
      36FFEDECEEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008F8F8FFF04040400030303005E5E
      5EFFB4B4B4FFD0D0D0FFC6C6C6FF939393FF1C1C1CFF04040400323232FFDFDF
      DFFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DDDDDDFF454545FF8687
      86FFEDEEEACCF6EDDEFFDEC8A7FFD7B183FFD8B88DFFE5D6BDFFFAF6ED66CFD1
      D1FF4B4B49FF858686FFF8F8F800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FDFD
      FD00000000000000000000000000000000000000000000000000D7D7D7005353
      530033333300333333003333330033333300353535006F6F6F00858585009595
      95009595950080808000616161003F3F3F003333330033333300333333003333
      330066666600E5E5E50000000000000000000000000000000000FAFAFA00FAFA
      FA00FBFBFB000000000000000000000000000000000000000000FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D8D8D9FF29282AFF212023FF444345FFF6F6F6FFFFFFFEFFFEFEFEFF9A9A
      9BFF1F1F20FF202022FF7E7E7FFFFEFDFEFFFFFEFFFFFDFDFDFF5D5D5DFF2222
      22FF222222FFC3C3C3FFFEFEFEFFFFFEFFFFE1E1E3FF373638FF212121FF3433
      35FFF1F0F1FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C2C2C2FF01010100040404009E9E9EFF0000
      000000000000000000000000000000000000DBDBDBFF454545FF030303005959
      59FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F7F7F7006D6D6DFF7A7A7AFFF4F4
      F000E2CCAFFFBF7B2FFFBE7102FFC07301FFC07202FFBB700AFFC6935EFFF4EA
      DAFFD8D6D6FF383737FFB8B8B8FFFEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0B0B000333333003333
      3300333333003333330075757500C3C3C300FEFEFE0000000000000000000000
      000000000000FEFEFE00FEFEFE00F4F4F400C1C1C1005F5F5F00373737003333
      33003333330044444400BDBDBD00000000000000000000000000FEFEFE00FCFC
      FC00FBFBFB00FBFBFB00FEFEFE0000000000FEFEFE00FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FBFBFCFF6B6A6DFF222123FFA1A1A1FFFEFEFEFFFFFFFDFFFFFFFDFFEBEB
      EBFF434344FF2D2C2DFFDFDEE1FFFEFDFFFFFEFEFFFF00000000B9B9B9FF2929
      29FF505050FFF8F8F8FF00000000FFFEFFFFFCFBFCFF858586FF212121FF9594
      96FFFFFEFFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000565656FF01010100828282FF000000000000
      00000000000000000000000000000000000000000000D7D7D7FF0D0D0D000000
      0000C7C7C7FF000000000000000000000000000000000000000000000000D4D4
      D4FFABABABFF6A6A6AFF444444FF464646FF747474FFB8B8B8FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CACACAFF323130FFDEDEDDFFE9D6
      C1FFBB7519FFBF7201FFBC7201FFBD7301FFC07301FFBF7202FFBE7101FFC48E
      52FFFAF3E8FFA3A3A3FF555555FFF3F3F300FEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FDFDFD00ADADAD0033333300333333003333
      33005B5B5B00DFDFDF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFE00FDFCFC00FDFDFD00CBCBCB005959
      590033333300333333003E3E3E00B6B6B6000000000000000000000000000000
      0000FCFCFC00F9F9F900F9F9F900FDFDFD00FEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FEFFFEFEFFFFDFDEE0FF727174FFF9F9F9FFFFFFFEFFFFFFFDFFFFFFFEFF0000
      0000A9A9A9FF9D9D9DFFFEFDFFFFFEFDFFFFFFFEFFFF00000000F6F6F6FF8181
      81FFD2D2D2FFFEFEFEFFFEFDFEFFFEFDFFFFFEFDFFFFE2E2E3FF6B6B6BFFEFEF
      EFFFFEFEFEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DADADAFF020202000E0E0E00E0E0E0FF000000000000
      0000000000000000000000000000000000000000000000000000838383FF0101
      0100878787FF0000000000000000000000000000000000000000BCBCBCFF2323
      23FF0101010000000000030303000202020000000000000000003D3D3DFFD0D0
      D0FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFE008D8D8DFF7C7B7AFFFCF8ED66C68E
      54FFBD7102FFBD7102FFBC7201FFBD7300FFBF7301FFBF7302FFBF7202FFBB71
      03FFDEC6A9FFE0DFDEFF2B2B2BFFD4D4D4FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BABABA003434340033333300333333009A9A
      9A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FBFAFA00FAFAFA000000000000000000F2F2
      F2008282820033333300333333003F3F3F00C1C1C10000000000000000000000
      000000000000FDFDFD00FCFCFC00FBFBFB00FCFCFC0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFDFFEBEBECFFF4F3
      F4FFFEFEFEFFFEFDFEFFFEFEFEFFFEFEFEFFFCFCFBFFE8E8E8FFF9F9F9FFFEFE
      FEFFFAFAFAFFFFFEFFFFFEFEFFFFF4F3F5FFEAE9EBFFFDFDFDFFFEFEFEFFFAFA
      FAFFFEFEFEFFFDFDFDFFEFEEEFFFF1F1F3FFFEFDFFFFFEFDFEFFFEFEFEFF0000
      0000FBFAFCFFE7E7E8FFF6F5F7FFFDFDFEFFFEFEFFFFFEFEFEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BFBFBFFF02020200414141FF00000000000000000000
      0000000000000000000000000000000000000000000000000000BBBBBBFF0000
      00004E4E4EFF00000000000000000000000000000000B5B5B5FF040404000606
      0600353535FF9E9E9EFFC5C5C5FFC2C2C2FF919191FF212121FF010101001717
      17FFCECECEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FAFAFA00636363FFA7A7A7FFF4EADBFFB974
      12FFBD7201FFBD7101FFBC7201FFBD7300FFBE7302FFBE7302FFC07301FFBE72
      01FFCEA069FFF7F5F1004F4F4FFFBBBBBBFFFEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DEDEDE00343434003333330034343400AEAEAE000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFE00FEFEFE000000000000000000000000000000
      0000F8F8F80086868600333333003333330044444400E7E7E700000000000000
      000000000000FEFEFE00FEFEFE00FCFCFC00FAFAFA00FCFCFC00FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCFBFCFF8B8A8DFF333235FF4746
      48FFD9D9DAFFFEFEFEFFFEFEFEFFEEEEEEFF575757FF303031FF6A6A6BFFF6F6
      F6FF0000000000000000CFCED0FF414143FF343335FF9D9D9DFFFDFDFDFFFEFE
      FEFFFEFEFEFF949494FF333233FF3F3E40FFC9C9CBFFFEFEFEFFFEFEFEFFF6F6
      F7FF6B6A6CFF302F32FF5A595DFFE9E8EAFFFEFEFEFFFEFEFEFFFEFEFEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000AFAFAFFF020202005C5C5CFF00000000000000000000
      0000000000000000000000000000000000000000000000000000C3C3C3FF0202
      02003D3D3DFF000000000000000000000000DDDDDDFF1E1E1EFF050505007E7E
      7EFF0000000000000000000000000000000000000000E6E6E6FF5B5B5BFF0000
      00003C3C3CFF9D9D9DFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F9F9F900595959FFB1B1B2FFF1E5D6FFBC71
      0BFFBD7201FFBD7201FFBC7201FFBC7302FFBC7302FFBD7301FFC07301FFC172
      03FFCA9459FFF9F7F300575757FFB8B8B8FFFEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FEFEFE005656560033333300333333008D8D8D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDFDFD0000000000000000000000000000000000000000000000
      000000000000FCFCFC007575750033333300333333007E7E7E00000000000000
      0000FEFEFE00000000000000000000000000FBFBFB00FAFAFA00FCFCFC00FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E4E4E5FF2D2C2EFF222123FF2322
      23FF868686FFFEFEFEFFFEFEFEFFADADADFF212121FF212022FF232224FFCCCC
      CCFFFEFEFEFFFDFDFDFF6D6C6EFF212022FF212022FF393939FFF1F1F1FFFEFE
      FEFFF2F2F2FF3A3A3AFF212122FF212022FF747376FFFDFCFDFFFEFEFEFFC5C4
      C6FF222123FF212022FF1F1D21FFB1B0B2FFFEFEFEFFFEFEFEFFFEFEFEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B0B0B0FF020202005F5F5FFF00000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0FF0101
      0100717171FF000000000000000000000000818181FF060606005B5B5BFF0000
      0000000000000000000000000000000000000000000000000000E2E2E2FF3636
      36FF04040400A6A6A6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FBFBFB00707070FF9B9C9DFFF5EFE4FFBB76
      22FFBE7200FFBD7101FFBC7201FFBC7302FFBD7302FFBD7301FFBD7301FFC172
      03FFD0AA7CFFF1F0ED66434343FFC3C3C3FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B6B6B60033333300333333005252520000000000000000000000
      0000BCBCBC00797979007E7E7E00C4C4C400000000000000000000000000FEFE
      FE00A2A2A200616161005757570081818100E5E5E50000000000000000000000
      00000000000000000000F2F2F200454545003333330049494900E4E4E400FEFE
      FE000000000000000000000000000000000000000000FEFEFE00FBFBFB00FCFC
      FC00FEFEFE000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0EFF0FF424243FF222122FF2020
      21FFA7A7A8FFFEFDFFFFFEFEFFFFC6C5C6FF272628FF202022FF2B2B2CFFE3E3
      E3FF00000000FEFEFEFF8B8A8DFF202022FF202021FF505050FFFAFAFAFFFEFE
      FEFFF7F7F7FF505050FF1F1F20FF212023FF959496FFFEFEFFFF00000000D9D9
      DAFF2D2C2EFF201F22FF262528FFD1D1D1FFFEFEFDFFFEFEFDFFFEFEFEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DFDFDFFF414141FFA1A1A1FF00000000000000000000
      0000000000000000000000000000000000000000000000000000393939FF0101
      0100ADADADFF000000000000000000000000171717FF05050500C3C3C3FF0000
      000000000000000000000000000000000000000000000000000000000000A6A6
      A6FF05050500545454FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFE00A4A4A4FF606261FFF6F5F000CDA5
      78FFBE7102FFBE7103FFBD7102FFBE7202FFBF7302FFBF7301FFBF7300FFBD71
      0FFFEBD8C3FFD2D1D1FF2A2A2AFFE1E1E1FFFEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000515151003333330033333300D4D4D40000000000000000000000
      0000EBEBEB00434343003333330050505000F1F1F10000000000000000008181
      81003333330033333300333333003333330043434300E8E8E800000000000000
      0000000000000000000000000000CDCDCD00E3E3E300D8D8D800B7B7B700AEAE
      AE00BBBBBB00DCDCDC00F7F7F700000000000000000000000000FDFDFD00FAFA
      FA00FEFEFE000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFDFFA4A4A4FF222222FF4544
      46FFF2F2F3FFFEFDFFFFFFFEFFFFF6F5F7FF666567FF212022FF79797AFFFDFD
      FDFF0000000000000000DDDCDEFF39383BFF272628FFB8B8B8FFFEFEFEFFFEFE
      FEFFFEFEFEFFB3B3B3FF232223FF383739FFE9E8EAFFFEFEFFFF00000000FCFC
      FCFF7C7C7DFF222123FF68686AFFFDFDFDFFFFFFFEFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000858585FF020202002424
      24FFC4C4C4FF0000000000000000DDDDDDFF0303030003030300E2E2E2FF0000
      000000000000000000000000000000000000000000000000000000000000CFCF
      CFFF01010100171717FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DDDDDDFF2F2F2FFFC6C6C6FFF3EB
      D9FFC08441FFBD7001FFBD7102FFBE7202FFC07302FFBE7301FFBB7205FFD1B0
      8AFFF7F5F0007E7D7DFF787878FFFBFBFB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FE00D6D6D6003333330033333300676767000000000000000000000000000000
      000000000000A8A8A80033333300333333008F8F8F0000000000F1F1F1003333
      3300333333006C6C6C00C5C5C5003D3D3D00333333008F8F8F00000000000000
      00000000000000000000FEFEFE00A5A5A5004949490033333300333333003333
      3300333333003434340058585800A7A7A700F8F8F80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EEEEEEFF616161FFBDBD
      BDFFFEFDFEFFFFFEFFFFFFFEFFFFFEFDFFFFD4D3D6FF4F4E51FFE8E8E9FFFEFE
      FEFFFEFEFEFFFEFEFEFFFDFCFFFFA1A0A2FF6C6C6DFFF9F9F9FFFEFEFEFFFEFE
      FEFFFEFEFEFFF7F7F7FF767676FFABAAACFFFEFDFFFFFFFEFFFFFEFEFEFFFEFE
      FEFFE1E1E2FF4E4D50FFDDDCDEFFFEFEFEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CFCFCFFF666666FF0202020006060600B1B1
      B1FF000000000000000000000000DADADAFF05050500000000005F5F5FFF0000
      000000000000000000000000000000000000000000000000000000000000D3D3
      D3FF040404001212126600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFD009A9A9AFF4A4A4BFFDFDF
      DEFFF4EBD9FFCBA070FFBD7308FFBF7302FFC07302FFBE7A2CFFDEC1A2FFF9F7
      F100ADADAFFF333333FFD7D7D7FFFEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008E8E8E003333330033333300B4B4B4000000000000000000000000000000
      000000000000FBFBFB006D6D6D00333333003D3D3D00CACAC900D4D4D4003333
      330033333300BBBBBB000000000063636300333333006C6C6C00000000000000
      000000000000E9E9E9005F5F5F00333333004B4B4B0096969600C3C3C300CFCF
      CF00C0C0C00090909000555555003333330063636300E8E8E800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFEFFFEFEFEFFEEEEEEFFFDFD
      FDFF00000000FEFEFFFFFEFEFFFFFEFEFFFFFDFCFEFFF2F1F3FFFEFDFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFDFFFFF7F6F8FFF5F5F6FFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFDFFFFFEFDFEFFEDECEEFFFBFBFCFFFEFEFFFFFEFEFEFFFEFDFFFFFEFD
      FFFFFEFDFFFFF1F1F2FFFCFCFCFF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B4B4B4FF494949FF4646
      46FF454545FF454545FF454545FF454545FF454545FF454545FF454545FF4545
      45FF454545FF454545FF454545FF454545FF454545FF454545FF454545FF4545
      45FF454545FF464646FF2B2B2BFF010101000000000009090900A6A6A6FF0000
      0000000000000000000000000000DADADAFF03030300000000005F5F5FFF0000
      000000000000000000000000000000000000000000000000000000000000BFBF
      BFFF00000000303030FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F3F3F3007C7C7CFF4C4B
      4BFFCBCBCCFFFCF8EACCC48A4AFFBE7302FFBE7204FFE0C19FFFF4F4F2009B9B
      9BFF2E2E2DFFBABABAFFFDFDFD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005B5B5B003333330039393900F7F7F7000000000000000000000000000000
      00000000000000000000DBDBDB003E3E3E003333330054545400DADADA003434
      3400333333009F9F9F00FEFEFE00474747003333330074747400000000000000
      0000F0F0F0004C4C4C0034343400A7A7A70000000000FEFEFE00D4D4D4009C9C
      9C00828282007A7A7A007F7F7F0053535300333333004E4E4E00EDEDED000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFEFFFDFDFEFFFDFDFDFFFEFE
      FEFFFEFEFEFFFDFDFDFFFDFDFDFFFDFDFEFFFDFCFEFFFDFCFEFFFDFCFEFFFDFD
      FDFFFDFDFDFFFDFDFEFFFDFCFEFFFDFCFEFFFDFCFEFFFDFDFDFFFDFDFDFFFDFD
      FEFFFDFCFEFFFDFCFEFFFDFCFEFFFDFDFDFFFDFDFDFFFDFDFEFFFDFCFEFFFDFC
      FEFFFEFDFEFFFEFEFEFFFAFAFAFF000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7FFF060606000404
      0400040404000404040004040400040404000404040004040400040404000404
      040003039FFF0000FFFF0000FFFF0000FFFF040433FF04040400040404000404
      040006060600040404000A0A0A00171717FF696969FFAAAAE0FF0000FFFF0000
      FFFF0000FFFF0000000000000000838383FF505050FF6363AAFF3131FFFF0000
      FFFF0000FFFF6666FFFF00000000000000000000000000000000000000006D6D
      6DFF00000000838383FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F4F4F4008080
      80FF6E6E6FFFFAF7F200C68E54FFBF7302FFBD7303FFE1C7A8FFD9DAD9FF2222
      22FFBFBFBEFFFCFCFC00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE003C3C3C00333333004D4D4D00000000000000000000000000000000000000
      00000000000000000000FEFEFE009B9B9B003333330033333300979797006767
      6700333333003A3A3A00393939003333330033333300B1B1B100000000000000
      00005C5C5C0033333300BFBFBF0000000000DFDFDF006E6E6E00333333003333
      330033333300333333003333330033333300333333003333330075757500FBFB
      FB00FEFEFE000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFCFEFFE3E2E5FFC0BFC2FFBDBC
      BEFFBCBBBEFFBBBABDFFBBBABDFFBBBABDFFBBBABEFFBBBABEFFBBBABEFFBBBA
      BDFFBBBABDFFBBBABDFFBBBABEFFBBBABEFFBBBABEFFBBBABDFFBBBABDFFBBBA
      BEFFBBBABEFFBBBABEFFBBBABEFFBBBABDFFBBBABDFFBBBABEFFBBBABEFFBBBA
      BEFFBCBBBDFFBEBEBFFFD2D2D3FFF0F0F0FF0000000000000000000000000000
      000000000000000000000000000000000000000000005F5F5FFFC6C6C6FFC4C4
      C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4
      C4FFA2A2DBFF0000FFFF0000FFFF0000FFFFC1C1C6FFC4C4C4FFC4C4C4FFC4C4
      C4FFC5C5C5FFC9C9C9FFD8D8D8FFC4C4C4FF00000000D4D4FFFF0000FFFF0000
      FFFF0000FFFF000000000000000000000000D7D7FCFF2E2EFFFF0000FFFF0000
      FFFF6969FFFF0000000000000000000000000000000000000000B5B5B5FF0000
      000005050500CECECEFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6EFFFAF7F000C68D53FFBF7302FFBD7303FFE1C7A8FFD8DAD9FF2828
      28FFE6E6E6FFFEFEFE00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F1F1
      F100333333003333330074747400000000000000000000000000000000000000
      000000000000FCFCFC00FAFAFA00F5F5F50061616100333333003C3C3C00C5C5
      C50061616100363636003333330033333300898989000000000000000000B9B9
      B900333333008585850000000000C9C9C9003434340033333300333333003333
      330033333300333333003333330033333300333333003333330033333300C2C2
      C200FEFEFE000000000000000000000000000000000000000000000000000000
      0000FEFEFEFFFFFEFFFFFDFCFDFFC3C2C4FF535256FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF222025FF57565AFFABABADFFF2F1F2FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D2D2FEFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      00000000000000000000000000000000000000000000D0D0FCFF0000FFFF0000
      FFFF0000FFFF0000000000000000D6D6FEFF2A2AFFFF0000FFFF0000FFFF6C6C
      FFFF00000000000000000000000000000000E1E1E1FF9D9D9DFF050505000404
      0400848484FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6EFFFAF7F100C68D53FFBF7302FFBD7303FFE1C7A8FFD8DAD9FF2424
      24FFB7B7B7FFCACACAFFCBCBCBFFF1F1F1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E4E4
      E40033333300333333008383830000000000000000000000000000000000CDCD
      CD0056565600343434004747470089898900C3C3C3003A3A3A00333333006C6C
      6C00F5F5F500DEDEDE00D5D5D500F4F4F4000000000000000000000000006161
      61003A3A3A00F4F4F400D9D9D900333333003333330033333300333333003333
      3300333333003333330033333300333333003333330033333300333333007373
      7300000000000000000000000000000000000000000000000000000000000000
      0000FEFEFEFFFCFCFDFF88878BFF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF6C6A6EFF747376FF747376FF646366FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF626165FFEDECEDFF0000
      00000000000000000000000000000000000000000000B7B7B7FF4A4A4AFF4242
      42FF414141FF414141FF414141FF414141FF414141FF414141FF414141FF4141
      41FF3434A6FF0000FFFF0000FFFF0000FFFF404051FF414141FF414141FF4141
      41FF444444FF535353FF5E5E5EFF575757FF565656FF2B2BA4FF0000FFFF0000
      FFFF0000FFFF444454FF3737A3FF0404FDFF0000FFFF0000FFFF1313EDFF4444
      6CFF4D4D4DFF505050FF393939FF373737FF0E0E0E0000000000020202007D7D
      7DFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6EFFFAF7F100C68D53FFBF7302FFBD7303FFE1C7A8FFD8DAD9FF1D1D
      1DFF353535FF383838FF3A3A3AFFC5C5C5FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E4E4
      E400333333003333330082828200000000000000000000000000E2E2E2003333
      3300333333003333330033333300333333007D7D7D0091919100333333003333
      3300A1A1A100FEFEFE0000000000000000000000000000000000F1F1F1003737
      37006F6F6F00FDFDFD0055555500333333003333330033333300333333003333
      3300333333003333330033333300333333003333330033333300333333003F3F
      3F00F9F9F9000000000000000000000000000000000000000000000000000000
      0000FEFEFEFFADADAFFF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF7F7D81FFFEFE
      FEFF00000000000000000000000000000000000000007B7B7BFF040404000202
      0200000000000000000000000000000000000000000000000000000000000000
      000000009FFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FDFF0000
      F4FF0000D7FF010187FF00000000000000000000000000009FFF0000FFFF0000
      FFFF0000FFFF0101A6FF0000FDFF0000FFFF0000FFFF0000EBFF000053FF0000
      00000000000001010100000000000000000004040400373737FFB9B9B9FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6EFFFAF7F200C58D55FFBE7302FFBC7302FFE0C7A8FFD8DADAFF2727
      27FFDADADAFFEFEFEF22F1F1F100FCFCFC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F2F2
      F20034343400333333006C6C6C000000000000000000000000008B8B8B003333
      33003A3A3A00D0D0D000969696003333330036363600D6D6D600525252003333
      330040404000DDDDDD00FEFEFE000000000000000000FEFEFE00E4E4E4003333
      330094949400C1C1C10033333300333333003333330033333300333333003333
      3300333333003333330033333300333333003333330033333300333333003333
      3300E6E6E600000000000000000000000000000000000000000000000000FFFE
      FFFFF9F8F9FF37353AFF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FFB9B9
      BAFF0000000000000000000000000000000000000000D4D4D4FFC2C2C2FFC1C1
      C1FFC1C1C1FFC1C1C1FFC1C1C1FFC1C1C1FFC1C1C1FFC1C1C1FFC1C1C1FFC1C1
      C1FFA0A0D9FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0707FFFF9292D9FFB9B9B9FFBDBDBDFFA0A0DAFF0000FFFF0000
      FFFF0000FFFF0707FFFF0000FFFF0000FFFF5656F5FFBABAC7FFBABABAFFC0C0
      C0FFC2C2C2FFBABABAFFBBBBBBFFC4C4C4FFD8D8D8FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFAFAF900D3AE88FFBA7105FFB77521FFEDDFCBFFDAD8DAFF2929
      29FFE7E7E7FFFEFEFE00FEFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE004B4B4B00333333004D4D4D00FEFEFE000000000000000000757575003333
      33004C4C4C0000000000D2D2D2003333330033333300C9C9C900BEBEBE003737
      37003333330073737300FEFEFE00000000000000000000000000D9D9D9003333
      3300939393008484840033333300333333003333330033333300333333003333
      3300333333003333330033333300333333003333330033333300333333003333
      3300E0E0E0000000000000000000000000000000000000000000FFFEFFFFFFFE
      FFFFB8B7B9FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF6B69
      6CFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CFCFFCFF0000FFFF0000FFFF0000FFFF0000000000000000B2B2BEFF8484
      FEFF0000FFFF0000FFFF3333FFFF0000000000000000D0D0FCFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF6F6FFEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFBFBFB00FCF8F000EAD6BEFFF0E3CFFFFEFDFB00D9D9DAFF2121
      21FF8E8E8EFFA1A1A1FFEFEFEF22000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006E6E6E003333330033333300E3E3E3000000000000000000929292003333
      330038383800DFDFDF00A0A0A0003333330033333300E1E1E100000000008686
      86003333330033333300B2B2B200000000000000000000000000E4E4E4003333
      3300828282005A5A5A0033333300333333003333330033333300333333003333
      3300333333003333330033333300323232003333330033333300333333003535
      3500F6F6F6000000000000000000000000000000000000000000FFFEFFFFFFFE
      FFFF868589FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF5452
      56FF0000000000000000000000000000000000000000B1B1B1FF383838FF3030
      30FF303030FF303030FF303030FF303030FF303030FF303030FF303030FF3030
      30FF2626A3FF0000FFFF0000FFFF0000FFFF2F2F45FF303030FF303030FF2A2A
      82FF0000FFFF0000FFFF0000FFFF1616A0FF1E1E1EFF1717A0FF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0303FAFF1E1E8BFF292929FF272727FF2828
      28FF313131FF434343FF2D2D2DFF4D4D4DFF787878FFB2B2B2FF5F5F5FFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFBFBFB0000000000000000000000000000000000DADADAFF1F1F
      1FFF707070FF828282FFEAEAEACC000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A2A2A20033333300333333009F9F9F000000000000000000DCDCDC004040
      4000333333003333330033333300333333004E4E4E000000000000000000F1F1
      F100464646003333330045454500EEEEEE0000000000FEFEFE00FEFEFE004F4F
      4F004E4E4E004D4D4D0033333300333333003333330033333300333333003333
      3300333333003333330033333300333333003333330033333300333333004D4D
      4D00000000000000000000000000000000000000000000000000FFFEFFFFFFFE
      FFFF727074FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF3E3C
      40FF0000000000000000000000000000000000000000818181FF040404000404
      0400040404000404040004040400040404000404040004040400040404000404
      040003039FFF0000FFFF0000FFFF0000FFFF040433FF04040400040404000404
      47FF0000FFFF0000FFFF0000FFFF0000AFFF0101010001019FFF0000FFFF0000
      FFFF0000FFFF0000DCFF0000FFFF0000FFFF0000FBFF00008EFF000000000707
      0700040404000000000000000000000000000000000005050500383838FFCDCD
      CDFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFBFBFB0000000000000000000000000000000000DADADAFF2828
      28FFE6E6E6FFFDFDFD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E4E4E400373737003333330053535300F3F3F3000000000000000000C6C6
      C60056565600393939003434340069696900E8E8E80000000000000000000000
      0000B3B3B3004B4B4B004B4B4B009B9B9B000000000000000000000000009393
      9300333333003434340033333300333333003333330033333300333333003333
      3300333333003333330033333300333333003333330033333300333333009E9E
      9E00000000000000000000000000000000000000000000000000FFFEFFFFFFFE
      FFFF969598FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF7573
      76FF000000000000000000000000000000000000000000000000C9C9C9FFC8C8
      C8FFC8C8C8FFC8C8C8FFC8C8C8FFC8C8C8FFC8C8C8FFC8C8C8FFC8C8C8FFC8C8
      C8FFA5A5DDFF0000FFFF0000FFFF0000FFFFC5C5CAFFC8C8C8FFC8C8C8FFB5B5
      D4FF0000FFFF0000FFFF0000FFFFA5A5DDFFC6C6C6FFA5A5DDFF0000FFFF0000
      FFFF0000FFFFC3C3CAFF7979EFFF0000FFFF0000FFFF2525FEFFACACDAFFC8C8
      C8FFC8C8C8FFC6C6C6FFC7C7C7FFC0C0C0FF919191FF292929FF010101001515
      15CCCECECEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFBFBFB0000000000000000000000000000000000DADADAFF2727
      27FFE4E4E4FFFBFBFB00FBFBFB00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD00737373003333330033333300A6A6A60000000000000000000000
      0000F9F9F900F0F0F000F9F9F90000000000000000000000000000000000FEFE
      FE00FEFEFE00000000000000000000000000000000000000000000000000E9E9
      E900CBCBCB00CDCDCD00AFAFAF00626262003434340033333300333333003333
      33003333330033333300333333003333330033333300333333003F3F3F00F5F5
      F500000000000000000000000000000000000000000000000000FFFEFFFFFEFD
      FFFFCCCBCDFF222025FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF9E9D
      9FFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D2D2FEFF0000FFFF0000FFFF0000FFFF000000000000000083838CFF8686
      FFFF0000FFFF0000FFFF3535FFFF0000000000000000D4D4FFFF0000FFFF0000
      FFFF0000FFFF0000000000000000A0A0FFFF0000FFFF0000FFFF2A2AFFFFD9D9
      FFFF0000000000000000000000000000000000000000DFDFDFFF575757FF0101
      0100414141FF5F5F5FFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFBFBFB0000000000000000000000000000000000DADADAFF1D1D
      1DFF4F4F4FFF565656FF575757FFCACACAFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE0000000000D3D3D300343434003333330042424200E1E1E100000000000000
      0000000000000000000000000000000000000000000000000000FEFEFE000000
      0000000000000000000000000000000000000000000000000000DADADA008787
      8700585858005151510075757500CDCDCD00C2C2C20042424200333333003333
      3300333333003333330033333300333333003333330033333300B9B9B9000000
      0000FEFEFE00000000000000000000000000000000000000000000000000FFFE
      FFFFF8F8F9FF656467FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF363438FFE3E3
      E4FF0000000000000000000000000000000000000000B5B5B5FF323232FF2C2C
      2CFF2C2C2CFF2C2C2CFF2C2C2CFF2C2C2CFF2C2C2CFF2C2C2CFF2C2C2CFF2C2C
      2CFF2323A2FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF3838B1FF868686FFC7C7C7FFCFCFFCFF0000FFFF0000
      FFFF0000FFFF0000000000000000000000007676E8FF0000FFFF0000FFFF2626
      FFFFD6D6FFFF00000000000000000000000000000000000000009D9D9DFF3333
      33FF00000000A7A7A7FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFBFBFB0000000000000000000000000000000000DADADAFF2222
      22FFA8A8A8FFB9B9B9FFBABABAFFE9E9E9EE0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFCFC00FEFEFE000000
      000000000000000000008787870033333300333333005B5B5B00F1F1F1000000
      000000000000000000000000000000000000FDFDFD00FDFDFD00000000000000
      00000000000000000000000000000000000000000000B4B4B40042424200A5A5
      A500E5E5E500BABABA00878787004242420092919100CBCBCB003B3B3B003333
      330033333300333333003333330033333300333333006D6D6D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E4E3E5FF3D3B3FFF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FFC1C1C2FF0000
      000000000000000000000000000000000000000000007D7D7DFF020202000202
      0200020202000202020002020200020202000202020002020200020202000202
      020001019FFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FDFF0000
      F3FF0101D6FF020284FF0505050006060600050505005757B1FF0000FFFF0000
      FFFF0000FFFF0000000000000000DDDDDDFF060611440E0ECCFF0000FFFF0000
      FFFF2222FFFFD4D4FFFF0000000000000000000000000000000000000000A5A5
      A5FF00000000535353FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFBFBFB0000000000000000000000000000000000DADADAFF2727
      27FFE7E7E7FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00F9F9F800000000000000
      00000000000000000000F2F2F20054545400333333003333330068686800F2F2
      F20000000000000000000000000000000000F9F9F900FEFEFE00000000000000
      000000000000000000000000000000000000D1D1D10046464600EFEFEF009F9F
      9F003535350033333300333333003434340033333300B0B0B000929292003333
      3300333333003333330033333300333333003F3F3F00F0F0F000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDFDFEFFDCDCDDFF424145FF28262BFF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF2A282DFFB8B7BAFFFDFCFDFF0000
      00000000000000000000000000000000000000000000C4C4C4FFC5C5C5FFC4C4
      C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4
      C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFC4C4
      C4FFC4C4C4FFC4C4C4FFB6B6B6FF7A7A7AFF0D0D0D0006060600404040FFE6E6
      E6FF000000000000000000000000DADADAFF08080800000000005F5F5FFF0000
      000000000000000000000000000000000000000000000000000000000000CECE
      CEFF02020200181818FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFBFBFB0000000000000000000000000000000000DADADAFF2525
      25FFCBCBCBFFE3E3E3FFFCFCFC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FEFEFE000000
      0000000000000000000000000000DEDEDE004444440033333300333333005B5B
      5B00DEDEDE000000000000000000FEFEFE0000000000FEFEFE00000000000000
      0000000000000000000000000000000000006A6A6A00B3B3B300898989003333
      330033333300333333003333330033333300333333004F4F4F00D7D7D7003333
      330033333300333333003333330033333300BDBDBD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFFFFF9F9FAFFB2B1B3FF69676BFF514F53FF3735
      3AFF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF2A282DFF4F4E52FF5E5D60FF919092FFF5F5F5FFFDFDFEFFFEFEFEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CCCCCCFF313131FF000000006767
      67FF000000000000000000000000DBDBDBFF0505050003030300838383FF0000
      000000000000000000000000000000000000000000000000000000000000D3D3
      D3FF030303001010102200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFBFBFB0000000000000000000000000000000000DADADAFF1C1C
      1CFF222222FF2F2F2FFFDFDFDFFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE0000000000000000000000000000000000D5D5D50046464600333333003333
      33003D3D3D0098989800ECECEC00000000000000000000000000FEFEFE000000
      0000000000000000000000000000FCFCFC003D3D3D00D6D6D600333333003333
      3300333333003333330033333300333333003333330033333300DFDFDF003F3F
      3F00333333003333330033333300696969000000000000000000000000000000
      0000FEFEFE000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFFFFFDFDFDFFF9F8FAFF8F8D
      91FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FFE0E0E1FF0000000000000000E9E9E9FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF555458FFF8F7F9FFFCFBFCFFFEFEFEFFFEFEFEFFFEFEFEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BEBEBEFFE0E0E0FF00000000000000000000
      00000000000000000000000000000000000000000000CECECEFF030303000000
      0000CCCCCCFF0000000000000000E8E8E8FF0000000003030300D9D9D9FF0000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0FF000000002D2D2DFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFAFAFA0000000000000000000000000000000000DADADAFF2626
      26FFD0D0D0FFE6E6E6FFFDFDFD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE0000000000000000000000000000000000DEDEDE00676767003333
      33003333330033333300404040007C7C7C00C1C1C100E9E9E900FEFEFE00FEFE
      FE00FEFEFE0000000000EDEDED00F6F6F600383838008A8A8A00333333003333
      3300333333003333330033333300333333003333330033333300DDDDDD004747
      470033333300333333003E3E3E00E6E6E600000000000000000000000000FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000908F
      92FF211F24FF211F24FF211F24FF211F24FF211F24FF343237FF5D5B5FFF5D5B
      5FFF5D5B5FFF5D5B5FFFE9E8E9FF0000000000000000F0EFF0FF5D5B5FFF5D5B
      5FFF5D5B5FFF5D5B5FFF434145FF211F24FF211F24FF211F24FF211F24FF211F
      24FF555357FFFDFDFEFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BABABAFF02020200686868FF00000000000000000000
      0000000000000000000000000000000000000000000000000000787878FF0101
      01008D8D8DFF000000000000000000000000515151FF02020200969696FF0000
      0000000000000000000000000000000000000000000000000000000000007070
      70FF00000000838383FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFAFAFA00FEFEFE00000000000000000000000000DADADAFF2828
      28FFE7E7E7FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FEFEFE00FEFEFE00000000000000000000000000F2F2F2008E8E
      8E003F3F3F003333330033333300333333003333330037373700424242004C4C
      4C004C4C4C003A3A3A0033333300D5D5D5005151510058585800333333003333
      3300333333003333330033333300333333003333330037373700EDEDED003838
      380033333300333333009D9D9D00000000000000000000000000FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BAB9
      BBFF211F24FF211F24FF211F24FF211F24FF211F24FF7F7E81FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000908F91FF211F24FF211F24FF211F24FF211F24FF211F
      24FF7A797CFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000AEAEAEFF020202005A5A5AFF00000000000000000000
      0000000000000000000000000000000000000000000000000000B8B8B8FF0101
      01004E4E4EFF000000000000000000000000B6B6B6FF04040400141414AAC5C5
      C5FF000000000000000000000000000000000000000000000000ABABABFF0101
      010005050500CECECEFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFAFAFA00FEFEFE00000000000000000000000000DADADAFF2222
      22FFA1A1A1FFB1B1B1FFB1B1B1FFE7E7E7FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFE000000000000000000FEFEFE000000
      0000EEEEEE008E8E8E004A4A4A00333333003333330033333300333333003333
      3300333333003333330033333300909090009D9D9D0033333300333333003333
      3300333333003333330033333300333333003333330081818100B0B0B0003333
      33003333330048484800FDFDFD0000000000FEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EEED
      EFFF37353AFF211F24FF211F24FF211F24FF211F24FF7F7E81FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000908F91FF211F24FF211F24FF211F24FF211F24FF211F
      24FFD2D1D3FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B5B5B5FF05050500545454FF00000000000000000000
      0000000000000000000000000000000000000000000000000000C4C4C4FF0000
      00003B3B3BFF000000000000000000000000000000006F6F6FFF010101001212
      1266A8A8A8FFD4D4D4FF0000000000000000E4E4E4FF929292FF020202000101
      01008F8F8FFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFAFAFA00FEFEFE00000000000000000000000000DADADAFF1D1D
      1DFF545454FF5B5B5BFF5C5C5CFFCCCCCCFFFEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F5F5F500CACACA009A9A9A006A6A6A00535353004747
      4700484848005959590073737300A6A6A600F4F4F40056565600333333003333
      33003333330033333300333333003333330041414100E8E8E8004C4C4C003333
      330033333300B5B5B5000000000000000000FEFEFE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FFFFA4A3A6FF2A282CFF211F24FF211F24FF211F24FF6C6A6EFFC7C7C8FFC7C7
      C8FFC7C7C8FFC7C7C8FFC7C7C8FFC7C7C8FFC7C7C8FFC7C7C8FFC7C7C8FFC7C7
      C8FFC7C7C8FFC7C7C8FF747376FF211F24FF211F24FF211F24FF211F24FF7B79
      7DFFFDFDFEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CCCCCCFF06060600202020FF00000000000000000000
      0000000000000000000000000000000000000000000000000000A5A5A5FF0505
      05006C6C6CFF00000000000000000000000000000000B2B2B2FF606060FF0303
      030005050500131313883D3D3DFF3A3A3AFF0808080006060600070707007C7C
      7CFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6D6D6DFFFAFAFA00FEFEFE00000000000000000000000000DADADAFF2727
      27FFE1E1E1FFF9F9F900FAFAFA00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0D0D0003E3E3E003333
      330033333300333333003333330033333300BFBFBF00F3F3F3004B4B4B003333
      3300454545000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFDFF8A898BFF2C2A2FFF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF5E5D60FFF8F7
      F8FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000838383FF222222FF06060600B9B9B9FF000000000000
      0000000000000000000000000000000000000000000000000000474747FF0606
      0600A8A8A8FF000000000000000000000000000000000000000000000000A8A8
      A8FF2C2C2CFF04040400060606000404040006060600414141FFB8B8B8FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AAFF6C6C6CFFFAFAFA00FEFEFE00000000000000000000000000DADADAFF2828
      28FFE6E6E6FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFE000000000000000000FEFEFE00949494003333
      33003333330033333300333333006D6D6D000000000000000000999999003333
      3300A7A7A700FEFEFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FCFCFCFFBDBCBEFF525055FF2A282DFF211F24FF222025FF2B29
      2EFF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FF222025FF232126FF211F24FF222025FF424045FF9B9A9DFFFBFBFCFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000939393FF06060600303030FFE1E1E1FF0000
      00000000000000000000000000000000000000000000959595FF050505001E1E
      1EFFE6E6E6FF0000000000000000000000000000000000000000000000000000
      000000000000D3D3D3FFC1C1C1FFC3C3C3FFD7D7D7FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B9B9
      B9FF4B4B4BFFF3F3F30000000000000000000000000000000000C6C6C6FF3737
      37FFF0F0F0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F1F1F1005555
      550033333300333333003E3E3E00EDEDED000000000000000000E6E6E6003C3C
      3C00F1F1F1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFFFFF8F7F9FFDFDEE1FFD3D2D4FFD7D6D9FFD3D2
      D4FF2C2A2FFF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF211F
      24FFA9A8ABFFDBDADDFFD2D1D3FFD9D9DBFFFAF9FBFFFDFCFEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C4C4C4FF353535FF060606003A3A3AFFBABA
      BAFF000000000000000000000000DDDDDDFF7F7F7FFF0303030005050500A5A5
      A5FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E5E5
      E5FF363636FFAFAFAFFFFBFBFB0000000000FEFEFE00EEEEEE44696969FF8585
      85FFFCFCFC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B5B5
      B5003333330033333300A3A3A300000000000000000000000000FEFEFE009D9D
      9D00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFEFFFFFFFEFFFFFFFEFFFFFDFD
      FEFF79787BFF211F24FF211F24FF211F24FF211F24FF211F24FF211F24FF302E
      33FFF6F5F7FFFFFEFFFFFFFEFFFFFEFEFFFFFFFEFFFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDCFF3F3F3FFF010101000606
      0600282828FF5B5B5BFF464646FF090909000505050006060600979797FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00B7B7B7FF2D2D2DFF898989FFBEBEBEFFB2B2B2FF5D5D5DFF595959FFE6E6
      E6FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FAFA
      FA00636363003F3F3F00F7F7F7000000000000000000FEFEFE00FEFEFE00F8F8
      F800000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFEFFFFFFFE
      FFFFEBEBEDFF6A686CFF211F24FF211F24FF211F24FF211F24FF413F43FFD9D8
      DAFFFEFEFFFFFFFEFFFFFFFEFFFFFFFEFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E8E8E8FF8A8A8AFF1A1A
      1AFF04040400010101000202020000000000545454FFBFBFBFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD00CECECEFF797979FF4C4C4CFF585858FF999999FFE9E9E9EE0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B1B1B10090909000FEFEFE000000000000000000FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFE
      FFFFFFFEFFFFFAF9FBFFB4B3B5FF818083FF7E7D80FFA3A2A4FFEEEEEEFFFEFE
      FEFFFEFEFEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B2B2
      B2FFCBCBCBFFB9B9B9FFC0C0C0FFDCDCDCFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FDFDFD00F5F5F500F9F9F900FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EFEFEF00E1E1E10000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFEFFFF00000000FEFEFEFFFEFEFEFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FCFFFE00CEC8C700F5F5F500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FF000000FFFEFD
      FBFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EBEBEA00B7B6BA00FEFBF000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FF000000FF0000
      00FFFBF7EFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E8E8E800B9B9B900A3A5A9008F919100BDBDBD00C9C9C900D8D8
      D800F6F6F6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FFA587
      42FF000000FFF2EEE5FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DFDFDF00A9A9A900AFAF
      AF00AEAEAE0099AA9F0031B8600029CB610021CB5A0020C5590031C76600679B
      7800B2B2B200BBBBBB00ACACAC00D0D0D0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF651B0CFFA387
      42FF000000FFFEFDFBFF00000000000000000000000000000000000000000000
      000000000000FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEF
      DA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEF
      DA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEF
      DA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEF
      DA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FEFA
      F300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFE00BFBFBF00B9B9B900CBCBCB00000000000000
      000000000000CFE4D60001DD090001E3020001EB020001E8050002EB0A0090C7
      8F00000000000000000000000000D2D2D2009D9D9D00DADADA00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FF000000FF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DFDFDF00B5B5B500E2E2E2000000000000000000000000000000
      000000000000E9E9E90002E6010001FF000001FF000001FF000001FE0100B2D5
      B300FAFAFA0000000000000000000000000000000000E9E9E900AEAEAE00E4E4
      E400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FFFAF6EEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FDFDFD009090
      90FF3E3E3EFF313131FF313131FF3E3E3EFF9C9C9CFFEFEFEF22000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00B6B6B600C9C9C9000000000000000000FEFEFE0000000000F6F6F600F9F9
      F900E9E9E900FCFCFD0021E4210001FF000001FF000001FF000001FC0100DEE3
      DF00EBEBEB00E8E8E800F0F0F000FEFEFE00000000000000000000000000CFCF
      CF00AEAEAE00FAFAFA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CECECEFF111111FF0101
      01FF010101FF010101FF010101FF010101FF010101FF313131FFB0B0B0FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      9900F9F9F900000000000000000000000000EBEBEB00E8E8E800000000000000
      000000000000FEFFFF0043E5430001FF000001FF000001FF000005E804000000
      0000000000000000000000000000F0F0F000FEFEFE00FDFDFD00000000000000
      0000EFEFEF00BABABA00EEEFEE00FDFFFE00FEFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000FEFDFCFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800DEB47400CBBEAB00CBBEAB00CBBE
      AB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBE
      AB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBE
      AB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBEAB00CBBE
      AB00CBBEAB00CBBEAB00CBBEAB00D7B88900F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEDEDEFF010101FF010101FF1111
      11FF8F8F8FFFBDBDBDFFBFBFBFFF717171FF111111FF010101FF101010FFC0C0
      C0FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F6F6F6009A9A9A00FEFE
      FE000000000000000000F0F0F000E9E9E900FEFEFE0000000000000000000000
      0000FEFEFE00F5F5F5005BCF5B0001FF000001FF000001FF00001FCE1E00F3F3
      F300FEFEFE000000000000000000FEFEFE0000000000F4F4F400F1F1F1000000
      000000000000E9E9E90095989C00D7D5D200F5F2EF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF0000000000000000F7F1EDFFD1AD94FFFC837FFFDEC2
      B0FFFEFDFCFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F0F0F0001F1F1FFF000000FF313131FFEEEE
      EE4400000000000000000000000000000000EFEFEF22212121FF000000FF4D4D
      4DFFF0F0F0000000000000000000000000000000000000000000000000000000
      000000000000EEEEEE44EFEFEF22EDEDED66FDFDFD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000092929200000000000000
      000000000000EEEEEE00F8F8F800000000000000000000000000F5F5F500F5F5
      F500F0F0F000FEFEFE009DCC90003BB201003FAF01003CA901006DAA5100F9FA
      FA00F1F1F100F7F7F700F0F0F000000000000000000000000000FBFBFB00FCFC
      FC00FFFEFF00F2EFE700E7EDE900ADB2B100EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF0000000000000000D8B59DFFFF1000FFFF1000FFFF10
      00FFD1C4B9FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BFBFBFFF000000FF020202FFEFEFEF220000
      00000000000000000000000000000000000000000000DEDEDEFF020202FF0101
      01FFBCBCBCFF0000000000000000000000000000000000000000000000008F8F
      8FFF212121FF000000FF000000FF111111FF606060FFCFCFCFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000097979700FEFEFE00000000000000
      0000EDEDED00000000000000000000000000FCFCFC00F1F1F100F8F8F800FEFE
      FE000000000000000000BFD0B00055AB000054AA000054AA0000A3C78000FFFF
      FE000000000000000000FAFAFA00E9E9E900EFEFEF000000000000000000F7F6
      F000DED7D300DDD5D100EDF0EF00EFEFEF00B6B6B600FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF0000000000000000D2A98CFFFF1000FFFF1000FFFF10
      00FFBBA89BFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005C5C5CFF010101FF606060FF000000000000
      00000000000000000000000000000000000000000000000000005D5D5DFF0000
      00FF6E6E6EFF00000000000000000000000000000000ACACACFF020202FF0000
      00FF000000FF010101FF010101FF000000FF000000FF101010FF919191FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C9C9C900DDDDDD000000000000000000FAFA
      FA00000000000000000000000000FAFAFA00FBFBFB00FEFEFE00000000000000
      0000FEFEFE00F7F7F700D6DBD10054A8010054AA000053AA00009DB08C00F1F1
      F100FBFBFB00000000000000000000000000F3F3F300F4F4F400FEFFFE00F4F4
      F600E9EBE800E1EAF100FCFCFA0000000000DBDBDB00B6B6B600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF0000000000000000DFC3B1FFFF1000FFFF1000FFFF10
      00FF7D7068FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFDFDFFF8F3F0FFFAF7F5FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300A1A1A100A3A3A300A9A9A900ACACAC00BABA
      BA00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C3009E9E9E00A4A4A400AEAEAE009E9E9E00ACACAC00BFBFBF00C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003F3F3FFF010101FF9E9E9EFF000000000000
      00000000000000000000000000000000000000000000000000008F8F8FFF0000
      00FF606060FF000000000000000000000000C0C0C0FF000000FF010101FF2F2F
      2FFFAEAEAEFFFDFDFD0000000000BEBEBEFF424242FF000000FF000000FF7F7F
      7FFF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F0F0F000B5B5B5000000000000000000F5F5F500FEFE
      FE000000000000000000FAFAFA00F6F6F600000000000000000000000000EEEE
      EE00EDEDED0000000000F9F8F9004F99050054AA000054AA0100D7DFCF00F6F6
      F600F5F5F500F2F2F200FAFAFA000000000000000000F1F6F600E0D8D400E9E9
      E800FEFEFD00FEFFFF00F0F0F0000000000000000000A5A5A500EEEEEE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF0000000000000000FDFDFCFFD4C4B9FFDEC3B1FFFC83
      7FFFFF1000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FFFF1000FFFF1000FFF89590FFA39D9AFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C30099999900A6A6A600E5E5E500FEFEFE00FCFCFC00F1F1F100BABA
      BA00A2A2A200BABABA00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300B2B2
      B200A8A8A800E4E4E400FAFDF900B7EDA200F5FAF400E7E7E700A6A6A600AEAE
      AE00C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040FF010101FFB0B0B0FF000000000000
      00000000000000000000000000000000000000000000000000006F6F6FFF0000
      00FF5F5F5FFF000000000000000000000000202020FF010101FF303030FF0000
      000000000000000000000000000000000000FEFEFE00606060FF000000FF0E0E
      0EFFDEDEDEFF0000000000000000000000000000000000000000000000000000
      00000000000000000000898989000000000000000000FDFDFD00F7F7F7000000
      000000000000EEEEEE00FDFDFD000000000000000000FCFCFC00ECECEC000000
      00000000000000000000FEFDFE005C98210054AA000050A00100EFF0EF000000
      00000000000000000000F9F9F900F5F5F50000000000E8EFF300DBDDDB00EBEF
      EF00FEFEFE0000000000FCFCFC00EFEFEF0000000000F9F9F900B6B6B600FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      00FFFF1000FFD2A78BFFFAF6F4FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DDBDA8FFFF1000FFFF1000FFFF1000FFDCC0AEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C3009D9D9D00C7C7C70000000000000000000000000000000000000000000000
      0000F3F3F3009D9D9D00C3C3C300C3C3C300C3C3C300C3C3C300BBBBBB00B7B7
      B7000000000000000000EBFAE50050D41C00E4F8DB0000000000FEFEFE009D9D
      9D00ADADAD00C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004E4E4EFF010101FFB0B0B0FF000000000000
      0000000000000000000000000000000000000000000000000000323232FF0000
      00FF8C8C8CFF0000000000000000BFBFBFFF010101FF111111FFDFDFDFFF0000
      00000000000000000000000000000000000000000000EEEEEE44313131FF0101
      01FF7E7E7EFF0000000000000000000000000000000000000000000000000000
      000000000000EFEFEF00ADADAD000000000000000000EFEFEF00000000000000
      0000FCFCFC00F0F0F0000000000000000000F9F9F900F6F5F600B3DFB200FDFD
      FD00FEFEFE0091E68F0091DB90007DB4490054AA000057A01000EBEBEB00F5F5
      F500FEFEFE000000000000000000EDEEEF00E6DED800E3E2E40000000000FEFE
      FE00F1F1F1000000000000000000F1F1F100FEFEFE0000000000BEBEBE00EEEE
      EE00000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000FFFF1000FFDBBCA5FFFDFDFCFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E2D1C5FFFF1000FFFF1000FFFF1000FFFF1000FFD9B9A4FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300BBBB
      BB00A1A1A1000000000000000000000000000000000000000000000000000000
      000000000000E5E5E500A4A4A400C3C3C300C3C3C300C3C3C3009A9A9A00FEFE
      FE000000000000000000F9FEF8005DD72D00F2FCEE000000000000000000F8F8
      F800A1A1A100C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E0E0E0FF9D9D9DFF00000000000000000000
      00000000000000000000000000000000000000000000AEAEAEFF000000FF0101
      01FFDBDBDBFF00000000000000007E7E7EFF010101FF505050FF000000000000
      0000000000000000000000000000000000000000000000000000909090FF0000
      00FF4D4D4DFF0000000000000000000000000000000000000000000000000000
      000000000000AAAAAA00FEFEFE0000000000FCFCFC00F1F1F100000000000000
      0000F4F4F4000000000000000000F7F7F700E0E2DF0032CD370013F81200C7E7
      C70037D0360023D101005FAC320089AD650055AA01006AA53200FFFEFE000000
      0000EAEAEA00F9F9F90000000000E2E4E900E6DCCF00EAEBE700000000000000
      0000EDEDED00F7F7F70000000000FAFAFA00F8F8F80000000000F5F5F500A7A7
      A700000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      000000000000DFC5B5FFFF1000FFDFC6B3FF0000000000000000000000000000
      00000000000000000000000000000000000000000000FEFDFCFFE7D6CAFFFF10
      00FFFF1000FFFF1000FFFF1000FFFF1000FFFF1000FFC2B5ADFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C3009C9C
      9C00F8F8F8000000000000000000000000000000000000000000000000000000
      00000000000000000000A9A9A900C3C3C300C3C3C300BBBBBB00BDBDBD000000
      00000000000000000000FFFFFE007CDF5500FAFEF90000000000000000000000
      0000C3C3C300BEBEBE00C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008E8E8EFF010101FF010101FF7070
      70FF0000000000000000000000005E5E5EFF010101FF909090FF000000000000
      0000000000000000000000000000000000000000000000000000B0B0B0FF0000
      00FF404040FF0000000000000000000000000000000000000000000000000000
      000000000000959595000000000000000000E9E9E900FEFEFE0000000000EAEA
      EA00FEFEFE000000000000000000F0F0F1005DCE5B0002FF00001BB901005D99
      2300B9D49E0050A200004D9B020093B17400509800007C9D54004EB44E0091C7
      9500EFF2F100EDECEA00F8FCF800E6E1DF0000000000FBFBFB00FAFAFA000000
      000000000000F0F0F0000000000000000000F0F0F0000000000000000000BEBE
      BE00000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      000000000000FDFDFCFFD7AE99FFFF1000FFD2C4B9FF00000000000000000000
      0000000000000000000000000000FCFBF9FF5B524CFFFF1000FFFF1000FFD7A8
      90FF000000FFFEFDFCFFF7F2EFFFE0C7B7FFFF1000FFAFA095FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300A8A8
      A800EEFBE900D2F4C500E4F8DC00F1FBED00C4C6C3009A9A9A00F7F7F7000000
      00000000000000000000C6C6C600BDBDBD00C3C3C300B3B3B300E9E9E9000000
      00000000000000000000EAEAEA005B8F4700EAEAEA0000000000000000000000
      0000E9E9E900A2A2A200C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000EFEFEF228F8F
      8FFF808080FF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F
      7FFF7F7F7FFF808080FF6F6F6FFF1E1E1EFF000000FF000000FF404040FFFCFC
      FC000000000000000000000000005E5E5EFF000000FF8F8F8FFF000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0FF0000
      00FF404040FF0000000000000000000000000000000000000000000000000000
      0000EFEFEF00DEDEDE000000000000000000E8E8E8000000000000000000F3F3
      F3000000000000000000ECECEC00FEFEFE00EBFBEC0061D6540053AA010054AA
      00009AC96C006D9F3E0055AA02008B886400A7530000C2A27C003FA301002FB5
      1400FCFDFB00E6E7EA00CDCAD600EBF0F3000000000000000000EDEDED00FEFE
      FE0000000000F2F2F200F7F7F70000000000FCFCFC00F2F2F20000000000C9C9
      C900DEDEDE000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      00000000000000000000FBF7F4FFD4AA8FFFFF1000FF000000FF000000000000
      000000000000FEFDFCFFBCA89BFFFF1000FFFF1000FFD2A78AFFE0CFC3FF0000
      0000000000000000000000000000FBF9F7FFD5AC90FFD3A78AFFFDFCFCFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300B9B9
      B900A4E98A0052D41E0067D93A0088E265006E90600095959500CECECE000000
      00000000000000000000D8D8D800BEBEBE00C3C3C300B0B0B000F1F1F1000000
      00000000000000000000A6A6A600A8A8A800ACACAC0000000000000000000000
      0000F6F6F600A3A3A300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000BFBFBFFF0101
      01FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF717171FFFDFDFD000000
      00000000000000000000000000007F7F7FFF010101FFADADADFF000000000000
      0000000000000000000000000000000000000000000000000000303030FF0000
      00FF7F7F7FFF0000000000000000000000000000000000000000000000000000
      0000B7B7B700FEFEFE0000000000FCFCFC00FCFCFC0000000000FEFEFE00F6F6
      F60000000000F9F9F900F5F5F50000000000FEFEFE00EBE9E90083A169005FAF
      100054AA000088A268009E6412008E633C00A15000007E7D470055AA0100A1B6
      8F00F6F1EF00E3DBDC00FEFEFD00EBEBEA00F7F7F70000000000F7F7F700F0F0
      F00000000000FEFEFE00F0F0F0000000000000000000F7F7F70000000000F6F6
      F600B5B5B5000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000FFFE6461FFFF1000FFD1A68AFFDCBF
      ABFFAB998DFFFF1000FFFF1000FFF3A198FFD2C4BAFF00000000000000000000
      000000000000000000000000000000000000998C82FFFF1000FFB1A59CFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300A4A4
      A400F9FCF800FAFEF9000000000000000000E5E5E500CCCCCC00000000000000
      00000000000000000000B7B7B700BDBDBD00C3C3C300ACACAC00D8D8D8000000
      00000000000000000000F8F8F800ABABAB00FBFBFB0000000000000000000000
      0000E1E1E100AFAFAF00C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000007E7E
      7EFF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF727272FF707070FF727272FF969696FFF6F6F60000000000000000000000
      000000000000000000000000000000000000BFBFBFFF00000000000000000000
      00000000000000000000000000000000000000000000B1B1B1FF050505FF0303
      03FFDDDDDDFF0000000000000000000000000000000000000000000000000000
      0000B7B7B7000000000000000000F9F9F9000000000000000000F4F4F4000000
      000000000000EBEBEB000000000000000000F7F7F700D2DED4003FDB420099C9
      8A006E812100B05E1300A2754800985E2600A15811008C6B36007B7C2B004D9E
      220072B86800EAF1F300FEFFFF00FEFEFE00ECECEC0000000000FEFEFE00E9E9
      E9000000000000000000F5F5F5000000000000000000F7F7F700000000000000
      0000B2B2B2000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000DDBEA9FFFF1000FFFF1000FFFF10
      00FFFF1000FFD3AB90FF9B918AFF000000000000000000000000000000000000
      000000000000000000000000000000000000FCFBF9FFE3AA99FFD0A78CFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C3009E9E
      9E00E3E3E3000000000000000000000000000000000000000000000000000000
      0000000000000000000096969600C3C3C300C3C3C300C2C2C200C8C8C8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B1B1B100C0C0C000C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FEFEFE000000
      0000000000000000000000000000FBFBFB00868686FF010101FF010101FF7979
      79FF000000000000000000000000000000000000000000000000000000000000
      0000ADADAD000000000000000000F6F6F500D3DFDB00A4D1B100C9E6D200E5E5
      E500FDFEFE00F9F9F800FDFEFE0000000000EEEEEE0061C3660003FE01003A95
      030074984500A173350096592100B5894D00B4905400A7804600947739006FA3
      2C0096AF9000F1F1F10000000000FEFEFE00F5F5F5000000000000000000E8E8
      E8000000000000000000E7E7E7000000000000000000F0F0F000000000000000
      0000AFAFAF000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6B199FFFF1000FFFF1000FFFF10
      00FFD9B69EFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000096877BFFFF1000FF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300BCBC
      BC00A6A6A600FEFEFE0000000000000000000000000000000000000000000000
      000000000000CCCCCC00A2A2A200C3C3C300C3C3C300C3C3C3008E8E8E00EDED
      ED0000000000000000000000000000000000000000000000000000000000E8E8
      E8008B8B8B00C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000ECECEC884040
      40FF404040FF404040FF404040FF404040FF404040FF404040FF404040FF4040
      40FF404040FF404040FF404040FF404040FF404040FF404040FF404040FF4040
      40FF404040FF444444FF3C3C3CFF3B3B3BFF434343FF3F3F3FFF444444FF4343
      43FF414141FF404040FF464646FF414141FF3C3C3CFF2F2F2FFF0F0F0FFF4343
      43FF414141FF444444FF464646FF030303FF060606FF020202FF4B4B4BFFFEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000BBBBBB000000000000000000EFEFEF007DD4B30000FE540001EA270002F0
      000011E011002DD62C0063E6630080E18000A7BE9F00A0C09B0070C57000689A
      3900539813007F440500B5956100E9CE8600EACE8700EACE8600C3A063006D75
      2100378D1700F4F6F600F0EFEF00EEF0EE00EAEAEA00F9F9F90000000000F1F1
      F100FCFCFC0000000000F1F1F1000000000000000000EDEDED00000000000000
      0000B2B2B2000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000005A514BFFFF1000FFFF1000FFFF10
      00FF5A514CFF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F4F1FFFF1000FFDAB7
      A1FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300BBBBBB00ACACAC00FBFBFB00000000000000000000000000000000000000
      0000D7D7D7008C8C8C00C3C3C300C3C3C300C3C3C300C3C3C300BBBBBB008888
      8800EBEBEB000000000000000000000000000000000000000000F2F2F2007D7D
      7D00C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000BEBEBEFF0101
      01FF010101FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF010101FF090909FF050505FF040404FF000000FF050505FF0101
      01FF020202FF010101FF030303FF010101FF000000FF000000FF000000FF0101
      01FF010101FF020202FF040404FF040404FF040404FF848484FFFEFEFE000000
      00000000000000000000000000000000000000000000F6F5F600B3B8BA00B8C2
      CA00A7A7A700ECECEC00ECECEC00E1E1E10067B6960000FF550001F0220001FF
      000001FF000001FF000002FF010001FF000041A7010051A500005EAD1000599B
      1B007F833D0085552700CFB87800D2BF8200CFBC8300C3AF8000EBCD86009978
      4100996B3E0060992A003590020073C57400ECECEC00E3E3E300ECECEC00E2E2
      E200E8E8E800ECECEC00DCDCDC00EBEBEB00ECECEC00E0E0E000ECECEC00ECEC
      EC00AAABAA00C0C6CA00DFDBD500FEFFFE000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFCFFE2D1C6FFE1C5B5FF978A
      82FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DDBFACFFFF10
      00FFB9B4B0FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300B8B8B800A1A1A100C5C5C500E0E0E000EEEEEE00C3C3C300B0B0
      B0009B9B9B00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300B7B7
      B70098989800BEBEBE00E1E1E100FDFDFD00EBEBEB00B2B2B20092929200C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000FDFDFD00BEBE
      BEFFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0
      B0FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0
      B0FFAFAFAFFFB2B2B2FF8F8F8FFFB0B0B0FFAFAFAFFFB3B3B3FFB0B0B0FFB0B0
      B0FFB0B0B0FFAFAFAFFFB0B0B0FFA0A0A0FFAFAFAFFF9E9E9EFF7C7C7CFFB0B0
      B0FFB0B0B0FFB0B0B0FF9D9D9DFFCECECEFFEFEFEF2200000000000000000000
      00000000000000000000000000000000000000000000D3D3D700B2B1AF00C8C2
      BF00ADACAC000000000000000000F3F3F30078C7A70001FF550001E3210001FF
      000001FF000001FF000001FF000001FE01003CA0020051A201005698160080BB
      47007576390098633300D9B97800DAC18200C9B37F00CAB68100EACD86008558
      2600986D41005E8A320040A51A008FCA9100FDFDFD00F0F0F00000000000F5F5
      F500F8F8F80000000000EEEEEE00FDFDFD0000000000F0F0F000FEFEFE000000
      0000AFB0AF00AEB3B900DAD8D900FFFFFE000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7F1EDFFFF10
      00FFD9BAA5FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C2C2C2009E9E9E009D9D9D00BDBDBD00C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C2C2C200A5A5A500A6A6A600B1B1B100C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA0000000000000000000000000000000000000000000000000000000000EFEF
      EF22DFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
      DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
      DFFFDFDFDFFFDDDDDDFFDFDFDFFFDCDCDCFFD9D9D9FFDDDDDDFFDDDDDDFFDFDF
      DFFFDBDBDBFFDADADAFFDDDDDDFFDFDFDFFFDDDDDDFFDDDDDDFFDDDDDDFFDFDF
      DFFFDDDDDDFFDFDFDFFFDDDDDDFF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00FEFFFE00FEFE
      FF00B4B4B4000000000000000000EEEDEE0091CBB60001F9540002E6280001D3
      010037E037005FEC5E007CDF7B00A5E0A500C5CCC000A3D096008FB76A0067A5
      2A0073770100B36F2D00B1894C00EACE8700EACE8700EACE8700BB9C5F00935B
      27009A4D020097521100829A5B00A7BB9400D2D8CC00FBFBFA0000000000F3F3
      F3000000000000000000F1F1F1000000000000000000E7E7E700000000000000
      0000A8A9A900FEFEFE00FEFEFE00000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D9B7
      A1FFFF1000FFF7F2EDFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300C2C2C2009D9D9D00B2B2B200D1D1D100CFCFCF00B1B1B1009797
      9700B7B7B700C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300ADADAD00A8A8A800AEAEAE00BCBCBC00ADADAD009F9F9F00B6B6B600C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000CFCFCFFF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF404040FFAEAEAEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AFAFAF000000000000000000F5F5F500D0E8E100BED8C700E3E4E4000000
      0000F0F0F0009CDBAB0070EE700017D4170001F9010021C0020054AA00004E9B
      020093A46500A5692F00AF713100AA723200A88752009E743E0098643000A767
      2400BC9570008453130055AA010055AA000051A600005395140055B6460088C2
      8800CEDFCE00FFFEFF00F3F3F300FEFEFE0000000000FAFAFA00000000000000
      0000B6B6B6000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00FFFF1000FF7E7066FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300A2A2A200AFAFAF00FEFEFE0000000000000000000000000000000000EFEF
      EF00ACACAC00B3B3B300C3C3C300C3C3C300C3C3C300C3C3C300C2C2C2009393
      9300D3D3D30000000000000000000000000000000000F7F7F700C1C1C100A1A1
      A100C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000AFAFAFFF1010
      10FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF1010
      10FF101010FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF101010FF7F7F7FFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B6B6B6000000000000000000EDEDED000000000000000000FAFAFA00FEFF
      FF0021D8760001E8430002F1000001FF000001FF000007F9010083B45D008FA3
      7D005E8D0300965F0F00896B3400AA763F0091490100A271420076602400A872
      3800AF5E1100C29F74008BB561005AA7100054AA010051A1020001E4020001FF
      000002EF00001FE5240058D38600D4E0DE0000000000F0F0F000000000000000
      0000B0B0B0000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D4AC93FFFF1000FFFDFDFCFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300BFBF
      BF009C9C9C000000000000000000000000000000000000000000000000000000
      0000FDFDFD00A9A9A900C2C2C200C3C3C300C3C3C300C3C3C3009D9D9D00F5F5
      F50000000000000000000000000000000000000000000000000000000000B4B4
      B400A8A8A800C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA0000000000000000000000000000000000000000000000000000000000EDED
      ED66EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEF
      EF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEF
      EF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF220000
      0000EBEBEBAAEFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEFEF22EFEF
      EF22EFEFEF22EFEFEF22EDEDED669D9D9DFF202020FF000000FF000000FF7F7F
      7FFF000000000000000000000000000000000000000000000000000000000000
      0000B5B5B500FEFEFE0000000000F2F2F200F7F7F70000000000F9F9F900F5F6
      F6007ADFB70002F4510002E7130001FE000030F72F009ABF9B009AC3700054AA
      010051A500009AB28300509F0100819F5700717D0100748A510055A902007E94
      52009E5711009555020075A04100A9B49F006D9F3F002FBE010001FF000001FF
      000001FF000001E61C0004DB6400E0E4E30000000000E2E2E20000000000EFEF
      EF00ADADAD000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FFFF1000FFD8AA90FFBDA89BFFFBF9F7FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C3009393
      9300F9F9F9000000000000000000000000000000000000000000000000000000
      000000000000E9E9E900AEAEAE00C3C3C300C3C3C300B7B7B700BFBFBF000000
      000000000000000000000000000000000000000000000000000000000000F9F9
      F900A6A6A600C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA0000000000000000000000000000000000000000000000000000000000D0D0
      D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0
      D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0
      D0FFD0D0D0FFD0D0D0FFD0D0D0FFDDDDDDFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFEFEF225D5D5DFF000000FF1010
      10FFDFDFDFFF0000000000000000000000000000000000000000000000000000
      0000EAEAEA00BFBFBF0000000000FEFEFE00F6F6F6000000000000000000EBEB
      EB00CBE1D90008D75F0001D538008BEA8A00CEE3CE004BC5330052A7010055AA
      01007D9E60006BAB300057AB0200708A580054AA0000668946004C94040030B6
      1400B7BA92004F91010054AA0100569F1000C1D4B000BCF4BD0014DF130001FF
      000002FF000003D63E004FD79D00FEFEFF00FAFAFA00F8F8F80000000000BCBC
      BC00E1E1E1000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DABEAAFFFF1000FFFF1000FFFF1000FFE1CFC3FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300B0B0
      B00000000000000000000000000000000000E9E9E900E6E6E600000000000000
      00000000000000000000A4A4A400C3C3C300C3C3C3009B9B9B00FEFEFE000000
      0000000000000000000000000000F4F4F4000000000000000000000000000000
      0000C4C4C400BDBDBD00C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000DEDEDEFF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF010101FF3E3E3EFFCCCCCCFF000000000000
      00000000000000000000000000009F9F9FFF000000FFAFAFAFFF000000000000
      00000000000000000000000000000000000000000000EFEFEF22202020FF0000
      00FF7E7E7EFF0000000000000000000000000000000000000000000000000000
      000000000000B2B2B2000000000000000000F0F0F000FEFEFE0000000000F1F1
      F100F8FAFA009BDDBB00DBE0DF0089D2890001E8010001FF010028BE02006EA8
      3500B5C9A10055AA000055A5050092AF790054AA000080B052002BDA2A0001FE
      0100AAE9A8008DB66A0055AA000054AB000054A3060095BC7A00D5E6D5006FDF
      6F0012DC220002DD5500C0E2D60000000000F3F3F3000000000000000000B0B0
      B000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D5B197FFFF1000FFFF1000FFFF1000FFBEA89AFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C4C4
      C400000000000000000000000000F6F6F6006D6D6D0078787800000000000000
      00000000000000000000B5B5B500C3C3C300C3C3C300B0B0B000000000000000
      00000000000000000000878787007A7B7A00A8DA9500A6E98C008EE36D008BE2
      6800CDDFC700B8B8B800C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000DFDFDFFF2F2F
      2FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F
      1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F
      1FFF1F1F1FFF1F1F1FFF202020FF010101FF010101FF010101FF6B6B6BFF0000
      0000000000000000000000000000606060FF000000FF606060FF000000000000
      0000000000000000000000000000000000000000000000000000707070FF0000
      00FF3F3F3FFF0000000000000000000000000000000000000000000000000000
      000000000000A8A8A800EEEEEE0000000000F5F5F500EFEFEF00FEFEFE000000
      0000F4F4F400FBFCFB0054DF540003FF020001FF000001FF000011FC1100C6DA
      C8001DE81B0015C1010051A52E0098C16F0054AA01006BA63100BBE4BB00BFC3
      C000E8E8E800EFF0EE007BB9410054AA00004EAC03000CE3020040F04100DDF0
      DD00B2C6B9007BCCA800FEFEFE00F9F9F900F6F6F60000000000F4F4F400A8A8
      A800000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AB998DFFFF1000FFFF1000FFFF1000FF000000FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C1C1
      C10000000000000000000000000000000000819C77008E968B00000000000000
      00000000000000000000B6B6B600C3C3C300C3C3C300B1B1B100000000000000
      00000000000000000000999999007E827C00BBE1AC00B8EDA200A0E784009DE7
      8000DEE1DD00B9B9B900C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D1D1D1FF5F5F5FFF010101FF010101FF9F9F
      9FFF000000000000000000000000606060FF000000FF606060FF000000000000
      0000000000000000000000000000000000000000000000000000797979FF0000
      00FF202020FF0000000000000000000000000000000000000000000000000000
      000000000000EEEEEE00C2C2C2000000000000000000EBEBEB00000000000000
      0000CEDFD50022D7280002FD010001FF000001FF000002FF0100AEE2AE006AE2
      690002FF010001FF00008AF28C0047BE3F0010E101000AB40800F4F3F400FEFE
      FE000000000000000000D5DFCD004A9D11000ADB010002FF000001FF000013D4
      18009AC6A600FDFDFD0000000000E7E7E7000000000000000000AFAFAF00FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FBF8F7FFD9C2B2FFDEBDA8FF5A514BFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300AFAF
      AF0000000000000000000000000000000000A5E98B00D5F4C800000000000000
      000000000000FEFEFE00A5A5A500C3C3C300C3C3C300A1A1A100EFEFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B8B8B800BFBFBF00C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEEEEE44FEFEFE00000000000000
      000000000000000000000000000000000000F0F0F000626262FF000000FF1010
      10FFEEEEEE440000000000000000606060FF000000FF505050FF000000000000
      00000000000000000000000000000000000000000000000000007C7C7CFF0000
      00FF303030FF0000000000000000000000000000000000000000000000000000
      00000000000000000000AAAAAA00EFEFEF0000000000F8F8F800ECECED0095D6
      AB0002FA540001CF320001FD040001FF000001FF00005AC65A00CADACB0001FE
      000001FF000001FE0000B3D5B50014D3120001FF000001FC0100E0E4E0000000
      000000000000FEFEFE00E2E3E20089E1880001FB010001FF000002F4030003DB
      3C00C9E2D20000000000FCFCFC00F0F0F00000000000F0F0F000B6B6B6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C3009F9F
      9F00DADADA0000000000000000000000000090E47000B8EDA300000000000000
      000000000000CBCBCB00AFAFAF00C3C3C300C3C3C300BFBFBF00C0C0C0000000
      000000000000000000000000000000000000000000000000000000000000FDFD
      FD009C9C9C00C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005C5C5CFF111111FFBEBEBEFF000000000000
      00000000000000000000000000000000000000000000EFEFEF221F1F1FFF0101
      01FFAFAFAFFF00000000000000008F8F8FFF000000FF101010FFEFEFEF220000
      0000000000000000000000000000000000000000000000000000202020FF0000
      00FF5F5F5FFF0000000000000000000000000000000000000000000000000000
      00000000000000000000EFEFEF00B5B5B5000000000000000000EBECEC0016DA
      8B0002FC5B0001FF540001D9320001FD060028E32800FEFDFE0041C1690004CD
      2A0002EF0D0002E70200E0E4E10021CD300013D020001AC42600D2D8D200FAFA
      FA00F1F1F100E7E7E70000000000FEFFFE006FDF6E0005F0030005ED3F00ADE2
      C000FEFFFE00FEFEFE00F6F6F600000000000000000098989800FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C2C2
      C2009C9C9C00F2F2F200000000000000000078DE51009FE78200000000000000
      0000F4F4F4008D8D8D00C3C3C300C3C3C300C3C3C300C3C3C3009A9A9A00D8D8
      D80000000000000000000000000000000000000000000000000000000000A6A6
      A600BABABA00C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040FF010101FFB0B0B0FF000000000000
      00000000000000000000000000000000000000000000000000007E7E7EFF0000
      00FF5D5D5DFF0000000000000000EDEDED66000000FF000000FF707070FF0000
      000000000000000000000000000000000000000000008F8F8FFF000000FF0000
      00FFCFCFCFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B6B6B600D1D1D1000000000000000000C6F4
      E60012D2820000FD5B0002FF550011F14A00C6E2C60000000000E3F3E90073D2
      950019DA5B0037B86000EFEEEF00F2F3F100E5E4E500EFEEEE00F2F3F3000000
      000000000000000000000000000000000000E1EDE20036CB5D00BEE1CC00FEFE
      FF0000000000EBEBEB000000000000000000D0D0D000C7C7C700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300B8B8B8008E8E8E00DEDEDE00FDFDFD00B5ED9F00D4F4C80000000000C4C4
      C4008D8D8D00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C2C2C200AEAE
      AE00BCBCBC00F5F5F500000000000000000000000000ECECEC00A5A5A500A9A9
      A900C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003F3F3FFF010101FFB0B0B0FF000000000000
      00000000000000000000000000000000000000000000000000008F8F8FFF0000
      00FF606060FF0000000000000000000000008F8F8FFF000000FF000000FF5050
      50FFDFDFDFFF0000000000000000000000007E7E7EFF000000FF000000FF4040
      40FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BEBEBE00EFEFEF0000000000FEFE
      FE00AAE1CF0012EE930003F05700AEEFC500F6F6F600EAEAEA00F0F0F0000000
      0000EFF0F000EEF0EF000000000000000000EEEEEE0000000000000000000000
      00000000000000000000F8F8F800EBEBEB00FBFCFC00FFFEFF00000000000000
      0000F1F1F1000000000000000000EEEEEE00C7C7C70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300A3A3A300A2A2A200AEAFAE00BCBCBC0098989800AAAA
      AA00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300B0B0B000B2B2B200ABABAB00BDBDBD00A4A4A400A6A6A600C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004F4F4FFF010101FF6D6D6DFF000000000000
      00000000000000000000000000000000000000000000000000006C6C6CFF0101
      01FF6D6D6DFF00000000000000000000000000000000505050FF000000FF0000
      00FF000000FF303030FF303030FF000000FF000000FF000000FF404040FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FBFBFB00AAAAAA00F3F3F3000000
      000000000000CAEBE00078CAB000FEFEFE000000000000000000FCFCFC00E2E2
      E200E3E3E300F4F4F400FEFEFE0000000000EEEEEE000000000000000000FCFC
      FC00F7F7F700ECECEC00F5F5F500000000000000000000000000F9F9F900ECEC
      EC00FEFEFE0000000000FEFEFE00A9A9A9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009B9B9BFF010101FF1F1F1FFFEFEFEF220000
      00000000000000000000000000000000000000000000EFEFEF22212121FF0101
      01FF8F8F8FFF00000000000000000000000000000000000000009F9F9FFF2020
      20FF000000FF000000FF000000FF000000FF000000FF707070FFFBFBFB000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFEFEF00A8A8A800EFEF
      EF000000000000000000FDFDFD00F1F1F100F7F7F70000000000000000000000
      0000FEFEFE00F9F9F900F1F1F100F0F0F000DEDEDE00ECECEC00ECECEC00FBFB
      FB000000000000000000000000000000000000000000EEEEEE00F7F7F700FEFE
      FE0000000000F9F9F90089898900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C8BEA6FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800D9B68200C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D2BA9700F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000ECECEC88111111FF010101FF5E5E5EFFF1F1
      F1000000000000000000000000000000000000000000515151FF010101FF1111
      11FFFEFEFE00000000000000000000000000000000000000000000000000EFEF
      EF22BFBFBFFF9F9F9FFF9F9F9FFFAFAFAFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F2F2F2009C9C
      9C00E2E2E200000000000000000000000000F2F2F200E9E9E900FAFAFA000000
      000000000000000000000000000000000000EEEEEE0000000000000000000000
      0000000000000000000000000000F0F0F000F2F2F20000000000000000000000
      0000E6E6E600BBBBBB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FFC9926FFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800E5B06000D9B68200D9B68200D9B6
      8200D9B68200D9B68200D9B68200D9B68200D9B68200D9B68200D9B68200D9B6
      8200D9B68200D9B68200D9B68200D9B68200D9B68200D9B68200D9B68200D9B6
      8200D9B68200D9B68200D9B68200D9B68200D9B68200D9B68200D9B68200D9B6
      8200D9B68200D9B68200D9B68200E4B06300F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009D9D9DFF020202FF010101FF4F4F
      4FFFBDBDBDFFEAEAEACCFAFAFA00ADADADFF212121FF000000FF010101FFB0B0
      B0FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FDFD
      FD00ACACAC00BEBEBE0000000000000000000000000000000000ECECEC00F0F0
      F000EFEFEF00F1F1F100FEFEFE0000000000EEEEEE000000000000000000F6F6
      F600F2F2F200F6F6F600F6F6F60000000000000000000000000000000000B1B1
      B100ADADAD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000FF0000
      00FF857E6BFFA45B43FFCFCCC3FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00747474FF010101FF0101
      01FF010101FF121212FF020202FF010101FF010101FF010101FF8E8E8EFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E4E4E400A9A9A900DDDDDD000000000000000000000000000000
      0000FEFEFE00F9F9F900F4F4F400F2F2F200E5E5E500EEEEEE00E9E9E900FEFE
      FE000000000000000000000000000000000000000000CACACA00BCBCBC00F8F8
      F800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000827B6BFF0000
      00FF000000FFB97859FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BFBFBFFF3131
      31FF121212FF010101FF010101FF010101FF5E5E5EFFDDDDDDFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFE00CFCFCF00B0B0B000D3D3D300EFEFEF000000
      000000000000000000000000000000000000EEEEEE0000000000000000000000
      00000000000000000000FEFEFE00A4A4A400B8B8B800DFDFDF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FEFDFBFF0000
      00FF420F03FF000000FF000000FFFEFEFCFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDEFDA00F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A8
      3800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800F3A83800FDEF
      DA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00CCCCCCFFCECECEFFFCFCFC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFEFEF00C6C6C600A8A8
      A800B4B4B400CECECE00D8D8D800E8E8E800DEDEDE00E8E8E800D6D6D600AFAF
      AF00B6B6B600B1B1B100ABABAB00F9F9F9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FDFB
      F6FF000000FF000000FFFCF9F3FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFAF300FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEF
      DA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEF
      DA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEF
      DA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEF
      DA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA00FDEFDA000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EEEEEE00D3D3D300C7C7C700B4B2AE00BABBB900D0D0D000FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E8EBF2009E979200E1D9D300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F1F5F800D2D5D700EFEBE800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      28000000C0000000C00000000100010000000000001200000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF00000000000000000000
      0000000000000000FFFFFFFFFFFF000000000000000000000000000000000000
      FFFFFFFFFFFF000000000000000000000000000000000000FFFFFFFFFFFF0000
      00000000000000000000000000000000FFFFFFFFFFFF00000000000000000000
      0000000000000000FFFFFFFFFFFF000000000000000000000000000000000000
      FFFFFC3FFFFF000000000000000000000000000000000000FFFFFC3FFFFF0000
      00000000000000000000000000000000FFFFFC3FFFFF00000000000000000000
      0000000000000000FFFFFC3FFFFF000000000000000000000000000000000000
      FFFFFC3FFFFF000000000000000000000000000000000000FFFFFC3FFFFF0000
      00000000000000000000000000000000FFFFFC3FFFFF00000000000000000000
      0000000000000000FFFFFC3FFFFF000000000000000000000000000000000000
      FFFFFC3FFFFF000000000000000000000000000000000000FFFFFC3FFFFF0000
      00000000000000000000000000000000FFFFFC3FFFFF00000000000000000000
      0000000000000000FFFFFC3FFFFF000000000000000000000000000000000000
      FFFFFC3FFFFF000000000000000000000000000000000000FFF9FC3F9FFF0000
      00000000000000000000000000000000FFF0FC3F0FFF00000000000000000000
      0000000000000000FFE1FC3F87FF000000000000000000000000000000000000
      FFE23C3C47FF000000000000000000000000000000000000FFC23E7C43FF0000
      00000000000000000000000000000000FFC43E7C23FF00000000000000000000
      0000000000000000FF80466201FF000000000000000000000000000000000000
      FF88866111FF000000000000000000000000000000000000FF888E7111FF0000
      00000000000000000000000000000000FF898FF191FF00000000000000000000
      0000000000000000FF911C3889FF000000000000000000000000000000000000
      FF911C3889FF000000000000000000000000000000000000FF911C3889FF0000
      00000000000000000000000000000000FF898E7191FF00000000000000000000
      0000000000000000FF888FF111FF000000000000000000000000000000000000
      FF8887E111FF000000000000000000000000000000000000FF8847E211FF0000
      00000000000000000000000000000000FFC47FFE23FF00000000000000000000
      0000000000000000FFC03FFC03FF000000000000000000000000000000000000
      FFE23FFC47FF000000000000000000000000000000000000FFE1FFFF87FF0000
      00000000000000000000000000000000FFF1FFFF8FFF00000000000000000000
      0000000000000000FFF9FFFF9FFF000000000000000000000000000000000000
      FFFFFFFFFFFF000000000000000000000000000000000000FFFFFFFFFFFF0000
      00000000000000000000000000000000FFFFFFFFFFFF00000000000000000000
      0000000000000000FFFFFFFFFFFF000000000000000000000000000000000000
      FFFFFFFFFFFF000000000000000000000000000000000000FFFFFFFFFFFF0000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0FFFF0000FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFF7F00FFFFFF84FFFFFFFFFFFFFFFFF3C1FFFFFFFF
      F3C1FFFF7FFFFF0000FFFFFFFFFFFFFFFFE061C10FFFFFE061C10FFFF00000FF
      FF33FFFFFFFFFFFFFFF081C107FFFFF081C107FFC7FFFF0000F0FFFFFFFFFFFF
      FFF0408107FFFFF0408107FF8C0000FFFF8FFFC0000001FFFFF0000007FFFFF0
      000007FFF80000000007FF80000001FFFFF0004207FFFFF0004207FFD0000000
      0005FF80000001FFFFE0104007FFFFE0104007FFB00000000007FF8FFFFFF1FF
      FF800000103FFF800000103F100000000001FFCE000031FFFF000C00001FFF00
      0C00001FE00000000003FFC6000031FFFF000000001FFF000000001FA02FB002
      5E02FFC7FFFFF1FFFF000800201FFF000800201F4078C001D303FC070000701F
      FF000C00207FFF000C00207FA0334000E100F8070000600FFF80000000FFFF80
      000000FFA000C0E08101F1E3FFFFE387FF08000001FFFF08000001FF80800010
      0081F3E18000E7C7FF00000001FFFF00000001FFE00800100880F3F10000E7C7
      FF00000000FFFF00000000FFA00084100900F3F18000C7C7F0000000003FF000
      0000003F418306000081F3F0000007C7F0000000001FF0000000001F40610100
      8101F3F000000FC7F00003E0000FF0000000000F801780808701F3F800000FC7
      E0000FFC000FE000380E000F803CC0016A42F3FFFFFFFFC7C0001E1C000FC000
      381E000F600B60009603F3FFFFFFBFC7C000381C000FC000381E000FC078A000
      AD02F3FFFFFFFFC7C000701C000FC000387C000F502E921E5A05F3FFFFFFFFC7
      C000701C000FC0003FF0000F601965961404F30FFFFFFFC7C000601C000FC000
      3FF0000FD03248058403F30FFFFFFFC7E00060FC000FE0003FF8000F70257003
      C00CF1FFFFFFFFC7F80060FC001FF80038F8001F3006C200C009F0000000000F
      F8007000001FF800383C001F5C0950038414F8000000000FFC007000001FFC00
      381C001FB002E8034016FE000000007FFF003000003FFF00383C003FFF025B05
      0032FF03FFFFC07FFFE0380003FFFFE0387C03FFFF0004110017FF03FFFFC0FF
      FFE01E1807FFFFE03FF807FFFF80022800B5FF83FFFFC1FFFFE007F807FFFFE0
      3FF007FFFF8000200269FFF3FFFFC7FFFFE0006007FFFFE03FC007FFFF600000
      02DEFFF3FFFFC7FFFFF000000FFFFFF000000FFFFF9800000D36FFF3FFFFC7FF
      FFF800001FFFFFF800001FFFFFA200006CBDFFF1FFFFC7FFFFFC00003FFFFFFC
      00003FFFFFB4C001BAA6FFF0000007FFFFFF00007FFFFFFF00007FFFFFFFFFFF
      FFFFFFF000000FFFFFFFC000FFFFFFFFC000FFFFFFFFFFFFFFFFFFFC00003FFF
      FFFFE007FFFFFFFFE007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA7FFFFFFFFF
      FA7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFBFFFFFFEFFFFFFFFF3C1FFFFFFFFFFFFFFFFFFFFF80FFFFFFFFF01FC
      7FFFFFE061C10FFFFFFFC07FFFFFFFFFE001FFFFE7FC001B9FF7FFF081C107FF
      FFFF801FFFFFFFFF8001FFFFE7F000078FEFFFF0408107FFFFFF000FFFFFFFFF
      8001FFFFEFC00003C7DFFFF0000007FFFFFE1F0FFFFFFFFF0000FFFFFF807801
      C13FFFF0004207FFFFFE3F97E03FFFFF00007FFFFE03FE00F07FFFE0104007FF
      FFFC3FC7C4CFFFFE0000FFFFFE0FFE60787FFF800000103FFFFC7FD78007FFFE
      00007FFFFC1FFCF0381FFF000C00001FFFFC7FC70F93FFFE00007FFFF83FFBF8
      370FFF000000001FFFFC7FC71FC3FFFE0000FFFFF870E07C0F87FF000800201F
      FFFC7FC71FE3FFFE00007FFFF870603E01C7FF000C00207FFFFFFF861FE3FFFF
      0000FFFFE0F8403C007FFF80000000FFFFFFFE0E5FE3FFFF0000FFFFF0F80238
      003FFF08000001FF8000009E5FEBFFFF8001FFFFF0FC0030801FFF00000001FF
      8000000603EBFFFFC001FFFFE1FC00310007FF00000000FF8000008707D3FFFF
      E001FFFFE1F800620007F0000000003FFFF0FF860F07FFFFE000FFFFE1E000E0
      000FF0000000001F80000000004FFFFFE000FFFFE1C003C00007F0000180000F
      8FF003801B1FFFFFE000FFFFE1C001800007E0000180000F80000000007FFFFF
      E001FFFFE0C401C00007C0000180000FFFF0C180FFFFFFFFE001FFFFF0C021C0
      0007C0000180000F80000000001FFFFFE3C1FFFFF0C06080000FC0000180000F
      80000000278FFFFFE3C3FFFFF06070E0000FC0000180000FC00000000007FFFF
      E3C0FFFFF071E7E0000FC0000180000FFFF0C1860F83FFFFE3C0FFFFE83FDFC0
      0017E0000180000F8000000707CBFFFFE3C0FFFF9C1F3F80003FF8000180001F
      8000000603EBFFFFE3C7FFFF3C0F3F00003FF8000180001F8000000E5FE3FFFF
      E3C1FFFFDE06BF00007FFC000180001FFFFFFF2E1FE3FFFFE3C1FFFFEF01DE00
      00F7FF000180003FFFFE7F969FEBFFFFE3C1FFFFF780040000EFFFE0018003FF
      FFFC7FC71FEBFFFFE1C7FFFFF9C0000001DFFFE03FFC07FFFFFC7FC70FC3FFFF
      E1C0FFFFFED00000017FFFE03FFC07FFFFFC7FD78307FFFFE1C07FFFFFFC0000
      037FFFE0000007FFFFFC7FC7800FFFFFE1C0FFFFFFFFFF8007FFFFF000000FFF
      FFFC3FC7E01FFFFFE1C7FFFFFFFFFD80C3FFFFF800001FFFFFFE1F87F87FFFFF
      E3C7FFFFFFFFFFC0C7FFFFFC00003FFFFFFE0E0FFFFFFFFFE107FFFFFFFFFFE1
      CFFFFFFF00007FFFFFFF001FFFFFFFFFE00FFFFFFFFFFFE18FF7FFFFC000FFFF
      FFFF813FFFFFFFFFF01FFFFFFFFFFFF1BFFFFFFFE007FFFFFFFFE0FFFFFFFFFF
      FC3FFFFFFFFFFFF3FFFFFFFFFA7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFE3FFFFFFFFFFFFFFF8FFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFE3FFFFFFFFFFFFFFF87FFFFFFFFFFFFFFFFFFFFFFFFFFFFF807FFFFF000
      00000003FFFFFFFFFFFFFFFFFFFFFFFFFFFF8000FFFFF00000000003F8000000
      000FFFFFFFFFFFFFFFFC380E3FFFF3FFFFFFFF8FF0000000000FFFFFFFFFFFFF
      FFF8F8078FFFF3FFFFFFFF9FF0000000000FFFFFC03FFFFFFFE34000E3FFF3FF
      FFFFFFFFF0000000000FFFFF801FFFFFFFE7381E307FF3DFFFFFFFFFF0000000
      000FFFFF000FFFFFFF8C7006987FF307FFFFFFFFF0000000000FFFFE0F07F87F
      FFB9C001C07FF307FFFFFFFFF0000000000FFFFE1F87E03FFF370C0C603FF307
      FFFFFFFFF0000000000FFFFE3FC7801FFE6E3007013FF307FFFC7FFFF0000000
      000FFFFE3FC7020FFCCCE401819FF303FFF83FFFF0000000000FFFFE3FC71F07
      FD999C1C848FF3E1FFF83FFFF003F00C400FFFFE3FC61F87F9B30006264FF3F0
      FFF03FFFF007F80C600FFFFE7F863FC7F9360012324FF3F8FF803FFFF007FC1C
      700FFFFFFF0E3FC7FB2600009B6FF3F87E003FFFF0001C1C700FC000000E3FC7
      F36C0000C927F3FC381E1FFFF0001C1C700FC000001E3FC7F249000049A7F3FE
      007F1FFFF0033C1C700FE000007F7F87F6DB00004DB7F3FF01FF1FFFF007FC1F
      F00FFFFFFFFFDE0FF60100026DB7F3FF07FF8FFFF003F80FE00FC0000000000F
      F600000025B7F3FF07FF8FFFF001F007C00FC0000000001F800000000000F3FF
      0FFFC7FFF0000000000FC0000000007F860000002490F3FFFFFFC7FFF0000000
      000FE000000001FF860000002DB1F3FFFFFFE3FFF0000000000FC0000000003F
      F610000000B7F3FFFFFFE3FFF001E007800FC0000000001FF6C0000000B7F3FF
      FFFFF1FFF007F00FE00FE0000010000FF240000000A7F3FFFFFFF07FF007F81F
      E00FE00000FFFF07F26000000027F3FFFFFFF07FF00F3C1EF00FC000003E3F87
      FB200000016FF3FFFFFFF07FF00E3C3C000FC000001E3FC7F9100000004FF3FF
      FFFFF07FF00F3C3C000FFFFFFE0E3FC7F9B0000C02CFF3FFFFFFF0FFF00F381F
      F00FFFFF3F063FC7FC800018049FF3FFFFFFFFFFF007381FE00FFFFE3F861FC7
      FCC00002019FF3FFFFFFFFFFF003300FE00FFFFE3FC61F87FE60401F0B3FF3FF
      FFFFFFFFF0002003800FFFFE3FC7070FFF20137C367FF3FFFFFFFFFFF0000000
      000FFFFE3FC7801FFF18C161C4FFF3FFFFFFFFFFF0000000000FFFFE1F87C01F
      FF8C700F89FFF3FFFFFFFFFFF0000000000FFFFE0F87E0FFFFC71F7E73FFF3FF
      FFFFFFFFF0000000000FFFFF000FFFFFFFE3C161E7FFC0FFFFFFFFFFF0000000
      000FFFFF001FFFFFFFF8F00F8FFFC0FFFFFFFFFFF0000000000FFFFFC03FFFFF
      FFFC1F7C3FFFC0FFFFFFFFFFF0000000000FFFFFF0FFFFFFFFFF8000FFFFE1FF
      FFFFFFFFF0000000001FFFFFFFFFFFFFFFFFF80FFFFFF3FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFE3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFE3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PSD: TPrinterSetupDialog
    Left = 615
    Top = 245
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 615
    Top = 298
  end
  object ImageList16: TImageList
    Left = 693
    Top = 180
    Bitmap = {
      494C010105000800600010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      00000000002E00000098000000D9000000FF000000FF000000D9000000980000
      002E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000A0000
      0099000000FF000000D300000080000000660000006600000080000000D40000
      00FF000000990000000A00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000A000000C20000
      00F1000000550000000000000000000000000000000000000000000000000000
      0056000000F2000000C20000000A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000099000000F10000
      0024000000000000000000000000000000520000005200000000000000000000
      000000000025000000F200000099000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000002E000000FF000000550000
      00000000000000000000000000000000009B0000009B00000000000000000000
      00000000000000000056000000FF0000002E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000098000000D3000000000000
      00000000000000000000000000000000009B0000009B00000000000000000000
      00000000000000000000000000D4000000980000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000D900000080000000000000
      00000000000000000000000000000000009B0000009B00000000000000000000
      0000000000000000000000000081000000D90000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF00000065000000000000
      00000000000000000000000000000000009B0000009B00000000000000000000
      0000000000000000000000000066000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF00000065000000000000
      00000000000000000000000000000000009B0000009B00000000000000000000
      0000000000000000000000000066000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000D900000080000000000000
      00000000000000000000000000000000008F0000008F00000000000000000000
      0000000000000000000000000080000000D90000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000098000000D3000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000D3000000980000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000002E000000FF000000550000
      0000000000000000000000000000000000520000005200000000000000000000
      00000000000000000055000000FF0000002E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000099000000F10000
      0024000000000000000000000000000000520000005200000000000000000000
      000000000024000000F100000098000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000A000000C20000
      00F1000000550000000000000000000000000000000000000000000000000000
      0055000000F1000000C20000000A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000A0000
      0099000000FF000000D300000080000000650000006500000080000000D30000
      00FF000000980000000A00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000002E00000098000000D9000000FF000000FF000000D9000000980000
      002E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000290000007E0000
      00B5000000D3000000FD000000FF000000FF000000FD000000D3000000B60000
      007E000000290000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000089000000A2000000A100000089000000000000
      0000000000000000000000000000000000000000000000000007000000730000
      00AA000000AB000000AB000000AB000000AB000000AB000000AB000000AB0000
      00AB000000AA0000007300000007000000000000008E000000D80000007D0000
      003E0000001400000000000000060000000600000000000000140000003E0000
      007C000000D80000008E00000000000000000000000000000000000000000000
      00000000000000000000000000610000007F0000007F00000061000000000000
      00000000000000000000000000000000000000000000000000000000000A0000
      00660000001E00000000000000A10000000000000000000000A1000000000000
      001E000000660000000A00000000000000000000000000000073000000F30000
      00AE000000AB000000AB000000AB000000AB000000AB000000AB000000AB0000
      00AB000000AE000000F30000007300000000000000F500000049000000950000
      00CC000000FB0000009000000051000000510000000000000000000000000000
      000000000008000000F500000000000000000000000000000000000000000000
      00000000000000000000000000AD0000007F0000007F000000AD000000000000
      000000000000000000000000000000000000000000000000000A000000B60000
      005A000000B3000000AB0000008E00000000000000000000008E000000AB0000
      00B20000005A000000B60000000A0000000000000000000000AA000000AE0000
      0001000000000000000000000000000000000000000000000000000000000000
      000000000001000000AE000000AA00000000000000FF000000C2000000600000
      00250000000F000000330000003300000033000000330000000F000000000000
      000000000000000000EF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000990000009900000000000000000000
      00000000000000000000000000000000000000000000000000660000005A0000
      00000000000A0000001900000000000000000000000000000000000000190000
      000A000000000000005A000000660000000000000000000000AB000000AB0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000AB000000AB00000000000000F600000067000000B80000
      00F0000000D7000000CC000000CA000000CA000000CC000000D7000000F10000
      00B800000067000000F300000000000000000000000000000000000000000000
      0000000000000000000000000000000000990000009900000000000000000000
      000000000000000000000000000000000000000000000000001E000000B20000
      000A00000000000000000000000B0000004A0000004A0000000B000000000000
      00000000000A000000B30000001E0000000000000000000000AA000000AA0000
      0000000000000000000000000002000000660000006600000002000000000000
      000000000000000000AA000000AA00000000000000FF000000A1000000450000
      0012000000330000002300000028000000280000000000000000000000040000
      0045000000A2000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000990000009900000000000000000000
      0000000000000000000000000000000000000000000000000000000000AB0000
      0019000000000000003D000000B80000006900000069000000B80000003D0000
      000000000019000000AB00000000000000000000000000000059000000590000
      0000000000000000000200000074000000FC000000FC00000074000000020000
      000000000000000000590000005900000000000000F300000085000000DC0000
      00E3000000C50000005D0000003D0000003D0000000000000000000000000000
      000000000000000000F000000000000000000000000000000000000000000000
      0000000000000000000000000000000000990000009900000000000000000000
      00000000002800000033000000160000000000000089000000A10000008E0000
      00000000000B000000B800000009000000000000000000000009000000B80000
      000B000000000000008E000000A1000000890000000000000000000000000000
      00000000000200000074000000F8000000ED000000ED000000F8000000740000
      000200000000000000000000000000000000000000FF000000880000001F0000
      0030000000580000006600000065000000650000006600000058000000300000
      000100000000000000EF00000000000000000000000000000000000000000000
      00000000000000000000000000000000009900000099000000000000003B0000
      006B0000008B000000670000005300000000000000A100000000000000000000
      00000000004A0000006900000000000000000000000000000000000000690000
      004A000000000000000000000000000000A20000000000000000000000000000
      00000000003E000000F700000073000000AC000000AC00000073000000F80000
      003E00000000000000000000000000000000000000F6000000A5000000EE0000
      00C5000000990000008D0000006B0000006B0000008D00000099000000C50000
      00EE000000A5000000F600000000000000000000000000000000000000000000
      007A0000007F00000061000000000000009900000099000000D9000000D90000
      00BD000000520000008C0000000600000000000000A100000000000000000000
      00000000004A0000006900000000000000000000000000000000000000690000
      004A000000000000000000000000000000A10000000000000000000000000000
      00000000000C0000003E00000002000000AB000000AB000000020000003E0000
      000C00000000000000000000000000000000000000FC0000005D000000220000
      00500000006C000000590000003D0000003D0000000000000000000000000000
      000A0000005D000000FC00000000000000000000000000000000000000000000
      00CC00000099000000B800000000000000990000009900000033000000990000
      00A30000003300000029000000000000000000000089000000A10000008E0000
      00000000000B000000B800000009000000000000000000000009000000B80000
      000B000000000000008E000000A1000000890000000000000000000000000000
      0000000000000000000000000000000000AB000000AB00000000000000000000
      000000000000000000000000000000000000000000F8000000C4000000E10000
      00A40000007B0000003D00000028000000280000000000000000000000000000
      000000000000000000EF00000000000000000000000000000000000000160000
      00D9000000B2000000C7000000920000007F0000007F0000007F0000007F0000
      007F0000007F0000007A00000000000000000000000000000000000000AB0000
      0019000000000000003D000000B80000006900000069000000B80000003D0000
      000000000019000000AB00000000000000000000000000000000000000000000
      0000000000000000000000000000000000AB000000AB00000000000000000000
      000000000000000000000000000000000000000000FA000000410000003A0000
      006B000000990000009D000000BF000000C00000009E000000990000006C0000
      003900000000000000EF000000000000000000000000000000000000007F0000
      006600000066000000660000004A000000330000003300000033000000330000
      0033000000330000007F0000000000000000000000000000001E000000B30000
      000A00000000000000000000000B0000004A0000004A0000000B000000000000
      00000000000A000000B20000001E000000000000000000000000000000000000
      0000000000000000000000000000000000AB000000AB00000000000000000000
      000000000000000000000000000000000000000000F9000000E7000000BC0000
      0085000000650000003A00000033000000330000003A00000065000000840000
      00BB000000E7000000F900000000000000000000000000000007000000400000
      00840000009D000000570000005D000000B8000000B80000007C000000BF0000
      00B2000000A400000016000000000000000000000000000000660000005A0000
      00000000000A0000001900000000000000000000000000000000000000190000
      000A000000000000005A00000066000000000000000000000000000000000000
      0000000000000000000000000000000000AA000000AA00000000000000000000
      000000000000000000000000000000000000000000FE0000002C000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000002F000000FF0000000000000000000000000000006C000000830000
      00C2000000B2000000D9000000830000005200000028000000CD000000800000
      007F000000CA0000001D0000000000000000000000000000000A000000B60000
      005A000000B3000000AB0000008E00000000000000000000008E000000AB0000
      00B30000005A000000B60000000A000000000000000000000000000000000000
      0000000000000000000000000000000000590000005900000000000000000000
      0000000000000000000000000000000000000000008E000000D80000007D0000
      003D0000001300000000000000000000000000000000000000140000003E0000
      007C000000D80000008E0000000000000000000000000000001F0000006D0000
      0033000000330000003D0000006D000000070000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000A0000
      00660000001E00000000000000A10000000000000000000000A1000000000000
      001E000000660000000A00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000290000007E0000
      00B5000000D3000000FD000000FF000000FF000000FD000000D3000000B60000
      007E000000290000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000089000000A1000000A100000089000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00F00F000000000000C003000000000000
      87E10000000000008E710000000000001E780000000000003E7C000000000000
      3E7C0000000000003E7C0000000000003E7C0000000000003E7C000000000000
      3FFC0000000000001E780000000000008E7100000000000087E1000000000000
      C003000000000000F00F000000000000FFFF8007FFFFFC3F80010483FC3FC5A3
      800100F3FC3F81818FF1003BFE7F93C99FF90003FE7F8C319C3900C3FE7FC813
      981900FBFE711188F00F000BFE4173CEF00F0003E20173CEF00F00E3E2031188
      FE7F00FBC003C813FE7F000BC0038C31FE7F0003800393C9FE7F3FF380038181
      FE7F078380FFC5A3FFFF8007FFFFFC3F00000000000000000000000000000000
      000000000000}
  end
end
