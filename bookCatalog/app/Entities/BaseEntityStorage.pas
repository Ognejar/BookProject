unit BaseEntityStorage;

{
  @author(Бегтин К.В. (Огнеяр))
  @brief(Модуль для определения типов данных, связанных с книгами.)
  Модуль BookTypes содержит определения типов данных для представления информации о
  книгах и их сериальных частях.
  Он также обеспечивает удобное управление данными книгами, включая краткую информацию
  и полные метаданные.
  @created(2025-01-30)
  @lastmod(2025-02-02)
}
interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.JSON,
  System.IOUtils, System.Rtti, System.Math, System.TypInfo;

type
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
    FDataPath: string; // < Путь к папке с данными
    FCache: TObjectDictionary<Integer, T>; // < Кэш сущностей
    FMaxCacheSize: Integer; // < Максимальный размер кэша
    FRttiContext: TRttiContext; // < Контекст RTTI
    FCachedRttiType: TRttiType; // < Кэшированный RTTI-тип
    FCachedProperties: TArray<TRttiProperty>; // < Кэшированные свойства

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

{ TBaseEntity }

constructor TBaseEntity.Create;
begin
  inherited;
end;

{ TBaseEntityStorage<T> }

constructor TBaseEntityStorage<T>.Create(const ADataPath: string;
  AMaxCacheSize: Integer);
begin
  inherited Create;
  FDataPath := ADataPath;
  FMaxCacheSize := AMaxCacheSize;
  FCache := TObjectDictionary<Integer, T>.Create([doOwnsValues]);
  FRttiContext := TRttiContext.Create;
  try
    CacheRttiInfo; // < Кэшируем RTTI-информацию
    if not TDirectory.Exists(FDataPath) then
      TDirectory.CreateDirectory(FDataPath);
  except
    FreeAndNil(FCache);
    FRttiContext.Free;
    raise;
  end;
end;

destructor TBaseEntityStorage<T>.Destroy;
begin
  try
      // Логирование: начало освобождения ресурсов
    Writeln('Начало освобождения ресурсов TBaseEntityStorage.');
    FCache.Free;
    FRttiContext.Free;
  finally
    inherited;
  end;
end;

//destructor TBaseEntityStorage.Destroy;
//begin
//  try
//    // Логирование: начало освобождения ресурсов
//    // Освобождение ресурсов
//  except
//    on E: Exception do
//      Writeln('Ошибка при освобождении ресурсов: ' + E.Message);
//  end;
//  inherited Destroy;
//end;

function TBaseEntityStorage<T>.GetEntityFilePath(const AID: Integer): string;
begin
  Result := TPath.Combine(FDataPath, Format('%d.json', [AID]));
end;

function TBaseEntityStorage<T>.LoadEntityFromFile(const AID: Integer): T;
var
  jsonText: string;
  jsonObj: TJSONObject;
begin
  var
  filePath := GetEntityFilePath(AID);
  if not TFile.Exists(filePath) then
    raise Exception.CreateFmt('Entity file not found: %d', [AID]);

  try
    jsonText := TFile.ReadAllText(filePath);
  except
    on E: Exception do
      raise Exception.CreateFmt('Error reading entity file: %s', [E.Message]);
  end;

  jsonObj := TJSONObject.ParseJSONValue(jsonText) as TJSONObject;
  if not Assigned(jsonObj) then
    raise Exception.Create('Invalid JSON format');

  try
    Result := T.Create;
    EntityFromJSON(Result, jsonObj);
  finally
    jsonObj.Free; // < Освобождаем JSON-объект
  end;
end;

procedure TBaseEntityStorage<T>.SaveEntityToFile(const AEntity: T);
var
  jsonObj: TJSONObject;
begin
  jsonObj := EntityToJSON(AEntity);
  try
    TFile.WriteAllText(GetEntityFilePath(AEntity.ID), jsonObj.ToString);
  finally
    jsonObj.Free; // < Освобождаем JSON-объект
  end;
end;

procedure TBaseEntityStorage<T>.EnsureCacheSize;
var
  keysToRemove: TList<Integer>;
  i: Integer;
begin
  if FCache.Count > FMaxCacheSize then
  begin
    keysToRemove := TList<Integer>.Create;
    try
      for i := 0 to FCache.Count - FMaxCacheSize - 1 do
        keysToRemove.Add(FCache.Keys.ToArray[i]);
      for i := 0 to keysToRemove.Count - 1 do
        FCache.Remove(keysToRemove[i]);
    finally
      keysToRemove.Free;
    end;
  end;
end;

function TBaseEntityStorage<T>.GetNextID: Integer;
begin
  if FCache.Count = 0 then
    Result := 1
  else
    Result := MaxIntValue(FCache.Keys.ToArray) + 1;
end;

function TBaseEntityStorage<T>.CreateEntity(const AEntity: T): Integer;
begin
  var
  newID := GetNextID;
  AEntity.ID := newID;
  FCache.Add(newID, AEntity);
  SaveEntityToFile(AEntity);
  EnsureCacheSize;
  Result := newID;
end;

function TBaseEntityStorage<T>.ReadEntity(const AID: Integer): T;
begin
  if not FCache.TryGetValue(AID, Result) then
  begin
    Result := LoadEntityFromFile(AID);
    FCache.Add(AID, Result);
  end;
end;

procedure TBaseEntityStorage<T>.UpdateEntity(const AEntity: T);
begin
  SaveEntityToFile(AEntity);
  FCache.AddOrSetValue(AEntity.ID, AEntity);
  EnsureCacheSize;
end;

procedure TBaseEntityStorage<T>.DeleteEntity(const AID: Integer);
begin
  FCache.Remove(AID);
  TFile.Delete(GetEntityFilePath(AID));
end;

function TBaseEntityStorage<T>.GetAllEntities: TObjectList<T>;
begin
  Result := TObjectList<T>.Create(False);
  for var entity in FCache.Values do
    Result.Add(entity);
end;

function TBaseEntityStorage<T>.ToJSON(const AEntity: T): string;
var
  JSONObject: TJSONObject;
begin
  JSONObject := EntityToJSON(AEntity);
  try
    Result := JSONObject.ToString;
  finally
    JSONObject.Free;
  end;
end;

procedure TBaseEntityStorage<T>.FromJSON(const AEntity: T;
  const AJSONString: string);
var
  jsonObj: TJSONObject;
begin
  jsonObj := TJSONObject.ParseJSONValue(AJSONString) as TJSONObject;
  try
    EntityFromJSON(AEntity, jsonObj);
  finally
    jsonObj.Free;
  end;
end;

procedure TBaseEntityStorage<T>.CacheRttiInfo;
begin
  FCachedRttiType := FRttiContext.GetType(TypeInfo(T));
  if FCachedRttiType = nil then
    raise Exception.CreateFmt('RTTI type information not found for type: %s',
      [T.ClassName]);

  FCachedProperties := FCachedRttiType.GetProperties;
  if Length(FCachedProperties) = 0 then
    raise Exception.CreateFmt('No properties found for type: %s',
      [T.ClassName]);
end;

function TBaseEntityStorage<T>.EntityToJSON(const AEntity: T): TJSONObject;
var
  JSONObject: TJSONObject;
  prop: TRttiProperty;
  value: TValue;
begin
  JSONObject := TJSONObject.Create;
  try
    for prop in FCachedProperties do
    begin
      if not prop.IsReadable then
        Continue;

      value := prop.GetValue(TObject(AEntity));
      case value.Kind of
        tkInteger, tkInt64, tkChar, tkString, tkLString, tkWChar, tkWString,
          tkUnicodeString, tkFloat, tkEnumeration, tkSet:
          JSONObject.AddPair(prop.Name, value.ToString);
        tkClass:
          begin
            if prop.PropertyType.TypeKind = tkClass then
            begin
              var
              obj := value.AsObject;
              if obj is TBaseEntity then
                {
                  var
                  nestedJSON := EntityToJSON(TBaseEntity(obj));
                  JSONObject.AddPair(prop.Name, nestedJSON);
                }
            end;
          end;
      end;
    end;
    Result := JSONObject;
  except
    JSONObject.Free;
    raise;
  end;
end;

procedure TBaseEntityStorage<T>.EntityFromJSON(const AEntity: T;
  const AJSONObj: TJSONObject);
var
  prop: TRttiProperty;
  jsonValue: TJSONValue;
  strValue: string;
begin
  for prop in FCachedProperties do
  begin
    if not prop.IsWritable then
      Continue;

    if AJSONObj.TryGetValue(prop.Name, jsonValue) then
      {
        strValue := jsonValue.value;
        case prop.PropertyType.TypeKind of
        tkInteger:
        prop.SetValue(TObject(AEntity), StrToInt(strValue));
        tkInt64:
        prop.SetValue(TObject(AEntity), StrToInt64(strValue));
        tkChar, tkString, tkLString, tkWChar, tkWString, tkUnicodeString:
        prop.SetValue(TObject(AEntity), strValue);
        tkFloat:
        prop.SetValue(TObject(AEntity), StrToFloat(strValue));
        tkEnumeration:
        begin
        var
        enumValue := GetEnumValue(prop.PropertyType.Handle, strValue);
        if enumValue = -1 then
        raise Exception.CreateFmt
        ('Invalid enum value for property "%s": %s', [prop.Name, strValue]);
        prop.SetValue(TObject(AEntity),
        TValue.FromOrdinal(prop.PropertyType.Handle, enumValue));
        end;
        tkSet:
        begin
        var
        SetValue := StringToSet(prop.PropertyType.Handle, strValue);
        prop.SetValue(TObject(AEntity),
        TValue.FromOrdinal(prop.PropertyType.Handle, Integer(SetValue)));
        end;
        tkClass:
        begin
        if prop.PropertyType.TypeKind = tkClass then
        {
        var
        obj := prop.GetValue(TObject(AEntity)).AsObject;
        if obj is TBaseEntity then
        EntityFromJSON(TBaseEntity(obj),
        TJSONObject.ParseJSONValue(strValue) as TJSONObject);
      }
  end;
end;

end.
