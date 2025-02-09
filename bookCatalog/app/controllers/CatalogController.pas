unit CatalogController;

interface

uses
  BookModel, // Модуль для управления коллекцией книг
  BookTypes, // Модуль с типами, связанными с книгами
  ListTypes, // Модуль с типами, связанными со списками, включая TListFilter
  System.Generics.Collections, // Коллекции общего назначения
  System.SysUtils,   // Системные утилиты
  System.StrUtils;   // Утилиты для работы со строками

type
  /// <summary>
  /// Класс TCatalogController управляет каталогом книг.
  /// </summary>
  TCatalogController = class
  private
    FBookModel: TBookModel;
    FSelectedBook: TBookMetadata;
  public
    /// <summary>
    /// Конструктор класса TCatalogController.
    /// Инициализирует экземпляр TBookModel.
    /// </summary>
    constructor Create;

    /// <summary>
    /// Деструктор класса TCatalogController.
    /// Освобождает экземпляр TBookModel.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Возвращает выбранную книгу.
    /// </summary>
    /// <returns>TBookMetadata объект, если книга выбрана; иначе nil.</returns>
    function GetSelectedBook: TBookMetadata;

    /// <summary>
    /// Редактирует выбранную книгу.
    /// </summary>
    /// <param name="NewBookData">Новые данные для книги.</param>
    procedure EditBook(const NewBookData: TBookMetadata);

    /// <summary>
    /// Удаляет выбранную книгу.
    /// </summary>
    procedure DeleteBook;

    /// <summary>
    /// Загружает книги из хранилища.
    /// </summary>
    procedure LoadBooks;

    /// <summary>
    /// Применяет фильтры для фильтрации списка книг.
    /// </summary>
    /// <param name="Filters">Фильтры для применения.</param>
    procedure ApplyFilters(const Filters: TListFilter);

    /// <summary>
    /// Ищет книги по заданному тексту.
    /// </summary>
    /// <param name="SearchText">Текст для поиска.</param>
    /// <returns>TObjectList с найденными книгами.</returns>
    function SearchBooks(const SearchText: string): TObjectList<TBookMetadata>;
  end;

implementation

{ TCatalogController }

constructor TCatalogController.Create;
begin
  inherited Create;
  FBookModel := TBookModel.Create;
end;

destructor TCatalogController.Destroy;
begin
  FBookModel.Free;
  inherited Destroy;
end;

function TCatalogController.GetSelectedBook: TBookMetadata;
begin
  Result := FSelectedBook;
end;

procedure TCatalogController.EditBook(const NewBookData: TBookMetadata);
begin
  if Assigned(FSelectedBook) then
  begin
    FSelectedBook.Title := NewBookData.Title;
    FSelectedBook.Author := NewBookData.Author;
    FSelectedBook.Year := NewBookData.Year;
    // Добавьте другие поля, которые нужно обновить
  end
  else
    raise Exception.Create('No book is selected for editing');
end;

procedure TCatalogController.DeleteBook;
begin
  if Assigned(FSelectedBook) then
  begin
    FBookModel.RemoveBook(FSelectedBook);
    FSelectedBook := nil;
  end
  else
    raise Exception.Create('No book is selected for deletion');
end;

procedure TCatalogController.LoadBooks;
begin
  // Загружаем книги из хранилища
  // Предполагается, что BookModel имеет метод для загрузки книг
  // Например, FBookModel.LoadBooksFromStorage;
end;

procedure TCatalogController.ApplyFilters(const Filters: TListFilter);
begin
  // Применяем фильтры к списку книг
  // Реализация зависит от вашей логики фильтрации
end;

function TCatalogController.SearchBooks(const SearchText: string): TObjectList<TBookMetadata>;
var
  SearchResults: TObjectList<TBookMetadata>;
  Book: TBookMetadata;
begin
  SearchResults := TObjectList<TBookMetadata>.Create;
  try
    for Book in FBookModel.GetAllBooks do
    begin
      if AnsiContainsText(Book.Title, SearchText) or
         AnsiContainsText(Book.Author, SearchText) then
      begin
        SearchResults.Add(Book);
      end;
    end;
    Result := SearchResults;
  except
    SearchResults.Free;
    raise;
  end;
end;

end.
