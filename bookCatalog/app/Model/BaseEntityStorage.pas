unit BaseEntityStorage;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.JSON, System.IOUtils, System.Rtti, System.Math;

type
  TBaseEntity = class
  private
    FID: Integer;
  public
    property ID: Integer read FID write FID;
  end;

  TBaseEntityStorage<T: TBaseEntity, constructor> = class
  private
    FDataPath: string;
    FCache: TObjectDictionary<Integer, T>;
    FMaxCacheSize: Integer;
    FRttiContext: TRttiContext;
    function GetEntityFilePath(const AID: Integer): string;
    function LoadEntityFromFile(const AID: Integer): T;
    procedure SaveEntityToFile(const AEntity: T);
    procedure EnsureCacheSize;
    function GetNextID: Integer;
    function EntityToJSON(const AEntity: T): TJSONObject;
    procedure EntityFromJSON(const AEntity: T; const AJSONObj: TJSONObject);
  public
    constructor Create(const ADataPath: string; AMaxCacheSize: Integer = 100);
    destructor Destroy; override;
    // CRUD операции
    function CreateEntity(const AEntity: T): Integer; virtual;
    function ReadEntity(const AID: Integer): T; virtual;
    procedure UpdateEntity(const AEntity: T); virtual;
    procedure DeleteEntity(const AID: Integer); virtual;
    // Дополнительные методы
    function GetAllEntities: TObjectList<T>; virtual;
    function FindEntityByProperty(const APropertyName: string; AValue: TValue): T; virtual;
    // Универсальные методы для сериализации и десериализации JSON
    function ToJSON(const AEntity: T): string;
    procedure FromJSON(const AEntity: T; const AJSONString: string);
  end;

implementation

{ TBaseEntityStorage<T> }

constructor TBaseEntityStorage<T>.Create(const ADataPath: string; AMaxCacheSize: Integer);
begin
  inherited Create;
  FDataPath := ADataPath;
  FMaxCacheSize := AMaxCacheSize;
  FCache := TObjectDictionary<Integer, T>.Create([doOwnsValues]);
  FRttiContext := TRttiContext.Create;
  if not TDirectory.Exists(FDataPath) then
    TDirectory.CreateDirectory(FDataPath);
end;

destructor TBaseEntityStorage<T>.Destroy;
begin
  FCache.Free;
  FRttiContext.Free;
  inherited;
end;

function TBaseEntityStorage<T>.GetEntityFilePath(const AID: Integer): string;
begin
  Result := TPath.Combine(FDataPath, Format('%d.json', [AID]));
end;

function TBaseEntityStorage<T>.LoadEntityFromFile(const AID: Integer): T;
var
  jsonText: string;
  jsonObj: TJSONObject;
begin
  var filePath := GetEntityFilePath(AID);
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
    jsonObj.Free;
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
    jsonObj.Free;
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
  Result := 1;
  if FCache.Count > 0 then
    Result := MaxIntValue(FCache.Keys.ToArray) + 1;
end;

function TBaseEntityStorage<T>.CreateEntity(const AEntity: T): Integer;
begin
  var newID := GetNextID;
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
  Result := TObjectList<T>.Create(False); // Не владеем объектами, так как они уже в кэше
  for var entity in FCache.Values do
    Result.Add(entity);
end;

function TBaseEntityStorage<T>.FindEntityByProperty(const APropertyName: string; AValue: TValue): T;
var
  rttiType: TRttiType;
  prop: TRttiProperty;
  entity: T;
  value: TValue;
begin
  rttiType := FRttiContext.GetType(T);
  prop := rttiType.GetProperty(APropertyName);
  if not Assigned(prop) then
    raise Exception.CreateFmt('Property "%s" not found in entity', [APropertyName]);
  for entity in FCache.Values do
  begin
    value := prop.GetValue(TObject(entity));
    if value.Kind = AValue.Kind then
    begin
      case value.Kind of
        tkInteger, tkInt64:
          if value.AsOrdinal = AValue.AsOrdinal then
            Exit(entity);
        tkChar, tkString, tkLString, tkWChar, tkWString, tkUnicodeString:
          if value.AsString = AValue.AsString then
            Exit(entity);
        tkFloat:
          if SameValue(value.AsExtended, AValue.AsExtended, 0.00001) then
            Exit(entity);
      end;
    end;
  end;
  Result := nil;
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

procedure TBaseEntityStorage<T>.FromJSON(const AEntity: T; const AJSONString: string);
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

function TBaseEntityStorage<T>.EntityToJSON(const AEntity: T): TJSONObject;
var
  JSONObject: TJSONObject;
  rttiType: TRttiType;
  prop: TRttiProperty;
  value: TValue;
begin
  JSONObject := TJSONObject.Create;
  try
    rttiType := FRttiContext.GetType(T);
    for prop in rttiType.GetProperties do
    begin
      if not Assigned(prop) then
        Continue;
      if prop.PropertyType.TypeKind in [tkInteger, tkInt64, tkChar, tkString, tkLString, tkWChar, tkWString, tkUnicodeString] then
      begin
        value := prop.GetValue(TObject(AEntity));
        JSONObject.AddPair(prop.Name, value.ToString);
      end;
    end;
    Result := JSONObject;
  except
    JSONObject.Free;
    raise;
  end;
end;

procedure TBaseEntityStorage<T>.EntityFromJSON(const AEntity: T; const AJSONObj: TJSONObject);
var
  rttiType: TRttiType;
  prop: TRttiProperty;
  value: TValue;
  jsonValue: TJSONValue;
  strValue: string;
  objValue: TObject;
begin
  rttiType := FRttiContext.GetType(T);
  for prop in rttiType.GetProperties do
  begin
    if not Assigned(prop) then
      Continue;
    if prop.PropertyType.TypeKind in [tkInteger, tkInt64, tkChar, tkString, tkLString, tkWChar, tkWString, tkUnicodeString] then
    begin
      if AJSONObj.TryGetValue(prop.Name, jsonValue) then
      begin
        strValue := jsonValue.Value;
        case prop.PropertyType.TypeKind of
          tkInteger:
            begin
              value := StrToInt(strValue);
              objValue := TObject(AEntity);
              prop.SetValue(objValue, value);
            end;
          tkInt64:
            begin
              value := StrToInt64(strValue);
              objValue := TObject(AEntity);
              prop.SetValue(objValue, value);
            end;
          tkChar, tkString, tkLString, tkWChar, tkWString, tkUnicodeString:
            begin
              value := strValue;
              objValue := TObject(AEntity);
              prop.SetValue(objValue, value);
            end;
        end;
      end;
    end;
  end;
end;

end.
