object CatalogForm: TCatalogForm
  Left = 0
  Top = 0
  Caption = 'Dementor Library'
  ClientHeight = 661
  ClientWidth = 1084
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 21
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 1084
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 1080
    object AddButton: TButton
      Left = 10
      Top = 10
      Width = 40
      Height = 40
      ImageIndex = 0
      TabOrder = 0
      OnClick = AddButtonClick
    end
    object EditButton: TButton
      Left = 60
      Top = 10
      Width = 40
      Height = 40
      ImageIndex = 1
      TabOrder = 1
      OnClick = EditButtonClick
    end
    object DeleteButton: TButton
      Left = 110
      Top = 10
      Width = 40
      Height = 40
      ImageIndex = 2
      TabOrder = 2
      OnClick = DeleteButtonClick
    end
    object RefreshButton: TButton
      Left = 160
      Top = 10
      Width = 40
      Height = 40
      ImageIndex = 3
      TabOrder = 3
      OnClick = RefreshButtonClick
    end
    object SettingsButton: TButton
      Left = 210
      Top = 10
      Width = 40
      Height = 40
      ImageIndex = 4
      TabOrder = 4
      OnClick = SettingsButtonClick
    end
  end
  object SearchPanel: TPanel
    Left = 0
    Top = 60
    Width = 1084
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 1080
    object SearchLabel: TLabel
      Left = 10
      Top = 10
      Width = 47
      Height = 21
      Caption = #1055#1086#1080#1089#1082':'
    end
    object SearchEdit: TEdit
      Left = 60
      Top = 8
      Width = 300
      Height = 29
      TabOrder = 0
      TextHint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
      OnChange = SearchEditChange
    end
    object QuickFilterPanel: TPanel
      Left = 360
      Top = 10
      Width = 300
      Height = 25
      TabOrder = 1
      object QuickFilterComboBox: TComboBox
        Left = 0
        Top = 0
        Width = 150
        Height = 29
        Style = csDropDownList
        TabOrder = 0
        OnChange = QuickFilterComboBoxChange
      end
      object QuickFilterButton: TButton
        Left = 160
        Top = 0
        Width = 40
        Height = 25
        Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
        TabOrder = 1
        OnClick = QuickFilterButtonClick
      end
    end
  end
  object FiltersPanel: TPanel
    Left = 0
    Top = 100
    Width = 200
    Height = 561
    Align = alLeft
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    ExplicitHeight = 560
    object FiltersLabel: TLabel
      Left = 10
      Top = 10
      Width = 71
      Height = 21
      Caption = #1060#1080#1083#1100#1090#1088#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 14935012
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object AuthorsFilterComboBox: TComboBox
      Left = 10
      Top = 40
      Width = 180
      Height = 29
      Style = csDropDownList
      TabOrder = 0
      OnChange = AuthorsFilterComboBoxChange
    end
    object LanguagesFilterComboBox: TComboBox
      Left = 10
      Top = 80
      Width = 180
      Height = 29
      Style = csDropDownList
      TabOrder = 1
      OnChange = LanguagesFilterComboBoxChange
    end
    object SeriesFilterComboBox: TComboBox
      Left = 10
      Top = 120
      Width = 180
      Height = 29
      Style = csDropDownList
      TabOrder = 2
      OnChange = SeriesFilterComboBoxChange
    end
    object FormatsFilterComboBox: TComboBox
      Left = 10
      Top = 160
      Width = 180
      Height = 29
      Style = csDropDownList
      TabOrder = 3
      OnChange = FormatsFilterComboBoxChange
    end
    object PublishersFilterComboBox: TComboBox
      Left = 10
      Top = 200
      Width = 180
      Height = 29
      Style = csDropDownList
      TabOrder = 4
      OnChange = PublishersFilterComboBoxChange
    end
    object RatingsFilterComboBox: TComboBox
      Left = 10
      Top = 240
      Width = 180
      Height = 29
      Style = csDropDownList
      TabOrder = 5
      OnChange = RatingsFilterComboBoxChange
    end
    object TagsFilterComboBox: TComboBox
      Left = 10
      Top = 280
      Width = 180
      Height = 29
      Style = csDropDownList
      TabOrder = 6
      OnClick = TagsFilterComboBoxClick
    end
  end
  object MainPanel: TPanel
    Left = 200
    Top = 100
    Width = 684
    Height = 561
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 3
    ExplicitWidth = 680
    ExplicitHeight = 560
    object BooksView: TListView
      Left = 0
      Top = 0
      Width = 684
      Height = 561
      Align = alClient
      Columns = <
        item
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          Width = 200
        end
        item
          Caption = #1040#1074#1090#1086#1088'('#1099')'
          Width = 150
        end
        item
          Caption = #1044#1072#1090#1072
          Width = 100
        end
        item
          Caption = #1054#1094#1077#1085#1082#1072
        end
        item
          Caption = #1048#1079#1076#1072#1090#1077#1083#1100#1089#1090#1074#1086
          Width = 100
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnColumnClick = BooksViewColumnClick
      OnDblClick = BooksViewDblClick
      OnSelectItem = BooksViewSelectItem
      ExplicitWidth = 680
      ExplicitHeight = 560
    end
  end
  object RightPanel: TPanel
    Left = 884
    Top = 100
    Width = 200
    Height = 561
    Align = alRight
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 4
    ExplicitLeft = 880
    ExplicitHeight = 560
    object PreviewPanel: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 561
      Align = alClient
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      ExplicitHeight = 560
      object PreviewImage: TImage
        Left = 10
        Top = 10
        Width = 180
        Height = 300
        Stretch = True
      end
      object PreviewMemo: TMemo
        Left = 10
        Top = 320
        Width = 180
        Height = 232
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 32
    Top = 80
    object FileMenu: TMenuItem
      Caption = '&'#1060#1072#1081#1083
      object AddMenuItem: TMenuItem
        Caption = '&'#1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1085#1080#1075#1091
        ShortCut = 16462
        OnClick = AddButtonClick
      end
      object EditMenuItem: TMenuItem
        Caption = '&'#1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1082#1085#1080#1075#1091
        ShortCut = 16453
        OnClick = EditButtonClick
      end
      object DeleteMenuItem: TMenuItem
        Caption = '&'#1059#1076#1072#1083#1080#1090#1100' '#1082#1085#1080#1075#1091
        ShortCut = 16452
        OnClick = DeleteButtonClick
      end
      object FileSeparatorItem: TMenuItem
        Caption = '-'
      end
      object ExitMenuItem: TMenuItem
        Caption = #1042'&'#1099#1093#1086#1076
        ShortCut = 32883
        OnClick = ExitMenuItemClick
      end
    end
    object ViewMenu: TMenuItem
      Caption = '&'#1042#1080#1076
      object RefreshMenuItem: TMenuItem
        Caption = '&'#1054#1073#1085#1086#1074#1080#1090#1100
        ShortCut = 116
        OnClick = RefreshButtonClick
      end
      object ViewSeparatorItem: TMenuItem
        Caption = '-'
      end
      object StatusBarMenuItem: TMenuItem
        Caption = #1057#1090#1088#1086#1082#1072' '#1089#1086#1089#1090#1086#1103#1085#1080#1103
        Checked = True
        OnClick = StatusBarMenuItemClick
      end
    end
    object ToolsMenu: TMenuItem
      Caption = '&'#1048#1085#1089#1090#1088#1091#1084#1077#1085#1090#1099
      object SettingsMenuItem: TMenuItem
        Caption = '&'#1053#1072#1089#1090#1088#1086#1081#1082#1080'...'
        ShortCut = 16467
        OnClick = SettingsButtonClick
      end
      object SeriesMenuItem: TMenuItem
        Caption = '&'#1057#1077#1088#1080#1080'...'
        ShortCut = 16468
        OnClick = SeriesMenuItemClick
      end
      object AuthorsMenuItem: TMenuItem
        Caption = '&'#1040#1074#1090#1086#1088#1099'...'
        ShortCut = 16469
        OnClick = AuthorsMenuItemClick
      end
    end
    object HelpMenu: TMenuItem
      Caption = '&'#1057#1087#1088#1072#1074#1082#1072
      object AboutMenuItem: TMenuItem
        Caption = '&'#1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
        OnClick = AboutMenuItemClick
      end
    end
  end
  object ImageList: TImageList
    Left = 32
    Top = 144
  end
end
