### Гайд по использованию модуля `BaseEntityStorage`

Модуль `BaseEntityStorage` предназначен для управления сущностями (например, книгами, пользователями и т.д.) с возможностью их сохранения, загрузки, обновления и удаления. Данные хранятся в файловой системе в формате JSON, а для повышения производительности используется кэширование в памяти. В этом гайде мы рассмотрим, как использовать модуль для работы с сущностями.

---

## 1. **Подключение модуля**
Для начала работы с модулем необходимо добавить его в раздел `uses` вашего проекта:

```pascal
uses
  BaseEntityStorage;
```

---

## 2. **Создание сущности**
Для работы с модулем необходимо создать класс, который будет представлять вашу сущность. Этот класс должен быть унаследован от `TBaseEntity`.

### Пример:
```pascal
type
  TBook = class(TBaseEntity)
  private
    FAuthor: string;
    FYear: Integer;
  public
    property Author: string read FAuthor write FAuthor;
    property Year: Integer read FYear write FYear;
  end;
```

---

## 3. **Инициализация хранилища**
Для работы с сущностями необходимо создать экземпляр `TBaseEntityStorage`, указав путь к папке, где будут храниться данные, и максимальный размер кэша (опционально).

### Пример:
```pascal
var
  BookStorage: TBaseEntityStorage<TBook>;
begin
  BookStorage := TBaseEntityStorage<TBook>.Create('C:\Data\Books', 100);
  try
    // Работа с хранилищем
  finally
    BookStorage.Free;
  end;
end;
```

---

## 4. **Добавление сущности**
Для добавления новой сущности в хранилище используйте метод `CreateEntity`. Метод возвращает уникальный ID сущности.

### Пример:
```pascal
var
  NewBook: TBook;
  BookID: Integer;
begin
  NewBook := TBook.Create;
  try
    NewBook.Name := 'Война и мир';
    NewBook.Author := 'Лев Толстой';
    NewBook.Year := 1869;
    BookID := BookStorage.CreateEntity(NewBook);
    WriteLn('Книга добавлена с ID: ', BookID);
  finally
    NewBook.Free;
  end;
end;
```

---

## 5. **Получение сущности по ID**
Для получения сущности из хранилища используйте метод `ReadEntity`, передав ID сущности.

### Пример:
```pascal
var
  Book: TBook;
begin
  Book := BookStorage.ReadEntity(1); // Получаем книгу с ID = 1
  try
    WriteLn('Название: ', Book.Name);
    WriteLn('Автор: ', Book.Author);
    WriteLn('Год: ', Book.Year);
  finally
    Book.Free;
  end;
end;
```

---

## 6. **Обновление сущности**
Для обновления сущности используйте метод `UpdateEntity`. Изменения будут сохранены в файловой системе и обновлены в кэше.

### Пример:
```pascal
var
  Book: TBook;
begin
  Book := BookStorage.ReadEntity(1); // Получаем книгу с ID = 1
  try
    Book.Year := 1870; // Обновляем год издания
    BookStorage.UpdateEntity(Book); // Сохраняем изменения
    WriteLn('Книга обновлена.');
  finally
    Book.Free;
  end;
end;
```

---

## 7. **Удаление сущности**
Для удаления сущности используйте метод `DeleteEntity`, передав ID сущности.

### Пример:
```pascal
begin
  BookStorage.DeleteEntity(1); // Удаляем книгу с ID = 1
  WriteLn('Книга удалена.');
end;
```

---

## 8. **Получение списка всех сущностей**
Для получения списка всех сущностей, находящихся в кэше, используйте метод `GetAllEntities`.

### Пример:
```pascal
var
  Books: TObjectList<TBook>;
  Book: TBook;
begin
  Books := BookStorage.GetAllEntities;
  try
    for Book in Books do
    begin
      WriteLn('ID: ', Book.ID, ', Название: ', Book.Name, ', Автор: ', Book.Author);
    end;
  finally
    Books.Free;
  end;
end;
```

---

## 9. **Сериализация и десериализация в JSON**
Модуль поддерживает преобразование сущностей в JSON и обратно. Это может быть полезно для экспорта/импорта данных или передачи сущностей по сети.

### Пример:
```pascal
var
  Book: TBook;
  JSONString: string;
begin
  Book := BookStorage.ReadEntity(1); // Получаем книгу с ID = 1
  try
    JSONString := BookStorage.ToJSON(Book); // Преобразуем в JSON
    WriteLn('JSON: ', JSONString);

    // Десериализация из JSON
    BookStorage.FromJSON(Book, JSONString);
  finally
    Book.Free;
  end;
end;
```

---

## 10. **Очистка кэша**
Кэш автоматически очищается при превышении максимального размера (`FMaxCacheSize`). Однако, если вам нужно вручную очистить кэш, вы можете удалить все сущности из кэша:

```pascal
BookStorage.FCache.Clear;
```

---

## 11. **Обработка ошибок**
При работе с модулем могут возникать ошибки, такие как отсутствие файла сущности или проблемы с чтением/записью JSON. Рекомендуется использовать блоки `try..except` для обработки исключений.

### Пример:
```pascal
try
  Book := BookStorage.ReadEntity(999); // Пытаемся получить несуществующую сущность
except
  on E: Exception do
    WriteLn('Ошибка: ', E.Message);
end;
```

---

## 12. **Заключение**
Модуль `BaseEntityStorage` предоставляет удобный способ управления сущностями с использованием файловой системы и кэширования. Он легко расширяется и может быть адаптирован для различных типов данных. Следуя этому гайду, вы сможете эффективно использовать модуль в своих проектах.

Если у вас возникнут вопросы или потребуется доработать функциональность, обратитесь к документации модуля или к автору (Бегтин К.В. (Огнеяр)). Удачи в разработке! 🚀