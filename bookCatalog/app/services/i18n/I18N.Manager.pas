unit I18N.Manager;

{
  Автор: Бегтин К.В. (Огнеяр)
  Название проекта: Библиотека Дементора
  Лицензия: Freeware
  Год создания: 2025
  Версия: 3.1
  Назначение модуля:
  Модуль I18N.Manager управляет загрузкой и использованием переводов
  в системе интернационализации (i18n). Поддерживает работу с разными
  провайдерами переводов и предоставляет интерфейс для получения переводов.
}

interface

uses
  System.SysUtils, System.Generics.Collections, I18N.Types;

type
  { Класс для управления провайдерами переводов и текущей локалью }
  TI18NManager = class
  private
    FProviders: TObjectList<ITranslationProvider>; // Список провайдеров переводов
    FCurrentLocale: string; // Текущая локаль
  public
    constructor Create; // Создание менеджера переводов
    destructor Destroy; override; // Освобождение ресурсов

    procedure AddProvider(AProvider: ITranslationProvider); // Добавление провайдера переводов
    procedure SetLocale(const Locale: string); // Установка текущей локали
    function Translate(const Key: string): string; // Перевод текста по ключу
  end;

implementation

{ TI18NManager }

{*
  Конструктор: Инициализирует список провайдеров и устанавливает локаль по умолчанию.
*}
constructor TI18NManager.Create;
begin
  inherited Create;
  FProviders := TObjectList<ITranslationProvider>.Create;
  FCurrentLocale := 'en'; // Локаль по умолчанию
end;

{*
  Деструктор: Освобождает ресурсы, связанные с провайдерами переводов.
*}
destructor TI18NManager.Destroy;
begin
  FProviders.Free;
  inherited;
end;

{*
  Добавляет нового провайдера переводов в систему.
  @param AProvider - Провайдер переводов.
*}
procedure TI18NManager.AddProvider(AProvider: ITranslationProvider);
begin
  if Assigned(AProvider) then
    FProviders.Add(AProvider)
  else
    raise Exception.Create('Попытка добавить недопустимый провайдер переводов.');
end;

{*
  Устанавливает текущую локаль для перевода.
  @param Locale - Новый язык для перевода.
*}
procedure TI18NManager.SetLocale(const Locale: string);
begin
  if Locale.IsEmpty then
    raise Exception.Create('Локаль не может быть пустой.');
  
  FCurrentLocale := Locale;
end;

{*
  Переводит текст по указанному ключу, используя зарегистрированные провайдеры.
  @param Key - Ключ перевода.
  @return Строка с переводом или сообщение об отсутствии перевода.
*}
function TI18NManager.Translate(const Key: string): string;
var
  Provider: ITranslationProvider;
  Translation: string;
begin
  for Provider in FProviders do
  begin
    Translation := Provider.Translate(Key);
    if not Translation.StartsWith('[Отсутствует перевод') then
      Exit(Translation);
  end;

  // Если перевод не найден ни в одном провайдере
  Result := Format('[Отсутствует перевод: %s]', [Key]);
end;

end.
