unit CategoryTypes;

interface

uses
  System.SysUtils, System.Classes, BaseEntityStorage;

type
  TCategory = class(TBaseEntity)
  private
    FName: string;
    FParentID: Integer; // Идентификатор родительской категории (0, если нет родителя)
    FChildren: TArray<Integer>; // Идентификаторы дочерних категорий
  public
    property Name: string read FName write FName;
    property ParentID: Integer read FParentID write FParentID;
    property Children: TArray<Integer> read FChildren write FChildren;
  end;

implementation

end.