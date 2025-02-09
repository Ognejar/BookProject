unit KeyManager;

{
  �����: ������ �.�. (������)
  ������: ���������� ���������
  ��������: Freeware
  ������: 1.0.3
  ���� ��������: 2025

  ��������:
    ������ KeyManager �������� �� ���������, �������� � ���������
    ������������� ������. ������������ �������� ����������������
    ��������������� ��� ��������� ��������� ���� ������ � ����������� ������.

  ������� ���������:
    [2025-01-31] ������ ������ � �������� ��������� ���������� ������� (GUID).
    [2025-02-05] ��������� �������� �� ������ ����, �������� ��������� GUID.
                 ��������� ������� �������� ������ �� ���������.
    [2025-02-06] ������� �� ������������� ����� ��� ����������� ������
                 � ����� ������ � ������.
    [2025-02-06] ��������� ��������� ����������� ����������� ������ ����� GetNextKey.
    [2025-02-06] ��������� ������� ��������� �������� ����� ����� GetCurrentKey.
}

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TKeyManager = class
  private
    FKeyStorage: TDictionary<string, Integer>;
  public
    constructor Create;
    destructor Destroy; override;

    { ���������� ��������� ���������� ���� ��� ��������� ����� }
    function GetNextKey(const Name: string): Integer;

    { ���������� ������� ���� ��� ��������� ����� ��� ���������� �������� }
    function GetCurrentKey(const Name: string): Integer;

    { ���������, ���������� �� ���� ��� ���������� ����� }
    function KeyExists(const Name: string; const Key: Integer): Boolean;

    { ���������� ������� ������ ��� ���������� ����� }
    procedure ResetKeys(const Name: string);
  end;

implementation

{ TKeyManager }

constructor TKeyManager.Create;
begin
  inherited Create;
  FKeyStorage := TDictionary<string, Integer>.Create;
end;

destructor TKeyManager.Destroy;
begin
  FKeyStorage.Free;
  inherited Destroy;
end;

function TKeyManager.GetNextKey(const Name: string): Integer;
begin
  if not FKeyStorage.ContainsKey(Name) then
    FKeyStorage.Add(Name, 1)
  else
    FKeyStorage[Name] := FKeyStorage[Name] + 1;

  Result := FKeyStorage[Name];
end;

function TKeyManager.GetCurrentKey(const Name: string): Integer;
begin
  if not FKeyStorage.ContainsKey(Name) then
    raise EKeyNotFoundException.CreateFmt('������������ ��� "%s" �� �������.', [Name]);
  
  Result := FKeyStorage[Name];
end;

function TKeyManager.KeyExists(const Name: string; const Key: Integer): Boolean;
begin
  Result := FKeyStorage.ContainsKey(Name) and (FKeyStorage[Name] >= Key);
end;

procedure TKeyManager.ResetKeys(const Name: string);
begin
  if FKeyStorage.ContainsKey(Name) then
    FKeyStorage[Name] := 0;
end;

end.
