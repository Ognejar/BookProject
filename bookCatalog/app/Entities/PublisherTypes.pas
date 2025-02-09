{
  ┌───────────────────────────────────────────────────────────────────┐
  │ Автор: Бегтин К.В. (Огнеяр)                                       │
  │ Название проекта: Библиотека Дементора                            │
  │ Лицензия: Freeware                                                │
  │ Год создания: 2025                                                │
  │ Версия: 3.4                                                       │
  │                                                                   │
  │ Назначение модуля:                                                │
  │ Модуль PublisherTypes содержит определения типов данных для       │
  │ представления информации об издателях.                            │
  │                                                                   │
  │ История изменений:                                                │
  │ [2025-01-31]: Создание модуля с типом TPublisher                  │
  │                                                                   │
  └───────────────────────────────────────────────────────────────────┘
}
unit PublisherTypes;
interface
uses
  System.SysUtils, System.Classes, BaseEntityStorage;

type
  // TPublisher - класс, представляющий издателя
  TPublisher = class(TBaseEntity)
  private
    FName: string;	// Название издателя
    FAddress: string;      // Адрес издателя
  public
    property Name: string read FName write FName;
    property Address: string read FAddress write FAddress;
  end;

implementation

end.
