{
  ┌───────────────────────────────────────────────────────────────────┐
  │ Автор: Бегтин К.В. (Огнеяр)                                       │
  │ Название проекта: Библиотека Дементора                             │
  │ Лицензия: Freeware                                                │
  │ Год создания: 2025                                                │
  │ Версия: 3.4                                                       │
  │                                                                   │
  │ Назначение модуля:                                                │
  │ Модуль BookTypes содержит определения типов данных для            │
  │ представления метаданных о книгах и их сериальных частях.         │
  │                                                                   │
  │ История изменений:                                                │
  │ [2025-01-15]: Создание модуля с базовыми типами TBook и          │
  │               TBookSeriesItem.                                    │
  │ [2025-01-20]: Добавлены методы инициализации для TBookSeriesItem  │
  │               и TBookSeries.                                      │
  │ [2025-01-25]: Внесены изменения в структуру TBook для поддержки   │
  │               дополнительных полей, таких как ISBN и Publisher.   │
  │ [2025-01-30]: Добавлен тип TBookSeries для представления          │
  │               информации о сериях книг.                          │
  │ [2025-02-05]: Добавлен тип TBookMetadata для полных метаданных.  │
  └───────────────────────────────────────────────────────────────────┘
}

unit BookTypes;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON;

type
  // TBook - запись, представляющая книгу с полными метаданными
  TBook = record
    ID: Integer;          // Уникальный идентификатор книги
    Title: string;        // Название книги
    Author: string;       // Автор книги
    Year: Integer;        // Год издания
    Format: string;       // Формат книги (например, PDF, EPUB)
    FilePath: string;     // Путь к файлу книги
    CategoryID: Integer;  // Идентификатор категории
    Tags: TArray<string>; // Теги книги
    Series: TArray<TBookSeriesItem>; // Информация о серии книг
    ISBN: string;         // Международный стандартный книжный номер
    Publisher: string;    // Издательство
    PageCount: Integer;   // Количество страниц
    Language: string;     // Язык книги
    Description: string;  // Описание книги
    AddedDate: TDateTime;// Дата добавления книги
    Rating: Integer;      // Рейтинг книги
    ReadStatus: string;   // Статус чтения (например, "Прочитана", "В процессе")
    Notes: string;        // Примечания
    Keywords: string;     // Ключевые слова для поиска
    CustomFields: TDictionary<string, string>; // Дополнительные поля
  end;

  // TBookMetadata - класс для работы с метаданными книги
  TBookMetadata = class
  private
    FID: Integer;               // Уникальный идентификатор
    FTitle: string;             // Название книги
    FAuthor: string;            // Автор книги
    FCategoryID: Integer;       // Идентификатор категории
    FDescription: string;       // Описание книги
    FYear: Integer;             // Год издания
    FISBN: string;              // ISBN
    FPublisher: string;         // Издательство
    FPageCount: Integer;        // Количество страниц
    FLanguage: string;          // Язык книги
    FFormat: string;            // Формат книги
    FFileSize: Int64;           // Размер файла
    FFilePath: string;          // Путь к файлу
    FCoverPath: string;         // Путь к обложке
    FTags: TArray<string>;      // Теги
    FAddedDate: TDateTime;      // Дата добавления
    FNotes: string;             // Примечания
    FRating: Integer;           // Рейтинг
    FReadStatus: string;        // Статус чтения
    FKeywords: string;          // Ключевые слова
    FSeries: TArray<TBookSeriesItem>; // Серия
    FCustomFields: TDictionary<string, string>; // Дополнительные поля
    procedure SetSeries(ASeries: TArray<TBookSeriesItem>); // Установка серии
  public
    constructor Create;
    destructor Destroy; override;

    // Преобразование в JSON / из JSON
    function ToJSON: string;
    procedure FromJSON(const JSONString: string);

    // Преобразование в TBookBrief
    function ToBrief: TBookBrief; // Для списка книг в памяти

    // Проверка наличия обложки
    function HasCover: Boolean; // Есть ли обложка

    // Количество элементов в серии
    function GetSeriesCount: Integer; // Количество элементов в серии

    // Получение элемента серии по индексу
    function GetSeriesItem(Index: Integer): TBookSeriesItem; // Получение элемента серии

    // Добавление элемента в серию
    procedure AddSeriesItem(const AItem: TBookSeriesItem); // Добавление элемента в серию

    // Удаление элемента из серии
    procedure RemoveSeriesItem(const AIndex: Integer); // Удаление элемента из серии

    property SeriesCount: Integer read GetSeriesCount; // Количество элементов в серии
    property ID: Integer read FID write FID; // Уникальный идентификатор
    property Title: string read FTitle write FTitle; // Название книги
    property Author: string read FAuthor write FAuthor; // Автор книги
    property CategoryID: Integer read FCategoryID write FCategoryID; // Идентификатор категории
    property Description: string read FDescription write FDescription; // Описание книги
    property Year: Integer read FYear write FYear; // Год издания
    property ISBN: string read FISBN write FISBN; // ISBN
    property Publisher: string read FPublisher write FPublisher; // Издательство
    property PageCount: Integer read FPageCount write FPageCount; // Количество страниц
    property Language: string read FLanguage write FLanguage; // Язык книги
    property Format: string read FFormat write FFormat; // Формат книги
    property FileSize: Int64 read FFileSize write FFileSize; // Размер файла
    property FilePath: string read FFilePath write FFilePath; // Путь к файлу
    property CoverPath: string read FCoverPath write FCoverPath; // Путь к обложке
    property Tags: TArray<string> read FTags write FTags; // Теги
    property AddedDate: TDateTime read FAddedDate write FAddedDate; // Дата добавления
    property Notes: string read FNotes write FNotes; // Примечания
    property Rating: Integer read FRating write FRating; // Рейтинг
    property ReadStatus: string read FReadStatus write FReadStatus; // Статус чтения
    property Keywords: string read FKeywords write FKeywords; // Ключевые слова
    property Series: TArray<TBookSeriesItem> read FSeries write SetSeries; // Серия
    property CustomFields: TDictionary<string, string> read FCustomFields; // Дополнительные поля

    // Установка значения дополнительного поля
    procedure SetCustomFieldsValue(const Key, Value: string);

    // Установка дополнительных полей
    procedure SetCustomFields(const ACustomFields: TDictionary<string, string>);
  end;

implementation

{ TBookMetadata }

constructor TBookMetadata.Create;
begin
  inherited;
  FCustomFields := TDictionary<string, string>.Create;
end;

destructor TBookMetadata.Destroy;
begin
  FCustomFields.Free;
  inherited;
end;

procedure TBookMetadata.SetSeries(ASeries: TArray<TBookSeriesItem>);
begin
  FSeries := ASeries;
end;

function TBookMetadata.ToBrief: TBookBrief;
begin
  Result.ID := FID;
  Result.Title := FTitle;
  Result.Author := FAuthor;
  Result.Year := FYear;
  Result.Format := FFormat;
  Result.FilePath := FFilePath;
  Result.CategoryID := FCategoryID;
  Result.Tags := FTags;
  Result.Series := FSeries;
end;

function TBookMetadata.HasCover: Boolean;
begin
  Result := not FCoverPath.IsEmpty;
end;

function TBookMetadata.GetSeriesCount: Integer;
begin
  Result := Length(FSeries);
end;

function TBookMetadata.GetSeriesItem(Index: Integer): TBookSeriesItem;
begin
  if (Index >= 0) and (Index < Length(FSeries)) then
    Result := FSeries[Index]
  else
    raise Exception.Create('Index out of bounds');
end;

procedure TBookMetadata.AddSeriesItem(const AItem: TBookSeriesItem);
var
  tempSeries: TArray<TBookSeriesItem>;
begin
  SetLength(tempSeries, Length(FSeries) + 1);
  if Length(FSeries) > 0 then
    Move(FSeries[0], tempSeries[0], Length(FSeries) * SizeOf(TBookSeriesItem));
  tempSeries[High(tempSeries)] := AItem;
  FSeries := tempSeries;
end;

procedure TBookMetadata.RemoveSeriesItem(const AIndex: Integer);
var
  tempSeries: TArray<TBookSeriesItem>;
  i: Integer;
begin
  if (AIndex >= 0) and (AIndex < Length(FSeries)) then
  begin
    SetLength(tempSeries, Length(FSeries) - 1);
    for i := 0 to High(tempSeries) do
      if i < AIndex then
        tempSeries[i] := FSeries[i]
      else
        tempSeries[i] := FSeries[i + 1];
    FSeries := tempSeries;
  end
  else
    raise Exception.Create('Index out of bounds');
end;

procedure TBookMetadata.SetCustomFields(const ACustomFields: TDictionary<string, string>);
begin
  FCustomFields.Clear;
  for var pair in ACustomFields do
    FCustomFields.Add(pair.Key, pair.Value);
end;

procedure TBookMetadata.SetCustomFieldsValue(const Key, Value: string);
begin
  FCustomFields.AddOrSetValue(Key, Value);
end;

function TBookMetadata.ToJSON: string;
var
  JSONObject: TJSONObject;
  SeriesArray: TJSONArray;
  SeriesItemObject: TJSONObject;
  CustomFieldsArray: TJSONArray;
  CustomFieldObject: TJSONObject;
  Tag: string;
begin
  JSONObject := TJSONObject.Create;
  try
    JSONObject.AddPair('ID', TJSONNumber.Create(FID));
    JSONObject.AddPair('Title', FTitle);
    JSONObject.AddPair('Author', FAuthor);
    JSONObject.AddPair('CategoryID', TJSONNumber.Create(FCategoryID));
    JSONObject.AddPair('Description', FDescription);
    JSONObject.AddPair('Year', TJSONNumber.Create(FYear));
    JSONObject.AddPair('ISBN', FISBN);
    JSONObject.AddPair('Publisher', FPublisher);
    JSONObject.AddPair('PageCount', TJSONNumber.Create(FPageCount));
    JSONObject.AddPair('Language', FLanguage);
    JSONObject.AddPair('Format', FFormat);
    JSONObject.AddPair('FileSize', TJSONNumber.Create(FFileSize));
    JSONObject.AddPair('FilePath', FFilePath);
    JSONObject.AddPair('CoverPath', FCoverPath);
    JSONObject.AddPair('AddedDate', TJSONNumber.Create(FAddedDate));
    JSONObject.AddPair('Notes', FNotes);
    JSONObject.AddPair('Rating', TJSONNumber.Create(FRating));
    JSONObject.AddPair('ReadStatus', FReadStatus);
    JSONObject.AddPair('Keywords', FKeywords);

    // 
    SeriesArray := TJSONArray.Create;
    for var seriesItem in FSeries do
    begin
      SeriesItemObject := TJSONObject.Create;
//      SeriesItemObject.AddPair('Title', seriesItem.Title);
//      SeriesItemObject.AddPair('Number', TJSONNumber.Create(seriesItem.Number));
      SeriesArray.AddElement(SeriesItemObject);
    end;
    JSONObject.AddPair('Series', SeriesArray);

    //  
    CustomFieldsArray := TJSONArray.Create;
    for var customField in FCustomFields do
    begin
      CustomFieldObject := TJSONObject.Create;
      CustomFieldObject.AddPair('Key', customField.Key);
      CustomFieldObject.AddPair('Value', customField.Value);
      CustomFieldsArray.AddElement(CustomFieldObject);
    end;
    JSONObject.AddPair('CustomFields', CustomFieldsArray);

    // 
    Tag := '';
    for var tagItem in FTags do
    begin
      Tag := Tag + tagItem + ',';
    end;
    if Tag <> '' then
      Tag := Copy(Tag, 1, Length(Tag) - 1);
    JSONObject.AddPair('Tags', Tag);

    Result := JSONObject.ToString;
  finally
    JSONObject.Free;
  end;
end;

procedure TBookMetadata.FromJSON(const JSONString: string);
var
  JSONObject: TJSONObject;
  SeriesArray: TJSONArray;
  SeriesItemObject: TJSONObject;
  CustomFieldsArray: TJSONArray;
  CustomFieldObject: TJSONObject;
  TagArray: TArray<string>;
  i: Integer;
begin
  JSONObject := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
  try
    FID := JSONObject.GetValue<Integer>('ID');
    FTitle := JSONObject.GetValue<string>('Title');
    FAuthor := JSONObject.GetValue<string>('Author');
    FCategoryID := JSONObject.GetValue<Integer>('CategoryID');
    FDescription := JSONObject.GetValue<string>('Description');
    FYear := JSONObject.GetValue<Integer>('Year');
    FISBN := JSONObject.GetValue<string>('ISBN');
    FPublisher := JSONObject.GetValue<string>('Publisher');
    FPageCount := JSONObject.GetValue<Integer>('PageCount');
    FLanguage := JSONObject.GetValue<string>('Language');
    FFormat := JSONObject.GetValue<string>('Format');
    FFileSize := JSONObject.GetValue<Int64>('FileSize');
    FFilePath := JSONObject.GetValue<string>('FilePath');
    FCoverPath := JSONObject.GetValue<string>('CoverPath');
    FTags := JSONObject.GetValue<TArray<string>>('Tags');
    FAddedDate := JSONObject.GetValue<TDateTime>('AddedDate');
    FNotes := JSONObject.GetValue<string>('Notes');
    FRating := JSONObject.GetValue<Integer>('Rating');
    FReadStatus := JSONObject.GetValue<string>('ReadStatus');
    FKeywords := JSONObject.GetValue<string>('Keywords');

    // 
    SeriesArray := JSONObject.GetValue<TJSONArray>('Series');
    SetLength(FSeries, SeriesArray.Count);
    for i := 0 to SeriesArray.Count - 1 do
    begin
      SeriesItemObject := SeriesArray.Items[i] as TJSONObject;
//      FSeries[i].Title := SeriesItemObject.GetValue<string>('Title');
//      FSeries[i].Number := SeriesItemObject.GetValue<Integer>('Number');
    end;

    //  
    CustomFieldsArray := JSONObject.GetValue<TJSONArray>('CustomFields');
    FCustomFields.Clear;
    for i := 0 to CustomFieldsArray.Count - 1 do
    begin
      CustomFieldObject := CustomFieldsArray.Items[i] as TJSONObject;
      FCustomFields.Add(CustomFieldObject.GetValue<string>('Key'), CustomFieldObject.GetValue<string>('Value'));
    end;
  finally
    JSONObject.Free;
  end;
end;

end.