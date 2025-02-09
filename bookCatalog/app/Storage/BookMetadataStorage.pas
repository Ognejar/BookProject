unit BookMetadataStorage;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, BookTypes, BaseEntityStorage;

type
  TBookMetadataStorage = class(TBaseEntityStorage<TBookMetadata>)
  end;

implementation

end.