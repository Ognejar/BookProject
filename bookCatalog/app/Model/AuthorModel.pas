unit AuthorModel;

{
  Автор: Бегтин К.В. (Огнеяр)
  Проект: Библиотека Дементора
  Лицензия: Freeware
  Версия: 3.4
  Дата создания: 2025

  Описание:
    Модуль AuthorModel содержит методы для манипуляции данными, связанными с авторами.
    Методы включают создание, чтение, обновление и удаление информации об авторах.

  История изменений:
    [2025-01-31] Создание модуля с базовыми методами для работы с TAuthor.
    [2025-01-31] Добавлены комментарии и проверка данных.
    [2025-02-06] Исправлены вызовы конструктора TAuthor.Create с передачей параметров.
}

interface

uses
  System.SysUtils,
  System.Classes,
  AuthorTypes;

type
  TAuthorManipulation = class
  public
    { Создает нового автора }
    function CreateAuthor(const AName, ABio: string): TAuthor;

    { Обновляет данные существующего автора }
    function UpdateAuthor(const AAuthor: TAuthor): Boolean;

    { Удаляет автора по его идентификатору }
    function DeleteAuthor(const AAuthorID: Integer): Boolean;

    { Получает автора по его идентификатору }
    function GetAuthorByID(const AAuthorID: Integer): TAuthor;

    { Ищет авторов по имени }
    function FindAuthorByName(const AName: string): TArray<TAuthor>;

    { Получает всех авторов }
    function GetAllAuthors: TArray<TAuthor>;
  end;

implementation

{ TAuthorManipulation }

function TAuthorManipulation.CreateAuthor(const AName, ABio: string): TAuthor;
begin
  if Trim(AName) = '' then
    raise Exception.Create('Имя автора не может быть пустым.');

  Result := TAuthor.Create(AName, ABio);
end;

function TAuthorManipulation.UpdateAuthor(const AAuthor: TAuthor): Boolean;
begin
  if AAuthor = nil then
    raise Exception.Create('Объект автора не может быть nil.');

  // Здесь должен быть код для обновления данных автора
  Result := True;
end;

function TAuthorManipulation.DeleteAuthor(const AAuthorID: Integer): Boolean;
begin
  if AAuthorID <= 0 then
    raise Exception.Create('Идентификатор автора должен быть положительным числом.');

  // Здесь должен быть код для удаления автора
  Result := True;
end;

function TAuthorManipulation.GetAuthorByID(const AAuthorID: Integer): TAuthor;
begin
  if AAuthorID <= 0 then
    raise Exception.Create('Идентификатор автора должен быть положительным числом.');

  // Здесь должен быть код для получения автора из хранилища
  Result := TAuthor.Create('Sample Author', 'Sample Biography');
end;

function TAuthorManipulation.FindAuthorByName(const AName: string): TArray<TAuthor>;
begin
  if Trim(AName) = '' then
    raise Exception.Create('Имя автора не может быть пустым.');

  // Здесь должен быть код для поиска авторов
  SetLength(Result, 1);
  Result[0] := TAuthor.Create(AName, 'Sample Biography');
end;

function TAuthorManipulation.GetAllAuthors: TArray<TAuthor>;
begin
  // Здесь должен быть код для получения всех авторов из хранилища
  SetLength(Result, 2);
  Result[0] := TAuthor.Create('Author 1', 'Biography 1');
  Result[1] := TAuthor.Create('Author 2', 'Biography 2');
end;

end.

