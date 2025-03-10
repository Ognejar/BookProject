unit BaseEntityStorage_Tests;

interface

uses
  DUnitX.TestFramework,
  BaseEntityStorage,
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections;

type
  TTestBook = class(TBaseEntity)
  private
    FName: string;
    FAuthor: string;
    FYear: Integer;
  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property Year: Integer read FYear write FYear;
  end;

  [TestFixture]
  TBaseEntityStorageTests = class
  private
    FStorage: TBaseEntityStorage<TTestBook>;
    FDataPath: string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestCreateEntity;
    [Test]
    procedure TestReadEntity;
    [Test]
    procedure TestUpdateEntity;
    [Test]
    procedure TestDeleteEntity;
    [Test]
    procedure TestGetAllEntities;
    [Test]
    procedure TestEntityPersistence;
  end;

implementation

{ TBaseEntityStorageTests }

procedure TBaseEntityStorageTests.Setup;
begin
  FDataPath := TPath.Combine(TPath.GetTempPath, 'BaseEntityStorageTests');
  if TDirectory.Exists(FDataPath) then
    TDirectory.Delete(FDataPath, True);
  TDirectory.CreateDirectory(FDataPath);

  FStorage := TBaseEntityStorage<TTestBook>.Create(FDataPath, 10);
end;

procedure TBaseEntityStorageTests.TearDown;
begin
  try
    FStorage.Free;
  except
    on E: Exception do
      Writeln('������ ��� ������������ FStorage: ' + E.Message);
  end;
  if TDirectory.Exists(FDataPath) then
    try
      TDirectory.Delete(FDataPath, True);
    except
      on E: Exception do
        Writeln('������ ��� �������� ����������: ' + E.Message);
    end;
end;

procedure TBaseEntityStorageTests.TestCreateEntity;
var
  Book: TTestBook;
  BookID: Integer;
begin
  Book := TTestBook.Create;
  try
    Book.Name := '1984';
    Book.Author := 'George Orwell';
    Book.Year := 1949;

    BookID := FStorage.CreateEntity(Book);
    Assert.IsTrue(BookID > 0, 'ID �������� ������ ���� ������ 0');
  finally
    Book.Free;
  end;
end;

procedure TBaseEntityStorageTests.TestReadEntity;
var
  Book: TTestBook;
  BookID: Integer;
begin
  Book := TTestBook.Create;
  try
    Book.Name := '1984';
    Book.Author := 'George Orwell';
    Book.Year := 1949;

    BookID := FStorage.CreateEntity(Book);
    Book := FStorage.ReadEntity(BookID);
    try
      Assert.AreEqual('1984', Book.Name, '�������� ����� �� ���������');
      Assert.AreEqual('George Orwell', Book.Author, '����� ����� �� ���������');
      Assert.AreEqual(1949, Book.Year, '��� ������� ����� �� ���������');
    finally
      Book.Free;
    end;
  finally
    Book.Free;
  end;
end;

procedure TBaseEntityStorageTests.TestUpdateEntity;
var
  Book: TTestBook;
  BookID: Integer;
begin
  Book := TTestBook.Create;
  try
    Book.Name := '1984';
    Book.Author := 'George Orwell';
    Book.Year := 1949;

    BookID := FStorage.CreateEntity(Book);
    Book := FStorage.ReadEntity(BookID);
    try
      Book.Year := 1950;
      FStorage.UpdateEntity(Book);

      Book := FStorage.ReadEntity(BookID);
      Assert.AreEqual(1950, Book.Year, '��� ������� �� ��������');
    finally
      Book.Free;
    end;
  finally
    Book.Free;
  end;
end;

procedure TBaseEntityStorageTests.TestDeleteEntity;
var
  Book: TTestBook;
  BookID: Integer;
  FilePath: string;
begin
  Book := TTestBook.Create;
  try
    Book.Name := '1984';
    Book.Author := 'George Orwell';
    Book.Year := 1949;

    BookID := FStorage.CreateEntity(Book);
    FilePath := TPath.Combine(FDataPath, Format('Entity_%d.dat', [BookID]));

    Assert.IsTrue(TFile.Exists(FilePath), '���� �������� �� ��� ������');

    // ������� ��������
    FStorage.DeleteEntity(BookID);
    Assert.IsFalse(TFile.Exists(FilePath), '���� �������� �� ��� ������');

    // �������� ��������� ��������� ��������
    Assert.WillRaise(
      procedure
      begin
        FStorage.ReadEntity(BookID);
      end,
      Exception,
      '���������� �� ���� ��������� ��� ������ ��������� ��������'
    );
  finally
    Book.Free;
  end;
end;

procedure TBaseEntityStorageTests.TestGetAllEntities;
var
  Book1, Book2: TTestBook;
  Books: TObjectList<TTestBook>;
begin
  Book1 := TTestBook.Create;
  Book2 := TTestBook.Create;
  try
    Book1.Name := '1984';
    Book1.Author := 'George Orwell';
    Book1.Year := 1949;

    Book2.Name := 'Animal Farm';
    Book2.Author := 'George Orwell';
    Book2.Year := 1945;

    FStorage.CreateEntity(Book1);
    FStorage.CreateEntity(Book2);

    Books := FStorage.GetAllEntities;
    try
      Assert.AreEqual(2, Books.Count, '���������� ��������� �� ���������');
    finally
      Books.Free;
    end;
  finally
    Book1.Free;
    Book2.Free;
  end;
end;

procedure TBaseEntityStorageTests.TestEntityPersistence;
var
  Book: TTestBook;
  BookID: Integer;
  FilePath: string;
begin
  Book := TTestBook.Create;
  try
    Book.Name := 'Brave New World';
    Book.Author := 'Aldous Huxley';
    Book.Year := 1932;

    BookID := FStorage.CreateEntity(Book);
    FilePath := TPath.Combine(FDataPath, Format('Entity_%d.dat', [BookID]));

    Assert.IsTrue(TFile.Exists(FilePath), '���� �������� �� ��� ������');

    // ������� ��������
    FStorage.DeleteEntity(BookID);
    Assert.IsFalse(TFile.Exists(FilePath), '���� �������� �� ��� ������');
  finally
    Book.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TBaseEntityStorageTests);

end.
