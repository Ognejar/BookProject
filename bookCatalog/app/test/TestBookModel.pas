unit TestBookModel;

interface

uses
  TestFramework, BookModel, BookTypes, System.SysUtils;

type
  TestTBookModel = class
  private
    FBookModel: TBookModel;
  public
    procedure SetUp;
    procedure TearDown;
    procedure TestAddBook;
    procedure TestRemoveBook;
    procedure TestFindBookByID;
    procedure TestFindBookByTitle;
    procedure TestGetAllBooks;
    procedure TestToJSON;
    procedure TestFromJSON;
  end;

implementation

{ TestTBookModel }

procedure TestTBookModel.SetUp;
begin
  FBookModel := TBookModel.Create;
end;

procedure TestTBookModel.TearDown;
begin
  FBookModel.Free;
end;

procedure TestTBookModel.TestAddBook;
var
  Book: TBookMetadata;
begin
  Book := TBookMetadata.Create;
  Book.ID := 1;
  Book.Title := 'Test Book';
  FBookModel.AddBook(Book);
  Assert.AreEqual(1, FBookModel.GetAllBooks.Count);
  Book.Free;
end;

procedure TestTBookModel.TestRemoveBook;
var
  Book: TBookMetadata;
begin
  Book := TBookMetadata.Create;
  Book.ID := 1;
  Book.Title := 'Test Book';
  FBookModel.AddBook(Book);
  FBookModel.RemoveBook(Book);
  Assert.AreEqual(0, FBookModel.GetAllBooks.Count);
  Book.Free;
end;

procedure TestTBookModel.TestFindBookByID;
var
  Book: TBookMetadata;
begin
  Book := TBookMetadata.Create;
  Book.ID := 1;
  Book.Title := 'Test Book';
  FBookModel.AddBook(Book);
  Assert.AreEqual(Book, FBookModel.FindBookByID(1));
  Book.Free;
end;

procedure TestTBookModel.TestFindBookByTitle;
var
  Book: TBookMetadata;
begin
  Book := TBookMetadata.Create;
  Book.ID := 1;
  Book.Title := 'Test Book';
  FBookModel.AddBook(Book);
  Assert.AreEqual(Book, FBookModel.FindBookByTitle('Test Book'));
  Book.Free;
end;

procedure TestTBookModel.TestGetAllBooks;
var
  Book: TBookMetadata;
begin
  Book := TBookMetadata.Create;
  Book.ID := 1;
  Book.Title := 'Test Book';
  FBookModel.AddBook(Book);
  Assert.AreEqual(1, FBookModel.GetAllBooks.Count);
  Book.Free;
end;

procedure TestTBookModel.TestToJSON;
var
  Book: TBookMetadata;
  JSON: string;
begin
  Book := TBookMetadata.Create;
  Book.ID := 1;
  Book.Title := 'Test Book';
  JSON := FBookModel.ToJSON(Book);
  Assert.AreEqual('{"ID":1,"Title":"Test Book"}', JSON);
  Book.Free;
end;

procedure TestTBookModel.TestFromJSON;
var
  Book: TBookMetadata;
  JSON: string;
begin
  JSON := '{"ID":1,"Title":"Test Book"}';
  Book := FBookModel.FromJSON(JSON);
  Assert.AreEqual(1, Book.ID);
  Assert.AreEqual('Test Book', Book.Title);
  Book.Free;
end;

end.

