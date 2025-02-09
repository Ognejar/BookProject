
{
  ┌───────────────────────────────────────────────────────────────────┐
  │ Автор: Бегтин К.В. (Огнеяр)                                       │
  │ Название проекта: Библиотека Дементора                            │
  │ Лицензия: Freeware                                                │
  │ Год создания: 2025                                                │
  │ Версия: 3.4                                                       │
  │                                                                   │
  │ Назначение модуля:                                                │
  │ Модуль CategoryModel содержит методы для манипуляции данными,    │
  │ связанными с категориями. Методы включают создание, чтение,      │
  │ обновление и удаление информации о категориях и их иерархии.    │
  │                                                                   │
  │ История изменений:                                                │
  │ [2025-01-31 22:00]: Создание модуля с базовыми методами для      │
  │                     работы с TCategory.                          │
  │ [2025-01-31 22:30]: Добавлены комментарии и проверка данных.     │
  │                                                                   │
  └───────────────────────────────────────────────────────────────────┘
}
unit CategoryModel;

interface

uses
  System.SysUtils, System.Classes, CategoryTypes;

type
  TCategoryManipulation = class
  public
    /// <summary>
    /// Создает новую категорию.
    /// </summary>
    /// <param name="AName">Название категории.</param>
    /// <param name="AParentID">Идентификатор родительской категории (0, если нет родителя).</param>
    /// <returns>Созданный объект TCategory.</returns>
    function CreateCategory(const AName: string; const AParentID: Integer): TCategory;

    /// <summary>
    /// Обновляет данные существующей категории.
    /// </summary>
    /// <param name="ACategory">Категория для обновления.</param>
    /// <returns>True, если обновление прошло успешно, иначе False.</returns>
    function UpdateCategory(const ACategory: TCategory): Boolean;

    /// <summary>
    /// Удаляет категорию по её идентификатору.
    /// </summary>
    /// <param name="ACategoryID">Идентификатор категории.</param>
    /// <returns>True, если удаление прошло успешно, иначе False.</returns>
    function DeleteCategory(const ACategoryID: Integer): Boolean;

    /// <summary>
    /// Получает категорию по её идентификатору.
    /// </summary>
    /// <param name="ACategoryID">Идентификатор категории.</param>
    /// <returns>Объект TCategory или nil, если категория не найдена.</returns>
    function GetCategoryByID(const ACategoryID: Integer): TCategory;

    /// <summary>
    /// Ищет категории по названию.
    /// </summary>
    /// <param name="AName">Название категории для поиска.</param>
    /// <returns>Массив объектов TCategory.</returns>
    function FindCategoryByName(const AName: string): TArray<TCategory>;

    /// <summary>
    /// Получает все категории.
    /// </summary>
    /// <returns>Массив объектов TCategory.</returns>
    function GetAllCategories: TArray<TCategory>;

    /// <summary>
    /// Добавляет дочернюю категорию.
    /// </summary>
    /// <param name="AParentID">Идентификатор родительской категории.</param>
    /// <param name="AChildID">Идентификатор дочерней категории.</param>
    /// <returns>True, если добавление прошло успешно, иначе False.</returns>
    function AddChildCategory(const AParentID, AChildID: Integer): Boolean;

    /// <summary>
    /// Удаляет дочернюю категорию.
    /// </summary>
    /// <param name="AParentID">Идентификатор родительской категории.</param>
    /// <param name="AChildID">Идентификатор дочерней категории.</param>
    /// <returns>True, если удаление прошло успешно, иначе False.</returns>
    function RemoveChildCategory(const AParentID, AChildID: Integer): Boolean;
  end;

implementation

{ TCategoryManipulation }

function TCategoryManipulation.CreateCategory(const AName: string; const AParentID: Integer): TCategory;
begin
  // Проверка входных данных
  if Trim(AName) = '' then
    raise Exception.Create('Название категории не может быть пустым.');

  // Создание категории
  Result := TCategory.Create;
  Result.Name := AName;
  Result.ParentID := AParentID;
  // Инициализация дочерних категорий как пустой массив
  Result.Children := [];
end;

function TCategoryManipulation.UpdateCategory(const ACategory: TCategory): Boolean;
begin
  // Проверка входных данных
  if ACategory = nil then
    raise Exception.Create('Объект категории не может быть nil.');

  // Обновление категории
  // Здесь должен быть код для обновления данных категории
  Result := True; // Или False в зависимости от результата
end;

function TCategoryManipulation.DeleteCategory(const ACategoryID: Integer): Boolean;
begin
  // Проверка входных данных
  if ACategoryID <= 0 then
    raise Exception.Create('Идентификатор категории должен быть положительным числом.');

  // Удаление категории
  // Здесь должен быть код для удаления категории
  Result := True; // Или False в зависимости от результата
end;

function TCategoryManipulation.GetCategoryByID(const ACategoryID: Integer): TCategory;
begin
  // Проверка входных данных
  if ACategoryID <= 0 then
    raise Exception.Create('Идентификатор категории должен быть положительным числом.');

  // Получение категории по ID
  // Здесь должен быть код для получения категории из хранилища
  Result := TCategory.Create;
  Result.Name := 'Sample Category';
  Result.ParentID := 0;
  Result.Children := [];
  // Если категория не найдена, можно вернуть nil
end;

function TCategoryManipulation.FindCategoryByName(const AName: string): TArray<TCategory>;
begin
  // Проверка входных данных
  if Trim(AName) = '' then
    raise Exception.Create('Название категории не может быть пустым.');

  // Поиск категорий по названию
  // Здесь должен быть код для поиска категорий
  SetLength(Result, 1);
  Result[0] := TCategory.Create;
  Result[0].Name := AName;
  Result[0].ParentID := 0;
  Result[0].Children := [];
end;

function TCategoryManipulation.GetAllCategories: TArray<TCategory>;
begin
  // Получение всех категорий
  // Здесь должен быть код для получения всех категорий из хранилища
  SetLength(Result, 2);
  Result[0] := TCategory.Create;
  Result[0].Name := 'Category 1';
  Result[0].ParentID := 0;
  Result[0].Children := [];
  Result[1] := TCategory.Create;
  Result[1].Name := 'Category 2';
  Result[1].ParentID := 0;
  Result[1].Children := [];
end;

function TCategoryManipulation.AddChildCategory(const AParentID, AChildID: Integer): Boolean;
begin
  // Проверка входных данных
  if AParentID <= 0 then
    raise Exception.Create('Идентификатор родительской категории должен быть положительным числом.');

  if AChildID <= 0 then
    raise Exception.Create('Идентификатор дочерней категории должен быть положительным числом.');

  // Добавление дочерней категории
  // Здесь должен быть код для добавления дочерней категории
  Result := True; // Или False в зависимости от результата
end;

function TCategoryManipulation.RemoveChildCategory(const AParentID, AChildID: Integer): Boolean;
begin
  // Проверка входных данных
  if AParentID <= 0 then
    raise Exception.Create('Идентификатор родительской категории должен быть положительным числом.');

  if AChildID <= 0 then
    raise Exception.Create('Идентификатор дочерней категории должен быть положительным числом.');

  // Удаление дочерней категории
  // Здесь должен быть код для удаления дочерней категории
  Result := True; // Или False в зависимости от результата
end;

end.