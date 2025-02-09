unit SeriesTypes;

interface

uses
  System.SysUtils, System.Classes;

type
  TBookSeriesItem = record
    BookID: Integer;      // Идентификатор книги
    SeriesID: Integer;    // Идентификатор серии
    BookNumber: Integer;  // Номер книги в серии
    procedure Initialize(ABookID, ASeriesID, ABookNumber: Integer);
  end;

  TBookSeries = record
    ID: Integer;          // Уникальный идентификатор серии
    Name: string;         // Название серии
    Publisher: string;    // Издательство
    Description: string;  // Описание серии
    procedure Initialize(const AID: Integer; const AName, APublisher, ADescription: string);
  end;

implementation

{ TBookSeriesItem }

procedure TBookSeriesItem.Initialize(ABookID, ASeriesID, ABookNumber: Integer);
begin
  BookID := ABookID;
  SeriesID := ASeriesID;
  BookNumber := ABookNumber;
end;

{ TBookSeries }

procedure TBookSeries.Initialize(const AID: Integer; const AName, APublisher, ADescription: string);
begin
  ID := AID;
  Name := AName;
  Publisher := APublisher;
  Description := ADescription;
end;

end.