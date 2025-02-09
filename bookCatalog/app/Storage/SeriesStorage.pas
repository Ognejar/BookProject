unit SeriesStorage;

interface

uses
  BaseEntityStorage, SeriesTypes;

type
  TBookSeriesStorage = class(TBaseEntityStorage<TBookSeries>)
  public
    constructor Create(const ADataPath: string; AMaxCacheSize: Integer = 100);
  end;

implementation

{ TBookSeriesStorage }

constructor TBookSeriesStorage.Create(const ADataPath: string; AMaxCacheSize: Integer);
begin
  inherited Create(ADataPath, AMaxCacheSize);
end;

end.
