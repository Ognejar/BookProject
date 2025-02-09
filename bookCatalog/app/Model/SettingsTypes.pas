unit SettingsTypes;

interface

type
  TSettingKind = (skString, skInteger, skBoolean, skPath, skEnum);

  TSettingMetadata = record
    Section: string;
    Key: string;
    Caption: string;
    Kind: TSettingKind;
    DefaultValue: string;
    Group: string;
    Hint: string;
  end;

const
  SETTINGS_METADATA: array[0..1] of TSettingMetadata = (
    (
      Section: 'Main';
      Key: 'LibraryPath';
      Caption: 'Путь к библиотеке';
      Kind: skPath;
      DefaultValue: '';
      Group: 'Основные';
      Hint: 'Укажите путь к папке с книгами'
    ),
    (
      Section: 'Interface';
      Key: 'BooksPerPage';
      Caption: 'Книг на странице';
      Kind: skInteger;
      DefaultValue: '10';
      Group: 'Интерфейс';
      Hint: 'Количество книг, отображаемых на одной странице'
    )
  );

implementation

end.

