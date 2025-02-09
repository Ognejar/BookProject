{┌───────────────────────────────────────────────────────────────────┐
 │ Автор: Бегтин К.В. (Огнеяр)                                       │
 │ Название проекта: Библиотека Дементора                            │
 │ Лицензия: Freeware                                                │
 │ Год создания: 2025                                                │
 │ Версия: 3.1                                                       │
 │                                                                   │
 │ Назначение модуля:                                               │
 │ Модуль Model содержит логику управления данными о книгах          │
 │ Модуль обеспечивает добавление, обновление и удаление книг        │
 │ из списка                                                         │
 └───────────────────────────────────────────────────────────────────┘}

unit Model;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,
  BookTypes; // Подключение модуля BookTypes

type
  TBookList = TObjectList<TBookMetadata>; // Определение списка книг

  TModel = class
  private
    FBooks: TBookList;
    function GetBookByID(const AID: Integer): TBookMetadata;
    procedure SetBookByID(const AID: Integer; const ABook: TBookMetadata);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddBook(const ABook: TBookMetadata);
    procedure UpdateBook(const ABook: TBookMetadata);
    procedure DeleteBook(const AID: Integer);
    property Books: TBookList read FBooks;
    property BookByID[const AID: Integer]: TBookMetadata read GetBookByID write SetBookByID; default;
  end;

implementation

{ TModel }

constructor TModel.Create;
begin
  inherited Create;
  FBooks := TBookList.Create(True); // Установка OwnsObjects на True для автоматического освобождения памяти
end;

destructor TModel.Destroy;
begin
  FBooks.Free;
  inherited;
end;

procedure TModel.AddBook(const ABook: TBookMetadata);
begin
  FBooks.Add(ABook);
end;

procedure TModel.UpdateBook(const ABook: TBookMetadata);
var
  bookIndex: Integer;
  existingBook: TBookMetadata;
begin
  bookIndex := FBooks.IndexOf(ABook);
  if bookIndex >= 0 then
  begin
    existingBook := FBooks[bookIndex];
    existingBook.Title := ABook.Title;
    existingBook.Author := ABook.Author;
    existingBook.CategoryID := ABook.CategoryID;
    existingBook.Description := ABook.Description;
    existingBook.Year := ABook.Year;
    existingBook.ISBN := ABook.ISBN;
    existingBook.Publisher := ABook.Publisher;
    existingBook.PageCount := ABook.PageCount;
    existingBook.Language := ABook.Language;
    existingBook.Format := ABook.Format;
    existingBook.FileSize := ABook.FileSize;
    existingBook.FilePath := ABook.FilePath;
    existingBook.CoverPath := ABook.CoverPath;
    existingBook.Tags := ABook.Tags;
    existingBook.AddedDate := ABook.AddedDate;
    existingBook.Notes := ABook.Notes;
    existingBook.Rating := ABook.Rating;
    existingBook.ReadStatus := ABook.ReadStatus;
    existingBook.Keywords := ABook.Keywords;

    // Обновляем пользовательские поля
    existingBook.CustomFields.Clear;
    for var pair in ABook.CustomFields do
      existingBook.CustomFields.AddOrSetValue(pair.Key, pair.Value);
  end;
end;

procedure TModel.DeleteBook(const AID: Integer);
var
  book: TBookMetadata;
begin
  for book in FBooks do
  begin
    if book.ID = AID then
    begin
      FBooks.Remove(book);
      Break;
    end;
  end;
end;

function TModel.GetBookByID(const AID: Integer): TBookMetadata;
var
  book: TBookMetadata;
begin
  for book in FBooks do
  begin
    if book.ID = AID then
    begin
      Result := book;
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TModel.SetBookByID(const AID: Integer; const ABook: TBookMetadata);
var
  book: TBookMetadata;
begin
  for book in FBooks do
  begin
    if book.ID = AID then
    begin
      book.Title := ABook.Title;
      book.Author := ABook.Author;
      book.CategoryID := ABook.CategoryID;
      book.Description := ABook.Description;
      book.Year := ABook.Year;
      book.ISBN := ABook.ISBN;
      book.Publisher := ABook.Publisher;
      book.PageCount := ABook.PageCount;
      book.Language := ABook.Language;
      book.Format := ABook.Format;
      book.FileSize := ABook.FileSize;
      book.FilePath := ABook.FilePath;
      book.CoverPath := ABook.CoverPath;
      book.Tags := ABook.Tags;
      book.AddedDate := ABook.AddedDate;
      book.Notes := ABook.Notes;
      book.Rating := ABook.Rating;
      book.ReadStatus := ABook.ReadStatus;
      book.Keywords := ABook.Keywords;

      // Обновляем пользовательские поля
      book.CustomFields.Clear;
      for var pair in ABook.CustomFields do
        book.CustomFields.AddOrSetValue(pair.Key, pair.Value);

      Break;
    end;
  end;
end;

end.
