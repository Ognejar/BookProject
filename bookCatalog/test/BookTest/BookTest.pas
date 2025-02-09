{**
 * Этот модуль содержит тесты для проверки различных аспектов функциональности.
 *
 * @module BookTest
 * @author Ваше Имя
 * @author Ognejqr
 * @version 1.0
 *}

unit BookTest;

interface

type
  { @abstract(Базовый класс для всех сущностей.) }
  TBaseEntity = class
  private
    FID: Integer;
    FName: string;
  public
    constructor Create; virtual;
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
  end;

  { @abstract(Класс для хранения и управления сущностями в файловой системе.) }
  TBaseEntityStorage<T: TBaseEntity, constructor> = class
  private
    FDataPath: string;
    function GetEntityFilePath(const AID: Integer): string;
  public
    constructor Create(const ADataPath: string);
    procedure SaveEntityToFile(const AEntity: T);
  end;