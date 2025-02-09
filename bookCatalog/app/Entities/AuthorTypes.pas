unit AuthorTypes;

{
  Автор: Бегтин К.В. (Огнеяр)
  Проект: Библиотека Дементора
  Лицензия: Freeware
  Версия: 1.0.0
  Дата создания: 2025

  Описание:
    Модуль AuthorTypes содержит класс TAuthor, представляющий автора книги.
    Класс включает в себя основные свойства: имя и биографию автора.
    Наследуется от TBaseEntity для поддержки базовых механизмов хранения.

  История изменений:
    [2025-02-06] Создан класс TAuthor, унаследованный от TBaseEntity.
}

interface

uses
  System.SysUtils, System.Classes, BaseEntityStorage;

type
  { Класс, представляющий автора книги }
  TAuthor = class(TBaseEntity)
  private
    FName: string; // Имя автора
    FBio: string;  // Биография автора
  public
    { Конструктор, инициализирующий автора }
    constructor Create(const AName, ABio: string);

    { Свойство: имя автора }
    property Name: string read FName write FName;

    { Свойство: биография автора }
    property Bio: string read FBio write FBio;
  end;

implementation

{ TAuthor }

constructor TAuthor.Create(const AName, ABio: string);
begin
  inherited Create;
  FName := AName;
  FBio := ABio;
end;

end.

