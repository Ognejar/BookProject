program bookCatalog;

uses
  Vcl.Forms,
  catalog in 'app\views\catalog.pas' {Form1},
  BookTypes in 'app\models\BookTypes.pas',
  ListTypes in 'app\models\ListTypes.pas',
  SeriesTypes in 'app\models\SeriesTypes.pas',
  SettingsTypes in 'app\models\SettingsTypes.pas',
  BookStorage in 'app\services\BookStorage.pas',
  Logger in 'app\services\Logger.pas',
  I18N.Manager in 'app\services\i18n\I18N.Manager.pas',
  I18N.Provider.JSON in 'app\services\i18n\I18N.Provider.JSON.pas',
  I18N.Types in 'app\services\i18n\I18N.Types.pas',
  i18nUtils in 'app\services\i18n\i18nUtils.pas',
  CatalogController in 'app\controllers\CatalogController.pas',
  Controller in 'app\controllers\Controller.pas',
  View in 'app\views\View.pas',
  Config in 'app\services\config\Config.pas',
  Unit2 in 'app\test\Unit2.pas' {Form2},
  EditMetadata in 'app\views\EditMetadata.pas' {Form3},
  Main in 'app\views\Main.pas',
  BookController in 'app\controllers\BookController.pas',
  BookModel in 'app\models\BookModel.pas',
  ArrayUtils in 'app\services\utils\ArrayUtils.pas',
  DUnitX.TestFramework,
  DUnitX.TextTestRunner,
  TestBookModel in 'app\test\TestBookModel.pas',
  TestArrayUtils in 'app\test\TestArrayUtils.pas',
  StringUtils in 'app\services\utils\StringUtils.pas',
  KeyManager in 'app\services\KeyManager.pas';

{$R *.res}

begin
TDUnitX.RunRegisteredTests;

//  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
////  Application.CreateForm(TCatalogForm, CatalogForm);
////  Application.CreateForm(TForm2, Form2);
//  Application.CreateForm(TMainForm, MainForm);
//  Application.Run;
end.
