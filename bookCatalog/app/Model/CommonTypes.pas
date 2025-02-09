unit CommonTypes;

interface

type
  TListSortOrder = (soAscending, soDescending);
  TListSortField = (sfTitle, sfAuthor, sfYear, sfPublisher, sfFormat,
    sfSize, sfAdded);
  TListViewMode = (vmList, //< Список
    vmDetails, //< Подробности
    vmTiles, //< Плитки
    vmCovers //< Обложки
    );

  // TBookSeriesItem - запись, представляющая элемент серии книг
  TBookSeriesItem = record
    BookID: Integer; //< Идентификатор книги
    SeriesID: Integer; //< Идентификатор серии
    BookNumber: Integer; //< Номер книги в серии
    procedure Initialize(ABookID, ASeriesID, ABookNumber: Integer);
  end;

  // TBookSeries - запись, представляющая серию книг
  TBookSeries = record
    ID: Integer; //< Уникальный идентификатор серии
    Name: string; //< Название серии
    Publisher: string; //< Издательство
    Description: string; //< Описание серии
    procedure Initialize(const AID: Integer;
      const AName, APublisher, ADescription: string);
  end;

implementation

{ TBookSeriesItem }

procedure TBookSeriesItem.Initialize(ABookID, ASeriesID, ABookNumber: Integer);
begin
  Self.BookID := ABookID;
  Self.SeriesID := ASeriesID;
  Self.BookNumber := ABookNumber;
end;

{ TBookSeries }

procedure TBookSeries.Initialize(const AID: Integer;
  const AName, APublisher, ADescription: string);
begin
  Self.ID := AID;
  Self.Name := AName;
  Self.Publisher := APublisher;
  Self.Description := ADescription;
end;

end.
