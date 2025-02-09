unit Config;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, System.IOUtils, Vcl.Forms;

const
  SectionPaths = 'Paths';
  KeyDataPath = 'DataPath';

type
  TConfig = class
  private
    FIniFile: TIniFile;
    FModified: Boolean;
    FDataPath: string;
    class var FInstance: TConfig;
    constructor Create;
    function GetDataPath: string;
    procedure SetDataPath(const Value: string);
  public
    class function Instance: TConfig;
    class procedure ReleaseInstance;
    function ReadString(const Section, Name, Default: string): string;
    procedure WriteString(const Section, Name, Value: string);
    function ReadInteger(const Section, Name: string; Default: Integer): Integer;
    procedure WriteInteger(const Section, Name: string; Value: Integer);
    function ReadBool(const Section, Name: string; Default: Boolean): Boolean;
    procedure WriteBool(const Section, Name: string; Value: Boolean);
    procedure SaveConfig;
    property Modified: Boolean read FModified;
    property DataPath: string read GetDataPath write SetDataPath;
    destructor Destroy; override;
  end;

function CatalogConfig: TConfig;

implementation

{ TConfig }

constructor TConfig.Create;
begin
  inherited Create;
  FIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  FDataPath := ReadString(SectionPaths, KeyDataPath, 
    TPath.Combine(ExtractFilePath(Application.ExeName), 'Data'));
  if not DirectoryExists(FDataPath) then
    ForceDirectories(FDataPath);
end;

destructor TConfig.Destroy;
begin
  if FModified then
    SaveConfig;
  FreeAndNil(FIniFile);
  inherited;
end;

class function TConfig.Instance: TConfig;
begin
  if not Assigned(FInstance) then
    FInstance := TConfig.Create;
  Result := FInstance;
end;

class procedure TConfig.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

function TConfig.GetDataPath: string;
begin
  Result := FDataPath;
end;

procedure TConfig.SetDataPath(const Value: string);
begin
  if FDataPath <> Value then
  begin
    FDataPath := Value;
    WriteString(SectionPaths, KeyDataPath, Value);
    FModified := True;
  end;
end;

function TConfig.ReadString(const Section, Name, Default: string): string;
begin
  Result := FIniFile.ReadString(Section, Name, Default);
end;

procedure TConfig.WriteString(const Section, Name, Value: string);
begin
  FIniFile.WriteString(Section, Name, Value);
  FModified := True;
end;

function TConfig.ReadInteger(const Section, Name: string; Default: Integer): Integer;
begin
  Result := FIniFile.ReadInteger(Section, Name, Default);
end;

procedure TConfig.WriteInteger(const Section, Name: string; Value: Integer);
begin
  FIniFile.WriteInteger(Section, Name, Value);
  FModified := True;
end;

function TConfig.ReadBool(const Section, Name: string; Default: Boolean): Boolean;
begin
  Result := FIniFile.ReadBool(Section, Name, Default);
end;

procedure TConfig.WriteBool(const Section, Name: string; Value: Boolean);
begin
  FIniFile.WriteBool(Section, Name, Value);
  FModified := True;
end;

procedure TConfig.SaveConfig;
begin
  FIniFile.UpdateFile;
  FModified := False;
end;

function CatalogConfig: TConfig;
begin
  Result := TConfig.Instance;
end;

end.
