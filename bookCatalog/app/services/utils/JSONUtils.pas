unit JSONUtils;

{
  Модуль: JSONUtils
  Автор: Бегтин К.В. (Огнеяр)
  Проект: Библиотека Дементора
  Лицензия: Freeware
  Версия: 1.6.0
  Дата создания: 2025-02-16

  Описание:
    Модуль JSONUtils предоставляет функции для работы с JSON-данными.
    Включает в себя функции для сортировки полей в JSON-объектах,
    рекурсивной обработки вложенных структур, а также другие вспомогательные операции.

  История изменений:
    [2025-02-08] Создан модуль с функцией сортировки JSON-полей.
    [2025-02-09] Добавлена рекурсивная обработка вложенных объектов и массивов.
    [2025-02-10] Исправлены ошибки, связанные с обработкой дубликатов ключей.
    [2025-02-11] Улучшена производительность сортировки для больших JSON-объектов.
    [2025-02-12] Версия 1.3.1: Оптимизация использования памяти и улучшение читаемости кода.
    [2025-02-13] Версия 1.4.0: Изменена сигнатура функции SortJSONFields для возврата строки.
    [2025-02-14] Версия 1.5.0: Изменена функция SortJSONFields для работы со строками.
    [2025-02-15] Версия 1.5.1: Исправлены ошибки в объявлении и реализации функции SortJSONValue.
    [2025-02-16] Версия 1.6.0: Добавлена поддержка сортировки массивов и исправлены ошибки типов.
}

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections, System.Generics.Defaults;

{ Сортирует поля в JSON-объекте в алфавитном порядке, сохраняя последнее значение для дубликатов.
  Рекурсивно обрабатывает вложенные объекты и массивы.
  Принимает и возвращает JSON в виде строки. }
function SortJSONFields(const JSONObject: string): string;

{ Вспомогательная рекурсивная функция для сортировки }
function SortJSONValue(const Value: TJSONValue): TJSONValue;

{ Вспомогательная функция для сортировки массивов }
function SortJSONArray(const ArrayValue: TJSONArray): TJSONArray;

implementation

function SortJSONValue(const Value: TJSONValue): TJSONValue;
var
  Obj: TJSONObject;
  Arr: TJSONArray;
  Pair: TJSONPair;
  Element: TJSONValue;
  SortedObj: TJSONObject;
  SortedArr: TJSONArray;
  KeyMap: TDictionary<string, TJSONValue>;
  SortedKeys: TArray<string>;
begin
  if Value is TJSONObject then
  begin
    Obj := Value as TJSONObject;
    SortedObj := TJSONObject.Create;
    try
      KeyMap := TDictionary<string, TJSONValue>.Create;
      try
        for Pair in Obj do
          KeyMap.AddOrSetValue(Pair.JsonString.Value, SortJSONValue(Pair.JsonValue));

        SortedKeys := KeyMap.Keys.ToArray;
        TArray.Sort<string>(SortedKeys, TComparer<string>.Construct(
          function(const Left, Right: string): Integer
          begin
            Result := CompareText(Left, Right);
          end
        ));

        for var Key in SortedKeys do
          SortedObj.AddPair(Key, KeyMap[Key]);

        Result := SortedObj;
      finally
        KeyMap.Free;
      end;
    except
      SortedObj.Free;
      raise;
    end;
  end
  else if Value is TJSONArray then
  begin
    Arr := Value as TJSONArray;
    SortedArr := TJSONArray.Create;
    try
      for Element in Arr do
      begin
        if Element is TJSONObject then
          SortedArr.AddElement(SortJSONValue(Element))
        else
          SortedArr.AddElement(TJSONValue(Element.Clone));
      end;
      Result := SortedArr;
    except
      SortedArr.Free;
      raise;
    end;
  end
  else
  begin
    Result := TJSONValue(Value.Clone);
  end;
end;

function SortJSONArray(const ArrayValue: TJSONArray): TJSONArray;
var
  SortedArray: TJSONArray;
  Element: TJSONValue;
begin
  SortedArray := TJSONArray.Create;
  try
    for Element in ArrayValue do
    begin
      if Element is TJSONObject then
        SortedArray.AddElement(SortJSONValue(Element))
      else
        SortedArray.AddElement(TJSONValue(Element.Clone)); // Исправлено приведение типа
    end;
    Result := SortedArray;
  except
    SortedArray.Free;
    raise;
  end;
end;

function SortJSONFields(const JSONObject: string): string;
var
  JSONValue: TJSONValue;
begin
  if Assigned(JSONValue) then
  begin
  JSONValue := TJSONObject.ParseJSONValue(JSONObject);
    try
      if JSONValue is TJSONObject then
      begin
        Result := SortJSONValue(JSONValue).ToString;
      end
      else if JSONValue is TJSONArray then
      {
        Здесь мы должны рекурсивно сортировать каждый объект в массиве.
        Если элементы массива не являются объектами, мы просто возвращаем массив как есть.
      }
      begin
        Result := SortJSONArray(JSONValue as TJSONArray).ToString;
      end
      else
      {
        Если входная строка не является JSON-объектом или массивом, возвращаем её как есть.
        В данном случае, это может быть строка, число, логическое значение и т.д.
      }
      begin
        Result := JSONObject;
      end;
    finally
      JSONValue.Free;
    end;
  end
  else
  begin
    // Если парсинг не удался, возвращаем пустую строку
    Result := '';
  end;
end;

end.
