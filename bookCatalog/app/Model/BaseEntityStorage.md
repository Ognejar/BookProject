
```markdown
# BaseEntityStorage

## Описание

Модуль `BaseEntityStorage` предоставляет универсальное хранилище для сущностей, наследуемых от класса `TBaseEntity`. Он обеспечивает базовые операции CRUD (создание, чтение, обновление, удаление) и управление данными в файловой системе с использованием формата JSON.

## Назначение

- Управление данными сущностей в файловой системе.
- Поддержка кэширования для повышения производительности операций чтения.
- Универсальность: работа с любыми сущностями, наследуемыми от `TBaseEntity`.

## Класс TBaseEntity

Базовый класс для всех сущностей, содержащий свойство `ID`.

```pascal
type
  TBaseEntity = class
  private
    FID: Integer;
  public
    property ID: Integer read FID write FID;
  end;
```

## Класс TBaseEntityStorage<T>

Универсальный класс для хранения и управления сущностями типа `T`, где `T` наследуется от `TBaseEntity`.

### Параметры типа

- `T`: Тип сущности, должен наследоваться от `TBaseEntity` и иметь конструктор по умолчанию.

### Методы

#### Конструктор

```pascal
constructor Create(const ADataPath: string; AMaxCacheSize: Integer = 100);
```

- **Описание**: Инициализирует хранилище данных.
- **Параметры**:
  - `ADataPath`: Путь к каталогу, где будут храниться файлы сущностей.
  - `AMaxCacheSize`: Максимальный размер кэша (по умолчанию 100).

#### Деструктор

```pascal
destructor Destroy;
```

- **Описание**: Освобождает ресурсы, связанные с хранилищем.

#### CreateEntity

```pascal
function CreateEntity(const AEntity: T): Integer;
```

- **Описание**: Создает новую сущность и сохраняет ее в хранилище.
- **Параметры**:
  - `AEntity`: Сущность для создания.
- **Возвращает**: ID созданной сущности.

#### ReadEntity

```pascal
function ReadEntity(const AID: Integer): T;
```

- **Описание**: Читает сущность по ID из хранилища.
- **Параметры**:
  - `AID`: ID сущности.
- **Возвращает**: Сущность с указанным ID.

#### UpdateEntity

```pascal
procedure UpdateEntity(const AEntity: T);
```

- **Описание**: Обновляет существующую сущность в хранилище.
- **Параметры**:
  - `AEntity`: Сущность для обновления.

#### DeleteEntity

```pascal
procedure DeleteEntity(const AID: Integer);
```

- **Описание**: Удаляет сущность по ID из хранилища.
- **Параметры**:
  - `AID`: ID сущности.

#### GetAllEntities

```pascal
function GetAllEntities: TObjectList<T>;
```

- **Описание**: Возвращает список всех сущностей в хранилище.
- **Возвращает**: Список сущностей.

#### FindEntityByProperty

```pascal
function FindEntityByProperty(const APropertyName: string; AValue: TValue): T;
```

- **Описание**: Ищет сущность по значению свойства.
- **Параметры**:
  - `APropertyName`: Имя свойства.
  - `AValue`: Значение свойства.
- **Возвращает**: Сущность, если найдена, иначе `nil`.

#### ToJSON

```pascal
function ToJSON(const AEntity: T): string;
```

- **Описание**: Преобразует сущность в строку JSON.
- **Параметры**:
  - `AEntity`: Сущность для преобразования.
- **Возвращает**: Строка JSON.

#### FromJSON

```pascal
procedure FromJSON(const AEntity: T; const AJSONString: string);
```

- **Описание**: Преобразует строку JSON в сущность.
- **Параметры**:
  - `AEntity`: Сущность для заполнения.
  - `AJSONString`: Строка JSON.

### Пример использования

```pascal
uses
  BaseEntityStorage, System.SysUtils, System.Generics.Collections;

type
  TMyEntity = class(TBaseEntity)
  private
    FName: string;
    FValue: Integer;
  public
    property Name: string read FName write FName;
    property Value: Integer read FValue write FValue;
  end;

var
  Storage: TBaseEntityStorage<TMyEntity>;
  Entity: TMyEntity;
  ID: Integer;
begin
  Storage := TBaseEntityStorage<TMyEntity>.Create('C:\Data\Entities');
  try
    Entity := TMyEntity.Create;
    Entity.Name := 'Example';
    Entity.Value := 42;
    ID := Storage.CreateEntity(Entity);
    WriteLn('Created entity with ID: ', ID);
  finally
    Storage.Free;
  end;
end.
```

## Зависимости

- `System.Classes`
- `System.SysUtils`
- `System.Generics.Collections`
- `System.JSON`
- `System.IOUtils`
- `System.Rtti`
- `System.Math`

## Лицензия

Freeware

## Автор

Бегтин К.В. (Огнеяр)

## История изменений

- **2025-01-10**: Создание базового класса для хранения данных и управления ими.

```

