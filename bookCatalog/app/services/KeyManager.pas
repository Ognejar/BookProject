unit KeyManager;

{
  Автор: Бегтин К.В. (Огнеяр)
  Проект: Библиотека Дементора
  Лицензия: Freeware
  Версия: 1.0.3
  Дата создания: 2025

  Описание:
    Модуль KeyManager отвечает за генерацию, хранение и валидацию
    целочисленных ключей. Поддерживает создание автоинкрементных
    идентификаторов для различных сущностей базы данных в оперативной памяти.

  История изменений:
    [2025-01-31] Создан модуль с базовыми функциями управления ключами (GUID).
    [2025-02-05] Добавлена проверка на пустой ключ, улучшена валидация GUID.
                 Добавлена функция удаления ключей из хранилища.
    [2025-02-06] Переход на целочисленные ключи для оптимизации работы
                 с базой данных в памяти.
    [2025-02-06] Добавлена поддержка именованных пространств ключей через GetNextKey.
    [2025-02-06] Добавлена функция получения текущего ключа через GetCurrentKey.
}

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TKeyManager = class
  private
    FKeyStorage: TDictionary<string, Integer>;
  public
    constructor Create;
    destructor Destroy; override;

    { Возвращает следующий уникальный ключ для заданного имени }
    function GetNextKey(const Name: string): Integer;

    { Возвращает текущий ключ для заданного имени без увеличения счётчика }
    function GetCurrentKey(const Name: string): Integer;

    { Проверяет, существует ли ключ для указанного имени }
    function KeyExists(const Name: string; const Key: Integer): Boolean;

    { Сбрасывает счётчик ключей для указанного имени }
    procedure ResetKeys(const Name: string);
  end;

implementation

{ TKeyManager }

constructor TKeyManager.Create;
begin
  inherited Create;
  FKeyStorage := TDictionary<string, Integer>.Create;
end;

destructor TKeyManager.Destroy;
begin
  FKeyStorage.Free;
  inherited Destroy;
end;

function TKeyManager.GetNextKey(const Name: string): Integer;
begin
  if not FKeyStorage.ContainsKey(Name) then
    FKeyStorage.Add(Name, 1)
  else
    FKeyStorage[Name] := FKeyStorage[Name] + 1;

  Result := FKeyStorage[Name];
end;

function TKeyManager.GetCurrentKey(const Name: string): Integer;
begin
  if not FKeyStorage.ContainsKey(Name) then
    raise EKeyNotFoundException.CreateFmt('Пространство имён "%s" не найдено.', [Name]);
  
  Result := FKeyStorage[Name];
end;

function TKeyManager.KeyExists(const Name: string; const Key: Integer): Boolean;
begin
  Result := FKeyStorage.ContainsKey(Name) and (FKeyStorage[Name] >= Key);
end;

procedure TKeyManager.ResetKeys(const Name: string);
begin
  if FKeyStorage.ContainsKey(Name) then
    FKeyStorage[Name] := 0;
end;

end.
