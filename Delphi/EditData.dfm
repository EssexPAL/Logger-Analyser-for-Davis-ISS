object DataEditForm: TDataEditForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Data Edit'
  ClientHeight = 361
  ClientWidth = 205
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
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 33
    Width = 199
    Height = 214
    Margins.Bottom = 0
    Align = alClient
    BevelInner = bvLowered
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 189
    object vstEdit: TVirtualStringTree
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 189
      Height = 204
      Align = alClient
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = 1
      Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      TabOrder = 0
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toUseBlendedImages, toFullVertGridLines]
      OnEdited = vstEditEdited
      OnGetText = vstEditGetText
      OnNewText = vstEditNewText
      ExplicitWidth = 179
      Columns = <
        item
          Alignment = taRightJustify
          CaptionAlignment = taCenter
          Options = [coDraggable, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
          Position = 0
          Width = 100
          WideText = 'Measurement'
        end
        item
          Alignment = taRightJustify
          CaptionAlignment = taRightJustify
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
          Position = 1
          Width = 75
          WideText = 'Value'
        end>
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 250
    Width = 199
    Height = 44
    Align = alBottom
    BevelInner = bvLowered
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 189
    object buSave: TButton
      AlignWithMargins = True
      Left = 107
      Top = 8
      Width = 75
      Height = 28
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 15
      Margins.Bottom = 6
      Align = alRight
      Caption = 'Save'
      ModalResult = 1
      TabOrder = 0
      OnClick = buSaveClick
      ExplicitLeft = 97
    end
    object buCancel: TButton
      AlignWithMargins = True
      Left = 17
      Top = 8
      Width = 75
      Height = 28
      Margins.Left = 15
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alLeft
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 199
    Height = 27
    Margins.Bottom = 0
    Align = alTop
    BevelInner = bvLowered
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 2
    ExplicitWidth = 189
    object DDTLabel: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 189
      Height = 16
      Align = alTop
      Alignment = taCenter
      Caption = 'DDTLabel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 54
    end
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 300
    Width = 199
    Height = 58
    Align = alBottom
    BorderStyle = bsNone
    Color = clMoneyGreen
    Enabled = False
    Lines.Strings = (
      'To edit a value click once on the value '
      'and then a second time to enter edit '
      'mode.  Press Save to permanently '
      'save the changes.')
    ReadOnly = True
    TabOrder = 3
    ExplicitWidth = 189
  end
end
