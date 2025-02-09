{
  ┌───────────────────────────────────────────────────────────────────┐
  │ Автор: Бегтин К.В. (Огнеяр)                                       │
  │ Название проекта: Библиотека Дементора                            │
  │ Лицензия: Freeware                                                │
  │ Год создания: 2025                                                │
  │ Версия: 3.4                                                       │
  │                                                                   │
  │ Назначение модуля:                                                │
  │ Модуль BriefTypes содержит определения типов данных для            │
  │ представления списка книг в памяти.                                │
  │ Модуль также обеспечивает удобное управление данными               │
  │ краткой информации о книгах.                                       │
  │                                                                   │
  │ История изменений:                                                │
  │ [2025-01-20]: Создание модуля с типом TBookBrief                 │
  │                                                                   │
  └───────────────────────────────────────────────────────────────────┘
}
unit BriefTypes;
interface
uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  System.Generics.Defaults, CommonTypes, System.Math,
  BaseEntityStorage, SeriesTypes;

// Определение типа TBookBrief для представления краткой информации о книге
type
  // TBookBrief - класс для представления краткой информации о книге
  TBookBrief = class(TBaseEntity)
  private
    // Приватные поля для хранения информации о книге
    FTitle: string;      // Название книги
    FAuthor: string;     // Автор книги
    FYear: Integer;      // Год издания
    FFormat: string;     // Формат книги
    FFilePath: string;   // Путь к файлу книги
    FCategoryID: Integer;// Идентификатор категории
    FTags: TArray<string>; // Теги книги
    FSeries: TArray<SeriesTypes.TBookSeriesItem>; // Серия книги

  public
    // Открытые свойства для доступа к приватным полям
    property Title: string read FTitle write FTitle; // Название книги
    property Author: string read FAuthor write FAuthor; // Автор книги
    property Year: Integer read FYear write FYear; // Год издания
    property Format: string read FFormat write FFormat; // Формат книги
    property FilePath: string read FFilePath write FFilePath; // Путь к файлу
    property CategoryID: Integer read FCategoryID write FCategoryID; // Идентификатор категории
    property Tags: TArray<string> read FTags write FTags; // Теги
    property Series: TArray<SeriesTypes.TBookSeriesItem> read FSeries write FSeries; // Серия
  end;

  // TBookBriefList - список книг
  TBookBriefList = class(TList<TBookBrief>)
  private
    // Приватная функция для сравнения двух объектов TBookBrief по указанному полю
    function CompareBooks(const Left, Right: TBookBrief;
      const AField: TListSortField; const AOrder: TListSortOrder): Integer;
  public
    // Открытые методы для поиска книг по различным критериям
    function FindByID(const AID: Integer): TBookBrief;
    function FindByTitle(const ATitle: string): TBookBrief;
    function FindByAuthor(const AAuthor: string): TBookBrief;

    // Открытый метод для сортировки списка книг по указанному полю
    procedure Sort(const AField: TListSortField; const AOrder: TListSortOrder = soAscending);
  end;

implementation
uses
  System.StrUtils;

{ TBookBriefList }

// Метод для поиска книги по идентификатору
function TBookBriefList.FindByID(const AID: Integer): TBookBrief;
begin
  // Проходим по всем элементам списка
  for var Book in Self do
    // Если найдено совпадение по ID, возвращаем книгу
    if Book.ID = AID then
      Exit(Book);
  // Если книга не найдена, выбрасываем исключение
  raise Exception.CreateFmt('Book not found with ID: %d', [AID]);
end;

// Метод для поиска книги по названию
function TBookBriefList.FindByTitle(const ATitle: string): TBookBrief;
begin
  // Проходим по всем элементам списка
  for var Book in Self do
    // Если найдено совпадение по названию, возвращаем книгу
    if AnsiContainsText(Book.Title, ATitle) then
      Exit(Book);
  // Если книга не найдена, выбрасываем исключение
  raise Exception.CreateFmt('Book not found with title: %s', [ATitle]);
end;

// Метод для поиска книги по автору
function TBookBriefList.FindByAuthor(const AAuthor: string): TBookBrief;
begin
  // Проходим по всем элементам списка
  for var Book in Self do
    // Если найдено совпадение по автору, возвращаем книгу
    if AnsiContainsText(Book.Author, AAuthor) then
      Exit(Book);
  // Если книга не найдена, выбрасываем исключение
  raise Exception.CreateFmt('Book not found with author: %s', [AAuthor]);
end;

// Функция для сравнения двух объектов TBookBrief по указанному полю
function TBookBriefList.CompareBooks(const Left, Right: TBookBrief;
  const AField: TListSortField; const AOrder: TListSortOrder): Integer;
begin
  // Выбираем поле для сравнения
  case AField of
    sfTitle:
      Result := CompareText(Left.Title, Right.Title); // Сравнение по названию
    sfAuthor:
      Result := CompareText(Left.Author, Right.Author); // Сравнение по автору
    sfYear:
      Result := CompareValue(Left.Year, Right.Year); // Сравнение по году
    else
      Result := 0; // По умолчанию - равны
  end;
  // Если порядок сортировки обратный, инвертируем результат
  if AOrder = soDescending then
    Result := -Result;
end;

// Метод для сортировки списка книг по указанному полю
procedure TBookBriefList.Sort(const AField: TListSortField; const AOrder: TListSortOrder = soAscending);
begin
  // Выполняем сортировку списка, используя функцию сравнения CompareBooks
  inherited Sort(
    TComparer<TBookBrief>.Construct(
      function(const Left, Right: TBookBrief): Integer
      begin
        Result := CompareBooks(Left, Right, AField, AOrder);
      end)
  );
end;

end.
