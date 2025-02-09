{*******************************************************}
{                                                       }
{    Модуль: BookStorage.pas                             }
{    Описание: Реализует логику для управления          }
{              хранением книг.                           }
{                                                       }
{    Автор: Дом Сварога                                  }
{    Версия: 1.0                                         }
{    Лицензия: Freeware                                  }
{                                                       }
{*******************************************************}

unit BookStorage; // Название модуля

interface // Начало интерфейсной секции

uses
  // Подключаемые модули
  BookModel,         // Модуль для управления коллекцией книг
  BookTypes,         // Модуль с типами, связанными с книгами
  SeriesTypes,       // Модуль с типами, связанными с сериями
  System.Generics.Collections, // Коллекции общего назначения
  System.JSON,       // Работа с JSON
  System.SysUtils,   // Системные утилиты, включая обработку исключений
  System.IOUtils;    // Утилиты для работы с файловой системой

type
  /// <summary>
  /// Класс TBookStorage управляет хранением книг.
  /// </summary>
  TBookStorage = class
  private
    /// <summary>
    /// Экземпляр TBookModel для управления коллекцией книг.
    /// </summary>
    FBookModel: TBookModel;

    /// <summary>
    /// Путь к файлу, в котором хранятся книги.
    /// </summary>
    FFilePath: string;

    /// <summary>
    /// Внутренний метод для загрузки книг из файла.
    /// </summary>
    procedure InternalLoadBooks;

    /// <summary>
    /// Внутренний метод для сохранения книг в файл.
    /// </summary>
    procedure InternalSaveBooks;
  public
    /// <summary>
    /// Конструктор класса TBookStorage.
    /// Инициализирует экземпляр TBookModel и устанавливает путь к файлу.
    /// </summary>
    /// <param name="AFilePath">Путь к файлу для хранения книг.</param>
    constructor Create(const AFilePath: string);

    /// <summary>
    /// Деструктор класса TBookStorage.
    /// Освобождает экземпляр TBookModel.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Загружает книги из файла.
    /// </summary>
    procedure LoadBooks;

    /// <summary>
    /// Сохраняет книги в файл.
    /// </summary>
    procedure SaveBooks;

    /// <summary>
    /// Добавляет книгу в коллекцию и сохраняет изменения.
    /// </summary>
    /// <param name="Book">Книга для добавления.</param>
    procedure AddBook(const Book: TBookMetadata);

    /// <summary>
    /// Удаляет книгу из коллекции и сохраняет изменения.
    /// </summary>
    /// <param name="Book">Книга для удаления.</param>
    procedure RemoveBook(const Book: TBookMetadata);

    /// <summary>
    /// Экспортирует книги в указанный файл в формате JSON.
    /// </summary>
    /// <param name="ExportPath">Путь к файлу для экспорта.</param>
    procedure ExportBooksToFile(const ExportPath: string);

    /// <summary>
    /// Импортирует книги из указанного файла в формате JSON.
    /// </summary>
    /// <param name="ImportPath">Путь к файлу для импорта.</param>
    procedure ImportBooksFromFile(const ImportPath: string);
  end;

implementation // Начало секции реализации

{ TBookStorage }

// Конструктор
constructor TBookStorage.Create(const AFilePath: string);
begin
  inherited Create;
  // Инициализация экземпляра TBookModel
  FBookModel := TBookModel.Create;
  // Установка пути к файлу
  FFilePath := AFilePath;
end;

// Деструктор
destructor TBookStorage.Destroy;
begin
  // Освобождение экземпляра TBookModel
  FBookModel.Free;
  inherited Destroy;
end;

// Метод для загрузки книг
procedure TBookStorage.LoadBooks;
begin
  // Вызов внутреннего метода для загрузки книг
  InternalLoadBooks;
end;

// Метод для сохранения книг
procedure TBookStorage.SaveBooks;
begin
  // Вызов внутреннего метода для сохранения книг
  InternalSaveBooks;
end;

// Метод для добавления книги
procedure TBookStorage.AddBook(const Book: TBookMetadata);
begin
  // Добавляем книгу в модель
  FBookModel.AddBook(Book);
  // Сохраняем изменения
  SaveBooks;
end;

// Метод для удаления книги
procedure TBookStorage.RemoveBook(const Book: TBookMetadata);
begin
  // Удаляем книгу из модели
  FBookModel.RemoveBook(Book);
  // Сохраняем изменения
  SaveBooks;
end;

// Метод для экспорта книг в файл
procedure TBookStorage.ExportBooksToFile(const ExportPath: string);
var
  JSONArray: TJSONArray;
  Book: TBookMetadata;
begin
  JSONArray := TJSONArray.Create;
  try
    for Book in FBookModel.GetAllBooks do
    begin
      JSONArray.Add(Book.ToJSON);
    end;
    TFile.WriteAllText(ExportPath, JSONArray.ToString);
  finally
    JSONArray.Free;
  end;
end;

// Метод для импорта книг из файла
procedure TBookStorage.ImportBooksFromFile(const ImportPath: string);
var
  JSONString: string;
  JSONArray: TJSONArray;
  Book: TBookMetadata;
begin
  if not TFile.Exists(ImportPath) then
    raise Exception.CreateFmt('Import file not found: %s', [ImportPath]);

  JSONString := TFile.ReadAllText(ImportPath);
  JSONArray := TJSONObject.ParseJSONValue(JSONString) as TJSONArray;
  try
    for var Item in JSONArray do
    begin
      Book := TBookMetadata.Create;
      Book.FromJSON(Item.ToString);
      FBookModel.AddBook(Book);
    end;
  finally
    JSONArray.Free;
  end;
end;

// Внутренний метод для загрузки книг из файла
procedure TBookStorage.InternalLoadBooks;
var
  JSONString: string;
  Book: TBookMetadata;
begin
  if not TFile.Exists(FFilePath) then
    Exit; // Файл не существует, ничего не загружаем

  JSONString := TFile.ReadAllText(FFilePath);
  // Парсим JSON и создаём объекты
  var JSONArray := TJSONObject.ParseJSONValue(JSONString) as TJSONArray;
  try
    for var Item in JSONArray do
    begin
      Book := TBookMetadata.Create;
      Book.FromJSON(Item.ToString);
      FBookModel.AddBook(Book);
    end;
  finally
    JSONArray.Free;
  end;
end;

// Внутренний метод для сохранения книг в файл
procedure TBookStorage.InternalSaveBooks;
var
  JSONArray: TJSONArray;
  Book: TBookMetadata;
begin
  JSONArray := TJSONArray.Create;
  try
    for Book in FBookModel.GetAllBooks do
    begin
      JSONArray.Add(Book.ToJSON);
    end;
    TFile.WriteAllText(FFilePath, JSONArray.ToString);
  finally
    JSONArray.Free;
  end;
end;

end.
