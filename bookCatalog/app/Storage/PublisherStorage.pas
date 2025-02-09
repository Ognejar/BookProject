unit PublisherStorage;

interface

uses
  BaseEntityStorage, PublisherTypes;

type
  TPublisherStorage = class(TBaseEntityStorage<TPublisher>)
  public
    constructor Create(const ADataPath: string; AMaxCacheSize: Integer = 100);
  end;

implementation

{ TPublisherStorage }

constructor TPublisherStorage.Create(const ADataPath: string; AMaxCacheSize: Integer);
begin
  inherited Create(ADataPath, AMaxCacheSize);
end;

end.
