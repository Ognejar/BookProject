object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Library Manager'
  ClientHeight = 712
  ClientWidth = 938
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 938
    Height = 25
    Caption = 'ToolBar1'
    TabOrder = 0
    ExplicitWidth = 796
    object AddButton: TToolButton
      Left = 0
      Top = 0
      Caption = 'Add'
      OnClick = ButtonAddClick
    end
    object DeleteButton: TToolButton
      Left = 23
      Top = 0
      Caption = 'Delete'
      OnClick = ButtonDeleteClick
    end
    object EditButton: TToolButton
      Left = 46
      Top = 0
      Caption = 'Edit'
      OnClick = ButtonEditClick
    end
  end
  object PanelFilters: TPanel
    Left = 0
    Top = 25
    Width = 800
    Height = 50
    Caption = 'Filters'
    TabOrder = 1
    object LabelSearch: TLabel
      Left = 10
      Top = 15
      Width = 37
      Height = 13
      Caption = 'Search:'
    end
    object LabelFilter: TLabel
      Left = 370
      Top = 15
      Width = 28
      Height = 13
      Caption = 'Filter:'
    end
    object EditSearch: TEdit
      Left = 70
      Top = 12
      Width = 200
      Height = 21
      TabOrder = 0
    end
    object ButtonSearch: TButton
      Left = 280
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Search'
      TabOrder = 1
      OnClick = ButtonSearchClick
    end
    object ComboBoxFilter: TComboBox
      Left = 430
      Top = 12
      Width = 150
      Height = 21
      TabOrder = 2
      Items.Strings = (
        'All'
        'Title'
        'Author'
        'Year'
        'ISBN')
    end
  end
  object StringGridBooks: TStringGrid
    Left = 0
    Top = 75
    Width = 800
    Height = 500
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goRowSelect]
    TabOrder = 3
  end
  object PreviewPanel: TPanel
    Left = 0
    Top = 575
    Width = 800
    Height = 150
    Caption = 'Preview'
    TabOrder = 2
    object ImageCover: TImage
      Left = 10
      Top = 10
      Width = 100
      Height = 130
      Center = True
      Proportional = True
    end
    object LabelPreview: TLabel
      Left = 120
      Top = 10
      Width = 248
      Height = 13
      Caption = 'Preview of the selected book will be displayed here.'
    end
  end
  object MainMenu1: TMainMenu
    object File1: TMenuItem
      Caption = '&File'
      object AddBook1: TMenuItem
        Caption = '&Add Book'
        OnClick = ButtonAddClick
      end
      object DeleteBook1: TMenuItem
        Caption = '&Delete Book'
        OnClick = ButtonDeleteClick
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object EditBook1: TMenuItem
        Caption = '&Edit Book'
        OnClick = ButtonEditClick
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object Refresh1: TMenuItem
        Caption = '&Refresh'
        OnClick = Refresh1Click
      end
    end
  end
end
