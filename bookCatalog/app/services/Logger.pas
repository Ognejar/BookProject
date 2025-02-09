unit Logger;

{
  Автор: Бегтин К.В. (Огнеяр)
  Проект: Библиотека Дементора
  Лицензия: Freeware
  Версия: 1.4.0
  Дата создания: 2025

  Описание:
  Модуль Logger отвечает за ведение логов с возможностью записи в файл
  и дублирования вывода в консоль. Поддерживает уровни логирования:
  DEBUG, INFO, WARNING и ERROR. Вывод в консоль можно включать и выключать
  динамически, а также выделять цветом разные типы сообщений.

  История изменений:
  [2025-01-31] Создан модуль с базовыми функциями логирования.
  [2025-02-06] Добавлено дублирование вывода в консоль при включённой
  константе LOG_TO_CONSOLE.
  [2025-02-07] Добавлена обработка ошибок и метод очистки логов.
  [2025-02-08] Добавлена возможность включать и выключать вывод в консоль
  динамически.
  [2025-02-09] Добавлено выделение цветом вывода в консоль для разных
  типов сообщений.
}

interface

uses
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  TypInfo,
  Windows; // Для работы с консолью

type
  TLogLevel = (llDebug, llInfo, llWarning, llError);

  TLogger = class
  private
    FLogFile: string;
    FCriticalSection: TCriticalSection;
    FConsoleEnabled: Boolean;
    class var gLog: TLogger; // Глобальный экземпляр логгера
    procedure WriteToFile(const Level: TLogLevel; const Msg: string);
    procedure WriteToConsole(const Level: TLogLevel; const Msg: string);
    procedure SetConsoleColor(const Level: TLogLevel);
  public
    constructor Create(const ALogFile: string = 'app.log');
    destructor Destroy; override;
    procedure Debug(const Msg: string); overload;
    procedure Debug(const Msg: string; const Args: array of const); overload;
    procedure Info(const Msg: string); overload;
    procedure Info(const Msg: string; const Args: array of const); overload;
    procedure Warning(const Msg: string); overload;
    procedure Warning(const Msg: string; const Args: array of const); overload;
    procedure Error(const Msg: string); overload;
    procedure Error(const Msg: string; const Args: array of const); overload;
    procedure Clear; // Метод для очистки логов
    // Метод для включения/выключения вывода в консоль
    procedure SetConsoleOutput(const Enabled: Boolean);
    class function GetInstance: TLogger; static;
  end;

var
  gLog: TLogger = nil; // Глобальная переменная для удобства использования

implementation

{ TLogger }

constructor TLogger.Create(const ALogFile: string);
begin
  inherited Create;
  FCriticalSection := TCriticalSection.Create;
  FLogFile := ALogFile;
  FConsoleEnabled := True; // По умолчанию вывод в консоль включен

  if FConsoleEnabled then
    AllocConsole;
end;

destructor TLogger.Destroy;
begin
  if FConsoleEnabled then
    FreeConsole;

  FCriticalSection.Free;
  inherited Destroy;
end;

class function TLogger.GetInstance: TLogger;
begin
  if gLog = nil then
    gLog := TLogger.Create;
  Result := gLog;
end;

procedure TLogger.SetConsoleColor(const Level: TLogLevel);
const
  Colors: array [TLogLevel] of WORD = (FOREGROUND_BLUE or FOREGROUND_GREEN,
    // llDebug - Cyan
    FOREGROUND_GREEN, // llInfo - Green
    FOREGROUND_RED or FOREGROUND_GREEN, // llWarning - Yellow
    FOREGROUND_RED); // llError - Red
begin
  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), Colors[Level]);
end;

procedure TLogger.WriteToFile(const Level: TLogLevel; const Msg: string);
var
  LogFile: TextFile;
  LogLevelStr: string;
begin
  FCriticalSection.Enter;
  try
    AssignFile(LogFile, FLogFile);
    if FileExists(FLogFile) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    try
      case Level of
        llDebug:
          LogLevelStr := 'DEBUG';
        llInfo:
          LogLevelStr := 'INFO';
        llWarning:
          LogLevelStr := 'WARNING';
        llError:
          LogLevelStr := 'ERROR';
      end;

      Writeln(LogFile, Format('%s [%s] %s', [DateTimeToStr(Now),
        LogLevelStr, Msg]));
    except
      on E: Exception do
        Writeln('Ошибка записи в файл лога: ' + E.Message);
    end;
  finally
    CloseFile(LogFile);
    FCriticalSection.Leave;
  end;

  if FConsoleEnabled then
    WriteToConsole(Level, Msg);
end;

procedure TLogger.WriteToConsole(const Level: TLogLevel; const Msg: string);
begin
  SetConsoleColor(Level);
  try
    Writeln(Format('%s [%s] %s', [DateTimeToStr(Now),
      GetEnumName(TypeInfo(TLogLevel), Ord(Level)), Msg]));
  finally
    // Сбрасываем цвет текста на стандартный
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_RED or
      FOREGROUND_GREEN or FOREGROUND_BLUE);
  end;
end;

procedure TLogger.Debug(const Msg: string);
begin
  WriteToFile(llDebug, Msg);
end;

procedure TLogger.Debug(const Msg: string; const Args: array of const);
begin
  WriteToFile(llDebug, Format(Msg, Args));
end;

procedure TLogger.Info(const Msg: string);
begin
  WriteToFile(llInfo, Msg);
end;

procedure TLogger.Info(const Msg: string; const Args: array of const);
begin
  WriteToFile(llInfo, Format(Msg, Args));
end;

procedure TLogger.Warning(const Msg: string);
begin
  WriteToFile(llWarning, Msg);
end;

procedure TLogger.Warning(const Msg: string; const Args: array of const);
begin
  WriteToFile(llWarning, Format(Msg, Args));
end;

procedure TLogger.Error(const Msg: string);
begin
  WriteToFile(llError, Msg);
end;

procedure TLogger.Error(const Msg: string; const Args: array of const);
begin
  WriteToFile(llError, Format(Msg, Args));
end;

procedure TLogger.Clear;
var
  LogFile: TextFile;
begin
  FCriticalSection.Enter;
  try
    AssignFile(LogFile, FLogFile);
    Rewrite(LogFile);
  finally
    CloseFile(LogFile);
    FCriticalSection.Leave;
  end;
end;

procedure TLogger.SetConsoleOutput(const Enabled: Boolean);
begin
  if Enabled <> FConsoleEnabled then
  begin
    if Enabled then
    begin
      AllocConsole;
      FConsoleEnabled := True;
    end
    else
    begin
      FreeConsole;
      FConsoleEnabled := False;
    end;
  end;
end;

initialization

gLog := TLogger.GetInstance;

finalization

if gLog <> nil then
  gLog.Free;

end.
