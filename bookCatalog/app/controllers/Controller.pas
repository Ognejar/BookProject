unit Controller;

interface

uses
  BookModel,         //< Модуль для управления коллекцией книг
  BookTypes,         //< Модуль с типами, связанными с книгами
  System.Generics.Collections, //< Коллекции общего назначения
  System.SysUtils;   //< Системные утилиты

type
   
   // Класс TController управляет основной логикой приложения.
   
  TController = class
  private
    FBookModel: TBookModel;
    FBooks: TObjectList<TBookMetadata>;
    // Другие поля, если необходимо
  public
     
     // Конструктор класса TController.
     // Инициализирует экземпляр TBookModel и загружает книги.
     
    constructor Create;

     
     // Деструктор класса TController.
     // Освобождает экземпляр TBookModel и список книг.
     
    destructor Destroy; override;

     
     // Загружает книги.
     
    procedure LoadBooks;

     
     // Загружает подробности книги по ID.
     
     // <param name="ID">Идентификатор книги.</param>
     // <returns>TBookMetadata объект с подробностями книги.</returns>
    function LoadBookDetails(const ID: Integer): TBookMetadata;

     
     // Сохраняет подробности книги.
     
     // <param name="Book">Книга для сохранения.</param>
    procedure SaveBookDetails(const Book: TBookMetadata);

    // Другие методы, если необходимо
  end;

implementation

{ TController }

constructor TController.Create;
begin
  inherited Create;
  FBookModel := TBookModel.Create;
  FBooks := TObjectList<TBookMetadata>.Create;
  // Загружаем книги при создании контроллера
  LoadBooks;
end;

destructor TController.Destroy;
begin
  FBooks.Free;
  FBookModel.Free;
  inherited Destroy;
end;

procedure TController.LoadBooks;
var
  Book: TBookMetadata;
begin
  // Предполагается, что BookModel имеет метод для загрузки книг
  // Например, FBookModel.LoadBooksFromStorage;
  // Здесь просто добавляем пример книги
  Book := TBookMetadata.Create;
  Book.ID := 1;
  Book.Title := 'Example Title';
  Book.Author := 'Example Author';
  FBooks.Add(Book);
end;

function TController.LoadBookDetails(const ID: Integer): TBookMetadata;
var
  Book: TBookMetadata;
begin
  Result := nil;
  for Book in FBooks do
    if Book.ID = ID then // Исправлено на Book.ID
      Exit(Book);
  raise Exception.CreateFmt('Book with ID %d not found', [ID]);
end;

procedure TController.SaveBookDetails(const Book: TBookMetadata);
begin
  // Реализация сохранения подробностей книги
  // Например, обновление данных в FBooks
  // Здесь просто выводим сообщение
  Writeln('Book details saved:', Book.Title);
end;

end.
