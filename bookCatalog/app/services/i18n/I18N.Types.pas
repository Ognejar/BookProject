unit I18N.Types;

{
  Автор: Бегтин К.В. (Огнеяр)
  Название проекта: Библиотека Дементора
  Лицензия: Freeware
  Год создания: 2025
  Версия: 3.1
  Назначение модуля:
  Модуль I18N.Types содержит определения типов данных,
  используемых в системе интернационализации (i18n).
  Включает типы для кодов языков, ключей и значений переводов.
}

interface

uses
  System.SysUtils;

type
  { Интерфейс провайдера переводов }
  ITranslationProvider = interface
    ['{A1B2C3D4-E5F6-7890-1234-56789ABCDEF0}']
    function Translate(const Key: string): string; // Метод для получения перевода по ключу
  end;

  { Тип для представления кода языка }
  TLanguageCode = type string;

  { Тип для ключа перевода }
  TTranslationKey = type string;

  { Тип для значения перевода }
  TTranslationValue = type string;

implementation

end.
