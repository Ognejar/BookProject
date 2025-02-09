unit BookBriefStorage;

interface

uses
  BaseEntityStorage, BriefTypes;

type
  TBookBriefStorage = class(TBaseEntityStorage<TBookBrief>)
  public
    constructor Create(const ADataPath: string; AMaxCacheSize: Integer = 100);
  end;

implementation

{ TBookBriefStorage }

constructor TBookBriefStorage.Create(const ADataPath: string; AMaxCacheSize: Integer);
begin
  inherited Create(ADataPath, AMaxCacheSize);
end;

end.
