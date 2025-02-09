unit ArrayUtils;

{
  Автор: Бегтин К.В. (Огнеяр)
  Название проекта: Библиотека Дементора
  Лицензия: Freeware
  Год создания: 2025
  Версия: 1.0.0
  Назначение:
    Модуль ArrayUtils содержит утилиты для работы с массивами,
    включая функции для поиска, сортировки и обработки данных.

  История изменений:
    [2025-01-31] Создание модуля с базовыми функциями работы с массивами.
}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults;

{ Находит максимальный элемент в массиве }
function FindMax(const Arr: array of Integer): Integer;

{ Находит минимальный элемент в массиве }
function FindMin(const Arr: array of Integer): Integer;

{ Сортирует массив в порядке возрастания }
procedure SortArray(var Arr: array of Integer);

{ Проверяет, содержит ли массив заданное значение }
function Contains(const Arr: array of Integer; Value: Integer): Boolean;

{ Удаляет все вхождения значения из массива }
function RemoveValue
(const Arr: array of Integer; Value: Integer): TArray<Integer>;

implementation

function FindMax(const Arr: array of Integer): Integer;
var
  I: Integer;
begin
  if Length(Arr) = 0 then
    raise Exception.Create('Массив пуст. Невозможно найти максимум.');

  Result := Arr[0];
  for I := 1 to High(Arr) do
    if Arr[I] > Result then
      Result := Arr[I];
end;

function FindMin(const Arr: array of Integer): Integer;
var
  I: Integer;
begin
  if Length(Arr) = 0 then
    raise Exception.Create('Массив пуст. Невозможно найти минимум.');

  Result := Arr[0];
  for I := 1 to High(Arr) do
    if Arr[I] < Result then
      Result := Arr[I];
end;

procedure SortArray(var Arr: array of Integer);
begin
  TArray.Sort<Integer>(Arr, TComparer<Integer>.Default);
end;

function Contains(const Arr: array of Integer; Value: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I in Arr do
    if I = Value then
    begin
      Result := True;
      Break;
    end;
end;

function RemoveValue(const Arr: array of Integer; Value: Integer): TArray<Integer>;
var
  TempList: TList<Integer>;
  I: Integer;
begin
  TempList := TList<Integer>.Create;
  try
    for I in Arr do
      if I <> Value then
        TempList.Add(I);
    Result := TempList.ToArray;
  finally
    TempList.Free;
  end;
end;

end.

