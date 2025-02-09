
unit BookTest_1;
{**
  Модуль BookTest_1 содержит определения типов данных для представления информации о
  книгах и их сериальных частях.
  Он также обеспечивает удобное управление данными книгами, включая краткую информацию
  и полные метаданные.
  @author(Бегтин К.В. (Огнеяр))
  @abstract Модуль для определения типов данных, связанных с книгами.
  @created(2025-01-30)
  @lastmod(2025-02-02)
1 Этот модуль12345 содержит тесты для проверки различных аспектов функциональности.
*}

 

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.JSON,
  System.IOUtils, System.Rtti, System.Math, System.TypInfo;

type
  {* Этот класс делает несколько очень полезных вещей.
    С помощью этого класса вы можете ...
    (далее следует текст, описывающий, насколько очень
    полезным является этот класс). *}

  { Базовый класс для всех сущностей. }
  TBaseEntity = class
  private
    FID: Integer;
    FName: string; // < Предполагается, что это свойство есть
  public
    { Создает новый экземпляр TBaseEntity. }
    constructor Create; virtual;

    { Уникальный идентификатор сущности. }
    property ID: Integer read FID write FID;

    { Название сущности. }
    property Name: string read FName write FName;
    // < Предполагается, что это свойство есть
  end;

  { Класс для хранения и управления сущностями в файловой системе. }
  TBaseEntityStorage<T: TBaseEntity, constructor> = class
  private
    FDataPath: string; //< Путь к папке с данными
    FCache: TObjectDictionary<Integer, T>; //< Кэш сущностей
    FMaxCacheSize: Integer; //< Максимальный размер кэша
    FRttiContext: TRttiContext; //< Контекст RTTI
    FCachedRttiType: TRttiType; //< Кэшированный RTTI-тип
    FCachedProperties: TArray<TRttiProperty>; //< Кэшированные свойства

    { Возвращает путь к файлу сущности по её ID. }
    function GetEntityFilePath(const AID: Integer): string;

    { Загружает сущность из файла по её ID. }
    function LoadEntityFromFile(const AID: Integer): T;

    { Сохраняет сущность в файл. }
    procedure SaveEntityToFile(const AEntity: T);

    { Обеспечивает, чтобы размер кэша не превышал максимальный. }
    procedure EnsureCacheSize;

    { Возвращает следующий доступный ID для новой сущности. }
    function GetNextID: Integer;

    { Преобразует сущность в JSON-объект. }
    function EntityToJSON(const AEntity: T): TJSONObject;

    { Заполняет сущность данными из JSON-объекта. }
    procedure EntityFromJSON(const AEntity: T; const AJSONObj: TJSONObject);

    { Кэширует RTTI-информацию о типе сущности. }
    procedure CacheRttiInfo;
  public
    { Создает экземпляр TBaseEntityStorage.
      @param(ADataPath Путь к папке с данными.)
      @param(AMaxCacheSize Максимальный размер кэша (по умолчанию 100).) }
    constructor Create(const ADataPath: string; AMaxCacheSize: Integer = 100);

    { Уничтожает экземпляр TBaseEntityStorage. }
    destructor Destroy; override;

    { Создает новую сущность и возвращает её ID. }
    function CreateEntity(const AEntity: T): Integer; virtual;

    { Возвращает сущность по её ID. }
    function ReadEntity(const AID: Integer): T; virtual;

    { Обновляет сущность. }
    procedure UpdateEntity(const AEntity: T); virtual;

    { Удаляет сущность по её ID. }
    procedure DeleteEntity(const AID: Integer); virtual;

    { Возвращает список всех сущностей. }
    function GetAllEntities: TObjectList<T>; virtual;

    { Преобразует сущность в JSON-строку. }
    function ToJSON(const AEntity: T): string;

    { Заполняет сущность данными из JSON-строки. }
    procedure FromJSON(const AEntity: T; const AJSONString: string);
  end;

implementation