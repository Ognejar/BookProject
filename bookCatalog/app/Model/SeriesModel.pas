{
  ┌───────────────────────────────────────────────────────────────────┐
  │ Автор: Бегтин К.В. (Огнеяр)                                       │
  │ Название проекта: Библиотека Дементора                             │
  │ Лицензия: Freeware                                                │
  │ Год создания: 2025                                                │
  │ Версия: 3.4                                                       │
  │                                                                   │
  │ Назначение модуля:                                                │
  │ Модуль SeriesModel содержит методы для манипуляции данными,        │
  │ связанными с сериями книг и их элементами. Методы включают        │
  │ создание, чтение, обновление и удаление серий и их элементов.     │
  │                                                                   │
  │ История изменений:                                                │
  │ [2025-01-31 19:17]: Создание модуля с базовыми методами для работы │
  │                     с TBookSeries и TBookSeriesItem.               │
  │ [2025-01-31 19:17]: Добавлены методы для поиска серий по названию, │
  │                     фильтрации книг в серии и получения всех серий.│
  │ [2025-01-31 20:00]: Добавлены комментарии и проверка данных.      │
  │                                                                   │
  └───────────────────────────────────────────────────────────────────┘
}
unit SeriesModel;

interface

uses
  System.SysUtils, System.Classes, SeriesTypes;

type
  TSeriesManipulation = class
  public
    /// <summary>
    /// Создает новую серию книг.
    /// </summary>
    /// <param name="AName">Название серии.</param>
    /// <param name="APublisher">Издательство серии.</param>
    /// <param name="ADescription">Описание серии.</param>
    /// <returns>Созданный объект TBookSeries.</returns>
    function CreateSeries(const AName, APublisher, ADescription: string): TBookSeries;

    /// <summary>
    /// Обновляет данные существующей серии.
    /// </summary>
    /// <param name="ASeries">Серия для обновления.</param>
    /// <returns>True, если обновление прошло успешно, иначе False.</returns>
    function UpdateSeries(const ASeries: TBookSeries): Boolean;

    /// <summary>
    /// Удаляет серию по её идентификатору.
    /// </summary>
    /// <param name="ASeriesID">Идентификатор серии.</param>
    /// <returns>True, если удаление прошло успешно, иначе False.</returns>
    function DeleteSeries(const ASeriesID: Integer): Boolean;

    /// <summary>
    /// Получает серию по её идентификатору.
    /// </summary>
    /// <param name="ASeriesID">Идентификатор серии.</param>
    /// <returns>Объект TBookSeries или nil, если серия не найдена.</returns>
    function GetSeriesByID(const ASeriesID: Integer): TBookSeries;

    /// <summary>
    /// Ищет серии по названию.
    /// </summary>
    /// <param name="AName">Название серии для поиска.</param>
    /// <returns>Массив объектов TBookSeries.</returns>
    function FindSeriesByName(const AName: string): TArray<TBookSeries>;

    /// <summary>
    /// Получает все серии.
    /// </summary>
    /// <returns>Массив объектов TBookSeries.</returns>
    function GetAllSeries: TArray<TBookSeries>;

    /// <summary>
    /// Добавляет книгу в серию.
    /// </summary>
    /// <param name="ABookID">Идентификатор книги.</param>
    /// <param name="ASeriesID">Идентификатор серии.</param>
    /// <param name="ABookNumber">Номер книги в серии.</param>
    /// <returns>Созданный объект TBookSeriesItem.</returns>
    function AddBookToSeries(const ABookID, ASeriesID, ABookNumber: Integer): TBookSeriesItem;

    /// <summary>
    /// Удаляет книгу из серии.
    /// </summary>
    /// <param name="ABookID">Идентификатор книги.</param>
    /// <param name="ASeriesID">Идентификатор серии.</param>
    /// <returns>True, если удаление прошло успешно, иначе False.</returns>
    function RemoveBookFromSeries(const ABookID, ASeriesID: Integer): Boolean;

    /// <summary>
    /// Получает все книги в серии.
    /// </summary>
    /// <param name="ASeriesID">Идентификатор серии.</param>
    /// <returns>Массив объектов TBookSeriesItem.</returns>
    function GetBooksInSeries(const ASeriesID: Integer): TArray<TBookSeriesItem>;

    /// <summary>
    /// Фильтрует книги в серии по номеру.
    /// </summary>
    /// <param name="ASeriesID">Идентификатор серии.</param>
    /// <param name="ABookNumber">Номер книги.</param>
    /// <returns>Массив объектов TBookSeriesItem.</returns>
    function FilterBooksInSeries(const ASeriesID, ABookNumber: Integer): TArray<TBookSeriesItem>;

    /// <summary>
    /// Обновляет номер книги в серии.
    /// </summary>
    /// <param name="ABookID">Идентификатор книги.</param>
    /// <param name="ASeriesID">Идентификатор серии.</param>
    /// <param name="ANewBookNumber">Новый номер книги.</param>
    /// <returns>True, если обновление прошло успешно, иначе False.</returns>
    function UpdateBookNumberInSeries(const ABookID, ASeriesID, ANewBookNumber: Integer): Boolean;
  end;

implementation

{ TSeriesManipulation }

function TSeriesManipulation.CreateSeries(const AName, APublisher, ADescription: string): TBookSeries;
begin
  // Проверка входных данных
  if Trim(AName) = '' then
    raise Exception.Create('Название серии не может быть пустым.');

  if Trim(APublisher) = '' then
    raise Exception.Create('Издательство серии не может быть пустым.');

  // Создание серии
  Result := TBookSeries.Create(0, AName, APublisher, ADescription);
  // Предполагается, что ID будет установлено при сохранении в хранилище
end;

function TSeriesManipulation.UpdateSeries(const ASeries: TBookSeries): Boolean;
begin
  // Проверка входных данных
  if ASeries = nil then
    raise Exception.Create('Объект серии не может быть nil.');

  // Обновление серии
  // Здесь должен быть код для обновления данных серии
  Result := True; // Или False в зависимости от результата
end;

function TSeriesManipulation.DeleteSeries(const ASeriesID: Integer): Boolean;
begin
  // Проверка входных данных
  if ASeriesID <= 0 then
    raise Exception.Create('Идентификатор серии должен быть положительным числом.');

  // Удаление серии
  // Здесь должен быть код для удаления серии
  Result := True; // Или False в зависимости от результата
end;

function TSeriesManipulation.GetSeriesByID(const ASeriesID: Integer): TBookSeries;
begin
  // Проверка входных данных
  if ASeriesID <= 0 then
    raise Exception.Create('Идентификатор серии должен быть положительным числом.');

  // Получение серии по ID
  // Здесь должен быть код для получения серии из хранилища
  Result := TBookSeries.Create(ASeriesID, 'Sample Series', 'Sample Publisher', 'Sample Description');
  // Если серия не найдена, можно вернуть nil
end;

function TSeriesManipulation.FindSeriesByName(const AName: string): TArray<TBookSeries>;
begin
  // Проверка входных данных
  if Trim(AName) = '' then
    raise Exception.Create('Название серии не может быть пустым.');

  // Поиск серий по названию
  // Здесь должен быть код для поиска серий
  SetLength(Result, 1);
  Result[0] := TBookSeries.Create(1, AName, 'Sample Publisher', 'Sample Description');
end;

function TSeriesManipulation.GetAllSeries: TArray<TBookSeries>;
begin
  // Получение всех серий
  // Здесь должен быть код для получения всех серий из хранилища
  SetLength(Result, 2);
  Result[0] := TBookSeries.Create(1, 'Series 1', 'Publisher 1', 'Description 1');
  Result[1] := TBookSeries.Create(2, 'Series 2', 'Publisher 2', 'Description 2');
end;

function TSeriesManipulation.AddBookToSeries(const ABookID, ASeriesID, ABookNumber: Integer): TBookSeriesItem;
begin
  // Проверка входных данных
  if ABookID <= 0 then
    raise Exception.Create('Идентификатор книги должен быть положительным числом.');

  if ASeriesID <= 0 then
    raise Exception.Create('Идентификатор серии должен быть положительным числом.');

  if ABookNumber <= 0 then
    raise Exception.Create('Номер книги должен быть положительным числом.');

  // Добавление книги в серию
  Result := TBookSeriesItem.Create(ABookID, ASeriesID, ABookNumber);
end;

function TSeriesManipulation.RemoveBookFromSeries(const ABookID, ASeriesID: Integer): Boolean;
begin
  // Проверка входных данных
  if ABookID <= 0 then
    raise Exception.Create('Идентификатор книги должен быть положительным числом.');

  if ASeriesID <= 0 then
    raise Exception.Create('Идентификатор серии должен быть положительным числом.');

  // Удаление книги из серии
  // Здесь должен быть код для удаления книги из хранилища
  Result := True; // Или False в зависимости от результата
end;

function TSeriesManipulation.GetBooksInSeries(const ASeriesID: Integer): TArray<TBookSeriesItem>;
begin
  // Проверка входных данных
  if ASeriesID <= 0 then
    raise Exception.Create('Идентификатор серии должен быть положительным числом.');

  // Получение списка книг в серии
  // Здесь должен быть код для получения списка книг
  SetLength(Result, 1);
  Result[0] := TBookSeriesItem.Create(1, ASeriesID, 1); // Пример данных
end;

function TSeriesManipulation.FilterBooksInSeries(const ASeriesID, ABookNumber: Integer): TArray<TBookSeriesItem>;
begin
  // Проверка входных данных
  if ASeriesID <= 0 then
    raise Exception.Create('Идентификатор серии должен быть положительным числом.');

  if ABookNumber <= 0 then
    raise Exception.Create('Номер книги должен быть положительным числом.');

  // Фильтрация книг в серии по номеру
  // Здесь должен быть код для фильтрации книг
  SetLength(Result, 1);
  Result[0] := TBookSeriesItem.Create(1, ASeriesID, ABookNumber);
end;

function TSeriesManipulation.UpdateBookNumberInSeries(const ABookID, ASeriesID, ANewBookNumber: Integer): Boolean;
begin
  // Проверка входных данных
  if ABookID <= 0 then
    raise Exception.Create('Идентификатор книги должен быть положительным числом.');

  if ASeriesID <= 0 then
    raise Exception.Create('Идентификатор серии должен быть положительным числом.');

  if ANewBookNumber <= 0 then
    raise Exception.Create('Новый номер книги должен быть положительным числом.');

  // Обновление номера книги в серии
  // Здесь должен быть код для обновления номера книги
  Result := True; // Или False в зависимости от результата
end;

end.
