unit catalog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Menus, Vcl.ExtCtrls, Vcl.ImgList, System.ImageList, Vcl.Imaging.jpeg,
  System.Types,
  System.IOUtils, System.Generics.Collections,
  Logger, {Config, I18N.Manager, I18N.Types,}
{  Model,} View{, CatalogController};

type
  TCatalogForm = class(TCatalogView)
    // Элементы управления
    TopPanel: TPanel;
    AddButton: TButton;
    EditButton: TButton;
    DeleteButton: TButton;
    RefreshButton: TButton;
    SettingsButton: TButton;
    SearchPanel: TPanel;
    SearchLabel: TLabel;
    SearchEdit: TEdit;
    QuickFilterPanel: TPanel;
    QuickFilterComboBox: TComboBox;
    QuickFilterButton: TButton;
    FiltersPanel: TPanel;
    FiltersLabel: TLabel;
    AuthorsFilterComboBox: TComboBox;
    LanguagesFilterComboBox: TComboBox;
    SeriesFilterComboBox: TComboBox;
    FormatsFilterComboBox: TComboBox;
    PublishersFilterComboBox: TComboBox;
    RatingsFilterComboBox: TComboBox;
    TagsFilterComboBox: TComboBox;
    MainPanel: TPanel;
    BooksView: TListView;
    RightPanel: TPanel;
    PreviewPanel: TPanel;
    PreviewImage: TImage;
    PreviewMemo: TMemo;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    AddMenuItem: TMenuItem;
    EditMenuItem: TMenuItem;
    DeleteMenuItem: TMenuItem;
    FileSeparatorItem: TMenuItem;
    ExitMenuItem: TMenuItem;
    ViewMenu: TMenuItem;
    RefreshMenuItem: TMenuItem;
    ViewSeparatorItem: TMenuItem;
    StatusBarMenuItem: TMenuItem;
    ToolsMenu: TMenuItem;
    SettingsMenuItem: TMenuItem;
    SeriesMenuItem: TMenuItem;
    AuthorsMenuItem: TMenuItem;
    HelpMenu: TMenuItem;
    AboutMenuItem: TMenuItem;
    ImageList: TImageList;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure SearchEditChange(Sender: TObject);
    procedure QuickFilterComboBoxChange(Sender: TObject);
    procedure QuickFilterButtonClick(Sender: TObject);
    procedure AuthorsFilterComboBoxChange(Sender: TObject);
    procedure LanguagesFilterComboBoxChange(Sender: TObject);
    procedure SeriesFilterComboBoxChange(Sender: TObject);
    procedure FormatsFilterComboBoxChange(Sender: TObject);
    procedure PublishersFilterComboBoxChange(Sender: TObject);
    procedure RatingsFilterComboBoxChange(Sender: TObject);
    procedure TagsFilterComboBoxClick(Sender: TObject);
    procedure BooksViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure BooksViewDblClick(Sender: TObject);
    procedure BooksViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure StatusBarMenuItemClick(Sender: TObject);
    procedure SeriesMenuItemClick(Sender: TObject);
    procedure AuthorsMenuItemClick(Sender: TObject);
    procedure AboutMenuItemClick(Sender: TObject);
  private
//    FController: TCatalogController;
//    FConfig: TConfig;
//    FI18NManager: TI18NManager;
//    FModel: TBookModel;
    procedure LoadBooks;
    procedure ApplyFilters;
    procedure UpdatePreview;

    procedure FormShow(Sender: TObject); // Объявляем FormShow
    procedure SettingsButtonClick(Sender: TObject); // Объявляем SettingsButtonClick

    procedure LoadSettings; // Объявляем метод LoadSettings
    procedure LoadLanguage; // Объявляем метод LoadLanguage

  public
    { Public declarations }
  end;

var
  CatalogForm: TCatalogForm;

implementation

{$R *.dfm}

procedure TCatalogForm.FormCreate(Sender: TObject);
begin
    // Инициализация логгера
 if Assigned(Log) then
    Log.Info('Форма каталога создана.');
    // Инициализация конфигурации
//  FConfig := TConfig.Instance;
//  LoadSettings;

 // Инициализация менеджера локализации
//  FI18NManager := TI18NManager.Create;
  LoadLanguage;

  // Инициализация модели
//  FModel := TBookModel.Create;

  // Инициализация контроллера
//  FController := TCatalogController.Create(FModel, Self);

  // Загрузка данных
  LoadBooks;

end;

procedure TCatalogForm.FormDestroy(Sender: TObject);
begin
    // Освобождаем контроллер
//  if Assigned(FController) then
//    FController.Free;

  // Освобождаем модель
//  if Assigned(FModel) then
//    FModel.Free;

  // Освобождаем другие ресурсы
//  if Assigned(FI18NManager) then
//    FI18NManager.Free;

    Log.Info('Форма каталога уничтожена.'); // Логируем перед освобождением
end;

procedure TCatalogForm.FormShow(Sender: TObject);
begin
  // Код, который должен выполняться при показе формы
  if Assigned(Log) then
    Log.Info('Форма каталога показана.');
end;

procedure TCatalogForm.AddButtonClick(Sender: TObject);
begin
//  FController.AddBook;
end;

procedure TCatalogForm.EditButtonClick(Sender: TObject);
begin
//  FController.EditBook;
end;

procedure TCatalogForm.DeleteButtonClick(Sender: TObject);
begin
//  FController.DeleteBook;
end;

procedure TCatalogForm.RefreshButtonClick(Sender: TObject);
begin
//  FController.RefreshBooks;
end;

procedure TCatalogForm.SearchEditChange(Sender: TObject);
begin
//  FController.SearchBooks(SearchEdit.Text);
end;

procedure TCatalogForm.QuickFilterComboBoxChange(Sender: TObject);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.QuickFilterButtonClick(Sender: TObject);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.AuthorsFilterComboBoxChange(Sender: TObject);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.LanguagesFilterComboBoxChange(Sender: TObject);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.SeriesFilterComboBoxChange(Sender: TObject);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.FormatsFilterComboBoxChange(Sender: TObject);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.PublishersFilterComboBoxChange(Sender: TObject);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.RatingsFilterComboBoxChange(Sender: TObject);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.TagsFilterComboBoxClick(Sender: TObject);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.BooksViewColumnClick(Sender: TObject; Column: TListColumn);
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.BooksViewDblClick(Sender: TObject);
begin
//  FController.UpdatePreview;
end;

procedure TCatalogForm.BooksViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Selected then
//    FController.UpdatePreview;
end;

procedure TCatalogForm.ExitMenuItemClick(Sender: TObject);
begin
  Close;
end;

procedure TCatalogForm.StatusBarMenuItemClick(Sender: TObject);
begin
  StatusBarMenuItem.Checked := not StatusBarMenuItem.Checked;
end;

procedure TCatalogForm.SeriesMenuItemClick(Sender: TObject);
begin
  // Логика управления сериями
end;

procedure TCatalogForm.AuthorsMenuItemClick(Sender: TObject);
begin
  // Логика управления авторами
end;

procedure TCatalogForm.SettingsButtonClick(Sender: TObject);
begin
  // Код, который должен выполняться при нажатии на кнопку "Настройки"
    if Assigned(Log) then
    Log.Info('Нажата кнопка "Настройки".');
  // Например, открыть форму настроек
end;

procedure TCatalogForm.AboutMenuItemClick(Sender: TObject);
begin
  ShowMessage('Dementor Library v1.0');
end;

procedure TCatalogForm.LoadBooks;
begin
//  FController.RefreshBooks;
end;

procedure TCatalogForm.ApplyFilters;
begin
//  FController.ApplyFilters;
end;

procedure TCatalogForm.UpdatePreview;
begin
//  FController.UpdatePreview;
end;

procedure TCatalogForm.LoadSettings;
begin
//  if Assigned(FConfig) then
//  begin
//    // Загружаем настройки из конфигурации
//    FConfig.LoadConfig;
//    if Assigned(Log) then
//      Log.Info('Настройки загружены.');
//  end;
end;

procedure TCatalogForm.LoadLanguage;
begin
//  if Assigned(FI18NManager) and Assigned(FConfig) then
//  begin
//    // Загружаем язык из конфигурации
//    FI18NManager.LoadLanguage(FConfig.Language);
//    if Assigned(Log) then
//      Log.Info('Язык загружен: ' + FConfig.Language);
//  end;
end;


end.
