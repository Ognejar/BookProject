unit AuthorStorage;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, AuthorTypes, BaseEntityStorage;

type
  TAuthorStorage = class(TBaseEntityStorage<TAuthor>)
  end;

implementation

end.