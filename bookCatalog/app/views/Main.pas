unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.Menus, BookTypes, ListTypes, SeriesTypes, SettingsTypes, BookController, Config;

type
  TMainForm = class(TForm)
    MainMenuBar: TMainMenu;
    FileMenu: TMenuItem;
    ScanCatalogMenuBtn: TMenuItem;
    AddBookMenuBtn: TMenuItem;
    AddAuthorMenuBtn: TMenuItem;
    AddSeriesMenuBtn: TMenuItem;
    AddCategoryMenuBtn: TMenuItem;
    ExitMenuBtn: TMenuItem;
    MainPanel: TPanel;
    SearchPanel: TPanel;
    SearchEdit: TEdit;
    FilterPanel: TPanel;
    CategoryBox: TComboBox;
    PreviewPanel: TPanel;
    CoverImage: TImage;
    DescriptionMemo: TMemo;
    BooksGrid: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure ScanCatalogMenuBtnClick(Sender: TObject);
    procedure AddBookMenuBtnClick(Sender: TObject);
    procedure AddAuthorMenuBtnClick(Sender: TObject);
    procedure AddSeriesMenuBtnClick(Sender: TObject);
    procedure AddCategoryMenuBtnClick(Sender: TObject);
    procedure ExitMenuBtnClick(Sender: TObject);
    procedure SearchEditChange(Sender: TObject);
    procedure CategoryBoxChange(Sender: TObject);
    procedure BooksGridDblClick(Sender: TObject);
  private
    FBookController: TBookController;
    procedure UpdatePreview(AIndex: Integer);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FBookController := TBookController.Create;
  // Инициализация формы и контроллера
end;

procedure TMainForm.ScanCatalogMenuBtnClick(Sender: TObject);
begin
  FBookController.ScanCatalog;
end;

procedure TMainForm.AddBookMenuBtnClick(Sender: TObject);
begin
  // Логика добавления новой книги
  // Создание новой книги и сохранение в FBookController
  var newBook: TBookMetadata := TBookMetadata.Create;
  try
    // Здесь можно задать начальные значения для новых книг
    newBook.Title := 'Название';
    newBook.Author := 'Автор';
    newBook.Year := 2023;
    newBook.Format := 'PDF';
    // Добавление книги через контроллер
    FBookController.AddBook(newBook);
  finally
    newBook.Free;
  end;
  LoadBooks;
end;

procedure TMainForm.AddAuthorMenuBtnClick(Sender: TObject);
begin
  // Логика добавления нового автора
  // Можно создать диалоговое окно для ввода данных автора
end;

procedure TMainForm.AddSeriesMenuBtnClick(Sender: TObject);
begin
  // Логика добавления новой серии
  // Можно создать диалоговое окно для ввода данных серии
end;

procedure TMainForm.AddCategoryMenuBtnClick(Sender: TObject);
begin
  // Логика добавления новой категории
  // Можно создать диалоговое окно для ввода данных категории
end;

procedure TMainForm.ExitMenuBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.SearchEditChange(Sender: TObject);
begin
  FBookController.SearchBooks(SearchEdit.Text);
end;

procedure TMainForm.CategoryBoxChange(Sender: TObject);
begin
  FBookController.FilterBooks(CategoryBox.Text);
end;

procedure TMainForm.BooksGridDblClick(Sender: TObject);
var
  SelectedRow: Integer;
begin
  if BooksGrid.Row > 0 then
  begin
    SelectedRow := BooksGrid.Row - 1;
    UpdatePreview(SelectedRow);
  end;
end;

procedure TMainForm.UpdatePreview(AIndex: Integer);
var
  bookID: Integer;
  book: TBookMetadata;
  coverImagePath: string;
begin
  bookID := FBookController.BookBriefs[AIndex].ID;
  book := FBookController.LoadBookDetails(bookID);

  // Обновление предпросмотра на форме
  if TFile.Exists(book.CoverPath) then
    CoverImage.Picture.LoadFromFile(book.CoverPath); // Загрузка обложки
  DescriptionMemo.Lines.Clear;
  DescriptionMemo.Lines.Add('Заголовок: ' + book.Title);
  DescriptionMemo.Lines.Add('Автор: ' + book.Author);
  DescriptionMemo.Lines.Add('Год издания: ' + IntToStr(book.Year));
  DescriptionMemo.Lines.Add('Описание: ' + book.Description);
  DescriptionMemo.Lines.Add('Категория: ' + IntToStr(book.CategoryID));
  DescriptionMemo.Lines.Add('Метки: ' + string.Join(', ', book.Tags));
end;

// Функция для загрузки списка книг в сетку
procedure LoadBooks;
var
  i: Integer;
  book: TBookBrief;
begin
  BooksGrid.RowCount := FBookController.BookBriefs.Count + 1; // +1 для заголовков столбцов
  BooksGrid.Cells[0, 0] := 'Заголовок';
  BooksGrid.Cells[1, 0] := 'Автор';
  BooksGrid.Cells[2, 0] := 'Год';
  BooksGrid.Cells[3, 0] := 'Формат';

  for i := 0 to FBookController.BookBriefs.Count - 1 do
  begin
    book := FBookController.BookBriefs[i];
    BooksGrid.Cells[0, i + 1] := book.Title;
    BooksGrid.Cells[1, i + 1] := book.Author;
    BooksGrid.Cells[2, i + 1] := IntToStr(book.Year);
    BooksGrid.Cells[3, i + 1] := book.Format;
  end;
end;

end.