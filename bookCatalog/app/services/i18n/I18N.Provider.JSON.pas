unit I18N.Provider.JSON;

{
  Автор: Бегтин К.В. (Огнеяр)
  Название проекта: Библиотека Дементора
  Лицензия: Freeware
  Год создания: 2025
  Версия: 3.1
  Назначение модуля:
  Модуль I18N.Provider.JSON предоставляет провайдер переводов,
  использующий JSON-файлы для системы интернационализации (i18n).
  Позволяет загружать переводы из файлов и получать значения по ключам.
}

interface

uses
  System.SysUtils, System.Classes, System.JSON, I18N.Types;

type
  { Класс для работы с переводами из JSON-файлов }
  TJSONTranslationProvider = class(TInterfacedObject, ITranslationProvider)
  private
    FTranslations: TJSONObject; // Хранит загруженные переводы
    procedure LoadTranslations(const FileName: string); // Загружает переводы из файла
  public
    constructor Create(const FileName: string); // Создает провайдер и загружает переводы
    destructor Destroy; override; // Освобождает ресурсы
    function Translate(const Key: string): string; // Возвращает перевод по ключу
  end;

implementation

{ TJSONTranslationProvider }

{*
  Конструктор: Создает объект и загружает переводы из указанного файла.
  @param FileName - Имя файла с переводами.
*}
constructor TJSONTranslationProvider.Create(const FileName: string);
begin
  inherited Create;
  try
    LoadTranslations(FileName); // Загружаем переводы из файла
  except
    on E: Exception do
    begin
      // В случае ошибки при загрузке выбрасываем исключение с описанием
      raise Exception.CreateFmt('Не удалось загрузить переводы из %s: %s', [FileName, E.Message]);
    end;
  end;
end;

{*
  Деструктор: Освобождает ресурсы, связанные с переводами.
*}
destructor TJSONTranslationProvider.Destroy;
begin
  FTranslations.Free; // Освобождаем память, занятую объектом JSON
  inherited;
end;

{*
  Загружает переводы из указанного JSON-файла.
  @param FileName - Имя файла с переводами.
*}
procedure TJSONTranslationProvider.LoadTranslations(const FileName: string);
var
  JSONString: TStringList;
begin
  // Проверяем наличие файла переводов
  if not FileExists(FileName) then
    raise Exception.CreateFmt('Файл переводов не найден: %s', [FileName]);

  JSONString := TStringList.Create;
  try
    JSONString.LoadFromFile(FileName, TEncoding.UTF8); // Загружаем файл в строковый список
    try
      // Парсим JSON-строку в объект
      FTranslations := TJSONObject.ParseJSONValue(JSONString.Text) as TJSONObject;
      if FTranslations = nil then
        raise Exception.Create('Некорректный формат JSON в файле переводов.');
    except
      on E: EJSONException do
        raise Exception.CreateFmt('Ошибка при разборе JSON в файле %s: %s', [FileName, E.Message]);
    end;
  finally
    JSONString.Free; // Освобождаем строковый список
  end;
end;

{*
  Возвращает перевод по указанному ключу.
  @param Key - Ключ перевода.
  @return Строка с переводом или сообщение о его отсутствии.
*}
function TJSONTranslationProvider.Translate(const Key: string): string;
begin
  if Assigned(FTranslations) and FTranslations.TryGetValue(Key, Result) then
    Exit;
  
  // Возвращаем сообщение о том, что перевод не найден
  Result := Format('[Отсутствует перевод: %s]', [Key]);
end;

end.
