unit ListTypes;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  System.Generics.Defaults, CommonTypes, System.Math,BaseEntityStorage;

type
  // TBookBrief - класс для представления краткой информации о книге
  TBookBrief = class(TBaseEntity)
  private
    FTitle: string;       // Название книги
    FAuthor: string;      // Автор книги
    FYear: Integer;       // Год издания
    FFormat: string;      // Формат книги
    FFilePath: string;    // Путь к файлу книги
    FCategoryID: Integer; // Идентификатор категории
    FTags: TArray<string>; // Теги книги
    FSeries: TArray<TBookSeriesItem>; // Серия книги
  public
    property Title: string read FTitle write FTitle; // Название книги
    property Author: string read FAuthor write FAuthor; // Автор книги
    property Year: Integer read FYear write FYear; // Год издания
    property Format: string read FFormat write FFormat; // Формат книги
    property FilePath: string read FFilePath write FFilePath; // Путь к файлу
    property CategoryID: Integer read FCategoryID write FCategoryID; // Идентификатор категории
    property Tags: TArray<string> read FTags write FTags; // Теги
    property Series: TArray<TBookSeriesItem> read FSeries write FSeries; // Серия
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
  raise Exception.CreateFmt('Book not found with ID: %d', [AID]);
end;

function TBookBriefList.FindByTitle(const ATitle: string): TBookBrief;
begin
  for var Book in Self do
    if AnsiContainsText(Book.Title, ATitle) then
      Exit(Book);
  raise Exception.CreateFmt('Book not found with title: %s', [ATitle]);
end;

function TBookBriefList.FindByAuthor(const AAuthor: string): TBookBrief;
begin
  for var Book in Self do
    if AnsiContainsText(Book.Author, AAuthor) then
      Exit(Book);
  raise Exception.CreateFmt('Book not found with author: %s', [AAuthor]);
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
      Result := CompareValue(Left.Year, Right.Year);
    else
      Result := 0;
  end;
  if AOrder = soDescending then
    Result := -Result;
end;

procedure TBookBriefList.Sort(const AField: TListSortField; const AOrder: TListSortOrder = soAscending);
begin
  inherited Sort(
    TComparer<TBookBrief>.Construct(
      function(const Left, Right: TBookBrief): Integer
      begin
        Result := CompareBooks(Left, Right, AField, AOrder);
      end)
  );
end;

end.
