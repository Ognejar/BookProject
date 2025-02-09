unit View;

interface

uses
  System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, BookTypes, BookModel;

type
  TCatalogView = class(TForm)
    BooksView: TListView;
    SearchEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FModel: TBookModel;
  public
    constructor Create(AOwner: TComponent; AModel: TBookModel); reintroduce;
    procedure UpdateView;
    procedure UpdatePreview(Book: TBookMetadata);
  end;

implementation

constructor TCatalogView.Create(AOwner: TComponent; AModel: TBookModel);
begin
  inherited Create(AOwner);
  FModel := AModel;
end;

procedure TCatalogView.FormCreate(Sender: TObject);
begin
  // Инициализация представления
end;

procedure TCatalogView.FormDestroy(Sender: TObject);
begin
  // Освобождение ресурсов
end;

procedure TCatalogView.UpdateView;
begin
  // Обновление списка книг
  BooksView.Items.Clear;
  // Заполнение списка книг из модели
end;

procedure TCatalogView.UpdatePreview(Book: TBookMetadata);
begin
  // Обновление превью книги
end;

end.
