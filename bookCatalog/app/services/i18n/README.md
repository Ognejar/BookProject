# Модуль i18n

{
Автор: Бегтин К.В. (Огнеяр)
Название проекта: Библиотека Дементора
Лицензия: Freeware
Год создания: 2025
Версия: 3.1
Назначение:
Модуль `i18n` предназначен для поддержки интернационализации (i18n) в приложении.
Он позволяет переводить тексты на разные языки и управлять локализацией.
}

## Установка

Для использования модуля `i18n` необходимо установить его через npm:

```bash
npm install i18n
```

## Настройка

### Инициализация

Для начала работы с модулем `i18n` необходимо его инициализировать в вашем приложении:

```javascript
const i18n = require('i18n');

i18n.configure({
  locales: ['en', 'ru', 'es'], // Список поддерживаемых языков
  defaultLocale: 'en', // Язык по умолчанию
  directory: __dirname + '/locales', // Директория с файлами переводов
  objectNotation: true, // Использование точечной нотации для вложенных ключей
  updateFiles: false, // Автоматическое обновление файлов переводов
  register: global // Регистрация функций перевода в глобальной области видимости
});
```

### Структура файлов переводов

Файлы переводов должны находиться в директории, указанной в параметре `directory`. Каждый файл должен соответствовать определенному языку и иметь расширение `.json`.

Пример структуры файлов:

```
/locales
  ├── en.json
  ├── ru.json
  └── es.json
```

Пример содержимого файла `en.json`:

```json
{
  "greeting": "Hello",
  "farewell": "Goodbye",
  "user": {
    "profile": "User Profile"
  }
}
```

Пример содержимого файла `ru.json`:

```json
{
  "greeting": "Привет",
  "farewell": "До свидания",
  "user": {
    "profile": "Профиль пользователя"
  }
}
```

## Использование

### Перевод текста

Для перевода текста используйте функцию `__` (двойное подчеркивание):

```javascript
console.log(__('greeting')); // Вывод: "Hello" (если язык по умолчанию 'en')
```

### Установка локали

Для изменения текущей локали используйте функцию `setLocale`:

```javascript
i18n.setLocale('ru');
console.log(__('greeting')); // Вывод: "Привет"
```

### Локализация с параметрами

Вы можете передавать параметры в переводы:

```javascript
console.log(__('Hello %s', 'John')); // Вывод: "Hello John"
```

### Вложенные ключи

Используйте точечную нотацию для доступа к вложенным ключам:

```javascript
console.log(_В' user.profile')); // Вывод: "User Profile" (если язык по умолчанию 'en')
```

## API

### `i18n.configure(options)`

Настройка модуля `i18n`. Принимает объект с параметрами:

- `locales`: Массив поддерживаемых языков.
- `defaultLocale`: Язык по умолчанию.
- `directory`: Директория с файлами переводов.
- `objectNotation`: Использование точечной нотации для вложенных ключей.
- `updateFiles`: Автоматическое обновление файлов переводов.
- `register`: Регистрация функций перевода в глобальной области видимости.

### `i18n.setLocale(locale)`

Устанавливает текущую локаль.

### `i18n.getLocale()`

Возвращает текущую локаль.

### `i18n.__()`

Функция для перевода текста. Принимает ключ перевода и опциональные параметры.

### `i18n.__n()`

Функция для перевода текста с учетом множественного числа.

## Пример использования

```javascript
const i18n = require('i18n');

i18n.configure({
  locales: ['en', 'ru', 'es'],
  defaultLocale: 'en',
  directory: __dirname + '/locales',
  objectNotation: true,
  updateFiles: false,
  register: global
});

i18n.setLocale('ru');
console.log(__('greeting')); // Вывод: "Привет"
console.log(__('user.profile')); // Вывод: "Профиль пользователя"
```

## Заключение

Модуль `i18n` предоставляет удобный способ управления переводами и локализацией в вашем приложении. Он поддерживает множественные языки, вложенные ключи и параметры, что делает его гибким инструментом для интернационализации.

