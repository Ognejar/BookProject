{
  ┌───────────────────────────────────────────────────────────────────┐
  │ Автор: Бегтин К.В. (Огнеяр)                                       │
  │ Название проекта: Библиотека Дементора                             │
  │ Лицензия: Freeware                                                │
  │ Год создания: 2025                                                │
  │ Версия: 3.4                                                       │
  │                                                                   │
  │ Назначение модуля:                                                │
  │ Модуль ListTypes содержит определения типов данных для            │
  │ представления списка книг в памяти.                              │
  │                                                                   │
  │ История изменений:                                                │
  │ [2025-01-20]: Создание модуля с типом TBookBrief.                │
  │ [2025-02-10]: Добавлен класс TBookBriefList для управления        │
  │               списком книг.                                       │
  │                                                                   │
  └───────────────────────────────────────────────────────────────────┘
}

unit ListTypes;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults, BookTypes;

type
  // TBookBrief - запись для представления краткой информации о книге
  TBookBrief = record
    ID: Integer;          // Уникальный идентификатор книги
    Title: string;        // Название книги
    Author: string;       // Автор книги
    Year: Integer;        // Год издания
    Format: string;       // Формат книги
    FilePath: string;     // Путь к файлу книги
    CategoryID: Integer;  // Идентификатор категории
    Tags: TArray<string>; // Теги книги
    Series: TArray<TBookSeriesItem>; // Серия книги
  end;

  // TBookBriefList - список книг
  TBookBriefList = class(TList<TBookBrief>)
  private
    function CompareBooks(const Left, Right: TBookBrief; 
      const AField: TListSortField; const AOrder: TListSortOrder): Integer;
  public
    function FindByID(const AID: Integer): TBookBrief;
    function FindByTitle(const ATitle: string): TBookBrief;
    function FindByAuthor(const AAuthor: string): TBookBrief;
    procedure Sort(const AField: TListSortField; const AOrder: TListSortOrder = soAscending);
  end;

implementation

uses
  System.StrUtils;

{ TBookBriefList }

function TBookBriefList.FindByID(const AID: Integer): TBookBrief;
begin
  for var Book in Self do
    if Book.ID = AID then
      Exit(Book);
  raise Exception.Create(_('List.Errors.BookNotFound', [AID]));
end;

function TBookBriefList.FindByTitle(const ATitle: string): TBookBrief;
begin
  for var Book in Self do
    if AnsiContainsText(Book.Title, ATitle) then
      Exit(Book);
  raise Exception.Create(_('List.Errors.TitleNotFound', [ATitle]));
end;

function TBookBriefList.FindByAuthor(const AAuthor: string): TBookBrief;
begin
  for var Book in Self do
    if AnsiContainsText(Book.Author, AAuthor) then
      Exit(Book);
  raise Exception.Create(_('List.Errors.AuthorNotFound', [AAuthor]));
end;

function TBookBriefList.CompareBooks(const Left, Right: TBookBrief;
  const AField: TListSortField; const AOrder: TListSortOrder): Integer;
begin
  case AField of
    sfTitle:
      Result := CompareText(Left.Title, Right.Title);
    sfAuthor:
      Result := CompareText(Left.Author, Right.Author);
    sfYear:
      Result := Left.Year - Right.Year;
    else
      Result := 0;
  end;
  
  if AOrder = soDescending then
    Result := -Result;
end;

procedure TBookBriefList.Sort(const AField: TListSortField; const AOrder: TListSortOrder);
begin
  inherited Sort(TComparer<TBookBrief>.Construct(
    function(const Left, Right: TBookBrief): Integer
    begin
      Result := CompareBooks(Left, Right, AField, AOrder);
    end));
end;

end.