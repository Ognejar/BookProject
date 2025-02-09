unit StringUtils;

{
  Модуль: StringUtils
  Автор: Бегтин К.В. (Огнеяр)
  Проект: Библиотека Дементора
  Лицензия: Freeware
  Версия: 1.4.0
  Дата создания: 2025-02-12

  Описание:
  Модуль StringUtils содержит вспомогательные функции для работы со строками.
  Включает в себя функции обработки, нормализации, генерации и преобразования строк.

  История изменений:
  [2025-01-31] Создан модуль с базовыми строковыми функциями.
  [2025-02-06] Восстановлены утраченные функции, добавлены перегруженные методы.
  [2025-02-07] Исправлена реализация SortJSONFields, добавлена обработка регистра.
  [2025-02-08] Перенесена функция SortJSONFields в модуль JSONUtils.
  [2025-02-12] Добавлены новые функции для работы со строками, включая проверки и преобразования.
  [2025-02-16] Убрана перегрузка функций для AnsiString и WideString.
  [2025-02-17] Убраны функции ReverseString, RemoveDuplicates, IsPalindrome.
}

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Character, JSONUtils;

{ Удаляет начальные и конечные пробелы из строки }
function TrimString(const S: string): string;

{ Преобразует строку в верхний регистр }
function ToUpperCaseString(const S: string): string;

{ Преобразует строку в нижний регистр }
function ToLowerCaseString(const S: string): string;

{ Проверяет, является ли строка числом }
function IsNumeric(const S: string): Boolean;

{ Проверяет, содержит ли строка только буквы (включая кириллицу) }
function IsAlpha(const S: string): Boolean;

{ Проверяет, содержит ли строка только буквы (включая кириллицу) и цифры }
function IsAlphaNumeric(const S: string): Boolean;

{ Проверяет, является ли строка пустой }
function IsEmpty(const S: string): Boolean;

{ Заменяет все вхождения подстроки в строке }
function ReplaceSubstring(const S, OldPattern, NewPattern: string): string;

{ Нормализует имя файла, оставляя кириллические символы и заменяя недопустимые символы }
function NormalizeFileName(const FileName: string): string;

{ Генерирует уникальное имя папки, добавляя числовой суффикс при необходимости }
function GenerateUniqueFolderName(const BaseName: string;
  MaxLength: Integer = 100): string;

{ Дополняет строку справа указанным символом до заданной длины }
function PadRight(const Str: string; TotalWidth: Integer;
  PadChar: Char = ' '): string;

implementation

function TrimString(const S: string): string;
begin
  Result := Trim(S);
end;

function ToUpperCaseString(const S: string): string;
begin
  Result := S.ToUpper;
end;

function ToLowerCaseString(const S: string): string;
begin
  Result := S.ToLower;
end;

function IsNumericHelper(const S: string): Boolean;
var
  I: Integer;
  HasDecimalPoint: Boolean;
begin
  Result := S <> '';
  HasDecimalPoint := False;
  for I := 1 to Length(S) do
  begin
    if S[I] = '.' then
    begin
      if HasDecimalPoint then
      begin
        Result := False;
        Exit;
      end;
      HasDecimalPoint := True;
    end
    else if not S[I].IsDigit then
    begin
      if (I = 1) and (S[I] in ['+', '-']) then
        Continue;
      Result := False;
      Exit;
    end;
  end;
end;

function IsNumeric(const S: string): Boolean;
begin
  Result := IsNumericHelper(S);
end;

function IsAlpha(const S: string): Boolean;
var
  I: Integer;
begin
  Result := S <> '';
  for I := 1 to Length(S) do
    if not TCharacter.IsLetter(S[I]) then
    begin
      Result := False;
      Exit;
    end;
end;

function IsAlphaNumeric(const S: string): Boolean;
var
  I: Integer;
begin
  Result := S <> '';
  for I := 1 to Length(S) do
    if not (TCharacter.IsLetter(S[I]) or S[I].IsDigit) then
    begin
      Result := False;
      Exit;
    end;
end;

function IsEmpty(const S: string): Boolean;
begin
  Result := S = '';
end;

function ReplaceSubstring(const S, OldPattern, NewPattern: string): string;
begin
  Result := StringReplace(S, OldPattern, NewPattern, [rfReplaceAll]);
end;

function NormalizeFileName(const FileName: string): string;
const
  InvalidChars: array [1 .. 11] of Char = ('\', '/', ':', '*', '?', '"', '<',
    '>', '|', ' ', '''');
var
  C: Char;
begin
  Result := LowerCase(FileName);
  for C in InvalidChars do
    Result := StringReplace(Result, C, '_', [rfReplaceAll]);
  if Length(Result) > 100 then
    Result := Copy(Result, 1, 100);
end;

function GenerateUniqueFolderName(const BaseName: string;
  MaxLength: Integer = 100): string;
var
  Suffix: Integer;
  FolderName: string;
begin
  Suffix := 1;
  FolderName := Copy(BaseName, 1, MaxLength);
  while DirectoryExists(FolderName) do
  begin
    Inc(Suffix);
    FolderName := Copy(BaseName, 1, MaxLength - Length(IntToStr(Suffix)) - 1) +
      '_' + IntToStr(Suffix);
  end;
  Result := FolderName;
end;

function PadRight(const Str: string; TotalWidth: Integer;
  PadChar: Char = ' '): string;
begin
  Result := Str + StringOfChar(PadChar, TotalWidth - Length(Str));
end;

end.

