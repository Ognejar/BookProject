{
  @author(Бегтин К.В. (Огнеяр))
  @author(Jane Doe (http://jane.doe.org))
  @abstract(Модуль для определения типов данных, связанных с метаданными книг.)
  Модуль BookTypes содержит определения классов и типов данных для представления метаданных о книгах и их сериальных частях.
  Он также предоставляет методы для работы с обложками, сериями и другими аспектами книг.

  @version 3.4
  @date 2025
  @copyright Авторское право (c) 2025, Бегтин К.В. (Огнеяр)
  @license Freeware

  @par История изменений:
  - [2025-01-15]: Первоначальная версия.
  - [2025-01-20]: Добавлены методы для работы с серией и тегами.
  - [2025-01-25]: Исправлены ошибки и улучшена обработка JSON.
}

unit BookTypes;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,
  System.IOUtils, System.Rtti, System.Math, SeriesTypes, BriefTypes,
  BaseEntityStorage;

type
  {
    Класс для работы с метаданными книги

    TBookMetadata предоставляет функциональность для хранения и управления
    метаданными о книге, включая такие аспекты, как название, автор, ISBN,
    обложка, серия и другие.
  }
  TBookMetadata = class(TBaseEntity)
  private
    FID: Integer; //< Уникальный идентификатор книги.
    FTitle: string; //< Название книги.
    FAuthor: string; // @brief(Автор книги.)
    FCategoryID: Integer; { ** @brief Идентификатор категории книги. * }
    FDescription: string; { ** @brief Описание книги. * }
    FYear: Integer; { ** @brief Год издания книги. * }
    FISBN: string; { ** @brief ISBN книги. * }
    FPublisher: string; { ** @brief Издательство книги. * }
    FPageCount: Integer; { ** @brief Количество страниц в книге. * }
    FLanguage: string; { ** @brief Язык книги. * }
    FFormat: string; { ** @brief Формат книги (например, PDF, EPUB). * }
    FFileSize: Int64; { ** @brief Размер файла книги в байтах. * }
    FFilePath: string; { ** @brief Путь к файлу книги. * }
    FCoverPath: string; { ** @brief Путь к обложке книги. * }
    FTags: TArray<string>; { ** @brief Теги, связанные с книгой. * }
    FAddedDate: TDateTime; { ** @brief Дата добавления книги. * }
    FNotes: string; { ** @brief Примечания к книге. * }
    FRating: Integer; { ** @brief Рейтинг книги. * }
    FReadStatus: string;
    { ** @brief Статус чтения книги (например, "Прочитана", "Читается"). * }
    FKeywords: string; { ** @brief Ключевые слова для поиска книги. * }
    FSeries: TArray<SeriesTypes.TBookSeriesItem>;
    { ** @brief Серия, к которой принадлежит книга. * }
    procedure SetSeries(const ASeries: TArray<SeriesTypes.TBookSeriesItem>);
    { ** @brief Установка серии для книги. * }
  public
    constructor Create; override;
    destructor Destroy; override;

    {
      Проверяет, есть ли у книги обложка.
      @return True, если у книги есть обложка, иначе False.
    }
    function HasCover: Boolean;

    // Возвращает путь к обложке книги.
    // @return Путь к обложке.

    function GetCoverPath: string;

    { **
      * @brief Преобразует метаданные книги в краткий формат.
      *
      * @return Объект TBookBrief, содержащий краткие сведения о книге.
      * }
    function ToBrief: TBookBrief;

    { **
      * @brief Возвращает количество элементов в серии.
      *
      * @return Количество элементов в серии.
      * }
    function GetSeriesCount: Integer;

    { **
      * @brief Возвращает элемент серии по индексу.
      *
      * @param Index Индекс элемента в серии.
      * @return Элемент серии.
      * }
    function GetSeriesItem(Index: Integer): SeriesTypes.TBookSeriesItem;

    {Добавляет элемент в серию.

     @param AItem Элемент серии для добавления.
    }
    procedure AddSeriesItem(const AItem: SeriesTypes.TBookSeriesItem);

    {Удаляет элемент из серии по индексу.
      @param (AIndex Индекс элемента в серии.)
    }
    procedure RemoveSeriesItem(const AIndex: Integer);

    // Свойства класса

    { Уникальный идентификатор книги. }
    property ID: Integer read FID write FID;
    // Название книги
    property Title: string read FTitle write FTitle;
    // Автор книги.
    property Author: string read FAuthor write FAuthor;
    property CategoryID: Integer read FCategoryID write FCategoryID;
    { < Идентификатор категории книги. * }
    property Description: string read FDescription write FDescription;
    { <Описание книги. * }
    property Year: Integer read FYear write FYear; // <Год издания книги.
    property ISBN: string read FISBN write FISBN; { ** @brief ISBN книги. * }
    property Publisher: string read FPublisher write FPublisher;
    { ** @brief Издательство книги. * }
    property PageCount: Integer read FPageCount write FPageCount;
    { ** @brief Количество страниц в книге. * }
    property Language: string read FLanguage write FLanguage;
    { ** @brief Язык книги. * }
    property Format: string read FFormat write FFormat;
    { ** @brief Формат книги. * }
    property FileSize: Int64 read FFileSize write FFileSize;
    { ** @brief Размер файла книги в байтах. * }
    property FilePath: string read FFilePath write FFilePath;
    { ** @brief Путь к файлу книги. * }
    property CoverPath: string read GetCoverPath;
    { ** @brief Путь к обложке книги. * }
    property Tags: TArray<string> read FTags write FTags;
    { ** @brief Теги, связанные с книгой. * }
    property AddedDate: TDateTime read FAddedDate write FAddedDate;
    { ** @brief Дата добавления книги. * }
    property Notes: string read FNotes write FNotes;
    { ** @brief Примечания к книге. * }
    property Rating: Integer read FRating write FRating;
    { ** @brief Рейтинг книги. * }
    property ReadStatus: string read FReadStatus write FReadStatus;
    { ** @brief Статус чтения книги. * }
    property Keywords: string read FKeywords write FKeywords;
    { ** @brief Ключевые слова для поиска книги. * }
    property Series: TArray<SeriesTypes.TBookSeriesItem> read FSeries
      write SetSeries; { ** @brief Серия, к которой принадлежит книга. * }
  end;

implementation

{ TBookMetadata }

constructor TBookMetadata.Create;
begin
  inherited;
end;

destructor TBookMetadata.Destroy;
begin
  inherited;
end;

function TBookMetadata.HasCover: Boolean;
begin
  Result := not FCoverPath.IsEmpty;
end;

function TBookMetadata.GetCoverPath: string;
begin
  Result := FCoverPath;
end;

function TBookMetadata.ToBrief: TBookBrief;
begin
  Result := TBookBrief.Create;
  try
    Result.ID := FID;
    Result.Title := FTitle;
    Result.Author := FAuthor;
    Result.Year := FYear;
    Result.Format := FFormat;
    Result.FilePath := FFilePath;
    Result.CategoryID := FCategoryID;
    Result.Tags := FTags;
    Result.Series := FSeries;
  except
    Result.Free;
    raise;
  end;
end;

function TBookMetadata.GetSeriesCount: Integer;
begin
  Result := Length(FSeries);
end;

function TBookMetadata.GetSeriesItem(Index: Integer)
  : SeriesTypes.TBookSeriesItem;
begin
  if (Index >= 0) and (Index < Length(FSeries)) then
    Result := FSeries[Index]
  else
    raise Exception.Create('Index out of bounds');
end;

procedure TBookMetadata.AddSeriesItem(const AItem: SeriesTypes.TBookSeriesItem);
var
  tempSeries: TArray<SeriesTypes.TBookSeriesItem>;
begin
  SetLength(tempSeries, Length(FSeries) + 1);
  if Length(FSeries) > 0 then
    Move(FSeries[0], tempSeries[0], Length(FSeries) *
      SizeOf(SeriesTypes.TBookSeriesItem));
  tempSeries[High(tempSeries)] := AItem;
  FSeries := tempSeries;
end;

procedure TBookMetadata.RemoveSeriesItem(const AIndex: Integer);
var
  tempSeries: TArray<SeriesTypes.TBookSeriesItem>;
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

procedure TBookMetadata.SetSeries(const ASeries
  : TArray<SeriesTypes.TBookSeriesItem>);
begin
  FSeries := ASeries;
end;

end.
