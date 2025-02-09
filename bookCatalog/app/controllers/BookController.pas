unit BookController;

interface

uses
  BookTypes, ListTypes, SeriesTypes, SettingsTypes, System.SysUtils, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.ExtCtrls, BookStorage, Config;

type
  TBookController = class
  private
    FBookStorage: TBookStorage;
    FBookBriefs: TBookBriefList;
    procedure UpdateGrid;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ScanCatalog;
    procedure AddBook(const ABook: TBookMetadata);
    procedure UpdateBook(const ABook: TBookMetadata);
    procedure DeleteBook(const AID: Integer);
    procedure SearchBooks(const AQuery: string);
    procedure FilterBooks(const AFilter: string);
    procedure ShowBookDetails(const AIndex: Integer);
    property BookBriefs: TBookBriefList read FBookBriefs;
  end;

implementation

{ TBookController }

constructor TBookController.Create;
begin
  FBookStorage := TBookStorage.Create;
  FBookBriefs := TBookBriefList.Create;
  LoadBooks;
end;

destructor TBookController.Destroy;
begin
  FBookStorage.Free;
  FBookBriefs.Free;
  inherited;
end;

procedure TBookController.LoadBooks;
begin
  FBookBriefs := FBookStorage.LoadBookList;
  UpdateGrid;
end;

procedure TBookController.UpdateGrid;
begin
  // Логика обновления сетки с книгами
  // Например, заполнение BooksGrid данными из FBookBriefs
end;

procedure TBookController.ScanCatalog;
begin
  FBookStorage.ScanCatalog;
  LoadBooks;
end;

procedure TBookController.AddBook(const ABook: TBookMetadata);
begin
  FBookStorage.AddBook(ABook);
  LoadBooks;
end;

procedure TBookController.UpdateBook(const ABook: TBookMetadata);
begin
  FBookStorage.UpdateBook(ABook);
  LoadBooks;
end;

procedure TBookController.DeleteBook(const AID: Integer);
begin
  FBookStorage.DeleteBook(AID);
  LoadBooks;
end;

procedure TBookController.SearchBooks(const AQuery: string);
begin
  FBookBriefs := FBookStorage.SearchBooks(AQuery);
  UpdateGrid;
end;

procedure TBookController.FilterBooks(const AFilter: string);
begin
  // Логика фильтрации книг
  // Например, загрузка книг по фильтру из FBookStorage
end;

procedure TBookController.ShowBookDetails(const AIndex: Integer);
begin
  var bookID := FBookBriefs[AIndex].ID;
  var book := FBookStorage.LoadBookDetails(bookID);
  // Отображение деталей книги на форме
end;

end.