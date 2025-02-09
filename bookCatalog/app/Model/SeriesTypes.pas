{
  ┌───────────────────────────────────────────────────────────────────┐
  │ Автор: Бегтин К.В. (Огнеяр)                                       │
  │ Название проекта: Библиотека Дементора                            │
  │ Лицензия: Freeware                                                │
  │ Год создания: 2025                                                │
  │ Версия: 3.4                                                       │
  │                                                                   │
  │ Назначение модуля:                                                │
  │ Модуль SeriesTypes содержит определения типов данных для            │
  │ представления информации о сериях книг и их элементах.              │
  │ Модуль обеспечивает управление данными для серии книг, включая     │
  │ создание, чтение, обновление и удаление элементов серии.           │
  │                                                                   │
  │ История изменений:                                                │
  │ [2025-01-30]: Создание модуля с типами TBookSeriesItem и          │
  │               TBookSeries                                         │
  │                                                                   │
  └───────────────────────────────────────────────────────────────────┘
}
unit SeriesTypes;
interface
uses
  System.SysUtils, System.Classes, BaseEntityStorage;

type
  // TBookSeriesItem - класс, представляющий элемент серии книг
  TBookSeriesItem = class(TBaseEntity)
  private
    FBookID: Integer;      // Идентификатор книги
    FSeriesID: Integer;    // Идентификатор серии
    FBookNumber: Integer;  // Номер книги в серии
  public
    constructor Create(ABookID, ASeriesID, ABookNumber: Integer);
    property BookID: Integer read FBookID write FBookID; // Идентификатор книги
    property SeriesID: Integer read FSeriesID write FSeriesID; // Идентификатор серии
    property BookNumber: Integer read FBookNumber write FBookNumber; // Номер книги в серии
  end;

  // TBookSeries - класс, представляющий серию книг
  TBookSeries = class(TBaseEntity)
  private
    FName: string;         // Название серии
    FPublisher: string;    // Издательство
    FDescription: string;  // Описание серии
  public
    constructor Create(const AID: Integer; const AName, APublisher, ADescription: string);
    property Name: string read FName write FName; // Название серии
    property Publisher: string read FPublisher write FPublisher; // Издательство
    property Description: string read FDescription write FDescription; // Описание серии
  end;

implementation

{ TBookSeriesItem }

constructor TBookSeriesItem.Create(ABookID, ASeriesID, ABookNumber: Integer);
begin
  inherited Create;
  FBookID := ABookID;
  FSeriesID := ASeriesID;
  FBookNumber := ABookNumber;
end;

{ TBookSeries }

constructor TBookSeries.Create(const AID: Integer; const AName, APublisher, ADescription: string);
begin
  inherited Create;
  ID := AID;
  FName := AName;
  FPublisher := APublisher;
  FDescription := ADescription;
end;

end.
