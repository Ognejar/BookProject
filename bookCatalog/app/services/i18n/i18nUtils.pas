unit i18nUtils;

{
  Автор: Бегтин К.В. (Огнеяр)
  Название проекта: Библиотека Дементора
  Лицензия: Freeware
  Год создания: 2025
  Версия: 3.1
  Назначение модуля:
  Модуль i18nUtils содержит вспомогательные функции и процедуры,
  используемые в системе интернационализации (i18n).
  Включает утилиты для работы со строками, проверки корректности данных,
  и упрощённого доступа к переводам.
}

interface

uses
  System.SysUtils, System.Classes, I18N.Manager;

{ Проверяет, является ли строка валидным кодом локали (например, 'en-US') }
function IsValidLocaleCode(const LocaleCode: string): Boolean;

{ Преобразует строку в нижний регистр для унификации ключей переводов }
function NormalizeKey(const Key: string): string;

{ Загружает содержимое файла в строку }
function LoadFileContent(const FileName: string): string;

{ Упрощённая функция для получения перевода по ключу }
function _(const Key: string): string;

implementation

var
  I18NManager: TI18NManager;

{*
  Проверяет, соответствует ли строка формату локали (например, 'en', 'ru-RU').
  @param LocaleCode - Код локали.
  @return True, если строка является валидным кодом локали.
*}
function IsValidLocaleCode(const LocaleCode: string): Boolean;
begin
  Result := TRegEx.IsMatch(LocaleCode, '^[a-z]{2}(-[A-Z]{2})?$');
end;

{*
  Преобразует ключ перевода в нижний регистр для унификации.
  @param Key - Ключ перевода.
  @return Преобразованный ключ.
*}
function NormalizeKey(const Key: string): string;
begin
  Result := Key.ToLower;
end;

{*
  Загружает содержимое текстового файла в строку.
  @param FileName - Имя файла.
  @return Содержимое файла в виде строки.
*}
function LoadFileContent(const FileName: string): string;
var
  StringList: TStringList;
begin
  if not FileExists(FileName) then
    raise Exception.CreateFmt('Файл не найден: %s', [FileName]);

  StringList := TStringList.Create;
  try
    StringList.LoadFromFile(FileName, TEncoding.UTF8);
    Result := StringList.Text;
  finally
    StringList.Free;
  end;
end;

{*
  Упрощённая функция для получения перевода по ключу.
  @param Key - Ключ перевода.
  @return Переведённая строка.
*}
function _(const Key: string): string;
begin
  if not Assigned(I18NManager) then
    I18NManager := TI18NManager.Create;

  Result := I18NManager.Translate(Key);
end;

initialization
  I18NManager := TI18NManager.Create;

finalization
  I18NManager.Free;

end.
