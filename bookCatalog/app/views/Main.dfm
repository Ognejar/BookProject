object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Библиотека Дементора'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenuBar: TMainMenu
    object FileMenu: TMenuItem
      Caption = '&Файл'
      object ScanCatalogMenuBtn: TMenuItem
        Caption = 'Сканировать &каталог...'
        OnClick = ScanCatalogMenuBtnClick
      end
      object AddBookMenuBtn: TMenuItem
        Caption = '&Добавить книгу...'
        OnClick = AddBookMenuBtnClick
      end
      object AddAuthorMenuBtn: TMenuItem
        Caption = 'Добавить &автора...'
        OnClick = AddAuthorMenuBtnClick
      end
      object AddSeriesMenuBtn: TMenuItem
        Caption = 'Добавить &серию...'
        OnClick = AddSeriesMenuBtnClick
      end
      object AddCategoryMenuBtn: TMenuItem
        Caption = 'Добавить &категорию...'
        OnClick = AddCategoryMenuBtnClick
      end
      object ExitMenuBtn: TMenuItem
        Caption = '&Выход'
        OnClick = ExitMenuBtnClick
      end
    end
  end
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object SearchPanel: TPanel
    Left = 0
    Top = 41
    Width = 800
    Height = 41
    Align = alTop
    TabOrder = 1
    object SearchEdit: TEdit
      Left = 8
      Top = 8
      Width = 784
      Height = 21
      TabOrder = 0
      OnChange = SearchEditChange
    end
  end
  object FilterPanel: TPanel
    Left = 0
    Top = 82
    Width = 200
    Height = 518
    Align = alLeft
    TabOrder = 2
    object CategoryBox: TComboBox
      Left = 8
      Top = 8
      Width = 185
      Height = 21
      TabOrder = 0
      OnChange = CategoryBoxChange
    end
  end
  object PreviewPanel: TPanel
    Left = 600
    Top = 82
    Width = 200
    Height = 518
    Align = alRight
    TabOrder = 3
    object CoverImage: TImage
      Left = 8
      Top = 8
      Width = 185
      Height = 249
      Stretch = True
    end
    object DescriptionMemo: TMemo
      Left = 8
      Top = 263
      Width = 185
      Height = 247
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object BooksGrid: TStringGrid
    Left = 200
    Top = 82
    Width = 400
    Height = 518
    Align = alClient
    TabOrder = 4
    OnDblClick = BooksGridDblClick
  end
end