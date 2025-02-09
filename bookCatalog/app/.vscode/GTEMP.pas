unit StringUtils;

interface

uses
  System.Generics.Collections, // Коллекции общего назначения
  System.Generics.Defaults, // Для использования TComparer
  System.JSON, // Работа с JSON
  System.SysUtils, // Системные утилиты
  System.StrUtils, // Дополнительные функции для работы со строками
  System.Classes, // Классы общего назначения
  System.IOUtils, // Функции для работы с файловой системой
  System.RegularExpressions; // Для регулярных выражений

// Нормализует имя файла, урезая его до 100 символов, оставляя
// кириллические символы и заменяя недопустимые символы.
function NormalizeFileName(const FileName: string): string;

// Сортирует поля в JSON-строке в алфавитном порядке.
function SortJSONFields(const JSONString: string): string;

// Генерирует уникальное имя папки на основе названия книги, добавляя
// числовой суффикс, если необходимо.
function GenerateUniqueFolderName(const BookTitle: string;
  MaxLength: Integer = 100): string;

function PadRight(const Str: string; TotalWidth: Integer;
  PadChar: Char = ' '): string;

implementation

function NormalizeFileName(const FileName: string): string;
const
  InvalidChars: string = '/\:*?"<>|';
  MaxLength = 100;
var
  i, j: Integer;
  Normalized: string;
begin
  Writeln('NormalizeFileName: Starting normalization for "' + FileName + '"');
  Normalized := FileName;

  // Заменяем недопустимые символы на "_"
  for i := 1 to Length(Normalized) do
  begin
    for j := 1 to Length(InvalidChars) do
    begin
      if Normalized[i] = InvalidChars[j] then
      begin
        Writeln('NormalizeFileName: Replacing character "' + Normalized[i] + '" with "_"');
        Normalized[i] := '_';  // Заменяем недопустимый символ на "_"
        Break;  // Прерываем внутренний цикл, как только нашли первый несовпадающий символ
      end;
    end;
  end;

  // Урезаем до 100 символов
  if Length(Normalized) > MaxLength then
  begin
    Writeln('NormalizeFileName: Truncating to 100 characters');
    Normalized := Copy(Normalized, 1, MaxLength);
  end;

  // Приводим к нижнему регистру
  Writeln('NormalizeFileName: Converting to lower case');
  Result := ANSILowerCase(Normalized);
  Writeln('NormalizeFileName: Normalization completed');
end;

function SortJSONFields(const JSONString: string): string;
var
  JSONObject: TJSONObject;
  SortedList: TList<TJSONPair>;
  SortedJSON: TJSONObject;
  Pair: TJSONPair;
begin
  // Парсим JSON-строку в объект
  JSONObject := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
  if not Assigned(JSONObject) then
    raise Exception.Create('Invalid JSON string.');

  SortedList := TList<TJSONPair>.Create;
  try
    // Добавляем пары из JSONObject в список для сортировки
    for Pair in JSONObject do
      SortedList.Add(Pair);

    // Сортируем список по ключам
    SortedList.Sort(
      TComparer<TJSONPair>.Construct(
        function(const Left, Right: TJSONPair): Integer
        begin
          Result := CompareText(Left.JsonString.Value, Right.JsonString.Value);
        end)
    );

    // Создаем новый объект JSON и добавляем отсортированные пары
    SortedJSON := TJSONObject.Create;
    try
      for Pair in SortedList do
        SortedJSON.AddPair(Pair.JsonString.Clone as TJSONString, Pair.JsonValue.Clone as TJSONValue);

      // Преобразуем отсортированный объект в строку
      Result := SortedJSON.ToString;
    finally
      SortedJSON.Free;
    end;
  finally
    SortedList.Free;
    JSONObject.Free;
  end;
end;


function GenerateUniqueFolderName(const BookTitle: string;
MaxLength: Integer = 100): string;
var
  BaseName: string;
  Counter: Integer;
  NewName: string;
begin
  BaseName := NormalizeFileName(BookTitle);
  Result := BaseName;

  // Проверка на существование папки и добавление суффикса
  if TDirectory.Exists(BaseName) then
  begin
    Counter := 1;
    repeat
      NewName := Format('%s_%d', [BaseName, Counter]);
      Inc(Counter);
    until not TDirectory.Exists(NewName);
    Result := NewName;
  end;
end;

function PadRight(const Str: string; TotalWidth: Integer;
PadChar: Char = ' '): string;
begin
  if Length(Str) >= TotalWidth then
    Result := Str
  else
    Result := Str + StringOfChar(PadChar, TotalWidth - Length(Str));
end;

end.
